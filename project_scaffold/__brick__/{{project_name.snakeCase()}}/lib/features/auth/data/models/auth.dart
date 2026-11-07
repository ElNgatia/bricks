class Auth {
  final String token;
  final String tokenType;
  final String userId;
  final String name;
  final String email;
  final String defaultOrganisationCode;

  Auth({
    required this.token,
    required this.tokenType,
    required this.userId,
    required this.name,
    required this.email,
    required this.defaultOrganisationCode,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    final defaultOrg =
        user['default_organisation'] as Map<String, dynamic>? ?? {};

    return Auth(
      token: json['token']?.toString() ?? '',
      tokenType: json['token_type']?.toString() ?? 'Bearer',
      userId: user['id']?.toString() ?? json['user_id']?.toString() ?? '',
      name: user['name']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      defaultOrganisationCode: defaultOrg['code']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    'token_type': tokenType,
    'user': {
      'id': userId,
      'name': name,
      'email': email,
      'default_organisation': {
        'code': defaultOrganisationCode,
      },
    },
  };
}

