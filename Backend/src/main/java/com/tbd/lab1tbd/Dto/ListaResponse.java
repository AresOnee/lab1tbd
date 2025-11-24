package com.tbd.lab1tbd.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

// DTO para devolver información de la lista
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ListaResponse {
    private Long id;
    private Long idUsuario;
    private String nombreUsuario; // Lo sacaremos de un JOIN
    private String nombreLista;
    private Timestamp fechaCreacion;
}