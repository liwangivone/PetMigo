package com.group4.petmigo.Controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.group4.petmigo.Service.ChatBotService;
import com.group4.petmigo.models.entities.ChatBot.AIChatRoom;
import com.group4.petmigo.models.entities.User.User;
import com.group4.petmigo.Repository.UserRepository;
import com.group4.petmigo.DTO.ChatbotDTO;
import com.group4.petmigo.DTO.RenameRoomDTO;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/chatbot")
@CrossOrigin(origins = "*")
@Tag(name = "Chatbot", description = "API untuk manajemen chatbot AI PetMigo")
public class ChatbotController {@Autowired
    private ChatBotService chatBotService;

    @Autowired
    private UserRepository userRepository;    @Operation(summary = "Dapatkan semua chat rooms user", description = "Mengambil daftar semua chat room yang dimiliki oleh user")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Berhasil mengambil chat rooms"),
        @ApiResponse(responseCode = "404", description = "User tidak ditemukan")
    })
    @GetMapping("/rooms/{userId}")
    public ResponseEntity<List<AIChatRoom>> getChatRooms(
            @Parameter(description = "ID user", required = true) @PathVariable Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        
        List<AIChatRoom> chatRooms = chatBotService.getChatRoomsByUser(userOpt.get());
        return ResponseEntity.ok(chatRooms);
    }

    @PostMapping("/rooms/{userId}")
    public ResponseEntity<AIChatRoom> createChatRoom(@PathVariable Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        
        AIChatRoom newRoom = chatBotService.createChatRoom(userOpt.get());
        return ResponseEntity.status(HttpStatus.CREATED).body(newRoom);
    }

    @GetMapping("/rooms/detail/{roomId}")
    public ResponseEntity<AIChatRoom> getChatRoom(@PathVariable String roomId) {
        Optional<AIChatRoom> roomOpt = chatBotService.findChatRoomById(roomId);
        if (roomOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        
        return ResponseEntity.ok(roomOpt.get());
    }

    @PutMapping("/rooms/{roomId}/rename")
    public ResponseEntity<String> renameChatRoom(@PathVariable String roomId, @RequestBody RenameRoomDTO renameDTO) {
        Optional<AIChatRoom> roomOpt = chatBotService.findChatRoomById(roomId);
        if (roomOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        
        String updatedName = chatBotService.renameChatRoom(roomOpt.get(), renameDTO.getNewName());
        return ResponseEntity.ok(updatedName);
    }

    @DeleteMapping("/rooms/{roomId}")
    public ResponseEntity<Void> deleteChatRoom(@PathVariable String roomId) {
        Optional<AIChatRoom> roomOpt = chatBotService.findChatRoomById(roomId);
        if (roomOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        
        chatBotService.deleteChatRoomById(roomOpt.get());
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/rooms/{roomId}/chat")
    public ResponseEntity<String> sendMessage(@PathVariable String roomId, @RequestBody ChatbotDTO promptDTO) {
        Optional<AIChatRoom> roomOpt = chatBotService.findChatRoomById(roomId);
        if (roomOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        
        try {
            // Validate DTO
            promptDTO.trim();
            promptDTO.checkDTO();
            promptDTO.checkLength();
            
            String response = chatBotService.sendPrompt(promptDTO.getPrompt(), roomOpt.get());
            return ResponseEntity.ok(response);
        } catch (JsonProcessingException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error processing request: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/rooms/{roomId}/generate-name")
    public ResponseEntity<String> generateRoomName(@PathVariable String roomId) {
        Optional<AIChatRoom> roomOpt = chatBotService.findChatRoomById(roomId);
        if (roomOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        
        try {
            String generatedName = chatBotService.generateRoomName(roomOpt.get());
            String updatedName = chatBotService.renameChatRoom(roomOpt.get(), generatedName);
            return ResponseEntity.ok(updatedName);
        } catch (JsonProcessingException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error generating room name: " + e.getMessage());
        }
    }
}
