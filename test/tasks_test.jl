using SyntheticLikelihood2, Test, Distributions, Random, Distributions
import SyntheticLikelihood2: gaussian_simulator

prior = Prior(fill(Uniform(-1,1), 3))
rng = MersenneTwister(1)

θ_vec = propose(rng, prior)
θ_mat = propose(rng, prior, 5)

@loopify 3 gaussian_simulator

@testset "gaussian simulator" begin
    @test gaussian_simulator(rng, θ_vec) isa Vector{Float64}
    @test gaussian_simulator(rng, θ) isa Matrix{Float64}
    @test size(gaussian_simulator(rng, θ)) === (5,3)
end
