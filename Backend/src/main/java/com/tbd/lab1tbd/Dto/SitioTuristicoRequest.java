package com.tbd.lab1tbd.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Para crear o actualizar un Sitio Turístico.
 * Contiene solo los campos que el usuario debe proveer.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SitioTuristicoRequest {

    private String nombre;
    private String descripcion;
    private String tipo;
    private Double latitud;
    private Double longitud;
}