package blog.gerberding.sandra.rating.talk;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TalkRepository extends CrudRepository<Talk, Long> {
}
