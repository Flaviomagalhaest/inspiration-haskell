{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.TemaImagem where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Handler.Funcs as F


optionsBuscaTemasImagensR :: TemaImagemId -> Handler()
optionsBuscaTemasImagensR tid = anyOriginIn [F.OPTIONS, F.GET]
-----------------------------------------------
optionsBuscaTodosTemasImagensR :: Handler ()
optionsBuscaTodosTemasImagensR = anyOriginIn [F.OPTIONS, F.GET]
-----------------------------------------------
optionsInsereTemaImagemR :: Handler ()
optionsInsereTemaImagemR = anyOriginIn [F.OPTIONS, F.POST]
-----------------------------------------------
optionsRemoveTemaImagemR :: TemaImagemId -> Handler ()
optionsRemoveTemaImagemR tid = anyOriginIn [F.OPTIONS, F.DELETE]

getBuscaTemasImagensR :: TemaImagemId -> Handler Value
getBuscaTemasImagensR temaimagem = do
    anyOriginIn [ F.OPTIONS, F.GET ]
    temasimagens <- runDB $ selectList [ TemaImagemId ==. temaimagem] []
    sendStatusJSON ok200 (object ["resp" .= temasimagens])


getBuscaTodosTemasImagensR :: Handler Value
getBuscaTodosTemasImagensR = do
    anyOriginIn [ F.OPTIONS, F.GET ]
    temaimagem <- runDB $ selectList ([] :: [Filter TemaImagem]) []
    sendStatusJSON ok200 (object ["resp" .= temaimagem])

postInsereTemaImagemR :: Handler Value
postInsereTemaImagemR = do
    anyOriginIn [ F.OPTIONS, F.POST ]
    usu <- requireJsonBody :: Handler TemaImagem
    uid <- runDB $ insert usu
    sendStatusJSON created201 (object ["resp" .= uid])

deleteRemoveTemaImagemR :: TemaImagemId -> Handler Value
deleteRemoveTemaImagemR uid = do
    anyOriginIn [ F.OPTIONS, F.DELETE ]
    _ <- runDB $ get404 uid
    temaimagem <- runDB $ delete uid
    sendStatusJSON ok200 (object ["resp" .= temaimagem])