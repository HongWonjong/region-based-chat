import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
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
  bool _mapReady = false;

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
        borderRadius: BorderRadius.circular(16),
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

          // 지도
          Expanded(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: NaverMap(
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
                  contentPadding: EdgeInsets.zero,
                  nightModeEnable: false,
                  locale: const Locale.fromSubtags(languageCode: 'ko'),
                ),
                onMapReady: (controller) {
                  _mapController = controller;

                  // 위치 추적 모드 해제
                  controller
                      .setLocationTrackingMode(NLocationTrackingMode.none);

                  // 카메라 이동 시도
                  Future.delayed(Duration(milliseconds: 300), () {
                    controller.updateCamera(
                      NCameraUpdate.withParams(
                        target: widget.initialLocation ??
                            NLatLng(37.5666102, 126.9783881),
                        zoom: 15,
                      ),
                    );
                  });

                  if (widget.initialLocation != null) {
                    _updateMarker(widget.initialLocation!);
                  }

                  setState(() {
                    _mapReady = true;
                  });

                  // 햅틱 피드백 제공 - 지도가 준비되었음을 알림
                  HapticFeedback.lightImpact();
                },
                onMapTapped: (point, latLng) {
                  // 햅틱 피드백 제공 - 맵이 정상 작동함을 알림
                  HapticFeedback.selectionClick();
                  _onMapTap(point, latLng);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
