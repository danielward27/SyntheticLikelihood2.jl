using SyntheticLikelihood2, Test, SafeTestsets

@time begin
    @time @safetestset "Prior" begin include("prior_test.jl") end
end
