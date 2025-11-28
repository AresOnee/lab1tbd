package com.tbd.lab1tbd.Services;

import com.tbd.lab1tbd.Dto.ListaRequest;
import com.tbd.lab1tbd.Dto.ListaResponse;
import com.tbd.lab1tbd.Entities.ListaPersonalizada;
import com.tbd.lab1tbd.Entities.SitioTuristico;
import com.tbd.lab1tbd.Entities.UserEntity;
import com.tbd.lab1tbd.Repositories.ListaRepository;
import com.tbd.lab1tbd.Repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ListaService {

    private final ListaRepository listaRepository;
    private final UserRepository userRepository;
    private final SitioTuristicoService sitioTuristicoService; // Para verificar que el sitio existe

    private Long getUserIdFromEmail(String email) {
        UserEntity user = userRepository.getByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        return user.getId();
    }

    private void checkAutorizacion(Long idLista, Long idUsuario) {
        Long idAutor = listaRepository.findAutorId(idLista)
                .orElseThrow(() -> new RuntimeException("Lista no encontrada"));
        
        if (!idUsuario.equals(idAutor)) {
            throw new AccessDeniedException("No tiene permiso para modificar esta lista");
        }
    }

    public Long create(ListaRequest request, String userEmail) {
        Long idUsuario = getUserIdFromEmail(userEmail);
        ListaPersonalizada lista = new ListaPersonalizada();
        lista.setIdUsuario(idUsuario);
        lista.setNombre(request.getNombre());
        return listaRepository.create(lista);
    }

    public List<ListaResponse> getByUsuario(String userEmail) {
        Long idUsuario = getUserIdFromEmail(userEmail);
        return listaRepository.findByUsuarioId(idUsuario);
    }

    public List<ListaResponse> getByUsuarioId(Long idUsuario) {
        return listaRepository.findByUsuarioId(idUsuario);
    }

    public List<SitioTuristico> getSitios(Long idLista) {
        return listaRepository.getSitiosByListaId(idLista);
    }

    public void delete(Long idLista, String userEmail) {
        Long idUsuario = getUserIdFromEmail(userEmail);
        checkAutorizacion(idLista, idUsuario);
        
        listaRepository.delete(idLista);
    }

    public void addSitio(Long idLista, Long idSitio, String userEmail) {
        Long idUsuario = getUserIdFromEmail(userEmail);
        checkAutorizacion(idLista, idUsuario);
        
        // Verificamos que el sitio existe
        sitioTuristicoService.getById(idSitio);
        
        listaRepository.addSitioToLista(idLista, idSitio);
    }

    public void removeSitio(Long idLista, Long idSitio, String userEmail) {
        Long idUsuario = getUserIdFromEmail(userEmail);
        checkAutorizacion(idLista, idUsuario);

        listaRepository.removeSitioFromLista(idLista, idSitio);
    }
}