import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class Course {
  final String name;
  final String room;
  final String location;
  final String startTime;
  final String endTime;
  final String date;

  Course({
    required this.name,
    required this.room,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.date,
  });
}

class MapController extends GetxController {
  // Position de l'utilisateur
  var userPosition = Rxn<LatLng>();
  var isLoadingLocation = true.obs;
  var locationError = ''.obs;

  // Position de l'école (ISM Dakar Campus)
  final LatLng schoolLocation = LatLng(14.6928, -17.4467);

  // Prochains cours
  var nextCourses = <Course>[].obs;

  @override
  void onInit() {
    super.onInit();
    print('MapController initialisé');
    _loadNextCourses();
    _getCurrentLocation();
  }

  void _loadNextCourses() {
    // Simuler le chargement des prochains cours
    nextCourses.value = [
      Course(
        name: 'Flutter',
        room: '204',
        location: 'Campus Baobab',
        startTime: '8h',
        endTime: '12h',
        date: '12/06/2025',
      ),
      Course(
        name: 'Base de données',
        room: '105',
        location: 'Campus Baobab',
        startTime: '14h',
        endTime: '17h',
        date: '12/06/2025',
      ),
    ];
  }

  Future<void> _getCurrentLocation() async {
    try {
      isLoadingLocation.value = true;
      locationError.value = '';

      // Vérifier si le service de localisation est activé
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationError.value = 'Service de localisation désactivé';
        isLoadingLocation.value = false;
        // Position par défaut si pas de géolocalisation
        userPosition.value = LatLng(14.6837, -17.4440);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationError.value = 'Permission de localisation refusée';
          isLoadingLocation.value = false;
          userPosition.value = LatLng(14.6837, -17.4440);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        locationError.value =
            'Permission de localisation refusée définitivement';
        isLoadingLocation.value = false;
        userPosition.value = LatLng(14.6837, -17.4440);
        return;
      }

      // Obtenir la position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(Duration(seconds: 15));

      userPosition.value = LatLng(position.latitude, position.longitude);
      isLoadingLocation.value = false;
    } catch (e) {
      print('Erreur de géolocalisation: $e');
      locationError.value = 'Erreur lors de la récupération de la position';
      isLoadingLocation.value = false;
      userPosition.value = LatLng(14.6837, -17.4440);
    }
  }

  void refreshLocation() {
    _getCurrentLocation();
  }

  double? getDistanceToSchool() {
    if (userPosition.value == null) return null;

    return Geolocator.distanceBetween(
      userPosition.value!.latitude,
      userPosition.value!.longitude,
      schoolLocation.latitude,
      schoolLocation.longitude,
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
