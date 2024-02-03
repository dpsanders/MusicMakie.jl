
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
    ave = sum(positions) / length(positions)

    if ave < 0
        beam_position = maximum(positions) + 3 * p.s.h
        is_up = true
    else
        beam_position = minimum(positions) - 3 * p.s.h
        is_up = false
    end

    initial_x = stem_x_pos(p.s, p.x, is_up)

    for n in p.to_beam
        pos = map_to_stave(n.pitch, p.clef)
        draw_leger_lines!(p.s, p.x, pos) #, color = colorant"red")
        draw_note_head!(p.s, p.x, pos) #, color=colorant"red")

        if is_up
            draw_stem_up!(p.s, p.x, pos, end_y = beam_position)
        else
            draw_stem_down!(p.s, p.x, pos, end_y = beam_position)
        end


        p.x += 1
        p.current_time += n.duration

    end

    final_x = stem_x_pos(p.s, p.x - 1, is_up)

    num_beams = round.(Int, log2.(denominator.(n.duration for n in p.to_beam))) .- 2
    max_num_beams = maximum(num_beams)
    # @show num_beams
    # draw beams
    for i in 1:max_num_beams
        # find start and stop locations for each beam

        start = findfirst(>=(i), num_beams)
        stop = findlast(>=(i), num_beams)

        start_x = initial_x + (start - 1)
        stop_x = initial_x + (stop - 1)

        y = is_up ? beam_position - (i - 1) * 0.3 : beam_position + (i - 1) * 0.3
        lines!(p.s.ax, [start_x, stop_x], [y, y], linewidth = 5,
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

    # draw bar line
    if p.current_time > 0 && p.current_time % p.time_signature.bar_length == 0
        draw_bar_line!(p.s, p.x)
        p.x += 0.8
    end

end
