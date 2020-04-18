local water = {}

function water:create(shape)
    self:reshape(shape)
    self.transform = transform(0, 0)
end


function water:reshape(shape)
    self._shape = shape
    local hitbox = self:child("hitbox", require "collision.hitbox", shape:unpack())
    hitbox.transform = transform(0, 5)

    function hitbox.on_collision(col)
        if col.other.subtype ~= "torch" then return end
        gamestate:kill_player()
    end
end

function water:draw()
    if not self._shape then return end
    gfx.setColor(0.2, 0.5, 0.8, 0.4)
    gfx.rectangle("fill", self._shape:unpack())
end

function water:test()
    self:reshape(spatial(0, 0, 100, 300))
end

function water.scene(shape)
    return Node.create(water, shape)
end

return water
