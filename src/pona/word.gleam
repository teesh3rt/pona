import gleam/httpc
import gleam/result
import gleam/http/request
import gleam/json
import gleam/string
import gleam/dynamic.{dict, field, list, string}
import gleam/dict.{type Dict}
import pona/translation.{type WordTranslation, WordTranslation}

pub const sona_linku: String = "https://api.linku.la/v1/words/"

pub type WordFetcher {
  WordFetcher(word: String, lang: List(String))
}

pub type Word {
  Word(
    id: String,
    book: String,
    coined_era: String,
    coined_year: String,
    source_language: String,
    usage_category: String,
    translations: Dict(String, WordTranslation),
    creator: List(String),
  )
}

pub type WordError {
  JSONDecodeError(json.DecodeError)
  DynamicError(dynamic.Dynamic)
  WordNotFound(String)
  WordParsingError(String)
  TranslationNotFound(String)
}

pub fn word(word: String) -> WordFetcher {
  WordFetcher(word, ["en"])
}

pub fn language(wf: WordFetcher, new: String) -> WordFetcher {
  WordFetcher(wf.word, [new, ..wf.lang])
}

pub fn fetch(wf: WordFetcher) -> Result(Word, WordError) {
  let comma_seperate = string.join(_, ",")

  let assert Ok(req) =
    request.to(sona_linku <> wf.word <> "?lang=" <> comma_seperate(wf.lang))

  let resp = result.replace_error(httpc.send(req), DynamicError)

  let body = case resp {
    Ok(resp) -> resp.body
    Error(_) -> ""
  }

  let word_translation_decoder =
    dynamic.decode2(
      WordTranslation,
      field("commentary", string),
      field("definition", string),
    )

  let word_decoder =
    dynamic.decode8(
      Word,
      // dict(string, string),
      // string("def"),
      field("id", string),
      field("book", string),
      field("coined_era", string),
      field("coined_year", string),
      field("source_language", string),
      field("usage_category", string),
      field("translations", dict(string, word_translation_decoder)),
      field("creator", list(string)),
    )

  let word =
    json.decode(from: body, using: word_decoder)
    |> result.replace_error(WordParsingError(
      "There was an error parsing the word!",
    ))

  word
}

pub fn get_translation(
  word: Word,
  lang: String,
) -> Result(WordTranslation, WordError) {
  word.translations
  |> dict.get(lang)
  |> result.replace_error(TranslationNotFound(
    "The translation for the language "
    <> lang
    <> " was not found for word "
    <> word.id,
  ))
}
