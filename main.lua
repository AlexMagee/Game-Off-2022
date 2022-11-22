function love.load()
    love.window.setTitle("Strike While The Iron Is Hot")
    clang = love.audio.newSource("clang.wav", "static")

    -- Variables
    -- Heat
    heat_val = 0
    heat_max = 1
    heat_speed = 0.75
    heat_direction = 0
end

function love.update(dt)
    if heat_direction == 0 then
        heat_val = heat_val + (heat_speed * dt)
        if heat_val > heat_max then
            heat_val = heat_max
            heat_direction = 1
        end
    elseif heat_direction == 1 then
        heat_val = heat_val - (heat_speed * dt)
        if heat_val < 0 then
            heat_val = 0
            heat_direction = 0
        end
    end
end

function love.keypressed(key, scancode, isrepeat)

end

function love.keyreleased(key, scancode, isrepeat)

end

function love.draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.print(heat_val, 100, 100)
end