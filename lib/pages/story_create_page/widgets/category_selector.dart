import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onCategoryChanged;
  final List<CategoryOption> categories;

  const CategorySelector({
    super.key,
    required this.selectedIndex,
    required this.onCategoryChanged,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withAlpha(100)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _showCategoryOptions(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      _getCategoryIcon(categories[selectedIndex].color),
                      SizedBox(width: 8),
                      Text(
                        categories[selectedIndex].name,
                        style: TextStyle(fontSize: 15),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 카테고리별 아이콘 생성
  Widget _getCategoryIcon(Color color) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.withAlpha(100),
          width: 0.5,
        ),
      ),
    );
  }

  // 카테고리 선택 바텀시트 표시
  void _showCategoryOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 4, bottom: 16),
                child: Row(
                  children: [
                    Text(
                      '카테고리 선택',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              for (int i = 0; i < categories.length; i++)
                _buildCategoryOption(context, i),
            ],
          ),
        );
      },
    );
  }

  // 각 카테고리 옵션 항목 생성
  Widget _buildCategoryOption(BuildContext context, int index) {
    final isSelected = index == selectedIndex;

    return InkWell(
      onTap: () {
        onCategoryChanged(index);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            _getCategoryIcon(categories[index].color),
            SizedBox(width: 12),
            Text(
              categories[index].name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Spacer(),
            if (isSelected) Icon(Icons.check, color: Colors.green, size: 20),
          ],
        ),
      ),
    );
  }
}

class CategoryOption {
  final String name;
  final Color color;

  const CategoryOption({
    required this.name,
    required this.color,
  });

  static List<CategoryOption> defaultCategories = [
    CategoryOption(
      name: '일반적인 행사',
      color: Color(0xffEEFF06),
    ),
    CategoryOption(
      name: '가벼운사건',
      color: Color(0xFF77FA7D),
    ),
    CategoryOption(
      name: '중요한 사건/범죄',
      color: Color(0xffF20C0C),
    ),
    CategoryOption(
      name: '분실',
      color: Color(0xff0022FF),
    ),
  ];
}
