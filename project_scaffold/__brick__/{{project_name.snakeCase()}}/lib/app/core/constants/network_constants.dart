class NetworkConstants {
  static const baseUrl = '{{api_base_url}}';
  static const defaultTimeOut = Duration(seconds: 30);

  /// Where the organisation's custom terminology is fetched from.
  static String terminologyPath(String orgCode) => '/$orgCode/terminology';
}

