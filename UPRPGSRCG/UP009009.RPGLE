     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Update Action File details for new file')     *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP009009 - Update Action File details for new file           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CUP021  *CREATE    Date 15Feb11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP021 - Rewrite of Action File processing                   *
      *                                                               *
      *****************************************************************
      *
     FUPACTFL0  UF A E           K DISK
     FUPAFFLPD  UF A E             DISK
      *
     D PFile           S             10
     D PKeyFile        S             10
     D PLayer          S              7
      *
     D KFile           S             10
     D ReturnCode      S             10
     D NumberOfKey     S              2  0
     D KeyName         S             10    DIM(10)
     D Library         S             10
     D ErrorMsg        S             30
     D SourceLib       S             10
     D TargetLib       S             10
     D WINKC           S              1
     D WINKL           S              1
     D Recursive       S              1
      *
     D UPFLTD        E DS                  EXTNAME(UPAFFLPD)
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFile
     C                   PARM                    PKeyFile
     C                   PARM                    PLayer
      *
     C                   EVAL      KFile = PFile
      *
      * Update main Action File file.
     C     KFile         CHAIN     UPACTFL0
     C                   EVAL      AABONF = PFile
     C                   EVAL      AAAFLF = PKeyFile
     C                   EVAL      AALAYR = PLayer
     C                   IF        %FOUND
     C                   UPDATE    UPACTFD0
     C                   ELSE
     C                   WRITE     UPACTFD0
     C                   ENDIF
      *
      * Update temporary list of files.
     C                   EVAL      FLNAME = PFile
     C                   EVAL      FLREFF = PFile
     C                   EVAL      FLKYLF = PKeyFile
     C                   EVAL      FLOFFS = 0
     C                   WRITE     UPCFFLD0
      *
      * Call program to get key data.
     C                   CALL      'UTAOKEYD'
     C                   PARM                    ReturnCode
     C                   PARM                    NumberOfKey
     C                   PARM                    KeyName
     C                   PARM                    PKeyFile
     C                   PARM      '*LIBL'       Library
      *
      * Call program to get field information.
     C                   CALL      'UP009004'
     C                   PARM                    PFile
     C                   PARM                    KeyName
     C                   PARM                    Library
      *
      * Call program to display field information.
     C                   CALL      'UP009002'
     C                   PARM                    ReturnCode
     C                   PARM                    ErrorMsg
     C                   PARM                    UPFLTD
     C                   PARM      '*LIBL'       SourceLib
     C                   PARM      '*LIBL'       TargetLib
     C                   PARM                    WINKC
     C                   PARM                    WINKL
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
      ********************************************************************
     C     *PSSR         BEGSR
      *
     C     Recursive     IFEQ      *blanks
     C                   MOVE      'Y'           Recursive
     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
      *
     C     PSSRE         ENDSR
      *********************************************************************
