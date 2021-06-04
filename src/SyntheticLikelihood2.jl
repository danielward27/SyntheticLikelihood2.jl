module SyntheticLikelihood2

using Distributions
using Random
using ForwardDiff
using LinearAlgebra
using Statistics
using StatsBase
using Parameters
import Base.@kwdef

# prior.jl
export Prior, sample_θ

include("prior.jl")
include("example_task.jl")

end
