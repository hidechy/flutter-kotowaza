import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart';

import 'package:toast/toast.dart';

class WordListScreen extends StatefulWidget {
  final String head;
  WordListScreen({@required this.head});

  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<Map<dynamic, dynamic>> _headData = List();
  List<Map<dynamic, dynamic>> _wordData = List();

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

    String url = "http://toyohide.work/BrainLog/api/getkotowazacount";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"head": ''});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      data = jsonDecode(response.body);

      var headStr =
          "あ,い,う,え,お,か,き,く,け,こ,さ,し,す,せ,そ,た,ち,つ,て,と,な,に,ぬ,ね,の,は,ひ,ふ,へ,ほ,ま,み,む,め,も,や,ゆ,よ,ら,り,る,れ,ろ,わ,を,ん";
      var headAry = (headStr).split(',');

      for (var i = 0; i < headAry.length; i++) {
        Map _map = Map();
        _map['head'] = headAry[i];

        _map['count'] = _getCount(
          head: headAry[i],
          data: data['data'],
        );

        _map['flaged'] = _getFlaged(
          head: headAry[i],
          data: data['data'],
        );

        _headData.add(_map);
      }
    }
    ////////////////////////////////////////

    //---------------------------//
    Map data2 = Map();

    String url2 = "http://toyohide.work/BrainLog/api/getkotowaza";
    Map<String, String> headers2 = {'content-type': 'application/json'};
    String body2 = json.encode({"head": '${widget.head}'});
    Response response2 = await post(url2, headers: headers2, body: body2);

    if (response2 != null) {
      data2 = jsonDecode(response2.body);
      for (var i = 0; i < data2['data'].length; i++) {
        _wordData.add(data2['data'][i]);
      }
    }
    //---------------------------//

    setState(() {});
  }

  /**
   *
   */
  int _getCount({head, data}) {
    var cnt = 0;
    for (var i = 0; i < data.length; i++) {
      if (data[i]['head'] == head) {
        cnt = data[i]['count'];
        break;
      }
    }
    return cnt;
  }

  /**
   *
   */
  int _getFlaged({String head, data}) {
    var cnt = 0;
    for (var i = 0; i < data.length; i++) {
      if (data[i]['head'] == head) {
        cnt = data[i]['flaged'];
        break;
      }
    }
    return cnt;
  }

  /**
   *
   */
  int _getHeadCount({head, data}) {
    var cnt = 0;

    for (var i = 0; i < data.length; i++) {
      if (data[i]['head'] == head) {
        cnt = data[i]['count'];
        break;
      }
    }

    return cnt;
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('${widget.head}'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[],
      ),
      body: Row(
        children: <Widget>[
          Container(
            width: 120,
            child: _headList(),
          ),
          Expanded(
            child: _wordList(),
          ),
        ],
      ),
    );
  }

  /**
   * リスト表示
   */
  Widget _headList() {
    return ListView.builder(
      itemCount: _headData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem({int position}) {
    return Card(
      color: _getBgColor(position: position),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        onTap: () => _goWordListScreen(head: _headData[position]['head']),
        title: Row(
          children: <Widget>[
            Container(
              child: Text(
                '${_headData[position]['head']}',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: Text(
                  '${_headData[position]['flaged']} / ${_headData[position]['count']}',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   *
   */
  Color _getBgColor({position}) {
    var bgColor = Colors.black.withOpacity(0.3);

    if (_headData[position]['head'] == widget.head) {
      bgColor = Colors.orangeAccent.withOpacity(0.3);
    } else if (_headData[position]['count'] == 0) {
      bgColor = Colors.grey.withOpacity(0.3);
    }

    return bgColor;
  }

  /**
   * リスト表示
   */
  Widget _wordList() {
    return ListView.builder(
      itemCount: _wordData.length,
      itemBuilder: (context, int position) => _listItem2(position: position),
    );
  }

  /**
   * リストアイテム表示
   */
  Widget _listItem2({int position}) {
    return Card(
      color: Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${_wordData[position]['word']}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                '${_wordData[position]['yomi']}',
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.star),
          onPressed: () => _showAlertWindow(id: _wordData[position]['id']),
          color: _getFlagColor(id: _wordData[position]['id']),
        ),
      ),
    );
  }

  /**
   *
   */
  Color _getFlagColor({id}) {
    var kotowaza = _getKotowaza(id: id);

    switch (kotowaza['flag']) {
      case 0:
        return Colors.white.withOpacity(0.3);
        break;
      case 1:
        return Colors.greenAccent.withOpacity(0.3);
        break;
    }
  }

  /**
   *
   */
  void _showAlertWindow({id}) {
    var kotowaza = _getKotowaza(id: id);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.3),
        title: Column(
          children: <Widget>[
            Text('${kotowaza['word']}'),
            Text(
              '${kotowaza['yomi']}',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        content: Text('${kotowaza['explanation']}'),
        actions: <Widget>[
          RaisedButton(
            child: Text('flag'),
            onPressed: () => _changeFlag(id: id),
            color: _getFlagColor(id: kotowaza['id']),
          ),
          FlatButton(
            child: Text("close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
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
  void _changeFlag({id}) async {
    String url3 = "http://toyohide.work/BrainLog/api/changekotowazaflag";
    Map<String, String> headers3 = {'content-type': 'application/json'};
    String body3 = json.encode({"id": id});
    Response response3 = await post(url3, headers: headers3, body: body3);

    var head;
    if (response3 != null) {
      var data3 = jsonDecode(response3.body);
      for (var i = 0; i < data3['data'].length; i++) {
        _wordData.add(data3['data'][i]);
        head = data3['data'][i]['head'];
      }
    }

    Toast.show('更新が完了しました', context, duration: Toast.LENGTH_LONG);

    _goWordListScreen(head: head);
  }

  /**
   *
   */
  void _goWordListScreen({head}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WordListScreen(
          head: head,
        ),
      ),
    );
  }
}
