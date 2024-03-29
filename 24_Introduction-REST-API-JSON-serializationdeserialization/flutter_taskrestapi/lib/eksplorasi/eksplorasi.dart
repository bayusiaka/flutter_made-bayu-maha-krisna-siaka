import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Eksplorasi extends StatefulWidget {
  @override
  _EksplorasiState createState() => _EksplorasiState();
}

class _EksplorasiState extends State<Eksplorasi> {
  String imageUrl = '';
  TextEditingController _seedController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> generateAvatar() async {
    final seed = _seedController.text;
    setState(() {
      imageUrl =
          'https://api.dicebear.com/7.x/open-peeps/svg?backgroundColor=b6e3f4,c0aede,d1d4f9&seed=$seed';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dicebar Image Generator'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        SvgPicture.network(imageUrl, height: 250, width: 250))
                : Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade500),
                    ),
                  ),
            SizedBox(height: 20),
            TextField(
              controller: _seedController,
              decoration: InputDecoration(
                  labelText: 'Input Seed',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                generateAvatar();
              },
              child: const Text("Generate"),
            )
          ],
        ),
      ),
    );
  }
}