package com.tbd.lab1tbd.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para Consulta #4: Sitios con valoraciones inusuales
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SitioValoracionInusualResponse {
    private String nombre;
    private Double calificacionPromedio;
    private Integer totalResenas;
}
