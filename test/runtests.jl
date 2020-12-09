import Colors: XYZ, xyY
import Unitful.@u_str
using UnitfulColors
using Test

@testset "UnitfulColors.jl" begin
    @test colormatch(612.2u"nm") == colormatch(612.2)
    @test typeof(colormatch(600u"THz")) <:  XYZ
    @test typeof(colormatch(2.3u"eV"))  <:  XYZ
    @test typeof(colormatch(5000u"K"))  <:  XYZ
    @test typeof(colormatch(1.5e4u"K",:spectrum)) <:  xyY
end
