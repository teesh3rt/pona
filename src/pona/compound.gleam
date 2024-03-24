import gleam/httpc
import gleam/http/request
import gleam/result
import gleam/dict.{type Dict}
import gleam/dynamic.{dict, int, string}
import gleam/json

const nimi_pona = "https://nimi.pona.la/en-tp.json"

pub type CompoundFetcher {
  CompoundFetcher(english: String)
}

pub type CompoundError {
  DynamicError(dynamic.Dynamic)
  WordNotFound(String)
}

pub type Compound {
  Compound(word: String, definitions: Dict(String, Int))
}

pub fn compound(english: String) -> CompoundFetcher {
  CompoundFetcher(english)
}

pub fn fetch(fetcher: CompoundFetcher) -> Result(Compound, CompoundError) {
  let assert Ok(req) = request.to(nimi_pona)

  let resp = result.replace_error(httpc.send(req), DynamicError)

  let body = case resp {
    Ok(resp) -> resp.body
    Error(_) -> "{}"
  }

  let data_decoder = dict(string, dict(string, int))

  let data =
    json.decode(from: body, using: data_decoder)
    |> result.unwrap(dict.new())

  let result =
    data
    |> dict.get(fetcher.english)

  case result {
    Ok(definitions) -> Ok(Compound(fetcher.english, definitions))
    Error(_) -> Error(WordNotFound("Word not found:" <> fetcher.english))
  }
}

pub fn get_definitions(compound: Compound) -> Dict(String, Int) {
  compound.definitions
}
