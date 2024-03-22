import gleam/httpc
import gleam/result
import gleam/http/request
import gleam/json
import gleam/dynamic.{field, dict, string}
import gleam/dict.{type Dict}

pub const sona_linku: String = "https://raw.githubusercontent.com/lipu-linku/jasima/main/data.json"

pub type WordFetcher {
    WordFetcher(
	word: String,
	lang: String
    )
}

type WordIntermediate {
    WordIntermediate(
	def: Dict(String, String),
	word: String
    )
}

pub type WordError {
    JSONDecodeError(json.DecodeError)
    DynamicError(dynamic.Dynamic)
    WordNotFound(String)
    DataParsingError(String)
}

type WordDataset {
    Data(
	data: Dict(String, WordIntermediate)
    )
}

pub type Word {
    Word(
	word: String,
	def: String
    )
}

pub fn word(word: String) -> WordFetcher {
    WordFetcher(
	word,
	"en"
    )
}

pub fn language(wf: WordFetcher, new: String) -> WordFetcher {
    WordFetcher(wf.word, new)
}

pub fn fetch(wf: WordFetcher) -> Result(Word, WordError) {
    let assert Ok(req) = 
	request.to(sona_linku)

    let resp =
	result.replace_error(httpc.send(req), DynamicError)

    let body = case resp {
	Ok(resp) -> resp.body
	Error(_) -> ""
    }

    let word_decoder = dynamic.decode2(
	WordIntermediate,
	// dict(string, string),
	// string("def")
	field("def", dict(string, string)),
	field("word", string),
    )

    let data_decoder = dynamic.decode1(
	Data,
	field("data", dict(string, word_decoder))
    )

    let data_decoded = 
	json.decode(from: body, using: data_decoder)
	|> result.replace_error(DataParsingError("There was an error parsing the data!"))

    let data = case data_decoded {
	Ok(data) -> data
	Error(_) -> Data(data: dict.new())
    }

    let interword =
	data.data
	|> dict.get(wf.word)
	|> result.replace_error(WordNotFound("The word you were looking for was not found!"))
   
    case interword {
	Ok(iw) -> {
	    Ok(Word(
		word: iw.word,
		def:
		    dict.get(iw.def, wf.lang)
		    |> result.unwrap("could not get definition")
	    ))
	}
	Error(_) -> Error(WordNotFound("The word you were looking for was not found!"))
    }
}

pub fn get_definition(word: Word) -> String {
    word.def
}
