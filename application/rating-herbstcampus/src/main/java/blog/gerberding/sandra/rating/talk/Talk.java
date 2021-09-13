package blog.gerberding.sandra.rating.talk;

import org.springframework.data.annotation.Id;

public class Talk {

  @Id
  private final long id;

  private final String      title;
  private final String      speaker;
  private final RatingStars ratingStars;

  public Talk (final long id, final String title, final String speaker, final RatingStars ratingStars) {
    this.id          = id;
    this.title       = title;
    this.speaker     = speaker;
    this.ratingStars = ratingStars;
  }

  public long getId () {
    return id;
  }

  public String getTitle () {
    return title;
  }

  public String getSpeaker () {
    return speaker;
  }

  public RatingStars getRatingStars () {
    return ratingStars;
  }

  public Talk withRating (final RatingStars ratingStars) {
    return new Talk (id, title, speaker, ratingStars);
  }
}
