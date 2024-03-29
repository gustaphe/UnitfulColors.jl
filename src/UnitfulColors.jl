module UnitfulColors
using Unitful
import Colors.colormatch
import Colors.XYZ
import PhysicalConstants.CODATA2018.h
import PhysicalConstants.CODATA2018.c_0
import PhysicalConstants.CODATA2018.b
import PhysicalConstants.CODATA2018.k_B

export colormatch

"""
`colormatch(λ::Unitful.Length)`

A color approximately matching wavelength `λ`
"""
function colormatch(λ::Unitful.Length)
    return colormatch(ustrip(u"nm", λ))
end

"""
`colormatch(ν::Unitful.Frequency)`

A color approximately matching frequency `ν`
"""
function colormatch(ν::Unitful.Frequency)
    return colormatch(ustrip(u"nm", c_0 / ν))
end

"""
`colormatch(E::Unitful.Energy)`

A color approximately matching photon energy `E`
"""
function colormatch(E::Unitful.Energy)
    return colormatch(ustrip(u"nm", h * c_0 / E))
end

"""
`colormatch(T::Unitful.Temperature)`

A color approximately matching the peak wavelength of a black-body radiator with
temperature `T`.

If given a second argument `:spectrum`, tries to approximate the actual color spectrum of
such a black-body radiator. If the keyword argument `Y` is given, it determines the
brightness (default `0.75`, `0<=Y<=1`).
"""
function colormatch(T::Unitful.Temperature, interp::Symbol=:peak; Y=0.75)
    T = T + 0.0u"K"
    interp == :peak && return colormatch(b / T)
    if interp == :spectrum
        # Cubic spline from (expired) US patent US2003095138 (A1)
        r = 1 / ustrip(u"kK", T)
        T <= 1667.0u"K" && return XYZ{Float64}(0, 0, 0)
        T >= 25000.0u"K" && return XYZ{Float64}(0, 0, 0)
        if T <= 4000.0u"K"
            x = -0.2661239 * r^3 - 0.2343589 * r^2 + 0.8776956 * r + 0.179910
            if T <= 2222.0u"K"
                y = -1.1063814x^3 - 1.34811020x^2 + 2.18555832x - 0.20219683
            else
                y = -0.9549476x^3 - 1.37418593x^2 + 2.09137015x - 0.16748867
            end
        else
            x = -3.0258469 * r^3 + 2.1070379 * r^2 + 0.2226347 * r + 0.240390
            y = 3.0817580x^3 - 5.87338670x^2 + 3.75112997x - 0.37001483
        end

        X = Y / y * x
        Z = Y / y * (1 - x - y)

        return XYZ{Float64}(X, Y, Z)
    end
end

end #module UnitfulColors
