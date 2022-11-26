-- Function to swing hammer. Assumes that can hammer has been checked
function swingHammer()
    hammer_swing_count = hammer_swing_count - 1
    hammer_cooldown_val = hammer_cooldown_max
    love.audio.play(clang)

    -- Process score
    temp_score = 0
    if heat_val > sweet_spot - (sweet_spot_width / 2) and heat_val < sweet_spot + (sweet_spot_width / 2) then
        temp_score = 10
    elseif heat_val > cool_spot and heat_val > sweet_spot - (sweet_spot_width / 2) - semi_sweet_spot_width and heat_val < sweet_spot + (sweet_spot_width / 2) + semi_sweet_spot_width then
        temp_score = 5
    elseif heat_val > cool_spot then
        temp_score = 2
    else
        temp_score = 0
    end
    score = score + temp_score

    -- Store hammer hit history
    hammer_hit_history[hammer_swing_count_max - hammer_swing_count] = temp_score

    -- Reset hammer hit timer quality
    hammer_hit_quality_timer = hammer_hit_quality_timer_max

    -- Process sweet spot
    sweet_spot = tonumber(string.format("%.2f", love.math.random() * (sweet_spot_range[2] - sweet_spot_range[1]) + sweet_spot_range[1]))

    -- Check end of round
    if hammer_swing_count == 0 then
        -- Process end of round
        game_active = 2
        
        -- Calculate temp score
        if score < 30 then
            temp_scoring_bracket = "Elf-made"
        elseif score < 50 then
            temp_scoring_bracket = "Decent"
        elseif score < 75 then
            temp_scoring_bracket = "Fine"
        elseif score < 100 then
            temp_scoring_bracket = "Exceptional"
        else
            temp_scoring_bracket = "Masterful"
        end

        -- Calculate time bonus
        if timer_val < timer_positive_ceil then
            time_bonus = 10
        elseif timer_val > timer_negative_floor then
            time_bonus = -10
        end

        -- Calculate final score
        if score + time_bonus < 20 then
            scoring_bracket = "Elf-made"
        elseif score + time_bonus < 50 then
            scoring_bracket = "Decent"
        elseif score + time_bonus < 70 then
            scoring_bracket = "Fine"
        elseif score + time_bonus < 100 or (score ~= 100 and score + time_bonus >= 100) then
            scoring_bracket = "Exceptional"
        else
            scoring_bracket = "Masterful"
        end
    end
end