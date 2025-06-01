package com.group4.petmigo.Controller;

import com.group4.petmigo.models.entities.pet.PetSchedule;
import com.group4.petmigo.Service.PetScheduleService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/petschedules")
public class PetScheduleController {

    private final PetScheduleService service;

    public PetScheduleController(PetScheduleService service) {
        this.service = service;
    }

    // Buat schedule dengan petId wajib
    @PostMapping("/pet/{petId}")
    public ResponseEntity<PetSchedule> createSchedule(@PathVariable Long petId, @RequestBody PetSchedule schedule) {
        try {
            PetSchedule created = service.createSchedule(petId, schedule);
            return ResponseEntity.ok(created);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<PetSchedule> getSchedule(@PathVariable Long id) {
        return service.getScheduleById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<PetSchedule> updateSchedule(@PathVariable Long id, @RequestBody PetSchedule schedule) {
        if (!id.equals(schedule.getSchedule_id())) {
            return ResponseEntity.badRequest().build();
        }
        try {
            PetSchedule updated = service.updateSchedule(schedule);
            return ResponseEntity.ok(updated);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSchedule(@PathVariable Long id) {
        service.deleteSchedule(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping
    public ResponseEntity<List<PetSchedule>> getAllSchedules() {
        return ResponseEntity.ok(service.getAllSchedules());
    }
    
    @GetMapping("/total-expense/{petId}")
    public ResponseEntity<Integer> getTotalExpenseByPet(@PathVariable Long petId) {
        int totalExpense = service.getTotalExpenseByPetId(petId);
        return ResponseEntity.ok(totalExpense);
    }


}
