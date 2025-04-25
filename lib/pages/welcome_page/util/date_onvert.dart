String dateConvert(String input) {
  DateTime now = DateTime.now(); // 현재시간
  final utcFromLocal = now.toUtc(); // UTC기준 현재시간
  DateTime dt = DateTime.parse(input); // 글 작성시간 datetime으로 변환
  final krTime = dt.toLocal();

  final diffMin = utcFromLocal.difference(dt).inMinutes;
  final diffHour = utcFromLocal.difference(dt).inHours;
  final diffDay = utcFromLocal.difference(dt).inDays;

  if (diffMin < 60) {
    return '$diffMin분전';
  } else if (diffMin > 59 && diffMin < 1440) {
    return '$diffHour시간전';
  } else if (diffMin > 1439 && diffMin < 10080) {
    return '$diffDay일전';
  } else if (diffMin > 10079 && (utcFromLocal.year == dt.year)) {
    return '${krTime.month}월 ${krTime.day}일';
  } else {
    return '${krTime.year}년 ${krTime.month}월 ${krTime.day}일';
  }
}
