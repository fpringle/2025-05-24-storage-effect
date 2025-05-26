{-# OPTIONS_GHC -Wno-orphans #-}

module Storage.Postgres where

import Control.Lens
import Control.Monad (void)
import Core
import Database.PostgreSQL.Simple
import Effectful
import Effectful.Dispatch.Dynamic
import Effectful.State.Static.Local
import Storage.Effect

-- first we need some instances

instance FromRow User

instance ToRow User

instance FromRow Transaction

instance ToRow Transaction

-- again, we use 'State' for generating IDs
runStoragePostgres ::
  (State Int :> es, IOE :> es) =>
  Connection ->
  Eff (Storage : es) a ->
  Eff es a
runStoragePostgres conn = interpret $ \_ -> \case
  ListUsers -> liftIO $ query_ conn "SELECT * FROM app_users"
  CreateUser userCreate -> do
    uId <- get
    modify (+ 1)
    let newUser = userCreate & userId .~ uId
    liftIO $
      execute conn "INSERT INTO app_users values (?)" newUser
    pure newUser
  ListTransactions ->
    liftIO $ query_ conn "SELECT * FROM transactions"
  DeleteTransaction tId ->
    void . liftIO $
      execute conn "DELETE FROM transactions where id = ?" (Only tId)
