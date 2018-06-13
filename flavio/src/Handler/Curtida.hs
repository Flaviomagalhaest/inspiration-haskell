{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Curtida where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Handler.Funcs as F 

optionsInsereCurtidaR :: Handler()
optionsInsereCurtidaR = anyOriginIn [F.OPTIONS, F.GET]
-----------------------------------------------
optionsBuscaCurtidaPorImagemR :: Handler()
optionsBuscaCurtidaPorImagemR = anyOriginIn [F.OPTIONS, F.POST]
-----------------------------------------------
optionsRemoveCurtidaR :: CurtidaId -> Handler()
optionsRemoveCurtidaR uid = anyOriginIn [F.OPTIONS, F.DELETE]
--------------------------------------------------
optionsNumeroCurtidasR :: CurtidaId -> Handler()
optionsNumeroCurtidasR uid = anyOriginIn [F.OPTIONS, F.GET]
---------------------------------------------------
optionsCurteImagemR :: CurtidaId -> Handler()
optionsCurteImagemR uid = anyOriginIn [F.OPTIONS, F.PATCH]
---------------------------------------------------
optionsDescurteImagemR :: CurtidaId -> Handler()
optionsDescurteImagemR uid = anyOriginIn [F.OPTIONS, F.PATCH]

postInsereCurtidaR :: Handler Value
postInsereCurtidaR = do
    anyOriginIn [ F.OPTIONS, F.POST ]
    usu <- requireJsonBody :: Handler Curtida
    uid <- runDB $ insert usu
    sendStatusJSON created201 (object ["resp" .= uid])

postBuscaCurtidaPorImagemR :: Handler Value
postBuscaCurtidaPorImagemR = do
    anyOriginIn [ F.OPTIONS, F.POST]
    (imagem, 1) <- requireJsonBody :: Handler (ImagemId, Int)
    curtida <- runDB $ selectList [CurtidaImagemid ==. imagem][]
    sendStatusJSON ok200 (object ["resp" .= curtida])

deleteRemoveCurtidaR :: CurtidaId -> Handler Value
deleteRemoveCurtidaR uid = do
    anyOriginIn [ F.OPTIONS, F.DELETE ]
    _ <- runDB $ get404 uid
    curtida <- runDB $ delete uid
    sendStatusJSON ok200 (object ["resp" .= curtida])

getNumeroCurtidasR :: CurtidaId -> Handler Value
getNumeroCurtidasR uid = do
    anyOriginIn [ F.OPTIONS, F.GET ]
    _ <- runDB $ get404 uid
    curtida <- runDB $ selectFirst [ CurtidaId ==. uid] []
    sendStatusJSON ok200 (object ["resp" .= curtida])

patchCurteImagemR :: CurtidaId -> Handler Value
patchCurteImagemR uid = do
    anyOriginIn [ F.OPTIONS, F.PATCH ]
    (valor, 1) <- requireJsonBody :: Handler (Int, Int)
    _ <- runDB $ get404 uid
    video <- runDB $ update uid [CurtidaPositivas =. valor]
    sendStatusJSON ok200 (object ["resp" .= ("Sucesso"::Text)])

patchDescurteImagemR :: CurtidaId -> Handler Value
patchDescurteImagemR uid = do
    anyOriginIn [ F.OPTIONS, F.PATCH ]
    (valor,1 ) <- requireJsonBody :: Handler (Int, Int)
    _ <- runDB $ get404 uid
    video <- runDB $ update uid [CurtidaNegativas =. valor]
    sendStatusJSON ok200 (object ["resp" .= ("Sucesso"::Text)])