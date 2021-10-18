import 'package:LAP/screen/transfer/Transfer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

showWarningDialog(BuildContext context,String _title,String _desc) {
  AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          dialogType: DialogType.ERROR,
          // body: Center(child: Text(
          //   'If the body is specified, then title and description will be ignored, this allows to further customize the dialogue.',
          //   style: TextStyle(fontStyle: FontStyle.italic),
          // ),),
          tittle: _title,
          desc: _desc,
          btnOkOnPress: () {},
          // btnOkColor: Color.fromRGBO(13, 68, 148, .9),
           btnOkColor: Colors.redAccent,
          btnOkText: AppLocalizations.of(context).ok,
          )
      .show();
}
