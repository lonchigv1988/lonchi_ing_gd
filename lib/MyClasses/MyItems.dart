
class Items {
  final int? id;
  final int? proyectoId;
  final int? reportId;
  final String? description;
  final String? photo;
  final int? count;
  Items({this.id, this.proyectoId, this.reportId, this.description, this.photo, this.count});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'proyectoId': proyectoId,
      'reportId': reportId,
      'description': description,
      'photo': photo,
      'count': count,
    };
  }
}
