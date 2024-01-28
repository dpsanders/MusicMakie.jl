struct TimeSignature
    numerator::Int
    denominator::Int
    bar_length::Rational{Int}
end

TimeSignature(numerator::Int, denominator::Int) = 
    TimeSignature(numerator, denominator, numerator // denominator)


function draw!(s, sig::TimeSignature, x)

    draw_text!(s, x, 2, string(sig.numerator), fontsize=1.5)
    draw_text!(s, x, -2, string(sig.denominator), fontsize=1.5)

    x += 2
    return x
end

