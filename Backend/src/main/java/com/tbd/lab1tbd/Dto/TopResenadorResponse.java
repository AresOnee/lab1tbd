package com.tbd.lab1tbd.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para Consulta #2: Top reseñadores
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TopResenadorResponse {
    private String nombreUsuario;
    private Integer conteoResenas;
}
