package blog.gerberding.sandra.rating.talk;

import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class TalkService {
  private final TalkRepository talkRepository;

  public TalkService (TalkRepository talkRepository) {
    this.talkRepository = talkRepository;
  }

  public Talk rate (final long id, final int stars) {
    final Optional<Talk> optionalTalk = talkRepository.findById (id);
    if (optionalTalk.isPresent ()) {
      final Talk talk = optionalTalk.get ();
      final RatingStars ratingStars = RatingStars.findByValue (stars);
      final Rating rating = new Rating (ratingStars);
      talk.addRating (rating);
      return talkRepository.save (talk);
    }
    return null;
  }
}
