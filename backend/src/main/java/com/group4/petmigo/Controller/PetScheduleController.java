package com.group4.petmigo.Controller;

import com.group4.petmigo.models.entities.pet.PetSchedule;
import com.group4.petmigo.Service.PetScheduleService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/petschedules")
public class PetScheduleController {

    private final PetScheduleService service;

    public PetScheduleController(PetScheduleService service) {
        this.service = service;
    }

    /* ──────────────── Create ──────────────── */
    @PostMapping("/pet/{petId}")
    public ResponseEntity<PetSchedule> createSchedule(
            @PathVariable Long petId,
            @RequestBody PetSchedule schedule) {

        PetSchedule created = service.createSchedule(petId, schedule);
        return ResponseEntity.ok(created);
    }

    /* ──────────────── Update ──────────────── */
    @PutMapping("/{scheduleId}")
    public ResponseEntity<PetSchedule> updateSchedule(
            @PathVariable Long scheduleId,
            @RequestBody PetSchedule schedule) {

        PetSchedule updated = service.updateSchedule(scheduleId, schedule);
        return ResponseEntity.ok(updated);
    }

    /* ──────────────── Delete ──────────────── */
    @DeleteMapping("/{scheduleId}")
    public ResponseEntity<Void> deleteSchedule(@PathVariable Long scheduleId) {
        service.deleteSchedule(scheduleId);
        return ResponseEntity.noContent().build();
    }

    /* ──────────────── List jadwal per user ──────────────── */
    @GetMapping("/user/{userId}")
    public ResponseEntity<Map<String, Object>> getPetsSchedulesByUserId(
            @PathVariable Long userId) {

        Map<String, Object> response = service
                .getPetsWithSchedulesAndTotalExpenseByUserId(userId);
        return ResponseEntity.ok(response);
    }

    /* ──────────────── 🔍 List jadwal per pet ──────────────── */
    @GetMapping("/pet/{petId}")
    public ResponseEntity<List<PetSchedule>> getSchedulesByPetId(
            @PathVariable Long petId) {

        List<PetSchedule> schedules = service.getSchedulesByPetId(petId);
        return ResponseEntity.ok(schedules);
    }
}
