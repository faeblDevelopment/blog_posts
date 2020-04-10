module Main where

{-
I wrote this little program to convert from my proper GHC-compileable LHS files
to proper markdown files for viewing them online
-}
import Data.List
import Control.Monad
import System.Environment

main = do
    args <- getArgs
    when (length args < 1) $
        error "no files given"

    files <- mapM (readFile) args

    converted <- return $ map (unlines . convert . lines) files
    mapM_ (uncurry writeFile) $ zip (map (++ ".md") args) converted
    putStrLn "Finished Conversions ;)"

convert :: [String] -> [String]
convert = convert' "" 
  where
    convert' :: String -> [String] -> [String]
    convert' prev []
        | isFirstOO prev "<>" = ["```"]
        | otherwise        = []
    convert' prev (h:t)
        | not (isFirstOO prev "<>") && 
               isFirstOO h    "<>"     = (if prev == "" then [] else [""]) ++ ["```haskell", drop 2 h] ++ rest
        | isFirstOO      h    "<>"     = (drop 2 h):rest 
        | isFirstOO      prev "<>"     = ["```"] ++ (if h == "" then [] else [""]) ++ [h] ++ rest
        | otherwise                    = h:rest
        where 
            rest = convert' h t

isFirstOO :: String -> [Char] -> Bool
isFirstOO l e = or $ map (isFirst l) e

isFirst :: String -> Char -> Bool
isFirst []        _ = False
isFirst (h:' ':_) a = a == h
isFirst (h:_)     a = False

