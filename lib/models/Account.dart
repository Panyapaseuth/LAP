// To parse this JSON data, do
//
//     final account = accountFromJson(jsonString);

import 'dart:convert';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account {
  Account({
    this.accountId,
    this.accountName,
    this.balance,
    this.status,
  });

  String accountId;
  String accountName;
  int balance;
  String status;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    accountId: json["account_id"] == null ? null : json["account_id"],
    accountName: json["account_name"] == null ? null : json["account_name"],
    balance: json["balance"] == null ? null : json["balance"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "account_id": accountId == null ? null : accountId,
    "account_name": accountName == null ? null : accountName,
    "balance": balance == null ? null : balance,
    "status": status == null ? null : status,
  };

  @override
  String toString() {
    return 'Account{accountId: $accountId, accountName: $accountName, balance: $balance, status: $status}';
  }
}
