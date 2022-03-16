Vue.component('rating-stars', {
  props: ['talkId', 'ratingStars'],
  methods: {
    sendRating(starValue) {
      axios.post("/sendRating", {}, {params: {talkId: this.talkId, stars: starValue}});
    }
  },
  template: `
      <star-rating
             @rating-selected="sendRating"
             :rating="ratingStars"
             :show-rating="false"
             inactive-color="#ddd"
             active-color="#FFD700"
             v-bind:star-size="20">
      </star-rating>
      `
});