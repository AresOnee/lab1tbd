package com.tbd.lab1tbd.Services;

import com.tbd.lab1tbd.Dto.ReseñaRequest;
import com.tbd.lab1tbd.Dto.ReseñaResponse;
import com.tbd.lab1tbd.Entities.Reseña;
import com.tbd.lab1tbd.Entities.UserEntity;
import com.tbd.lab1tbd.Repositories.ReseñaRepository;
import com.tbd.lab1tbd.Repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReseñaService {

    private final ReseñaRepository reseñaRepository;
    private final UserRepository userRepository; // Necesario para obtener el ID del usuario
    private final SitioTuristicoService sitioTuristicoService; // Para verificar que el sitio existe

    /**
     * Obtiene el ID del usuario autenticado a partir de su email (que viene del token JWT).
     */
    private Long getUserIdFromEmail(String email) {
        UserEntity user = userRepository.getByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        return user.getId();
    }

    /**
     * Crea una nueva reseña.
     */
    public Long create(Long idSitio, ReseñaRequest request, String userEmail) {
        // 1. Obtenemos el ID del usuario autenticado
        Long idUsuario = getUserIdFromEmail(userEmail);
        
        // 2. Verificamos que el sitio existe (lanza excepción si no)
        sitioTuristicoService.getById(idSitio);
        
        // 3. Creamos el POJO de la reseña
        Reseña reseña = new Reseña();
        reseña.setIdUsuario(idUsuario);
        reseña.setIdSitio(idSitio);
        reseña.setContenido(request.getContenido());
        reseña.setCalificacion(request.getCalificacion());
        
        // 4. Guardamos en la BD
        return reseñaRepository.create(reseña);
    }

    /**
     * Obtiene todas las reseñas de un sitio.
     */
    public List<ReseñaResponse> getBySitioId(Long idSitio) {
        // Verificamos que el sitio existe
        sitioTuristicoService.getById(idSitio);
        return reseñaRepository.findBySitioId(idSitio);
    }

    /**
     * Obtiene todas las reseñas de un usuario específico.
     */
    public List<ReseñaResponse> getByUsuarioId(Long idUsuario) {
        return reseñaRepository.findByUsuarioId(idUsuario);
    }

    /**
     * Actualiza una reseña.
     */
    public void update(Long idReseña, ReseñaRequest request, String userEmail) {
        Long idUsuario = getUserIdFromEmail(userEmail);

        // Lógica de autorización:
        // Verificamos que el usuario autenticado es el autor de la reseña
        Long idAutor = reseñaRepository.findAutorId(idReseña)
                .orElseThrow(() -> new RuntimeException("Reseña no encontrada"));
        
        if (!idUsuario.equals(idAutor)) {
            throw new AccessDeniedException("No tiene permiso para editar esta reseña");
        }

        // Si es el autor, actualizamos
        reseñaRepository.update(idReseña, request);
    }

    /**
     * Elimina una reseña.
     */
    public void delete(Long idReseña, String userEmail) {
        Long idUsuario = getUserIdFromEmail(userEmail);
        
        // Lógica de autorización (igual que en update)
        Long idAutor = reseñaRepository.findAutorId(idReseña)
                .orElseThrow(() -> new RuntimeException("Reseña no encontrada"));

        if (!idUsuario.equals(idAutor)) {
            throw new AccessDeniedException("No tiene permiso para eliminar esta reseña");
        }

        // Si es el autor, eliminamos
        if (reseñaRepository.delete(idReseña) == 0) {
             throw new RuntimeException("Error al eliminar la reseña");
        }
    }
}
