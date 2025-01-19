import 'package:flutter/material.dart';

class Laptop {
  final int id;
  final String name;
  final String description;
  final int stock;
  final double price;
  

  Laptop({
    required this.id,
    required this.name,
    required this.description,
    required this.stock,
    required this.price,
    
  });
}

class LaptopApp extends StatefulWidget {
  @override
  _LaptopAppState createState() => _LaptopAppState();
}

class _LaptopAppState extends State<LaptopApp> {
  List<Laptop> _laptops = [];
  int _nextId = 1;

  void _addLaptop(String name, String description, int stock, double price) {
    setState(() {
      _laptops.add(Laptop(
        id: _nextId,
        name: name,
        description: description,
        stock: stock,
        price: price,
        
      ));
      _nextId++;
    });
  }

  void _updateLaptop(int id, String name, String description, int stock, double price) {
    setState(() {
      final laptopIndex = _laptops.indexWhere((laptop) => laptop.id == id);
      if (laptopIndex != -1) {
        _laptops[laptopIndex] = Laptop(
          id: id,
          name: name,
          description: description,
          stock: stock,
          price: price,
        );
      }
    });
  }

  void _deleteLaptop(int id) {
    setState(() {
      _laptops.removeWhere((laptop) => laptop.id == id);
    });
  }

  void _showAddLaptopScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddLaptopScreen(
          onLaptopAdded: _addLaptop,
        ),
      ),
    );
  }

  void _showEditLaptopScreen(Laptop laptop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddLaptopScreen(
          onLaptopAdded: (name, description, stock, price) =>
              _updateLaptop(laptop.id, name, description, stock, price),
          existingLaptop: laptop,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambahkan Produk"),
        backgroundColor: Colors.transparent, // Membuat AppBar transparan
        elevation: 0, // Menghilangkan bayangan di bawah AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green], // Gradien dari biru ke hijau
            begin: Alignment.topLeft, // Gradien dimulai dari kiri atas
            end: Alignment.bottomRight, // Gradien berakhir di kanan bawah
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _laptops.length,
                itemBuilder: (context, index) {
                  final laptop = _laptops[index];
                  return ListTile(
                    title: Text(laptop.name),
                    subtitle: Text("Stok: ${laptop.stock}, Harga: \$${laptop.price}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showEditLaptopScreen(laptop),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteLaptop(laptop.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            FloatingActionButton(
              onPressed: _showAddLaptopScreen,
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class AddLaptopScreen extends StatelessWidget {
  final Function(String, String, int, double) onLaptopAdded;
  final Laptop? existingLaptop;

  AddLaptopScreen({required this.onLaptopAdded, this.existingLaptop});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(
      text: existingLaptop?.name,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: existingLaptop?.description,
    );
    final TextEditingController stockController = TextEditingController(
      text: existingLaptop?.stock.toString(),
    );
    final TextEditingController priceController = TextEditingController(
      text: existingLaptop?.price.toString(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(existingLaptop != null ? "Edit Laptop" : "Tambah Laptop"),
        backgroundColor: Colors.transparent, // Transparan juga untuk AddLaptopScreen
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Nama Laptop",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: stockController,
              decoration: InputDecoration(
                labelText: "Stok",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: "Harga",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  String description = descriptionController.text;
                  int? stock = int.tryParse(stockController.text);
                  double? price = double.tryParse(priceController.text);

                  if (name.isNotEmpty &&
                      description.isNotEmpty &&
                      stock != null &&
                      price != null) {
                    onLaptopAdded(name, description, stock, price);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Semua field wajib diisi!"),
                      ),
                    );
                  }
                },
                child: Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LaptopApp(),
  ));
}
