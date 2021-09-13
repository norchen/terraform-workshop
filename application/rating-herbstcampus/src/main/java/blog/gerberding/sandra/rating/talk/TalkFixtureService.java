package blog.gerberding.sandra.rating.talk;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Service;

@Service
public class TalkFixtureService implements ApplicationRunner {

  private final TalkRepository talkRepository;

  public TalkFixtureService (final TalkRepository talkRepository) {
    this.talkRepository = talkRepository;
  }

  @Override
  public void run (ApplicationArguments args) {
    if (talkRepository.count () == 0) {
      talkRepository.save (new Talk (0, "Moderne Software-Architektur mit dem Architektur-Hamburger", "Henning Schwentner", RatingStars.ZERO));
      talkRepository.save (new Talk (0, "Secrets of Java", "Elisabeth Schulz", RatingStars.ZERO));
      talkRepository.save (new Talk (0, "Die Corona-Warn-App unter der Lupe", "Falk Sippach", RatingStars.ZERO));
      talkRepository.save (new Talk (0, "Was geht ab in meinem Cluster?", "Matthias Häußler", RatingStars.ZERO));
      talkRepository.save (new Talk (0, "Setzen wir erst mal einen Vertrag auf: Contract-First mit OpenAPI", "Birgit Kratz", RatingStars.ZERO));
      talkRepository.save (new Talk (0, "Continuous Operations mit GitOps – eine Einführung", "Johannes Schnatterer", RatingStars.ZERO));
      talkRepository.save (new Talk (0, "Mythos Teamautonomie: Warum sie eine Illusion ist und wir sie trotzdem brauchen", "Gerrit Beine", RatingStars.ZERO));
    }
  }
}
