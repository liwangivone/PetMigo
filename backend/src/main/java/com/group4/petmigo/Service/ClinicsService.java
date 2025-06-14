package com.group4.petmigo.Service;

import java.util.*;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.group4.petmigo.DTO.ClinicsDTO;
import com.group4.petmigo.Repository.ClinicsRepository;
import com.group4.petmigo.Repository.VetRepository;
import com.group4.petmigo.models.entities.NeedVet.Clinics.Clinics;
import com.group4.petmigo.models.entities.NeedVet.Vet.Vet;

@Service
public class ClinicsService {

    private final ClinicsRepository clinicsRepo;
    private final VetRepository vetRepo;

    public ClinicsService(ClinicsRepository cRepo, VetRepository vRepo) {
        this.clinicsRepo = cRepo;
        this.vetRepo = vRepo;
    }

    public String normalizeName(String n) {
        return Arrays.stream(n.trim().toLowerCase().split(" "))
                .filter(w -> !w.isBlank())
                .map(w -> w.substring(0, 1).toUpperCase() + w.substring(1))
                .collect(Collectors.joining(" "));
    }

    public ClinicsDTO createClinic(ClinicsDTO dto) {
        String name = normalizeName(dto.getName());
        Vet vet = vetRepo.findById(dto.getVetId())
                .orElseThrow(() -> new RuntimeException("[ERROR] Vet tidak ditemukan untuk ID: " + dto.getVetId()));

        detachVet(vet);

        Optional<Clinics> optional = clinicsRepo.findByName(name);
        Clinics clinic = optional.orElse(null);

        if (clinic != null) {
            System.out.println("[WARNING] Klinik \"" + name + "\" sudah ada. Data lokasi dan jam buka diabaikan.");
            if (clinic.getVet() == null) clinic.setVet(new ArrayList<>());
            if (!clinic.getVet().contains(vet)) {
                clinic.getVet().add(vet);
                vet.setClinics(clinic);
                System.out.println("[INFO] Vet ID: " + vet.getVetid() + " dikaitkan ke klinik \"" + name + "\"");
            }
            System.out.println("[OK] Klinik lama disimpan ulang.");
            return toDTO(clinicsRepo.save(clinic));
        }

        Clinics newClinic = new Clinics();
        newClinic.setName(name);
        newClinic.setLocation(dto.getLocation());
        newClinic.setOpeninghours(dto.getOpeninghours());
        newClinic.setVet(new ArrayList<>(List.of(vet)));
        vet.setClinics(newClinic);

        System.out.println("[INFO] Klinik baru \"" + name + "\" berhasil dibuat.");
        System.out.println("[OK] Vet ID: " + vet.getVetid() + " dikaitkan ke klinik baru.");
        return toDTO(clinicsRepo.save(newClinic));
    }

    public ClinicsDTO updateClinic(Long clinicId, ClinicsDTO dto) {
        if (dto.getVetId() != null) {
            Vet vet = vetRepo.findById(dto.getVetId())
                    .orElseThrow(() -> new RuntimeException("[ERROR] Vet tidak ditemukan untuk ID: " + dto.getVetId()));

            detachVet(vet);

            String targetName = dto.getName() != null ? normalizeName(dto.getName())
                    : vet.getClinics() != null ? vet.getClinics().getName()
                    : normalizeName("Default");

            Optional<Clinics> optional = clinicsRepo.findByName(targetName);
            Clinics target = optional.orElse(null);

            if (target != null) {
                System.out.println("[INFO] Memindahkan Vet ID: " + vet.getVetid() + " ke klinik \"" + targetName + "\" (klinik lama ditemukan)");
                if (target.getVet() == null) target.setVet(new ArrayList<>());
                if (!target.getVet().contains(vet)) {
                    target.getVet().add(vet);
                    vet.setClinics(target);
                }
                System.out.println("[OK] Vet berhasil dipindahkan ke klinik \"" + targetName + "\"");
                return toDTO(clinicsRepo.save(target));
            }

            Clinics newClinic = new Clinics();
            newClinic.setName(targetName);
            newClinic.setLocation(dto.getLocation());
            newClinic.setOpeninghours(dto.getOpeninghours());
            newClinic.setVet(new ArrayList<>(List.of(vet)));
            vet.setClinics(newClinic);

            System.out.println("[INFO] Klinik baru \"" + targetName + "\" dibuat & Vet dikaitkan.");
            return toDTO(clinicsRepo.save(newClinic));
        }

        Clinics clinic = clinicsRepo.findById(clinicId)
                .orElseThrow(() -> new RuntimeException("[ERROR] Clinic tidak ditemukan untuk ID: " + clinicId));

        System.out.println("[INFO] Memperbarui data klinik ID: " + clinicId);

        if (dto.getName() != null) {
            clinic.setName(normalizeName(dto.getName()));
            System.out.println(" > Nama diupdate menjadi: " + clinic.getName());
        }
        if (dto.getLocation() != null) {
            clinic.setLocation(dto.getLocation());
            System.out.println(" > Lokasi diupdate menjadi: " + dto.getLocation());
        }
        if (dto.getOpeninghours() != null) {
            clinic.setOpeninghours(dto.getOpeninghours());
            System.out.println(" > Jam buka diupdate menjadi: " + dto.getOpeninghours());
        }

        System.out.println("[OK] Klinik berhasil diperbarui.");
        return toDTO(clinicsRepo.save(clinic));
    }

    public List<ClinicsDTO> getAllClinics() {
        return clinicsRepo.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public ClinicsDTO getClinicById(Long id) {
        return toDTO(clinicsRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("[ERROR] Clinic tidak ditemukan untuk ID: " + id)));
    }

    // ✅ deleteClinic Diperbaiki
    public void deleteClinic(Long clinicId, Long vetId) {
        Clinics clinic = clinicsRepo.findById(clinicId)
                .orElseThrow(() -> new RuntimeException("[ERROR] Clinic tidak ditemukan untuk ID: " + clinicId));

        if (vetId != null) {
            Vet vet = vetRepo.findById(vetId)
                    .orElseThrow(() -> new RuntimeException("[ERROR] Vet tidak ditemukan untuk ID: " + vetId));

            if (!clinic.getVet().contains(vet)) {
                throw new RuntimeException("[ERROR] Vet ID " + vetId + " tidak terdaftar di klinik ini.");
            }

            clinic.getVet().remove(vet);
            vet.setClinics(null);
            System.out.println("[INFO] Vet ID: " + vetId + " dilepas dari klinik \"" + clinic.getName() + "\"");

            if (clinic.getVet().isEmpty()) {
                clinicsRepo.delete(clinic);
                System.out.println("[INFO] Klinik \"" + clinic.getName() + "\" dihapus karena tidak memiliki vet lagi.");
            } else {
                clinicsRepo.save(clinic);
                System.out.println("[OK] Vet dihapus; klinik masih memiliki vet lain, jadi tidak dihapus.");
            }

        } else {
            if (clinic.getVet() != null && !clinic.getVet().isEmpty()) {
                throw new RuntimeException("[ERROR] Klinik masih memiliki vet. Lepas semua vet terlebih dulu atau gunakan vetId parameter.");
            }
            clinicsRepo.delete(clinic);
            System.out.println("[OK] Klinik \"" + clinic.getName() + "\" dihapus (kosong).");
        }
    }

    private void detachVet(Vet vet) {
        Clinics old = vet.getClinics();
        if (old != null) {
            old.getVet().remove(vet);
            vet.setClinics(null);
            System.out.println("[INFO] Vet ID: " + vet.getVetid() + " dilepas dari klinik \"" + old.getName() + "\"");
            if (old.getVet().isEmpty()) {
                clinicsRepo.delete(old);
                System.out.println("[INFO] Klinik \"" + old.getName() + "\" dihapus karena tidak memiliki vet lagi.");
            } else {
                clinicsRepo.save(old);
                System.out.println("[INFO] Klinik \"" + old.getName() + "\" disimpan ulang setelah vet dilepas.");
            }
        }
    }

    private ClinicsDTO toDTO(Clinics c) {
        ClinicsDTO dto = new ClinicsDTO();
        dto.setName(c.getName());
        dto.setLocation(c.getLocation());
        dto.setOpeninghours(c.getOpeninghours());

        if (c.getVet() != null && !c.getVet().isEmpty()) {
            List<Long> ids = c.getVet().stream()
                    .map(Vet::getVetid)
                    .collect(Collectors.toList());
            dto.setVetIds(ids);
            dto.setVetId(ids.get(0));
        }

        return dto;
    }
}
