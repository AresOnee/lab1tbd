package com.tbd.lab1tbd.Controllers;

import com.tbd.lab1tbd.Dto.ReseñaRequest;
import com.tbd.lab1tbd.Dto.ReseñaResponse;
import com.tbd.lab1tbd.Services.ReseñaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class ReseñaController {

    private final ReseñaService reseñaService;

    /**
     * POST /api/sitios/{idSitio}/reseñas
     * Crea una nueva reseña para un sitio específico.
     * Requiere autenticación JWT.
     */
    @PostMapping("/sitios/{idSitio}/reseñas")
    public ResponseEntity<Long> createReseña(
            @PathVariable Long idSitio,
            @RequestBody ReseñaRequest request,
            Authentication authentication // De aquí sacamos el email del usuario
    ) {
        String userEmail = authentication.getName();
        Long idReseña = reseñaService.create(idSitio, request, userEmail);
        return ResponseEntity.created(URI.create("/api/reseñas/" + idReseña)).body(idReseña);
    }

    /**
     * GET /api/sitios/{idSitio}/reseñas
     * Obtiene todas las reseñas de un sitio específico.
     * Requiere autenticación JWT.
     */
    @GetMapping("/sitios/{idSitio}/reseñas")
    public List<ReseñaResponse> getReseñasPorSitio(@PathVariable Long idSitio) {
        return reseñaService.getBySitioId(idSitio);
    }

    /**
     * PUT /api/reseñas/{idReseña}
     * Actualiza una reseña específica.
     * Requiere autenticación JWT y ser el autor.
     */
    @PutMapping("/reseñas/{idReseña}")
    public ResponseEntity<Void> updateReseña(
            @PathVariable Long idReseña,
            @RequestBody ReseñaRequest request,
            Authentication authentication
    ) {
        String userEmail = authentication.getName();
        reseñaService.update(idReseña, request, userEmail);
        return ResponseEntity.noContent().build();
    }

    /**
     * DELETE /api/reseñas/{idReseña}
     * Elimina una reseña específica.
     * Requiere autenticación JWT y ser el autor.
     */
    @DeleteMapping("/reseñas/{idReseña}")
    public ResponseEntity<Void> deleteReseña(
            @PathVariable Long idReseña,
            Authentication authentication
    ) {
        String userEmail = authentication.getName();
        reseñaService.delete(idReseña, userEmail);
        return ResponseEntity.noContent().build();
    }
}
