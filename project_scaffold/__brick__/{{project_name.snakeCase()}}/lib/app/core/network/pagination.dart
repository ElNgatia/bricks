class PaginationMeta {
  final int currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  const PaginationMeta({
    required this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  bool get hasMore => lastPage == null || currentPage < lastPage!;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      total: json['total'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'last_page': lastPage,
    'per_page': perPage,
    'total': total,
  };
}

