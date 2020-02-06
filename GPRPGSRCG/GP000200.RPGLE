     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP DataFile Trigger for GPWEIGPD')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP000200 - DataFile Trigger for GPWEIGPD                     *
      *                                                               *
      *  Function:  This program sends triggers to the Data Queue     *
      *             when GPWEIGPD has been updated.                   *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP009             Date 22Dec04               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGPZONEL0  IF   E             DISK    INFSR(*PSSR)
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D*COPY*ZACPYSRC,PSDS*
     D/COPY GPCPYSRCG,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** First entry parameter
     D PARM1           DS
      ** Physical file name
     D  PFlName                1     10
      ** Member name
     D  MbrName               21     30
      ** Trigger event 1=Insert, 2=Delete, 3=Update, 4=Read
     D  TrgEvent              31     31
      ** Trigger time  1=After, 2=Before
     D  TrgTime               32     32
      ** Offset to the before image of the record
     D  BOff                  49     52B 0
      ** Length of the before image of the record
     D  BLen                  53     56B 0
      ** Offset to the after image of the record
     D  AOff                  65     68B 0
      ** Length of the after image of the record
     D  ALen                  69     72B 0
      ** Images
     D  EntryData            117  10117A
 
      ** Second entry parameter
     D PARM2           DS
     D  Leng                   1      4B 0
 
      ** Before and After images
     D BGPWEIGPD     E DS                  EXTNAME(GPWEIGPD) PREFIX(B1)
     D AGPWEIGPD     E DS                  EXTNAME(GPWEIGPD) PREFIX(A1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
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
 
     D AfterImg        S           4000A
     D BeforeImg       S           4000A
     D Buffer          S           6000A
     D DtqLen          S              5P 0
     D DtqLib          S             10A
     D DtqNam          S             10A
     D Offset          S              5P 0
     D WBeforeAfter    S              1A
     D WDetail         S            200A
     D WDtl1           S            200A
     D WDtl2           S            200A
     D WDtl3           S            200A
     D WEvntTyp        S             30A
     D WFldChg1        S              1A
     D WFldChg2        S              1A
     D WFldChg3        S              1A
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
 
      ** Retrieve before/after image from PARM1 using length and offset
 
     C     BOff          ADD       1             OffSet
     C     BLen          SUBST     PARM1:OffSet  BeforeImg
 
     C     AOff          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  AfterImg
 
      ** Check if specific fields have been changed
 
     C                   IF        PFlName = 'GPWEIGPD'
     C                   EXSR      SrGPWEIGPD
     C                   ENDIF
 
      ** Send buffer to the data queue: do for all zones
 
     C                   IF        Buffer <> *BLANKS
 
     C     1             SETLL     GPZONEL0
     C                   READ      GPZONEL0                               81
 
     C                   DOW       *IN81 = *OFF
     C                   EVAL      DtqLib = ZOMSYS + 'DPLIB'
     C                   EXSR      SrSendDtaQ
     C                   READ      GPZONEL0                               81
     C                   ENDDO
 
     C                   ENDIF
 
      ** Terminate Program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrGPWEIGPD - Processing for GPWEIGPD                         *
      *****************************************************************
     C     SrGPWEIGPD    BEGSR
 
     C                   EXSR      SrReset
     C                   EVAL      BGPWEIGPD = BeforeImg
     C                   EVAL      AGPWEIGPD = AfterImg
 
     C                   IF        TrgEvent = '3'
     C                   IF        B1PDCUML <> A1PDCUML
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   IF        B1PDPERC <> A1PDPERC
     C                   EVAL      WFldChg2 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '2' OR
     C                             WFldChg1 = 'Y' OR WFldChg2 = 'Y'
 
     C                   EVAL      WEvntTyp = 'MN_WEIGHTING_CODE'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'PDWEIG'
     C                   EVAL      WParamValue = *BLANKS
     C                   IF        TrgEvent = '2'
     C                   MOVEL     B1PDWEIG      WParamValue
     C                   ELSE
     C                   MOVEL     A1PDWEIG      WParamValue
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
 
     C                   IF        WFldChg1 = 'Y'
     C                   EVAL      WParamName = 'PDCUML'
     C                   EVAL      WParamValue = A1PDCUML
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   ENDIF
 
     C                   IF        WFldChg2 = 'Y'
     C                   EVAL      WParamName = 'PDPERC'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     A1PDPERC      WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C                                      + ConstFoot
 
     C                   ENDIF
 
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
 
     C                   EVAL      WBeforeAfter = *BLANKS
     C                   EVAL      WDtl1 = *BLANKS
     C                   EVAL      WDtl2 = *BLANKS
     C                   EVAL      WDtl3 = *BLANKS
     C                   EVAL      WFldChg1 = *BLANKS
     C                   EVAL      WFldChg2 = *BLANKS
     C                   EVAL      WFldChg3 = *BLANKS
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
     C                   PARM      'CLECALCMGR'  DtqNam
     C                   PARM                    DtqLib
     C                   PARM      6000          DtqLen
     C                   PARM                    Buffer
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
      ** Read in data areas
 
     C     *DTAARA       DEFINE                  LDA
 
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
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
