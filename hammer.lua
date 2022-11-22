-- Function to swing hammer. Assumes that can hammer has been checked
function swingHammer()
    hammer_swing_count = hammer_swing_count - 1
    hammer_cooldown_val = hammer_cooldown_max
    love.audio.play(clang)
    -- Process score
    score = score + 10
    -- Check end of round
    if hammer_swing_count == 0 then
        game_active = 0
        -- Process end of round
        if score < 20 then
            scoring_bracket = "Elf-made"
        elseif score < 50 then
            scoring_bracket = "Decent"
        elseif score < 70 then
            scoring_bracket = "Fine"
        elseif score < 100 then
            scoring_bracket = "Exceptional"
        else
            scoring_bracket = "Masterful"
        end
    end
end