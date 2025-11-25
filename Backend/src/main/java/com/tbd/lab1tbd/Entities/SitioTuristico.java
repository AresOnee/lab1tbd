package com.tbd.lab1tbd.Entities;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SitioTuristico {

    private Long id;
    private String nombre;
    private String descripcion;
    private String tipo;

    // Campos para las coordenadas (extraídos con ST_X y ST_Y)
    private Double latitud;
    private Double longitud;

    // Campos calculados por el trigger
    private Double calificacionPromedio;
    private Integer totalResenas;
}
