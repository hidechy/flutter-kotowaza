import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart';

import '../utilities/utility.dart';

import 'package:toast/toast.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _wordData = List();

  var kotowazaId = 0;
  var kotowazaExplanation = '';
  var kotowazaFlag = 0;

  /**
   * 初期動作
   */
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /**
   * 初期データ作成
   */
  void _makeDefaultDisplayData() async {
    Map data = Map();

    String url = "http://toyohide.work/BrainLog/api/getkotowazachecktest";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"head": ''});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      data = jsonDecode(response.body);
      for (var i = 0; i < data['data'].length; i++) {
        _wordData.add(data['data'][i]);
      }
    }

    setState(() {});
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('test'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.greenAccent,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _goTestScreen(context: context),
            color: Colors.greenAccent,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          PageView.builder(
              controller: PageController(),
              itemCount: _wordData.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(20),
                  child: _dispKotowazaDetail(index),
                );
              }),
        ],
      ),
    );
  }

  /**
   *
   */
  Widget _dispKotowazaDetail(int index) {
    return Column(
      children: <Widget>[
        _dispHeaderLine(index),
        Container(
          alignment: Alignment.topRight,
          child: (kotowazaExplanation == '')
              ? Container(
                  padding: EdgeInsets.all(5),
                  child: RaisedButton(
                    color: Colors.green[900].withOpacity(0.5),
                    child: Text('呼出'),
                    onPressed: () => _callData(id: _wordData[index]['id']),
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(5),
                  child: RaisedButton(
                    color: Colors.green[900].withOpacity(0.5),
                    child: Text('消去'),
                    onPressed: () => _clearData(),
                  ),
                ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            alignment: Alignment.topLeft,
            child: Text(
              '${kotowazaExplanation}',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        (kotowazaExplanation == '')
            ? Container()
            : Container(
                alignment: Alignment.topRight,
                child: RaisedButton(
                  color: Colors.green[900].withOpacity(0.5),
                  child: Text('cancel'),
                  onPressed: () => _cancelFlag(
                    context: context,
                  ),
                ),
              ),
      ],
    );
  }

  /**
   *
   */
  Container _dispHeaderLine(int index) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            '${_wordData[index]['word']}',
            style: TextStyle(fontSize: 22),
          ),
          Text(
            '${_wordData[index]['yomi']}',
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  void _callData({id}) {
    var kotowaza = _getKotowaza(id: id);
    kotowazaId = kotowaza['id'];
    kotowazaExplanation = kotowaza['explanation'];
    kotowazaFlag = kotowaza['flag'];
    setState(() {});
  }

  /**
   *
   */
  void _clearData() {
    kotowazaId = 0;
    kotowazaExplanation = '';
    kotowazaFlag = 0;
    setState(() {});
  }

  /**
   *
   */
  Map _getKotowaza({id}) {
    Map _kotowaza = Map();

    for (int i = 0; i < _wordData.length; i++) {
      if (_wordData[i]['id'] == id) {
        _kotowaza = _wordData[i];
        break;
      }
    }

    return _kotowaza;
  }

  /**
   *
   */
  void _cancelFlag({BuildContext context}) async {
    String url3 = "http://toyohide.work/BrainLog/api/changekotowazaflag";
    Map<String, String> headers3 = {'content-type': 'application/json'};
    String body3 = json.encode({"id": kotowazaId});
    await post(url3, headers: headers3, body: body3);

    Toast.show(
      '記憶済みから消去しました',
      context,
      duration: Toast.LENGTH_LONG,
      backgroundColor: Colors.green[900].withOpacity(0.5),
    );

    _goTestScreen(context: context);
  }

  /**
   *
   */
  void _goTestScreen({BuildContext context}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TestScreen(),
      ),
    );
  }
}
