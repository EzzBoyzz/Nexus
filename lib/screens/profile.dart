import 'package:flutter/material.dart';
import 'login.dart';


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigasi ke layar profil
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar profil
            CircleAvatar(
              radius: 60, // Ukuran gambar profil
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // URL placeholder
              backgroundColor: Colors.grey[200],
            ),
            SizedBox(height: 20), // Jarak antara gambar dan teks
            // Nama profil
            Text(
              'reza',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20), // Jarak antara teks dan tombol
            // Tombol Edit Profile
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController nameController =
                        TextEditingController();
                    return AlertDialog(
                      title: Text('Edit Profile'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Input untuk nama profil
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Tutup dialog tanpa menyimpan
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Simpan data baru
                            print('Updated name: ${nameController.text}');
                            Navigator.of(context).pop();
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: 30, vertical: 10), // Ukuran tombol
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Membuat tombol bulat
                ),
              ),
              child: Text(
                'Edit Profile',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20), // Jarak antara tombol Edit Profile dan Logout
            // Tombol Logout
          ElevatedButton(
            onPressed: () {
              // Kembali ke layar login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Ukuran tombol
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Membuat tombol bulat
              ),
              backgroundColor: Colors.red, // Warna tombol Logout
            ),
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: LoginScreen(),
    ));
