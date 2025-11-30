#import "template.typ": *

#show: toc-template.with(
  title: [图灵机理论基础],
  date: datetime(year: 2025, month: 11, day: 30),
)

= 图灵机

== 确定性图灵机（DTM）

#context [
  #set text(size: 24pt)

  - 在 DFA 的基础上添加了对纸带和读写头的操作
  - 五元组 $M = (K,Sigma,delta,s,H)$
    #aligned-terms[
      / $K$: 自动机状态集
      / $Sigma$: 符号集，包含特殊符号 $tm.start$ 和 $tm.blank$
      / $delta$: 状态转移函数，$delta : (K - H) times Sigma -> K times ({<-, ->} union (Sigma - {tm.start}))$
        - $forall q in K - H, exists p in K, delta (q, tm.start) = (p, ->)$
      / $s$: 起始状态，$s in K$
      / $H$: 停机状态集合，处于任意停机状态即结束运行，$H subset.eq K$
    ]
  / 配置: 形如 $(q, tm.start tm.blank a b, a)$，此时读写头指向第二个参数的最后符号
    - 也写作 $(q, tm.start tm.blank a underline(b) a)$
  / 推导: $(q_1, tm.start w_1 underline(a_1) u_1) tm.yield (q_2, tm.start w_2 underline(a_2) u_2)$
]

== 基本的图灵机

#aligned-terms[
  / $M_a$ 或 $a$: 如果当前位置可写则写入 $a$，否则（$tm.start$）右移再写入 $a$
  / $M_(<-)$ 或 $L$: 如果不位于 $tm.start$ 就左移
  / $M_(->)$ 或 $R$: 右移
  / $L_tm.blank, R_tm.blank$: 左移 / 右移至少一格并停在 $tm.blank$
  / $L_overline(tm.blank), R_overline(tm.blank)$: 左移 / 右移至少一格并停在非空符号
]

#components.left-and-right(
  figure(diagram(
    spacing: 2em,
    node((0, 0), name: <A>)[],
    node((1, 0), name: <B>)[$M_1 M_2$],
    node((2, 0), name: <C>)[$M_3$],
    node((1, 1), name: <D>)[$M_4$],
    edge(<A>, <B>, "->"),
    edge(<B>, <C>, "->")[$a$],
    edge(<B>, <D>, "->")[$b$],
    edge((<B.north-east>, 25%, <B.north>), (<B.north-east>, 75%, <B.north>), "->", bend: -130deg)[$c$],
  )),
  [
    - $M_1$ 停机后运行 $M_2$
    - $M_2$ 停机后根据当前位置的符号决定前往 $M_3$ 或 $M_4$ 或再次运行 $M_2$
  ],
)

== 图灵机的功能

#context [
  // #set text(size: 26pt)

  对于图灵机 $M = (K, Sigma, delta, s, H)$：
  - 识别语言 $L subset.eq Sigma_0$，其中 $Sigma_0 = Sigma - {tm.start, tm.blank}$
    - 对于输入 $w in Sigma_0^*$，从 $(s, tm.start underline(tm.blank) w)$ 开始运行
    / $M$ 判定（decide）$L$:
      - $H = {y, n}$
      - $forall w in L, (s, tm.start underline(tm.blank) w) tm.yield^* (y, ...)$
      - $forall w in Sigma_0^* - L, (s, tm.start underline(tm.blank) w) tm.yield^* (n, ...)$
    / $M$ 半判定（semidecide）$L$:
      - $forall w in L, exists h in H, (s, tm.start underline(tm.blank) w) tm.yield^* (h, ...)$
]

---

/ Recursive / Decidable: 存在图灵机判定的（语言）
/ Recursively Enumerable (R.E.) / Recognizable: \ 存在图灵机半判定的（语言）
- 假设 $A$ 和 $B$ 均为递归语言，则：
  - $A union B, A compose B, A^*, A inter B, overline(A)$ 都是递归语言
- 假设 $A$ 和 $B$ 均为递归可数语言，则：
  - $A union B, A compose B, A^*, A inter B$ 都是递归可数语言
  - $overline(A)$ 不一定递归可数

---

*例* 构造判定 $L = {w in {a, b, c}^*: w = a^n b^n c^n: n in NN}$ 的图灵机

#only("2-3")[
  #figure(diagram({
    let arrow(a, b, label-sep: 0pt, ..args) = edge(
      a,
      b,
      "->",
      ..args,
      label-angle: auto,
      label-sep: label-sep,
    )
    node((0, 0), name: <A>)[$R$]
    node((1, 0), name: <B>)[$d R$]
    node((2, 0), name: <C>)[$d R$]
    node((3, 0), name: <D>)[$d L_tm.blank$]
    node((0, 1), name: <Y>)[$y$]
    node((1, 1), name: <N>)[$n$]
    arrow(<A>, <B>)[$a$]
    arrow(<B>, <C>)[$b$]
    arrow(<C>, <D>)[$c$]
    arrow(<A>, <Y>)[$tm.blank$]
    arrow(<A>, <N>, label-sep: -40pt)[$b, c$]
    arrow(<B>, <N>)[$c, tm.blank$]
    arrow(<C>, <N>)[$a, tm.blank$]
    arrow((<A.north-west>, 75%, <A.north-east>), (<A.north-west>, 25%, <A.north-east>), bend: -130deg)[$d$]
    arrow((<B.north>, 75%, <B.north-east>), (<B.north>, 25%, <B.north-east>), bend: -150deg)[$a, d$]
    arrow((<C.north>, 75%, <C.north-east>), (<C.north>, 25%, <C.north-east>), bend: -150deg)[$b, d$]
    edge(<D>, "u", (-0.5, -1), "d", <A>, "->")[]
    edge((-1, 0), <A>, "->")
  }))
]

#only("3")[
  $w = a b c a b c in.not L$ 但 $M$ 接受了 $w$
]

#only("4-5")[
  #figure(diagram(spacing: 2.5em, {
    let arrow(a, b, label-sep: 0pt, ..args) = edge(
      a,
      b,
      "->",
      ..args,
      label-angle: auto,
      label-sep: label-sep,
    )
    node((0, 0), name: <A>)[$R$]
    node((1, 0), name: <B>)[$d R$]
    node((2, 0), name: <C>)[$d R$]
    node((3, 0), name: <D>)[$d R$]
    node((4, 0), name: <E>)[$L_tm.blank$]
    node((0, 1), name: <Y>)[$y$]
    node((1, 1), name: <N>)[$n$]
    node((-0.5, 0.1))[#sym.star]
    arrow(<A>, <B>)[$a$]
    arrow(<B>, <C>)[$b$]
    arrow(<C>, <D>)[$c$]
    arrow(<D>, <E>)[$tm.blank$]
    arrow(<A>, <Y>)[$tm.blank$]
    arrow(<A>, <N>, label-sep: -35pt)[$b, c$]
    arrow(<B>, <N>, label-sep: -35pt)[$c, tm.blank$]
    arrow(<C>, <N>)[$a, tm.blank$]
    edge(<D>, "d", <N>, "->", label-pos: 60%, label-sep: 0pt)[$a, b$]
    arrow((<A.north-west>, 75%, <A.north-east>), (<A.north-west>, 25%, <A.north-east>), bend: -130deg)[$d$]
    arrow((<B.north>, 75%, <B.north-east>), (<B.north>, 25%, <B.north-east>), bend: -150deg)[$a, d$]
    arrow((<C.north>, 75%, <C.north-east>), (<C.north>, 25%, <C.north-east>), bend: -150deg)[$b, d$]
    arrow((<D.north>, 75%, <D.north-east>), (<D.north>, 25%, <D.north-east>), bend: -150deg)[$c, d$]
    edge(<E>, "u", (-0.5, -1), "d", <A>, "->")[]
    edge((-1, 0), <A>, "->")
  }))
]

#only("5")[
  #set text(size: 23pt)

  从第二次开始，每当运行至 #sym.star 处时：
  - 纸带内容 $w' in L((a union d)^* (b union d)^* (c union d)^*)$
  - $a, b, c$ 的数量之和少于上次运行至 #sym.star 处（对任何输入必然会停机）
  - 最终在 $y$ 状态停机 #sym.arrow.l.r $w'$ 中 $a, b, c$ 数量相等
]

---

对于图灵机 $M = (K, Sigma, delta, s, H)$：
- 计算函数 $f: Sigma_0^* -> Sigma_0^*$
  - 对于 $w in Sigma_0^*$，如果 $exists h in H, y in Sigma_0^*, (s, tm.start underline(tm.blank) w) tm.yield^* (h, tm.start underline(tm.blank) y)$，则称 $y = M(w)$ 为 $M$ 在输入 $w$ 时的输出
  / $M$ 可计算 $f$: $forall w in Sigma_0^*, M(w) = f(w)$
- 数值计算：二进制编码

== 图灵机的扩展

图灵机的各种扩展都和标准图灵机等价
/ 多纸带: $k$ 条纸带，每条纸带一个读写头，输入输出放第一条纸带，$delta: (K - H) times Sigma^k -> K times (Sigma union {<-, ->})^k$
  - 将纸带分隔成 $2 k$ 段
    - $k$ 段用于标识多纸带图灵机上每条纸带的内容
    - $k$ 段由 0, 1 组成，用于标识多纸带图灵机上每条纸带上读写头的位置
  - 多纸带图灵机的每一步操作都逐纸带模拟
/ 双向无限纸带: 纸带两侧都可以无限延伸
  - 可以用双纸带图灵机模拟

---

/ 多读写头: 一条纸带，$k$ 个读写头
  - 把纸带分为 $k+1$ 段
    - 一段模拟纸带数据
    - 剩余 $k$ 段记录每个读写头的位置
/ 二维纸带: 纸带沿右、下无限延伸
  - 从左上角开始将所有格子沿反对角线编号，唯一映射到一维纸带上的位置

---

/ 随机访问: 由寄存器、一条单向纸带、程序组成，$M = (k, Pi)$
  #aligned-terms[
    / $k$: 寄存器的数量（每一个寄存器可以存放一个自然数）
    / $Pi$: 由指令序列 $(pi_1, pi_2, ..., pi_p)$ 组成的程序，$pi_p$ 为 `halt`
      - 具体指令集见课本 P211
  ]
  / 配置: $(kappa, R_0, R_1, ..., R_(k-1), T)$
    #aligned-terms[
      / $kappa$: 接下来要执行的指令编号
      / $R_i$: 寄存器状态
      / $T$: 纸带内容
    ]

---

构造方法：使用 $k+3$ 纸带的图灵机模拟
- 每个状态对应一条指令，无需在纸带上记录 $kappa$
- 纸带 1：程序开始时存放输入，`halt` 时存放输出
- 纸带 2：模拟过程中存放随机访问图灵机的内存
  - 地址 $i$ 的数据用 $(i, bold(E)(a_i))$ 表示，其中 $bold(E) : Sigma -> {0, ..., |Sigma|-1}$ 为符号的一种编码方案
- 纸带 3 至纸带 $k+2$：$k$ 个寄存器
- 纸带 $k+3$：存储中间计算结果的临时寄存器

== 非确定性图灵机（NTM）

- 五元组 $M = (K,Sigma,Delta,s,H)$
  - $Delta: ((K-H) times Sigma) times (K times ({<-, ->} union (Sigma - {triangle.stroked.r})))$
  - 半判定：存在一个分支停机
  - 判定：所有分支都能够停机，且存在一个分支进入接受状态
  - 计算函数：所有分支在有限时间内停机并输出相同
- 使用三纸带 DTM 模拟 NTM
  - 第一条纸带存放原始输入
  - 使用迭代加深搜索枚举所有非确定的决策
    - 第二条纸带存放 NTM 的纸带的当前状态
    - 第三条纸带存放每次决策的走向
    - 每次枚举新的决策方案时，将第一条纸带复制到第二条纸带
