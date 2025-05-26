module Backend.Server where

import Backend.API
import Data.Functor (($>))
import Effectful
import Servant.API hiding ((:>))
import Servant.Server
import Storage.Effect

userServer :: (Storage :> es) => ServerT UserAPI (Eff es)
userServer = listUsers :<|> createUser

transactionServer ::
  (Storage :> es) => ServerT TransactionAPI (Eff es)
transactionServer =
  listTransactions :<|> deleteTransaction'
  where
    deleteTransaction' tId = deleteTransaction tId $> NoContent

apiServer :: (Storage :> es) => ServerT API (Eff es)
apiServer = userServer :<|> transactionServer
