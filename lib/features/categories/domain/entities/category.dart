enum CategoryKind {
  income,
  expense;

  static CategoryKind fromString(String value) {
    switch (value.toLowerCase()) {
      case 'income':
        return CategoryKind.income;
      case 'expense':
      default:
        return CategoryKind.expense;
    }
  }
}

class Category {
  final int id;
  final String? key;
  final String? name;
  final CategoryKind kind;
  final String icon;
  final int color;
  final bool isDefault;
  final bool isActive;
  final int sortOrder;

  const Category({
    required this.id,
    this.key,
    this.name,
    required this.kind,
    required this.icon,
    required this.color,
    this.isDefault = false,
    this.isActive = true,
    this.sortOrder = 0,
  });

  Category copyWith({
    String? name,
    String? icon,
    int? color,
    bool? isActive,
    int? sortOrder,
  }) {
    return Category(
      id: id,
      key: key,
      name: name ?? this.name,
      kind: kind,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isDefault: isDefault,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  String displayName(String Function(String key) translator) {
    if (isDefault && key != null) {
      return translator(key!);
    }
    return name ?? key ?? '';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          key == other.key &&
          name == other.name &&
          kind == other.kind &&
          icon == other.icon &&
          color == other.color &&
          isDefault == other.isDefault &&
          isActive == other.isActive &&
          sortOrder == other.sortOrder;

  @override
  int get hashCode => Object.hash(
    id,
    key,
    name,
    kind,
    icon,
    color,
    isDefault,
    isActive,
    sortOrder,
  );
}
