class RecipesUpdater {
  updInterval = 5000;
  alertTime = this.updInterval/2;

  constructor(contSelector) {
    this.contSelector = contSelector;
  }

  startLoop() {
    if(this.intervalId) return;

    if(location.search.match(/page=[^1]|query=[^&]/)) {
      console.log('Loop did not start. We interested only in first page of recipes without query to show recent');
      return;
    }

    this.cont = $(this.contSelector);

    this.url = this.cont.data('recent-url');
    this.last_id = this.cont.data('last-id');

    this.intervalId = setInterval(this.requestData.bind(this), this.updInterval);
  }

  update(data) {
    if(!data.items || data.items.length <= 0) {
      this.showAlert('There are no new recipes. Add someone to see updates of the list');
      return;
    }

    var last_id;

    data.items.forEach((item) => {
      if(!last_id) last_id = item.id;

      $('#recipes').prepend(item.html);
    });

    this.last_id = last_id;

    this.showAlert();
  }

  showAlert(msg = 'We updated list. Check new recipes!') {
    $('#alerts').append('<div class="alert alert-primary recent-recipes">' + msg + '</div>');

    setTimeout(this.hideAlert, this.alertTime);
  }

  hideAlert() {
    $('#alerts .recent-recipes').hide();
  }

  error(data) {
    console.log('Failed to get data', data);
  }

  requestData() {
    if($(this.contSelector).length <= 0) {
      this.stopLoop();

      return;
    }

    var self = this;

    $.ajax({
      url: self.url,
      type: 'GET',
      data: { last_id: self.last_id },
      dataType: 'json',
      success: function(data) { self.update(data) },
      error: function(data) { self.error(data) },
    });
  }

  stopLoop() {
    if(this.intervalId) clearInterval(this.intervalId);

    this.intervalId = null;

    console.log('RecipesUpdater stopped');
  }
}

$(() => {
  var updater = new RecipesUpdater('#recent-recipes');

  updater.startLoop();

  document.addEventListener("turbolinks:load", function() {
    updater.startLoop();
  });

  document.addEventListener("turbolinks:click", function() {
    updater.stopLoop();
  });
});
