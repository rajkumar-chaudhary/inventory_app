import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  int _numberOfPizzaBase = 1;
  double _chicken = 1.0;
  double _souce = 1.0;
  double _cheese = 1.0;

  void _submitForm() async {
    final _isValid = _formKey.currentState!.validate();
    if (!_isValid) {
      return;
    }
    _formKey.currentState!.save();
    print('okokokokokokokoo');
    await FirebaseFirestore.instance
        .collection('Inventory')
        .doc(DateTime.now().toString())
        .set(
      {
        'id': DateTime.now(),
        'Number of pizza bases': _numberOfPizzaBase,
        'Amount of chicken (in kg)': _chicken,
        'Amount of cheese (in kg)': _cheese,
        'Enter amount of souce': _souce,
      },
    );
    print('okokoko');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Managment'),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                width: 2,
                color: Colors.grey,
              )),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('Number of pizza base'),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Provide a Value';
                        }
                      },
                      onSaved: ((newValue) {
                        _numberOfPizzaBase = int.parse(newValue!);
                      }),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('Enter amount of chicken(in kg)'),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Provide a Value';
                        }
                      },
                      onSaved: ((newValue) {
                        _chicken = double.parse(newValue!);
                      }),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('Enter amount of cheese(in kg)'),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Provide a Value';
                        }
                      },
                      onSaved: ((newValue) {
                        _cheese = double.parse(newValue!);
                      }),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('Enter amount of souce(in L)'),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Provide a Value';
                        }
                      },
                      onSaved: ((newValue) {
                        _souce = double.parse(newValue!);
                      }),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
                  ]),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 200,
            width: 200,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Inventory')
                  .limit(1)
                  .orderBy(
                    'id',
                    descending: true,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final documents = snapshot.data!.docs;

                return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final pizzebase =
                          documents[index]['Number of pizza bases'];
                      final souces = documents[index]['Enter amount of souce'];
                      final cheese =
                          documents[index]['Amount of cheese (in kg)'];
                      final chickens =
                          documents[index]['Amount of chicken (in kg)'];
                      print(pizzebase);
                      print(souces);
                      print(cheese);
                      print(chickens);
                      final pizza = [
                        pizzebase,
                        souces / 100,
                        cheese / 200,
                        chickens / 400
                      ].reduce((curr, next) => curr < next ? curr : next);
                      print('pizzas');
                      print(pizza);
                      final pizzaInt = pizza.toInt();
                      return Container(
                        height: 200,
                        width: 200,
                        child: Column(
                          children: [
                            Text(
                                'Number Pizzas can be made with these ingrediants:${pizzaInt}'),
                            SizedBox(
                              height: 5,
                            ),
                            Text('<-------Remaining Ingrediants------>'),
                            Text(
                                'number of pizza base: ${pizzebase - pizzaInt}'),
                            Text(
                                'Amount of chicken(in kg): ${chickens - 400 * pizzaInt}'),
                            Text(
                                'Amount of cheese(in kg): ${cheese -  200 * pizzaInt}'),
                            Text(
                                'Amount of souce(in L): ${souces - 100 * pizzaInt}'),
                          ],
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
