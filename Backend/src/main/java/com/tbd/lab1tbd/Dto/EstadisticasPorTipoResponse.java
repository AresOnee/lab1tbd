package com.tbd.lab1tbd.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para Consulta #1: Estadísticas por tipo de sitio
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class EstadisticasPorTipoResponse {
    private String tipo;
    private Double calificacionPromedioGeneral;
    private Integer totalResenasGeneral;
}
