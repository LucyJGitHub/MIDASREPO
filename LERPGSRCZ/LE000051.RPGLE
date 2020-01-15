     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Aggr. Facility Reductions for Repayments')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000051 - Aggregated Facility Reductions for Repayments     *
      *                                                               *
      *  Function:  This program will reduce the facility amount of   *
      *  (COB)      affected non-revolving aggregated facilities due  *
      *             to the repayments done on the tranche facilities, *
      *             and to keep these events in the history.          *
      *                                                               *
      *  Called By: LEC000051 - Aggregated Facility Reductions for    *
      *                         Repayments Control                    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. AR674226           Date 04Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
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
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *                                                               *
      *****************************************************************
     FLE000051AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
      ** Aggregated Facility Reductions for Repayments - Audit
 
     FLE000051P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
      ** Aggregated Facility Reductions for Repayments - Report
 
     FLEAGRDL1  IF   E           K DISK    INFSR(*PSSR)
      ** Aggregated Facility Reduction by Branch, Aggregate Facility/Value Date
 
     FLEAGHSL0  UF A E           K DISK    INFSR(*PSSR)
      ** Aggregated Facility History by Facility/Value Date/Sequence
 
     FLEAGACPD  UF A E           K DISK    INFSR(*PSSR)
      ** Aggregated Facilities with Actions
 
     FLEAGFYL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AA)
      ** Aggregate Facilities detail A record
     FLEAGFCL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYFMF)
     F                                     IGNORE(FCLTYFNF)
      ** Aggregate Facilities File
 
      *****************************************************************
      /EJECT
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
 
     D LDA           E DS           256    EXTNAME(LDA)
      *
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
      ** Rundate data area
 
     D LERSTS        E DS                  EXTNAME(LERSTS) DTAARA(LERSTS)
      ** Status data area for Fees & Profitabilities
 
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
     D SPOOL1          DS
      ** File Information Data Structure for LE000051P1
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D SPOOLU          DS
      ***  File Information Data Structure for LE000051AU
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
     D                 DS
     D WkFclty                 1     14
     D AHAGBR                  1      3
     D*AHAGNM***               4      9  0                                                    CSD027
     D AHAGNM                  4      9                                                       CSD027
     D AHAGFX                 10     14  0
     D AHAGFT                 10     12  0
     D AHAGFN                 13     14  0
 
     D                 DS
     D R1FCLT                  1      6
     D WkSlash                 4      4
 
      ***  Dummy Data Structures used by Access Programs.
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External data structures for Bank Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ***  External data structures for General Ledger ICD
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ***  External data structures for Branch Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External data structures for Currency Details
 
     D SDCUHS        E DS                  EXTNAME(SDCUHSPD)
      ***  External data structures for Historic Spot Rates Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  Short data structures for Access Objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WkOpen          S              1
     D PSeq            S              5
     D PEnty           S              3
     D PRtCd           S              7
     D POptn           S              7
     D PCcy            S              3
     D PBrca           S              3
     D PFld15          S             15  0
     D PDecs           S              1  0
     D PECode          S              1
     D Zout21          S             21
     D PZSErr          S              1
     D PZSNum          S              6  0
     D PSFile          S             10
     D WRun            S              1
     D WkSPRT          S             13P 8
     D WkMDIN          S              1
     D WFAMT           S             15  0
     D TFAMT           S             15  0
     D WAFAM           S             15  0
     D WRVCR           S              1
     D WEFRC           S              1
     D WkOFAMT         S             13  0
     D WkPrvBrc        S              3
     D*WkPrvCNo*       S              6  0                                                    CSD027
     D WkPrvCNo        S              6                                                       CSD027
     D WkPrvFcT        S              3  0
     D WkPrvFcN        S              2  0
     D PDate           S              5  0
     D WRKTOT          S             18  0
     D ACT@            S             80
     D RQDLN1          S              3  0
     D DIFLN1          S              3  0
 
      ** Parameters for ZXRATE module
     D ZRATE1          S             13P 8
     D ZMDI1           S              1
     D ZRATE2          S             13P 8
     D ZMDI2           S              1
     D ZRATEX          S             13P 8
     D ZMDIX           S              1
 
      ** Parameters for ZCONVZ1 module
     D ZAMTCI          S             15  0
     D ZEXCH           S             13P 8
     D ZMD             S              1
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 3
      *****************************************************************
      /EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Perform Initialisation.
     C                   EXSR      SRInit
 
      ** Perform Detail Processing.
     C                   EXSR      SRProcess
 
      ** Output Audit Report and End Program.
     C                   EXSR      SRAudit
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Subroutine to do Program Initialisation.            *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Set up copyright parameter
     C                   MOVEA     CPY@          ACT@
 
      ** Initialise LDA field.
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBMOD = 'LE000051'
     C                   EVAL      DBPGM = 'LE000051'
     C                   OUT       LDA
 
      ** Access LE Status dtaara for Fees & Profitability
     C                   IN        LERSTS
 
      ** Access RUNDAT for multibranching indicator
     C                   IN        RUNDAT
 
     C                   IF        AGMBIN = 'Y'
     C                   MOVE      *ON           *IN37
     C                   ENDIF
 
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error.
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check System Date Format, DDMMYY (*IN98 off)
      **                           MMDDYY (*IN98 on).
     C                   IF        BJDFIN = 'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
 
      ** Call Access Program for General Ledger Details
     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSFDY
 
      ** Handle Database Error.
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     KLFclt1       KLIST
     C                   KFLD                    AHAGBR
     C                   KFLD                    AHAGNM
     C                   KFLD                    AHAGFT
     C                   KFLD                    AHAGFN
 
     C     KLFclt2       KLIST
     C                   KFLD                    AHAGBR
     C                   KFLD                    AHAGNM
     C                   KFLD                    AHAGFX
     C                   KFLD                    AHVDAT
 
     C     KLFclt3       KLIST
     C                   KFLD                    AHAGBR
     C                   KFLD                    AHAGNM
     C                   KFLD                    AHAGFX
 
      ** Ensure Audit Spool File recorded by RCF.
     C                   MOVEL     SFILEU        PSFile
     C                   Z-ADD     SFNUMU        PZSNum
 
     C                   EXSR      SRRCFProc
 
      ** Report Work fields.
     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0
 
     C                   EVAL      WFAMT = 0
     C                   EVAL      TFAMT = 0
     C                   EVAL      WkPrvBrc = *BLANKS
     C**********         EVAL      WkPrvCNo = 0                                               CSD027
     C                   EVAL      WkPrvCNo = *BLANKS                                         CSD027
     C                   EVAL      WkPrvFcT = 0
     C                   EVAL      WkPrvFcN = 0
 
      ** Initialise report fields
     C                   EXSR      SRInitRFld
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Subroutine to do the Detail Processing           *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
 
      ** Read first record from File.
     C     *LOVAL        SETLL     LEAGRDL1
     C                   READ      LEAGRDL1                               89
 
      ** Do While not End of File
     C                   DOW       *IN89 = *OFF
 
      ** If aggregate facility changed, access corresponding record from
      ** aggregate facilities detail A table
     C                   IF        WkPrvBrc <> AHAGBR OR
     C                             WkPrvCNo <> AHAGNM OR
     C                             WkPrvFcT <> AHAGFT OR
     C                             WkPrvFcN <> AHAGFN
 
     C     KLFclt1       CHAIN     LEAGFYL1                           90
     C                   IF        *IN90 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'LEAGFYL1'
     C                   EVAL      DBKEY = WkFclty
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WFAMT = 0
     C                   ENDIF
 
      ** Process Loan Actions
     C                   EXSR      SRProcLAct
 
     C                   EVAL      WkPrvBrc = AHAGBR
     C                   EVAL      WkPrvCNo = AHAGNM
     C                   EVAL      WkPrvFcT = AHAGFT
     C                   EVAL      WkPrvFcN = AHAGFN
 
      ** Read next record.
     C                   READ      LEAGRDL1                               89
 
      ** If aggregate facility changed or end of file, update aggregated
      ** facility amount
     C                   IF        WkPrvBrc <> AHAGBR OR
     C                             WkPrvCNo <> AHAGNM OR
     C                             WkPrvFcT <> AHAGFT OR
     C                             WkPrvFcN <> AHAGFN OR
     C                             *IN89 = *ON
     C                   IF        WFAMT <> 0
     C                   EXSR      SRUpdAggFac
 
      ** Process Report Lines.
     C                   EXSR      SRReport
 
      ** Count records read.
     C                   ADD       1             RCOUNT
     C                   ENDIF
     C                   ENDIF
 
      ** End of Do Until End of Valid Records.
     C                   ENDDO
 
      ** Write End of Report.
     C                   IF        WkOpen = *ON
     C                   EXSR      SRWriteEnd
     C                   ENDIF
 
     C                   EXSR      SRUpdAggTrl
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdAggFac - Subroutine that Updates Aggregate Facility     *
      *                Record A File                                  *
      *                                                               *
      *****************************************************************
     C     SRUpdAggFac   BEGSR
 
     C                   EVAL      WkOFAMT = AAFAMT
     C                   EVAL      AAFAMT = AAFAMT - WFAMT
 
     C                   IF        AAFAMT < 0
     C                   EVAL      AAFAMT = 0
     C                   ENDIF
 
     C                   EVAL      TFAMT = TFAMT + WkOFAMT - AAFAMT
 
     C                   UPDATE    FCLTYFMF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdAggTrl - Subroutine that Updates Trailer File LEAGFZPD  *
      *                                                               *
      *****************************************************************
     C     SRUpdAggTrl   BEGSR
 
     C                   IF        RCOUNT <> *ZEROS
     C     *LOVAL        SETLL     LEAGFCL0
     C                   READ      FCLTYZZF                               93
 
     C                   IF        *IN93 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'LEAGFZPD'
     C                   EVAL      DBKEY = '*READ   '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Adjust both the value before and the values after for the
      ** the total amount reduced.
     C     VLBF          MULT      1000          WRKTOT
     C                   ADD       VLBL          WRKTOT
     C     WRKTOT        SUB       TFAMT         WRKTOT
     C     WRKTOT        DIV       1000          VLBF
     C                   MVR                     VLBL
     C     VLAF          MULT      1000          WRKTOT
     C                   ADD       VLAL          WRKTOT
     C     WRKTOT        SUB       TFAMT         WRKTOT
     C     WRKTOT        DIV       1000          VLAF
     C                   MVR                     VLAL
     C                   EVAL      LCD = BJRDNB
     C                   EVAL      CHTP = 'A'
     C                   UPDATE    FCLTYZZF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcLAct - Subroutine to Process Loan Actions              *
      *                                                               *
      *****************************************************************
     C     SRProcLAct    BEGSR
 
     C                   EVAL      WRVCR = AARVCR
     C                   EVAL      WAFAM = AAFAMT
 
     C                   IF        AHVDAT < BJRDNB OR
     C                             AHVDAT <= BKAPDT AND BKAPFQ = 'D'
     C                   IF        AHVDAT < FACHISD
     C                   EVAL      AHVDAT = FACHISD
     C                   ENDIF
     C                   ENDIF
 
     C     KLFclt2       SETGT     LEAGHSL0
     C     KLFclt3       READPE    LEAGHSL0                               91
     C                   IF        *IN91 = *OFF
     C                   EVAL      WRVCR = AIRCIN
     C                   EVAL      WAFAM = AIAFAM
     C                   ENDIF
 
      ** If revolving credit indicator is 'T', inherit its tranche's revolving
      ** credit indicator
     C                   IF        WRVCR = 'T'
     C                   EVAL      WEFRC = AHTRRC
     C                   ELSE
     C                   EVAL      WEFRC = WRVCR
     C                   ENDIF
 
     C                   EXSR      SRSetFFld
 
     C                   WRITE     LEAGHSD0
 
      ** Check if the aggregate facility exists in the Aggregated Facilities
      ** with Actions table. If it does, update its value date with that of
      ** aggregate facility reduction value date, otherwise, write this as a
      ** new record
     C     KLFclt3       CHAIN     LEAGACPD                           92
 
     C                   IF        *IN92 = *OFF
     C                   IF        AIDATE < AJDATE
     C                   EVAL      AJDATE = AIDATE
     C                   UPDATE    LEAGACD0
     C                   ENDIF
     C                   ELSE
     C                   EVAL      AJBRCA = AHAGBR
     C                   EVAL      AJCNUM = AHAGNM
     C                   EVAL      AJFCTY = AHAGFX
     C                   EVAL      AJDATE = AIDATE
     C                   WRITE     LEAGACD0
     C                   ENDIF
 
     C                   IF        WEFRC <> 'Y'
     C                   EVAL      WFAMT = WFAMT + AIAAMT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetFFld - Subroutine to Set the File Fields before WRITE   *
      *                                                               *
      *****************************************************************
     C     SRSetFFld     BEGSR
 
     C                   EVAL      AIRECI = 'D'
     C                   EVAL      AIBRCA = AHAGBR
     C                   EVAL      AICNUM = AHAGNM
     C                   MOVEL     AHAGFT        AIFCTY
     C                   MOVE      AHAGFN        AIFCTY
     C                   EVAL      AIDATE = AHVDAT
     C                   EVAL      AISEQ = 98
     C                   EVAL      AIACTN = AHAMTP
 
     C                   EVAL      AIAAMT = 0
     C                   EVAL      ZEXCH = 0
     C                   EVAL      ZMD = *BLANKS
 
      ** If non-revolving credit, set action amount as reduction amount
     C                   IF        WEFRC <> 'Y'
 
      ** If tranche facility currency is not equal to aggregate facility ccy,
      ** perform conversions
     C                   IF        AAFCCY <> AHTRCY
 
      ** Get the cross rate between the tranche ccy & aggregate facility ccy
     C                   EVAL      ZCCYI = AHTRCY
     C                   EVAL      ZCCYO = AAFCCY
     C                   EXSR      SRGetXRate
     C                   EVAL      ZEXCH = ZRATEX
     C                   EVAL      ZMD = ZMDIX
 
      ** Convert reduction amount from tranche ccy to aggregate facility ccy
     C                   EVAL      ZAMTCI = AHRAMT
     C                   EXSR      SRCvtAmount
     C                   EVAL      AIAAMT = ZAMTCO
     C                   ELSE
 
      ** Get Details of the Facility Currency
     C                   EVAL      I#LFD1 = AAFCCY
     C                   EXSR      SRGetCurDet
     C                   EVAL      ZCDPO = A6NBDP
     C                   Z-ADD     1             ZEXCH
     C                   EVAL      ZMD = 'M'
     C                   EVAL      AIAAMT = AHRAMT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      AIRCIN = WRVCR
     C                   EVAL      AITSEQ = 98
     C                   EVAL      AITRBR = AHTRBR
     C                   EVAL      AITRNM = AHTRNM
     C                   MOVEL     AHTRFT        AITRFC
     C                   MOVE      AHTRFN        AITRFC
     C                   EVAL      AITRAM = AHRAMT
     C                   EVAL      AITRCY = AHTRCY
     C                   EVAL      AITRRC = AHTRRC
     C                   EVAL      AIEXRT = ZEXCH
     C                   EVAL      AIMDIN = ZMD
     C                   EVAL      AILOAN = AHLOAN
     C                   EVAL      AIDEAL = AHDEAL
     C                   EVAL      AIUSEQ = AHUSEQ
     C                   EVAL      AIMTID = AHMTID
     C                   EVAL      AIFCAM = WAFAM - AIAAMT
 
     C                   IF        AIFCAM < 0
     C                   EVAL      AIFCAM = 0
     C                   ENDIF
 
     C                   EVAL      AIAFAM = WAFAM - AIAAMT
     C                   EVAL      AIORED = BJRDNB
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurDet - Subroutine that Retrieves Currency Details via *
      *                *MODULE/MXACSCURR                              *
      *                                                               *
      *****************************************************************
     C     SRGetCurDet   BEGSR
 
     C                   CALLB     'MXACSCURR'
      /COPY MXCPYSRC,MXACSPRME
 
     C                   IF        ACS_RTCD = '*ERROR '
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = I#LFD1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SDCURR = InData
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtAmount - Subroutine that Converts Amount via            *
      *                *MODULE/ZCONVZ1                                *
      *                                                               *
      *****************************************************************
     C     SRCvtAmount   BEGSR
 
     C                   CALL      'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
      ** Output
     C                   PARM      *ZEROS        ZAMTCO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetXRate - Subroutine to Get the Cross Rate between Two    *
      *               Currencies                                      *
      *                                                               *
      *****************************************************************
     C     SRGetXRate    BEGSR
 
      ** Get Details of the 'From' Ccy
     C                   EVAL      I#LFD1 = ZCCYI
     C                   EXSR      SRGetCurDet
 
      ** If Value Date of the action is less than rundate, use historic
      ** spot rate. Else, use current spot rate for the currency
     C                   IF        AHVDAT < BJRDNB
     C                   EVAL      PCcy = I#LFD1
     C                   EVAL      PDate = AHVDAT
     C                   EXSR      SRGetHisSpot
     C                   EVAL      ZRATE1 = WkSPRT
     C                   EVAL      ZMDI1 = WkMDIN
     C                   ELSE
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   ENDIF
 
     C                   EVAL      ZCDPI = A6NBDP
 
      ** Get Details of the 'To' Ccy
     C                   EVAL      I#LFD1 = ZCCYO
     C                   EXSR      SRGetCurDet
 
     C                   EVAL      ZCDPO = A6NBDP
 
      ** If Value Date of the action is less than rundate, use historic
      ** spot rate. Else, use current spot rate for the currency
     C                   IF        AHVDAT < BJRDNB
     C                   EVAL      PCcy = I#LFD1
     C                   EVAL      PDate = AHVDAT
     C                   EXSR      SRGetHisSpot
     C                   EVAL      ZRATE2 = WkSPRT
     C                   EVAL      ZMDI2 = WkMDIN
     C                   ELSE
     C                   EVAL      ZRATE2 = A6SPRT
     C                   EVAL      ZMDI2 = A6MDIN
     C                   ENDIF
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
      ** Outputs
     C                   PARM      *ZEROS        ZRATEX
     C                   PARM      *BLANKS       ZMDIX
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetHisSpot - Subroutine to Get Historic Spot Rate          *
      *                                                               *
      *****************************************************************
     C     SRGetHisSpot  BEGSR
 
      ** Call Access Program for Historic Spot Rates
     C                   CALL      'AOCUHSR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PDate
     C                   PARM                    PCcy
     C     SDCUHS        PARM      SDCUHS        DSSDY
 
      ** Handle Database Error.
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 7
     C                   EVAL      DBFILE = 'SDCUHSPD'
     C                   EVAL      DBKEY = PCcy
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WkSPRT = G2SPRT
     C                   EVAL      WkMDIN = G2MDIN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReport - Process Report Lines                              *
      *                                                               *
      *****************************************************************
     C     SRReport      BEGSR
 
      ** Branch Level Break
     C                   IF        AHAGBR <> A8BRCD
 
     C                   IF        WkOpen = *ON
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   Z-ADD     5             RQDLN1
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     TRAILP1
     C                   CLOSE     LE000051P1
 
     C                   ENDIF
 
      ** Open LE000051P1 and register in RCF
     C                   OPEN      LE000051P1
     C                   MOVE      *ON           WkOpen
 
      ** Ensure Report Spool File recorded by RCF.
     C                   MOVE      SFILE1        PSFile
     C                   Z-ADD     SFNUM1        PZSNum
 
     C                   EXSR      SRRCFProc
 
     C                   MOVEL     AHAGBR        A8BRCD
     C                   EVAL      PBrca = AHAGBR
     C                   EXSR      SRGetBrchD
 
      ** Write out the Header
     C                   WRITE     HEADP1
 
     C                   ENDIF
 
      ** Set report detail fields
     C                   EXSR      SRSetRFld
 
      ** Write out the record.
     C                   EXSR      SRWriteDet
 
      ** Initialize Report Fields
     C                   EXSR      SRInitRFld
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitRFld - Subroutine that Initialises Report Fields       *
      *                                                               *
      *****************************************************************
     C     SRInitRFld    BEGSR
 
     C                   EVAL      R1CUST = *BLANKS
     C                   EVAL      R1FCLT = *BLANKS
     C                   EVAL      WkSlash = '/'
     C                   EVAL      R1CURR = *BLANKS
     C                   EVAL      R1OAMT = *BLANKS
     C                   EVAL      R1RAMT = *BLANKS
     C                   EVAL      R1DIFF = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetRFld - Subroutine that Sets Report Detail Fields        *
      *                                                               *
      *****************************************************************
     C     SRSetRFld     BEGSR
 
     C                   MOVEL     AACNUM        R1CUST
     C                   MOVEL     AAFACT        R1FCLT
     C                   MOVE      AAFCNO        R1FCLT
     C                   EVAL      R1CURR = AAFCCY
     C                   EVAL      R1RAMT = *BLANKS
     C                   EVAL      R1DIFF = *BLANKS
 
      ** Format Old Facility Amount
     C                   EVAL      PDecs = ZCDPO
     C                   EVAL      PFld15 = WkOFAMT
     C                   EXSR      SRFmtAmt
     C                   EVAL      R1OAMT = ZOut21
 
      ** Format Reduced Facility Amount
     C                   EVAL      PFld15 = AAFAMT
     C                   EXSR      SRFmtAmt
     C                   EVAL      R1RAMT = ZOut21
 
      ** Format the amount difference
     C                   EVAL      PFld15 = WkOFAMT - AAFAMT
     C                   EXSR      SRFmtAmt
     C                   EVAL      R1DIFF = ZOut21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmt - Subroutine that Formats Amount                    *
      *                                                               *
      *****************************************************************
     C     SRFmtAmt      BEGSR
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PFld15
     C                   PARM                    PDecs
     C                   PARM      'J'           PECode
     C                   PARM      *BLANKS       Zout21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetBrchD - Subroutine that Retrieves Branch Details        *
      *                                                               *
      *****************************************************************
     C     SRGetBrchD    BEGSR
 
      ** Call Access Program for Branch Details.
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PBrca
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Handle Database Error.
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
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
      *  SRWriteDet - Subroutine to Write Detail Record to the Report *
      *                                                               *
      *****************************************************************
     C     SRWriteDet    BEGSR
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out Detail Record.
     C                   WRITE     DETAIL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteEnd - Subroutine to Write End of Report               *
      *                                                               *
      *****************************************************************
     C     SRWriteEnd    BEGSR
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out Total Format.
     C                   WRITE     TRAILP1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to Output Audit report and End Program  *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Output Report Header and File Controls.
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
 
      ** If there is a DB Error, Output the DB Error Information.
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
     C     RCOUNT        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
      ** End Program and Return.
     C                   MOVE      *ON           *INLR
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called.
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here.
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFProc - Subroutine to register Printer File via RCF      *
      *                                                               *
      *****************************************************************
     C     SRRCFProc     BEGSR
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANKS       PZSErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
     C                   IF        PZSErr = 'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
