package blog.gerberding.sandra.rating.talk;

public enum RatingStars {
  ZERO, ONE, TWO, THREE, FOUR, FIVE;

  static RatingStars findByValue (final int value) {
    return values () [value];
  }
}