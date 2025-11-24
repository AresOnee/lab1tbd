package com.tbd.lab1tbd.Entities;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

/**
 * POJO que representa la tabla 'reseñas'.
 * Usado internamente para la lógica de negocio.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Reseña {
    
    private Long id;
    private Long idUsuario;
    private Long idSitio;
    private String contenido;
    private Integer calificacion;
    private Timestamp fecha;
}
