package com.group4.petmigo.Service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.group4.petmigo.DTO.VetDTO;
import com.group4.petmigo.Repository.VetRepository;
import com.group4.petmigo.models.entities.NeedVet.Vet.Vet;
import com.group4.petmigo.models.entities.User.status;

@Service
public class VetService {

    private final VetRepository vetRepository;

    // Constructor injection agar vetRepository tidak null
    public VetService(VetRepository vetRepository) {
        this.vetRepository = vetRepository;
    }

    public VetDTO register(Vet vet){

        if (vetRepository.existsByEmail(vet.getEmail())) {
            throw new RuntimeException("Email sudah digunakan.");
        }
        if (vetRepository.existsByName(vet.getName())) {
            throw new RuntimeException("Username sudah digunakan.");
        }

        vet.setStatus(status.offline);
        vet.setClinics(null);

        Vet saved = vetRepository.save(vet);
        return toDTO(saved);
    }

    public VetDTO login(String email, String password){
        Vet vet = vetRepository.findByEmail(email);
        if (vet != null && vet.getPassword().equals(password)) {
            return toDTO(vet);
        }
        throw new RuntimeException("email atau password salah");
    }

    public List<VetDTO> getAllVets() {
    List<Vet> vets = vetRepository.findAll();
    return vets.stream()
               .map(this::toDTO)
               .collect(Collectors.toList());
}

    private VetDTO toDTO(Vet vet){
        VetDTO dto = new VetDTO();
        dto.setVetid(vet.getVetid());         // perbaikan: set ke dto, bukan vet
        dto.setName(vet.getName());
        dto.setEmail(vet.getEmail());
        dto.setSpecialization(vet.getSpecialization());
        dto.setExperienceYears(vet.getExperienceYears());
        dto.setOverview(vet.getOverview());
        dto.setSchedule(vet.getSchedule());;
        return dto;
    }
}
