import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class LocationMapModal extends StatefulWidget {
  final NLatLng? initialLocation;

  const LocationMapModal({
    super.key,
    this.initialLocation,
  });

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
      // 전체 화면 크기로 변경
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      // 모서리 둥글게 제거
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          // 헤더 바
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
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

          // 지도 - 남은 공간 전체를 채우도록 변경
          Expanded(
            child: Stack(
              children: [
                NaverMap(
                  options: NaverMapViewOptions(
                    initialCameraPosition: NCameraPosition(
                      target: widget.initialLocation ??
                          NLatLng(37.5666102, 126.9783881), // 서울시청 기본값
                      zoom: 15,
                    ),
                    logoAlign: NLogoAlign.leftBottom,
                    extent: NLatLngBounds(
                      southWest: NLatLng(31.43, 122.37),
                      northEast: NLatLng(44.35, 132.0),
                    ),
                    mapType: NMapType.basic,
                    indoorEnable: true,
                    scaleBarEnable: true,
                    nightModeEnable: false,
                  ),
                  onMapReady: (controller) {
                    _mapController = controller;
                    controller
                        .setLocationTrackingMode(NLocationTrackingMode.none);

                    if (widget.initialLocation != null) {
                      _updateMarker(widget.initialLocation!);
                    }
                  },
                  onMapTapped: _onMapTap,
                ),
                // 서울시청 이동 버튼
                Positioned(
                  bottom: 80,
                  right: 16,
                  child: InkWell(
                    onTap: () {
                      _mapController?.updateCamera(
                        NCameraUpdate.withParams(
                          target: NLatLng(37.5670135, 126.9783740),
                          zoom: 16,
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_city,
                              color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '서울시청으로 이동',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // 드래그 안내 메시지
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '화면을 터치하여 위치를 선택하세요',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ),
              ],
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
