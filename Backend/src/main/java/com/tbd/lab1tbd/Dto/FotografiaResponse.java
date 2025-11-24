package com.tbd.lab1tbd.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

/**
 * DTO para DEVOLVER información de las fotografías.
 * Incluye el nombre del usuario que la subió.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class FotografiaResponse {
    
    private Long id; // ID de la fotografía
    private String url;
    private Timestamp fecha;
    private Long idUsuario;
    private String nombreUsuario; // Del JOIN con usuarios
    private Long idSitio;
}
