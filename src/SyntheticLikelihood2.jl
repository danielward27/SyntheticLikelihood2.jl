module SyntheticLikelihood2

using Distributions
using Random
using ForwardDiff
using LinearAlgebra
using Statistics
using StatsBase
using Parameters
import Base.@kwdef

import Random: default_rng

include("prior.jl")
include("example_task.jl")

# prior
export Prior, sample_prior

end
