{-# LANGUAGE TemplateHaskell #-}

module Storage.Effect where

import Core
import Effectful
import Effectful.TH

data Storage :: Effect where
  ListUsers :: Storage m [User]
  CreateUser :: UserCreate -> Storage m User
  --
  ListTransactions :: Storage m [Transaction]
  DeleteTransaction :: TransactionId -> Storage m ()

makeEffect ''Storage
