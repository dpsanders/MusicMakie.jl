
mutable struct Part
    clef::Clef
    time_signature::TimeSignature
    current_time::Rational{Int}
    x::Float64   # current x position
    s::Stave
    to_beam::Vector{Note}
end

function Part(ax)
    clef = TrebleClef()
    time_signature = TimeSignature(4, 4)
    s = Stave(ax, 0, 30, 0, 0.5)
    draw!(s)
    return Part(clef, time_signature, 0, 0.0, s, [])
end

function Base.push!(p::Part, c::Clef)
    p.clef = c
    p.x = draw!(p.s, c, p.x)
end

function Base.push!(p::Part, sig::TimeSignature)
    p.time_signature = sig
    p.x = draw!(p.s, sig, p.x)
end

function draw_beam!(p::Part)
    positions = [height(p.s, map_to_stave(n.pitch, p.clef)) for n in p.to_beam]
    # ave = sum(positions) / length(positions)
@show positions
    beam_position = maximum(positions) + 2.5 * p.s.h

    initial_x = p.x

    for n in p.to_beam
        pos = map_to_stave(n.pitch, p.clef)
        draw_leger_lines!(p.s, p.x, pos, color = colorant"red")
        draw_note_head!(p.s, p.x, pos, color=colorant"red")
        draw_stem_up!(p.s, p.x, pos, end_y = beam_position)

        p.x += 1
        p.current_time += n.duration

    end

    final_x = p.x - 1 + 0.5

    num_flags = round(Int, log2(denominator(p.to_beam[1].duration))) - 2

    # draw beams
    for i in 0:(num_flags - 1)
        y = beam_position - i * 0.5
        lines!(p.s.ax, [initial_x, final_x], [y, y], linewidth = 5,
        color = default_color)
    end

end


function draw_beamed!(p::Part)
    @show p.to_beam
    if length(p.to_beam) == 1
        n = only(p.to_beam)
        p.x = draw!(p.s, n, p.clef, p.x)
        p.current_time += n.duration
    else
        # for n in p.to_beam
        #     p.x = draw!(p.s, n, p.clef, p.x, color = colorant"red")
        #     p.current_time += n.duration
        # end

        draw_beam!(p)
    end
end


function Base.push!(p::Part, obj::Note)

    if denominator(obj.duration) > 4
        if isempty(p.to_beam) || obj.duration == p.to_beam[end].duration
            push!(p.to_beam, obj)

        else # end of beam
            draw_beamed!(p)
            p.to_beam = [obj]
        end

    else

        if !isempty(p.to_beam)
            draw_beamed!(p)
            p.to_beam = []
        end

        p.x = draw!(p.s, obj, p.clef, p.x)
        p.current_time += obj.duration

    end

    if p.current_time > 0 && p.current_time % p.time_signature.bar_length == 0
        draw_bar_line!(p.s, p.x)
        p.x += 0.8
    end

end
