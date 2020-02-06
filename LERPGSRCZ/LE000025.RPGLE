     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Send Facility Update Event')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000025 - Send Facility Update Event                        *
      *                                                               *
      *  Function:  This program reads the records of PF/FCLTYFM and  *
      *  (CoB)      dumps the folllowing fields to a data queue:      *
      *             facility customer number, facility type, facility *
      *             sequence number and COB Indicator.                *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 253161             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE041             Date 11Oct04               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  253161 - Branch missing from paramater list                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
 
     FFCLTYL1   IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Facilities detail A record
 
     FLEAGFYL1  IF   E           K DISK    INFSR(*PSSR)                                       CLE041
     F                                     Rename(FCLTYFMF:Rec02)                             CLE041
      ** Midas LE Facilities Aggregate Facilities detail A record                             CLE041
                                                                                              CLE041
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
      ** Data Area for Standing Data Details
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D ConstHead1      C                   CONST('<?xml version="1.0" encoding')
     D ConstHead2      C                   CONST('="UTF-8"?><calcManagerEvent ')
     D ConstHead3      C                   CONST('xmlns="http://www.misys.com/')
     D ConstHead4      C                   CONST('midas/midasplus/calculationm')
     D ConstHead5      C                   CONST('anager/xml"><eventType>')
     D ConstHead6      C                   CONST('</eventType>')
     D ConstDet1       C                   CONST('<eventParam><paramName>')
     D ConstDet2       C                   CONST('</paramName><paramValue>')
     D ConstDet3       C                   CONST('</paramValue></eventParam>')
     D ConstFoot       C                   CONST('</calcManagerEvent>')
 
     D*Buffer***       S            600A                                                      253161
     D Buffer          S            800A                                                      253161
     D DtqLen          S              5P 0
     D DtqLib          S             10A
     D DtqNam          S             10A
     D WDetail         S            200A
     D WDtl1           S            200A
     D WDtl2           S            200A
     D WDtl3           S            200A
     D WDtl3a          S            200A                                                      253161
     D WDtl4           S            200A
     D WDtl5           S            200A                                                      CLE041
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
                                                                                              CLE041
      ** Read all records of facility details file to get the values                          CLE041
      ** that will be dumped to the data queue                                                CLE041
     C     *LOVAL        SETLL     FCLTYL1                                                    CLE041
     C                   READ      FCLTYL1                                10                  CLE041
                                                                                              CLE041
     C                   DOW       *IN10 = *OFF                                               CLE041
     C                   EXSR      SrSetDta                                                   CLE041
      ** Read next record                                                                     CLE041
     C                   READ      FCLTYL1                                10                  CLE041
     C                   ENDDO                                                                CLE041
                                                                                              CLE041
      ** Read all records of facility details file to get the values                          CLE041
      ** that will be dumped to the data queue                                                CLE041
     C     *LOVAL        SETLL     LEAGFYL1                                                   CLE041
     C                   READ      LEAGFYL1                               10                  CLE041
                                                                                              CLE041
     C                   DOW       *IN10 = *OFF                                               CLE041
     C                   EXSR      SrSetDta                                                   CLE041
      ** Read next record                                                                     CLE041
     C                   READ      LEAGFYL1                               10                  CLE041
     C                   ENDDO                                                                CLE041
                                                                                              CLE041
      ** Terminate Program                                                                    CLE041
                                                                                              CLE041
     C                   EVAL      *INLR = *ON                                                CLE041
     C                   RETURN                                                               CLE041
                                                                                              CLE041
      *****************************************************************                       CLE041
      /EJECT                                                                                  CLE041
      *****************************************************************                       CLE041
      *  SrSetDta - Set up data                                       *                       CLE041
      *****************************************************************                       CLE041
     C     SrSetDta      BEGSR                                                                CLE041
 
      ** Reset all variables
     C                   EXSR      SrReset
 
      ** Read all records of facility details file to get the values
      ** that will be dumped to the data queue
     C******LOVAL        SETLL     FCLTYL1                                                    CLE041
     C**********         READ      FCLTYL1                                10                  CLE041
      **********                                                                              CLE041
     C**********         DOW       *IN10 = *OFF                                               CLE041
 
     C                   IF        RECI = 'D'
     C                   EVAL      WEvntTyp = 'FACILITY_UPDATE'
     C                   EXSR      SrHeader
 
     C                   EVAL      WParamName = 'facCustNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     CNUM          WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
 
     C                   EVAL      WParamName = 'facType'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     FACT          WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
 
     C                   EVAL      WParamName = 'facSeqNo'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     FCNO          WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
                                                                                              253161
     C                   EVAL      WParamName = 'facBrch'                                     253161
     C                   EVAL      WParamValue = *BLANKS                                      253161
     C                   MOVEL     BRCA          WParamValue                                  253161
     C                   EXSR      SrDetail                                                   253161
     C                   EVAL      WDtl3a = WDetail                                           253161
 
     C                   EVAL      WParamName = 'COBInd'
     C                   EVAL      WParamValue = 'Y'
     C                   EXSR      SrDetail
     C                   EVAL      WDtl4 = WDetail
                                                                                              CLE041
     C                   EVAL      WParamName = 'facClass'                                    CLE041
     C                   EVAL      WParamValue = *BLANKS                                      CLE041
     C                   EXSR      SrDetail                                                   CLE041
     C                   EVAL      WDtl5 = WDetail                                            CLE041
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C**********                            + %TRIM(WDtl4) + ConstFoot                        CLE041
     C                                      + %TRIM(WDtl3a)                                   253161
     C                                      + %TRIM(WDtl4) + %TRIM(WDtl5)                     CLE041
     C                                      + ConstFoot                                       CLE041
 
      ** Send buffer to the data queue
     C                   EVAL      DtqLib = LIBR + 'DPLIB'
 
     C                   EXSR      SrSendDtaQ
 
     C                   ENDIF
 
      ***Read*next*record**********************************************                       CLE041
     C**********         READ      FCLTYL1                                10                  CLE041
      *****************************************************************                       CLE041
     C**********         ENDDO                                                                CLE041
      *****************************************************************                       CLE041
      ***Terminate*Program*********************************************                       CLE041
      *****************************************************************                       CLE041
     C**********         EVAL      *INLR = *ON                                                CLE041
     C**********         RETURN                                                               CLE041
      *****************************************************************                       CLE041
                                                                                              CLE041
     C                   ENDSR                                                                CLE041
                                                                                              CLE041
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
 
     C                   EVAL      WDtl1 = *BLANKS
     C                   EVAL      WDtl2 = *BLANKS
     C                   EVAL      WDtl3 = *BLANKS
     C                   EVAL      WDtl4 = *BLANKS
     C                   EVAL      WDtl5 = *BLANKS                                            CLE041
     C                   EVAL      WEvntTyp = *BLANKS
     C                   EVAL      WParamName = *BLANKS
     C                   EVAL      WParamValue = *BLANKS
     C                   EVAL      Buffer = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSendDtaQ - Send Buffer to the data queue                   *
      *****************************************************************
     C     SrSendDtaQ    BEGSR
 
     C                   CALL      'QSNDDTAQ'                           7070
     C                   PARM      'CLELTVMNTR'  DtqNam
     C                   PARM                    DtqLib
     C**********         PARM      600           DtqLen                                       253161
     C                   PARM      800           DtqLen                                       253161
     C                   PARM                    Buffer
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
