import 'dart:core';
import 'dart:math';

class Question {
  String userName, platform;
  String description;
  double rating;


  Question(this.userName, this.platform, this.description,
      this.rating);

  static Question sampleQuestion() {
    Random r = Random();
    switch (r.nextInt(4)) {
      case 0:
        return Question("Ademar Aguiar", "Twitch", "Gosto muito de viaturas e estava interessado em comprar um automóvel de quatro rodas. Andei a considerar várias marcas, mas nem todas são boas o suficiente para mim. Seria melhor conduzir um BMW ou um Mercedes?", 5);
      case 1:
        return Question("João Cardoso", "Zoom", "A stream parou outra vez, pode por a funcionar outra vez, por favor?", 0.2);
      case 2:
        return Question("A Strange Duck", "YouTube", "I've been trying to contact YouTube all day to come to my place film me so I can create content, how do other people get their videos out? I have lots of ideas but they won't come :saderCrack:", 4.3);
      case 3:
        return Question("Maria Pia", "Twitch", "Estou indecisa entre um carro híbrido ou elétrico. Qual é que acha melhor para conduzir de casa para o trabalho?", 3.8);
    }
  }
}
