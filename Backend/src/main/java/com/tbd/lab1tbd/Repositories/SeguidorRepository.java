package com.tbd.lab1tbd.Repositories;

import com.tbd.lab1tbd.Dto.UsuarioSeguidorResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class SeguidorRepository {

    private final NamedParameterJdbcTemplate jdbc;

    /**
     * RowMapper para convertir resultados a UsuarioSeguidorResponse
     */
    private static final RowMapper<UsuarioSeguidorResponse> MAPPER = new RowMapper<>() {
        @Override
        public UsuarioSeguidorResponse mapRow(ResultSet rs, int rowNum) throws SQLException {
            UsuarioSeguidorResponse response = new UsuarioSeguidorResponse();
            response.setIdUsuario(rs.getLong("id_usuario"));
            response.setNombre(rs.getString("nombre"));
            response.setEmail(rs.getString("email"));
            response.setBiografia(rs.getString("biografia"));
            response.setFechaSeguimiento(rs.getObject("fecha_seguimiento", LocalDateTime.class));

            // Campo opcional para seguimiento mutuo
            try {
                response.setSigueAlUsuarioActual(rs.getBoolean("sigue_al_usuario_actual"));
            } catch (SQLException e) {
                response.setSigueAlUsuarioActual(false);
            }

            return response;
        }
    };

    /**
     * Crea una relación de seguimiento entre dos usuarios.
     *
     * @param idSeguidor ID del usuario que sigue
     * @param idSeguido ID del usuario que será seguido
     * @return ID de la relación creada
     */
    public Long seguirUsuario(Long idSeguidor, Long idSeguido) {
        String sql = """
                INSERT INTO seguidores (id_seguidor, id_seguido)
                VALUES (:idSeguidor, :idSeguido)
                ON CONFLICT (id_seguidor, id_seguido) DO NOTHING
                RETURNING id
                """;

        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("idSeguidor", idSeguidor)
                .addValue("idSeguido", idSeguido);

        try {
            return jdbc.queryForObject(sql, params, Long.class);
        } catch (EmptyResultDataAccessException e) {
            // Ya existe la relación, retornar null
            return null;
        }
    }

    /**
     * Elimina una relación de seguimiento.
     *
     * @param idSeguidor ID del usuario que sigue
     * @param idSeguido ID del usuario seguido
     * @return Número de filas afectadas
     */
    public int dejarDeSeguir(Long idSeguidor, Long idSeguido) {
        String sql = """
                DELETE FROM seguidores
                WHERE id_seguidor = :idSeguidor AND id_seguido = :idSeguido
                """;

        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("idSeguidor", idSeguidor)
                .addValue("idSeguido", idSeguido);

        return jdbc.update(sql, params);
    }

    /**
     * Verifica si un usuario sigue a otro.
     *
     * @param idSeguidor ID del usuario que sigue
     * @param idSeguido ID del usuario seguido
     * @return true si existe la relación, false en caso contrario
     */
    public boolean estaSiguiendo(Long idSeguidor, Long idSeguido) {
        String sql = """
                SELECT COUNT(*) FROM seguidores
                WHERE id_seguidor = :idSeguidor AND id_seguido = :idSeguido
                """;

        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("idSeguidor", idSeguidor)
                .addValue("idSeguido", idSeguido);

        Integer count = jdbc.queryForObject(sql, params, Integer.class);
        return count != null && count > 0;
    }

    /**
     * Obtiene la lista de seguidores de un usuario.
     *
     * @param idUsuario ID del usuario
     * @param idUsuarioActual ID del usuario actual (para verificar seguimiento mutuo)
     * @return Lista de seguidores
     */
    public List<UsuarioSeguidorResponse> obtenerSeguidores(Long idUsuario, Long idUsuarioActual) {
        String sql = """
                SELECT
                    u.id AS id_usuario,
                    u.nombre,
                    u.email,
                    u.biografia,
                    s.fecha_inicio AS fecha_seguimiento,
                    EXISTS(
                        SELECT 1 FROM seguidores s2
                        WHERE s2.id_seguidor = :idUsuarioActual
                        AND s2.id_seguido = u.id
                    ) AS sigue_al_usuario_actual
                FROM seguidores s
                JOIN usuarios u ON s.id_seguidor = u.id
                WHERE s.id_seguido = :idUsuario
                ORDER BY s.fecha_inicio DESC
                """;

        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("idUsuario", idUsuario)
                .addValue("idUsuarioActual", idUsuarioActual);

        return jdbc.query(sql, params, MAPPER);
    }

    /**
     * Obtiene la lista de usuarios que sigue un usuario.
     *
     * @param idUsuario ID del usuario
     * @param idUsuarioActual ID del usuario actual (para verificar seguimiento mutuo)
     * @return Lista de usuarios seguidos
     */
    public List<UsuarioSeguidorResponse> obtenerSiguiendo(Long idUsuario, Long idUsuarioActual) {
        String sql = """
                SELECT
                    u.id AS id_usuario,
                    u.nombre,
                    u.email,
                    u.biografia,
                    s.fecha_inicio AS fecha_seguimiento,
                    EXISTS(
                        SELECT 1 FROM seguidores s2
                        WHERE s2.id_seguidor = u.id
                        AND s2.id_seguido = :idUsuarioActual
                    ) AS sigue_al_usuario_actual
                FROM seguidores s
                JOIN usuarios u ON s.id_seguido = u.id
                WHERE s.id_seguidor = :idUsuario
                ORDER BY s.fecha_inicio DESC
                """;

        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("idUsuario", idUsuario)
                .addValue("idUsuarioActual", idUsuarioActual);

        return jdbc.query(sql, params, MAPPER);
    }

    /**
     * Obtiene el conteo de seguidores y siguiendo de un usuario.
     *
     * @param idUsuario ID del usuario
     * @return Map con 'seguidores' y 'siguiendo'
     */
    public Map<String, Integer> obtenerEstadisticas(Long idUsuario) {
        String sql = """
                SELECT
                    (SELECT COUNT(*) FROM seguidores WHERE id_seguido = :idUsuario) AS seguidores,
                    (SELECT COUNT(*) FROM seguidores WHERE id_seguidor = :idUsuario) AS siguiendo
                """;

        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("idUsuario", idUsuario);

        return jdbc.queryForMap(sql, params);
    }
}
