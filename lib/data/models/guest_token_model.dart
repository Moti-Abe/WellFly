class GuestTokenResponse {
  final String guestToken;

  GuestTokenResponse({required this.guestToken});

  factory GuestTokenResponse.fromJson(Map<String, dynamic> json) {
    return GuestTokenResponse(
      guestToken: json['guestToken'] ?? json['guest_token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guestToken': guestToken,
    };
  }
}
