import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../core/app_colors.dart';
import '../../Dashboard/view/widgets/appbar.dart';

class CustomerLocationView extends StatelessWidget {
  const CustomerLocationView({
    super.key,
    required this.customerLat,
    required this.customerLong,
    required this.employLat,
    required this.employLong
  });

  final double customerLat, customerLong;
  final double employLat,employLong;

  @override
  Widget build(BuildContext context) {
    final startPoint = LatLng(employLat, employLong); //LatLng(61.18081843,  -149.8359225);
    final endPoint = LatLng(customerLat, customerLong);
    return Scaffold(
      appBar: commonAppBar(
        context,
        showLeading: true,
        title: 'Job Location',
      ),
     // body: WebViewWidget(controller: _controller),
     body:Stack(
       children: [
         FlutterMap(
           options: MapOptions(
             initialCenter: LatLng(customerLat, customerLong)
           ),
           children:
           [
             TileLayer(
               urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
               userAgentPackageName: 'com.younderbot.acvmx',
             ),
             PolylineLayer(
                 polylines: [
                  Polyline(
                    points: [
                      startPoint,
                      endPoint
                    ],
                    strokeWidth: 4.0,
                    color: AppColor.blue18338E,
                    strokeCap: StrokeCap.round
                  )
             ]),
             MarkerLayer(
               markers: [
                 Marker(
                   width: 40,
                   height: 40,
                   point: startPoint,
                   child:  Icon(Icons.circle, color: AppColor.blue19489F, size: 40),
                 ),
                 Marker(
                   width: 50,
                   height: 50,
                   point: endPoint,
                   child:  Icon(Icons.location_on, color: AppColor.redColor, size: 40),
                 ),
               ],
             ),
             ],
         )
       ],
     ) ,
    );
  }
}
