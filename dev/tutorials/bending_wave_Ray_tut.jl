# # Vibration of a cube of nearly incompressible material

# ## Description


# Compute the free-vibration spectrum of a unit cube of nearly
# incompressible isotropic material, E = 1, ν = 0.499, and ρ = 1 (refer to [1]). 

# The solution with the `FinEtools` package is compared with a commercial
# software  solution, and hence we also export the model to Abaqus.

# ## References

# [1] Puso MA, Solberg J (2006) A stabilized nodally integrated tetrahedral. International Journal for Numerical Methods in Engineering 67: 841-867.
# [2] P. Krysl, Mean-strain 8-node hexahedron with optimized energy-sampling
# stabilization, Finite Elements in Analysis and Design 108 (2016) 41–53.

# ![](unit_cube-mode7.png)

# ## Goals

# - Show how to generate hexahedral mesh, mirroring and merging together parts.
# - Export the model to Abaqus.

##
# ## Definitions

# Basic imports.
using LinearAlgebra
using Arpack

# This is the finite element toolkit itself.
using FinEtools

# The linear stress analysis application is implemented in this package.
using FinEtoolsDeforLinear
using FinEtoolsDeforLinear.AlgoDeforLinearModule

# Input parameters
E = 205000*phun("MPa");# Young's modulus
nu = 0.3;# Poisson ratio
rho = 7850*phun("KG*M^-3");# mass density
loss_tangent = 0.0001;
frequency = 1/0.0058;
Rayleigh_mass = 2*loss_tangent*(2*pi*frequency);
L = 200*phun("mm");
W = 4*phun("mm");
H = 8*phun("mm");
tolerance = W/500;
vmag = 0.1*phun("m")/phun("SEC");
tend = 0.013*phun("SEC");
    
##
# ## Create the discrete model

MR = DeforModelRed3D
fens,fes  = H8block(L,W,H, 50,1,4)

geom = NodalField(fens.xyz)
u = NodalField(zeros(size(fens.xyz,1),3)) # displacement field

nl = selectnode(fens, box=[L L -Inf Inf -Inf Inf], inflate=tolerance)
setebc!(u, nl, true, 1)
setebc!(u, nl, true, 2)
setebc!(u, nl, true, 3)
applyebc!(u)
numberdofs!(u)

corner = selectnode(fens, nearestto=[0 0 0])
cornerzdof = u.dofnums[corner[1], 3]

material = MatDeforElastIso(MR, rho, E, nu, 0.0)

femm = FEMMDeforLinear(MR, IntegDomain(fes, GaussRule(3,2)), material)
femm = associategeometry!(femm, geom)
K = stiffness(femm, geom, u)
femm = FEMMDeforLinear(MR, IntegDomain(fes, GaussRule(3,3)), material)
M = mass(femm, geom, u)
C = Rayleigh_mass * M

# Figure out the highest frequency in the model, and use a time step that is
# considerably larger than the period of that highest frequency.
evals, evecs = eigs(K, M; nev=1, which=:LM);
dt = 350 * 2/sqrt(evals[1]);

# The time stepping loop is protected by `let end` to avoid unpleasant surprises
# with variables getting clobbered by globals.
ts, corneruzs = let dt = dt
    # Initial displacement, velocity, and acceleration.
    U0 = gathersysvec(u)
    v = deepcopy(u)
    v.values[:, 3] .= vmag
    V0 = gathersysvec(v)
    F0 = fill(0.0, length(V0))
    U1 = fill(0.0, length(V0))
    V1 = fill(0.0, length(V0))
    F1 = fill(0.0, length(V0))
    R  = fill(0.0, length(V0))

    # Factorize the dynamic stiffness
    DSF = cholesky((M + (dt/2)*C + ((dt/2)^2)*K))

    # The times and displacements of the corner will be collected into two vectors
    ts = Float64[]
    corneruzs = Float64[]
    # Let us begin the time integration loop:
    t = 0.0; 
    step = 0;
    while t < tend
        push!(ts, t)
        push!(corneruzs, U0[cornerzdof])
        t = t+dt;
        step = step + 1;
        (mod(step,50)==0) && println("Step$(t)")
        # Zero out the load
        fill!(F1, 0.0);
        # Compute the out of balance force.
        R = (M*V0 - C*(dt/2*V0) - K*((dt/2)^2*V0 + dt*U0) + (dt/2)*(F0+F1));
        # Calculate the new velocities.
        V1 = DSF\R;
        # Update the velocities.
        U1 = U0 + (dt/2)*(V0+V1);
        # Switch the temporary vectors for the next step.
        U0, U1 = U1, U0;
        V0, V1 = V1, V0;
        F0, F1 = F1, F0;
        if (t == tend) # Are we done yet?
            break;
        end
        if (t+dt > tend) # Adjust the last time step so that we exactly reach tend
            dt = tend-t;
        end
    end
    ts, corneruzs # return the collected results
end

##
# ## Plot the results

using PlotlyJS

options = Dict(
    :showSendToCloud=>true, 
    :plotlyServerURL=>"https://chart-studio.plotly.com"
    )

# Define the layout of the figure.
layout = Layout(;width=600, height=500, xaxis=attr(title="Time [s]", type = "linear"), yaxis=attr(title="Displacement [mm]", type = "linear"), title = "Displacement of the corner")
# Create the graphs:
plots = cat(scatter(;x=ts, y=corneruzs./phun("mm"), mode="lines", name = "", line_color = "rgb(215, 15, 15)", line_width = 4); dims = 1)
# Plot the graphs:
pl = plot(plots, layout; options)
display(pl)

# The end.
true