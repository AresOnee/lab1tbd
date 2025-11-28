package com.tbd.lab1tbd.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/*
  DTO para retornar información de un seguidor o seguido.
  Incluye datos básicos del usuario y la fecha de inicio del seguimiento.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioSeguidorResponse {
    private Long idUsuario;
    private String nombre;
    private String email;
    private String biografia;
    private LocalDateTime fechaSeguimiento;
    private Boolean sigueAlUsuarioActual; // Si el usuario actual también lo sigue (para seguimiento mutuo)
}
