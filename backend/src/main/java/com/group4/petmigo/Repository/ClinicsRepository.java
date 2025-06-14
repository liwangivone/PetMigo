package com.group4.petmigo.Repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.group4.petmigo.models.entities.NeedVet.Clinics.Clinics;

public interface ClinicsRepository extends JpaRepository<Clinics, Long> {
    boolean existsByName(String name);
    Optional<Clinics> findByName(String name);   // ← untuk mengambil klinik eksis
}
