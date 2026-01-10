#import "template.typ": *

#show: toc-template.with(
  title: [判定问题],
  date: datetime(year: 2025, month: 12, day: 14),
)

= 判定问题基础

== Church-Turing 公理

一个关于自然数的函数能够用确定性方法在有限时间内计算当且仅当它能被图灵机计算

- 其他类型的问题可以编码到自然数的函数上
  - 例如，对于判定语言问题，把字符串编码到自然数，输出 0/1
- 并非定理

== 编码与可判定问题

#[
  #set text(size: 23pt)
  / 编码: 用某一语言中的字符串来表示某一集合中的元素，可以通过字符串还原出原元素， $O$ 的编码用 $encoding(O)$ 表示
  - 有限集合可编码
  - 有限个有限集合组成的整体可编码，FA、正则表达式、CFG、PDA、TM 都可编码
  / 可判定问题: 被编码得到的语言可判定（递归）的问题
  / 可半判定问题: 被编码得到的语言可半判定（递归可数）的问题
  / 规约 $A <= B$: $A, B$ 为 $Sigma$ 上的语言，存在可计算函数 $f: Sigma^* -> Sigma^*$ 使 $forall w in Sigma^*, w in A <-> f(w) in B$
  - $"recursive"(B) and (A <= B) -> "recursive"(A)$
  - $"RE"(B) and (A <= B) -> "RE"(A)$
]

== 通用图灵机（UTM）

一台（已知编码方法时）特定的图灵机 $U$，能够在输入一台图灵机 $M$ 及其输入 $w$ 的编码时模拟该图灵机的行为

即 $U(encoding(M) encoding(w)) = encoding(M(w))$，$U$ 在 $encoding(M) encoding(w)$ 上停机 #sym.arrow.l.r $M$ 在 $w$ 上停机

构造方法：三带图灵机
- 纸带 1：记录 $M$ 的纸带的编码
- 纸带 2：记录 $encoding(M)$
- 纸带 3：记录当前所处的 $M$ 的状态的编码

== 非 RE 语言

已知：正则语言（regular）#sym.subset 上下文无关语言（context-free）#sym.subset 递归语言（recursive）#sym.subset 递归可数语言（RE）

图灵机的编码可数 #sym.arrow.double 所有 RE 语言组成的集合可数

$|Sigma| >= 2$ 时 $Sigma$ 上的所有语言的集合不可数 #sym.arrow.double 存在非 RE 语言

== 停机问题

语言 $H = {encoding(M) encoding(w) : M "is a TM that halts on" w}$

直接用 UTM 模拟 $M(w)$ #sym.arrow.double $H$ 是 RE 语言

#pause

假设存在一台图灵机能够判定 $H$

#components.side-by-side(
  [
    构造 $M_"diagonal"$：

    #{
      set text(size: 20pt)
      pseudocode-list(title: [$M_"diagonal" (encoding(M))$])[
        + if $encoding(M) encoding(M) in H$
          + infinite loop
        + else
          + halt
      ]
    }
  ],
  [
    令 $w = encoding(M_"diagonal") encoding(M_"diagonal")$

    $w in H$ 和 $w in.not H$ 均不成立

    #sym.arrow.double 假设不成立，$H$ 不是递归语言
  ],
  gutter: 0em,
)

---

正式的证明方法：

- 令 $H_d = {encoding(M) : M "is a TM that does not halt on" encoding(M)}$
- 假设 $H$ 是递归语言，则 $H_d$ 是递归语言
  - 假设 $"RE"(H_d)$ 即存在图灵机 $M$ 半判定 $H_d$
    - $encoding(M) in H_d$ 矛盾
    - $encoding(M) in.not H_d$ 矛盾
  - 假设不成立，$not "RE"(H_d)$
- 假设不成立，$H$ 是非递归语言

== 停机问题变体

$A_1 = {encoding(M) : M "is a TM that halts on" e}$，显然 RE

#pause

对 $H$，构造 $f(encoding(M) encoding(w)) = encoding(M')$，其中：

#[
  #set text(size: 20pt)
  #pseudocode-list(title: $M'(u)$)[
    + run $M(w)$
  ]
]

图灵机编码可计算 #sym.arrow.double $f$ 可计算（$f$ 代表构造 $encoding(M')$ 的过程），且有
$
  encoding(M) encoding(w) in H -> f(encoding(M) encoding(w)) in A_1, encoding(M) encoding(w) in.not H -> f(encoding(M) encoding(w)) in.not A_1
$

因此 $H <= A_1$，$A_1$ 非递归

---

$A_2 = {encoding(M) : M "is a TM that halts on some input"}$ 非递归，RE？

// HACK 分页以避免图灵机编号错误

---

$A_2 = {encoding(M) : M "is a TM that halts on some input"}$ 非递归，RE？

$Sigma^*$ 可数，令其为 $w_1, w_2, ...$

#[
  #set text(size: 20pt)
  #figure(
    pseudocode-list(title: $M'(encoding(M))$)[
      + for $i = 1, 2, ...$
        + for $w = w_1, w_2, ..., w_i$
          + run $M$ on $w$ for $i$ steps
          + if $M$ halts on $w$ within $i$ steps
            + halt
    ],
    caption: [$A_2$ 的构造],
    kind: "turing",
    supplement: "Turing Machine",
  ) <halt-some-input>
]

$M'$ 半判定 $A_2$

---

$A_3 = {encoding(M) : M "is a TM that halts on every input"}$ 非递归，RE？

#pause

$H_d <= overline(H) => not "RE"(overline(H))$

对 $overline(H)$，构造 $f(encoding(M) encoding(w)) = encoding(M')$，其中：

#[
  #set text(size: 20pt)
  #pseudocode-list(title: $M'(encoding(u))$)[
    + if $M$ halts on $w$ in $u$ steps
      + infinite loop
    + else
      + halt
  ]
]

则有 $encoding(M) encoding(w) in overline(H) <-> f(encoding(M) encoding(w)) in A_3$，$overline(H) <= A_3$，$A_3$ 非 RE

= 判定问题

== 证明递归 / RE 的方法

没有通解

证明 $"recursive"(A)$
- 构造判定 $A$ 的图灵机
- $exists B, "recursive"(B) and (A <= B)$
- $"RE"(A) and "RE"(overline(A)) -> "recursive"(A)$
  - 证明：轮流运行两台半判定的图灵机
证明 $not "recursive"(A)$
- 对角化构造
- $exists B, not "recursive"(B) and (B <= A)$

---

证明 $"RE"(A)$
- 构造半判定 $A$ 的图灵机
- $exists B, "RE"(B) and (A <= B)$
证明 $not "RE"(A)$
- $exists B, not "RE"(B) and (B <= A)$
- $
    ("RE"(A) and "RE"(overline(A)) -> "recursive"(A)) \
    <-> (not "recursive"(A) and "RE"(overline(A)) -> not "RE"(A))
  $

== 正则语言的常见问题

- $A_"DFA" = {encoding(D) encoding(w) : D "is a DFA that accepts" w}$
- $A_"NFA" = {encoding(N) encoding(w) : N "is a NFA that accepts" w}$
- $A_"REX" = {encoding(R) encoding(w) : R "is a regular expression that generates" w}$
- $E_"DFA" = {encoding(D) : D "is a DFA", L(D) = emptyset}$
  - 搜索是否有可达的接受状态
- $"EQ"_"DFA" = {encoding(D_1) encoding(D_2) : D_1, D_2 "are DFAs", L(D_1) = L(D_2)}$
  - 构造 $D_1 plus.o D_2 = L(D_1) union L(D_2) - L(D_1) inter L(D_2)$
  - $L(D_1) = L(D_2) <-> D_1 plus.o D_2 = emptyset$
- $"ALL"_"DFA" = {encoding(D) : D "is a DFA that accepts all inputs"}$
  - 构造 $overline(D)$

全部都可判定

== 上下文无关语言的常见问题

- $A_"CFG" = {encoding(G) encoding(w) : G "is a CFG that generates" w}$
- $A_"PDA" = {encoding(P) encoding(w) : P "is a PDA that accepts" w}$
- $E_"CFG" = {encoding(G) : G "is a CFG", L(G) = emptyset}$
  - 迭代计算每一非终结符是否能推导出空串
- $E_"PDA" = {encoding(P) : P "is a PDA", L(P) = emptyset}$

以上可判定

---

#[
  #set text(size: 24pt)
  - $"ALL"_"CFG" = {encoding(G) : G "is a CFG that generates all strings"}$
    - $A_"TM" = {encoding(M) encoding(w) : M "is a TM that accepts" w}$ 不可判定
    - 令 $T_M (C, k) = cases(encoding(C) & "if" k "is odd", encoding(C)^R & "if" k "is even")$，其中 $C$ 为 $M$ 的配置
    - $
        L_M = { & T_M (C_1, 1) T_M (C_2, 2) ... T_M (C_k, k), \
                & C_1 tm.yield C_2 tm.yield ... tm.yield C_k, C_1 = (s, tm.start tm.blank w), C_k = (y, x)}
      $
    - 使用合适的编码方案时，$overline(L_M)$ 是上下文无关语言
      - 用 PDA 非确定性地寻找不正确的转移发生的步骤
    - $A_"TM" <= "ALL"_"CFG"$（判定 $overline(L_M)$ 是否属于 $"ALL"_"CFG"$）
  - $"EQ"_"CFG" = {encoding(G_1) encoding(G_2) : G_1, G_2 "are CFGs", L(G_1) = L(G_2)}$
    - $"ALL"_"CFG" <= "EQ"_"CFG"$（构造 $L(G) = Sigma^*$）

  以上不可判定
]

---

- $overline("ALL"_"CFG")$ 和 $overline("EQ"_"CFG")$ 显然可半判定，参考 @halt-some-input
- $overline(A_"TM")$ 不可半判定，$overline(A_"TM") <= "ALL"_"CFG"$，故 $"ALL"_"CFG"$ 不可半判定
- $"ALL"_"CFG" <= "EQ"_"CFG"$，故 $"EQ"_"CFG"$ 不可半判定

== 图灵机的常见问题

#[
  #set text(size: 20pt)
  $("RE"(A) and "RE"(overline(A)) -> "recursive"(A)) <-> (not "recursive"(A) and "RE"(A) -> not "RE"(overline(A)))$
]

#[
  #set text(size: 22pt)

  - $H = {encoding(M) encoding(w) : M "is a TM that halts on" w}$ 不可判定但可半判定
  - $H_e = {encoding(M) : M "is a TM that halts on" e}$ 不可判定但可半判定
  - $"SOME"_"TM" = {encoding(M) : M "is a TM that halts on some input"}$ 不可判定但可半判定
  - $"ALL"_"TM" = {encoding(M) : M "is a TM that halts on all inputs"} >= overline(H)$ 不可半判定
    - 对 $overline(H)$ 的输入 $encoding(M) encoding(w)$ 构造 $M'(encoding(n))$：如果 $M(w)$ 在 $n$ 步内终止则无限循环，否则终止
  - $overline("ALL"_"TM") >= overline(H)$ 不可半判定
  - $"EQ"_"TM" = {encoding(M_1) encoding(M_2) : M_1, M_2 "are TMs that halts on same inputs"} >= "ALL"_"TM"$ 不可半判定（构造 $M_2$ 为无视输入立刻停机的 TM）
  - $overline("EQ"_"TM") >= overline(H)$ 不可半判定（同上）
]

---

- $R_"TM" = {encoding(M) : M "is a TM", "regular"(L(M))} >= overline(H)$ 不可半判定
  - 对 $overline(H)$ 的输入 $encoding(M) encoding(w)$ 构造 $M'(x)$：模拟 $M(w)$，如果能终止则检查 $x$ 是否形如 $0^n 1^n$，是就接受
- $overline(R_"TM") >= overline(H)$ 不可半判定
  - 对 $overline(H)$ 的输入 $encoding(M) encoding(w)$ 构造 $M'(x)$：检查 $x$ 是否形如 $0^n 1^n$，否就拒绝；模拟 $M(w)$ $n$ 步，能终止就拒绝，否则接受
- $"CF"_"TM" = {encoding(M) : M "is a TM", "context-free"(L(M))}$ 不可半判定
- $overline("CF"_"TM") >= overline(H)$ 不可半判定
- $"REC"_"TM", overline("REC"_"TM")$ 不可半判定
