function results_update(dt)
    if results_timer_val ~= 0 then
        results_timer_val = results_timer_val - dt
        if results_timer_val < 0 then
            results_timer_val = 0
            if results_state == 0 then
                results_timer_val = 1
                results_state = 1
            elseif results_state == 1 then
                results_timer_val = 1
                results_state = 2
            end
        end
    end
end

function results_keypressed(key, scancode, isrepeat)
    if results_state == 2 and key == 'r' then
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
        results_state = 0
    elseif  results_state == 2 and key == 'escape' then
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
        application_state = 0
        results_state = 0
        music_direction = 1
        music_fade_timer = music_fade_timer_max
        menu_music:setVolume(1)
    end
end

function results_keyreleased(key, scancode, isrepeat)

end

function draw_goblet(bracket)
    love.graphics.setColor(1, 1, 1)
    -- Goblet artwork
    if bracket == "Elf-made" then
        love.graphics.draw(goblet_elf, (love.graphics.getWidth() / 2) - 28, 200)
    elseif bracket == "Decent" then
        love.graphics.draw(goblet_decent, (love.graphics.getWidth() / 2) - 28, 200)
    elseif bracket == "Fine" then
        love.graphics.draw(goblet_fine, (love.graphics.getWidth() / 2) - 28, 200)
    elseif bracket == "Exceptional" then
        love.graphics.draw(goblet_exceptional, (love.graphics.getWidth() / 2) - 28, 200)
    elseif bracket == "Masterful" then
        love.graphics.draw(goblet_masterful, (love.graphics.getWidth() / 2) - 28, 200)
    end
end

function draw_bracket(bracket)
    -- Graphics for scoring bracket
    if score >= 20 then
        love.graphics.setColor(0, 1, 0)
    else
        love.graphics.setColor(1, 0 ,0)
    end
    love.graphics.printf(bracket, love.graphics.getWidth() / 2 - 150, 150, 300, "center")
end

function draw_timer()
    -- Graphics for timer
    love.graphics.setColor(0, 1, 0)
    if timer_val > timer_positive_ceil then
        love.graphics.setColor(1, 1, 1)
    end
    if timer_val > timer_negative_floor then
        love.graphics.setColor(1, 0, 0)
    end
    love.graphics.printf(math.floor(timer_val / 60) .. ":" .. string.format("%02d", math.floor(timer_val % 60)) .. "." .. ("%03d"):format((timer_val % 1) * 1000), love.graphics.getWidth() / 2 - 50, 350, 100, "center")
end

function draw_time_bonus()
    -- Graphics for time Bonus
    love.graphics.setColor(0, 1, 0)
    if time_bonus == 0 then
        love.graphics.setColor(1, 1, 1)
    elseif time_bonus == -10 then
        love.graphics.setColor(1, 0, 0)
    end
    love.graphics.printf("Time Bonus: " .. time_bonus, love.graphics.getWidth() / 2 - 150, 370, 300, "center")
end

function results_draw()
    if results_state == 0 then
        -- Graphics for score
        -- love.graphics.setColor(1, 1, 0)
        -- love.graphics.print("Score: " .. score, 10, 130)

        draw_bracket(temp_scoring_bracket)

        draw_goblet(temp_scoring_bracket)
    elseif results_state == 1 then
        draw_bracket(temp_scoring_bracket)

        draw_timer()

        draw_time_bonus()

        draw_goblet(temp_scoring_bracket)
    elseif results_state == 2 then

        draw_timer()

        draw_time_bonus()

        draw_bracket(scoring_bracket)

        draw_goblet(scoring_bracket)

        -- Graphics for win and lose
        -- if game_active == 2 and score + time_bonus >= 20 then
        --     love.graphics.print("You Win", 10, 210)
        -- elseif game_active == 2 then
        --     love.graphics.print("You Lose", 10, 210)
        -- end

        -- Graphics for play again prompt
        if game_active == 2 then
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf("Press R to play again\nEscape to return to menu", love.graphics.getWidth() / 2 - 250, 390, 500, "center")
        end
    end

    -- Graphics for hit history
    -- love.graphics.setColor(1, 1, 1)
    -- love.graphics.print("Hammer Hit History: [" .. hammer_hit_history[1] .. "], [" .. hammer_hit_history[2] .. "], [" .. hammer_hit_history[3] .. "], [" .. hammer_hit_history[4] .. "], [" .. hammer_hit_history[5] .. "], [" .. hammer_hit_history[6] .. "], [" .. hammer_hit_history[7] .. "], [" .. hammer_hit_history[8] .. "], [" .. hammer_hit_history[9] .. "], [" .. hammer_hit_history[10] .. "]", 10, 250)
end