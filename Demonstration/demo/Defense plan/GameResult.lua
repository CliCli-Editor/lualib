local M = {}

M.finished = false

function M.win()
    if M.finished then
        return
    end
    M.finished = true
    clicli.player(1):display_message('Win the game!')
end

function M.lose()
    if M.finished then
        return
    end
    M.finished = true
    clicli.player(1):display_message('The game has failed!')
end

return M
