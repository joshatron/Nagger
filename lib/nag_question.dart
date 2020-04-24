import 'package:flutter/material.dart';

import 'nag.dart';

class NagQuestionPage extends StatefulWidget {
  Nag nag;

  NagQuestionPage(this.nag, {Key key}) : super(key: key);

  @override
  _NagQuestionState createState() => _NagQuestionState();
}

class _NagQuestionState extends State<NagQuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nag.title)),
      body: _buildConfirmation(context),
    );
  }

  Widget _buildConfirmation(BuildContext context) {

  }
}