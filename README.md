# Pona - A library for toki pona

An example program:

```gleam
import pona/word
import gleam/io
import gleam/result

pub fn main() {
    word.word("toki")
    |> word.fetch
    |> result.unwrap(word.Word("nimi", "name, word"))
    |> word.get_definition
    |> io.println

    word.word("jan")
    |> word.language("es")
    |> word.fetch
    |> result.unwrap(word.Word("nimi", "name, word"))
    |> word.get_definition
    |> io.println
}
```
