---
## Front matter
title: "Отчёт по лабораторной работе"
subtitle: "Лабораторная работа №5"
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
lof: true # List of figures
lot: true # List of tables
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
lofTitle: "Список иллюстраций"
lotTitle: "Список таблиц"
lolTitle: "Листинги"
## Misc options
indent: true
header-includes:
  - \usepackage{indentfirst}
  - \usepackage{float} # keep figures where there are in the text
  - \floatplacement{figure}{H} # keep figures where there are in the text
---

# Цель работы

​	При помощи Julia и Openmodelica построить фазовый портрет гармонического осциллятора и решение уравнения гармонического осциллятора для следующих случаев. 


# Задание

$$\begin{cases}\frac{\text{d}x}{\text{d}t}=-0.25x(t)+0.025x(t)y(y)\\\frac{\text{d}y}{\text{d}t}=0.45y(t)-0.045x(t)y(t)\end{cases}$$

Постройте график зависимости численности хищников от численности жертв, а также графики изменения численности хищников и численности жертв при следующих начальных условиях: $x_{0} = 8, y_{0} = 11$. Найдите стационарное состояние системы.  

# Теоретическое введение

Простейшая модель взаимодействия двух видов типа «хищник — жертва» - модель **Лотки-Вольтерры**. Данная двувидовая модель основывается на следующих предположениях: 

1. Численность популяции жертв x и хищников y зависят только от времени (модель не учитывает пространственное распределение популяции на занимаемой территории) 
2. В отсутствии взаимодействия численность видов изменяется по модели Мальтуса, при этом число жертв увеличивается, а число хищников падает 
3. Естественная смертность жертвы и естественная рождаемость хищника считаются несущественными
4. Эффект насыщения численности обеих популяций не учитывается 
5. Скорость роста численности жертв уменьшается пропорционально численности хищников

$$\begin{cases}\frac{\text{d}x}{\text{d}t}=ax(t)+bx(t)y(y)\\\frac{\text{d}y}{\text{d}t}=-cy(t)+dx(t)y(t)\end{cases}$$

В этой модели $x$ -- число жертв, $y$ -- число хищников. Коэффициент $a$ описывает скорость естественного прироста числа жертв в отсутствие хищников, $c$ -- естественное вымирание хищников, лишенных пищи в виде жертв.

# Выполнение лабораторной работы

## Выполнение в Julia

### Колебания гармонического осциллятора без затуханий и без действий внешней силы

___

На языке Julia я описал систему дифференциальных уравнений, по которой затем построил график решений и график  фазового портрета для каждого из двух случаев. 

Первый случай:

```julia
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
```

Второй случай:

```julia
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
```

### Полученные графики

___

В результате получаем два графика  (рис. @fig:003 и @fig:004).


![График](first.png)

![График](second.png){#fig:003 width=70%}


![График](third.png)

![Фазовый портрет](fourth.png){#fig:004 width=70%}


# Выводы

​	Мы смогли при помощи Julia и Openmodelica построить фазовый портрет гармонического осциллятора и решение уравнения гармонического осциллятора для заданных случаев. 

# Список литературы{.unnumbered}

::: {#refs}
:::
