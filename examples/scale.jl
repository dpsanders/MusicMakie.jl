using Revise, MusicTheory, MusicTheory.PitchNames
using CairoMakie
using MusicMakie

import MusicMakie.draw!



function draw_scale()

    # scale = Scale(C[4], major_scale)
    scale = Scale(A[3], major_scale)
    pitches = Base.Iterators.take(scale, 2*8-1) |> collect

    # durations = repeat([1//2, 1//4, 1//4], 10)
    # durations = repeat([1//4, 1//8, 1//8, 1//8, 1//8], 10)
    durations = 1 .// repeat([8, 16, 16, 16, 16, 16, 16], 10)

    # @show durations
    notes = [Note(p, d) for (p, d) in zip(pitches, durations)]

    setup = [TrebleClef(), TimeSignature(4, 4)]

    fig, ax = make_canvas()
    p = Part(ax)

    for obj in setup
        push!(p, obj)
    end

    for obj in notes
        push!(p, obj)
    end

    fig
end

draw_scale()


# function scale_notes(p::Pitch)
#     scale = Scale(p, natural_minor_scale)

#     pitches = Base.Iterators.take(scale, 3*8-1) |> collect

#     return pitches
# end

# scale_notes(C[4])






