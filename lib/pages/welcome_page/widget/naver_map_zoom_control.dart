import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

/// 네이버 지도 줌 컨트롤 위젯
///
/// 다크모드에 대응하는 확대/축소 버튼을 제공합니다.
class NaverMapZoomControlWidget extends StatelessWidget {
  final NaverMapController? mapController;

  const NaverMapZoomControlWidget({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 확대 버튼
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.add,
              color: isDark ? Colors.amber : Colors.deepPurple,
            ),
            onPressed: () {
              if (mapController != null) {
                mapController!.updateCamera(
                  NCameraUpdate.zoomIn(),
                );
              }
            },
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(),
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
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.remove,
              color: isDark ? Colors.amber : Colors.deepPurple,
            ),
            onPressed: () {
              if (mapController != null) {
                mapController!.updateCamera(
                  NCameraUpdate.zoomOut(),
                );
              }
            },
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(),
            iconSize: 24,
          ),
        ),
      ],
    );
  }
}
