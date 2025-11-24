package com.tbd.lab1tbd.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

/**
 * DTO para DEVOLVER reseñas al frontend.
 * Incluimos el nombre del usuario para que el frontend
 * no tenga que hacer una consulta extra.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ReseñaResponse {
    
    private Long id; // ID Reseña
    private String contenido;
    private Integer calificacion;
    private Timestamp fecha;
    private Long idUsuario;
    private String nombreUsuario;
    private Long idSitio;
}
