import 'package:flutter/material.dart';
import 'package:myapp/models/produk_model.dart';
import 'login.dart'; // Mengimpor halaman Login
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:myapp/screens/kategori.dart';

class MainScreens extends StatefulWidget {
  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  int _selectedIndex = 0;

  // List of Screens (Home, Kategori, dan Profile)
  final List<Widget> _screens = [
    HomeScreen(),
    LaptopApp(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Nexus'),
          backgroundColor: Colors.blue, // Set the AppBar color to blue
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Tindakan yang dilakukan ketika tombol pencarian diklik
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // DrawerHeader dengan background gambar
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/nexus.jpg'), // Ganti dengan path gambar yang sesuai
                    fit: BoxFit.fill,
                  ),
                ),
                child: null,
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  setState(() {
                    _selectedIndex = 0; // Navigate to Home screen
                  });
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                title: Text('Profile'),
                onTap: () {
                  setState(() {
                    _selectedIndex = 2; // Navigate to Profile screen
                  });
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                title: Text('Logout'), // Tombol logout
                onTap: () {
                  // Navigasi kembali ke halaman login (Login screen)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ],
          ),
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Produk',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor:
              Colors.blue, // Set the BottomNavigationBar color to blue
          selectedItemColor: Colors.white, // Set the color of selected item
          unselectedItemColor:
              Colors.white70, // Set the color of unselected item
        ),
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String baseurl = "https://3c42-103-3-220-115.ngrok-free.app/Tnexus/";

  var dio = Dio();
  
  bool isBought = false;
  Future<List<ProdukModel>> getData() async {
    var response = await dio.get('$baseurl/api/get_menu/');

    print("Respon GetDataMotivasi -> ${response.data}");
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers = getUsersData.map((i) => ProdukModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Tambahkan background image di sini
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background1.jpg'), // Path gambar background
          fit: BoxFit.cover, // Menyesuaikan gambar agar mengisi seluruh layar
        ),
      ),
      child: SingleChildScrollView(
        // Membuat layar bisa di-scroll
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Tambahkan gambar utama
              Image.asset(
                'assets/promosi3.jpg',
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              // Teks selamat datang
              Text(
                'Selamat Datang di Nexus!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Temukan berbagai laptop terbaik sesuai kebutuhan Anda, mulai dari laptop office, gaming, hingga chromebook.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Tambahkan list produk sebagai contoh
              FutureBuilder<List<ProdukModel>>(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Tidak ada data produk'));
                  } else {
                    final produkList = snapshot.data!;
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: produkList.length,
                      itemBuilder: (context, index) {
                        final produk = produkList[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          child: ListTile(
                            leading: produk.gambar != null
                                ? Image.network(
                                    produk.gambar!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.broken_image),
                                  )
                                : Icon(Icons.image_not_supported),
                            title: Text(produk.namaMenu ?? 'Nama Produk'),
                            subtitle: Text('Stock: ${produk.stock ?? '-'}'),
                            trailing: IconButton(
                              icon: Icon(Icons.info_outline),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Detail Produk'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          produk.gambar != null
                                              ? Image.network(
                                                  produk.gambar!,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Icon(Icons.broken_image),
                                                )
                                              : Icon(Icons.image_not_supported,
                                                  size: 100),
                                          SizedBox(height: 10),
                                          Text(
                                              'Nama Produk: ${produk.namaMenu ?? '-'}'),
                                          Text(
                                              'Deskripsi: ${produk.deskrispsi ?? '-'}'),
                                          if (produk.deskrispsi == null ||
                                              produk.deskrispsi!.isEmpty)
                                            Text('Deskripsi tidak tersedia',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          Text(
                                              'Harga: \$${produk.harga != null ? produk.harga.toString() : '-'}'),
                                       if (isBought) // Pesan muncul setelah produk dibeli
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20.0),
                                            child: Text(
                                              "Produk Anda sudah dibeli!",
                                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // Logika saat tombol Beli ditekan
                                          print("Tombol Beli ditekan");
                                        },
                                        child: Text('Beli'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Tutup'),
                                      ),
                                    ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatCurrency(int amount) {
  final formatter = NumberFormat.currency(
    locale: 'en_US', // Format Dollar (AS)
    symbol: '\$', // Simbol Dollar
  );
  return formatter.format(amount);
}

// Profile Screen

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text(
          'My Profile',  // Title halaman
          textAlign: TextAlign.center,  // Memastikan title berada di tengah
          style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
        ),
        centerTitle: true, 
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,  // Menyelarakan konten ke atas
            children: [
              // Gambar default di atas box
              Container(
                padding: EdgeInsets.all(16.0),
                child: ClipOval(  // Membuat gambar bulat
                  child: Image.asset(
                    'assets/default_profile.png', // Gambar default
                    width: 200,  // Ukuran gambar
                    height: 200,
                    fit: BoxFit.cover,  // Agar gambar terpotong dengan rapih sesuai ukuran
                  ),
                ),
              ),
              
              // Kotak dengan informasi pengguna
              Container(
                padding: EdgeInsets.all(16.0), // Padding dalam kotak
                width: 300, // Lebar kotak
                decoration: BoxDecoration(
                  color: Colors.white, // Warna latar kotak
                  borderRadius: BorderRadius.circular(12), // Sudut membulat
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // Warna bayangan
                      blurRadius: 10, // Blur radius
                      offset: Offset(0, 4), // Posisi bayangan
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center, // Menyelaraskan teks ke tengah
                  children: [
                    Text(
                      'Hai Reza!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center, // Memastikan teks ini juga di-center
                    ),
                    SizedBox(height: 10), // Jarak antar paragraf
                    Text(
                      'Selamat datang di aplikasi kami. Kami senang Anda bergabung. '
                      'Semoga Anda menikmati pengalaman menggunakan aplikasi ini.',
                      textAlign: TextAlign.center, // Menyelaraskan teks ke tengah
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 10), // Jarak antar paragraf
                    Text(
                      'Email: make@gmail.com',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center, // Menyelaraskan teks ke tengah
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}

// Custom Search Delegate
class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    // Tombol untuk membersihkan pencarian
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Menghapus teks pencarian
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Tombol untuk kembali
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Menutup pencarian
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Menampilkan hasil pencarian
    return Center(
      child: Text('Hasil Pencarian: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Tidak ada histori pencarian atau item saran tetap
    return ListView(); // Mengembalikan ListView kosong
  }
}
