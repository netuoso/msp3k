(function() {
  var Locale;

  this.RailsAdmin || (this.RailsAdmin = {});

  this.RailsAdmin.I18n = Locale = (function() {
    function Locale() {}

    Locale.init = function(locale, translations) {
      this.locale = locale;
      this.translations = translations;
      return moment.locale(this.locale);
    };

    Locale.t = function(key) {
      var humanize;
      humanize = key.charAt(0).toUpperCase() + key.replace(/_/g, " ").slice(1);
      return this.translations[key] || humanize;
    };

    return Locale;

  })();

}).call(this);
