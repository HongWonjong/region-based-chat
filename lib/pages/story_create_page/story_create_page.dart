import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:region_based_chat/enum/story_type_enum.dart';

import '../../services/story_service.dart';
import '../../widgets/custom_alert_dialog.dart';
import 'widgets/category_selector.dart';
import 'widgets/input_fields.dart';
import 'widgets/location_info_panel.dart';
import 'widgets/location_map_modal.dart';
import 'widgets/select_image_button.dart';
import 'widgets/submit_button.dart';

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
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

      if (!userDoc.exists) {
        throw Exception("사용자 정보를 찾을 수 없습니다");
      }

      final String userName = userDoc.data()?['username'] ?? '';

      // 이미지 업로드
      List<String> imageUrls = [];
      if (_selectedImages.isNotEmpty) {
        imageUrls = await _uploadImages(_selectedImages);
      }

      await _storyService.createStory(
        title: _titleController.text,
        description: _contentController.text,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        userId: userName,
        type: _getStoryTypeFromIndex(_selectedCategoryIndex),
        uid: FirebaseAuth.instance.currentUser!.uid,
        imageUrls: imageUrls, // 업로드된 이미지 URL 전달
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

  // 이미지 업로드 메서드
  Future<List<String>> _uploadImages(List<XFile> images) async {
    List<String> urls = [];
    final FirebaseStorage storage = FirebaseStorage.instance;

    try {
      for (int i = 0; i < images.length; i++) {
        XFile image = images[i];
        final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final String fileName = 'story_image_${timestamp}_$i.jpg';

        // 스토리지 참조 생성
        final Reference storageRef = storage.ref().child('story_images/$fileName');

        // 이미지 파일 업로드
        final UploadTask uploadTask = storageRef.putFile(File(image.path));

        // 업로드 완료 대기 및 URL 가져오기
        final TaskSnapshot taskSnapshot = await uploadTask;
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        urls.add(downloadUrl);
      }
      return urls;
    } catch (e) {
      throw Exception('이미지 업로드 실패: $e');
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
      _selectedImages = []; // 이미지 목록도 초기화
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

  bool get _isFormValid => _isTitleValid && _isContentValid && _selectedLocation != null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  colors: isDark
                      ? [
                          Colors.grey[900]!,
                          Colors.grey[850]!,
                        ]
                      : [
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
                  backgroundColor: isDark ? Colors.grey[900] : Colors.deepPurple,
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
                              colors: isDark
                                  ? [
                                      Colors.black,
                                      Colors.grey[850]!,
                                    ]
                                  : [
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
                          color: _selectedLocation != null ? Colors.amber : Colors.white70,
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
                        _buildSectionTitle('위치 정보', Icons.place, isDark),
                        SizedBox(height: 16),

                        // 위치 정보 패널
                        LocationInfoPanel(
                          selectedLocation: _selectedLocation,
                          onEditPressed: _showLocationPickerModal,
                        ),
                        SizedBox(height: 24),

                        // 제목 섹션
                        _buildSectionTitle('소문 내용', Icons.edit_note, isDark),
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
                          isDark: isDark,
                        ),

                        SizedBox(height: 24),

                        // 카테고리 선택 섹션
                        _buildSectionTitle('카테고리 선택', Icons.category, isDark),
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
                          isDark: isDark,
                        ),
                        // 이미지 선택 버튼 추가
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                        SizedBox(height: 20),
                        // 소문내기 버튼
                        SubmitButton(
                          onPressed: _isFormValid && !_isLoading ? _saveStory : null,
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
                      color: isDark ? Colors.grey[800] : Colors.white,
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
                          valueColor: AlwaysStoppedAnimation<Color>(isDark ? Colors.amberAccent : Colors.deepPurple),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '소문 등록 중...',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.deepPurple,
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
  Widget _buildSectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          color: isDark ? Colors.amber : Colors.deepPurple,
          size: 26,
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.amber[200] : Colors.deepPurple.shade800,
          ),
        ),
      ],
    );
  }

  // 카드 위젯
  Widget _buildCard({required Widget child, bool isDark = false}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
