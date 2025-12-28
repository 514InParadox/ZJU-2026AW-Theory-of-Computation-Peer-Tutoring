#import "template.typ": *

#import "@preview/cetz:0.4.0"
#import "@preview/cetz-venn:0.1.4"

#show: toc-template.with(
  title: [2023-2024 学年真题讲解],
  date: datetime(year: 2025, month: 12, day: 28),
)

= 判断题

#let correct = sym.checkmark.light
#let wrong = sym.crossmark

==

The set of all regular languages over the alphabet ${a, b}$ is countable.
#pause #correct

${L : L subset {a,b}^*, "regular"(L)} = {L(R) : R "is a regexp over" {a,b}}$

某一字符集上的正则表达式组成的集合是 CFL #sym.arrow.double 可数

==

Let $Sigma = emptyset$, some language over $Sigma$ is not empty. #pause #correct

$L = {e}$

==

Let $L_1, L_2$ and $L_3$ be some recursively enumerable languages,
then $L_1 L_2 inter L_3^*$ must be recursively enumerable. #pause #correct

RE 语言对并、连接、星号、交运算封闭，对补不封闭

==

Let $L_1$ be a regular language, $L_3$ be a context-free language.
For any language $L_2 subset.eq L_3 - L_1$,
although $L_2$ may not be regular, it must be context-free. #pause #correct

$L_3 - L_1 = L_3 inter overline(L_1)$

$"context-free"(L_3) and "regular"(overline(L_1)) -> "context-free"(L_3 inter overline(L_1))$

"may not be regular": $L_1 = emptyset and not "regular"(L_3) -> not "regular"(L_2)$

==

Let $L_1$ and $L_2$ be some recursively enumerable languages,
then $L_1 plus.o L_2$ must be recursively enumerable.
Recall that $A plus.o B = (A union B) - (A inter B)$. #pause #wrong

RE 语言对补不封闭 #sym.arrow 对差不封闭

#pause

取 $L_1 = Sigma^*$，有 $L_1 plus.o L_2 = overline(L_2)$

$(forall L_2 subset Sigma^*, "RE"(L_2) -> "RE"(L_1 plus.o L_2)) -> \ (forall L_2 subset Sigma^*, "RE"(L_2) -> "RE"(overline(L_2)))$

取 $L_2 = H$，矛盾

==

Let $w$ be some string over $(Sigma - {tm.start, tm.blank})$.
The following Turing machine transforms $underline(tm.blank) w tm.blank$
to $tm.blank w underline(tm.blank)$. #only("2-")[#correct]

// TODO layout does not converge (why?)
#figure(
  diagram(
    spacing: 2em,
    node((0, 0), name: <A>)[$R$],
    node((1, 0), name: <B>)[$tm.blank R_tm.blank tm.blank L_tm.blank a$],
    edge((-1, 0), <A>, "->")[],
    edge(<A>, <B>, "->", label-sep: 0pt)[$a != tm.blank$],
    edge(<B>, (1.75, 0), "u", (0, -1), <A>, "->"),
  ),
)

#pause

归纳证明第 $i$ 次执行过 $R$ 之后：
- 纸带内容和初始状态相同
- 读写头位于 $tm.blank w tm.blank$ 中的第 $i+1$ 个字符
- $a != tm.blank$ 当且仅当 $i <= |w|$

$i = |w|+1$ 时停机且纸带内容不变

==

The set of all numerical functions is uncountable, but the set of all $mu$-recursive functions is countable. #pause #correct

"set of all numerical functions" #sym.arrow.double $cal(P)(NN)$，不可数

$mu$-recursive functions #sym.arrow.double 图灵机，可数

==

Let $A$ be some language. Suppose that $A <= overline(A)$, it is impossible that $A$ is not recursive but recursively enumerable. #pause #correct

$"RE"(A) and (A <= overline(A)) -> "RE"(overline(A))$

$"RE"(A) and "RE"(overline(A)) -> "recursive"(A)$

= 不定项选择题

// modified from https://forum.typst.app/t/how-to-layout-nested-enum-in-two-columns/4873
#let choices(body, columns: 1) = {
  set enum(numbering: "A.")
  let sub-item-counter = counter("sub-item")
  sub-item-counter.update(0)
  let numbered-children = body
    .children
    .filter(c => c.has("body"))
    .map(c => {
      sub-item-counter.step()
      context sub-item-counter.display("A. ")
      c.body
    })
  grid(
    columns: (1fr,) * columns,
    row-gutter: 0.8em,
    ..numbered-children.flatten(),
  )
}

==

Choose the languages that may not be regular: #only("2-")[AB]

#choices[
  + the union of an infinite number of regular languages
  + ${w: w in {a, b}^* and w != w^R}$
  + ${a^i b^j c^k: i + j eq.triple.not k space (mod 2023)}$
  + ${w v w^R: w in {a, b}^+ and v in {a, b}^*}$ (${a, b}^+ = {a, b}^* - {e}$)
]

#pause

- A 能凑任何语言
- B, C 讲过
- D 项看着不像正则语言，但证明不了
  - 对于 $w in L_D$，$w$ 和 $v$ 的解析方式往往不止一种
  - $|w| > 1$ 的情况被 $|w| = 1$ 包含，枚举首尾字符构造正则表达式

==

$L_1, L_2$ are context-free languages.
Which of the following languages must be context-free? #only("2-")[D]

#choices(columns: 4)[
  + $L_1 inter L_2$
  + $overline(L_1)$
  + $L_1 plus.o L_2$
  + $L_1^* L_2^*$
]

#pause

CFL 对并、连接、星号、反转封闭，对交、补、差不封闭

如果对异或封闭，那么对 $overline(L) = Sigma^* plus.o L$ 也封闭，矛盾

==

Choose the languages that may not be context-free. #only("2-")[D]

#choices[
  + ${a^m b^n c^p: m=n or n=p or p=m}$
  + ${a^m b^n c^p: m != n or n != p or p != m}$
  + $L - R$, where $L$ is context-free and $R$ is regular
  + $R - L$, where $L$ is context-free and $R$ is regular
]

#pause

- A,B 直接把条件拆开构造，C 是 CFL 的运算性质
- D 取 $R = Sigma^*$，$R - L = overline(L)$

==

Choose true statements. #only("2-")[AB]

#choices[
  + Any recursive language must be recursively enumerable
  + The class of recursively enumerable languages is closed under intersection
  + If a language satisfies the pumping theorem, it must be regular
  + If a language $L$ is recursively enumerable, so is $overline(L)$
]

#pause

- 正则语言 #sym.subset CFL #sym.subset 递归语言 #sym.subset RE 语言
- Pumping theorem 的定义（正则语言的必要不充分条件）

= 大题

==

判断以下两个语言是否正则并证明

+ $A = {1^k y: y in {0, 1}^* and y "contains at most" k "1's" and k >= 1}$
+ $B = {1^k y: y in {0, 1}^* and y "contains at least" k "1's" and k >= 1}$

#pause

看着不像正则语言，套 Pumping theorem

- $A$：构造 $w = 1^p 0 1^p$ 可证不是正则语言
- $B$：似乎构造不动，尝试往是正则语言的方向处理 #pause
  - 同一字符串的解析方式不唯一
  - $k > 1$ 的情况被 $k = 1$ 包含
  - $B = {1 y: y in {0, 1}^* and y "contains at least single" 1}$
  - 直接构造 DFA

==

Design a context-free grammar that generates
${w w^R c a^n b^m: w in {a, b}^*, n > m, n "is even", m "is odd"}$
over ${a, b, c}$. #pause

明显分成 $w w^R$ 和 $a^n b^m$ 两部分处理
- $S -> S_1 c S_2$
- $w w^R$：$S_1 -> e | a S_1 a | b S_1 b$ #pause
- $a^n b^m$：分成 $a^m b^m$ 和 $a^(n-m)$ 两步
  - 把数量较少的 $m$ 转为偶数：$S_2 -> a S'_2 b$
  - 完成 $m$ 的构造：$S'_2 -> A | a a S'_2 b b$
  - 剩余的 $n-m$ 为奇数，转为偶数：$A -> a A'$
  - $A' -> e | a a A'$

==

#[
  #set text(size: 20pt)
  Let $"RE"$ be the set of all recursively enumerable languages.
  Let $"co-RE" = {A: overline(A) "is recursively enumerable"}$.

  Consider the following Venn diagram, which zone do $H, H_1, overline(H), overline(H_1)$ belong? What about $"P"$ and $"NP"$? (Assume that $"P" != "NP"$)

  $H = {encoding(M) encoding(w): M "is a Turing machine that halts on" w}$

  $H_1 = {encoding(M): M "is a Turing machine that halts on" encoding(M)}$

  #figure(
    cetz.canvas({
      import cetz.draw: *

      scale(2)
      cetz-venn.venn2(name: "venn", padding: 0em, not-ab-stroke: none)
      content("venn.a", [$"RE"$])
      content("venn.b", [$"co-RE"$])
    }),
  )
]

---

#[
  #set text(size: 23pt)
  - $"recursive"(A) -> "RE"(A) and "co-RE"(A)$
  - 变形：$not "recursive"(A) and "RE"(A) -> not "co-RE"(A)$
  - $H$ 是经典的非递归但 RE 语言
    - 非递归：构造 $H_d = {encoding(M): M "is a TM that does not halt on" encoding(M)}$
    - RE：直接运行 UTM
  - $H_1 <= H$ #sym.arrow.double $H_1$ 是 RE：对输入的 $encoding(M)$ 构造 $encoding(M) encoding(M)$
  - $H <= H_1$ #sym.arrow.double $H_1$ 非递归：对输入的 $encoding(M) encoding(w)$ 构造 $M'$
    - $M'$ 无视输入直接运行 $M(w)$
  - $"P"$ 和 $"NP"$ 都可计算（递归），既 RE 又 co-RE
]

==

Let $M = (K, Sigma, delta, s, {h})$ be a standard Turing machine.
Assume that whenever $M$ halts, it's always in configuration
$(h, tm.start underline(tm.blank))$.
Describe how to construct a grammar that generates $L(M)$.

#pause

用 $triangle.small$ 表示纸带尾，$(q, tm.start tm.blank w_1 underline(a) w_2)$ 记为 $tm.start tm.blank w_1 a q w_2 triangle.small$

构造 $S => tm.start tm.blank h triangle.small => ... => tm.start tm.blank s w triangle.small => w$

- $tm.start tm.blank s -> e, triangle.small -> e$ 用于最终清理
- 对 $M$ 的所有转移反向构造

==

#[
  #set text(size: 24pt)

  Consider the following languages.
  Are they recursive, recursively enumerable but not recursive,
  or not recursively enumerable? Justify your answer.

  1. $A = {encoding(M): M "is the only Turing machine that semidecides" L(M)}$
  2. $B = {encoding(M): M "is a Turing machine", L(M) "is finite"}$

  #pause

  - 图灵机可以随意添加不可达状态，$A = emptyset$，递归语言 #pause
  - $H <= B$：对输入 $encoding(M) encoding(w)$，构造 ${0, 1}$ 上的 $M'$
    - $M'(x)$：运行 $M(w)$ $x$ 步，停机就拒绝，否则接受 #pause
  - $overline(H) <= B$：对输入 $encoding(M) encoding(w)$ 构造 $M'$
    - $M'(x)$：运行 $M(w)$，结束后接受
  - $B$ 非 RE
]
