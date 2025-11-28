package com.tbd.lab1tbd.Entities;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

/**
 * representa la tabla 'fotografias'.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Fotografia {
    
    private Long id;
    private Long idUsuario;
    private Long idSitio;
    private String url;
    private Timestamp fecha;
}
