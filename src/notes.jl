
const default_color = RGBAf(0, 0, 1, 0.7)

# function draw_circle!(cx, cy, r)
#     θs = 0:0.1:2π
#     xs = cx .+ r.*cos.(θs)
#     ys = cy .+ r.*sin.(θs)

#     poly!(xs, ys, color=:blue)
# end

function draw_ellipse!(s::Stave, cx, cy, a, b; color = default_color, filled=true)
    θs = 0:0.1:2π
    xs = cx .+ a .* cos.(θs)
    ys = cy .+ b .* sin.(θs)

    if filled
        poly!(s.ax, Point2.(xs, ys), color=color, alpha=0.7)
    else
        lines!(s.ax, xs, ys, color=color, alpha=0.7, linewidth=5)
    end
end


function draw_note_head!(s::Stave, x, pos; color = default_color, filled=true)
    y = height(s, pos)

    h = 0.5 * s.h
    w = 1.2 * h

    draw_ellipse!(s, x, y, w, h; filled=filled, color=color)
end

# l is the length of the stem in multiples of the stave gap
function draw_stem_up!(s::Stave, x, pos; l = 3.5, color = default_color)
    y = height(s, pos)
    h = 0.5 * s.h
    w = 1.1 * h

    lines!(s.ax, [x + w, x + w], [y, y + l * s.h], color=color, linewidth=5)
end

function draw_flag_down!(s::Stave, x, pos; l = 3.5, color = default_color)
    y = height(s, pos)
    h = 0.5 * s.h
    w = 1.1 * h

    d = 0.8  # distance to draw flag out

    lines!(s.ax,
        [x + w, x + w + (d * s.h)],
        [y + l * s.h, y + (l - d) * s.h],
        color = color,
        linewidth=3)
end

function draw_stem_down!(s::Stave, x, pos; l = 3.5, color = default_color)
    y = height(s, pos)
    h = 0.5 * s.h
    w = 1.1 * h

    lines!(s.ax, [x - w, x - w], [y, y - l * s.h], color = color, linewidth=5)
end

function draw_flag_up!(s::Stave, x, pos; l = 3.5, color = default_color)
    y = height(s, pos)
    h = 0.5 * s.h
    w = 1.1 * h

    d = 0.8  # distance to draw flag out

    lines!(s.ax,
        [x - w, x - w + (d * s.h)],
        [y - l * s.h, y - (l - d) * s.h],
        color = color,
        linewidth=3)
end



# single leger line
function draw_leger_line!(s::Stave, x, pos; color = default_color)

    y = height(s, pos)

    h = 0.5 * s.h
    w = 1.2 * h

    r = 1.6   # leger line width ratio

    lines!(s.ax, [x - r * w, x + r * w], [y, y], color=stave_color)
end

function draw_leger_lines!(s::Stave, x, pos; color = default_color)
    for i in -6:-2:pos
        draw_leger_line!(s, x, i, color = color)
    end

    for i in 6:2:pos
        draw_leger_line!(s, x, i, color = color)
    end
end

## draw n flags
function draw_flags_up!(s::Stave, x, pos, n; color = default_color)

    for i in 1:n
        draw_flag_up!(s, x, pos + i, color = color)
    end
end

function draw_flags_down!(s::Stave, x, pos, n; color = default_color)

    for i in 1:n
        draw_flag_down!(s, x, pos - i, color = color)
    end
end



function draw!(s::Stave, p::Pitch, x; color = default_color)
    draw!(s, Note(p, 1//4), x, color=color)
end


function draw!(s::Stave, n::Note, c::Clef, x; color = default_color)
    p = n.pitch
    pos = map_to_stave(p, c)

    if accidental(p) != ♮
        draw_text!(s, x, pos, string(accidental(p)), color = default_color)
        x += 0.7
    end

    draw_leger_lines!(s, x, pos, color = color)

    duration = n.duration

    filled = (duration <= 1 // 4)
    draw_note_head!(s, x, pos, color=color, filled = filled)

    draw_stem = (duration < 1)

    num_flags = round(Int, log2(denominator(duration))) - 2

    if draw_stem
        if pos > 0
            draw_stem_down!(s, x, pos, color=color)
            draw_flags_up!(s, x, pos, num_flags, color=color)
        else
            draw_stem_up!(s, x, pos, color=color)
            draw_flags_down!(s, x, pos, num_flags, color=color)
        end

        if num_flags > 0
            x += 0.2
        end
    end

    return x
end



"""Draw notes given by positions, where
0 is the space just under stave, 1 is on the bottom line, etc.

x0 is the left-most position
"""
function draw!(s::Stave, c::Clef, notes::Vector{<:Union{Pitch, Note}};
    x = 1.0, w = 1, color = RGBAf(0, 0, 1, 0.5))

    total_duration = 0

    for n in notes
        x = draw!(s, n, c, x, color=color)
        x += w

        total_duration += n.duration

        if isinteger(total_duration)  # whole number of bars, assuming 4/4 time
            x = draw_bar_line!(s, x)
        end
    end

    return x

end
