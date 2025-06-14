package com.group4.petmigo.DTO;

import java.util.Optional;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class ChatbotDTO {
    private String prompt;

    public boolean checkDTO() {
        if (this.prompt == null)
            throw new IllegalArgumentException("Prompt Tidak Boleh Bernilai NULL");
        return this.prompt != null;
    }

    public boolean checkLength() {
        boolean prompt = Optional.ofNullable(this.prompt)
                .map(s -> s.length() <= 65535 && !s.trim().isEmpty())
                .orElse(true);

        if (!prompt)
            throw new IllegalArgumentException("Prompt Tidak Valid atau Melewati Batas Karakter");

        return prompt;
    }

    public void trim() {
        this.prompt = Optional.ofNullable(this.prompt).map(String::trim).filter(s -> !s.isBlank()).orElse(null);
    }
}