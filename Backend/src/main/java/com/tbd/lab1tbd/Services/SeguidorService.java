package com.tbd.lab1tbd.Services;

import com.tbd.lab1tbd.Dto.EstadisticasSeguidoresResponse;
import com.tbd.lab1tbd.Dto.UsuarioSeguidorResponse;
import com.tbd.lab1tbd.Repositories.SeguidorRepository;
import com.tbd.lab1tbd.Repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class SeguidorService {

    private final SeguidorRepository seguidorRepository;
    private final UserRepository userRepository;

    /**
     * Hace que un usuario siga a otro.
     *
     * @param idSeguidor ID del usuario que va a seguir
     * @param idSeguido ID del usuario que será seguido
     */
    public void seguirUsuario(Long idSeguidor, Long idSeguido) {
        // Validaciones
        if (idSeguidor.equals(idSeguido)) {
            throw new IllegalArgumentException("Un usuario no puede seguirse a sí mismo");
        }

        // Verificar que ambos usuarios existen
        if (!userRepository.findById(idSeguidor).isPresent()) {
            throw new RuntimeException("Usuario seguidor no encontrado");
        }
        if (!userRepository.findById(idSeguido).isPresent()) {
            throw new RuntimeException("Usuario a seguir no encontrado");
        }

        // Verificar si ya lo está siguiendo
        if (seguidorRepository.estaSiguiendo(idSeguidor, idSeguido)) {
            throw new IllegalArgumentException("Ya estás siguiendo a este usuario");
        }

        seguidorRepository.seguirUsuario(idSeguidor, idSeguido);
    }

    /**
     * Hace que un usuario deje de seguir a otro.
     *
     * @param idSeguidor ID del usuario que va a dejar de seguir
     * @param idSeguido ID del usuario que será dejado de seguir
     */
    public void dejarDeSeguir(Long idSeguidor, Long idSeguido) {
        int rowsAffected = seguidorRepository.dejarDeSeguir(idSeguidor, idSeguido);

        if (rowsAffected == 0) {
            throw new RuntimeException("No estás siguiendo a este usuario");
        }
    }

    /**
     * Verifica si un usuario sigue a otro.
     *
     * @param idSeguidor ID del usuario que sigue
     * @param idSeguido ID del usuario seguido
     * @return true si lo está siguiendo, false en caso contrario
     */
    public boolean estaSiguiendo(Long idSeguidor, Long idSeguido) {
        return seguidorRepository.estaSiguiendo(idSeguidor, idSeguido);
    }

    /**
     * Obtiene la lista de seguidores de un usuario.
     *
     * @param idUsuario ID del usuario
     * @param idUsuarioActual ID del usuario actual (para contexto)
     * @return Lista de seguidores
     */
    public List<UsuarioSeguidorResponse> obtenerSeguidores(Long idUsuario, Long idUsuarioActual) {
        // Verificar que el usuario existe
        if (!userRepository.findById(idUsuario).isPresent()) {
            throw new RuntimeException("Usuario no encontrado");
        }

        return seguidorRepository.obtenerSeguidores(idUsuario, idUsuarioActual);
    }

    /**
     * Obtiene la lista de usuarios que sigue un usuario.
     *
     * @param idUsuario ID del usuario
     * @param idUsuarioActual ID del usuario actual (para contexto)
     * @return Lista de usuarios seguidos
     */
    public List<UsuarioSeguidorResponse> obtenerSiguiendo(Long idUsuario, Long idUsuarioActual) {
        // Verificar que el usuario existe
        if (!userRepository.findById(idUsuario).isPresent()) {
            throw new RuntimeException("Usuario no encontrado");
        }

        return seguidorRepository.obtenerSiguiendo(idUsuario, idUsuarioActual);
    }

    /**
     * Obtiene las estadísticas de seguidores de un usuario.
     *
     * @param idUsuario ID del usuario
     * @param idUsuarioActual ID del usuario actual (para verificar si lo sigue)
     * @return Estadísticas de seguidores
     */
    public EstadisticasSeguidoresResponse obtenerEstadisticas(Long idUsuario, Long idUsuarioActual) {
        // Verificar que el usuario existe
        if (!userRepository.findById(idUsuario).isPresent()) {
            throw new RuntimeException("Usuario no encontrado");
        }

        Map<String, Integer> stats = seguidorRepository.obtenerEstadisticas(idUsuario);

        EstadisticasSeguidoresResponse response = new EstadisticasSeguidoresResponse();
        response.setIdUsuario(idUsuario);
        response.setTotalSeguidores(stats.getOrDefault("seguidores", 0));
        response.setTotalSiguiendo(stats.getOrDefault("siguiendo", 0));

        // Verificar si el usuario actual sigue a este usuario
        if (idUsuarioActual != null && !idUsuarioActual.equals(idUsuario)) {
            response.setSigueAlUsuarioActual(seguidorRepository.estaSiguiendo(idUsuarioActual, idUsuario));
        } else {
            response.setSigueAlUsuarioActual(false);
        }

        return response;
    }
}
