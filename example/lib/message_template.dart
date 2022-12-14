import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';

final FeedTemplate defaultFeed = FeedTemplate(
  content: Content(
    title: '딸기 치즈 케익',
    description: '#케익 #딸기 #삼평동 #카페 #분위기 #소개팅',
    imageUrl: Uri.parse(
        'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
    link: Link(
        webUrl: Uri.parse('https://developers.kakao.com'),
        mobileWebUrl: Uri.parse('https://developers.kakao.com')),
  ),
  itemContent: ItemContent(
    profileText: 'Kakao',
    profileImageUrl: Uri.parse(
        'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
    titleImageUrl: Uri.parse(
        'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
    titleImageText: 'Cheese cake',
    titleImageCategory: 'cake',
    items: [
      ItemInfo(item: 'cake1', itemOp: '1000원'),
      ItemInfo(item: 'cake2', itemOp: '2000원'),
      ItemInfo(item: 'cake3', itemOp: '3000원'),
      ItemInfo(item: 'cake4', itemOp: '4000원'),
      ItemInfo(item: 'cake5', itemOp: '5000원')
    ],
    sum: 'total',
    sumOp: '15000원',
  ),
  social: Social(likeCount: 286, commentCount: 45, sharedCount: 845),
  buttons: [
    Button(
      title: '웹으로 보기',
      link: Link(
        webUrl: Uri.parse('https://developers.kakao.com'),
        mobileWebUrl: Uri.parse('https://developers.kakao.com'),
      ),
    ),
    Button(
      title: '앱으로보기',
      link: Link(
        androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
        iosExecutionParams: {'key1': 'value1', 'key2': 'value2'},
      ),
    ),
  ],
);

final ListTemplate defaultList = ListTemplate(
  headerTitle: 'WEEKLY MAGAZINE',
  headerLink: Link(
    webUrl: Uri.parse('https://developers.kakao.com'),
    mobileWebUrl: Uri.parse('https://developers.kakao.com'),
  ),
  contents: [
    Content(
      title: '취미의 특징, 탁구',
      description: '스포츠',
      imageUrl: Uri.parse(
          'https://mud-kage.kakao.com/dn/bDPMIb/btqgeoTRQvd/49BuF1gNo6UXkdbKecx600/kakaolink40_original.png'),
      link: Link(
        webUrl: Uri.parse('https://developers.kakao.com'),
        mobileWebUrl: Uri.parse('https://developers.kakao.com'),
      ),
    ),
    Content(
      title: '크림으로 이해하는 커피이야기',
      description: '음식',
      imageUrl: Uri.parse(
          'https://mud-kage.kakao.com/dn/QPeNt/btqgeSfSsCR/0QJIRuWTtkg4cYc57n8H80/kakaolink40_original.png'),
      link: Link(
        webUrl: Uri.parse('https://developers.kakao.com'),
        mobileWebUrl: Uri.parse('https://developers.kakao.com'),
      ),
    ),
    Content(
      title: '감성이 가득한 분위기',
      description: '사진',
      imageUrl: Uri.parse(
          'https://mud-kage.kakao.com/dn/c7MBX4/btqgeRgWhBy/ZMLnndJFAqyUAnqu4sQHS0/kakaolink40_original.png'),
      link: Link(
        webUrl: Uri.parse('https://developers.kakao.com'),
        mobileWebUrl: Uri.parse('https://developers.kakao.com'),
      ),
    ),
  ],
  buttons: [
    Button(
      title: '웹으로 보기',
      link: Link(
        webUrl: Uri.parse('https://developers.kakao.com'),
        mobileWebUrl: Uri.parse('https://developers.kakao.com'),
      ),
    ),
    Button(
      title: '앱으로 보기',
      link: Link(
        androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
        iosExecutionParams: {'key1': 'value1', 'key2': 'value2'},
      ),
    ),
  ],
);

final LocationTemplate defaultLocation = LocationTemplate(
  address: '경기 성남시 분당구 판교역로 235 에이치스퀘어 N동 8층',
  content: Content(
    title: '신메뉴 출시❤️ 체리블라썸라떼',
    description: '이번 주는 체리블라썸라떼 1+1',
    imageUrl: Uri.parse(
        'https://mud-kage.kakao.com/dn/bSbH9w/btqgegaEDfW/vD9KKV0hEintg6bZT4v4WK/kakaolink40_original.png'),
    link: Link(
      webUrl: Uri.parse('https://developers.kakao.com'),
      mobileWebUrl: Uri.parse('https://developers.kakao.com'),
    ),
  ),
  social: Social(likeCount: 286, commentCount: 45, sharedCount: 845),
);

final CommerceTemplate defaultCommerce = CommerceTemplate(
  content: Content(
    title: 'Ivory long dress (4 Color)',
    imageUrl: Uri.parse(
        'https://mud-kage.kakao.com/dn/RY8ZN/btqgOGzITp3/uCM1x2xu7GNfr7NS9QvEs0/kakaolink40_original.png'),
    link: Link(
      webUrl: Uri.parse('https://developers.kakao.com'),
      mobileWebUrl: Uri.parse('https://developers.kakao.com'),
    ),
  ),
  commerce: Commerce(
    regularPrice: 208800,
    discountPrice: 146160,
    discountRate: 30,
    productName: "Ivory long dress",
    currencyUnit: "₩",
    currencyUnitPosition: 1,
  ),
  buttons: [
    Button(
      title: '구매하기',
      link: Link(
        webUrl: Uri.parse('https://developers.kakao.com'),
        mobileWebUrl: Uri.parse('https://developers.kakao.com'),
      ),
    ),
    Button(
      title: '공유하기',
      link: Link(
        androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
        iosExecutionParams: {'key1': 'value1', 'key2': 'value2'},
      ),
    )
  ],
);

final TextTemplate defaultText = TextTemplate(
  text:
      '카카오톡 공유는 카카오 플랫폼 서비스의 대표 기능으로써 사용자의 모바일 기기에 설치된 카카오 플랫폼과 연동하여 다양한 기능을 실행할 수 있습니다.\n현재 이용할 수 있는 카카오톡 공유는 다음과 같습니다.\n카카오톡링크\n카카오톡을 실행하여 사용자가 선택한 채팅방으로 메시지를 전송합니다.\n카카오스토리링크\n카카오스토리 글쓰기 화면으로 연결합니다.',
  link: Link(
    webUrl: Uri.parse('https://developers.kakao.com'),
    mobileWebUrl: Uri.parse('https://developers.kakao.com'),
  ),
);

final CalendarTemplate defaultCalendar = CalendarTemplate(
  idType: IdType.event,
  id: '63996425afcec577cce94f0b',
  content: Content(
    title: '1월 신작 평론 모임',
    description: '따끈한 신작 감상평을 나누는 월간 모임에 초대합니다.',
    imageUrl: Uri.parse(
        'http://k.kakaocdn.net/dn/dFUqwp/bl3SUTqb2VV/VFSqyPpKUzZVVMcmotN9A0/kakaolink40_original.png'),
    link: Link(
      webUrl: Uri.parse('https://developers.kakao.com'),
      mobileWebUrl: Uri.parse('https://developers.kakao.com'),
    ),
  ),
  buttons: [
    Button(
      title: '모임 주제 보기',
      link: Link(
        webUrl: Uri.parse('https://developers.kakao.com'),
        mobileWebUrl: Uri.parse('https://developers.kakao.com'),
      ),
    )
  ],
);
