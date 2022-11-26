require "hammer"
require "game"

function love.load()
    love.window.setTitle("Strike While The Iron Is Hot")
    clang = love.audio.newSource("clang.wav", "static")
    menu_music = love.audio.newSource("giant_cave_toad.mp3", "static")
    love.audio.play(menu_music)

    application_state = 0

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
    if application_state == 1 then
        game_update(dt)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if application_state == 0 then
        if key == 's' then
            application_state = 1
        end
    elseif application_state == 1 then
        game_keypressed(key, scancode, isrepeat)
    end
end

function love.keyreleased(key, scancode, isrepeat)
    if application_state == 1 then
        game_keyreleased(key, scancode, isrepeat)
    end
end

function love.draw()
    if application_state == 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Welcome to Strike While the Iron is Hot.\nYou are about to become a Metalcraftdwarf completing a series of goblet work orders.\nYou will be given an anvil, a hammer, and unrestricted access to the metal bar stockpile.\n\nPress H to swing your hammer.\nFor best results, swing while the iron is hot.\nPress S to start", 100, 100)
    elseif application_state == 1 then
        game_draw()
    end
end