package com.group4.petmigo.Controller;

import com.group4.petmigo.Service.ChatService;
import com.group4.petmigo.models.entities.Chat.Chat;
import com.group4.petmigo.models.entities.Chat.Message;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/chat")
public class ChatController {

    @Autowired
    private ChatService chatService;

    // Endpoint membuat chat baru antara user dan dokter
    // Contoh: POST /api/chat/create?user_id=1&vet_id=2
    @PostMapping("/create")
    public ResponseEntity<Chat> createChat(@RequestParam Long user_id, @RequestParam Long vet_id) {
        Chat chat = chatService.createChat(user_id, vet_id);
        return ResponseEntity.ok(chat);
    }

    // Endpoint kirim pesan ke chat yang sudah ada
    // Contoh: POST /api/chat/send-message?chat_id=1&role=USER&sender_id=1&messagetext=halo
    @PostMapping("/send-message")
    public ResponseEntity<Message> sendMessage(
            @RequestParam Long chat_id,
            @RequestParam String role,
            @RequestParam Long sender_id,
            @RequestParam String messagetext) {
        Message message = chatService.sendMessage(chat_id, role, sender_id, messagetext);
        return ResponseEntity.ok(message);
    }

    // Endpoint mengambil semua pesan dalam chat tertentu
    // Contoh: GET /api/chat/messages?chat_id=1
    @GetMapping("/messages")
    public ResponseEntity<List<Message>> getMessages(@RequestParam Long chat_id) {
        List<Message> messages = chatService.getMessages(chat_id);
        return ResponseEntity.ok(messages);
    }

    // Endpoint mengambil semua chat berdasarkan user_id
    // Contoh: GET /api/chat/by-user?user_id=1
    @GetMapping("/by-user")
    public ResponseEntity<List<Chat>> getChatsByUser(@RequestParam Long user_id) {
        List<Chat> chats = chatService.getChatsByUser_Id(user_id);
        return ResponseEntity.ok(chats);
    }

    // Endpoint mengambil semua chat berdasarkan senderType dan id
    // Contoh: GET /api/chat/by-sender?role=USER&id=1
    @GetMapping("/by-sender")
    public ResponseEntity<List<Chat>> getChatsBySender(
            @RequestParam String role,
            @RequestParam Long id) {
        List<Chat> chats = chatService.getChatsBySender(role, id);
        return ResponseEntity.ok(chats);
    }

}
