class Account {
  String id;
  String name;
  String imagePath;

  Account({
    this.id = '',
    this.name = '',
    this.imagePath = '',
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'imagePath': imagePath,
      };
}
