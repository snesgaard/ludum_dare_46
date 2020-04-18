require "nodeworks"
require "update_coroutine"
require "bumpdebug"
collision = require "collision"
level_io = require "level"
Camera = require "camera"
local control = require "gameplay.control"


player_id = "player_0x"
control_id = "player_control"

function love.load()
    gfx.setBackgroundColor(0, 0, 0, 0)

    level = level_io.load("art/maps/build/test.lua")

    scene_graph = Node.create(require "scene_graph")
    local player = require "actor.player"
    world = bump.newWorld(64)
    scene_graph:init_actor(player_id, player.scene, level.world)
    local player_body = scene_graph:get_body(player_id)
    player_body.transform = transform(100, 100)
    local player_sprite = scene_graph:get_sprite(player_id):queue("run")
    scene_graph:get_sprite(player_id):find("torch"):set_motion(0, 0)

    coroutine.set(control_id, control.idle, scene_graph, player_id)

    camera = Camera.create()
end

function love.keypressed(...)
    event("keypressed", ...)
end

function love.update(dt)
    event("update", dt)
    scene_graph:traverse(require "scene.update", {dt = dt})
    tween.update(dt)
    event:spin()
    require("lovebird").update()
end


function love.draw()
    gfx.setColor(1, 1, 1)
    local render = require "scene.render"

    render.fullpass(
        camera, level,
        scene_graph:find("world")
    )
    --gfx.origin()
    --draw_world(level.world)
end
