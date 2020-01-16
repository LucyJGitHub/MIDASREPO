     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Reorg. & Archive of Aggregated Fac. Hist')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000057 - Reorganise & Archive of Aggregated Facility       *
      *             History                                           *
      *                                                               *
      *  Function:  This program drops all closed and expired records *
      *             from the Aggregated Facility History Header and   *
      *             Aggregated Facility History tables.               *
      *                                                               *
      *  (phase(s))                                                   *
      *  Close of Business                                            *
      *                                                               *
      *  Called By: LEC000057                                         *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. AR674226           Date 04Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27112           Date 01Mar10               *
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
      *  CLE148 - Alpha Loan Reference                                *
      *  BUG27112 - LEC000057 00001 (applied GEMS# 254502)            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *                                                               *
      *****************************************************************
 
      ** Midas LE Aggregated Facility History Header
     FLEAGFHPD  IF   E           K DISK
 
      ** Midas LE Aggregate Facility File
     FLEAGFCL0  IF   E           K DISK    PREFIX(AG)
     F                                     IGNORE(FCLTYHHF:FCLTYFNF:FCLTYZZF)
 
      ** Midas LE Aggregated Facility History
     FLEAGHSL0  IF   E           K DISK
 
      ** Midas LE New Agg. Facility History Header
     FLENAFHPD  O    E             DISK    RENAME(LEAGFHD0:LENAFHD0)
 
      ** Midas LE New Agg. Facility History Header
     FLENAHSPD  O    E             DISK    RENAME(LEAGHSD0:LENAHSD0)
 
      ** Midas LE Archive Agg Facility History Header
     FLEAAFHPD  O    E             DISK    RENAME(LEAGFHD0:LEAAFHD0)
 
      ** Midas LE Archive Agg Facility History
     FLEAAHSPD  O    E             DISK    RENAME(LEAGHSD0:LEAAHSD0)
 
      ** Reorgranise & Archive of Aggregated Facility Audit
     FLE000057AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
 
      ** Reorgranise & Archive of Aggregated Facility Report
     FLE000057P1O    E             PRINTER USROPN
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
      *  SrRETAIN   - Facilities not to be dropped                    *
      *  SrARCHIVE  - Drop Close and Expired Facilities               *
      *                                                               *
      *  SrP1SUBH   - Subroutine to Write the Sub-Header for P1       *
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
      ** File Information Data Structure for LE000057P1.
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
     D  WCount         S              5P 0
     D  WBranch        S              3
     D  WBRCA          S              3
     D  WFcty          S              5S 0
     D  WRun           S              1
     D  WRcdt          S              1
     D  WAgNoDec       S              1S 0
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
      ** Output Audit Report and End Program.
      *
     C                   EXSR      SrAUDIT
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
     C                   EVAL      DBPGM = 'LE000057'
     C                   OUT       LDA
      *
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
      ** Call Access Program for GL ICD
      *
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ***  Handle Database Error.
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = POPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **   Access RUNDAT for multibranching indicator
      *
     C                   IN        RUNDAT
      *
     C                   IF        AGMBIN = 'Y'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
      *
      ** RCF Processing for Audit File.
      *
     C                   EXSR      SrRCFAU
      *
      ** Report Work fields.
      *
     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0
     C                   EVAL      WCount = 0
      *
      ** Key lists
      *
     C     KFacility     KLIST
     C                   KFLD                    WCust
     C                   KFLD                    WFType
     C                   KFLD                    WFSeq
     C                   KFLD                    WRcdt
      *
     C     KAGFclty      KLIST
     C                   KFLD                    WBranch
     C                   KFLD                    WCust
     C                   KFLD                    WFcty
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
     C                   READ      LEAGFHPD                               89
      *
      ** If End of Records, (*IN89), Perform: Audit Reporting (No
      ** Records).
      *
     C                   IF        *IN89 = *ON
     C                   EXSR      SrAUDIT
     C                   ENDIF
      *
      ** Do Until End of File.
      *
     C                   DOW       *IN89 = *OFF
      *
      ** Close or expired record
      *
     C                   IF        AKRECI = 'C' OR AKRECI = 'E'
      *
      ** Check if the facility is still existing from the details file
      *
     C                   EVAL      WCust = AKCNUM
     C                   EVAL      WFType = AKFTYP
     C                   EVAL      WFSeq = AKFSEQ
     C                   EVAL      WRcdt = 'A'
      *
     C     KFacility     CHAIN     LEAGFCL0                           81
      *
      ** Do not drop if existing, otherwise drop the record
      ** and write to archive files
      *
     C                   IF        *IN81 = *OFF
     C                   EXSR      SrRETAIN
     C                   ELSE
     C                   EXSR      SrP1SUBH
     C                   EXSR      SrARCHIVE
      *
      ** Increment archived record counter
      *
     C                   EVAL      WCount = WCount + 1
     C                   ENDIF
     C                   ENDIF
      *
      ** Retain the facility if live
      *
     C                   IF        AKRECI = 'D'
     C                   EXSR      SrRETAIN
     C                   ENDIF
      *
     C                   READ      LEAGFHPD                               89
     C                   ENDDO
      *
      ** Write final records and Totals to Report.
      *
     C                   IF        WCount <> 0
     C                   IF        *IN37 = *ON
     C                   EXSR      SrP1END
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF
     C                   EXSR      SrP1END
     C                   ENDIF
      *
     C                   EXSR      SrAUDIT
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SrRETAIN
      *****************************************************************
      *                                                               *
      *  SrRETAIN - Facilities not to be dropped                      *
      *                                                               *
      *****************************************************************
      *
     C     SrRETAIN      BEGSR
      *
      ** Write record to LENAFHPD which will be copied back to LEAGFHPD
      ** after this program
      *
     C                   WRITE     LENAFHD0
      *
     C                   EVAL      WBranch = AKBRCA
     C                   EVAL      WCust = AKCNUM
     C                   EVAL      WFcty = (AKFTYP * 100) + AKFSEQ
     C     KAGFclty      SETLL     LEAGHSL0
     C                   READ      LEAGHSL0                               82
      *
     C                   DOW       *IN82 = *OFF AND WBranch = AIBRCA AND
     C                             WCust = AICNUM  AND WFcty = AIFCTY
      *
      ** Write record to detail file
      *
     C                   WRITE     LENAHSD0
      *
      ** Read next record
      *
     C                   READ      LEAGHSL0                               82
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SrARCHIVE
      *****************************************************************
      *                                                               *
      *  SrARCHIVE - Drop Close and Expired Facilities                *
      *                                                               *
      *****************************************************************
      *
     C     SrARCHIVE     BEGSR
      *
      ** Write record to LEAAFHPD (archived facility records)
      *
     C                   WRITE     LEAAFHD0
      *
     C                   EVAL      WBranch = AKBRCA
     C                   EVAL      WCust = AKCNUM
     C                   EVAL      WFcty = (AKFTYP * 100) + AKFSEQ
     C     KAGFclty      SETLL     LEAGHSL0
     C                   READ      LEAGHSL0                               82
      *
     C                   DOW       *IN82 = *OFF AND WBranch = AIBRCA AND
     C                             WCust = AICNUM  AND WFcty = AIFCTY
      *
      ** Write record to detail archive file
      *
     C                   WRITE     LEAAHSD0
      *
      ** Generate report
      *
     C                   EXSR      SrREPORT
      *
      ** Read next record
      *
     C                   READ      LEAGHSL0                               82
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SrP1SUBH
      *****************************************************************
      *                                                               *
      *  SrP1SUBH - Subroutine to Write a Sub-Header for P1 Report    *
      *                                                               *
      *****************************************************************
      *
     C     SrP1SUBH      BEGSR
      *
     C                   IF        OPNIND = '0'
     C                   OPEN      LE000057P1
     C                   EXSR      SrRCFP1
     C                   ENDIF
      *
      ** Change in branch, write header details
      *
     C                   IF        AKBRCA <> WBRCA
     C                   IF        WBRCA <> *BLANK
     C                   EXSR      SrP1END
     C                   CLOSE     LE000057P1
     C                   OPEN      LE000057P1
     C                   ENDIF
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      AKBRCA        PBRCH
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = PBRCH
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      WBRCA = AKBRCA
     C                   EVAL      RBRCA = A8BRCD
     C                   EVAL      RBRNM = A8BRNM
      *
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C                   EVAL      RCUST = *BLANK
     C                   EVAL      RCNAM = *BLANK
     C                   EVAL      RFCTY  = *BLANK
     C                   EVAL      RFSEQ  = *BLANK
     C                   EVAL      RCCY = *BLANK
     C                   EVAL      RRVCR = *BLANK
     C                   EVAL      ROAMT = *BLANK
      *
     C                   EVAL      PCNUM = *BLANK
     C                   MOVEL     AKCNUM        PCNUM
      *
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM                    PCNST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = PCNUM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      RCUST = PCNUM
     C                   EVAL      RCNAM = BBCSSN
     C                   MOVE      AKFTYP        RFCTY
     C                   MOVE      AKFSEQ        RFSEQ
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      AKFCCY        PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 5
     C                   EVAL      DBKEY = PCURR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      RCCY = A6CYCD
     C                   EVAL      RRVCR = AKRCIN
     C                   EVAL      WAgNoDec = A6NBDP
      *
     C                   MOVE      AKOFAM        PZFIELD
     C                   CALL      'ZEDIT'
     C                   PARM                    PZFIELD
     C                   PARM      A6NBDP        PZDEC
      *
     C                   EVAL      ROAMT = PZFIELD
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     3             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C                   WRITE     SUBHD1
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     5             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     SUBHD2
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SrREPORT
      *****************************************************************
      *                                                               *
      *  SrREPORT - Process Report Lines                              *
      *                                                               *
      *****************************************************************
      *
     C     SrREPORT      BEGSR
      *
     C                   EVAL      RDATE1 = *BLANK
     C                   EVAL      RACTN1 = *BLANK
     C                   EVAL      RAAMT1  = *BLANK
     C                   EVAL      RFAMT1 = *BLANK
     C                   EVAL      RREVC1 = *BLANK
     C                   EVAL      RBRAN2 = *BLANK
     C                   EVAL      RCNUM2 = *BLANK
     C                   EVAL      RFACT2 = *BLANK
     C                   EVAL      RFCNO2 = *BLANK
     C                   EVAL      RAAMT2 = *BLANK
     C                   EVAL      RCURR2 = *BLANK
     C                   EVAL      RREVC2 = *BLANK
     C                   EVAL      REXRT2 = *BLANK
     C                   EVAL      RMOD2 = *BLANK
     C                   EVAL      RTRAN2 = *BLANK
      *
     C                   CALL      'ZDATE2'
     C                   PARM      AIDATE        PDAYNO
     C                   PARM      BJDFIN        PDATFMT
     C                   PARM      *ZEROS        PZDATE
     C                   PARM      *BLANK        PCDATE
      *
     C                   EVAL      RDATE1 = PCDATE
     C                   EVAL      RACTN1 = AIACTN
      *
     C                   MOVE      AIAAMT        PZFIELD
     C                   CALL      'ZEDIT'
     C                   PARM                    PZFIELD
     C                   PARM      WAgNoDec      PZDEC
      *
     C                   EVAL      RAAMT1 = PZFIELD
      *
     C                   MOVE      AIAFAM        PZFIELD
     C                   CALL      'ZEDIT'
     C                   PARM                    PZFIELD
     C                   PARM      WAgNoDec      PZDEC
      *
     C                   EVAL      RFAMT1 = PZFIELD
     C                   EVAL      RREVC1 = AIRCIN
      *
     C                   EVAL      RBRAN2 = AITRBR
     C**********         EVAL      RCNUM2 = %EDITC(AITRNM:'X')                                CSD027
     C                   EVAL      RCNUM2 = AITRNM                                            CSD027
     C                   EVAL      RFACT2 = %SUBST(%EDITC(AITRFC:'X'):1:3)
     C                   EVAL      RFCNO2 = %SUBST(%EDITC(AITRFC:'X'):4:2)
      *
     C                   IF        AITRNM <> *BLANKS AND AITRFC <> *ZEROS                   BUG27112
      *                                                                                     BUG27112
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      AITRCY        PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = PCURR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                     BUG27112
     C                   ENDIF                                                              BUG27112
      *
     C                   EVAL      RCURR2 = A6CYCD
      *
     C                   MOVE      AITRAM        PZFIELD
     C                   CALL      'ZEDIT'
     C                   PARM                    PZFIELD
     C                   PARM      A6NBDP        PZDEC
      *
     C                   EVAL      RAAMT2 = PZFIELD
     C                   EVAL      RREVC2 = AITRRC
      *
     C                   MOVE      AIEXRT        PZFIELD
     C                   CALL      'ZEDIT'
     C                   PARM                    PZFIELD
     C                   PARM      7             PZDEC
      *
     C                   EVAL      REXRT2 = PZFIELD
     C                   EVAL      RMDIN2 = AIMDIN
      *
     C                   SELECT
     C**********         WHEN      AILOAN <> *ZERO                                            CLE148
     C                   WHEN      AILOAN <> *BLANKS                                          CLE148
     C                   EVAL      RMOD2 = 'LE'
     C**********         EVAL      RTRAN2 = %EDITC(AILOAN:'X')                                CLE148
     C                   EVAL      RTRAN2 = AILOAN                                            CLE148
     C                   WHEN      AIDEAL <> *ZERO
     C                   EVAL      RMOD2 = 'DL'
     C                   EVAL      RTRAN2 = %EDITC(AIDEAL:'X')
     C                   WHEN      AIUSEQ <> *ZERO
     C                   EVAL      RMOD2 = 'MT'
     C                   EVAL      RTRAN2 = %EDITC(AIUSEQ:'X')
     C                   ENDSL
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   WRITE     SUBHD2
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SrP1END
      *****************************************************************
      *                                                               *
      *  SrP1END - Subroutine to Write End of Report.                 *
      *                                                               *
      *****************************************************************
      *
     C     SrP1END       BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out Total Format.
      *
     C                   WRITE     TRAILP1
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SrAUDIT
      *****************************************************************
      *                                                               *
      *  SrAUDIT  - Subroutine to Output Audit report and End         *
      *             Program                                           *
      *                                                               *
      *****************************************************************
      *
     C     SrAUDIT       BEGSR
      *
      ** Output Report Header and File Controls.
      *
     C                   IF        *INU7 = *ON OR WCount = 0
     C                   WRITE     HEADAU
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C                   IF        WCount = 0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** End Program and Return.
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
     C                   EXSR      SrAUDIT
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
      /TITLE SR/SrRCFP1
      *****************************************************************
      *                                                               *
      *  SrRCFP1  - Subroutine to register the P1 Printer File via    *
      *             RCF.                                              *
      *                                                               *
      *****************************************************************
      *
     C     SrRCFP1       BEGSR
      *
      ***  Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        PZSNUM
      *
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILE1        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANKS       PZSERR
      *
      ***  If Error occurs during ZSFILE processing, then return to the
      ***  Calling Program.
      *
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SrRCFAU
      *****************************************************************
      *                                                               *
      *  SrRCFAU  - Subroutine to register the AU Printer File via    *
      *             RCF.                                              *
      *                                                               *
      *****************************************************************
      *
     C     SrRCFAU       BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        PZSNUM
      *
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILEU        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR
      *
      ***  If Error occurs during ZSFILE processing, then return to the
      ***  Calling Program.
      *
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
