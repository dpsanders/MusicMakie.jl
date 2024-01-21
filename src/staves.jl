
stave_color = :black

"""
    struct Stave

Represents a stave (or staff) with left position `x_min` and
height `h` between each line.
`y` is the y position of the center line.
"""
struct Stave
    x_min::Float64
    x_max::Float64
    y::Float64
    h::Float64
end

# draw staff lines
function draw!(ax, s::Stave)

    x_min, x_max, h = s.x_min, s.x_max, s.h

    for y in -2h:h:2h
        lines!(ax, [x_min, x_max], [s.y + y, s.y + y], color=stave_color)# , alpha=0.5)
    end

end


"""
Position 0 is center line.
Position 1 is the space above it.
"""
height(s::Stave, position) = position * 0.5 * s.h


function draw_text!(ax, s::Stave, x, pos, text)
    y = height(s, pos)
    text!(text, position = Point2(x, s.y + y), font = "Bravura",
        fontsize = 85.0,
        align = (:center, :center),
        color=RGBAf(0.0, 0.0, 0.0, 0.6))
end

