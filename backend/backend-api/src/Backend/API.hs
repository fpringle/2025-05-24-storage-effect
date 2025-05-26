module Backend.API where

import Core
import Servant.API

type UserAPI =
  -- list all the users
  "list" :> Get '[JSON] [User]
    -- create a new user
    :<|> "create" :> ReqBody '[JSON] UserCreate :> Post '[JSON] User

type TransactionAPI =
  -- list all user transactions
  "list" :> Get '[JSON] [Transaction]
    -- delete a transaction
    :<|> "delete" :> Capture "id" TransactionId :> DeleteNoContent

-- | The full API.
type API =
  "user" :> UserAPI
    :<|> "transaction" :> TransactionAPI
