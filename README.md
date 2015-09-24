# puppet-squid-module

Download, compile and install squid from source

Uses initforthe/build_essential from forge.puppetlabs.com, testing using version 0.0.4 and jfqd/puppet-module-build on github 


=== Add to Puppetfile

mod 'initforthe/build_essential', '0.0.4'

# Dont need to add ref here since using master branch, even so, Im using it for a future guidance 
mod "puppet-module-build", :git => "https://github.com/jfqd/puppet-module-build.git", :ref=> "master" 

