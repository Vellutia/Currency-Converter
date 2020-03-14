import 'package:flutter/material.dart';

import '../locator.dart';
import '../model/dialog_model.dart';
import '../services/dialog_service.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    var isConfirmationDialog = request.cancelTitle != null;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          request.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        content: Text(request.description),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: <Widget>[
          if (isConfirmationDialog)
            FlatButton(
              child: Text(request.cancelTitle),
              onPressed: () {
                _dialogService.dialogComplete(DialogResponse(confirmed: false));
              },
            ),
          FlatButton(
            child: Text(request.buttonTitle),
            onPressed: () {
              _dialogService.dialogComplete(DialogResponse(confirmed: true));
            },
          ),
        ],
      ),
    );
  }
}
