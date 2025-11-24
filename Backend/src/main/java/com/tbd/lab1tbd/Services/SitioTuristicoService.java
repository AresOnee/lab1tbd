package com.tbd.lab1tbd.Services;

import com.tbd.lab1tbd.Entities.SitioTuristico;
import com.tbd.lab1tbd.Dto.SitioTuristicoRequest;
import com.tbd.lab1tbd.Repositories.SitioTuristicoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SitioTuristicoService {

    private final SitioTuristicoRepository repository;

    public List<SitioTuristico> getAll() {
        return repository.findAll();
    }

    public SitioTuristico getById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Sitio Turístico no encontrado"));
    }

    public Long create(SitioTuristicoRequest sitio) {
        // (Aquí podrías agregar validaciones, ej. que el nombre no esté vacío)
        return repository.create(sitio);
    }

    public void update(Long id, SitioTuristicoRequest sitio) {
        // Primero, verificamos que exista
        getById(id); 
        // Si no lanza excepción, actualizamos
        repository.update(id, sitio);
    }

    public void delete(Long id) {
        if (repository.delete(id) == 0) {
            throw new RuntimeException("Sitio Turístico no encontrado");
        }
    }

    public List<SitioTuristico> getPopulares() {
        return repository.findPopulares();
    }

    public List<SitioTuristico> getByTipo(String tipo) {
        return repository.findByTipo(tipo);
    }
}
