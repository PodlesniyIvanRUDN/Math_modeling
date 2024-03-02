---
## Front matter
title: "Отчёт по лабораторной работе"
subtitle: "Лабораторная работа №4"
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

​	При помощи Julia построить фазовый портрет гармонического осциллятора и решение уравнения гармонического осциллятора для следующих случаев. 

# Задание

Вариант №32

Постройте фазовый портрет гармонического осциллятора и решение уравнения гармонического осциллятора для следующих случаев 

1. Колебания гармонического осциллятора без затуханий и без действий внешней силы:
   $$
   \ddot{x}+5.2x=0
   $$

2. Колебания гармонического осциллятора c затуханием и без действий  внешней силы:
   $$
   \ddot{x}+14\dot{x}+0.5x=0
   $$

3. Колебания гармонического осциллятора c затуханием и под действием внешней силы:
   $$
   \ddot{x}+13\dot{x}+0.3x=0.8\sin(9t)
   $$
   На интервале $t \in [0;59]$ с шагом 0.05 и начальными условиями:$x_{0} = 0.5, y_{0}= -1.5$

       В общем виде наши уравнения это однородные ОДУ 2-го порядка (линейные):

   $$
   \ddot x(t) + a\dot x(t) + bx(t) = F(t)
   $$ {#eq:06}

   где $\dot x = \frac{dx}{dt}$ - производная по времени.

   Если $F(t) = 0$ и $b \ne 0$, значит есть трение и система затухнет. Если $F(t) = 0$ и $b = 0$, то трения нет.Если $F(t) \ne 0$, то система никогда не затухнет.


   Можно сделать систему ОДУ:

   $y = \frac{dx}{dt} = \dot x(t)$ --> 
   $\frac{d^2x}{dt^2} = \frac{dy}{dt}$ --> $\frac{dy}{dt} + ay(t) + bx(t) = 0$ 

   Тогда система для решения:

   $$
   \begin{cases}
     \frac{dx}{dt} = y
     \\
     \frac{dy}{dt} = F(t) -ay - bx
   \end{cases}
   $$ {#eq:07}

4. Разберем три случая в нашем задании. 

   В первом случае мы работаем с колебаниями гармонического осциллятора без затуханий и без действий внешней силы $\ddot x + 7x = 0$. Тогда, по общему виду [-@eq:05] видим, что $a=0$, $F(x)=0$, $b=7$. Подставляем значения в систему для решения [-@eq:07] и получаем систему для решения первого случая

   $$
   \begin{cases}
     \dot x = y
     \\
     \dot y = -7x
   \end{cases}
   $$ {#eq:08}

   Во втором случае мы работаем с колебаниями гармонического осциллятора c затуханием и без действий внешней силы $\ddot x + 9 \dot x +3x= 0$. Тогда по общему виду [-@eq:05] видим, что $a=9$, $F(x)=0$, $b=3$. Подставляем значения в систему для решения [-@eq:07] и получаем систему для решения второго случая

   $$
   \begin{cases}
     \dot x = y
     \\
     \dot y = -9y - 3x
   \end{cases}
   $$ {#eq:9}

   В третьем случае мы работаем с колебаниями гармонического осциллятора c затуханием и под действием внешней силы $\ddot x + 4 \dot x +x= \cos(2t)$. Тогда по общему виду [-@eq:05] видим, что $a=4$, $F(x)=\cos(2t)$, $b=1$. Подставляем значения в систему для решения [-@eq:07] и получаем систему для решения третьего случая

   $$
   \begin{cases}
     \dot x = y
     \\
     \dot y = \cos(2t) -4y -x
   \end{cases}
   $$ {#eq:10}


# Теоретическое введение

​	В лабораторной работе исследуется уравнение свободных колебаний гармонического осциллятора, которое имеет следующий вид:

$$
\ddot{x}+\gamma\dot{x}+\omega^{2}_{0}x=0
$$
где $x$ – переменная, описывающая состояние системы (смещение грузика, заряд конденсатора и т.д.), $\gamma$  – параметр, характеризующий потери энергии (трение в механической системе, сопротивление в контуре), $\omega_{0}$ – собственная частота колебаний, $t$ – время. 
$$
\ddot{x}=\frac{\partial^{2} x}{\partial t^{2}}, \dot{x}=\frac{\partial x}{\partial t}
$$


# Выполнение лабораторной работы

## Выполнение в Julia

### Колебания гармонического осциллятора без затуханий и без действий внешней силы

___

На языке Julia я описал систему дифференциальных уравнений, по которой затем построил график решений и график  фазового портрета для каждого из трёх случаев. 



```julia
using Plots
using DifferentialEquations

const x0 = 0.5
const y0 = -1.5

u0 = [x0, y0]
time = [0.0, 59.0]

a = 0
b = 5.2

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
    title = "case 1 without outside forces impact and attenuation"
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
    title = "case 1 without outside forces impact and attenuation"
        )

plot!(
    plt2,
    X,
    Y,
    color=:red,
    label = "phasal portrait"
)

savefig(plt2,"plot-2.png")
```

###  Полученные графики

___

В результате работы программы получились следующие графики. По фазовому портрету можно заметить, что система не теряет энергию

(рис. @fig:001).

![График](plot-411.png)

![Фазовый портрет](plot-412.png){#fig:001 width=70%}

### Колебания гармонического осциллятора c затуханием и без действий внешней силы 

___

Для создания этой модели, изменим систему уравнений 

```julia
a = 14
b = 0.5

function F(du, u, p, t)
    du[1]=u[2]
    du[2]= -a*u[2]-b*u[1]
end
```

### Полученный графики

___

В результате получаем два графика (рис. @fig:002).


![График](plot-421.png)

![Фазовый портрет](plot-422.png){#fig:002 width=70%}

### Колебания гармонического осциллятора c затуханием и под действием внешней силы

___

Для создания этой модели, изменим систему уравнений 

```julia
function F!(du, u, p, t)
function F(du, u, p, t)
    du[1]=u[2]
    du[2]= 0.8*sin(9*t)-a*u[2]-b*u[1]
end
```

### Полученный графики

___

В результате получаем два графика  (рис. @fig:003).


![График](plot-431.png)

![Фазовый портрет](plot-432.png){#fig:003 width=70%}


# Выводы

В результате работы мне удалось построить графики решений и фазовых портретов для всех трёх случаев в обоих средах. 

# Список литературы{.unnumbered}

::: {#refs}
:::
