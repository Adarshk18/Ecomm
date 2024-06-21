import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> store;

  const StoreDetailsScreen({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double latitude = store['geometry']['location']['lat'];
    final double longitude = store['geometry']['location']['lng'];
    final LatLng storeLocation = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(store['name']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              store['photos'] != null
                  ? Image.network(
                      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${store['photos'][0]['photo_reference']}&key=YOUR_API_KEY', // Replace with your API key
                    )
                  : Container(),
              const SizedBox(height: 10),
              Text(
                store['name'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(store['vicinity']),
              const SizedBox(height: 10),
              store['opening_hours'] != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Opening Hours',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        for (var period in store['opening_hours']
                            ['weekday_text'])
                          Text(period),
                      ],
                    )
                  : Container(),
              const SizedBox(height: 10),
              Text('Contact: ${store['formatted_phone_number'] ?? 'N/A'}'),
              const SizedBox(height: 10),
              const Text('Location:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                height: 200,
                width: double.infinity,
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: storeLocation, zoom: 15),
                  markers: {
                    Marker(
                      markerId: MarkerId(store['place_id']),
                      position: storeLocation,
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
