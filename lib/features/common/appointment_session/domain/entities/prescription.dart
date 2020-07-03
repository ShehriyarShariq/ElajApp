class Prescription {
  String appointmentID;
  List<Medicine> medicines;

  Prescription({this.medicines});

  factory Prescription.fromJson(List<dynamic> jsonList) =>
      Prescription(medicines: _decodeMedicinesList(jsonList));

  List toJson() {
    return _encodeMedicinesList(medicines);
  }

  static List _encodeMedicinesList(List<Medicine> medicines) {
    List list = List();
    medicines.forEach((medicine) {
      list.add(medicine.toJson());
    });
    return list;
  }

  static List<Medicine> _decodeMedicinesList(List list) {
    List<Medicine> medicines = List();
    list.forEach((item) {
      medicines.add(Medicine.fromJson(item));
    });
    return medicines;
  }
}

class Medicine {
  String name, dosage;

  Medicine({this.name, this.dosage});

  factory Medicine.fromJson(Map<String, String> json) =>
      Medicine(name: json['name'], dosage: json['dosage']);

  Map<String, String> toJson() {
    return {'name': name, 'dosage': dosage};
  }
}
