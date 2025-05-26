package com.group4.petmigo.Repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.group4.petmigo.models.entities.Chat.Chat;


@Repository
public interface ChatRepository extends JpaRepository<Chat, Long> {
    List<Chat> findByVet_Vetid(Long vetid);
    List<Chat> findByUser_Userid(Long userid);
}
