import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const CryptoPage());

class CryptoPage extends StatefulWidget {
  const CryptoPage({Key? key}) : super(key: key);

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Currency Converter'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Flexible(
              flex: 3,
              child: Image.asset('assets/images/icon.png')
            ),
            const Flexible(flex: 5, child: CryptoForm(),)
          ],
        )
      ),
    );
  }
}

class CryptoForm extends StatefulWidget {
  const CryptoForm({ Key? key }) : super(key: key);

  @override
  _CryptoFormState createState() => _CryptoFormState();
}

class _CryptoFormState extends State<CryptoForm> {
  TextEditingController inputEditingController = TextEditingController();
  TextEditingController outputEditingController = TextEditingController();
  
  double inputValue = 0.0, outputValue = 0.0, inputCurr = 0.0, outputCurr = 0.0;
  String desc = "";

  String selectCur1 = "btc", selectCur2 = "eth";
  List<String> curList = [
    
       "btc","eth","ltc","bch","bnb","eos","xrp","xlm","link","dot","yfi",
"usd","aed","ars","aud","bdt","bhd","bmd","brl","cad","chf","clp",
"cny","czk","dkk","eur","gbp","hkd","huf","idr","ils","inr","jpy","krw",
"kwd","lkr","mmk","mxn","myr","ngn","nok","nzd","php","pkr","pln","rub","sar",
"sek","sgd","thb","try","twd","uah","vef","vnd","zar","xdr","xag","xau","bits","sats"
  ];

  _convert() async {
    
    var url = Uri.parse('https://api.coingecko.com/api/v3/exchange');
    var response = await http.get(url);
    var rescode = response.statusCode;

    


    

    setState(() {
      
      if(rescode == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);


        if(selectCur1 == "btc") {
           inputCurr = 1.0;
        } else {
          inputCurr = parsedJson['data'][selectCur1];
        }

        if(selectCur2 == "eth") {
          outputCurr = 1.0;
        }else {
          outputCurr = parsedJson['data'][selectCur2];
        }

        desc = "";
      } else {
          desc = "No data";
      }

      if (inputEditingController.text != "") {
        inputValue = double.parse(inputEditingController.text);
        outputValue = (inputValue/inputCurr)*outputCurr;
        outputEditingController.text = outputValue.toString();
      } else {
        outputEditingController.text = "";
        inputValue = 0.0;
        outputValue = 0.0;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Row( 
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 2,
                  child: TextField(
                    controller: inputEditingController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(),
                    onChanged: (newValue) {
                      _convert();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius:BorderRadius.circular(10.0)
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: DropdownButton(
                    itemHeight: 60,
                    value: selectCur1,
                    onChanged: (newValue) {
                      selectCur1 = newValue.toString();
                      _convert();
                    },
                    items: curList.map((selectCur1) {
                      return DropdownMenuItem(
                        child: Text(
                          selectCur1,
                        ),
                        value: selectCur1,
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Row( 
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 2,
                  child: TextField(
                    controller: outputEditingController,
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius:BorderRadius.circular(10.0)
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: DropdownButton(
                    itemHeight: 60,
                    value: selectCur2,
                    items: curList.map((selectCur2) {
                      return DropdownMenuItem(
                        child: Text(
                          selectCur2,
                        ),
                        value: selectCur2,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      selectCur2 = newValue.toString();
                      _convert();
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Text(inputValue.toString() + " " + selectCur1 + " = " + outputValue.toString() + " " + selectCur2,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(desc),
          ],
        ),
      ),
    );
  }
}