using Plots

const s = 11.5
const k = 3.5
const ThetaCrdeg = 320
const dTheta = 0.01
const MaxTheta = 4*pi
const cases =["F","S"]

function F(theta)
return r0 * exp.(theta / sqrt.(k^2 - 1))
end

for case in cases
global r0 = -1
theta0 = -1

if case=="F"
r0 = s / (k + 1)
theth0 = 0
else
r0 = s / (k - 1)
theta0 = -pi
end

theta1 = theta0 + MaxTheta
thetaCop = theta0 : dTheta : theta1
thetaCrook = ThetaCrdeg * pi / 180 + 2 *theta0

plt = plot( proj=:polar, aspect_ratio=:equal, dpi=500, title="Lab-#2" * case * "Case", legend=true )
plot!(plt, [theta0, theta0], [s, F(theta0)], label=false, color=:red)
plot!(plt, thetaCop, F, label=:"Cop's path" , color=:red)
plot!(plt, [0, thetaCrook],[0, F(thetaCrook)+20], label=:"Crook trajectory", color=:green)

plot!(plt, [theta0], [s], seriestype=:scatter, label=:"Cop's starting position", color=:red)
plot!(plt, [0], [0], seriestype=:scatter, label=:"Crook starting position", color=:green)
plot!(plt, [thetaCrook], [F(thetaCrook)], seriestype=:scatter, label=:"intersection point", color=:yellow)

savefig(plt, "Lab-#2" * case * "Case#.png")
display(plt)
end