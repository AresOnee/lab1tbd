package com.tbd.lab1tbd.Controllers;

import com.tbd.lab1tbd.Dto.FotografiaRequest;
import com.tbd.lab1tbd.Dto.FotografiaResponse;
import com.tbd.lab1tbd.Services.FotografiaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class FotografiaController {

    private final FotografiaService fotografiaService;

    /**
     * POST /api/sitios/{idSitio}/fotografias
     * Sube una nueva URL de fotografía para un sitio.
     * Requiere autenticación JWT.
     */
    @PostMapping("/sitios/{idSitio}/fotografias")
    public ResponseEntity<Long> createFotografia(
            @PathVariable Long idSitio,
            @RequestBody FotografiaRequest request,
            Authentication authentication // De aquí sacamos el email
    ) {
        String userEmail = authentication.getName();
        Long idFotografia = fotografiaService.create(idSitio, request, userEmail);
        return ResponseEntity.created(URI.create("/api/fotografias/" + idFotografia)).body(idFotografia);
    }

    /**
     * GET /api/sitios/{idSitio}/fotografias
     * Obtiene todas las fotografías de un sitio específico.
     * Requiere autenticación JWT.
     */
    @GetMapping("/sitios/{idSitio}/fotografias")
    public List<FotografiaResponse> getFotografiasPorSitio(@PathVariable Long idSitio) {
        return fotografiaService.getBySitioId(idSitio);
    }

    /**
     * DELETE /api/fotografias/{idFotografia}
     * Elimina una fotografía específica.
     * Requiere autenticación JWT y ser el autor.
     */
    @DeleteMapping("/fotografias/{idFotografia}")
    public ResponseEntity<Void> deleteFotografia(
            @PathVariable Long idFotografia,
            Authentication authentication
    ) {
        String userEmail = authentication.getName();
        fotografiaService.delete(idFotografia, userEmail);
        return ResponseEntity.noContent().build();
    }
}
