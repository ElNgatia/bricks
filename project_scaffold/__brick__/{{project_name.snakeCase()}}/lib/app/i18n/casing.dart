/// Upper-cases the first letter, for a lower-case term form that starts a sentence.
String sentenceCase(String text) =>
    text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

/// Upper-cases the first letter of every word, for a lower-case term form
/// used as a label.
String titleCase(String text) => text
    .split(' ')
    .map((word) => word.isEmpty ? word : sentenceCase(word))
    .join(' ');

