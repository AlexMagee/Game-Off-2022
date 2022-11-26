require "hammer"

function love.load()
    love.window.setTitle("Strike While The Iron Is Hot")
    clang = love.audio.newSource("clang.wav", "static")

    -- Variables
    -- Heat
    heat_val = 0
    heat_max = 1
    heat_speed = 0.75
    heat_direction = 0
    cool_spot = 0.2
    sweet_spot_range = {cool_spot, 1}
    sweet_spot = tonumber(string.format("%.2f", love.math.random() * (sweet_spot_range[2] - sweet_spot_range[1]) + sweet_spot_range[1]))
    sweet_spot_width = 0.05
    semi_sweet_spot_width = 0.1
    -- Difficulty
    difficulty = 2
    difficulty_values = {1, 1.5, 2}
    -- Timer
    timer_val = 0
    timer_positive_ceil = 10
    timer_negative_floor = 20
    -- Hammer
    hammer_cooldown_val = 0
    hammer_cooldown_max = 0.5
    hammer_cooldown_speed = 1
    hammer_held = 0
    hammer_swing_count_max = 10
    hammer_swing_count = hammer_swing_count_max
    hammer_hit_history = {'-', '-', '-', '-', '-', '-', '-', '-', '-', '-'}
    hammer_hit_quality_timer = 0
    hammer_hit_quality_timer_max = 2
    -- Game
    game_active = 0
    score = 0
    temp_scoring_bracket = ""
    time_bonus = 0
    scoring_bracket = ""
    -- Animation
    round_start_countdown_max = 4
    round_start_countdown = round_start_countdown_max
end

function love.update(dt)
    -- Advance round start timer
    if round_start_countdown > 0 then
        round_start_countdown = round_start_countdown - dt
        if round_start_countdown < 0 then
            round_start_countdown = 0
        end
    end
    -- Check if game is inactive
    if game_active == 0 then
        -- Check if countdown has elapsed
        if round_start_countdown < 1 then
            -- Start round
            game_active = 1
        end
        return
    end
    -- Check if game is over
    if game_active == 2 then
        return
    end
    -- Advance timer
    timer_val = timer_val + dt
    -- Process heat
    if heat_direction == 0 then
        heat_val = heat_val + (heat_speed * dt * difficulty_values[difficulty])
        if heat_val > heat_max then
            heat_val = heat_max
            heat_direction = 1
        end
    elseif heat_direction == 1 then
        heat_val = heat_val - (heat_speed * dt * difficulty_values[difficulty])
        if heat_val < 0 then
            heat_val = 0
            heat_direction = 0
        end
    end
    -- Process hammer cooldown
    if hammer_cooldown_val ~= 0 then
        hammer_cooldown_val = hammer_cooldown_val - hammer_cooldown_speed * dt
        if hammer_cooldown_val < 0 then
            hammer_cooldown_val = 0
        end
    end
    -- Process hammer held
    if game_active == 1 and hammer_cooldown_val == 0 and hammer_held == 1 and hammer_swing_count > 0 then
        swingHammer()
    end
    -- Process hammer hit quality timer
    if hammer_hit_quality_timer > 0 then
        hammer_hit_quality_timer = hammer_hit_quality_timer - dt
        if hammer_hit_quality_timer < 0 then
            hammer_hit_quality_timer = 0
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'h' then
        -- Check can do hammer hit
        if hammer_cooldown_val == 0 and hammer_swing_count > 0 then
            -- Process hammer hit
            hammer_held = 1
            if game_active == 1 then
                swingHammer()
            end
        end
    end
    if game_active == 2 and key == 'r' then
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
    end
end

function love.keyreleased(key, scancode, isrepeat)
    if key == 'h' then
        hammer_held = 0
    end
end

function love.draw()
    -- Graphics for round start timer
    if round_start_countdown > 0 then
        love.graphics.setColor(round_start_countdown % 1, round_start_countdown % 1, round_start_countdown % 1);
        if round_start_countdown < 1 then
            love.graphics.print("Begin", love.graphics.getWidth() / 2 - 18, love.graphics.getHeight() / 2)
        else
            love.graphics.print(math.ceil(round_start_countdown - 1), love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
        end
    end

    -- Graphics for Heat
    love.graphics.setColor(1, 0, 0)
    love.graphics.print("Heat: " .. math.floor(heat_val * 10), 10, 10)
    -- hot area
    love.graphics.rectangle("fill", 45, 13, 100, 10)
    -- semi sweet spot area
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("fill", 45 + (sweet_spot - (sweet_spot_width / 2) - semi_sweet_spot_width) * 100, 13, (semi_sweet_spot_width * 2 + sweet_spot_width) * 100, 10)
    -- sweet spot area
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", 45 + (sweet_spot - (sweet_spot_width / 2)) * 100, 13, sweet_spot_width * 100, 10)
    -- cool area
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", 45, 13, cool_spot * 100, 10)
    -- swing marker
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(45 + heat_val * 100, 13, 45 + heat_val * 100, 23)

    -- Graphics for sweet spot
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Sweet Spot: " .. sweet_spot * 10, 10, 30)

    -- Graphics for timer
    love.graphics.setColor(0, 1, 0)
    if timer_val > timer_positive_ceil then
        love.graphics.setColor(1, 1, 1)
    end
    if timer_val > timer_negative_floor then
        love.graphics.setColor(1, 0, 0)
    end
    love.graphics.print("Timer: " .. math.floor(timer_val / 60) .. ":" .. string.format("%02d", math.floor(timer_val % 60)) .. "." .. ("%03d"):format((timer_val % 1) * 1000), 10, 50)

    -- Graphics for hammer cooldown
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Hammer Cooldown: ", 10, 70)
    if game_active == 1 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.arc("fill", 140, 80, 5, -math.pi / 2, -math.pi / 2 + 6 - 6 * ((hammer_cooldown_max - hammer_cooldown_val) / hammer_cooldown_max), 10)
    end

    -- Graphics for hammer swing count
    love.graphics.setColor(1, 1, 1)
    if hammer_swing_count == 0 then
        love.graphics.setColor(1, 0, 0)
    end
    love.graphics.print("Hammer Swings: " .. hammer_swing_count, 10, 90)

    -- Graphics for hit quality
    if hammer_hit_quality_timer ~= 0 and hammer_hit_history[hammer_swing_count_max - hammer_swing_count] == 10 then
        love.graphics.setColor(0, 1, 0)
        love.graphics.print("Hit Quality: Great", 10, 110)
    elseif hammer_hit_quality_timer ~= 0 and hammer_hit_history[hammer_swing_count_max - hammer_swing_count] == 5 then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print("Hit Quality: Good", 10, 110)
    elseif hammer_hit_quality_timer ~= 0 and hammer_hit_history[hammer_swing_count_max - hammer_swing_count] == 2 then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Hit Quality: Okay", 10, 110)
    elseif hammer_hit_quality_timer ~= 0 and hammer_hit_history[hammer_swing_count_max - hammer_swing_count] == 0 then
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.print("Hit Quality: Cold", 10, 110)
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Hit Quality:", 10, 110)
    end

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