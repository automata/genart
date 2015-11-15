# @cjsx React.DOM
'use strict'

React = require 'react/addons'

App = React.createClass
  getDefaultProps: ->
    className: 'app'

  render: ->
    {className} = @props

    <div className={className}>
      <h1>App</h1>
    </div>

module.exports = App
