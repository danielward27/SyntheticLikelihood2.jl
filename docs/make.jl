using SyntheticLikelihood2
using Documenter

DocMeta.setdocmeta!(SyntheticLikelihood2, :DocTestSetup, :(using SyntheticLikelihood2); recursive=true)

makedocs(;
    modules=[SyntheticLikelihood2],
    authors="Daniel Ward",
    repo="https://github.com/danielward27/SyntheticLikelihood2.jl/blob/{commit}{path}#{line}",
    sitename="SyntheticLikelihood2.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://danielward27.github.io/SyntheticLikelihood2.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/danielward27/SyntheticLikelihood2.jl",
    devbranch="main",
)
