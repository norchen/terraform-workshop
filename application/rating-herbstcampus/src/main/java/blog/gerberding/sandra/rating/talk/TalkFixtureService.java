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
  public void run (ApplicationArguments args) throws Exception {
    if (talkRepository.count () == 0) {
      talkRepository.save (new Talk (0, "Reise durch die JDKs", "Sandra Gerberding"));
    }
  }
}
