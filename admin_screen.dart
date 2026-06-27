import 'package:flutter/material.dart';
import 'package:asmart_chef/theme/app_theme.dart';

class AdminScreen extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const AdminScreen({super.key, required this.themeNotifier});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _lozinkaController = TextEditingController();
  bool _prijavljen = false;
  bool _pogresnaLozinka = false;
  bool _prikaziLozinku = false;

  static const String _ispravnaLozinka = '1234567890';

  static const List<Map<String, dynamic>> _boje = [
    {'naziv': 'Ljubičasta', 'boja': Color(0xFF6A1B9A)},
    {'naziv': 'Plava', 'boja': Color(0xFF1565C0)},
    {'naziv': 'Zelena', 'boja': Color(0xFF2E7D32)},
    {'naziv': 'Crvena', 'boja': Color(0xFFC62828)},
    {'naziv': 'Narančasta', 'boja': Color(0xFFE65100)},
    {'naziv': 'Tirkizna', 'boja': Color(0xFF00695C)},
    {'naziv': 'Ružičasta', 'boja': Color(0xFFAD1457)},
    {'naziv': 'Smeđa', 'boja': Color(0xFF4E342E)},
  ];

  void _provjeriLozinku() {
    if (_lozinkaController.text == _ispravnaLozinka) {
      setState(() {
        _prijavljen = true;
        _pogresnaLozinka = false;
      });
    } else {
      setState(() {
        _pogresnaLozinka = true;
      });
    }
  }

  @override
  void dispose() {
    _lozinkaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.themeNotifier,
      builder: (context, _) {
        final color = widget.themeNotifier.buttonColor;
        return Scaffold(
          backgroundColor: Colors.deepPurple.shade50,
          appBar: AppBar(
            title: const Text('Admin panel'),
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: _prijavljen
              ? _AdminPanel(
                  themeNotifier: widget.themeNotifier,
                  boje: _boje,
                )
              : _PrijavaNaAdmin(
                  controller: _lozinkaController,
                  pogresnaLozinka: _pogresnaLozinka,
                  prikaziLozinku: _prikaziLozinku,
                  color: color,
                  onToggleVisibility: () => setState(
                      () => _prikaziLozinku = !_prikaziLozinku),
                  onPotvrdi: _provjeriLozinku,
                ),
        );
      },
    );
  }
}

class _PrijavaNaAdmin extends StatelessWidget {
  final TextEditingController controller;
  final bool pogresnaLozinka;
  final bool prikaziLozinku;
  final Color color;
  final VoidCallback onToggleVisibility;
  final VoidCallback onPotvrdi;

  const _PrijavaNaAdmin({
    required this.controller,
    required this.pogresnaLozinka,
    required this.prikaziLozinku,
    required this.color,
    required this.onToggleVisibility,
    required this.onPotvrdi,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 72, color: color),
            const SizedBox(height: 24),
            const Text(
              'Admin prijava',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Unesite administratorsku lozinku',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: controller,
              obscureText: !prikaziLozinku,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => onPotvrdi(),
              decoration: InputDecoration(
                labelText: 'Lozinka',
                hintText: 'Unesite lozinku',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: color, width: 2),
                ),
                prefixIcon: const Icon(Icons.password),
                suffixIcon: IconButton(
                  icon: Icon(
                    prikaziLozinku ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: onToggleVisibility,
                ),
                filled: true,
                fillColor: Colors.white,
                errorText: pogresnaLozinka ? 'Pogrešna lozinka!' : null,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPotvrdi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text('Prijava'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminPanel extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  final List<Map<String, dynamic>> boje;

  const _AdminPanel({
    required this.themeNotifier,
    required this.boje,
  });

  @override
  Widget build(BuildContext context) {
    final color = themeNotifier.buttonColor;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: color),
                const SizedBox(width: 12),
                const Text(
                  'Uspješno ste prijavljeni!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Boja gumba',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Odaberite novu boju za gumbe u aplikaciji:',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: boje.length,
            itemBuilder: (context, index) {
              final boja = boje[index];
              final isOdabrana = themeNotifier.buttonColor == boja['boja'];
              return GestureDetector(
                onTap: () =>
                    themeNotifier.setButtonColor(boja['boja'] as Color),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: boja['boja'] as Color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isOdabrana
                              ? Colors.black
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (boja['boja'] as Color).withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: isOdabrana
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 28)
                          : null,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      boja['naziv'] as String,
                      style: const TextStyle(fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 28),
          const Text(
            'Pregled tema',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Primjer gumba',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Trenutna boja gumba',
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
