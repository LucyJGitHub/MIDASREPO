     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL CGL013 Initialisation Program')               *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  GL001450 - GL CGL013 Initialisation program                  *
      *                                                               *
      *  Function:  This program initialises fields for CGL013        *
      *             enhancement.                                      *
      *                                                               *
      *  Called By: GLC001450 - GL CGL013 Initialisation Program      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. 223783             Date 28May12               *
      *  Prev Amend No. CMG008             Date 20Feb20               *
      *                 CSD101             Date 07Dec18               *
      *                 MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL029             Date 01Sep03               *
      *                 216937             Date 28Apr03               *
      *                 CRE008             Date 28Apr03               *
      *                 CGL013  *CREATE    Date 25May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  223783 - Applied for AR973615.(Child: AR973617) (Recompile)  *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  CSD101 - Password Encryption                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216937 - Initialise MGSRCA in GLPOSTPD  (CRE008 fix)         *
      *  CRE008 - Cash Management                                     *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
      *
      ** Network Details file
     FSDNWRKL0  UF   E           K DISK    INFSR(*PSSR)
      *
      ** SWIFT Accounts file by Branch/Account no.
     FSWACB     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SW)
     F                                     IGNORE(SWACSSAF)
     F                                     IGNORE(SWACSSCF)
      *
      ** SWIFT Statement Postings
     FMSPOSTL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Bic Directory file
     FMEBICDL2  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Customer file by SWIFT Id
     FSDCUSTL7  IF   E           K DISK    INFSR(*PSSR)
      *
      ** GL Network Accounts
     FGLNWACPD  O    E             DISK    INFSR(*PSSR)
      *
      ** GL Network Accounts
     FGLNW94PD  O    E             DISK    INFSR(*PSSR)
      *
      ** GL Postings for MT94x
     FGLPOSTPD  O    E             DISK    INFSR(*PSSR)
      *
     FGL001450AUO    E             PRINTER INFDS(SPOOLU)
     FGL001450P1O    E             PRINTER INFDS(SPOOL1)
      *****************************************************************
     D/EJECT
      *****************************************************************
      *
      /SPACE 3
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
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SPOOL1          DS
      *
      ** File Information Data Structure for FT0014P1
      *
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      *
      ** File Information Data Structure for FT0014AU
      *
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structure for Bank details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External data structure for SAR details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for Currency details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for Access Objects - short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for Access Objects - long data structure
      *
     D*RACCOUNT*       DS            18                                                       CGL029
     D RACCOUNT        DS            24                                                       CGL029
     D  RBRCA                  1      3
     D**RCNUM***               4      9  0                                                    CSD027
     D  RCNUM                  4      9                                                       CSD027
     D  RCCY                  10     12
     D**RACOD***              13     16  0                                                    CGL029
     D**RACSQ***              17     18  0                                                    CGL029
     D  RACOD                 13     22  0                                                    CGL029
     D  RACSQ                 23     24  0                                                    CGL029
      *
     D                 DS
      ** Data Structure to avoid decimal error
     D NITMS                          5P 0                                      Number of items
     D WNITMS                  1      3A
     D                 DS
      ** Data Structure to avoid decimal error
     D CHGA                          13P 0                                      Charge amount
     D WCHGA                   1      7A
     D                 DS
      ** Data Structure to avoid decimal error
     D ORAMT                         13P 0                                      Original Amt - Giro
     D WORAMT                  1      7A
      *
      *****************************************************************
     D/EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform initialisation.
      *
     C                   EXSR      SRINIT
      *
      ** Perform upgrade of Network Details file.
      *
     C                   EXSR      SRNWRK
      *
      ** Perform migration of SWACSSB to GLNWACPD and GLNW94PD
      *
     C                   EXSR      SRNWAC
      *
      ** Output Audit report.
      *
     C                   EXSR      SRAUDIT
      *
      ** End program and return.
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Subroutine to do Program Initialisation             *
      *                                                               *
      *  Called By : Main Processing                                  *
      *  Calls     : AOBANKR0, AOFTFRR0, AOSARDR0, *PSSR              *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Move program name into *LDA field.
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'GL001450'    DBPGM
     C                   OUT       LDA
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
     C                   Z-ADD     0             RCNT1
     C                   Z-ADD     0             RCNT2
     C                   Z-ADD     0             RCNT3
     C                   Z-ADD     0             RPOST
      *
     C                   MOVE      *BLANK        WRCCY             3
      *
     C     KBickey       Klist
     C                   Kfld                    KBic              8
     C                   Kfld                    KBrc              3
      *
     C     KAccount      Klist
     C                   Kfld                    SWBRCA
     C                   Kfld                    WCNUM
     C                   Kfld                    SWCCY
     C                   Kfld                    SWACOD
     C                   Kfld                    SWACSQ
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNWRK  - SDNWRKPD Upgrade                                   *
      *                                                               *
      *  Called By : Main Processing                                  *
      *  Calls     :                                                  *
      *                                                               *
      *****************************************************************
     C     SRNWRK        BEGSR
      *
      ** Read first record from file.
      *
     C     *LOVAL        SETLL     @EDREJY
      *
     C                   READ      @EDREJY                                89
      *
      ** Do Until End of File.
      *
     C                   DOW       *IN89 = *OFF
      *
      ** Count records read.
      *
     C                   ADD       1             RCNT1
      *
      ** Update SDNWRKPD
      *
      ** Prior to this feature, the MT940s and MT950s are generated only for network
      **    SWIFT so this upgrade will consider only the current setting
      ** This means for other networks, the flags to generate MT94x messages will be set to 'N'
      **    as none of these used to generate these messages before.
      ** Note that even for Fontis network (the interface generates MT940 and Mt942)  these
      **    fields will still need to be set to 'N' because some modifications will need to be
      **    developed before it could work with  this feature.
      ** It is envisaged that after switching on this  feature, these records will be
      **    revisited so that the bank users are able to apply values according to their use.
      *
      * Network
     C                   EVAL      EDNWRK = EDNWRK
      * Network Description
     C                   EVAL      EDNETD = EDNETD
      * Last Change Date
     C                   EVAL      EDLCD  = BJRDNB
      * Type of Last Change
     C                   EVAL      EDTYLC = 'A'
      * Type of protocol
     C                   If        EDNWRK = 'SWIFT'
     C                   EVAL      EDPROT = '*SWIFT'
     C                   Else
     C                   EVAL      EDPROT = *blank
     C                   Endif
      * Allow MT940 generation
     C                   EVAL      EDM940 = 'N'
      *   For SWIFT only,
      *   if any one record in SWACSSB has MT940 destination <> blank,
      *   then a this flag must be set to 'Y'
     C                   If        EDNWRK = 'SWIFT'
     C     *LOVAL        SETLL     SWACSSBF
     C                   READ      SWACSSBF                               70
     C                   DOW       *IN70 = *OFF
     C                   If        SWMT94 <> *Blank
     C                   EVAL      EDM940 = 'Y'
     C                   Leave
     C                   Endif
     C                   READ      SWACSSBF                               70
     C                   Enddo
     C                   Endif
      * Allow MT941 generation
     C                   EVAL      EDM941 = 'N'
      * Allow MT942 generation
     C                   EVAL      EDM942 = 'N'
      * Allow MT950 generation
     C                   EVAL      EDM950 = 'N'
      *   For SWIFT only,
      *   if any one record in SWACSSB has MT940 destination = blank,
      *   then this flag must be set to 'Y'
     C                   If        EDNWRK = 'SWIFT'
     C     *LOVAL        SETLL     SWACSSBF
     C                   READ      SWACSSBF                               70
     C                   DOW       *IN70 = *OFF
     C                   If        SWMT94 = *Blank
     C                   EVAL      EDM950 = 'Y'
     C                   Leave
     C                   Endif
     C                   READ      SWACSSBF                               70
     C                   Enddo
     C                   Endif
      * Allow multiple destination for MT94x
     C                   EVAL      EDAMDS = 'N'
      * Extended narrative allowed
     C                   EVAL      EDENRA = 'N'
      * Retention period for schedule request
     C                   EVAL      EDRPSR = 0
      * Prevent automatic submission at start of business
     C                   EVAL      EDPASS = 'N'
      * Prevent automatic submission if NWD
     C                   EVAL      EDPASN = 'N'
      * MT940 Maximum message length
      * Default MT940 message status
     C                   EVAL      ED0MXL = 0
     C                   EVAL      ED0DMS = *blank
     C                   If        EDM940 = 'Y'
     C                   EVAL      ED0MXL = 1900
     C                   EVAL      ED0DMS = 'R'
     C                   Endif
      * Default MT940 message level 1-6
     C                   EVAL      ED0MI1 = *blank
     C                   EVAL      ED0MI2 = *blank
     C                   EVAL      ED0MI3 = *blank
     C                   EVAL      ED0MI4 = *blank
     C                   EVAL      ED0MI5 = *blank
     C                   EVAL      ED0MI6 = *blank
      * Allow MT941 generation on external request
     C                   EVAL      ED1AER = *blank
      * Default MT941 message status
     C                   EVAL      ED1SER = *blank
      * Allow MT941 generation on schedule
     C                   EVAL      ED1AGS = *blank
      * Default MT941 message status
     C                   EVAL      ED1SGS = *blank
      * Allow MT941 generation on manual request
     C                   EVAL      ED1AMR = *blank
      * Default MT941 message status
     C                   EVAL      ED1SMR = *blank
      * MT941 maximum length
     C                   EVAL      ED1MXL = 0
      * Generate MT941 even when no movement
     C                   EVAL      ED1GNM = *blank
      * MT941 Re-extract real posting
     C                   EVAL      ED1RPL = *blank
      * MT941 Re-extract shadow posting
     C                   EVAL      ED1RSP = *blank
      * Default MT941 message level 1-6
     C                   EVAL      ED1MI1 = *blank
     C                   EVAL      ED1MI2 = *blank
     C                   EVAL      ED1MI3 = *blank
     C                   EVAL      ED1MI4 = *blank
     C                   EVAL      ED1MI5 = *blank
     C                   EVAL      ED1MI6 = *blank
      * Allow MT942 generation on external request
     C                   EVAL      ED2AER = *blank
      * Default MT942 message status
     C                   EVAL      ED2SER = *blank
      * Allow MT942 generation on schedule
     C                   EVAL      ED2AGS = *blank
      * Default MT942 message status
     C                   EVAL      ED2SGS = *blank
      * Allow MT942 generation on manual request
     C                   EVAL      ED2AMR = *blank
      * Default MT942 message status
     C                   EVAL      ED2SMR = *blank
      * MT942 maximum length
     C                   EVAL      ED2MXL = 0
      * Generate MT942 even when no
     C                   EVAL      ED2GNM = *blank
      * MT942 Fix number of items per message
     C                   EVAL      ED2FNI = *blank
      * MT942 Number of items per message
     C                   EVAL      ED2NIM = 0
      * MT942 Re-extract real posting
     C                   EVAL      ED2RPL = *blank
      * MT942 Re-extract shadow posting
     C                   EVAL      ED2RSP = *blank
      * Default MT942 message level
     C                   EVAL      ED2MI1 = *blank
     C                   EVAL      ED2MI2 = *blank
     C                   EVAL      ED2MI3 = *blank
     C                   EVAL      ED2MI4 = *blank
     C                   EVAL      ED2MI5 = *blank
     C                   EVAL      ED2MI6 = *blank
      * MT950 Maximum length
      * Default MT950 message status
     C                   EVAL      ED5MXL = 0
     C                   EVAL      ED5DMS = *blank
     C                   If        EDM950 = 'Y'
     C                   EVAL      ED5MXL = 1900
     C                   EVAL      ED5DMS = 'R'
     C                   Endif
      * FTP Polling frequency
     C                   EVAL      EDPFRQ = 0
      * FTP Remote file name (prefix)
     C                   EVAL      EDRFNP = *blank
      * FTP Remote file name suffixed by date
     C                   EVAL      EDRFSD = *blank
      * FTP Remote file name suffixed by time
     C                   EVAL      EDRFST = *blank
      * FTP Remote file name suffixe by sequence
     C                   EVAL      EDRFSS = *blank
      * FTP File extension to be used
     C                   EVAL      EDFEXU = *blank
      * FTP Remote path name
     C                   EVAL      EDRPNM = *blank
      * FTP Target server name
     C                   EVAL      EDTSNM = *blank
      * FTP Server User ID
     C                   EVAL      EDSUID = *blank
      **FTP*Server*Password                                                                   CSD101
     C**********         EVAL      EDSRVP = *blank                                            CSD101
      * FTP Exit Program
     C                   EVAL      EDEXTP = *blank
      *
      *
     C                   UPDATE    @EDREJY
      *
      ** Write report detail
      *
     C                   EXSR      SRWREC1
      *
      ** Read next record.
      *
     C                   READ      @EDREJY                                89
      *
      ** End of Do Until End of Valid Records.
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNWAC  - Perform migration of SWACSSB to GLNWACPD and       *
      *            GLNW94PD                                           *
      *                                                               *
      *  Called By : Main Processing                                  *
      *  Calls     :                                                  *
      *                                                               *
      *****************************************************************
     C     SRNWAC        BEGSR
      *
      *
      ** Read first record from file.
      *
     C     *LOVAL        SETLL     SWACSSBF
     C                   READ      SWACSSBF                               60
      *
      ** Do Until End of File.
      *
     C                   DOW       *IN60 = *OFF
      *
     C                   CLEAR                   GLNWACD0
     C                   CLEAR                   GLNW94D0
      *
      ** Count records read.
      *
     C                   ADD       1             RCNT2
      *
      *  =======================
      ** Write to file GLNWACPD
      *  =======================
      *
      *  Record Id
     C                   EVAL      NARECI = SWRECI
      *  Network
     C                   EVAL      NANWRK = 'SWIFT'
      *  Branch
     C                   EVAL      NABRCH = SWBRCA
      *  Customer Number
     C                   Movel     SWCNUMA       NACNUM
      *  Currency
     C                   EVAL      NACCY  = SWCCY
      *  Account code
     C                   EVAL      NAACOD = SWACOD
      *  Account sequence
     C                   EVAL      NAACSQ = SWACSQ
      *  Network account type
     C                   EVAL      NANATY = 'S'
      *  Generate MT950 flag
     C                   If        SWMT94 = *blank
     C                   EVAL      NAG950 = 'Y'
     C                   Else
     C                   EVAL      NAG950 = 'N'
     C                   Endif
      *  MT950 statement frequency
      *  MT950 statement day in month
      *  MT950 next statement date
      *  MT950 demand statement ind.
      *  MT950 last closing balance
      *  MT950 Last statement date
      *  MT950 last statement time
      *  MT950 last page number
     C                   If        NAG950 = 'Y'
     C                   EVAL      NA5SFQ = SWSTFQ
     C                   EVAL      NA5SDY = SWSTDY
     C                   EVAL      NA5NSD = SWNSTD
     C                   EVAL      NA5DSI = SWDDIS
     C                   EVAL      NA5LCB = SWCFSB
     C                   EVAL      NA5LSD = SWLSTD
     C                   EVAL      NA5LST = 0
     C                   EVAL      NA5LSN = SWLSNO
     C                   Else
     C                   EVAL      NA5SFQ = *blank
     C                   EVAL      NA5SDY = 0
     C                   EVAL      NA5NSD = 0
     C                   EVAL      NA5DSI = *blank
     C                   EVAL      NA5LCB = 0
     C                   EVAL      NA5LSD = 0
     C                   EVAL      NA5LST = 0
     C                   EVAL      NA5LSN = 0
     C                   Endif
      *  Last record change date
     C                   EVAL      NALCDT = BJRDNB
      *  Type of last change
     C                   EVAL      NACHTP = 'I'
      *  Last change user
     C                   EVAL      NAUSER = *blank
      *
      ** Write record to GLNWACPD
     C                   WRITE     GLNWACD0
      *
      ** Count records written
      *
     C                   ADD       1             RCNT3
      *
      ** Transfer postings from SWPOSPD to GLPOSTPD, if MT950
      ** then skip writing GLNW94PD
      *
     C                   If        NAG950 = 'Y'
     C                   EXSR      SRPOST
     C                   GOTO      READNEXT
     C                   Endif
      *
      *  ===================================================================
      ** Write to file GLNW94PD only if a MT940 is generated for the account
      *  ===================================================================
      *
     C                   If        SWMT94 <> *blank
      *
      * Record Id
     C                   Eval      N4RECI = SWRECI
      * Network
     C                   Eval      N4NWRK = 'SWIFT '
      * Account Branch
     C                   Eval      N4BRCA = SWBRCA
      * Account Customer
     C                   Movel     SWCNUMA       N4CNUM
      * Account Currency
     C                   Eval      N4CCY  = SWCCY
      * Account Code
     C                   Eval      N4ACCD = SWACOD
      * Account Sequence
     C                   Eval      N4ACSQ = SWACSQ
      * Network Account type
     C                   Eval      N4NATY = 'S'
      * MT94x Destination
     C                   Eval      N4DSTN = SWMT94
      * MT94x Destination description
      *    Take this from BIC directory if loaded, else from Customer file
     C                   Eval      KBic   = %Subst(N4DSTN: 1 : 8 )
     C                   Eval      KBrc   = %Subst(N4DSTN: 9 : 3 )
     C                   If        KBrc = *blank
     C                   Eval      KBrc   = 'XXX'
     C                   Endif
     C     KBickey       Chain     MEBICDL2                           50
     C                   If        *IN50 = *off
     C                   Eval      N4DSTD = BDINS1
     C                   Else
     C                   Movel     N4DSTD        KBic12           12
     C     KBic12        Chain     SDCUSTL7                           50
     C                   If        *IN50 = *off
     C                   Eval      N4DSTD = BBCNA1
     C                   Else
     C                   Eval      N4DSTD = 'Description not found'
     C                   Endif
     C                   Endif
     C                   Endif
      * Generate MT940 flag
     C                   Eval      N4G940 = 'Y'
      * Generate MT941 flag
     C                   Eval      N4G941 = 'N'
      * Generate MT942 flag
     C                   Eval      N4G942 = 'N'
      * MT940 statement frequency
     C                   Eval      N40SFR = SWSTFQ
      * MT940 Statement day in month
     C                   Eval      N40SDM = SWSTDY
      * MT940 Next statement date
     C                   Eval      N40NSD = SWNSTD
      * MT940 demand statement ind.
     C                   Eval      N40DSI = SWDDIS
      * Default MT940 message level
      * Default MT940 message level
      * Default MT940 message level
      * Default MT940 message level
      * Default MT940 message level
      * Default MT940 message level
     C                   Eval      N40MI1 = *blank
     C                   Eval      N40MI2 = *blank
     C                   Eval      N40MI3 = *blank
     C                   Eval      N40MI4 = *blank
     C                   Eval      N40MI5 = *blank
     C                   Eval      N40MI6 = *blank
      * MT940 Last statement date
     C                   Eval      N40LSD = SWLSTD
      * MT940 Last statement time
     C                   Eval      N40LST = 0
      * MT940 Last statement page
     C                   Eval      N40LSN = SWLSNO
      * MT940 Last closing available
     C                   Eval      N40LCA = SWCFSB
      * MT941 Date/Time indicator
     C                   Eval      N41DTI = *blank
      * MT941 Opening balance information
     C                   Eval      N41OBI = *blank
      * MT941 Number and sum of field
     C                   Eval      N41LSF = *blank
      * MT941 Closing available balance
     C                   Eval      N41CAB = *blank
      * MT941 Forward available bala
     C                   Eval      N41FAB = *blank
      * Default MT941 message level 1-6
     C                   Eval      N41MI1 = *blank
     C                   Eval      N41MI2 = *blank
     C                   Eval      N41MI3 = *blank
     C                   Eval      N41MI4 = *blank
     C                   Eval      N41MI5 = *blank
     C                   Eval      N41MI6 = *blank
      * MT941 Re-extract postings f
     C                   Eval      N41RPL = *blank
      * MT941 Re-extract all shadow
     C                   Eval      N41RAS = *blank
      * MT941 generation even when
     C                   Eval      N41GNM = *blank
      * Allow MT941 generation on e
     C                   Eval      N41AER = *blank
      * Allow MT941 generation on s
     C                   Eval      N41AGS = *blank
      * Allow MT941 generation on manual request
     C                   Eval      N41AMR = *blank
      * MT941 Last statement page
     C                   Eval      N41LSP = 0
      * MT941 Last statement date
     C                   Eval      N41LSD = 0
      * MT941 Last statement time
     C                   Eval      N41LST = 0
      * MT941 Last sum of debit numb
     C                   Eval      N41LDN = 0
      * MT941 Last sum of debit amou
     C                   Eval      N41LDA = 0
      * MT941 Last sum of credit num
     C                   Eval      N41LCN = 0
      * MT941 Last sum of credit amo
     C                   Eval      N41LCA = 0
      * MT941 Next Opening balance
     C                   Eval      N41LCB = 0
      * MT942 Number and Sum of Entr
     C                   Eval      N42LSF = *blank
      * MT942 Floor limit debit
     C                   Eval      N42FLD = 0
      * MT942 Floor limit credit
     C                   Eval      N42FLC = 0
      * Default MT942 message level 1- 6
     C                   Eval      N42MI1 = *blank
     C                   Eval      N42MI2 = *blank
     C                   Eval      N42MI3 = *blank
     C                   Eval      N42MI4 = *blank
     C                   Eval      N42MI5 = *blank
     C                   Eval      N42MI6 = *blank
      * MT942 Re-extract postings fr
     C                   Eval      N42RPL = *blank
      * MT942 Re-extract all shadow
     C                   Eval      N42RAS = *blank
      * MT942 generation even when n
     C                   Eval      N42GNM = *blank
      * MT942 generation on external
     C                   Eval      N42AER = *blank
      * MT942 generation on schedule
     C                   Eval      N42AGS = *blank
      * MT942 generation on manual r
     C                   Eval      N42AMR = *blank
      * MT942 Last statement page
     C                   Eval      N42LSP = 0
      * MT942 Last statement date
     C                   Eval      N42LSD = 0
      * MT942 Last statement time
     C                   Eval      N42LST = 0
      * MT942 Last sum of debit numb
     C                   Eval      N42LDN = 0
      * MT942 Last sum of debit amou
     C                   Eval      N42LDA = 0
      * MT942 Last sum of credit num
     C                   Eval      N42LCN = 0
      * MT942 Last sum of credit amo
     C                   Eval      N42LCA = 0
      * Last record change date
     C                   Eval      N4LCDT = BJRDNB
      * Type of last change
     C                   Eval      N4CHTP = 'I'
      * Last change user
     C                   Eval      N4USER = *blank
      *
      ** Transfer postings from SWPOSPD to GLPOSTPD
      *
     C                   EXSR      SRPOST
      *
      ** Write record to file
      *
     C                   WRITE     GLNW94D0
      *
     C     READNEXT      TAG
      *
      ** First write detail on report
      *
     C                   EXSR      SRWREC2
      *
      ** Read next record.
      *
     C                   READ      SWACSSBF                               60
      *
      ** End of Do Until End of Valid Records.
      *
     C                   ENDDO
      *
      ** Write final record and End of Report.
      *
     C                   EXSR      SRWEND
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPOST  - Transfer Postings from SWPOSPD to GLPOSTPD         *
      *                                                               *
      *  Called By : SRNWAC                                           *
      *  Calls     :                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRPOST        BEGSR
      *
      ** For each record in MSPOSTL0 with the same account number,
      ** write a record in  GLPOSTL0
      *
     C                   Eval      RPOST = 0
     C**********         Move      SWCNUMA       WCNUM             6 0                        CSD027
     C                   Move      SWCNUMA       WCNUM             6                          CSD027
      *
     C     KAccount      SETLL     MSPOSTL0
      *
     C                   Read      MSPOSTL0                               40
      *
     C                   DoW       *IN40 = *OFF    And
     C                             BRCA  = SWBRCA  And
     C                             CNUM  = WCNUM   And
     C                             CCY   = SWCcy   And
     C                             ACOD  = SWACOD  And
     C                             ACSQ  = SWACSQ
      *
      *   Manage the invalid fields (Invalid decimal error)
      *
     C                   MOVE      WNITMS        WNITMS                   99
     C   99              EVAL      NITMS = *ZEROS
     C                   MOVE      WCHGA         WCHGA                    99
     C   99              EVAL      CHGA = *ZEROS
     C                   MOVE      WORAMT        WORAMT                   99
     C   99              EVAL      ORAMT = *ZEROS
      *
      *   APOSTPDF fields will be carried on to GLPOSTPD
      *    and now, the MG* fields:
      *
      *    Network
     C                   Eval      MGNWRK = 'SWIFT'
      *    Network Account Type
     C                   Eval      MGNATY = 'S'
      *    Destination
     C                   Eval      MGDSTN = SWMT94
      *    Message type
     C                   If        SWMT94 = *blank
     C                   Eval      MGMTPY = '950'
     C                   Else
     C                   Eval      MGMTPY = '940'
     C                   Endif
      *    Additional Information 1 - 6
     C                   Eval      MGADI1 = *blank
     C                   Eval      MGADI2 = *blank
     C                   Eval      MGADI3 = *blank
     C                   Eval      MGADI4 = *blank
     C                   Eval      MGADI5 = *blank
     C                   Eval      MGADI6 = *blank
      *    ERI Indicator
     C                   Eval      MGAERI = *blank
      *    Processed Indicator
     C                   Eval      MGPROC = *blank
      *    ZS Field 61   6-9                                                                  CRE008
     C                   Eval      MGZ616 = *blank                                            CRE008
     C                   Eval      MGZ617 = *blank                                            CRE008
     C                   Eval      MGZ618 = *blank                                            CRE008
     C                   Eval      MGZ619 = *blank                                            CRE008
      *    ZS Field 86 - 1-6                                                                  CRE008
     C                   Eval      MGZ861 = *blank                                            CRE008
     C                   Eval      MGZ862 = *blank                                            CRE008
     C                   Eval      MGZ863 = *blank                                            CRE008
     C                   Eval      MGZ864 = *blank                                            CRE008
     C                   Eval      MGZ865 = *blank                                            CRE008
     C                   Eval      MGZ866 = *blank                                            CRE008
      *    GA Source Account                                                                  216937
     C                   Eval      MGSRCA = *blank                                            216937
      *
      ** Write to GLPOSTPD
      *
     C                   WRITE     GLPOSTD0
      *
      ** Accumulate record counter
      *
     C                   Add       1             RPOST
      *
      *  Read next SWPOSPD  record
     C                   Read      MSPOSTL0                               40
      *
     C                   Enddo
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWREC1 - Subroutine to write a Detail record to the Report  *
      *                                                               *
      *  Called By : SRNWRK                                           *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRWREC1       BEGSR
      *
     C                   EVAL      RNWRK = EDNWRK
      *
      ** Check that sufficient lines remain for the Format.  If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADPY
     C                   WRITE     HEAD1
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   WRITE     DETAIL1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWREC2 - Subroutine to write a Detail record to the Report  *
      *                                                               *
      *  Called By : SRNWAC                                           *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRWREC2       BEGSR
      *
     C                   EVAL      RNETWORK = NANWRK
     C                   EVAL      RBRCA    = NABRCH
     C                   EVAL      RCNUM    = NACNUM
     C                   EVAL      RCCY     = NACCY
     C                   EVAL      RACOD    = NAACOD
     C                   EVAL      RACSQ    = NAACSQ
     C                   EVAL      RMT950   = NAG950
     C                   If        NAG950   = 'Y'
     C                   EVAL      RMT940   = 'N'
     C                   Else
     C                   EVAL      RMT940   = N4G940
     C                   Endif
     C                   EVAL      RMT941   = 'N'
     C                   EVAL      RMT942   = 'N'
     C                   If        RMT940 = 'Y'
     C                   EVAL      RDEST    = N4DSTN
     C                   Else
     C                   EVAL      RDEST    = *blank
     C                   Endif
      *
      ** Check that sufficient lines remain for the Format.  If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C     RCNT2         OREQ      1
     C                   WRITE     HEADPY
     C                   WRITE     HEAD2
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   WRITE     DETAIL2
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWEND - Subroutine to write End of Report                   *
      *                                                               *
      *  Called By : SRINPAY, SROTPAY                                 *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRWEND        BEGSR
      *
      ** Check that sufficient lines remain for the Format.  If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
      *
      ** Write out Reminder
      *
     C                   WRITE     REMIND
      *
      ** Write out End of Report
      *
     C                   WRITE     TRAILPY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Output Audit report                                *
      *                                                               *
      *  Called By : Main Processing, *PSSR                           *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRAUDIT       BEGSR
      *
      ** Output Report Header.
      *
     C                   WRITE     HEADAU
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, output "No Details" message.
      *
     C                   IF        RCNT1 = 0 AND RCNT2 = 0
     C                   WRITE     NODTLS
     C                   ELSE
      *
      ** Output Report Header and File Controls.
      *
     C                   WRITE     CONTROL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error Control subroutine                            *
      *                                                               *
      *  Called By :                                                  *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
      ** Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   EXSR      SRAUDIT
     C                   DUMP
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
