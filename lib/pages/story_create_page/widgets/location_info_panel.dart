import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class LocationInfoPanel extends StatelessWidget {
  final NLatLng? selectedLocation;
  final VoidCallback onEditPressed;

  const LocationInfoPanel({
    super.key,
    this.selectedLocation,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 위치가 선택되지 않은 경우의 패널
    if (selectedLocation == null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isDark
                  ? Colors.amber.withOpacity(0.3)
                  : Colors.deepPurple.shade100,
              width: 1.5),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.deepPurple.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on,
                color: isDark ? Colors.amber[300] : Colors.deepPurple.shade300,
                size: 28,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                '위치를 선택해주세요',
                style: TextStyle(
                  color:
                      isDark ? Colors.amber[300] : Colors.deepPurple.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: onEditPressed,
              style: TextButton.styleFrom(
                backgroundColor: isDark
                    ? Colors.amber.withOpacity(0.1)
                    : Colors.deepPurple.shade50,
                foregroundColor: isDark ? Colors.amber : Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                '위치 선택',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 위치가 선택된 경우의 패널
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark
                ? Colors.amber.withOpacity(0.5)
                : Colors.deepPurple.shade200,
            width: 1.5),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.deepPurple.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on,
              color: isDark ? Colors.amber : Colors.deepPurple,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '선택된 위치',
                  style: TextStyle(
                    color: isDark ? Colors.amber : Colors.deepPurple,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '위도: ${selectedLocation!.latitude.toStringAsFixed(6)}\n경도: ${selectedLocation!.longitude.toStringAsFixed(6)}',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          TextButton(
            onPressed: onEditPressed,
            style: TextButton.styleFrom(
              backgroundColor: isDark
                  ? Colors.amber.withOpacity(0.1)
                  : Colors.deepPurple.shade50,
              foregroundColor: isDark ? Colors.amber : Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              '변경하기',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
