exports.config =
  # See http://brunch.readthedocs.org/en/latest/config.html for documentation.
  paths:
    public: "public"
    compass: "config/compass.rb"

  files:
    javascripts:
      defaultExtension: "coffee"
      joinTo:
        "js/app.js": /^app/
        "js/vendor.js": /^vendor/
        "test/js/test.js": /^test(\/|\\)(?!vendor)/
        "test/js/test-vendor.js": /^test(\/|\\)(?=vendor)/
      order:
        before: [
          "vendor/js/auto-reload-brunch.js"
          "vendor/js/zepto.min.js"
          # "vendor/js/jquery-1.10.1.min.js"
          "vendor/js/iscroll5-probe.js"
          "vendor/js/lodash.underscore-1.1.1.min.js"
          "vendor/js/backbone-1.0.0.js"
        ]
        
    stylesheets:
      defaultExtension: "sass"
      joinTo: 
        # Only compile the application's stylesheet
        # leaving compilation to the import rules
        "css/app.css": /application\.sass/
        # "css/app.css": /^(app|vendor)/

    templates:
      defaultExtension: "jade"
      joinTo: "js/app.js"

  framework: "backbone"