import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_coin_wallet/transfer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';
import 'scan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: MyLoginPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class CryptoWalletApp extends StatefulWidget {
  const CryptoWalletApp({Key? key}) : super(key: key);
  @override
  State<CryptoWalletApp> createState() => _CryptoWalletAppState();
}

class _CryptoWalletAppState extends State<CryptoWalletApp> {
  var list;
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance.collection("UsersData");
  List l = [Icons.home, Icons.qr_code, Icons.swap_horiz_sharp];
  var scr = [
    CryptoWalletApp(),
    Qr(),transfer()
  ];
  int curr = 0;
  Future fetch() async {
    http.Response r;
    r = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en'));
    if (r.statusCode == 200) {
      setState(() {
        list = json.decode(r.body);
      });
    }
    else{
      setState(() {
        fetch();
      });
    }
  }
  var username,b;
 void getusername() async{
   DocumentSnapshot user =await _db.doc(_auth.currentUser?.uid).get();
    username=user.get("Name");
    b=user.get("countofeth");
}
  @override
  void initState() {
    // TODO: implement initState
    fetch();
    getusername();
    super.initState();
  }
 void onTapped(int index){
    setState(() {
      curr=index;
    });
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(children: const [Icon(Icons.wallet), Text('Crypto Wallet')]),
      ),
      body: (curr == 0)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    color: Colors.blueAccent,
                  ),
                  child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            minRadius: 30,
                            maxRadius: 40,
                            backgroundColor: Colors.blueAccent,
                            foregroundImage: NetworkImage(
                                'https://img.freepik.com/premium-psd/3d-cartoon-character-avatar-isolated-3d-rendering_235528-554.jpg'),
                          ),
                          Column(
                              children:[Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text('${username}',style: GoogleFonts.arsenal(fontSize: 30,color: Colors.white, fontStyle: FontStyle.italic,fontWeight: FontWeight.w900),),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Account balance:$b ETH',style: TextStyle(color: Colors.white,fontSize: 20,)),
                          )]),

                        ]
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: 50,
                    itemBuilder: (context, ind) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 5 ,top: 10,bottom: 7),
                                padding: EdgeInsets.all(5),

                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  
                                  boxShadow: [BoxShadow(color:Colors.blue,blurRadius:5 ,spreadRadius:5,blurStyle: BlurStyle.outer)],
                                ),
                                child: Image.network(
                                    list[ind]['image'].toString()),
                              ),
                              Text('${list[ind]['symbol'].toString().toUpperCase()}'),
                              Text('${(list[ind]['current_price'].toString())} \$'),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            )
          : scr[curr],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: curr,
          backgroundColor: Colors.blueAccent,
          fixedColor: Colors.white,
          onTap: onTapped,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(l[0]), label: 'home', backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(l[1]), label: 'scan', backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(l[2]),
                label: 'send & receive',
                backgroundColor: Colors.white),
          ]

      ),
    );
  }
}
