// lib/core/vnpay_config.dart
class VNPayConfig {
  /// Mã website (Terminal code) do VNPAY cung cấp
  static const String tmnCode = 'YOUR_VNPAY_TMN_CODE';

  /// Mật khẩu băm (Hash secret) do VNPAY cung cấp
  static const String hashSecret = 'YOUR_VNPAY_HASH_SECRET';

  /// URL mà VNPAY redirect về sau khi thanh toán xong
  /// Ví dụ: https://mydomain.com/vnpay_return
  /// Nếu bạn xử lý ngay trong app (WebView), hãy để giống với URL mà VNPAY đã đăng ký
  static const String returnUrl = 'https://yourdomain.com/vnpay_return';
}
