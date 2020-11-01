import 'dart:core';
import 'dart:math';

class Question {
  String userName, platform;
  String description;
  double rating;

  Question(this.userName, this.platform, this.description, this.rating);

  static Question randomQuestion() {
    Random r = Random();
    return sampleQuestion(r.nextInt(4));
  }

  static Question sampleQuestion(int index) {
    switch (index) {
      case 0:
        return Question(
            "Carlos Pereira",
            "Twitch",
            "Gosto muito de viaturas e estava interessado em comprar um automóvel de quatro rodas. Andei a considerar várias marcas, mas nem todas são boas o suficiente para mim. Seria melhor conduzir um BMW ou um Mercedes?",
            5);
      case 1:
        return Question(
            "João Cardoso",
            "Zoom",
            "A stream parou outra vez, pode por a funcionar outra vez, por favor?",
            0.2);
      case 2:
        return Question(
            "A Strange Duck",
            "YouTube",
            "I've been trying to contact YouTube all day to come to my place film me so I can create content, how do other people get their videos out? I have lots of ideas but they won't come :saderCrack:",
            4.3);
      case 3:
        return Question(
            "Maria Pia",
            "Twitch",
            "Estou indecisa entre um carro híbrido ou elétrico. Qual é que acha melhor para conduzir de casa para o trabalho?",
            3.8);
    }
  }

  Question clone() {
    return Question(userName, platform, description, rating);
  }

  void updateDescription(String desc) {
    this.description = desc;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question &&
          runtimeType == other.runtimeType &&
          userName == other.userName &&
          platform == other.platform &&
          description == other.description &&
          rating == other.rating;

  @override
  int get hashCode =>
      userName.hashCode ^
      platform.hashCode ^
      description.hashCode ^
      rating.hashCode;
}
