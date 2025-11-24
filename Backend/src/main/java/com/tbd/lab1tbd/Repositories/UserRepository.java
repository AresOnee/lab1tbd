package com.tbd.lab1tbd.Repositories;

import com.tbd.lab1tbd.Entities.UserEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class UserRepository {

    private final NamedParameterJdbcTemplate jdbc;

    private static final RowMapper<UserEntity> MAPPER = new RowMapper<>() {
        @Override public UserEntity mapRow(ResultSet rs, int rowNum) throws SQLException {
            return new UserEntity(
                    rs.getLong("id"),
                    rs.getString("nombre"),
                    rs.getString("email"),
                    rs.getString("contrasena_hash")
            );
        }
    };

    // Nota: El hasheo se hace en el SERVICIO, antes de llamar a este método.
    public Long create(UserEntity u) {
        String sql = """
                INSERT INTO usuarios(nombre, email, contrasena_hash)
                VALUES (:nombre, :email, :contrasena_hash)
                RETURNING id
                """;
        MapSqlParameterSource p = new MapSqlParameterSource()
                .addValue("nombre", u.getName())
                .addValue("email", u.getEmail())
                .addValue("contrasena_hash", u.getPassword());
        return jdbc.queryForObject(sql, p, Long.class);
    }

    public Optional<UserEntity> getbyid(Long id) {
        String sql = "SELECT id, nombre, email, contrasena_hash FROM usuarios WHERE id=:id";
        try {
            return Optional.ofNullable(jdbc.queryForObject(sql, Map.of("id", id), MAPPER));
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }
    
    // ... (El método getByEmail será necesario para el Login) ...
    public Optional<UserEntity> getByEmail(String email) {
        String sql = "SELECT id, nombre, email, contrasena_hash FROM usuarios WHERE email=:email";
        try {
            return Optional.ofNullable(jdbc.queryForObject(sql, Map.of("email", email), MAPPER));
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    public int update(Long id, UserEntity u) {
        String sql = """
                UPDATE usuarios
                   SET nombre=:nombre, email=:email
                   -- Generalmente, la contraseña se actualiza en un endpoint separado
                WHERE id=:id
                """;
        MapSqlParameterSource p = new MapSqlParameterSource()
                .addValue("id", id)
                .addValue("nombre", u.getName())
                .addValue("email", u.getEmail());
        return jdbc.update(sql, p);
    }

    public int delete(Long id) {
        String sql = "DELETE FROM usuarios WHERE id=:id";
        return jdbc.update(sql, Map.of("id", id));
    }
}