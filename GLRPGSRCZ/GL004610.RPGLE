     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer Report')                     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL004610  - Midas GL Account Transfer Report                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. MD042785           Date 20Nov16               *
      *  Prev Amend No. AR1075388          Date 21Nov13               *
      *                 AR845655           Date 06Oct11               *
      *                 AR688316           Date 17Jan11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27398           Date 29Apr10               *
      *                 BUG27515           Date 26Mar10               *
      *                 BUG27287           Date 26Mar10               *
      *                 CAP204  *CREATE    Date 18Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD042785 - Component GLC004610 10001 failed during COB       *
      *  AR1075388 - Account transfer fees - net (Child:AR1075389)    *
      *              Applied for MD-23536 (Recompile)                 *
      *  AR845655 - Update datatype of Paying Bank to Alphanumeric    *
      *  AR688316 - Input Cycle Reports GLC004610 job fails to        *
      *             generate after requesting for an Account Transfer *
      *             List (Child: AR688317)                            *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *  BUG27398 - Remove audit report for historic account transfer *
      *             list                                              *
      *  BUG27515 - GLC004610 Printer overflow                        *
      *  BUG27287 - Deleted Items does not reflect of audit report    *
      *             (Recompile)                                       *
      *  CAP204 - Retail Account Transfer                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrProcess    - Subroutine to process the report              *
      *  SrMoveFields - Move values to report fields                  *
      *  SrTransTypeD - Get Account transfer type description         *
      *  SrSubTypeD   - Get Account transfer subtype description      *
      *  SrCurr       - Subroutine to get currency details            *
      *  SrAmount     - Subroutine to convert amount from number      *
      *                 to reporting format                           *
      *  SrDate       - Subroutine to convert midas day number to     *
      *                 DDMMMYY format                                *
      *  SrrcfP1      - Register P1 Printer file for RCF processing   *
      *  SRRcfAu      - Register AU Printer file for RCF processing   *
      *  SRGetBrch    - Get Branch Details                            *
      *  SrAudit      - Output Audit Report                           *
      *  *INZSR       - Program Initialisation Routine                *
      *  *PSSR        - Error handling Routine                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      * If Pmode = 'H'                                                *
      *                                                               *
      * OVRDBF     FILE(GLATMIL2) TOFILE(GLHATML0) OVRSCOPE(*JOB)     *
      *              SHARE(*YES)                                      *
      *                                                               *
      *****************************************************************

      ** Account Transfer Manual Input

     FGLATMIL2  IF   E           K DISK    INFSR(*PSSR)

      ** Account Transfer Type/Subtype

     FSDATSTL0  IF   E           K DISK    INFSR(*PSSR)

      ** System Pulldown Header

     FSDPDWHL2  IF   E           K DISK    INFSR(*PSSR)

      ** System Pulldown Lists

     FSDPDWNL1  IF   E           K DISK    INFSR(*PSSR)

      ** Audit Printer File

     FGL004610AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
     F                                     USROPN

      ** Report Printer File

     FGL004610P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN

      *****************************************************************
     D/COPY ZACPYSRC,PSDS
      *****************************************************************

     D LDA           E DS                  EXTNAME(LDA)

      ** Bank Details

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Branch Details

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** Currrency Details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)

     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** File Information Data Structure for GL004610P1

     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0

      ** File Information Data Structure for GL004610AU

     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0

     D KGroup          S             10A
     D KData           S             20A
     D KHeaderID       S             10P 0
     D PRTCD           S              7A
     D POPTN           S              7A
     D PFLD15          S             15P 0
     D PDECS           S              1P 0
     D PCODE           S              1A
     D POUT21          S             21A
     D PDayNo          S              5P 0
     D PDateN          S              6P 0
     D DDMMMYY         S              7A
     D Pmode           S              1A
     D PSeq            S              5A
     D X_ERMS          S             50A
     D CCY             S              3A
     D WCount          S              5P 0
     D PZSeq           S              5A
     D PZEnty          S              3A
     D PSFile          S             10A
     D PZSNum          S              6P 0
     D PZSErr          S              1A
     D PBrca           S              3A
     D PEntity         S              3A

     D FeeInd          S              1N
     D WRun            S              1N
     D WACOD           S             10A                                                      CRE067
     D WACSQ           S              2A                                                      CRE067
      *****************************************************************
      /SPACE 5
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation                                 ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Process report

     C                   EXSR      SrProcess

      ** Audit Report
     C                   IF        Pmode <> 'H'                                             BUG27398

     C                   EXSR      SrAudit
     C                   ENDIF                                                              BUG27398
      ** End program                                                                        BUG27398
                                                                                            BUG27398
     C                   EVAL      *INLR = *ON                                              BUG27398
     C                   RETURN                                                             BUG27398

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcess  - Subroutine to process the report                *
      *                                                               *
      *****************************************************************
     C     SrProcess     BEGSR

      ** Read account transfer manual input

     C                   IF        PEntity = *BLANKS
     C     *START        SETLL     GLATMIL2
     C                   READ      GLATMIL2
     C                   ELSE
     C     PEntity       SETLL     GLATMIL2
     C     PEntity       READE     GLATMIL2
     C                   ENDIF

     C                   DOW       NOT %EOF(GLATMIL2)

     C                   IF        Pmode <> 'A' OR
     C                             Pmode = 'A' AND
     C                             R1LCDT  = BJRDNB

     C                   EVAL      RCount = RCount + 1

     C                   EXSR      SRGetBrch

      ** Write header record

     C                   IF        NOT %OPEN(GL004610P1)
     C                   OPEN      GL004610P1
     C                   EXSR      SrrcfP1
     C                   WRITE     HEADER
     C                   ENDIF

      ** Populate report fields

     C                   EXSR      SrMoveFields

      ** Write detail record
      ** (include header record to skip to next page if needed)

     C**********         IF        (OflLn1 - PrtLn1) < 21                                   AR688316
     C                   IF        (OflLn1 - PrtLn1) < 24                                   AR688316
     C                   WRITE     HEADER
     C                   ENDIF

     C                   WRITE     DETAIL

      ** Write fee details only if there's a fee present
      ** (include header record to skip to next page if needed)

     C                   IF        FeeInd = *ON

     C**********         IF        (OflLn1 - PrtLn1) < 9                                    MD042785
     C                   IF        (OflLn1 - PrtLn1) < 12                                   MD042785
     C                   WRITE     HEADER
     C                   ENDIF

     C                   WRITE     FEEDETAIL

     C                   ENDIF

     C                   IF        (OflLn1 - PrtLn1) < 2
     C                   WRITE     HEADER
     C                   ENDIF

     C                   WRITE     FOOTER

     C                   ENDIF

     C                   IF        PEntity = *BLANKS
     C                   READ      GLATMIL2
     C                   ELSE
     C     PEntity       READE     GLATMIL2
     C                   ENDIF

     C                   ENDDO

      ** Write trailer record

     C                   IF        %OPEN(GL004610P1)

     C**********         IF        (OflLn1 - PrtLn1) < 3                                    BUG27515
     C                   IF        (OflLn1 - PrtLn1) <= 3                                   BUG27515
     C                   WRITE     HEADER
     C                   ENDIF

     C                   WRITE     Trailer
     C                   CLOSE     GL004610P1
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMoveFields - Move values to report fields                  *
      *                                                               *
      *****************************************************************
     C     SrMoveFields  BEGSR

      ** Branch

     C                   EVAL      R#BRCA  = R1BRCA
     C                   EVAL      R#BRCD  = A8BRNM

      ** Transfer Type

     C                   EVAL      R#TRTY  = R1TRTY
     C                   EXSR      SrTransTypeD
     C                   EVAL      R#TRDS  = %TRIM(GLDESC)

      ** Transfer Sub-type

     C                   EVAL      R#TRST  = R1TRST
     C                   EXSR      SrSubTypeD
     C                   EVAL      R#TRSD  = ATTRSD

      ** Transaction Reference

     C                   EVAL      R#TREF  = R1TREF

      ** Debit Account

     C                   EVAL      R#DBAC  = R1DBBR + R1DBCU + R1DBCY
     C                                + %EDITC(R1DBAC:'X') + %EDITC(R1DBSQ:'X')

      ** Debit Retail Account

     C                   EVAL      R#DACN  = %EDITC(R1DBRE:'X')

      ** Debit Currency

     C                   EVAL      R#DCUR  = R1DBCY

      ** Debit Amount

     C                   EVAL      CCY  =  R1DBCY
     C                   EXSR      SrCurr
     C                   EVAL      PFLD15 = R1DAMT
     C                   EXSR      SrAmount
     C                   EVALR     R#DAMT  = POUT21

      ** Debit Retail Transaction Type

     C                   EVAL      R#DRTT  = R1DRTT

      ** Debit value date (dfference/sign)

     C                   EVAL      R#DRVD  = %EDITC(R1DBVD:'X') + R1DBVS
      ** Debit value date

     C                   EVAL      PDayNo  = R1DRVL
     C                   EXSR      SrDate
     C                   EVAL      R#DDVD  = DDMMMYY

      ** Credit Account

     C                   EVAL      R#CRAC  = R1CRBR + R1CRCU + R1CRCY
     C                                + %EDITC(R1CRAC:'X') + %EDITC(R1CRSQ:'X')

      ** Credit Retail Account

     C                   EVAL      R#CACN  = %EDITC(R1CRRE:'X')

      ** Credit currency

     C                   EVAL      R#CCUR  = R1CRCY

      ** Credit amount

     C                   EVAL      CCY  =  R1CRCY
     C                   EXSR      SrCurr
     C                   EVAL      PFLD15 = R1CAMT
     C                   EXSR      SrAmount
     C                   EVALR     R#CAMT  = POUT21

      ** Credit Retail Transaction Type

     C                   EVAL      R#CRTT  = R1CRTT

      ** Credit Value date (difference/sign)
      ** Credit Value date

     C                   EVAL      R#CRVD  = %EDITC(R1CRVD:'X') + R1CRVS

     C                   EVAL      PDayNo  = R1CRVL
     C                   EXSR      SrDate
     C                   EVAL      R#CRVL  = DDMMMYY

      ** Exchange Rate
      ** Multiply/Divide indicator

     C                   EVALR     R#EXCH  = %EDITC(R1EXCH:'J')
     C                   EVAL      R#MDIN  = R1MDIN

      ** Input Date

     C                   EVAL      PDayNo  = R1INDT
     C                   EXSR      SrDate
     C                   EVAL      R#INDT  = DDMMMYY

      ** Execution Date

     C                   EVAL      PDayNo  = R1EXDT
     C                   EXSR      SrDate
     C                   EVAL      R#EXDT  = DDMMMYY

      ** Cheque Number

     C                   EVAL      R#CHNO  = %EDITC(R1CHNO:'X')

      ** Cheque Account Identifier

     C                   EVAL      R#CHAC  = R1CHBR + R1CHCU + R1CHCY
     C                                + %EDITC(R1CHAC:'X') + %EDITC(R1CHSQ:'X')

      ** Paying Bank

     C**********         EVAL      R#PAYB  = %EDITC(R1PAYB:'X')                             AR845655
     C                   EVAL      R#PYBK  = R1PYBK                                         AR845655

      ** Debit Statement Narrative

     C                   EVAL      R#DBSN  = R1DBSN

      ** Credit Statement Narrative

     C                   EVAL      R#CRSN  = R1CRSN

      ** Statement Extended Narrative 1-6

     C                   EVAL      R#EXT1  = R1EXT1
     C                   EVAL      R#EXT2  = R1EXT2
     C                   EVAL      R#EXT3  = R1EXT3
     C                   EVAL      R#EXT4  = R1EXT4
     C                   EVAL      R#EXT5  = R1EXT5
     C                   EVAL      R#EXT6  = R1EXT6

      ** Reset extended narrative statement indicators
      ** (used by GL004610P1)

     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN36 = *OFF

     C                   IF        R#EXT1  <> *BLANKS
     C                   EVAL      *IN31 = *ON
     C                   ENDIF

     C                   IF        R#EXT2  <> *BLANKS
     C                   EVAL      *IN32 = *ON
     C                   ENDIF

     C                   IF        R#EXT3  <> *BLANKS
     C                   EVAL      *IN33 = *ON
     C                   ENDIF

     C                   IF        R#EXT4  <> *BLANKS
     C                   EVAL      *IN34 = *ON
     C                   ENDIF

     C                   IF        R#EXT5  <> *BLANKS
     C                   EVAL      *IN35 = *ON
     C                   ENDIF

     C                   IF        R#EXT6  <> *BLANKS
     C                   EVAL      *IN36 = *ON
     C                   ENDIF

      ** Fee Details

     C                   EVAL      R#FPAY  = R1FPAY
     C                   EVAL      R#FGRS  = R1FGRS

     C                   EVAL      FeeInd = *OFF

      ** Fee 1

     C                   IF        R1F1CU <> *BLANKS
     C                   EVAL      FeeInd = *ON
     C                   MOVE      R1F1AC        WACOD                                        CRE067
     C                   MOVE      R1F1AS        WACSQ                                        CRE067
     C                   EVAL      R#F1IN  = R1F1BR + R1F1CR +                                CRE067
     C                             R1F1CY + WACOD + WACSQ                                     CRE067
     C                   EVAL      R#F1DS  = ATF1DS
     C                   EVAL      R#F1CU  = R1F1CU

     C                   EVAL      CCY  =  R#F1CU
     C                   EXSR      SrCurr
     C                   EVAL      PFLD15 = R1F1AM
     C                   EXSR      SrAmount
     C                   EVALR     R#F1AM  = POUT21
     C                   ELSE
     C                   EVAL      R#F1IN  = *BLANKS                                          CRE067
     C                   EVAL      R#F1DS  = *BLANKS
     C                   EVAL      R#F1CU  = *BLANKS
     C                   EVAL      R#F1AM  = *BLANKS
     C                   ENDIF

      ** Fee 2

     C                   IF        R1F2CU <> *BLANKS
     C                   EVAL      FeeInd = *ON
     C                   MOVE      R1F2AC        WACOD                                        CRE067
     C                   MOVE      R1F2AS        WACSQ                                        CRE067
     C                   EVAL      R#F2IN  = R1F2BR + R1F2CR +                                CRE067
     C                             R1F2CY + WACOD + WACSQ                                     CRE067
     C                   EVAL      R#F2DS  = ATF2DS
     C                   EVAL      R#F2CU  = R1F2CU

     C                   EVAL      CCY  =  R#F2CU
     C                   EXSR      SrCurr
     C                   EVAL      PFLD15 = R1F2AM
     C                   EXSR      SrAmount
     C                   EVALR     R#F2AM  = POUT21
     C                   ELSE
     C                   EVAL      R#F2IN  = *BLANKS                                          CRE067
     C                   EVAL      R#F2DS  = *BLANKS
     C                   EVAL      R#F2CU  = *BLANKS
     C                   EVAL      R#F2AM  = *BLANKS
     C                   ENDIF

      ** Fee 3

     C                   IF        R1F3CU <> *BLANKS
     C                   EVAL      FeeInd = *ON
     C                   MOVE      R1F3AC        WACOD                                        CRE067
     C                   MOVE      R1F3AS        WACSQ                                        CRE067
     C                   EVAL      R#F3IN  = R1F3BR + R1F3CR +                                CRE067
     C                             R1F3CY + WACOD + WACSQ                                     CRE067
     C                   EVAL      R#F3DS  = ATF3DS
     C                   EVAL      R#F3CU  = R1F3CU

     C                   EVAL      CCY  =  R#F3CU
     C                   EXSR      SrCurr
     C                   EVAL      PFLD15 = R1F3AM
     C                   EXSR      SrAmount
     C                   EVALR     R#F3AM  = POUT21
     C                   ELSE
     C                   EVAL      R#F3IN  = *BLANKS                                          CRE067
     C                   EVAL      R#F3DS  = *BLANKS
     C                   EVAL      R#F3CU  = *BLANKS
     C                   EVAL      R#F3AM  = *BLANKS
     C                   ENDIF

      ** Fee 4

     C                   IF        R1F4CU <> *BLANKS
     C                   EVAL      FeeInd = *ON
     C                   MOVE      R1F4AC        WACOD                                        CRE067
     C                   MOVE      R1F4AS        WACSQ                                        CRE067
     C                   EVAL      R#F4IN  = R1F4BR + R1F4CR +                                CRE067
     C                             R1F4CY + WACOD + WACSQ                                     CRE067
     C                   EVAL      R#F4DS  = ATF4DS
     C                   EVAL      R#F4CU  = R1F4CU

     C                   EVAL      CCY  =  R#F4CU
     C                   EXSR      SrCurr
     C                   EVAL      PFLD15 = R1F4AM
     C                   EXSR      SrAmount
     C                   EVALR     R#F4AM  = POUT21
     C                   ELSE
     C                   EVAL      R#F4IN  = *BLANKS                                          CRE067
     C                   EVAL      R#F4DS  = *BLANKS
     C                   EVAL      R#F4CU  = *BLANKS
     C                   EVAL      R#F4AM  = *BLANKS
     C                   ENDIF

      ** Fee 5

     C                   IF        R1F5CU <> *BLANKS
     C                   EVAL      FeeInd = *ON
     C                   MOVE      R1F5AC        WACOD                                        CRE067
     C                   MOVE      R1F5AS        WACSQ                                        CRE067
     C                   EVAL      R#F5IN  = R1F5BR + R1F5CR +                                CRE067
     C                             R1F5CY + WACOD + WACSQ                                     CRE067
     C                   EVAL      R#F5DS  = ATF5DS
     C                   EVAL      R#F5CU  = R1F5CU

     C                   EVAL      CCY  =  R#F5CU
     C                   EXSR      SrCurr
     C                   EVAL      PFLD15 = R1F5AM
     C                   EXSR      SrAmount
     C                   EVALR     R#F5AM  = POUT21
     C                   ELSE
     C                   EVAL      R#F5IN  = *BLANKS                                          CRE067
     C                   EVAL      R#F5DS  = *BLANKS
     C                   EVAL      R#F5CU  = *BLANKS
     C                   EVAL      R#F5AM  = *BLANKS
     C                   ENDIF

      ** Fee 6

     C                   IF        R1F6CU <> *BLANKS
     C                   EVAL      FeeInd = *ON
     C                   MOVE      R1F6AC        WACOD                                        CRE067
     C                   MOVE      R1F6AS        WACSQ                                        CRE067
     C                   EVAL      R#F6IN  = R1F6BR + R1F6CR +                                CRE067
     C                             R1F6CY + WACOD + WACSQ                                     CRE067
     C                   EVAL      R#F6DS  = ATF6DS
     C                   EVAL      R#F6CU  = R1F6CU

     C                   EVAL      CCY  =  R#F6CU
     C                   EXSR      SrCurr
     C                   EVAL      PFLD15 = R1F6AM
     C                   EXSR      SrAmount
     C                   EVALR     R#F6AM  = POUT21
     C                   ELSE
     C                   EVAL      R#F6IN  = *BLANKS                                          CRE067
     C                   EVAL      R#F6DS  = *BLANKS
     C                   EVAL      R#F6CU  = *BLANKS
     C                   EVAL      R#F6AM  = *BLANKS
     C                   ENDIF

      ** Last Change Type

     C                   SELECT

     C                   WHEN      R1CHTP  = 'I'
     C                   EVAL      R#CHTP  = 'INSERT'
     C                   EVAL      RINSRT  = RINSRT + 1

     C                   WHEN      R1CHTP  = 'A'
     C                   EVAL      R#CHTP  = 'AMEND'
     C                   EVAL      RAMEND  = RAMEND + 1

     C                   WHEN      R1CHTP  = 'D'
     C                   EVAL      R#CHTP  = 'DELETE'
     C                   EVAL      RDELET  = RDELET + 1

     C                   ENDSL

      ** Last Change Date

     C                   EVAL      PDayNo  = R1LCDT
     C                   EXSR      SrDate
     C                   EVAL      R#LCDT  = DDMMMYY

      ** Input User

     C                   EVAL      R#USER  = R1USER

      ** Amend User

     C                   EVAL      R#APRV  = R1APRV

      ** Authorised by

     C                   EVAL      R#AUTH  = R1AUTH

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTransTypeD - Get Account transfer type description         *
      *                                                               *
      *****************************************************************
     C     SrTransTypeD  BEGSR

     C                   EVAL      KGroup = 'ATTYPE'

     C     KGroup        CHAIN     SDPDWHL2

     C                   IF        NOT %FOUND(SDPDWHL2)
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 3
     C                   EVAL      DBFILE = 'SDPDWHL2'
     C                   EVAL      DBKEY  = KGroup
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      KHeaderID = GHHIND
     C                   EVAL      KData     = R1TRTY

     C     K_SDPDWNL1    CHAIN     SDPDWNL1

     C                   IF        NOT %FOUND(SDPDWNL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 4
     C                   EVAL      DBFILE = 'SDPDWNL1'
     C                   EVAL      DBKEY  = %EDITC(GHHIND:'X') + R1TRTY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSubTypeD  -  Get Account transfer subtype description      *
      *                                                               *
      *****************************************************************
     C     SrSubTypeD    BEGSR

     C     K_SDATSTL0    CHAIN     SDATSTL0

     C                   IF        NOT %FOUND(SDATSTL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 5
     C                   EVAL      DBFILE = 'SDATSTL0'
     C                   EVAL      DBKEY  = R1TRTY + R1TRST
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCurr   - Subroutine to get currency details                *
      *                                                               *
      *****************************************************************
     C     SrCurr        BEGSR

      ** Retrieve decimal positions for given currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    CCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 6
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = CCY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAmount - Subroutine to convert amount from number format   *
      *             to reporting format                               *
      *                                                               *
      *****************************************************************
     C     SrAmount      BEGSR

     C                   CALL      'ZSEDIT'
     C                   PARM                    PFLD15
     C                   PARM      A6NBDP        PDECS
     C                   PARM      'J'           PCODE
     C                   PARM      *BLANKS       POUT21

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDate   - Subroutine to convert midas day number to DDMMMYY *
      *             format                                            *
      *                                                               *
      *****************************************************************
     C     SrDate        BEGSR

     C                   CALL      'ZDATE2'
     C                   PARM                    PDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateN
     C                   PARM      *BLANKS       DDMMMYY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrrcfP1 -  Register P1 Printer file for RCF processing       *
      *                                                               *
      *****************************************************************
     C     SrrcfP1       BEGSR

     C                   EVAL      PZSNum = PSFNum1
     C                   EVAL      PSFile = PSFile1

     C                   CALL      'ZSFILE'
     C                   PARM                    PZSeq
     C                   PARM                    PZEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANKS       PZSErr

      ** If error occurs during ZSFILE processing, then end abnormally

     C                   IF        PZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRcfAu  - Register AU Printer file for RCF processing       *
      *                                                               *
      *****************************************************************
     C     SRRcfAu       BEGSR

      ** Ensure Audit Spool File recorded by RCF.

     C                   EVAL      PZSNum = PSFNumU
     C                   EVAL      PSFile = PSFileU

     C                   CALL      'ZSFILE'
     C                   PARM                    PZSeq
     C                   PARM                    PZEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANKS       PZSErr

      ** If error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C                   IF        PZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetBrch - Get Branch Details                               *
      *                                                               *
      *****************************************************************
     C     SRGetBrch     BEGSR

      ** Call Access Program for Branch Details.

     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      R1BRCA        PBrca
     C     SDBRCH        PARM      SDBRCH        DSSDY

      ** Handle Database Error.

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBrca
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAudit  - Output Audit Report                               *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR

     C                   OPEN      GL004610AU

     C                   EXSR      SRRcfAu

      ** Output Report Header and File Controls

     C                   WRITE     HEADAU

      ** If there is a DB Error, Output the DB Error Information.

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE

      ** Or, if no records read, Output "No Details" message.

     C                   IF        RCount = *ZERO
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     CONTROL
     C                   ENDIF

     C                   ENDIF

     C                   WRITE     ENDRPT

     C                   CLOSE     GL004610AU

      ** End program

     C**********         EVAL      *INLR = *ON                                              BUG27398
     C**********         RETURN                                                             BUG27398

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR   - Program Initialisation Routine                    *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    Pmode
     C                   PARM                    PSeq
     C                   PARM                    PEntity

     C     K_SDATSTL0    KLIST
     C                   KFLD                    R1TRTY
     C                   KFLD                    R1TRST

     C     K_SDPDWNL1    KLIST
     C                   KFLD                    KHeaderID
     C                   KFLD                    KData

     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = *ZERO
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBPGM  = 'GL004610'
     C                   OUT       LDA

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set on appropriate report title indicator

     C                   SELECT
     C                   WHEN      Pmode = 'L'
     C                   EVAL      *IN02 = *ON
     C                   WHEN      Pmode = 'H'
     C                   EVAL      *IN03 = *ON
     C                   OTHER
     C                   EVAL      *IN01 = *ON
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR    - Error handling Routine                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

      ** Set on error indicators

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON


      ** Execute dump/sraudit once only to prevent looping of *PSSR

     C                   IF        WRun = *OFF
     C                   EVAL      WRun = *ON
     C                   DUMP
     C                   EXSR      SrAudit
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
