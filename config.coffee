exports.config =
  # See http://brunch.readthedocs.org/en/latest/config.html for documentation.
  paths:
    public: "public"
    compass: "config/compass.rb"

  plugins:
    sass:
      options: ["--compass"]

  files:
    javascripts:
      joinTo:
        "js/app.js": /^app/
        "js/vendor.js": /^vendor/

      order:
        before: [

          "vendor/js/zepto.min.js"
          # "vendor/js/jquery-1.10.1.min.js"
          "vendor/js/iscroll5-probe.js"
          "vendor/js/lodash.underscore-1.1.1.min.js"
          "vendor/js/backbone-1.0.0.js"
        ]

    stylesheets:
      joinTo:
        # Only compile the application's stylesheet
        # leaving compilation to the import rules
        "css/app.css": /application\.sass/

    templates:
      defaultExtension: "jade"
      joinTo: "js/app.js"

  framework: "backbone"
