     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Revalue All 'Pledge' Collateral Items')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000011 - Revalue All 'Pledge' Collateral Items             *
      *                                                               *
      *  Function:  This job will perform the revaluation of all      *
      *             'Pledge' collateral items. This is submitted from *
      *             the Collateral and Credit Control ICD when the    *
      *             'Default Collateral Price Type for SE Valuation'  *
      *             field is changed, that is flagged to be applied   *
      *             to all pledged securities and the user doesn't    *
      *             want to defer the revaluation in COB.             *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG3824            Date 27Jul04               *
      *                 CGL014  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG3824 - Max length of data-queue changed to 600 from 6,000 *
      *           (GPUTUxxxx1 failing as DTAQ is full.)               *
      *  CGL014 - Collaterals Processing                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCOCCPD  IF   E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Data Area giving Standing Data details
     D SDSTAT        E DS           256    EXTNAME(SDSTAT)
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D ConstHead1      C                   CONST('<?xml version="1.0" encoding')
     D ConstHead2      C                   CONST('="UTF-8"?><calcManagerEvent ')
     D ConstHead3      C                   CONST('xmlns="http://www.misys.com/')
     D ConstHead4      C                   CONST('midas/midasplus/calculationm')
     D ConstHead5      C                   CONST('anager/xml><eventType>')
     D ConstHead6      C                   CONST('</eventType>')
     D ConstDet1       C                   CONST('<eventParam><paramName>')
     D ConstDet2       C                   CONST('</paramName><paramValue>')
     D ConstDet3       C                   CONST('</paramValue></eventParam>')
     D ConstFoot       C                   CONST('</calcManagerEvent>')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D DtqNam          S             10A
     D DtqLib          S             10A
     D DtqLen          S              5P 0
     D Buffer          S           6000A
     D WDetail         S            200A
     D WEvntTyp        S             30A
     D WHeader         S            200A
     D WParamName      S             10A
     D WParamValue     S            100A
     D WRun            S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Read first record in SDCOCCPD
 
     C     1             SETLL     SDCOCCPD
     C                   READ      SDCOCCPD
 
     C                   IF        %FOUND(SDCOCCPD)
     C                   EXSR      SRProcess
 
      ** Send buffer to the data queue: do for all zones
 
     C                   IF        Buffer <> *BLANKS
     C                   EVAL      DtqNam = 'CLECALCMGR'
     C                   EVAL      DtqLib = LIBR + 'DPLIB'
     C                   EVAL      DtqLen = 600                                              BUG3824
     C*******************EVAL      DtqLen = 6000                                             BUG3824
     C                   EXSR      SrSendDtaQ
     C                   ENDIF
     C                   ENDIF
 
      ** Terminate Program
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrProcess - Process data                                     *
      *****************************************************************
     C     SrProcess     BEGSR
 
     C                   EXSR      SrReset
 
     C                   EVAL      WEvntTyp = 'MN_COLLATERAL_CREDIT_ICD'
     C                   EXSR      SrHeader
 
     C                   EVAL      WParamName = 'CCDCPS'
     C                   EVAL      WParamValue = CCDCPS
     C                   EXSR      SrDetail
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDetail) +
     C                                      ConstFoot
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrHeader - Header Processing                                 *
      *****************************************************************
     C     SrHeader      BEGSR
 
     C                   EVAL      WHeader = ConstHead1 + ConstHead2 +
     C                                       ConstHead3 + ConstHead4 +
     C                                       ConstHead5 + %TRIM(WEvntTyp)
     C                                       + ConstHead6
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrDetail - Detail Processing                                 *
      *****************************************************************
     C     SrDetail      BEGSR
 
     C                   EVAL      WDetail = ConstDet1 + %TRIM(WParamName)
     C                                       + ConstDet2 + %TRIM(WParamValue)
     C                                       + ConstDet3
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrReset - Initialise variables                               *
      *****************************************************************
     C     SrReset       BEGSR
 
     C                   EVAL      Buffer = *BLANKS
     C                   EVAL      WEvntTyp = *BLANKS
     C                   EVAL      WParamName = *BLANKS
     C                   EVAL      WParamValue = *BLANKS
     C                   EVAL      WHeader = *BLANKS
     C                   EVAL      WDetail = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSendDtaQ - Send Buffer to the data queue                   *
      *****************************************************************
     C     SrSendDtaQ    BEGSR
 
     C                   CALL      'QSNDDTAQ'                           7070
     C                   PARM      'CLECALCMGR'  DtqNam
     C                   PARM                    DtqLib
     C                   PARM      600           DtqLen                                      BUG3824
     C*******************PARM      6000          DtqLen                                      BUG3824
     C                   PARM                    Buffer
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Read in data areas
 
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  SDSTAT
 
     C                   IN        RUNDAT
     C                   IN        SDSTAT
 
      ** Set Date Format Indicator *IN98 on if date format is MMDDYY
 
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
