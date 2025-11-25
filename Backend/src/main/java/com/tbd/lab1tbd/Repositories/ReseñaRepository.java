package com.tbd.lab1tbd.Repositories;

import com.tbd.lab1tbd.Dto.ReseñaRequest;
import com.tbd.lab1tbd.Dto.ReseñaResponse;
import com.tbd.lab1tbd.Entities.Reseña;
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
public class ReseñaRepository {

    private final NamedParameterJdbcTemplate jdbc;

    /**
     * RowMapper para nuestro DTO de Respuesta.
     * Une 'reseñas' con 'usuarios' para obtener el nombre.
     */
    private static final RowMapper<ReseñaResponse> RESPONSE_MAPPER = new RowMapper<>() {
        @Override
        public ReseñaResponse mapRow(ResultSet rs, int rowNum) throws SQLException {
            return new ReseñaResponse(
                    rs.getLong("id_reseña"),
                    rs.getString("contenido"),
                    rs.getInt("calificacion"),
                    rs.getTimestamp("fecha"),
                    rs.getLong("id_usuario"),
                    rs.getString("nombre_usuario"), // Del JOIN
                    rs.getLong("id_sitio")
            );
        }
    };

    // SQL para la consulta del Response
    private static final String SELECT_SQL = 
        "SELECT r.id AS id_reseña, r.contenido, r.calificacion, r.fecha, " + 
        "r.id_usuario, u.nombre AS nombre_usuario, r.id_sitio " +
        "FROM reseñas r " +
        "JOIN usuarios u ON r.id_usuario = u.id ";

    /**
     * Obtiene todas las reseñas de un sitio específico.
     */
    public List<ReseñaResponse> findBySitioId(Long idSitio) {
        String sql = SELECT_SQL + "WHERE r.id_sitio = :idSitio ORDER BY r.fecha DESC";
        return jdbc.query(sql, Map.of("idSitio", idSitio), RESPONSE_MAPPER);
    }

    /**
     * Obtiene todas las reseñas de un usuario específico.
     */
    public List<ReseñaResponse> findByUsuarioId(Long idUsuario) {
        String sql = SELECT_SQL + "WHERE r.id_usuario = :idUsuario ORDER BY r.fecha DESC";
        return jdbc.query(sql, Map.of("idUsuario", idUsuario), RESPONSE_MAPPER);
    }

    /**
     * Busca una reseña por su ID.
     */
    public Optional<ReseñaResponse> findById(Long idReseña) {
        String sql = SELECT_SQL + "WHERE r.id = :idReseña";
        try {
            return Optional.ofNullable(jdbc.queryForObject(sql, Map.of("idReseña", idReseña), RESPONSE_MAPPER));
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    /**
     * Crea una nueva reseña.
     * Nota: El trigger en la BD se encargará de actualizar la calificación del sitio.
     */
    public Long create(Reseña reseña) {
        String sql = """
                INSERT INTO reseñas (id_usuario, id_sitio, contenido, calificacion)
                VALUES (:idUsuario, :idSitio, :contenido, :calificacion)
                RETURNING id
                """;
        
        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("idUsuario", reseña.getIdUsuario())
                .addValue("idSitio", reseña.getIdSitio())
                .addValue("contenido", reseña.getContenido())
                .addValue("calificacion", reseña.getCalificacion());

        return jdbc.queryForObject(sql, params, Long.class);
    }

    /**
     * Actualiza una reseña existente.
     */
    public int update(Long idReseña, ReseñaRequest reseña) {
        String sql = """
                UPDATE reseñas
                SET contenido = :contenido, calificacion = :calificacion
                WHERE id = :idReseña
                """;
        
        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("idReseña", idReseña)
                .addValue("contenido", reseña.getContenido())
                .addValue("calificacion", reseña.getCalificacion());
        
        return jdbc.update(sql, params);
    }

    /**
     * Elimina una reseña por su ID.
     */
    public int delete(Long idReseña) {
        String sql = "DELETE FROM reseñas WHERE id = :idReseña";
        return jdbc.update(sql, Map.of("idReseña", idReseña));
    }

    /**
     * (Helper) Busca el ID del autor de una reseña.
     * Esto es crucial para la lógica de autorización (que solo el autor pueda editar/borrar).
     */
    public Optional<Long> findAutorId(Long idReseña) {
        String sql = "SELECT id_usuario FROM reseñas WHERE id = :idReseña";
        try {
            return Optional.ofNullable(jdbc.queryForObject(sql, Map.of("idReseña", idReseña), Long.class));
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }
}
