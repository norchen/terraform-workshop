Vue.component('rating-talks', {
  data() {
    return {talks: []};
  },
  created() {
    axios.get("/talks").then(response => {
      if (response.data) {
        this.talks = response.data;
      }
    });
  },
  template: `  
        <div id="rating-grid-body">  
          <div v-for="talk in talks" :key="talk.id" class="row application-grey grid-border">
            <div class="col-md-4 themed-grid-col">{{talk.speaker}}</div>
            <div class="col-md-6 themed-grid-col">{{talk.title}}</div>
            <div class="col-md-2 themed-grid-col">
              <rating-stars :talkId="talk.id" :ratingStars="talk.ratingStars" ></rating-stars>
            </div>
          </div>
        </div>  
      `
});