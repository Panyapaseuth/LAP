// To parse this JSON data, do
//
//     final transaction = transactionFromJson(jsonString);

import 'dart:convert';

Transaction transactionFromJson(String str) => Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

class Transaction {
  Transaction({
    this.tranxId,
    this.accountId,
    this.date,
    this.tranxTypeEn,
    this.income,
    this.credit,
    this.debit,
    this.description,
    this.toOrFromAcc,
    this.toOrFromName,
    this.feeId,
  });

  String tranxId;
  String accountId;
  String date;
  String tranxTypeEn;
  bool income;
  int credit;
  int debit;
  String description;
  String toOrFromAcc;
  String toOrFromName;
  int feeId;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    tranxId: json["tranx_id"] == null ? null : json["tranx_id"],
    accountId: json["account_id"] == null ? null : json["account_id"],
    date: json["date"] == null ? null : json["date"],
    tranxTypeEn: json["tranx_type_en"] == null ? null : json["tranx_type_en"],
    income: json["income"] == null ? null : json["income"],
    credit: json["credit"] == null ? null : json["credit"],
    debit: json["debit"] == null ? null : json["debit"],
    description: json["description"] == null ? null : json["description"],
    toOrFromAcc: json["to_or_from_acc"] == null ? null : json["to_or_from_acc"],
    toOrFromName: json["to_or_from_name"] == null ? null : json["to_or_from_name"],
    feeId: json["fee_id"] == null ? null : json["fee_id"],
  );

  Map<String, dynamic> toJson() => {
    "tranx_id": tranxId == null ? null : tranxId,
    "account_id": accountId == null ? null : accountId,
    "date": date == null ? null : date,
    "tranx_type_en": tranxTypeEn == null ? null : tranxTypeEn,
    "income": income == null ? null : income,
    "credit": credit == null ? null : credit,
    "debit": debit == null ? null : debit,
    "description": description == null ? null : description,
    "to_or_from_acc": toOrFromAcc == null ? null : toOrFromAcc,
    "to_or_from_name": toOrFromName == null ? null : toOrFromName,
    "fee_id": feeId == null ? null : feeId,
  };
}
