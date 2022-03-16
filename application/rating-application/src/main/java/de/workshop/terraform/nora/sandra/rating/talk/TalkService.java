package de.workshop.terraform.nora.sandra.rating.talk;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class TalkService {
  private final TalkRepository talkRepository;
  private static final Logger log = LoggerFactory.getLogger (TalkService.class);

  public TalkService (TalkRepository talkRepository) {
    this.talkRepository = talkRepository;
  }

  public Talk rate (final long talkId, final int stars) {
    final Optional<Talk> optionalTalk = talkRepository.findById (talkId);
    if (optionalTalk.isPresent ()) {
      final Talk talk = optionalTalk.get ();
      final RatingStars ratingStars = RatingStars.findByValue (stars);
      log.debug ("Rating talk {} with {} stars.", talk.getTitle (), stars);
      return talkRepository.save (talk.withRating (ratingStars));
    }
    log.debug ("Could not find talk with talkId {}.", talkId);
    return null;
  }

  public Iterable<Talk> getTalks () {
    return talkRepository.findAllByOrderByIdAsc ();
  }
}
