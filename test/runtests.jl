using SyntheticLikelihood2, Test, SafeTestsets

@time begin
    @time @safetestset "prior" begin include("prior_test.jl") end
end
