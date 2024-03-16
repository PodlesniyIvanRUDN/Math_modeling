using Plots
using DifferentialEquations

N = 11900
I0 = 290
R0 = 52
S0 = N - I0 - R0
a = 0.01
b = 0.02


u0 = [S0, I0, R0]
time = [0.0 , 100]

function F(du, u, p, t)
    du[1] =0
    du[2] = -b * u[2]
    du[3] = -b * u[3]
end

problem = ODEProblem(F, u0, time)
const solution = solve(problem , saveat = 0.1 )

const S = Float64[]
const I = Float64[]
const R = Float64[]

for u in solution.u
    s, i, r = u
    push!(S, s)
    push!(I, i)
    push!(R, r)
end




plt1 = plot(
    dpi = 300,
    size = (800,600),
    title = "Динамика изменений в каждой группе сл-1"
)

plot!(
    plt1,
    solution.t,
    I,
    color =:red,
    label = "Инфицированные"
)

plot!(
    plt1,
    solution.t,
    S,
    color =:blue,
    label = "Восприимчивые"
)

plot!(
    plt1,
    solution.t,
    R,
    color =:red,
    label = "Имунные"
)

savefig(plt1, "first.png")


