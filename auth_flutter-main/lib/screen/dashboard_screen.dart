import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth package
import '../screen/dosen_screen.dart';
import '../screen/berita_screen.dart';
import '../screen/fasilitas_screen.dart';
import '../screen/galeri_screen.dart';
import '../screen/prodi_screen.dart';
import '../screen/tentang_screen.dart';
import '../screen/testimoni_screen.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    List<IconData> icons = [
      Icons.book,
      Icons.person,
      Icons.article,
      Icons.info,
      Icons.home,
      Icons.comment,
      Icons.photo,
    ];

    List<String> titles = [
      "Prodi",
      "Dosen",
      "Berita",
      "Tentang",
      "Fasilitas",
      "Testimoni",
      "Galeri",
    ];

    List<Widget> pages = [
      ProdiPage(),
      DosenPage(),
      BeritaPage(),
      TentangPage(),
      FasilitasPage(),
      TestimoniPage(),
      GaleriPage(),
    ];

    void _showLogoutDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Konfirmasi Logout"),
            content: Text("Anda yakin untuk logout?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Tidak"),
              ),
              TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Ya"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 201, 216, 245),
          width: width,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 201, 216, 245),
                ),
                height: height * 0.23,
                width: width,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 35,
                        left: 15,
                        right: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              _showLogoutDialog(context);
                            },
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dashboard",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Sistem Informasi Fakultas Vokasi IT Del",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 20,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: icons.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => pages[index]),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              icons[index],
                              size: 100,
                              color: Colors.grey,
                            ),
                            Text(
                              titles[index],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
