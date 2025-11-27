package com.tbd.lab1tbd.Repositories;

import com.tbd.lab1tbd.Entities.SitioTuristico;
import com.tbd.lab1tbd.Dto.SitioTuristicoRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class SitioTuristicoRepository {

    private final NamedParameterJdbcTemplate jdbc;

    /**
     * RowMapper para convertir una fila de 'sitios_turisticos' a nuestro POJO.
     * Usa funciones de PostGIS (ST_Y para lat, ST_X para lon) para extraer
     * las coordenadas del tipo 'geography'.
     */
    private static final RowMapper<SitioTuristico> MAPPER = new RowMapper<>() {
        @Override
        public SitioTuristico mapRow(ResultSet rs, int rowNum) throws SQLException {
            return new SitioTuristico(
                    rs.getLong("id"),
                    rs.getString("nombre"),
                    rs.getString("descripcion"),
                    rs.getString("tipo"),
                    rs.getDouble("latitud"), // Obtenido del alias ST_Y
                    rs.getDouble("longitud"), // Obtenido del alias ST_X
                    rs.getDouble("calificacion_promedio"),
                    rs.getInt("total_resenas")
            );
        }
    };

    // Columnas base para las consultas SELECT
    private static final String SELECT_COLUMNS =
        "id, nombre, descripcion, tipo, calificacion_promedio, total_resenas, " +
        "ST_Y(coordenadas::geometry) AS latitud, " +
        "ST_X(coordenadas::geometry) AS longitud ";

    /**
     * Obtiene todos los sitios turísticos.
     */
    public List<SitioTuristico> findAll() {
        String sql = "SELECT " + SELECT_COLUMNS + "FROM sitios_turisticos";
        return jdbc.query(sql, MAPPER);
    }

    /**
     * Busca un sitio por su ID.
     */
    public Optional<SitioTuristico> findById(Long id) {
        String sql = "SELECT " + SELECT_COLUMNS + "FROM sitios_turisticos WHERE id = :id";
        try {
            return Optional.ofNullable(jdbc.queryForObject(sql, Map.of("id", id), MAPPER));
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    /**
     * Crea un nuevo sitio turístico.
     * Usa ST_SetSRID(ST_MakePoint(lon, lat), 4326) para crear el punto 'geography'.
     */
    public Long create(SitioTuristicoRequest sitio) {
        String sql = """
                INSERT INTO sitios_turisticos (nombre, descripcion, tipo, coordenadas)
                VALUES (:nombre, :descripcion, :tipo, ST_SetSRID(ST_MakePoint(:longitud, :latitud), 4326))
                RETURNING id
                """;
        
        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("nombre", sitio.getNombre())
                .addValue("descripcion", sitio.getDescripcion())
                .addValue("tipo", sitio.getTipo())
                .addValue("longitud", sitio.getLongitud())
                .addValue("latitud", sitio.getLatitud());

        return jdbc.queryForObject(sql, params, Long.class);
    }

    /**
     * Actualiza un sitio turístico existente.
     */
    public int update(Long id, SitioTuristicoRequest sitio) {
        String sql = """
                UPDATE sitios_turisticos
                SET nombre = :nombre,
                    descripcion = :descripcion,
                    tipo = :tipo,
                    coordenadas = ST_SetSRID(ST_MakePoint(:longitud, :latitud), 4326)
                WHERE id = :id
                """;

        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("id", id)
                .addValue("nombre", sitio.getNombre())
                .addValue("descripcion", sitio.getDescripcion())
                .addValue("tipo", sitio.getTipo())
                .addValue("longitud", sitio.getLongitud())
                .addValue("latitud", sitio.getLatitud());

        return jdbc.update(sql, params);
    }

    /**
     * Elimina un sitio turístico por su ID.
     */
    public int delete(Long id) {
        String sql = "DELETE FROM sitios_turisticos WHERE id = :id";
        return jdbc.update(sql, Map.of("id", id));
    }

    /**
     * Obtiene los sitios turísticos más populares (ordenados por calificación y número de reseñas).
     * Retorna los top 10 sitios con mejor calificación.
     */
    public List<SitioTuristico> findPopulares() {
        String sql = "SELECT " + SELECT_COLUMNS +
                     "FROM sitios_turisticos " +
                     "WHERE total_resenas > 0 " +
                     "ORDER BY calificacion_promedio DESC, total_resenas DESC " +
                     "LIMIT 10";
        return jdbc.query(sql, MAPPER);
    }

    /**
     * Busca sitios turísticos por tipo.
     */
    public List<SitioTuristico> findByTipo(String tipo) {
        String sql = "SELECT " + SELECT_COLUMNS +
                     "FROM sitios_turisticos " +
                     "WHERE tipo = :tipo";
        return jdbc.query(sql, Map.of("tipo", tipo), MAPPER);
    }

    /**
     * Busca sitios turísticos cercanos a una ubicación específica.
     * Utiliza el procedimiento almacenado 'buscar_sitios_cercanos' de PostGIS.
     *
     * @param longitud Longitud de la ubicación de referencia
     * @param latitud Latitud de la ubicación de referencia
     * @param radioMetros Radio de búsqueda en metros
     * @return Lista de sitios turísticos dentro del radio especificado
     */
    public List<SitioTuristico> findCercanos(Double longitud, Double latitud, Integer radioMetros) {
        // La función buscar_sitios_cercanos devuelve SETOF sitios_turisticos
        // Usamos una subconsulta para obtener todos los campos y luego extraemos las coordenadas
        String sql = """
                SELECT
                    s.id,
                    s.nombre,
                    s.descripcion,
                    s.tipo,
                    s.calificacion_promedio,
                    s.total_resenas,
                    ST_Y(s.coordenadas::geometry) AS latitud,
                    ST_X(s.coordenadas::geometry) AS longitud
                FROM (
                    SELECT * FROM buscar_sitios_cercanos(:longitud, :latitud, :radio)
                ) AS s
                """;

        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("longitud", longitud)
                .addValue("latitud", latitud)
                .addValue("radio", radioMetros);

        return jdbc.query(sql, params, MAPPER);
    }
}

