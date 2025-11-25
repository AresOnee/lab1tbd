package com.tbd.lab1tbd.Repositories;

import com.tbd.lab1tbd.Dto.ListaResponse;
import com.tbd.lab1tbd.Entities.ListaPersonalizada;
import com.tbd.lab1tbd.Entities.SitioTuristico;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DuplicateKeyException;
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
public class ListaRepository {

    private final NamedParameterJdbcTemplate jdbc;

    // RowMapper para la respuesta (incluyendo nombre de usuario)
    private static final RowMapper<ListaResponse> RESPONSE_MAPPER = (rs, rowNum) -> new ListaResponse(
            rs.getLong("id_lista"),
            rs.getLong("id_usuario"),
            rs.getString("nombre_usuario"),
            rs.getString("nombre_lista"),
            rs.getTimestamp("fecha_creacion")
    );
    
    // RowMapper para el POJO de SitioTuristico (reutilizado de SitioTuristicoRepository)
    private static final RowMapper<SitioTuristico> SITIO_MAPPER = (rs, rowNum) -> new SitioTuristico(
            rs.getLong("id"),
            rs.getString("nombre"),
            rs.getString("descripcion"),
            rs.getString("tipo"),
            rs.getDouble("latitud"),
            rs.getDouble("longitud"),
            rs.getDouble("calificacion_promedio"),
            rs.getInt("total_resenas")
    );

    public Long create(ListaPersonalizada lista) {
        String sql = "INSERT INTO listas_personalizadas (id_usuario, nombre) VALUES (:idUsuario, :nombre) RETURNING id";
        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("idUsuario", lista.getIdUsuario())
                .addValue("nombre", lista.getNombre());
        return jdbc.queryForObject(sql, params, Long.class);
    }

    public List<ListaResponse> findByUsuarioId(Long idUsuario) {
        String sql = "SELECT l.id AS id_lista, l.nombre AS nombre_lista, l.fecha_creacion, u.id AS id_usuario, u.nombre AS nombre_usuario " +
                     "FROM listas_personalizadas l " +
                     "JOIN usuarios u ON l.id_usuario = u.id " +
                     "WHERE l.id_usuario = :idUsuario ORDER BY l.fecha_creacion DESC";
        return jdbc.query(sql, Map.of("idUsuario", idUsuario), RESPONSE_MAPPER);
    }

    public int delete(Long idLista) {
        String sql = "DELETE FROM listas_personalizadas WHERE id = :idLista";
        return jdbc.update(sql, Map.of("idLista", idLista));
    }

    public Optional<Long> findAutorId(Long idLista) {
        String sql = "SELECT id_usuario FROM listas_personalizadas WHERE id = :idLista";
        try {
            return Optional.ofNullable(jdbc.queryForObject(sql, Map.of("idLista", idLista), Long.class));
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    // --- Métodos para la tabla 'lista_sitios' ---

    public int addSitioToLista(Long idLista, Long idSitio) {
        String sql = "INSERT INTO lista_sitios (id_lista, id_sitio) VALUES (:idLista, :idSitio)";
        try {
            return jdbc.update(sql, Map.of("idLista", idLista, "idSitio", idSitio));
        } catch (DuplicateKeyException e) {
            // Si ya existe, no es un error, simplemente no se inserta de nuevo.
            return 0; 
        }
    }

    public int removeSitioFromLista(Long idLista, Long idSitio) {
        String sql = "DELETE FROM lista_sitios WHERE id_lista = :idLista AND id_sitio = :idSitio";
        return jdbc.update(sql, Map.of("idLista", idLista, "idSitio", idSitio));
    }

    public List<SitioTuristico> getSitiosByListaId(Long idLista) {
        String sql = "SELECT s.id, s.nombre, s.descripcion, s.tipo, " +
                     "s.calificacion_promedio, s.total_resenas, " +
                     "ST_Y(s.coordenadas::geometry) AS latitud, " +
                     "ST_X(s.coordenadas::geometry) AS longitud " +
                     "FROM sitios_turisticos s " +
                     "JOIN lista_sitios ls ON s.id = ls.id_sitio " +
                     "WHERE ls.id_lista = :idLista";
        return jdbc.query(sql, Map.of("idLista", idLista), SITIO_MAPPER);
    }
}