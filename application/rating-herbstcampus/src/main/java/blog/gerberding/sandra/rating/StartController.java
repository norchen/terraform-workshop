package blog.gerberding.sandra.rating;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller("/")
public class StartController {

  @GetMapping("/")
  public String start (){
    return "index";
  }
}
