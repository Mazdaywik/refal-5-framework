Библиотека `Refal5-AST`
=======================

Абстратное синтаксическое дерево Рефала-5.

Библиотека описывает узлы абстрактного синтаксического дерева для Рефала-05
и определяет функцию `Builtins`.

### Описание абстрактного синтаксического дерева

    t.Refal5-AST ::= t.Unit*
    t.Unit ::= t.Function | t.Extern | t.SpecialComment
    t.Extern ::= (Extern (e.Name)*)
    t.SpecialComment ::= (SpecialComment t.SrcPos e.Text)

    t.Function ::= (Function t.SrcPos (e.Name) s.Scope t.Sentence+)
    s.Scope ::= Entry | Local
    t.Sentence ::= (t.Pattern (Condition t.Result t.Pattern)* e.SentenceTail)
    e.SentenceTail ::= RETURN t.Result | CALL-BLOCK t.Result t.Sentence*

    t.Pattern, t.Result ::= (t.Term*)
    t.Term ::=
        (Symbol Word t.SrcPos e.Chars*)
      | (Symbol Number s.Number)
      | (Symbol Char s.Char)
      | (Variable t.SrcPos s.VarType e.Index)
      | (Brackets t.Term*)
      | (Call t.SrcPos (e.Function) t.Terms*)
    s.VarType ::= 's' | 't' | 'e'

* `t.Unit` — элемент верхнего уровня: функция, объявление `$EXTERN` или
  специальный комментарий.
* `t.Function` — определение функции на Рефале.
* `t.Extern` — последовательность имён, объявленная одной директивой `$EXTERN`.
* `t.SpecialComment` — специальный комментарий — строка, которая начинается
  с `*$` и расположена вне функции.
* `s.Scope` — область видимости функции, `Entry` для функций, определённых
  с ключевым словом `$ENTRY` и `Local` для функций без этого ключевого слова.
* `t.Sentence` — предложение функции. Состоит из образца, нуля и более условий
  и окончания предложения
* `t.Pattern` — образцовое выражение.
* `e.SentenceTail` — окончание предложения. Может быть либо простой правой
  частью (`RETURN`), либо вызовом блока (`CALL-BLOCK`).
* `t.Result` — результатное выражение.
* `t.Term` — терм выражения, может быть:
  - `Symbol Word` — словом (составным символом),
  - `Symbol Number` — макроцифрой,
  - `Symbol Char` — литерой,
  - `Variable` — переменной,
  - `Brackets` — скобочным термом,
  - `Call` — вызовом функции (недопустим внутри образца).
* `s.VarType` — тип переменной.

### Функция `Builtins`

    <Builtins> == (e.FunctionName)*

    e.FunctionName ::= s.CHAR+

Функция возвращает имена встроенных функций, включая сокращённые имена для
арифметических операций (`+`, `-`, `/`, `%`, `*`, `?`).
