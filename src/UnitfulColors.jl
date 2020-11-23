module UnitfulColors
using Unitful
import Colors.colormatch
import Colors.XYZ
import Colors.xyY
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
    return colormatch(upreferred(λ/u"nm"))
end

"""
`colormatch(ν::Unitful.Frequency)`

A color approximately matching frequency `ν`
"""
function colormatch(ν::Unitful.Frequency)
    return colormatch(upreferred(c_0/ν))
end

"""
`colormatch(E::Unitful.Energy)`

A color approximately matching photon energy `E`
"""
function colormatch(E::Unitful.Energy)
    return colormatch(upreferred(h*c_0/E))
end

"""
`colormatch(T::Unitful.Temperature)`

A color approximately matching the peak wavelength of a black-body radiator with
temperature `T`.

If given a second argument `:spectrum`, tries to approximate the actual color spectrum
of such a black-body radiator.
"""
function colormatch(T::Unitful.Temperature, interp::Symbol=:peak)
    T = T + 0.0u"K"
    interp==:peak && return colormatch(b/T)
    if interp==:spectrum
        # Cubic spline from US patent US2003095138 (A1)
        T<=1667.0u"K" && return XYZ{Float64}(0,0,0)
        T>=25000.0u"K" && return XYZ{Float64}(0,0,0)
        x_c = (T <= 4000.0u"K"
               ? -0.2661239*(1e3u"K"/T)^3 - 0.2343589*(1e3u"K"/T)^2 + 0.8776956*(1e3u"K"/T) + 0.179910
               : -3.0258469*(1e3u"K"/T)^3 + 2.1070379*(1e3u"K"/T)^2 + 0.2226347*(1e3u"K"/T) + 0.240390
              )
        y_c = (T <= 2222.0u"K"
               ? -1.1063814x_c^3 - 1.34811020x_c^2 + 2.18555832x_c - 0.20219683
               : (T <= 4000.0u"K"
                  ? -0.9549476x_c^3 - 1.37418593x_c^2 + 2.09137015x_c - 0.16748867
                  : 3.0817580x_c^3 - 5.87338670x_c^2 + 3.75112997x_c - 0.37001483
                 )
              )
        Y = 0.75
        return xyY{Float64}(x_c,y_c,Y)
    end
end

end #module UnitfulColors
