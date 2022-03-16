package de.workshop.terraform.nora.sandra.rating.talk;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
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
  public ResponseEntity<Talk> rate (@RequestParam final long talkId, @RequestParam final int stars) {
    final Talk talk = talkService.rate (talkId, stars);
    if (talk != null) {
      return ResponseEntity.ok (talk);
    } else {
      return ResponseEntity.status (HttpStatus.NOT_FOUND).build ();
    }
  }

  @GetMapping ("/talks")
  public ResponseEntity<Iterable<Talk>> getTalks () {
    return ResponseEntity.ok (talkService.getTalks ());
  }
}
