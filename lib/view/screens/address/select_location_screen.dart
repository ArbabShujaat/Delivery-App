import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectLocationScreen extends StatefulWidget {
  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController _controller;
  TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<LocationProvider>(context).address != null) {
      _locationController.text =
          '${Provider.of<LocationProvider>(context).address.featureName ?? ''} '
          '${Provider.of<LocationProvider>(context).address.subAdminArea ?? ''} '
          '${Provider.of<LocationProvider>(context).address.countryCode ?? ''}';
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Container(
          color: ColorResources.COLOR_PRIMARY,
          height: 100,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 20.0),
          child: Text(
            getTranslated('select_delivery_address', context),
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) => Stack(
          overflow: Overflow.visible,
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(locationProvider.position.latitude ?? 0.0,
                    locationProvider.position.longitude ?? 0.0),
                zoom: 14,
              ),
              zoomControlsEnabled: false,
              compassEnabled: false,
              indoorViewEnabled: true,
              mapToolbarEnabled: true,
              onCameraIdle: () {
                locationProvider.dragableAddress();
              },
              onCameraMove: ((_position) =>
                  locationProvider.updatePosition(_position)),
              // markers: Set<Marker>.of(locationProvider.markers),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                if (_controller != null) {
                  locationProvider.getCurrentLocation(
                      mapController: _controller);
                }
              },
            ),
            locationProvider.address != null
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_LARGE,
                        vertical: 18.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_LARGE,
                        vertical: 23.0),
                    decoration: BoxDecoration(
                        color: Color(0xffdcfdff),
                        borderRadius: BorderRadius.circular(26)),
                    child: Text(locationProvider.address.featureName != null
                        ? '${locationProvider.address.featureName} , ${locationProvider.address.subAdminArea} , ${locationProvider.address.countryCode} '
                        : ''),
                  )
                : SizedBox.shrink(),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      locationProvider.getCurrentLocation(
                          mapController: _controller);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      margin:
                          EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            Dimensions.PADDING_SIZE_SMALL),
                        color: ColorResources.COLOR_WHITE,
                      ),
                      child: Icon(
                        Icons.my_location,
                        color: ColorResources.COLOR_PRIMARY,
                        size: 35,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_LARGE,
                        vertical: 47.0),
                    child: Center(
                      child: CustomButton(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.06,
                        btnTxt: getTranslated('select_location', context),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  Images.marker,
                  width: 25,
                  height: 35,
                )),
            locationProvider.loading
                ? Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor)))
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
