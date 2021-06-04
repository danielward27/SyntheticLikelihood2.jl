using SyntheticLikelihood2, Test, Distributions, ForwardDiff, LinearAlgebra
using SyntheticLikelihood2: cut_at, prior_logpdf, log_prior_gradient,
    log_prior_hessian, in_prior_support, prior_cov

v = [1,2,3,4]
@test cut_at(v, [1,3]) == [[1], [2,3], [4]]

test_θ = rand(3)
prod = Product([Normal(1), Normal(2), Normal(3)])
mvn = MvNormal([1, 2, 3], [1., 1, 1])

prior_uni = Prior(prod.v)
prior_mv = Prior([mvn])


@testset "Log density" begin
    expected_density = loglikelihood(prod, test_θ)
    @test expected_density ≈ loglikelihood(mvn, test_θ)
    @test expected_density ≈ prior_logpdf(prior_mv, test_θ)
    @test expected_density ≈ prior_logpdf(prior_uni, test_θ)
end


@testset "Autodiff" begin
    expected_grad = gradlogpdf(mvn, test_θ)

    # Check Hessian calculated right
    expected_Hessian = begin
        f(θ) = loglikelihood(mvn, θ)
        Symmetric(ForwardDiff.hessian(f, test_θ))
    end

    @test expected_grad ≈ log_prior_gradient(prior_uni, test_θ)
    @test expected_grad ≈ log_prior_gradient(prior_mv, test_θ)

    @test expected_Hessian ≈ log_prior_hessian(prior_uni, test_θ)
    @test expected_Hessian ≈ log_prior_hessian(prior_mv, test_θ)
end


@testset "Covariance" begin
    expected_cov = Symmetric(diagm(ones(3)))
    @test expected_cov ≈ prior_cov(prior_uni)
    @test expected_cov ≈ prior_cov(prior_mv)
end


@testset "Support" begin
    prior_uni = Prior([Uniform(-5,5), Uniform(-10,10)])
    prior_mv = Prior([MvLogNormal([1.,2.,3.])])

    @test in_prior_support(prior_uni, [0., 0]) === true
    @test in_prior_support(prior_uni, [-6., 5]) === false
    @test in_prior_support(prior_uni, [-4., 11]) === false

    @test in_prior_support(prior_mv, [1e7, 1e6, 1e5]) === true
    @test in_prior_support(prior_mv, [1e7, 1e6, -1e-10]) === false
end


@testset "Sampling" begin
    prior = Prior([MvNormal([1.,2.]), Normal()])
    @test sample_prior(prior) isa Vector{Float64}
    @test sample_prior(prior, 10) isa Matrix{Float64}
    @test size(sample_prior(prior, 10)) == (3,10)
end



