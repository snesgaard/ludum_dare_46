local control = require "gameplay.control"
local sfx = require "actor.vent.sfx"

local function move_filter(item, other)
    -- Ignore terrain
    if other.type ~= "body" then return end
    return "cross"
end

local function on_collision(col)
    if not col.other.velocity then return end

    if col.other.id ~= gamestate.player_id then return end
    coroutine.set(
        gamestate.control_id, control.constant_motion, gamestate.scene_graph,
        gamestate.player_id, {velocity = vec2(600, 0), sleep=0.3}
    )
end

return {
    scene = function(world)
        local hitbox = Node.create(collision.Hitbox, 0, -10, 40, 20)

        hitbox.move_filter = move_filter
        hitbox.on_collision = on_collision

        local sprite = hitbox:child("sprite_thing", sfx)
        sprite.transform = transform(0, 0, math.pi * 0.5)

        return hitbox
    end,
    align = "leftcenter"
}
