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
    -- Difficulty
    difficulty = 2
    difficulty_values = {0.5, 1, 2}
    -- Timer
    timer_val = 0
    timer_positive_ceil = 10
    timer_negative_floor = 20
    -- Hammer
    hammer_cooldown_val = 0
    hammer_cooldown_max = 1
    hammer_cooldown_speed = 1
    hammer_held = 0
    hammer_swing_count = 10
    -- Game
    game_active = 0
    score = 0
    temp_scoring_bracket = ""
    time_bonus = 0
    scoring_bracket = ""
    -- Animation
    round_start_countdown = 4
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

    -- Graphics for timer
    love.graphics.setColor(0, 1, 0)
    if timer_val > timer_positive_ceil then
        love.graphics.setColor(1, 1, 1)
    end
    if timer_val > timer_negative_floor then
        love.graphics.setColor(1, 0, 0)
    end
    love.graphics.print("Timer: " .. math.floor(timer_val / 60) .. ":" .. string.format("%02d", math.floor(timer_val % 60)) .. "." .. ("%03d"):format((timer_val % 1) * 1000), 10, 30)

    -- Graphics for hammer cooldown
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Hammer Cooldown: " .. math.floor(hammer_cooldown_val * 10), 10, 50)

    -- Graphics for hammer swing count
    love.graphics.setColor(1, 1, 1)
    if hammer_swing_count == 0 then
        love.graphics.setColor(1, 0, 0)
    end
    love.graphics.print("Hammer Swings: " .. hammer_swing_count, 10, 70)

    -- Graphics for score
    love.graphics.setColor(1, 1, 0)
    love.graphics.print("Score: " .. score, 10, 90)

    -- Graphics for scoring bracket
    if score >= 20 then
        love.graphics.setColor(0, 1, 0)
    else
        love.graphics.setColor(1, 0 ,0)
    end
    love.graphics.print("Temporary scoring Bracket: " .. temp_scoring_bracket, 10, 110)

    -- Graphics for time Bonus
    love.graphics.setColor(0, 1, 0)
    if time_bonus == 0 then
        love.graphics.setColor(1, 1, 1)
    elseif time_bonus == -10 then
        love.graphics.setColor(1, 0, 0)
    end
    love.graphics.print("Time Bonus: " .. time_bonus, 10, 130)

    -- Graphics for scoring bracket
    if score + time_bonus >= 20 then
        love.graphics.setColor(0, 1, 0)
    else
        love.graphics.setColor(1, 0 ,0)
    end
    love.graphics.print("Scoring Bracket: " .. scoring_bracket, 10, 150)
end