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
      body: _buildQuestion(context),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    switch(widget.nag.answerType) {
      case AnswerType.confirmation:
        return _buildConfirmation(context);
      case AnswerType.yesno:
        return _buildYesNo(context);
      case AnswerType.text:
        return _buildText(context);
      case AnswerType.scale5:
        return _buildScale5(context);
      case AnswerType.scale10:
        return _buildScale10(context);
    }

    return Center();
  }

  Widget _buildConfirmation(BuildContext context) {
  }

  Widget _buildYesNo(BuildContext context) {
  }

  Widget _buildText(BuildContext context) {
  }

  Widget _buildScale5(BuildContext context) {
  }

  Widget _buildScale10(BuildContext context) {
  }
}