     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Watch List Bulk Data Checking module (SE)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000014 - Watch List Bulk Data Checking module for SE       *
      *                                                               *
      *  Function:  This module check functions under them if watch   *
      *             list checking will be performed on their existing *
      *             details file. When the periodic check date equals *
      *             the run date, the component will call the         *
      *             appropriate module to process each live record for*
      *             each specific function. Run daily on COB.         *
      *                                                               *
      *  Component of: SDC000014 (Watch List Bulk Data Checking       *
      *                Component for Securities)                      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR702741           Date 02Feb11               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 222727             Date 05Nov03               *
      *                 221934             Date 30Sep03               *
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  221934 - Compliance Watch alpha site fix.                    *
      *           Array index error caused by doing the CW ICD data   *
      *           update even if no bulk check to be performed.       *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
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
 
     FSDCWHTL0  IF   E           K DISK    INFSR(*PSSR)
     ** Midas Compliance Watch Hit List(FType/Identifier/Branch)
 
     FTRADS     IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
      ** Midas SE Trade Details File
 
     FTRADSDY2  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      ** Midas SE Trade Extension File
 
     FDPTMVCHK  IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
      ** Midas SE Depot Movements
 
     FDPTMVDY3  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      ** Midas SE Depot Movements Extension File
 
     FPOSET2    IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
      ** Midas SE Position Settlement (Live)
 
     FPOSETDY2  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      ** Midas SE Position Settlement Extension File
 
     FSDWLCCL0  UF   E           K DISK    INFSR(*PSSR)
      ** Watch List Checking Details by Function Code
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
 
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
     `** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** WATCH LIST FIELDS's OPEN AND CLOSE TAGS
     D*Opentag**       S             35    CTDATA DIM(27) PERRCD(1)                           CSW210
     D*Clostag**       S             35    CTDATA DIM(27) PERRCD(1)                           CSW210
     D Opentag         S             35    CTDATA DIM(29) PERRCD(1)                           CSW210
     D Clostag         S             35    CTDATA DIM(29) PERRCD(1)                           CSW210
 
      ** Temporary Data Structur for Midas Compliance Watch
     D TEMPDS          DS          3000
 
      ** Data structure for data area SDSTAT
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for Functions for Watch List Checking
      ** Details File
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)
 
      ** Midas SD Watch List Configuration Data File
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Externally described DS for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data Structure used as parameters for the Compliance Engine
     D PDSWLTD       E DS                  EXTNAME(SDWLTDPD)
     D P_XML           DS         30000
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Watch List Checking Details by Function Code Key Field
     D KFuncCode       S              8A
 
      ** Rate Change Frequency passed to ZFREQB
     D  PZFREQ         S              1
 
      ** MIDAS day number
     D  PZDAYNO        S              5  0
 
      ** Currency code passed passed to ZFREQB
     D  PZCCY          S              3A
 
      ** Location code passed passed to ZFREQB                                              AR702741
     D  PZLOC          S              3A                                                    AR702741
                                                                                            AR702741
      ** Rate frequency day passed to ZFREQB
     D  PZMDAY         S              2  0
 
      ** Key Fields for SDCWHTL1
     D KFunt           S              8A
     D KIden           S             40A
     D KBrch           S              3A
 
      ** Parameter for AOBANKR0/AOSARDR0/AOCUSTR0/AOWLCCR0
     D PReturnCode     S              7
     D POption         S              7
     D PSard           S              6
     D PKey1           S             10A
     D PKyst           S              7A
     D PFuncCode       S              8    INZ('SECTTRAD')
 
      ** Parameter for AOCURRR0
     D PmRetn          S              7
     D PmOption        S              7
     D PmCcy           S              3
 
      ** Parameter for 'SDCWLFMT'
     D  PInput1        S             35A
     D  PInput2        S             35A
     D  PInput3        S             35A
     D  PInput4        S             35A
     D  PInput5        S             35A
     D  PInput6        S             35A
     D  PCurrency      S              3A
     D  POutput1       S            216A
     D  POutput2       S              6A
 
      ** Switchable Features
     D CSC011          S              1A
     D CCF001          S              1A
 
      ** Parameter for ZACVTDATE
     D PInDate         S              5A
     D POutDate        S               D
     D PCvtdDate       S             10A
 
      ** Parameter for ZACVTAMT
     D PCcy            S              3
     D PInAmt          S             15
     D POutAmt         S             18  3
     D PCvtdAmt        S             16
 
      ** Work Variables
     D @RUN            S              1
     D PDUDA           S              5
     D PCPYA           S              6
 
     D PRetCode        S              7A
     D PMsg            S            132A
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgQ           S             10A
     D PSrvContext     S               *
     D WDBASE          S              3  0
     D WDBNUM          S              3  0
 
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
 
      ** Open OFAC server
 
     C                   CALL      'SDOFACOP'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
      ** Error calling SDOFACOP
 
     C                   IF        PRetCode <> *BLANK
 
     C                   SELECT
 
     C                   WHEN      PRetCode = '*INIT  '
     C                   EVAL      WDBASE = 39
     C                   EVAL      PMsgId = 'USR9686'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*OPEN  '
     C                   EVAL      WDBASE = 40
     C                   EVAL      PMsgID = 'USR9687'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*NREADY'
     C                   EVAL      WDBASE = 41
     C                   EVAL      PMsgID = 'USR9688'
     C                   EXSR      SRSndErr
 
     C                   ENDSL
 
      ** Perform database error
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = WDBASE
     C                   EVAL      DBKEY = PRetCode
     C                   EVAL      DBFile = 'SDOFACOP'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        W1FUNC = 'SECTTRAD'
 
      ** When Periodic Watch List Checking Frequency is not equal to blanks and
      ** Next Periodic Check Date is less than or equal to run day number
 
     C                   IF        W1PFRQ <> *Blanks AND W1NPCD <= BJRDNB
 
      ** Process Trades Deatils File
 
     C                   EXSR      SrTrads
 
      ** Process Depot Movement Files
 
     C                   EXSR      SrDptmvd
 
      ** Process Position Settlements File (Live)
 
     C                   EXSR      SrPoset
                                                                                              221934
      ** Update Watch List Checking Details by Function Code                                  221934
                                                                                              221934
     C                   EXSR      SRUPDWLCC                                                  221934
 
     C                   ENDIF
 
     C                   ENDIF
 
      ***Update*Watch*List*Checking*Details*by*Function*Code*                                 221934
      *******************                                                                     221934
     C*******************EXSR      SRUPDWLCC                                                  221934
 
      ** Close connection with the server
 
     C                   CALL      'SDOFACCL'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
     C                   EVAL      *INLR = *ON
 
      ** Return to the calling program.
 
     C                   RETURN
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTrads - Process TRADSD                                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRWatch                                                *
      *                                                               *
      *****************************************************************
 
     C     SrTrads       BEGSR
 
      ** Open Trade Details File
 
     C                   OPEN      TRADS
     C                   OPEN      TRADSDY2
 
      ** For every live record read on TRADS, send details to Compliance Watch
      ** Engine by calling SDWLENGN
 
     C                   READ      TRADS
 
     C                   DOW       NOT %EOF (TRADS)
 
     C                   IF        RECI = 'D'
 
      ** Access record in PF/SDCWHTL0
 
     C                   MOVEL     'TRADSD '     KFunt
     C                   MOVEL     TDRF          KIden
     C                   MOVEL     TDBA          KBrch
 
     C     KCWHT         CHAIN     SDCWHTL0
 
      ** If record is not found
 
     C                   IF        NOT %FOUND(SDCWHTL0)
 
      ** If the last periodic check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W1LPCD < W1LUDT
 
     C                   EXSR      SRWtchTrad
 
     C                   ENDIF
 
      ** Else, record already exist
 
     C                   ELSE
 
      ** If the last watch list check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W3LWCD < W1LUDT
 
     C                   EXSR      SRWtchTrad
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      TRADS
 
     C                   ENDDO
 
      ** Close Trade Details File
 
     C                   CLOSE     TRADSDY2
     C                   CLOSE     TRADS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWtchTrad - Send Details to Compliance Watch Engine for      *
      *              Live record on TRADSD.                           *
      *                                                               *
      * Called by: SRTrads                                            *
      *                                                               *
      * Calls: SrEngine                                               *
      *                                                               *
      *****************************************************************
 
     C     SrWtchTrad    BEGSR
 
     C                   EVAL      DBPROC =  'SrWtchTrad'
 
      ** Set-up parameter for Compliance Engine Program
 
     C                   EXSR      SRInitParm
 
      ** 2nd Parameter
 
      ** Pay From
 
     C                   IF        PYFM <> *BLANKS
     C                   EVAL      PInput1 = PYFM
     C                   EVAL      PCurrency = SETC
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(1):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(1):0  P_XML
     C                   ENDIF
 
      ** Pay To
 
     C                   IF        PAYT <> *BLANKS
     C                   EVAL      PInput1 = PAYT
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(2):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(2):0  P_XML
     C                   ENDIF
 
      ** For Account of - Pay To
 
     C                   IF        TDFA <> *BLANKS
     C                   EVAL      PInput1 = TDFA
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(3):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(3):0  P_XML
     C                   ENDIF
 
      ** Deliver To
 
     C**********         IF        DELT <> *Zeros                                             CSD027
     C                   IF        DELT <> *Blanks                                            CSD027
     C                   MOVEL     DELT          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(4):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(4):0  P_XML
     C                   ENDIF
 
      ** or Account of - Deliver To
 
     C                   IF        DTFA <> *Blanks
     C                   EVAL      PInput1 = DTFA
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(5):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(5):0  P_XML
     C                   ENDIF
 
      ** Deliver From
 
     C**********         IF        DELF <> *Zeros                                             CSD027
     C                   IF        DELF <> *Blanks                                            CSD027
     C                   MOVEL     DELF          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(6):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(6):0  P_XML
     C                   ENDIF
 
      ** For Account of - Deliver From>
 
     C                   IF        DFFA <> *Blanks
     C                   EVAL      PInput1 = DFFA
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(7):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(7):0  P_XML
     C                   ENDIF
 
      ** Chain Extention File for other details
 
     C     TDRF          CHAIN     TRADSDY2
 
     C                   IF        %FOUND(TRADSDY2)
      ** MT510 A/C for Payment
 
     C                   IF        T2AP1N <> *Blanks
     C                   EVAL      PInput1 = T2AP1N
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(8):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(8):0  P_XML
     C                   ENDIF
 
      ** Account for Payment
 
     C                   IF        T2AFPN <> *Blanks
     C                   EVAL      PInput1 = T2AFPN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(9):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(9):0  P_XML
     C                   ENDIF
 
      ** A/C with Institution
 
     C                   IF        T2AWIN <> *Blanks
     C                   EVAL      PInput1 = T2AWIN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(10):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(10):0 P_XML
     C                   ENDIF
 
      ** Beneficiary
 
     C                   IF        T2BOFN <> *Blanks
     C                   EVAL      PInput1 = T2BOFN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(11):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(11):0 P_XML
     C                   ENDIF
 
      ** Instructing Party
 
     C                   IF        T2IPYN <> *Blanks
     C                   EVAL      PInput1 = T2IPYN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(12):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(12):0 P_XML
     C                   ENDIF
 
      ** Counterparty
 
     C                   IF        T2CTYN <> *Blanks
     C                   EVAL      PInput1 = T2CTYN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(13):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(13):0 P_XML
     C                   ENDIF
 
      ** MT510 Safekeeping A/C
 
     C                   IF        T2SA1N <> *Blanks
     C                   EVAL      PInput1 = T2SA1N
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(14):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(14):0 P_XML
     C                   ENDIF
 
      ** Safekeeping Account
 
     C                   IF        T2SKAN <> *Blanks
     C                   EVAL      PInput1 = T2SKAN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(15):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(15):0 P_XML
     C                   ENDIF
 
      ** Deliverer Instructing Party
 
     C                   IF        T2DCTL <> *Blanks
     C                   EVAL      PInput1 = T2DCTL
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(16):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(16):0 P_XML
     C                   ENDIF
 
      ** Receivers of Securties
 
     C                   IF        T2RSSN <> *Blanks
     C                   EVAL      PInput1 = T2RSSN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(17):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(17):0 P_XML
     C                   ENDIF
 
      ** Deliverers of Securities
 
     C                   IF        T2DSSN <> *Blanks
     C                   EVAL      PInput1 = T2DSSN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(18):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(18):0 P_XML
     C                   ENDIF
 
      ** Beneficiary of Securities
 
     C                   IF        T2BSSN <> *Blanks
     C                   EVAL      PInput1 = T2BSSN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(19):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(19):0 P_XML
     C                   ENDIF
 
      ** Investor
 
     C                   IF        T2INVE <> *Blanks
     C                   EVAL      PInput1 = T2INVE
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(20):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(20):0 P_XML
     C                   ENDIF
 
      ** Settlement Party Intermediary
 
     C                   EVAL      TempDS = *Blanks
 
     C                   IF        T2IMD1 <> *Blanks
     C                   EVAL      PInput1 = T2IMD1
     C                   EXSR      SrFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMD2 <> *Blanks
     C                   EVAL      PInput1 = T2IMD2
     C                   EXSR      SrFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMD3 <> *Blanks
     C                   EVAL      PInput1 = T2IMD3
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMD4 <> *Blanks
     C                   EVAL      PInput1 = T2IMD4
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMD5 <> *Blanks
     C                   EVAL      PInput1 = T2IMD5
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMD6 <> *Blanks
     C                   EVAL      PInput1 = T2IMD6
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMD7 <> *Blanks
     C                   EVAL      PInput1 = T2IMD7
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMD8 <> *Blanks
     C                   EVAL      PInput1 = T2IMD8
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMD9 <> *Blanks
     C                   EVAL      PInput1 = T2IMD9
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        TempDS <> *Blanks
     C     P_XML         CAT       OpenTag(21):0 P_XML
     C     P_XML         CAT       TempDS:0      P_XML
     C     P_XML         CAT       ClosTag(21):0 P_XML
     C                   ENDIF
 
 
      ** Safekeeping A/C Intermediary
 
     C                   EVAL      TempDS = *Blanks
 
     C                   IF        T2IMS1 <> *Blanks
     C                   EVAL      PInput1 = T2IMS1
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMS2 <> *Blanks
     C                   EVAL      PInput1 = T2IMS2
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMS3 <> *Blanks
     C                   EVAL      PInput1 = T2IMS3
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMS4 <> *Blanks
     C                   EVAL      PInput1 = T2IMS4
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMS5 <> *Blanks
     C                   EVAL      PInput1 = T2IMS5
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMS6 <> *Blanks
     C                   EVAL      PInput1 = T2IMS6
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMS7 <> *Blanks
     C                   EVAL      PInput1 = T2IMS7
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMS8 <> *Blanks
     C                   EVAL      PInput1 = T2IMS8
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        T2IMS9 <> *Blanks
     C                   EVAL      PInput1 = T2IMS9
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        TempDS <> *Blanks
     C     P_XML         CAT       OpenTag(22):0 P_XML
     C     P_XML         CAT       TempDS:0      P_XML
     C     P_XML         CAT       ClosTag(22):0 P_XML
     C                   ENDIF
 
      ** Debtor                                                                               CSW210
                                                                                              CSW210
     C                   IF        T2DIDN <> *BLANKS                                          CSW210
     C                   EVAL      PInput1 = T2DIDN                                           CSW210
     C                   EXSR      SrFormat                                                   CSW210
     C     P_XML         CAT       OpenTag(28):0 P_XML                                        CSW210
     C     P_XML         CAT       POutput1:0    P_XML                                        CSW210
     C     P_XML         CAT       ClosTag(28):0 P_XML                                        CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Qualified Foreign Intermediary                                                       CSW210
                                                                                              CSW210
     C                   IF        T2QFIN <> *BLANKS                                          CSW210
     C                   EVAL      PInput1 = T2QFIN                                           CSW210
     C                   EXSR      SrFormat                                                   CSW210
     C     P_XML         CAT       OpenTag(29):0 P_XML                                        CSW210
     C     P_XML         CAT       POutput1:0    P_XML                                        CSW210
     C     P_XML         CAT       ClosTag(29):0 P_XML                                        CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF
 
      ** First Parameter
 
     C                   IF        P_XML <> *BLANKS
 
      ** Identifier
 
     C                   EVAL      W4IDEN = TDRF
 
      ** Item Type Code
 
     C                   EVAL      W4ITEM = 'SETRAD'
 
      ** Branch
 
     C                   EVAL      W4BRCH = TDBA
 
      ** System
 
     C                   EVAL      W4SYSM = LIBR
 
      ** Function Type
 
     C                   EVAL      W4FUNT = 'TRADSD  '
 
      ** Counter Party Number
 
     C                   MOVEL     TCNR          W4CNUM
 
      ** Get Customer Detail
 
     C                   MOVEL     TCNR          PKey1
 
     C                   EXSR      SrCustDet
 
      ** If Customer detail not found, issue DB error.
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Counterparty Type
 
      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ELSE
 
      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.
 
     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Counter Party Name
 
     C     BBCRNM        CAT       BBCRTN        W4CUST
 
      ** Deal Date
 
     C                   MOVEL     TDDT          PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4DDAT = POutDate
 
      ** Value Date
 
     C                   MOVEL     TDVD          PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4VDAT = POutDate
 
      ** Maturity Date
 
     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4MDAT = POutDate
 
      ** Denomination Side 1
 
     C                   EVAL      W4DEN1 = TNMC
 
      ** Denomination Side 2
 
     C                   EVAL      W4DEN2 = *BLANKS
 
      ** Amount Side 1
 
      ** Access currency details to check if denomination is a valid ccy
 
     C                   EVAL      PmCcy = W4DEN1
 
     C                   EXSR      SrCurrDet
 
      ** Format Amount 1
 
     C                   IF        PmRetn = *BLANK
     C                   EVAL      PCcy = W4DEN1
     C                   ELSE
     C                   EVAL      PCcy = *BLANKS
     C                   ENDIF
 
     C                   MOVE      NOML          PInAmt
     C                   EXSR      SrCvtAmt
 
      ** DB Error Processing
 
     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4AMT1 = PoutAmt
 
      ** Amount Side 2 (W4AMT2)
 
     C                   EVAL      W4AMT2 = *ZERO
 
 
      ** Send Transaction Details to Compliance Watch by Calling the
      ** Engine Program.
 
     C                   EVAL      WDBNUM = 21
     C                   EXSR      SREngine
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDptmvd - Process DPTMVCHK                                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRWatch                                                *
      *                                                               *
      *****************************************************************
 
     C     SrDptmvd      BEGSR
 
      ** Open Depot Movements File
 
     C                   OPEN      DPTMVDY3
     C                   OPEN      DPTMVCHK
 
      ** For every live record read on DPTMVCHK, send details to Compliance Watch
      ** Engine by calling SDWLENGN
 
     C                   READ      DPTMVCHK
 
     C                   DOW       NOT %EOF (DPTMVCHK)
 
      ** Access record in PF/SDCWHTL0
 
     C                   MOVEL     'DPTMVD '     KFunt
     C                   MOVEL     DPRN          KIden
     C                   MOVEL     DPBA          KBrch
 
     C     KCWHT         CHAIN     SDCWHTL0
 
      ** If record is not found
 
     C                   IF        NOT %FOUND(SDCWHTL0)
 
      ** If the last periodic check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W1LPCD < W1LUDT
 
     C                   EXSR      SRWtchDptmvd
 
     C                   ENDIF
 
      ** Else, record already exist
 
     C                   ELSE
 
      ** If the last watch list check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W3LWCD < W1LUDT
 
     C                   EXSR      SRWtchDptmvd
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      DPTMVCHK
 
     C                   ENDDO
 
      ** Close Depot Movements File
 
     C                   CLOSE     DPTMVCHK
     C                   CLOSE     DPTMVDY3
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWtchDptmvd - Send Details to Compliance Watch Engine for    *
      *                Live record on DPTMVD.                         *
      *                                                               *
      * Called by: SRTrads                                            *
      *                                                               *
      * Calls: SrEngine                                               *
      *                                                               *
      *****************************************************************
 
     C     SrWtchDptmvd  BEGSR
 
     C                   EVAL      DBPROC =  'SrWtchDptmvd'
 
      ** Set-up parameter for Compliance Engine Program
 
     C                   EXSR      SRInitParm
 
      ** 2nd Parameter
 
      ** Depot In
 
     C**********         IF        DPID <> *Zeros                                             CSD027
     C                   IF        DPID <> *Blanks                                            CSD027
     C                   MOVEL     DPID          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(23):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(23):0 P_XML
     C                   ENDIF
 
      ** Depot Out
 
     C**********         IF        DPOD <> *Zeros                                             CSD027
     C                   IF        DPOD <> *Blanks                                            CSD027
     C                   MOVEL     DPOD          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(24):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(24):0 P_XML
     C                   ENDIF
 
      ** Chain Extention File for other details
 
     C     DPRN          CHAIN     DPTMVDY3
 
     C                   IF        %FOUND(DPTMVDY3)
 
      ** Account for Payment
 
     C                   IF        D2AFPN <> *Blanks
     C                   EVAL      PInput1 = D2AFPN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(9):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(9):0  P_XML
     C                   ENDIF
 
      ** A/C with Institution
 
     C                   IF        D2AWIN <> *Blanks
     C                   EVAL      PInput1 = D2AWIN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(10):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(10):0 P_XML
     C                   ENDIF
 
      ** Beneficiary
 
     C                   IF        D2BOFN <> *Blanks
     C                   EVAL      PInput1 = D2BOFN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(11):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(11):0 P_XML
     C                   ENDIF
 
      ** Instructing Party
 
     C                   IF        D2IPYN <> *Blanks
     C                   EVAL      PInput1 = D2IPYN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(12):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(12):0 P_XML
     C                   ENDIF
 
      ** Counterparty
 
     C                   IF        D2CTYN <> *Blanks
     C                   EVAL      PInput1 = D2CTYN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(13):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(13):0 P_XML
     C                   ENDIF
 
      ** Safekeeping Account
 
     C                   IF        D2SKAN <> *Blanks
     C                   EVAL      PInput1 = D2SKAN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(15):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(15):0 P_XML
     C                   ENDIF
 
      ** Deliverr Instrctg Prty
 
     C                   IF        D2DCTL <> *Blanks
     C                   EVAL      PInput1 = D2DCTL
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(16):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(16):0 P_XML
     C                   ENDIF
 
      ** Receivers of Securties
 
     C                   IF        D2RSSN <> *Blanks
     C                   EVAL      PInput1 = D2RSSN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(17):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(17):0 P_XML
     C                   ENDIF
 
      ** Deliverrs of Securties
 
     C                   IF        D2DSSN <> *Blanks
     C                   EVAL      PInput1 = D2DSSN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(18):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(18):0 P_XML
     C                   ENDIF
 
      ** Benfciary of Securties
 
     C                   IF        D2BSSN <> *Blanks
     C                   EVAL      PInput1 = D2BSSN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(19):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(19):0 P_XML
     C                   ENDIF
 
      ** Investor
 
     C                   IF        D2INVE <> *Blanks
     C                   EVAL      PInput1 = D2INVE
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(20):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(20):0 P_XML
     C                   ENDIF
 
      ** Sttlmnt Prty Intmdiary
 
     C                   EVAL      TempDS = *Blanks
 
     C                   IF        D2IMD1 <> *Blanks
     C                   EVAL      PInput1 = D2IMD1
     C                   EXSR      SrFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMD2 <> *Blanks
     C                   EVAL      PInput1 = D2IMD2
     C                   EXSR      SrFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMD3 <> *Blanks
     C                   EVAL      PInput1 = D2IMD3
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMD4 <> *Blanks
     C                   EVAL      PInput1 = D2IMD4
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMD5 <> *Blanks
     C                   EVAL      PInput1 = D2IMD5
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMD6 <> *Blanks
     C                   EVAL      PInput1 = D2IMD6
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMD7 <> *Blanks
     C                   EVAL      PInput1 = D2IMD7
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMD8 <> *Blanks
     C                   EVAL      PInput1 = D2IMD8
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMD9 <> *Blanks
     C                   EVAL      PInput1 = D2IMD9
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        TempDS <> *Blanks
     C     P_XML         CAT       OpenTag(21):0 P_XML
     C     P_XML         CAT       TempDS:0      P_XML
     C     P_XML         CAT       ClosTag(21):0 P_XML
     C                   ENDIF
 
      ** Safkeepg A/C Intmdiary
 
     C                   EVAL      TempDS = *Blanks
 
     C                   IF        D2IMS1 <> *Blanks
     C                   EVAL      PInput1 = D2IMS1
     C                   EXSR      SrFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMS2 <> *Blanks
     C                   EVAL      PInput1 = D2IMS2
     C                   EXSR      SrFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMS3 <> *Blanks
     C                   EVAL      PInput1 = D2IMS3
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMS4 <> *Blanks
     C                   EVAL      PInput1 = D2IMS4
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMS5 <> *Blanks
     C                   EVAL      PInput1 = D2IMS5
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMS6 <> *Blanks
     C                   EVAL      PInput1 = D2IMS6
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMS7 <> *Blanks
     C                   EVAL      PInput1 = D2IMS7
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMS8 <> *Blanks
     C                   EVAL      PInput1 = D2IMS8
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        D2IMS9 <> *Blanks
     C                   EVAL      PInput1 = D2IMS9
     C                   EXSR      SRFormat
     C                   CAT       POutput1:0    TempDS
     C                   ENDIF
 
     C                   IF        TempDS <> *Blanks
     C     P_XML         CAT       OpenTag(22):0 P_XML
     C     P_XML         CAT       TempDS:0      P_XML
     C     P_XML         CAT       ClosTag(22):0 P_XML
     C                   ENDIF
                                                                                              CSW210
      ** Debtor                                                                               CSW210
                                                                                              CSW210
     C                   IF        D2DIDN <> *Blanks                                          CSW210
     C                   EVAL      PInput1 = D2DIDN                                           CSW210
     C                   EXSR      SrFormat                                                   CSW210
     C     P_XML         CAT       OpenTag(28):0 P_XML                                        CSW210
     C     P_XML         CAT       POutput1:0    P_XML                                        CSW210
     C     P_XML         CAT       ClosTag(28):0 P_XML                                        CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Qualified Foreign Intermediary                                                       CSW210
                                                                                              CSW210
     C                   IF        D2QFIN <> *Blanks                                          CSW210
     C                   EVAL      PInput1 = D2QFIN                                           CSW210
     C                   EXSR      SrFormat                                                   CSW210
     C     P_XML         CAT       OpenTag(29):0 P_XML                                        CSW210
     C     P_XML         CAT       POutput1:0    P_XML                                        CSW210
     C     P_XML         CAT       ClosTag(29):0 P_XML                                        CSW210
     C                   ENDIF                                                                CSW210
 
     C                   ENDIF
 
      ** First Parameter
 
     C                   IF        P_XML <> *BLANKS
 
      ** Identifier
 
     C                   EVAL      W4IDEN = DPRN
 
      ** Item Type Code
 
     C                   IF        DPMV = 'WI'
     C                   EVAL      W4ITEM = 'SEWKIN'
     C                   ELSE
     C                   IF        DPMV = 'WO'
     C                   EVAL      W4ITEM = 'SEWKOT'
     C                   ELSE
     C                   EVAL      W4ITEM = 'SEDPOT'
     C                   ENDIF
     C                   ENDIF
 
      ** Branch
 
     C                   EVAL      W4BRCH = DPBA
 
      ** System
 
     C                   EVAL      W4SYSM = LIBR
 
      ** Function Type
 
     C                   EVAL      W4FUNT = 'DPTMVD  '
 
      ** Counter Party Number
 
     C                   MOVEL     DPBN          W4CNUM
 
      ** Get Customer Detail
 
     C                   MOVEL     DPBN          PKey1
 
     C                   EXSR      SrCustDet
 
      ** If Customer detail not found, issue DB error.
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  006
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Counterparty Type
 
      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ELSE
 
      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.
 
     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Counter Party Name
 
     C     BBCRNM        CAT       BBCRTN        W4CUST
 
      ** Deal Date
 
     C                   MOVEL     DMTD          PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  007
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4DDAT = POutDate
 
      ** Value Date
 
     C                   MOVEL     DPVD          PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  008
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4VDAT = POutDate
 
      ** Maturity Date
 
     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  009
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4MDAT = POutDate
 
      ** Denomination Side 1
 
     C                   EVAL      W4DEN1 = DPSS
 
      ** Denomination Side 2
 
     C                   EVAL      W4DEN2 = *BLANKS
 
      ** Amount Side 1
 
      ** Access currency details to check if denomination is a valid ccy
 
     C                   EVAL      PmCcy = W4DEN1
 
     C                   EXSR      SrCurrDet
 
      ** Format Amount 1
 
     C                   IF        PmRetn = *BLANK
     C                   EVAL      PCcy = W4DEN1
     C                   ELSE
     C                   EVAL      PCcy = *BLANKS
     C                   ENDIF
 
     C                   MOVE      DPNA          PInAmt
     C                   EXSR      SrCvtAmt
 
      ** DB Error Processing
 
     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  010
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4AMT1 = PoutAmt
 
      ** Amount Side 2 (W4AMT2)
 
     C                   EVAL      W4AMT2 = *ZERO
 
      ** Send Transaction Details to Compliance Watch by Calling the
      ** Engine Program.
 
     C                   EVAL      WDBNUM = 27
     C                   EXSR      SrEngine
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPoset - Process POSETD                                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRWatch                                                *
      *                                                               *
      *****************************************************************
 
     C     SrPoset       BEGSR
 
      ** Open Position Settlement File (Live)
 
     C                   OPEN      POSETDY2
     C                   OPEN      POSET2
 
      ** For every live record read on POSET2, send details to Compliance Watch
      ** Engine by calling SDWLENGN
 
     C                   READ      POSET2
 
     C                   DOW       NOT %EOF (POSET2)
 
      ** Access record in PF/SDCWHTL0
 
     C                   MOVEL     'POSETD '     KFunt
     C                   MOVEL     PCPY          PCPYA
     C                   MOVEL     PDUD          PDUDA
     C     PBCA          CAT       PSSH:0        KIden
     C     KIden         CAT       PCPYA:0       KIden
     C     KIden         CAT       PDUDA:0       KIden
     C     KIden         CAT       PEVT:0        KIden
     C                   MOVEL     PBCA          KBrch
 
     C     KCWHT         CHAIN     SDCWHTL0
 
      ** If record is not found
 
     C                   IF        NOT %FOUND(SDCWHTL0)
 
      ** If the last periodic check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W1LPCD < W1LUDT
 
     C                   EXSR      SRWtchPoset
 
     C                   ENDIF
 
      ** Else, record already exist
 
     C                   ELSE
 
      ** If the last watch list check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W3LWCD < W1LUDT
 
     C                   EXSR      SRWtchPoset
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      POSET2
 
     C                   ENDDO
 
      ** Close Position Settlements File (Live)
 
     C                   CLOSE     POSETDY2
     C                   CLOSE     POSET2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWtchPoset  - Send Details to Compliance Watch Engine for    *
      *                Live record on POSETD.                         *
      *                                                               *
      * Called by: SRTrads                                            *
      *                                                               *
      * Calls: SrEngine                                               *
      *                                                               *
      *****************************************************************
 
     C     SrWtchPoset   BEGSR
 
     C                   EVAL      DBPROC =  'SrWtchPoset '
 
      ** Set-up parameter for Compliance Engine Program
 
     C                   EXSR      SRInitParm
 
      ** 2nd Parameter
 
      ** Settlement account
 
     C                   IF        PSEA <> *Blanks
     C                   EVAL      PInput1 = PSEA
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(25):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(25):0 P_XML
     C                   ENDIF
 
      ** Counterparty bank
 
     C                   IF        PCPN <> *Blanks
     C                   EVAL      PInput1 = PCPN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(26):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(26):0 P_XML
     C                   ENDIF
 
      ** For account of
 
     C                   IF        PFAC <> *Blanks
     C                   EVAL      PInput1 = PFAC
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(27):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(27):0 P_XML
     C                   ENDIF
 
 
      ** Chain Extention File for other details
 
     C     PosetKey      CHAIN     POSETDY2
 
     C                   IF        %FOUND(POSETDY2)
 
      ** Account for Payment
 
     C                   IF        P2AFPN <> *Blanks
     C                   EVAL      PInput1 = P2AFPN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(9):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(9):0  P_XML
     C                   ENDIF
 
      ** Safekeeping Account
 
     C                   IF        P2SKAN <> *Blanks
     C                   EVAL      PInput1 = P2SKAN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(15):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(15):0 P_XML
     C                   ENDIF
 
      ** Deliverer of Securities
 
     C                   IF        P2DSSN <> *Blanks
     C                   EVAL      PInput1 = P2DSSN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(18):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(18):0 P_XML
     C                   ENDIF
 
 
     C                   ENDIF
 
      ** First Parameter
 
     C                   IF        P_XML <> *BLANKS
 
      ** Identifier
 
     C                   EVAL      W4IDEN = PBCA + PSSH +PCPYA + PDUDA + PEVT
 
      ** Item Type Code
 
     C                   EVAL      W4ITEM = 'POSETD'
 
      ** Branch
 
     C                   EVAL      W4BRCH = PBCA
 
      ** System
 
     C                   EVAL      W4SYSM = LIBR
 
      ** Function Type
 
     C                   EVAL      W4FUNT = 'POSETD  '
 
      ** Counter Party Number
 
     C                   MOVEL     PCPY          W4CNUM
 
      ** Get Customer Detail
 
     C                   MOVEL     PCPY          PKey1
 
     C                   EXSR      SrCustDet
 
      ** If Customer detail not found, issue DB error.
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  011
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Counterparty Type
 
      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ELSE
 
      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.
 
     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Counter Party Name
 
     C     BBCRNM        CAT       BBCRTN        W4CUST
 
      ** Deal Date
 
     C                   MOVEL     PDUD          PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  012
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4DDAT = POutDate
 
      ** Value Date
 
     C                   MOVEL     PSVL          PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  013
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4VDAT = POutDate
 
      ** Maturity Date
 
     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  014
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4MDAT = POutDate
 
      ** Denomination Side 1
 
     C                   EVAL      W4DEN1 = PNCY
 
      ** Denomination Side 2
 
     C                   EVAL      W4DEN2 = *BLANKS
 
      ** Amount Side 1
 
      ** Access currency details to check if denomination is a valid ccy
 
     C                   EVAL      PmCcy = W4DEN1
 
     C                   EXSR      SrCurrDet
 
      ** Format Amount 1
 
     C                   IF        PmRetn = *BLANK
     C                   EVAL      PCcy = W4DEN1
     C                   ELSE
     C                   EVAL      PCcy = *BLANKS
     C                   ENDIF
 
     C                   MOVE      PNMP          PInAmt
     C                   EXSR      SrCvtAmt
 
      ** DB Error Processing
 
     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  015
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4AMT1 = PoutAmt
 
      ** Amount Side 2 (W4AMT2)
 
     C                   EVAL      W4AMT2 = *ZERO
 
 
      ** Send Transaction Details to Compliance Watch by Calling the
      ** Engine Program.
 
     C                   EVAL      WDBNUM = 33
     C                   EXSR      SrEngine
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREngine - Calls Watch List Engine                            *
      *                                                               *
      * Called by: SrWtchTrad, SrDptMvd, SrPoset                      *
      *                                                               *
      * Calls: SDWLENGN                                               *
      *                                                               *
      *****************************************************************
 
     C     SrEngine      BEGSR
 
     C                   CALL      'SDWLENGN'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
     C                   PARM                    PDSWLTD
     C                   PARM                    P_XML
 
      ** Error calling SDWLENGN
 
     C                   IF        PRetCode <> *BLANK
     C                   SELECT
 
     C                   WHEN      PRetCode = '*ERROR '
     C                   EVAL      WDBASE = WDBNUM
 
     C                   WHEN      PRetCode = '*FOFEXE'
     C                   EVAL      WDBASE = WDBNUM + 1
     C                   EVAL      PMsgId = 'USR9680'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*SRVNAM'
     C                   EVAL      WDBASE = WDBNUM + 2
     C                   EVAL      PMsgId = 'USR9681'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*DBNAME'
     C                   EVAL      WDBASE = WDBNUM + 3
     C                   EVAL      PMsgId = 'USR9682'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*USRNAM'
     C                   EVAL      WDBASE = WDBNUM + 4
     C                   EVAL      PMsgId = 'USR9683'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*PASSWD'
     C                   EVAL      WDBASE = WDBNUM + 5
     C                   EVAL      PMsgId = 'USR9684'
     C                   EXSR      SRSndErr
 
     C                   OTHER
     C                   EVAL      PMsgId = 'USR9685'
     C                   EXSR      SRSndErr
     C                   ENDSL
 
      ** Perform database error either of the following return code is true
 
     C                   IF        PRetCode = '*ERROR ' OR
     C                             PRetCode = '*FOFEXE' OR
     C                             PRetCode = '*SRVNAM' OR
     C                             PRetCode = '*DBNAME' OR
     C                             PRetCode = '*USRNAM' OR
     C                             PRetCode = '*PASSWD'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = WDBASE
     C                   EVAL      DBKey = PDSWLTD
     C                   EVAL      DBFile = 'SDWLENGN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPDWLCC - Update Watch List Checking Details by Function    *
      *             Code                                              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRUPDWLCC     BEGSR
 
     C                   EVAL      KFuncCode = W1FUNC
 
     C     KFuncCode     CHAIN     SDWLCCL0
 
 
      ** Set Last Periodic Check Date = Run date
 
     C                   EVAL      W1LPCD = BJRDNB
 
      ** Determine Next Periodic Check Date
 
     C                   EVAL      PZFREQ = W1PFRQ
     C                   EVAL      PZDAYNO = W1NPCD
     C                   EVAL      PZCCY = BJLCCY
     C                   EVAL      PZMDAY = W1PDYN
 
     C                   CALLB     'ZFREQB'
     C                   PARM                    PReturnCode
     C                   PARM                    PZFREQ
     C                   PARM                    PZDAYNO
     C                   PARM                    PZCCY
     C                   PARM      *BLANKS       PZLOC                                      AR702741
     C                   PARM                    PZMDAY
     C                   PARM                    BJDFIN
     C     SDGELR        PARM                    SDGELR
 
     C                   EVAL      W1NPCD = PZDAYNO
 
     C                   UPDATE    SDWLCCD0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFormat   - Convert Settlement Details to Customer Name and  *
      *              Address                                          *
      *                                                               *
      * Called by: SrWtchTrad, SrWtchDptmvd, SrWtchPoset              *
      *                                                               *
      * Calls: SDCWLFMT                                               *
      *                                                               *
      *****************************************************************
 
     C     SrFormat      BEGSR
 
     C                   EVAL      DBPROC =  'SrFormat'
 
     C                   EVAL      POutput1 = *BLANKS
     C                   EVAL      POutput2 = *BLANKS
 
     C                   CALL      'SDCWLFMT'
     C                   PARM                    PReturnCode
     C                   PARM                    PInput1
     C                   PARM                    PInput2
     C                   PARM                    PInput3
     C                   PARM                    PInput4
     C                   PARM                    PInput5
     C                   PARM                    PInput6
     C                   PARM                    PCurrency
     C                   PARM                    POutput1
     C                   PARM                    POutput2
 
      ** Initialize to blanks the input parameters.
 
     C                   EVAL      PInput1 = *BLANKS
     C                   EVAL      PInput2 = *BLANKS
     C                   EVAL      PInput3 = *BLANKS
     C                   EVAL      PInput4 = *BLANKS
     C                   EVAL      PInput5 = *BLANKS
     C                   EVAL      PInput6 = *BLANKS
     C                   EVAL      PCurrency = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCurrDet - Retrieve Currency Details                         *
      *                                                               *
      * Called by: SrWtchTrad, SrWtchDptmvd, SrWtchPoset              *
      *                                                               *
      * Calls: AOCUSTR0                                               *
      *                                                               *
      *****************************************************************
     C     SrCurrDet     BEGSR
 
     C                   EVAL      DBPROC =  'SrCurrDet'
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PmRetn
     C                   PARM      '*KEY'        PmOption
     C                   PARM                    PmCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCustDet - Retrieve Customer Details                         *
      *                                                               *
      * Called by: SrWtchTrad, SrWtchDptmvd, SrWtchPoset              *
      *                                                               *
      * Calls: AOCUSTR0                                               *
      *                                                               *
      *****************************************************************
     C     SrCustDet     BEGSR
 
     C                   EVAL      DBPROC =  'SrCustDet'
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PKey1
     C                   PARM      *BLANK        PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCvtDate - Convert dates to be used for Watch Engine Program *
      *                                                               *
      * Called by: SrWtchTrad, SrWtchDptmvd, SrWtchPoset              *
      *                                                               *
      * Calls: ZaCvtDate                                              *
      *                                                               *
      *****************************************************************
     C     SrCvtDate     BegSr
 
     C                   EVAL      DBPROC =  'SrCvtDate'
 
     C                   CALL      'ZACVTDATE'
     C                   PARM      *Blanks       PReturncode
     C                   PARM                    PInDate
     C                   PARM                    POutDate
     C                   PARM                    PCvtdDate
 
     C                   Endsr
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCvtAmt - Convert amounts for Watch Engine Program           *
      *                                                               *
      * Called by: SrWtchTrad, SrWtchDptmvd, SrWtchPoset              *
      *                                                               *
      * Calls: ZaCvtAmt                                               *
      *                                                               *
      *****************************************************************
     C     SrCvtAmt      BegSr
 
     C                   EVAL      DBPROC =  'SrCvtAmt'
     C                   EVAL      POutAmt = *ZERO
     C                   EVAL      PCvtdAmt = *BLANKS
 
     C                   CALL      'ZACVTAMT'
     C                   PARM      *Blanks       ReturnCode
     C                   PARM                    PCcy
     C                   PARM                    PInAmt
     C                   PARM                    POutAmt
     C                   PARM                    PCvtdAmt
 
     C                   Endsr
      *********************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrInitParm - Initialize 1st and 2nd Parameters of Watch List  *
      *              Engine                                           *
      *                                                               *
      * Called by: SrWtchTrad, SrWtchDptmvd, SrWtchPoset              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrInitParm    BEGSR
 
     C                   EVAL      DBPROC =  'SrInitParm'
 
     C                   EVAL      W4IDEN = *BLANKS
     C                   EVAL      W4ITEM = *BLANKS
     C                   EVAL      W4BRCH = *BLANKS
     C                   EVAL      W4SYSM = *BLANKS
     C                   EVAL      W4FUNT = *BLANKS
     C                   EVAL      W4CNUM = *BLANKS
     C                   EVAL      W4CTYP = *BLANKS
     C                   EVAL      W4CUST = *BLANKS
     C                   EVAL      W4DEN1 = *BLANKS
     C                   EVAL      W4DEN2 = *BLANKS
     C                   EVAL      W4AMT1 = *ZERO
     C                   EVAL      W4AMT2 = *ZERO
     C                   EVAL      P_XML = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSndErr - Send error message to *SYSOPR                      *
      *                                                               *
      *****************************************************************
 
     C     SRSndErr      BEGSR
 
     C                   CALLB     'ZAMSGTOMSQ'
     C                   PARM                    RetCodeOut
     C                   PARM      'SD000014'    PMsg
     C                   PARM                    PMsgId
     C                   PARM      'GBSDUSRMSG'  PMsgF
     C                   PARM      'MOPERQ    '  PMsgQ
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   EVAL      DBPROC =  '*INZSR'
 
     C                   IN        SDSTAT
 
      **  Used for SDCWHTL1
 
     C     KCWHT         KLIST
     C                   KFLD                    KFunt
     C                   KFLD                    KIden
     C                   KFLD                    KBrch
 
     C     PosetKey      KLIST
     C                   KFLD                    PBCA
     C                   KFLD                    PSSH
     C                   KFLD                    PCPY
     C                   KFLD                    PDUD
     C                   KFLD                    PEVT
 
      ** Access bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PReturnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PReturnCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POption
     C                   EVAL      DBFile= 'SDBANKPD'
     C                   EVAL      DBase = 016
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve compliance watch configuration data file
 
     C                   CALLB     'AOCWCDR0'
     C                   PARM      *Blanks       PReturnCode
     C                   PARM      '*FIRST '     POption
     C     SDCWCD        PARM      SDCWCD        DSSDY
 
      ** Database error
 
     C                   IF        PReturnCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POption
     C                   EVAL      DBFile= 'SDCWCDPD'
     C                   EVAL      DBase = 017
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SAR Details to see if Concord Interface Development (CCF001)
      ** is installed.
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PReturnCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CCF001'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
 
     C                   IF        PReturnCode <> *Blanks AND
     C                             PReturnCode <> '*NRF    '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CCF001'
     C                   EVAL      DBASE = 018
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PReturnCode =  *Blanks
     C                   EVAL      CCF001 = 'Y'
     C                   ELSE
     C                   EVAL      CCF001 = 'N'
     C                   ENDIF
 
      ** Access SAR Details to see if 24x7 Midas Availability (CSC011)
      ** is installed.
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PReturnCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
 
     C                   IF        PReturnCode <> *Blanks AND
     C                             PReturnCode <> '*NRF    '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBASE = 019
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PReturnCode = *Blanks
     C                   EVAL      CSC011 = 'Y'
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
 
      ** Check if function code is being monitored by compliance watch.
 
     C                   CALLB     'AOWLCCR0'
     C                   PARM      *Blanks       PReturnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      'SECTTRAD'    PFuncCode
     C     SDWLCC        PARM      SDWLCC        DSFDY
 
     C                   IF        PReturnCode <> '*NRF    ' AND
     C                             PReturnCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDWLCCPD'
     C                   EVAL      DBASE = 020
     C                   EVAL      DBKEY = PFuncCode
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
      ** Close connection with the server
 
     C                   CALL      'SDOFACCL'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
** Opentag - Open tags for XML
<Pay From>
<Pay To>
<For Account of - Pay To>
<Deliver To>
<For Account of - Deliver To>
<Deliver From>
<For Account of - Deliver From>
<MT510 A/C for Payment>
<Account for Payment>
<A/C with Institution>
<Beneficiary>
<Instructing Party>
<Counterparty>
<MT510 Safekeeping A/C>
<Safekeeping Account>
<Deliverer Instructing Party>
<Receivers of Securities>
<Deliverers of Securities>
<Beneficiary of Securities>
<Investor>
<Settlement Party Intermediary>
<Safekeeping A/C Intermediary>
<Depot In>
<Depot Out>
<Settlement account>
<Counterparty bank>
<For account of>
<Debtor>                                                                                      CSW210
<Qualified Foreign Intermediary                                                               CSW210
** Closetag - Close tags for XML
</Pay From>
</Pay To>
</For Account of - Pay To>
</Deliver To>
</For Account of - Deliver To>
</Deliver From>
</For Account of - Deliver From>
</MT510 A/C for Payment>
</Account for Payment>
</A/C with Institution>
</Beneficiary>
</Instructing Party>
</Counterparty>
</MT510 Safekeeping A/C>
</Safekeeping Account>
</Deliverer Instructing Party>
</Receivers of Securities>
</Deliverers of Securities>
</Beneficiary of Securities>
</Investor>
</Settlement Party Intermediary>
</Safekeeping A/C Intermediary>
</Depot In>
</Depot Out>
</Settlement account>
</Counterparty bank>
</For account of>
</Debtor>                                                                                     CSW210
</Qualified Foreign Intermediary                                                              CSW210
