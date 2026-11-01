#import "template.typ": *

#show: toc-template.with(
  title: [计算理论课程前瞻],
  date: datetime(year: 2026, month: 10, day: 24),
)

= 课程介绍

== 课程介绍

核心问题：计算机的基本能力和局限性是什么？

三个主要分支
- 自动机理论与形式语言（计算模型）
- 可计算性理论
- 计算复杂性理论

// Public-domain originals; labels are typeset independently.
#let branch-image(body, caption) = align(center, stack(
  dir: ttb,
  spacing: 5mm,
  box(width: 58mm, height: 30mm, align(center + horizon, body)),
  text(size: 14pt, caption),
))

#align(center, grid(
  columns: (58mm, 58mm, 58mm),
  column-gutter: 6mm,
  align: center,
  branch-image(image("images/preview/dfa.svg", width: 25mm), [Automata\ theory]),
  branch-image(image("images/preview/wang-tiles.svg", width: 25mm), [Computability\ theory]),
  branch-image(text(size: 18pt)[$P = N P$ ?], [Computational\ complexity theory]),
))

== 教学安排

- 课程
  - 周六 13:30-15:00，两周一次，共四次
  - 线下授课，钉群同步直播
  - 以知识点总结和习题讲解为主

- 答疑
  - 期末周复习时全天线下辅导
  - 听课 < 线上讨论 < 线下讨论；询问 AI

#context {
  set text(size: 12pt)
  set block(above: 10pt, below: 0pt)
  figure(
    image("images/preview/learn-math.png", width: 88%),
    caption: link("https://www.bilibili.com/video/BV1HBnH6JEAZ")[3Blue1Brown],
    supplement: none,
    numbering: none,
    gap: 1mm,
  )
}

== 相关资料

- 课件
  - https://codeberg.org/LoctStrider/ZJU-2025AW-Theory-of-Computation-Peer-Tutoring
- 学长笔记
  - https://note.tonycrane.cc/cs/tcs/toc/
  - https://xuan-insr.github.io/other_courses/theory_of_computation/
- 25 年聚众复习整理的资料 & 笔记

= 内容概览

== 语言、自动机与正则表达式

- *符号集 $Sigma$*：有限个符号组成的集合
- *字符串 $w$*：由符号集中符号组成的有限序列
  - 空串：$e$ 或 $epsilon$
  - $Sigma^*$：由 $Sigma$ 中符号组成的所有字符串的集合
  - $Sigma^+$：由 $Sigma$ 中符号组成的非空字符串的集合
  - $Sigma^n$：由 $Sigma$ 中符号组成的长度为 $n$ 的字符串集合
  - 运算
    - 连接：$w_1 w_2$ 或 $w_1 compose w_2$
    - 反转：$w^R$
    - 重复：$w^k$
    - 字符串长度：$|w|$

---

- *语言 $L$*：字符串的集合，$L subset.eq Sigma^*$
  - 空语言：$emptyset$
  - 包含空串的语言：${epsilon}$
  - 运算
    - 并集 $L_1 union L_2$，交集 $L_1 inter L_2$，差集 $L_1 - L_2$
    - 连接：$L_1 L_2 = {w_1 w_2 | w_1 in L_1, w_2 in L_2}$
    - $L^* = L^0 union L^1 union L^2 union ...$
    - $L^+ = L L^*$

- 字符集上的语言大小可数
- 字符集上的语言数量不可数

---

- *确定性有限自动机 (DFA)*：五元组 $M = (K, Sigma, delta, s, F)$
  - $K$：有限状态集合
  - $Sigma$：输入符号集
  - $delta$：状态转移函数，$delta: K times Sigma arrow K$
  - $s$：初始状态，$s in K$
  - $F$：接受状态集合，$F subset.eq K$

#figure-automaton(
  (
    q0: (q1: "a", q4: "b"),
    q1: (q2: "b", q4: "a"),
    q2: (q3: "a", q4: "b"),
    q3: (q1: "a", q2: "b"),
    q4: (q4: "a,b"),
  ),
  final: ("q0", "q2", "q3"),
  layout: (
    q0: (0, 0),
    q1: (3, 0),
    q2: (6, 0),
    q3: (9, 0),
    q4: (3, -3),
  ),
  style: (
    q0-q1: (curve: 0, label: (dist: -0.33)),
    q1-q2: (curve: 0, label: (dist: -0.33)),
    q2-q3: (curve: 0, label: (dist: -0.33)),
    q0-q4: (curve: 0),
    q1-q4: (curve: 0),
    q2-q4: (curve: 0),
    q4-q4: (anchor: right),
    q3-q1: (curve: -1.5, label: (dist: -0.33)),
  ),
)

---

- *非确定性有限自动机 (NFA)*：五元组 $M = (K, Sigma, Delta, s, F)$
  - $Delta$：状态转移集合，$Delta: K times (Sigma union {epsilon}) times K$

#image("images/preview/nfa.png", height: 50%)

- DFA 和 NFA 等价，合称为有限自动机 (FA)
- DFA 最简化

---

- *正则表达式*：$Sigma union {(,),union,*,emptyset}$ 上的字符串
  - $emptyset$ 和 $a$（$a in Sigma$）是正则表达式
  - 如果 $r_1$ 和 $r_2$ 是正则表达式，则 $(r_1 union r_2)$、$(r_1 r_2)$ 和 $(r_1^*)$ 也是正则表达式
  - 不符合以上规则的字符串不是正则表达式
  - 所有正则表达式的集合：$cal(R)$
- *正则语言 $cal(L)(a)$*：$a in cal(R)$ 所表示的语言
  - $cal(L)(alpha beta) = cal(L)(alpha)cal(L)(beta)$
  - $cal(L)(alpha union beta) = cal(L)(alpha) union cal(L)(beta)$
  - $cal(L)(alpha^*) = cal(L)(alpha)^*$

---

- *闭包性质*：设 $L_1, L_2 subset.eq Sigma^*$ 均为正则语言，则
  - 并集：$L_1 union L_2 = {w: w in L_1 "or" w in L_2}$ 是正则语言
  - 交集：$L_1 inter L_2 = {w: w in L_1 "and" w in L_2}$ 是正则语言
  - 补集：$overline(L_1) = Sigma^* - L_1$ 是正则语言
- *等价性*：$L$ 是正则语言 $arrow.l.r$ $L$ 可由某个 FA 接受
  - NFA $arrow$ DFA：子集构造法，Exponential
  - 正则语言 $arrow$ NFA：Thompson 构造，Polynomial
  - DFA $arrow$ 正则语言：状态消除法

---

- Pumping Theorem：令 $L$ 是一个正则语言，存在一个整数 $p >= 1$，使得对于任意字符串 $w in L$，如果 $|w| >= p$，则存在字符串 $x, y, z$，使得
  - $w = x y z$
  - $|x y| <= p$
  - $|y| >= 1$
  - $forall i >= 0$，都有 $x y^i z in L$
- 一般用来证明某语言不是正则语言
- 不存在一般方法证明语言是 / 不是正则的
- 几何直观：FA 上成环 $arrow$ 环可任意多次复制

== 上下文无关文法与下推自动机

- *上下文无关文法 (CFG)*：四元组 $G=(V, Sigma, R, S)$
  - $V$：符号集
  - $Sigma$：终结符集合，$Sigma subset.eq V$
  - $S$：开始符号，$S in V-Sigma$
  - $R$：产生式集合，$R subset.eq (V-Sigma) times V^*$
  - 例：
    - $S -> S S$
    - $S -> ( S )$
    - $S -> epsilon$
- *Chomsky Normal Form (CNF)*：每条产生式形如 $A -> B C$ 或 $A -> a$ 或 $S -> epsilon$

---

- *解析树*：表示 CFG 推导过程的树形结构

#figure(diagram(spacing: 1em, {
  node((3, 0), name: <A>)[$S$]
  node((1, 1), name: <B>)[$S$]
  node((5, 1), name: <C>)[$S$]
  node((0, 2), name: <D>)[(]
  node((1, 2), name: <E>)[$S$]
  node((2, 2), name: <F>)[)]
  node((4, 2), name: <G>)[(]
  node((5, 2), name: <H>)[$S$]
  node((6, 2), name: <I>)[)]
  node((0, 3), name: <J>)[(]
  node((1, 3), name: <K>)[$S$]
  node((2, 3), name: <L>)[)]
  node((5, 3), name: <M>)[$e$]
  node((1, 4), name: <N>)[$e$]
  edge(<A>, <B>)
  edge(<A>, <C>)
  edge(<B>, <D>)
  edge(<B>, <E>)
  edge(<B>, <F>)
  edge(<C>, <G>)
  edge(<C>, <H>)
  edge(<C>, <I>)
  edge(<E>, <J>)
  edge(<E>, <K>)
  edge(<E>, <L>)
  edge(<H>, <M>)
  edge(<K>, <N>)
}))

---

- *下推自动机 (PDA)*：六元组 $P = (K, Sigma, Gamma, Delta, s, F)$
  - $Gamma$：栈符号集
  - $Delta$：状态转移集合，$Delta: (K times (Sigma union {epsilon}) times Gamma^*) times (K times Gamma^*)$
  - NFA + 栈

---

- *闭包性质*：设 $L_1, L_2 subset.eq Sigma^*$ 均为上下文无关语言，则
  - $L_1 union L_2$、$L_1 L_2$、$L_1^*$ 均为上下文无关语言
  - $L_1 inter L_2$、$overline(L_1) = Sigma^* - L_1$ 不一定是上下文无关语言
  - 若 $R subset.eq Sigma^*$ 是正则语言，则 $L_1 inter R$ 是上下文无关语言
- *等价性*：$L$ 是上下文无关语言 $arrow.l.r$ $L$ 可由某个非确定性 PDA 接受
  - CFG $arrow$ PDA：朴素构造
  - PDA $arrow$ CFG：规范化后构造；可以读读书上证明
- 确定性 PDA 与非确定性 PDA 不等价
  - $L = {w w^R: w in {a, b}^*}$
  - 需要非确定性地猜测中点

---

- Pumping Theorem：令 $L$ 是一个上下文无关语言，存在一个整数 $p >= 1$，使得对于任意字符串 $w in L$，如果 $|w| >= p$，则存在字符串 $u, v, x, y, z$，使得
  - $w = u v x y z$
  - $|v x y| <= p$
  - $|v y| >= 1$
  - $forall i >= 0$，都有 $u v^i x y^i z in L$
- 同样用于证明某语言不是上下文无关语言
- 同样不存在一般方法
- 几何直观：非终结符成环 $arrow$ 此非终结符左右可任意复制

== 图灵机与递归可数语言

- *停机（Halting）*：程序在给定输入上执行有限步后终止
- *停机问题*：给定程序 $M$ 及输入 $w$，判断 $M$ 在 $w$ 上是否停机

---

- *确定性图灵机 (DTM)*：五元组 $M = (K,Sigma,delta,s,H)$
  - $Sigma$：符号集，包含特殊符号 $triangle.stroked.r$（纸带左端）和 $bracket.b$
  - $delta$：状态转移函数，$delta: (K-H) times Sigma -> K times ({<-, ->} union (Sigma - {triangle.stroked.r}))$
  - $H$：停机状态集合，$H subset.eq K$
  - *半判定（semidecide）*：对于语言 $L$，存在 DTM $M$，使得对于任意输入 $w$，当且仅当 $w in L$ 时，$M$ 停机并接受 $w$
  - *判定（decide）*：对于语言 $L$，存在 DTM $M$，使得对于任意输入 $w$，$M$ 停机并接受当且仅当 $w in L$，否则停机并拒绝 $w$

---

- *非确定性图灵机 (NTM)*：五元组 $M = (K,Sigma,Delta,s,H)$
  - $Delta$：状态转移集合，$Delta: ((K-H) times Sigma) times (K times ({<-, ->} union (Sigma - {triangle.stroked.r})))$
  - 半判定：存在一个分支停机
  - 判定：所有分支停机且存在一个分支进入接受状态
- NTM 和 DTM 等价
- 其他图灵机变种：多带图灵机、多头图灵机等
  - 均与标准图灵机等价

---

- *无限制文法（Unrestricted Grammar）*：四元组 $G = (V, Sigma, R, S)$
  - $V$：有限符号集；$Sigma subset.eq V$：终结符集合；$S in V-Sigma$：开始符号
  - $R$：有限产生式集合，规则形如 $alpha -> beta$
    - $alpha in V^*(V-Sigma)V^*$：左部至少包含一个非终结符
    - $beta in V^*$：右部为任意符号串，可以为空串
  - 一步推导：若 $(alpha -> beta) in R$，则 $x alpha y =>_G x beta y$
- *递归可数（Recursively Enumerable, RE）*：语言 $L$ 被 DTM 半判定
  - 等价：存在无限制文法 $G$，使得 $L = L(G)$
- *递归（Recursive）*：语言 $L$ 被 DTM 判定

---

- *闭包性质*：设 $L_1, L_2 subset.eq Sigma^*$，补集相对于 $Sigma^*$ 定义
  - 若 $L_1, L_2$ 均递归，则 $L_1 union L_2$、$L_1 inter L_2$、$overline(L_1)$、$L_1 L_2$、$L_1^*$ 均递归
  - 若 $L_1, L_2$ 均递归可数，则 $L_1 union L_2$、$L_1 inter L_2$、$L_1 L_2$、$L_1^*$ 均递归可数
  - $L_1$ 递归可数不保证 $overline(L_1)$ 递归可数
- $L$ 递归 $arrow.l.r$ $L$ 与 $overline(L)$ 均递归可数

---

- *可计算函数*：将输入和输出编码为自然数，输入 $x in NN^k$，输出 $f(x) in NN$
  - *全可计算*：存在图灵机 $M$，对每个输入 $x$ 都停机并输出 $f(x)$
  - *部分可计算*：$f(x)$ 有定义时，$M$ 停机并输出该值；否则不停机
- *原始递归函数（Primitive Recursive）*
  - 全可计算函数的组合；允许限定边界的循环
- *$mu$-递归函数*
  - 进一步允许无界最小化，相当于引入不限定边界的循环
  - $mu$ 主要是使得函数有了和图灵机相等的能力；是否可判定需要进一步分析

---

- 递归 $arrow.l.r$ 可判定 $arrow.l.r$ 全可计算
- 递归可数 $arrow.l.r$ 半可判定 $arrow.l.r$ 部分可计算
- 原始递归函数更弱

== 判定问题

- *编码*：将图灵机、自动机、若干字符串等对象通过计算表示为字符串
  - 语言不一定能编码：可计算函数集可数，语言可能不可数
- *通用图灵机 (UTM)*：接受图灵机编码 $M$ 和字符串 $w$ 作为输入，模拟图灵机 $M$ 在输入 $w$ 上的运行
- 图灵机可以在运行时写下自身的编码
- *可判定问题*：将问题实例编码为字符串，构成语言 $L$，存在图灵机判定 $L$
- *停机问题*：输入图灵机编码 $M$ 和字符串 $w$，判定 $M$ 在输入 $w$ 时是否停机
  - 不可判定

---

- *可判定（Decidable）*：对任何输入停机
- *可半判定但不可判定*：停机问题。判断程序是否停机
  - 对属于此语言的输入停机
- *不可半判定*：判断程序是否永不停机
  - 对属于此语言的输入也不停机
- 后两类均为 *不可判定（Undecidable）*

---

- 规约 $A <= B$：存在可计算函数 $f : Sigma^* -> Sigma^*$ 使得对于任意字符串 $w$，$w in A$ 当且仅当 $f(w) in B$
  - $B$ 可判定 $arrow$ $A$ 可判定
  - $A$ 不可判定 $arrow$ $B$ 不可判定

== 计算复杂性理论

- $P$：标准确定性图灵机在多项式时间内停机的语言集合
- $N P$：标准非确定性图灵机在多项式时间内判定的语言集合
  - 等价：标准确定性图灵机在多项式时间内可判定的语言集合
- 多项式归约 $A <=_P B$：语言 $A$ 多项式时间归约到语言 $B$
  - 存在多项式时间可计算的函数 $f$，使得对于任意输入 $w$，$w in A$ 当且仅当 $f(w) in B$
- $N P$-完全：$N P$ 中的语言 $C$，满足对于任意 $A in N P$，都有 $A <=_P C$
  - $A in N P C$, $B in N P$, $A <=_P B$ $arrow$ $B in N P C$
  - 代表：SAT 问题，极大团问题，顶点覆盖问题等

---

- $A in P$, $B in P$ $arrow$ $A B in P$
- $A in N P$, $B in N P$ $arrow$ $A B in N P$
- $A in P$ $arrow$ $overline(A) in P$
