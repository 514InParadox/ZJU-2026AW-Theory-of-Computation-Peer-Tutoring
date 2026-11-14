#import "template.typ": *

#show: toc-template.with(
  title: [上下文无关语言],
  date: datetime(year: 2026, month: 11, day: 14),
)

/* 

TODOs

+ 看看书上的 PDA to CFG 证明

+ Parse tree、最左 / 最右推导、Ambiguity √

+ PDA 例子 √

+ 闭包性质这里举几个例子

---

CFG & CNF

PDA

CFG 2 PDA & PDA 2 CFG

Pumping theorem & 判定

*/

= 上下文无关文法

== 上下文无关文法（CFG）

- 四元组 $G=(V, Sigma, R, S)$
  - $V$：符号集
  - $Sigma subset.eq V$：终结符集合
  - $S in V - Sigma$：开始符号
  - $R subset.eq (V - Sigma) times V^*$：产生式集合
- 单步推导 $x A y =>_G x B C y, (A, B C) in R$
- 多步推导 $x =>_G^* y$，生成字符串 $S =>_G^* w$

#let expression-tree(product-first: true) = diagram(cell-size: (1.7em, 1.5em), spacing: .3em, {
  if product-first {
    node((2, 0), name: <root>)[$E$]
    node((0, 1), name: <left>)[$E$]
    node((2, 1), name: <op>)[+]
    node((4, 1), name: <right>)[$E$]
    node((0, 2), name: <a1>)[$a$]
    node((3, 2), name: <inner-left>)[$E$]
    node((4, 2), name: <inner-op>)[∗]
    node((5, 2), name: <inner-right>)[$E$]
    node((3, 3), name: <a2>)[$a$]
    node((5, 3), name: <a3>)[$a$]
    edge(<left>, <a1>)
    edge(<right>, <inner-left>)
    edge(<right>, <inner-op>)
    edge(<right>, <inner-right>)
    edge(<inner-left>, <a2>)
    edge(<inner-right>, <a3>)
  } else {
    node((4, 0), name: <root>)[$E$]
    node((2, 1), name: <left>)[$E$]
    node((4, 1), name: <op>)[∗]
    node((6, 1), name: <right>)[$E$]
    node((1, 2), name: <inner-left>)[$E$]
    node((2, 2), name: <inner-op>)[+]
    node((3, 2), name: <inner-right>)[$E$]
    node((6, 2), name: <a3>)[$a$]
    node((1, 3), name: <a1>)[$a$]
    node((3, 3), name: <a2>)[$a$]
    edge(<left>, <inner-left>)
    edge(<left>, <inner-op>)
    edge(<left>, <inner-right>)
    edge(<inner-left>, <a1>)
    edge(<inner-right>, <a2>)
    edge(<right>, <a3>)
  }
  edge(<root>, <left>)
  edge(<root>, <op>)
  edge(<root>, <right>)
})

== 解析树（Parse Tree）

#block[
  文法 $G = (V, Sigma, R, E)$，其中

  $V = {E, a, +, *}$，$Sigma = {a, +, *}$，\
  $R = {(E, E + E), (E, E * E), (E, a)}$。

  #grid(columns: (1.4fr, 1fr), column-gutter: 18pt, align: horizon,
    [
      - *解析树*：有根有序树
      - *产出*：最终得到的字符串
      - *最左/最右推导*
    ],
    [
      #align(center)[#expression-tree()]
      #align(center)[产出：$a + a * a$]
    ],
  )
]

---

=== 歧义性（Ambiguity）

#block[
  - *歧义文法*：存在 $w in L(G)$，具有两棵不同的解析树
    - 等价地，$w$ 有两个不同的最左推导（或两个不同的最右推导）

  #grid(columns: (1fr, 1fr), column-gutter: 24pt, align: center,
    [#expression-tree() \ $a + (a * a)$],
    [#expression-tree(product-first: false) \ $(a + a) * a$],
  )

]

---

= 下推自动机（PDA）

== 下推自动机（PDA）

- NFA + 栈
- 六元组 $M = (K, Sigma, Gamma, Delta, s, F)$
  - $Gamma$：栈符号集
  - $Delta: (K times (Sigma union {epsilon}) times Gamma^*) times (K times Gamma^*)$

    $((q_1, a, x), (q_2, y))$ 表示在状态 $q_1$，读取输入 $a$，栈顶为 $x$ 时，可以转移到状态 $q_2$，并将栈顶的 $x$ 替换为 $y$（$y$ 中的每一个符号将被倒序压入栈顶）
- 配置 $C: K times Sigma^* times Gamma^*$，状态、剩余输入、栈内容
- 推导：$(q, a w', x) tack.r_M (q', w', y), (q, w w', x) tack.r_M^* (q', w', y)$
- 接受串 $w$：$(s, w, epsilon) tack.r_M^* (q, epsilon, epsilon), q in F$
- 非确定性 PDA 计算能力强于确定性 PDA

---

*Example 3.3.3*

#block[
  接受语言 $L = {w in {a, b}^*: C_a (w) = C_b (w)}$，其中 $C_a, C_b$ 表示字符个数。

  $M = (K, Sigma, Gamma, Delta, s, F)$，其中
  $K = {s, q, f}$，$Sigma = {a, b}$，$Gamma = {a, b, c}$，$F = {f}$。$Delta$：

  #table(
    columns: (auto, 1fr, auto, 1fr),
    stroke: none, inset: (x: 8pt, y: 5pt),
    [(1)], [$((s, epsilon, epsilon), (q, c))$],
    [(5)], [$((q, b, c), (q, b c))$],
    [(2)], [$((q, a, c), (q, a c))$],
    [(6)], [$((q, b, b), (q, b b))$],
    [(3)], [$((q, a, a), (q, a a))$],
    [(7)], [$((q, b, a), (q, epsilon))$],
    [(4)], [$((q, a, b), (q, epsilon))$],
    [(8)], [$((q, epsilon, c), (f, epsilon))$],
  )
]

---

*Example 3.3.3*

#block[
  #set text(size: 18pt)
  #set par(leading: .45em)
  #align(center)[
    #table(
      columns: (auto, 1fr, auto, auto, 1.5fr),
      align: (center, center, center, center, left),
      inset: (x: 12pt, y: 4pt), stroke: 0.5pt + luma(70%),
      table.header([*状态*], [*未读输入*], [*栈（栈顶在左）*], [*所用转移*], [*说明*]),
      [$s$], [$a b b b a b a a$], [$epsilon$], [—], [初始配置],
      [$q$], [$a b b b a b a a$], [$c$], [1], [压入栈底标记],
      [$q$], [$b b b a b a a$], [$a c$], [2], [压入 $a$],
      [$q$], [$b b a b a a$], [$c$], [7], [读入 $b$，抵消一个 $a$],
      [$q$], [$b a b a a$], [$b c$], [5], [压入 $b$],
      [$q$], [$a b a a$], [$b b c$], [6], [再压入一个 $b$],
      [$q$], [$b a a$], [$b c$], [4], [读入 $a$，抵消一个 $b$],
      [$q$], [$a a$], [$b b c$], [6], [压入 $b$],
      [$q$], [$a$], [$b c$], [4], [抵消一个 $b$],
      [$q$], [$epsilon$], [$c$], [4], [输入读完，$a$、$b$ 恰好抵消],
      [$f$], [$epsilon$], [$epsilon$], [8], [弹出 $c$，进入接受状态],
    )
  ]
]

== 从 CFG 构造 PDA

- 注意到 PDA 是非确定性的，可以利用非确定性来模拟 CFG 的推导过程
- 已知 $G = (V, Sigma, R, S)$ 构造 $M = (K, Sigma, Gamma, Delta, s, F)$
  - $F = {f}, K = {s, f}, Gamma = V$
  - $Delta$：在栈上模拟非确定性最左推导并与输入串匹配的过程
    - 初始转移：$((s, epsilon, epsilon), (f, S))$
    - $forall (A, alpha) in R$，添加转移 $((f, epsilon, A), (f, alpha))$
    - $forall a in Sigma$，添加转移 $((f, a, a), (f, epsilon))$

== 从 PDA 构造 CFG

- 先从 PDA 构造 Simple PDA，再从 Simple PDA 构造 CFG
- PDA $M = (K, Sigma, Gamma, Delta, s, F)$ 满足以下条件时称为 Simple PDA：
  - $forall ((q, a, beta), (p, gamma)) in Delta, q != s -> beta in Gamma and |gamma| <= 2$
- 从任意 PDA $M = (K, Sigma, Gamma, Delta, s, F)$ 构造 Simple PDA $M' = (K', Sigma, Gamma union {Z}, Delta', s', {f'})$
  - 栈底符号 $Z in.not Gamma$
  - $K' = K union {s', f'}$

---

- $Delta'$ 包含：
  - $((s', epsilon, epsilon), (s, Z))$
  - $forall f in F$，添加转移 $((f, epsilon, Z), (f', epsilon))$
  - $Delta$ 中的所有转移 $((q, a, beta), (p, gamma))$：
    - 如果 $|beta| >= 2$，分解为多个转移，每次弹出一个符号
    - 如果 $|gamma| >= 2$，分解为多个转移，每次压入一个符号
    - 如果 $beta = epsilon$，替换为 $((q, a, A), (p, gamma A)), A in Gamma union {Z}$

---

- 从 Simple PDA $M = (K, Sigma, Gamma, Delta, s, {f})$ 构造 CFG $G = (V, Sigma, R, S)$
  - $V = {S} union Sigma union {chevron.l q, A, r chevron.r: q, r in K, A in Gamma union {e, Z}}$
    - 非终结符 $chevron.l q, A, r chevron.r$ 表示从状态 $q$ 开始，栈顶为 $A$，最终到达状态 $r$ 且 $A$ 被删去的过程中所有可能被读取的输入

---

- $R$ 由以下产生式组成：
  - $S -> chevron.l s, Z, f chevron.r$
  - $forall q in K$，添加产生式 $chevron.l q, epsilon, q chevron.r -> epsilon$
  - 形如 $((q, a, B), (r, C)), C in Gamma union {epsilon}$ 的转移，$forall p in K$ 添加产生式 $chevron.l q, B, p chevron.r -> a chevron.l r, C, p chevron.r$
  - 形如 $((q, a, B), (r, C_1 C_2)), C_1, C_2 in Gamma$ 的转移，$forall p, p' in K$ 添加产生式 $chevron.l q, B, p chevron.r -> a chevron.l r, C_1, p' chevron.r chevron.l p', C_2, p chevron.r$

= 上下文无关语言

== 上下文无关语言（CFL）

- CFG $G$ 对应的语言 $L(G) = {w in Sigma^*: S =>_G^* w}$
- 所有正则语言都是 CFL
  - 从 DFA 构造：将每个转移 $(p, a, q)$ 转换为产生式 $P -> a Q$
  - 从正则表达式构造：递归构造
- 闭包性质：当 $A$ 和 $B$ 是 CFL 时：
  - $A union B, A compose B, A^*, A^R$ 是 CFL
  - $A inter B, overline(A), A-B$ 不一定是 CFL
  - 令 $h: Sigma -> Gamma^*$，将其扩展到 $h: Sigma^* -> Gamma^*$，其中 $h(a_1 a_2 ... a_n) = h(a_1) h(a_2) ... h(a_n), h(epsilon) = epsilon$
    - $C_1 = {h(w): w in A}, C_2 = {h^(-1)(w): w in A}$ 是 CFL
- $L$ 为 CFL，$R$ 为正则语言，则 $L inter R$ 是 CFL

---

*Theorem 3.5.4*

#block[

  - $ L_1 = {a^n b^n c^m: m, n >= 0}, quad L_2 = {a^m b^n c^n: m, n >= 0}. $

  $ L_1 inter L_2 = {a^n b^n c^n: n >= 0} in.not "CFL". $
]

---

// 根据教材 Theorem 3.5.4 与习题 3.5.14(b) 构造具体反例。
*Problem 3.5.14*

#block[
    $L = {a^n b^n c^n: n >= 0} in.not "CFL".$

    $overline(L) in "CFL".$

  - $A = {a^i b^j c^k: i, j, k >= 0, i != j "or" j != k}$

    - $A = {a^i b^j: i != j} c^* union a^* {b^j c^k: j != k}$

  - $overline(L) = (Sigma^* - a^* b^* c^*) union A$

  - 若 CFL 对补封闭，则由德摩根律也会对交封闭，与例 2 矛盾
]

== CFL 的 Pumping Theorem

#context [
  #show math.equation: set align(left)
  $
    forall L subset.eq Sigma^*, "context-free"(L) -> \
    space (exists p >= 1, forall w in L, |w| >= p -> exists u, v, x, y, z in Sigma^*, \
      quad (w = u v x y z) and (|v y| >= 1) and (|v x y| <= p) and (forall i >= 0, u v^i x y^i z in L))
  $
]

#components.left-and-right(
  [
    - 有限语言可以直接取 $p = max_(w in L) |w| + 1$
    - 对于任意 $n in NN$，无限语言中都存在长度至少为 $n$ 的字符串
    - 对于任何足够长的字符串 $s in L$，解析树上存在非终结符 $Q$，其子树中再次出现 $Q$
  ],
  figure(image("images/ch2/pumping-theorem.png", width: 50%)),
)

---

- 令使用的 CFG $G$ 为 CNF 形式
- $|v y| >= 1$：$Q$ 的两次出现间必然会在两侧添加新终止符
- $|v x y| <= p$
  - 从解析树上深度最大的叶节点出发向祖先方向走 $|V - Sigma| + 1$ 步，经过的非终结符中必然存在一对相同的非终结符，令其中的祖先为 $Q_1$，后代为 $Q_2$
  - 取 $x$ 为 $Q_2$ 的推导结果，$v x y$ 为 $Q_1$ 的推导结果
  - $Q_1$ 子树中的最大深度不超过 $|V - Sigma| + 1$，取 $p = 2^(|V - Sigma| + 1)$

---

变形：

#context [
  #show math.equation: set align(left)
  $
    forall L subset.eq Sigma^*, \
    (forall p >= 1, exists w in L, |w| >= p and (forall u, v, x, y, z in Sigma^*, \
        quad (w = u v x y z) and (|v y| >= 1) and (|v x y| <= p) -> (exists i >= 0, u v^i x y^i z in.not L))) \
    arrow not "context-free"(L)
  $
]

例：$L = {a^n b^n c^n: n >= 0}$
- $forall p >= 1$，取 $w = a^p b^p c^p$，则 $|w| = 3p >= p$
- 任意划分 $w = u v x y z, |v x y| <= p, |v y| >= 1$，则 $v x y$ 最多包含两种字符
- 取 $i = 0$，$u v^0 x y^0 z = u x z in.not L$

---

课本版：

#context [
  #show math.equation: set align(left)
  $
    forall L subset.eq Sigma^*, forall G = (V, Sigma, R, S), L = L(G) -> \
    (forall w in L, |w| >= phi.alt (G)^(|V-Sigma|) -> exists u, v, x, y, z in Sigma^*, \
      quad (w = u v x y z) and (|v y| >= 1) and (forall i >= 0, u v^i x y^i z in L))
  $
]

- $phi.alt (G)$：CFG $G$ 的解析树的最大叉数（产生式右侧最大符号数）
- 没有限定 $|v x y|$ 的上界 #sym.arrow 弱于 $|v x y| <= p$ 的版本
- 例：证明 $L = {w w: w in {a,b}^*}$ 不是 CFL
  - 无论如何构造 $w' = w w in L$，都存在一种划分方案使 $u = x, v = y, z = epsilon, w = u v = x y$
  - 该划分方案下 $forall i >= 0, u v^i = x y^i, u v^i x y^i z in L$

== CFL 的判定

- 同样不存在判断任意语言是否为 CFL 的算法
- 证明语言是 CFL
  - 有限
  - 构造 CFG 或 PDA
  - 运算性质
- 证明语言不是 CFL
  - Pumping Theorem
  - 运算性质

---

#context [
  #show math.equation: set text(24pt)

  *例 1* $L = {w in {a, b}^*: C_a (w) != C_b (w), a b a a "is not a substring of" w}$
]

（$C_a (w)$ 表示 $w$ 中 $a$ 的个数）

#pause

$L' = {w in {a, b}^*: C_a (w) != C_b (w)}$

$R = {w in {a, b}^*: a b a a "is a substring of" w}$

$L = L' inter overline(R)$

---

*例 1.1* $L = {w in {a, b}^*: C_a (w) != C_b (w)}$

（$C_a (w)$ 表示 $w$ 中 $a$ 的个数）

#pause

构造 PDA $M = (K, Sigma, Gamma, Delta, s, F)$

#context [
  #show math.equation: set text(20pt)

  $
    Delta = { & ((s, epsilon, epsilon), (s', Z)), \
              & ((s', a, Z), (s', a Z)), ((s', b, Z), (s', b Z)), \
              & ((s', a, a), (s', a a)), ((s', a, b), (s', epsilon)), \
              & ((s', b, a), (s', epsilon)), ((s', b, b), (s', b b)), \
              & ((s', epsilon, a), (f, epsilon)), ((s', epsilon, b), (f, epsilon)), \
              & ((f, epsilon, a), (f, epsilon)), ((f, epsilon, b), (f, epsilon)), \
              & ((f, epsilon, Z), (f, epsilon)) }
  $
]

---

*例 1.1* $L = {w in {a, b}^*: C_a (w) != C_b (w)}$

（$C_a (w)$ 表示 $w$ 中 $a$ 的个数）

分成大于和小于两种情况构造 CFG

#pause

构造 $a$ 和 $b$ 数量相同的串：$E -> a E b | b E a | E E | epsilon$

（从左到右扫描字符串，每当扫描过的部分 $a$ 和 $b$ 数量相等时就将这段子段从原串中切出
，这个子段首尾字符一定不同）

#pause

构造 $a$ 比 $b$ 多的串：$G -> E A E | G G, A -> a A | a$

$L -> E B E | L L, B -> b B | b$

$S -> L | G$

---

*例 2* $L = {a^i b^j c^i d^j}$

#pause

$forall p >= 1$，取 $w = a^p b^p c^p d^p$，则 $|w| = 4p >= p$

任意划分 $w = u v x y z, |v x y| <= p, |v y| >= 1$，则 $v x y$ 最多包含两种字符

取 $k = 0$，$u v^k x y^k z = u x z in.not L'$

---

*例 3* $L = {a^m b^n c^k d^l: m + n = k + l}$

#pause

令 $L' = {w_1 w_2: w_1 in {a, b}^*, w_2 in {c, d}^*, |w_1| = |w_2|}$

$R = L(a^* b^* c^* d^*)$

则 $L = L' inter R$

---

*例 3* $L = {a^m b^n c^k d^l: m + n = k + l}$

#pause

$
  S_(a d) -> epsilon | a S_(a d) d \
  S_(a c) -> epsilon | a S_(a c) c \
  S_(b d) -> epsilon | b S_(b d) d \
  S_(b c) -> epsilon | b S_(b c) c
$

#pause

$
  S_(a d) -> S_(a c) | S_(b d) \
  S_(a c) -> S_(b c) \
  S_(b d) -> S_(b c) \
  S -> S_(a d)
$

---

*例 3* $L = {a^m b^n c^k d^l: m + n = k + l}$

#pause

构造 PDA

#figure-automaton(
  (
    s: (q0: "e, e/Z"),
    q0: (q0: "a, e/a", q1: "e, e/e"),
    q1: (q1: "b, e/a", q2: "e, e/e"),
    q2: (q2: "c, a/e", q3: "e, e/e"),
    q3: (q3: "d, a/e", q4: "e, Z/e"),
    q4: (),
  ),
  layout: (
    s: (0, 0),
  ),
  style: (
    s-q0: (curve: 0),
    q0-q1: (curve: 0),
    q1-q2: (curve: 0),
    q2-q3: (curve: 0),
    q3-q4: (curve: 0),
  ),
)

// $
//   Delta = { & ((s, epsilon, epsilon), (q_0, Z)), \
//             & ((q_0, a, epsilon), (q_0, a)), ((q_0, b, epsilon), (q_0, b)), \
//             & ((q_0, epsilon, epsilon), (q_1, epsilon)), \
//             & ((q_1, c, a), (q_1, epsilon)), ((q_1, c, b), (q_1, epsilon)), \
//             & ((q_1, d, a), (q_1, epsilon)), ((q_1, d, b), (q_1, epsilon)), \
//             & ((q_1, epsilon, epsilon), (f, epsilon)), \
//             & ((f, epsilon, Z), (f, epsilon)) }
// $
