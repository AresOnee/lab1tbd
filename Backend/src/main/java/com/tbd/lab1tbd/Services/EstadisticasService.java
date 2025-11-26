package com.tbd.lab1tbd.Services;

import com.tbd.lab1tbd.Dto.*;
import com.tbd.lab1tbd.Repositories.EstadisticasRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Service para exponer las estadísticas del sistema.
 * Simplemente delega al repository.
 */
@Service
@RequiredArgsConstructor
public class EstadisticasService {

    private final EstadisticasRepository repository;

    public List<EstadisticasPorTipoResponse> obtenerEstadisticasPorTipo() {
        return repository.obtenerEstadisticasPorTipo();
    }

    public List<TopResenadorResponse> obtenerTopResenadores() {
        return repository.obtenerTopResenadores();
    }

    public List<ProximidadSitiosResponse> obtenerAnalisisProximidad() {
        return repository.obtenerAnalisisProximidad();
    }

    public List<SitioValoracionInusualResponse> obtenerSitiosValoracionInusual() {
        return repository.obtenerSitiosValoracionInusual();
    }

    public List<SitioPocasContribucionesResponse> obtenerSitiosPocasContribuciones() {
        return repository.obtenerSitiosPocasContribuciones();
    }

    public List<ResenaLargaResponse> obtenerResenasLargas() {
        return repository.obtenerResenasLargas();
    }

    public List<ResumenContribucionesResponse> obtenerResumenContribuciones() {
        return repository.obtenerResumenContribuciones();
    }
}
