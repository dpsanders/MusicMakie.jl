
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

function stem_x_pos(s::Stave, x, is_up::Bool) 
    h = 0.5 * s.h
    w = 1.2 * h

    if is_up
        return x + w
    else
        return x - w
    end
end

# l is the length of the stem in multiples of the stave gap
function draw_stem_up!(s::Stave, x, pos; end_y = nothing, color = default_color)

    l = 3.5  # default length = 1 octave

    y = height(s, pos)
    h = 0.5 * s.h
    w = 1.1 * h

    if isnothing(end_y)
        end_y = y + l * s.h
        # stems shouldn't end below the midline
        end_y < s.y && (end_y = s.y)
    end

    lines!(s.ax, [x + w, x + w], [y, end_y], color=color, linewidth=5)

    return end_y
end

function draw_stem_down!(s::Stave, x, pos; end_y = nothing, color = default_color)

    l = 3.5  # default length = 1 octave

    y = height(s, pos)
    h = 0.5 * s.h
    w = 1.1 * h
     # stems shouldn't end above the midline

    if isnothing(end_y)
        end_y = y - l * s.h
        end_y > s.y && (end_y = s.y)
    end

    lines!(s.ax, [x - w, x - w], [y, end_y], color = color, linewidth=5)

    return end_y
end

function draw_flag_down!(s::Stave, x, pos, start; color = default_color)
    y = height(s, pos)
    h = 0.5 * s.h
    w = 1.1 * h

    d = 0.8  # distance to draw flag out

    lines!(s.ax,
        [x + w, x + w + (d * s.h)],
        [start, start - (d * s.h)],
        color = color,
        linewidth=3)
end

function draw_flag_up!(s::Stave, x, pos, start; color = default_color)
    y = height(s, pos)
    h = 0.5 * s.h
    w = 1.1 * h

    d = 0.8  # distance to draw flag out

    lines!(s.ax,
        [x - w, x - w + (d * s.h)],
        [start, start + (d * s.h)],
        color = color,
        linewidth=3)
end

## draw n flags
function draw_flags_up!(s::Stave, x, pos, n, start; color = default_color)

    for i in 1:n
        draw_flag_up!(s, x, pos + i, start + i/3, color = color)
    end
end

function draw_flags_down!(s::Stave, x, pos, n, start; color = default_color)

    for i in 1:n
        draw_flag_down!(s, x, pos - i, start - i/3, color = color)
    end
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





function draw!(s::Stave, p::Pitch, x; color = default_color)
    draw!(s, Note(p, 1//4), x, color=color)
end


function draw!(s::Stave, n::Note, c::Clef, x; color = default_color)
    p = n.pitch
    pos = map_to_stave(p, c)

    if accidental(p) != ♮
        draw_text!(s, x, pos, string(accidental(p)), color = color)
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
            # start is height at which stem starts / ends
            start = draw_stem_down!(s, x, pos, color=color)
            draw_flags_up!(s, x, pos, num_flags, start, color=color)
        else
            start = draw_stem_up!(s, x, pos, color=color)
            draw_flags_down!(s, x, pos, num_flags, start, color=color)
        end

        if num_flags > 0
            x += 0.2
        end
    end

    x += 1

    return x
end

# struct KeySignature
#     accidentals::Dict{PitchClass, Accidental}
# end

# # no accidental if the pitch class is the same as in the key signature
# struct NoteHead
#     pos::Int
#     accidental::Union{Nothing,Accidental}
#     x::Float64
# end

# # assume stems are vertical
# struct Stem
#     is_up::Bool
#     start::Int
#     end::Int
#     x::Float64
# end