package com.tbd.lab1tbd.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO para Consulta #7: Sitios con pocas contribuciones
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SitioPocasContribucionesResponse {
    private String nombre;
    private String tipo;
    private LocalDateTime fechaUltimaContribucion;
}
