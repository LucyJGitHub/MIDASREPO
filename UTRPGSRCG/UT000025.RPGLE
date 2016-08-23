     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*XBI *  CRTSRCPF FILE(QTEMP/INPSRC) RCDLEN(112)                      *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Determine object type from member type')      *
/*XAI *  DLTF FILE(QTEMP/INPSRC)                                      *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000025 - Determine object type from member type            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CCB020             Date 06Aug12               *
      *  Prev Amend No. CUT008  *CREATE    Date 16Nov10               *
      *                 xxxxxx             Date ddMmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CUT008 - CRTOBJ rewrite.                                     *
      *                                                               *
      *****************************************************************
     FINPSRC    IF   F  112        DISK
      *
     D PSrcType        S             10
     D PReturnCode     S              1
     D PObjType        S              8
     D PChkCrtPrm      S              1
     D PMultiLang      S              1
     D PSQL            S              1
     D POption         S              1
     D PReplace        S              1
     D PBindDir        S              1
     D PSource         S              1
     D PDebug          S              1
     D FoundPos        S              2  0
     D Recursive       S              1    INZ(*blank)
      *
     IINPSRC    NS  01
     I                                  1    6 2SRCSEQ
     I                                  7   12 0SRCDAT
     I                                 13  112  SRCDTA
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSrcType
     C                   PARM                    PReturnCode
     C                   PARM                    PObjType
     C                   PARM                    PChkCrtPrm
     C                   PARM                    PMultiLang
     C                   PARM                    PSQL
     C                   PARM                    POption
     C                   PARM                    PReplace
     C                   PARM                    PBindDir
     C                   PARM                    PSource
     C                   PARM                    PDebug
      *
     C                   SELECT
      *
     C                   WHEN      PSrcType = 'CLE'
     C                   EXSR      CheckILE
     C                   EVAL      PDebug = 'L'
      *
     C                   WHEN      PSrcType = 'CLLE'
     C                   EXSR      CheckILE
     C                   EVAL      PDebug = 'L'
      *
     C                   WHEN      PSrcType = 'CLP'
     C                   EVAL      PObjType = '*PGM'
      *
     C                   WHEN      PSrcType = 'CMD'
     C                   EVAL      PObjType = '*CMD'
     C                   EVAL      POption = 'N'
      *
     C                   WHEN      PSrcType = 'DSPF'
     C                   EVAL      PObjType = '*FILE'
     C                   EVAL      PMultiLang = 'Y'
      *
     C                   WHEN      PSrcType = 'DTAARA'
     C                   EVAL      PObjType = '*DTAARA'
     C                   EVAL      POption = 'N'
     C                   EVAL      PReplace = 'N'
     C                   EVAL      PSource = 'N'
      *
     C                   WHEN      PSrcType = 'DTAQ'
     C                   EVAL      PObjType = '*DTAQ'
     C                   EVAL      POption = 'N'
     C                   EVAL      PReplace = 'N'
     C                   EVAL      PSource = 'N'
      *
     C                   WHEN      PSrcType = 'ICFF'
     C                   EVAL      PObjType = '*FILE'
     C                   EVAL      POption = 'N'
      *
     C                   WHEN      PSrcType = 'LF'
     C                   EVAL      PObjType = '*FILE'
     C                   EVAL      PReplace = 'N'
      *
     C                   WHEN      PSrcType = 'PF'
     C                   EVAL      PObjType = '*FILE'
     C                   EVAL      PReplace = 'N'
      *
     C                   WHEN      PSrcType = 'PGM'
     C                   EVAL      PObjType = '*PGM'
     C                   EVAL      PBindDir = 'Y'
     C                   EVAL      PSource = 'N'
      *
     C                   WHEN      PSrcType = 'PNLGRP'
     C                   EVAL      PObjType = '*PNLGRP'
      *
     C                   WHEN      PSrcType = 'PRTF'
     C                   EVAL      PObjType = '*FILE'
      *
     C                   WHEN      PSrcType = 'RPG'
     C                   EVAL      PObjType = '*PGM'
      *
     C                   WHEN      PSrcType = 'RPGLE'
     C                   EXSR      CheckILE
     C                   EVAL      PSource = 'Y'
     C                   EVAL      PDebug = 'L'
      *
     C                   WHEN      PSrcType = 'SQLDTAARA'
     C                   EVAL      PObjType = '*DTAARA'
     C                   EVAL      PChkCrtPrm = 'N'
     C                   EVAL      PSQL = 'Y'
     C                   EVAL      POption = 'N'
     C                   EVAL      PReplace = 'N'
     C                   EVAL      PSource = 'N'
      *
     C                   WHEN      PSrcType = 'SQLPROC'
     C                   EVAL      PObjType = '*PGM'
     C                   EVAL      PChkCrtPrm = 'N'
     C                   EVAL      PSQL = 'Y'
     C                   EVAL      POption = 'N'
     C                   EVAL      PSource = 'N'
      *                                                                                       CCB020
     C                   WHEN      PSrcType = 'SQLRPG'                                        CCB020
     C                   EVAL      PObjType = '*PGM'                                          CCB020
      *
     C                   WHEN      PSrcType = 'SQLRPGLE'
     C                   EXSR      CheckILE
     C                   EVAL      PSource = 'Y'
     C                   EVAL      PDebug = 'S'
      *
     C                   WHEN      PSrcType = 'SQLTBL'
     C                   EVAL      PObjType = '*FILE'
     C                   EVAL      PChkCrtPrm = 'N'
     C                   EVAL      PSQL = 'Y'
     C                   EVAL      POption = 'N'
     C                   EVAL      PReplace = 'N'
     C                   EVAL      PSource = 'N'
      *
     C                   WHEN      PSrcType = 'SQLVIEW'
     C                   EVAL      PObjType = '*FILE'
     C                   EVAL      PChkCrtPrm = 'N'
     C                   EVAL      PSQL = 'Y'
     C                   EVAL      POption = 'N'
     C                   EVAL      PReplace = 'N'
     C                   EVAL      PSource = 'N'
      *
     C                   WHEN      PSrcType = 'SRVPGM'
     C                   EVAL      PObjType = '*SRVPGM'
     C                   EVAL      PBindDir = 'Y'
      *
     C                   WHEN      PSrcType = 'TAPF'
     C                   EVAL      PObjType = '*FILE'
     C                   EVAL      POption = 'N'
      *
     C                   WHEN      PSrcType = 'TBL'
     C                   EVAL      PObjType = '*TBL'
     C                   EVAL      PChkCrtPrm = 'N'
     C                   EVAL      POption = 'N'
     C                   EVAL      PReplace = 'N'
     C                   EVAL      PSource = 'N'
      *
     C                   WHEN      PSrcType = 'VLDL'
     C                   EVAL      PObjType = '*VLDL'
     C                   EVAL      POption = 'N'
     C                   EVAL      PReplace = 'N'
     C                   EVAL      PSource = 'N'
      *
     C                   OTHER
     C                   EVAL      PReturnCode = 'N'
      *
     C                   ENDSL
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  CheckILE - Check creation parameters to determine whether    *
      *             object type is *MODULE or *PGM.                   *
      *                                                               *
      *****************************************************************
      *
     C     CheckILE      BEGSR
      *
     C     1             SETLL     INPSRC
     C                   READ      INPSRC
     C                   IF        %EOF
     C                   EVAL      PReturnCode = 'I'
     C                   ELSE
      * Check for the string 'MOD' in the creation parameters.
     C                   EVAL      FoundPos = %SCAN('MOD':SRCDTA:1)
     C                   IF        FoundPos = 0
     C                   EVAL      PObjType = '*PGM'
     C                   ELSE
     C                   EVAL      PObjType = '*MODULE'
     C                   ENDIF
     C                   ENDIF
      *
     C     CheckILEE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
