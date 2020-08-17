module UnitfulColors
using Unitful
import Colors.colormatch
import PhysicalConstants.CODATA2018.h
import PhysicalConstants.CODATA2018.c_0
import PhysicalConstants.CODATA2018.b

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
    return colormatch(upreferred(PhysicalConstants.CODATA2018.c_0/ν))
end

"""
`colormatch(E::Unitful.Energy)`

A color approximately matching photon energy `E`
"""
function colormatch(E::Unitful.Energy)
    return colormatch(upreferred(PhysicalConstants.CODATA2018.h*PhysicalConstants.CODATA2018.c_0/E))
end
"""
`colormatch(T::Unitful.Temperature)`

A color approximately matching the peak wavelength of a black-body radiator with
temperature `T`.

If given a second argument `:spectrum`, tries to approximate the actual color spectrum
of such a black-body radiator (not implemented)
"""
function colormatch(T::Unitful.Temperature, interp::Symbol=:peak)
    interp==:peak && return colormatch(PhysicalConstants.CODATA2018.b/(T+0u"K"))
    interp==:spectrum && begin
        print("Spectrum not yet implemented")
        return colormatch(T,:peak)
    end
end

end #module UnitfulColors
