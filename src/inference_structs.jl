


"""
Perform sequential inference using a fixed number of simulations per round.
"""
function sequential_inference(
    seed::AbstractRNG,
    simulator::Function,
    proposal::AbstractProposal,  # This will just be the prior at first
    estimator::AbstractDensityEstimator,
    sim_schedule::Vector{Int},
    n_mcmc_steps::Int)  # Probably best to do this to an ess?
    error("unimplemented")
    r = length(sim_schedule)
    
    for i in 1:r
        n_sim = sim_schedule[i]
        θ = propose(seed, proposal, n_sim)
        x = simulator(seed, θ)

        data = append_data(data, θ, x) # TODO: append to what?? Just do manually?

        density = fit_density(estimator, data)

        proposal = update_proposal(density, n_mcmc_steps)
        
    end

    posterior = propose(proposal)
    posterior

end



# Check Can infer rounds from n_sim_schedule