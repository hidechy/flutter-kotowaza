import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<Map<dynamic, dynamic>> _wordData = List();

  var kotowazaId = 0;
  var kotowazaWord = '';
  var kotowazaYomi = '';
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
    ////////////////////////////////////////
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
            icon: Icon(Icons.close),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: _wordList(),
          ),
          Container(
            height: 350,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.yellowAccent.withOpacity(0.3),
                  width: 10,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    '${kotowazaWord}',
                    style: TextStyle(fontSize: 26),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: Text('${kotowazaYomi}'),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    child: Text('${kotowazaExplanation}'),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.all(8),
                  child: (kotowazaWord == '')
                      ? Container()
                      : RaisedButton(
                          child: Text('cancel'),
                          onPressed: () => _cancelFlag(
                            id: kotowazaId,
                            context: context,
                          ),
                          color: Colors.greenAccent.withOpacity(0.3),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  Widget _wordList() {
    return ListView.builder(
      itemCount: _wordData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    return InkWell(
      onTap: () => _callData(id: _wordData[position]['id']),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.all(5),
        child: Text('${_wordData[position]['word']}'),
      ),
    );
  }

  /**
   *
   */
  void _callData({id}) {
    var kotowaza = _getKotowaza(id: id);
    kotowazaId = kotowaza['id'];
    kotowazaWord = kotowaza['word'];
    kotowazaYomi = kotowaza['yomi'];
    kotowazaExplanation = kotowaza['explanation'];
    kotowazaFlag = kotowaza['flag'];
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
  void _cancelFlag({id, context}) async {
    String url3 = "http://toyohide.work/BrainLog/api/changekotowazaflag";
    Map<String, String> headers3 = {'content-type': 'application/json'};
    String body3 = json.encode({"id": id});
    await post(url3, headers: headers3, body: body3);

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
