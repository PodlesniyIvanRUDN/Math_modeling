---
## Front matter
title: "Отчёт по лабораторной работе №6"
subtitle: "НКНбд-01-21"
author: "Подлесный Иван Сергеевич"

## Generic otions
lang: ru-RU
toc-title: "Содержание"

## Bibliography
bibliography: bib/cite.bib
csl: pandoc/csl/gost-r-7-0-5-2008-numeric.csl

## Pdf output format
toc: true # Table of contents
toc-depth: 2
fontsize: 12pt
linestretch: 1.5
papersize: a4
documentclass: scrreprt
## I18n polyglossia
polyglossia-lang:
  name: russian
  options:
        - spelling=modern
        - babelshorthands=true
polyglossia-otherlangs:
  name: english
## I18n babel
babel-lang: russian
babel-otherlangs: english
## Fonts
mainfont: PT Serif
romanfont: PT Serif
sansfont: PT Sans
monofont: PT Mono
mainfontoptions: Ligatures=TeX
romanfontoptions: Ligatures=TeX
sansfontoptions: Ligatures=TeX,Scale=MatchLowercase
monofontoptions: Scale=MatchLowercase,Scale=0.9
## Biblatex
biblatex: true
biblio-style: "gost-numeric"
biblatexoptions:
  - parentracker=true
  - backend=biber
  - hyperref=auto
  - language=auto
  - autolang=other*
  - citestyle=gost-numeric
## Pandoc-crossref LaTeX customization
figureTitle: "Рис."
tableTitle: "Таблица"
listingTitle: "Листинг"
lofTitle: "Цель Работы"
lotTitle: "Ход Работы"
lolTitle: "Листинги"
## Misc options
indent: true
header-includes:
  - \usepackage{indentfirst}
  - \usepackage{float} # keep figures where there are in the text
  - \floatplacement{figure}{H} # keep figures where there are in the text
---

# Теоретическое введение

## Задача об эпидемии (SIR модель)

Рассмотрим простейшую модель эпидемии. Предположим, что некая популяция, состоящая из N особей, (считаем, что популяция изолирована) подразделяется на три группы. Первая группа - это восприимчивые к болезни, но пока здоровые особи, обозначим их через $S(t)$. Вторая группа – это число инфицированных особей, которые также при этом являются распространителями инфекции, обозначим их $I(t)$. А третья группа, обозначающаяся через $R(t)$ – это здоровые особи с иммунитетом к болезни.

До того, как число заболевших не превышает критического значения  I*, считаем, что все больные изолированы и не заражают здоровых. Когда $I(t) > I^{*}$,
тогда инфицирование способны заражать восприимчивых к болезни особей.

Таким образом, скорость изменения числа S(t) меняется по следующему закону:

$\frac{dS}{dt} = \left\{ \begin{array}{cl}
-\alpha S & : \ I(t) > I^{*} \\
0 & : \ I(t) <=  I^{*} 
\end{array} \right.$

Поскольку каждая восприимчивая к болезни особь, которая, в конце концов, заболевает, сама становится инфекционной, то скорость изменения числа инфекционных особей представляет разность за единицу времени между заразившимися и теми, кто уже болеет и лечится, т.е.:

$\frac{dI}{dt} = \left\{ \begin{array}{cl}
\alpha S - \beta I & : \ I(t) > I^{*} \\
-\beta I & : \ I(t) <=  I^{*}
\end{array} \right.$

А скорость изменения выздоравливающих особей (при этом приобретающие иммунитет к болезни)

$\frac{dR}{dt} = \beta I$

Постоянные пропорциональности,  $\alpha$ и $\beta$ - это коэффициенты заболеваемости и выздоровления соответственно.

Для того, чтобы решения соответствующих уравнений определялось однозначно, необходимо задать начальные условия. Считаем, что на начало эпидемии в момент времени $t = 0$ нет особей с иммунитетом к болезни $R(0)=0$, а  число инфицированных и восприимчивых к болезни особей $I(0)$ и $S(0)$ соответственно. Для анализа картины протекания эпидемии необходимо рассмотреть два случая: $I(0) <= I^{*}, I(0) > I^{*}$

## Задание

### Вариант 32

На одном острове вспыхнула эпидемия. Известно, что из всех проживающих на острове (N=11 900) в момент начала эпидемии (t=0) число заболевших людей (являющихся распространителями инфекции) I(0)=290, А число здоровых людей с иммунитетом к болезни R(0)=52. Таким образом, число людей восприимчивых к болезни, но пока здоровых, в начальный момент времени S(0)=N-I(0)- R(0).

Постройте графики изменения числа особей в каждой из трех групп. 

Рассмотрите, как будет протекать эпидемия в случае:

1) $I(0) <= I^{*}$

2) $I(0) > I^{*}$

# Ход работы

## Решение и листинг программы №1

```julia
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




```

## Решение и листинг программы №2

```julia
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
    du[1] = -a*u[1]
    du[2] = a*u[1] - b * u[2]
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

savefig(plt1, "second.png")

```

## Результаты работы

![$I(0) <= I^{*}$](first.png)

![$I(0) > I^{*}$](second.png)

# Вывод

Во время выполнения лабораторной работы мы познакомились с SIR моделью.