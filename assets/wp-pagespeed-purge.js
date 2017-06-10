jQuery(document).ready(function ($) {

  $('#wp-admin-bar-pagespeed_purge')
    .click(function (event) {
      event.preventDefault();

      var spinner = $(this).find('a');
      pagespeed_purge_animate(spinner);

      // Purge cache for the entire website
      // More info: https://modpagespeed.com/doc/system#purge_cache
      $.ajax({
          method: "PURGE",
          url: document.location.origin + '/*'
        })
        .done(function (msg) {
          if (msg && msg.indexOf("successful") > -1) {
            pagespeed_purge_success(spinner);
          } else {
            pagespeed_purge_error(spinner);
          }
        })
        .fail(function () {
          pagespeed_purge_error(spinner);
        })
        .always(function () {
          setTimeout(function () {
            pagespeed_purge_reset(spinner);
          }, 750);
        });

      return false;
    });

  function pagespeed_purge_animate(spinner) {
    pagespeed_purge_reset(spinner);
    spinner.addClass('spin');
  }

  function pagespeed_purge_error(spinner) {
    pagespeed_purge_reset(spinner);
    spinner.addClass('error');
  }

  function pagespeed_purge_success(spinner) {
    pagespeed_purge_reset(spinner);
    spinner.addClass('success');
  }

  function pagespeed_purge_reset(spinner) {
    spinner.removeClass('spin').removeClass('success').removeClass('error');
  }

});