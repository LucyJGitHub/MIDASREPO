     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Populate UTSRCFPD for CRTALLOBJ')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  UT000300 - Populate UTSRCCPD for CRTALLOBJ                   *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CUT011  *CREATE    Date 09Nov07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUT011 - Rewrite of command.  Make it more flexible and      *
      *           easier to maintain.                                 *
      *                                                               *
      *****************************************************************
      *
      * File containing types of source file
     FUTSRCTPD  IF   E           K DISK
      *
      * File containg list of source files to be compiled.
     FUTSRCCPD  UF A E             DISK
      *
      * Variables:
     D PSourceFile     S             10A
     D PGM             S              1
     D PGP             S              1
     D PGT             S              1
     D PGV             S              1
     D PGDEV           S              1
     D PGCMD           S              1
     D PGOAM           S              1
     D PGSVP           S              1
     D PGPGM           S              1
     D PDM             S              1
     D PDP             S              1
     D PDT             S              1
     D PDV             S              1
     D PDZ             S              1
     D PZDEV           S              1
     D PZCMD           S              1
     D PZOAM           S              1
     D PZSVP           S              1
     D PZPGM           S              1
     D PGLobDBTgtLib   S             10
     D PGLobNDTgtLib   S             10
     D PZoneDBTgtLib   S             10
     D PZoneNDTgtLib   S             10
     D PGLobDBOwner    S             10
     D PGLobNDOwner    S             10
     D PZoneDBOwner    S             10
     D PZoneNDOwner    S             10
     D PGLobDBPublic   S             10
     D PGLobNDPublic   S             10
     D PZoneDBPublic   S             10
     D PZoneNDPublic   S             10
     D PReturn         S              1
      *
     D KSourceType     S              8
      *
     D Write           S              1    INZ('N')
     D Global          S              1    INZ('N')
     D Recursive       S              1    INZ('N')
      *
     D                 DS
     D SourceFile              1     10
     D SourceType              3     10
     D                 DS
     D TargetLib               1     10
     D Prefix                  1      2
     D Target                  3     10
      *
      * Start of MAIN processing
     C     *ENTRY        PLIST
     C                   PARM                    PSourceFile
     C                   PARM                    PGM
     C                   PARM                    PGP
     C                   PARM                    PGT
     C                   PARM                    PGV
     C                   PARM                    PGDEV
     C                   PARM                    PGCMD
     C                   PARM                    PGOAM
     C                   PARM                    PGSVP
     C                   PARM                    PGPGM
     C                   PARM                    PDM
     C                   PARM                    PDP
     C                   PARM                    PDT
     C                   PARM                    PDV
     C                   PARM                    PDZ
     C                   PARM                    PZDEV
     C                   PARM                    PZCMD
     C                   PARM                    PZOAM
     C                   PARM                    PZSVP
     C                   PARM                    PZPGM
     C                   PARM                    PGlobDBTgtLib
     C                   PARM                    PGlobNDTgtLib
     C                   PARM                    PZoneDBTgtLib
     C                   PARM                    PZoneNDTgtLib
     C                   PARM                    PGLobDBOwner
     C                   PARM                    PGLobNDOwner
     C                   PARM                    PZoneDBOwner
     C                   PARM                    PZoneNDOwner
     C                   PARM                    PGLobDBPublic
     C                   PARM                    PGLobNDPublic
     C                   PARM                    PZoneDBPublic
     C                   PARM                    PZoneNDPublic
     C                   PARM                    PReturn
      *
     C                   EVAL      SourceFile = PSourceFile
     C                   EVAL      KSourceType = SourceType
      *
     C                   IF        %SUBST(SourceFile:9:1) = 'G'
     C                   EVAL      Global = 'Y'
     C                   ENDIF
      *
      * CHAIN to list of source file types.  If not found return an error
      *  else write to lsit of source files to be compiled.
     C     KSourceType   CHAIN     UTSRCTD0
     C                   IF        NOT(%FOUND)
     C                   EVAL      PReturn = 'Y'
     C                   ELSE
      *
     C                   SELECT
      *
     C                   WHEN      STSRCT = '*GM'
     C                   IF        PGM = 'Y'
     C                   IF        %SUBST(PGlobDBTgtLib:1:4) = '*PFX'
     C                   EVAL      Prefix = %SUBST(PGlobDBTgtLib:5:2)
     C                   EVAL      Target = 'GMLIB'
     C                   EVAL      SCTGTL = TargetLib
     C                   ELSE
     C                   EVAL      SCTGTL = PGlobDBTgtLib
     C                   ENDIF
     C                   EVAL      SCOWN = PGlobDBOwner
     C                   EVAL      SCPUB = PGlobDBPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
      *
     C                   WHEN      STSRCT = '*GP'
     C                   IF        PGP = 'Y'
     C                   IF        %SUBST(PGlobDBTgtLib:1:4) = '*PFX'
     C                   EVAL      Prefix = %SUBST(PGlobDBTgtLib:5:2)
     C                   EVAL      Target = 'GPLIB'
     C                   EVAL      SCTGTL = TargetLib
     C                   ELSE
     C                   EVAL      SCTGTL = PGlobDBTgtLib
     C                   ENDIF
     C                   EVAL      SCOWN = PGlobDBOwner
     C                   EVAL      SCPUB = PGlobDBPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
      *
     C                   WHEN      STSRCT = '*GTA'
     C                   IF        PGT = 'Y'
     C                   IF        %SUBST(PGlobDBTgtLib:1:4) = '*PFX'
     C                   EVAL      Prefix = %SUBST(PGlobDBTgtLib:5:2)
     C                   EVAL      Target = 'GTALIB'
     C                   EVAL      SCTGTL = TargetLib
     C                   ELSE
     C                   EVAL      SCTGTL = PGlobDBTgtLib
     C                   ENDIF
     C                   EVAL      SCOWN = PGlobDBOwner
     C                   EVAL      SCPUB = PGlobDBPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
      *
     C                   WHEN      STSRCT = '*GV'
     C                   IF        PGV = 'Y'
     C                   IF        %SUBST(PGlobDBTgtLib:1:4) = '*PFX'
     C                   EVAL      Prefix = %SUBST(PGlobDBTgtLib:5:2)
     C                   EVAL      Target = 'GVLIB'
     C                   EVAL      SCTGTL = TargetLib
     C                   ELSE
     C                   EVAL      SCTGTL = PGlobDBTgtLib
     C                   ENDIF
     C                   EVAL      SCOWN = PGlobDBOwner
     C                   EVAL      SCPUB = PGlobDBPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
      *
     C                   WHEN      STSRCT = '*DM'
     C                   IF        PDM = 'Y'
     C                   IF        %SUBST(PZoneDBTgtLib:1:4) = '*PFX'
     C                   EVAL      Prefix = %SUBST(PZoneDBTgtLib:5:2)
     C                   EVAL      Target = 'DMLIB'
     C                   EVAL      SCTGTL = TargetLib
     C                   ELSE
     C                   EVAL      SCTGTL = PZoneDBTgtLib
     C                   ENDIF
     C                   EVAL      SCOWN = PZoneDBOwner
     C                   EVAL      SCPUB = PZoneDBPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
      *
     C                   WHEN      STSRCT = '*DP'
     C                   IF        PDP = 'Y'
     C                   IF        %SUBST(PZoneDBTgtLib:1:4) = '*PFX'
     C                   EVAL      Prefix = %SUBST(PZoneDBTgtLib:5:2)
     C                   EVAL      Target = 'DPLIB'
     C                   EVAL      SCTGTL = TargetLib
     C                   ELSE
     C                   EVAL      SCTGTL = PZoneDBTgtLib
     C                   ENDIF
     C                   EVAL      SCOWN = PZoneDBOwner
     C                   EVAL      SCPUB = PZoneDBPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
      *
     C                   WHEN      STSRCT = '*DTA'
     C                   IF        PDT = 'Y'
     C                   IF        %SUBST(PZoneDBTgtLib:1:4) = '*PFX'
     C                   EVAL      Prefix = %SUBST(PZoneDBTgtLib:5:2)
     C                   EVAL      Target = 'DTALIB'
     C                   EVAL      SCTGTL = TargetLib
     C                   ELSE
     C                   EVAL      SCTGTL = PZoneDBTgtLib
     C                   ENDIF
     C                   EVAL      SCOWN = PZoneDBOwner
     C                   EVAL      SCPUB = PZoneDBPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
      *
     C                   WHEN      STSRCT = '*DV'
     C                   IF        PDV = 'Y'
     C                   IF        %SUBST(PZoneDBTgtLib:1:4) = '*PFX'
     C                   EVAL      Prefix = %SUBST(PZoneDBTgtLib:5:2)
     C                   EVAL      Target = 'DVLIB'
     C                   EVAL      SCTGTL = TargetLib
     C                   ELSE
     C                   EVAL      SCTGTL = PZoneDBTgtLib
     C                   ENDIF
     C                   EVAL      SCOWN = PZoneDBOwner
     C                   EVAL      SCPUB = PZoneDBPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
      *
     C                   WHEN      STSRCT = '*DZ'
     C                   IF        PDZ = 'Y'
     C                   IF        %SUBST(PZoneDBTgtLib:1:4) = '*PFX'
     C                   EVAL      Prefix = %SUBST(PZoneDBTgtLib:5:2)
     C                   EVAL      Target = 'DZLIB'
     C                   EVAL      SCTGTL = TargetLib
     C                   ELSE
     C                   EVAL      SCTGTL = PZoneDBTgtLib
     C                   ENDIF
     C                   EVAL      SCOWN = PZoneDBOwner
     C                   EVAL      SCPUB = PZoneDBPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
      *
     C                   WHEN      STSRCT = '*DEV'
     C                   IF        Global = 'Y'
     C                   IF        PGDEV = 'Y'
     C                   EVAL      SCTGTL = PGlobNDTgtLib
     C                   EVAL      SCOWN = PGlobNDOwner
     C                   EVAL      SCPUB = PGlobNDPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   IF        PZDEV = 'Y'
     C                   EVAL      SCTGTL = PZoneNDTgtLib
     C                   EVAL      SCOWN = PZoneNDOwner
     C                   EVAL      SCPUB = PZoneNDPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   WHEN      STSRCT = '*CMD'
     C                   IF        Global = 'Y'
     C                   IF        PGCMD = 'Y'
     C                   EVAL      SCTGTL = PGlobNDTgtLib
     C                   EVAL      SCOWN = PGlobNDOwner
     C                   EVAL      SCPUB = PGlobNDPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   IF        PZCMD = 'Y'
     C                   EVAL      SCTGTL = PZoneNDTgtLib
     C                   EVAL      SCOWN = PZoneNDOwner
     C                   EVAL      SCPUB = PZoneNDPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   WHEN      STSRCT = '*OPMMOD'
     C                   IF        Global = 'Y'
     C                   IF        PGOAM = 'Y'
     C                   EVAL      SCTGTL = PGlobNDTgtLib
     C                   EVAL      SCOWN = PGlobNDOwner
     C                   EVAL      SCPUB = PGlobNDPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   IF        PZOAM = 'Y'
     C                   EVAL      SCTGTL = PZoneNDTgtLib
     C                   EVAL      SCOWN = PZoneNDOwner
     C                   EVAL      SCPUB = PZoneNDPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   WHEN      STSRCT = '*SRVPGM'
     C                   IF        Global = 'Y'
     C                   IF        PGSVP = 'Y'
     C                   EVAL      SCTGTL = PGlobNDTgtLib
     C                   EVAL      SCOWN = PGlobNDOwner
     C                   EVAL      SCPUB = PGlobNDPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   IF        PZSVP = 'Y'
     C                   EVAL      SCTGTL = PZoneNDTgtLib
     C                   EVAL      SCOWN = PZoneNDOwner
     C                   EVAL      SCPUB = PZoneNDPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   WHEN      STSRCT = '*PGM'
     C                   IF        Global = 'Y'
     C                   IF        PGPGM = 'Y'
     C                   EVAL      SCTGTL = PGlobNDTgtLib
     C                   EVAL      SCOWN = PGlobNDOwner
     C                   EVAL      SCPUB = PGlobNDPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   IF        PZPGM = 'Y'
     C                   EVAL      SCTGTL = PZoneNDTgtLib
     C                   EVAL      SCOWN = PZoneNDOwner
     C                   EVAL      SCPUB = PZoneNDPublic
     C                   EVAL      Write = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   IF        Write = 'Y'
     C                   EVAL      SCSRCF = SourceFile
     C                   EVAL      SCPTY = STPTY
     C                   EVAL      SCSRCT = STSRCT
     C                   EVAL      SCOBJT = STOBJT
     C                   WRITE     UTSRCCD0
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive <> 'Y'
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      PReturn = 'E'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
