     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Fee accrual account key generation')          *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL000130 - Midas DL Fee Accruals Account Key Generation      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CDL093             Date 08Apr14               *
      *                 CLE148             Date 23Jul12               *
      *                 AR821740           Date 29Aug11               *
      *                 CRE073             Date 06Dec10               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSW208             Date 15Apr08               *
      *                 BUG13085B          Date 06Mar07               *
      *                 BUG13085A          Date 01Mar07               *
      *                 BUG13404           Date 16Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG13053A          Date 14Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12838           Date 06Dec06               *
      *                 BUG12682           Date 16Nov06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9807            Date 21Jul06               *
      *                 BUG9356            Date 10Dec05               *
      *                 233545             Date 18May05               *
      *                 232928             Date 08Apr05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CDL093 - MM Interest calculation type 9.                     *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR821740 - COB - No stamp tax account keys generated         *
      *             (Recompile)                                       *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *  BUG13085B - Reopen BUG13085.                                 *
      *  BUG13085A - Include DISA in the computation of TFDP/TFDPA    *
      *  BUG13404 - Doubling of amounts of TFDP and TFDPA.            *
      *  BUG13053A- accruing fees Total recurred amount not displyed  *
      *  BUG12838 - Incorrect no. of decimal places is being printed  *
      *             in the report.  Initialise currency indicators    *
      *             everytime.                                        *
      *  BUG12682 - MMC004600 00001 failed (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9807- Problem manipulating dates                          *
      *  BUG9356- Extended Deal Sub Type (CDL038)                     *
      *  233545 - Cut-off Date                                        *
      *  232928 - Amortise all fees non-linearly, EIR calculation,    *
      *           Non-linear amortisation calculation & adjustment    *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FDEALS     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(DEALSDFF)
     F                                     PREFIX(D_)
      ** Deal Details File

     FDLFEEDLF  UF A E           K DISK    INFSR(*PSSR)
      ** Fee Details File

     FDLFEEZ    UF   E             DISK    INFSR(*PSSR)
      ** Fee Details Trailer File

     FMMEIRDL0  UF   E           K DISK    INFSR(*PSSR)
      ** MM Effective Interest Rate Details

     FMMEIRAL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMEIRAD0:MMEIRAD4)
      ** MM EIR Amortisation Details

     FDLFHST    O    E             DISK    INFSR(*PSSR)
      ** Deal Fee History Details File

     FDKEYSDP   O    E             DISK    INFSR(*PSSR)
     F                                     PREFIX(KD)
     FDKEYSZZ   UF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(KZ)
      ** Deal Generated Account Keys

     FMMCFLSPD  O    E             DISK    INFSR(*PSSR)
      ** Cash Flow
                                                                                              233545
     FSDHEDGPD  IF   E             DISK    INFSR(*PSSR)                                       233545
      ** Midas SD Hedging ICD File                                                            233545

     FDL000130P1O    E             PRINTER INFDS(SPOOL)
     F                                     USROPN
      ** Deal Event Generation Detail Report

     FDL000130AUO    E             PRINTER INFDS(SPOOLU)
      ** Deal Event Generation Audit Report

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

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 CDL093
     D/COPY ZSRSRC,ZFEB29Z1LE                                                                 CDL093
      ** Account Key Array
     D*AKY*************S**************1    DIM(10)                                           BUG9356
     D AKY             S              1    DIM(14)                                           BUG9356

      ** Layout for the RUNDAT data area
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)

      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Module Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CAS011

      ** General Ledger Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)


      *** File information data structure - detail report
     DSPOOL            DS
     D SFILE                  83     92
     D SFNUM                 123    124B 0
     D OFLLN                 188    189B 0
     D PRTLN                 367    368B 0

      *** File information data structure - Audit report
     DSPOOLU           DS
     D SFILEU                 83     92
     D SFNUMU                123    124B 0

      **  Divide up start of month date
     D                 DS
     DSMDT                     1      6
     DSMDD                     1      2
     DSM                       3      4  0
     DSY                       5      6  0

      **  Divide up start of month date for U.S.A. format
     D                 DS
     DSMDTUS                   1      6
     DSMUS                     1      2  0
     DSMDDUS                   3      4

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameters for access objects
     D PRTCD           S              7
     D POPTN           S              7
     D PCUST1          S             10
     D PKYST           S              7
     D PCURR           S              7
     D PCCY            S              3
     D PZOBRX          S              3
     D PSARD           S              6
     D PBranch         S              3
     D PReturnCode     S              7

      ** Parameters for ZALIGN
     D ZALIGNOK        S              1
     D ZFIELD          S             16
     D ZECODE          S              1
     D ZADEC           S              1  0
     D ZADIG           S              2  0

      ** Parameters for ZDATE2
     D PValDat         S              5  0
     D PDatFmt         S              1
     D PDate           S              6  0
     D PZADATE         S              7

      ** Parameters for ZZAMT
     D ZZAmt           S             15  3
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
     D ZZBEG           S              5  0
     D ZZEND           S              5  0

      ** Parameters for ZVACTBU
     D PACTN           S              1    INZ('A')
     D PBRCH           S              3
     D PERROR          S              1P 0

      ** Parameters for LERDATEF
     D PLDate          S              6  0
     D PLDayNo         S              5  0
     D PLRetCode       S              1

      ** Parameters for ZSFILE
     D SEQ             S              5A
     D SENTY           S              3A
     D ZSNUMU          S              6  0
     D ZSNUM           S              6  0
     D ZSERR           S              1A

     D RQDLN           S              3S 0
     D DIFLN           S              3S 0

      ** Paramaters for ZXRATE
     D  ZRATE1         S             13P 8
     D  ZMDI1          S              1A
     D  ZRATE2         S             13P 8
     D  ZMDI2          S              1A
     D  ZRATEX         S             13P 8
     D  ZMDIX          S              1A

      ** Paramaters for ZCONVZ1
     D ZAMTCI          S             15  0
     D ZEXCH           S             13  8
     D ZMD             S              1
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0

     D WFEERT          S             13  8
     D WFEEMD          S              1
     D WFEEDP          S              1  0
     D WDELRT          S             13  8
     D WDELMD          S              1
     D WDELDP          S              1  0

     D PMSGFILE        S             10
     D PMSGID          S             10
     D WADJNUM         S             14  0
     D WLNRF           S              6  0
     D WRCDT           S              1    INZ('A')
     D WCCYERR         S              1
     D WCNUM           S              6
     D WAccPftDate     S              5  0
     D REPBRC          S              3A
     D WFeeCode        S              2A
     D WStart          S              5  0
     D WStartOfYr      S              2
     D WStartOfYrNo    S              2  0
     D WNxtWDay        S              5  0
     D WDate           S              6  0
     D WADATE          S              6                                                      BUG9807
     D WDate2          S              7A
     D WSMDT           S              6
     D WDayNo          S              2  0
     D WADAYNO         S              2                                                      BUG9807
     D CEU003          S              1A
     D WWork           S             22  9
     D WWork2          S             22  9
     D WWork3          S             15  2
     D NWNPYD          S              5  0
     D DAYACR          S             13  0
     D WRun            S              1A
     D WLoop           S              1A
     D WFPEND          S              5  0
     D WFPSTD          S              5  0
     D WNoDay          S              5  0
     D WActDy          S              5  0
     D WExcss          S             13  0
     D STRBRC          S              3A
     D MNTND           S              2  0
     D WNoRec          S              5  0
     D WNDel           S              5  0
     D WNRev           S              5  0
     D KDNOR0          S              5  0
     D KDNTOT          S              5  0
     D MSTD            S              5  0
     D P1OP            S              1A

     D KTRAN           S              6S 0
     D KFSEQ           S              2S 0
     D KSDAM           S              5  0
     D WFAMT           S                   LIKE(DFFAMT)
     D Wdiff404        S              5  0                                                  BUG13404
     D CSW208          S              1A                                                      CSW208

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************

     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 CDL093
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************

      ** Read all Deal Fee record

     C                   READ      DLFEEDLF
     C                   DOW       NOT %EOF(DLFEEDLF)

     C                   EVAL      REPBRC = DFBRCA
     C                   EVAL      PBranch = DFBRCA
     C**********         EVAL      KDBRTT = DFFSEQ                                            CSD103

      ** Read Deals File
     C     DFDLNO        CHAIN     DEALS

     C                   IF        %FOUND(DEALS)
     C                   EXSR      TOTFEE
     C                   ENDIF
      ** Process live record

     C     DFRECI        CASEQ     'D'           SRDetail

      ** Process reversal if deleted records

     C     DFRECI        CASEQ     'R'           SRReverse

      ** Remove expired records from DLFEEDLF

     C                   CAS                     SRRemove

     C                   ENDCS

     C                   EVAL      WNREC = WNREC + 1
     C                   READ      DLFEEDLF
     C                   ENDDO

      ** Trailer processing

     C                   EXSR      SRTrailer

      ** End the program

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetail - Detail processing                                  *
      *                                                               *
      *****************************************************************
     C     SRDetail      BEGSR

      ** Initialize reversal indicator

     C                   EVAL      KDREVI = 0

      ** Payment On indicator is blank (One off fee)

     C                   IF        DFPYON = *Blanks

     C                   IF        DFPSTD <= WAccPftDate
     C                   EVAL      DFAMTO = DFFAMT
     C                   EVAL      KDEDAT = DFPSTD
     C                   EXSR      SRSettle
     C                   ENDIF

     C                   ENDIF

      ** Payment On indicator is 'S' (Amortising fee)

     C                   IF        DFPYON = 'S'

     C                   IF        DFPSTD <= WAccPftDate
     C                   EVAL      WFPSTD = DFPSTD
     C                   EVAL      WFPEND = DFPEND
     C                   EXSR      SRAccrue

     C                   IF        DFAMTS = 0
     C                   EVAL      KDEDAT = DFPSTD
     C                   EXSR      SRSettle
     C                   ENDIF

     C                   IF        DFPEND <= WAccPftDate
     C                   EVAL      DFRECI = 'M'
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** Payment On indicator is 'E' (Accruing fee)

     C                   IF        DFPYON = 'E'

     C                   IF        DFPSTD <= WAccPftDate
     C                   EVAL      WFPSTD = DFPSTD
     C                   EVAL      WFPEND = DFPEND
     C                   EXSR      SRAccrue
     C                   ENDIF

     C                   IF        DFPEND <= WAccPftDate
     C                   EVAL      KDEDAT = DFPEND
     C                   EXSR      SRSettle
     C                   ENDIF

     C                   ENDIF

      ** Payment On indicator is 'N' (Repetitive fee)

     C                   IF        DFPYON = 'N'

     C                   IF        DFLPDT > DFPSTD
     C                   EVAL      WFPSTD = DFLPDT
     C                   ELSE
     C                   EVAL      WFPSTD = DFPSTD
     C                   ENDIF

     C                   IF        DFPEND < DFNPYD
     C                   EVAL      WFPEND = DFPEND
     C                   ELSE
     C                   EVAL      WFPEND = DFNPYD
     C                   ENDIF

     C                   EVAL      WLoop = 'Y'

     C                   DOW       WLoop = 'Y'

     C                   IF        WFPSTD <= WAccPftDate
     C                   EXSR      SRAccrue
     C                   ENDIF

     C                   IF        WFPEND <= WAccPftDate

     C                   EVAL      KDEDAT = WFPEND
     C                   EXSR      SRSettle
     C                   EVAL      DFLPDT = WFPEND
     C                   EXSR      SRSetDate
     C                   EVAL      WFPSTD = DFNPYD
     C                   EVAL      DFNPYD = NWNPYD
     C                   EVAL      WFPEND = DFNPYD

     C                   IF        NWNPYD = 0
     C                   EVAL      DFFREQ = *Blanks
     C                   EVAL      DFDYIM = 0
     C                   ENDIF

     C                   ELSE
     C                   EVAL      WLoop = 'N'
     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

      ** Update files

     C                   EVAL      WNoRec = WNoRec + 1
     C                   UPDATE    DLFEEDD0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccrue - Accrual processing                                 *
      *                                                               *
      *****************************************************************
     C     SRAccrue      BEGSR

     C                   IF        DFADJY = 'Y' and                                           233545
     C                             FSAMRM = 'N' and                                           233545
     C                             D_VDAT >= FSNLAC and                                       233545
     C                             D_ORED >= FSSWDT                                           233545
      ** Bypass                                                                               233545
     C                   ELSE                                                                 233545
      ** If a Reversal

     C                   IF        KDREVI = 1

      ** Setup account key amount

     C                   EVAL      KDEAMT = DFFAMT
     C                   EVAL      DFADAT = 0

     C                   ELSE

      ** If not a Reversal

     C                   IF        WFPEND <= WAccPftDate

     C                   EVAL      KDEAMT = DFFAMT - DFADAT
     C                   EVAL      KDEDAT = WFPEND

     C                   IF        WFPEND = WAccPftDate
     C                   EVAL      DFADAT = 0
     C                   ENDIF

     C                   ELSE

     C                   EVAL      KDEDAT = WAccPftDate

     C                   EVAL      WNoDay = WFPEND - WFPSTD
     C                   EVAL      WActDy = WAccPftDate - WFPSTD

     C                   IF        BKALDI <> 'Y'
     C                   EVAL      WActDy = WActDy + 1
     C                   ENDIF

     C                   EVAL(H)   Wwork = DFFAMT / WNoDay
     C                   EVAL(H)   Wwork2 = Wwork
     C                   EVAL      Wwork = Wwork * WActDy
     C                   EVAL(H)   KDEAMT = Wwork - DFADAT

     C                   EVAL      DFADAT = DFADAT + KDEAMT

     C                   EVAL      WEXCSS = DFADAT - DFFAMT
     C                   IF        WEXCSS > 0
     C                   EVAL      KDEAMT = KDEAMT - WEXCSS
     C                   EVAL      DFADAT = DFADAT - WEXCSS
     C                   ENDIF

     C                   IF        DFORED = BJRDNB
     C                             AND WFPSTD < MSTD
     C                   EVAL      WWork2 = MNTND * WWork2
     C                   EVAL(H)   WWork3 = DAYACR - WWork2
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
      ***  ENDTAG
     C                   EVAL      KDDLNO = DFDLNO
     C                   EVAL      KDRECI = 'D'
     C                   EVAL      AKY(3) = 'A'
     C                   MOVEA     DFDTYP        AKY(1)
     C                   MOVEA     DFSTYP        AKY(4)

      ** Recourse Indicator

     C                   EVAL      AKY(7) = ' '

     C                   MOVE      DFFCOD        WFeeCode
     C                   MOVEA     WFeeCode      AKY(8)
     C                   EVAL      AKY(10) = 'F'
     C                   EVAL      AKY(6) = ' '

     C                   IF        DFPYON = 'S'
     C                   EVAL      AKY(6) = 'S'
     C                   ENDIF
     C                   MOVEA     D_CLAS        AKY(11)                                     BUG9356
     C                   MOVEA     AKY           KDAKEY

     C                   EVAL      KDSTCY = *Blanks

      ** If the settlement currency is entered and the amount is not 0
      ** then output the settlement currency on the account key

     C                   IF        CEU003 = 'Y'   AND
     C                             DFSCCY <> '   '   AND
     C                             DFSCCY <> DFFCCY  AND
     C                             KDEAMT <> 0
     C                   EVAL      KDSTCY = DFSCCY
     C                   ENDIF

     C                   EVAL      KDCNUM = DFCUST
     C                   EVAL      KDECCY = DFFCCY
     C                   EVAL      KDOSAC = DFOURS
     C                   EVAL      KDSETP = DFSTTL

      ** Setup start date or last interest date variable

     C                   EVAL      KDSLID = WFPSTD

     C                   EVAL      KDPRFC = D_PRFC
     C                   EVAL      KDBRCA = DFBRCA
     C                   EVAL      KDOSBR = *Blanks
     C                   EVAL      KDACSQ = DFFSEQ

      ** Determine decimal places

     C                   EVAL      PCurr = DFFCCY
     C                   EXSR      SRCurr
                                                                                            BUG12838
      ** Initialise currency indicators                                                     BUG12838
                                                                                            BUG12838
     C                   EVAL      *IN30 = *OFF                                             BUG12838
     C                   EVAL      *IN31 = *OFF                                             BUG12838
     C                   EVAL      *IN32 = *OFF                                             BUG12838
     C                   EVAL      *IN33 = *OFF                                             BUG12838
                                                                                            BUG12838
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      *IN30 = *ON
     C                   WHEN      A6NBDP = 1
     C                   EVAL      *IN31 = *ON
     C                   WHEN      A6NBDP = 2
     C                   EVAL      *IN32 = *ON
     C                   OTHER
     C                   EVAL      *IN33 = *ON
     C                   ENDSL

     C                   EXSR      SROpenFile

      ** Setup PAY settlement details

     C                   IF        DFDTYP = 'IT'  OR
     C                             DFDTYP = 'TD'  OR
     C                             DFDTYP = 'CI'  OR
     C                             DFDTYP = 'CD'

     C                   IF        DFOMDB <> *Blanks
     C                   EVAL      KDOSBR = DFOMDB
     C                   ELSE
     C                   EVAL      KDOSBR = DFOSBR
     C                   ENDIF

     C                   EVAL      KDOSAC = DFPONS
     C                   EVAL      KDSETP = DFPSTM

      ** Setup RECEIVE settlement details

     C                   ELSE

     C                   IF        DFOMDB <> *Blanks
     C                   EVAL      KDOSBR = DFOSDB
     C                   ELSE
     C                   EVAL      KDOSBR = DFOSBR
     C                   ENDIF

     C                   EVAL      KDOSAC = DFRONS
     C                   EVAL      KDSETP = DFRSTM
     C                   ENDIF

      ** Write record to A/C key file

     C                   IF        KDEAMT <> 0
     C                   WRITE     DKEYSDPF
     C                   EVAL      KDNOR0 = KDNOR0 + 1

     C     DFDLNO        CHAIN     MMEIRDL0
     C                   IF        %FOUND(MMEIRDL0)
     C                   EVAL      EIACTD = EIACTD + KDEAMT
     C                   UPDATE    MMEIRDD0
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      DFAFEE = KDEAMT
     C                   MOVE      KDEAMT        EAMT0
     C                   MOVE      KDEAMT        EAMT1
     C                   MOVE      KDEAMT        EAMT2
     C                   MOVE      KDEAMT        EAMT3

      ** Output to report
     C                   IF        KDEAMT <> 0
     C                   EXSR      SRWriteDetRpt

      ** Calculate Hash Total

     C                   EVAL      ZZAMT = KDEAMT / 1000
     C                   EVAL      ZZTOTI = KDVLRF
     C                   EVAL      ZZTOTD = KDVLRL

     C                   CALLB     'ZZADD'
     C                   PARM                    ZZAMT
     C                   PARM                    ZZTOTI
     C                   PARM                    ZZTOTD

     C                   EVAL      KDVLRF = ZZTOTI
     C                   EVAL      KDVLRL = ZZTOTD

     C                   EVAL      ZZAMT = KDEAMT / 1000
     C                   EVAL      ZZTOTI = KZHRWN
     C                   EVAL      ZZTOTD = KZHRDC

     C                   CALLB     'ZZADD'
     C                   PARM                    ZZAMT
     C                   PARM                    ZZTOTI
     C                   PARM                    ZZTOTD

     C                   EVAL      KZHRWN = ZZTOTI
     C                   EVAL      KZHRDC = ZZTOTD
     C                   ENDIF

      ** Restore value for daily accrued fee amount

     C                   EVAL      KDEAMT = DAYACR

     C                   ENDIF                                                                233545
                                                                                              233545
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReverse - Reversal processing                               *
      *                                                               *
      *****************************************************************
     C     SRReverse     BEGSR

     C                   EVAL      DFRECI = '*'

      ** If original entry date is today ignore processing

     C                   IF        DFORED <> BJRDNB

      ** If amount has already been settled then reverse

     C                   IF        DFAMTS <> 0
     C                   EVAL      KDREVI = 1
     C                   EVAL      KDEDAT = DFSDAT
     C                   EXSR      SRSettle
     C                   ENDIF

      ** If amount has already been posted then reverse

     C                   EVAL      WNREV = WNREV + 1
     C                   ENDIF

     C                   UPDATE    DLFEEDD0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRemove - Remove expired records                             *
      *                                                               *
      *****************************************************************
     C     SRRemove      BEGSR

      ** Before deleting matured records from DLFEED, write detail to
      ** Fee History file DLFHST.

     C                   IF        DFRECI = 'M'
     C                   EVAL      HIRECI = DFRECI
     C                   EVAL      HIBRCA = DFBRCA
     C                   EVAL      HICUST = DFCUST
     C                   EVAL      HIDLNO = DFDLNO
     C                   EVAL      HIFSEQ = DFFSEQ
     C                   EVAL      HIFCOD = DFFCOD
     C                   EVAL      HIFCCY = DFFCCY
     C                   EVAL      HIAMTS = DFAMTS
     C                   EVAL      HIHDAT = DFORED
     C                   EVAL      HILCHD = BJRDNB
     C                   EVAL      HILCHT = 'I'
     C                   EVAL      HIRECS = HIRECS + 1
      *                                                                                       CSW208
      ** All settlement instructions must be copied if SWIFT 2008 is ON                       CSW208
      *                                                                                       CSW208
     C                   IF        CSW208 = 'Y'                                               CSW208
      *                                                                                       CSW208
     C                   EVAL      HISCCY = DFSCCY                                            CSW208
     C                   EVAL      HIICCY = DFICCY                                            CSW208
     C                   EVAL      HIOSDB = DFOSDB                                            CSW208
     C                   EVAL      HIOMDB = DFOMDB                                            CSW208
     C                   EVAL      HIRSTM = DFRSTM                                            CSW208
     C                   EVAL      HIRONS = DFRONS                                            CSW208
     C                   EVAL      HIRIBN = DFRIBN                                            CSW208
     C                   EVAL      HIRIBA = DFRIBA                                            CSW208
     C                   MOVE      DFROBN        HIROBN                                       CSW208
     C                   MOVE      DFROCN        HIROCN                                       CSW208
     C                   EVAL      HIPSTM = DFPSTM                                            CSW208
     C                   EVAL      HIPONS = DFPONS                                            CSW208
     C                   EVAL      HIPIBN = DFPIBN                                            CSW208
     C                   EVAL      HIPIBA = DFPIBA                                            CSW208
     C                   MOVE      DFPOBN        HIPOBN                                       CSW208
     C                   MOVE      DFPOCN        HIPOCN                                       CSW208
     C                   EVAL      HIRCRN = DFRCRN                                            CSW208
     C                   EVAL      HIRCRA = DFRCRA                                            CSW208
     C                   EVAL      HIRVNO = DFRVNO                                            CSW208
     C                   EVAL      HIAWBN = DFAWBN                                            CSW208
     C                   EVAL      HIAWBA = DFAWBA                                            CSW208
     C                   EVAL      HIBENN = DFBENN                                            CSW208
     C                   EVAL      HIBENA = DFBENA                                            CSW208
     C                   EVAL      HIDTP1 = DFDTP1                                            CSW208
     C                   EVAL      HIDTP2 = DFDTP2                                            CSW208
     C                   EVAL      HIDTP3 = DFDTP3                                            CSW208
     C                   EVAL      HIDTP4 = DFDTP4                                            CSW208
     C                   EVAL      HIDCHG = DFDCHG                                            CSW208
     C                   EVAL      HIBTB1 = DFBTB1                                            CSW208
     C                   EVAL      HIBTB2 = DFBTB2                                            CSW208
     C                   EVAL      HIBTB3 = DFBTB3                                            CSW208
     C                   EVAL      HIBTB4 = DFBTB4                                            CSW208
     C                   EVAL      HIBTB5 = DFBTB5                                            CSW208
     C                   EVAL      HIBTB6 = DFBTB6                                            CSW208
     C                   EVAL      HICVMR = DFCVMR                                            CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
     C                   EVAL      HIAMTD = DFAMTD                                            232928
     C                   WRITE     DLFHSTD0
     C                   ENDIF

     C                   EVAL      WNDEL = WNDEL + 1

     C                   DELETE    DLFEEDLF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSettle - Perform Settlement Processing                      *
      *                                                               *
      *****************************************************************
     C     SRSettle      BEGSR

      ** If a Reversal

     C                   IF        KDREVI = 1
     C                   EVAL      KDEAMT = DFAMTS
     C                   EVAL      DFAMTS = 0
     C                   EVAL      DFSDAT = 0
     C                   EVAL      DFAMTO = DFAMTO + KDEAMT

     C                   ELSE

      ** If not a Reversal

     C                   EVAL      KDEAMT = DFFAMT
     C                   EVAL      DFAMTS = DFAMTS + DFFAMT
     C                   EVAL      DFSDAT = BJRDNB

      ** If the fee has been entered today and is due to be settled
      ** immediately,  OR  if the fee end date has been changed to
      ** today and is due to be settled, set-up the outstanding amount
      ** as the full fee

     C                   IF        DFORED = BJRDNB  OR
     C                             DFAMTO = 0       AND
     C                             DFPEND <= BJRDNB
     C                   EVAL      DFAMTO = DFFAMT
     C                   ENDIF
     C                   EVAL      DFAMTO = DFAMTO - KDEAMT

     C                   ENDIF

     C                   EVAL      KDDLNO = DFDLNO
     C                   EVAL      KDRECI = 'D'
     C                   EVAL      AKY(3) = 'R'
     C                   MOVEA     DFDTYP        AKY(1)
     C                   MOVEA     DFSTYP        AKY(4)
     C                   MOVE      DFFCOD        WFeeCode
     C                   MOVEA     WFeeCode      AKY(8)

     C                   IF        DFPYON = 'S'
     C                   EVAL      AKY(6) = 'S'
     C                   ELSE
     C                   EVAL      AKY(6) = ' '
     C                   ENDIF

     C                   EVAL      AKY(7) = ' '
     C                   EVAL      AKY(10) = 'F'
     C                   MOVEA     D_CLAS        AKY(11)                                     BUG9356
     C                   MOVEA     AKY           KDAKEY

      ** Setup field for output to DKEYSDP

     C                   EVAL      KDCNUM = DFCUST
     C                   EVAL      KDECCY = DFFCCY
     C                   EVAL      KDOSAC = DFOURS
     C                   EVAL      KDSETP = DFSTTL
     C                   EVAL      KDBRCA = DFBRCA
     C                   EVAL      KDOSBR = DFOSBR
     C                   EVAL      KDACSQ = DFFSEQ
     C                   EVAL      KDPRFC = D_PRFC
     C                   MOVE      KDEAMT        EAMT0
     C                   MOVE      KDEAMT        EAMT1
     C                   MOVE      KDEAMT        EAMT2
     C                   MOVE      KDEAMT        EAMT3

      ** Determine decimal places

     C                   EVAL      PCurr = DFFCCY
     C                   EXSR      SRCurr
                                                                                            BUG12838
      ** Initialise currency indicators                                                     BUG12838
                                                                                            BUG12838
     C                   EVAL      *IN30 = *OFF                                             BUG12838
     C                   EVAL      *IN31 = *OFF                                             BUG12838
     C                   EVAL      *IN32 = *OFF                                             BUG12838
     C                   EVAL      *IN33 = *OFF                                             BUG12838
                                                                                            BUG12838
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      *IN30 = *ON
     C                   WHEN      A6NBDP = 1
     C                   EVAL      *IN31 = *ON
     C                   WHEN      A6NBDP = 2
     C                   EVAL      *IN32 = *ON
     C                   OTHER
     C                   EVAL      *IN33 = *ON
     C                   ENDSL

     C                   EXSR      SROpenFile

      ** Setup PAY settlement details

     C                   IF        DFDTYP = 'IT'  OR
     C                             DFDTYP = 'TD'  OR
     C                             DFDTYP = 'CI'  OR
     C                             DFDTYP = 'CD'

     C                   IF        DFOMDB <> *Blanks
     C                   EVAL      KDOSBR = DFOMDB
     C                   ELSE
     C                   EVAL      KDOSBR = DFOSBR
     C                   ENDIF

     C                   EVAL      KDOSAC = DFPONS
     C                   EVAL      KDSETP = DFPSTM

      ** Setup RECEIVE settlement details

     C                   ELSE

     C                   IF        DFOMDB <> *Blanks
     C                   EVAL      KDOSBR = DFOSDB
     C                   ELSE
     C                   EVAL      KDOSBR = DFOSBR
     C                   ENDIF

     C                   EVAL      KDOSAC = DFRONS
     C                   EVAL      KDSETP = DFRSTM
     C                   ENDIF

      ** Write record to A/C key file

     C                   IF        KDEAMT <> 0
     C                   WRITE     DKEYSDPF
     C                   EVAL      KDNOR0 = KDNOR0 + 1

      ** Output to report
     C                   EXSR      SRWriteDetRpt

      ** Calculate Hash Total

     C                   EVAL      ZZAMT = KDEAMT / 1000
     C                   EVAL      ZZTOTI = KDVLRF
     C                   EVAL      ZZTOTD = KDVLRL

     C                   CALLB     'ZZADD'
     C                   PARM                    ZZAMT
     C                   PARM                    ZZTOTI
     C                   PARM                    ZZTOTD

     C                   EVAL      KDVLRF = ZZTOTI
     C                   EVAL      KDVLRL = ZZTOTD

     C                   EVAL      ZZAMT = KDEAMT / 1000
     C                   EVAL      ZZTOTI = KZHRWN
     C                   EVAL      ZZTOTD = KZHRDC

     C                   CALLB     'ZZADD'
     C                   PARM                    ZZAMT
     C                   PARM                    ZZTOTI
     C                   PARM                    ZZTOTD

     C                   EVAL      KZHRWN = ZZTOTI
     C                   EVAL      KZHRDC = ZZTOTD
     C                   ENDIF

      ** Generate Cash Flow

     C                   EXSR      SRMMCF

     C                   IF        DFPYON = ' '
     C                   EVAL      AKY(3) = 'A'
     C                   MOVEA     AKY           KDAKEY

     C                   EXSR      SROpenFile

      ** Write record to A/C key file

     C                   IF        KDEAMT <> 0
     C                   WRITE     DKEYSDPF
     C                   EVAL      KDNOR0 = KDNOR0 + 1

      ** Output to report
     C                   EXSR      SRWriteDetRpt

      ** Calculate Hash Total

     C                   EVAL      ZZAMT = KDEAMT / 1000
     C                   EVAL      ZZTOTI = KDVLRF
     C                   EVAL      ZZTOTD = KDVLRL

     C                   CALLB     'ZZADD'
     C                   PARM                    ZZAMT
     C                   PARM                    ZZTOTI
     C                   PARM                    ZZTOTD

     C                   EVAL      KDVLRF = ZZTOTI
     C                   EVAL      KDVLRL = ZZTOTD

     C                   EVAL      ZZAMT = KDEAMT / 1000
     C                   EVAL      ZZTOTI = KZHRWN
     C                   EVAL      ZZTOTD = KZHRDC

     C                   CALLB     'ZZADD'
     C                   PARM                    ZZAMT
     C                   PARM                    ZZTOTI
     C                   PARM                    ZZTOTD

     C                   EVAL      KZHRWN = ZZTOTI
     C                   EVAL      KZHRDC = ZZTOTD
     C                   ENDIF

     C                   IF        KDREVI <> 1
     C                   EVAL      DFRECI = 'M'
     C                   ENDIF
     C                   ENDIF

     C                   IF        DFPYON = 'E'  AND
     C                             KDREVI <> 1
     C                   EVAL      DFRECI = 'M'
     C                   ENDIF

     C                   EVAL      KDSTCY = *Blanks

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCurr - Access SDCURRPD to get telex notice days             *
      *                                                               *
      *****************************************************************
     C     SRCurr        BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCurr
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = PCCY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBranch-  Access SDBRCHPD                                    *
      *                                                               *
      *****************************************************************
     C     SRBranch      BEGSR

     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PBranch
     C     SDBRCH        PARM      SDBRCH        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = PBranch
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      BRNM = A8BRNM

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWriteDetRpt - Write Detail Report                           *
      *                                                               *
      *****************************************************************
     C     SRWriteDetRpt BEGSR
      *
      ** Check overflow
      *
     C                   Z-ADD     2             RQDLN
     C     OFLLN         SUB       PRTLN         DIFLN
     C     DIFLN         IFLE      RQDLN
     C                   WRITE     DL000130H1
     C                   WRITE     DL000130H2
     C                   ENDIF

     C                   WRITE     DL000130D1
     C                   EVAL      *IN21 = *ON

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROpenFile - Open P1 File                                     *
      *                                                               *
      *****************************************************************
     C     SROpenFile    BEGSR
      *
     C                   IF        AGMBIN = 'Y' AND
     C                             REPBRC <> STRBRC OR
     C                             AGMBIN <> 'Y'  AND
     C                             P1OP <> 'Y'

      ** Write out total number of account keys generated for last
      ** branch and end of report message before opening new spool file
      ** KDNTOT is total number of account keys output to file.

     C                   IF        *IN21 = *ON
     C                   EVAL      KDNTOT = KDNTOT + KDNOR0
     C                   EVAL      KDNORE = KDNOR0
      *
      ** Check overflow
      *
     C                   Z-ADD     5             RQDLN
     C     OFLLN         SUB       PRTLN         DIFLN
     C     DIFLN         IFLE      RQDLN
     C                   WRITE     DL000130H1
     C                   WRITE     DL000130H2
     C                   ENDIF
     C                   WRITE     DL000130T1
     C                   EVAL      KDNOR0 = 0
     C                   EVAL      *IN21 = *OFF
     C                   ENDIF

     C                   EVAL      STRBRC = REPBRC
     C                   IF        P1OP <> 'N'
     C                   CLOSE     DL000130P1
     C                   ENDIF

     C                   OPEN      DL000130P1
     C                   EVAL      P1OP = 'Y'
     C                   EVAL      PAGE = 0

     C                   EVAL      ZSNUM = SFNUM
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      REPBRC        SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM                    ZSERR

      ** If error during ZSFILE processing, return to calling program

     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Obtain branch name for output

     C                   EXSR      SRBranch

     C                   WRITE     DL000130H1
     C                   WRITE     DL000130H2
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetDate - Calculate Next Payment date from a Frequency      *
      *                                                               *
      *****************************************************************
     C     SRSetDate     BEGSR

      ** If Frequency is not blank, calculate next payment date:

     C                   IF        DFFREQ <> *Blanks
     C                   MOVE      DFFREQ        ZFREQ             1
     C                   Z-ADD     DFNPYD        ZDAYNO            5 0
     C                   Z-ADD     DFDYIM        ZMDAY             2 0
     C                   MOVE      BJLCCY        ZCCY              3

     C                   CALLB     'ZFREQB'
     C                   PARM                    PReturnCode
     C                   PARM                    ZFREQ
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM      *BLANKS       ZLOC              3                        AR702741
     C                   PARM                    ZMDAY
     C                   PARM                    BJDFIN
     C                   PARM                    SDGELR

     C                   IF        PReturnCode <> *Blanks
     C                   EVAL      DBFILE = 'ZFREQB'
     C                   EVAL      DBASE = 3
     C                   MOVE      DFNPYD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If calculated next payment date is beyond end date of the fee:

     C                   IF        ZDAYNO > DFPEND

      ** If end date of fee is greater than Accrual Profit work date:

     C                   IF        DFPEND > WAccPftDate
     C                   EVAL      NWNPYD = DFPEND
     C                   ELSE
     C                   EVAL      NWNPYD = 0
     C                   ENDIF

     C                   ELSE
     C                   IF        DFNPYD <= WAccPftDate
     C                   EVAL      NWNPYD = ZDAYNO
     C                   ENDIF
     C                   ENDIF

      **  Else, Frequency is blank:

     C                   ELSE
     C                   IF        DFPEND > WAccPftDate
     C                   IF        DFNPYD <= WAccPftDate
     C                   EVAL      NWNPYD = DFPEND
     C                   ELSE
     C                   EVAL      NWNPYD = 0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTrailer - Trailer Processing and File Update                *
      *                                                               *
      *****************************************************************
     C     SRTrailer     BEGSR

     C                   EVAL      PAGE = 0

     C                   WRITE     DL000130A1

      ** If no account keys have been generated output such a
      ** message to the audit report

     C                   IF        P1OP <> 'Y'
     C                   WRITE     DL000130T3
     C                   END

      ** Output number of account keys generated message to the last
      ** branch report.

     C                   EVAL      KDNORE = KDNOR0

     C                   IF        P1OP = 'Y'
      *
      ** Check overflow
      *
     C                   Z-ADD     5             RQDLN
     C     OFLLN         SUB       PRTLN         DIFLN
     C     DIFLN         IFLE      RQDLN
     C                   WRITE     DL000130H1
     C                   WRITE     DL000130H2
     C                   ENDIF
     C                   WRITE     DL000130T1
     C                   ENDIF

      ** KDNTOT is total number of account keys generated field.

     C                   EVAL      KDNTOT = KDNTOT + KDNOR0

     C                   READ      DLFEEZ

     C                   IF        %EOF(DLFEEZ)
     C                   EVAl      DBASE = 4
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'DLFEEZ'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      DFNORE = DFNRIC - WNDEL + DFNINT
     C                   WRITE     DL000130T2

      ** Reset trailer file

     C                   EVAL      DFNRIC = DFNORE
     C                   EVAL      DFNINT = 0
     C                   EVAL      DFNAMD = 0
     C                   EVAL      DFNDEL = 0
     C                   UPDATE    DLFEEZF

     C                   EVAL      KZNORE = KZNORE + KDNTOT
     C                   UPDATE    DKEYSZZF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZDATE2 - Convert Midas Day No. to DDMMYY                    *
      *                                                               *
      *****************************************************************
     C     SRZDATE2      BEGSR

     C                   CALL      'ZDATE2'
     C                   PARM                    PValDat
     C                   PARM                    PDatFmt
     C                   PARM                    PDate
     C                   PARM                    PZADATE

      ** Database error

     C                   IF        PDATE = 0  AND
     C                             PZADATE = *Blanks
     C                   EVAL      DBFILE = 'ZDATE2  '
     C                   EVAL      DBASE = 5
     C                   MOVE      WStart        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMMCF - Convert Midas Day No. to DDMMYY                      *
      *                                                               *
      *****************************************************************
     C     SRMMCF        BEGSR

     C                   CLEAR                   MMCFLSD0

     C                   Z-ADD     D_DLNO        MFDLNO
     C                   Z-ADD     DFFSEQ        MFFSEQ
     C                   MOVE      D_DTYP        MFDTYP
     C                   MOVE      D_DLST        MFDLST
     C                   Z-ADD     KDEDAT        MFFLDT

     C                   MOVE      *BLANK        PZADATE
     C                   Z-ADD     KDEDAT        PValDat
     C                   EXSR      SRZDATE2
     C                   MOVE      PZADATE       MFDATE

     C                   IF        D_CCY = DFFCCY
     C                   Z-ADD     KDEAMT        MFCAMT
     C                   ELSE
     C                   Z-ADD     KDEAMT        ZAMTCI
     C                   EXSR      CNVF2D
     C                   Z-ADD     ZAMTCO        MFCAMT
     C                   ENDIF

     C                   SELECT

     C                   WHEN      DFADJY = 'Y'
     C                             AND DFPYON = 'E'
     C                             OR DFADJY = 'Y'
     C                             AND DFPYON = 'N'
     C                   EVAL      MFFTYP = 'EFAC'

     C                   WHEN      DFADJY = 'Y'
     C                             AND DFPYON = 'S'
     C                   EVAL      MFFTYP = 'SFAM'

     C                   WHEN      DFADJY = 'Y'
     C                             AND DFPYON = ' '
     C                   EVAL      MFFTYP = 'SFBT'

     C                   WHEN      DFADJY <> 'Y'
     C                             AND DFPYON = 'E'
     C                             OR DFADJY <> 'Y'
     C                             AND DFPYON = 'N'
     C                   EVAL      MFFTYP = 'EFAN'

     C                   WHEN      DFADJY <> 'Y'
     C                             AND DFPYON = 'S'
     C                   EVAL      MFFTYP = 'SFAN'

     C                   WHEN      DFADJY <> 'Y'
     C                             AND DFPYON = ' '
     C                   EVAL      MFFTYP = 'SFBN'
     C                   ENDSL

     C                   IF        DFDTYP = 'IT'
     C                             OR  DFDTYP = 'TD'
     C                             OR  DFDTYP = 'CI'
     C                             OR  DFDTYP = 'CD'
     C                   EVAL      MFIOIN = 'O'
     C                   ELSE
     C                   EVAL      MFIOIN = 'I'
     C                   ENDIF

     C                   EVAL      MFNDYP = KDEDAT - BJRDNB
     C                   MOVE      D_ICBS        MFICBS

      ** Calculation type '9'                                                                 CDL093
                                                                                              CDL093
     C                   If        D_ICBS = 9                                                 CDL093
      *                                                                                       CDL093
     C                   Z-ADD     BJRDNB        @@DAYN            5 0                        CDL093
     C                   EXSR      ZDATE9                                                     CDL093
     C                   Z-ADD     @@VDT         ZZStartDate                                  CDL093
      *                                                                                       CDL093
     C                   Z-ADD     KDEDAT        @@DAYN                                       CDL093
     C                   EXSR      ZDATE9                                                     CDL093
     C                   Z-ADD     @@VDT         ZZEndDate                                    CDL093
                                                                                              CDL093
      ** Check if the period contains a Feb 29                                                CDL093
                                                                                              CDL093
     C                   EXSR      #FEB29                                                     CDL093
      *                                                                                       CDL093
     C                   ENDIF                                                                CDL093
      *                                                                                       CDL093
     C                   SELECT

     C                   WHEN      D_ICBS = 1
     C                             OR D_ICBS = 4
     C                             OR D_ICBS = 9 AND #29FEB <> 'Y'                            CDL093
     C                   Z-ADD     365           MFNDYY

     C                   WHEN      D_ICBS = 2
     C                             OR D_ICBS = 3
     C                             OR D_ICBS = 5
     C                   Z-ADD     360           MFNDYY

     C                   WHEN      D_ICBS = 6
     C                             OR D_ICBS = 9 AND #29FEB =  'Y'                            CDL093
     C                   Z-ADD     366           MFNDYY
     C                   ENDSL


     C                   Z-ADD     D_INTR        MFIRAT
     C**********         Z-ADD     D_CNUM        MFCNUM                                       CSD027
     C                   EVAL      MFCNUM = D_CNUM                                            CSD027
     C                   MOVE      D_BRCA        MFBRCA
     C                   MOVE      D_CCY         MFCYCD
     C                   MOVE      D_BOKC        MFBKCD

     C                   Z-ADD     D_PCPL        MFCPAM


     C                   WRITE     MMCFLSD0
      *
     C     DFFCCY        IFNE      D_CCY
      *
      ** Update Amortisation Details if Fee Currency is
      ** different from Deal Currency.
      *
     C                   Z-ADD     D_DLNO        KTRAN
     C                   Z-ADD     DFFSEQ        KFSEQ
      *
     C     DFPYON        IFNE      'N'
      *
     C                   Z-ADD     DFPSTD        KSDAM
     C     KEIRA         CHAIN     MMEIRAD4
     C                   IF        %FOUND(MMEIRAL3)
     C                   Z-ADD     MFCAMT        EAAMNT
     C                   Z-ADD     ZEXCH         EAXRAT
     C                   MOVE      ZMD           EAMDIN
     C                   UPDATE    MMEIRAD4
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   Z-ADD     KDEDAT        KSDAM
     C     KEIRA         SETLL     MMEIRAD4
     C                   READP(e)  MMEIRAD4
     C                   IF        NOT %ERROR AND NOT %EOF(MMEIRAL3)
     C                             AND KTRAN = EATRAN
     C                   Z-ADD     MFCAMT        EAAMNT
     C                   Z-ADD     ZEXCH         EAXRAT
     C                   MOVE      ZMD           EAMDIN
     C                   UPDATE    MMEIRAD4
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CNVF2D - Convert Fee currency to deal currency                *
      *                                                               *
      *****************************************************************
     C     CNVF2D        BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    DFFCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   Z-ADD     A6SPRT        WFEERT
     C                   MOVE      A6MDIN        WFEEMD
     C                   Z-ADD     A6NBDP        WFEEDP
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    D_CCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   Z-ADD     A6SPRT        WDELRT
     C                   MOVE      A6MDIN        WDELMD
     C                   Z-ADD     A6NBDP        WDELDP
      *
     C                   Z-ADD     WFEERT        ZRATE1
     C                   MOVE      WFEEMD        ZMDI1
     C                   Z-ADD     WDELRT        ZRATE2
     C                   MOVE      WDELMD        ZMDI2
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1                                       232928
     C                   PARM                    ZMDI1                                        232928
     C                   PARM                    ZRATE2                                       232928
     C                   PARM                    ZMDI2                                        232928
     C                   PARM                    ZRATEX                                       232928
     C                   PARM                    ZMDIX                                        232928
                                                                                              232928
     C                   Z-ADD     ZRATEX        ZEXCH
     C                   MOVE      ZMDIX         ZMD

     C                   CALL      'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM      DFFCCY        ZCCYI
     C                   PARM      D_CCY         ZCCYO
     C                   PARM      WFEEDP        ZCDPI
     C                   PARM      WDELDP        ZCDPO
     C                   PARM                    ZAMTCO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  TOTFEE - Update Total Accruing/Amortising Fee                *
      *                                                               *
      *  Called from:  DETAIL                                         *
      *                                                               *
      *  Calls:  ZCONVZ1                                              *
      *                                                               *
      *****************************************************************
      *
     C     TOTFEE        BEGSR
      *
      ** If fee is entered today or reverse today
      *
     C                   IF        DFORED = BJRDNB
     C                             OR DFLCHD = BJRDNB
     C                             AND DFRECI = 'R'

     C                   IF        DFFCCY = D_CCY
     C                   EVAL      WFAMT = DFFAMT
     C                   ELSE
     C                   Z-ADD     DFFAMT        ZAMTCI
     C                   EXSR      CNVF2D
     C                   Z-ADD     ZAMTCO        WFAMT
     C                   ENDIF

     C                   IF        DFORED = BJRDNB
     C                             AND DFRECI = 'D'
                                                                                            BUG13404
      **                                                                                    BUG13404
     C                   IF        Wdiff404 <> 1                                            BUG13404
     C                             And BKANWD = '1'                                         BUG13404
     C                             Or  BKANWD = '0'                                        BUG13085B
     C                             And DFORED = BKAPDT                                     BUG13085B

     C                   IF        DFPYON <> 'N'                                           BUG13053A
     C                   ADD       WFAMT         D_TFDP
     C**********         EVAL      D_TFDP = D_TFDP + D_DISA                      BUG13085A BUG13085B
     C                   ENDIF                                                             BUG13053A

     C                   IF        DFADJY = 'Y'
     C                   IF        DFPYON <> 'N'                                           BUG13053A
     C                   ADD       WFAMT         D_TFDPA
     C                   ENDIF                                                             BUG13053A
     C                   SELECT

     C                   WHEN      DFPYON = 'E'
     C                             OR DFPYON = 'N'
      ** Accruing fee
     C                   ADD       WFAMT         D_TFAC
     C                   WHEN      DFPYON = 'S'
      ** Amortising fee
     C                   ADD       WFAMT         D_TFAM
     C                   WHEN      DFPYON = ' '
      ** Bullet/One off fee
     C                   ADD       WFAMT         D_TFOF
     C                   ENDSL
      *
     C                   IF        D_RCDT = 'C'
     C                   UPDATE    DEALSDCF
     C                   ELSE
     C                   UPDATE    DEALSDDF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                              BUG13404
     C                   ENDIF

     C                   IF        DFLCHD = BJRDNB
     C                             AND DFORED <> BJRDNB
     C                             AND DFRECI = 'R'
     C                   SUB       WFAMT         D_TFDP

     C                   IF        DFADJY = 'Y'
     C                   SUB       WFAMT         D_TFDPA
     C                   SELECT
      *
     C                   WHEN      DFPYON = 'E'
     C                             OR DFPYON = 'N'
      ** Accruing fee
     C                   SUB       WFAMT         D_TFAC
     C                   WHEN      DFPYON = 'S'
      ** Amortising fee
     C                   SUB       WFAMT         D_TFAM
     C                   WHEN      DFPYON = ' '
      ** Bullet/One off feeee
     C                   SUB       WFAMT         D_TFOF
     C                   ENDSL
      *
     C                   IF        D_RCDT = 'C'
     C                   UPDATE    DEALSDCF
     C                   ELSE
     C                   UPDATE    DEALSDDF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Inital processing (Only done first time through)
      *****************************************************************

     C     *INZSR        BEGSR

      **  Set up Local Data Area

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *Blanks
     C                   EVAL      DBKEY = *Blanks
     C                   EVAL      DBPGM = *Blanks
     C                   EVAL      DBASE = *Zero
     C                   OUT       LDA

      ** Key list for LEEIRAL4
     C     KEIRA         KLIST
     C                   KFLD                    KTRAN
     C                   KFLD                    KFSEQ
     C                   KFLD                    KSDAM

      ** Set sequence number to zero

     C                   EVAL      SEQ = *Blanks

      ** If system is not multibranching do not output branch details
      ** on print report

     C                   IF        AGMBIN <> 'Y'
     C                   EVAL      *IN35 = *OFF
     C                   ENDIF

     C                   EVAL      WNoRec = 0
     C                   EVAL      WNDel = 0
     C                   EVAL      KDNORE = 0
     C                   EVAL      KDNOR0 = 0
     C                   EVAL      KDNTOT = 0
     C                   EVAL      WNRev =  0
     C                   EVAL      *IN20 = *ON
     C                   EVAL      DBPGM = 'DL000130'

      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = '*FIRST'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      PDatFmt = BJDFIN

      ** Access Module Details

     C                   CALLB     'AOMMODR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY

      ** Database Error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 7
     C                   EVAL      DBKEY = '*FIRST'
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access General Ledger details

     C**********         CALLB     'AOGELRR0'                                                 CAS011
     C                   CALLB     'AOGELRR1'                                                 CAS011
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CAS011
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS011

      ** Database Error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 8
     C                   EVAL      DBKEY = '*FIRST'
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Switchable Feature if CEU003 is ON

     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      'CEU003'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database Error
     C                   IF        PRTCD = *Blanks
     C                   EVAL      CEU003 = 'Y'
     C                   ELSE
     C                   EVAL      CEU003 = 'N'

     C                   IF        PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 9
     C                   EVAL      DBKEY = 'CEU003'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW208
      ** Check if SWIFT2008 is installed                                                      CSW208
      *                                                                                       CSW208
     C                   MOVEL     'N'           CSW208                                       CSW208
     C                   CALL      'SWIF2008'                                                 CSW208
     C                   PARM      *BLANKS       PRTCD                                        CSW208
                                                                                              CSW208
     C                   IF        PRTCD = 'CSW2008'                                          CSW208
     C                   MOVEL     'Y'           CSW208                                       CSW208
     C                   ENDIF                                                                CSW208

     C                   IN        RUNDAT
     C                   EVAL      ZDAYNO = AGRDNB

      ** Check system date fprmat: DDMMYY (*IN98 off) or MMDDYY (*IN98 on)

     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF

      ** Use previous end of year and month of RUNDAY to check whether
      ** the current month should be used for the array index

     C                   EVAL      WStart = BJPEYD + 1
     C                   EVAL      PValDat = WStart
     C                   EXSR      SRZDATE2
     C
     C                   MOVEL     PZADATE       WStartOfYr

     C                   EVAL      WNxtWDay = BJDNWD - 1
     C                   EVAL      PValDat = BJDNWD
     C                   EXSR      SRZDATE2
     C                   EVAL      WDate = PDate

      ** If the date format is to be European (DDMMYY) then use the
      ** correct data structure

     C                   MOVE      WDate         SMDT
     C                   IF        BJDFIN = 'D'
     C                   MOVEL     WStartOfYr    SMDT
     C                   EVAL      WDayNo = WDate / 10000
     C                   ELSE

      ** Otherwise use the U.S.A.-defined date data structure
      ** (MMDDYY) for manipulation.

     C                   MOVE      WDate         SMDTUS
     C                   MOVE      WDate         WADATE                                      BUG9807
     C                   MOVE      WStartOfYr    SMDDUS
     C                   MOVE      SMDDUS        SMDD
     C                   MOVE      SMUS          SM
     C*******************EVAL      WDayNo = WDate / 100                                      BUG9807
     C                   EVAL      WADAYNO = %Subst(WADATE:3:2)                              BUG9807
     C                   MOVE      WADAYNO       WDayNo                                      BUG9807
     C                   ENDIF

     C                   MOVEL     WStartOfYr    WStartOfYrNo

      ** If the day number of the date of next working
      ** day is less than the start of month day subtract
      ** one from the month number of the date of next working day
      ** this ensures that the conversion and checking of the start
      ** of month date is performed on the current month & not the next

     C                   IF        WStartOfYrNo > WDayNo
     C                   EVAL      SM = SM - 1
     C                   IF        SM = 0
     C                   EVAL      SM = 12
     C                   EVAL      SY = SY - 1
     C                   ENDIF
     C                   ENDIF

      ** Convert the constructed start date to day format

     C                   MOVE      SMDT          PLDate
     C                   CALL      'LERDATEF'
     C                   PARM                    PLDate
     C                   PARM                    PLDayNo
     C                   PARM                    PLRetCode

      ** Check whether the start of the new month falls after RUND
      ** and on or before the date of next working day and if so
      ** use the last day of the month as the accrual/profit day.

     C                   IF        PLDayNo > BJRDNB  AND
     C                             PLDayNo <= BJDNWD AND
     C                             BKAPDT  = BJRDNB
     C                   EVAL      WAccPftDate = PLDayNo - 1
     C                   ELSE

      ** Find the lesser of next working day minus 1 and accrual profit day

     C                   IF        BKAPDT < WNxtWDay
     C                   EVAL      WAccPftDate = BKAPDT
     C                   ELSE
     C                   EVAL      WAccPftDate = WNxtWDay
     C                   ENDIF
     C                   ENDIF

      ** Find the month of the APDAT field for historic file

     C                   EVAL      PValDat = WAccPftDate
     C                   EXSR      SRZDate2
     C                   MOVE      PDate         SMDT
     C                   MOVE      PDate         SMDTUS

      ** Check which date format is being used and set up the date to
      ** be converted accordingly.

     C                   IF        AGDFF = 'D'
     C                   MOVE      SMDD          MNTND
     C                   ELSE
     C                   MOVE      SMDDUS        MNTND
     C                   ENDIF

      ** Compute the total number of days from start date of the month
      ** up to the accrual profit date.  Also, get the value of the
      ** start date of the month in Midas format.

     C                   EVAL      MSTD = (WAccPftDate - MNTND) + 1

      ** Read in DKEYSZZ totals

     C                   READ      DKEYSZZF

      ** Ensure Report Spool File recorded by RCF.
     C                   EVAL      ZSNUMU = SFNUMU

     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM                    ZSERR

      ** Error during ZSFILE processing, return to calling program

     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   READ      SDHEDGPD                                                   233545
                                                                                              233545
     C                   Eval      Wdiff404 = BJDNWD - BKAPDT                               BUG13404
     C                   ENDSR

      *****************************************************************
      /EJECT
      ********************************************************************
      *
      * *PSSR  - Program exception error routine
      *          Called automatically if a program error occurs,
      *          or directly by the program code using EXSR.
      *          This subroutine DUMPs the program just once.
      *
      *  CALLED FROM:  Any Error Situation
      *
      *  CALLS:
      *
      ********************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP

     C                   EVAL      PAGE = 0

      ** Write error report details

     C                   WRITE     DL000130A1
     C                   WRITE     ERROR
     C                   ENDIF

      **  If *PSSR already run, then just end the program here.

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDSR
     C/COPY ZSRSRC,ZFEB29Z2LE                                                                 CDL093
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 CDL093
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
