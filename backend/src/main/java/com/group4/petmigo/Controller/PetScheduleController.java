package com.group4.petmigo.Controller;

import com.group4.petmigo.models.entities.pet.PetSchedule;
import com.group4.petmigo.Service.PetScheduleService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.util.Map;

@RestController
@RequestMapping("/api/petschedules")
public class PetScheduleController {

    private final PetScheduleService service;

    public PetScheduleController(PetScheduleService service) {
        this.service = service;
    }

    @PostMapping("/pet/{petId}")
    public ResponseEntity<PetSchedule> createSchedule(@PathVariable Long petId, @RequestBody PetSchedule schedule) {
        try {
            PetSchedule created = service.createSchedule(petId, schedule);
            return ResponseEntity.ok(created);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PutMapping("/schedules/{scheduleId}")
    public ResponseEntity<PetSchedule> updateSchedule(
            @PathVariable Long scheduleId,
            @RequestBody PetSchedule schedule) {
        try {
            PetSchedule updated = service.updateSchedule(scheduleId, schedule);
            return ResponseEntity.ok(updated);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    @DeleteMapping("/{scheludeId}")
    public ResponseEntity<Void> deleteSchedule(@PathVariable Long id) {
        service.deleteSchedule(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<Map<String, Object>> getPetsSchedulesByUserId(@PathVariable Long userId) {
        Map<String, Object> response = service.getPetsWithSchedulesAndTotalExpenseByUserId(userId);
        return ResponseEntity.ok(response);
    }
}
