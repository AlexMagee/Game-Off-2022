require "hammer"
require "game"
require "menu"

function love.load()
    love.window.setTitle("Strike While The Iron Is Hot")
    clang = love.audio.newSource("clang.wav", "static")
    menu_music = love.audio.newSource("giant_cave_toad.mp3", "static")
    game_music = love.audio.newSource("the_bearded_bastard.mp3", "static")
    love.audio.play(menu_music)

    meter_frame = love.graphics.newImage("gui/meter.png")
    marker_frame = love.graphics.newImage("gui/marker.png")
    quality_frame = love.graphics.newImage("gui/quality.png")

    anvil = love.graphics.newImage("gui/anvil.png")
    iron = love.graphics.newImage("gui/iron.png")
    hammer_up = love.graphics.newImage("gui/hammer_up.png")
    hammer_down = love.graphics.newImage("gui/hammer_down.png")

    menu_font = love.graphics.newFont(12)

    application_state = 0
    music_fade_timer_max = 1
    music_fade_timer = 0

    -- Menu Variables
    menu_highlight = 0
    menu_state = 0

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
    if application_state == 0 then
        
    elseif application_state == 1 then
        game_update(dt)
    end
    if music_fade_timer ~= 0 then
        music_fade_timer = music_fade_timer - dt
        if music_fade_timer < 0 then
            music_fade_timer = 0
            love.audio.stop(menu_music)
            game_music:setLooping(true)
            love.audio.play(game_music)
        end
        menu_music:setVolume(music_fade_timer)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if application_state == 0 then
        menu_keypressed(key, scancode, isrepeat)        
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
        love.graphics.setFont(menu_font)
        menu_draw()
    elseif application_state == 1 then
        -- Art Assets
        love.graphics.draw(quality_frame, 495, 107)
        love.graphics.draw(meter_frame, 255, 107)
        love.graphics.draw(anvil, 287, 186)
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.draw(iron, 287, 186)

        game_draw()
    end
end