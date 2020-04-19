local sfx = require "actor.vent.sfx"

local function move_filter(item, other)
    -- Ignore terrain
    if other.type ~= "body" then return end
    return "cross"
end

local function on_collision(col)
    if not col.other.velocity then return end

    col.other.velocity.y = 900
end

return {
    scene = function(world)
        local node = Node.create(sfx)
        node.transform = transform(0, 0, 0, 1, -1)

        local hitbox = node:child("hitbox", collision.Hitbox, -10, -40, 20, 40)
        hitbox.move_filter = move_filter
        hitbox.on_collision = on_collision

        return node
    end,
    align = "centertop"
}
