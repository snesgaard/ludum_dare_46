require "nodeworks"
require "update_coroutine"
require "bumpdebug"
collision = require "collision"
level_io = require "level"
Camera = require "camera"
local control = require "gameplay.control"
gamestate = require "gameplay.gamestate"


function reload(p)
    package.loaded[p] = nil
    return require(p)
end

local test_id = "tested"

function love.load(args)
    gfx.setBackgroundColor(0, 0, 0, 0)

    scene_graph = Node.create(require "scene_graph")
    scene_graph.world = bump.newWorld(64)
    event = EventServer()
    camera = Camera.create()

    local path = args[1]

    if not path then return end

    local p = path:gsub('.lua', '')
    local Type = reload(p)

    if not Type.scene then return end
    scene_graph:init_actor(test_id, Type.scene, scene_graph.world)

    local actor = scene_graph:get_body(test_id)
    if Type.test then
        actor:fork(Type.test)
    end

    actor.transform = transform(200, 150)

    --camera.position = vec2(-200, -150)
end

function love.keypressed(...)
    event("keypressed", ...)
end

function love.update(dt)
    event("update", dt)
    scene_graph:traverse(require "scene.update", {dt = dt})
    tween.update(dt)
    event:spin()
    --camera:update(dt, scene_graph:get_body(test_id), level)
    require("lovebird").update()
end


function love.draw()
    gfx.setColor(1, 1, 1)
    local render = require "scene.render"

    render.diffuse(
        camera, nil,
        scene_graph:find("world")
    )
    --gfx.origin()
    draw_world(scene_graph.world)
end
