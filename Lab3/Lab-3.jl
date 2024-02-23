using Plots
using DifferentialEquations

const x0 = 61000
const y0 = 45000
point0 = [x0, y0]
time = [0.0,  5.0]

a1 = 0.22
b1 = 0.82
c1 = 0.45
h1 = 0.67

a2 = 0.28
b2 = 0.83
c2 = 0.31
h2 = 0.75

function P1(t)
    return 2sin(4t)
end

function Q1(t)
    return 2cos(4t)
end

function P2(t)
    return 1.5sin(t)
end

function Q2(t)
    return 1.5cos(t)
end

function F1(dp, point, p, t)
    dp[1] = -a1*point[1] - b1*point[2] + P1(t)
    dp[2] = -c1*point[1] - h1*point[2] + Q1(t)
end

function F2(dp, point, p, t)
    dp[1] = -a2*point[1] - b2*point[2] + P2(t)
    dp[2] = -c2*point[1]*point[2] - h2*point[2] + Q2(t)
end

t= collect( LinRange(0, 1, 100))
task1 = ODEProblem(F1, point0, time)
solution1 = solve(task1, saveat=t)
task2 = ODEProblem(F2, point0, time)
solution2 = solve(task2, saveat=t) 

plot1 = plot(solution1, color=:red, label = "Численность войск армии №1", title="Модель боевых действий №1", xlabel="Время", y="Численность войск")

plot!(solution1, color=:yellow, label = "Численность войск армии №2")

savefig( plot1, "first_case.png")


plot2 = plot(solution2, color=:red, label = "Численность войск армии №1", title="Модель боевых действий №2", xlabel="Время", y="Численность войск")

plot!(solution2, color=:yellow, label = "Численность войск армии №2")

savefig( plot2, "second_case.png")
