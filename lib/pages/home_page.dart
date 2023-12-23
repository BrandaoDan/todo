import 'package:flutter/material.dart';
import 'package:todo/models/item.dart';
import 'package:todo/utils/database.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onSignOut;

  HomePage({required this.onSignOut});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _newTaskCtrl = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late List<Item> _items;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final data = await _dbHelper.getItems();
    setState(() {
      _items = data.map((item) => Item.fromMap(item)).toList();
    });
  }

  Future<void> _addItem() async {
    await _dbHelper.db;

    if (_newTaskCtrl.text.isNotEmpty) {
      await _dbHelper.addItem(_newTaskCtrl.text, false);
      _newTaskCtrl.clear();
      _loadItems();
    }
  }

 Future<void> _toggleItemDone(int id, bool done) async {
    await _dbHelper.updateItem(id, !done); // Alteração aqui
    setState(() {
      _items.firstWhere((item) => item.id == id).done = !done; // Alteração aqui
    });
  }

  Future<void> _deleteItem(int id) async {
    await _dbHelper.deleteItem(id);
    _loadItems();
  }

  Future<void> _signOut() async {
    // Adicione a lógica de logout aqui
    widget.onSignOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 58, 0, 81),
        leading: Icon(
          Icons.menu_open,
          color: Colors.white,
        ),
        title: TextFormField(
          controller: _newTaskCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            labelText: "Nova Tarefa",
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final item = _items[index];
          return Dismissible(
            key: Key(item.id.toString()),
            background: Container(
              color: Colors.red[200],
            ),
            onDismissed: (direction) {
              _deleteItem(item.id);
            },
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                _toggleItemDone(item.id, item.done);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 233, 162, 255),
      ),
    );
  }
}
