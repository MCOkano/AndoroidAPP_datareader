import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NextPage extends StatefulWidget {
  NextPage({Key key, this.date,this.kind}) : super(key:key);
  final String date;
  final String kind;

  @override
  _NextPageState createState() => new _NextPageState();
}

class _NextPageState extends State<NextPage> {
  String _result = "";
  List<String> _idlist = [];
  var stat_flag = 0;

  final List<int> colorCodes = <int>[600, 300, 100];

  @override
  initState() {
    super.initState();
    send();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('検索結果'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Container(child: Text('${_result}')),
              Container(
                height: 125,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 20.0, right: 0.0, bottom: 20.0, left: 0.0),
//                color: Colors.lightBlue,
                // 配列を元にリスト表示
                child: ListView.builder(
                  itemCount: _idlist.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 30,
                      color: Colors.lightBlue[colorCodes[(index%2)]],
                      child: Text(_idlist[index]),
                    );
                  }, //itemBuilder
                ),
              ),

              RaisedButton(
                onPressed: () => {Navigator.of(context).pop()},
                child: Text('メイン画面に戻る'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future send() async {
//    final Uri addr = 'http://localhost:7071/api/mctest00/' ;
    var url = Uri.parse(
//        'https://demotest00.azurewebsites.net/api/DMREHttpTriggerTEST?apid=rd&date=${widget.date}');
    'https://dmre-demo-httptrigger-app.azurewebsites.net/api/DMREHttpTriggerTEST?apid=rd&date=${widget.date}');
    print('date: ${widget.date}');
    var response = await http.get(url);
    String result = "";
    String httpresult = "";
    var in_resulttb = "";
    var temp = "";
    var temp2 = "";
    var temp3 = "";
    var id_count = 0;
    List<String> idlist = [];

    if (response.statusCode == 200) {
//      var jsonResponse = convert.jsonDecode(response.body);
//      rcv_kind = jsonResponse['kind'];
      print('rcv kind about http: ${response.body}');
      httpresult = response.body.toString();
      if (response.body.toString() == "該当するデータがありませんでした。") {
        result = '${widget.date} には${httpresult}';
      }
      else if(response.body.toString() == "検索日付が指定されていません。") {
        result = httpresult;
      }
      else{
        stat_flag = 1;
        in_resulttb = response.body;
        print('conv: ${in_resulttb}');
        temp = in_resulttb.replaceAll("[","");
        temp2 = temp.replaceAll("]","");
        temp3 = temp2.replaceAll("'","");
        print('conv2:${temp3}');
        idlist = temp3.split(', ');
        id_count = idlist.length;
        print('idlist: ${idlist}');
        print('id_count: ${id_count}');
        result = '検索日付：${widget.date}  該当件数：${id_count} 件';
      }
    } else {
      result = "ステータス：正常に通信できませんでした";
      print('Request failed with status: ${response.statusCode}.');
    }
    setState(() {
      _result = result;
      _idlist = idlist;

    });
  }
}
