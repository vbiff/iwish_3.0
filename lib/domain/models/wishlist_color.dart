enum WishlistColor {
  orange('orange'),
  blue('blue'),
  green('green'),
  purple('purple'),
  red('red'),
  yellow('yellow'),
  pink('pink'),
  teal('teal');

  const WishlistColor(this.value);
  final String value;

  static WishlistColor fromString(String value) {
    return WishlistColor.values.firstWhere(
      (color) => color.value == value,
      orElse: () => WishlistColor.orange,
    );
  }
}
