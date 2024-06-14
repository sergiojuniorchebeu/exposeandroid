import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReservationHistoryPage extends StatelessWidget {
  const ReservationHistoryPage({Key? key});

  Future<Map<String, dynamic>> _getReservationDetails(String reservationId) async {
    DocumentSnapshot reservationSnapshot =
    await FirebaseFirestore.instance.collection('reservations').doc(reservationId).get();
    if (!reservationSnapshot.exists) {
      throw Exception('Réservation introuvable');
    }

    String trainId = reservationSnapshot['trainId'];
    DocumentSnapshot trainSnapshot =
    await FirebaseFirestore.instance.collection('trains').doc(trainId).get();
    if (!trainSnapshot.exists) {
      throw Exception('Train introuvable');
    }

    String trainName = trainSnapshot['name'];
    String seatId = reservationSnapshot['seatId'];
    String passengerName = reservationSnapshot['passengerName'];

    return {
      'trainName': trainName,
      'seatId': seatId,
      'passengerName': passengerName,
    };
  }

  Future<void> _cancelReservation(
      BuildContext context, DocumentSnapshot reservation) async {
    try {
      String reservationId = reservation.id;
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
          content:
          Text('Votre réservation pour le siège $seatId a été annulée.'),
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
      appBar: AppBar(
        title: const Text('Historique des réservations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reservations')
            .where('status', isEqualTo: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucune réservation trouvée.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var reservation = snapshot.data!.docs[index];
              return FutureBuilder<Map<String, dynamic>>(
                future: _getReservationDetails(reservation.id),
                builder: (context, AsyncSnapshot<Map<String, dynamic>> reservationDetailsSnapshot) {
                  if (reservationDetailsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Chargement...'),
                    );
                  } else if (reservationDetailsSnapshot.hasError) {
                    return const ListTile(
                      title: Text('Erreur de chargement des détails de la réservation'),
                    );
                  } else {
                    return ListTile(
                      title: Text('Train: ${reservationDetailsSnapshot.data!['trainName']}'),
                      subtitle: Text('Siège: ${reservationDetailsSnapshot.data!['seatId']} - Passager: ${reservationDetailsSnapshot.data!['passengerName']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () => _cancelReservation(context, reservation),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
