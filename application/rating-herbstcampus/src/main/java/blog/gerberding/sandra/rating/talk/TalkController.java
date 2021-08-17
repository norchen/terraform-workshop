package blog.gerberding.sandra.rating.talk;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TalkController {

  private final TalkService talkService;

  public TalkController (final TalkService talkService) {
    this.talkService = talkService;
  }

  @PostMapping ("/sendRating")
  public ResponseEntity<Talk> rate (@RequestParam final long id, @RequestParam final int stars) {
    final Talk talk = talkService.rate (id, stars);
    if (talk != null) {
      return ResponseEntity.ok (talk);
    } else {
      return ResponseEntity.status (HttpStatus.NOT_FOUND).build ();
    }
  }
}
