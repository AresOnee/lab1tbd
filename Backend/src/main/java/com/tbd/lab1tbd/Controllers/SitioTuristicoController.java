package com.tbd.lab1tbd.Controllers;

import com.tbd.lab1tbd.Entities.SitioTuristico;
import com.tbd.lab1tbd.Dto.SitioTuristicoRequest;
import com.tbd.lab1tbd.Services.SitioTuristicoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/sitios")
@RequiredArgsConstructor
public class SitioTuristicoController {

    private final SitioTuristicoService service;

    /**
     * POST /api/sitios
     * Crea un nuevo sitio turístico.
     * Requiere autenticación JWT.
     */
    @PostMapping
    public ResponseEntity<Long> create(@RequestBody SitioTuristicoRequest sitio) {
        Long id = service.create(sitio);
        return ResponseEntity.created(URI.create("/sitios/" + id)).body(id);
    }

    /**
     * GET /api/sitios
     * Obtiene todos los sitios turísticos.
     * Requiere autenticación JWT.
     */
    @GetMapping
    public List<SitioTuristico> getAll() {
        return service.getAll();
    }

    /**
     * GET /api/sitios/{id}
     * Obtiene un sitio específico por su ID.
     * Requiere autenticación JWT.
     */
    @GetMapping("/{id}")
    public SitioTuristico getById(@PathVariable Long id) {
        return service.getById(id);
    }

    /**
     * PUT /api/sitios/{id}
     * Actualiza un sitio existente.
     * Requiere autenticación JWT.
     */
    @PutMapping("/{id}")
    public ResponseEntity<Void> update(@PathVariable Long id, @RequestBody SitioTuristicoRequest sitio) {
        service.update(id, sitio);
        return ResponseEntity.noContent().build();
    }

    /**
     * DELETE /api/sitios/{id}
     * Elimina un sitio.
     * Requiere autenticación JWT.
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * GET /api/sitios/populares
     * Obtiene los sitios turísticos más populares (top 10 por calificación).
     * Requiere autenticación JWT.
     */
    @GetMapping("/populares")
    public List<SitioTuristico> getPopulares() {
        return service.getPopulares();
    }

    /**
     * GET /api/sitios/tipo?tipo={tipo}
     * Filtra sitios turísticos por tipo.
     * Requiere autenticación JWT.
     */
    @GetMapping("/tipo")
    public List<SitioTuristico> getByTipo(@RequestParam String tipo) {
        return service.getByTipo(tipo);
    }

    /**
     * GET /api/sitios/cercanos?lat={lat}&lng={lng}&radio={metros}
     * Busca sitios turísticos cercanos a una ubicación específica.
     * Utiliza el procedimiento almacenado de PostGIS para búsqueda geoespacial.
     * Requiere autenticación JWT.
     *
     * @param lat Latitud de la ubicación de referencia
     * @param lng Longitud de la ubicación de referencia
     * @param radio Radio de búsqueda en metros (opcional, por defecto 1000m)
     * @return Lista de sitios turísticos dentro del radio especificado
     *
     * Ejemplo: GET /api/sitios/cercanos?lat=-33.4489&lng=-70.6693&radio=2000
     */
    @GetMapping("/cercanos")
    public List<SitioTuristico> getCercanos(
            @RequestParam Double lat,
            @RequestParam Double lng,
            @RequestParam(required = false, defaultValue = "1000") Integer radio) {
        return service.getCercanos(lng, lat, radio);
    }
}
