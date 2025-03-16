enum PersonState {
  available,
  busy,
  unknown,
}

class Person {
  final String name;
  final int age;
  final PersonState state;

  Person({
    required this.name,
    required this.age,
    required this.state,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String,
      age: json['age'] as int,
      state: PersonState.values.firstWhere(
        (e) => e.toString() == 'PersonState.${json['state']}',
        orElse: () => PersonState.unknown,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'state': state.toString().split('.').last,
    };
  }
}


