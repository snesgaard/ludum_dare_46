local sfx = require "actor.vent.sfx"

local function move_filter(item, other)
    -- Ignore terrain
    if other.type ~= "body" then return end
    return "cross"
end

local function on_collision(col)
    if not col.other.velocity then return end

    col.other.velocity.y = -900
end

return function(world)
    local hitbox = Node.create(collision.Hitbox, -10, -40, 20, 40)

    hitbox.move_filter = move_filter
    hitbox.on_collision = on_collision

    local sprite = hitbox:child("sprite_thing", sfx)

    return hitbox
end
