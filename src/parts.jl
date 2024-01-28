
mutable struct Part
    v::Vector{Any}
    clef::Clef
    time_signature::TimeSignature
    current_time::Rational{Int}
    x::Float64
    s::Stave
end

function Part(ax)
    clef = TrebleClef()
    time_signature = TimeSignature(4, 4)
    s = Stave(ax, 0, 30, 0, 0.5)
    draw!(s)
    return Part([], clef, time_signature, 0, 0.0, s)
end

function Base.push!(p::Part, c::Clef)
    p.clef = c
    p.x = draw!(p.s, c, p.x)
end

function Base.push!(p::Part, sig::TimeSignature)
    p.time_signature = sig
    p.x = draw!(p.s, sig, p.x)
end

function Base.push!(p::Part, obj::Note)
    p.x = draw!(p.s, obj, p.clef, p.x)
    p.current_time += obj.duration

    if p.current_time > 0 && p.current_time % p.time_signature.bar_length == 0
        draw_bar_line!(p.s, p.x)
        p.x += 0.8
    end
end
