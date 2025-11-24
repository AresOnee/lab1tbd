package com.tbd.lab1tbd.Entities;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ListaPersonalizada {
    private Long id;
    private Long idUsuario;
    private String nombre;
    private Timestamp fechaCreacion;
}