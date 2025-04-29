# 🚨 소문 이웃 지킴이 프로젝트

스파르타 코딩 클럽 1조의 혁신적인 팀 프로젝트! **소이지(소문 이웃 지킴이)** 는 위치 기반의 실시간 채팅 서비스로, 사용자들이 특정 장소(마커)에 연결된 채팅방에서 소통할 수 있는 플랫폼입니다. 사건 신고, 이벤트 공유, 커뮤니티 형성 등 다양한 용도로 활용 가능합니다. Firebase를 기반으로 빠르고 안정적인 데이터 관리와 실시간 채팅 기능을 제공합니다.

## 📱 스크린샷

<div style="display: flex; flex-wrap: nowrap; overflow-x: auto; gap: 10px; margin-bottom: 20px;">
  <img src="https://github.com/user-attachments/assets/1cf0b139-8020-413d-a554-dd9400028798" width="200"/>
  <img src="https://github.com/user-attachments/assets/e53f517a-1045-4b4e-a0c5-fc4d9cbf1ace" width="200" />
  <img src="https://github.com/user-attachments/assets/762af693-8d08-4558-b684-58c2fbe109b7" width="200" />
  <img src="https://github.com/user-attachments/assets/b03646cf-eb08-463e-a4f4-1f704f3676d1" width="200" />
  <img src="https://github.com/user-attachments/assets/a09d938f-65a2-4baf-898d-0db095526770" width="200" />
  <img src="https://github.com/user-attachments/assets/da09ca87-bcf3-4081-a850-ab2b47e19441" width="200" />
  <img src="https://github.com/user-attachments/assets/9d409a8c-93b0-421e-a915-cbe485482a11" width="200" />
  <img src="https://github.com/user-attachments/assets/7e41a564-6f72-4967-9356-82044de956c3" width="200" />
  <img src="https://github.com/user-attachments/assets/ad972b55-0b04-4bd1-88c7-b8925ff909ac" width="200" />
  <img src="https://github.com/user-attachments/assets/b302110f-dede-4622-a285-3780e571ac8a" width="200" />
  <img src="https://github.com/user-attachments/assets/aae2a213-703c-4209-b8bd-f44ff9fc2496" width="200" />
  <img src="https://github.com/user-attachments/assets/7c63a32b-a9aa-42f3-b348-eee87cdea760" width="200" />
  <img src="https://github.com/user-attachments/assets/76d2b45c-afc4-4403-ae83-ec7571cf361e" width="200" />
  <img src="https://github.com/user-attachments/assets/59e5fb96-1ab5-4d9c-8fb4-dfaca5f4dd56" width="200" />
  <img src="https://github.com/user-attachments/assets/880518ba-cdda-4717-8f90-424b07e49290" width="200" />
  <img src="https://github.com/user-attachments/assets/4085aef6-10c2-458a-b6ec-7387b8c294c1" width="200" />
</div>


## 🎯 프로젝트 소개

**소이지**는 사용자들이 지도 위의 특정 위치(마커)에 채팅방을 생성하고, 다른 사용자들과 실시간으로 소통할 수 있는 서비스입니다. 주요 기능은 다음과 같습니다:

- **위치 기반 마커 생성**: 사용자가 특정 위치에 사건(도난, 사고 등)이나 이벤트를 등록할 수 있습니다.
- **실시간 채팅**: 마커에 연결된 채팅방에서 텍스트와 이미지를 주고받으며 소통합니다.
- **프로필 관리**: 사용자 프로필 이미지와 정보를 저장하여 개인화된 경험을 제공합니다.
- **Firebase 통합**: Firestore와 Storage를 활용해 데이터와 미디어를 안전하게 관리합니다.

## 🛠️ 기술 스택

| 카테고리   | 기술                          |
| ---------- | ----------------------------- |
| 백엔드     | Firebase (Firestore, Storage) |
| 프론트엔드 | Flutter (Dart)                |
| 지도 API   | Kakao Maps                    |

## 📂 Firebase 데이터베이스 구조

아래는 프로젝트에서 사용되는 Firestore 데이터베이스의 구조입니다. 데이터는 사용자, 마커, 채팅, 메시지로 나뉘어 효율적으로 관리됩니다.

### 👤 Users

사용자 정보를 저장하는 컬렉션입니다.

```json
// Users/<user_uid>
{
  "uid": "user123",
  "email": "user@example.com",
  "username": "홍길동",
  "profileImageUrl": null, // 또는 Storage URL
  "createdAt": "2025-04-22T00:00:00Z",
  "lastLogin": "2025-04-22T10:00:00Z",
  "joinedMarkers": ["marker001", "marker002"] // 참여한 마커 ID 리스트
}
```

### 📍 Markers

지도에 표시되는 마커(위치) 정보를 저장합니다.

```json
// Markers/<marker_id>
{
  "id": "marker001", // 실제로는 uuid
  "type": "majorIncident", //majorIncident, minorIncident, event, lostItem
  "title": "도난 신고",
  "description": "자전거 도난 사건 발생",
  "latitude": 37.5665,
  "longitude": 126.978,
  "createdBy": "user123",
  "createdAt": "2025-04-22T00:00:00Z"
}
```

### 💬 Chats

마커에 연결된 채팅방 정보를 저장합니다.

```json
// Markers/<marker_id>/Chats/<chat_id> // 채팅방은 마커당 하나이므로 chatId를 알 필요는 없음
{
  "markerId": "marker001", // 실제로는 uuid
  "title": "도난 신고",
  "createdBy": "user123",
  "createdAt": "2025-04-22T00:00:00Z",
  "participants": ["user123", "user456"],
  "lastMessage": "도난 장소 확인했습니다.",
  "lastMessageTime": "2025-04-22T10:00:00Z",
  "lastMessageSender": "user456"
}
```

### ✉️ Messages

채팅방 내 개별 메시지를 저장합니다.

```json
// Markers/<marker_id>/Chats/<chat_id>/Messages/<message_id>
{
  "messageId": "msg001", // 실제로는 uuid
  "senderId": "user123",
  "senderName": "홍길동",
  "message": "도난 장소 확인했습니다.",
  "type": "text",
  "timestamp": "2025-04-22T10:00:00Z",
  "readBy": ["user123", "user456"]
}
```

```json
{
  // 채팅방에 이미지를 올리는 경우
  // Markers/<marker_id>/Chats/<chat_id>/Messages/<message_id>

  "messageId": "msg002", // 실제로는 uuid
  "senderId": "user456",
  "senderName": "김영희",
  "message": "https://storage.googleapis.com/<bucket>/chats/marker001/messages/msg002/image.jpg",
  "type": "image",
  "timestamp": "2025-04-22T10:01:00Z",
  "readBy": ["user456"]
}
```

## 🗄️ Firebase Storage 구조

프로필 이미지와 채팅 이미지는 Firebase Storage에 저장됩니다. 아래는 파일 경로 구조입니다:

```
프로필 이미지: users/profileImages/<user_uid>.jpg
채팅 이미지: chats/<marker_id>/messages/<message_id>/image.jpg
```

## 🚀 주요 기능

### 마커 생성 및 관리

- 사용자는 지도에서 특정 위치를 선택해 마커를 생성할 수 있습니다.
- 마커는 사건 유형(중대 사건, 경미한 사건, 이벤트 등)과 색상으로 구분됩니다.

### 실시간 채팅

- 마커에 연결된 채팅방에서 텍스트와 이미지를 주고받습니다.
- 타이핑 상태, 메시지 읽음 여부 등 실시간 상태를 표시합니다.

### 사용자 프로필

- 사용자 정보(이메일, 이름, 프로필 이미지)를 관리합니다.
- 프로필 이미지는 Firebase Storage에 저장됩니다.

### 지도 연동

- Kakao Maps API를 사용해 마커를 시각화합니다.
- 사용자는 지도에서 마커를 클릭해 채팅방에 입장할 수 있습니다.

## 📈 향후 계획

추후 작성

## 👥 팀원

스파르타 코딩 클럽 1조의 열정적인 팀원들이 함께 만들었습니다!

- 팀장: 홍원종
- 팀원1: 유일송
- 팀원2: 신성재
- 팀원3: 이인혁
- 팀원4: 안정희
