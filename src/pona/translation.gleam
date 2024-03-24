pub type WordTranslation {
    WordTranslation(
	commentary: String,
	definition: String
    )
}

pub fn get_commentary(translation: WordTranslation) -> String {
    translation.commentary
}

pub fn get_definition(translation: WordTranslation) -> String {
    translation.definition
}
