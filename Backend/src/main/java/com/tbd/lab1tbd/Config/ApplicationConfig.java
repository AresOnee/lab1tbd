package com.tbd.lab1tbd.Config;

import com.tbd.lab1tbd.Repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@RequiredArgsConstructor
public class ApplicationConfig {

    private final UserRepository userRepository;

    /**
     * Define cómo Spring Security debe buscar a un usuario.
     * Usamos el 'UserRepository' que ya tenías para buscar por email.
     */
    @Bean
    public UserDetailsService userDetailsService() {
        return username -> userRepository.getByEmail(username)
                // Convertimos nuestro UserEntity a UserDetails de Spring Security
                .map(user -> new org.springframework.security.core.userdetails.User(
                        user.getEmail(),
                        user.getPassword(), // Aquí va la contraseña hasheada
                        java.util.Collections.emptyList() // Roles/Autoridades (vacío por ahora)
                ))
                .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado con email: " + username));
    }

    /**
     * Bean para el encriptador de contraseñas.
     * Usaremos BCrypt, el estándar de la industria.
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * El proveedor de autenticación.
     * Combina el 'UserDetailsService' (cómo buscar) y el 'PasswordEncoder' (cómo comparar contraseñas).
     */
    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService());
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }

    /**
     * El gestor de autenticación, necesario para el proceso de login.
     */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }
}
