// lib/utils/error_handler.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

/// إعداد التعامل مع الأخطاء بشكل عام في التطبيق
void setupErrorHandling() {
  // التقاط أخطاء Flutter غير المعالجة
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('خطأ في Flutter: ${details.exception}');
    debugPrint('معلومات إضافية: ${details.stack}');
  };

  // تعيين معالج الأخطاء للأخطاء غير المتوقعة
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('خطأ غير متوقع: $error');
    debugPrint('تتبع الأخطاء: $stack');
    return true;
  };
}