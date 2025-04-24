import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'widgets/select_image_button.dart';
import 'widgets/input_fields.dart';
import 'widgets/submit_button.dart';
import 'widgets/category_button.dart';
import 'widgets/location_picker_button.dart';
import 'widgets/location_map_modal.dart';
import 'widgets/location_info_panel.dart';

class StoryCreatePage extends StatefulWidget {
  const StoryCreatePage({super.key});

  @override
  State<StoryCreatePage> createState() => _StoryCreatePageState();
}

class _StoryCreatePageState extends State<StoryCreatePage> {
  int _selectedCategoryIndex = 1; // 기본값: '가벼운사건'
  NLatLng? _selectedLocation;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // 유효성 상태를 추적
  bool _isTitleValid = false;
  bool _isContentValid = false;

  @override
  void initState() {
    super.initState();

    // 컨트롤러 리스너 등록
    _titleController.addListener(_checkFormValidity);
    _contentController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    setState(() {
      _isTitleValid = _titleController.text.trim().isNotEmpty;
      _isContentValid = _contentController.text.trim().isNotEmpty;
    });
  }

  void _selectCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
  }

  void _onLocationSelected(NLatLng location) {
    setState(() {
      _selectedLocation = location;
    });
    _checkFormValidity();
  }

  // 위치 선택 모달 표시
  Future<void> _showLocationPickerModal() async {
    final NLatLng? result = await showModalBottomSheet<NLatLng>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationMapModal(
        initialLocation: _selectedLocation,
      ),
    );

    if (result != null) {
      _onLocationSelected(result);
    }
  }

  bool get _isFormValid =>
      _isTitleValid && _isContentValid && _selectedLocation != null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('소문내기',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          actions: [
            // 위치 선택 버튼을 앱바 액션으로 이동
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: Icon(
                  Icons.location_on,
                  color: _selectedLocation != null
                      ? Colors.blue
                      : Colors.grey[600],
                  size: 28,
                ),
                onPressed: _showLocationPickerModal,
                tooltip: _selectedLocation != null ? '위치 변경' : '위치 추가',
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 사진 추가 버튼 (위치 버튼 제거)
                Container(child: SelectImageButton()),

                // 위치 정보 패널 (항상 표시, 선택하지 않았을 때는 회색으로)
                LocationInfoPanel(
                  selectedLocation: _selectedLocation,
                  onEditPressed: _showLocationPickerModal,
                ),

                // 입력 필드
                InputFields(
                  titleController: _titleController,
                  contentController: _contentController,
                  onTitleChanged: (_) => _checkFormValidity(),
                  onContentChanged: (_) => _checkFormValidity(),
                ),
                SizedBox(height: 16),

                // 카테고리 선택
                Row(
                  children: [
                    Expanded(
                      child: CategoryButton(
                        text: '일반적인 행사',
                        color: Colors.grey[300],
                        activeColor: Color(0xffEEFF06).withAlpha(76),
                        initiallySelected: _selectedCategoryIndex == 0,
                        onSelectionChanged: (_) => _selectCategory(0),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CategoryButton(
                        color: Colors.grey[300],
                        activeColor: Color(0xFF77FA7D).withAlpha(76),
                        text: '가벼운사건',
                        initiallySelected: _selectedCategoryIndex == 1,
                        onSelectionChanged: (_) => _selectCategory(1),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CategoryButton(
                        text: '중요한 사건/범죄',
                        color: Colors.grey[300],
                        activeColor: Color(0xffF20C0C).withAlpha(76),
                        initiallySelected: _selectedCategoryIndex == 2,
                        onSelectionChanged: (_) => _selectCategory(2),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CategoryButton(
                        text: '분실',
                        color: Colors.grey[300],
                        activeColor: Color(0xff0022FF).withAlpha(76),
                        initiallySelected: _selectedCategoryIndex == 3,
                        onSelectionChanged: (_) => _selectCategory(3),
                      ),
                    ),
                  ],
                ),

                // 제출 버튼
                SizedBox(height: 32),
                SubmitButton(
                  onPressed: _isFormValid
                      ? () {
                          // 위치 정보가 선택되었을 때만 제출 가능
                          print(
                              '소문 제출: 제목: ${_titleController.text}, 내용: ${_contentController.text}, 위치: (${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}), 카테고리: $_selectedCategoryIndex');
                          // 여기에 실제 제출 로직 추가
                        }
                      : null,
                  text: '소문내기',
                ),
                SizedBox(height: 40)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
