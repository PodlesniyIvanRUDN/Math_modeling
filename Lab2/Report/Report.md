---
## Front matter
title: "Oтчёт по лабораторной работе №2"
subtitle: "Вариант 32"
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
mainfont: Open Sans
romanfont: Open Sans
sansfont: Open Sans
monofont: Open Sans
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

# Введение

Математи́ческая моде́ль — математическое представление реальности[1], один из вариантов модели как системы, исследование которой позволяет получать информацию о некоторой другой системе. Математическая модель, в частности, предназначена для прогнозирования поведения реального объекта, но всегда представляет собой ту или иную степень его идеализации.

Математи́ческим моделированием называют как саму деятельность, так и совокупность принятых приёмов и техник построения и изучения математических моделей. 

# Цель работы

1. Запишите уравнение, описывающее движение катера, с начальными условиями для двух случаев (в зависимости от расположения катера относительно лодки в начальный момент времени).
2. Постройте траекторию движения катера и лодки для двух случаев.
3. Найдите точку пересечения траектории катера и лодки

Для данной задачи: 
- На море в тумане катер береговой охраны преследует лодку браконьеров. Через определенный промежуток времени туман рассеивается, и лодка обнаруживается на расстоянии 11,5 км от катера. Затем лодка снова скрывается в тумане и уходит прямолинейно в неизвестном направлении. Известно, что скорость катера в 3,5 раза больше скорости браконьерской лодки

Вариант вычислялся по формуле номер ст.билета % кол-во заданий. Результатом стало число n % 70 = 32

# Ход работы

1. Установили Julia, используя пакет apt ```bash sudo apt-get install julia```, и внутренний пакет Plots, используя команду ```julia using Pkg; Pkg.add("Plots")```.

2. Вычислили расстояние между лодкой (браконьеров) и катером (охрана), используя формулу $\frac{x}{\nu} = \frac{s \pm  x}{k*\nu}$, где s = начальное расстояние между лодкой и катером равный 14.4 км и k = коэффициент во сколько раз скорость катера выше чем скорость лодки. В итоге получили значения $x_1 = \frac{11.5}{4.5}$ и $x_2 = \frac{11.5}{2.5}$

3. Полагая, что катер береговой охраны окажется на одном расстоянии от полюса, что и лодка, он должен сменить прямолинейную траекторию и
начать двигаться вокруг полюса удаляясь от него со скоростью лодки $\nu$. Для этого скорость катера раскладываем на две составляющие: $\nu_r$ - радиальная скорость и $\nu_t$ - тангенциальная скорость. $\nu_r = \frac{dr}{dt}$. Нам нужно, чтобы эта скорость была равна скорости лодки, поэтому полагаем $\frac{dr}{dt} = \nu$. Тангенциальная скорость – это линейная скорость вращения катера относительно полюса. Она равна произведению угловой скорости $\frac{d\theta}{dt}$ на радиус, то есть $\nu_t = r \frac{d\theta}{dt}$. Отсюда, используя теорему Пифагора находим $\nu_t$, которая равна $\sqrt{(k*\nu)^2 - \nu^2}$. В данном варианте получаем $\nu_t = \sqrt{11.25} \nu$.

4. Решение исходной задачи сводится к решению системы из двух дифференциальных уравнений $\left\{ \begin{array}{cl}\frac{d\nu}{dt} = \nu \\ r\frac{d\theta}{dt} = \sqrt{11.25}\nu \end{array}\right.$. После интегрирования получаем r = $C e^{\frac{\theta}{\sqrt{11.25}}}$

5. Переписываем все в julia и получаем
```julia
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
```

6. Результат случая s + x (рис. [-@fig:001])

![Результат при случае s + x](Case-1.png){ #fig:001 width=70% }

7. Результат случая s - x (рис. [-@fig:002])

![Результат при случае s - x](Case-2.png){ #fig:002 width=70% }

# Вывод

Во время выполнения лабораторной работы, мы получили базовые знания работы с julia и математическим моделированием.

