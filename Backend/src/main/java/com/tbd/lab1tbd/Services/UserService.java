package com.tbd.lab1tbd.Services;

import com.tbd.lab1tbd.Entities.UserEntity;
import com.tbd.lab1tbd.Repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository repo;

    public UserEntity getbyid(Long id) {
        return repo.getbyid(id).orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    }

    public void update(Long id, UserEntity u) {
        // Importante: Asegurarse que el 'update' en el repositorio
        // NO actualice la contraseña. Eso debe hacerse en un
        // endpoint separado de 'cambiar contraseña'.
        if (repo.update(id, u) == 0) throw new RuntimeException("Usuario no encontrado");
    }

    public void delete(Long id) {
        if (repo.delete(id) == 0) throw new RuntimeException("Usuario no encontrado");
    }
}
