class Score{
  late final int id;
  late final int points;

  Score({required this.id,required this.points});

  Map<String,dynamic> toMap(){
    return {
      'points': points,
    };
  }

}