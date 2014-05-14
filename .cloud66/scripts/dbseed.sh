#!/bin/bash
# access your Rails stack path
cd $STACK_PATH
# run your seed task
bundle exec rake db:seed
