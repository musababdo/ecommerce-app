import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDialog extends StatefulWidget {

  MyDialog({Key key, this.mlocation}) : super(key: key);
  TextEditingController mlocation=new TextEditingController();

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {

  TextEditingController editingController=new TextEditingController();

  final location=["ديم سواكن", "ديم جابر", "ديم موسى", "الملاحة", "ترانزيت", "كوريا", "حي المطار", "حي الشاطيء", "حي البوستة", "حي الشجرة", "الميرغنية", "دار النعيم", "دار السلام", "الرياض", "الجنائن", "فلب", "يثرب", "عوج الدرب", "الإنقاذ", "غرب الزلط",
  "السوق الكبير", " ديم المدينة","سكه حديد", "ديم عرب", "حي التقدم", "أونقواب", "ديم سجن", "حي الأغاريق", "حي الجامعة (خور كلاب سابقاً)", "حي العظمة", "دبايوا", "ديم مايو", "ســـــلالاب شرق", "ســـــلالاب غرب", "ســـــلالاب الوحده", "شقر", "الاسكان", "إشلاق الدفاع الجوي", "الإسكندرية", "اللالوبه",
  "ديم النور", "القادسية", "أم القرى", "أبو حشيش", "حي الخليج","الثوره", "هدل", "سلبونا", "ديم التيجاني"];

  var items = List<String>();

  @override
  void initState() {
    // TODO: implement initState
    items.addAll(location);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(location);
    if(query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if(item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(location);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                  hintText: "بحث",
                  hintStyle: GoogleFonts.cairo(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: GestureDetector(
                      onTap:(){
                        widget.mlocation.text=items[index];
                        Navigator.of(context).pop();
                      },
                      child: Text('${items[index]}',
                          style: GoogleFonts.cairo()
                      ),
                    )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}