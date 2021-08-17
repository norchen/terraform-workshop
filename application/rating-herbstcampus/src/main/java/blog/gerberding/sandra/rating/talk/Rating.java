package blog.gerberding.sandra.rating.talk;

public class Rating {

  private final RatingStars ratingStars;

  public Rating (final RatingStars ratingStars) {
    this.ratingStars   = ratingStars;
  }

  public RatingStars getRatingStars () {
    return ratingStars;
  }
}
