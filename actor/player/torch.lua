local torch = {}

torch.frames = get_atlas("art/characters"):get_animation("torch_fire")

function torch:create()
    self._particles = list()

    for i, frame in ipairs(torch.frames) do
        self._particles[i] = particles{
            image=frame.image,
            quad=frame.quad,
            buffer = 20,
            rate=2,
            emit=5,
            lifetime={4.0, 6.0},
            acceleration={0, -3},
            damp=0.5,
            spread=math.pi * 0.6,
            dir=-math.pi * 0.5,
            speed={3, 6},
            color=List.concat(
                vec4(0.1, 0.1, 0.9, 0.0),
                vec4(0.3, 0.3, 0.4, 0.6),
                vec4(1.0, 0.7, 0.14, 0.6),
                vec4(0.9, 0.1, 0.05, 0.3),
                vec4(1.0, 0, 0, 0.0)
            ),
            offset={frame.offset.x, frame.offset.y},
            area={"uniform", 1, 1},
            size={1, 1.5},
        }
    end

    self._radius = 250
end

function torch:update(dt)
    for _, p in ipairs(self._particles) do p:update(dt * 6) end
end

function torch:set_motion(dx, dy)
    local amp_x = 5
    local ax, ay = 0, -3
    if dx > 0 then
        ax = -amp_x
    elseif dx < 0 then
        ax = amp_x
    end

    if dy > 0 then
        ay = 3
    end

    for _, p in ipairs(self._particles) do
        p:setLinearAcceleration(ax, ay, ax + 0.5, ay + 0.5)
    end
end

function torch:reshape(shape)
    self.transform = transform(shape.x, shape.y)
    self._shape = spatial(0, 0, shape.w, shape.h)
end

function torch:draw()
    if not self._shape then return end
    gfx.setColor(1, 1, 1)
    gfx.setBlendMode("add")
    --gfx.rectangle("fill", self._shape:unpack())
    for _, p in ipairs(self._particles) do
        gfx.draw(p, 0, 0)
    end
    gfx.setBlendMode("alpha")
end

function torch:glow()
    for _, p in ipairs(self._particles) do
        gfx.draw(p, 0, 0)
    end
end

function torch:light(mesh)
    local r = self._radius
    gfx.setColor(1.0, 0.9, 0.6)
    gfx.draw(mesh, -r, -r, 0, r * 2, r * 2)
end

function torch:test()
    self:reshape(spatial(0, 0, 10, 10))
    self:set_motion(1, -1)
end

return torch
