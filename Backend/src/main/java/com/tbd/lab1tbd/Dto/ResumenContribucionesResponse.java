package com.tbd.lab1tbd.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para Consulta #9: Vista materializada de contribuciones
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ResumenContribucionesResponse {
    private Long idUsuario;
    private String nombre;
    private Integer totalResenas;
    private Integer totalFotos;
    private Integer totalListas;
}
