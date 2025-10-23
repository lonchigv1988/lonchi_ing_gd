
class Photos {
  final int? id;
  final itemId;
  final proyectoId;
  final reportId;
  final String? photo;
  Photos({this.id, this.itemId, this.proyectoId, this.reportId, this.photo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'proyectoId':proyectoId,
      'reportId': reportId,
      'photo': photo,
    };
  }
}

class Logo {
  final int? id;
  final int? proyectoId;
  final String? photo;
  Logo({this.id, this.proyectoId, this.photo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'proyectoId':proyectoId,
      'photo': photo,
    };
  }
}