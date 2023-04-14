const GOOGLE_API_KEY = 'AIzaSyCOp9dVrGZ_pvQQexvkDMZoL48Co_XD2A8';

class LocationUtil {
  static String generateLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    return '''https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=satellite&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY''';
  }
}
