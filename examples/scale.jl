using Revise, MusicTheory, MusicTheory.PitchNames
using CairoMakie, MusicMakie

function draw_scale()

    # scale = Scale(C[4], major_scale)
    scale = Scale(G[3], major_scale)

    pitches = Base.Iterators.take(scale, 2*8-1) |> collect

    # durations = repeat([1//2, 1//4, 1//4], 10)
    durations = repeat([1//4, 1//8, 1//8], 10)

    # @show durations
    notes = [Note(p, d) for (p, d) in zip(pitches, durations)]

    fig, ax = make_canvas()

    s = Stave(0, 30, 0, 0.5)

    sc = StaveWithClef(s, treble_clef)

    x0 = 3

    draw_text!(ax, s, x0, 2, "4", fontsize=1.5)
    draw_text!(ax, s, x0, -2, "4", fontsize=1.5)

    x0 += 2

    draw!(ax, sc)
    draw!(ax, sc, notes, x0=x0, w=1)

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






