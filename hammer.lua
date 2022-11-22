-- Function to swing hammer. Assumes that can hammer has been checked
function swingHammer()
    hammer_cooldown_val = hammer_cooldown_max
    love.audio.play(clang)
end