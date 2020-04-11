module Main where

{-
I wrote this little program to convert from my proper GHC-compileable LHS files
to proper markdown files for viewing them online
-}
import Data.List
import Data.Char (toLower)
import Control.Monad
import System.Environment

main = do
    args <- getArgs
    when (length args < 2) $
        error "not enough arguments given;\nlhs_converter (toLhs|toMd) files"

    files <- mapM (readFile) $ tail args

    let (func, ex) = case (map toLower $ head args) of
                "tolhs" -> (convertToLhs, "lhs")
                "tomd"  -> (convertToMd, "md")
                _       -> (id, "id") 
        paths = tail args

    when (ex == "id") $
        error $ "command " ++ head args ++ " not recongised"

    converted <- return $ map (unlines . func . lines) files
    mapM_ (uncurry writeFile) $ zip (map (++ "." ++ ex) paths) converted
    putStrLn "Finished Conversions ;)"

convertToMd :: [String] -> [String]
convertToMd = convert' "" 
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

convertToLhs :: [String] -> [String]
convertToLhs s = convert' False False "" s 
  where
    convert' :: Bool -> Bool -> String -> [String] -> [String]
    convert' inCode inSample prev [] = []
    convert' inCode inSample prev (h:t)
        | inCode   && h /= "```"       = ["> " ++ h] ++ (convert' True False h t)
        | inSample && h /= "```"       = ["< " ++ h] ++ (convert' False True h t)
        | headingN h /= 0              = [headingO h ++ (tail $ dropWhile (=='#') h) ++ headingC h] ++ rest
        | h == "```haskell"            = (if prev == "" then [] else [""]) ++ convert' True False prev t
        | (inCode || inSample) && h == "```" = (if length t > 0 && (head t) == "" then [] else [""]) ++ convert' False False prev t
        | take 3 h == "```"            = (if prev == "" then [] else [""]) ++ convert' False True prev t
        | isFirstOO h ">"              = ["NOTE: " ++ drop 2 h] ++ rest
        | otherwise                    = h:rest
        where 
            headingO h = "<h" ++ show (headingN h) ++ ">"
            headingC h = "</h" ++ show (headingN h) ++ ">"
            headingN h = length $ takeWhile (=='#') h
            rest = convert' False False h t

isFirstOO :: String -> [Char] -> Bool
isFirstOO l e = or $ map (isFirst l) e

isFirst :: String -> Char -> Bool
isFirst []        _ = False
isFirst (h:' ':_) a = a == h
isFirst (h:_)     a = False

