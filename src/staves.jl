
stave_color = :black

"""
    struct Stave

Represents a stave (or staff) with left position `x_min` and
height `h` between each line.
`y` is the y position of the center line.
"""
struct Stave
    ax::Axis
    x_min::Float64
    x_max::Float64
    y::Float64
    h::Float64
end

# draw staff lines
function draw!(s::Stave)

    x_min, x_max, h = s.x_min, s.x_max, s.h

    for y in -2h:h:2h
        lines!(s.ax, [x_min, x_max], [s.y + y, s.y + y], color=stave_color)# , alpha=0.5)
    end

end


"""
Position 0 is center line.
Position 1 is the space above it.
"""
height(s::Stave, position) = position * 0.5 * s.h


function draw_text!(s::Stave, x, pos, text; fontsize=2.0, color = default_color)
    y = height(s, pos)
    text!(text, position = Point2(x, s.y + y), font = "Bravura",
        # fontsize = 85.0,
        fontsize = fontsize,
        markerspace = :data,
        align = (:center, :center),
        color = color)
end


function draw_bar_line!(s::Stave, x)

    lines!(s.ax, [x, x], [s.y - 2*s.h, s.y + 2*s.h], color = stave_color)
    x += 0.7

    return x
end