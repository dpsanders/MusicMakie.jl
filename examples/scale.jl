using Revise, MusicTheory, MusicTheory.PitchNames
using CairoMakie
using MusicMakie

    

function draw_scale()

    # scale = Scale(C[4], major_scale)
    scale = Scale(G[3], major_scale)

    pitches = Base.Iterators.take(scale, 2*8-1) |> collect

    # durations = repeat([1//2, 1//4, 1//4], 10)
    durations = repeat([1//4, 1//8, 1//8], 10)
    # durations = repeat([1//8, 1//16, 1//16], 10)

    # @show durations
    notes = [Note(p, d) for (p, d) in zip(pitches, durations)]

    fig, ax = make_canvas()

    s = Stave(ax, 0, 30, 0, 0.5)
    draw!(s)

    clef = treble_clef

    x = 1
    x = draw!(s, clef, x)

    time_signature = TimeSignature(4, 4)
    x = draw!(s, time_signature, x)

    draw!(s, clef, notes, x = x, w = 1)

    # @show notes

    fig
end

draw_scale()


# function scale_notes(p::Pitch)
#     scale = Scale(p, natural_minor_scale)

#     pitches = Base.Iterators.take(scale, 3*8-1) |> collect

#     return pitches
# end

# scale_notes(C[4])






