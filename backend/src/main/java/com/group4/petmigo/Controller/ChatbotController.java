package com.group4.petmigo.Controller;

import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.group4.petmigo.Service.ChatBotService;
import com.group4.petmigo.models.entities.AskAI.AIChatRoom;
import com.group4.petmigo.models.entities.User.User;
import com.group4.petmigo.Repository.UserRepository;
import com.group4.petmigo.DTO.ChatbotDTO;
import com.group4.petmigo.DTO.RoomNameDTO;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

import jakarta.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/api/chatbot")
@CrossOrigin(origins = "*")
@Tag(name = "Chatbot", description = "API untuk manajemen chatbot AI PetMigo")
public class ChatbotController {

    @Autowired
    private ChatBotService chatBotService;

    @Autowired
    private UserRepository userRepository;

    private Object data = "";

    @Operation(summary = "Dapatkan semua chat rooms user", description = "Mengambil daftar semua chat room yang dimiliki oleh user")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Berhasil mengambil chat rooms"),
        @ApiResponse(responseCode = "404", description = "User tidak ditemukan"),
        @ApiResponse(responseCode = "403", description = "Akses ditolak"),
        @ApiResponse(responseCode = "500", description = "Internal server error")
    })
    @GetMapping("/rooms/{userId}")
    public ResponseEntity<Object> getChatRooms(
            HttpServletRequest request,
            @Parameter(description = "ID user", required = true) @PathVariable Long userId) {
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isEmpty()) {
                httpStatus = HttpStatus.NOT_FOUND;
                data = Map.of("error", "User tidak ditemukan");
            } else {
                List<AIChatRoom> chatRooms = chatBotService.getChatRoomsByUser(userOpt.get());
                ArrayList<Object> chatRoomsData = new ArrayList<Object>();
                for (AIChatRoom chatRoom : chatRooms) {
                    chatRoomsData.add(Map.of(
                            "chatRoomId", chatRoom.getId(),
                            "chatRoomName", chatRoom.getTitle() != null ? chatRoom.getTitle() : "New Chat",
                            "lastChatDateTime", chatRoom.getLastChatDateTime() != null ? chatRoom.getLastChatDateTime() : "",
                            "lastChat", chatRoom.getLastChat() != null ? chatRoom.getLastChat() : "",
                            "lastChatIsBot", false
                    ));
                }
                data = Map.of("chatRooms", chatRoomsData);
            }
        } catch (IllegalArgumentException e) {
            httpStatus = HttpStatus.BAD_REQUEST;
            data = Map.of("error", e.getMessage());
        } catch (Exception e) {
            httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
            data = Map.of("error", e.getMessage());
        }
        return ResponseEntity
                .status(httpStatus)
                .contentType(MediaType.APPLICATION_JSON)
                .body(data);
    }

    @GetMapping("/rooms/detail/{roomId}")
    public ResponseEntity<Object> getChatRoom(HttpServletRequest request, @PathVariable String roomId) {
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            Optional<AIChatRoom> roomOpt = chatBotService.findChatRoomById(roomId);
            if (roomOpt.isEmpty()) {
                httpStatus = HttpStatus.NOT_FOUND;
                data = Map.of("error", "Chat Room tidak ditemukan");
            } else {
                AIChatRoom chatRoom = roomOpt.get();
                data = Map.of(
                        "chatRoomId", chatRoom.getId(),
                        "chatRoomName", chatRoom.getTitle() != null ? chatRoom.getTitle() : "New Chat",
                        "chatHistory", chatBotService.getHistory(chatRoom)

                );
            }
        } catch (IllegalArgumentException e) {
            httpStatus = HttpStatus.BAD_REQUEST;
            data = Map.of("error", e.getMessage());
        } catch (Exception e) {
            httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
            data = Map.of("error", e.getMessage());
        }
        return ResponseEntity
                .status(httpStatus)
                .contentType(MediaType.APPLICATION_JSON)
                .body(data);
    }

    @PutMapping("/rooms/{roomId}/rename")
    public ResponseEntity<Object> renameChatRoom(HttpServletRequest request, @PathVariable String roomId, @RequestBody RoomNameDTO renameDTO) {
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            if (renameDTO.getRoomName() == null || renameDTO.getRoomName().trim().isEmpty()) {
                httpStatus = HttpStatus.BAD_REQUEST;
                data = Map.of("error", "Judul Chat tidak valid");
            } else {
                Optional<AIChatRoom> roomOpt = chatBotService.findChatRoomById(roomId);
                if (roomOpt.isEmpty()) {
                    httpStatus = HttpStatus.NOT_FOUND;
                    data = Map.of("error", "Chat Room tidak ditemukan");
                } else {
                    AIChatRoom chatRoom = roomOpt.get();
                    String updatedName = chatBotService.renameChatRoom(chatRoom, renameDTO.getRoomName());
                    data = Map.of(
                            "chatRoomId", chatRoom.getId(),
                            "chatRoomName", updatedName
                    );
                }
            }
        } catch (IllegalArgumentException e) {
            httpStatus = HttpStatus.BAD_REQUEST;
            data = Map.of("error", e.getMessage());
        } catch (Exception e) {
            httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
            data = Map.of("error", e.getMessage());
        }
        return ResponseEntity
                .status(httpStatus)
                .contentType(MediaType.APPLICATION_JSON)
                .body(data);
    }

    @DeleteMapping("/rooms/{roomId}")
    public ResponseEntity<Object> deleteChatRoom(HttpServletRequest request, @PathVariable String roomId) {
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            Optional<AIChatRoom> roomOpt = chatBotService.findChatRoomById(roomId);
            if (roomOpt.isEmpty()) {
                httpStatus = HttpStatus.NOT_FOUND;
                data = Map.of("error", "Chat Room tidak ditemukan");
            } else {
                AIChatRoom chatRoom = roomOpt.get();
                chatBotService.deleteChatRoomById(chatRoom);
                data = Map.of("status", "Chat Room berhasil dihapus");
            }
        } catch (IllegalArgumentException e) {
            httpStatus = HttpStatus.BAD_REQUEST;
            data = Map.of("error", e.getMessage());
        } catch (Exception e) {
            httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
            data = Map.of("error", e.getMessage());
        }
        return ResponseEntity
                .status(httpStatus)
                .contentType(MediaType.APPLICATION_JSON)
                .body(data);
    }

    @PostMapping("/rooms/{roomId}/chat")
    public ResponseEntity<Object> sendMessage(HttpServletRequest request, @PathVariable String roomId, @RequestBody ChatbotDTO promptDTO) {
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            // Validate DTO
            promptDTO.trim();
            if (!promptDTO.checkDTO()) {
                httpStatus = HttpStatus.BAD_REQUEST;
                data = Map.of("error", "Prompt data tidak valid");
            } else {
                promptDTO.checkLength();
                
                Optional<AIChatRoom> roomOpt = chatBotService.findChatRoomById(roomId);
                if (roomOpt.isEmpty()) {
                    httpStatus = HttpStatus.NOT_FOUND;
                    data = Map.of("error", "Chat Room tidak ditemukan");
                } else {
                    AIChatRoom chatRoom = roomOpt.get();
                    String response = chatBotService.sendPrompt(promptDTO.getPrompt(), chatRoom);
                    data = Map.of(
                            "chatRoomId", chatRoom.getId(),
                            "chatRoomName", chatRoom.getTitle() != null ? chatRoom.getTitle() : "New Chat",
                            "response", response
                    );
                }
            }
        } catch (JsonProcessingException e) {
            httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
            data = Map.of("error", "Error processing request: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            httpStatus = HttpStatus.BAD_REQUEST;
            data = Map.of("error", e.getMessage());
        } catch (Exception e) {
            httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
            data = Map.of("error", e.getMessage());
        }
        return ResponseEntity
                .status(httpStatus)
                .contentType(MediaType.APPLICATION_JSON)
                .body(data);
    }

    @PostMapping("/rooms/{roomId}/generate-name")
    public ResponseEntity<Object> generateRoomName(HttpServletRequest request, @PathVariable String roomId) {
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            Optional<AIChatRoom> roomOpt = chatBotService.findChatRoomById(roomId);
            if (roomOpt.isEmpty()) {
                httpStatus = HttpStatus.NOT_FOUND;
                data = Map.of("error", "Chat Room tidak ditemukan");
            } else {
                AIChatRoom chatRoom = roomOpt.get();
                String generatedName = chatBotService.generateRoomName(chatRoom);
                String updatedName = chatBotService.renameChatRoom(chatRoom, generatedName);
                data = Map.of(
                        "chatRoomId", chatRoom.getId(),
                        "chatRoomName", updatedName
                );
            }
        } catch (JsonProcessingException e) {
            httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
            data = Map.of("error", "Error generating room name: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            httpStatus = HttpStatus.BAD_REQUEST;
            data = Map.of("error", e.getMessage());
        } catch (Exception e) {
            httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
            data = Map.of("error", e.getMessage());
        }
        return ResponseEntity
                .status(httpStatus)
                .contentType(MediaType.APPLICATION_JSON)
                .body(data);
    }

    @PostMapping("/rooms/{userId}")
    public ResponseEntity<Object> createChatRoom(
            HttpServletRequest request,
            @Parameter(description = "ID user", required = true) @PathVariable Long userId) {
        HttpStatus httpStatus = HttpStatus.CREATED;
        try {
            System.out.println("Creating chat room for user ID: " + userId);
            
            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isEmpty()) {
                System.err.println("User not found with ID: " + userId);
                httpStatus = HttpStatus.NOT_FOUND;
                data = Map.of("error", "User tidak ditemukan");
            } else {
                User user = userOpt.get();
                System.out.println("Found user: " + user.getName());
                
                AIChatRoom chatRoom = chatBotService.createChatRoom(user);
                
                System.out.println("Chat room created successfully: " + chatRoom.getId());
                System.out.println("Chat room Title: " + chatRoom.getTitle());
                
                // Return data in format expected by frontend
                data = Map.of(
                    "id", chatRoom.getId(),
                    "title", chatRoom.getTitle(),
                    "judulChat", chatRoom.getTitle(), // Untuk backward compatibility
                    "createdAt", chatRoom.getCreatedAt().toString(),
                    "editedAt", chatRoom.getEditedAt().toString(),
                    "aiChats", new ArrayList<>(),
                    "user_id", Map.of("userid", user.getUserid())
                );
            }
        } catch (IllegalArgumentException e) {
            System.err.println("Bad request error: " + e.getMessage());
            httpStatus = HttpStatus.BAD_REQUEST;
            data = Map.of("error", e.getMessage());
        } catch (Exception e) {
            System.err.println("Internal server error: " + e.getMessage());
            e.printStackTrace();
            httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
            data = Map.of("error", "Error creating chat room: " + e.getMessage());
        }
        return ResponseEntity
                .status(httpStatus)
                .contentType(MediaType.APPLICATION_JSON)
                .body(data);
    }

    @PostMapping("/rooms/create")
    public ResponseEntity<Object> createRoomPrompt(HttpServletRequest request, @RequestBody ChatbotDTO promptDTO) {
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            // Validate DTO
            promptDTO.trim();
            if (!promptDTO.checkDTO()) {
                httpStatus = HttpStatus.BAD_REQUEST;
                data = Map.of("error", "Prompt data tidak valid");
            } else {
                promptDTO.checkLength();
                
                // Assuming we need a user - this might need adjustment based on your authentication
                // For now, using a default user or you might need to get user from session/token
                User defaultUser = userRepository.findById(1L).orElse(null);
                if (defaultUser == null) {
                    httpStatus = HttpStatus.NOT_FOUND;
                    data = Map.of("error", "User tidak ditemukan");
                } else {
                    AIChatRoom chatRoom = chatBotService.createChatRoom(defaultUser);
                    String response = chatBotService.sendPrompt(promptDTO.getPrompt(), chatRoom);
                    String generatedName = chatBotService.generateRoomName(chatRoom);
                    String chatRoomName = chatBotService.renameChatRoom(chatRoom, generatedName);
                    data = Map.of(
                            "chatRoomId", chatRoom.getId(),
                            "chatRoomName", chatRoomName,
                            "response", response
                    );
                }
            }
        } catch (JsonProcessingException e) {
            httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
            data = Map.of("error", "Error processing request: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            httpStatus = HttpStatus.BAD_REQUEST;
            data = Map.of("error", e.getMessage());
        } catch (Exception e) {
            httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
            data = Map.of("error", e.getMessage());
        }
        return ResponseEntity
                .status(httpStatus)
                .contentType(MediaType.APPLICATION_JSON)
                .body(data);
    }
}