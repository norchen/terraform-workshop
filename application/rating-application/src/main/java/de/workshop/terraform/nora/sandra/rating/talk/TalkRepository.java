package de.workshop.terraform.nora.sandra.rating.talk;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TalkRepository extends CrudRepository<Talk, Long> {
  List<Talk> findAllByOrderByIdAsc ();
}
