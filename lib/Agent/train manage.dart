import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_android/AppWidget.dart';

class TrainsManagementAgent extends StatefulWidget {
  const TrainsManagementAgent({super.key});

  @override
  _TrainsManagementAgentState createState() => _TrainsManagementAgentState();
}

class _TrainsManagementAgentState extends State<TrainsManagementAgent> {
  final TextEditingController _trainNameController = TextEditingController();
  TimeOfDay? _selectedDepartTime;

  final List<String> regions = [
    'Adamaoua', 'Centre', 'Est', 'Extrême-Nord', 'Littoral',
    'Nord', 'Nord-Ouest', 'Ouest', 'Sud', 'Sud-Ouest'
  ];

  String? _selectedDepartRegion;
  String? _selectedArriveRegion;
  String? _selectedDepartCity;
  String? _selectedArriveCity;

  final Map<String, List<String>> citiesByRegion = {
    'Adamaoua': ['Ngaoundéré', 'Tibati', 'Meiganga'],
    'Centre': ['Yaoundé', 'Obala', 'Mbalmayo'],
    'Est': ['Bertoua', 'Batouri', 'Abong-Mbang'],
    'Extrême-Nord': ['Maroua', 'Kousséri', 'Mokolo'],
    'Littoral': ['Douala', 'Nkongsamba', 'Loum'],
    'Nord': ['Garoua', 'Guider', 'Poli'],
    'Nord-Ouest': ['Bamenda', 'Wum', 'Kumbo'],
    'Ouest': ['Bafoussam', 'Dschang', 'Foumban'],
    'Sud': ['Ebolowa', 'Kribi', 'Sangmélima'],
    'Sud-Ouest': ['Buea', 'Limbe', 'Kumba'],
  };

  Future<void> _addTrain() async {
    final String trainName = _trainNameController.text.trim();
    final String departRegion = _selectedDepartRegion ?? '';
    final String arriveRegion = _selectedArriveRegion ?? '';
    final String departCity = _selectedDepartCity ?? '';
    final String arriveCity = _selectedArriveCity ?? '';
    final String? departTime = _selectedDepartTime?.format(context);

    if (trainName.isEmpty || departRegion.isEmpty || arriveRegion.isEmpty || departCity.isEmpty || arriveCity.isEmpty || departTime == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: const Text('Veuillez remplir tous les champs.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('trains').add({
        'name': trainName,
        'departRegion': departRegion,
        'arriveRegion': arriveRegion,
        'departCity': departCity,
        'arriveCity': arriveCity,
        'departTime': departTime,
        'places': 100,
      });

      _trainNameController.clear();
      setState(() {
        _selectedDepartRegion = null;
        _selectedArriveRegion = null;
        _selectedDepartCity = null;
        _selectedArriveCity = null;
        _selectedDepartTime = null;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: Text("Erreur: ${e.toString()}"),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedDepartTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedDepartTime) {
      setState(() {
        _selectedDepartTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Ajouter un Train",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _trainNameController,
              decoration: const InputDecoration(
                labelText: "Nom du train",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedDepartRegion,
              onChanged: (String? value) {
                setState(() {
                  _selectedDepartRegion = value;
                  _selectedDepartCity = null;
                });
              },
              decoration: const InputDecoration(
                labelText: "Région de départ",
                border: OutlineInputBorder(),
              ),
              items: regions.map((String region) {
                return DropdownMenuItem<String>(
                  value: region,
                  child: Text(region),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            if (_selectedDepartRegion != null)
              DropdownButtonFormField<String>(
                value: _selectedDepartCity,
                onChanged: (String? value) {
                  setState(() {
                    _selectedDepartCity = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Ville de départ",
                  border: OutlineInputBorder(),
                ),
                items: citiesByRegion[_selectedDepartRegion!]!.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
              ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedArriveRegion,
              onChanged: (String? value) {
                setState(() {
                  _selectedArriveRegion = value;
                  _selectedArriveCity = null;
                });
              },
              decoration: const InputDecoration(
                labelText: "Région de destination",
                border: OutlineInputBorder(),
              ),
              items: regions.map((String region) {
                return DropdownMenuItem<String>(
                  value: region,
                  child: Text(region),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            if (_selectedArriveRegion != null)
              DropdownButtonFormField<String>(
                value: _selectedArriveCity,
                onChanged: (String? value) {
                  setState(() {
                    _selectedArriveCity = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Ville d'arrivée",
                  border: OutlineInputBorder(),
                ),
                items: citiesByRegion[_selectedArriveRegion!]!.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
              ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xff28c6ff), Color(0xff86e0a0)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Sélectionner l'heure de départ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            if (_selectedDepartTime != null)
              Text('Heure de départ: ${_selectedDepartTime!.format(context)}'),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: _addTrain,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xff28c6ff), Color(0xff86e0a0)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Ajouter un Train",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 400,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('trains').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: AppWidget.loading(Colors.green));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Aucun train disponible.'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var train = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(train['name'] ?? ''),
                        subtitle: Text(
                            '${train['departCity']} à ${train['arriveCity']} à ${train['departTime']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await FirebaseFirestore.instance.collection('trains').doc(train.id).delete();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
