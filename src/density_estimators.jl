# Each density estimator should have a fit method, taking AbstractDensityData

abstract type AbstractDensityEstimator end
abstract type AbstractDensityData end

@kwdef struct DensityData <: AbstractDensityData
    θ::Vector{Int}
    x::AbstractVector
end


"""
Naive conditional kernel density estimator. Uses kernel density estimates for
p(x, θ) and p(θ), and estimates the likelihood with p(x, θ)/p(θ).
"""
struct DoubleKernel <: AbstractDensityEstimator

end






function fit_density(
    density_estimator::AbstractDensityEstimator,
    inference_state::AbstractDensityData)
    error("unimplemented")
end
