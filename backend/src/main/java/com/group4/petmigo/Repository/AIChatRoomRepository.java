package com.group4.petmigo.Repository;

import com.group4.petmigo.models.entities.AskAI.AIChatRoom;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

@Repository
public interface AIChatRoomRepository extends JpaRepository<AIChatRoom, String> {

    @Query("SELECT DISTINCT cr FROM AIChatRoom cr LEFT JOIN FETCH cr.aiChats WHERE cr.userid.userid = :userId AND cr.deletedAt IS NULL ORDER BY cr.editedAt DESC")
    List<AIChatRoom> findChatRoomsWithChatsByUserid(Long userId);

    @Query("SELECT DISTINCT cr FROM AIChatRoom cr LEFT JOIN FETCH cr.aiChats WHERE cr.id = :roomId AND cr.deletedAt IS NULL")
    Optional<AIChatRoom> findChatRoomWithChatsById(String roomId);

    List<AIChatRoom> findByUserid_UseridAndDeletedAtIsNullOrderByEditedAtDesc(Long userId);
}