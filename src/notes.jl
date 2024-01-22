
function draw_circle!(ax, cx, cy, r)
    θs = 0:0.1:2π
    xs = cx .+ r.*cos.(θs)
    ys = cy .+ r.*sin.(θs)

    poly!(ax, xs, ys, color=:blue)
end

function draw_ellipse!(ax, cx, cy, a, b; color=RGBAf(0, 0, 1, 0.5), filled=true)
    θs = 0:0.1:2π
    xs = cx .+ a .* cos.(θs)
    ys = cy .+ b .* sin.(θs)

    if filled
        poly!(ax, Point2.(xs, ys), color=color, alpha=0.7)
    else
        lines!(ax, xs, ys, color=color, alpha=0.7, linewidth=5)
    end
end


function draw_note_head!(ax, s::Stave, x, pos; color=RGBAf(0, 0, 1, 0.5), filled=true)
    y = height(s, pos)

    h = 0.5 * s.h
    w = 1.2 * h

    draw_ellipse!(ax, x, y, w, h; filled=filled, color=color)
end

function draw_stem_up!(ax, s::Stave, x, pos; color=RGBAf(0, 0, 1, 0.5))
    y = height(s, pos)

    h = 0.5 * s.h
    w = 1.1 * h

    lines!(ax, [x + w, x + w], [y, y + 3 * s.h], color=color, linewidth=5)
end

function draw_stem_down!(ax, s::Stave, x, pos; color=RGBAf(0, 0, 1, 0.5))
    y = height(s, pos)

    h = 0.5 * s.h
    w = 1.1 * h

    lines!(ax, [x - w, x - w], [y, y - 3 * s.h], color=color, linewidth=5)
end

# single leger line
function draw_leger_line!(ax, s::Stave, x, pos; color=RGBAf(0, 0, 1, 0.5))

    y = height(s, pos)

    h = 0.5 * s.h
    w = 1.2 * h

    r = 1.6   # leger line width ratio

    lines!(ax, [x - r * w, x + r * w], [y, y], color=stave_color)
end

function draw_leger_lines!(ax, s::Stave, x, pos; color=RGBAf(0, 0, 1, 0.5))
    for i in -6:-2:pos
        draw_leger_line!(ax, s, x, i, color=color)
    end

    for i in 6:2:pos
        draw_leger_line!(ax, s, x, i, color=color)
    end
end


function draw!(ax, s::StaveWithClef, p::Pitch, x; color=RGBAf(0, 0, 1, 0.5))
    draw!(ax, s, Note(p, 1//4), x, color=color)
end


function draw!(ax, s::StaveWithClef, n::Note, x; color=RGBAf(0, 0, 1, 0.5))
    p = n.pitch
    pos = map_to_stave(p, s.clef)

    if accidental(p) != ♮
        draw_text!(ax, s.stave, x, pos, string(accidental(p)))
        x += 1
    end

    draw_leger_lines!(ax, s.stave, x, pos, color=color)

    duration = n.duration

    filled = (duration == 1 // 4)
    draw_note_head!(ax, s.stave, x, pos, color=color, filled = filled)

    draw_stem = (duration == 1 // 2) || (duration == 1 // 4)

    if draw_stem
        if pos > 0
            draw_stem_down!(ax, s.stave, x, pos, color=color)
        else
            draw_stem_up!(ax, s.stave, x, pos, color=color)
        end
    end

    return x
end



"""Draw notes given by positions, where
0 is the space just under stave, 1 is on the bottom line, etc.

x0 is the left-most position
"""
function draw!(ax, s::StaveWithClef, notes::Vector{<:Union{Pitch, Note}}; 
    x0 = 1.0, w = 1, color = RGBAf(0, 0, 1, 0.5))

    x = x0

    total_duration = 0

    for n in notes
        x = draw!(ax, s, n, x, color=color)
        x += w

        total_duration += n.duration

        if isinteger(total_duration)
            draw_bar_line!(ax, s.stave, x)
            x += 1
        end
    end

end
