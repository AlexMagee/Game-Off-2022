-- Function to swing hammer. Assumes that can hammer has been checked
function swingHammer()
    hammer_swing_count = hammer_swing_count - 1
    hammer_cooldown_val = hammer_cooldown_max
    love.audio.play(clang)
    -- Process score
    score = score + 0
    -- Process potential end of round
    if hammer_swing_count == 0 then
        game_active = 0
    end
end