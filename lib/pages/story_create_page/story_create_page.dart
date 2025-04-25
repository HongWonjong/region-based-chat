import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../services/story_service.dart';
import '../../widgets/custom_alert_dialog.dart';
import 'widgets/select_image_button.dart';
import 'widgets/input_fields.dart';
import 'widgets/submit_button.dart';
import 'widgets/category_selector.dart';
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
  bool _isLoading = false;
  final StoryService _storyService = StoryService();

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

  // 카테고리 인덱스를 StoryType으로 변환
  StoryType _getStoryTypeFromIndex(int index) {
    switch (index) {
      case 0:
        return StoryType.event; // 일반적인 행사
      case 1:
        return StoryType.minorIncident; // 가벼운 사건
      case 2:
        return StoryType.majorIncident; // 중요한 사건/범죄
      case 3:
        return StoryType.lostItem; // 분실
      default:
        return StoryType.minorIncident;
    }
  }

  // 스토리 저장
  Future<void> _saveStory() async {
    if (!_isFormValid || _selectedLocation == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final String storyId = await _storyService.createStory(
        title: _titleController.text,
        description: _contentController.text,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        userId: "user123", // 실제 사용자 ID로 대체 필요
        type: _getStoryTypeFromIndex(_selectedCategoryIndex),
        // imageUrls는 이미지 업로드 후 URL 배열로 대체 필요
      );

      // 성공 메시지 표시 (스낵바 대신 멋진 알림창 사용)
      await CustomAlertDialog.showSuccess(
        context: context,
        title: '소문 등록 완료',
        message: '소문이 성공적으로 등록되었습니다. 소중한 정보 공유에 감사드립니다! 😊',
        onConfirm: _resetForm,
      );
    } catch (e) {
      // 오류 메시지 표시 (스낵바 대신 멋진 알림창 사용)
      await CustomAlertDialog.showError(
        context: context,
        title: '소문 등록 실패',
        message: '소문 등록 중 오류가 발생했습니다: $e\n잠시 후 다시 시도해 주세요.',
        confirmText: '닫기',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 폼 초기화
  void _resetForm() {
    _titleController.clear();
    _contentController.clear();
    setState(() {
      _selectedLocation = null;
      _selectedCategoryIndex = 1;
      _isTitleValid = false;
      _isContentValid = false;
    });
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
          centerTitle: true,
          title: Text(
            '소문내기',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
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
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 사진 추가 버튼 (위치 버튼 제거)
                    SelectImageButton(),

                    // 위치 정보 패널 (항상 표시, 선택하지 않았을 때는 회색으로)
                    LocationInfoPanel(
                      selectedLocation: _selectedLocation,
                      onEditPressed: _showLocationPickerModal,
                    ),
                    SizedBox(height: 16),
                    // 입력 필드
                    InputFields(
                      titleController: _titleController,
                      contentController: _contentController,
                      onTitleChanged: (_) => _checkFormValidity(),
                      onContentChanged: (_) => _checkFormValidity(),
                    ),
                    SizedBox(height: 24),

                    CategorySelector(
                      selectedIndex: _selectedCategoryIndex,
                      onCategoryChanged: _selectCategory,
                      categories: CategoryOption.defaultCategories,
                    ),

                    // 제출 버튼
                    SizedBox(height: 32),
                    SubmitButton(
                      onPressed:
                          _isFormValid && !_isLoading ? _saveStory : null,
                      text: '소문내기',
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // 로딩 인디케이터
            if (_isLoading)
              Container(
                color: Colors.black.withAlpha(100),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
