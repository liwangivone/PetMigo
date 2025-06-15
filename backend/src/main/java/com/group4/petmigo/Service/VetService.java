package com.group4.petmigo.Service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.group4.petmigo.DTO.VetDTO;
import com.group4.petmigo.Repository.VetRepository;
import com.group4.petmigo.models.entities.NeedVet.Clinics.Clinics;
import com.group4.petmigo.models.entities.NeedVet.Vet.Vet;
import com.group4.petmigo.models.entities.User.status;

@Service
public class VetService {

    private final VetRepository vetRepository;

    public VetService(VetRepository vetRepository) {
        this.vetRepository = vetRepository;
    }

    // ─────────── register ───────────
    public VetDTO register(Vet vet) {
        if (vetRepository.existsByEmail(vet.getEmail()))
            throw new RuntimeException("Email sudah digunakan.");
        if (vetRepository.existsByName(vet.getName()))
            throw new RuntimeException("Username sudah digunakan.");

        vet.setStatus(status.offline);
        vet.setClinics(null);               // vet awalnya belum terikat klinik

        return toDTO(vetRepository.save(vet));
    }

    // ─────────── login ───────────
    public VetDTO login(String email, String password) {
        Vet vet = vetRepository.findByEmail(email);
        if (vet != null && vet.getPassword().equals(password))
            return toDTO(vet);
        throw new RuntimeException("email atau password salah");
    }

    // ─────────── get all ───────────
    public List<VetDTO> getAllVets() {
        return vetRepository.findAll()
                            .stream()
                            .map(this::toDTO)
                            .collect(Collectors.toList());
    }

    // ─────────── mapper ───────────
    private VetDTO toDTO(Vet vet) {
        VetDTO dto = new VetDTO();
        dto.setVetid(vet.getVetid());
        dto.setName(vet.getName());
        dto.setEmail(vet.getEmail());
        dto.setSpecialization(vet.getSpecialization());
        dto.setExperienceYears(vet.getExperienceYears());
        dto.setOverview(vet.getOverview());
        dto.setSchedule(vet.getSchedule());

        Clinics cl = vet.getClinics();          // relasi Many‑to‑One
        if (cl != null) {
            dto.setClinicId(cl.getClinicsid());
            dto.setClinicName(vet.getClinics().getName());   // ← inilah kuncinya
        }
        return dto;
    }
}
