#!/bin/bash

echo "MIGRATING!!!"
rails db:migrate

echo "ASSETS!!!"
rails assets:precompile

echo "GO GO!!!"
rails server -b 0.0.0.0 -p 80