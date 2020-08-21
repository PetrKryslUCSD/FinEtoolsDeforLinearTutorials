using Documenter, FinEtoolsDeforLinearTutorials 

makedocs(
	modules = [FinEtoolsDeforLinearTutorials],
	doctest = false, clean = true,
	format = Documenter.HTML(prettyurls = false),
	authors = "Petr Krysl",
	sitename = "FinEtoolsDeforLinearTutorials.jl",
	pages = Any[
		"Home" => "index.md",
		"Tutorials" => "tutorials/tutorials.md",
		]
	)


deploydocs(
    repo = "github.com/PetrKryslUCSD/FinEtoolsDeforLinearTutorials.jl.git",
)
