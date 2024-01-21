

struct Clef
    symbol::String
    position::Int
    pitch::Pitch
end

const G_clef_symbol = string(Char('\U1D11E'))
const treble_clef = Clef(G_clef_symbol, -2, G[4])


function map_to_stave(p::Pitch, clef::Clef = treble_clef)
    return tone(p) - tone(clef.pitch) + clef.position
end


struct StaveWithClef
    stave::Stave
    clef::Clef
end


function draw!(ax, s, c::Clef)
    draw_text!(ax, s, 1.0, c.position, c.symbol)
end

function draw!(ax, sc::StaveWithClef)
    c = sc.clef
    draw!(ax, sc.stave)
    draw!(ax, sc.stave, sc.clef)
end