import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'widgets/select_image_button.dart';
import 'widgets/input_fields.dart';
import 'widgets/submit_button.dart';
import 'widgets/category_button.dart';
import 'widgets/location_picker_button.dart';

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
                    fontWeight: FontWeight.bold))),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 사진 추가 버튼
                    Expanded(
                      flex: 7,
                      child: SelectImageButton(),
                    ),

                    // 위치 추가 버튼
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: LocationPickerButton(
                          onLocationSelected: _onLocationSelected,
                          selectedLocation: _selectedLocation,
                        ),
                      ),
                    ),
                  ],
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
                  text: _isFormValid ? '소문내기' : '제목, 내용, 위치를 모두 입력해주세요',
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
