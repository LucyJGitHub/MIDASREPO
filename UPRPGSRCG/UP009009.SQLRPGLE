     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                       CUP040
/*STD *  RPGSQLBND                                                    *                       CUP040
/*EXI *  TEXT('Midas UP Update Action File details for new file')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP009009 - Update Action File details for new file           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CUP040             Date 22Feb13               *
      *  Prev Amend No. CUP021  *CREATE    Date 15Feb11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP040 - New deliverable data methodology.                   *
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
     D POriFile        S             10                                                       CUP040
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
     D Format          S              8    INZ('OBJD0100')                                    CUP040
     D ObjD            S             10                                                       CUP040
     D ObjDLen         S              4B 0 INZ(10)                                            CUP040
     D ObjType         S             10    INZ('*FILE')                                       CUP040
      *
     D UPFLTD        E DS                  EXTNAME(UPAFFLPD)
      *
     D Object          DS                                                                     CUP040
     D  ExtFile                1     10                                                       CUP040
     D                        11     20    INZ('*LIBL')                                       CUP040
     D
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFile
     C                   PARM                    PKeyFile
     C                   PARM                    PLayer
     C                   PARM                    POriFile                                     CUP040
      *
     C                   EVAL      KFile = PFile
      ** Check if Extension File exists.                                                      CUP040
     C                   EVAL      ExtFile = %SUBST(PFile:1:5) + 'XTD'                        CUP040
     C                   CALL      'QUSROBJD'                                                 CUP040
     C                   PARM                    ObjD                                         CUP040
     C                   PARM                    ObjDLen                                      CUP040
     C                   PARM                    Format                                       CUP040
     C                   PARM                    Object                                       CUP040
     C                   PARM                    ObjType                                      CUP040
      *
      * Update main Action File file.
     C     KFile         CHAIN     UPACTFL0
     C                   EVAL      AABONF = PFile
     C                   EVAL      AAAFLF = PKeyFile
     C                   EVAL      AALAYR = PLayer
     C                   EVAL      AAORIF = POriFile                                          CUP040
     C                   IF        %FOUND
     C                   UPDATE    UPACTFD0
     C                   ELSE
     C                   WRITE     UPACTFD0
     C                   ENDIF
      *
      * If this is a replacement then remove records associated with original                 CUP040
      *  file.                                                                                CUP040
     C/exec SQL                                                                               CUP040
     C+ delete from UPACTFPD                                                                  CUP040
     C+ where                                                                                 CUP040
     C+    AABONF = :POriFile                                                                 CUP040
     C/end-exec                                                                               CUP040
     C/exec SQL                                                                               CUP040
     C+ delete from UPAFFDPD                                                                  CUP040
     C+ where                                                                                 CUP040
     C+    AFFILE = :POriFile                                                                 CUP040
     C/end-exec                                                                               CUP040
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
      * If an Extension File was found the update field data.
     C                   IF        %SUBST(ObjD:10:1) <> *blank                                CUP040
     C                   CALL      'UP009011'
     C                   PARM                    ExtFile
     C                   PARM                    KeyName
     C                   PARM                    Library
     C                   ENDIF                                                                CUP040
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
