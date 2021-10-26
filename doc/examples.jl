using UnitfulColors
using Plots, Unitful, UnitfulRecipes, Colors, Latexify, UnitfulLatexify

function showUnitColor(title, x, varargs...)
    return heatmap(
        x,
        [-1, 1],
        repeat(x, 2, 1);
        background=:black,
        color=colormatch.(x, varargs...),
        legend=false,
        colorbar=false,
        xlabel="\\textrm{$title}",
        yticks=[],
        yshowaxis=false,
        fontfamily="Computer Modern",
        unitformat=latexify,
    )
end

length = 1000;
pl = plot(
    showUnitColor("Wavelength", range(350, 750; length) .* u"nm"),
    showUnitColor("Frequency", range(400, 800; length) .* u"THz"),
    showUnitColor("Energy", range(1.5, 3.5; length) .* u"eV"),
    showUnitColor("Temperature (peak)", range(4000, 8000; length) .* u"K"),
    showUnitColor("Temperature (spectrum)", range(1000, 27000; length) .* u"K", :spectrum);
    layout=(5, 1),
);

savefig(pl, "$(pkgdir(UnitfulColors))/doc/examples.png")
