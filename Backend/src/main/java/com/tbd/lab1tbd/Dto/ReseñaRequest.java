package com.tbd.lab1tbd.Dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para crear o actualizar una Reseña.
 * El usuario solo envía el contenido y la calificación.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ReseñaRequest {
    
    private String contenido;
    
    // La BD tiene un CHECK (1-5), pero es bueno
    // validar esto también en el backend o frontend.
    private Integer calificacion;
}
