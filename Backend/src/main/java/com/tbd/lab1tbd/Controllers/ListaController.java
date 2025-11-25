package com.tbd.lab1tbd.Controllers;

import com.tbd.lab1tbd.Dto.ListaRequest;
import com.tbd.lab1tbd.Dto.ListaResponse;
import com.tbd.lab1tbd.Entities.SitioTuristico;
import com.tbd.lab1tbd.Services.ListaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/listas")
@RequiredArgsConstructor
public class ListaController {

    private final ListaService listaService;

    @PostMapping
    public ResponseEntity<Long> createLista(
            @RequestBody ListaRequest request,
            Authentication authentication
    ) {
        String userEmail = authentication.getName();
        Long idLista = listaService.create(request, userEmail);
        return ResponseEntity.created(URI.create("/listas/" + idLista)).body(idLista);
    }

    @GetMapping("/mis-listas")
    public List<ListaResponse> getMisListas(Authentication authentication) {
        String userEmail = authentication.getName();
        return listaService.getByUsuario(userEmail);
    }

    @GetMapping("/usuario/{idUsuario}")
    public List<ListaResponse> getListasByUsuarioId(@PathVariable Long idUsuario) {
        return listaService.getByUsuarioId(idUsuario);
    }

    @DeleteMapping("/{idLista}")
    public ResponseEntity<Void> deleteLista(
            @PathVariable Long idLista,
            Authentication authentication
    ) {
        String userEmail = authentication.getName();
        listaService.delete(idLista, userEmail);
        return ResponseEntity.noContent().build();
    }

    // --- Endpoints para manejar sitios en una lista ---

    @GetMapping("/{idLista}/sitios")
    public List<SitioTuristico> getSitiosDeLista(@PathVariable Long idLista) {
        // Este endpoint es público, no requiere autenticación (o sí, según tu lógica)
        return listaService.getSitios(idLista);
    }

    @PostMapping("/{idLista}/sitios/{idSitio}")
    public ResponseEntity<Void> addSitioToLista(
            @PathVariable Long idLista,
            @PathVariable Long idSitio,
            Authentication authentication
    ) {
        String userEmail = authentication.getName();
        listaService.addSitio(idLista, idSitio, userEmail);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{idLista}/sitios/{idSitio}")
    public ResponseEntity<Void> removeSitioFromLista(
            @PathVariable Long idLista,
            @PathVariable Long idSitio,
            Authentication authentication
    ) {
        String userEmail = authentication.getName();
        listaService.removeSitio(idLista, idSitio, userEmail);
        return ResponseEntity.noContent().build();
    }
}