#!/usr/bin/env stack
-- stack --resolver lts-11.7 script --nix --nix-packages openssh

{-# LANGUAGE OverloadedStrings #-}

-- | Run me with ./deploy.hs !!!
-- or `stack deploy <your name>`

import Prelude hiding (concat)
import Turtle hiding (append)
import Turtle.Options
import Data.Text (Text,append, concat)

parser = argPath "onid" "Your onid username"

server :: Text
server = "shell.onid.oregonstate.edu:~/public_html/"

folder :: Text
folder = "~youngjef/*"


main = do
  onid <- options "A simple wrapper around scp to deploy easily" parser
  shell ("scp " `append` concat ["-r ", folder, " ", format fp onid `append` "@" `append` server]) empty
