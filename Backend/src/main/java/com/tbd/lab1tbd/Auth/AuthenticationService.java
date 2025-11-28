package com.tbd.lab1tbd.Auth;

import com.tbd.lab1tbd.Entities.UserEntity;
import com.tbd.lab1tbd.Repositories.UserRepository;
import com.tbd.lab1tbd.Config.JwtService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthenticationService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder; // Inyectamos el Hasher
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    /**
     * Lógica para REGISTRAR un nuevo usuario.
     */
    public AuthenticationResponse register(RegisterRequest request) {
        // Creamos el UserEntity (POJO)
        UserEntity user = new UserEntity();
        user.setName(request.getNombre());
        user.setEmail(request.getEmail());
        
        // Hasheamos la contraseña antes de guardarla
        user.setPassword(passwordEncoder.encode(request.getPassword()));

        // Guardamos en la BD usando tu repositorio
        Long userId = userRepository.create(user);
        user.setId(userId);

        // Creamos los UserDetails para el token
        var userDetails = new User(request.getEmail(), user.getPassword(), java.util.Collections.emptyList());

        // Generamos el token JWT
        String jwtToken = jwtService.generateToken(userDetails);

        // Creamos el DTO del usuario (sin información sensible)
        UserDTO userDTO = UserDTO.builder()
                .id(user.getId())
                .nombre(user.getName())
                .email(user.getEmail())
                .biografia(user.getBiografia())
                .build();

        // Devolvemos tanto el token como el usuario
        return AuthenticationResponse.builder()
                .token(jwtToken)
                .user(userDTO)
                .build();
    }

    /**
     * Lógica para LOGUEAR un usuario existente.
     */
    public AuthenticationResponse authenticate(AuthenticationRequest request) {
        // Spring Security (AuthenticationManager) hace la validación
        // Comprobará el email y comparará la contraseña hasheada
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );

        // Si la autenticación fue exitosa (no lanzó excepción),
        // buscamos al usuario para generar el token.
        var user = userRepository.getByEmail(request.getEmail())
                .orElseThrow(); // Debería existir si la autenticación pasó

        // Creamos los UserDetails para el token
        var userDetails = new User(user.getEmail(), user.getPassword(), java.util.Collections.emptyList());

        // Generamos el token JWT
        String jwtToken = jwtService.generateToken(userDetails);

        // Creamos el DTO del usuario (sin información sensible)
        UserDTO userDTO = UserDTO.builder()
                .id(user.getId())
                .nombre(user.getName())
                .email(user.getEmail())
                .biografia(user.getBiografia())
                .build();

        // Devolvemos tanto el token como el usuario
        return AuthenticationResponse.builder()
                .token(jwtToken)
                .user(userDTO)
                .build();
    }
}
