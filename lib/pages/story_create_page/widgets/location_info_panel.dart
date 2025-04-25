import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class LocationInfoPanel extends StatelessWidget {
  final NLatLng? selectedLocation;
  final VoidCallback onEditPressed;

  const LocationInfoPanel({
    super.key,
    required this.selectedLocation,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEditPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, top: 8),
        decoration: BoxDecoration(
          color: selectedLocation != null
              ? Colors.blue.withAlpha(20)
              : Colors.grey.withAlpha(13),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: selectedLocation != null
                  ? Colors.blue.withAlpha(51)
                  : Colors.grey.withAlpha(51)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.location_on,
                  color:
                      selectedLocation != null ? Colors.blue : Colors.grey[400],
                  size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  selectedLocation != null
                      ? '선택한 위치: ${selectedLocation!.latitude.toStringAsFixed(5)}, ${selectedLocation!.longitude.toStringAsFixed(5)}'
                      : '위치를 선택해주세요',
                  style: TextStyle(
                    fontSize: 14,
                    color: selectedLocation != null
                        ? Colors.black87
                        : Colors.grey[600],
                  ),
                ),
              ),
              Icon(
                Icons.edit,
                color:
                    selectedLocation != null ? Colors.blue : Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
