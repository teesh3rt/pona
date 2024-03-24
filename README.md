# Pona - A library for toki pona

An example program:

```gleam
import pona/word
import pona/translation
import gleam/io
import gleam/result

pub fn word_definition_test() {
  let assert Ok(word) =
    word.word("toki")
    |> word.fetch

  let assert Ok(translation) =
    word
    |> word.get_translation("en")

  translation
  |> translation.get_definition()
  |> io.println
}
```
