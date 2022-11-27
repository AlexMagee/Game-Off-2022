function menu_keypressed(key, scancode, isrepeat)
    if menu_state == 0 then
        if key == 'up' then
            menu_highlight = menu_highlight - 1
            if menu_highlight < 0 then
                menu_highlight = 3
            end
        end
        if key == 'down' then
            menu_highlight = menu_highlight + 1
            if menu_highlight > 3 then
                menu_highlight = 0
            end
        end
        if key == 'return' then
            clang:play()
            if menu_highlight == 0 then
                application_state = 1
                music_fade_timer = music_fade_timer_max
            elseif menu_highlight == 1 then
                menu_state = 1
            elseif menu_highlight == 2 then
                menu_state = 2
            elseif menu_highlight == 3 then
                love.event.quit(0)
            end
        end
    elseif menu_state == 1 or menu_state == 2 then
        if key == 'escape' then
            clang:play()
            menu_state = 0
        end
    end
end

function menu_draw()
    love.graphics.setFont(menu_font)
    love.graphics.setColor(1, 0, 0)
    love.graphics.printf("Strike While the Iron is Hot", (love.graphics.getWidth() / 2) - 150, 30, 300, "center")
    if menu_state == 0 then
        -- Play Game
        if menu_highlight == 0 then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(0.5, 0.5, 0.5)
        end
        love.graphics.printf("Play Game", (love.graphics.getWidth() / 2) - 150, 100, 300, "center")

        -- Instructions
        if menu_highlight == 1 then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(0.5, 0.5, 0.5)
        end
        love.graphics.printf("Instructions", (love.graphics.getWidth() / 2) - 150, 120, 300, "center")

        -- Credits
        if menu_highlight == 2 then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(0.5, 0.5, 0.5)
        end
        love.graphics.printf("Credits", (love.graphics.getWidth() / 2) - 150, 140, 300, "center")

        -- Quit
        if menu_highlight == 3 then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(0.5, 0.5, 0.5)
        end
        love.graphics.printf("Quit", (love.graphics.getWidth() / 2) - 150, 160, 300, "center")
    elseif menu_state == 1 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Welcome to Strike While the Iron is Hot.\nYou are about to become a Metalcraftdwarf completing a series of goblet work orders.\nYou will be given an anvil, a hammer, and unrestricted access to the metal bar stockpile.\n\nYour Craftsdwarfship will be judged as either Elf-made, Decent, Fine, Exceptional, or Masterful\ndepending on how well you work the iron.\nBonus points will be given for completing orders quickly. Delays will cost you.\n\nPress H to swing your hammer.\nFor best results, swing while the iron is hot.\n\n\nPress Escape to Return", 100, 100)
    elseif menu_state == 2 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Game Design by Alex Magee\nArtwork by Alex Magee\nSoundtrack by Logan Hardin\nSound Effects by Alex Magee\nSpecial thanks to Amy, Kyle, and Logan\n\n\nPress Escape to Return", 100, 100)
    end
end