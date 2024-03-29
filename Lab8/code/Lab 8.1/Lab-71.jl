using Plots
using DifferentialEquations

M1 = 3.3
M2 = 2.2
P_cr = 26
N = 33
q = 1
Tau_1 = 25
Tau_2 = 14
p1 = 5.5
p2 = 11

a1 = P_cr / ((Tau_1^2)*(p1^2) * N * q)
a2 = P_cr / ((Tau_2^2)*(p2^2) * N * q )
b = P_cr/ ((Tau_1^2)*(p1^2)*(Tau_2^2)*(p2^2)* N * q)
c1 = (P_cr - p1) / (Tau_1 * p1)
c2 = (P_cr - p2) / (Tau_2 * p2)
    

u0 = [M1, M2]

time = [0.0, 60.0]


function F(du, u, p, t)
    du[1] = u[1] - (b/c1) * u[1] * u[2] - (a1 / c1) * (u[1]^2)
    du[2] = (c2 / c1) * u[2] - (b / c1) * u[1]*u[2] -(a2 / c1) * (u[2]^2)
end

problem = ODEProblem( F, u0, time)
solution = solve(problem, saveat = 0.001)

const M_1 = Float64[]
const M_2 = Float64[]


for u in solution.u
    m1 = u[1]
    m2 = u[2]
    push!(M_1, m1)
    push!(M_2, m2)
end

plt1 = plot(
    dpi = 300,
    size = (800,600),
    title = "Модель конкуренции компаний сл-1"
)

plot!(
    plt1,
    solution.t,
    M_1,
    color =:red,
    xlabel = "Время",
    ylabel = "Объем продаж",
    label = "Компания 1"
)


plot!(
    plt1,
    solution.t,
    M_2,
    color =:blue,
    xlabel = "Время",
    ylabel = "Объем продаж",
    label = "Компания 2"
)


savefig(plt1, "first.png")


