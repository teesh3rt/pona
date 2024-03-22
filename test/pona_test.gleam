import gleeunit
import gleeunit/should
import pona/word
import gleam/result

pub fn main() {
    gleeunit.main()
}

pub fn word_eng_test() {
    word.word("toki")
    |> word.fetch
    |> result.unwrap(word.Word("nimi", "name, word"))
    |> word.get_definition
    |> should.equal("communicate, say, speak, talk, use language, think; hello")
}

pub fn word_es_test() {
    word.word("jan")
    |> word.language("es")
    |> word.fetch
    |> result.unwrap(word.Word("nimi", "name, word"))
    |> word.get_definition
    |> should.equal("ser humano, persona, alguien")
}
