import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_android/AppWidget.dart';


class RegionTrainsPage extends StatelessWidget {
  final String region;

  const RegionTrainsPage({super.key, required this.region});

  Future<void> _reserveSeat(BuildContext context, DocumentSnapshot train) async {
    final int availableSeats = train['places'];
    if (availableSeats <= 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Réservation impossible'),
          content: const Text('Aucune place disponible pour ce train.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    int seatsToReserve = 1;
    List<String> passengerNames = [];

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Réserver des places'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<int>(
                      value: seatsToReserve,
                      onChanged: (value) {
                        setState(() {
                          seatsToReserve = value!;
                          passengerNames = List<String>.filled(seatsToReserve, '');
                        });
                      },
                      items: List.generate(availableSeats, (index) => index + 1).map((value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value places'),
                        );
                      }).toList(),
                    ),
                    ...List.generate(seatsToReserve, (index) {
                      return TextField(
                        onChanged: (value) {
                          passengerNames[index] = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Nom du passager ${index + 1}',
                        ),
                      );
                    }),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Annuler'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Confirmer'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _confirmReservation(context, train, seatsToReserve, passengerNames);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }


  Future<void> _confirmReservation(BuildContext context, DocumentSnapshot train, int seatsToReserve, List<String> passengerNames) async {
    final int availableSeats = train['places'];
    if (seatsToReserve > availableSeats) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Réservation impossible'),
          content: const Text('Le nombre de places demandé est supérieur au nombre de places disponibles.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    List<String> seatIds = List.generate(seatsToReserve, (index) => _generateSeatId(availableSeats - index));

    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (int i = 0; i < seatsToReserve; i++) {
        batch.set(
          FirebaseFirestore.instance.collection('reservations').doc(),
          {
            'trainId': train.id,
            'seatId': seatIds[i],
            'passengerName': passengerNames[i],
            'status': true,
            'timestamp': FieldValue.serverTimestamp(),
          },
        );
      }

      batch.update(
        FirebaseFirestore.instance.collection('trains').doc(train.id),
        {'places': availableSeats - seatsToReserve},
      );

      await batch.commit();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Réservation réussie'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: seatIds.map((seatId) => Text('Votre siège est $seatId')).toList(),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erreur'),
          content: Text('Une erreur s\'est produite lors de la réservation: $e'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  String _generateSeatId(int availableSeats) {
    const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    int row = (100 - availableSeats) ~/ 10;
    int seatNumber = (100 - availableSeats) % 10 + 1;
    String seatId = '${alphabet[row]}$seatNumber';
    return seatId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trains disponibles pour $region', style: AppWidget.styledetexte(taille: 15)),
        flexibleSpace: AppWidget.themeappbar(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('trains')
            .where('departRegion', isEqualTo: region)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucun train disponible.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var train = snapshot.data!.docs[index];
              return ListTile(
                title: Text(train['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Train: ${train['name']}'),
                    Text('De: ${train['departCity']} à ${train['arriveCity']}'),
                    Text('Heure de départ: ${train['departTime']}'),
                    Text('Places disponibles: ${train['places']}'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () => _reserveSeat(context, train),
                  child: const Text('Réserver'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
