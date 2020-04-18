local droplet = {}

local inner_color = list(48, 176, 219, 133):map(function(v) return v / 255.0 end)
local outer_color = list(0, 51, 170, 133):map(function(v) return v / 255.0 end)
local radius = 4

function droplet.scene(world)
    local w = 1.7 * radius / math.sqrt(2)
    local body = Node.create(collision.Body, world, -w * 0.5, -w * 0.5, w, w)

    function body:on_ground_collision()
        self:destroy()
    end

    local hitbox = body:child("hitbox", collision.Hitbox, -w * 0.5, -w * 0.5, w, w, world)

    function hitbox.on_collision(col)
        if col.other.subtype == "torch" then
            body:destroy()
            gamestate:reduce_torch()
        end
    end

    function body:draw()
        gfx.setColor(unpack(inner_color))
        gfx.circle("fill", 0, 0, radius)
        gfx.setColor(unpack(outer_color))
        gfx.setLineWidth(3)
        gfx.circle("line", 0, 0, radius)
    end

    return body
end

function droplet:test()
    self:set_gravity(vec2(0, 0))
end

local droplet_master = {}

function droplet_master:create(world)
    self.world = world
end

function droplet_master.scene(world)

end

return droplet
