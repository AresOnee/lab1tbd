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
import org.springframework.web.cors.CorsConfigurationSource;

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
    private final CorsConfigurationSource corsConfigurationSource;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Deshabilitamos CSRF (común en APIs REST)
                .cors(cors -> cors.configurationSource(corsConfigurationSource)) // CORS habilitado
                
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
}
