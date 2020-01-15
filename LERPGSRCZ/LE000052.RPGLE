     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Aggregated Facility Amendments Processing')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000052 - Aggregated Facility Amendments Processing         *
      *                                                               *
      *  Function:  This program processes the aggregated facility    *
      *             amendments to be actioned today.                  *
      *  (phase(s))                                                   *
      *  Close of Business                                            *
      *                                                               *
      *  Called By: LEC000052                                         *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. AR674226           Date 04Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
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
      *                 CLE041  *CREATE    Date 11Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. Recompile. (Child: AR674227)            *
      *           - Applied for MD054782.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00382                                 *
      *             WNCPYSRC,LEH00394                                 *
      *             WNCPYSRC,LEH00383                                 *
      *             WNCPYSRC,LEH00395                                 *
      *             WNCPYSRC,LEH00384                                 *
      *             WNCPYSRC,LEH00385                                 *
      *             WNCPYSRC,LEH00386                                 *
      *             WNCPYSRC,LEH00387                                 *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *                                                               *
      *****************************************************************
 
      ** Midas LE Agg. Facility amendment update index
     FLEAGAML0  UF A E           K DISK
 
      ** Midas LE Agg Facility Amendment Trans Trailer
     FLEAGAMZZ  UF A E           K DISK
 
      ** Midas LE Aggregate Facility File
     FLEAGFCL0  UF A E           K DISK    PREFIX(AG)
     F                                     IGNORE(FCLTYHHF:FCLTYFNF)
 
      ** Midas LE Aggregate Facilities with Actions
     FLEAGACPD  UF A E           K DISK
     F/COPY WNCPYSRC,LEH00382
 
      ** Midas LE Aggregate Facility History
     FLEAGHSPD  O    E             DISK
 
      ** Midas LE Aggregated Facility Amendments - Audit
     FLE000052AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
 
      ** Midas LE Aggregated Facility Amendments - Report
     FLE000052P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   37  - Multibranching ON                                     *
      *                                                               *
      *                                                               *
      *   89  - End of File                                           *
      *   80  - End of File                                           *
      *   81  - End of File                                           *
      *   82  - End of File                                           *
      *   83  - End of File                                           *
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
      *  SrREPORT   - Process Report Lines                            *
      *  SrHISTORY  - History Action Processing                       *
      *  SrFACUPDAT - Facility Update Processing                      *
      *  SrTRAILER  - Update the Facility Amenment trailer file       *
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
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SPOOL1          DS
      ** File Information Data Structure for LE000052P1.
      *
     D  OPNIND                 9      9
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      ** File Information Data Structure for LE000052AU.
      *
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Dummy data structures
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Dummy data structures
      *
     D/COPY WNCPYSRC,LEH00394
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External data structures for GL ICD
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  XQDFAC       E                     EXTFLD(QQDFAC)
      ** External data structures for Branch Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External data structures for Customer Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structures for Currency Details
      *
     D FacilityDS      DS
     D**WCust***               1      6S 0                                                    CSD027
     D  WCust                  1      6                                                       CSD027
     D  WFType                 7      9S 0
     D  WFSeq                 10     11S 0
      *
     D SaveIndDS       DS
     D  WIN91                  1      1
     D  WIN92                  2      2
     D  WIN93                  3      3
     D  WIN94                  4      4
     D  WIN95                  5      5
      *
     D  CPY2@          S             80
     D  RQDLN1         S              3  0
     D  DIFLN1         S              3  0
     D  PRTCD          S              7
     D  POPTN          S              7
     D  PBRCH          S              3
     D  PCNUM          S             10
     D  PCNST          S              7
     D  PCURR          S              3
     D  PDAYNO         S              5P 0
     D  PDATFMT        S              1
     D  PZDATE         S              6P 0
     D  PCDATE         S              7
     D  PZFIELD        S             16
     D  PZDEC          S              1P 0
     D  PSEQ           S              5
     D  PSENTY         S              3
     D  PZSNUM         S              6  0
     D  PZSERR         S              1
     D  PSFILE         S             10
     D  WEventCDate    S              5P 0
     D  WCount         S              5P 0
     D  WAgFacDrop     S              5P 0
     D  WRcdWrHist     S              5P 0
     D  WLiveRec       S              5P 0
     D  WValLiveRec    S             15P 0
     D  WBranch        S              3
     D  WFacility      S              5S 0
     D  WOldFAMT       S             13P 0
     D  WBkAmt         S             15P 0
     D  WBRCA          S              3
     D  WRun           S              1
     D  WRcdt          S              1
     D  WZAMT          S             15  3
     D  WZTOTI         S             15  0
     D  WZTOTD         S              3  0
     D  WZAMTI         S             15  0
     D  WZAMTD         S              3  0
     D  WZWK2          S              4  0
     D  WZWK3          S             15  0
     D  WZNEGD         S              5
      *
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
     C                   EVAL      DBPGM = 'LE000052'
     C                   OUT       LDA
 
     C/COPY WNCPYSRC,LEH00383
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
 
      ** Call Access Program for GL ICD
 
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDGELR        PARM      SDGELR        DSSDY
 
      ***  Handle Database Error.
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = POPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **   Access RUNDAT for multibranching indicator
 
     C                   IN        RUNDAT
 
     C                   IF        AGMBIN = 'Y'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
 
      ** Calculate for the event control date
 
     C                   EVAL      WEventCDate = BJDNWD - 1
     C                   IF        BKAPDT < WEventCDate
     C                   EVAL      WEventCDate = BKAPDT
     C                   ENDIF
 
      ** RCF Processing for Audit File.
 
     C                   EXSR      SrRCFAU
 
      ** Report Work fields.
 
     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0
     C                   EVAL      WCount = 0
 
      ** Initialise counters
 
     C                   EVAL      WAgFAcDrop = 0
     C                   EVAL      WRcdWrHist = 0
     C                   EVAL      WLiveRec = 0
     C                   EVAL      WValLiveRec = 0
 
      ** Key lists
 
     C     KFacility     KLIST
     C                   KFLD                    WCust
     C                   KFLD                    WFType
     C                   KFLD                    WFSeq
     C                   KFLD                    WRcdt
 
     C     KFacility2    KLIST
     C                   KFLD                    WBranch
     C                   KFLD                    WCust
     C                   KFLD                    WFacility
 
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
 
     C                   READ      LEAGAML0                               89
 
      ** If End of Records, (*IN89), Perform: Audit Reporting (No
      ** Records).
 
     C                   IF        *IN89 = *ON
     C                   EXSR      SrAUDIT
     C                   ENDIF
 
      ** Do Until End of File.
 
     C                   DOW       *IN89 = *OFF
 
      ** Reversed record, remove from file
 
     C                   IF        RECI = 'R'
     C                   DELETE    LEFCAMPF
     C                   ELSE
 
      ** Check if existing in the table
 
     C                   EVAL      WCust = CNUM
     C                   EVAL      WFType = FACT
     C                   EVAL      WFSeq = FCNO
     C                   EVAL      WRcdt = 'A'
     C     KFacility     CHAIN     LEAGFCL0                           80
 
      ** DB Error if facility not found
 
     C                   IF        *IN80 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEAGFMPD'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = FacilityDS
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,LEH00395
 
      ** Record existing, check if can be action today
 
     C                   IF        *IN80 = *OFF
     C                   IF        VLDT <= WEventCDate
     C                   EXSR      SrREPORT
     C                   EXSR      SrHISTORY
     C                   EXSR      SrFACUPDAT
     C                   DELETE    LEFCAMPF
     C                   EVAL      WCount = WCount + 1
     C                   EVAL      WAgFacDrop = WAgFacDrop + 1
     C                   ELSE
     C                   EVAL      WLiveRec = WLiveRec + 1
     C                   EVAL      WValLiveRec = WValLiveRec + AAMT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Read next record.
 
     C                   READ      LEAGAML0                               89
 
      ** End of Do Until End of Valid Records.
 
     C                   ENDDO
 
      ** Update the Trailer
 
     C                   EXSR      SrTRAILER
 
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
      /TITLE SR/SrHISTORY
      *****************************************************************
      *                                                               *
      *  SrHISTORY - History Action Processing                        *
      *                                                               *
      *****************************************************************
     C     SrHISTORY     BEGSR
 
      ** Write history record
 
     C                   EVAL      AIRECI = 'D'
     C                   EVAL      AIBRCA = BRCA
     C                   EVAL      AICNUM = CNUM
     C                   MOVEL     FACT          AIFCTY
     C                   MOVE      FCNO          AIFCTY
     C                   EVAL      AIDATE = VLDT
     C                   EVAL      AIRCIN = AGRVCR
 
     C                   SELECT
     C                   WHEN      FATP = 'FI' OR FATP = 'FD'
     C                   EVAL      AISEQ  = 97
     C                   EVAL      AITSEQ  = 97
     C                   IF        FATP = 'FI'
     C                   EVAL      AIAFAM  = AGFAMT + AAMT
     C                   ELSE
     C                   EVAL      AIAFAM  = AGFAMT - AAMT
     C                   ENDIF
     C                   WHEN      FATP = 'FR'
     C                   EVAL      AISEQ  = 96
     C                   EVAL      AITSEQ  = 96
     C                   EVAL      AIAFAM  = AAMT
     C                   WHEN      FATP = 'RC'
     C                   EVAL      AIRCIN = RVCR
     C                   EVAL      AISEQ  = -2
     C                   EVAL      AITSEQ  = -2
     C                   OTHER
     C                   EVAL      AISEQ = 0
     C                   EVAL      AITSEQ = 0
     C                   EVAL      AIAFAM  = AGFAMT
     C                   ENDSL
 
     C                   EVAL      AIACTN = FATP
     C                   EVAL      AIAAMT = AAMT
     C                   EVAL      AITRBR = *BLANK
     C**********         EVAL      AITRNM = *ZEROS                                            CSD027
     C                   EVAL      AITRNM = *BLANKS                                           CSD027
     C                   EVAL      AITRFC = *ZEROS
     C                   EVAL      AITRAM = *ZEROS
     C                   EVAL      AITRCY = *BLANK
     C                   EVAL      AITRRC = *BLANK
     C                   EVAL      AIEXRT = *ZEROS
     C                   EVAL      AIMDIN = *BLANK
     C                   EVAL      AILOAN = *ZEROS
     C                   EVAL      AIDEAL = *ZEROS
     C                   EVAL      AIUSEQ = *ZEROS
     C                   EVAL      AIMTID = *ZEROS
 
     C                   IF        AIAFAM < 0
     C                   EVAL      AIFCAM = *ZEROS
     C                   ELSE
     C                   EVAL      AIFCAM = AIAFAM
     C                   ENDIF
     C                   EVAL      AIORED = BJRDNB
 
     C/COPY WNCPYSRC,LEH00384
     C                   WRITE     LEAGHSD0
 
      ** Write/Update record to LEAGACPD
 
     C                   EVAL      WBranch = AIBRCA
     C                   EVAL      WCust = AICNUM
     C                   EVAL      WFacility = AIFCTY
 
     C     KFacility2    CHAIN     LEAGACPD                           81
 
     C                   IF        *IN81 = *OFF
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
 
     C                   EVAL      WRcdWrHist = WRcdWrHist + 1
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrFACUPDAT
      *****************************************************************
      *                                                               *
      *  SrFACUPDAT - Facility Update Processing                      *
      *                                                               *
      *****************************************************************
     C     SrFACUPDAT    BEGSR
 
     C                   IF        FATP = 'FR'
     C                   EVAL      AGRECI = 'D'
     C                   ENDIF
 
     C                   EVAL      WOldFAMT = AGFAMT
 
     C                   SELECT
     C                   WHEN      FATP = 'FI'
     C                   EVAL      AGFAMT  = AGFAMT + AAMT
     C                   WHEN      FATP = 'FD'
     C                   EVAL      AGFAMT  = AGFAMT - AAMT
     C                   WHEN      FATP = 'FR'
     C                   EVAL      AGFAMT  = AAMT
     C                   EVAL      AGDTEX  = NDEX
     C                   EVAL      AGAVLD  = NDEX
     C                   ENDSL
 
     C                   IF        FATP = 'RC'
     C                   EVAL      AGRVCR = RVCR
     C                   EVAL      AGRVCD = VLDT
     C                   ENDIF
 
     C                   UPDATE    FCLTYFMF
     C/COPY WNCPYSRC,LEH00385
 
      ** Update trailer file
 
     C**********         EVAL      WCust = 999999                                             CSD027
     C                   EVAL      WCust = '999999'                                           CSD027
     C                   EVAL      WFType = 999
     C                   EVAL      WFSeq = 99
     C                   EVAL      WRcdt = 'Z'
     C     KFacility     CHAIN     LEAGFCL0                           83
 
      ** DB Error if facility not found
 
     C                   IF        *IN83 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEAGFZPD'
     C                   EVAL      DBASE = 5
     C                   EVAL      DBKEY = 'NO RECORD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        FATP = 'FI' OR FATP = 'FD'
     C                             OR FATP = 'FR'
     C                   EVAL      AGLCD = BJRDNB
     C                   EVAL      AGCHTP = 'A'
     C                   IF        FATP = 'FR' AND AGRECI = 'C'
     C                   EVAL      AGNLRB = AGNLRB + 2
     C                   ENDIF
 
     C                   IF        FATP = 'FI' OR FATP = 'FD'
     C                   EVAL      WBkAmt = AGFAMT - WOldFAMT
     C                   ENDIF
     C                   IF        FATP = 'FR'
     C                   EVAL      WBkAmt = AGFAMT
     C                   ENDIF
 
     C                   EVAL      WZAMT = WBkAmt/1000
     C                   Z-ADD     AGVLBF        WZTOTI
     C                   Z-ADD     AGVLBL        WZTOTD
     C                   EXSR      SRZADD
     C                   Z-ADD     WZTOTI        AGVLBF
     C                   Z-ADD     WZTOTD        AGVLBL
 
     C                   IF        FATP = 'FR' AND AGRECI = 'C'
     C                   EVAL      AGNLRA = AGNLRA + 2
     C                   ENDIF
 
     C                   Z-ADD     AGVLAF        WZTOTI
     C                   Z-ADD     AGVLAL        WZTOTD
     C                   EXSR      SRZADD
     C                   Z-ADD     WZTOTI        AGVLAF
     C                   Z-ADD     WZTOTD        AGVLAL
 
     C                   UPDATE    FCLTYZZF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrTRAILER
      *****************************************************************
      *                                                               *
      *  SrTRAILER - Update the Aggregate Facility Amendment trailer  *
      *              file.                                            *
      *                                                               *
      *****************************************************************
 
     C     SrTRAILER     BEGSR
 
     C                   READ      LEAGAMZZ                               83
 
     C                   IF        *IN83 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEAGAMZZ'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = 'NO RECORD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      NORE = WLiveRec
     C                   EVAL      NINS = *ZEROS
     C                   EVAL      NAMD = *ZEROS
     C                   EVAL      NDEL = *ZEROS
     C                   EVAL      NLRB = WLiveRec
     C                   EVAL      NLRA = WLiveRec
     C                   EVAL      VIRF = *ZEROS
     C                   EVAL      VIRL = *ZEROS
     C                   EVAL      VARF = *ZEROS
     C                   EVAL      VARL = *ZEROS
     C                   EVAL      VDRF = *ZEROS
     C                   EVAL      VDRL = *ZEROS
 
     C                   EVAL      WZAMT = WValLiveRec/1000
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
 
     C                   UPDATE    LEFCAMZF
 
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
     C                   OPEN      LE000052P1
     C                   EXSR      SrRCFP1
     C                   ENDIF
 
     C                   IF        BRCA <> WBRCA
     C                   IF        WBRCA <> *BLANK
     C                   EXSR      SrP1END
     C                   CLOSE     LE000052P1
     C                   OPEN      LE000052P1
     C                   ENDIF
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      BRCA          PBRCH
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 7
     C                   EVAL      DBKEY = PBRCH
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WBRCA = BRCA
     C                   EVAL      RBRCA = A8BRCD
     C                   EVAL      RBRNM = A8BRNM
 
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out the record.
 
     C                   IF        *IN89 = *OFF
     C                   EXSR      SrP1REC
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SrP1REC
      *****************************************************************
      *                                                               *
      *  SrP1REC - Subroutine to Write a Detail record to the Report. *
      *                                                               *
      *****************************************************************
     C     SrP1REC       BEGSR
 
     C                   EVAL      RCNAME = *BLANK
     C                   EVAL      RCNUM = *BLANK
     C                   EVAL      RFCLT  = *BLANK
     C                   EVAL      RFCNO  = *BLANK
     C                   EVAL      RCCY = *BLANK
     C                   EVAL      RVDAT = *BLANK
     C                   EVAL      RACTN = *BLANK
     C                   EVAL      RDTLS = *BLANK
 
     C                   EVAL      PCNUM = *BLANK
     C                   MOVEL     CNUM          PCNUM
 
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM                    PCNST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 8
     C                   EVAL      DBKEY = PCNUM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RCNUM = PCNUM
     C                   EVAL      RCNAME = BBCSSN
     C                   MOVE      FACT          RFCLT
     C                   MOVE      FCNO          RFCNO
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      ACCY          PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 9
     C                   EVAL      DBKEY = PCURR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RCCY = A6CYCD
 
     C                   CALL      'ZDATE2'
     C                   PARM      VLDT          PDAYNO
     C                   PARM      BJDFIN        PDATFMT
     C                   PARM      *ZEROS        PZDATE
     C                   PARM      *BLANK        PCDATE
 
     C                   EVAL      RVDAT = PCDATE
 
     C                   SELECT
     C/COPY WNCPYSRC,LEH00386
     C                   WHEN      FATP = 'FI'
     C                   EVAL      RACTN = 'FACILITY INCREASE'
     C                   WHEN      FATP = 'FD'
     C                   EVAL      RACTN = 'FACILITY DECREASE'
     C                   WHEN      FATP = 'FR'
     C                   EVAL      RACTN = 'FACILITY REACTIVATION'
     C                   WHEN      FATP = 'RC'
     C                   EVAL      RACTN = 'REVOLVING CREDIT CHANGE'
     C                   ENDSL
 
     C                   IF        FATP = 'FI' OR FATP = 'FD'
     C                             OR FATP = 'FR'
 
     C                   MOVE      AAMT          PZFIELD
     C                   CALL      'ZEDIT'
     C                   PARM                    PZFIELD
     C                   PARM      A6NBDP        PZDEC
 
     C                   EVAL      RDTLS = PZFIELD
     C                   ENDIF
 
     C                   IF        FATP = 'RC'
     C                   SELECT
     C                   WHEN      AGRVCR = 'T'  AND RVCR = 'Y'
     C                   EVAL      RDTLS = 'FROM T TO Y'
     C                   WHEN      AGRVCR = 'T'  AND RVCR = 'N'
     C                   EVAL      RDTLS = 'FROM T TO N'
     C                   WHEN      AGRVCR = 'Y'  AND RVCR = 'T'
     C                   EVAL      RDTLS = 'FROM Y TO T'
     C                   WHEN      AGRVCR = 'Y'  AND RVCR = 'N'
     C                   EVAL      RDTLS = 'FROM Y TO N'
     C                   WHEN      AGRVCR = 'N'  AND RVCR = 'T'
     C                   EVAL      RDTLS = 'FROM N TO T'
     C                   WHEN      AGRVCR = 'N'  AND RVCR = 'Y'
     C                   EVAL      RDTLS = 'FROM N TO Y'
     C                   ENDSL
     C                   ENDIF
     C/COPY WNCPYSRC,LEH00387
 
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
 
     C                   EVAL      RRDROP = WAgFacDrop
     C                   EVAL      RRTRLR = WLiveRec
     C                   EVAL      RVTRLR = WValLiveRec
     C                   EVAL      RRADD  = WRcdWrHist
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
 
      **  If Error occurs during ZSFILE processing, then return to the
      **  Calling Program.
 
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
 
      **  If Error occurs during ZSFILE processing, then return to the
      **  Calling Program.
 
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
