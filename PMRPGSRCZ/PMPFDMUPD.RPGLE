     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBI *: OVRDBF FILE(SDPBDSLR) TOFILE(SDPBDSL0) SHARE(*NO)          : *         CPB002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio definitions database update 2')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDMUPD - Portfolio Definition Details Database Update     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 218080             Date 16May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 20Nov01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 175680             Date 08Mar00               *
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  218080 - To avoid lock problems during DBU_CUSD and DBU_PFDM *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CPK014 - Release 4 Packaging -                               *
      *         - Change CALLB's to simple CALL's to prevent module   *
      *           being bound in                                      *
      *  175680 - PB Customer Maintenance - Fields protection         *
      *  CPB002 - New Private Banking Customer Processing.            *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FPMPORTPD  UF A E           K DISK
      ** Portfolio Definition Details file
     F                                     COMMIT
      *
     FPMPORTPA  UF   E             DISK
      ** Portfolio Definition Details file - Audit
     F                                     COMMIT
      *
     FSDPLCSL1  UF   E           K DISK
      ** Portfolio Management Customer Details file
     F                                     COMMIT
      *                                                                         CPB002
     FSDPBDSLR  UF   E           K DISK                                         CPB002
      ** Customer Private Banking Details file                                  CPB002
     F                                     COMMIT                               CPB002
      *                                                                         CPB002
     FSDCUSTL0  UF   E           K DISK                                         CPB002
      ** Customer Details Update file                                           CPB002
     F                                     COMMIT                               CPB002
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D PMVPFD        E DS                  EXTNAME(PMVPFDMPD)
      ** Externally described data structure for Valid Portfolio Defns.
     D  WDKEY                 22     31
      *
     D PMPORT        E DS                  EXTNAME(PMPORTPD)
      ** Externally described data structure for Portfolio Defn. file
      *
     D ChkPortFmt    E DS                  EXTNAME(PMPORTPD)
      ** Rename fields for Timestamp checking
     D                                     PREFIX(CH)
      *
     D PMEPFD        E DS                  EXTNAME(PMEPFDMPD)
      ** Error indicators
      *
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
      ** Midas API Message Header Format Definition                                           CSC011
                                                                                              CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
      ** External DS for Switchable Features                                                  CSC011
                                                                                              CSC011
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC011
      ** First DS for Access Programs, Short Data Structure                                   CSC011
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Timestamp for the transaction
     D PTimeStamp      S               Z
      *                                                                         CPB002
      ** Work field used to start defaulting processing.                        CPB002
     D WPB1030         S              1A                                        CPB002
      *                                                                         CPB002
      **----------- Start of parameters passed to PB1030 ------------**         CPB002
      ** Return Code.                                                           CPB002
     D PReturnCode     S             10A                                        CPB002
      ** Customer Number.                                                       CPB002
     D PCustNum        S              6A                                        CPB002
      ** Portfolio Definition Reference.                                        CPB002
     D PPortDfn        S              4A                                        CPB002
      ** Portfolio Currency Code.                                               CPB002
     D PPortCcy        S              3A                                        CPB002
      ** Portfolio Currency Decimal Places.                                     CPB002
     D PPortCdp        S              1  0                                      CPB002
      **------------ End of parameters passed to PB1030 -------------**         CPB002
      *
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
      *
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
                                                                                CPB002
      ** Override Database Table                                                CPB002
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)            CPB002
      *
                                                                                              CSC011
      ** Defined fields for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D Timestamp       S             26A                                                      CSC011
     D PRetCd          S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D PDealNum        S             18A                                                      CSC011
     D PADealNum       S             18A                                                      CSC011
     D WCust           S              6A                                                      CSC011
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
      *
     C                   EXSR      SRChkOthUpd
      *
     C     PRTCD         IFEQ      *BLANKS
 
      *
      ** Only process transactions with change type equal to
      ** insert (I), amend (A) or close (C).
     C     P1PNCHTP      IFEQ      'I'
     C                   EXSR      SRInsert
     C                   ELSE
     C     P1PNCHTP      IFEQ      'A'
     C     P1PNCHTP      OREQ      'C'
     C                   EXSR      SRAmend
     C                   ENDIF
     C                   ENDIF
      *
      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   CALLB     'PMPFDMLOG'                                                CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    PMVPFD                                       CSC011
     C                   PARM      P1PNCHTP      PACTN                                        CSC011
     C                   PARM                    PMCUST                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If there is no error, write the log file                                             CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *Blanks                                       CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'PMPFDM'                                       CSC011
     C                   EVAL      APFOTRANID = P1PNFRNT                                      CSC011
     C                   EVAL      APRPRLOCN  = P1PNREPA                                      CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
                                                                                              CSC011
     C                   MOVEL     P1PNCNUM      WCust                                        CSC011
     C                   EVAL      PDealNum = WCust + PNPTFR + PNPTCY                         CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *Blanks       Timestamp                                    CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM                    PADealNum                                    CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C                   EVAL      PRTCD = '*ERROR'                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
      *
      ** Exit to program.
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsert - Insert a Portfolio Definition Record              *
      *                                                               *
      *****************************************************************
     C     SRInsert      BEGSR
      *                                                                         CPB002
      ** If Private Banking Module is installed.                                CPB002
     C     BGN4ST        IFEQ      'Y'                                          CPB002
      *                                                                         CPB002
      ** Initialize working flag used to start defaulting processing.           CPB002
     C                   EVAL      WPB1030 = 'N'                                CPB002
      *                                                                         CPB002
      ** Access Customer Private Banking Details.                               CPB002
     C*****P1PNCNUM      CHAIN     SDPBDSLR                           01        CPB002 218080
     C     P1PNCNUM      CHAIN(N)  SDPBDSLR                           01        218080
      *                                                                         CPB002
      ** If record was not found, handle database error.                        CPB002
     C     *IN01         IFEQ      *ON                                          CPB002
     C                   MOVEL(P)  P1PNCNUM      DBKEY                          CPB002
     C                   MOVEL(P)  'SDPLCSPD'    DBFILE                         CPB002
     C                   Z-ADD     002           DBASE                          CPB002
     C                   EXSR      SRERR                                        CPB002
     C                   ENDIF                                                  CPB002
      *                                                                         CPB002
      ** If PB Requested Flag was set to 'Y', access to Portfolio               CPB002
      ** Definition Details to check if a Portfolio Definition                  CPB002
      ** already exists for this customer.                                      CPB002
     C     PBREPB        IFEQ      'Y'                                          CPB002
     C     P1PNCNUM      SETLL     PMPORTPD                               01    CPB002
      *                                                                         CPB002
      ** If no Portfolio Definition was found, that means current               CPB002
      ** one is the first to be opened for this customer.                       CPB002
      ** So, defaulting processing has to be run.                               CPB002
     C     *IN01         IFEQ      *OFF                                         CPB002
     C                   EVAL      WPB1030 = 'Y'                                CPB002
      *                                                                         CPB002
     C                   ENDIF                                                  CPB002
      *                                                                         CPB002
     C                   ENDIF                                                  CPB002
      *                                                                         CPB002
     C                   ENDIF                                                  CPB002
      *
     C     KPMDF         CHAIN     PMPORTPD                           01
      *
     C     *IN01         IFEQ      *OFF
     C                   MOVEL(P)  WDKEY         DBKEY
     C                   MOVEL(P)  'PMPORTPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimeStamp
      *
     C                   EVAL      P1PNTMST = PTimeStamp
      *
      ** Move valid file details to update file details.
     C                   MOVEL     PMVPFD        PMPORT
      *                                                                         CPB002
     C     PNMGTP        IFEQ      *ZEROS                                       CPB002
     C                   Z-ADD     1             PNMGTP                         CPB002
     C                   ENDIF                                                  CPB002
      *                                                                         CPB002
     C     PNINTP        IFEQ      *ZEROS                                       CPB002
     C                   Z-ADD     1             PNINTP                         CPB002
     C                   ENDIF                                                  CPB002
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        PNFRNT = *BLANKS                                           CSC011
     C                   MOVE      PNCNUM        WCust                                        CSC011
     C                   EVAL      PNFRNT = 'MD' + WCust + PNPTFR +                           CSC011
     C                                      PNPTCY                                            CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      *
     C                   WRITE     PMPORTP0
      *
      ** Update Portfolio Definitions audit record.
     C     1             CHAIN     PMPORTPA                           01
      *
     C     *IN01         IFEQ      *OFF
     C                   ADD       1             PNNORE
     C                   UPDATE    PMPORTZ0
     C                   ELSE
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL(P)  'PMPORTPA'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Do further update for PM Customer if necessary.
      *
     C     PMCUST        IFEQ      'Y'
      *
      ** If currency written to PF/PMPORTPD is different from customer
      ** base currency, update difference indicator on SDPLCSL1.
      *
     C     P1PNPTCY      IFNE      QBCSBY
      *
     C                   MOVE      P1PNCNUM      WCNUM             6
     C     WCNUM         CHAIN     SDPLCSL1                           01
      *
     C     *IN01         IFEQ      *ON
     C                   MOVEL(P)  P1PNCNUM      DBKEY
     C                   MOVEL(P)  'SDPLCSPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVE      'N'           QBAPBC
      *
     C                   UPDATE    @PLCSL1
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                         CPB002
      ** If Private Banking Module is installed.                                CPB002
     C     BGN4ST        IFEQ      'Y'                                          CPB002
      *                                                                         CPB002
      ** If defaulting processing has to be run.                                CPB002
     C     WPB1030       IFEQ      'Y'                                          CPB002
      *                                                                         CPB002
     C                   MOVE      PNCNUM        PCustNum                       CPB002
     C************       CALLB     'PB1030'                                     CPB002        CPK014
     C                   CALL      'PB1030'                                                   CPK014
     C                   PARM      *BLANKS       PReturnCode                    CPB002
     C                   PARM                    PCustNum                       CPB002
     C                   PARM      PNPTFR        PPortDfn                       CPB002
     C                   PARM      PNPTCY        PPortCcy                       CPB002
     C                   PARM      PNPCDP        PPortCdp                       CPB002
      *                                                                         CPB002
      ** If any error occurred while running defaulting processing.             CPB002
     C     PReturnCode   IFNE      *BLANKS                                      CPB002
     C                   EXSR      SRERR                                        CPB002
      *                                                                         CPB002
     C                   ENDIF                                                  CPB002
      *                                                                         CPB002
      ** Access to Customer Details to:                                         CPB002
      **        - Set "PB Customer" flag to 'Y'                                 CPB002
     C                   MOVE      P1PNCNUM      WCNUM                          CPB002
     C     WCNUM         CHAIN     SDCUSTL0                           01        CPB002
      *                                                                         CPB002
      **  If record was not found, handle database error.                       CPB002
     C     *IN01         IFEQ      *ON                                          CPB002
     C                   MOVEL(P)  P1PNCNUM      DBKEY                          CPB002
     C                   MOVEL(P)  'SDCUSTPD'    DBFILE                         CPB002
     C                   Z-ADD     003           DBASE                          CPB002
     C                   EXSR      SRERR                                        CPB002
      *                                                                         CPB002
     C                   ENDIF                                                  CPB002
      *                                                                         CPB002
     C                   EVAL      BBPRBA = 'Y'                                 CPB002
      *                                                                         CPB002
      ** Update Customer Details record.                                        CPB002
     C                   UPDATE    @BBREBG                                      CPB002
      *                                                                         218080
      ** Access Customer Private Banking Details.                               218080
     C     P1PNCNUM      CHAIN     SDPBDSLR                           01        218080
      *                                                                         CPB002
      ** Set "Requested PB Customer" flag to 'N'.                               CPB002
     C                   EVAL      PBREPB = 'N'                                 CPB002
      *                                                                         CPB002
      ** Set "PB Start Date" to Midas Run Date.                                 CPB002
     C                   EVAL      PBPBST = P1PNLCD                             CPB002
      *                                                                         CPB002
      ** Update Customer Private Banking Details record.                        CPB002
     C                   UPDATE    SDPBDSD0                                     CPB002
      *                                                                         CPB002
     C                   ENDIF                                                  CPB002
      *                                                                         CPB002
     C                   ENDIF                                                  CPB002
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmend - Amend/Close a Portfolio Definition Record          *
      *                                                               *
      *****************************************************************
     C     SRAmend       BEGSR
      *
     C     KPMDF         CHAIN     PMPORTPD                           01
      *
     C     *IN01         IFEQ      *OFF
      *
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimeStamp
      *
     C                   EVAL      P1PNTMST = PTimeStamp
      *
      ** Retain original Last Change Type if action code is Amend
      ** and original Last Change Date is equal to the Last
      ** Change Date in the valid records file (that is, equal
      ** to rundate).
     C     P1PNCHTP      IFEQ      'A'
     C     PNLCD         ANDEQ     P1PNLCD
     C                   EVAL      P1PNCHTP = PNCHTP
     C                   ENDIF
      *
      ** If Action code is 'C' (Closure) and Date Portfolio Closed is
      ** equal to zero, then last changed type is 'A' (Amend).
     C     P1PNCHTP      IFEQ      'C'
     C     P1PNDPCL      ANDEQ     *ZERO
     C                   EVAL      P1PNCHTP = 'A'
     C                   ENDIF
      *
      ** Move valid file details to update file details.
     C                   MOVEL     PMVPFD        PMPORT
     C                   UPDATE    PMPORTP0
      *
      ** Error if record is not found (*IN01 = *ON).
     C                   ELSE
     C                   MOVEL(P)  WDKEY         DBKEY
     C                   MOVEL(P)  'PMPORTPD'    DBFILE
     C                   Z-ADD     004           DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkOthUpd - Check for update by another workstation        *
      *                                                               *
      *****************************************************************
     C     SRChkOthUpd   BEGSR
      *
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive).
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PReturn           6
     C                   PARM                    Ptype             1
      *
      ** If Insert, set retrieve mode to '*FRONT' (Access using Front Office
      ** Id).  Otherwise, set retrieve mode to blank  (Access using Midas
      ** transaction Id).
      *
     C**** P1PNCHTP      IFNE      'I'                                          175680
     C****               MOVEL     '1'           PTYPE                          175680
     C****               ENDIF                                                  175680
      *
     C     PType         IFEQ      '0'
     C     P1PNCHTP      IFEQ      'I'                                          175680
     C                   MOVE      '*FRONT'      PMODE
     C                   ELSE                                                   175680
     C                   MOVE      *BLANKS       PMODE                          175680
     C                   ENDIF                                                  175680
     C                   ELSE
     C                   MOVE      *BLANKS       PMODE
     C                   ENDIF
      *
     C                   MOVEL     P1PNCNUM      PCNUM
      *
     C                   CALLB     'PMPFDM2RV'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** MODE = '      ' (Not Front Office Transaction Interface)
     C                   PARM                    PMODE             6
      *
      ** Response mode
     C                   PARM      ' '           PRESP             1
      *
      ** Action Code
     C                   PARM      P1PNCHTP      PACTN             1
      *
      ** Front Office Transaction ID
     C                   PARM      P1PNFRNT      PFOTRID          20
      *
      ** Portfolio Reference
     C                   PARM      P1PNPTFR      PREF              4
      *
      ** Customer Number
     C                   PARM                    PCNUM            10
      *
      ** REVIEW FROM key fields to position browse display in
      ** Screen Input function - not used in this function
     C                   PARM                    PREVIEW          10
      *
      ** STANDING DATA
      ** =============
      *
      ** SDPORT - Portfolios Supported
     C                   PARM                    FCPORS
      *
      ** SDBANK - Single Branch Code (not applicable)
     C                   PARM      *BLANKS       PSBRC             3
      *
      ** SDMMOD - Portfolio Management
     C                   PARM                    BGPFMG
      *
      ** OUTPUT
      ** ======
      *
      ** Original Portfolio Definition Details in file format
     C                   PARM                    ChkPortFmt
      *
      ** OK - Action code
     C                   PARM      *BLANK        OKACTN
      *
      ** OK - Portfolio reference
     C                   PARM      *BLANK        OKPREF
      *
      ** OK - Customer number
     C                   PARM      *BLANK        OKCSNM
      *
      ** OK - REVIEW FROM (not used in this function)
     C                   PARM                    POKREVIEW         1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx               3 0
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM                    QBCSBY
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST            1
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD            3
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    BBACOC            2
      *
      ** Error if Timestamp is not the same (record has been changed
      ** by another workstation).
      *
      ** Processing varies according to mode program is running in.
      ** In interacive mode, simply check whether the timestamp field
      ** has been updated since the original Portfolio Definition
      ** was fetched by this program.
      ** In batch (API input), check return parameters from Retrieve
      ** module for errors, and send message to system operator.
      *
      ** Interactive mode:
     C     PTYPE         IFEQ      '1'
 
     C     CHPNTMST      IFNE      P1PNTMST
     C                   MOVEL     '*RECUPD'     PRTCD
     C                   ENDIF
      *
      ** Batch mode:
     C                   ELSE
     C     OKACTN        IFEQ      'N'
     C     OKPREF        OREQ      'N'
     C     OKCSNM        OREQ      'N'
     C                   MOVEL     '*RECUPD'     PRTCD
     C                   Z-ADD     1             Wc                2 0
      *
     C     Wc            DOWLE     ArrayMax
     C     FldNameArr(Wc)ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       PDBError         28
     C                   MOVEL     MsgIDArr(Wc)  PDBError
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn       10
     C                   PARM                    PDBError
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
     C                   ADD       1             Wc
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Return code
     C                   PARM                    PRTCD             7
      *
      ** Valid Portfolio Definition Details
     C                   PARM                    PMVPFD
      *
      ** STANDING DATA
      ** =============
      *
      ** SDPORT - Portfolios Supported
     C                   PARM                    FCPORS            1
      *
      ** SDMMOD - Portfolio Management
     C                   PARM                    BGPFMG            1
      *                                                                         CPB002
      ** SDMMOD - Private Banking                                               CPB002
     C                   PARM                    BGN4ST            1            CPB002
      *
      ** Define key list for PMPORTPD.
     C     KPMDF         KLIST
     C                   KFLD                    P1PNCNUM
     C                   KFLD                    P1PNPTFR
      *                                                                         CPB002
     C* Overrride SDPBDSLR                                                      CPB002
     C                   Z-ADD     50            MESLEN           15 5          CPB002
     C                   CALL      'QCMDEXC'                                    CPB002
     C                   PARM                    ##OX1                          CPB002
     C                   PARM                    MESLEN                         CPB002
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRetCd                                       CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRetCd = *Blanks                                           CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRetCd <> '*NRF'                                           CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 5                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRERR - Routine for Exception Errors                         *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     '*ERROR '     PRTCD
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   DUMP
      *
      ** Terminate program.
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
** ##OX1
OVRDBF FILE(SDPBDSLR) TOFILE(SDPBDSL0) SHARE(*NO)
