class HintService {
  String getHint(String answer) {
    final trimmedAnswer = answer.trim();

    if (trimmedAnswer.isEmpty) {
      return '';
    }

    final words = trimmedAnswer.split(' ');

    if (words.length == 1) {
      return '${words[0]} _';
    }

    return '${words.first} _';
  }
}