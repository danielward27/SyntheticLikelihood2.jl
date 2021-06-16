# Each density estimator should have a method fit_density(::AbstractDensityData)
# We should use log density problems...

abstract type AbstractDensityEstimator end
abstract type AbstractDensityData end

@kwdef struct DensityData <: AbstractDensityData
    θ::Vector{Int}
    x::AbstractVector
end


@kwdef struct LocalRegressionPosterior <: AbstractDensityEstimator
    prior::Prior
    P::Union{Diagonal, Symmetric}
end



function fit_density(
    density_estimator::LocalRegression,
    inference_state::AbstractDensityData)
    error("unimplemented")
end
