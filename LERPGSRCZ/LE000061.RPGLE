     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Extract Manual Changes to the Agg. Fclty')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000061 - Extract Manual Changes to the Aggregated Facility *
      *                                                               *
      *  Function:  This program processes the Facility Start, Faci   *
      *             lity Expiry and Facility Closure against          *
      *             aggregated facilities                             *
      *  (phase(s))                                                   *
      *  Close of Business                                            *
      *                                                               *
      *  Called By: LEC000061                                         *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. AR674226           Date 04Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE041  *CREATE    Date 11Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. Recompile. (Child: AR674227)            *
      *           - Applied for MD054782.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00398                                 *
      *             WNCPYSRC,LEH00399                                 *
      *             WNCPYSRC,LEH00400                                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *                                                               *
      *****************************************************************
 
      ** Midas LE Aggregate Facility File
     FLEAGFCL0  IF   E           K DISK    IGNORE(FCLTYHHF:FCLTYFNF:FCLTYZZF)
     F/COPY WNCPYSRC,LEH00398
 
      ** Midas LE Aggregate Facilities with Actions
     FLEAGACPD  UF A E           K DISK
 
      ** Midas LE Aggregated Facility History Header
     FLEAGFHPD  UF A E           K DISK
 
      ** Midas LE Aggregated Facility History
     FLEAGHSPD  O    E             DISK
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   89  - End of File                                           *
      *   80  - End of File                                           *
      *   81  - End of File                                           *
      *   82  - End of File                                           *
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
      *  SrTERM     - Terminate Program                               *
      *  SrNEWHEAD  - Write new header details                        *
      *  SrUPDHEAD  - Update header details                           *
      *                                                               *
      *  *PSSR      - Program Error Processing Subroutine             *
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
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Dummy data structures
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details
      *
     D  CPY2@          S             80
     D  PRTCD          S              7
     D  POPTN          S              7
     D  WBranch        S              3
     D  WBranch2       S              3
     D**WCustomer      S              6S 0                                                    CSD027
     D**WCustomer2     S              6S 0                                                    CSD027
     D  WCustomer      S              6                                                       CSD027
     D  WCustomer2     S              6                                                       CSD027
     D  WFType         S              3S 0
     D  WFSequence     S              2S 0
     D  WFacility2     S              5S 0
     D  WRun           S              1
      *
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform Initialisation.
      *
     C                   EXSR      SrINIT
      *
      ** Perform Detail Processing.
      *
     C                   EXSR      SrPROCES
      *
      ** Terminate Program.
      *
     C                   EXSR      SrTERM
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrINIT - Subroutine to do Program Initialisation.            *
      *                                                               *
      *****************************************************************
      *
     C     SrINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   EVAL      CPY2@ = CPY@(1)
      *
      ** Initialise LDA field.
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'LE000061'
     C                   OUT       LDA
      *
     C/COPY WNCPYSRC,LEH00399
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Key lists
      *
     C     KFacility     KLIST
     C                   KFLD                    WBranch
     C                   KFLD                    WCustomer
     C                   KFLD                    WFType
     C                   KFLD                    WFSequence
      *
     C     KFacility2    KLIST
     C                   KFLD                    WBranch2
     C                   KFLD                    WCustomer2
     C                   KFLD                    WFacility2
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SrPROCES
      *****************************************************************
      *                                                               *
      *  SrPROCES - Subroutine to do the Detail Processing.           *
      *                                                               *
      *****************************************************************
      *
     C     SrPROCES      BEGSR
      *
      ** Read first record from File.
      *
     C     *LOVAL        SETLL     LEAGFCL0
     C                   READ      LEAGFCL0                               89
      *
      ** Check if the facility already exists in the aggregated facility his
      ** tory header
      *
     C                   DOW       *IN89 = *OFF
      *
     C                   IF        RECI = 'D' OR RECI = 'C' OR RECI = 'E'
     C                   EVAL      WBranch = BRCA
     C                   EVAL      WCustomer = CNUM
     C                   EVAL      WFType = FACT
     C                   EVAL      WFSequence = FCNO
     C     KFacility     CHAIN     LEAGFHPD                           81
      *
      ** Write new header if not found otherwise update the existing record
      *
     C                   IF        *IN81 = *ON
     C                   EXSR      SrNEWHEAD
     C                   ELSE
     C                   EXSR      SrUPDHEAD
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      LEAGFCL0                               89
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SrNEWHEAD
      *****************************************************************
      *                                                               *
      *  SrNEWHEAD - Write new aggregated facility history record     *
      *              header                                           *
      *                                                               *
      *****************************************************************
      *
     C     SrNEWHEAD     BEGSR
      *
      ** Write history record
      *
     C                   EVAL      AKRECI = RECI
     C                   EVAL      AKBRCA = BRCA
     C                   EVAL      AKCNUM = CNUM
     C                   EVAL      AKFTYP = FACT
     C                   EVAL      AKFSEQ = FCNO
     C                   EVAL      AKFCCY = FCCY
     C                   EVAL      AKOFAM = FAMT
     C                   EVAL      AKRCIN = RVCR
     C                   EVAL      AKORED = BJRDNB
      *
     C                   WRITE     LEAGFHD0
      *
      ** Write history detail record
      *
     C                   EVAL      AIRECI = 'D'
     C                   EVAL      AIBRCA = BRCA
     C                   EVAL      AICNUM = CNUM
     C                   EVAL      AIFCTY = (FACT * 100) + FCNO
     C                   EVAL      AIDATE = DTAP
     C                   EVAL      AISEQ  = 1
     C                   EVAL      AIACTN = 'FS'
     C                   EVAL      AIAAMT = FAMT
     C                   EVAL      AIRCIN = RVCR
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
     C                   EVAL      AIFCAM = FAMT
     C                   EVAL      AIAFAM = FAMT
     C                   EVAL      AIORED = BJRDNB
      *
     C/COPY WNCPYSRC,LEH00400
     C                   WRITE     LEAGHSD0
      *
      ** Write history 'FC' record for facility which was both inserted
      ** and then closed during the same input cycle
      *
     C                   IF        RECI = 'C' AND ORED = BJRDNB
     C                   EVAL      AIRECI = 'D'
     C                   EVAL      AIBRCA = BRCA
     C                   EVAL      AICNUM = CNUM
     C                   EVAL      AIFCTY = (FACT * 100) + FCNO
     C                   EVAL      AIDATE = BJRDNB
     C                   EVAL      AISEQ  = 99
     C                   EVAL      AIACTN = 'FC'
     C                   EVAL      AIAAMT = *ZERO
     C                   EVAL      AIRCIN = RVCR
     C                   EVAL      AITSEQ = 99
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
     C                   EVAL      AIFCAM = *ZERO
     C                   EVAL      AIAFAM = *ZERO
     C                   EVAL      AIORED = BJRDNB
      *
     C                   WRITE     LEAGHSD0
     C                   ENDIF
      *
      ** Write/Update record to LEAGACPD
      *
     C                   EVAL      WBranch2 = BRCA
     C                   EVAL      WCustomer2 = CNUM
     C                   EVAL      WFacility2 = (FACT * 100) + FCNO
      *
     C     KFacility2    CHAIN     LEAGACPD                           82
      *
     C                   IF        *IN82 = *OFF
     C                   IF        DTAP < AJDATE
     C                   EVAL      AJDATE = DTAP
     C                   UPDATE    LEAGACD0
     C                   ENDIF
     C                   ELSE
     C                   EVAL      AJDATE = DTAP
     C                   EVAL      AJBRCA = BRCA
     C                   EVAL      AJCNUM = CNUM
     C                   EVAL      AJFCTY = WFacility2
     C                   WRITE     LEAGACD0
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SrUPDHEAD
      *****************************************************************
      *                                                               *
      *  SrUPDHEAD - Update the aggregated facility history record    *
      *              header                                           *
      *                                                               *
      *****************************************************************
      *
     C     SrUPDHEAD     BEGSR
      *
      ** Write history record
      *
     C                   IF        AKRECI = 'D' AND RECI = 'E'
     C                   EVAL      AIRECI = 'D'
     C                   EVAL      AIBRCA = BRCA
     C                   EVAL      AICNUM = CNUM
     C                   EVAL      AIFCTY = (FACT * 100) + FCNO
     C                   EVAL      AIDATE = DTEX
     C                   EVAL      AISEQ  = 99
     C                   EVAL      AIACTN = 'FE'
     C                   EVAL      AIAAMT = *ZERO
     C                   EVAL      AIRCIN = RVCR
     C                   EVAL      AITSEQ = 99
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
     C                   EVAL      AIFCAM = *ZERO
     C                   EVAL      AIAFAM = *ZERO
     C                   EVAL      AIORED = BJRDNB
      *
     C                   WRITE     LEAGHSD0
      *
      ** Write/Update record to LEAGACPD
      *
     C                   EVAL      WBranch2 = AIBRCA
     C                   EVAL      WCustomer2 = AICNUM
     C                   EVAL      WFacility2 = AIFCTY
      *
     C     KFacility2    CHAIN     LEAGACPD                           82
      *
     C                   IF        *IN82 = *OFF
     C                   IF        AIDATE < AJDATE
     C                   EVAL      AJDATE = AIDATE
     C                   UPDATE    LEAGACD0
     C                   ENDIF
     C                   ELSE
     C                   EVAL      AJDATE = AIDATE
     C                   EVAL      AJBRCA = AIBRCA
     C                   EVAL      AJCNUM = AICNUM
     C                   EVAL      AJFCTY = AIFCTY
     C                   WRITE     LEAGACD0
     C                   ENDIF
     C                   ENDIF
      *
      ** Write history 'FC' record for closed facility
      *
     C                   IF        AKRECI = 'D' AND RECI = 'C'
     C                   EVAL      AIRECI = 'D'
     C                   EVAL      AIBRCA = BRCA
     C                   EVAL      AICNUM = CNUM
     C                   EVAL      AIFCTY = (FACT * 100) + FCNO
     C                   EVAL      AIDATE = BJRDNB
     C                   EVAL      AISEQ  = 99
     C                   EVAL      AIACTN = 'FC'
     C                   EVAL      AIAAMT = *ZERO
     C                   EVAL      AIRCIN = RVCR
     C                   EVAL      AITSEQ = 99
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
     C                   EVAL      AIFCAM = *ZERO
     C                   EVAL      AIAFAM = *ZERO
     C                   EVAL      AIORED = BJRDNB
      *
     C                   WRITE     LEAGHSD0
      *
      ** Write/Update record to LEAGACPD
      *
     C                   EVAL      WBranch2 = AIBRCA
     C                   EVAL      WCustomer2 = AICNUM
     C                   EVAL      WFacility2 = AIFCTY
      *
     C     KFacility2    CHAIN     LEAGACPD                           82
      *
     C                   IF        *IN82 = *OFF
     C                   IF        AIDATE < AJDATE
     C                   EVAL      AJDATE = AIDATE
     C                   UPDATE    LEAGACD0
     C                   ENDIF
     C                   ELSE
     C                   EVAL      AJDATE = AIDATE
     C                   EVAL      AJBRCA = AIBRCA
     C                   EVAL      AJCNUM = AICNUM
     C                   EVAL      AJFCTY = AIFCTY
     C                   WRITE     LEAGACD0
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SrTERM
      *****************************************************************
      *                                                               *
      *  SrTERM   - Terminate Program.                                *
      *                                                               *
      *****************************************************************
      *
     C     SrTERM        BEGSR
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
