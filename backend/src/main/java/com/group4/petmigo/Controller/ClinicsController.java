package com.group4.petmigo.Controller;

import com.group4.petmigo.DTO.ClinicsDTO;
import com.group4.petmigo.Service.ClinicsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/clinics")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ClinicsController {

    private final ClinicsService clinicsService;

    // CREATE
    @PostMapping
    public ResponseEntity<ClinicsDTO> createClinic(@RequestBody ClinicsDTO dto) {
        ClinicsDTO createdClinic = clinicsService.createClinic(dto);
        return ResponseEntity.ok(createdClinic);
    }

    // READ ALL
    @GetMapping
    public ResponseEntity<List<ClinicsDTO>> getAllClinics() {
        return ResponseEntity.ok(clinicsService.getAllClinics());
    }

    // READ ONE
    @GetMapping("/{id}")
    public ResponseEntity<ClinicsDTO> getClinicById(@PathVariable Long id) {
        ClinicsDTO clinic = clinicsService.getClinicById(id);
        return ResponseEntity.ok(clinic);
    }

    // UPDATE
    @PutMapping("/{id}")
    public ResponseEntity<ClinicsDTO> updateClinic(
            @PathVariable Long id,
            @RequestBody ClinicsDTO dto) {
        ClinicsDTO updatedClinic = clinicsService.updateClinic(id, dto);
        return ResponseEntity.ok(updatedClinic);
    }

    // DELETE
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteClinic(
            @PathVariable Long id,
            @RequestParam(required = false) Long vetId) {
        clinicsService.deleteClinic(id, vetId);
        return ResponseEntity.noContent().build();
    }
}
