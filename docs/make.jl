using Documenter, FinEtools, FinEtoolsDeforLinear

makedocs(
	modules = [FinEtoolsDeforLinear],
	doctest = false, clean = true,
	format = Documenter.HTML(prettyurls = false),
	authors = "Petr Krysl",
	sitename = "FinEtoolsDeforLinear.jl",
	pages = Any[
		"Home" => "index.md",
		"Tutorials" => "tutorials/tutorials.md",
	)

deploydocs(
    repo = "github.com/PetrKryslUCSD/FinEtoolsDeforLinearTutorials.jl.git",
)
