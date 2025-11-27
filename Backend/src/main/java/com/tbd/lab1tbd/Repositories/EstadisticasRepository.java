package com.tbd.lab1tbd.Repositories;

import com.tbd.lab1tbd.Dto.*;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Repository para ejecutar las consultas SQL del enunciado.
 * Cada método corresponde a una consulta específica.
 */
@Repository
@RequiredArgsConstructor
public class EstadisticasRepository {

    private final NamedParameterJdbcTemplate jdbc;

    /**
     * Consulta #1: Cálculo de Calificación Promedio y Conteo de Reseñas por tipo
     */
    public List<EstadisticasPorTipoResponse> obtenerEstadisticasPorTipo() {
        String sql = """
                SELECT
                    tipo,
                    AVG(calificacion_promedio) AS calificacion_promedio_general,
                    SUM(total_resenas) AS total_resenas_general
                FROM
                    sitios_turisticos
                GROUP BY
                    tipo
                ORDER BY total_resenas_general DESC
                """;

        return jdbc.query(sql, (rs, rowNum) -> new EstadisticasPorTipoResponse(
                rs.getString("tipo"),
                rs.getDouble("calificacion_promedio_general"),
                rs.getInt("total_resenas_general")
        ));
    }

    /**
     * Consulta #2: Identificación de los 5 Reseñadores Más Activos (últimos 6 meses)
     */
    public List<TopResenadorResponse> obtenerTopResenadores() {
        String sql = """
                WITH ResenasRecientes AS (
                    SELECT
                        id_usuario,
                        COUNT(*) AS conteo_resenas
                    FROM
                        resenas
                    WHERE
                        fecha >= (CURRENT_TIMESTAMP - INTERVAL '6 months')
                    GROUP BY
                        id_usuario
                )
                SELECT
                    u.nombre AS nombre_usuario,
                    rr.conteo_resenas
                FROM
                    ResenasRecientes rr
                JOIN
                    usuarios u ON rr.id_usuario = u.id
                ORDER BY
                    rr.conteo_resenas DESC
                LIMIT 5
                """;

        return jdbc.query(sql, (rs, rowNum) -> new TopResenadorResponse(
                rs.getString("nombre_usuario"),
                rs.getInt("conteo_resenas")
        ));
    }

    /**
     * Consulta #3: Análisis de Proximidad (Restaurantes a < 100m de un Teatro)
     */
    public List<ProximidadSitiosResponse> obtenerAnalisisProximidad() {
        String sql = """
                SELECT
                    t.nombre AS nombre_teatro,
                    r.nombre AS nombre_restaurante,
                    ST_Distance(t.coordenadas, r.coordenadas) AS distancia_en_metros
                FROM
                    sitios_turisticos t
                JOIN
                    sitios_turisticos r ON ST_DWithin(t.coordenadas, r.coordenadas, 100)
                WHERE
                    t.tipo = 'Teatro'
                    AND r.tipo = 'Restaurante'
                    AND t.id != r.id
                ORDER BY distancia_en_metros ASC
                """;

        return jdbc.query(sql, (rs, rowNum) -> new ProximidadSitiosResponse(
                rs.getString("nombre_teatro"),
                rs.getString("nombre_restaurante"),
                rs.getDouble("distancia_en_metros")
        ));
    }

    /**
     * Consulta #4: Detección de Sitios con Valoraciones Inusuales
     * (Promedio > 4.5, < 10 reseñas)
     */
    public List<SitioValoracionInusualResponse> obtenerSitiosValoracionInusual() {
        String sql = """
                SELECT
                    nombre,
                    calificacion_promedio,
                    total_resenas
                FROM
                    sitios_turisticos
                WHERE
                    calificacion_promedio > 4.5
                    AND total_resenas < 10
                    AND total_resenas > 0
                ORDER BY calificacion_promedio DESC
                """;

        return jdbc.query(sql, (rs, rowNum) -> new SitioValoracionInusualResponse(
                rs.getString("nombre"),
                rs.getDouble("calificacion_promedio"),
                rs.getInt("total_resenas")
        ));
    }

    /**
     * Consulta #7: Listado de Sitios con Pocas Contribuciones
     * (Sin reseñas o fotos en 3 meses)
     */
    public List<SitioPocasContribucionesResponse> obtenerSitiosPocasContribuciones() {
        String sql = """
                WITH UltimasContribuciones AS (
                    SELECT
                        id_sitio,
                        MAX(fecha) AS ultima_fecha
                    FROM (
                        SELECT id_sitio, fecha FROM resenas
                        UNION ALL
                        SELECT id_sitio, fecha FROM fotografias
                    ) AS contribuciones
                    GROUP BY id_sitio
                )
                SELECT
                    s.nombre,
                    s.tipo,
                    uc.ultima_fecha AS fecha_ultima_contribucion
                FROM
                    sitios_turisticos s
                LEFT JOIN
                    UltimasContribuciones uc ON s.id = uc.id_sitio
                WHERE
                    uc.ultima_fecha IS NULL
                    OR uc.ultima_fecha < (CURRENT_TIMESTAMP - INTERVAL '3 months')
                ORDER BY uc.ultima_fecha ASC NULLS FIRST
                """;

        return jdbc.query(sql, (rs, rowNum) -> new SitioPocasContribucionesResponse(
                rs.getString("nombre"),
                rs.getString("tipo"),
                rs.getObject("fecha_ultima_contribucion", LocalDateTime.class)
        ));
    }

    /**
     * Consulta #8: Análisis de Contenido de Reseñas
     * (3 más largas de usuarios con promedio > 4.0)
     */
    public List<ResenaLargaResponse> obtenerResenasLargas() {
        String sql = """
                WITH PromedioUsuario AS (
                    SELECT
                        id_usuario,
                        AVG(calificacion) AS promedio_calificacion
                    FROM
                        resenas
                    GROUP BY
                        id_usuario
                    HAVING
                        AVG(calificacion) > 4.0
                )
                SELECT
                    u.nombre AS nombre_usuario,
                    s.nombre AS nombre_sitio,
                    r.contenido,
                    LENGTH(r.contenido) AS longitud_resena
                FROM
                    resenas r
                JOIN
                    usuarios u ON r.id_usuario = u.id
                JOIN
                    sitios_turisticos s ON r.id_sitio = s.id
                JOIN
                    PromedioUsuario pu ON r.id_usuario = pu.id_usuario
                ORDER BY
                    longitud_resena DESC
                LIMIT 3
                """;

        return jdbc.query(sql, (rs, rowNum) -> new ResenaLargaResponse(
                rs.getString("nombre_usuario"),
                rs.getString("nombre_sitio"),
                rs.getString("contenido"),
                rs.getInt("longitud_resena")
        ));
    }

    /**
     * Consulta #9: Resumen de Contribuciones por Usuario
     * (Vista Materializada)
     */
    public List<ResumenContribucionesResponse> obtenerResumenContribuciones() {
        String sql = "SELECT * FROM resumen_contribuciones_usuario ORDER BY total_resenas DESC";

        return jdbc.query(sql, (rs, rowNum) -> new ResumenContribucionesResponse(
                rs.getLong("id_usuario"),
                rs.getString("nombre"),
                rs.getInt("total_resenas"),
                rs.getInt("total_fotos"),
                rs.getInt("total_listas")
        ));
    }
}
