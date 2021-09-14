package blog.gerberding.sandra.rating.talk;

import com.fasterxml.jackson.annotation.JsonValue;

public enum RatingStars {
  ZERO, ONE, TWO, THREE, FOUR, FIVE;

  static RatingStars findByValue (final int value) {
    return values () [value];
  }

  @JsonValue
  public int toValue() {
    return ordinal();
  }
}