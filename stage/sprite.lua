require "nodeworks"
require "update_coroutine"
require "bumpdebug"
collision = require "collision"
level_io = require "level"
Camera = require "camera"
local control = require "gameplay.control"
gamestate = require "gameplay.gamestate"

function love.load()
    gfx.setBackgroundColor(0, 0, 0, 0)

    level = level_io.load(
        "art/maps/build/cave_1.lua", require "loader", gamestate.scene_graph
    )

    gamestate.scene_graph.world = level.world

    coroutine.set(
        gamestate.control_id, control.idle, gamestate.scene_graph, gamestate.player_id
    )

    camera = Camera.create()

    gamestate:set_torch_level(4)
end

function love.keypressed(...)
    event("keypressed", ...)
end

function love.update(dt)
    gamestate:update(dt)
    event("update", dt)
    gamestate.scene_graph:traverse(require "scene.update", {dt = dt})
    tween.update(dt)
    event:spin()
    camera:update(dt, gamestate.scene_graph:get_body(gamestate.player_id), level)
    require("lovebird").update()
end


function love.draw()
    gfx.setColor(1, 1, 1)
    local render = require "scene.render"

    render.fullpass(
        camera, level,
        gamestate.scene_graph:find("world")
    )
    --gfx.origin()
    --draw_world(level.world)
end
