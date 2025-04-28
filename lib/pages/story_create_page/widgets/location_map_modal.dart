import 'package:flutter/material.dart';
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

    // 마커 생성 및 스타일 지정
    _marker = NMarker(
      id: 'selected_location',
      position: position,
      icon: NOverlayImage.fromAssetImage('assets/marker_black.png'),
    );

    // 마커 크기 설정
    _marker!.setSize(Size(20, 30));

    // 마커 색상 설정 (테마에 따라 보라색 또는 황색)
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    _marker!.setIconTintColor(isDark ? Colors.amber : Colors.deepPurple);

    _mapController?.addOverlay(_marker!);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // 헤더 바
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.deepPurple,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '위치 선택',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white.withOpacity(0.9),
                      ),
                      child: Text('취소'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _selectedLocation != null
                          ? () => Navigator.pop(context, _selectedLocation)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.amber : Colors.amber,
                        foregroundColor:
                            isDark ? Colors.black : Colors.deepPurple.shade900,
                        disabledBackgroundColor: isDark
                            ? Colors.grey[600] // 다크모드에서 더 밝은 회색으로 변경
                            : Colors.grey.shade400,
                        disabledForegroundColor: isDark
                            ? Colors.grey[300] // 다크모드에서 텍스트 색상을 더 밝게 변경
                            : Colors.grey[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        '선택',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                      mapType: isDark ? NMapType.navi : NMapType.basic,
                      indoorEnable: true,
                      scaleBarEnable: true,
                      contentPadding: EdgeInsets.zero,
                      nightModeEnable: isDark,
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

                      HapticFeedback.lightImpact();
                    },
                    onMapTapped: (point, latLng) {
                      HapticFeedback.selectionClick();
                      _onMapTap(point, latLng);
                    },
                  ),

                  // 확대/축소 버튼
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 확대 버튼
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: isDark ? Colors.amber : Colors.deepPurple,
                            ),
                            onPressed: () {
                              if (_mapController != null) {
                                _mapController!.updateCamera(
                                  NCameraUpdate.zoomIn(),
                                );
                              }
                            },
                            padding: EdgeInsets.all(12),
                            constraints: BoxConstraints(),
                            iconSize: 24,
                          ),
                        ),

                        // 구분선
                        Container(
                          height: 1,
                          color: isDark
                              ? Colors.grey[700]!.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.3),
                          width: 48,
                        ),

                        // 축소 버튼
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: isDark ? Colors.amber : Colors.deepPurple,
                            ),
                            onPressed: () {
                              if (_mapController != null) {
                                _mapController!.updateCamera(
                                  NCameraUpdate.zoomOut(),
                                );
                              }
                            },
                            padding: EdgeInsets.all(12),
                            constraints: BoxConstraints(),
                            iconSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
