#import "template.typ": *
#show: toc-template.with(
  title: [语言、自动机与正则表达式],
  date: datetime(year: 2025, month: 11, day: 2),
)

= 语言

== 语言

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

= 有限自动机（FA）

== 确定性有限自动机（DFA）

#components.left-and-right(
  [
    - 五元组 $M = (K, Sigma, delta, s, F)$
      - $K$：有限状态集合
      - $Sigma$：输入符号集
      - $delta: K times Sigma arrow K$：状态转移函数
      - $s in K$：初始状态
      - $F subset.eq K$：接受状态集合
    - 配置：$(q, w)$，$q in K$，$w in Sigma^*$
      - $(q, a w) tack.r_M (q', w)$：一步转移
      - $(q, w) tack.r_M^* (q', w')$：若干步转移
      - $(s, w) tack.r_M^* (q, e), q in F$：接受字符串 $w$
    - $L(M)$：自动机 $M$ 接受的字符串形成的语言
  ],
  figure-automaton(
    (
      q0: (q0: 0, q1: 1),
      q1: (q2: 0, q0: 1),
      q2: (q1: 0, q2: 1),
    ),
  ),
)

== DFA 最小化

- 任意能被 DFA 表示的语言都存在唯一的最小化 DFA
- 最小化 DFA
  - 删除不可达状态
  - 合并等价状态：将状态划分为若干等价类
    - 接受状态与非接受状态不等价
    - 对某一输入符号转移到不同等价类的两个状态不等价
- 从 ${K-F, F}$ 开始，不断细分每个暂定的等价类直到无法细分

---

#context [
  #let step0 = figure-automaton(
    (
      q0: (q1: 0, q2: 1),
      q1: (q0: 0, q3: 1),
      q2: (q4: 0, q5: 1),
      q3: (q4: 0, q5: 1),
      q4: (q4: 0, q5: 1),
      q5: (q5: (0, 1)),
    ),
    layout: (
      q0: (0, 0),
      q1: (0, 4),
      q2: (4, 0),
      q3: (4, 4),
      q4: (8, 0),
      q5: (8, 4),
    ),
    style: (
      state: (radius: 1),
      q1-q3: (curve: 0),
      q0-q2: (curve: 0),
      q2-q4: (curve: 0),
      q3-q5: (curve: 0),
      q4-q5: (curve: 0),
      q4-q4: (anchor: bottom),
    ),
  )

  #let step1 = figure-automaton(
    (
      q0: (q1: 0, q2: 1),
      q1: (q0: 0, q2: 1),
      q2: (q4: 0, q5: 1),
      q4: (q4: 0, q5: 1),
      q5: (q5: (0, 1)),
    ),
    labels: (q2: $"q"_2 "q"_3$),
    layout: (
      q0: (0, 0),
      q1: (0, 4),
      q2: (4, 2),
      q4: (8, 0),
      q5: (8, 4),
    ),
    style: (
      state: (radius: 1),
      q1-q2: (curve: 0),
      q0-q2: (curve: 0),
      q2-q4: (curve: 0),
      q2-q5: (curve: 0),
      q4-q5: (curve: 0),
      q4-q4: (anchor: bottom),
    ),
  )

  #let step2 = figure-automaton(
    (
      q0: (q1: 0, q2: 1),
      q1: (q0: 0, q2: 1),
      q2: (q2: 0, q5: 1),
      q5: (q5: (0, 1)),
    ),
    labels: (q2: $"q"_2 "q"_3 "q"_4$),
    layout: (
      q0: (0, 0),
      q1: (0, 4),
      q2: (4, 2),
      q5: (8, 2),
    ),
    style: (
      state: (radius: 1),
      q2: (radius: 1.5),
      q1-q2: (curve: 0),
      q0-q2: (curve: 0),
      q2-q5: (curve: 0),
      q2-q2: (anchor: bottom),
    ),
  )

  #let step3 = figure-automaton(
    (
      q0: (q0: 0, q2: 1),
      q2: (q2: 0, q5: 1),
      q5: (q5: (0, 1)),
    ),
    labels: (q0: $"q"_0 "q"_1$, q2: $"q"_2 "q"_3 "q"_4$),
    style: (
      state: (radius: 1),
      q2: (radius: 1.5),
      q0-q2: (curve: 0),
      q2-q5: (curve: 0),
    ),
  )

  #components.side-by-side(step0, step3)

  - 初始：${q_0, q_1, q_2, q_3, q_4}, {q_5}$
  - ${q_0, q_1}, {q_2, q_3, q_4}, {q_5}$
]

== 非确定性有限自动机（NFA）

#components.left-and-right(
  [
    - 五元组 $M = (K, Sigma, Delta, s, F)$
      - $K$：有限状态集合
      - $Sigma$：输入符号集
      - $Delta: K times (Sigma union {epsilon})$：状态转移集合
      - $s in K$：初始状态
      - $F subset.eq K$：接受状态集合
    - 存在一种转移路线接受字符串 $w$ 即称为 NFA 接受字符串 $w$
  ],
  figure-automaton(
    (
      q0: (q0: "a", q1: "a,b"),
      q1: (q0: "b", q2: "a,e"),
      q2: (),
    ),
    style: (
      q1-q2: (curve: 0),
    ),
  ),
)

== NFA 到 DFA 的转换

- 所有 DFA 都是 NFA
- NFA 可以通过子集构造法转换为等价的 DFA
  - 用 DFA 的状态表示 NFA 状态的子集
    - $epsilon$-闭包 $E(q) = {p in K: (q,e) tack.r_M^* (p,e)}$
    - 初始状态为 NFA 初始状态的 $epsilon$-闭包
    - 接受状态为包含 NFA 接受状态的子集
  - 通常使用 BFS 方法遍历所有需要的状态

---

#components.left-and-right(
  [
    #figure-automaton(
      (
        q0: (q0: "a", q1: "a,b"),
        q1: (q0: "b", q2: "a,e"),
        q2: (),
      ),
      style: (
        state: (radius: 1),
        q1-q2: (curve: 0),
      ),
    )
  ],
  [
    #table(
      columns: 4,
      [*ID*], [*States*], [*a*], [*b*],
      [0], [$q_0$], [1], [2],
      [1], [$q_0, q_1, q_2$], [1], [1],
      [2], [$q_1, q_2$], [3], [1],
      [3], [$q_2$], [], [],
    )

    #figure-automaton(
      (
        q0: (q1: "a", q2: "b"),
        q1: (q1: "a, b"),
        q2: (q3: "a", q1: "b"),
        q3: (),
      ),
      final: ("q2", "q3"),
      layout: (
        q0: (0, 0),
        q1: (4, 0),
        q2: (0, 4),
        q3: (4, 4),
      ),
      labels: (
        q0: $q_0$,
        q1: $q_0 q_1 q_2$,
        q2: $q_1 q_2$,
        q3: $q_2$,
      ),
      style: (
        state: (radius: 1),
        q1: (radius: 1.5),
        q0-q1: (curve: 0),
        q0-q2: (curve: 0),
        q2-q3: (curve: 0),
        q2-q1: (curve: 0),
        // q1-q1: (anchor: right),
      ),
    )
  ],
)

= 正则表达式和正则语言

== 正则表达式（Regular Expression）

- $Sigma union {(,),union,*,emptyset}$ 上的字符串
  - $emptyset$ 是正则表达式，对应语言 $L(emptyset) = emptyset$
  - $forall a in Sigma$，$a$ 是正则表达式，对应语言 $L(a) = {a}$
  - 如果 $r_1$ 和 $r_2$ 是正则表达式，则
    - $(r_1 union r_2)$ 是正则表达式，对应语言 $L(r_1) union L(r_2)$
    - $(r_1 r_2)$ 是正则表达式，对应语言 $L(r_1) compose L(r_2)$
    - $(r_1^*)$ 是正则表达式，对应语言 $L(r_1)^*$
    - 运算优先级：$* > compose > union$
  - 不符合以上规则的字符串不是正则表达式
  - 所有正则表达式的集合：$cal(R)$

== 从正则表达式构造 NFA

- 已知 NFA $M_1 = (K_1, Sigma, Delta_1, s_1, F_1)$ 和 $M_2 = (K_2, Sigma, Delta_2, s_2, F_2)$
  - 构造 $L(M) = L(M_1) union L(M_2)$
    - $K = K_1 union K_2 union {s}, F = F_1 union F_2$
    - $Delta = Delta_1 union Delta_2 union {(s, e, s_1), (s, e, s_2)}$
  - 构造 $L(M) = L(M_1) compose L(M_2)$
    - $K = K_1 union K_2, F = F_2$
    - $Delta = Delta_1 union Delta_2 union {(q, e, s_2): q in F_1}$
  - 构造 $L(M) = L(M_1)^*$
    - $K = K_1 union {s}, F = F_1 union {s}$
    - $Delta = Delta_1 union {(s, e, s_1)} union {(q, e, s_1): q in F_1}$
    - 构造新的初始状态是有必要的：空串或中途返回起始状态

== 从 NFA 构造正则表达式

- 广义 NFA $M_G = (K_G, Sigma_G, Delta_G, s_G, F_G)$
  - 仅有一个接受状态 $F = {f_G}$
  - $Sigma_G = Sigma union cal(R)_0$，$cal(R)_0$ 是有限的正则表达式集合（边上可以使用正则表达式）
  - $Delta_G subset.eq (K - f_G) times (Sigma union {e} union cal(R)_0) times (K - s_G)$
- 从 NFA 构造广义 NFA：添加新初始状态 $s_G$ 和接受状态 $f_G$
- 消除状态 $q in K_G - {s_G, f_G}$：
  - 对于每对状态 $(p, r)$，若存在转移 $(p, a_1, q), (q, a_2, r)$
    - 如果 $q$ 有自环 $(q, a_3, q)$，则添加转移 $(p, (a_1 (a_3)^* a_2), r)$
    - 否则添加转移 $(p, (a_1 a_2), r)$
  - 删除状态 $q$ 及其相关转移

== 正则语言（Regular Language）

#context [
  #set text(size: 20pt)

  - 可由某个正则表达式表示的语言称为正则语言
  - $L$ 是正则语言 $arrow.l.r$ $L$ 可由某个 FA 接受
  - 闭包性质：当 $A$ 和 $B$ 是正则语言时：
    - $A union B = {w: w in A "or" w in B}$ 是正则的
    - $A compose B = {w_1 w_2: w_1 in A, w_2 in B}$ 是正则的
    - $A^* = {w_1 w_2 ... w_k: k >= 0, w_i in A}$ 是正则的
    - $overline(A) = Sigma^* - A$ 是正则的
    - $A^R = {w^R: w in A}$ 是正则的
    - $A inter B = {w: w in A, w in B} = overline(overline(A) union overline(B))$ 是正则的
    - $A - B = {w: w in A, w in.not B} = A inter overline(B)$ 是正则的
    - 令 $h: Sigma -> Gamma^*$，将其扩展为 $h: Sigma^* -> Gamma^*$，其中 $h(e) = e$，$h(a_1 a_2 ... a_n) = h(a_1) h(a_2) ... h(a_n)$
      - $C_1 = {h(w): w in A}, C_2 = {h^(-1)(w): w in A}$ 是正则的
    - 无限次运算后不一定是正则的
]

== Pumping Theorem

#context [
  #show math.equation: set align(left)
  $
    forall L subset.eq Sigma^*, "regular"(L) -> \
    space (exists p >= 1, forall w in L, |w| >= p -> \
      space space exists x, y, z in Sigma^*,
      (w = x y z) and (|x y| <= p) and (|y| >= 1) and (forall i >= 0, x y^i z in L))
  $
]
证明：
- 令 $M = (K, Sigma, delta, s, F)$ 是接受语言 $L$ 的 DFA，取 $p = |K|$
- 输入长度不小于 $p$ 的字符串 $w in L$，则在 $M$ 处理 $w$ 的前 $p$ 步过程中经过了 $p+1$ 个状态，必然有某个状态 $q_s$ 被访问了至少两次
- 令 $y$ 为两次访问 $q_s$ 之间读取的字符串，$x$ 为之前读取的字符串，$z$ 为之后读取的字符串

---

- 变形：
  #context [
    #show math.equation: set align(left)
    $
      forall L subset.eq Sigma^*, \
      (forall p >= 1, exists w in L, |w| >= p and (forall x, y, z in Sigma^*, \
          quad (w = x y z) and (|x y| <= p) and (|y| >= 1) -> (exists i >= 0, x y^i z in.not L))) \
      -> not "regular"(L)
    $
  ]
- 例：语言 $L = {a^n b^n | n >= 0}$
  - 对于所有 $p >= 1$，取 $w = a^p b^p in L$，则 $|w| = 2p >= p$
  - 任意划分 $w = x y z$ 使 $|x y| <= p, |y| >= 1$，则 $y = a^k, k >= 1$
  - 取 $i = 0$，则 $x y^i z = a^(p-k) b^p in.not L$
  - 因此 $L$ 不是正则语言

== 正则语言的判定

- 不存在判断任意语言是否正则的通用方法
- 证明语言正则
  - 该语言有限
  - 构造一个接受该语言的 FA
  - 构造一个生成该语言的正则表达式
  - 正则语言的闭包性质
- 证明语言非正则
  - Pumping Theorem
  - 反证
    - 不存在接受该语言的 FA
    - 正则语言的闭包性质

---

*例 1* $L = {a^i b^j c^k: i+j eq.triple.not k space (mod 3), i, j, k in NN}$

#pause

令 $i eq.triple t_1 space (mod 3), j eq.triple t_2 space (mod 3), k eq.triple t_3 space (mod 3), t_1, t_2, t_3 in {0, 1, 2}$

显然 $(t_1, t_2, t_3)$ 的取值只有有限种

#pause

$L_(1,t_1) = {a^(3n_1 + t_1): n_1 in NN}, L_(2,t_2) = {b^(3n_2 + t_2): n_2 in NN}, L_(3,t_3) = {c^(3n_3 + t_3): n_3 in NN}$ 均为正则语言

对每组 $(t_1, t_2, t_3)$ 的取值，$L_(1,t_1) compose L_(2,t_2) compose L_(3,t_3)$ 为正则语言

#pause

$L = union.big_(t_1 + t_2 eq.triple.not t_3 space (mod 3)) L_(1,t_1) compose L_(2,t_2) compose L_(3,t_3)$ 为有限个正则语言的并集，故 $L$ 为正则语言

---

*例 2* $L = {w: w "is binary representation of" n, n mod 3 = 0, n in NN}$

#pause

#figure-automaton(
  (
    q3: (q4: "0", q1: "1"),
    q0: (q0: "0", q1: "1"),
    q1: (q2: "0", q0: "1"),
    q2: (q1: "0", q2: "1"),
  ),
  final: ("q0", "q4"),
  layout: (
    q3: (0, 0),
    q4: (0, -4),
    q1: (4, 0),
    q0: (8, 0),
    q2: (4, -4),
  ),
  style: (
    state: (radius: 1),
    q3-q4: (curve: 0),
    q3-q1: (curve: 0),
    q2-q2: (anchor: bottom),
  ),
)

---

*例 3* $L = {w: w in {a, b}^*, w != w^R}$

#pause

令 $L' = {a, b}^* - L = {w: w in {a, b}^*, w = w^R}$

则 $L$ 和 $L'$ 的正则性相同

#pause

- 对任意 $p >= 1$，取 $w = a^p b a^p in L'$，则 $|w| = 2p + 1 >= p$
- 任意划分 $w = x y z$ 使 $|x y| <= p, |y| >= 1$，则 $y = a^k, k >= 1$
- 取 $i = 0$，则 $x y^i z = a^(p-k) b a^p in.not L'$
- 因此 $L'$ 不是正则语言，故 $L$ 也不是正则语言
