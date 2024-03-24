import gleeunit
import gleeunit/should
import pona/word
import pona/translation

pub fn main() {
    gleeunit.main()
}

// pub fn word_eng_test() {
//     word.word("toki")
//     |> word.fetch
//     |> result.unwrap(word.Word("nimi", "name, word"))
//     |> word.get_definition
//     |> should.equal("communicate, say, speak, talk, use language, think; hello")
// }
//
// pub fn word_es_test() {
//     word.word("jan")
//     |> word.language("es")
//     |> word.fetch
//     |> result.unwrap(word.Word("nimi", "name, word"))
//     |> word.get_definition
//     |> should.equal("ser humano, persona, alguien")
// }

pub fn word_fetcher_test() {
    word.word("toki")
    |> should.equal(word.WordFetcher("toki", ["en"]))
}


pub fn word_translation_test() {
    let assert Ok(word) =
	word.word("toki")
	|> word.fetch

    let assert Ok(translation) =
	word
	|> word.get_translation("en")

    translation
    |> should.equal(translation.WordTranslation("", "communicate, say, speak, talk, use language, think; hello"))
}

pub fn word_definition_test() {
    let assert Ok(word) =
	word.word("toki")
	|> word.fetch

    let assert Ok(translation) =
	word
	|> word.get_translation("en")

    translation
    |> translation.get_definition()
    |> should.equal("communicate, say, speak, talk, use language, think; hello")
}
