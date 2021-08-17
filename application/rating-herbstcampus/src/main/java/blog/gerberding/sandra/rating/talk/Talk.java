package blog.gerberding.sandra.rating.talk;

import org.springframework.data.annotation.Id;

import java.util.ArrayList;
import java.util.List;

public class Talk {

  @Id
  private final long id;

  private final String       title;
  private final String       speaker;
  private List<Rating> ratingList = new ArrayList<> ();

  public Talk (final long id, final String title, final String speaker) {
    this.id      = id;
    this.title   = title;
    this.speaker = speaker;
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

  public List<Rating> getRatingList () {
    return ratingList;
  }

  public void setRatingList (List<Rating> ratingList) {
    this.ratingList = ratingList;
  }

  public void addRating (final Rating rating) {
    ratingList.add (rating);
  }
}
