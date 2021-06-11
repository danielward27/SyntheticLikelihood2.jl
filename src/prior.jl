# All AbstractProposal should have methods propose(::AbstractRNG,
# ::AbstractProposal), and propose(::AbstractProposal) (using default_rng())
abstract type AbstractProposal end


"""
Struct to hold prior distributions. `v` is a vector of distributions from
Distributions.jl. Univariate and/or multivariate distributions can be used.
Each element in the vector is assumed to be independent.
"""
struct Prior <: AbstractProposal
    "A vector of distributions"
    v::Vector{<: Distribution}
    splits::Vector{Int}
    length::Int

    Prior(v) = begin
        dims = [length(d) for d in v]
        dim = sum(dims)
        splits = cumsum(dims)[1:(end-1)]
        new(v, splits, dim)
    end
end


"""
'Cut' vector at specified indexes, to form a vector of vectors. Note the cut
occurs after the index, so [1] would cut between index 1 and 2 in the vector.
"""
function cut_at(v::AbstractVector, idxs::Vector{Int})
    @assert all(idxs .>= 1)
    @assert all(idxs .< length(v))
    idxs = [0; idxs; length(v)]
    [v[(idxs[i]+1):idxs[i+1]] for i in 1:(length(idxs)-1)]
end


"Evaluate the density of the prior at θ."
function prior_logpdf(prior::Prior, θ::Vector{Float64})
    split_θ = cut_at(θ, prior.splits)
    l = 0
    for (d, θ) in zip(prior.v, split_θ)
        lᵢ = d isa UnivariateDistribution ? loglikelihood(d, θ[1]) : loglikelihood(d, θ)
        l += lᵢ
    end
    l
end


"Automatic differentiation to get prior gradient."
function log_prior_gradient(prior::Prior, θ::Vector{Float64})
    split_θ = cut_at(θ, prior.splits)
    ∇s = Vector{Vector{Float64}}(undef, length(split_θ))
    for (i, (d, θ)) in enumerate(zip(prior.v, split_θ))
        f(θ) = loglikelihood(d, θ)
        ∇s[i] = ForwardDiff.gradient(f, θ)
    end
    vcat(∇s...)
end


"Automatic differentiation to get prior Hessian."
function log_prior_hessian(prior::Prior, θ::Vector{Float64})
    split_θ = cut_at(θ, prior.splits)
    Hs = Vector{Matrix{Float64}}(undef, length(split_θ))
    for (i, (d, θ)) in enumerate(zip(prior.v, split_θ))
        f(θ) = loglikelihood(d, θ)
        Hs[i] = ForwardDiff.hessian(f, θ)
    end
    H = cat(Hs..., dims=(1,2))  # Block diagonal
    Symmetric(H)
end


"""
Covariance matrix of the prior.
"""
function prior_cov(prior::Prior)
    blocks = [d isa UnivariateDistribution ? var(d) : Distributions.cov(d) for d in prior.v]
    Σ = cat(blocks..., dims=(1,2))  # Block diagonal
    Symmetric(Matrix(Σ))
end


"""
Check if a parameter vector falls within the prior support.
"""
function in_prior_support(prior::Prior, θ::AbstractVector{Float64})
    split_θ = cut_at(θ, prior.splits)
    all([Distributions.insupport(d, θᵢ)[1] for (d, θᵢ) in zip(prior.v, split_θ)])
end


"""
Sample parameters from the prior. Note that if n is provided, a matrix is
returned with n columns.
"""
function propose(rng::AbstractRNG, prior::Prior)
    θ = [rand(rng, d) for d in prior.v]
    vcat(θ...)
end

propose(prior::Prior) = propose(default_rng(), prior)

function propose(rng::AbstractRNG, prior::Prior, n::Int64)
    θ = Matrix{Float64}(undef, n, prior.length)
    for i in 1:n
        θ[i, :] = propose(rng, prior)
    end
    θ
end

propose(prior::Prior, n::Int64) = propose(default_rng(), prior, n)
