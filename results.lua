function results_update(dt)
    
end

function results_keypressed(key, scancode, isrepeat)
    if key == 'r' then
        sweet_spot = tonumber(string.format("%.2f", love.math.random() * (sweet_spot_range[2] - sweet_spot_range[1]) + sweet_spot_range[1]))
        heat_val = 0
        heat_direction = 0
        timer_val = 0
        hammer_cooldown_val = 0
        hammer_held = 0
        hammer_swing_count = hammer_swing_count_max
        game_active = 0
        score = 0
        temp_scoring_bracket = ""
        time_bonus = 0
        scoring_bracket = ""
        round_start_countdown = round_start_countdown_max
        hammer_hit_history = {'-', '-', '-', '-', '-', '-', '-', '-', '-', '-'}
        hammer_hit_quality_timer = hammer_hit_quality_timer_max
        application_state = 1
    end
end

function results_keyreleased(key, scancode, isrepeat)

end

function results_draw()
    -- Graphics for score
    love.graphics.setColor(1, 1, 0)
    love.graphics.print("Score: " .. score, 10, 130)

    -- Graphics for scoring bracket
    if score >= 20 then
        love.graphics.setColor(0, 1, 0)
    else
        love.graphics.setColor(1, 0 ,0)
    end
    love.graphics.print("Temporary scoring Bracket: " .. temp_scoring_bracket, 10, 150)

    -- Graphics for time Bonus
    love.graphics.setColor(0, 1, 0)
    if time_bonus == 0 then
        love.graphics.setColor(1, 1, 1)
    elseif time_bonus == -10 then
        love.graphics.setColor(1, 0, 0)
    end
    love.graphics.print("Time Bonus: " .. time_bonus, 10, 170)

    -- Graphics for scoring bracket
    if score + time_bonus >= 20 then
        love.graphics.setColor(0, 1, 0)
    else
        love.graphics.setColor(1, 0 ,0)
    end
    love.graphics.print("Scoring Bracket: " .. scoring_bracket, 10, 190)

    -- Graphics for win and lose
    if game_active == 2 and score + time_bonus >= 20 then
        love.graphics.print("You Win", 10, 210)
    elseif game_active == 2 then
        love.graphics.print("You Lose", 10, 210)
    end

    -- Graphics for play again prompt
    if game_active == 2 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Press R to play again", 10, 230)
    end

    -- Graphics for hit history
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Hammer Hit History: [" .. hammer_hit_history[1] .. "], [" .. hammer_hit_history[2] .. "], [" .. hammer_hit_history[3] .. "], [" .. hammer_hit_history[4] .. "], [" .. hammer_hit_history[5] .. "], [" .. hammer_hit_history[6] .. "], [" .. hammer_hit_history[7] .. "], [" .. hammer_hit_history[8] .. "], [" .. hammer_hit_history[9] .. "], [" .. hammer_hit_history[10] .. "]", 10, 250)
end