package com.group4.petmigo.Service;

import com.group4.petmigo.Repository.ChatRepository;
import com.group4.petmigo.Repository.MessageRepository;
import com.group4.petmigo.Repository.UserRepository;
import com.group4.petmigo.Repository.VetRepository;
import com.group4.petmigo.models.entities.Chat.Chat;
import com.group4.petmigo.models.entities.Chat.Message;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ChatService {

    @Autowired
    private ChatRepository chatRepo;

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private VetRepository vetrepo;

    @Autowired
    private MessageRepository messageRepo;

    // Membuat chat baru antara user dan dokter
    public Chat createChat(Long user_id, Long vet_id) {
        Chat chat = new Chat();
        chat.setTimecreated(LocalDateTime.now());
        chat.setStatus("ACTIVE");
        chat.setUser(userRepo.findById(user_id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User tidak ditemukan")));
        chat.setVet(vetrepo.findById(vet_id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Dokter tidak ditemukan")));
        return chatRepo.save(chat);
    }

    // Kirim pesan ke dalam chat yang sudah ada
    public Message sendMessage(Long chat_id, String role, Long sender_id, String messagetext) {
        if (messagetext == null || messagetext.trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Pesan tidak boleh kosong");
        }

        Chat chat = chatRepo.findById(chat_id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Chat tidak ditemukan"));

        String name;

        switch (role.toUpperCase()) {
            case "USER":
                if (chat.getUser() == null || !chat.getUser().getUserid().equals(sender_id)) {
                    throw new ResponseStatusException(HttpStatus.FORBIDDEN, "User tidak berhak mengirim pesan ke chat ini");
                }
                name = userRepo.findById(sender_id)
                        .map(user -> user.getName())
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User tidak ditemukan"));
                break;

            case "VET":
                if (chat.getVet() == null || !chat.getVet().getVetid().equals(sender_id)) {
                    throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Dokter tidak berhak mengirim pesan ke chat ini");
                }
                name = vetrepo.findById(sender_id)
                        .map(doc -> doc.getName())
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Dokter tidak ditemukan"));
                break;

            default:
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tipe pengirim tidak valid");
        }

        Message message = new Message();
        message.setRole(role.toUpperCase());
        message.setSender_id(sender_id);
        message.setName(name);
        message.setMessagetext(messagetext.trim());
        message.setSentdate(LocalDateTime.now());
        message.setChat(chat);

        return messageRepo.save(message);
    }

    // Mengambil semua pesan dalam chat tertentu
    public List<Message> getMessages(Long chat_id) {
        Chat chat = chatRepo.findById(chat_id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Chat tidak ditemukan"));

        List<Message> messages = chat.getMessages();

        messages.forEach(msg -> {
            System.out.println("[" + msg.getSentdate() + "] " +
                    msg.getRole() + " ID " + msg.getSender_id() + ": " +
                    msg.getMessagetext());
        });

        return messages;
    }

    // Mengambil semua chat berdasarkan userId
    public List<Chat> getChatsByUser_Id(Long user_id) {
        userRepo.findById(user_id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User tidak ditemukan"));
        return chatRepo.findByUser_Userid(user_id);
    }

    // Mengambil semua chat berdasarkan senderType dan ID
    public List<Chat> getChatsBySender(String role, Long id) {
        List<Chat> chats;
        switch (role.toUpperCase()) {
            case "USER":
                userRepo.findById(id)
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User tidak ditemukan"));
                chats = chatRepo.findByUser_Userid(id);
                break;
            case "VET":
                vetrepo.findById(id)
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Dokter tidak ditemukan"));
                chats = chatRepo.findByVet_Vetid(id);
                break;
            default:
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tipe pengirim tidak valid");
        }

        // Urutkan pesan dari yang paling awal
        chats.forEach(chat -> {
            chat.getMessages().sort((m1, m2) -> m1.getSentdate().compareTo(m2.getSentdate()));
        });

        return chats;
    }
}
