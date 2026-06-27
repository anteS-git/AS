import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// Globalna "tema" koju admin može mijenjati
class AppTheme {
  static Color primaryButton = Colors.orange;
  static Color secondaryButton = Colors.green;
  static String backgroundUrl =
      "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1200&q=80";
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PocetniEkran(),
    );
  }
}

class PocetniEkran extends StatefulWidget {
  const PocetniEkran({super.key});

  @override
  State<PocetniEkran> createState() => _PocetniEkranState();
}

class _PocetniEkranState extends State<PocetniEkran> {
  Future<void> _openAdmin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminEkran()),
    );
    setState(() {}); // osvježi boje nakon povratka
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(AppTheme.backgroundUrl),
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(
              Colors.black45,
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(240, 60),
                  backgroundColor: AppTheme.primaryButton,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UnesiNamirniceEkran(),
                    ),
                  );
                },
                child: const Text(
                  "Unesi namirnice",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(240, 60),
                  backgroundColor: AppTheme.secondaryButton,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DnevniReceptiEkran(),
                    ),
                  );
                },
                child: const Text(
                  "Predloži recept",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: Colors.grey.shade800,
                ),
                onPressed: _openAdmin,
                child: const Text(
                  "Admin",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DnevniReceptiEkran extends StatefulWidget {
  const DnevniReceptiEkran({super.key});

  @override
  State<DnevniReceptiEkran> createState() => _DnevniReceptiEkranState();
}

class _DnevniReceptiEkranState extends State<DnevniReceptiEkran> {
  List<String> recepti = [];

  @override
  void initState() {
    super.initState();
    _generirajDnevneRecepte();
  }

  void _generirajDnevneRecepte() {
    // Seed po danu → svaki dan druga kombinacija (osvježi se u 00:00)
    final now = DateTime.now();
    final random = Random(now.year + now.month + now.day);

    final dorucak = [
      "Omlet s povrćem",
      "Zobena kaša s voćem",
      "Palačinke s medom",
      "Jaja na oko s povrćem",
    ];

    final rucak = [
      "Piletina s rižom",
      "Tjestenina bolonjez",
      "Rižoto s gljivama",
      "Lazanje",
    ];

    final vecera = [
      "Salata s tunom",
      "Tortilja s piletinom",
      "Juha od povrća",
      "Bruschette s rajčicom",
    ];

    setState(() {
      recepti = [
        dorucak[random.nextInt(dorucak.length)],
        rucak[random.nextInt(rucak.length)],
        vecera[random.nextInt(vecera.length)],
      ];
    });
  }

  String coolinarikaLink(String naziv) {
    final encoded = Uri.encodeComponent(naziv);
    return "https://www.coolinarika.com/pretraga/?query=$encoded";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dnevni prijedlozi"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Doručak: ${recepti[0]}"),
            subtitle: Text(coolinarikaLink(recepti[0])),
          ),
          ListTile(
            title: Text("Ručak: ${recepti[1]}"),
            subtitle: Text(coolinarikaLink(recepti[1])),
          ),
          ListTile(
            title: Text("Večera: ${recepti[2]}"),
            subtitle: Text(coolinarikaLink(recepti[2])),
          ),
        ],
      ),
    );
  }
}

class UnesiNamirniceEkran extends StatefulWidget {
  const UnesiNamirniceEkran({super.key});

  @override
  State<UnesiNamirniceEkran> createState() => _UnesiNamirniceEkranState();
}

class _UnesiNamirniceEkranState extends State<UnesiNamirniceEkran> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _namirnice = [];

  void _dodajNamirnicu() {
    final tekst = _controller.text.trim();
    if (tekst.isNotEmpty) {
      setState(() {
        _namirnice.add(tekst);
      });
      _controller.clear();
    }
  }

  void _traziRecepte() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceptiEkran(namirnice: _namirnice),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Unesi namirnice")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Upiši namirnicu",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _dodajNamirnicu,
              child: const Text("Dodaj"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _namirnice.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_namirnice[index]),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _traziRecepte,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryButton,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Traži recept"),
            ),
          ],
        ),
      ),
    );
  }
}

class ReceptiEkran extends StatefulWidget {
  final List<String> namirnice;

  const ReceptiEkran({super.key, required this.namirnice});

  @override
  State<ReceptiEkran> createState() => _ReceptiEkranState();
}

class _ReceptiEkranState extends State<ReceptiEkran> {
  List<dynamic> recepti = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    final query = widget.namirnice.join(", ");
    final url = Uri.parse("https://api.api-ninjas.com/v1/recipe?query=$query");

    final response = await http.get(
      url,
      headers: {
        "X-Api-Key": "H9x9fkJ4XEkTsFt8JNOGyA6XEP2vh0hBbOhPTn5y",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        recepti = jsonDecode(response.body);
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  String coolinarikaLink(String naziv) {
    final encoded = Uri.encodeComponent(naziv);
    return "https://www.coolinarika.com/pretraga/?query=$encoded";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pronađeni recepti")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : recepti.isEmpty
              ? const Center(child: Text("Nema pronađenih recepata"))
              : ListView.builder(
                  itemCount: recepti.length,
                  itemBuilder: (context, index) {
                    final r = recepti[index];
                    final naziv = r["title"] ?? "Nepoznato";
                    final link = coolinarikaLink(naziv);

                    return ListTile(
                      title: Text(naziv),
                      subtitle: Text(link),
                    );
                  },
                ),
    );
  }
}

class AdminEkran extends StatefulWidget {
  const AdminEkran({super.key});

  @override
  State<AdminEkran> createState() => _AdminEkranState();
}

class _AdminEkranState extends State<AdminEkran> {
  final TextEditingController _passController = TextEditingController();
  bool _authorized = false;

  void _checkPassword() {
    if (_passController.text == "1234567890") {
      setState(() {
        _authorized = true;
      });
    }
  }

  void _setThemeOrangeGreen() {
    setState(() {
      AppTheme.primaryButton = Colors.orange;
      AppTheme.secondaryButton = Colors.green;
      AppTheme.backgroundUrl =
          "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1200&q=80";
    });
  }

  void _setThemeRedYellow() {
    setState(() {
      AppTheme.primaryButton = Colors.redAccent;
      AppTheme.secondaryButton = Colors.amber;
      AppTheme.backgroundUrl =
          "https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=1200&q=80";
    });
  }

  void _setThemeDark() {
    setState(() {
      AppTheme.primaryButton = Colors.deepPurple;
      AppTheme.secondaryButton = Colors.blueGrey;
      AppTheme.backgroundUrl =
          "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=80";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: !_authorized
            ? Column(
                children: [
                  const Text("Unesi lozinku za admin sučelje:"),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Lozinka",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _checkPassword,
                    child: const Text("Potvrdi"),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Uredi sučelje (boje i pozadina):",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _setThemeOrangeGreen,
                    child: const Text("Tema 1: Narančasta / Zelena"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _setThemeRedYellow,
                    child: const Text("Tema 2: Crvena / Žuta"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _setThemeDark,
                    child: const Text("Tema 3: Tamna kuhinja"),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Promjene će se vidjeti kad se vratiš na početni ekran.",
                  ),
                ],
              ),
      ),
    );
  }
}
