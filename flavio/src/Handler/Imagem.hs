{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Imagem where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Handler.Funcs as F


-----------------------------------------------
optionsCadImagensR :: Handler ()
optionsCadImagensR = anyOriginIn [ F.OPTIONS, F.POST ]
-----------------------------------------------
optionsBuscaTodasImagensR :: Handler()
optionsBuscaTodasImagensR = anyOriginIn [F.OPTIONS, F.GET]
-----------------------------------------------
optionsBuscaImagensPorTemaR :: Handler()
optionsBuscaImagensPorTemaR = anyOriginIn[F.OPTIONS, F.POST]
-----------------------------------------------
optionsInsereImagemR :: Handler()
optionsInsereImagemR = anyOriginIn[F.OPTIONS, F.POST]
--------------------------------------------------
optionsRemoveImagemR :: ImagemId -> Handler()
optionsRemoveImagemR uid = anyOriginIn [F.OPTIONS, F.DELETE]

postCadImagensR :: Handler Value
postCadImagensR = do   
    anyOriginIn [ F.OPTIONS, F.POST ]
    usu <- requireJsonBody :: Handler Imagem
    uid <- runDB $ insert usu
    sendStatusJSON created201 (object ["resp" .= uid])

getBuscaImagensR :: Text -> Handler Value
getBuscaImagensR tema = do
    anyOriginIn [ F.OPTIONS, F.GET ]
    temas <- runDB $ selectList [ TemaNome ==. tema] []
    sendStatusJSON ok200 (object ["resp" .= temas])

getBuscaTodasImagensR :: Handler Value
getBuscaTodasImagensR = do
    anyOriginIn [ F.OPTIONS, F.GET ]
    imagem <- runDB $ selectList ([] :: [Filter Imagem]) []
    sendStatusJSON ok200 (object ["resp" .= imagem])

postBuscaImagensPorTemaR ::  Handler Value
postBuscaImagensPorTemaR  = do
    anyOriginIn [ F.OPTIONS, F.POST]
    (tema, 1) <- requireJsonBody :: Handler (TemaId, Int)
    imagem <- runDB $ selectList [ImagemTemaid ==. tema][]
    sendStatusJSON ok200 (object ["resp" .= imagem])

postInsereImagemR :: Handler Value
postInsereImagemR = do
    anyOriginIn [ F.OPTIONS, F.POST ]
    usu <- requireJsonBody :: Handler Imagem
    uid <- runDB $ insert usu
    sendStatusJSON created201 (object ["resp" .= uid])

deleteRemoveImagemR :: ImagemId -> Handler Value
deleteRemoveImagemR uid = do
    anyOriginIn [ F.OPTIONS, F.DELETE ]
    _ <- runDB $ get404 uid
    imagem <- runDB $ delete uid
    sendStatusJSON ok200 (object ["resp" .= imagem])