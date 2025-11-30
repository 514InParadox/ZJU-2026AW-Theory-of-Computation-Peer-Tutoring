#import "@preview/touying:0.6.1": *
#import themes.university: *

#import "@preview/theorion:0.4.0": *
#import cosmos.clouds: *
#show: show-theorion

#import "@preview/numbly:0.1.0": numbly

#import "@preview/finite:0.5.0": automaton, layout
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let aligned-terms(it) = {
  show terms: it => grid(
    columns: 2, row-gutter: .8em, column-gutter: .6em, align: (left, left),
    ..it.children.enumerate().map(((i, item)) => ([*#item.term*], item.description)).flatten()
  )
  it
}

#let toc-template(title: [Title], date: datetime.today(), doc) = {
  show sym.lt.eq: math.scripts
  show sym.arrow.double: math.scripts
  show sym.tack.r: math.scripts

  set text(font: "Dream Han Serif")

  show: university-theme.with(
    aspect-ratio: "16-9",
    config-info(
      title: title,
      subtitle: [2025 年秋冬学期计算机学院朋辈辅学计算理论],
      author: [Loct Strider],
      date: date,
      institution: [浙江大学],
      logo: [],
    ),
  )

  set heading(numbering: numbly("{1}.", default: "1.1"))

  title-slide()

  doc
}

#let figure-automaton(caption: none, ..args) = figure(
  {
    set text(font: "libertinus serif")
    automaton(..args)
  },
  caption: caption,
)

// #let figure-turing-machine(style: (:), ..args) = {
//   style += (
//     state: (
//       stroke: 0pt + black,
//       initial: (stroke: 1pt + black),
//     ),
//   )
//   figure-automaton(
//     style: style,
//     ..args,
//   )
// }

#let cfg = (
  yield: $arrow.double_G$,
)

#let pda = (
  yield: $tack.r_M$,
)

#let tm = (
  start: "\u{25B9}",
  // blank: "\u{2423}",
  blank: "\u{2294}",
  yield: $tack.r_M$,
)
