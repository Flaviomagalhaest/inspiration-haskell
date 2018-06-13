{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Tema where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Handler.Funcs as F 

optionsTemaporidR :: TemaId -> Handler()
optionsTemaporidR tid = anyOriginIn [F.OPTIONS, F.GET]
-----------------------------------------------
optionsBuscaTemasR :: Handler()
optionsBuscaTemasR= anyOriginIn [F.OPTIONS, F.GET]
-----------------------------------------------
optionsCriaTemaR :: Handler()
optionsCriaTemaR = anyOriginIn [F.OPTIONS, F.POST]

getTemaporidR :: TemaId -> Handler Value
getTemaporidR tid = do
    anyOriginIn [ F.OPTIONS, F.GET ]
    _ <- runDB $ get404 tid
    tema <- runDB $ selectFirst [ TemaId ==. tid] []
    sendStatusJSON ok200 (object ["resp" .= tema])

getBuscaTemasR :: Handler Value
getBuscaTemasR = do
    anyOriginIn [ F.OPTIONS, F.GET ]
    tema <- runDB $ selectList ([] :: [Filter Tema]) [Asc TemaNome]
    sendStatusJSON ok200 (object ["resp" .= tema])

postCriaTemaR :: Handler Value
postCriaTemaR = do
    anyOriginIn [ F.OPTIONS, F.POST ]
    usu <- requireJsonBody :: Handler Tema
    uid <- runDB $ insert usu
    sendStatusJSON created201 (object ["resp" .= uid])