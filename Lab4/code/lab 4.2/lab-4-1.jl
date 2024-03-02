using Plots
using DifferentialEquations

const x0 = 0.5
const y0 = -1.5

u0 = [x0, y0]
time = [0.0, 59.0]

a = 14
b = 0.5

function F(du, u, p, t)
    du[1]=u[2]
    du[2]= -a*u[2]-b*u[1]
end

problem = ODEProblem(F, u0, time)
solution = solve(problem, saveat=0.05)

const X = Float64[]
const Y = Float64[]

for u in solution.u
    x,y = u
    push!(X,x)
    push!(Y,y)
end


plt1 = plot(
    dpi = 300,
    size = (800, 600),
    title = "case 2 with attenuation without outside forces impact"
        )

plot!(
    plt1,
    solution.t,
    X,
    color=:green,
    label = "x"
)

plot!(
    plt1,
    solution.t,
    Y,
    color=:yellow,
    label = "y"
)

savefig(plt1,"plot-1.png")


plt2 = plot(
    dpi = 300,
    size = (800, 600),
    title = "case 2 with attenuation without outside forces impact"
        )

plot!(
    plt2,
    X,
    Y,
    color=:red,
    label = "phasal portrait"
)

savefig(plt2,"plot-2.png")