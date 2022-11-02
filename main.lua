function love.load()
    love.window.setTitle("Strike While The Iron Is Hot")
    clang = love.audio.newSource("clang.wav", "static")
    badclang = love.audio.newSource("break.wav", "static")
    badclang:setVolume(0.25)
    lose = love.audio.newSource("lose.wav", "static")
    cooltime = 5
    heat = 0
    hammercooldown = 1
    hammertimer = 0
    hammerhealth = 10
    metalhealth = 50
    fuel = 50
    adown = 0
    fdown = 0
end

function love.update(dt)
    if heat ~= 0 then
        heat = heat - dt
    end
    if heat < 0 then
        heat = 0
    end

    if fdown == 1 and fuel > 0 then
        fuel = fuel - dt
    end
    if fuel < 0 then
        fuel = 0
    end
    if heat ~= 5 and fdown == 1 and fuel > 0 then
        heat = heat + dt + dt
    end

    if heat > 5 and fdown == 1 then
        heat = 5
    end
    if hammertimer ~= 0 then
        hammertimer = hammertimer - dt
    end
    if hammertimer < 0 then
        hammertimer = 0
    end
    if adown == 1 then
        swinghammer()
    end
end

function swinghammer()
    if hammertimer == 0 then
        if hammerhealth > 1 then
            hammertimer = hammercooldown
        end
        if heat > cooltime / 3 and hammerhealth > 0 then
            love.audio.stop()
            love.audio.play(clang)
            metalhealth = metalhealth -1
        else
            if hammerhealth == 1 then
                love.audio.stop()
                love.audio.play(lose)
                hammerhealth = 0
            elseif hammerhealth > 1 then
                love.audio.stop()
                love.audio.play(badclang)
                hammerhealth = hammerhealth -1
            end
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'a' then
        adown = 1
        swinghammer()
    end
    if key == 'f' then
        fdown = 1
    end
    if fuel < 0 then
        fuel = 0
    end
end

function love.keyreleased(key, scancode, isrepeat)
    if key == 'a' then
        adown = 0
    end
    if key == 'f' then
        fdown = 0
    end
end

function love.draw()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.print(hammerhealth, 0, 100)
    love.graphics.print(metalhealth, 0, 120)
    love.graphics.print(("%.3g"):format(fuel), 0, 140)
    -- TODO draw hammer
    if adown == 1 then
        love.graphics.setColor(1, 1, 1)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
    end
    love.graphics.print("a", 115, 85)

    love.graphics.setColor(1, 1, 1)
    love.graphics.arc("fill", 105, 105, 10, 0, 6 - 6 * ((hammercooldown - hammertimer) / hammercooldown), 10)

    if hammerhealth > 0 then
        love.graphics.setColor(0.5, 0.5, 0.5)
    else
        love.graphics.setColor(0.1, 0.1, 0.1)
    end
    love.graphics.rectangle("fill", 100, 100, 10, 10)

    -- TODO draw metal
    love.graphics.setColor(1 - (0.5 * ((cooltime - heat) / cooltime)), 0.25 + (0.25 * ((cooltime - heat) / cooltime)), 0 + (0.5 * ((cooltime - heat) / cooltime)))
    love.graphics.rectangle("fill", 90, 150, 30, 10)
    if heat > cooltime / 3 then
        love.graphics.setColor(1, 0.25, 0)
        love.graphics.rectangle("line", 87, 147, 36, 16)
    end
    if fdown == 1 then
        love.graphics.setColor(1, 1, 1)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
    end
    love.graphics.print("f", 125, 135)
end