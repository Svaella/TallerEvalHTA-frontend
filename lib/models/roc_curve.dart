class RocCurve {
  final List<double> fpr;
  final List<double> tpr;

  RocCurve({
    required this.fpr,
    required this.tpr,
  });

  factory RocCurve.fromJson(Map<String, dynamic> json) {
    return RocCurve(
      fpr: List<double>.from(json['fpr'].map((x) => x.toDouble())),
      tpr: List<double>.from(json['tpr'].map((x) => x.toDouble())),
    );
  }
}
