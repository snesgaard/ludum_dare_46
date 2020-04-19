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

return {
    scene = function(world, shape)
        return Node.create(sfx, shape)
    end
}
