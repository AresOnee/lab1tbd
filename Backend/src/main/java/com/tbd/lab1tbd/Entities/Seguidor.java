package com.tbd.lab1tbd.Entities;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Entidad que representa la relación de seguimiento entre usuarios.
 * Un usuario (seguidor) puede seguir a otro usuario (seguido).
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Seguidor {
    private Long id;
    private Long idSeguidor;    // ID del usuario que sigue (follower)
    private Long idSeguido;     // ID del usuario que es seguido (following)
    private LocalDateTime fechaInicio;
}
