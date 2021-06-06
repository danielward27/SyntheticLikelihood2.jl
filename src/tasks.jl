
"""
Simulate a three dimensional Gaussian mean vector θ. The covariance is diagonal,
and fixed to σ=0.1. Parameter vector θ is the mean vector of the Gaussian
"""
function gaussian_simulator(
    rng::AbstractRNG,
    θ::Vector{Float64}
    )
    sds = fill(√0.1, 3)
    d = MvNormal(θ, sds)
    rand(rng, d)
end


"""
Convenience macro to define a method for a simulator that allows simulating in
    batches. i.e. it takes `simulator(rng::AbstractRNG, θ::Vector{Float64})` and
    wraps it in a for loop to get `simulator(rng::AbstractRNG,
    θ::Matrix{Float64})`.
"""
macro loopify(x_dim, simulator)
    fn_name = Symbol(simulator)
    simulator = esc(simulator)
    quote
        function $(esc(fn_name))(rng::AbstractRNG, θ::Matrix{Float64})
            n = size(θ, 1)
            x = Matrix{Float64}(undef, n, $x_dim)
            for i in 1:n
                x[i, :] = $simulator(rng, θ[i, :])
            end
            return x
        end
    end
end

