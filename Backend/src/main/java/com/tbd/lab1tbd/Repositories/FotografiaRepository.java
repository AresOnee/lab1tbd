package com.tbd.lab1tbd.Repositories;

import com.tbd.lab1tbd.Dto.FotografiaResponse;
import com.tbd.lab1tbd.Entities.Fotografia;
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
public class FotografiaRepository {

    private final NamedParameterJdbcTemplate jdbc;

    /**
     * RowMapper para nuestro DTO de Respuesta.
     * Une 'fotografias' con 'usuarios' para obtener el nombre.
     */
    private static final RowMapper<FotografiaResponse> RESPONSE_MAPPER = new RowMapper<>() {
        @Override
        public FotografiaResponse mapRow(ResultSet rs, int rowNum) throws SQLException {
            return new FotografiaResponse(
                    rs.getLong("id_foto"),
                    rs.getString("url"),
                    rs.getTimestamp("fecha"),
                    rs.getLong("id_usuario"),
                    rs.getString("nombre_usuario"), // Del JOIN
                    rs.getLong("id_sitio")
            );
        }
    };

    // SQL para la consulta del Response
    private static final String SELECT_SQL = 
        "SELECT f.id AS id_foto, f.url, f.fecha, " + 
        "f.id_usuario, u.nombre AS nombre_usuario, f.id_sitio " +
        "FROM fotografias f " +
        "JOIN usuarios u ON f.id_usuario = u.id ";

    /**
     * Obtiene todas las fotografías de un sitio específico.
     */
    public List<FotografiaResponse> findBySitioId(Long idSitio) {
        String sql = SELECT_SQL + "WHERE f.id_sitio = :idSitio ORDER BY f.fecha DESC";
        return jdbc.query(sql, Map.of("idSitio", idSitio), RESPONSE_MAPPER);
    }

    /**
     * Crea una nueva fotografía.
     */
    public Long create(Fotografia fotografia) {
        String sql = """
                INSERT INTO fotografias (id_usuario, id_sitio, url)
                VALUES (:idUsuario, :idSitio, :url)
                RETURNING id
                """;
        
        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("idUsuario", fotografia.getIdUsuario())
                .addValue("idSitio", fotografia.getIdSitio())
                .addValue("url", fotografia.getUrl());

        return jdbc.queryForObject(sql, params, Long.class);
    }

    /**
     * Elimina una fotografía por su ID.
     */
    public int delete(Long idFotografia) {
        String sql = "DELETE FROM fotografias WHERE id = :idFotografia";
        return jdbc.update(sql, Map.of("idFotografia", idFotografia));
    }

    /**
     * (Helper) Busca el ID del autor de una fotografía.
     * Esencial para la autorización de borrado.
     */
    public Optional<Long> findAutorId(Long idFotografia) {
        String sql = "SELECT id_usuario FROM fotografias WHERE id = :idFotografia";
        try {
            return Optional.ofNullable(jdbc.queryForObject(sql, Map.of("idFotografia", idFotografia), Long.class));
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }
}
