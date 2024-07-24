import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Data/constant/constants.dart';
import 'package:flutter_application_1/data/model/crypto.dart';

class CoinListScreen extends StatefulWidget {
  CoinListScreen({Key? key, this.cryptoList}) : super(key: key);
  List<Crypto>? cryptoList;
  @override
  _CoinListScreenState createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  List<Crypto>? cryptoList;
  bool isSearchLoadingVisible = false;
  @override
  void initState() {
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: blackColor,
          title: Text(
            'کریپتو بازار',
            style:
                TextStyle(color: Colors.white, fontFamily: 'mr', fontSize: 18),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: blackColor,
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  onChanged: (value) {
                    _fiterList(value);
                  },
                  decoration: InputDecoration(
                      hintText: 'اسم رمزارز معتبر را سرچ کنید',
                      hintStyle:
                          TextStyle(fontFamily: 'mr', color: Colors.black87),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none),
                      ),
                      filled: true,
                      fillColor: greenColor),
                ),
              ),
            ),
            Visibility(
              visible: isSearchLoadingVisible,
              child: Text(
                '...درحال آپدیت اطلاعات رمز ارز ها',
                style: TextStyle(color: greenColor, fontFamily: 'mr'),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: blackColor,
                backgroundColor: greenColor,
                onRefresh: () async {
                  List<Crypto> fereshData = await _getData();
                  setState(() {
                    cryptoList = fereshData;
                  });
                },
                child: ListView.builder(
                  itemCount: cryptoList!.length,
                  itemBuilder: (context, index) {
                    return _getListTileItem(cryptoList![index]);
                  },
                ),
              ),
            ),
          ],
        )));
  }

  Widget _getIconChangePercent(double PercentChange) {
    return PercentChange <= 0
        ? Icon(
            Icons.trending_down,
            size: 24,
            color: Colors.red,
          )
        : Icon(
            Icons.trending_up,
            size: 24,
            color: Colors.green,
          );
  }

  Color _getColorChnageText(double percentChange) {
    return percentChange <= 0 ? redColor : greenColor;
  }

  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: TextStyle(color: greenColor),
      ),
      subtitle: Text(crypto.symbol, style: TextStyle(color: greyColor)),
      leading: SizedBox(
        width: 30,
        child: Center(
            child: Text(crypto.rank.toString(),
                style: TextStyle(color: greyColor))),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(crypto.priceUsd.toStringAsFixed(2),
                    style: TextStyle(color: greyColor)),
                Text(crypto.changePercent24hr.toStringAsFixed(2),
                    style: TextStyle(
                        color: _getColorChnageText(
                      crypto.changePercent24hr,
                    )))
              ],
            ),
            SizedBox(
                width: 30,
                child: Center(
                    child: _getIconChangePercent(
                  crypto.changePercent24hr,
                )))
          ],
        ),
      ),
    );
  }

  Future<List<Crypto>> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
    return cryptoList;
  }

  Future<void> _fiterList(String enteredKeyword) async {
    List<Crypto> cryptoResultList = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        isSearchLoadingVisible = true;
      });
      var result = await _getData();

      setState(() {
        cryptoList = result;
        isSearchLoadingVisible = false;
              });
    }

    cryptoResultList = cryptoList!.where((element) {
      return element.name.toLowerCase().contains(enteredKeyword.toLowerCase());
    }).toList();
    setState(() {
      cryptoList = cryptoResultList;
    });
  }
}
