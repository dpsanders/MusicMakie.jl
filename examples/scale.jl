using Revise, MusicTheory, MusicTheory.PitchNames
using CairoMakie, MusicMakie

function draw_scale()

    # scale = Scale(C[4], major_scale)
    scale = Scale(E[3], major_scale)

    pitches = Base.Iterators.take(scale, 2*8-1) |> collect
    notes = pitches ./ 1

    fig, ax = make_canvas()

    s = Stave(0, 30, 0, 0.5)

    sc = StaveWithClef(s, treble_clef)

    draw!(ax, sc)
    draw!(ax, sc, notes, x0=3, w = 1.1)

    @show notes

    fig
end

draw_scale()


# function scale_notes(p::Pitch)
#     scale = Scale(p, natural_minor_scale)

#     pitches = Base.Iterators.take(scale, 3*8-1) |> collect

#     return pitches
# end

# scale_notes(C[4])






