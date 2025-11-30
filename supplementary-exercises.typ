#import "template.typ": *

#show: toc-template.with(
  title: [习题补充],
  date: none,
)

#components.adaptive-columns(outline())

= 杂题

== 形式语言与集合表示

- 已知 NFA / 正则表达式 / CFG / PDA，选出等价的自然语言表述
- 证明形式语言和某一集合表示的语言等价

不存在解决这一类问题的通法

解题思路：
- 不等价：举反例
- 等价
  - $L_1 = L_2 <-> (L_1 subset.eq L_2) and (L_1 supset.eq L_2)$
  - 数学归纳法：证明循环不变量

---

*例 1* 已知 $G = (V, Sigma, R, S)$，其中 $V = {a, b, S, A, B}, Sigma = {a, b},$

$
  R = { & S -> a B | b A, \
        & A -> a | a S | B A A, \
        & B -> b | b S | A B B}
$

证明：$L(G) = {w: w in Sigma^*, C_a (w) = C_b (w)}$

（$C_a (w)$ 表示 $w$ 中符号 $a$ 的数量）

---

*例 1* $G: S -> a B | b A, A -> a | a S | B A A, B -> b | b S | A B B$

证明：$L(G) = L_"eq"$，其中 $L_"eq" = {w: w in Sigma^*, C_a (w) = C_b (w)}$

#pause

令 $f(w) = C_a (w) - C_b (w)$，则 $L_"eq" = {w: w in Sigma^*, f(w) = 0}$

$
  L(G) subset.eq L_"eq" <-
  forall w in Sigma^*,
  cases(
    S cfg.yield^* w -> f(w) = 0,
    A cfg.yield^* w -> f(w) = 1,
    B cfg.yield^* w -> f(w) = -1,
  )
$

#pause

$(forall w in Sigma^*, p(w)) & <-> (forall n in NN, forall w in Sigma^*, |w|=n -> p(w)) \
& <-> (forall n in NN, forall w in Sigma^*, |w| <= n -> p(w))$

---

*例 1.1* $G: S -> a B | b A, A -> a | a S | B A A, B -> b | b S | A B B$

证明：$L(G) subset.eq L_"eq"$，其中 $L_"eq" = {w: w in Sigma^*, C_a (w) = C_b (w)}$

归纳证明：$forall n in NN, forall w in Sigma^*, |w|<=n -> cases(
  S cfg.yield^* w -> f(w) = 0,
  A cfg.yield^* w -> f(w) = 1, B cfg.yield^* w -> f(w) = -1
)$

- $n <= 2$ 时显然成立
- 如果 $n=k, k >= 2$ 时成立，证明对 $n=k+1$ 成立 #pause
  - 注意到 $S, A, B$ 的产生式不为空
  - 对所有 $|w|=k+1$ 的 $w$ 枚举第一步推导，无论采用哪一种推导结论依然成立

---

*例 1.1* $G: S -> a B | b A, A -> a | a S | B A A, B -> b | b S | A B B$

证明：$L(G) subset.eq L_"eq"$，其中 $L_"eq" = {w: w in Sigma^*, C_a (w) = C_b (w)}$

令 $f'(x) = cases(0 & "if" x=S, 1 & "if" x=a "or" x=A, -1 & "if" x=b "or" x=B), g'(w) = "sum" compose "map"_f' (w)$

则 $forall w in Sigma^*, w in L_"eq" <-> g'(w)=0$

$forall w, w' in V^*, w cfg.yield w' -> g'(w) = g'(w')$

$=> forall w, w' in V^*, w cfg.yield^* w' -> g'(w) = g'(w')$

$=> forall w in Sigma^*, S cfg.yield^* w -> g'(w)=g'(S)=0$

$=> forall w in Sigma^*, S cfg.yield^* w -> w in L_"eq" => L(G) subset.eq L_"eq"$

---

*例 1.2* $G: S -> a B | b A, A -> a | a S | B A A, B -> b | b S | A B B$

证明：$L_"eq" subset.eq L(G)$，其中 $L_"eq" = {w: w in Sigma^*, C_a (w) = C_b (w)}$

#pause

归纳证明：$forall n in NN^+, forall w in Sigma^*, |w| <= n -> cases(
  f(w) = 0 -> S cfg.yield^* w,
  f(w) = 1 -> A cfg.yield^* w,
  f(w) = -1 -> B cfg.yield^* w,
)$

- $n <= 2$ 时显然成立
- 如果 $n=k, k >= 2$ 时成立，证明 $n=k+1$ 时成立 #pause
  - 对于 $w in Sigma^*, |w|=k+1$，对 $w$ 的第一个符号分类讨论
  - $f(w) = 0$：分类讨论后可以直接确定第一步推导
  - $f(w) = 1, w = a w'$：第一步使用 $A -> a S, S cfg.yield^* w'$

---

- $f(w) = 1, w = b w' -> f(w') = 2$
  - 第一步必然选择 $A -> B A A$
  - 第二步尝试选择 $B -> b$，$A cfg.yield B A A cfg.yield b A A$ \
    即证：$A A cfg.yield^* w'$ #pause
  - 令 $g(l)$ 为 $w'$ 的长为 $l$ 的前缀，$f(g(0)) = 0$，$f(g(|w'|)) = 2$
  - $abs(f(g(l)) - f(g(l+1))) = 1 arrow.double exists l_0 in (0, |w'|), f(g(l_0)) = 1$
  - $g(l_0)$ 和 $w'$ 的剩余部分 $f$ 值都为 1，都可以从 $A$ 推导得到
- $f(w) = -1$ 的证明同 $f(w) = 1$

---

#[
  #let figure-pda = figure-automaton(
    (
      s: (s: "a/b, e/a", f: "a, e/e"),
      f: (f: "a/b, a/e"),
    ),
    layout: (
      s: (0, 0),
      f: (4, 0),
    ),
    style: (
      s-f: (curve: 0),
    ),
  )

  *例 2* PDA $M = (K, Sigma, Gamma, Delta, s, F), Sigma = {a, b}, Gamma = {a}, F = {f},$

  #figure-pda

  证明：$L(M) = {x a y: x, y in {a, b}^*, |x|=|y|}$

  ---

  两个循环中的不变量：
  - $forall w, w' in Sigma^*, forall y in Gamma^*, (s, w, e) pda.yield^* (s, w', y) <-> (w' "is a suffix of" w) and (|w| = |w'| + |y|)$
    - $((s, w, e) pda.yield^* (s, w', y)) <-> (exists n in NN, (s, w, e) pda.yield^n (s, w', y))$
    - 对 $n$ 归纳
  - $forall w in Sigma^*, forall y in Gamma^*, (f, w, y) pda.yield^* (f, e, e) <-> |w| = |y|$

  #pause

  #[
    #set text(size: 20pt)
    $
      L(M) & = {w: w in {a, b}^*, (s, w, e) pda.yield^* (f, e, e)} \
      & = {w: w, w' in {a, b}^*, y' in Gamma^*, (s, w, e) pda.yield^* (s, a w', y') pda.yield (f, w', y') pda.yield^* (f, e, e)} \
      & = {w: ..., a w' "is a suffix of" w, |w|=|a w'|+|y'|, (s, a w', y') pda.yield (f, w', y'), |w'|=|y'|} \
      & stretch(=)^(w = x a w') {x a w': w', x in {a, b}^*, y' in Gamma^*, |x| = |w'| = |y'|} \
      & = {x a w': w', x in {a, b}^*, |x| = |w'|} = L_s
    $
  ]
]
