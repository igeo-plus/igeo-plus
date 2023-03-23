const GOOGLE_API_KEY = 'AIzaSyDGsdWpyQmKfqa1IleoY9gm8BE4fvJVm-4';

class LocationUtil {
  static String generateLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    return '''https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=satellite&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY''';
  }
}
