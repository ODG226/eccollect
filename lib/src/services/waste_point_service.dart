import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocollect/src/models/waste_point.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_user.dart'; // adapte le chemin selon ton projet

class WastePointService {
  final CollectionReference pointRef = FirebaseFirestore.instance.collection("point");

 /// ajoute ou modifie le point de lutilisateur
 Future<void> saveOrUpdateUserPoint({required String id, required LatLng geolocation})async
 {
  var lat = geolocation.latitude;
  var long = geolocation.longitude;
    var data = {"id":id, "lat": lat, "long":long};
    var _setPoints = await pointRef.get();
    var matchedPoints = _setPoints.docs.where((item)=>item["id"]==id);
    try
    {
      // si la liste est vide on ajoute le nouvel element
      if(matchedPoints.isEmpty)
      {
        await pointRef.doc(id).set(data);
      }
      //si non on la modifie
      else
      {
        print(data);
        await pointRef.doc(id).update(data);
      }
  
    }
    catch(e, s)
    {
      throw Exception(e);
    }
 }

  /// Récupère la liste des points de collecte
  Future<List<WastePoint>> fetchWastePoints() async {
    var _setPoints = await pointRef.get();
    return _setPoints.docs.map((doc) => WastePoint.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
}
