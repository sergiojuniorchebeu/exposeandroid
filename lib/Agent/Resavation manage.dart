import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_android/AppWidget.dart';

class ReservationsManagementAgent extends StatelessWidget {
  const ReservationsManagementAgent({Key? key});

  Future<void> _cancelReservation(BuildContext context, DocumentSnapshot reservation) async {
    try {
      String trainId = reservation['trainId'];
      String seatId = reservation['seatId'];

      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Delete reservation
      batch.delete(reservation.reference);

      // Update train seats
      batch.update(
        FirebaseFirestore.instance.collection('trains').doc(trainId),
        {'places': FieldValue.increment(1)},
      );

      await batch.commit();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Annulation réussie'),
          content: Text('Votre réservation pour le siège $seatId a été annulée.'),
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
          content: Text('Une erreur s\'est produite lors de l\'annulation: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('reservations').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: AppWidget.loading(Colors.green));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Aucune réservation trouvée.'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var reservation = snapshot.data!.docs[index];
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('trains').doc(reservation['trainId']).get(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> trainSnapshot) {
                        if (trainSnapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(
                            title: Text("Chargement..."),
                          );
                        }
                        if (!trainSnapshot.hasData || !trainSnapshot.data!.exists) {
                          return const ListTile(
                            title: Text("Train introuvable"),
                          );
                        }
                        var trainData = trainSnapshot.data!;
                        return ListTile(
                          title: Text("Réservation pour ${trainData['name']}"),
                          subtitle: Text("Utilisateur: ${reservation['passengerName']}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _cancelReservation(context, reservation),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
