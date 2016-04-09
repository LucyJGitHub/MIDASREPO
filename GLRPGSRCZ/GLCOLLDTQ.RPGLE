     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Collateralised Lending Data Queue Update')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLLDTQ - Collateralised Lending DataQueue Program         *
      *                                                               *
      *  Function:  This program sends records to the Data Queue      *
      *             Collateral Data file has been written to,         *
      *             deleted, or amended.                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG18050*CREATE    Date 28Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BUG18050 - Collateral by facility enquiry displaying CAV     *
      *             and CLV as zero                                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
O    FGZGLCOLLL1IF   E           K DISK    INFSR(*PSSR) PREFIX(F_)
     FFCLTYL3   IF   E           K DISK
O
O    D F_GLCOLLPD    E DS                  EXTNAME(GLCOLLPD) PREFIX(F_)
      ** Before images
O    D B_GLCOLLPD    E DS                  EXTNAME(GLCOLLPD) PREFIX(B_)
      ** After images
O    D A_GLCOLLPD    E DS                  EXTNAME(GLCOLLPD) PREFIX(A_)
 
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
 
     D AfterImg        S           4000A
     D BeforeImg       S           4000A
     D Buffer          S           6000A
     D DtqLen          S              5P 0
     D DtqLib          S             10A
     D DtqNam          S             10A
     D WBeforeAfter    S              1A
     D WDetail         S            200A
     D WDtl1           S            200A
     D WDtl2           S            200A
     D WDtl3           S            200A
     D WDtl4           S            200A
     D WDtl5           S            200A
     D WDtl6           S            200A
     D WEvntTyp        S             30A
     D WFldChg1        S              1A
     D WFldChg2        S              1A
     D WFldChg3        S              1A
     D WFldChg4        S              1A
     D WFldChg5        S              1A
     D WFldChg6        S              1A
     D WFldChg7        S              1A
     D WFldChg8        S              1A
     D WFldChg9        S              1A
     D WFldChg10       S              1A
     D WFldChg11       S              1A
     D WFldChg12       S              1A
     D WFldChg13       S              1A
     D WFldChg14       S              1A
     D WFldChg15       S              1A
     D WFldChg16       S              1A
     D WFldChg17       S              1A
     D WFldChg18       S              1A
     D WFldChg19       S              1A
     D WFldChg20       S              1A
     D WFldChg21       S              1A
     D WFldChg22       S              1A
     D WFldChg23       S              1A
     D WFldChg24       S              1A
     D WFldChg25       S              1A
     D WFldChg26       S              1A
     D WFldChg27       S              1A
     D WFldChg28       S              1A
     D WFldChg29       S              1A
     D WFldChg30       S              1A
     D WFldChg31       S              1A
     D WFldChg32       S              1A
     D WFldChg33       S              1A
     D WFldChg34       S              1A
     D WFldChg35       S              1A
     D WFldChg36       S              1A
     D WFldChg37       S              1A
     D WHeader         S            200A
     D WParamName      S             10A
     D WParamValue     S            100A
     D WRun            S              1A
     D WZoned5         S              5S 0
     D WZoned15        S             15S 0
     D WLength         S              4S 0
     D FacBrch         S              3A
     D TRGEVENT        S              1A
 
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
 
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        B_GLCOLLPD
O    C                   Eval      CDCREF = %SUBST(B_GLCOLLPD:2:10)
O    C                   ELSE
O    C                   MOVEL     I#AIMG        A_GLCOLLPD
O    C                   Eval      CDCREF = %SUBST(A_GLCOLLPD:2:10)
O    C                   ENDIF
O
O    C     K_GLCOLLL1    CHAIN     GZGLCOLLL1                         99
      ** Before
O    C                   IF        I#BFAF = 'B'
 
O    C                   IF        %FOUND(GZGLCOLLL1)
     C                   Eval      TrgEvent = '2'
O    C                   MOVEL     *BLANKS       A_GLCOLLPD
     C                   ENDIF
 
     C                   Else
      ** After
O    C                   IF        %FOUND(GZGLCOLLL1)
     C                   Eval      TrgEvent = '3'
O    C                   MOVEL     F_GLCOLLPD    B_GLCOLLPD
     C                   Else
     C                   Eval      TrgEvent = '1'
O    C                   MOVEL     *BLANKS       B_GLCOLLPD
     C                   ENDIF
 
     C                   ENDIF
O
     C                   IF        TrgEvent <> *BLANK
     C                   EXSR      SrMain
     C                   ENDIF
 
      ** Terminate Program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      *  SrMain - Main Processing                                     *
      *****************************************************************
     C     SrMain        BEGSR
 
     C                   EXSR      SrReset
 
     C                   IF        TrgEvent = '3' AND
     C                             NOT (B_CDRECI = 'D' AND
     C                                  A_CDRECI = 'R' AND
     C                                  A_CDTYLC = 'D') AND
     C                             (A_CDRECI = 'D' AND
     C                              A_CDSTAT = 'C')
     C                   IF        B_CDCOLT <> A_CDCOLT
     C                   EVAL      WFldChg1 = 'Y'
     C                   ENDIF
     C                   IF        B_CDGNSP <> A_CDGNSP
     C                   EVAL      WFldChg2 = 'Y'
     C                   ENDIF
     C                   IF        B_CDVDAT <> A_CDVDAT
     C                   EVAL      WFldChg3 = 'Y'
     C                   ENDIF
     C                   IF        B_CDEDAT <> A_CDEDAT
     C                   EVAL      WFldChg4 = 'Y'
     C                   ENDIF
     C                   IF        B_CDCCY <> A_CDCCY
     C                   EVAL      WFldChg5 = 'Y'
     C                   ENDIF
     C                   IF        B_CDAPCT <> A_CDAPCT
     C                   EVAL      WFldChg6 = 'Y'
     C                   ENDIF
     C                   IF        B_CDNAMT <> A_CDNAMT
     C                   EVAL      WFldChg7 = 'Y'
     C                   ENDIF
     C                   IF        B_CDPCNT <> A_CDPCNT
     C                   EVAL      WFldChg8 = 'Y'
     C                   ENDIF
     C                   IF        B_CDMXNA <> A_CDMXNA
     C                   EVAL      WFldChg9 = 'Y'
     C                   ENDIF
     C                   IF        B_CDVAMT <> A_CDVAMT
     C                   EVAL      WFldChg10 = 'Y'
     C                   ENDIF
     C                   IF        B_CDMARG <> A_CDMARG
     C                   EVAL      WFldChg11 = 'Y'
     C                   ENDIF
     C                   IF        B_CDMODS <> A_CDMODS
     C                   EVAL      WFldChg12 = 'Y'
     C                   ENDIF
     C                   IF        B_CDFCUS <> A_CDFCUS
     C                   EVAL      WFldChg13 = 'Y'
     C                   ENDIF
     C                   IF        B_CDFTYP <> A_CDFTYP
     C                   EVAL      WFldChg14 = 'Y'
     C                   ENDIF
     C                   IF        B_CDFSEQ <> A_CDFSEQ
     C                   EVAL      WFldChg15 = 'Y'
     C                   ENDIF
     C                   IF        B_CDLNLM <> A_CDLNLM
     C                   EVAL      WFldChg16 = 'Y'
     C                   ENDIF
     C                   IF        B_CDSBRC <> A_CDSBRC
     C                   EVAL      WFldChg17 = 'Y'
     C                   ENDIF
     C                   IF        B_CDSCNM <> A_CDSCNM
     C                   EVAL      WFldChg18 = 'Y'
     C                   ENDIF
     C                   IF        B_CDSCCY <> A_CDSCCY
     C                   EVAL      WFldChg19 = 'Y'
     C                   ENDIF
     C                   IF        B_CDSACD <> A_CDSACD
     C                   EVAL      WFldChg20 = 'Y'
     C                   ENDIF
     C                   IF        B_CDSSEQ <> A_CDSSEQ
     C                   EVAL      WFldChg21 = 'Y'
     C                   ENDIF
     C                   IF        B_CDCBRC <> A_CDCBRC
     C                   EVAL      WFldChg22 = 'Y'
     C                   ENDIF
     C                   IF        B_CDCCNM <> A_CDCCNM
     C                   EVAL      WFldChg23 = 'Y'
     C                   ENDIF
     C                   IF        B_CDCCCY <> A_CDCCCY
     C                   EVAL      WFldChg24 = 'Y'
     C                   ENDIF
     C                   IF        B_CDCACD <> A_CDCACD
     C                   EVAL      WFldChg25 = 'Y'
     C                   ENDIF
     C                   IF        B_CDCSEQ <> A_CDCSEQ
     C                   EVAL      WFldChg26 = 'Y'
     C                   ENDIF
     C                   IF        B_CDDEAL <> A_CDDEAL
     C                   EVAL      WFldChg27 = 'Y'
     C                   ENDIF
     C                   IF        B_CDCSBR <> A_CDCSBR
     C                   EVAL      WFldChg28 = 'Y'
     C                   ENDIF
     C                   IF        B_CDCSEC <> A_CDCSEC
     C                   EVAL      WFldChg29 = 'Y'
     C                   ENDIF
     C                   IF        B_CDCSCN <> A_CDCSCN
     C                   EVAL      WFldChg30 = 'Y'
     C                   ENDIF
     C                   IF        B_CDVPCH <> A_CDVPCH
     C                   EVAL      WFldChg31 = 'Y'
     C                   ENDIF
     C                   IF        B_CDPTFR <> A_CDPTFR
     C                   EVAL      WFldChg32 = 'Y'
     C                   ENDIF
     C                   IF        B_CDMNNA <> A_CDMNNA
     C                   EVAL      WFldChg33 = 'Y'
     C                   ENDIF
     C                   IF        B_CDWEIG <> A_CDWEIG
     C                   EVAL      WFldChg34 = 'Y'
     C                   ENDIF
     C                   IF        B_CDPRTP <> A_CDPRTP
     C                   EVAL      WFldChg35 = 'Y'
     C                   ENDIF
     C                   IF        B_CDPR01 <> A_CDPR01
     C                   EVAL      WFldChg36 = 'Y'
     C                   ENDIF
     C                   IF        B_CDTSTP <> A_CDTSTP
     C                   EVAL      WFldChg37 = 'Y'
     C                   ENDIF
     C                   IF        (WFldChg13 = 'Y' OR
     C                              WFldChg14 = 'Y' OR
     C                              WFldChg15 = 'Y') AND
     C                             (B_CDFCUS <> *BLANKS OR
     C                              B_CDFTYP <> *ZERO OR
     C                              B_CDFSEQ <> *ZERO)
     C                   EVAL      WBeforeAfter = 'B'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TrgEvent = '1' OR
     C                             (TrgEvent = '3' AND
     C                              B_CDRECI = 'D' AND
     C                              B_CDSTAT = 'C' AND
     C                              A_CDRECI = 'R' AND
     C                              A_CDTYLC = 'D') OR
     C                             WBeforeAfter = 'B' OR
     C                             WFldChg1 = 'Y' OR WFldChg2 = 'Y' OR
     C                             WFldChg3 = 'Y' OR WFldChg4 = 'Y' OR
     C                             WFldChg5 = 'Y' OR WFldChg6 = 'Y' OR
     C                             WFldChg7 = 'Y' OR WFldChg8 = 'Y' OR
     C                             WFldChg9 = 'Y' OR WFldChg10 = 'Y' OR
     C                             WFldChg11 = 'Y' OR WFldChg12 = 'Y' OR
     C                             WFldChg16 = 'Y' OR
     C                             WFldChg17 = 'Y' OR WFldChg18 = 'Y' OR
     C                             WFldChg19 = 'Y' OR WFldChg20 = 'Y' OR
     C                             WFldChg21 = 'Y' OR WFldChg22 = 'Y' OR
     C                             WFldChg23 = 'Y' OR WFldChg24 = 'Y' OR
     C                             WFldChg25 = 'Y' OR WFldChg26 = 'Y' OR
     C                             WFldChg27 = 'Y' OR WFldChg28 = 'Y' OR
     C                             WFldChg29 = 'Y' OR WFldChg30 = 'Y' OR
     C                             WFldChg31 = 'Y' OR WFldChg32 = 'Y' OR
     C                             WFldChg33 = 'Y' OR WFldChg34 = 'Y' OR
     C                             WFldChg35 = 'Y' OR WFldChg36 = 'Y' OR
     C                             WFldChg37 = 'Y'
 
     C                   EVAL      WEvntTyp = 'MN_COLLATERAL_REGISTER'
     C                   EXSR      SrHeader
     C                   EVAL      WParamName = 'CDCREF'
     C                   IF        TrgEvent = '2'
     C                   EVAL      WParamValue = B_CDCREF
     C                   ELSE
     C                   EVAL      WParamValue = A_CDCREF
     C                   ENDIF
     C                   EXSR      SrDetail
     C                   EVAL      WDtl1 = WDetail
 
     C                   IF        WBeforeAfter = 'B'
     C                   EVAL      CNUM = B_CDFCUS
     C                   EVAL      FACT = B_CDFTYP
     C                   EVAL      FCNO = B_CDFSEQ
     C                   EXSR      FNDBRCA
     C                   EVAL      WParamName = 'CDFCUS'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B_CDFCUS      WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl2 = WDetail
     C                   EVAL      WParamName = 'CDFTYP'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     B_CDFTYP      WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl3 = WDetail
     C                   EVAL      WParamValue = *BLANKS
     C                   EVAL      WParamName = 'CDFSEQ'
     C                   MOVEL     B_CDFSEQ      WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl4 = WDetail
     C                   EVAL      WParamName = 'FacBrch'
     C                   EVAL      WParamValue = *BLANKS
     C                   MOVEL     BRCA          WParamValue
     C                   EXSR      SrDetail
     C                   EVAL      WDtl5 = WDetail
     C                   ENDIF
 
     C                   EVAL      Buffer = %TRIM(WHeader) + %TRIM(WDtl1)
     C                                      + %TRIM(WDtl2) + %TRIM(WDtl3)
     C                                      + %TRIM(WDtl4) + %TRIM(WDtl5)
     C                                      + ConstFoot
 
     C                   ENDIF
 
      ** Send buffer to the data queue
     C                   IF        Buffer <> *BLANKS
     C                   EVAL      DtqLib = LIBR + 'DPLIB'
     C                   EXSR      SrSendDtaQ
 
     C                   ENDIF
 
     C                   ENDSR
 
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
     C                   EVAL      WDtl4 = *BLANKS
     C                   EVAL      WDtl5 = *BLANKS
     C                   EVAL      WDtl6 = *BLANKS
     C                   EVAL      WFldChg1 = *BLANKS
     C                   EVAL      WFldChg2 = *BLANKS
     C                   EVAL      WFldChg3 = *BLANKS
     C                   EVAL      WFldChg4 = *BLANKS
     C                   EVAL      WFldChg5 = *BLANKS
     C                   EVAL      WFldChg6 = *BLANKS
     C                   EVAL      WFldChg7 = *BLANKS
     C                   EVAL      WFldChg8 = *BLANKS
     C                   EVAL      WFldChg9 = *BLANKS
     C                   EVAL      WFldChg10 = *BLANKS
     C                   EVAL      WFldChg11 = *BLANKS
     C                   EVAL      WFldChg12 = *BLANKS
     C                   EVAL      WFldChg13 = *BLANKS
     C                   EVAL      WFldChg14 = *BLANKS
     C                   EVAL      WFldChg15 = *BLANKS
     C                   EVAL      WFldChg16 = *BLANKS
     C                   EVAL      WFldChg17 = *BLANKS
     C                   EVAL      WFldChg18 = *BLANKS
     C                   EVAL      WFldChg19 = *BLANKS
     C                   EVAL      WFldChg20 = *BLANKS
     C                   EVAL      WFldChg21 = *BLANKS
     C                   EVAL      WFldChg22 = *BLANKS
     C                   EVAL      WFldChg23 = *BLANKS
     C                   EVAL      WFldChg24 = *BLANKS
     C                   EVAL      WFldChg25 = *BLANKS
     C                   EVAL      WFldChg26 = *BLANKS
     C                   EVAL      WFldChg27 = *BLANKS
     C                   EVAL      WFldChg28 = *BLANKS
     C                   EVAL      WFldChg29 = *BLANKS
     C                   EVAL      WFldChg30 = *BLANKS
     C                   EVAL      WFldChg31 = *BLANKS
     C                   EVAL      WFldChg32 = *BLANKS
     C                   EVAL      WFldChg33 = *BLANKS
     C                   EVAL      WFldChg34 = *BLANKS
     C                   EVAL      WFldChg35 = *BLANKS
     C                   EVAL      WFldChg36 = *BLANKS
     C                   EVAL      WFldChg37 = *BLANKS
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
 
      ** Find the first non-blank position starting from the right
      ** Result field would contain the position relative to the left
 
     C     ' '           CHECKR    BUFFER        WLength
 
     C                   CALL      'QSNDDTAQ'                           7070
     C                   PARM      'CLECALCMGR'  DtqNam
     C                   PARM                    DtqLib
     C                   PARM      WLength       DtqLen
     C                   PARM                    Buffer
 
     C                   ENDSR
      *****************************************************************
      * FNDBRCA - Get the branch from facilities file.                *
      *****************************************************************
     C     FNDBRCA       BEGSR
 
     C     FBRCH         CHAIN     FCLTYFMF
     C                   EVAL      FacBrch = BRCA
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
 
O     * Key lists
O
O    C     K_GLCOLLL1    KLIST
O    C                   KFLD                    I#ZONE
O    C                   KFLD                    CDCREF           10
O    C     FBRCH         KLIST
O    C                   KFLD                    CNUM
O    C                   KFLD                    FACT
O    C                   KFLD                    FCNO
O    C
     C                   Eval      TrgEvent = *BLANK
 
      ** Read in data areas
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        RUNDAT
     C                   IN        SDSTAT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
      *
      * If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
      * Log an error on the error log
      *
     C                   CLEAR                   BUFFER2
     C                   EVAL      BUFFER2 = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER2        4000
 
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
