package com.tbd.lab1tbd.Controllers;

import com.tbd.lab1tbd.Entities.UserEntity;
import com.tbd.lab1tbd.Services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService service;

    @GetMapping("/{id}")
    public UserEntity getbyid(@PathVariable Long id) {
        return service.getbyid(id);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Void> update(
            @PathVariable Long id,
            @RequestBody UserEntity user,
            Authentication authentication
    ) {
        String userEmail = authentication.getName();
        service.update(id, user, userEmail);
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
