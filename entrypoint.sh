#!/bin/bash

mix deps.get
# mix deps.compile

mix phx.digest
iex -S mix phx.server