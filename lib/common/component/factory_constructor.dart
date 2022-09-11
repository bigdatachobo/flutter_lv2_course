void main() {
  final parent = Parent(id: 1);
  print(parent.id);
}

class Parent {
  final int id;
  Parent({
    required this.id,
  });
}
