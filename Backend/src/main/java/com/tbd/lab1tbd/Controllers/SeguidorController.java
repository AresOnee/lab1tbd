package com.tbd.lab1tbd.Controllers;

import com.tbd.lab1tbd.Config.JwtService;
import com.tbd.lab1tbd.Dto.EstadisticasSeguidoresResponse;
import com.tbd.lab1tbd.Dto.UsuarioSeguidorResponse;
import com.tbd.lab1tbd.Entities.UserEntity;
import com.tbd.lab1tbd.Repositories.UserRepository;
import com.tbd.lab1tbd.Services.SeguidorService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Controlador para gestionar las relaciones de seguimiento entre usuarios.
 * Endpoints para seguir/dejar de seguir usuarios y consultar listas de seguidores.
 */
@RestController
@RequestMapping("/usuarios")
@RequiredArgsConstructor
public class SeguidorController {

    private final SeguidorService seguidorService;
    private final JwtService jwtService;
    private final UserRepository userRepository;

    /**
     * Extrae el ID del usuario autenticado desde el token JWT.
     */
    private Long obtenerIdUsuarioActual(HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            String email = jwtService.extractUsername(token);

            // Buscar el usuario por email y obtener su ID
            UserEntity usuario = userRepository.getByEmail(email)
                    .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

            return usuario.getId();
        }
        throw new RuntimeException("Token de autenticación no encontrado");
    }

    /**
     * POST /api/usuarios/{idUsuario}/seguir
     * Hace que el usuario autenticado siga a otro usuario.
     */
    @PostMapping("/{idUsuario}/seguir")
    public ResponseEntity<Void> seguirUsuario(
            @PathVariable Long idUsuario,
            HttpServletRequest request) {

        Long idUsuarioActual = obtenerIdUsuarioActual(request);
        seguidorService.seguirUsuario(idUsuarioActual, idUsuario);

        return ResponseEntity.noContent().build();
    }

    /**
     * DELETE /api/usuarios/{idUsuario}/seguir
     * Hace que el usuario autenticado deje de seguir a otro usuario.
     */
    @DeleteMapping("/{idUsuario}/seguir")
    public ResponseEntity<Void> dejarDeSeguir(
            @PathVariable Long idUsuario,
            HttpServletRequest request) {

        Long idUsuarioActual = obtenerIdUsuarioActual(request);
        seguidorService.dejarDeSeguir(idUsuarioActual, idUsuario);

        return ResponseEntity.noContent().build();
    }

    /**
     * GET /api/usuarios/{idUsuario}/seguir
     * Verifica si el usuario autenticado sigue a otro usuario.
     */
    @GetMapping("/{idUsuario}/seguir")
    public ResponseEntity<Boolean> estaSiguiendo(
            @PathVariable Long idUsuario,
            HttpServletRequest request) {

        Long idUsuarioActual = obtenerIdUsuarioActual(request);
        boolean siguiendo = seguidorService.estaSiguiendo(idUsuarioActual, idUsuario);

        return ResponseEntity.ok(siguiendo);
    }

    /**
     * GET /api/usuarios/{idUsuario}/seguidores
     * Obtiene la lista de seguidores de un usuario.
     */
    @GetMapping("/{idUsuario}/seguidores")
    public ResponseEntity<List<UsuarioSeguidorResponse>> obtenerSeguidores(
            @PathVariable Long idUsuario,
            HttpServletRequest request) {

        Long idUsuarioActual = obtenerIdUsuarioActual(request);
        List<UsuarioSeguidorResponse> seguidores =
                seguidorService.obtenerSeguidores(idUsuario, idUsuarioActual);

        return ResponseEntity.ok(seguidores);
    }

    /**
     * GET /api/usuarios/{idUsuario}/siguiendo
     * Obtiene la lista de usuarios que sigue un usuario.
     */
    @GetMapping("/{idUsuario}/siguiendo")
    public ResponseEntity<List<UsuarioSeguidorResponse>> obtenerSiguiendo(
            @PathVariable Long idUsuario,
            HttpServletRequest request) {

        Long idUsuarioActual = obtenerIdUsuarioActual(request);
        List<UsuarioSeguidorResponse> siguiendo =
                seguidorService.obtenerSiguiendo(idUsuario, idUsuarioActual);

        return ResponseEntity.ok(siguiendo);
    }

    /**
     * GET /api/usuarios/{idUsuario}/estadisticas-seguidores
     * Obtiene las estadísticas de seguidores de un usuario.
     */
    @GetMapping("/{idUsuario}/estadisticas-seguidores")
    public ResponseEntity<EstadisticasSeguidoresResponse> obtenerEstadisticas(
            @PathVariable Long idUsuario,
            HttpServletRequest request) {

        Long idUsuarioActual = obtenerIdUsuarioActual(request);
        EstadisticasSeguidoresResponse stats =
                seguidorService.obtenerEstadisticas(idUsuario, idUsuarioActual);

        return ResponseEntity.ok(stats);
    }
}
