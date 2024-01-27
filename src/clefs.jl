

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


function draw!(ax, s, c::Clef, x)
    draw_text!(ax, s, x, c.position, c.symbol)
    x += 2
    return x
end
