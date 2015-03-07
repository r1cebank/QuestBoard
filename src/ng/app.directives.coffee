angular.module 'Questboard.web.directives', []

# --------------------------------------------------------------------------- #
# Angular.js directive version of Kernite.Multistate                          #
# --------------------------------------------------------------------------- #
.directive 'qbMultistate', ->
  restrict: 'A'
  scope:
    config: '=qbMultistate'
  link: (scope, element, attr) ->
    config = scope.config
    # Add default state to the config (if not already present)
    if not config.default
      config.default = class: '',  callback: null
    # Construct unique class table
    scope.classes = _.chain(config).map((v) -> (v.class ? '').split(' ')).
      flatten().uniq().compact().value().join(' ')
    # Save current state
    scope.state = 'default'

    # Make element accessible from config object
    config.element = element

    # Attach state method to the config variable
    config.state = (name, force) ->
      # Do not change state if already in the state; unless forced
      if (not force) and (scope.state is name) then return
      # if state not found, go to default
      if not config[name] then name = 'default'
      # Save current state
      scope.state = name
      # transition
      element.removeClass(scope.classes).addClass(config[name].class)
      if (config[name].callback) then config[name].callback.call(config)