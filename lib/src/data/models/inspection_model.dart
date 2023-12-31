class InspectionModel {
  final String type;
  final String productID;
  final String doer;
  final String comment;
  final String result;
  final String date;
  final String nextDate;
  final String nr;

  InspectionModel(
      {required this.nr,
      required this.date,
      required this.nextDate,
      this.comment = '',
      required this.result,
      required this.type,
      required this.productID,
      required this.doer});

  factory InspectionModel.fromMap(Map<String, dynamic> data) {
    final String type = data['type'];
    final String productID = data['productID'];
    final String doer = data['doer'];
    final String comment = data['comment'];
    final String result = data['result'];
    final String date = data['date'];
    final String nextDate = data['nextDate'];
    final String nr = data['nr'];

    return InspectionModel(
      type: type,
      productID: productID,
      doer: doer,
      comment: comment,
      result: result,
      date: date,
      nextDate: nextDate,
      nr: nr,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'productID': productID,
      'doer': doer,
      'comment': comment,
      'result': result,
      'date': date,
      'nextDate': nextDate,
      'nr': nr,
    };
  }
}
