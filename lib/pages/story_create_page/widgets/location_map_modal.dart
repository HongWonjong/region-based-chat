import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class LocationMapModal extends StatefulWidget {
  final NLatLng? initialLocation;

  const LocationMapModal({Key? key, this.initialLocation}) : super(key: key);

  @override
  State<LocationMapModal> createState() => _LocationMapModalState();
}

class _LocationMapModalState extends State<LocationMapModal> {
  NaverMapController? _mapController;
  NMarker? _marker;
  NLatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  void _onMapTap(NPoint point, NLatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
      _updateMarker(latLng);
    });
  }

  void _updateMarker(NLatLng position) {
    if (_marker != null) {
      _mapController?.deleteOverlay(_marker!.info);
    }
    _marker = NMarker(
      id: 'selected_location',
      position: position,
    );
    _mapController?.addOverlay(_marker!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // 헤더 바
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '위치 선택',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('취소'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _selectedLocation != null
                          ? () => Navigator.pop(context, _selectedLocation)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('선택'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 지도
          Expanded(
            child: NaverMap(
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: widget.initialLocation ?? NLatLng(37.5666102, 126.9783881), // 서울시청 기본값
                  zoom: 15,
                ),
                logoAlign: NLogoAlign.leftBottom,
                extent: NLatLngBounds(
                  southWest: NLatLng(31.43, 122.37),
                  northEast: NLatLng(44.35, 132.0),
                ),
              ),
              onMapReady: (controller) {
                _mapController = controller;
                if (widget.initialLocation != null) {
                  _updateMarker(widget.initialLocation!);
                }
              },
              onMapTapped: _onMapTap,
            ),
          ),
          
          // 하단 정보 표시
          if (_selectedLocation != null)
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '선택한 위치: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '위도: ${_selectedLocation!.latitude.toStringAsFixed(6)}\n경도: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
} 