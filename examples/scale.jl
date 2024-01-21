using Revise, MusicTheory, MusicTheory.PitchNames
using CairoMakie, MusicMakie

# scale = Scale(C[4], major_scale)
scale = Scale(E[3], major_scale)

pitches = Base.Iterators.take(scale, 15) |> collect


fig, ax = make_canvas()

s = Stave(0, 20, 0, 0.5)

sc = StaveWithClef(s, treble_clef)

draw!(ax, sc)


draw!(ax, sc, pitches, x0=3, w = 1.1)

fig


function scale_notes(p::Pitch)
    scale = Scale(p, natural_minor_scale)

    pitches = Base.Iterators.take(scale, 15) |> collect

    return pitches
end

scale_notes(C[4])


fig



