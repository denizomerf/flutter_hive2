import 'package:flutter/material.dart';
import 'package:flutter_hive2/hive_box.dart';
import 'package:flutter_hive2/model/amount.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AmountModelAdapter());
  await Hive.openBox<AmountModel>("amount");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AmountPage(),
    );
  }
}

class AmountPage extends StatefulWidget {
  const AmountPage({Key? key}) : super(key: key);

  @override
  State<AmountPage> createState() => _AmountPageState();
}

class _AmountPageState extends State<AmountPage> {
  final textController = TextEditingController();
  final amountController = TextEditingController();
  var isPlus;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Hive")),
        body: ValueListenableBuilder<Box<AmountModel>>(
          valueListenable: HiveBox.getAmount().listenable(),
          builder: (context, box, widget) {
            var amount = box.values.toList();
            return buildList(amount);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) =>
                    StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        title: Column(
                          children: [
                            TextFormField(
                              decoration:
                                  const InputDecoration(hintText: "Başlık"),
                              controller: textController,
                            ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(hintText: "Miktar"),
                              controller: amountController,
                            ),
                            RadioListTile(
                                title: const Text("True"),
                                value: true,
                                groupValue: isPlus,
                                onChanged: (value) {
                                  setState(() {
                                    isPlus = value;
                                  });
                                }),
                            RadioListTile(
                                title: const Text("False"),
                                value: false,
                                groupValue: isPlus,
                                onChanged: (value) {
                                  setState(() {
                                    isPlus = value;
                                  });
                                })
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                var amount = AmountModel()
                                  ..name = textController.text
                                  ..isPlus = isPlus
                                  ..amount =
                                      double.parse(amountController.text);
                                var box = HiveBox.getAmount();
                                box.add(amount);
                                Navigator.pop(context);
                                textController.clear();
                              },
                              child: const Text("Kaydet"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.greenAccent.shade700))),
                          ElevatedButton(
                              onPressed: () {
                                amountController.clear();
                                Navigator.pop(context);
                              },
                              child: const Text("Vazgeç"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.redAccent)))
                        ],
                      );
                    }));
          },
          child: const Icon(Icons.add),
        ));
  }

  Widget buildList(List<AmountModel> amount) {
    if (amount.isEmpty) {
      return const Center(
        child: Text("Empty List"),
      );
    } else {
      var totalAmount = amount.fold<double>(
          0,
          (previousValue, element) => element.isPlus
              ? previousValue + element.amount
              : previousValue - element.amount);
      MaterialColor color;
      if (totalAmount > 0) {
        color = Colors.green;
      } else if (totalAmount == 0) {
        color = Colors.blue;
      } else {
        color = Colors.red;
      }
      return Column(
        children: [
          Text(
            totalAmount.toString(),
            style: TextStyle(color: color, fontSize: 25),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: amount.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => Card(
                color: Colors.white,
                child: ExpansionTile(
                  title: Text(
                    amount[index].name,
                  ),
                  trailing: Text(
                    amount[index].amount.toString(),
                  ),
                  children: [
                    IconButton(
                        onPressed: () {
                          var thisAmount = amount[index];
                          thisAmount.delete();
                        },
                        icon: Icon(Icons.delete))
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
