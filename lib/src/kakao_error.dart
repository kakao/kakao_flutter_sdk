class KakaoError extends Error {}

class KakaoServerError extends Error {}

class KakaoAuthError extends KakaoServerError {}

class KakaoApiError extends KakaoServerError {}

class KakaoClientError extends KakaoError {}
