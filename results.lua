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

end