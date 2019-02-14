     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas LE Retrieve Available Balance')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000476 - Midas LE Retrieve Available Balance               *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD048216           Date 30Oct17               *
      *  Prev Amend No. MD036674           Date 26Nov15               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 MD032020           Date 23Jan15               *
      *                 MD031853           Date 18Jan15               *
      *                 MD027718           Date 23Sep14               *
      *                 CLE164 *CREATE     Date 18Aug14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD048216 - Fee- system in COB did not see the Credit account *
      *               at the time of processing and created PDCL ZZ   *
      *  MD036674 - CLE164 Downgrade Performance issues               *
      *           - Applied for MD-48954                              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD032020 - LE000496P1 report cleared balance is not equal    *
      *             to PAMV                                           *
      *  MD031853 - Report LE000496 same retail account was shown     *
      *             thrice with different balances                    *
      *  MD027718 - MRs for OL should be processed with PDCL loans    *
      *            to have correct split narratives on LEC000471A     *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *                                                               *
      *****************************************************************

     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account details - full a/c number
      *
     FACCNTL3   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCNTABK)
     F                                     PREFIX(K_)
     FACCNTBY0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account details - full a/c number - extension file
      *
      ** Midas GL Account details - full a/c number
      *
     FGLACBTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Balances Today
      *
     FGLACNTL3  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Extension File
      *
     FGLGESTL3  IF   E           K DISK    PREFIX(ST)
     F                                     INFSR(*PSSR)
      ** Midas GL Stamp Tax Average Balance Postings
      *
     FCLOANL3   IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Loans by facility for history takeon
      *
     FGLACPML0  IF   F  620    24AIDISK    KEYLOC(2)
     F                                     INFSR(*PSSR)
      ** Midas GL Accounts postings
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Key Fields
      *
     D KCNUM           S                   LIKE(CNUM)
     D KCCY            S                   LIKE(CCY)
     D KACOD           S                   LIKE(ACOD)
     D KACSQ           S                   LIKE(ACSQ)
     D KBRCA           S                   LIKE(BRCA)
      *
     D KACPO1          S             24    INZ
      *
      ** Passed Parameters
      *
     D P@CNUM          S              6
     D P@SCCY          S              3
     D P@BRCA          S              3
     D P@ACOD          S             10S 0
     D P@ACSQ          S              2S 0
      *
     D P@RTCE          S              1
     D P@BLBF          S             15P 0
     D P@BLAF          S             15P 0
     D P@OVLN          S             15P 0
     D P@CLBL          S             15P 0
     D P@COLL          S             15P 0
     D P@OVTL          S             15P 0
     D P@ACNO          S             10S 0
     D P@HELD          S             15P 0
     D P@RETB          S              1A
      *
     D MPHAS           DS             1
     D  DSPHASE                1      1
      *
     D DSAPOST       E DS                  EXTNAME(APOSTPD)
     D                                     PREFIX(AP)
      *
      **  Data Structure for AOSVALR0 string
      *
     DSVAL1            DS           200
     DSVAL11                   1      1
      *
     D SVALKK          C                   CONST('PDCLBlockDebit')
      *
      ** External Definitions
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
     D/COPY ZACPYSRC,PSDS
      *
     D/COPY ZACPYSRC,PROCPARMS
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data Structure for Bank Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  SAR Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  External data structures for Currency Details
      *
      ** Work Variables
     D                 DS
     D DSACOD0                       10S 0
     D  DSACOD                       10    OVERLAY(DSACOD0)
     D DSACSQ0                        2S 0
     D  DSACSQ                        2    OVERLAY(DSACSQ0)
      *
      ** Additional Field Definitions
     D @ACNT           S             21
     D @SCCY           S              3
     D @BRCA           S              3
     D @SMAM           S             13  0
     D @SDAT           S              5  0
     D @RTCE           S              1
     D @INCL           S              1
     D @BLBF           S             15  0
     D @BLAF           S             15  0
     D SEFACT          S              5  0
     D W@RETB          S                   LIKE(RETB)
     D P@C205          S              1
     D P@ABCF          S              1
      *
     D PCCY            S              3
     D Adjust          s             15p 0 inz(*blanks)                                     MD027718
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     I***ACPO1     NS
     IGLACPML0  NS
     I                                  1  620  APOSTDF
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Program Initialisation.
      *
     C                   EXSR      SRXEINIT
      *
      ** Process Request
      *
     C                   EXSR      SRXEAVLBAL
      *
     C     KACCNTL3      CHAIN     ACCNTL3                            90
     C                   IF        BlockDebit = 'Y'
      *
     C                   IF        CNUM = *BLANKS AND
     C                             CCY  = *BLANKS AND
     C                             ACOD = 0       AND
     C                             ACSQ = 0       AND
     C                             BRCA = *BLANKS
      *
     C                   IF        *IN90 = '0'
     C                   EVAL      W@RETB = K_RETB
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      W@RETB = RETB
     C                   ENDIF
      *
     C                   EVAL      P@RETB = 'N'
     C                   TESTB     '2'           W@RETB                   80
     C                   IF        *IN80 = *ON
     C                   EVAL      P@RETB = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      ** Set available balance to zero if account is already closed
      *
     C                   IF        *IN90 = '0' AND K_RECI = 'C'
     C                             AND P@BLAF <> 0
     C                   EVAL      P@BLAF = 0
     C                   EVAL      P@CLBL = 0
     C                   ENDIF
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRXEINIT - Initialisation Routine                             *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRXEINIT      BEGSR
      *
      ** Initialisation
      *
     C                   EVAL      P@RTCE = *BLANK
     C                   EVAL      P@BLBF = 0
     C                   EVAL      P@BLAF = 0
     C                   EVAL      P@CLBL = 0
     C                   EVAL      P@COLL = 0
      *
      ** If Midas Input Cycle, Retrieve Available Balance and Exit.
      *
     C                   EVAL      DSACod0 = P@ACod
     C                   EVAL      DSAcSq0 = P@AcSq
      *
     C                   EVAL      KCNUM = P@CNUM
     C                   EVAL      KCCY = P@SCCY
     C                   EVAL      KACOD = P@ACOD
     C                   EVAL      KACSQ = P@ACSQ
     C                   EVAL      KBRCA = P@BRCA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRXEAVLBAL - Evaluate Available Balance                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: LE000042, SRXEOPNBAL, SRXEADJBALPOS, SrStampTax        *
      *                                                               *
      *****************************************************************
     C     SRXEAVLBAL    BEGSR
      *
      ** Obtain Opening Balance
      *
      ** Retrieve ABC flag from GLACNTQD
      *
     C                   EVAL      P@C205 = 'N'
     C**********         EVAL      P@ABCF = 'N'                                            MD032020
     C                   IF        CAP205 = 'Y'
     C                   EVAL      P@C205 = 'Y'
     C*****KACCNTL0      CHAIN(E)  GLACNTL3                                                MD032020
     C**********         IF        %FOUND(GLACNTL3) AND (F1IABC = 'Y')                     MD032020
     C**********         EVAL      P@ABCF = 'Y'                                            MD032020
      *
     C                   CALL      'LE000042'    PSETTLE
     C                   EVAL      P@CLBL = P@BLAF
      *
     C**********         ELSE                                                              MD031853
     C**** KACCNTL0      CHAIN(E)  ACCNTL0                                        MD031853 MD032020
     C**********         EVAL      P@ACNO = ACNO                                  MD031853 MD032020
     C**********         ENDIF                                                             MD032020
     C                   ELSE
     C                   EXSR      SRXEOPNBAL
     C                   ENDIF
      *
      ** Adjust Balance with Days Postings
      *
     C                   EXSR      SRXEADJBALPOS
      *
      ** Adjust Balance with Stamp Tax Postings
      *
     C                   IF        CER049 = 'Y'
     C                   EXSR      SrStampTax
     C                   ENDIF
                                                                                            MD027718
     C                   EXSR      SrNegMRRev                                               MD027718
      *
     C                   ENDSR
      *****************************************************************                     MD027718
      /EJECT                                                                                MD027718
      *****************************************************************                     MD027718
      *                                                               *                     MD027718
      * SrNegMRRev - Apply negative manual repayment and reversal     *                     MD027718
      *                                                               *                     MD027718
      * Called by: SRXEAVLBAL                                         *                     MD027718
      *                                                               *                     MD027718
      * Calls: *None                                                  *                     MD027718
      *                                                               *                     MD027718
      *****************************************************************                     MD027718
     C     SrNegMRRev    BEGSR                                                              MD027718
                                                                                            MD027718
     C                   EVAL      ADJUST = 0                                               MD027718
     C/EXEC SQL                                                                             MD027718
     C+  SELECT COALESCE(SUM(EAMT),0) INTO :ADJUST                                 MD027718 MD036674
     C+  FROM LEPK1DPD WHERE                                                                MD027718
     C+  SECNUM = :P@CNUM AND                                                               MD027718
     C+  SEACCY = :P@SCCY AND                                                               MD027718
     C+  SEACOD = :P@ACOD AND                                                               MD027718
     C+  SEACSQ = :P@ACSQ AND                                                               MD027718
     C+  SEBRCA = :P@BRCA AND                                                               MD027718
     C+  REVI   = 1 AND                                                                     MD027718
     C+  EAMT > 0                                                                           MD027718
     C/END-EXEC                                                                             MD027718
     C                   EVAL      P@BLAF -= ADJUST                                         MD027718
     C                   EVAL      P@CLBL -= ADJUST                                         MD027718
                                                                                            MD027718
     C                   EVAL      ADJUST = 0                                               MD048216
     C/EXEC SQL                                                                             MD048216
     C+  SELECT COALESCE(SUM(LKEAMT),0) INTO :ADJUST                                        MD048216
     C+  FROM LEPK2DPD WHERE                                                                MD048216
     C+  SECNUM = :P@CNUM AND                                                               MD048216
     C+  SEACCY = :P@SCCY AND                                                               MD048216
     C+  SEACOD = :P@ACOD AND                                                               MD048216
     C+  SEACSQ = :P@ACSQ AND                                                               MD048216
     C+  SEBRCA = :P@BRCA AND                                                               MD048216
     C+  LKREVI   = 1 AND                                                                   MD048216
     C+  LKEAMT > 0                                                                         MD048216
     C/END-EXEC                                                                             MD048216
     C                   EVAL      P@BLAF -= ADJUST                                         MD048216
     C                   EVAL      P@CLBL -= ADJUST                                         MD048216
                                                                                            MD048216
     C                   EVAL      ADJUST = 0                                               MD048216
     C/EXEC SQL                                                                             MD048216
     C+  SELECT COALESCE(SUM(LKEAMT),0) INTO :ADJUST                                        MD048216
     C+  FROM LEPK3DPD WHERE                                                                MD048216
     C+  SECNUM = :P@CNUM AND                                                               MD048216
     C+  SEACCY = :P@SCCY AND                                                               MD048216
     C+  SEACOD = :P@ACOD AND                                                               MD048216
     C+  SEACSQ = :P@ACSQ AND                                                               MD048216
     C+  SEBRCA = :P@BRCA AND                                                               MD048216
     C+  LKREVI   = 1 AND                                                                   MD048216
     C+  LKEAMT > 0                                                                         MD048216
     C/END-EXEC                                                                             MD048216
     C                   EVAL      P@BLAF -= ADJUST                                         MD048216
     C                   EVAL      P@CLBL -= ADJUST                                         MD048216
                                                                                            MD048216
     C                   EVAL      ADJUST = 0                                               MD027718
     C/EXEC SQL                                                                             MD027718
     C+  SELECT COALESCE(SUM(EAMT),0) INTO :ADJUST                                 MD027718 MD036674
     C+  FROM LEPK1DPD WHERE                                                                MD027718
     C+  SECNUM = :P@CNUM AND                                                               MD027718
     C+  SEACCY = :P@SCCY AND                                                               MD027718
     C+  SEACOD = :P@ACOD AND                                                               MD027718
     C+  SEACSQ = :P@ACSQ AND                                                               MD027718
     C+  SEBRCA = :P@BRCA AND                                                               MD027718
     C+  REVI   = 0 AND                                                                     MD027718
     C+  EAMT < 0                                                                           MD027718
     C/END-EXEC                                                                             MD027718
     C                   EVAL      P@BLAF += ADJUST                                         MD027718
     C                   EVAL      P@CLBL += ADJUST                                         MD027718
     C                   EVAL      ADJUST = 0                                               MD048216
     C/EXEC SQL                                                                             MD048216
     C+  SELECT COALESCE(SUM(LKEAMT),0) INTO :ADJUST                                        MD048216
     C+  FROM LEPK2DPD WHERE                                                                MD048216
     C+  SECNUM = :P@CNUM AND                                                               MD048216
     C+  SEACCY = :P@SCCY AND                                                               MD048216
     C+  SEACOD = :P@ACOD AND                                                               MD048216
     C+  SEACSQ = :P@ACSQ AND                                                               MD048216
     C+  SEBRCA = :P@BRCA AND                                                               MD048216
     C+  LKREVI   = 0 AND                                                                   MD048216
     C+  LKEAMT < 0                                                                         MD048216
     C/END-EXEC                                                                             MD048216
     C                   EVAL      P@BLAF += ADJUST                                         MD048216
     C                   EVAL      P@CLBL += ADJUST                                         MD048216
     C                   EVAL      ADJUST = 0                                               MD048216
     C/EXEC SQL                                                                             MD048216
     C+  SELECT COALESCE(SUM(LKEAMT),0) INTO :ADJUST                                        MD048216
     C+  FROM LEPK3DPD WHERE                                                                MD048216
     C+  SECNUM = :P@CNUM AND                                                               MD048216
     C+  SEACCY = :P@SCCY AND                                                               MD048216
     C+  SEACOD = :P@ACOD AND                                                               MD048216
     C+  SEACSQ = :P@ACSQ AND                                                               MD048216
     C+  SEBRCA = :P@BRCA AND                                                               MD048216
     C+  LKREVI   = 0 AND                                                                   MD048216
     C+  LKEAMT < 0                                                                         MD048216
     C/END-EXEC                                                                             MD048216
     C                   EVAL      P@BLAF += ADJUST                                         MD048216
     C                   EVAL      P@CLBL += ADJUST                                         MD048216

     C                   ENDSR                                                              MD027718
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRXEOPNBAL - Evaluate Opening Balance                         *
      *                                                               *
      * Called by: SRXEAVLBAL                                         *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRXEOPNBAL    BEGSR
      *
      ** Initialisation
      *
     C                   EVAL      KCNUM = P@CNUM
     C                   EVAL      KCCY = P@SCCY
     C                   EVAL      KACOD = P@ACOD
     C                   EVAL      KACSQ = P@ACSQ
     C                   EVAL      KBRCA = P@BRCA
      *
      ** Retrieve Account Balance
      *
     C     KGLACBTL0     CHAIN(E)  GLACBTL0

     C                   IF        %ERROR
     C                   EVAL      P@RTCE = '8'
     C                   RETURN
     C                   ENDIF

     C                   IF        %FOUND(GLACBTL0)
     C                   EVAL      P@BLBF = CLBL
     C                   EVAL      P@BLAF = CLBL
     C                   EVAL      P@CLBL = CLBL
     C                   ELSE
     C                   EVAL      P@BLBF = 0
     C                   EVAL      P@BLAF = 0
     C                   EVAL      P@CLBL = 0
     C                   ENDIF
      *
      ** Retrieve Account Details
      *
     C     KACCNTL0      CHAIN(E)  ACCNTL0
      *
     C                   IF        NOT %FOUND(ACCNTL0) OR
     C                             %ERROR
     C                   EVAL      P@RTCE = '9'
     C                   RETURN
     C                   ENDIF
      *
      ** Adjust Available Balance
      *
     C                   EVAL      P@BLAF += HELD
     C                   EVAL      P@HELD =  HELD
     C                   EVAL      P@COLL =  0
      *
      ** Get currency detail
      *
     C                   EXSR      SRGetCurrD
      *
      ** If Include Overdraft And Overdraft Exist
      ** Adjust Available Balance
      *
     C                   EVAL      P@OVLN  = 0
     C                   IF        ODED >= BJRDNB
     C                   EVAL      P@OVLN  = ODLN * (10**A6NBDP)
     C                                       * -1
     C     KACCNTL0      CHAIN(E)  ACCNTBY0
     C                   IF        %FOUND(ACCNTBY0)
     C                   IF        (ATOLVD <> 0)  AND
     C                             (ATOLVD <> BJRDNB)
     C                   EVAL      P@OVLN = 0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      P@ACNO = ACNO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRXEADJBALPOS - Adjust Available Balance by Adding Days       *
      *                 Postings                                      *
      *                                                               *
      * Called by: SRXEAVLBAL                                         *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRXEADJBALPOS BEGSR
      *
      ** Initialisation
      *
     C                   EVAL      KACPO1 = P@CNUM + P@SCCY + DSACOD +
     C                                      DSACSQ + P@BRCA
      *
      ** Retrieve & Add Postings
      *
     C     KACPO1        SETGT     GLACPML0
     C     KACPO1        READPE(E) GLACPML0
     C                   EVAL      DSAPOST = APOSTDF
      *
     C                   DOW       NOT %EOF(GLACPML0)
     C                   IF        APRECI = 'P' AND
     C                             APVALD <= BJRDNB
     C                   IF        APSPOS = '  GE-IC' AND
     C                             APVALD < BJRDNB AND
     C                             APPSTD < BJRDNB
     C                   ELSE
      *
     C                   IF        APDRCR = 1
     C                   EVAL      P@BLAF -= APPSTA
     C                   EVAL      P@CLBL -= APPSTA
      *
     C                   ELSE
     C                   EVAL      P@BLAF += APPSTA
     C                   EVAL      P@CLBL += APPSTA
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     KACPO1        READPE(E) GLACPML0
     C                   EVAL      DSAPOST = APOSTDF
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrStampTax - Adjust todays balances with Stamp Tax Postings   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SrStampTax    BEGSR
      *
      ** Initialise key fields
      *
     C                   EVAL      KCNUM = P@CNUM
     C                   EVAL      KCCY = P@SCCY
     C                   EVAL      KACOD = P@ACOD
     C                   EVAL      KACSQ = P@ACSQ
     C                   EVAL      KBRCA = P@BRCA
      *
      ** Retrieve Stamp Tax Postings
      *
     C                   SETOFF                                       50
     C     KGLACNL3      SETLL     GLGESTL3
     C     *IN50         DOWEQ     *OFF
     C     KGLACNL3      READE     GLGESTL3                               50
      *
     C     *IN50         IFEQ      *OFF
     C                   IF        STRECI = 'P' AND STVALD <= BJRDNB
      *
     C                   IF        STDRCR = 1
     C                   EVAL      P@BLAF -= STPSTA
     C                   EVAL      P@CLBL -= STPSTA
     C                   ELSE
     C                   EVAL      P@BLAF += STPSTA
     C                   EVAL      P@CLBL += STPSTA
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurrD - Subroutine that Retrieves Currency Details      *
      *                                                               *
      *****************************************************************
     C     SRGetCurrD    BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      KCCY          PCCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCCY
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation Rountine                              *
      *                                                               *
      * Called by: Automatically called                               *
      *                                                               *
      * Calls: AOSARDR0, AOSVALR0                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR


      ** Retrieve Midas Status

     C                   IN(E)     MPHAS


      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        @RTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   MOVEL     '003'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *** Check if CAP205 - Retail Account Balance Check feature is
      *** installed
      *
     C                   MOVE      'N'           CAP205            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CAP205'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAP205
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CAP205
     C                   ELSE
      *
      ** Database Error
      *
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      *
      *** Check if CER049 - Portuguese Stamp Tax feauture is installed
      *
     C                   MOVE      'N'           CER049            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CER049'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER049
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CER049
     C                   ELSE
      *
      ** Database Error
      *
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C                   PARM      SVALKK        SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK0           20
     C                   PARM                    SVAL10          200
      *
     C     @RTCD         IFNE      *BLANKS

     C     SVAL10        IFEQ      '*NRF'
     C                   MOVE      SVALK0        DBKEY
     C                   ENDIF
     C     SVAL9         IFEQ      '*NRF'
     C                   MOVE      SVALK9        DBKEY
     C                   ENDIF
     C     SVAL8         IFEQ      '*NRF'
     C                   MOVE      SVALK8        DBKEY
     C                   ENDIF
     C     SVAL7         IFEQ      '*NRF'
     C                   MOVE      SVALK7        DBKEY
     C                   ENDIF
     C     SVAL6         IFEQ      '*NRF'
     C                   MOVE      SVALK6        DBKEY
     C                   ENDIF
     C     SVAL5         IFEQ      '*NRF'
     C                   MOVE      SVALK5        DBKEY
     C                   ENDIF
     C     SVAL4         IFEQ      '*NRF'
     C                   MOVE      SVALK4        DBKEY
     C                   ENDIF
     C     SVAL3         IFEQ      '*NRF'
     C                   MOVE      SVALK3        DBKEY
     C                   ENDIF
     C     SVAL2         IFEQ      '*NRF'
     C                   MOVE      SVALK2        DBKEY
     C                   ENDIF
     C     SVAL1         IFEQ      '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF

     C     *LOCK         IN        LDA
     C                   MOVEL     '004'         DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   MOVE      'LE000475'    DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     SVAL1         BlockDebit        1
      *

     C                   ENDSR
      *****************************************************************
      /SPACE
      *****************************************************************
      * @DEFN: Definition Rountine                                    *
      *****************************************************************
     C     @DEFN         BEGSR
      *
      ** Entry List
      *
     C     *ENTRY        PLIST
     C                   PARM                    P@RTCE
     C                   PARM                    P@CNUM
     C                   PARM                    P@SCCY
     C                   PARM                    P@ACOD
     C                   PARM                    P@ACSQ
     C                   PARM                    P@BRCA
     C                   PARM                    P@ACNO

     C                   PARM                    P@CLBL
     C                   PARM                    P@BLBF
     C                   PARM                    P@BLAF
     C                   PARM                    P@HELD
     C                   PARM                    P@OVLN
     C                   PARM                    P@COLL
     C                   PARM                    P@RETB
     C                   PARM                    P@C205
     C                   PARM                    P@ABCF
      *
      ** Key List
     C     KGLACBTL0     KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
      *
     C     KACCNTL0      KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
      *
     C     KACCNTL3      KLIST
     C                   KFLD                    KACOD
     C                   KFLD                    KCCY
     C                   KFLD                    KCNUM
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
      *

     C                   EVAL      SEFACT = 0

     C     PSETTLE       PLIST
      ** Input parameters
     C                   PARM                    P@CNUM
     C                   PARM                    P@SCCY
     C                   PARM                    P@ACOD
     C                   PARM                    P@ACSQ
     C                   PARM                    P@BRCA
      ** Output parameters
     C                   PARM                    P@BLAF
     C                   PARM                    P@OVLN
     C                   PARM                    P@HELD
     C                   PARM                    P@COLL
     C                   PARM                    P@ACNO

     C     KGLACNL3      KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA

      ** Dataareas

     C     *DTAARA       DEFINE                  MPHAS

     C                   ENDSR
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2014
