local sfx = {}

function sfx:create(shape)
    self._shape = shape:relative()
    self.color = {1, 1, 1}
end

function sfx:draw()
    gfx.rectangle("fill", self._shape:unpack())
end

function sfx:glow()
    gfx.setColor(1, 1, 1)
    gfx.rectangle("fill", self._shape:unpack())
end

local function move_filter(item, other)
    -- Ignore terrain
    if other.type ~= "body" then return end
    return "cross"
end

local function on_collision(col)
    if col.other.id == gamestate.player_id then
        gamestate:stop()
    end
end


return {
    scene = function(world, shape)
        local hitbox = Node.create(
            collision.Hitbox, shape:relative():unpack()
        )

        hitbox.move_filter = move_filter
        hitbox.on_collision = on_collision

        hitbox:child("sfx", sfx, shape)

        return hitbox
    end
}
