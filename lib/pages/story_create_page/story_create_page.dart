import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/story_service.dart';
import '../../widgets/custom_alert_dialog.dart';
import 'widgets/input_fields.dart';
import 'widgets/submit_button.dart';
import 'widgets/category_selector.dart';
import 'widgets/location_map_modal.dart';
import 'widgets/location_info_panel.dart';
import 'widgets/select_image_button.dart';
import 'package:image_picker/image_picker.dart';

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

  List<XFile> _selectedImages = [];

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
      // 현재 사용자 가져오기
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("로그인이 필요합니다");
      }

      // Firestore에서 사용자 정보 가져오기 (닉네임 포함)
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception("사용자 정보를 찾을 수 없습니다");
      }

      final String userName = userDoc.data()?['username'] ?? '';

      final String storyId = await _storyService.createStory(
        title: _titleController.text,
        description: _contentController.text,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        userId: userName, // 이제 닉네임을 userId로 전달
        type: _getStoryTypeFromIndex(_selectedCategoryIndex),
        // imageUrls는 이미지 업로드 후 URL 배열로 대체 필요
      );

      // 성공 메시지 표시 (스낵바 대신 멋진 알림창 사용)
      await CustomAlertDialog.showSuccess(
        context: context,
        title: '소문 등록 완료',
        message: '소문이 성공적으로 등록되었습니다.\n 소중한 정보 공유에 감사드립니다! 😊',
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
    final NLatLng? result = await showDialog<NLatLng>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(0), // 여백 제거
        backgroundColor: Colors.transparent,
        child: LocationMapModal(
          initialLocation: _selectedLocation,
        ),
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
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // 배경 그라데이션
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.deepPurple.shade50,
                    Colors.white,
                  ],
                  stops: [0.0, 0.3],
                ),
              ),
            ),

            // 콘텐츠
            CustomScrollView(
              slivers: [
                // 앱바
                SliverAppBar(
                  expandedHeight: 120.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.deepPurple,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      '소문내기',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // 그라데이션 배경
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.deepPurple.shade800,
                                Colors.deepPurple.shade500,
                              ],
                            ),
                          ),
                        ),
                        // 장식 패턴
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        // 앱 아이콘 - 메가폰
                        Positioned(
                          right: 20,
                          bottom: 20,
                          child: Icon(
                            Icons.campaign,
                            size: 36,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    // 위치 선택 버튼
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.location_on,
                          color: _selectedLocation != null
                              ? Colors.amber
                              : Colors.white70,
                          size: 28,
                        ),
                        onPressed: _showLocationPickerModal,
                        tooltip: _selectedLocation != null ? '위치 변경' : '위치 추가',
                      ),
                    ),
                  ],
                ),

                // 메인 콘텐츠
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),

                        // 위치 정보 섹션
                        _buildSectionTitle('위치 정보', Icons.place),
                        SizedBox(height: 16),

                        // 위치 정보 패널
                        LocationInfoPanel(
                          selectedLocation: _selectedLocation,
                          onEditPressed: _showLocationPickerModal,
                        ),
                        SizedBox(height: 24),

                        // 제목 섹션
                        _buildSectionTitle('소문 내용', Icons.edit_note),
                        SizedBox(height: 16),

                        // 입력 필드를 카드로 감싸기
                        _buildCard(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: InputFields(
                              titleController: _titleController,
                              contentController: _contentController,
                              onTitleChanged: (_) => _checkFormValidity(),
                              onContentChanged: (_) => _checkFormValidity(),
                            ),
                          ),
                        ),

                        SizedBox(height: 24),

                        // 카테고리 선택 섹션
                        _buildSectionTitle('카테고리 선택', Icons.category),
                        SizedBox(height: 16),

                        _buildCard(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: CategorySelector(
                              selectedIndex: _selectedCategoryIndex,
                              onCategoryChanged: _selectCategory,
                              categories: CategoryOption.defaultCategories,
                            ),
                          ),
                        ),

                        SizedBox(height: 40),

                        // 이미지 선택 버튼 추가
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '사진 첨부',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple.shade800,
                                ),
                              ),
                              SizedBox(height: 12),
                              SelectImageButton(
                                onImagesSelected: (images) {
                                  setState(() {
                                    _selectedImages = images;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        // 소문내기 버튼
                        SubmitButton(
                          onPressed:
                              _isFormValid && !_isLoading ? _saveStory : null,
                          text: '소문내기',
                        ),

                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 로딩 인디케이터
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '소문 등록 중...',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 섹션 제목 위젯
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.deepPurple,
          size: 26,
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple.shade800,
          ),
        ),
      ],
    );
  }

  // 카드 위젯
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  void _publishStory() {
    // 스토리 발행 로직에 이미지 처리 추가
    if (_selectedImages.isNotEmpty) {
      // 이미지 처리 로직을 여기에 추가
      print('첨부된 이미지 개수: ${_selectedImages.length}');
      // 이미지 업로드 및 관련 처리를 위한 코드
    }

    // 기존 발행 로직
    // ... existing code ...
  }
}
