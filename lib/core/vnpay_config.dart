// lib/core/vnpay_config.dart
class VNPayConfig {
  /// Mã website (Terminal code) do VNPAY cung cấp
  static const String tmnCode = 'YWCWLSW1';

  /// Mật khẩu băm (Hash secret) do VNPAY cung cấp
  static const String hashSecret = 'WY1S53OLZ60ZDJRT13TIBYBXPTK8EHX9';

  /// URL mà VNPAY redirect về sau khi thanh toán xong
  /// Ví dụ: https://mydomain.com/vnpay_return
  /// Nếu bạn xử lý ngay trong app (WebView), hãy để giống với URL mà VNPAY đã đăng ký
  static const String returnUrl = 'https://shad-obliging-ghost.ngrok-free.app';
}
