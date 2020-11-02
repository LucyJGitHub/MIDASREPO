     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Proj Insufficient Funds Report')              *
      *****************************************************************
      *                                                               *
      *  Midas - Retail module                                        *
      *                                                               *
      *  RE004244 - Projected Insufficient Funds Report               *
      *                                                               *
      *  Function:  This module will produce a report automatically   *
      *             in close of business showing details of all       *
      *             Proj Insufficient Funds where                     *
      *             1.) All accounts with negative (DR) balance on    *
      *                 any of the forward dates within the balance   *
      *                 reporting period (including today) with       *
      *                 posting within this period.                   *
      *             2.) Any accounts which have a forward posting but *
      *                 which are blocked for the sign of the posting,*
      *                 are inactive, have bad debt, are liquidated,  *
      *                 or are referred for the sign of the posting.  *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1005246          Date 30Jul12               *
      *                 AR737480A          Date 03Jun11               *
      *                 AR737480           Date 28Mar11               *
      *                 CAP207   *CREATE   Date 10Feb11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1005246 - Program RE004244AU receiver too small to hold    *
      *              result.                                          *
/*    *  AR737480A - REC0004243 00001                                 *
/*    *  AR737480 - REC0004243 00001 (Child: AR737476)                *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7 + U8    Error Occured                                   *
      *    LR         End Pgm                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrGenRep - Generate Projected Insufficient Funds Report      *
      *  SrSubHdrs - Process sub-headers                              *
      *  SrDetails - Process details                                  *
      *  SrWrtDtl - Write detail                                      *
      *  SrAuditRept - Generate Audit Report                          *
      *  SrEndPgm - End of the program                                *
      *  SrOpenP1 - Open printer file 1, RE004244P1                   *
      *  SrOpenAU - Open printer file, RE004244AU                     *
      *  SrGetSum - Get summary for Referred, Blocked, Inactive, etc. *
      *  SrZSEdit  - Convert amount from file format to screen format *
      *  SrZDate2 - Convert date from file format to screen format    *
      *  SrCurr - Get Currency Details                                *
      *  *PSSR   - Error processing                                   *
      *  *INZSR  - Initialise                                         *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FREPINFL0  IF   E           K Disk    InfSr(*PSSR)
      ** Midas RE REPINFPD by: BRCH/CUST/CURR/ACCT/SEQ

     FRSACMTL8  IF   E           K Disk    InfSr(*PSSR)
     F                                     Prefix(X_)
      ** Midas GL Account Movements by account/value date

     FRE004244P1O    E             Printer InfSr(*PSSR)
     F                                     InfDs(SPOOL1)
     F                                     UsrOpn
      ** PRT: Midas RE Projected Insufficient Funds Report

     FRE004244AUO    E             Printer InfSr(*PSSR)
     F                                     InfDs(SPOOLU)
     F                                     UsrOpn
      ** PRT: Midas RE Projected Insufficient Funds Audit Report

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

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

      ** File Information Data Structure for RE004244P1
     D SPOOL1          DS
     D  PsFile1               83     92
     D  PsFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0

      ** File Information Data Structure for RE004244AU
     D SPOOLU          DS
     D  PsFileU               83     92
     D  PsFNumU              123    124B 0
     D  PsFPleU              152    153B 0
     D  OflLnU               188    189B 0
     D  PrtLnU               367    368B 0

      ** DS for Access Programs: Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** DS for Access Programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External Data Structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Currency Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Format amount
     D                 DS
     D WCAmt                   1     21
     D  WAmt                   1     19
     D  WDrCr                 20     21

      ** Total reservation amount
     D                 DS
     D WCmpRsvAmt              1     25
     D  WRsvDrCr              23     25

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameters for Access Objects
     D PRtcd           S              7
     D POptn           S              7
     D PBrca           S              3
     D PCcy            S              3

      ** ZSEDIT fields
     D PzFld15         S             15  0
     D PzDecs          S              1  0
     D PzECode         S              1
     D PzOut21         S             21

      ** ZDATE2 fields
     D PzDayNo         S              5  0
     D PzDatFm         S              1
     D PzDate          S              6  0
     D PzADate         S              7

      ** Parameters for ZSFILE
     D PSeq            S              5
     D PsEnty          S              3
     D PsFile          S             10
     D PzSnum          S              6  0
     D PzSnumU         S              6  0
     D PzSerr          S              1

      ** Printer line counters
     D RqdLn1          S              3P 0
     D DIfLn1          S              4P 0

     D WRun            S              1
     D***WRecordCount    S              5  0                                               AR1005246
     D WRecordCount    S             10  0                                                 AR1005246
     D WReason         S             30
     D WLstDatPst      S                   LIKE(REDAT1)
     D WBRCA           S                   LIKE(X_BRCA)
     D WCUSN           S                   LIKE(X_CUSN)
     D WCCYD           S                   LIKE(X_CCYD)
     D WACDE           S                   LIKE(X_ACDE)
     D WASNC           S                   LIKE(X_ASNC)
     D WVUDT           S                   LIKE(X_VUDT)

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Report generation
     C                   EXSR      SrGenRep

      ** End program
     C                   EXSR      SrEndPgm

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGenRep - Generate Projected Insufficient Funds Report      *
      *                                                               *
      *****************************************************************

     C     SrGenRep      BEGSR

     C                   EXSR      SrOpenP1

      ** Report Header
     C                   WRITE     RE004244H1

      ** Read through all records in REPINFL0
     C     *Loval        SETLL     REPINFL0
     C                   READ      REPINFL0

     C                   DOW       Not %Eof

      ** Record Counter
     C                   EVAL      WRecordCount = WRecordCount + 1

      ** Write header if end of page
     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DIfLn1 = OflLn1 - PrtLn1
     C                   IF        DIfLn1 <= RqdLn1
     C                   WRITE     RE004244H1
     C                   ENDIF

      ** Get currency information
     C                   EVAL      PCcy = CCY
     C                   EXSR      SrCurr

      ** Process Sub-Headers
     C                   EXSR      SrSubHdrs
     C
      ** Process Details
     C                   EVAL      WBRCA = BRCA
     C                   EVAL      WCUSN = CNUM
     C                   EVAL      WCCYD = CCY
     C                   EVAL      WACDE = ACOD
     C                   EVAL      WASNC = ACSQ
     C                   EVAL      WVUDT = 0
     C                   EXSR      SrDetails

     C                   READ      REPINFL0
     C                   ENDDO

      ** Report footer
     C                   EVAL      RqdLn1 = 4                                              AR737480A
     C                   EVAL      DIfLn1 = OflLn1 - PrtLn1                                AR737480A
     C                   IF        DIfLn1 <= RqdLn1                                        AR737480A
     C                   WRITE     RE004244H1                                              AR737480A
     C                   ENDIF                                                             AR737480A
     C                   WRITE     RE004244F1

      ** Audit Report
     C                   EXSR      SrOpenAU
     C                   EXSR      SrAuditRept

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSubHdrs - Process sub-headers                              *
      *                                                               *
      *****************************************************************

     C     SrSubHdrs     BEGSR

      ** Write header if end of page
     C**********         EVAL      RqdLn1 = 12                                              AR737480
     C                   EVAL      RqdLn1 = 17                                              AR737480
     C                   EVAL      DIfLn1 = OflLn1 - PrtLn1
     C                   IF        DIfLn1 <= RqdLn1
     C                   WRITE     RE004244H1
     C                   ENDIF

      ** Sub-Header 1

      ** Account
     C                   EVAL      R1ACCT = %Trim(BRCA) + ' ' +
     C                                      %Trim(CNUM) + ' ' +
     C                                      %Trim(CCY)  + ' ' +
     C                                      %EditC(ACOD:'X') + ' ' +
     C                                      %EditC(ACSQ:'X')

      ** Reported Reason
     C                   EVAL      R1RESN = RERSN1
     C                   EVAL      WReason = R1RESN
     C                   EXSR      SrGetSum

      ** Account Balance Check
     C                   IF        REABCR = 'Y'
     C                   EVAL      R1ABCR = 'Yes'
     C                   ELSE
     C                   EVAL      R1ABCR = 'No'
     C                   ENDIF

     C                   WRITE     RE004244H2

      ** Sub-Header 2

      ** Write header if end of page
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DIfLn1 = OflLn1 - PrtLn1
     C                   IF        DIfLn1 <= RqdLn1
     C                   WRITE     RE004244H1
     C                   ENDIF

      ** Other Reported Reason
     C                   IF        RERSN2 <> *Blanks
     C                   EVAL      R2RESN = RERSN2
     C                   EVAL      WReason = R2RESN
     C                   EXSR      SrGetSum
     C                   WRITE     RE004244H3
     C                   ENDIF

     C                   IF        RERSN3 <> *Blanks
     C                   EVAL      R2RESN = RERSN3
     C                   EVAL      WReason = R2RESN
     C                   EXSR      SrGetSum
     C                   WRITE     RE004244H3
     C                   ENDIF

     C                   IF        RERSN4 <> *Blanks
     C                   EVAL      R2RESN = RERSN4
     C                   EVAL      WReason = R2RESN
     C                   EXSR      SrGetSum
     C                   WRITE     RE004244H3
     C                   ENDIF

     C                   IF        RERSN5 <> *Blanks
     C                   EVAL      R2RESN = RERSN5
     C                   EVAL      WReason = R2RESN
     C                   EXSR      SrGetSum
     C                   WRITE     RE004244H3
     C                   ENDIF

     C                   IF        RERSN6 <> *Blanks
     C                   EVAL      R2RESN = RERSN6
     C                   EVAL      WReason = R2RESN
     C                   EXSR      SrGetSum
     C                   WRITE     RE004244H3
     C                   ENDIF

      ** Sub-Header 3

      ** Write header if end of page
     C**********         EVAL      RqdLn1 = 10                                              AR737480
     C                   EVAL      RqdLn1 = 15                                              AR737480
     C                   EVAL      DIfLn1 = OflLn1 - PrtLn1
     C                   IF        DIfLn1 <= RqdLn1
     C                   WRITE     RE004244H1
     C                   ENDIF

      ** Ledger Balance
     C                   EVAL      PzFld15 = LDBL
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   IF        LDBL > 0
     C                   EVAL      WDrCr = 'DR'
     C                   ELSE
     C                   EVAL      WCAmt = %Subst(WCAmt:1:18)
     C                   IF        LDBL <> 0
     C                   EVAL      WDrCr = 'CR'
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WCAmt         R3LDBL

      ** Cleared Balance
     C                   EVAL      PzFld15 = CLBL
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   IF        CLBL > 0
     C                   EVAL      WDrCr = 'DR'
     C                   ELSE
     C                   EVAL      WCAmt = %Subst(WCAmt:1:18)
     C                   IF        CLBL <> 0
     C                   EVAL      WDrCr = 'CR'
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WCAmt         R3CLBL

     C                   EVAL      WDrCr = *Blanks
      ** Overdraft Line
     C                   EVAL      PzFld15 = ODLN
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   MOVE      WCAmt         R3ODLN

      ** Overdraft Tolerance
     C                   EVAL      PzFld15 = RETOLR
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   MOVE      WCAmt         R3TOLR

      ** Total Reservations (No conversion done)
     C                   EVAL      WCmpRsvAmt = %EditC(RERESV:'J')
     C                   IF        WCmpRsvAmt = '                   .00000'
     C                   MOVE      '0.00   '     WCmpRsvAmt
     C                   ENDIF
     C                   EVAL      WRsvDrCr = '   '
     C                   MOVE      WCmpRsvAmt    R3RESV

      ** Total Blocked Collateral
     C                   EVAL      PzFld15 = RETOBC
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   MOVE      WCAmt         R3TOBC

      ** Total Hard Held Items
     C                   EVAL      PzFld15 = RETOHH
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   MOVE      WCAmt         R3TOHH

      ** Total Soft Held Items
     C                   EVAL      PzFld15 = RETOSH
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   MOVE      WCAmt         R3TOSH

      ** Balances (Dates and Amounts)

      ** Balance (Date1 and Amount1)
     C                   IF        REDAT1 <> 0
     C                   EVAL      PzFld15 = REAVA1
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   IF        REAVA1 > 0
     C                   EVAL      WDrCr = 'DR'
     C                   ELSE
     C                   EVAL      WCAmt = %Subst(WCAmt:1:18)
     C                   IF        REAVA1 <> 0
     C                   EVAL      WDrCr = 'CR'
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WCAmt         R3AVA1

     C                   EVAL      PzDayNo = REDAT1
     C                   EVAL      PzDatFm = 'D'
     C                   EVAL      PzDate  = *Zero
     C                   EVAL      PzADate = *Blanks
     C                   EXSR      SRZDate2
     C                   EVAL      R3DAT1 = PzADate
     C                   ENDIF

      ** Balance (Date2 and Amount2)
     C                   IF        REDAT2 <> 0
     C                   EVAL      PzFld15 = REAVA2
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   IF        REAVA2 > 0
     C                   EVAL      WDrCr = 'DR'
     C                   ELSE
     C                   EVAL      WCAmt = %Subst(WCAmt:1:18)
     C                   IF        REAVA2 <> 0
     C                   EVAL      WDrCr = 'CR'
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WCAmt         R3AVA2

     C                   EVAL      PzDayNo = REDAT2
     C                   EVAL      PzDatFm = 'D'
     C                   EVAL      PzDate  = *Zero
     C                   EVAL      PzADate = *Blanks
     C                   EXSR      SRZDate2
     C                   EVAL      R3DAT2 = PzADate
     C                   ENDIF

      ** Balance (Date3 and Amount3)
     C                   IF        REDAT3 <> 0
     C                   EVAL      PzFld15 = REAVA3
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   IF        REAVA3 > 0
     C                   EVAL      WDrCr = 'DR'
     C                   ELSE
     C                   EVAL      WCAmt = %Subst(WCAmt:1:18)
     C                   IF        REAVA3 <> 0
     C                   EVAL      WDrCr = 'CR'
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WCAmt         R3AVA3

     C                   EVAL      PzDayNo = REDAT3
     C                   EVAL      PzDatFm = 'D'
     C                   EVAL      PzDate  = *Zero
     C                   EVAL      PzADate = *Blanks
     C                   EXSR      SRZDate2
     C                   EVAL      R3DAT3 = PzADate
     C                   ENDIF

      ** Balance (Date4 and Amount4)
     C                   IF        REDAT4 <> 0
     C                   EVAL      PzFld15 = REAVA4
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   IF        REAVA4 > 0
     C                   EVAL      WDrCr = 'DR'
     C                   ELSE
     C                   EVAL      WCAmt = %Subst(WCAmt:1:18)
     C                   IF        REAVA4 <> 0
     C                   EVAL      WDrCr = 'CR'
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WCAmt         R3AVA4

     C                   EVAL      PzDayNo = REDAT4
     C                   EVAL      PzDatFm = 'D'
     C                   EVAL      PzDate  = *Zero
     C                   EVAL      PzADate = *Blanks
     C                   EXSR      SRZDate2
     C                   EVAL      R3DAT4 = PzADate
     C                   ENDIF

      ** Balance (Date5 and Amount5)
     C                   IF        REDAT5 <> 0
     C                   EVAL      PzFld15 = REAVA5
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   IF        REAVA5 > 0
     C                   EVAL      WDrCr = 'DR'
     C                   ELSE
     C                   EVAL      WCAmt = %Subst(WCAmt:1:18)
     C                   IF        REAVA5 <> 0
     C                   EVAL      WDrCr = 'CR'
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WCAmt         R3AVA5

     C                   EVAL      PzDayNo = REDAT5
     C                   EVAL      PzDatFm = 'D'
     C                   EVAL      PzDate  = *Zero
     C                   EVAL      PzADate = *Blanks
     C                   EXSR      SRZDate2
     C                   EVAL      R3DAT5 = PzADate
     C                   ENDIF

      ** Balance (Date6 and Amount6)
     C                   IF        REDAT6 <> 0
     C                   EVAL      PzFld15 = REAVA6
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   IF        REAVA6 > 0
     C                   EVAL      WDrCr = 'DR'
     C                   ELSE
     C                   EVAL      WCAmt = %Subst(WCAmt:1:18)
     C                   IF        REAVA6 <> 0
     C                   EVAL      WDrCr = 'CR'
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WCAmt         R3AVA6

     C                   EVAL      PzDayNo = REDAT6
     C                   EVAL      PzDatFm = 'D'
     C                   EVAL      PzDate  = *Zero
     C                   EVAL      PzADate = *Blanks
     C                   EXSR      SRZDate2
     C                   EVAL      R3DAT6 = PzADate
     C                   ENDIF

      ** Balance (Date7 and Amount7)
     C                   IF        REDAT7 <> 0
     C                   EVAL      PzFld15 = REAVA7
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   IF        REAVA7 > 0
     C                   EVAL      WDrCr = 'DR'
     C                   ELSE
     C                   EVAL      WCAmt = %Subst(WCAmt:1:18)
     C                   IF        REAVA7 <> 0
     C                   EVAL      WDrCr = 'CR'
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WCAmt         R3AVA7

     C                   EVAL      PzDayNo = REDAT7
     C                   EVAL      PzDatFm = 'D'
     C                   EVAL      PzDate  = *Zero
     C                   EVAL      PzADate = *Blanks
     C                   EXSR      SRZDate2
     C                   EVAL      R3DAT7 = PzADate
     C                   ENDIF

      ** Balance (Date8 and Amount8)
     C                   IF        REDAT8 <> 0
     C                   EVAL      PzFld15 = REAVA8
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   IF        REAVA8 > 0
     C                   EVAL      WDrCr = 'DR'
     C                   ELSE
     C                   EVAL      WCAmt = %Subst(WCAmt:1:18)
     C                   IF        REAVA8 <> 0
     C                   EVAL      WDrCr = 'CR'
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WCAmt         R3AVA8

     C                   EVAL      PzDayNo = REDAT8
     C                   EVAL      PzDatFm = 'D'
     C                   EVAL      PzDate  = *Zero
     C                   EVAL      PzADate = *Blanks
     C                   EXSR      SRZDate2
     C                   EVAL      R3DAT8 = PzADate
     C                   ENDIF

      ** Balance (Date9 and Amount9)
     C                   IF        REDAT9 <> 0
     C                   EVAL      PzFld15 = REAVA9
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt
     C                   IF        REAVA9 > 0
     C                   EVAL      WDrCr = 'DR'
     C                   ELSE
     C                   EVAL      WCAmt = %Subst(WCAmt:1:18)
     C                   IF        REAVA9 <> 0
     C                   EVAL      WDrCr = 'CR'
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WCAmt         R3AVA9

     C                   EVAL      PzDayNo = REDAT9
     C                   EVAL      PzDatFm = 'D'
     C                   EVAL      PzDate  = *Zero
     C                   EVAL      PzADate = *Blanks
     C                   EXSR      SRZDate2
     C                   EVAL      R3DAT9 = PzADate
     C                   ENDIF

     C                   WRITE     RE004244H4

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDetails - Process details                                  *
      *                                                               *
      *****************************************************************

     C     SrDetails     BEGSR

      ** Get the last date
     C                   SELECT
     C                   WHEN      REDAT9 <> 0
     C                   EVAL      WLstDatPst = REDAT9
     C                   WHEN      REDAT8 <> 0
     C                   EVAL      WLstDatPst = REDAT8
     C                   WHEN      REDAT7 <> 0
     C                   EVAL      WLstDatPst = REDAT7
     C                   WHEN      REDAT6 <> 0
     C                   EVAL      WLstDatPst = REDAT6
     C                   WHEN      REDAT5 <> 0
     C                   EVAL      WLstDatPst = REDAT5
     C                   WHEN      REDAT4 <> 0
     C                   EVAL      WLstDatPst = REDAT4
     C                   WHEN      REDAT3 <> 0
     C                   EVAL      WLstDatPst = REDAT3
     C                   WHEN      REDAT2 <> 0
     C                   EVAL      WLstDatPst = REDAT2
     C                   OTHER
     C                   EVAL      WLstDatPst = REDAT1
     C                   ENDSL

     C     kRSAC         SETLL     RSACMTL8
     C                   READ      RSACMTL8
     C                   DOW       Not %Eof

     C                   IF        WBRCA <> X_BRCA or WCUSN <> X_CUSN or
     C                             WCCYD <> X_CCYD or WACDE <> X_ACDE or
     C                             WASNC <> X_ASNC
     C                   LEAVE
     C                   ENDIF

     C                   IF        (X_VUDT >= REDAT1 and X_VUDT <= WLstDatPst)

      ** Write header if end of page
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DIfLn1 = OflLn1 - PrtLn1
     C                   IF        DIfLn1 <= RqdLn1
     C                   WRITE     RE004244H1
     C                   ENDIF

     C                   EXSR      SrWrtDtl
     C                   ENDIF

     C                   READ      RSACMTL8
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWrtDtl - Write detail                                      *
      *                                                               *
      *****************************************************************

     C     SrWrtDtl      BEGSR

      ** Value Date
     C                   EVAL      PzDayNo = X_VUDT
     C                   EVAL      PzDatFm = 'D'
     C                   EVAL      PzDate  = *Zero
     C                   EVAL      PzADate = *Blanks
     C                   EXSR      SRZDate2
     C                   EVAL      R4VUDT = PzADate

      ** Posting Date
     C                   EVAL      PzDayNo = X_PTDT
     C                   EVAL      PzDatFm = 'D'
     C                   EVAL      PzDate  = *Zero
     C                   EVAL      PzADate = *Blanks
     C                   EXSR      SRZDate2
     C                   EVAL      R4PTDT = PzADate

      ** Posting Amount
     C                   EVAL      PzFld15 = X_MVAM
     C                   EVAL      PzDecs = A6NBDP
     C                   EVAL      PzECode = 'J'
     C                   EXSR      SrZSEdit
     C                   MOVE      PzOut21       WAmt

      ** 0 = Debit 1 = Credit
     C                   IF        X_DORC = 0
     C                   EVAL      WDrCr = 'DR'
     C                   ELSE
     C                   EVAL      WDrCr = 'CR'
     C                   ENDIF

     C                   MOVE      WCAmt         R4MVAM

      ** Posting Narrative
     C                   EVAL      R4NRTD = X_NRTD

     C                   WRITE     RE004244D1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAuditRept - Generate Audit Report                           *
      *                                                               *
      *****************************************************************
     C     SrAuditRept   BEGSR

      ** Output audit heading
     C                   WRITE     HEADAU

      ** Output audit detail
     C                   IF        *InU7 = *Off AND
     C                             *InU8 = *Off
     C                   IF        WRecordCount <> 0
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ELSE
     C                   WRITE     DBERROR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetSum - Get summary for Referred, Blocked, Inactive, etc. *
      *                                                               *
      *****************************************************************

     C     SrGetSum      BEGSR

     C                   SELECT

      ** Negative Balance
     C                   WHEN      WReason = 'Negative Balance'
     C                   EVAL      RNGCNT = RNGCNT + 1

      ** Referred
     C                   WHEN      WReason = 'Referred'
     C                   EVAL      RRFCNT = RRFCNT + 1

      ** Blocked
     C                   WHEN      WReason = 'Blocked'
     C                   EVAL      RBKCNT = RBKCNT + 1

      ** Inactive
     C                   WHEN      WReason = 'Inactive'
     C                   EVAL      RINCNT = RINCNT + 1

      ** Liquidated
     C                   WHEN      WReason = 'Liquidated'
     C                   EVAL      RLQCNT = RLQCNT + 1

      ** Bad Debt
     C                   WHEN      WReason = 'Bad Debt'
     C                   EVAL      RBDCNT = RBDCNT + 1

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrOpenP1 - Open printer file 1, RE004244P1                   *
      *                                                               *
      *****************************************************************

     C     SrOpenP1      BEGSR

     C                   IF        Not %Open(RE004244P1)
     C                   OPEN      RE004244P1

      ** Projected Insufficient Funds Report
     C                   EVAL      PsFile = PsFile1
     C                   EVAL      PzSnum = PsFNum1

      ** Ensure Detail Spool File recorded by RCF

     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSeq
     C                   PARM      *BLANKS       PsEnty
     C                   PARM                    PsFile
     C                   PARM                    PzSnum
     C                   PARM      *Blanks       PzSerr

     C                   IF        PzSerr = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZSFILE'
     C                   EVAL      DBKEY  =  'RE004244P1'
     C                   EVAL      DBASE  =  3
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrOpenAU - Open printer file, RE004244AU                     *
      *                                                               *
      *****************************************************************

     C     SrOpenAU      BEGSR

     C                   IF        Not %Open(RE004244AU)
     C                   OPEN      RE004244AU

      ** Audit Report
     C                   EVAL      PsFile = PsFileU
     C                   EVAL      PzSnum = PsFNumU

      ** Ensure Detail Spool File recorded by RCF

     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSeq
     C                   PARM      *BLANKS       PsEnty
     C                   PARM                    PsFile
     C                   PARM                    PzSnum
     C                   PARM      *Blanks       PzSerr

     C                   IF        PzSerr = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZSFILE'
     C                   EVAL      DBKEY  =  'RE004244AU'
     C                   EVAL      DBPGM  =  'RE004244'
     C                   EVAL      DBASE  =  4
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrZSEdit  - Convert amount from file format to screen format  *
      *                                                               *
      *****************************************************************

     C     SrZSEdit      BEGSR

     C                   CALL      'ZSEDIT'
     C                   PARM                    PzFld15
     C                   PARM                    PzDecs
     C                   PARM                    PzECode
     C                   PARM                    PzOut21

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrZDate2 - Convert date from file format to screen format     *
      *                                                               *
      *****************************************************************

     C     SrZDate2      BEGSR

     C                   CALL      'ZDATE2'
     C                   PARM                    PzDayNo
     C                   PARM                    PzDatFm
     C                   PARM                    PzDate
     C                   PARM                    PzADate

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCurr - Get Currency Details                                *
      *                                                               *
      *****************************************************************

     C     SrCurr        BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCcy
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrEndPgm - End of the program                                *
      *                                                               *
      *****************************************************************

     C     SrEndPgm      BEGSR

     C                   EVAL      *InLR = *On
     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * CALLed by: Implicitly on program activation                   *
      *                                                               *
      * CALLs: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C/COPY ZACPYSRC,DBFIELDS

      ** Keys for RSACMTL8
     C     kRSAC         KLIST
     C                   KFLD                    WBRCA
     C                   KFLD                    WCUSN
     C                   KFLD                    WCCYD
     C                   KFLD                    WACDE
     C                   KFLD                    WASNC
     C                   KFLD                    WVUDT

      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 1
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**CALLing routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'

     C                   CALL      'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
**  CPY@
(c) Finastra International Limited 2011
