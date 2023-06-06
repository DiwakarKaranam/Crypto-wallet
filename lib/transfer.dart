import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_coin_wallet/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class transfer extends StatefulWidget {
  const transfer({super.key});
  @override
  State<transfer> createState() => _transferState();
}

class _transferState extends State<transfer> {
  final _db = FirebaseFirestore.instance.collection("UsersData");
  TextEditingController a = TextEditingController();
  TextEditingController b = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Enter user name and number of tokens'),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
              obscureText: false,
              controller: a,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              )),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
              obscureText: false,
              keyboardType: TextInputType.number,
              controller: b,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tokens',
              )),
        ),
        ElevatedButton(
            onPressed: () async {
              QuerySnapshot snapshot_other =
                  await _db.where("Name", isEqualTo: a.text).get();
              DocumentSnapshot x = snapshot_other.docs[0];
              final id_other = x.id;
              int bal = x.get('countofeth');
              int t = int.parse(b.text);
              bal += t;

              await _db.doc(id_other).update({"countofeth": bal});
              String? u = FirebaseAuth.instance.currentUser?.uid;

              DocumentSnapshot e = await _db.doc(u).get();
              int q = e.get('countofeth');
              q -= t;
              print("curr bal=${q}");
              await _db.doc(u).update({'countofeth': q});
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CryptoWalletApp()));
            },
            child: Text('Send')),
      ],
    );
  }
}
