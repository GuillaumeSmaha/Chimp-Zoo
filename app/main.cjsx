init = require './init'
React = require 'react/addons'
Router = require 'react-router'
{Route, RouteHandler, DefaultRoute, Link} = require 'react-router'

Navigation = require './navigation'
Footer = require './footer'
Home = require './home'
Classify = require './classify'
About = require './about'

User = require 'zooniverse/models/user'
Profile = require './profile'

LanguageManager = require 'zooniverse/lib/language-manager'

Main = React.createClass
  displayName: 'Main'

  user: User.fetch()

  getInitialState: ->
    user: null
    language: null

  componentWillMount: ->
    User.on 'change', @onUserChange
    User.fetch()

  onUserChange: (e, user) ->
    @setState user: user

  render: ->
    <div className="main">
      <Navigation user={@state.user} hash={window.location.hash} />

      <RouteHandler user={@state.user} hash={window.location.hash} />
      <Footer />
    </div>

routes =
  <Route name="root" path="/" handler={Main}>
    <Route name="classify" path="classify" handler={Classify} />
    <Route name="about" path="about" handler={About} ignoreScrollBehavior>
      <Route name="team" path="team" handler={About} />
      <Route name="organizations" path="organizations" handler={About} />
    </Route>
    <Route name="profile" path="profile" handler={Profile} />

    <DefaultRoute handler={Home} />
  </Route>

Router.run routes, (Handler) ->
  React.render <Handler />, document.getElementById("app")

window.React = React
