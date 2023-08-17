

class Rewards {
  String id;
  String name;
  int pointsRequired;

  Rewards({
    this.id,
    this.name,
    this.pointsRequired,
  });

  Rewards.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    pointsRequired = data['pointsRequired'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pointsRequired': pointsRequired,
    };
  }
}
