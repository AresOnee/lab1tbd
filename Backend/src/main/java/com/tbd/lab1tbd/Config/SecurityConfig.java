package com.tbd.lab1tbd.Config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

/**
 * Esta es la configuración de seguridad principal.
 * REEMPLAZA el archivo que tenías.
 */
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthFilter;
    private final AuthenticationProvider authenticationProvider;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Deshabilitamos CSRF (común en APIs REST)
                .cors(cors -> cors.configurationSource(corsConfigurationSource())) // Habilitamos CORS con configuración segura

                // Aquí definimos las REGLAS de autorización
                .authorizeHttpRequests(auth -> auth
                        // Permitimos el acceso PÚBLICO a los endpoints de autenticación (login y registro)
                        .requestMatchers("/auth/**").permitAll()

                        // Permitimos el método OPTIONS de CORS (pre-flight)
                        .requestMatchers(HttpMethod.OPTIONS).permitAll()

                        // CUALQUIER OTRA petición requiere autenticación
                        .anyRequest().authenticated()
                )

                // Configuramos la gestión de sesión como STATELESS (sin estado)
                // Spring Security no creará sesiones.
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )

                // Le decimos a Spring qué proveedor de autenticación usar
                .authenticationProvider(authenticationProvider)

                // Añadimos nuestro filtro JWT ANTES del filtro de autenticación estándar
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    /**
     * Configuración de CORS (Cross-Origin Resource Sharing)
     * Permite que el frontend (Vue.js) en localhost:5173 pueda comunicarse con el backend
     */
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();

        // Orígenes permitidos: SOLO el frontend de Vue.js
        configuration.setAllowedOrigins(Arrays.asList("http://localhost:5173"));

        // Métodos HTTP permitidos
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));

        // Headers permitidos (incluyendo Authorization para JWT)
        configuration.setAllowedHeaders(Arrays.asList("*"));

        // Permitir envío de credenciales (necesario para JWT en headers)
        configuration.setAllowCredentials(true);

        // Headers expuestos al frontend
        configuration.setExposedHeaders(Arrays.asList("Authorization"));

        // Tiempo de cache para la configuración de CORS (1 hora)
        configuration.setMaxAge(3600L);

        // Aplicar esta configuración a todos los endpoints
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);

        return source;
    }
}
