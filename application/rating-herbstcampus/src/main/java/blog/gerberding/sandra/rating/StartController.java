package blog.gerberding.sandra.rating;

import blog.gerberding.sandra.rating.talk.Talk;
import blog.gerberding.sandra.rating.talk.TalkRepository;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller("/")
public class StartController {

  private final TalkRepository talkRepository;

  public StartController (TalkRepository talkRepository) {
    this.talkRepository = talkRepository;
  }

  @GetMapping("/")
  public String start () {
    final Iterable<Talk> talks = talkRepository.findAll ();
    talks.forEach (talk -> {
      System.out.println ("Eintrag: " + talk.getTitle ());
    });
    return "index";
  }
}
