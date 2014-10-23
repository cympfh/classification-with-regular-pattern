(正規)パターン言語
===

パターンとは、以下のpattern として定められるもの。

```
Sigma: alphabet (aka Hiragana)
X: vars

pattern = (Sigma or X)+
```

ここで、同じ変数は一度しか登場しないものを 正規パターンという。

パターン p に出現する変数に、空も含む、任意の文字列を代入してできる文字列の集合を、
パターン p が生成する言語 L(p) という。

パターン集合 `Pi = {p1, p2 ..}`
が生成する言語を
```
L(Pi) = L(p1) or L(p2) or ...
```
と定める.

パターン p にある代入を行うことで パターン q が生成されるような関係にあるときを、
```
p -> q
```
と書く。

> 嘘です。
> `q \preceq p`
> と書きます。
> 半順序

`p is generalization of q` と読む。

文字列は自然にパターンに変換することができる。
これを同一視する。

二つのパターン s, t に対して
```
p -> s
p -> t
```
という p を s, t の共通汎化と呼び、
s, t についての、pとは異なる任意の共通汎化 p' に対して

```
p -/> p' (not generalization)
```

のとき、pを極小であるという。

例えば、
`dog and cat`,
`cat and dog`
の共通汎化として

`X and Y`, `X Y`, `X`
がありえる.
言おうと思えばもっとある。

```
"X and Y" -/> "X Y"
"X and Y" -/> "X"
```

なので、`X and Y` が極小っぽそうで、
実際そうであるはず。

次は少し複雑な例である。

```
s = ab
t = ba
```

の共有汎化は

```
p1 = X
p2 = aX
p3 = Xb
p4 = XaY
p5 = XbY
```

があって、これが全てである。

p2, p3 はどちらの極小共有汎化になっている。

```
p2 -/> others
p3 -/> others
```

その名の示す通り、極小は一つとは限らない。

たぶん、「地の文」の部分をできるだけ大きくとって、
変数の数をできるだけ減らしてできた共通汎化は極小になっている。

mcp.coffee
---

二つの文字列から、極小の共有汎化 (minimum common generalization) の一つを探す。
二つの文字列の長さを`n,m`とするとき`O(nm)`で動く。


パターン分類
===

さて、文章について、二つのクラス、P, Q があるとき、
Pに属する文章は、
あるパターン集合 `PiP` によって、
Qに属する文章は、
あるパターン集合 `PiQ` によって、
生成されるという仮定を立てる。

Pの為の訓練データ (文章の集合) TP と、
Qの為のそれ、TQ を用意したときに、

PiP, PiQ を構成ですれば、
適当に、未知の文章 U に対して、
スコア附けてPかQか判定できる。

extract-pattern.coffee
---

以下を `k` 回繰り返す

> 同じクラスのドキュメントからランダムに2文を選択し、
> その極小共通汎化 `p` を求める。
> 
> `p` の有用さを、相互情報量で計る。
> また、`p` が最も多くマッチしたクラスを `k` とする。
> `k` は、初め選んだドキュメントのクラスと一致していてほしいのだけど、
> そう上手くも行かなかった。
> 
> 閾値 `m` を設定し、(今は `0` としている)
> 相互情報量が `m` よりも真に大きかったら、
> `p`
> を
> `k` 向けのパターンとして、その相互情報量とペアにして持つ。

一度取り出したパターンによって、
その言語を元のドキュメントから削除する、というのもあったけど、
今回はしていない。
つまり、同じパターンが何度も取れてしまうかもしれない。

それでもいいと思う。
だって、パターンごとに重みをつけることをしないから。

各クラス向けパターン集合から、
相互情報量でソートして、トップの1%だけを
取り出して、これを結果として返す。

pattern-classify.coffee
---

パターン集合の配列、
あるいは

```javascript
{
  positive: []
  negative: []
}
```
で表現されるようなパターン集合の集合 (要するに extract_pattern.coffee の返り値)
と、ドキュメント (文の集合)
を取って、
クラスを返す。
クラスとは、パターン集合の配列のときには、そのインデックス、
そうでないときは 'positive', 'negative' という文字列。

さて、分類は単なる多数決.

index.coffee
===

i-th element が
i-th class document (文の集合)
である配列 `docs`
を用意したとき,

```coffee
patterns = extract docs
```

は、i-th element が i-th class 向けの
パターン集合である配列。
これを用いて、未知の document `doc` についての分類は、

```coffee
k = classify pattern, doc
```

とする。 (0 <= k <= n-1)

同じだけど、二値分類の時は、

```coffee
patterns = extract
  positive: doc_P
  negative: doc_Q

label = classify patterns, doc
# label = 'positive' or 'negative'
```

author/
===

作者別に、小説にはパターンがあるのではないか。

### Dazai class - 斜陽, ダスゲマイネ, 女生徒
curl http://www.aozora.gr.jp/cards/000035/files/1565_8559.html | nkf > doc/d_a
curl http://www.aozora.gr.jp/cards/000035/files/42945_14904.html | nkf > doc/d_b
curl http://www.aozora.gr.jp/cards/000035/files/275_13903.html | nkf > doc/d_c

### Shimazaki class - 嵐, 朝飯, 食堂
curl http://www.aozora.gr.jp/cards/000158/files/1511_20470.html | nkf > doc/s_a
curl http://www.aozora.gr.jp/cards/000158/files/2949_48819.html | nkf > doc/s_b
curl http://www.aozora.gr.jp/cards/000158/files/47172_34186.html | nkf > doc/s_c

青空文庫から、htmlファイルをダウンロードして、
句点のみで文として区切って、一つのdocumentとして扱う。
htmlタグの除去はしてない。
`nkf`しているのは、utf-8にしたいから。

```bash
cd author
make
```

```
result is Shimazaki and expected is Dazai
result is Dazai and expected is Dazai
result is Dazai and expected is Dazai
result is Shimazaki and expected is Shimazaki
result is Shimazaki and expected is Shimazaki
result is Shimazaki and expected is Shimazaki
```

## 学習されたパターン

`learned.json` として学習したパターンを出力した.
重複があることに註意。

### Dazai class

- X、X、X
- おX、X
- Xのだ
- XんXてX、X
- XんXてX、X
- X、X
- X、X
- X、X
- X、X
- X、X

### Shimazaki class

- X&lt;bXrX
が8つ

ひどかった。
Shimazaki class の
(X&lt;bXrX)
は、明らかに、改行タグのことだろう。
