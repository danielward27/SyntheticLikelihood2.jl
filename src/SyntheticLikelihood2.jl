module SyntheticLikelihood2

using Base: ident_cmp
using Distributions
using Random
using ForwardDiff
using LinearAlgebra
using Statistics
using StatsBase
using Parameters
using KernelDensity
import Base.@kwdef

import Random: default_rng

include("prior.jl")
include("density_estimators.jl")
include("tasks.jl")

# prior
export Prior, propose

# Tasks
export @loopify

end
