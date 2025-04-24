import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'location_map_modal.dart';

class LocationPickerButton extends StatefulWidget {
  final Function(NLatLng) onLocationSelected;
  final NLatLng? selectedLocation;

  const LocationPickerButton({
    super.key,
    required this.onLocationSelected,
    this.selectedLocation,
  });

  @override
  State<LocationPickerButton> createState() => _LocationPickerButtonState();
}

class _LocationPickerButtonState extends State<LocationPickerButton> {
  Future<void> _showLocationPickerModal() async {
    final NLatLng? result = await showModalBottomSheet<NLatLng>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationMapModal(
        initialLocation: widget.selectedLocation,
      ),
    );

    if (result != null) {
      widget.onLocationSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: _showLocationPickerModal,
          splashColor: Colors.blue.withAlpha(76),
          highlightColor: Colors.blue.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: widget.selectedLocation != null
                  ? Colors.blue.withAlpha(30)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.selectedLocation != null
                    ? Colors.blue.withAlpha(100)
                    : Colors.grey[300]!,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  size: 32,
                  color: widget.selectedLocation != null
                      ? Colors.blue
                      : Colors.grey[600],
                ),
                SizedBox(height: 8),
                Text(
                  widget.selectedLocation != null ? '위치 변경' : '위치 추가',
                  style: TextStyle(
                    color: widget.selectedLocation != null
                        ? Colors.blue
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.selectedLocation != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              '위치: ${widget.selectedLocation!.latitude.toStringAsFixed(4)}, ${widget.selectedLocation!.longitude.toStringAsFixed(4)}',
              style: TextStyle(fontSize: 10, color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
