{-# LANGUAGE TemplateHaskell #-}

module Storage.Memory where

import Control.Lens
import Core
import qualified Data.Map as M
import Effectful
import Effectful.Dispatch.Dynamic
import Effectful.State.Static.Local
import Storage.Effect

-- first we define a datatype to hold our data in-memory

data Memory = Memory
  { _users :: M.Map UserId User
  , _transactions :: M.Map TransactionId Transaction
  , _nextId :: Int
  }
  deriving (Show)

makeLenses ''Memory

-- in real life, we'd want a cleaner way of generating IDs, but this
-- is good enough for demonstration purposes
runStorageMemory ::
  (State Memory :> es) => Eff (Storage : es) a -> Eff es a
runStorageMemory = interpret $ \_ -> \case
  ListUsers -> gets $ M.elems . _users
  CreateUser userCreate -> do
    uId <- state $ nextId <+~ 1
    let newUser = userCreate & userId .~ uId
    modify $ users . at uId ?~ newUser
    pure newUser
  ListTransactions -> gets $ M.elems . _transactions
  DeleteTransaction tId -> modify $ transactions . at tId .~ Nothing
