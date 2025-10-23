class Report {
  final int? id;
  final int? proyectoId;
  final String? ProyectTitle;
  final String? title;
  final String? date;
  final int? count;
  final int? datetime;
  Report({this.id, this.proyectoId, this.ProyectTitle, this.title, this.date, this.count, this.datetime});
  // Report({this.id, this.title, this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'proyectoId': proyectoId,
      'ProyectTitle': ProyectTitle,
      'title': title,
      'date' : date,
      'count' : count,
      'datetime': datetime,
    };
  }
}

class Proyecto {
  final int? id;
  final String? title;
  final int? count;
  final String? photo;
  Proyecto({this.id, this.title, this.count, this.photo});
  // Report({this.id, this.title, this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'count' : count,
      'photo': photo,
    };
  }
}