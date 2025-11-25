package com.tbd.lab1tbd.Config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * Este filtro se ejecuta UNA VEZ por cada petición.
 * Es el "guardia de seguridad" que intercepta las peticiones,
 * busca el token JWT y valida al usuario.
 */
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(JwtAuthenticationFilter.class);

    private final JwtService jwtService;
    private final UserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest request,
            @NonNull HttpServletResponse response,
            @NonNull FilterChain filterChain
    ) throws ServletException, IOException {

        String requestPath = request.getRequestURI();
        logger.info("🔐 JWT Filter - Procesando petición: {} {}", request.getMethod(), requestPath);

        final String authHeader = request.getHeader("Authorization");
        final String jwt;
        final String userEmail;

        // 1. Si no hay cabecera 'Authorization' o no empieza con 'Bearer ',
        // pasamos al siguiente filtro (el usuario no está logueado).
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            logger.warn("⚠️ JWT Filter - Sin header Authorization o no empieza con 'Bearer' para: {}", requestPath);
            logger.info("📋 Authorization header: {}", authHeader);
            filterChain.doFilter(request, response);
            return;
        }

        // 2. Extraemos el token (quitando "Bearer ")
        jwt = authHeader.substring(7);
        logger.info("🎫 JWT Filter - Token extraído (primeros 20 chars): {}...", jwt.substring(0, Math.min(20, jwt.length())));

        try {
            // 3. Extraemos el email del token
            userEmail = jwtService.extractUsername(jwt);
            logger.info("👤 JWT Filter - Email extraído del token: {}", userEmail);

            // 4. Si tenemos email y el usuario AÚN NO ESTÁ AUTENTICADO en el contexto de seguridad...
            if (userEmail != null && SecurityContextHolder.getContext().getAuthentication() == null) {

                // ...cargamos los detalles del usuario desde la BD
                UserDetails userDetails = this.userDetailsService.loadUserByUsername(userEmail);
                logger.info("✅ JWT Filter - Usuario cargado desde BD: {}", userEmail);

                // 5. Si el token es válido...
                if (jwtService.isTokenValid(jwt, userDetails)) {
                    // ...creamos un token de autenticación
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                            userDetails,
                            null, // Credenciales (null porque usamos JWT)
                            userDetails.getAuthorities()
                    );
                    authToken.setDetails(
                            new WebAuthenticationDetailsSource().buildDetails(request)
                    );

                    // ...y lo guardamos en el Contexto de Seguridad de Spring.
                    // ¡El usuario está oficialmente autenticado para esta petición!
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                    logger.info("🎉 JWT Filter - Usuario autenticado exitosamente: {}", userEmail);
                } else {
                    logger.error("❌ JWT Filter - Token INVÁLIDO para usuario: {}", userEmail);
                }
            } else if (userEmail == null) {
                logger.error("❌ JWT Filter - No se pudo extraer email del token");
            } else {
                logger.info("ℹ️ JWT Filter - Usuario ya autenticado en el contexto");
            }
        } catch (Exception e) {
            logger.error("❌ JWT Filter - Error procesando token: {}", e.getMessage(), e);
        }

        // 6. Pasamos al siguiente filtro en la cadena.
        filterChain.doFilter(request, response);
    }
}
