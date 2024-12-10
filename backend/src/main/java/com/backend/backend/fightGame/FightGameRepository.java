package com.backend.backend.fightGame;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.backend.backend.user.User;
import java.util.Optional;
import java.util.List;

@Repository
public interface FightGameRepository extends JpaRepository<FightGame, Long> {
    List<FightGame> findByUser1AndUser2(User user1, User user2);
}
