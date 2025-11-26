package com.tbd.lab1tbd.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para retornar estadísticas de seguidores de un usuario.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class EstadisticasSeguidoresResponse {
    private Long idUsuario;
    private Integer totalSeguidores;   // Cantidad de usuarios que lo siguen
    private Integer totalSiguiendo;    // Cantidad de usuarios que sigue
    private Boolean sigueAlUsuarioActual; // Si el usuario actual sigue a este usuario
}
