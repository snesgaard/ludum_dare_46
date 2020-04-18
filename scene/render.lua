local render = {}

local stack_op = {
    color = gfx.setColor,
    blend = gfx.setBlendMode,
    transform = function(t)
        if t.position then
            gfx.translate(t.position.x, t.position.y)
        end
        if t.angle then
            gfx.rotate(t.angle)
        end
        if t.scale then
            gfx.scale(t.scale.x, t.scale.y)
        end
    end
}

function render.enter(node)
    gfx.push("all")

    for key, op in pairs(stack_op) do
        local data = node[key]
        if data then op(data) end
    end
end

function render.exit(node, info)
    if node.post_draw then node:post_draw() end
    gfx.pop("all")
end

function render.visit(node, args)
    local draw = node[args.func or "draw"]
    if draw then draw(node) end

    if args.draw_frame then
        gfx.push("all")
        gfx.setLineWidth(2)
        gfx.setColor(0.2, 1.0, 0.3)
        gfx.line(0, -5, 0, 20)
        gfx.setColor(1.0, 0.3, 0.2)
        gfx.line(-5, 0, 20, 0)
        gfx.pop("all")
    end
end

render.glow_blur = moon(moon.effects.gaussianblur)
render.glow_blur.gaussianblur.sigma = 12.0

render.buffer = love.graphics.newCanvas(gfx.getWidth(), gfx.getHeight())

local light = {}

light.light_fragment = [[
    uniform Image diffuse;
    uniform int width;
    uniform int height;
    uniform float offset;

    vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
    {
        vec2 screen_uv = screen_coords / vec2(width, height);
        vec4 screen_color = Texel(diffuse, screen_uv);
        float dist = length(texture_coords - vec2(0.5)) + offset;
        float radius = 0.5;
        //float att = clamp(1.0 - dist*dist/(radius*radius), 0.0, 1.0); att *= att;

        float att = 1.0;
        att = dist <= radius * 0.60 ? att: att * 0.5;
        att = dist <= radius * 0.80 ? att: att * 0.5;
        att = dist <= radius ? att : 0.0;
        

        return color * screen_color * vec4(vec3(1.0), att);
    }
]]
light.light_shader = gfx.newShader(light.light_fragment)
light.mesh = gfx.newMesh({
    {0, 1, 0, 1},
    {1, 1, 1, 1},
    {1, 0, 1, 0},
    {0, 0, 0, 0},
})

light.stack_op = {
    transform = function(t)
        if t.position then
            gfx.translate(t.position.x, t.position.y)
        end
        if t.angle then
            gfx.rotate(t.angle)
        end
        if t.scale then
            gfx.scale(t.scale.x, t.scale.y)
        end
    end
}

function light.enter(node)
    gfx.push()

    for key, op in pairs(light.stack_op) do
        local data = node[key]
        if data then op(data) end
    end
end

function light.visit(node, args)
    if node.light then
        node:light(light.mesh)
    end
end

function light.exit(node, info)
    if node.post_draw then node:post_draw() end
    gfx.pop()
end

function render.diffuse(camera, level, scenegraph)
    if level then
        level:draw(camera:get_transform())
    end
    camera:transform()
    scenegraph:traverse(render, {draw_frame=false})
end

function render.fullpass(camera, level, scenegraph, settings)
    settings = settings or {}

    gfx.setCanvas(render.buffer)
    if level then
        level:draw(camera:get_transform())
    end
    camera:transform()

    scenegraph:traverse(render, {draw_frame=false})

    gfx.push()
    gfx.setCanvas()

    light.light_shader:send("diffuse", render.buffer)
    light.light_shader:send("width", gfx.getWidth())
    light.light_shader:send("height", gfx.getHeight())
    light.light_shader:send("offset", math.sin(love.timer.getTime() * 20) * 0.005)

    gfx.setShader(light.light_shader)

    gfx.setColor(1, 1, 1)
    scenegraph:traverse(light)

    gfx.setShader()
    gfx.pop()
    if not settings.disable_glow then
        gfx.setBlendMode("add")
        render.glow_blur(function()
            scenegraph:traverse(render, {draw_frame=false, func="glow"})
        end)
        gfx.setBlendMode("alpha")
    end
end

return render
