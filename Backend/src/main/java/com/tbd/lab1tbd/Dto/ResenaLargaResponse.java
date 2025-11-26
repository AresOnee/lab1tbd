package com.tbd.lab1tbd.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para Consulta #8: Reseñas más largas
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ResenaLargaResponse {
    private String nombreUsuario;
    private String nombreSitio;
    private String contenido;
    private Integer longitudResena;
}
