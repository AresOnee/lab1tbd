package com.tbd.lab1tbd.Services;

import com.tbd.lab1tbd.Dto.FotografiaRequest;
import com.tbd.lab1tbd.Dto.FotografiaResponse;
import com.tbd.lab1tbd.Entities.Fotografia;
import com.tbd.lab1tbd.Entities.UserEntity;
import com.tbd.lab1tbd.Repositories.FotografiaRepository;
import com.tbd.lab1tbd.Repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FotografiaService {

    private final FotografiaRepository fotografiaRepository;
    private final UserRepository userRepository;
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
     * Crea una nueva fotografía (asocia una URL a un sitio y usuario).
     */
    public Long create(Long idSitio, FotografiaRequest request, String userEmail) {
        // 1. Obtenemos el ID del usuario autenticado
        Long idUsuario = getUserIdFromEmail(userEmail);
        
        // 2. Verificamos que el sitio existe
        sitioTuristicoService.getById(idSitio);
        
        // 3. Creamos la fotografía
        Fotografia fotografia = new Fotografia();
        fotografia.setIdUsuario(idUsuario);
        fotografia.setIdSitio(idSitio);
        fotografia.setUrl(request.getUrl());
        
        // 4. Guardamos en la BD
        return fotografiaRepository.create(fotografia);
    }

    /**
     * Obtiene todas las fotografías de un sitio.
     */
    public List<FotografiaResponse> getBySitioId(Long idSitio) {
        // Verificamos que el sitio existe
        sitioTuristicoService.getById(idSitio);
        return fotografiaRepository.findBySitioId(idSitio);
    }

    /**
     * Obtiene todas las fotografías de un usuario específico.
     */
    public List<FotografiaResponse> getByUsuarioId(Long idUsuario) {
        return fotografiaRepository.findByUsuarioId(idUsuario);
    }

    /**
     * Elimina una fotografía.
     */
    public void delete(Long idFotografia, String userEmail) {
        Long idUsuario = getUserIdFromEmail(userEmail);
        
        // Lógica de autorización:
        // Verificamos que el usuario autenticado es el autor (quien subió la foto)
        Long idAutor = fotografiaRepository.findAutorId(idFotografia)
                .orElseThrow(() -> new RuntimeException("Fotografía no encontrada"));
        
        if (!idUsuario.equals(idAutor)) {
            throw new AccessDeniedException("No tiene permiso para eliminar esta fotografía");
        }

        // Si es el autor, eliminamos
        if (fotografiaRepository.delete(idFotografia) == 0) {
            throw new RuntimeException("Error al eliminar la fotografía");
        }
    }
}
