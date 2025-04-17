// lib/api/api_config.dart - ملف جديد للإعدادات

import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ApiConfig {
  // القيمة الافتراضية لعنوان الخادم
  static const String DEFAULT_API_HOST = '192.168.1.1'; // عنوان افتراضي
  static const int DEFAULT_API_PORT = 5000;
  static const String DEFAULT_API_PATH = '/api';
  
  // مفاتيح حفظ الإعدادات
  static const String KEY_API_HOST = 'api_host';
  static const String KEY_API_PORT = 'api_port';
  static const String KEY_API_PATH = 'api_path';
  
  // الحصول على عنوان IP للجهاز
  static Future<String?> getDeviceIpAddress() async {
    try {
      // استخدام مكتبة للحصول على معلومات الشبكة
      final info = NetworkInfo();
      String? wifiIP = await info.getWifiIP();
      
      if (wifiIP != null && wifiIP.isNotEmpty) {
        // تحويل آخر أوكتيت من عنوان IP إلى 1 للحصول على المحتمل العنوان الخاص بالخادم
        // مثال: إذا كان IP الجهاز 192.168.1.5 فسنحوله إلى 192.168.1.1
        final parts = wifiIP.split('.');
        if (parts.length == 4) {
          // المفترض أن نطاق الشبكة هو نفسه ونغير فقط آخر رقم ليكون أقرب للخادم
          String baseIP = '${parts[0]}.${parts[1]}.${parts[2]}';
          
          // اقتراح بعض العناوين المحتملة للخادم
          return baseIP + '.58'; // نستخدم نفس آخر رقم كما في الكود الأصلي
        }
      }
      
      return null;
    } catch (e) {
      print('خطأ في الحصول على عنوان IP: $e');
      return null;
    }
  }
  
  // حفظ إعدادات الخادم
  static Future<void> saveApiSettings({
    required String host,
    required int port,
    required String path,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(KEY_API_HOST, host);
      await prefs.setInt(KEY_API_PORT, port);
      await prefs.setString(KEY_API_PATH, path);
    } catch (e) {
      print('خطأ في حفظ إعدادات API: $e');
    }
  }
  
  // جلب إعدادات الخادم المحفوظة
  static Future<Map<String, dynamic>> getApiSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // محاولة الحصول على IP الجهاز أولاً
      String? deviceIp = await getDeviceIpAddress();
      
      // الحصول على الإعدادات المحفوظة مع القيم الافتراضية
      String host = prefs.getString(KEY_API_HOST) ?? 
                   deviceIp ?? 
                   DEFAULT_API_HOST;
                   
      int port = prefs.getInt(KEY_API_PORT) ?? DEFAULT_API_PORT;
      String path = prefs.getString(KEY_API_PATH) ?? DEFAULT_API_PATH;
      
      return {
        'host': host,
        'port': port,
        'path': path,
      };
    } catch (e) {
      print('خطأ في جلب إعدادات API: $e');
      
      // إرجاع القيم الافتراضية في حالة حدوث خطأ
      return {
        'host': DEFAULT_API_HOST,
        'port': DEFAULT_API_PORT,
        'path': DEFAULT_API_PATH,
      };
    }
  }
  
  // استرجاع العنوان الكامل للـ API
  static Future<String> getApiBaseUrl() async {
    final settings = await getApiSettings();
    return 'http://${settings['host']}:${settings['port']}${settings['path']}';
  }
}