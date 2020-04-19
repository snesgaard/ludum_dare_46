local sfx = {}

sfx.width = 14
sfx.height = 20

sfx.image = gfx.prerender(sfx.width, sfx.height, function(w, h)
    gfx.push('all')
    gfx.origin()
    gfx.setColor(1, 1, 1)
    local x, y = w / 2.0, h / 2.0
    gfx.ellipse("fill", x, y, x, y)
    gfx.pop()
end)

function sfx:create()
    self._particles = particles{
        image=self.image,
        buffer=10,
        rate=3,
        lifetime=1.0,
        size={0.5, 3},
        color={
            1, 1, 1, 1,
            1, 1, 1, 0
        },
        offset={sfx.width * 0.5, sfx.height}
    }
end

function sfx:update(dt)
    self._particles:update(dt * 3)
end

function sfx:draw()
    gfx.draw(self._particles, 0, 0)
end

return sfx
