local fire = {}

fire.frames = get_atlas("art/characters"):get_animation("torch_fire")

function fire:create()
    self._particles = list()
    for i, frame in ipairs(fire.frames) do
        self._particles[i] = particles{
            image=frame.image,
            quad=frame.quad,
            buffer = 20,
            rate=2,
            emit=5,
            lifetime={4.0, 6.0},
            acceleration={-2, -8, 2, -3},
            damp=0.5,
            spread=math.pi * 0.7,
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
            size={1, 1.5, 3},
        }
    end

    self.transform = transform(0, 0)
end

function fire:set_level(level)
    self._level = level
end

function fire:activate()
    self._active = true
end

function fire:update(dt)
    if not self._active then return end
    for _, p in ipairs(self._particles) do p:update(dt * 6) end
end

function fire:draw()
    gfx.setColor(1, 1, 1)
    gfx.setBlendMode("add")
    for _, p in ipairs(self._particles) do
        gfx.draw(p, 0, 0)
    end
    gfx.setBlendMode("alpha")
end

function fire:glow()
    for _, p in ipairs(self._particles) do
        gfx.draw(p, 0, 0)
    end
end


function fire:light(mesh)
    if not self._active then return end
    local r = 200
    gfx.setColor(1.0, 0.9, 0.6)
    gfx.draw(mesh, -r, -r, 0, r * 2, r * 2)
end

function fire:reshape(shape)
    local density = 0.04
    local area = shape.w * shape.h
    local buffer = math.ceil(area * density)
    local rate = buffer * 0.5
    for _, p in ipairs(self._particles) do
        p:setEmissionArea("uniform", shape.w * 0.5, shape.h * 0.5)
        p:setEmissionRate(rate)
        p:setBufferSize(buffer)
    end

    self.transform.position = shape:center()
end

function fire:test()
    self:reshape(spatial(0, 0, 50, 50))
end

return fire
