using Plots
using DifferentialEquations

const x0 = 8
const y0 = 11

state = [x0, y0]

time = [0.0, 60.0]

a = 0.25 
b = 0.025
c = 0.45
d = 0.045

function F(du, u, p, t)
    du[1] = -a*u[1]+b*u[1]*u[2]
    du[2] = c*u[2]-d*u[1]*u[2]
end

problem = ODEProblem(F,state,time)
solution = solve( problem, saveat=0.05)

const X = Float64[]
const Y = Float64[]

for u in solution.u
    x,y = u
    push!(X, x)
    push!(Y, y)
end


plt1 = plot(
    dpi = 300,
    size = (800,600),
    title = "Изменение численности хищников и добычи"
)

plot!(
    plt1,
    solution.t,
    X,
    color =:red,
    label = "Численность хищников"
)

plot!(
    plt1,
    solution.t,
    Y,
    color =:blue,
    label = "Численность жертв"
)

savefig(plt1, "first.png")


plt2 = plot(
    dpi = 300,
    size = (800,600),
    title = "График зависимости изменения численности хищников и добычи"
)

plot!(
    plt2,
    X,
    Y,
    color =:red,
    label = "зависимости изменения численности хищников и добычи"
)

savefig(plt2, "second.png")