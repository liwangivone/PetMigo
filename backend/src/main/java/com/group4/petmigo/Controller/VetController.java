package com.group4.petmigo.Controller;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.group4.petmigo.DTO.VetDTO;
import com.group4.petmigo.Service.VetService;
import com.group4.petmigo.models.entities.NeedVet.Vet.Vet;

@RestController
@RequestMapping("/api/vets")
@CrossOrigin(origins = "*")
public class VetController {

    private final VetService vetService;

    // Constructor injection agar vetService tidak null
    public VetController(VetService vetService) {
        this.vetService = vetService;
    }

    @PostMapping("/login")
    public VetDTO login(@RequestParam String email, @RequestParam String password) {
        return vetService.login(email, password);
    }

    @PostMapping("/register")
    public VetDTO register(
        @RequestParam String name, String email, String password, String specialization, int experienceYears, String overview, String schedule 
    ) {

        Vet vet = new Vet();
        vet.setName(name);
        vet.setEmail(email);
        vet.setPassword(password);
        vet.setSpecialization(specialization);
        vet.setExperienceYears(experienceYears);
        vet.setOverview(overview);
        vet.setSchedule(schedule);

        return vetService.register(vet);
    }

    @GetMapping("/vet/list")
    public List<VetDTO> getAllVets() {
        return vetService.getAllVets();
    }
}
