{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Logon where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Handler.Funcs as F

------------------------------------------------ST ]

optionsCadastroR :: Handler ()
optionsCadastroR = anyOriginIn [ F.OPTIONS, F.POST ]
------------------------------------------------
optionsCriaLoginR :: Handler()
optionsCriaLoginR = anyOriginIn [F.OPTIONS, F.POST]
----------------------------------------------------
optionsBuscaLogonR :: Handler()
optionsBuscaLogonR = anyOriginIn [F.OPTIONS,F.POST]


postCadastroR :: Handler Value
postCadastroR = do
    anyOriginIn [ F.OPTIONS, F.POST ]
    (email,senha) <- requireJsonBody :: Handler (Text,Text)
    maybeUsuario <- runDB $ getBy $ UsuarioLogon email senha
    case maybeUsuario of
        Just (Entity uid usuario) -> do
            sendStatusJSON ok200 (object ["resp" .= maybeUsuario ])
        _ ->  sendStatusJSON status404 (object ["resp" .= ("Usuário não cadastrado"::Text)])

postCriaLoginR :: Handler Value
postCriaLoginR = do
    anyOriginIn [ F.OPTIONS, F.POST ]
    usu <- requireJsonBody :: Handler Logon
    uid <- runDB $ insert usu
    sendStatusJSON created201 (object ["resp" .= uid])

postBuscaLogonR :: Handler Value
postBuscaLogonR = do
    anyOriginIn [ F.OPTIONS, F.POST ]
    (emailusuario, 1) <- requireJsonBody :: Handler (Text, Int)
    logon <- runDB $ selectFirst [LogonEmailusuario ==. emailusuario][]
    sendStatusJSON ok200 (object ["resp" .= logon])