![tom_servo](http://vignette3.wikia.nocookie.net/mst3k/images/7/76/Servo8.jpg/revision/latest?cb=20070115040444)

## Tom Servo

Tom Servo is our deployment pipeline.  His job is top make our lives easy.  All deployment scripts, code, tools will be handled by him.  

Due to the way Codeship works, deployment and testing commands would need to be set in each repo....all 160+ of them.  This is not fun in any way, shape, or form, so Tom helps us out with that.  Each repo only has a single deployment task, this ensures we never have to modify the Codeship deployment pipeline if we change deployment methods, add/remove steps, etc.  


### Usage

1. ensure all tests pass (the deploy won't happen if this fails)
1. edit the CHNAGELOG.md following the conventions laid out in [Keep A Changelog](http://keepachangelog.com/)
1. bump the version in *../lib/plugin/version.rb*
1. commit ONLY those two items with a message of **deploy**

This will need to be done to master, not across a fork.

### Under The Hood

#### Deployment Pipeline

```
cd /tmp/tom_servo
rake deploy:deploy
```

#### Task Flow

1. Build a gem
2. Push gem to Rubygems
3. Create Github tag and Release


### Making Tom Work For You

Create a new rake task file and namespace if needed or add a new task to one of the current task files.  There is no need to modify the root `RakeFile` as long as you follow the current layout.

When adding tasks please keep in mind the [Unix Philosophy](http://www.faqs.org/docs/artu/ch01s06.html), of do one task and do it well.  Your code should be abstracted out as much as makes sense.  It should also be kept in mind that currently there are nearly 175 plugin repos that use these tasks.  Make sure you plan for scale, avoid hardcoding ANYTHING if possible and make sure all paths use Ruby methods to ensure portability.
