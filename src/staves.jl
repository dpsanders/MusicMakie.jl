
stave_color = :black

"Represents a stave (or staff) with lower left position `(x_min, y_min)` and
height `h` between each line."
struct Stave
    x_min::Float64
    x_max::Float64
    y_min::Float64
    h::Float64
end

# draw staff lines
function draw!(ax, s::Stave)

    x_min, x_max, y_min, h = s.x_min, s.x_max, s.y_min, s.h

    y = y_min

    for i in 0:4
        lines!(ax, [x_min, x_max], [y, y], color=stave_color)# , alpha=0.5)
        y += h
    end

end


"""
Position 0 is space just under stave (D in treble clef).
Position 1 is on bottom line (E in treble clef).
"""
function height(s::Stave, position)
    return (0.5 * s.h) * (position - 1)
end




function draw_text!(ax, s::Stave, x, pos, text)
    y = height(s, pos)
    text!(text, position = Point2(x, y), font = "Bravura",
        fontsize = 85.0,
        align = (:center, :center),
        color=RGBAf(0.0, 0.0, 0.0, 0.6))
end

