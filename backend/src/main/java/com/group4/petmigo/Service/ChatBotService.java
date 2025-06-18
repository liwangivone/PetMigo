package com.group4.petmigo.Service;

import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.Optional;
import java.util.stream.Collectors;
import java.time.LocalDateTime;
import java.time.LocalDate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.group4.petmigo.Repository.AIChatRepository;
import com.group4.petmigo.Repository.AIChatRoomRepository;
import com.group4.petmigo.models.entities.AskAI.AIChat;
import com.group4.petmigo.models.entities.AskAI.AIChatRoom;
import com.group4.petmigo.models.entities.User.User;
import java.util.Comparator;

@Service
public class ChatBotService {    
        
    @Autowired
    private AIChatRepository aiChatRepository;

    @Autowired
    private AIChatRoomRepository aiChatRoomRepository;

    @Value("${gemini.api.key}")
    private String geminiApiKey;

    private final String GEMINI_MODEL = "gemini-2.0-flash";
    private final String GEMINI_LINK = "https://generativelanguage.googleapis.com/v1beta/models/" + GEMINI_MODEL
            + ":generateContent";
    private static final ObjectMapper mapper = new ObjectMapper();

    public String getLink() {
        return GEMINI_LINK + "?key=" + geminiApiKey;
    }    public Optional<AIChatRoom> findChatRoomById(String chatbotRoomId) {
        return aiChatRoomRepository.findById(chatbotRoomId).filter(f -> f.getDeletedAt() == null);
    }

    public void deleteChatRoomById(AIChatRoom chatRoom) {
        chatRoom.setDeletedAt(LocalDate.now());
        aiChatRoomRepository.save(chatRoom);
    }

    public List<AIChatRoom> getChatRoomsByUser(User user) {
        return aiChatRoomRepository.findAll().stream()
                .filter(chatRoom -> chatRoom.getDeletedAt() == null)
                .filter(chatRoom -> chatRoom.getUserid().equals(user))
                .sorted(Comparator.comparing(AIChatRoom::getLastChatDateTime).reversed())
                .collect(Collectors.toList());
    }

    public String renameChatRoom(AIChatRoom chatRoom, String newName) {
        chatRoom.setTitle(newName);
        chatRoom.setEditedAt(LocalDate.now());
        aiChatRoomRepository.save(chatRoom);
        return chatRoom.getTitle();
    }

    public AIChatRoom createChatRoom(User user) {
        System.out.println("Creating chat room for user: " + user.getUserid());
        
        AIChatRoom chatRoom = new AIChatRoom();
        chatRoom.setUserid(user);
        
        // Pastikan title tidak null atau kosong
        String defaultTitle = "Chat Room - " + java.time.LocalDateTime.now().format(
            java.time.format.DateTimeFormatter.ofPattern("dd/MM HH:mm")
        );
        chatRoom.setTitle(defaultTitle);
        
        chatRoom.setCreatedAt(LocalDate.now());
        chatRoom.setEditedAt(LocalDate.now());
        chatRoom.setDeletedAt(null);
        
        System.out.println("Saving chat room with title: " + chatRoom.getTitle());
        
        try {
            AIChatRoom savedRoom = aiChatRoomRepository.save(chatRoom);
            System.out.println("Chat room saved successfully with ID: " + savedRoom.getId());
            return savedRoom;
        } catch (Exception e) {
            System.err.println("Error saving chat room: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to create chat room: " + e.getMessage());
        }
    }

    public List<Map<String, Object>> getHistory(AIChatRoom chatRoom) {
        ArrayList<Map<String, Object>> history = new ArrayList<Map<String, Object>>();
        
        if (chatRoom == null || chatRoom.getAiChats() == null) {
            return history;
        }
        
        List<AIChat> chatList = aiChatRepository.findAll().stream()
                .filter(chat -> chat.getIdChatRoom() != null && chat.getIdChatRoom().getId().equals(chatRoom.getId()))
                .sorted(Comparator.comparing(AIChat::getCreatedAt))
                .collect(Collectors.toList());
        
        for (AIChat chat : chatList) {
            Map<String, Object> chatEntry = new HashMap<>();
            chatEntry.put("role", chat.getIsBot() ? "assistant" : "user");
            chatEntry.put("parts", List.of(Map.of("text", chat.getChat())));
            history.add(chatEntry);
        }
        
        return history;
    }
    
    public String sendPrompt(String prompt, AIChatRoom chatRoom) throws JsonProcessingException {
        aiChatRepository.save(new AIChat(
                null,
                chatRoom,
                prompt,
                false,
                LocalDateTime.now()));
        
        // Update last chat time
        chatRoom.setEditedAt(LocalDate.now());
        aiChatRoomRepository.save(chatRoom);
        
        List<Map<String, Object>> history = getHistory(chatRoom);
        String instructions = "Kamu adalah chatbot asisten untuk aplikasi PetMigo, aplikasi perawatan hewan peliharaan. Bantu pengguna dengan informasi tentang perawatan hewan, kesehatan hewan, tips merawat pet, dan konsultasi umum seputar hewan peliharaan. Berikan jawaban yang informatif, ramah, dan mudah dipahami. Jika ada pertanyaan medis serius, sarankan untuk konsultasi dengan dokter hewan. Respon kamu harus bersih tanpa formatting khusus seperti bold, italic, atau markdown.";
        Map<String, Object> data = Map.of("model", GEMINI_MODEL,
                "systemInstruction", Map.of("parts", List.of(Map.of("text", instructions))),
                "generationConfig", Map.of(
                        "temperature", 0.7,
                        "topK", 1,
                        "topP", 1,
                        "maxOutputTokens", 1024),
                "safetySettings", List.of(
                        Map.of("category", "HARM_CATEGORY_DANGEROUS_CONTENT",
                                "threshold", "BLOCK_MEDIUM_AND_ABOVE"),
                        Map.of("category", "HARM_CATEGORY_HATE_SPEECH",
                                "threshold", "BLOCK_MEDIUM_AND_ABOVE"),
                        Map.of("category", "HARM_CATEGORY_HARASSMENT",
                                "threshold", "BLOCK_MEDIUM_AND_ABOVE"),
                        Map.of("category", "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                                "threshold", "BLOCK_MEDIUM_AND_ABOVE")),
                "contents", List.of(history, Map.of(
                        "role", "user",
                        "parts", List.of(Map.of("text", prompt)))));

        // Parsing Map to JSON body
        String jsonBody = mapper.writeValueAsString(data);
        // Create HttpClient with default settings
        HttpClient client = HttpClient.newHttpClient();
        // Build POST request with no body
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(getLink()))
                .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                .header("Content-Type", "application/json")
                .build();

        try {
            // Send the request and retrieve the response as a String
            HttpResponse<String> response = client.send(
                    request,
                    HttpResponse.BodyHandlers.ofString()
            );
            // Output response
            String responseBody = response.body().split("text")[1].substring(4).split("\"")[0].replace("\\n", "");
            aiChatRepository.save(new AIChat(
                    null,
                    chatRoom,
                    responseBody,
                    true,
                    LocalDateTime.now()));
            return responseBody;
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
        return "";
    }
    
    public String generateRoomName(AIChatRoom chatRoom) throws JsonProcessingException {
        int nameLimit = 255;
        List<Map<String, Object>> history = getHistory(chatRoom);
        String prompt = "berikan saya nama room chat berdasarkan chat kita di atas dengan maksimal " + nameLimit
                + " karakter, fokus pada topik perawatan hewan yang dibahas";
        String instructions = "Berikan nama yang cocok untuk chat room ini berdasarkan topik perawatan hewan atau jenis hewan yang dibahas dalam chat. Berikan hanya nama chat room saja tanpa respon lain, maksimal " + nameLimit + " karakter.";
        Map<String, Object> data = Map.of("model", GEMINI_MODEL,
                "systemInstruction", Map.of("parts", List.of(Map.of("text", instructions))),
                "generationConfig", Map.of(
                        "temperature", 0.7,
                        "topK", 1,
                        "topP", 1,
                        "maxOutputTokens", 1024),
                "safetySettings", List.of(
                        Map.of("category", "HARM_CATEGORY_DANGEROUS_CONTENT",
                                "threshold", "BLOCK_MEDIUM_AND_ABOVE"),
                        Map.of("category", "HARM_CATEGORY_HATE_SPEECH",
                                "threshold", "BLOCK_MEDIUM_AND_ABOVE"),
                        Map.of("category", "HARM_CATEGORY_HARASSMENT",
                                "threshold", "BLOCK_MEDIUM_AND_ABOVE"),
                        Map.of("category", "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                                "threshold", "BLOCK_MEDIUM_AND_ABOVE")),
                "contents", List.of(history, Map.of(
                        "role", "user",
                        "parts", List.of(Map.of("text",
                                prompt)))));

        // Parsing Map to JSON body
        String jsonBody = mapper.writeValueAsString(data);
        // Create HttpClient with default settings
        HttpClient client = HttpClient.newHttpClient();
        // Build POST request with no body
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(getLink()))
                .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                .header("Content-Type", "application/json")
                .build();

        try {
            // Send the request and retrieve the response as a String
            HttpResponse<String> response = client.send(
                    request,
                    HttpResponse.BodyHandlers.ofString()
            );
            // Output response
            String responseBody = response.body().split("text")[1].substring(4).split("\"")[0].replace("\\n", "");
            return responseBody.length() > nameLimit ? responseBody.substring(0, nameLimit) : responseBody;
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
        return "";
    }
}