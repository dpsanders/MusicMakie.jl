module MusicMakie

using CairoMakie
using Colors
using ColorTypes
using GeometryTypes

using CairoMakie: Point2

using MusicTheory, MusicTheory.PitchNames
using MusicTheory: tone

export Stave, Clef, TrebleClef, draw!, map_to_stave, height, make_canvas,
    draw_bar_line!, draw_text!,
    TimeSignature, Part
export make_canvas

const sharp_symbol = "♯"
const flat_symbol = "♭"


include("staves.jl")
include("clefs.jl")
include("notes.jl")
include("time_signatures.jl")
include("parts.jl")




function make_canvas()
    fig = Figure(size = (1200, 700))
    ax = fig[1,1] = Axis(fig)
    ax.aspect = DataAspect()
    hidespines!(ax)
    hidedecorations!(ax)

    return fig, ax
end



end
