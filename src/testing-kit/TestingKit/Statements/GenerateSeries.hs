module TestingKit.Statements.GenerateSeries where

import Hasql.Decoders qualified as Decoders
import Hasql.Encoders qualified as Encoders
import Hasql.Pipeline qualified as Pipeline
import Hasql.Session qualified as Session
import Hasql.Statement qualified as Statement
import TestingKit.Preludes.Base

data Params = Params
  { start :: Int64,
    end :: Int64
  }

type Result = [Int64]

session :: Bool -> Params -> Session.Session Result
session prepared params =
  Session.statement params (statement prepared)

pipeline :: Bool -> Params -> Pipeline.Pipeline Result
pipeline prepared params =
  Pipeline.statement params (statement prepared)

statement :: Bool -> Statement.Statement Params Result
statement =
  Statement.Statement sql encoder decoder

sql :: ByteString
sql =
  "SELECT generate_series($1, $2)"

encoder :: Encoders.Params Params
encoder =
  mconcat
    [ start >$< Encoders.param (Encoders.nonNullable Encoders.int8),
      end >$< Encoders.param (Encoders.nonNullable Encoders.int8)
    ]

decoder :: Decoders.Result Result
decoder =
  Decoders.rowList
    (Decoders.column (Decoders.nonNullable Decoders.int8))
