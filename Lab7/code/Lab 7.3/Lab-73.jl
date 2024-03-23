using Plots
using DifferentialEquations

N = 609
n0 = 4
a1 = 0.2
a2 = 0.2

u0 = [n0]

time = [0.0, 60.0]

function F(du, u, p, t)
    du[1] = (a1*cos(t) + a2*u[1]*cos(2*t))*(N - u[1])
end

problem = ODEProblem(F, u0, time)
solution = solve(problem, saveat = 0.01)

const Ns = Float64[]

for u in solution.u
    n = u[1]
    push!( Ns, n)
end


plt1 = plot(
    dpi = 300,
    size = (800,600),
    title = "Модель рекламной компании сл-3"
)

plot!(  
    plt1,
    solution.t,
    Ns,
    color =:red,
    xlabel = "t",
    ylabel = "N(t)",
    label = "Знающие о товаре"
)


savefig(plt1, "third.png")


