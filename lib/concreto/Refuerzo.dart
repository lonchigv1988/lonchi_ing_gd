class Rebar {
  String Name; double db; double ab;

  Rebar({required this.Name, required this.db, required this.ab});

  int get hashCode => Name.hashCode;

  bool operator==(Object other) => other is Rebar && other.Name == Name;

  @override
  String toString() {
    return 'Rebar: {Name: ${Name}}';
  }
}

RebarCalc() {
  List Calc = [
    Rebar(Name: '#0', db: 0.0, ab: 0.0),
    Rebar(Name: '#2', db: 0.635, ab: 0.32),
    Rebar(Name: '#3', db: 0.952, ab: 0.71),
    Rebar(Name: '#4', db: 1.27, ab: 1.29),
    Rebar(Name: '#5', db: 1.59, ab: 2),
    Rebar(Name: '#6', db: 1.91, ab: 2.84),
    Rebar(Name: '#7', db: 2.22, ab: 3.87),
    Rebar(Name: '#8', db: 2.54, ab: 5.09),
    Rebar(Name: '#9', db: 2.87, ab: 6.45),
    Rebar(Name: '#10', db: 3.23, ab: 8.19),
    Rebar(Name: '#11', db: 3.58, ab: 10.06),
    Rebar(Name: '#14', db: 4.3, ab: 14.52),
  ];
  return Calc;
}

class epox {
  String Name; double ee;

  epox({required this.Name, required this.ee});

  int get hashCode => Name.hashCode;

  bool operator==(Object other) => other is epox && other.Name == Name;

  @override
  String toString() {
    return 'epox: {Name: ${Name}}';
  }
}

epoxList() {
  List lista = [
    epox(Name: 'sin epox', ee: 1.0),
    epox(Name: 'con epox', ee: 1.2),
  ];
  return lista;
}
