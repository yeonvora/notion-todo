![cover](./assets/images/cover.png)

# Noti

오늘 할 일을 노션 데이터베이스에 동기화해주는 서비스

<br/>
<br/>

**사용 방법**

1. Notion DB 생성
2. 제목 속성 이름을 Date로 변경
3. [Notion API Guide](https://developers.notion.com/docs/getting-started)에 따라 진행
4. [Notion Config](./lib/notion/notion_config.exam.dart) 수정
5. 취향대로 [제목, 배경화면](./lib/constants/brand.dart) 설정
6. [flutter 설치](https://docs.flutter.dev/get-started) 후 실행

<br/>

**기능 설명**

- [+]를 누르면 TASK 추가
- [+]를 길게 누르면 ROUTINE 추가
- 항목을 좌측으로 스와이프 하고 [아이콘]을 누르면 제거
- 우측 상단 [아이콘]을 누르면 노션 DB에 동기화
