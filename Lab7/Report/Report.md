---
## Front matter
title: "Отчет по лабораторной работе №7"
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

Рассмотреть модель рекламной компании. Выполнить задание согласно варианту: построить график распространения рекламы, математическая модель которой описывается заданным уравнением (три случая), определить в какой момент времени скорость распространения рекламы будет иметь максимальное значение.

# Задание

**Вариант № 32**:

Построить график распространения рекламы, математическая модель которой описывается следующим уравнением: 

1. $\frac{dn}{dt}=(0.54+0.00016n(t))(N-n(t))$

2. $\frac{dn}{dt}=(0.000021+0.38n(t))(N-n(t))$

2. $\frac{dn}{dt}=(0.2\cos(t)+0.2\cos(2t)n(t))(N-n(t))$

При этом объем аудитории $N=609$, в начальный момент о товаре знает $4$ человек. Для
случая 2 определить в какой момент времени скорость распространения рекламы будет
иметь максимальное значение.


# Теоретическое введение

Модель проведения рекламной кампании – это сочетание параметров, показателей, технологий и процедур, которые представляют собой схему проведения рекламных мероприятий 

Фирма начинает рекламировать новый товар или услугу. Естественно, прибыль от будущих продаж должна значительно покрывать издержки на рекламную кампанию. При этом вначале расходы могут превышать прибыль, поскольку лишь малая часть потенциальных покупателей будет информирована о новинке. Затем, при увеличении числа продаж, появляется возможность рассчитывать на заметную прибыль. Наконец, наступит момент, когда рынок насытится, и рекламировать товар далее станет бессмысленно .

Предположим, что торговыми учреждениями реализуется некоторая продукция, о которой в момент времени $t$
из числа потенциальных покупателей
$N$ знает лишь $n$ покупателей. Для ускорения сбыта продукции запускается реклама по радио, телевидению и других средств массовой информации. После запуска рекламной кампании информация о продукции начнет распространяться среди
потенциальных покупателей путем общения друг с другом. Таким образом, после
запуска рекламных объявлений скорость изменения числа знающих о продукции
людей пропорциональна как числу знающих о товаре покупателей, так и числу
покупателей о нем не знающих.

Модель рекламной кампании описывается следующими величинами. Считаем, что $\frac{dn}{dt}$ - скорость изменения со временем числа потребителей,
узнавших о товаре и готовых его купить,
$t$ - время, прошедшее с начала рекламной
кампании, $n(t)$ - число уже информированных клиентов. Эта величина
пропорциональна числу покупателей, еще не знающих о нем, это описывается
следующим образом: $\alpha_1(t)(N-n(t))$ где $N$ - общее число потенциальных
платежеспособных покупателей,
$\alpha_1(t)>0$ - характеризует интенсивность
рекламной кампании (зависит от затрат на рекламу в данный момент времени).
Помимо этого, узнавшие о товаре потребители также распространяют полученную
информацию среди потенциальных покупателей, не знающих о нем (в этом случае
работает т.н. сарафанное радио). Этот вклад в рекламу описывается величиной
$\alpha_2(t)n(t)(N-n(t))$, эта величина увеличивается с увеличением потребителей
узнавших о товаре. Математическая модель распространения рекламы описывается
уравнением:

$\frac{dn}{dt}=(\alpha_1(t)+\alpha_2(t)n(t))(N-n(t))$ {#eq:01}

При $\alpha_1(t)>\alpha_2(t)$
получается модель типа модели Мальтуса, В обратном случае, при $\alpha_1(t)<\alpha_2(t)$ получаем уравнение логистической
кривой.

# Выполнение лабораторной работы

1. Напишем код для первого случая на Julia:

```
using Plots
using DifferentialEquations

N = 609
n0 = 4
a1 = 0.54
a2 = 0.00016

u0 = [n0]

time = [0.0, 60.0]

function F(du, u, p, t)
    du[1] = (a1 + a2*u[1])*(N - u[1])
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
    title = "Модель рекламной компании сл-1"
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


savefig(plt1, "first.png")


```

2. Видим результат, полученный для первого случая с помощью Julia (рис. @fig:001)

![График распространения информации о товаре для первого случая (Julia)](first.png){#fig:001 width=70%}

3. Напишем код для второго случая на Julia:

```
using Plots
using DifferentialEquations

N = 609
n0 = 4
a1 = 0.000021
a2 = 0.38

u0 = [n0]

time = [0.0, 60.0]

function F(du, u, p, t)
    du[1] = (a1 + a2*u[1])*(N - u[1])
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
    title = "Модель рекламной компании сл-2"
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


savefig(plt1, "second.png")



```

4. Видим результат, полученный для второго случая с помощью Julia (рис. @fig:002)

![График распространения информации о товаре для второго случая (Julia)](second.png){#fig:002 width=70%}

5. Напишем код для третьего случая на Julia:

```
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


```

6. Видим результат, полученный для третьего случая с помощью Julia (рис. @fig:003)

![График распространения информации о товаре для третьего случая (Julia)](third.png){#fig:003 width=70%}

# Выводы

Я рассмотрел модель рекламной компании. Выполнил задание согласно варианту: построил график распространения рекламы, математическая модель которой описывается заданным уравнением (три случая), определил в какой момент времени скорость распространения рекламы будет иметь максимальное значение.

# Список литературы{.unnumbered}

::: {#refs}
:::
