     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Aggregate Facility History Update Report')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000055 - Aggregate Facility History Update Report          *
      *                                                               *
      *  Function:  This program reworks the aggregated facilities    *
      *             history due to back-valuation.                    *
      *                                                               *
      *  (phase(s))                                                   *
      *  Close of Business                                            *
      *                                                               *
      *  Called By: LEC000055                                         *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR787620           Date 10Jun11               *
      *                 CLE064             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG6004            Date 04Apr05               *
      *                 CLE041  *CREATE    Date 11Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00396                                 *
      *             WNCPYSRC,LEH00397                                 *
      *             WNCPYSRC,LEH00401                                 *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG6004- Use correct revolving credit indicator when record  *
      *           found in HISACT file.                               *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *                                                               *
      *****************************************************************
 
      ** Midas LE Aggregate Facilities with Actions
     FLEAGACPD  IF   E           K DISK
 
      ** Midas LE Aggregated Facility History Header
     FLEAGFHPD  UF A E           K DISK
 
      ** Midas LE Agg Fclty History by Fclty/VDAT/SEQ
     FLEAGHSL0  UF A E           K DISK
 
      ** Midas LE Facility history amounts
     FHISUPD    IF   E           K DISK    INFDS(HISUPDDS)
 
      ** Midas LE Aggregated Facility file
     FLEAGFYJ0  IF   E           K DISK
 
      ** Midas LE Aggregated Facility file
     FLEAGFCL0  UF A E           K DISK    IGNORE(FCLTYHHF)
 
      ** Midas LE Aggregate Facility History Update - Audit
     FLE000055AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
 
      ** Midas LE Aggregate Facility History Update - Report
     FLE000055P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   37  - Multibranching ON                                     *
      *                                                               *
      *   89  - End of File                                           *
      *   80  - End of File                                           *
      *   81  - End of File                                           *
      *   82  - End of File                                           *
      *   83  - End of File                                           *
      *   84  - End of File                                           *
      *                                                               *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SrINIT     - Program Initialisation                          *
      *  SrPROCES   - Detail Processing                               *
      *  SrCRTFS    - Create Facility Start record                    *
      *  SrFACHIS   - Process history action record                   *
      *  SrTRANCHE  - Process tranche-driven actions                  *
      *  SrAGGREGATE- Process aggregate-driven actions                *
      *  SrFACUPD   - Update the facility details                     *
      *  SrREPORT   - Process Report Lines                            *
      *                                                               *
      *  SrP1REC    - Format and Write a Detail Record to the Report  *
      *  SrP1END    - Write End of Report                             *
      *                                                               *
      *  SrAUDIT    - Produce Audit Report and End Program            *
      *  *PSSR      - Program Error Processing Subroutine             *
      *  SrRCFP1    - RCF Processing for P1 Report                    *
      *  SrRCFAU    - RCF Processing for Audit Report                 *
      *                                                               *
      *  ZDATE2     - Convert Midas Day Number into Date (DDMMMYY)    *
      *  ZSEDIT     - Edit an Amount                                  *
      *  SrZADD     - Adds an amount (WZAMT) to the total (WZTOTI,    *
      *               WZTOTD)                                         *
      *  SrZSUM     - Carries out the addition of the amounts         *
      *                                                               *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      ** Program Status Data Structure
 
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
     D HISUPDDS        DS
      ** File Information Data Structure for HISUPD.
 
     D  RecordFmt        *RECORD
 
     D SPOOL1          DS
      ** File Information Data Structure for LE000055P1.
 
     D  OPNIND                 9      9
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D SPOOLU          DS
      ** File Information Data Structure for LE000055AU.
 
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
     D SaveIndDS       DS
     D  WIN91                  1      1
     D  WIN92                  2      2
     D  WIN93                  3      3
     D  WIN94                  4      4
     D  WIN95                  5      5
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Dummy data structures
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Dummy data structures
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  XQDFAC       E                     EXTFLD(QQDFAC)
      ** External data structures for Branch Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structures for Currency Details
 
     D  CPY2@          S             80
     D  RQDLN1         S              3  0
     D  DIFLN1         S              3  0
     D  PRTCD          S              7
     D  POPTN          S              7
     D  PBRCH          S              3
     D  PCURR          S              3
     D  PZFIELD        S             15P 0
     D  PZDEC          S              1P 0
     D  PZCODE         S              1
     D  PZOUT21        S             21
     D  PSEQ           S              5
     D  PSENTY         S              3
     D  PZSNUM         S              6  0
     D  PZSERR         S              1
     D  PSFILE         S             10
     D  WCount         S              5P 0
     D  WRcdInv        S              5P 0
     D  WRcdInvTot     S              5P 0
     D  WBranch        S              3
     D  WBranchL       S              3
     D  WBRCA          S              3
     D  WFcty          S              5S 0
     D  WFctyL         S              5S 0
     D  WRun           S              1
     D  WRcdt          S              1
     D**WCust***       S              6S 0                                                    CSD027
     D**WCustL**       S              6S 0                                                    CSD027
     D  WCust          S              6A                                                      CSD027
     D  WCustL         S              6A                                                      CSD027
     D  WFType         S              3S 0
     D  WFSeq          S              2S 0
     D  WDate          S              5P 0
     D  WDateL         S              5P 0
     D  WSequence      S              3S 0
     D  WSequenceL     S              3S 0
     D**WLoan***       S              6S 0                                                    CLE148
     D**WLoanL**       S              6S 0                                                    CLE148
     D  WLoan          S              6A                                                      CLE148
     D  WLoanL         S              6A                                                      CLE148
     D  WWAFAM         S             15P 0
     D  WWFCAM         S             15P 0
     D  WWAAMT         S             15P 0
     D  WWRCIN         S              1
     D  WWTRRC         S              1
     D  PFrDecPlace    S              1P 0
     D  PToDecPlace    S              1P 0
     D  PInputAmnt     S             15P 0
     D  PExchRate      S             13P 8
     D  PMultDivInd    S              1
     D  PFrCcy         S              3
     D  PToCcy         S              3
     D  POutputAmnt    S             15P 0
     D  WOldFAMT       S             15P 0
     D  WBookedAmt     S             15P 0
     D  WZAMT          S             15  3
     D  WZTOTI         S             15  0
     D  WZTOTD         S              3  0
     D  WZAMTI         S             15  0
     D  WZAMTD         S              3  0
     D  WZWK2          S              4  0
     D  WZWK3          S             15  0
     D  WZNEGD         S              5
     D  WFMRECI        S              1
 
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Perform Initialisation.
 
     C                   EXSR      SrINIT
 
      ** Perform Detail Processing.
 
     C                   EXSR      SrPROCES
 
      ** Output Audit Report and End Program.
 
     C                   EXSR      SrAUDIT
 
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrINIT - Subroutine to do Program Initialisation.            *
      *                                                               *
      *****************************************************************
     C     SrINIT        BEGSR
 
      ** Set up copyright parameter
 
     C                   EVAL      CPY2@ = CPY@(1)
 
      ** Initialise LDA field.
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'LE000055'
     C                   OUT       LDA
 
     C/COPY WNCPYSRC,LEH00396
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error.
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **   Access RUNDAT for multibranching indicator
 
     C                   IN        RUNDAT
 
     C                   IF        AGMBIN = 'Y'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
 
      ** RCF Processing for Audit File.
 
     C                   EXSR      SrRCFAU
 
      ** Report Work fields.
 
     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0
     C                   EVAL      WCount = 0
     C                   EVAL      WRcdInv = 0
     C                   EVAL      WRcdInvTot = 0
     C                   EVAL      WWAFAM = 0
     C                   EVAL      WWFCAM = 0
     C                   EVAL      WWAAMT = 0
     C                   EVAL      WWRCIN = *BLANK
     C                   EVAL      WWTRRC = *BLANK
 
      ** Key lists
 
     C     KFacility     KLIST
     C                   KFLD                    WCust
     C                   KFLD                    WFType
     C                   KFLD                    WFSeq
     C                   KFLD                    WRcdt
 
     C     KAGFclty      KLIST
     C                   KFLD                    WBranch
     C                   KFLD                    WCust
     C                   KFLD                    WFcty
 
     C     KAGFcltyD     KLIST
     C                   KFLD                    WBranch
     C                   KFLD                    WCust
     C                   KFLD                    WFcty
     C                   KFLD                    WDate
 
     C     KAGFcltyS     KLIST
     C                   KFLD                    WBranch
     C                   KFLD                    WCust
     C                   KFLD                    WFcty
     C                   KFLD                    WDate
     C                   KFLD                    WSequence
 
     C     KHSFcltyL     KLIST
     C                   KFLD                    WBranchL
     C                   KFLD                    WCustL
     C                   KFLD                    WFctyL
     C                   KFLD                    WDateL
     C                   KFLD                    WSequenceL
     C                   KFLD                    WLoanL
 
     C     KAGFcltyH     KLIST
     C                   KFLD                    WBranch
     C                   KFLD                    WCust
     C                   KFLD                    WFType
     C                   KFLD                    WFSeq
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrPROCES
      *****************************************************************
      *                                                               *
      *  SrPROCES - Subroutine to do the Detail Processing.           *
      *                                                               *
      *****************************************************************
     C     SrPROCES      BEGSR
 
      ** Read first record from File.
 
     C                   READ      LEAGACPD                               89
 
      ** If End of Records, (*IN89), Perform: Audit Reporting (No
      ** Records).
 
     C                   IF        *IN89 = *ON
     C                   EXSR      SrAUDIT
     C                   ENDIF
 
      ** Do Until End of File.
 
     C                   DOW       *IN89 = *OFF
 
      ** Access the aggregate history header file
 
     C                   EVAL      WBranch = AJBRCA
     C                   EVAL      WCust = AJCNUM
     C                   MOVEL     AJFCTY        WFType
     C                   MOVE      AJFCTY        WFSeq
 
     C     KAGFcltyH     CHAIN     LEAGFHPD                           80
 
     C                   IF        *IN80 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEAGFHPD'
     C                   EVAL      DBASE = 2
     C**********         EVAL      DBKEY = WBranch + %EDITC(WCust:'X') +                      CSD027
     C                   EVAL      DBKEY = WBranch + WCust +                                  CSD027
     C                                     %EDITC(WFtype:'X') +
     C                                     %EDITC(WFSeq:'X')
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Also check in the aggregate facilities file if it is existing
      ** (join logical of FCLTYFM and FCLTYFN)
 
     C     KAGFcltyH     CHAIN     LEAGFYJ0                           80
 
     C                   IF        *IN80 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEAGFYJ0'
     C                   EVAL      DBASE = 3
     C**********         EVAL      DBKEY = WBranch + %EDITC(WCust:'X') +                      CSD027
     C                   EVAL      DBKEY = WBranch + WCust +                                  CSD027
     C                                     %EDITC(WFtype:'X') +
     C                                     %EDITC(WFSeq:'X')
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get the last facility history record prior to the value date
      ** of the action being processed (AJDATE)
 
     C                   EVAL      WFcty = AJFCTY
     C                   EVAL      WDate = AJDATE
 
     C     KAGFcltyD     SETLL     LEAGHSL0
     C     KAGFclty      READPE    LEAGHSL0                               80
 
      ** No record found, get the start record
 
     C                   IF        *IN80 = *ON
     C                   EVAL      WSequence = 1
     C     KAGFcltyS     CHAIN     LEAGHSL0                           81
 
      ** Create start record if still no record found
 
     C                   IF        *IN81 = *ON
     C                   EXSR      SrCRTFS
     C                   ENDIF
     C                   ENDIF
 
      ** Initialise the actual aggregate facility amount (WWAFAM) and aggregate
      ** facility revolving credit indicator (WWRCIN) prior to the action being
      ** processed.
 
     C                   EVAL      WWAFAM = AIAFAM
     C                   EVAL      WWFCAM = AIFCAM
     C                   EVAL      WWRCIN = AIRCIN
 
      ** Process each history record against the action being processed
 
     C     KAGFcltyD     SETLL     LEAGHSL0
     C     KAGFclty      READE     LEAGHSL0                               82
 
     C                   DOW       *IN82 = *OFF
 
      ** Process history action record
 
     C                   EXSR      SrFACHIS
 
      ** Get next facility history record
 
     C     KAGFclty      READE     LEAGHSL0                               82
     C                   ENDDO
 
      ** Update the facility
 
     C                   EXSR      SrFACUPD
 
      ** Generate report
 
     C                   EXSR      SrREPORT
 
      ** Increment record processed
 
     C                   EVAL      WCount = WCount + 1
 
      ** Update the record id of the aggregate facility historic record
 
     C                   EVAL      AKRECI = RECI
     C                   UPDATE    LEAGFHD0
 
      ** Get next action record
 
     C                   READ      LEAGACPD                               89
     C                   ENDDO
 
      ** Write final records and Totals to Report.
 
     C                   IF        WCount <> 0
     C                   IF        *IN37 = *ON
     C                   EXSR      SrP1END
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF
     C                   EXSR      SrP1END
     C                   ENDIF
 
     C                   EXSR      SrAUDIT
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrCRTFS
      *****************************************************************
      *                                                               *
      *  SrCRTFS - Create Facility Start record                       *
      *                                                               *
      *****************************************************************
     C     SrCRTFS       BEGSR
 
      ** Write record to LEAGHSPD
 
     C                   EVAL      AIRECI = 'D'
     C                   EVAL      AIBRCA = AJBRCA
     C                   EVAL      AICNUM = AJCNUM
     C                   EVAL      AIFCTY = AJFCTY
     C                   EVAL      AIDATE = DTAP
     C                   EVAL      AISEQ  = 1
     C                   EVAL      AIACTN = 'FS'
     C                   EVAL      AIAAMT = AKOFAM
     C                   EVAL      AIRCIN = AKRCIN
     C                   EVAL      AITSEQ = 1
     C                   EVAL      AITRBR = *BLANK
     C**********         EVAL      AITRNM = *ZEROS                                            CSD027
     C                   EVAL      AITRNM = *BLANKS                                           CSD027
     C                   EVAL      AITRFC = *ZEROS
     C                   EVAL      AITRAM = *ZEROS
     C                   EVAL      AITRCY = *BLANK
     C                   EVAL      AITRRC = *BLANK
     C                   EVAL      AIEXRT = *ZEROS
     C                   EVAL      AIMDIN = *BLANK
     C**********         EVAL      AILOAN = *ZEROS                                            CLE148
     C                   EVAL      AILOAN = *BLANKS                                           CLE148
     C                   EVAL      AIDEAL = *ZEROS
     C                   EVAL      AIUSEQ = *ZEROS
     C                   EVAL      AIMTID = *ZEROS
     C                   EVAL      AIFCAM = AKOFAM
     C                   EVAL      AIAFAM = AKOFAM
     C                   EVAL      AIORED = BJRDNB
 
     C/COPY WNCPYSRC,LEH00397
     C                   WRITE     LEAGHSD0
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrFACHIS
      *****************************************************************
      *                                                               *
      *  SrFACHIS - Process history action record                     *
      *                                                               *
      *****************************************************************
     C     SrFACHIS      BEGSR
 
      ** Process the tranche-driven actions if the event is coming from
      ** a tranche otherwise process aggregate facility-driven actions
 
     C**********         IF        AITRBR <> *BLANK AND AITRNM <> *ZEROS                      CSD027
     C                   IF        AITRBR <> *BLANK AND AITRNM <> *BLANKS                     CSD027
     C                             AND AITRFC <> *ZEROS
     C                   EXSR      SrTRANCHE
     C                   ELSE
     C                   EXSR      SrAGGREGATE
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrTRANCHE
      *****************************************************************
      *                                                               *
      *  SrTRANCHE - Process tranche-driven actions                   *
      *                                                               *
      *****************************************************************
     C     SrTRANCHE     BEGSR
 
      ** Check in HISUPD (action events of the tranche)
 
     C                   EVAL      WBranchL = AITRBR
     C                   EVAL      WCustL = AITRNM
     C                   EVAL      WFctyL = AITRFC
     C                   EVAL      WDateL = AIDATE
     C                   EVAL      WSequenceL = AITSEQ
     C                   EVAL      WLoanL = AILOAN
 
     C     KHSFcltyL     CHAIN     HISUPD                             83
 
     C                   IF        *IN83 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'HISUPD'
     C                   EVAL      DBASE = 4
     C**********         EVAL      DBKEY = WBranch + %EDITC(WCustL:'X') +                     CSD027
     C                   EVAL      DBKEY = WBranch + WCustL +                                 CSD027
     C                                     %EDITC(WFctyL:'X') +
     C                                     %EDITC(WDateL:'X') +
     C                                     %EDITC(WSequenceL:'X') +
     C**********                           %EDITC(WLoanL:'X')                                 CLE148
     C                                     WLoanL                                             CLE148
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      RecordFmt = 'FACHISAF'
     C                   EVAL      WWTRRC = FARCIN
     C                   WHEN      RecordFmt = 'HISACTF'
     C**********         EVAL      WWTRRC = HARCIN                                           BUG6004
     C                   EVAL      WWTRRC = HATRRC                                           BUG6004
     C                   ENDSL
 
      ** Process non-revolving facility
 
     C                   IF        WWRCIN = 'N' OR WWRCIN = 'T' AND WWTRRC = 'N'
 
      ** Aggregate facility not equal to tranche facility, convert amount
      ** to aggregate facility currency
 
     C                   IF        FCCY <> AITRCY
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      AITRCY        PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 5
     C                   EVAL      DBKEY = PCURR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PFrDecPlace = A6NBDP
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      FCCY          PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = PCURR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PToDecPlace = A6NBDP
 
     C                   EVAL      PInputAmnt = AITRAM
     C                   EVAL      PExchRate = AIEXRT
     C                   EVAL      POutputAmnt = *ZERO
 
     C                   CALL      'ZCONVZ1'
     C                   PARM                    PInputAmnt
     C                   PARM                    PExchRate
     C                   PARM      AIMDIN        PMultDivInd
     C                   PARM      AITRCY        PFrCcy
     C                   PARM      FCCY          PToCcy
     C                   PARM                    PFrDecPlace
     C                   PARM                    PToDecPlace
     C                   PARM                    POutputAmnt
 
     C                   EVAL      WWAAMT = POutputAmnt
     C                   ELSE
 
      ** Same currencies
 
     C                   EVAL      WWAAMT = AITRAM
     C                   ENDIF
     C                   ELSE
 
      ** Revolving aggregate facility
 
     C                   EVAL      WWAAMT = *ZERO
     C                   ENDIF
 
      ** Actual facility amount is the actual aggregate facility amount
      ** minus the action amount
 
     C                   EVAL      WWAFAM = WWAFAM - WWAAMT
     C                   EVAL      WWFCAM = WWAFAM
 
     C                   IF        WWFCAM < *ZERO
     C                   EVAL      WWFCAM = *ZERO
     C                   ENDIF
 
      ** Update history record if any of the following has changed
 
     C                   IF        WWAFAM <> AIAFAM
     C                   EVAL      AIAFAM = WWAFAM
     C                   ENDIF
     C                   IF        WWFCAM <> AIFCAM
     C                   EVAL      AIFCAM = WWFCAM
     C                   ENDIF
     C                   IF        WWRCIN <> AIRCIN
     C                   EVAL      AIRCIN = WWRCIN
     C                   ENDIF
     C                   IF        WWTRRC <> AITRRC
     C                   EVAL      AITRRC = WWTRRC
     C                   ENDIF
     C                   IF        WWAAMT <> AIAAMT
     C                   EVAL      AIAAMT = WWAAMT
     C                   ENDIF
 
     C                   UPDATE    LEAGHSD0
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrAGGREGATE
      *****************************************************************
      *                                                               *
      *  SrAGGREGATE - Process aggregate-driven actions               *
      *                                                               *
      *****************************************************************
     C     SrAGGREGATE   BEGSR
 
     C                   SELECT
 
      ** Facility increase
 
     C                   WHEN      AIACTN = 'FI'
     C                   EVAL      WWAFAM = WWAFAM + AIAAMT
 
      ** Facility decrease
 
     C                   WHEN      AIACTN = 'FD'
     C                   EVAL      WWAFAM = WWAFAM - AIAAMT
 
      ** Facility reactivation
 
     C                   WHEN      AIACTN = 'FR'
     C                   EVAL      WWAFAM = AIAAMT
 
      ** Facility revolving credit change
 
     C                   WHEN      AIACTN = 'RC'
     C                   EVAL      WWRCIN = AIRCIN
     C                   ENDSL
 
     C                   EVAL      WWFCAM = WWAFAM
 
     C                   IF        WWFCAM < *ZERO
     C                   EVAL      WWFCAM = *ZERO
     C                   ENDIF
 
      ** Update the history record if any of the fields has changed
 
     C                   IF        WWAFAM <> AIAFAM
     C                   EVAL      AIAFAM = WWAFAM
     C                   ENDIF
     C                   IF        WWFCAM <> AIFCAM
     C                   EVAL      AIFCAM = WWFCAM
     C                   ENDIF
     C                   IF        AIACTN = 'FE' OR AIACTN = 'FC'
     C                   EVAL      AIRECI = RECI
     C                   ENDIF
 
     C                   UPDATE    LEAGHSD0
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrFACUPD
      *****************************************************************
      *                                                               *
      *  SrFACUPD - Update the facility details                       *
      *                                                               *
      *****************************************************************
     C     SrFACUPD      BEGSR
 
     C                   EVAL      WCust = AKCNUM
     C                   EVAL      WFType = AKFTYP
     C                   EVAL      WFSeq = AKFSEQ
     C                   EVAL      WRcdt = 'A'
 
     C     KFacility     CHAIN     LEAGFCL0                           84
 
     C                   IF        *IN84 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEAGFMPD'
     C                   EVAL      DBASE = 7
     C**********         EVAL      DBKEY = %EDITC(WCust:'X') +                                CSD027
     C                   EVAL      DBKEY = WCust +                                            CSD027
     C                                     %EDITC(WFtype:'X') +
     C                                     %EDITC(WFSeq:'X')
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WFMRECI = RECI
 
     C                   EVAL      WOldFAMT = FAMT
 
     C                   IF        FAMT <> WWFCAM
     C                   EVAL      FAMT = WWFCAM
     C                   ENDIF
 
     C                   UPDATE    FCLTYFMF
 
     C     *LOVAL        SETLL     FCLTYZZF
     C                   READ      FCLTYZZF                               85
 
     C                   IF        *IN85 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEAGFZPD'
     C                   EVAL      DBASE = 8
     C                   EVAL      DBKEY = 'NO RECORD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WBookedAmt = WOldFAMT - FAMT
 
     C                   EVAL      WZAMT = WBookedAmt/1000
     C                   Z-ADD     VLBF          WZTOTI
     C                   Z-ADD     VLBL          WZTOTD
     C                   EXSR      SRZADD
     C                   Z-ADD     WZTOTI        VLBF
     C                   Z-ADD     WZTOTD        VLBL
 
     C                   Z-ADD     VLAF          WZTOTI
     C                   Z-ADD     VLAL          WZTOTD
     C                   EXSR      SRZADD
     C                   Z-ADD     WZTOTI        VLAF
     C                   Z-ADD     WZTOTD        VLAL
 
     C                   UPDATE    FCLTYZZF
 
     C                   EVAL      RECI = WFMRECI
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrREPORT
      *****************************************************************
      *                                                               *
      *  SrREPORT - Process Report Lines.                             *
      *                                                               *
      *****************************************************************
     C     SrREPORT      BEGSR
 
      ** Change in branch, write header details
 
     C                   IF        OPNIND = '0'
     C                   OPEN      LE000055P1
     C                   EXSR      SrRCFP1
     C                   ENDIF
 
     C                   IF        AJBRCA <> WBRCA
     C                   IF        WBRCA <> *BLANK
     C                   EXSR      SrP1END
     C                   CLOSE     LE000055P1
     C                   OPEN      LE000055P1
     C                   EVAL      WRcdInv = *ZERO
     C                   ENDIF
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      AJBRCA        PBRCH
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 9
     C                   EVAL      DBKEY = PBRCH
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WBRCA = AJBRCA
     C                   EVAL      RBRCA = A8BRCD
     C                   EVAL      RBRNM = A8BRNM
 
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out the record.
 
     C                   EXSR      SrP1REC
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrP1REC
      *****************************************************************
      *                                                               *
      *  SrP1REC - Subroutine to Write a Detail record to the Report. *
      *                                                               *
      *****************************************************************
     C     SrP1REC       BEGSR
 
     C                   EVAL      RCNUM = *BLANK
     C                   EVAL      RFCLT = *BLANK
     C                   EVAL      RFCNO  = *BLANK
     C                   EVAL      RCCY = *BLANK
     C                   EVAL      RFAMTH = *BLANK
     C                   EVAL      RFAMTF = *BLANK
     C                   EVAL      RSTAT = *BLANK
 
     C**********         EVAL      RCNUM = %EDITC(AKCNUM:'X')                                 CSD027
     C                   EVAL      RCNUM = AKCNUM                                             CSD027
     C                   EVAL      RFCLT = %EDITC(AKFTYP:'X')
     C                   EVAL      RFCNO = %EDITC(AKFSEQ:'X')
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      AKFCCY        PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 10
     C                   EVAL      DBKEY = PCURR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RCCY = A6CYCD
 
     C                   EVAL      PZFIELD = WOldFAMT
     C                   CALL      'ZSEDIT'
     C                   PARM                    PZFIELD
     C                   PARM      A6NBDP        PZDEC
     C                   PARM      'J'           PZCODE
     C                   PARM      *BLANK        PZOUT21
 
     C                   EVAL      RFAMTF = PZOUT21
 
     C                   EVAL      PZFIELD = WWFCAM
     C                   CALL      'ZSEDIT'
     C                   PARM                    PZFIELD
     C                   PARM      A6NBDP        PZDEC
     C                   PARM      'J'           PZCODE
     C                   PARM      *BLANK        PZOUT21
 
     C                   EVAL      RFAMTH = PZOUT21
 
     C                   IF        RECI <> 'E'
     C                   IF        WOldFAMT <> WWFCAM
     C                   EVAL      RSTAT = 'ERROR     '
     C                   EVAL      WRcdInv = WRcdInv + 1
     C                   EVAL      WRcdInvTot = WRcdInvTot + 1
     C                   ENDIF
     C                   ELSE
     C                   EVAL      RSTAT = 'EXPIRED   '
     C                   ENDIF
     C/COPY WNCPYSRC,LEH00401
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
 
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out Detail Record.
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrP1END
      *****************************************************************
      *                                                               *
      *  SrP1END - Subroutine to Write End of Report.                 *
      *                                                               *
      *****************************************************************
     C     SrP1END       BEGSR
 
      ** There is an error and some of the facilities need to be investigated
 
     C                   IF        *IN37 = *ON OR *IN37 = *OFF
     C                              AND AGMBIN = 'N'
     C                   IF        WRcdInv > 0
     C                   Z-ADD     5             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     ERROR
     C                   ENDIF
     C                   ENDIF
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
 
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out Total Format.
 
     C                   WRITE     TRAILP1
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrAUDIT
      *****************************************************************
      *                                                               *
      *  SrAUDIT  - Subroutine to Output Audit report and End         *
      *             Program                                           *
      *                                                               *
      *****************************************************************
     C     SrAUDIT       BEGSR
 
      ** Output Report Header and File Controls.
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
 
     C                   IF        WCount = 0
     C                   WRITE     NODTLS
     C                   ELSE
     C                   EVAL      RLISTD = WCount
     C                   EVAL      RINVTG = WRcdInvTot
     C                   WRITE     CONTROL
     C                   ENDIF
     C                   ENDIF
 
      ** End Program and Return.
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called.
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      SrAUDIT
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here.
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrRCFP1
      *****************************************************************
      *                                                               *
      *  SrRCFP1  - Subroutine to register the P1 Printer File via    *
      *             RCF.                                              *
      *                                                               *
      *****************************************************************
     C     SrRCFP1       BEGSR
 
      ***  Ensure Report Spool File recorded by RCF.
 
     C                   Z-ADD     SFNUM1        PZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILE1        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANKS       PZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrRCFAU
      *****************************************************************
      *                                                               *
      *  SrRCFAU  - Subroutine to register the AU Printer File via    *
      *             RCF.                                              *
      *                                                               *
      *****************************************************************
     C     SrRCFAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   Z-ADD     SFNUMU        PZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILEU        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrZADD
      *****************************************************************
      *                                                               *
      * SrZADD  - Adds an amount (WZAMT) to the total (WZTOTI,WZTOTD) *
      *                                                               *
      *****************************************************************
     C     SrZADD        BEGSR
 
      ** Split WZAMT into integer and decimal fields
 
     C                   Z-ADD     WZAMT         WZAMTI
     C                   MOVE      WZAMT         WZAMTD
 
      ** Both WZAMTI and WZAMTD contain a 'sign' zone now
 
     C                   EXSR      SrZSUM
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrZSUM
      *****************************************************************
      *                                                               *
      * SrZSUM  - Carries out the addition of the amounts             *
      *                                                               *
      *****************************************************************
     C     SrZSUM        BEGSR
 
      ** Save values of indicators to be used in the program
 
     C                   MOVEA     *IN(91)       SaveIndDS
     C                   MOVEA     '00000'       *IN(91)
     C                   EVAL      *IN99 = *OFF
 
     C                   DO
 
      ** Determine sign of WZAMTI and WZAMTD, 92 IF NEG
      ** If both are zero, bypass processing
 
     C                   IF        WZAMTI = *ZERO  AND
     C                             WZAMTD = *ZERO
     C                   LEAVE
     C                   ELSE
     C                   IF        WZAMTI < *ZERO OR
     C                             WZAMTD < *ZERO
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
     C                   ENDIF
 
      ** Determine sign of WZTOTI and WZTOTD, 91 IF NEG.
      ** If WZTOTAL is ZERO, return ZZAMOUNT.
 
     C                   IF        WZTOTI = *ZERO  AND
     C                             WZTOTD = *ZERO
     C                   Z-ADD     WZAMTI        WZTOTI
     C                   Z-ADD     WZAMTD        WZTOTD
     C                   LEAVE
     C                   ELSE
     C                   IF        WZTOTI < *ZERO  OR
     C                             WZTOTD < *ZERO
     C                   EVAL      *IN91 = *ON
     C                   ENDIF
     C                   ENDIF
 
      ** If signs differ, bypass overflow checks
 
     C                   IF        *IN91 = *OFF AND *IN92 = *OFF
     C                             OR *IN91 = *ON AND *IN92 = *ON
 
     C     WZAMTD        ADD       WZTOTD        WZWK2
     C                   IF        WZWK2 > 999 OR WZWK2 <= 999 AND WZWK2 < -999
 
     C                   IF        *IN92 = *OFF
     C     WZAMTI        ADD       1             WZWK3
     C                   ELSE
     C     WZAMTI        SUB       1             WZWK3
     C                   ENDIF
     C     WZTOTI        ADD       WZWK3         WZWK3
 
     C                   ELSE
     C     WZTOTI        ADD       WZAMTI        WZWK3
     C                   ENDIF
 
      ** If the modulus of WZWK3 is less than the modulus of WZTOTI,
      ** then overflow has occurred
 
     C                   IF        *IN92 = *OFF
     C     WZWK3         COMP      WZTOTI                               99
     C                   ELSE
     C     WZWK3         COMP      WZTOTI                             99
     C                   ENDIF
 
      ** If overflow occurs, zeroise WZAMT
 
     C                   IF        *IN99 = *ON
     C                   Z-ADD     0             WZAMT
     C                   ELSE
     C                   Z-ADD     WZWK2         WZTOTD
     C                   Z-ADD     WZWK3         WZTOTI
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
 
      ** the signs are different
 
     C                   IF        *IN91 = *ON AND *IN92 = *OFF OR
     C                             *IN91 = *OFF AND *IN92 = *ON
 
      ** If WZAMT was negative, make it positive to compare with WZTOT
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     WZAMTI        WZAMTI
     C                   Z-SUB     WZAMTD        WZAMTD
     C                   ENDIF
 
      ** If WZTOT was negative, make it positive to compare with WZAMT
 
     C                   IF        *IN91 = *ON
     C                   Z-SUB     WZTOTI        WZTOTI
     C                   Z-SUB     WZTOTD        WZTOTD
     C                   ENDIF
 
      ** Both WZAMT and WZTOT are now positive
      ** If WZTOT equals WZAMT, return zero
 
     C                   EVAL      *IN93 = *OFF
     C                   IF        WZTOTI = WZAMTI AND WZTOTD = WZAMTD
     C                   Z-ADD     0             WZTOTI
     C                   Z-ADD     0             WZTOTD
     C                   LEAVE
     C                   ELSE
     C                   IF        WZTOTI > WZAMTI OR WZTOTD = WZAMTD
     C                   EVAL      *IN93 = *ON
     C                   ENDIF
     C                   ENDIF
 
      ** If WZTOT greater than WZAMT
 
     C                   IF        *IN93 = *ON
     C                   IF        WZAMTD > WZTOTD
     C     WZTOTI        SUB       1             WZTOTI
     C     WZTOTD        ADD       1000          WZWK2
     C     WZTOTI        SUB       WZAMTI        WZTOTI
     C     WZWK2         SUB       WZAMTD        WZTOTD
     C                   ELSE
     C     WZTOTI        SUB       WZAMTI        WZTOTI
     C     WZTOTD        SUB       WZAMTD        WZTOTD
     C                   ENDIF
 
      ** If WZAMT greater than WZAMT
 
     C                   ELSE
     C                   IF        WZTOTD > WZAMTD
     C     WZAMTI        SUB       1             WZWK3
     C     WZAMTD        ADD       1000          WZWK2
     C     WZWK3         SUB       WZTOTI        WZTOTI
     C     WZWK2         SUB       WZTOTD        WZTOTD
     C                   ELSE
     C     WZAMTI        SUB       WZTOTI        WZTOTI
     C     WZAMTD        SUB       WZTOTD        WZTOTD
     C                   ENDIF
     C                   ENDIF
 
      ** Reverse sign of WZTOT if larger input fields were negative
 
     C                   IF        *IN93 = *ON AND *IN91 = *ON OR
     C                             *IN93 = *OFF AND *IN92 = *ON
     C                   Z-SUB     WZTOTI        WZTOTI
     C                   Z-SUB     WZTOTD        WZTOTD
     C                   ENDIF
 
      ** Restore sign of WZAMTI & WZAMTD if reversed
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     WZAMTI        WZAMTI
     C                   Z-SUB     WZAMTD        WZAMTD
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
      ** If WZTOTD is zero, and WZTOTI is negative, setup  WZNEGD
 
     C                   IF        WZTOTD = *ZERO AND WZTOTI < *ZERO
     C                   MOVE      '.000-'       WZNEGD
     C                   ENDIF
 
      ** Restore previous indicator values
 
     C                   MOVEA     SaveIndDS     *IN(91)
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
