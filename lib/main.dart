import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BonekaApp());
}

class BonekaApp extends StatelessWidget {
  const BonekaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.pinkAccent,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.jpg',
              height: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              'Manda\'s Store',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String staticEmail = "manda";
  String staticPassword = "123456";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.jpg',
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Manda\'s Store',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (emailController.text == staticEmail &&
                          passwordController.text == staticPassword) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(email: staticEmail)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email atau password salah!'),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({super.key, required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Map<String, String>> favorites = [];

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeMenu(
        onAddToFavorites: (item) {
          setState(() {
            if (!favorites.any((fav) => fav["name"] == item["name"])) {
              favorites.add(item);
            }
          });
        },
      ),
      FavoriteMenu(favorites: favorites),
      ProfileMenu(
        email: widget.email,
        onLogout: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manda\'s Store'),
        backgroundColor: Colors.pinkAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.pinkAccent),
              child: Center(
                child: Text(
                  'Manda\'s Store',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorit'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: pages[_currentIndex],
    );
  }
}

class HomeMenu extends StatelessWidget {
  final Function(Map<String, String>) onAddToFavorites;

  HomeMenu({super.key, required this.onAddToFavorites});

  final List<Map<String, String>> products = [
    {"name": "Boneka 1", "image": "assets/b1.jpeg"},
    {"name": "Boneka 2", "image": "assets/b2.jpeg"},
    {"name": "Boneka 3", "image": "assets/b3.jpeg"},
    {"name": "Boneka 4", "image": "assets/b4.jpeg"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            leading: Image.asset(
              product["image"]!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, color: Colors.grey);
              },
            ),
            title: Text(
              product["name"]!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.pink),
              onPressed: () => onAddToFavorites(product),
            ),
            onTap: () {
              // Navigasi ke layar detail produk
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetail(product: product),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ProductDetail extends StatelessWidget {
  final Map<String, String> product;

  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product["name"]!),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Mengatur agar kolom tidak memenuhi layar
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              product["image"]!,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, size: 100, color: Colors.grey);
              },
            ),
            const SizedBox(height: 20),
            Text(
              product["name"]!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class FavoriteMenu extends StatelessWidget {
  final List<Map<String, String>> favorites;

  const FavoriteMenu({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return favorites.isEmpty
        ? const Center(child: Text('Belum ada item favorit'))
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Image.asset(
                    favorite["image"]!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image, color: Colors.grey);
                    },
                  ),
                  title: Text(
                    favorite["name"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ),
              );
            },
          );
  }
}

class ProfileMenu extends StatelessWidget {
  final String email;
  final Function onLogout;

  const ProfileMenu({super.key, required this.email, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Center( // Membuat konten di tengah layar
      child: Column(
        mainAxisSize: MainAxisSize.min, // Agar hanya mengambil ruang secukupnya
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.pink[50],
            child: const Icon(Icons.person, size: 80, color: Colors.pinkAccent),
          ),
          const SizedBox(height: 20),
          Text(
            'Halo, $email',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => onLogout(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

