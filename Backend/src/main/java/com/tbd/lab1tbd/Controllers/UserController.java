package com.tbd.lab1tbd.Controllers;

import com.tbd.lab1tbd.Entities.UserEntity;
import com.tbd.lab1tbd.Services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService service;

    @GetMapping("/{id}")
    public UserEntity getbyid(@PathVariable Long id) {
        return service.getbyid(id);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Void> update(@PathVariable Long id, @RequestBody UserEntity user) {
        // (Aquí faltaría lógica para asegurar que el usuario autenticado
        // solo pueda modificarse a sí mismo)
        service.update(id, user);
        return ResponseEntity.noContent().build();
    }

    // Este endpoint ahora estará PROTEGIDO por JWT.
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        // (Aquí faltaría lógica de autorización)
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
