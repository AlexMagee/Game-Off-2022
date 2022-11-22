-- Function to swing hammer. Assumes that can hammer has been checked
function swingHammer()
    hammer_swing_count = hammer_swing_count - 1
    hammer_cooldown_val = hammer_cooldown_max
    love.audio.play(clang)

    -- Process score
    score = score + 0

    -- Check end of round
    if hammer_swing_count == 0 then
        -- Process end of round
        game_active = 2
        
        -- Calculate temp score
        if score < 20 then
            temp_scoring_bracket = "Elf-made"
        elseif score < 50 then
            temp_scoring_bracket = "Decent"
        elseif score < 70 then
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
        elseif score + time_bonus < 100 then
            scoring_bracket = "Exceptional"
        else
            scoring_bracket = "Masterful"
        end
    end
end