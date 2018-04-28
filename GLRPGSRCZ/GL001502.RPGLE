     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral Entry Generation')                 *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001502 - Collateral Entry Generation                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247479             Date 01May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244201             Date 06Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE041             Date 11Oct04               *
      *                 CGL014  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  247479 - Use multilanguage posting narrative file.           *
      *  244201 - Recompiled due to change in GLCOAKPD and GLCOAHPD   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  CGL014 - Collaterals Processing                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
      ** Midas GL Collateral Generated Account Keys Details
     FGLACKYPD  IF   E             DISK    INFSR(*PSSR)
 
      ** Midas GL Collateral Account Keys Details
     FGLCOAKL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Generated Collateral Entries header
     FGECOHH    O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTHHF:GECOHHD0)
     F                                     PREFIX(H_)
 
      ** Midas GL Generated Collateral Entries detail
     FGECOPD    O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:GECOPDD0)
 
      ** Midas GL Generated Collateral Entries trailer
     FGECOZZ    O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTZZF:GECOZZD0)
     F                                     PREFIX(Z_)
 
      ** Midas GL Collateral Entry - Missing Account Keys
     FGL001502P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     INFDS(SPOOL)
 
      ** Midas GL Collateral Entry Generation - Audit
     FGL001502AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
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
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ArrACOD         S             10S 0 DIM(6)
     D ArrNCOD         S              2A   DIM(6)
     D ArrPREF         S              1S 0 DIM(6)
 
      ** Data structure for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Data structure for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Data structure for Narrative code details
     D SDNARR        E DS                  EXTNAME(SDNARRPD)
 
      ** Data structure for Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Data structure for Account codes details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D QQACC2        E                     EXTFLD(QQACCD)
 
      ** Data structure for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Data structure for CM Multi-language                                                 247479
     D CGPNAR        E DS                  EXTNAME(CGPNARPD)                                  247479
                                                                                              247479
      ** Customer Details Data Structure                                                      247479
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  247479
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                     247479
                                                                                              247479
      ** SAR Data Structure                                                                   247479
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  247479
                                                                                              247479
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** SPOOL Information Data Structure for ZSFILE
     D SPOOL           DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
 
      ** SPOOL Information Data Structure for ZSFILE
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
     D ##PRM1          DS                                                                     247479
     D  A#CUST                 1      6                                                       247479
     D  A#BRCA                 7      9                                                       247479
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** 'Access Object' parameters
     D PRetCode        S              7
     D POption         S              7
     D PAcctCode       S             10
     D PBranch         S              3
     D PNarrCode       S              2
     D PCurrency       S              3
 
      ** ZSFILE parameters
     D PSEQ            S              5
     D PENTY           S              3
     D PSFILE          S             10
     D PZSNUM          S              6  0
     D PZSERR          S              1
 
      ** ZSEDIT parameters
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
 
      ** ZZADD parameters
     D ZZAMT           S             15  3
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
 
      ** ZA0140M parameters
     D PRTN            S              1
     D PDAYN           S              5  0
     D PDFMT           S              1
     D PDATE           S              6  0
     D PDATA           S              7
     D PDAT8           S              8  0
     D PDAT8F          S              8  0
 
      ** Work variables
     D WrkCNUM         S              6
     D WrkACOD         S             10
     D WrkACSQ         S              2
     D WACOD           S             10  0
     D*WCNUM****       S              6  0                                                    CSD027
     D WCNUM           S              6A                                                      CSD027
     D WACSQ           S              2  0
     D WDRCR           S              1  0
     D WPNAR           S             30
     D WHRDC           S              4  0
     D WNumRec         S              5  0
     D WGenRec         S              5  0
     D WDBerror        S              1
     D WMissRec        S              5  0
     D WSuspense       S              1
     D WRun            S              1
     D Ix              S              1  0
     D ##ACNO          S                   LIKE(ACNO)                                         247479
     D ##PNAR          S                   LIKE(CGPNAR)                                       247479
 
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
 
      *****************************************************************
      *                                                               *
      *  MAIN PROCEDURE                                               *
      *                                                               *
      *****************************************************************
     C     1             SETLL     GLACKYPD
     C                   READ      GLACKYPD
 
      ** Read through all generated collateral account keys records
 
     C                   DOW       NOT %EOF(GLACKYPD)
     C                   EVAL      WNumRec = WNumRec + 1
 
     C                   IF        GLRECI = 'D'
     C     GLAKEY        CHAIN     GLCOAKL0
 
     C                   IF        NOT %FOUND(GLCOAKL0)
     C                   EXSR      SRMissing
     C                   ELSE
     C                   EXSR      SRGenEntry
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      GLACKYPD
     C                   ENDDO
 
      ** Print 'END OF REPORT' if there are missing account keys
 
     C                   IF        WMissRec > 0
     C                   WRITE     GL1502R2
     C                   ENDIF
 
      ** Produce audit report
 
     C                   EXSR      SRAudit
 
      ** Set trailer file fields and output record
 
     C                   EVAL      Z_RECI = 'T'
     C                   EVAL      Z_HRWN = ZZTOTI
     C                   EVAL      Z_HRDC = ZZTOTD
     C                   EVAL      Z_NORE1 = WGenRec + 2
     C                   WRITE     GECOZZD0
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGenEntry - Generate collateral entries                     *
      *                                                               *
      *****************************************************************
     C     SRGenEntry    BEGSR
 
     C                   EVAL      ArrACOD(1) = COACD1
     C                   EVAL      ArrACOD(2) = COACD2
     C                   EVAL      ArrACOD(3) = COACD3
     C                   EVAL      ArrACOD(4) = COACD4
     C                   EVAL      ArrACOD(5) = COACD5
     C                   EVAL      ArrACOD(6) = COACD6
     C                   EVAL      ArrNCOD(1) = CONCD1
     C                   EVAL      ArrNCOD(2) = CONCD2
     C                   EVAL      ArrNCOD(3) = CONCD3
     C                   EVAL      ArrNCOD(4) = CONCD4
     C                   EVAL      ArrNCOD(5) = CONCD5
     C                   EVAL      ArrNCOD(6) = CONCD6
     C                   EVAL      ArrPREF(1) = COPRF1
     C                   EVAL      ArrPREF(2) = COPRF2
     C                   EVAL      ArrPREF(3) = COPRF3
     C                   EVAL      ArrPREF(4) = COPRF4
     C                   EVAL      ArrPREF(5) = COPRF5
     C                   EVAL      ArrPREF(6) = COPRF6
     C                   EVAL      Ix = 1
 
     C**********         DOW       Ix <= 6  AND  ArrACOD(Ix) <> *ZERO                         CLE041
     C                   DOW       Ix <= 6                                                    CLE041
 
     C                   EVAL      WSuspense = *BLANK
                                                                                              CLE041
     C                   IF        ArrACOD(Ix) <> *ZERO                                       CLE041
 
     C                   SELECT
 
      ** Posting Reference is 1
 
     C                   WHEN      ArrPREF(Ix) = 1
     C                   EVAL      WACOD = ArrACOD(Ix)
     C                   EVAL      PBranch = GLBRCA
     C                   EXSR      SRBranch
     C                   MOVE      A8BICN        WCNUM
 
      ** Posting Reference is 2
 
     C                   WHEN      ArrPREF(Ix) = 2
     C                   MOVE      BKACCD        WACOD
     C                   EVAL      PBranch = GLBRCA                                           CLE041
     C                   EXSR      SRBranch                                                   CLE041
     C                   MOVE      A8BICN        WCNUM                                        CLE041
     C                   EVAL      WSuspense = 'Y'
 
      ** Posting Reference is 3
 
     C                   WHEN      ArrPREF(Ix) = 3
     C                   EVAL      WACOD = ArrACOD(Ix)
     C                   EVAL      WCNUM = GLCNUM
     C                   ENDSL
 
      ** Access account code details
 
     C                   MOVE      WACOD         PAcctCode
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PAcctCode
     C     SDACOD        PARM      SDACOD        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDACODPD'
     C                   EVAL      DBKEY  = PAcctCode
     C                   EVAL      DBASE  = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Account Sequence
 
     C                   IF        GLASQN = *ZERO
     C                   EVAL      WACSQ = 1
     C                   ELSE
     C                   EVAL      WACSQ = GLASQN
     C                   ENDIF
 
      ** Set DR/CR indicator
 
     C                   IF        Ix < 4
     C                   EVAL      WDRCR = 0
     C                   ELSE
     C                   EVAL      WDRCR = 1
     C                   ENDIF
 
      ** Generate posting narrative
 
     C                   EXSR      SRPostNarr
 
      ** Write collateral entry record to file GECOPD
 
     C                   EXSR      SRWrite
 
     C                   EVAL      WGenRec = WGenRec + 1
 
      ** Add amount to hash fields
 
     C                   EXSR      SRHash
                                                                                              CLE041
     C                   ENDIF                                                                CLE041
 
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPostNarr - Generate posting narrative                      *
      *                                                               *
      *****************************************************************
     C     SRPostNarr    BEGSR
 
     C                   IF        WSuspense = 'Y'
     C                   MOVE      WCNUM         WrkCNUM
     C                   MOVE      WACOD         WrkACOD
     C                   MOVE      WACSQ         WrkACSQ
     C                   EVAL      WPNAR = 'SUS' + WrkCNUM + GLECCY + WrkACOD +
     C                                     WrkACSQ + GLCREF
     C                   ELSE
     C                   EVAL      PNarrCode = ArrNCOD(Ix)
 
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PNarrCode
     C     SDNARR        PARM      SDNARR        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDNARRPD'
     C                   EVAL      DBKEY  = POption
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WPNAR = GLCREF + ALDON
                                                                                              247479
      ** Access Multi-language file to retrieve narrative                                     247479
     C                   MOVE      *ZERO         ##MGID                                       247479
     C                   MOVE      PnarrCode     ##WK4             4                          247479
     C                   MOVEL     ##WK4         ##MGID                                       247479
     C                   MOVEL     'GB'          ##MGID                                       247479
                                                                                              247479
     C                   EXSR      SRPNAR                                                     247479
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Write collateral entry record to file GECOPD       *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
 
     C                   EVAL      RECI = 'P'
     C                   EVAL      CNUM = WCNUM
     C                   EVAL      CCY = GLECCY
     C                   EVAL      ACOD = WACOD
     C                   EVAL      ACSQ = WACSQ
     C                   EVAL      IPDN = *BLANKS
     C                   EVAL      ACNO = *ZERO
     C                   EVAL      PSTD = BJRDNB
     C                   EVAL      VALD = GLEDAT
     C                   EVAL      TRAT = *ZERO
     C                   EVAL      PNAR = WPNAR
     C                   EVAL      PSTA = GLEAMT
     C                   EVAL      DRCR = WDRCR
     C**********         EVAL      ASOC = *ZERO                                               CSD027
     C                   EVAL      ASOC = *BLANKS                                             CSD027
     C                   EVAL      CHQN = *ZERO
     C                   EVAL      SPOS = 'GE-CO'
     C                   EVAL      BRCA = GLBRCA
     C                   EVAL      RIND = *ZERO
     C                   EVAL      REJC = *ZERO
     C                   EVAL      DPMT = *BLANKS
     C                   EVAL      RRNM = *ZERO
     C                   EVAL      ZZ009 = *BLANKS
     C                   EVAL      ATYP = A5ACTY
     C                   EVAL      ZZ002 = *BLANKS
     C                   EVAL      EXIN = *BLANKS
     C                   EVAL      PRIN = *BLANKS
     C                   EVAL      GETP = *BLANKS
     C                   EVAL      ACUM = *ZERO
     C                   EVAL      PRFC = *BLANKS
     C                   EVAL      PTIM = *ZERO
     C                   EVAL      VOIN = GLREVI
     C                   EVAL      MGTT = *BLANKS
     C                   EVAL      ACSC = A5ACSC
     C                   EVAL      LTAI = *ZERO
     C                   EVAL      ZZ007 = *BLANKS
     C                   EVAL      RINO = *BLANKS
     C                   EVAL      SWCR = *BLANKS
     C                   EVAL      DLREF = *BLANKS
     C                   EVAL      FACO = *BLANKS
     C**********         EVAL      DBCNUM = *ZERO                                             CSD027
     C                   EVAL      DBCNUM = *BLANKS                                           CSD027
     C                   EVAL      PREF = *BLANKS
     C                   EVAL      OTRF = GLCREF
     C                   EVAL      OTST = *BLANKS
     C                   EVAL      OTTP = *BLANKS
     C                   EVAL      SDCB = *ZERO
     C                   EVAL      SDLB = *ZERO
     C                   EVAL      BOKC = GLBOKC
     C                   EVAL      NITMS = *ZERO
     C                   EVAL      REBI = *BLANKS
     C                   EVAL      CHGA = *ZERO
     C                   EVAL      ZZ019 = *BLANKS
     C                   EVAL      TLIN = *BLANKS
     C                   EVAL      TRCCY = *BLANKS
     C                   EVAL      STYP = *BLANKS
     C                   EVAL      CQRI = *BLANKS
     C                   EVAL      PBTT = *BLANKS
     C                   EVAL      ORBR = *BLANKS
     C                   EVAL      ORAMT = *ZERO
     C                   EVAL      XRFI = *BLANKS
     C                   EVAL      XRFN = *ZERO
     C                   EVAL      TRST = *BLANKS
     C                   EVAL      ACKEY = GLAKEY
     C                   EVAL      FEEFLG = *BLANKS
     C                   EVAL      FEEVAL = *ZERO
     C                   EVAL      FEEPCT = *ZERO
     C                   EVAL      RORACT = *BLANKS
     C                   EVAL      RORCTY = *BLANKS
     C                   EVAL      RORBNK = *BLANKS
     C                   EVAL      RORCDE = *BLANKS
     C                   EVAL      PORACT = *BLANKS
     C                   EVAL      PORCTY = *BLANKS
     C                   EVAL      PORBNK = *BLANKS
     C                   EVAL      PORCDE = *BLANKS
     C                   EVAL      DSTACT = *BLANKS
     C                   EVAL      DSTCTY = *BLANKS
     C                   EVAL      DSTBNK = *BLANKS
     C                   EVAL      SETDAT = *ZERO
     C                   EVAL      TICKER = *BLANKS
     C                   EVAL      EXCHNG = *BLANKS
     C                   EVAL      NOMINL = *ZERO
     C                   EVAL      FDTRID = *BLANKS
 
     C                   WRITE     GECOPDD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBranch - Access branch details                             *
      *                                                               *
      *****************************************************************
     C     SRBranch      BEGSR
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PBranch
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY  = PBranch
     C                   EVAL      DBASE  = 5
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMissing - Write to missing account keys report             *
      *                                                               *
      *****************************************************************
     C     SRMissing     BEGSR
 
      ** Increment number of missing records
 
     C                   EVAL      WMissRec = WMissRec + 1
 
     C                   EVAL      RAKEY = GLAKEY
     C                   EVAL      RCREF = GLCREF
     C                   MOVE      GLCNUM        RCNUM
     C                   EVAL      RECCY = GLECCY
 
      ** Format midas day number to DDMMMYY
 
     C                   EVAL      PDAYN = GLEDAT
     C                   EVAL      PDFMT = 'D'
 
     C                   CALLB     'ZA0140M'
     C                   PARM      *BLANKS       PRTN
     C                   PARM                    PDAYN
     C                   PARM                    PDFMT
     C                   PARM      *ZERO         PDATE
     C                   PARM      *BLANKS       PDATA
     C                   PARM      *ZERO         PDAT8
     C                   PARM      *ZERO         PDAT8F
 
     C                   IF        PRTN = '0'
     C                   EVAL      REDAT = PDATA
     C                   ENDIF
 
      ** Access currency details and retrieve number of decimal places
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      GLECCY        PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = PCurrency
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Format event amount
 
     C                   EVAL      ZFLD15 = GLEAMT
     C                   EVAL      ZDECS  = A6NBDP
     C                   EVAL      ZECODE = 'J'
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM      *BLANKS       ZOUT21
 
     C                   MOVE      ZOUT21        REAMT
 
      ** If first record to be printed, write header
 
     C                   IF        WMissRec = 1
     C                   WRITE     GL1502R0
     C                   ENDIF
 
      ** If overflow indicator, print header on next page
 
     C                   IF        *IN05 = *ON
     C                   WRITE     GL1502R0
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
 
     C                   WRITE     GL1502R1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Produce audit report                               *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Ensure printer file is recorded by RCF
 
     C                   MOVE      SFILEU        PSFILE
     C                   Z-ADD     SFNUMU        PZSNUM
     C                   EXSR      SRRCFProc
 
      ** Print header
 
     C                   WRITE     HEADAU
 
      ** Database Error
 
     C                   IF        WDBerror = 'Y'
     C                   WRITE     ERROR
 
     C                   ELSE
 
      ** Empty file GLACKYPD
 
     C                   IF        WNumRec = *ZERO
     C                   WRITE     NOREC
 
     C                   ELSE
     C                   EVAL      RNORE = WNumRec
     C                   EVAL      RGENC = WGenRec
     C                   WRITE     CONTROL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHash - Add amount to hash fields                           *
      *                                                               *
      *****************************************************************
     C     SRHash        BEGSR
 
     C                   EVAL      ZZAMT = GLEAMT / 1000
 
     C                   CALLB     'ZZADD'
     C                   PARM                    ZZAMT
     C                   PARM                    ZZTOTI
     C                   PARM                    ZZTOTD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFProc - RCF processing                                   *
      *                                                               *
      *****************************************************************
     C     SRRCFProc     BEGSR
 
      ** Ensure detail spool file recorded by RCF
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSEQ
     C                   PARM      *BLANKS       PENTY
     C                   PARM                    PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANKS       PZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     PZSERR        IFEQ      'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C********************************************************************                    247479
     C**  Subroutine SRPNAR determines the required narratives.         **                    247479
     C********************************************************************                    247479
     C     SRPNAR        BEGSR                                                                247479
     C*                                                                                       247479
     C*                                                                                       247479
     C* If the facility is switched off or unavailable,                                       247479
     C*  or UDC is not installed, exit this subroutine:                                       247479
     C*                                                                                       247479
     C     GLPNAR        IFNE      'Y'                                                        247479
     C                   GOTO      EXPNAR                                                     247479
     C                   ENDIF                                                                247479
     C*                                                                                       247479
     C* Determine the customer's name:                                                        247479
     C*                                                                                       247479
     C                   MOVEL     *BLANKS       PCust                                        247479
     C                   MOVEL     WCNUM         PCust                                        247479
     C*                                                                                       247479
     C                   CALL      'AOCUSTR0'                                                 247479
     C                   PARM      *BLANKS       PRtCd             7                          247479
     C                   PARM      '*KEY   '     POptn             7                          247479
     C                   PARM                    PCust            10                          247479
     C                   PARM      *BLANKS       PKyst             7                          247479
     C     SDCUST        PARM      SDCUST        DSSDY                                        247479
     C*                                                                                       247479
     C     PRtCd         IFNE      *BLANKS                                                    247479
     C                   MOVEL     'SDCUSTPD'    DBFILE                                       247479
     C                   MOVEL     '101'         DBASE                                        247479
     C                   MOVEL     PCust         DBKEY                                        247479
     C                   EXSR      *PSSR                                                      247479
     C                   ENDIF                                                                247479
     C* Determine the value for the narrative using AOPNARR0:                                 247479
     C*                                                                                       247479
     C                   CLEAR                   CGPNAR                                       247479
     C                   CLEAR                   ##PRM1                                       247479
     C*                                                                                       247479
     C                   MOVE      'GL'          MNMODI                                       247479
     C                   MOVE      GLBRCA        MNBRCA                                       247479
     C                   MOVE      WCNUM         MNCUST                                       247479
     C                   MOVE      GLECCY        MNCYCD                                       247479
     C                   MOVE      WACOD         MNACCD                                       247479
     C                   MOVE      WACSQ         MNACSQ                                       247479
     C                   MOVEL     WPNAR         MNNARR                                       247479
     C                   MOVEL     GLCREF        MNTRNO                                       247479
     C*                                                                                       247479
     C                   CALL      'AOPNARR0'                                                 247479
     C                   PARM                    PRtCd                                        247479
     C                   PARM                    ##MGID            7                          247479
     C                   PARM                    ##PRM1                                       247479
     C     CGPNAR        PARM      CGPNAR        ##PNAR                                       247479
     C                   PARM                    ##NARR           50                          247479
     C*                                                                                       247479
     C     PRtCd         IFNE      *BLANKS                                                    247479
     C                   MOVEL     'CGPNARPD'    DBFILE                                       247479
     C                   MOVEL     '102'         DBASE                                        247479
     C                   MOVEL     MNCUST        DBKEY                                        247479
     C                   EXSR      *PSSR                                                      247479
     C                   ENDIF                                                                247479
     C*                                                                                       247479
     C                   MOVEL     *BLANKS       WPNAR                                        247479
     C                   MOVEL     ##NARR        WPNAR                                        247479
     C*                                                                                       247479
     C     EXPNAR        TAG                                                                  247479
     C*                                                                                       247479
     C                   ENDSR                                                                247479
     C****************************************************************                        247479
     C/EJECT                                                                                  247479
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POption
     C                   EVAL      DBASE  = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Midas Modules detail
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBKEY  = POption
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger ICD
 
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDGELR        PARM      SDGELR        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY  = POption
     C                   EVAL      DBASE  = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **Call SAR Prog. for Switchable feature                                                 247479
     C                   MOVE      'N'           GLPNAR            1                          247479
     C     BGN1ST        IFEQ      'Y'                                                        247479
                                                                                              247479
     C                   CALL      'AOSARDR0'                                                 247479
     C                   PARM      *BLANKS       PRetCode                                     247479
     C                   PARM      '*VERIFY'     POptn                                        247479
     C                   PARM      'GLPNAR'      @SARD             6                          247479
     C     SCSARD        PARM      SCSARD        DSFDY                                        247479
                                                                                              247479
     C                   IF        PRetCode <> *BLANKS AND PRetCode <> '*NRF   '              247479
     C                   EVAL      DBFILE = 'SCSARDPD'                                        247479
     C                   EVAL      DBKEY = 'GLPNAR'                                           247479
     C                   EVAL      DBASE = 905                                                247479
     C                   EXSR      *PSSR                                                      247479
     C                   ENDIF                                                                247479
                                                                                              247479
     C                   IF        PRTCD = *BLANKS                                            247479
     C                   EVAL      GLPNAR = 'Y'                                               247479
     C                   ELSE                                                                 247479
     C                   EVAL      GLPNAR = 'N'                                               247479
     C                   ENDIF                                                                247479
                                                                                              247479
     C                   ENDIF                                                                247479
                                                                                              247479
      ** Output header record
 
     C                   EVAL      H_RECI = 'H'
     C                   WRITE     GECOHHD0
 
      ** Ensure printer file is recorded by RCF
 
     C                   Z-ADD     SFNUM         PZSNUM
     C                   MOVE      SFILE         PSFILE
     C                   EXSR      SRRCFProc
 
      ** Initialise work fields
 
     C                   EVAL      WNumRec = *ZERO
     C                   EVAL      WGenRec = *ZERO
     C                   EVAL      WMissRec = *ZERO
     C                   EVAL      WDBerror = *BLANK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   EVAL      WDBerror = 'Y'
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
