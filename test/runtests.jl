using Test
using SymbolicErrorPropagator

@testset "test_latex_enclose" begin
    simple_latex = "f(x) = ax + b"
    @test enclose(simple_latex) == "\\begin{equation}\n\tf(x) = ax + b\n\\end{equation}"
    @test enclose(simple_latex, numbered=false) == "\\begin{equation*}\n\tf(x) = ax + b\n\\end{equation*}"
    @test enclose(simple_latex, inline=true) == "\$f(x) = ax + b\$"
end
