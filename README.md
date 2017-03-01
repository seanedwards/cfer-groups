# Cfer::Groups

This project needs a lot of doc work, but you can find the basic concept in the examples directory:

* `network_template.rb` defines a "resource group" which can be instantiated multiple times with different arguments. It's like a function, with some DSL sugar to establish a naming convention for related resources.
* `vpc.rb` uses the network template to create an actual network with three subnets.

Give it a try: `bundle exec cfer generate examples/vpc.rb`

