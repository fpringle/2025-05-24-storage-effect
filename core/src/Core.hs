{-# LANGUAGE TemplateHaskell #-}

module Core where

import Control.Lens
import Data.Text (Text)
import GHC.Generics (Generic)

type UserId = Int

-- | This parameterisation allows us to define useful type synonyms.
data User' id name = User
  { _userId :: id
  , _userName :: name
  }
  deriving (Show, Generic)

-- | A full user in the model
type User = User' UserId Text

-- | A user without IDs etc, to be created
type UserCreate = User' () Text

type TransactionId = Int

data Transaction' id userId amount = Transaction
  { _transactionId :: id
  , _transactionUserId :: userId
  , _transactionAmount :: amount
  }
  deriving (Show, Generic)

type Transaction = Transaction' TransactionId UserId Double

type TransactionCreate = Transaction' () () Double

-- generate lenses for easy and awesome manipulation
makeLenses ''User'
makeLenses ''Transaction'
