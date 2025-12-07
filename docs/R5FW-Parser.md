Библиотека `R5FW-Parser`
========================

<div id="toc"></div>
<script src="toc.js"></script>
<script>
makeTOC.localizedHeader = "Содержание"
makeTOC.localizedShow = "Показать";
makeTOC.localizedHide = "Скрыть";
</script>

Токены (лексические домены) Рефала-5
------------------------------------

    t.Token ::= (s.TokType t.Pos e.TokValue)

    s.TokType ~ e.TokValue ::=
      TkName ~ s.CHAR*
      TkCompound ~ s.CHAR*
      TkMacroDigit ~ s.NUMBER
      TkChar ~ s.CHAR
      TkVariable ~ s.VarType e.VarName
      TkOpenBracket, TkCloseBracket, TkCloseCall,
      TkOpenBlock, TkCloseBlock ~ пусто
      TkOpenCall ~ s.CHAR* -- имя функции
      TkComma, TkColon, TkAssign, TkSemicolon ~ пусто
      TkExtern, TkEntry ~ пусто
      TkSpecComment ~ char*
      TkEOF ~ пусто
      TkError ~ s.CHAR* -- сообщение об ошибке в лексике
    s.VarType ::= 's' | 't' | 'e'

Каждый токен содержит тег токена, позицию в исходном тексте и необязательный
атрибут токена.

* `s.TokType` — тег токена,
* `t.Pos` — позиция в исходном файле,
* `e.TokValue` — атрибут токена.

Токены:

* `TkName` — идентификатор (имя функции или составной символ в идентификаторной
  форме), атрибут — последовательность литер.
* `TkCompound` — составной символ, записанный в двойных кавычках. Атрибут —
  последовательность литер (escape-последовательности преобразованы в их
  значения).
* `TkMacroDigit` — макроцифра, атрибут — её значение.
* `TkChar` — токен-литера, атрибут — литера. Если несколько токенов записаны
  внутри одних кавычек, каждому из них соответствует отдельный токен `TkChar`.
  Например, `'H20'` → `(TkChar t.1 'H') (TkChar t.2 '2') (TkChar t.3 'O')`.
* `TkVariable` переменная, атрибут — её тип (s, t или e) и её индекс.
* Знаки пунктуации без атрибутов:

Токен            | Смысл
-----------------|-------
`TkOpenBracket`  | `(`
`TkCloseBracket` | `)`
`TkCloseCall`    | `>`
`TkOpenBlock`    | `{`
`TkCloseBlock`   | `}`
`TkComma`        | `,`
`TkColon`        | `:`
`TkAssign`       | `=`
`TkSemicolon`    | `;`

* `TkOpenCall` — открывающая угловая скобка, атрибут — имя вызываемой функции.
* `TkSpecComment` — комментарий, начинающийся на `*$`. Атрибут — текст
  комментария (включая знаки `*$` в начале).
* `TkEOF` — служебный токен конца файла.
* `TkError` — служебный токен, сообщение о лексической ошибке.


Абстратное синтаксическое дерево Рефала-5
-----------------------------------------

    t.Refal5-AST ::= t.Unit*
    t.Unit ::= t.Function | t.Extern | t.SpecialComment
    t.Extern ::= (Extern (t.SrcPos e.Name)*)
    t.SpecialComment ::= (SpecialComment t.SrcPos e.Text)

    t.Function ::= (Function t.SrcPos (e.Name) s.Scope t.Sentence+)
    s.Scope ::= Entry | Local
    t.Sentence ::= (t.Pattern (Condition t.Result t.Pattern)* e.SentenceTail)
    e.SentenceTail ::= RETURN t.Result | CALL-BLOCK t.Result t.Sentence*

    t.Pattern, t.Result ::= (t.Term*)
    t.Term ::=
        (Symbol Word e.Chars*)
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


Лексический анализатор для Рефала-5
-----------------------------------

Возвращает строковое (человекочитаемое) представление данного лексического
домена.

    <TokName s.TokType> == s.CHAR*

Лексический анализатор для Рефала-5, для указанного файла формирует
последовательность токенов.

    <Scan e.SourceFile> == t.Token*
    t.Pos ::= (s.Line s.Col e.FileName)

Возвращает последовательность токенов для данного файла.

Позиция в исходном тексте, формируемая лексическим анализатором, содержит
номер колонки, строки и имя файла.

    <ScanString-FromPos t.InitPos e.String> == e.Tokens
    t.InitPos ::= t.Pos

Разбивает строку на токены, начальной позицией принимается `t.InitPos`.


Синтаксический анализатор для Рефала-5
--------------------------------------

    <Builtins> == (e.FunctionName)*

    e.FunctionName ::= s.CHAR+

Функция возвращает имена встроенных функций, включая сокращённые имена для
арифметических операций (`+`, `-`, `/`, `%`, `*`, `?`).

    <Parse e.Tokens>
      == Success e.Refal5-AST
      == Fails t.Error*

    t.Error ::= (t.SrcPos e.Message)

Функция `Parse` принимает последовательность токенов и возвращает абстрактное
синтаксическое дерево.

Если файл содержит корректный текст на Рефале, функция возвращает `Success`
и синтаксическое дерево. Иначе функция возвращает `Fails` и список ошибок.
Таким образом, возвращаемое дерево всегда соответствует корректной программе.

К позициям токенов парсер относится как к чёрному ящику, внутрь `t.SrcPos`
не заглядывает.

* `t.Error` — сообщение о синтаксической или семантической ошибке.
