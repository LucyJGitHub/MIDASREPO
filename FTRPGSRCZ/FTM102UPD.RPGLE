     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Update CCT header, details and trailer')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM102UPD - Customer Credit Transfer Database Update         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BUG24998           Date 17Jul09               *
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207B            Date 07Aug07               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CRE020             Date 20Jan04               *
      *                 CSC022             Date 24Feb04               *
      *                 CAP084             Date 25Jun03               *
      *                 220004             Date 24Jul03               *
      *                 213053             Date 14Oct02               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185660             Date 31Oct00               *
      *                 185107             Date 17Oct00               *
      *                 184191             Date 02Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178751             Date 09May00               *
      *                 178384             Date 02May00               *
      *                 178186             Date 25Apr00               *
      *                 177973             Date 18Apr00               *
      *                 177866             Date 17Apr00               *
      *                 177809             Date 14Apr00               *
      *                 177677             Date 12Apr00               *
      *                 177673             Date 12Apr00               *
      *                 177676             Date 12Apr00               *
      *                 CFT006  *CREATE    Date 14Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207B - Swift 2007 Changes                                 *
      *  CSW207 - Swift 2007 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  213053 - Remove unnecessary declaration of new fields        *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  185660 - When routing using ?,all message parts should be    *
      *         - processed                                           *
      *  185107 - Mapping of details from swift message                    *
      *  184191 - Incorrect commit.                                        *
      *  184060 - No transaction type code in detail screen - Recompile    *
      *  178751 - Auto generation of references                            *
      *  178384 - Use the correct date in UPDDTE and convert to Midas      *
      *           day number moving it in this field                       *
      *  178186 - Remove duplicated commit                                 *
      *  177973 - Refine error message RFU0004                             *
      *  177866 - Incorrect statements in FT0310P1                         *
      *  177809 - Link again deleted transaction to an existing one        *
      *  177677 - '08' is missing in the transaction number when           *
      *           this program is called by STP                            *
      *  177673 - Update the message status correctly when a credit        *
      *           get reassigned                                           *
      *  177676 - Correct decimal data error when we delete a CCT          *
      *           linked with a incoming SWIFT MT102                       *
      *  CFT006 - Swift Messages MT101/MT102                               *
      *                                                                    *
      **********************************************************************
      *                                                                    *
      * ID F  C  H  L    FUNCTION OF INDICATORS                            *
      *                                                                    *
      * 48 - Record found / not found for SDCWHTL1                         *                  CSD015
      * 49 - Record found / not found for FT102DL2                         *                  CSD015
      * 50 - Record found / not found for FT102HL2                         *                  CSD015
      * 90 - Record found / not found                                      *
      * 91 - Record locked                                                 *
      **********************************************************************
      * SUBROUTINE INDEX                                                   *
      *                                                                    *
      * *INZSR (for first call)                                            *
      * SrIni - INITIALIZE                                                 *
      * SrIns - INSERT A CCT PAYMENT                                       *
      * SrAmd - AMEND A CCT PAYMENT                                        *
      * SrAmdX - AUTHORISE A PAYMENT                                       *
      * SrDel - DELETE A CCT PAYMENT                                       *
      * SrReass - REASSIGN A CCT PAYMENT                                   *
      * SrIH - INSERT : HEADER SIDE ONLY                                   *
      * SrIHD - INSERT : HEADER/DETAIL BOTH                                *
      * SrID - INSERT : DETAIL SIDE ONLY                                   *
      * SrAH - AMEND : HEADER SIDE ONLY                                    *
      * SrAHD - AMEND : HEADER/DETAIL BOTH                                 *
      * SrAD - AMEND : DETAIL SIDE ONLY                                    *
      * SrDH - DELETE : HEADER SIDE ONLY                                   *
      * SrDHD - DELETE : HEADER/DETAIL BOTH                                *
      * SrDD - DELETE : DETAIL SIDE ONLY                                   *
      * HdrNfnd - CHECK HEADER NOT FOUND                                   *
      * DtlNfnd - CHECK DETAIL NOT FOUND                                   *
      * SrMapH - MAP FIELDS OF THE HEADER RECORD                           *
      * SrMapD - MAP FIELDS OF THE DETAIL RECORD                           *
      * RtvHdr - RETRIEVE HEADER                                           *
      * RtvHdr2 - RETRIEVE HEADER                                          *
      * RtvDtl - RETRIEVE DETAIL                                           *
      * RtvDtl2 - RETRIEVE DETAIL                                          *
      * RtvSeq - RETRIEVE SEQUENCE NUMBER                                  *    178751
      * WriteH - WRITE HEADER RECORD                                       *
      * WriteD - WRITE DETAIL RECORD                                       *
      * WriteT - WRITE TRAILER RECORD                                      *
      * UpdateH - UPDATE HEADER RECORD                                     *
      * UpdateD - UPDATE DETAIL RECORD                                     *
      * UpdateT - UPDATE TRAILER RECORD                                    *
      * SrFtst - UPDATE INCOMING MESSAGE FT TRANSACTION STATUS             *
      * RlsMsg - DELETE MESSAGE RESERVED                                   *
      * Sr1stParm - Setup first parameter for Compliance Engine Pgm   *                       CSD015
      * Sr2ndHParm - Setup 2nd header parm for Compliance Engine Pgm  *                       CSD015
      * Sr2ndDParm - Setup 2nd detail parm for Compliance Engine Pgm  *                       CSD015
      * Sr2ndH2Parm - Setup 2nd header parm for Compliance Engine Pgm *                       CSD015
      * Sr2ndD2Parm - Setup 2nd detail parm for Compliance Engine Pgm *                       CSD015
      * SrCallWatch - Send transaction details to Compliance Watch    *                       CSD015
      * SrConvrt - Convert Customer to Customer Name and Address      *                       CSD015
      * SrGetCntrPty - Get Report Name of Counterparty                *                       CSD015
      * SrCvtDate - Convert dates to be used for Watch Engine Program *                       CSD015
      * SrCvtAmt - Convert amountst for Watch Engine Program          *                       CSD015
      **********************************************************************
      /EJECT
      * CCT header
     FFT102HL7  UF A E           K DISK    COMMIT
     F                                     RENAME(FT102HD0:FT102HD7)
     FFT102HL3  UF   E           K DISK    COMMIT
      * CCT details
     FFT102DL0  UF A E           K DISK    COMMIT
                                                                                              CSD015
     FSDCWHTL1  IF   E           K DISK                                                       CSD015
      ** Compliance Watch Hit List File                                                       CSD015
                                                                                              CSD015
     FFT102DL2  IF A E           K DISK    RENAME(FT102DD0:FT102DD2)                          CSD015
     F                                     PREFIX(PD_)                                        CSD015
      * RFT details                                                                           CSD015
                                                                                              CSD015
     FFT102HLA  IF A E           K DISK    RENAME(FT102HD0:FT102HD2)                          CSD015
     F                                     PREFIX(PH_)                                        CSD015
      * RFT header                                                                            CSD015
                                                                                              CSD015
     FREADVCL1  UF A E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
      ** MIDAS RE Settled Transaction Index file                                              CRE020
                                                                                              CRE020
     F/COPY WNCPYSRC,FTM102UF01
      *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
     D/COPY MECPYSRC,ME1100_ILE
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Array of subroutines stack
     D SrStack         S             15    DIM(30)
 
      ** Message reference (ME1070 parameter)                                   185660
     D W0MSGREF        S              8P 0                                      185660
                                                                                185660
      ** Message part (ME1070 parameter)                                        185660
     D W0MSGPRT        S              3P 0                                      185660
 
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HPD) PREFIX(SH_)
     D DtlRcdIn      E DS                  EXTNAME(FT102DPD) PREFIX(SD_)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D q               S              2  0
 
      ** Timestamp for the tranaction
     D Timestamp       S               Z
 
      * External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Fisrt DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for MT101 MT102 control file
     D MEIRFT        E DS                  EXTNAME(MEIRFTPD) PREFIX(CK_)
 
      ** External DS for message status
     D MEINFT        E DS                  EXTNAME(MEINFTPD)
                                                                                              CSD015
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD015
      ** External DS for SAR Details                                                          CSD015
                                                                                              CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
      ** Midas Functions for Watch List Checking Details File                                 CSD015
                                                                                              CSD015
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                  CSD015
      ** Midas Watch List Transaction Details File                                            CSD015
                                                                                              CSD015
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD015
      ** 24x7 Status Dataarea                                                                 CSD015
                                                                                              CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
      ** Standing Data Dataarea                                                               CSD015
                                                                                              CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
      ** Midas Compliance Watch Configuration Data File                                       CSD015
                                                                                              CSD015
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
      ** Midas SD Customer Details File                                                       CSD015
                                                                                              CSD015
      **                                                                                      CSC022
      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      **                                                                                      CSC022
     D/COPY WNCPYSRC,FTM102UD01
 
      *
      ** Datastructure for FTM1012GN (creation of unique CCTID)
      *
     D P_Ref_Ds        DS
     D @P                      1      1
     D @@Date                  2      7
     D @@P_Ref                 8     13
     D @@Sett                 14     15
 
      ** Parameters for ZDATE1                                                  178384
     D DateIn          S              6A                                        178384
     D DaynoOut        S              5P 0                                      178384
     D DatFmt          S              1A                                        178384
     D ErrorFlag       S              1A                                        178384
                                                                                178384
      ** Parameters for FTM1013GN                                               178751
     D TrnType         S              2                                         178751
     D TrnId           S             15                                         178751
     D SeqNo           S              3                                         178751
                                                                                178751
      ** WORKING VARIABLES
      ** -----------------
 
      ** Old CCT id
     D OldCctID        S                   Like(CCTID)
 
      ** Old Transaction reference
     D OldTransID      S                   Like(TRNSID)
 
      ** Calling Program (for Message Management and STP)
     D CallingPgm      S             10
 
      ** Network (for Message Management and STP)
     D Network         S                   Like(PNWRK)
      *
     D WCCTAMT         S                   Like(CCTAMT)
     D WORIGAM         S                   Like(ORIGAM)
     D WPAYAMT         S                   Like(PAYAMT)
 
      ** CCT Id (13 long)                                                       178751
     D CCTID13         S             13                                         178751
 
      ** FLAGS
      ** -----
 
      ** Dump requested if error in i/o operation
     D DumpReq         S              1
 
      ** To indicate whether a header record is involved in the update
     D HdrInfo         S                   Like(DumpReq)
 
      ** To indicate whether a detail record is involved in the update
     D DtlInfo         S                   Like(DumpReq)
 
      ** To determine if main fields of an existing header matche
      ** with those passed in parameter
     D HdrMatch        S                   Like(DumpReq)
 
      ** To make COMMIT without allowing the value of IdxErr                    177866
     D CommitChg       S                   Like(DumpReq)                        177866
      *                                                                                       CSW201
      ** Flag for Enhancement 'SWIFT 2001 Standard Update'                                    CSW201
     D CSW201          S              1A                                                      CSW201
     D PRtCd           S              7A                                                      CSW201
 
      ** INDEX
      ** -----
 
     D E               S              2  0
     D IdxErr          S                   Like(E)
                                                                                              CSD015
      ** Variables for CSD015 Enhancement                                                     CSD015
                                                                                              CSD015
     D ArrWatch        S             35    DIM(22) CTDATA PERRCD(1)                           CSD015
     D CCF001          S              1A                                                      CSD015
     D CSC011          S              1A                                                      CSD015
     D CSD015          S              1A                                                      CSD015
     D KFuncCode       S              8                                                       CSD015
     D KIden           S             40                                                       CSD015
     D KBranch         S              3                                                       CSD015
     D PFunc           S              8A                                                      CSD015
     D PInCcy          S              3A                                                      CSD015
     D PInput1         S             35A                                                      CSD015
     D PInput2         S             35A                                                      CSD015
     D PInput3         S             35A                                                      CSD015
     D PInput4         S             35A                                                      CSD015
     D PInput5         S             35A                                                      CSD015
     D PInput6         S             35A                                                      CSD015
     D PKey            S             10A                                                      CSD015
     D PStatus         S             10A                                                      CSD015
     D POutput         S            216A                                                      CSD015
     D PCOutput        S              6A                                                      CSD015
     D POptn           S              7A                                                      CSD015
     D PInAmt          S             15A                                                      CSD015
     D POutAmt         S             16A                                                      CSD015
     D PCurr           S              3A                                                      CSD015
     D PInDate         S              5A                                                      CSD015
     D POutDate        S               D                                                      CSD015
     D PAMDate         S               D                                                      CSD015
     D PAMFlot         S             18  3                                                    CSD015
     D PRtnCode        S              7A                                                      CSD015
     D PSard           S              6A                                                      CSD015
     D PWatchString    S          30000A                                                      CSD015
     D WWrite          S              1A                                                      CSD015
      **                                                                                      CSC022
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      **                                                                                      CSC022
 
      ** Switchable Features Flags                                                            CRE020
     D CRE020          S              1A   INZ('N')                                           CRE020
                                                                                              CRE020
      ** Parameters for System Values Access Object                                           CRE020
     D PSValOpt        S             20A   INZ('CustCreditTransfer')                          CRE020
     D PSysVal         S            200A   INZ(' ')                                           CRE020
     D PSValOptB       S             20A   INZ(' ')                                           CRE020
     D PSysValB        S            200A   INZ(' ')                                           CRE020
                                                                                              CRE020
     D*CSW207***       S              7A   INZ('N')                                   CSW207 CSW207B
     D CSW207          S              1A                                                     CSW207B
     D CSW209          S              1A                                                      CSW209
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* MAIN - MAIN BODY                                                   *
     C*                                                                    *
     C**********************************************************************
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'MAIN'        SrStack(q)
 
      ** INITIALIZE
     C                   Exsr      SrIni
 
      *
      ** INSERT, AMEND, DELETE, AUTHORISE, REASSIGN
      *
     C     ActionCode    CasEq     'I'           SrIns
     C     ActionCode    CasEq     'A'           SrAmd
     C     ActionCode    CasEq     'D'           SrDel
     C     ActionCode    CasEq     'X'           SrAmdX
     C     ActionCode    CasEq     'R'           SrReass
     C                   EndCs
 
     C                   Z-add     E             IdxErr
     C*****IdxErr        Ifeq      0                                            177866
     C*****CommitChg     Ifeq      'Y'                                    177866178186
     C*****RetCodeIn     Andeq     *BLANK                                       178186
     C*******************Commit                                                 178186
     C*******************Else                                                   178186
     C*******************Rolbk                                                  178186
     C*******************Endif                                                  178186
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
      * EXIT FROM PROGRAM
 
     C                   RETURN
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrIni - INITIALIZE                                                 *
     C*                                                                    *
     C**********************************************************************
     C     SrIni         BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrIni'       SrStack(q)
 
     C                   Z-add     0             E
     C                   Movel     'Y'           CommitChg                      177866
     C                   Movel     *BLANK        FldNameArr
     C                   Movel     *BLANK        MsgIdArr
     C                   Movel     *BLANK        MsgDtaArr
 
      **  Unwind subroutine stack name
     C     SrIni_End     Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrIns - INSERT A CCT PAYMENT                                       *
     C*                                                                    *
     C**********************************************************************
     C     SrIns         BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrIns'       SrStack(q)
 
     C/COPY WNCPYSRC,FTM102UC01
     C                   Select
     C     HdrInfo       WhenEq    'Y'
     C     DtlInfo       AndEq     'N'
     C                   Exsr      SrIH
 
     C     HdrInfo       WhenEq    'Y'
     C     DtlInfo       AndEq     'Y'
     C                   Exsr      SrIHD
 
     C     HdrInfo       WhenEq    'N'
     C     DtlInfo       AndEq     'Y'
     C                   Exsr      SrID
 
     C                   EndSl
 
      **  Unwind subroutine stack name
     C     SrIns_End     Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrAmd - AMEND A CCT PAYMENT                                        *
     C*                                                                    *
     C**********************************************************************
     C     SrAmd         BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrAmd'       SrStack(q)
 
     C                   Select
     C     HdrInfo       WhenEq    'Y'
     C     DtlInfo       AndEq     'N'
     C                   Exsr      SrAH
 
     C     HdrInfo       WhenEq    'Y'
     C     DtlInfo       AndEq     'Y'
     C                   Exsr      SrAHD
 
     C     HdrInfo       WhenEq    'N'
     C     DtlInfo       AndEq     'Y'
     C                   Exsr      SrAD
 
     C                   EndSl
 
      **  Unwind subroutine stack name
     C     SrAmd_End     Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrAmdX - AUTHORISE A PAYMENT                                       *
     C*                                                                    *
     C**********************************************************************
     C     SrAmdX        BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrAmdX'      SrStack(q)
 
     C                   Callb     'FTM102CFM'                          90
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode
     C                   Parm      'X'           ActionCode
     C                   Parm                    SH_CCTID
     C                   Parm      SH_FILREF     CK_SNDREF
     C                   Parm      SH_SINST      CK_SNDIST
 
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FTM102CFM'   DBFILE
     C                   Z-add     01            DBASE
     C                   Movel     '*CALL'       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                   Rolbk                                                   184191
     C                   Else                                                                 CSC022
     C                   If        WSkpComtRolbk = 'N'                                        CSC022
     C                   RolBk                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   Else                                                    184191
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   Commit                                                  184191
     C                   EndIf                                                                CSC022
     C                   Endif
 
      ** If Online Printing of Advice is on and is set in the system,                         CRE020
      ** update READVCPD.                                                                     CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             PSysVal = 'Y'                                              CRE020
     C                   EXSR      SrUpdAdvice                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      **  Unwind subroutine stack name
     C     SrAmdX_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrDel - DELETE A CCT PAYMENT                                       *
     C*                                                                    *
     C**********************************************************************
     C     SrDel         BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrDel'       SrStack(q)
 
     C                   Select
     C     HdrInfo       WhenEq    'Y'
     C     DtlInfo       AndEq     'N'
     C                   Exsr      SrDH
 
     C     HdrInfo       WhenEq    'Y'
     C     DtlInfo       AndEq     'Y'
     C                   Exsr      SrDHD
 
     C     HdrInfo       WhenEq    'N'
     C     DtlInfo       AndEq     'Y'
     C                   Exsr      SrDD
 
     C                   EndSl
 
      **  Unwind subroutine stack name
     C     SrDel_End     Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrReass - REASSIGN A CCT PAYMENT                                   *
     C*                                                                    *
     C**********************************************************************
     C     SrReass       BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrReass'     SrStack(q)
                                                                                177673
     C                   Movel     'Y'           Unlocked                       177673
     C                   Movel     DumpReq       RtvDump                        177673
     C                   Movel     SH_CCTID      Cct_ID                         177673
     C                   Exsr      RtvHdr2                                      177673
                                                                                177673
     C     HdrFound      Ifeq      'Y'                                          177673
 
     C*******************Movel     'N'           Unlocked                       177673
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SD_CCTID      CCt_Id
     C                   Movel     SD_TRNSID     TransId
     C*******************Exsr      RtvDtl                                       177673
     C                   Exsr      DtlNfnd                                      177673
     C     DtlFound      Ifeq      'N'                                          177673
     C*****DtlFound      Ifeq      'Y'                                          177673
     C*******************Add       1             E                              177673
     C*******************Movel     SrStack(q)    FldNameArr(E)                  177673
     C*******************Movel     'RFU0005'     MsgIdArr(E)                    177673
     C*******************Else                                                   177673
     C*******************EVAL      E=0                                          177673
     C                   Movel     OldCCtID      CCt_ID
     C                   Movel     OldTransID    TransID
     C                   Movel     'N'           Unlocked                       177673
     C                   Movel     DumpReq       RtvDump                        177673
     C                   Exsr      RtvDtl                                       177673
     C     DtlFound      Ifeq      'Y'                                          177673
     C*****KCctDtl1      Chain     FT102DL0                           97        177673
     C                   Eval      CCTID = Sd_CctId
     C*******************Eval      TRNSID = SD_Trnsid                           178751
      *                                                                         178751
      ** Default transaction reference                                          178751
      *                                                                         178751
     C                   Exsr      RtvSeq                                       178751
     C                   Movel     CCTID         CCTID13                        178751
     C     CCTID13       Cat       SEQNO         TRNSID                         178751
     C                   Movel     SEQNO         TSEQNO                         178751
     C*******************Update    FT102DD0                                     177673
     C                   Exsr      UpdateD                                      177673
                                                                                177673
     C     CCTMSG        Ifne      0                                            177673
     C     CCTMSQ        andne     0                                            177673
      **  Reassign the message to the new transaction                           177673
     C                   Movel     SH_CCTTYP     PayType                        177673
     C                   Z-add     CCTMSG        MsgRefI                        177673
     C                   Z-add     CCTMSQ        MsgPartI                       177673
     C                   Movel     'MIN0030'     MsgStat                        177673
     C                   Exsr      SrFtst                                       177673
     C                   Endif                                                  177673
                                                                                177673
     C                   Endif                                                  177673
                                                                                177673
     C                   Endif
                                                                                177673
     C                   Endif                                                  177673
      *
      **  Unwind subroutine stack name
      *
     C     SrRea_End     Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrIH - INSERT : HEADER SIDE ONLY                                   *
     C*                                                                    *
     C**********************************************************************
     C     SrIH          BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrIH'        SrStack(q)
 
     C                   Movel     DumpReq       NfndDump
     C                   Movel     SH_FILREF     FileRef
     C                   Movel     SH_STID       SwiftID
     C                   Exsr      HdrNfnd
     C     HdrFound      Ifeq      'N'
     C                   Movel     DumpReq       NfndDump
     C                   Movel     SD_CCTID      Cct_ID
     C                   Movel     SD_TRNSID     TransID
     C                   Exsr      SrMapH
     C                   Exsr      WriteH
     C                   Endif
 
      **  Unwind subroutine stack name
     C     SrIH_End      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrIHD - INSERT : HEADER/DETAIL BOTH                                *
     C*                                                                    *
     C**********************************************************************
     C     SrIHD         BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrIHD'       SrStack(q)
 
      ** This procedure is supposed to be  called by STP
 
      ** By default theres a match with existing header and
      ** the header details passed in parameter
     C                   Movel     'Y'           HdrMatch
 
     C                   Movel     'N'           NfndDump
     C                   Movel     SH_FILREF     FileRef
     C                   Movel     SH_STID       SwiftID
     C                   Exsr      HdrNfnd
 
      ** Field passed in parameter come mainly from message
      ** management criteria maintenance (CRIT)
     C     HdrFound      Ifeq      'Y'
 
      ** No error in this case
      ** Remove latest errors generated by S/R  HdrNfnd
     C     E             Dowgt     0
     C     FldNameArr(E) Ifeq      'HdrNfnd'
     C                   Movel     *BLANK        FldNameArr(E)
     C                   Movel     *BLANK        MsgIdArr(E)
     C                   Sub       1             E
     C                   Else
     C                   Leave
     C                   Endif
     C                   Enddo
 
      ** No errors : allows commit                                              177866
     C     E             Ifeq      0                                            177866
     C                   Movel     'Y'           CommitChg                      177866
     C                   Endif                                                  177866
 
      ** Retrieve the data                                                      177809
     C                   Movel     'Y'           Unlocked                       177809
     C                   Movel     DumpReq       RtvDump                        177809
     C                   Movel     SH_FILREF     FileRef                        177809
     C                   Movel     SH_STID       SwiftID                        177809
     C                   Exsr      RtvHdr                                       177809
                                                                                177809
     C                   Endif                                                  177809
                                                                                177809
     C     HdrFound      Ifeq      'Y'                                          177809
                                                                                177809
      ** For S/R SrMapD, we need to store the ID of the request for
      ** transfert for each detail we want to insert.
     C                   Movel     CCTID         SH_CCTID
 
     C     SH_CCTTYP     Ifne      CCTTYP
     C     SH_CCTTST     orne      CCTTST
     C     SH_BRCA       orne      BRCA
     C     SH_ORBR       orne      ORBR
     C     SH_BOKC       orne      BOKC
     C     SH_PRFC       orne      PRFC
     C                   Movel     'N'           HdrMatch
     C     UserPrf       Ifeq      '*STP'                                       177973
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0004'     MsgIdArr(E)
      ** We commit changes done in FT0300 (STP)
     C                   Movel     'Y'           CommitChg                      177866
     C                   Else                                                   177973
     C                   Movel     'N'           CommitChg                      177973
     C                   Endif                                                  177973
     C     SH_CCTTYP     Ifne      CCTTYP                                       177973
     C                   Add       1             E                              177973
     C                   Movel     SrStack(q)    FldNameArr(E)                  177973
     C                   Movel     'RFU0007'     MsgIdArr(E)                    177973
     C                   Endif                                                  177973
     C     SH_CCTTST     Ifne      CCTTST                                       177973
     C                   Add       1             E                              177973
     C                   Movel     SrStack(q)    FldNameArr(E)                  177973
     C                   Movel     'RFU0008'     MsgIdArr(E)                    177973
     C                   Endif                                                  177973
     C     SH_BRCA       Ifne      BRCA                                         177973
     C                   Add       1             E                              177973
     C                   Movel     SrStack(q)    FldNameArr(E)                  177973
     C                   Movel     'RFU0009'     MsgIdArr(E)                    177973
     C                   Endif                                                  177973
     C     SH_ORBR       Ifne      ORBR                                         177973
     C                   Add       1             E                              177973
     C                   Movel     SrStack(q)    FldNameArr(E)                  177973
     C                   Movel     'RFU0010'     MsgIdArr(E)                    177973
     C                   Endif                                                  177973
     C     SH_BOKC       Ifne      BOKC                                         177973
     C                   Add       1             E                              177973
     C                   Movel     SrStack(q)    FldNameArr(E)                  177973
     C                   Movel     'RFU0011'     MsgIdArr(E)                    177973
     C                   Endif                                                  177973
     C     SH_PRFC       Ifne      PRFC                                         177973
     C                   Add       1             E                              177973
     C                   Movel     SrStack(q)    FldNameArr(E)                  177973
     C                   Movel     'RFU0012'     MsgIdArr(E)                    177973
     C                   Endif                                                  177973
     C                   Endif
     C                   Else
     C                   Exsr      SrMapH
     C                   Exsr      WriteH
     C                   Endif
 
     C     HdrMatch      Ifeq      'Y'
     C                   Movel     DumpReq       NfndDump
     C                   Movel     SD_CCTID      Cct_ID
     C                   Movel     SD_TRNSID     TransID
     C                   Exsr      DtlNfnd
 
     C     DtlFound      Ifeq      'N'
     C                   Movel     DumpReq       NfndDump
     C                   Movel     SD_CCTID      Cct_ID
     C                   Movel     SD_TRNSID     TransID
     C                   Exsr      SrMapD
     C                   Exsr      WriteD
 
      ** If payment created through a message MT102
      ** Update status of the message
     C     SD_CCTMSG     Ifne      0
     C     SD_CCTMSQ     andne     0
     C                   Movel     SH_CCTTYP     PayType
     C                   Z-add     SD_CCTMSG     MsgRefI
     C                   Z-add     SD_CCTMSQ     MsgPartI
     C                   Movel     'MIN0030'     MsgStat
     C                   Movel     'MIN0027'     Message
     C                   Exsr      SrFtst
     C                   Endif
 
     C                   Endif
     C                   Endif
      **  Unwind subroutine stack name
     C     SrIHD_End     Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrID - INSERT : DETAIL SIDE ONLY                                   *
     C*                                                                    *
     C**********************************************************************
     C     SrID          BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrID'        SrStack(q)
 
     C*******************Movel     'N'           Unlocked                       178751
     C                   Movel     'Y'           Unlocked                       178751
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SH_FILREF     FileRef
     C                   Movel     SH_STID       SwiftID
     C                   Exsr      RtvHdr
 
     C     HdrFound      Ifeq      'Y'
      ** For S/R SrMapD, we need to store the ID of the request for
      ** transfert for each detail we want to insert.
     C                   Movel     DumpReq       NfndDump
     C                   Movel     'Y'           Unlocked
     C                   Movel     CCTID         SH_CCTID
     C                   Movel     CCTID         Cct_ID
     C                   Movel     SD_TRNSID     TransID
     C                   Exsr      DtlNfnd
 
     C     DtlFound      Ifeq      'N'
     C                   Movel     'N'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     CCTID         SH_CCTID
     C                   Movel     CCTID         Cct_ID
     C                   Exsr      SrMapD
     C                   Exsr      WriteD
 
      ** If payment created through a message MT102
      ** Update status of the message
     C     SD_CCTMSG     Ifne      0
     C     SD_CCTMSQ     andne     0
     C                   Movel     SH_CCTTYP     PayType
     C                   Z-add     SD_CCTMSG     MsgRefI
     C                   Z-add     SD_CCTMSQ     MsgPartI
     C                   Movel     'MIN0030'     MsgStat
     C                   Movel     'MIN0027'     Message
     C                   Exsr      SrFtst
      ** Release the message
     C                   Exsr      RlsMsg
     C                   Endif
 
     C                   Endif
     C                   Endif
 
      **  Unwind subroutine stack name
     C     SrID_End      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrAH - AMEND : HEADER SIDE ONLY                                    *
     C*                                                                    *
     C**********************************************************************
     C     SrAH          BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrAH'        SrStack(q)
 
     C                   Movel     'N'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SH_FILREF     FileRef
     C                   Movel     SH_STID       SwiftID
     C                   Exsr      RtvHdr
 
     C     HdrFound      Ifeq      'Y'
                                                                                              CSD015
      ** If Function Code is being monitored by Compliance Watch                              CSD015
      ** and Watch List Checking Applied                                                      CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'N' OR LIBR = S1MAIN                              CSD015
                                                                                              CSD015
     C                   EVAL      KIden = SH_CCTID                                           CSD015
     C                   EVAL      KBranch = SH_BRCA                                          CSD015
     C                   EVAL      W3UNCF = *BLANKS                                           CSD015
                                                                                              CSD015
     C     KFuncKey      CHAIN     SDCWHTL1                           48                      CSD015
                                                                                              CSD015
     C                   IF        ((*IN48 = *OFF AND W3UNCF = 'Y') OR                        CSD015
     C                             ((SH_SINST <> *BLANKS AND SH_SINST <> SINST)               CSD015
     C                             OR (SH_CCTDST <> *BLANKS AND                               CSD015
     C                             SH_CCTDST <> CCTDST) OR (SH_TOCUS1 <> *BLANKS              CSD015
     C                             AND SH_TOCUS1 <> TOCUS1) OR                                CSD015
     C                             (SH_TOCUS2 <> *BLANKS AND                                  CSD015
     C                             SH_TOCUS2 <> TOCUS2)                                       CSD015
     C                             OR (SH_TOCUS3 <> *BLANKS AND                               CSD015
     C                             SH_TOCUS3 <> TOCUS3) OR (SH_TOCUS4 <> *BLANKS              CSD015
     C                             AND SH_TOCUS4 <> TOCUS4) OR                                CSD015
     C                             (SH_OINST1 <> *BLANKS AND                                  CSD015
     C                             SH_OINST1 <> OINST1)                                       CSD015
     C                             OR (SH_OINST3 <> *BLANKS AND                               CSD015
     C                             SH_OINST3 <> OINST3) OR (SH_SNDCOR <> *BLANKS              CSD015
     C                             AND SH_SNDCOR <> SNDCOR) OR                                CSD015
     C                             (SH_RCVCOR <> *BLANKS AND                                  CSD015
     C                             SH_RCVCOR <> RCVCOR)))                                     CSD015
     C                             OR (CSW207 ='Y' AND ((SH_TOCUS5 <> *BLANKS)                CSW207
     C                                 AND (SH_TOCUS5 <> TOCUS5)))                            CSW207
                                                                                              CSD015
     C                   EVAL      WWrite = 'N'                                               CSD015
     C                   EXSR      Sr2ndHParm                                                 CSD015
                                                                                              CSD015
     C                   IF        PWatchString <> *BLANKS                                    CSD015
     C                   EXSR      Sr1stParm                                                  CSD015
     C                   EXSR      SrCallWatch                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check other detail records in RFT Detail File                                        CSD015
                                                                                              CSD015
     C                   IF        W3UNCF = 'Y'                                               CSD015
     C     SH_CCTID      SETLL     FT102DL2                               49                  CSD015
     C     SH_CCTID      READE     FT102DL2                               49                  CSD015
     C                   DOW       *IN49 = *OFF                                               CSD015
     C                   EXSR      Sr2ndD2Parm                                                CSD015
     C                   EVAL      SD_CCTCCY = PD_CCTCCY                                      CSD015
     C                   EVAL      SD_PAYCCY = PD_PAYCCY                                      CSD015
     C                   EXSR      Sr2ndHParm                                                 CSD015
                                                                                              CSD015
     C                   IF        PWatchString <> *BLANKS                                    CSD015
     C                   EXSR      Sr1stParm                                                  CSD015
     C                   EXSR      SrCallWatch                                                CSD015
     C                   ENDIF                                                                CSD015
     C     SH_CCTID      READE     FT102DL2                               49                  CSD015
     C                   ENDDO                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   Movel     'N'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Exsr      SrMapH
     C                   Exsr      UpdateH
     C                   Endif
 
      **  Unwind subroutine stack name
     C     SrAH_End      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrAHD - AMEND : HEADER/DETAIL BOTH                                 *
     C*                                                                    *
     C**********************************************************************
     C     SrAHD         BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrAHD'       SrStack(q)
 
     C                   Movel     'N'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SH_FILREF     FileRef
     C                   Movel     SH_STID       SwiftID
     C                   Exsr      RtvHdr
 
     C     HdrFound      Ifeq      'Y'
                                                                                              CSD015
      ** If Function Code is being monitored by Compliance Watch                              CSD015
      ** and Watch List Checking Applied                                                      CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'N' OR LIBR = S1MAIN                              CSD015
                                                                                              CSD015
     C                   EVAL      KIden = SH_CCTID                                           CSD015
     C                   EVAL      KBranch = SH_BRCA                                          CSD015
     C                   EVAL      W3UNCF = *BLANKS                                           CSD015
                                                                                              CSD015
     C     KFuncKey      CHAIN     SDCWHTL1                           48                      CSD015
                                                                                              CSD015
     C                   IF        ((*IN48 = *OFF AND W3UNCF = 'Y') OR                        CSD015
     C                             ((SH_SINST <> *BLANKS AND SH_SINST <> SINST)               CSD015
     C                             OR (SH_CCTDST <> *BLANKS AND                               CSD015
     C                             SH_CCTDST <> CCTDST) OR (SH_TOCUS1 <> *BLANKS              CSD015
     C                             AND SH_TOCUS1 <> TOCUS1) OR                                CSD015
     C                             (SH_TOCUS2 <> *BLANKS AND                                  CSD015
     C                             SH_TOCUS2 <> TOCUS2) OR (SH_TOCUS3 <> *BLANKS              CSD015
     C                             AND SH_TOCUS3 <> TOCUS3) OR                                CSD015
     C                             (SH_TOCUS4 <> *BLANKS AND                                  CSD015
     C                             SH_TOCUS4 <> TOCUS4) OR (SH_OINST1 <> *BLANKS              CSD015
     C                             AND SH_OINST1 <> OINST1) OR                                CSD015
     C                             (SH_OINST3 <> *BLANKS AND                                  CSD015
     C                             SH_OINST3 <> OINST3) OR (SH_SNDCOR <> *BLANKS              CSD015
     C                             AND SH_SNDCOR <> SNDCOR) OR                                CSD015
     C                             (SH_RCVCOR <> *BLANKS AND                                  CSD015
     C                             SH_RCVCOR <> RCVCOR) OR (SD_ORDCU1 <> *BLANKS              CSD015
     C                             AND SD_ORDCU1 <> ORDCU1) OR                                CSD015
     C                             (SD_ORDCU2 <> *BLANKS AND                                  CSD015
     C                             SD_ORDCU2 <> ORDCU2) OR (SD_ORDCU3 <> *BLANKS              CSD015
     C                             AND SD_ORDCU3 <> ORDCU3) OR                                CSD015
     C                             (SD_ORDCU4 <> *BLANKS AND                                  CSD015
     C                             SD_ORDCU4 <> ORDCU4) OR (SD_ORDI11 <> *BLANKS              CSD015
     C                             AND SD_ORDI11 <> ORDI11) OR                                CSD015
     C                             (SD_ORDI35 <> *BLANKS AND                                  CSD015
     C                             SD_ORDI35 <> ORDI35) OR (SD_ACCI11 <> *BLANKS              CSD015
     C                             AND SD_ACCI11 <> ACCI11) OR                                CSD015
     C                             (SD_ACCI35 <> *BLANKS AND                                  CSD015
     C                             SD_ACCI35 <> ACCI35) OR (SD_BENF1 <> *BLANKS               CSD015
     C                             AND SD_BENF1 <> BENF1) OR                                  CSD015
     C                             (SD_BENF2 <> *BLANKS AND SD_BENF2 <> BENF2)                CSD015
     C                             OR (SD_BENF3 <> *BLANKS AND                                CSD015
     C                             SD_BENF3 <> BENF3) OR (SD_BENF4 <> *BLANKS                 CSD015
     C                             AND SD_BENF4 <> BENF4) OR                                  CSD015
     C                             (SD_BENF5 <> *BLANKS AND SD_BENF5 <> BENF5)                CSD015
     C                             OR (SD_REMI1 <> *BLANKS AND                                CSD015
     C                             SD_REMI1 <> REMI1) OR (SD_REMI2 <> *BLANKS                 CSD015
     C                             AND SD_REMI2 <> REMI2) OR                                  CSD015
     C                             (SD_REMI3 <> *BLANKS AND SD_REMI3 <> REMI3)                CSD015
     C                             OR (SD_REMI4 <> *BLANKS AND                                CSD015
     C                             SD_REMI4 <> REMI4)))                                       CSD015
     C                             OR (CSW207 = 'Y' AND                                       CSW207
     C                                 ((SH_TOCUS5 <> *BLANKS AND                             CSW207
     C                                   SH_TOCUS5 <> TOCUS5) OR                              CSW207
     C                                  (SD_ORDCU5 <> *BLANKS AND                             CSW207
     C                                   SD_ORDCU5 <> ORDCU5)))                               CSW207
                                                                                              CSD015
     C                   EVAL      WWrite = 'N'                                               CSD015
     C                   EXSR      Sr2ndHParm                                                 CSD015
     C                   EXSR      Sr2ndDParm                                                 CSD015
                                                                                              CSD015
     C                   IF        PWatchString <> *BLANKS                                    CSD015
     C                   EXSR      Sr1stParm                                                  CSD015
     C                   EXSR      SrCallWatch                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check other detail records in RFT Files                                              CSD015
                                                                                              CSD015
     C                   IF        W3UNCF = 'Y'                                               CSD015
     C     SH_CCTID      SETLL     FT102DL2                               49                  CSD015
     C     SH_CCTID      READE     FT102DL2                               49                  CSD015
     C                   DOW       *IN49 = *OFF                                               CSD015
     C                   EXSR      Sr2ndD2Parm                                                CSD015
     C                   EXSR      Sr2ndH2Parm                                                CSD015
                                                                                              CSD015
     C                   IF        PWatchString <> *BLANKS                                    CSD015
     C                   EXSR      Sr1stParm                                                  CSD015
     C                   EXSR      SrCallWatch                                                CSD015
     C                   ENDIF                                                                CSD015
     C     SH_CCTID      READE     FT102DL2                               49                  CSD015
     C                   ENDDO                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   Movel     'N'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SD_CCTID      Cct_ID
     C                   Movel     SD_TRNSID     TransID
     C                   Exsr      SrMapH
     C                   Exsr      UpdateH
     C                   Exsr      RtvDtl
 
     C     DtlFound      Ifeq      'Y'
     C                   Movel     'N'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SD_CCTID      Cct_ID
     C                   Exsr      SrMapD
     C                   Exsr      UpdateD
 
     C                   Endif
     C                   Endif
 
      **  Unwind subroutine stack name
     C     SrAHD_End     Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrAD - AMEND : DETAIL SIDE ONLY                                    *
     C*                                                                    *
     C**********************************************************************
     C     SrAD          BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrAD'        SrStack(q)
     C                   Movel     'Y'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SD_CCTID      Cct_ID
     C                   Exsr      RtvHdr2
 
     C     HdrFound      Ifeq      'Y'
     C                   Movel     'N'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SD_CCTID      Cct_ID
     C                   Movel     SD_TRNSID     TransID
     C                   Exsr      RtvDtl
 
     C     DtlFound      Ifeq      'Y'
                                                                                              CSD015
      ** If Function Code is being monitored by Compliance Watch                              CSD015
      ** and Watch List Checking Applied                                                      CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'N' OR LIBR = S1MAIN                              CSD015
                                                                                              CSD015
     C                   EVAL      KIden = SH_CCTID                                           CSD015
     C                   EVAL      KBranch = SH_BRCA                                          CSD015
     C                   EVAL      W3UNCF = *BLANKS                                           CSD015
                                                                                              CSD015
     C     KFuncKey      CHAIN     SDCWHTL1                           48                      CSD015
                                                                                              CSD015
     C                   IF        ((*IN48 = *OFF AND W3UNCF = 'Y') OR                        CSD015
     C                             ((SH_SINST <> *BLANKS AND SH_SINST <> SINST)               CSD015
     C                             OR (SH_CCTDST <> *BLANKS AND                               CSD015
     C                             SH_CCTDST <> CCTDST) OR (SH_TOCUS1 <> *BLANKS              CSD015
     C                             AND SH_TOCUS1 <> TOCUS1) OR                                CSD015
     C                             (SH_TOCUS2 <> *BLANKS AND                                  CSD015
     C                             SH_TOCUS2 <> TOCUS2) OR (SH_TOCUS3 <> *BLANKS              CSD015
     C                             AND SH_TOCUS3 <> TOCUS3) OR                                CSD015
     C                             (SH_TOCUS4 <> *BLANKS AND                                  CSD015
     C                             SH_TOCUS4 <> TOCUS4) OR (SH_OINST1 <> *BLANKS              CSD015
     C                             AND SH_OINST1 <> OINST1) OR                                CSD015
     C                             (SH_OINST3 <> *BLANKS AND                                  CSD015
     C                             SH_OINST3 <> OINST3) OR (SH_SNDCOR <> *BLANKS              CSD015
     C                             AND SH_SNDCOR <> SNDCOR) OR                                CSD015
     C                             (SH_RCVCOR <> *BLANKS AND                                  CSD015
     C                             SH_RCVCOR <> RCVCOR) OR (SD_ORDCU1 <> *BLANKS              CSD015
     C                             AND SD_ORDCU1 <> ORDCU1) OR                                CSD015
     C                             (SD_ORDCU2 <> *BLANKS AND                                  CSD015
     C                             SD_ORDCU2 <> ORDCU2) OR (SD_ORDCU3 <> *BLANKS              CSD015
     C                             AND SD_ORDCU3 <> ORDCU3) OR                                CSD015
     C                             (SD_ORDCU4 <> *BLANKS AND                                  CSD015
     C                             SD_ORDCU4 <> ORDCU4) OR (SD_ORDI11 <> *BLANKS              CSD015
     C                             AND SD_ORDI11 <> ORDI11) OR                                CSD015
     C                             (SD_ORDI35 <> *BLANKS AND                                  CSD015
     C                             SD_ORDI35 <> ORDI35) OR (SD_ACCI11 <> *BLANKS              CSD015
     C                             AND SD_ACCI11 <> ACCI11) OR                                CSD015
     C                             (SD_ACCI35 <> *BLANKS AND                                  CSD015
     C                             SD_ACCI35 <> ACCI35) OR (SD_BENF1 <> *BLANKS               CSD015
     C                             AND SD_BENF1 <> BENF1) OR                                  CSD015
     C                             (SD_BENF2 <> *BLANKS AND SD_BENF2 <> BENF2)                CSD015
     C                             OR (SD_BENF3 <> *BLANKS AND                                CSD015
     C                             SD_BENF3 <> BENF3) or (SD_BENF4 <> *BLANKS                 CSD015
     C                             AND SD_BENF4 <> BENF4) OR                                  CSD015
     C                             (SD_BENF5 <> *BLANKS AND SD_BENF5 <> BENF5)                CSD015
     C                             OR (SD_REMI1 <> *BLANKS AND                                CSD015
     C                             SD_REMI1 <> REMI1) or (SD_REMI2 <> *BLANKS                 CSD015
     C                             AND SD_REMI2 <> REMI2) OR                                  CSD015
     C                             (SD_REMI3 <> *BLANKS AND SD_REMI3 <> REMI3)                CSD015
     C                             OR (SD_REMI4 <> *BLANKS AND                                CSD015
     C                             SD_REMI4 <> REMI4)))                                       CSD015
     C                             OR (CSW207 = 'Y' AND                                       CSW207
     C                                 ((SH_TOCUS5 <> *BLANKS AND                             CSW207
     C                                   SH_TOCUS5 <> TOCUS5) OR                              CSW207
     C                                  (SD_ORDCU5 <> *BLANKS AND                             CSW207
     C                                   SD_ORDCU5 <> ORDCU5)))                               CSW207
                                                                                              CSD015
     C                   EVAL      WWrite = 'N'                                               CSD015
     C                   EXSR      Sr2ndDParm                                                 CSD015
                                                                                              CSD015
     C                   IF        PWatchString <> *BLANKS                                    CSD015
     C                   EXSR      Sr1stParm                                                  CSD015
     C                   EXSR      SrCallWatch                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check other detail records in RFT Detail File                                        CSD015
                                                                                              CSD015
     C                   IF        W3UNCF = 'Y'                                               CSD015
     C     SH_CCTID      SETLL     FT102DL2                               49                  CSD015
     C     SH_CCTID      READE     FT102DL2                               49                  CSD015
     C                   DOW       *IN49 = *OFF                                               CSD015
     C                   EXSR      Sr2ndD2Parm                                                CSD015
     C                   EXSR      Sr2ndH2Parm                                                CSD015
                                                                                              CSD015
     C                   IF        PWatchString <> *BLANKS                                    CSD015
     C                   EXSR      Sr1stParm                                                  CSD015
     C                   EXSR      SrCallWatch                                                CSD015
     C                   ENDIF                                                                CSD015
     C     SH_CCTID      READE     FT102DL2                               49                  CSD015
     C                   ENDDO                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   Movel     'N'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SD_CCTID      Cct_ID
     C                   Exsr      SrMapD
     C                   Exsr      UpdateD
 
     C                   Endif
     C                   Endif
 
      **  Unwind subroutine stack name
     C     SrAD_End      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrDH - DELETE : HEADER SIDE ONLY                                   *
     C*                                                                    *
     C**********************************************************************
     C     SrDH          BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrDH'        SrStack(q)
 
     C                   Movel     'N'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SH_CCTID      Cct_ID
     C                   Exsr      RtvHdr2
 
     C     HdrFound      Ifeq      'Y'
     C                   Delete    FT102HL3                             90
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102HL3'    DBFILE
     C                   Z-add     04            DBASE
     C                   Movel     '*DELETE'     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Movel     'N'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SH_CCTID      Cct_ID
     C                   Exsr      RtvDtl2
     C     DtlFound      Ifne      'Y'
      ** No error in this case
      ** Remove latest errors generated by S/R  RtvDtl2
     C     E             Dowgt     0
     C     FldNameArr(E) Ifeq      'RtvDtl2'
     C                   Movel     *BLANK        FldNameArr(E)
     C                   Movel     *BLANK        MsgIdArr(E)
     C                   Sub       1             E
     C                   Else
     C                   Leave
     C                   Endif
     C                   Enddo
      ** No errors : allows commit                                              177866
     C     E             Ifeq      0                                            177866
     C                   Movel     'Y'           CommitChg                      177866
     C                   Endif                                                  177866
     C                   Endif
 
      ** Its possible to have a header record without any details
     C     DtlFound      Ifeq      'Y'
 
     C                   Movel     SH_CCTID      Cct_ID
     C     *IN90         Doweq     '0'
     C                   Exsr      DeleteD
     C     CCTMSG        Ifne      0
     C     CCTMSQ        andne     0
      **  Detach the message from the payment
     C                   Movel     SH_CCTTYP     PayType
     C                   Z-add     CCTMSG        MsgRefI
     C                   Z-add     CCTMSQ        MsgPartI
     C                   Movel     *BLANK        MsgStat
     C                   Exsr      SrFtst
     C                   Endif
 
     C     Cct_ID        Reade     FT102DL0                             9190
     C     *IN91         Ifeq      '1'
     C                   Unlock    FT102DL0
     C     DumpReq       Ifeq      'Y'
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102DL0'    DBFILE
     C                   Z-add     07            DBASE
     C                   Movel     '*LOCKED'     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Else
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0002'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C                   Endif
     C                   Goto      SrDH_End
     C                   Endif
     C                   Enddo
 
     C                   Endif
 
     C*******************Movel     'N'           Unlocked                 177676
     C*******************Movel     DumpReq       RtvDump                  177676
     C*******************Movel     SH_CCTID      Cct_ID                   177676
     C                   Endif
 
      **  Unwind subroutine stack name
     C     SrDH_End      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrDHD - DELETE : HEADER/DETAIL BOTH                                *
     C*                                                                    *
     C**********************************************************************
     C     SrDHD         BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrDHD'       SrStack(q)
 
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     *BLANK        DBFILE
     C                   Z-add     06            DBASE
     C                   Movel     '*CALL'       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Dump
 
      **  Unwind subroutine stack name
     C     SrDHD_End     Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrDD - DELETE : DETAIL SIDE ONLY                                   *
     C*                                                                    *
     C**********************************************************************
     C     SrDD          BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrDD'        SrStack(q)
 
     C                   Movel     'N'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SD_CCTID      Cct_ID
     C                   Movel     SD_TRNSID     TransID
     C                   Exsr      RtvDtl
 
     C     DtlFound      Ifeq      'Y'
     C                   Exsr      DeleteD
     C     SD_CCTMSG     Ifne      0
     C     SD_CCTMSQ     andne     0
      **  Detach the message from the payment
     C                   Movel     SH_CCTTYP     PayType
     C                   Z-add     SD_CCTMSG     MsgRefI
     C                   Z-add     SD_CCTMSQ     MsgPartI
     C                   Movel     *BLANK        MsgStat
     C                   Exsr      SrFtst
     C                   Endif
     C                   Endif
 
      **  Unwind subroutine stack name
     C     SrDD_End      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrMapH - MAP FIELDS OF THE HEADER RECORD                           *
     C*                                                                    *
     C**********************************************************************
     C     SrMapH        BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrMapH'      SrStack(q)
      *
     C**********         Eval      WCCTAMT = CCTAMT                                           213053
     C**********         Eval      WORIGAM = ORIGAM                                           213053
     C**********         Eval      WPAYAMT = PAYAMT                                           213053
 
     C     ActionCode    Ifeq      'I'
     C                   Clear                   FT102HD7
      *
      ** Call FTM1012GN to create unique CCT identifier
      ** Only call if it has not already created a CCTID
      *
     C                   IF        SH_CCTID = *BLANKS
      ** Retrieve Transaction Number                                             177677
     C                   Eval      Trns_Type =  SH_CCTTYP                        177677
     C                   Exsr      RtvTrn                                        177677
     C                   Eval      SH_CCTID = P_Ref_Ds                           177677
     C                   Endif                                                   177677
 
     C*******************CALLB     'FTM1012GN'                                   177677
      ***OUTPUT*PARAMETERS***************                                        177677
     C*******************PARM                    RetCodeIn                       177677
      ***INPUT*PARAMETERS                                                        177677
     C*******************PARM                    SH_CCTTYP                       177677
     C*******************PARM                    P_Ref_Ds                        177677
      *******************                                                        177677
     C*******************MOVEL     P_Ref_Ds      SH_CCTID                        177677
      *******************                                                        177677
     C*******************ENDIF                                                   177677
 
      ***Retrieve*Transaction*Number**                                     177677
     C*****UserPrf       Ifeq      '*STP'                                  177677
     C*******************Move      SH_CCTTYP     Trns_Type                 177677
     C*******************Exsr      RtvTrn                                  177677
     C*******************Move      P_Ref_Ds      SH_CCTID                  177677
     C*******************Endif                                             177677
 
     C                   Move      SH_CCTID      CCTID
      *                                                                          178751
      ** If file reference is blank, default it to CCT Id                        178751
      *                                                                          178751
     C                   If        SH_FILREF = *blanks                           178751
     C                   Movel     CCTID         SH_FILREF                       178751
     C                   Endif                                                   178751
      *                                                                          178751
     C                   Move      SH_FILREF     FILREF
      *
      ** Get Base CCy Equiv of Transfer Ccy
      *
     C                   If        BJCYCD = SH_CCTCCY
     C                   Z-Add     1             BASTFR
     C                   Else
     C                   Move      SH_CCTCCY     CcyIn
     C                   Exsr      RtvCcy
     C                   Z-add     A6SPRT        BASTFR
      *
     C                   Endif
 
     C                   Endif
 
     C                   Move      SH_STID       STID
     C                   Move      SH_CCTTYP     CCTTYP
     C                   Move      SH_CCTTST     CCTTST
     C                   Move      SH_BRCA       BRCA
     C                   Move      SH_ORBR       ORBR
     C                   Move      SH_BOKC       BOKC
     C                   Move      SH_PRFC       PRFC
     C                   Move      SH_CCTBOC     CCTBOC
     C                   Move      SH_SINST      SINST
     C                   Move      SH_SINSTT     SINSTT
     C                   Move      SH_CCTDST     CCTDST
     C                   Move      SH_DSTTYP     DSTTYP
     C                   Move      SH_TOCUS1     TOCUS1
     C                   Move      SH_TOCUS2     TOCUS2
     C                   Move      SH_TOCUS3     TOCUS3
     C                   Move      SH_TOCUS4     TOCUS4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      TOCUS5 = SH_TOCUS5                                         CSW207
     C                   ENDIF                                                                CSW207
     C                   Move      SH_CUSTTH     CUSTTH
     C                   Move      SH_OINST3     OINST3
     C                   Move      SH_OINST1     OINST1
     C                   Move      SH_ORDITP     ORDITP
     C                   Move      SH_TRNSTP     TRNSTP
     C                   Move      SH_REGRP1     REGRP1
     C                   Move      SH_REGRP2     REGRP2
     C                   Move      SH_REGRP3     REGRP3
     C                   Move      SH_CCTCHG     CCTCHG
     C                   Move      SH_CCTRTE     CCTRTE
     C                   Move      SH_CCTAMT     CCTAMT
     C                   Move      SH_CCTCCY     CCTCCY
     C                   Move      SH_TTVDTE     TTVDTE
     C                   Move      SH_DBTVDT     DBTVDT
     C                   Move      SH_SUMCCT     SUMCCT
     C                   Move      SH_SUMSCG     SUMSCG
     C                   Move      SH_SUMRCH     SUMRCH
     C                   Move      SH_SNDCOR     SNDCOR
     C                   Move      SH_SNDTYP     SNDTYP
     C                   Move      SH_RCVCOR     RCVCOR
     C                   Move      SH_RCVTYP     RCVTYP
     C                   Move      SH_ADNLI1     ADNLI1
     C                   Move      SH_ADNLI2     ADNLI2
     C                   Move      SH_ADNLI3     ADNLI3
     C                   Move      SH_ADNLI4     ADNLI4
     C                   Move      SH_ADNLI5     ADNLI5
     C                   Move      SH_ADNLI6     ADNLI6
     C                   Move      SH_SWPRIO     SWPRIO
     C                   Move      SH_BASTFR     BASTFR
     C                   MOVE      SH_CHMSGR     CHMSGR                         185107
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   EVAL      CCNWRK  = SH_CCNWRK                                        CSW209
     C                   EVAL      CCMTPY  = SH_CCMTPY                                        CSW209
     C                   EVAL      CCVALF  = SH_CCVALF                                        CSW209
     C                   EVAL      CCOMVF  = SH_CCOMVF                                        CSW209
     C                   EVAL      CCOCVF  = SH_CCOCVF                                        CSW209
     C                   ENDIF                                                                CSW209
      *
 
     C     ActionCode    Ifeq      'I'
     C                   Move      UserPrf       INUSER
     C                   Z-add     BJRDNB        INDATE
     C                   Z-add     PSRuntime     INTIME
     C                   Move      UserPrf       SH_INUSER
     C                   Z-add     BJRDNB        SH_INDATE
     C                   Z-add     PSRuntime     SH_INTIME
     C*********          If        DtlInfo = 'Y'                                178384
     C                   Else
     C                   Move      UserPrf       UPDUSR
     C*********          Move      PSDate        UPDDTE                         178384
     C                   Move      PSRunDate     DateIn                         178384
     C                   CALLB     'ZDATE1'                                     178384
     C                   PARM                    DateIn                         178384
     C                   PARM      *ZEROS        DaynoOut                       178384
     C                   PARM      'M'           DatFmt                         178384
     C                   PARM      *BLANKS       ErrorFlag                      178384
                                                                                178384
     C                   Z-ADD     DaynoOut      Upddte                         178384
     C                   Move      PSRuntime     UPDTIM
      *                                                                         178384
     C                   Move      UserPrf       SH_UPDUSR                      178384
     C                   Move      PSRunDate     DateIn                         178384
     C                   CALLB     'ZDATE1'                                     178384
     C                   PARM                    DateIn                         178384
     C                   PARM      *ZEROS        DaynoOut                       178384
     C                   PARM      'M'           DatFmt                         178384
     C                   PARM      *BLANKS       ErrorFlag                      178384
     C                   Z-ADD     DaynoOut      SH_Upddte                      178384
      *                                                                         178384
     C                   Move      PSRuntime     SH_UPDTIM                      178384
     C**********         Endif                                                  178384
     C                   Endif
      *
     C                   If        ActionCode = 'D' and HdrInfo = 'N'
     C                   Eval      CCTAMT = CCTAMT - SD_CCTAMT
     C                   Eval      SUMCCT = SUMCCT - SD_CCTAMT
      *                                                                                       CSW201
      ** If enhancement 'SWIFT 2001 Standard update' is installed                             CSW201
      ** Calculate: Sum of senders charges = Sum of senders charges -                         CSW201
      ** the last non zero senders charges found.  Otherwise, do the                          CSW201
      ** original processing.                                                                 CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   SELECT                                                               CSW201
     C                   WHEN      SD_SDCCY5 <> *BLANKS                                       CSW201
     C                   EVAL      SUMSCG = SUMSCG - SD_SDCHG5                                CSW201
                                                                                              CSW201
     C                   WHEN      SD_SDCCY4 <> *BLANKS                                       CSW201
     C                   EVAL      SUMSCG = SUMSCG - SD_SDCHG4                                CSW201
                                                                                              CSW201
     C                   WHEN      SD_SDCCY3 <> *BLANKS                                       CSW201
     C                   EVAL      SUMSCG = SUMSCG - SD_SDCHG3                                CSW201
                                                                                              CSW201
     C                   WHEN      SD_SDCCY2 <> *BLANKS                                       CSW201
     C                   EVAL      SUMSCG = SUMSCG - SD_SDCHG2                                CSW201
                                                                                              CSW201
     C                   OTHER                                                                CSW201
     C                   EVAL      SUMSCG = SUMSCG - SD_SNDCHG                                CSW201
     C                   ENDSL                                                                CSW201
                                                                                              CSW201
     C                   ELSE                                                                 CSW201
     C                   Eval      SUMSCG = SUMSCG - SD_SNDCHG
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   Eval      SUMRCH = SUMRCH - SD_RCVCHG
     C                   Endif
 
      **  Unwind subroutine stack name
     C     SrMapH_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrMapD - MAP FIELDS OF THE DETAIL RECORD                           *
     C*                                                                    *
     C**********************************************************************
     C     SrMapD        BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrMapD'      SrStack(q)
 
     C     ActionCode    Ifeq      'I'
     C                   Clear                   FT102DD0
 
     C                   Move      SH_CCTID      CCTID
      *                                                                         178751
      ** Retrieve sequence number                                               178751
      *                                                                         178751
     C                   Exsr      RtvSeq                                       178751
     C                   Movel     SEQNO         TSEQNO                         178751
      *                                                                         178751
      ** If transaction reference is blank, default it to CCTID + seqno         178751
      *                                                                         178751
     C                   If        SD_TRNSID = *blanks                          178751
     C                   Movel     CCTID         CCTID13                        178751
     C     CCTID13       Cat       SEQNO         SD_TRNSID                      178751
     C                   Endif                                                  178751
      *                                                                         178751
     C                   Move      SD_TRNSID     TRNSID
 
     C                   Endif
 
      *
     C                   Move      SD_CCTAMT     CCTAMT
     C                   Move      SD_CCTCCY     CCTCCY
     C                   Move      SD_CRDVDT     CRDVDT
     C                   Move      SD_ORDCU1     ORDCU1
     C                   Move      SD_ORDCU2     ORDCU2
     C                   Move      SD_ORDCU3     ORDCU3
     C                   Move      SD_ORDCU4     ORDCU4
     C                   If        CSW207 = 'Y'                                               CSW207
     C                   EVAL      ORDCU5 = SD_ORDCU5                                         CSW207
     C                   Endif                                                                CSW207
     C                   Move      SD_CUSTTD     CUSTTD
     C                   Move      SD_ORDI35     ORDI35
     C                   Move      SD_ORDI11     ORDI11
     C                   Move      SD_ORDITP     ORDITP
     C                   Move      SD_ACCI35     ACCI35
     C                   Move      SD_ACCI11     ACCI11
     C                   Move      SD_AWITP      AWITP
     C                   Move      SD_BENF1      BENF1
     C                   Move      SD_BENF2      BENF2
     C                   Move      SD_BENF3      BENF3
     C                   Move      SD_BENF4      BENF4
     C                   Move      SD_BENF5      BENF5
     C                   Move      SD_BENTTD     BENTTD
     C                   Move      SD_REMI1      REMI1
     C                   Move      SD_REMI2      REMI2
     C                   Move      SD_REMI3      REMI3
     C                   Move      SD_REMI4      REMI4
     C                   Move      SD_CCTTYC     CCTTYC
     C                   Move      SD_REGRP1     REGRP1
     C                   Move      SD_REGRP2     REGRP2
     C                   Move      SD_REGRP3     REGRP3
     C                   Move      SD_PAYCCY     PAYCCY
     C                   Move      SD_PAYAMT     PAYAMT
     C                   Move      SD_CCYCHG     CCYCHG
     C                   Move      SD_SNDCHG     SNDCHG
     C                   Move      SD_SNDCCY     SNDCCY
     C                   Move      SD_SNDOCG     SNDOCG
     C                   Move      SD_SNDCTF     SNDCTF
      *                                                                                       CSW201
      ** Setup CSW201 fields for update.                                                      CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   Z-ADD     SD_SDCHG2     SDCHG2                                       CSW201
     C                   MOVE      SD_SDCCY2     SDCCY2                                       CSW201
     C                   Z-ADD     SD_SDOCG2     SDOCG2                                       CSW201
     C                   Z-ADD     SD_SDCTF2     SDCTF2                                       CSW201
     C                   Z-ADD     SD_SDCHG3     SDCHG3                                       CSW201
     C                   MOVE      SD_SDCCY3     SDCCY3                                       CSW201
     C                   Z-ADD     SD_SDOCG3     SDOCG3                                       CSW201
     C                   Z-ADD     SD_SDCTF3     SDCTF3                                       CSW201
     C                   Z-ADD     SD_SDCHG4     SDCHG4                                       CSW201
     C                   MOVE      SD_SDCCY4     SDCCY4                                       CSW201
     C                   Z-ADD     SD_SDOCG4     SDOCG4                                       CSW201
     C                   Z-ADD     SD_SDCTF4     SDCTF4                                       CSW201
     C                   Z-ADD     SD_SDCHG5     SDCHG5                                       CSW201
     C                   MOVE      SD_SDCCY5     SDCCY5                                       CSW201
     C                   Z-ADD     SD_SDOCG5     SDOCG5                                       CSW201
     C                   Z-ADD     SD_SDCTF5     SDCTF5                                       CSW201
     C                   ELSE                                                                 CSW201
     C                   Z-ADD     *ZEROS        SDCHG2                                       CSW201
     C                   MOVE      *BLANKS       SDCCY2                                       CSW201
     C                   Z-ADD     *ZEROS        SDOCG2                                       CSW201
     C                   Z-ADD     *ZEROS        SDCTF2                                       CSW201
     C                   Z-ADD     *ZEROS        SDCHG3                                       CSW201
     C                   MOVE      *BLANKS       SDCCY3                                       CSW201
     C                   Z-ADD     *ZEROS        SDOCG3                                       CSW201
     C                   Z-ADD     *ZEROS        SDCTF3                                       CSW201
     C                   Z-ADD     *ZEROS        SDCHG4                                       CSW201
     C                   MOVE      *BLANKS       SDCCY4                                       CSW201
     C                   Z-ADD     *ZEROS        SDOCG4                                       CSW201
     C                   Z-ADD     *ZEROS        SDCTF4                                       CSW201
     C                   Z-ADD     *ZEROS        SDCHG5                                       CSW201
     C                   MOVE      *BLANKS       SDCCY5                                       CSW201
     C                   Z-ADD     *ZEROS        SDOCG5                                       CSW201
     C                   Z-ADD     *ZEROS        SDCTF5                                       CSW201
     C                   ENDIF                                                                CSW201
     C                   Move      SD_RCVCHG     RCVCHG
     C                   Move      SD_RCVCCY     RCVCCY
     C                   Move      SD_RCVOCG     RCVOCG
     C                   Move      SD_RCVCTF     RCVCTF
     C                   Move      SD_CHGACC     CHGACC
     C                   Move      SD_XRATE      XRATE
     C                   Move      SD_GOPFLG     GOPFLG
     C                   Move      SD_XRATEO     XRATEO
     C                   Move      SD_TFTRNT     TFTRNT
     C                   Move      SD_TFTREF     TFTREF
     C                   Move      SD_CQIN       CQIN
     C                   Move      SD_CHQNUM     CHQNUM
     C                   Move      SD_INUSER     INUSER
     C                   Move      SD_INDATE     INDATE
     C                   Move      SD_INTIME     INTIME
     C                   Move      SD_UPDUSR     UPDUSR
     C                   Move      SD_UPDDTE     UPDDTE
     C                   Move      SD_UPDTIM     UPDTIM
     C                   Move      SD_CCTMSG     CCTMSG
     C                   Move      SD_CCTMSQ     CCTMSQ
 
      ** Retrieve the spot rate of the PAY currency
     C                   If        SD_PAYCCY <> *Blanks
     C                   Move      SD_PAYCCY     CcyIn
     C                   Exsr      RtvCcy
     C                   Z-add     A6SPRT        PYBCQS
     C                   Endif
 
      ** Retrieve the spot rate of the Transfer currency
     C                   If        SD_CCTCCY <> *Blanks
     C                   Move      SD_CCTCCY     CcyIn
     C                   Exsr      RtvCcy
     C                   Z-add     A6SPRT        TFBCQS
     C                   Endif
 
      *
     C     ActionCode    Ifeq      'I'
     C                   Move      UserPrf       INUSER
     C                   Z-add     BJRDNB        INDATE
     C                   Z-add     PSRuntime     INTIME
     C                   Else
     C                   Move      UserPrf       UPDUSR
     C*********          Move      PSDate        UPDDTE                         178384
     C                   Move      PSRunDate     DateIn                         178384
     C                   CALLB     'ZDATE1'                                     178384
     C                   PARM                    DateIn                         178384
     C                   PARM      *ZEROS        DaynoOut                       178384
     C                   PARM      'M'           DatFmt                         178384
     C                   PARM      *BLANKS       ErrorFlag                      178384
     C                   Z-ADD     DaynoOut      Upddte                         178384
     C                   Move      PSRuntime     UPDTIM
     C                   Endif
 
      **  Unwind subroutine stack name
     C     SrMapD_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* RtvTrn - RETRIEVE TRANSACTION NUMBER                               *
     C*                                                                    *
     C**********************************************************************
     C     RtvTrn        BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtvTrn'      SrStack(q)
 
      ** Inputs
      ** -------
      ** Transaction Type
     C     *Like         Define    SH_CCTTYP     Trns_Type
      ** Outputs
      ** -------
      ** Transaction Number
      **                                         P_Ref_Ds
     C*******************Movel     *BLANK        P_Ref_Ds         15       177677
 
     C                   Callb     'FTM1012GN'                            90
     C                   Parm                    RetCodeIn
     C                   Parm                    Trns_Type
     C*******************Parm                    P_Ref_Ds                       177677
     C                   Parm                    P_Ref_Ds         15            177677
 
     C     *IN90         Ifeq      '1'
     C     RetCodeIn     Orne      *BLANK
      ** *ERROR
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FTM1012GN'   DBFILE
     C                   Z-add     08            DBASE
     C                   Movel     '*CALL'       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Movel     *BLANK        Trns_Type
 
      **  Unwind subroutine stack name
     C     RtvTrn_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
                                                                                178751
      /EJECT                                                                    178751
     C**********************************************************************    178751
     C*                                                                    *    178751
     C* RtvSeq - RETRIEVE SEQUENCE NUMBER                                  *    178751
     C*                                                                    *    178751
     C**********************************************************************    178751
     C     RtvSeq        BegSr                                                  178751
                                                                                178751
      **  Set up subroutine stack name                                          178751
     C                   Add       1             q                              178751
     C                   Movea     'RtvSeq'      SrStack(q)                     178751
      *                                                                         178751
      ** Retrieve sequence number                                               178751
      *                                                                         178751
     C                   Callb     'FTM1013GN'                          90      178751
     C                   Parm                    RetCodeIn                      178751
     C                   Parm      CCTTYP        TrnType                        178751
     C                   Parm      CCTID         TrnId                          178751
     C                   Parm                    SeqNo                          178751
                                                                                178751
     C     *IN90         Ifeq      *On                                          178751
      ** *ERROR                                                                 178751
     C                   Movel     '*ERROR'      RetCodeIn                      178751
     C                   Movel     'FTM102UPD'   DBPGM                          178751
     C                   Movel     'FTM1013GN'   DBFILE                         178751
     C                   Z-add     29            DBASE                          178751
     C                   Movel     '*CALL'       DBKEY                          178751
     C                   Movel     SrStack(q)    DBPROC                         178751
     C                   Exsr      *PSSR                                        178751
     C                   Endif                                                  178751
                                                                                178751
      **  Unwind subroutine stack name                                          178751
     C     RtvSeq_End    Tag                                                    178751
     C                   Movea     *BLANKS       SrStack(q)                     178751
     C                   Sub       1             q                              178751
                                                                                178751
     C                   EndSr                                                  178751
     C**********************************************************************    178751
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* RtvJob  - RETRIEVE JOB INFORMATION                                 *
     C*                                                                    *
     C**********************************************************************
     C     RtvJob        BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtvJob'      SrStack(q)
 
      ** Outputs
      ** -------
      ** User profile
     C     *Like         Define    INUSER        UserPrf
      ** Response Mode (S=Submitted, A=Interactive)
      **                                         RespMode
 
     C                   Movel     *BLANK        UserPrf
     C                   Movel     *BLANK        RespMode          1
 
     C                   Callb     'ZACRTVJOBA'                         90
     C                   Parm                    PSJobName
     C                   Parm                    PSUser
     C                   Parm                    PSJobNo
     C                   Parm                    JobType           5
     C     *IN90         Ifeq      '1'
      ** *ERROR
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'ZACRTVJOBA'  DBFILE
     C                   Z-add     09            DBASE
     C                   Movel     '*CALL'       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
     C     JobType       Ifeq      'BATCH'
     C                   Movel(P)  '*STP'        UserPrf
     C                   Movel(P)  'S'           RespMode
     C                   Else
     C                   Movel(P)  PSUser        UserPrf
     C                   Movel(P)  'A'           RespMode
     C                   Endif
                                                                                CAP084
      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   MOVEL     USER          USERPRF                        CAP084
     C                   Movel(P)  'A'           RespMode                       CAP084
     C                   ENDIF                                                  CAP084
 
      **  Unwind subroutine stack name
     C     RtvJob_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* RtvCcy - RETRIEVE CURRENCY                                         *
     C*                                                                    *
     C**********************************************************************
     C     RtvCcy        BegSr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtvCcy'      SrStack(q)
 
      ** Inputs
      ** -------
      ** Currency
     C     *Like         Define    A6CYCD        CcyIn
      ** Outputs
      ** -------
      ** Fields of SDCURRPD
 
     C                   Clear                   SDCURR
 
     C                   Callb     'AOCURRR0'                           90
     C                   Parm      '*DBERR '     RtnCod            7
     C                   Parm      '*KEY   '     Option            7
     C                   Parm                    CcyIn
     C*****SDCURR        Parm      SDCURR        DSFDY                                        220004
     C     SDCURR        Parm      SDCURR        DSSDY                                        220004
 
     C     RtnCod        Ifne      *BLANK
     C     *IN90         Oreq      '1'
      ** *ERROR
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'AOCURRR0'    DBFILE
     C                   Z-add     10            DBASE
     C                   Movel     '*CALL'       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
      ** Reset input variables
     C                   Movel     *BLANK        CcyIn
 
      **  Unwind subroutine stack name
     C     RtvCcy_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* HdrNfnd - CHECK HEADER NOT FOUND                                   *
     C*                                                                    *
     C**********************************************************************
     C     HdrNfnd       BegSr
 
      ** Inputs
      ** -------
      ** File Reference
      **                                         FileRef
      ** SWIFT identifier
      **                                         SwiftID
      ** Dump if not found
     C     *Like         Define    DumpReq       NfndDump
      ** Outputs
      ** -------
      ** Header found
      **                                         HdrFound
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'HdrNfnd'     SrStack(q)
 
     C                   Movel     'N'           HdrFound
 
     C     KCctHdr7      Klist
     C                   Kfld                    SwiftID
     C                   Kfld                    FileRef
 
     C     KCctHdr7      Setll     FT102HL7                               90
     C     *IN90         Ifeq      '1'
     C                   Movel     'Y'           HdrFound
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0003'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C     NfndDump      Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102HL7'    DBFILE
     C                   Z-add     11            DBASE
     C                   Movel     FileRef       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
 
      ** Reset input variables
     C                   Movel     *BLANK        NfndDump
     C                   Movel     *BLANK        FileRef
     C                   Movel     *BLANK        SwiftID
 
      **  Unwind subroutine stack name
     C     HdrNfn_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* RtvHdr - RETRIEVE HEADER (UNLOCK In option)                        *
     C*                                                                    *
     C**********************************************************************
     C     RtvHdr        BegSr
 
      ** Inputs
      ** -------
      ** File Reference
     C     *Like         Define    SH_FILREF     FileRef
      ** Swift identifier
     C     *Like         Define    SH_STID       SwiftID
      ** Lock/Unlock indicator
      **                                         Unlocked
      ** Dump if not found
     C     *Like         Define    DumpReq       RtvDump
      ** Outputs
      ** -------
      ** Fields of FT102HPD
      ** Header found
      **                                         HdrFound
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtvHdr'      SrStack(q)
 
     C                   Clear                   FT102HD7
     C                   Movel     'Y'           HdrFound          1
 
     C     KCctHdr7      Setll     FT102HL7                               90
     C     *IN90         Ifeq      '0'
     C                   Movel     'N'           HdrFound
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0001'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C     RtvDump       Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102HL7'    DBFILE
     C                   Z-add     12            DBASE
     C                   Movel     FileRef       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Else
 
     C     KCctHdr7      Reade     FT102HL7                             9190
     C     Unlocked      Ifeq      'Y'
     C                   Unlock    FT102HL7
     C                   Endif
 
     C     *IN90         Ifeq      '1'
     C     *IN91         Oreq      '1'
     C                   Movel     'N'           DtlFound
     C     *IN90         Ifeq      '1'
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0001'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C                   Endif
     C     *IN91         Ifeq      '1'
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0002'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C                   Endif
     C     RtvDump       Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102HL7'    DBFILE
     C                   Z-add     13            DBASE
     C                   Movel     FileRef       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
     C                   Endif
 
      ** Reset input variables
     C                   Movel     *BLANK        Unlocked
     C                   Movel     *BLANK        FileRef
     C                   Movel     *BLANK        SwiftID
     C                   Movel     *BLANK        RtvDump
 
      **  Unwind subroutine stack name
     C     RtvHdr_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* RtvHdr2 - RETRIEVE HEADER (UNLOCK In option)                       *
     C*                                                                    *
     C**********************************************************************
     C     RtvHdr2       BegSr
 
      ** Inputs
      ** -------
      ** Request for Transfert ID
     C     *Like         Define    SH_CCTID      Cct_ID
      ** Lock/Unlock indicator
      **                                         Unlocked
      ** Dump if not found
      **                                         RtvDump
      ** Outputs
      ** -------
      ** Fields of FT102HPD
      ** Header found
      **                                         HdrFound
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtvHdr2'     SrStack(q)
 
     C                   Clear                   FT102HD0
     C                   Movel     'Y'           HdrFound          1
 
     C     Cct_ID        Setll     FT102HL3                               90
     C     *IN90         Ifeq      '0'
     C                   Movel     'N'           HdrFound
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0001'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C     RtvDump       Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102HL3'    DBFILE
     C                   Z-add     14            DBASE
     C                   Movel     Cct_ID        DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
     C                   Else
     C     Cct_ID        Reade     FT102HL3                             9190
     C     Unlocked      Ifeq      'Y'
     C                   Unlock    FT102HL3
     C                   Endif
 
     C     *IN90         Ifeq      '1'
     C     *IN91         Oreq      '1'
     C                   Movel     'N'           HdrFound
     C     *IN90         Ifeq      '1'
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0001'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C                   Endif
     C     *IN91         Ifeq      '1'
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0002'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C                   Endif
     C     RtvDump       Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102HL3'    DBFILE
     C                   Z-add     15            DBASE
     C                   Movel     FileRef       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
     C                   Endif
 
      ** Reset input variables
     C                   Movel     *BLANK        Unlocked
     C                   Movel     *BLANK        Cct_ID
 
      **  Unwind subroutine stack name
     C     RtvHd2_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* RtvDtl - RETRIEVE DETAIL (UNLOCK In option)                        *
     C*                                                                    *
     C**********************************************************************
     C     RtvDtl        BegSr
 
      ** Inputs
      ** -------
      ** CCT identifier
      **                                         Cct_ID
      ** Transaction ID
     C     *Like         Define    SD_TRNSID     TransID
      ** Lock/Unlock indicator
      **                                         Unlocked
      ** Dump if not found
      **                                         RtvDump
      ** Outputs
      ** -------
      ** Fields of FT102DPD
      ** Detail found
      **                                         DtlFound
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtvDtl'      SrStack(q)
 
     C                   Clear                   FT102DD0
     C                   Movel     'Y'           DtlFound
 
     C     KCctDtl1      Setll     FT102DL0                               90
     C     *IN90         Ifeq      '0'
     C                   Movel     'N'           DtlFound
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0001'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C     RtvDump       Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102DL0'    DBFILE
     C                   Z-add     16            DBASE
     C                   Movel     TransID       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Else
 
     C     KCctDtl1      Reade     FT102DL0                             9190
     C     Unlocked      Ifeq      'Y'
     C                   Unlock    FT102DL0
     C                   Endif
 
     C     *IN90         Ifeq      '1'
     C     *IN91         Oreq      '1'
     C                   Movel     'N'           DtlFound
     C     *IN90         Ifeq      '1'
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0001'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C                   Endif
     C     *IN91         Ifeq      '1'
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0002'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C                   Endif
     C     RtvDump       Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102DL0'    DBFILE
     C                   Z-add     17            DBASE
     C                   Movel     TransID       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
     C                   Endif
 
      ** Reset input variables
     C                   Movel     *BLANK        Unlocked          1
     C                   Movel     *BLANK        CCT_ID
     C                   Movel     *BLANK        TransID
 
      **  Unwind subroutine stack name
     C     RtvDtl_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* RtvDtl2 - RETRIEVE DETAIL (UNLOCK In option)                       *
     C*                                                                    *
     C**********************************************************************
     C     RtvDtl2       BegSr
 
      ** Inputs
      ** -------
      ** Request for Transfert ID
      **                                         CCT_ID
      ** Lock/Unlock indicator
      **                                         Unlocked
      ** Dump if not found
      **                                         RtvDump
      ** Outputs
      ** -------
      ** Fields of FT102DPD
      ** Detail found
      **                                         DtlFound
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtvDtl2'     SrStack(q)
 
     C                   Clear                   FT102DD0
     C                   Movel     'Y'           DtlFound          1
 
     C     CCT_ID        Setll     FT102DL0                               90
     C     *IN90         Ifeq      '0'
     C                   Movel     'N'           DtlFound
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0001'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C     RtvDump       Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102DL0'    DBFILE
     C                   Z-add     18            DBASE
     C                   Movel     CCT_ID        DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Else
 
     C     CCT_ID        Reade     FT102DL0                             9190
     C     Unlocked      Ifeq      'Y'
     C                   Unlock    FT102DL0
     C                   Endif
 
     C     *IN90         Ifeq      '1'
     C     *IN91         Oreq      '1'
     C                   Movel     'N'           DtlFound
     C     *IN90         Ifeq      '1'
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0001'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C                   Endif
     C     *IN91         Ifeq      '1'
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0002'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C                   Endif
     C     RtvDump       Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102DL0'    DBFILE
     C                   Z-add     19            DBASE
     C                   Movel     CCT_ID        DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
     C                   Endif
 
      ** Reset input variables
     C                   Movel     *BLANK        Unlocked
     C                   Movel     *BLANK        CCT_ID
     C                   Movel     *BLANK        RtvDump
 
      **  Unwind subroutine stack name
     C     RtvDt2_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* DtlNfnd - CHECK DETAIL NOT FOUND                                   *
     C*                                                                    *
     C**********************************************************************
     C     DtlNfnd       BegSr
 
      ** Inputs
      ** -------
      ** CCT identifier
      **                                         CCT_ID
      ** Transaction ID
      **                                         TransID
      ** Dump if not found
      **                                         NfndDump
      ** Outputs
      ** -------
      ** Detail found
      **                                         DtlFound
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'DtlNfnd'     SrStack(q)
 
     C                   Movel     'N'           DtlFound
     C     KCCTDtl1      Klist
     C                   Kfld                    CCT_ID
     C                   Kfld                    TransID
 
     C     KCCTDtl1      Setll     FT102DL0                               90
     C     *IN90         Ifeq      '1'
     C                   Movel     'Y'           DtlFound
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0003'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C     NfndDump      Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102DL0'    DBFILE
     C                   Z-add     20            DBASE
     C                   Movel     TransID       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
 
      ** Reset input variables
     C                   Movel     *BLANK        NfndDump
     C                   Movel     *BLANK        CCT_ID
     C                   Movel     *BLANK        TransID
 
      **  Unwind subroutine stack name
     C     DtlNfn_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* WriteH - WRITE HEADER RECORD                                       *
     C*                                                                    *
     C**********************************************************************
     C     WriteH        BegSr
 
      ** Inputs
      ** -------
      ** *NONE
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'WriteH'      SrStack(q)
                                                                                              CSD015
      ** If Function Code is being monitored by Compliance Watch                              CSD015
      ** and Watch Lict Checking Applied                                                      CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'N' OR LIBR = S1MAIN                              CSD015
                                                                                              CSD015
     C                   EVAL      KIden = SH_CCTID                                           CSD015
     C                   EVAL      KBranch = SH_BRCA                                          CSD015
     C                   EVAL      W3UNCF = *Blanks                                           CSD015
                                                                                              CSD015
     C     KFuncKey      CHAIN     SDCWHTL1                           48                      CSD015
                                                                                              CSD015
     C                   IF        (*IN48 = *OFF AND W3UNCF = 'Y') OR                         CSD015
     C                             (SH_SINST <> *BLANKS OR SH_CCTDST <> *BLANKS               CSD015
     C                             OR SH_TOCUS1 <> *BLANKS OR                                 CSD015
     C                             SH_TOCUS2 <> *BLANKS OR SH_TOCUS3 <> *BLANKS               CSD015
     C                             OR SH_TOCUS4 <> *BLANKS OR                                 CSD015
     C                             SH_OINST1 <> *BLANKS OR SH_OINST3 <> *BLANKS               CSD015
     C                             OR SH_SNDCOR <> *BLANKS OR                                 CSD015
     C                             SH_RCVCOR <> *BLANKS)                                      CSD015
     C                             OR (CSW207 = 'Y' AND SH_TOCUS5 <> *BLANKS)                 CSW207
                                                                                              CSD015
     C                   EVAL      WWrite = 'Y'                                               CSD015
     C                   EXSR      Sr2ndHParm                                                 CSD015
     C                   IF        PWatchString <> *BLANKS                                    CSD015
     C                   EXSR      Sr1stParm                                                  CSD015
     C                   EXSR      SrCallWatch                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
 
     C                   Write     FT102HD7                             90
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102HL7'    DBFILE
     C                   Z-add     21            DBASE
     C                   Movel     '*WRITE'      DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
      **  Unwind subroutine stack name
     C     WriteH_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* WriteD - WRITE DETAIL RECORD                                       *
     C*                                                                    *
     C**********************************************************************
     C     WriteD        BegSr
 
      ** Inputs
      ** -------
      ** *NONE
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'WriteD'      SrStack(q)
                                                                                              CSD015
      ** If Function Code is being monitored by Compliance Watch                              CSD015
      ** and Watch Lict Checking Applied                                                      CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'N' OR LIBR = S1MAIN                              CSD015
                                                                                              CSD015
     C                   EVAL      KIden = SH_CCTID                                           CSD015
     C                   EVAL      KBranch = SH_BRCA                                          CSD015
     C                   EVAL      W3UNCF = *BLANKS                                           CSD015
                                                                                              CSD015
     C     KFuncKey      CHAIN     SDCWHTL1                           48                      CSD015
                                                                                              CSD015
     C                   IF        (*IN48 = *OFF AND W3UNCF = 'Y') OR                         CSD015
     C                             (SH_SINST <> *BLANKS OR SH_CCTDST <> *BLANKS               CSD015
     C                             OR SH_TOCUS1 <> *BLANKS OR                                 CSD015
     C                             SH_TOCUS2 <> *BLANKS OR SH_TOCUS3 <> *BLANKS               CSD015
     C                             OR SH_TOCUS4 <> *BLANKS OR                                 CSD015
     C                             SH_OINST1 <> *BLANKS OR SH_OINST3 <> *BLANKS               CSD015
     C                             OR SH_SNDCOR <> *BLANKS OR                                 CSD015
     C                             SH_RCVCOR <> *BLANKS OR SD_ORDCU1 <> *BLANKS               CSD015
     C                             OR SD_ORDCU2 <> *BLANKS OR                                 CSD015
     C                             SD_ORDCU3 <> *BLANKS OR SD_ORDCU4 <> *BLANKS               CSD015
     C                             OR SD_ORDI11 <> *BLANKS OR                                 CSD015
     C                             SD_ORDI35 <> *BLANKS OR SD_ACCI11 <> *BLANKS               CSD015
     C                             OR SD_ACCI35 <> *BLANKS OR                                 CSD015
     C                             SD_BENF1 <> *BLANKS OR SD_BENF2 <> *BLANKS                 CSD015
     C                             OR SD_BENF3 <> *BLANKS OR SD_BENF3 <> *BLANKS              CSD015
     C                             OR SD_BENF4 <> *BLANKS OR SD_BENF5 <> *BLANKS              CSD015
     C                             OR SD_REMI1 <> *BLANKS OR SD_REMI2 <> *BLANKS              CSD015
     C                             OR SD_REMI3 <> *BLANKS OR                                  CSD015
     C                             SD_REMI4 <> *BLANKS)                                       CSD015
     C                             OR (CSW207 = 'Y' AND                                       CSW207
     C                                (SH_TOCUS5 <> *BLANKS OR                                CSW207
     C                                 SD_ORDCU5 <> *BLANKS))                                 CSW207
                                                                                              CSD015
     C                   EVAL      WWrite = 'Y'                                               CSD015
     C                   EXSR      Sr2ndDParm                                                 CSD015
                                                                                              CSD015
     C                   IF        PWatchString <> *BLANKS                                    CSD015
     C                   EXSR      Sr1stParm                                                  CSD015
     C                   EXSR      SrCallWatch                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check other detail records in RFT Detail File                                        CSD015
                                                                                              CSD015
     C                   IF        W3UNCF = 'Y'                                               CSD015
     C     SH_CCTID      SETLL     FT102DL2                               49                  CSD015
     C     SH_CCTID      READE     FT102DL2                               49                  CSD015
     C                   DOW       *IN49 = *OFF                                               CSD015
     C                   EXSR      Sr2ndD2Parm                                                CSD015
     C                   EXSR      Sr2ndH2Parm                                                CSD015
                                                                                              CSD015
     C                   IF        PWatchString <> *BLANKS                                    CSD015
     C                   EXSR      Sr1stParm                                                  CSD015
     C                   EXSR      SrCallWatch                                                CSD015
     C                   ENDIF                                                                CSD015
     C     SH_CCTID      READE     FT102DL2                               49                  CSD015
     C                   ENDDO                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
 
     C                   Write     FT102DD0                             90
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102DL0'    DBFILE
     C                   Z-add     22            DBASE
     C                   Movel     '*WRITE'      DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
      **  Unwind subroutine stack name
     C     WriteD_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* UpdateH - UPDATE HEADER RECORD                                     *
     C*                                                                    *
     C**********************************************************************
     C     UpdateH       BegSr
 
      ** Inputs
      ** -------
      ** *NONE
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'UpdateH'     SrStack(q)
 
     C                   Update    FT102HD7                             90
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102HL7'    DBFILE
     C                   Z-add     23            DBASE
     C                   Movel     '*UPDATE'     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
      **  Unwind subroutine stack name
     C     UpdatH_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* UpdateD - UPDATE DETAIL RECORD                                     *
     C*                                                                    *
     C**********************************************************************
     C     UpdateD       BegSr
 
      ** Inputs
      ** -------
      ** *NONE
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'UpdateD'     SrStack(q)
 
     C                   Update    FT102DD0                             90
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102DL0'    DBFILE
     C                   Z-add     24            DBASE
     C                   Movel     '*UPDATE'     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
      **  Unwind subroutine stack name
     C     UpdatD_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* DeleteD - DELETE DETAIL RECORD                                     *
     C*                                                                    *
     C**********************************************************************
     C     DeleteD       BegSr
 
      ** Inputs
      ** -------
      ** *NONE
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'DeleteD'     SrStack(q)
 
     C                   Delete    FT102DL0                             90
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'FT102DL0'    DBFILE
     C                   Z-add     05            DBASE
     C                   Movel     '*DELETE'     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
      **  Unwind subroutine stack name
     C     DeletD_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  SrFtst - UPDATE INCOMING MESSAGE FT TRANSACTION STATUS            *
      *             FILE RECORD                                            *
      *                                                                    *
      **********************************************************************
     C     SrFtst        Begsr
      ** Inputs
      ** -------
      ** Payment type
     C     *Like         Define    CCTTYP        PayType
      ** Message reference
     C     *Like         Define    SD_CCTMSG     MsgRefI
      ** Message part
     C     *Like         Define    SD_CCTMSQ     MsgPartI
      ** Message status
     C     *Like         Define    FTINFG        MsgStat
      ** Message to log
     C     *Like         Define    FTINFG        Message
      ** Funds From
     C     *Like         Define    FTFRGL        FundsFrom
      ** Funds To
     C     *Like         Define    FTTOGL        FundsTo
 
      **  Set up subroutine stack name
     C                   Add       1             Q
     C                   Movea     'SrFtst'      SrStack(q)
 
      **  Fill record format data structure with available data
     C                   Clear                   MEINFT
     C                   Movel     FundsFrom     FTFRGL
     C                   Movel     FundsTo       FTTOGL
     C*******************Z-add     SD_CCTMSG     FTMSGR                   177676
     C*******************Z-add     SD_CCTMSQ     FTKPRT                   177676
     C                   Z-add     MsgRefI       FTMSGR                   177676
     C                   Z-add     MsgPartI      FTKPRT                   177676
      **  If the status of the message is blank we detach
      **  the message from the payment by removing the transaction ID
     C     PayType       Ifeq      'BI'
     C                   Movel     '*FT INC '    TypeTrn
     C                   Movel     MsgStat       FTINFG
     C     MsgStat       Ifne      *BLANK
     C     MsgStat       andne     'MIN0083'
     C                   Movel     BRCA          FTBRCA
     C                   Movel     CCTID         FTIPRF
     C                   Endif
     C                   Else
     C                   Movel     '*FT OUT '    TypeTrn
     C                   Movel     MsgStat       FTOTFG
     C     MsgStat       Ifne      *BLANK
     C     MsgStat       andne     'MIN0083'
     C                   Movel     BRCA          FTBRCA
     C                   Movel     CCTID         FTOPRF
     C                   Endif
     C                   Endif
 
     C                   Call      'ME1050'                             90
     C                   Parm                    TypeTrn           8
     C                   Parm                    CallingPgm
     C                   Parm                    Network
     C                   Parm                    Message
     C                   Parm                    MEINFT
     C                   Parm      *BLANKS       RtnCod
 
     C     *IN90         Ifeq      '1'
     C     RtnCod        Oreq      '*ERROR*'
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0006'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C     DumpReq       Ifeq      'Y'
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'ME1050  '    DBFILE
     C                   Z-add     25            DBASE
     C                   Movel     SD_CCTMSG     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Endif
 
      ** Reset input variables
     C                   Z-add     0             MsgRefI
     C                   Z-add     0             MsgPartI
     C                   Movel     *BLANK        PayType
     C                   Movel     *BLANK        MsgStat
     C                   Movel     *BLANK        Message
     C                   Movel     *BLANK        FundsFrom
     C                   Movel     *BLANK        FundsTo
 
      **  Unwind subroutine stack name
     C     Ftst_End      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             Q
 
     C                   EndSr
     C**********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  RlsMsg - DELETE MESSAGE RESERVED                                  *
      *                                                                    *
      **********************************************************************
     C     RlsMsg        Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             Q
     C                   Movea     'RlsMsg'      SrStack(q)
 
     C                   Z-ADD     SD_CCTMSG     W0MSGREF                       185660
     C                   Z-ADD     SD_CCTMSQ     W0MSGPRT                       185660
 
     C                   Call      'ME1070'                             90
     C                   Parm      '*DEL   '     Request           7
     C*******************Parm                    SD_CCTMSG                      185660
     C*******************Parm                    SD_CCTMSQ                      185660
     C                   Parm                    W0MSGREF                       185660
     C                   Parm                    W0MSGPRT                       185660
     C                   Parm      *BLANKS       MsgOtRf          28
     C                   Parm      *BLANKS       MsgInRf          28
     C                   Parm      *BLANKS       RtnCod
      *
      *  If call to program resulted in an error then end program.
      *
     C     RtnCod        Ifeq      '*ERROR*'
     C     *IN90         Oreq      '1'
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM102UPD'   DBPGM
     C                   Movel     'ME1070  '    DBFILE
     C                   Z-add     26            DBASE
     C                   Movel     SD_CCTMSG     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
 
      **  Unwind subroutine stack name
     C     RMsg_End      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             Q
 
     C                   EndSr
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  Sr1stParm - Setup first parameter for Compliance Engine      *                       CSD015
      *              Program                                          *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     Sr1stParm     BEGSR                                                                CSD015
                                                                                              CSD015
      ** Setup first parameter for Compliance Engine Program                                  CSD015
                                                                                              CSD015
     C                   EVAL      W4ITEM = 'FTCRED'                                          CSD015
     C                   EVAL      W4IDEN = SH_CCTID                                          CSD015
     C                   EVAL      W4BRCH = SH_BRCA                                           CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   EVAL      W4FUNT = 'FT102HPD'                                        CSD015
     C                   EXSR      SrGetCntrPty                                               CSD015
     C                   MOVE      *BLANKS       PInDate                                      CSD015
     C                   EXSR      SrCvtDate                                                  CSD015
     C                   MOVE      PAMDate       W4DDAT                                       CSD015
     C                   MOVE      SH_TTVDTE     PInDate                                      CSD015
     C                   EXSR      SrCvtDate                                                  CSD015
     C                   MOVE      PAMDate       W4VDAT                                       CSD015
     C                   MOVE      *BLANKS       PInDate                                      CSD015
     C                   EXSR      SrCvtDate                                                  CSD015
     C                   MOVE      PAMDate       W4MDAT                                       CSD015
     C                   IF        HdrInfo = 'Y'                                              CSD015
     C                   EVAL      W4DEN1 = SH_CCTCCY                                         CSD015
     C                   MOVE      SH_CCTAMT     PInAmt                                       CSD015
     C                   EVAL      PCurr = W4DEN1                                             CSD015
     C                   EXSR      SrCvtAmt                                                   CSD015
     C                   EVAL      W4AMT1 = PAMFlot                                           CSD015
     C                   EVAL      W4DEN2 = *BLANKS                                           CSD015
     C                   Z-ADD     *ZEROS        W4AMT2                                       CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4DEN1 = SD_CCTCCY                                         CSD015
     C                   MOVE      SD_CCTAMT     PInAmt                                       CSD015
     C                   EVAL      PCurr = W4DEN1                                             CSD015
     C                   EXSR      SrCvtAmt                                                   CSD015
     C                   EVAL      W4AMT1 = PAMFlot                                           CSD015
     C                   EVAL      W4DEN2 = SD_PAYCCY                                         CSD015
     C                   EVAL      PCurr = W4DEN2                                             CSD015
     C                   MOVE      SD_PAYAMT     PInAmt                                       CSD015
     C                   EXSR      SrCvtAmt                                                   CSD015
     C                   EVAL      W4Amt2 = PAMFlot                                           CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  Sr2ndHParm - Setup second Header parameter for Compliance    *                       CSD015
      *               Engine Program                                  *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     Sr2ndHParm    BEGSR                                                                CSD015
                                                                                              CSD015
      ** Setup second Header parameter for Compliance Engine Program                          CSD015
                                                                                              CSD015
     C                   IF        SH_SINST <> *Blanks AND (WWrite = 'Y' OR                   CSD015
     C                             WWrite = 'N' AND                                           CSD015
     C                             (SH_SINST <> SINST OR W3UNCF = 'Y'))                       CSD015
     C                   EVAL      Pinput1 = SH_SINST                                         CSD015
     C                   EVAL      PInCcy = SD_CCTCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(11))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(12))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        SH_CCTDST <> *BLANKS AND (WWrite = 'Y' OR                  CSD015
     C                             WWrite = 'N' AND                                           CSD015
     C                             (SH_CCTDST <> CCTDST OR W3UNCF = 'Y'))                     CSD015
     C                   EVAL      Pinput1 = SH_CCTDST                                        CSD015
     C                   EVAL      PInCcy = SD_CCTCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(13))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(14))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (SH_TOCUS1 <> *BLANKS OR SH_TOCUS2 <> *BLANKS              CSD015
     C                             OR SH_TOCUS3 <> *BLANKS OR                                 CSD015
     C                             SH_TOCUS4 <> *BLANKS)                                      CSD015
     C                             OR (CSW207 = 'Y' AND SH_TOCUS5 <> TOCUS5)                  CSW207
     C                   IF        WWrite = 'Y' OR (WWrite = 'N' AND                          CSD015
     C                             (SH_TOCUS1 <> TOCUS1 OR SH_TOCUS2 <> TOCUS2                CSD015
     C                             OR SH_TOCUS3 <> TOCUS3 OR                                  CSD015
     C                             SH_TOCUS4 <> TOCUS4)) OR W3UNCF = 'Y'                      CSD015
     C                             OR (WWrite = 'N' AND CSW207 = 'Y' AND                      CSW207
     C                                 SH_TOCUS5 <> TOCUS5)                                   CSW207
     C                   EVAL      Pinput1 = SH_TOCUS1                                        CSD015
     C                   EVAL      Pinput2 = SH_TOCUS2                                        CSD015
     C                   EVAL      Pinput3 = SH_TOCUS3                                        CSD015
     C                   EVAL      Pinput4 = SH_TOCUS4                                        CSD015
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      Pinput5 = SH_TOCUS5                                        CSW207
     C                   ENDIF                                                                CSW207
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(1))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(2))                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        SH_OINST1 <> *BLANKS OR SH_OINST3 <> *BLANKS               CSD015
     C                   IF        (WWrite = 'Y' AND SH_OINST1 <> *BLANKS) OR                 CSD015
     C                             (WWrite = 'N' AND SH_OINST1 <> OINST1)                     CSD015
     C                             OR (W3UNCF = 'Y' AND SH_OINST1 <> *BLANKS)                 CSD015
     C                   EVAL      Pinput1 = SH_OINST1                                        CSD015
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(3))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(4))                      CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        (WWrite = 'Y' AND SH_OINST3 <> *BLANKS) OR                 CSD015
     C                             (WWrite = 'N' AND SH_OINST3 <> OINST3)                     CSD015
     C                             OR (W3UNCF = 'Y' AND SH_OINST3 <> *BLANKS)                 CSD015
     C                   EVAL      Pinput1 = SH_OINST3                                        CSD015
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(3))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(4))                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        SH_SNDCOR <> *BLANKS AND (WWrite = 'Y' OR                  CSD015
     C                             WWrite = 'N' AND                                           CSD015
     C                             (SH_SNDCOR <> SNDCOR OR W3UNCF = 'Y'))                     CSD015
     C                   EVAL      Pinput1 = SH_SNDCOR                                        CSD015
     C                   EVAL      PInCcy = SD_CCTCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(15))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(16))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        SH_RCVCOR <> *BLANKS AND (WWrite = 'Y' OR                  CSD015
     C                             WWrite = 'N' AND                                           CSD015
     C                             (SH_RCVCOR <> RCVCOR OR W3UNCF = 'Y'))                     CSD015
     C                   EVAL      Pinput1 = SH_RCVCOR                                        CSD015
     C                   EVAL      PInCcy = SD_CCTCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(17))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(18))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  Sr2ndDParm - Setup second Detail parameter for Compliance    *                       CSD015
      *               Engine Program                                  *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     Sr2ndDParm    BEGSR                                                                CSD015
                                                                                              CSD015
      ** Check Header file                                                                    CSD015
                                                                                              CSD015
     C     KCctID        CHAIN     FT102HLA                             50                    CSD015
     C                   IF        *IN50 = *OFF                                               CSD015
     C                   EVAL      PD_PAYCCY = SD_PAYCCY                                      CSD015
     C                   EVAL      PD_CCTCCY = SD_CCTCCY                                      CSD015
     C                   EXSR      Sr2ndH2Parm                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Setup second Detail parameter for Compliance Engine Program                          CSD015
                                                                                              CSD015
     C                   IF        (SD_ORDCU1 <> *BLANKS OR SD_ORDCU2 <> *BLANKS              CSD015
     C                             OR SD_ORDCU3 <> *BLANKS OR                                 CSD015
     C                             SD_ORDCU4 <> *BLANKS )                                     CSD015
     C                             OR (CSW207 = 'Y' AND SD_ORDCU5 <> *BLANKS)                 CSW207
     C                   IF        WWrite = 'Y' OR (WWrite = 'N' AND                          CSD015
     C                             ((SD_ORDCU1 <> ORDCU1 OR SD_ORDCU2 <> ORDCU2               CSD015
     C                             OR SD_ORDCU3 <> ORDCU3                                     CSD015
     C                             OR SD_ORDCU4 <> ORDCU4) OR W3UNCF = 'Y'))                  CSD015
     C                             OR (WWrite = 'N' AND CSW207 = 'Y' AND                      CSW207
     C                                 SD_ORDCU5 <> ORDCU5)                                   CSW207
     C                   EVAL      Pinput1 = SD_ORDCU1                                        CSD015
     C                   EVAL      Pinput2 = SD_ORDCU2                                        CSD015
     C                   EVAL      Pinput3 = SD_ORDCU3                                        CSD015
     C                   EVAL      Pinput4 = SD_ORDCU4                                        CSD015
     C                   IF        CSW207  = 'Y'                                              CSW207
     C                   EVAL      Pinput5 = SD_ORDCU5                                        CSW207
     C                   ENDIF                                                                CSW207
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(19))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(20))                     CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        SD_ORDI11 <> *BLANKS OR SD_ORDI35 <> *BLANKS               CSD015
     C                   IF        (WWrite = 'Y' AND SD_ORDI11 <> *BLANKS) OR                 CSD015
     C                             (WWrite = 'N' AND SD_ORDI11 <> ORDI11)                     CSD015
     C                             OR (W3UNCF = 'Y' AND SD_ORDI11 <> *BLANKS)                 CSD015
     C                   EVAL      Pinput1 = SD_ORDI11                                        CSD015
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(21))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(22))                     CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        (WWrite = 'Y' AND SD_ORDI35 <> *BLANKS) OR                 CSD015
     C                             (WWrite = 'N' AND SD_ORDI35 <> ORDI35)                     CSD015
     C                             OR (W3UNCF = 'Y'AND SD_ORDI35 <> *BLANKS)                  CSD015
     C                   EVAL      Pinput1 = SD_ORDI35                                        CSD015
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(21))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(22))                     CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        SD_ACCI35 <> *BLANKS OR SD_ACCI35 <> *BLANKS               CSD015
     C                   IF        (WWrite = 'Y' AND SD_ACCI11 <> *BLANKS) OR                 CSD015
     C                             (WWrite = 'N' AND SD_ACCI11 <> ACCI11)                     CSD015
     C                             OR (W3UNCF = 'Y' AND SD_ACCI11 <> *BLANKS)                 CSD015
     C                   EVAL      Pinput1 = SD_ACCI11                                        CSD015
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(5))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))                      CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        (WWrite = 'Y' AND SD_ACCI35 <> *BLANKS) OR                 CSD015
     C                             (WWrite = 'N' AND SD_ACCI35 <> ACCI35)                     CSD015
     C                             OR (W3UNCF = 'Y' AND SD_ACCI35 <> *BLANKS)                 CSD015
     C                   EVAL      Pinput1 = SD_ACCI35                                        CSD015
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(5))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (SD_BENF1 <> *BLANKS OR SD_BENF2 <> *BLANKS                CSD015
     C                             or SD_BENF3 <> *BLANKS OR SD_BENF4 <> *BLANKS              CSD015
     C                             or SD_BENF5 <> *Blanks)                                    CSD015
     C                   IF        WWrite = 'Y' OR (WWrite = 'N' AND                          CSD015
     C                             SD_BENF1 <> BENF1 OR SD_BENF2 <> BENF2                     CSD015
     C                             OR SD_BENF3 <> BENF3 OR SD_BENF4 <> BENF4                  CSD015
     C                             OR SD_BENF5 <> BENF5) OR W3UNCF = 'Y'                      CSD015
     C                   EVAL      Pinput1 = SD_BENF1                                         CSD015
     C                   EVAL      Pinput2 = SD_BENF2                                         CSD015
     C                   EVAL      Pinput3 = SD_BENF3                                         CSD015
     C                   EVAL      Pinput4 = SD_BENF4                                         CSD015
     C                   EVAL      Pinput5 = SD_BENF5                                         CSD015
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(7))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(8))                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (SD_REMI1 <> *BLANKS OR SD_REMI2 <> *BLANKS                CSD015
     C                             OR SD_REMI3 <> *BLANKS                                     CSD015
     C                             OR SD_REMI4 <> *BLANKS)                                    CSD015
     C                   IF        WWrite = 'Y' OR (WWrite = 'N' AND                          CSD015
     C                             SD_REMI1 <> REMI1 OR SD_REMI2 <> REMI2                     CSD015
     C                             OR SD_REMI3 <> REMI3 OR SD_REMI4 <> REMI4)                 CSD015
     C                             OR W3UNCF = 'Y'                                            CSD015
     C                   EVAL      Pinput1 = SD_REMI1                                         CSD015
     C                   EVAL      Pinput2 = SD_REMI2                                         CSD015
     C                   EVAL      Pinput3 = SD_REMI3                                         CSD015
     C                   EVAL      Pinput4 = SD_REMI4                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(9))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(10))                     CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  Sr2ndH2Parm - Setup second Header parameter for Compliance   *                       CSD015
      *                Engine Program                                 *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     Sr2ndH2Parm   BEGSR                                                                CSD015
                                                                                              CSD015
      ** Setup second Header parameter for Compliance Engine Program                          CSD015
                                                                                              CSD015
     C                   IF        PH_SINST <> *BLANKS                                        CSD015
     C                   EVAL      Pinput1 = PH_SINST                                         CSD015
     C                   EVAL      PInCcy = PD_CCTCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(11))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(12))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PH_CCTDST <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PH_CCTDST                                        CSD015
     C                   EVAL      PInCcy = PD_CCTCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(13))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(14))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (PH_TOCUS1 <> *BLANKS OR PH_TOCUS2 <> *BLANKS              CSD015
     C                             OR PH_TOCUS3 <> *BLANKS OR                                 CSD015
     C                             PH_TOCUS4 <> *BLANKS)                                      CSD015
     C                             OR (CSW207 = 'Y' AND PH_TOCUS5 <> *BLANKS)                 CSW207
     C                   EVAL      Pinput1 = PH_TOCUS1                                        CSD015
     C                   EVAL      Pinput2 = PH_TOCUS2                                        CSD015
     C                   EVAL      Pinput3 = PH_TOCUS3                                        CSD015
     C                   EVAL      Pinput4 = PH_TOCUS4                                        CSD015
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      Pinput5 = PH_TOCUS5                                        CSW207
     C                   ENDIF                                                                CSW207
     C                   EVAL      PInCcy = PD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(13))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(14))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PH_OINST1 <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PH_OINST1                                        CSD015
     C                   EVAL      PInCcy = PD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(3))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(4))                      CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        PH_OINST3 <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PH_OINST3                                        CSD015
     C                   EVAL      PInCcy = PD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(3))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(4))                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PH_SNDCOR <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PH_SNDCOR                                        CSD015
     C                   EVAL      PInCcy = PD_CCTCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(15))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(16))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PH_RCVCOR <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PH_RCVCOR                                        CSD015
     C                   EVAL      PInCcy = PD_CCTCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(17))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(18))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  Sr2ndD2Parm - Setup second Detail parameter for Compliance   *                       CSD015
      *                Engine Program                                 *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     Sr2ndD2Parm   BEGSR                                                                CSD015
                                                                                              CSD015
      ** Setup second Detail parameter for Compliance Engine Program                          CSD015
                                                                                              CSD015
     C                   IF        (PD_ORDCU1 <> *BLANKS OR PD_ORDCU2 <> *BLANKS              CSD015
     C                             OR PD_ORDCU3 <> *BLANKS OR                                 CSD015
     C                             PD_ORDCU4 <> *BLANKS )                                     CSD015
     C                             OR (CSW207 = 'Y' AND PD_ORDCU5 <> *BLANKS)                 CSW207
     C                   EVAL      Pinput1 = PD_ORDCU1                                        CSD015
     C                   EVAL      Pinput2 = PD_ORDCU2                                        CSD015
     C                   EVAL      Pinput3 = PD_ORDCU3                                        CSD015
     C                   EVAL      Pinput4 = PD_ORDCU4                                        CSD015
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      Pinput5 = PD_ORDCU5                                        CSW207
     C                   ENDIF                                                                CSW207
     C                   EVAL      PInCcy = PD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(19))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(20))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PD_ORDI11 <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PD_ORDI11                                        CSD015
     C                   EVAL      PInCcy = PD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(21))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(22))                     CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        PD_ORDI35 <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PD_ORDI35                                        CSD015
     C                   EVAL      PInCcy = PD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(21))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(22))                     CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PD_ACCI11 <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PD_ACCI11                                        CSD015
     C                   EVAL      PInCcy = PD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(5))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))                      CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        PD_ACCI35 <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PD_ACCI35                                        CSD015
     C                   EVAL      PInCcy = PD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(5))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (PD_BENF1 <> *BLANKS OR PD_BENF2 <> *BLANKS                CSD015
     C                             OR PD_BENF3 <> *BLANKS OR PD_BENF4 <> *BLANKS              CSD015
     C                             OR PD_BENF5 <> *BLANKS)                                    CSD015
     C                   EVAL      Pinput1 = PD_BENF1                                         CSD015
     C                   EVAL      Pinput2 = PD_BENF2                                         CSD015
     C                   EVAL      Pinput3 = PD_BENF3                                         CSD015
     C                   EVAL      Pinput4 = PD_BENF4                                         CSD015
     C                   EVAL      Pinput5 = PD_BENF5                                         CSD015
     C                   EVAL      PInCcy = PD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(7))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(8))                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (PD_REMI1 <> *BLANKS OR PD_REMI2 <> *BLANKS                CSD015
     C                             OR PD_REMI3 <> *BLANKS                                     CSD015
     C                             OR PD_REMI4 <> *BLANKS)                                    CSD015
     C                   EVAL      Pinput1 = PD_REMI1                                         CSD015
     C                   EVAL      Pinput2 = PD_REMI2                                         CSD015
     C                   EVAL      Pinput3 = PD_REMI3                                         CSD015
     C                   EVAL      Pinput4 = PD_REMI4                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(9))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(10))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  SrCallWatch - Send transaction details to Compliance Watch   *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrCallWatch   BEGSR                                                                CSD015
                                                                                              CSD015
      ** Send transaction details to Compliance Watch                                         CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    SDWLTD                                       CSD015
     C                   PARM                    PWatchString                                 CSD015
                                                                                              CSD015
      ** Initialise Parameters                                                                CSD015
                                                                                              CSD015
     C                   EVAL      SDWLTD = *BLANKS                                           CSD015
     C                   EVAL      PWatchString = *BLANKS                                     CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  SrConvrt - Convert Customer to Customer Name and Address     *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrConvrt      BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLFMT'                                                 CSD015
     C                   PARM                    PRtnCode                                     CSD015
     C                   PARM                    PInput1                                      CSD015
     C                   PARM                    PInput2                                      CSD015
     C                   PARM                    PInput3                                      CSD015
     C                   PARM                    PInput4                                      CSD015
     C                   PARM                    PInput5                                      CSD015
     C                   PARM                    PInput6                                      CSD015
     C                   PARM                    PInCcy                                       CSD015
     C                   PARM                    POutput                                      CSD015
     C                   PARM                    PCOutput                                     CSD015
                                                                                              CSD015
      ** Clear input variables                                                                CSD015
                                                                                              CSD015
     C                   EVAL      PInput1 = *BLANKS                                          CSD015
     C                   EVAL      PInput2 = *BLANKS                                          CSD015
     C                   EVAL      PInput3 = *BLANKS                                          CSD015
     C                   EVAL      PInput4 = *BLANKS                                          CSD015
     C                   EVAL      PInput5 = *BLANKS                                          CSD015
     C                   EVAL      PInput6 = *BLANKS                                          CSD015
     C                   EVAL      PInCcy = *BLANKS                                           CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  SrCvtDate - Convert dates to be used for Watch Engine Pgm    *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrCvtDate     BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CALL      'ZACVTDATE'                                                CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM                    PInDate                                      CSD015
     C                   PARM                    PAMDate                                      CSD015
     C                   PARM                    POutDate                                     CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  SrCvtAmt - Convert amountst for Watch Engine Program         *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrCvtAmt      BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CALL      'ZACVTAMT'                                                 CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM                    PCurr                                        CSD015
     C                   PARM                    PInAmt                                       CSD015
     C                   PARM                    PAMFlot                                      CSD015
     C                   PARM                    POutAmt                                      CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  SrGetCntrPty - Get Report Name of Counterparty               *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrGetCntrPty  BEGSR                                                                CSD015
                                                                                              CSD015
      ** Initialise Counterparty fields                                                       CSD015
                                                                                              CSD015
     C                   EVAL      W4CNUM = *BLANKS                                           CSD015
     C                   EVAL      W4CTYP = *BLANKS                                           CSD015
     C                   EVAL      W4CUST = *BLANKS                                           CSD015
                                                                                              CSD015
     C                   IF        SH_CCTTYP = 'BI'                                           CSD015
     C                   IF        SH_SINST <> *BLANKS                                        CSD015
     C                   EVAL      PInput1 = SH_SINST                                         CSD015
     C                   EVAL      PInCcy = SD_CCTCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   ENDIF                                                                CSD015
     C                   IF        PCOutput = '*CPART' OR                                     CSD015
     C                             PCOutput = '*FREE'  OR                                     CSD015
     C                             SH_SINST = *BLANKS                                         CSD015
     C                   EVAL      PInput1 = SH_SNDCOR                                        CSD015
     C                   EVAL      PInCcy = SD_CCTCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   ENDIF                                                                CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        SH_TOCUS1 <> *BLANKS                                       CSD015
     C                   EVAL      PInput1 = SH_TOCUS1                                        CSD015
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   ENDIF                                                                CSD015
     C                   IF        SH_TOCUS1 = *BLANKS                                        CSD015
     C                             OR PCOutput = '*CPART' OR                                  CSD015
     C                             PCOutput = '*FREE'                                         CSD015
     C                   EVAL      PInput1 = SH_OINST3                                        CSD015
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   ENDIF                                                                CSD015
     C                   IF        (SH_OINST3 = *BLANKS AND                                   CSD015
     C                             SH_TOCUS1 = *BLANKS) OR                                    CSD015
     C                             PCOutput = '*CPART' OR                                     CSD015
     C                             PCOutput = '*FREE'                                         CSD015
     C                   EVAL      PInput1 = SH_OINST1                                        CSD015
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PCOutput <> '*CPART' AND PCOutput <> '*FREE'               CSD015
     C                   EVAL      W4CNUM = PCOutput                                          CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        W4CNUM = *BLANKS                                           CSD015
     C                   GOTO      EGetCntrPty                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
                                                                                              CSD015
     C                   MOVE      *BLANKS       PKey                                         CSD015
     C                   MOVEL     W4CNUM        PKey                                         CSD015
                                                                                              CSD015
     C                   CALL      'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM      '*KEY   '     POptn                                        CSD015
     C                   PARM                    PKey                                         CSD015
     C                   PARM      *BLANKS       PStatus                                      CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank, then issue database error                                  CSD015
                                                                                              CSD015
     C                   IF        PRtnCode <> *BLANKS and PRtnCode <> '*NRF'                 CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = W4CNUM                                             CSD015
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        CSD015
     C                   EVAL      DBASE = 21                                                 CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtnCode = *BLANKS                                         CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
     C                   IF        BBCRPC = 'Y'                                               CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        BBLICD <> *BLANKS AND W1IND1 <> BBLICD                     CSD015
     C                             and W1IND2 <> BBLICD and W1IND3 <> BBLICD                  CSD015
     C                             and W1IND4 <> BBLICD and W1IND5 <> BBLICD                  CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      W4CUST = BBCRNM + BBCRTN                                   CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C     EGetCntrPty   ENDSR                                                                CSD015
                                                                                              CSD015
     C**********************************************************************
     C/EJECT
      **********************************************************************                  CRE020
      *                                                                    *                  CRE020
      * SrUpdAdvice - Update the Retail File Index Advice                  *                  CRE020
      *                                                                    *                  CRE020
      **********************************************************************                  CRE020
     C     SrUpdAdvice   BEGSR                                                                CRE020
                                                                                              CRE020
      ** Set Reference Key                                                                    CRE020
                                                                                              CRE020
     C                   OPEN      READVCL1                                                   CRE020
     C                   EVAL      RPRGMN = 'FTM102UPD'                                       CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   EVAL      RCHTYP = 'I'                                               CRE020
     C                   EVAL      RSEQNO = '000'                                             CRE020
     C                   EVAL      RREFNO = SH_CCTID                                          CRE020
     C                   EVAL      RTRTYP = SH_CCTTYP                                         CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   WRITE     READVCD0                                                   CRE020
                                                                                              CRE020
      ** Also write the transaction details to the Advice File                                CRE020
                                                                                              CRE020
     C     SH_CCTID      SETLL     FT102DL0                                                   CRE020
     C     SH_CCTID      READE     FT102DL0                                                   CRE020
                                                                                              CRE020
     C                   DOW       NOT %EOF(FT102DL0)                                         CRE020
                                                                                              CRE020
     C                   EVAL      RSEQNO = %SUBST(TRNSID:14:3)                               CRE020
     C                   WRITE     READVCD0                                                   CRE020
                                                                                              CRE020
     C     SH_CCTID      READE     FT102DL0                                                   CRE020
                                                                                              CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
     C**********************************************************************                  CRE020
      /EJECT                                                                                  CRE020
     C**********************************************************************
      *                                                                    *
      * *INZSR - Program Initialisation routine                            *
      *                                                                    *
      * Called by: Main processing                                         *
      *                                                                    *
      * Calls: None                                                        *
      *                                                                    *
      **********************************************************************
     C     *INZSR        BegSr
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
 
      ** INPUT PARAMETERS
 
      **  Return Code
     C                   Parm                    RetCodeIn
 
      **  Action Code
     C                   Parm                    ActionCode
 
      ** Details of the header record (in file format)
     C                   Parm                    HdrRcdIn
 
      ** Details of the detail record (in file format)
     C                   Parm                    DtlRcdIn
 
      ** Flag to indicate whether a header record is involved in the update
     C                   Parm                    HdrInfo
 
      ** Flag to indicate whether a detail record is involved in the update
     C                   Parm                    DtlInfo
 
      ** Old Request for transfert ID (for Reassign mode)
     C                   Parm                    OldCCTID
 
      ** Old Transaction reference (for Reassign mode)
     C                   Parm                    OldTransID
 
      ** Calling Program (for Message Management and STP)
     C                   Parm                    CallingPgm
 
      ** Network (for Message Management and STP)
     C                   Parm                    Network
 
      ** OUTPUT PARAMETERS
 
      ** Errors produced during I/O operation
     C                   Parm                    IdxErr
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
 
     C                   Movel     *BLANK        RetCodeIn
 
     C                   Exsr      RtvJob
     C     UserPrf       Ifeq      '*STP'
     C                   Movel     'Y'           DumpReq
     C                   Else
     C                   Movel     'N'           DumpReq
     C                   Endif
 
      ** Access Bank Details
 
     C                   Call      'AOBANKR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*FIRST   '   @OPTN
     C     Sdbank        Parm      Sdbank        Dsfdy
 
     C                   If        @RTCD <> *Blanks
     C                   Eval      dbfile = 'SDBANKPD'
     C                   Eval      dbase = 1
     C                   Eval      dbkey = '*FIRST'
     C                   Exsr      *PSSR
     C                   Endif
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       PRtCd                                        CSW201
                                                                                              CSW201
     C                   IF        PRtCd = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                      CSW207B
      ** Check if SWIFT2007 is installed                                                     CSW207B
      *                                                                                      CSW207B
     C                   Call      'SWIF2007'                                                CSW207B
     C                   Parm      *Blanks       PRtCd                                       CSW207B
                                                                                             CSW207B
     C                   If        PRtCd = 'CSW2007'                                         CSW207B
     C                   Eval      CSW207 = 'Y'                                              CSW207B
     C                   Else                                                                CSW207B
     C                   Eval      CSW207 = 'N'                                              CSW207B
     C                   EndIf                                                               CSW207B
                                                                                              CSD015
      ** Check if Compliance Watch Enhancement (CSD015) is installed                          CSD015
                                                                                              CSD015
     C                   Eval      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CallB     'AOSARDR0'                                                 CSD015
     C                   Parm      *Blanks       PRtCd                                        CSD015
     C                   Parm      '*VERIFY'     POptn                                        CSD015
     C                   Parm      'CSD015'      PSard                                        CSD015
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRtCd <> *BLANKS AND                                       CSD015
     C                             PRtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 30                                                 CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *BLANKS                                            CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   EVAL      KFuncCode = 'FT102HPD'                                     CSD015
                                                                                              CSD015
      ** Check if function code is being monitored by the compliance watch                    CSD015
                                                                                              CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM      '*KEY'        POptn                                        CSD015
     C                   PARM      'CUSTCRTR'    PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank, then issue database error                                  CSD015
                                                                                              CSD015
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF'                       CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CUSTCRTR'                                         CSD015
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBASE = 31                                                 CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check for Watch List Configuration Data File                                         CSD015
                                                                                              CSD015
     C                   CALLB     'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM      '*FIRST'      POptn                                        CSD015
     C     SDCWCD        PARM      SDCWCD        DSFDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank, then issue database error                                  CSD015
                                                                                              CSD015
     C                   IF        PRtnCode <> *BLANKS AND PRtnCode <> '*NRF'                 CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = '*FIRST'                                           CSD015
     C                   EVAL      DBFILE = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBASE = 32                                                 CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if 24x7 Enhancement (CSC011) is installed                                      CSD015
                                                                                              CSD015
     C                   EVAL      CSC011 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CSC011'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF'                       CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSC011'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 33                                                 CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *BLANKS                                            CSD015
     C                   EVAL      CSC011 = 'Y'                                               CSD015
     C                   IN        SC24X7                                                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
      **                                                                                      CSC022
      ** Access SAR details to see if CSC022 is switched on                                   CSC022
      **                                                                                      CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *Blanks       PRtCd                                        CSC022
     C                   Parm      '*VERIFY'     POptn                                        CSC022
     C                   Parm      'CSC022'      PSard                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      ** Initialize CSC022 and Skip Commit Flags                                              CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpComtRolbk = 'N'                                        CSC022
      **                                                                                      CSC022
     C                   If        PRtCd = *BLANKS                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MoveA     WDSJobs       WJobs                                        CSC022
      ** Verify if job running exists in array                                                CSC022
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                         CSC022
     C                   If        WArrPtr > 0                                                CSC022
     C                   Eval      WSkpComtRolbk = 'Y'                                        CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
     C                   Else                                                                 CSC022
      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
     C                   If        PRtCd <> '*NRF'                                            CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBPgm  = 'FTM102UPD'                                       CSC022
     C                   Eval      DBKey  = 'CSC022'                                          CSC022
     C                   Eval      DBase  = 34                                                CSC022
     C                   Out       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
                                                                                              CRE020
      ** Check if On Line Printing of Advice is on                                            CRE020
                                                                                              CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtnCode                                     CRE020
     C                   PARM      '*VERIFY'     POptn                                        CRE020
     C                   PARM      'CRE020'      PSard                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   IF        PRtnCode = *BLANKS                                         CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Database Error SAR File                                                              CRE020
                                                                                              CRE020
     C                   IF        PRtnCode <> *BLANKS AND                                    CRE020
     C                             PRtnCode <> '*NRF'                                         CRE020
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBASE = 035                                                CRE020
     C                   EVAL      DBKEY = 'CRE020'                                           CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Check if system value for the maintenance is on                                      CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
                                                                                              CRE020
     C                   CALL      'AOSVALR0'                                                 CRE020
     C                   PARM                    PRtnCode                                     CRE020
     C                   PARM                    PSValOpt                                     CRE020
     C                   PARM                    PSysVal                                      CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
                                                                                              CRE020
      ** Database Error for System Values File                                                CRE020
                                                                                              CRE020
     C                   IF        PRtnCode <> *Blanks                                        CRE020
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBASE = 036                                                CRE020
     C                   EVAL      DBKEY = PSValOpt                                           CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
                                                                                              CSD015
      ** Key list for SDCWHTL1                                                                CSD015
                                                                                              CSD015
     C     KFuncKey      KLIST                                                                CSD015
     C                   KFLD                    KFuncCode                                    CSD015
     C                   KFLD                    KIden                                        CSD015
     C                   KFLD                    KBranch                                      CSD015
                                                                                              CSD015
      ** Key list for FT102HLA                                                                CSD015
                                                                                              CSD015
     C     KCctId        KLIST                                                                CSD015
     C                   KFLD                    SH_CCTTYP                                    CSD015
     C                   KFLD                    SH_CCTID                                     CSD015
                                                                                              CSW201
                                                                                              CSW209
      ** Check if SWIFT2009 is installed                                                      CSW209
      *                                                                                       CSW209
     C                   Call      'SWIF2009'                                                 CSW209
     C                   Parm      *Blanks       PRtCd                                        CSW209
                                                                                              CSW209
     C                   If        PRtCd = 'CSW2009'                                          CSW209
     C                   Eval      CSW209 = 'Y'                                               CSW209
     C                   Else                                                                 CSW209
     C                   Eval      CSW209 = 'N'                                               CSW209
     C                   EndIf                                                                CSW209
                                                                                              CSW209
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      **********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  ArrWatch                                                                                  CSD015
<Header Ordering Customer>                                                                    CSD015
</Header Ordering Customer>                                                                   CSD015
<Header Ordering Institution>                                                                 CSD015
</Header Ordering Institution>                                                                CSD015
<Account With Institution>                                                                    CSD015
</Account With Institution>                                                                   CSD015
<Beneficiary>                                                                                 CSD015
</Beneficiary>                                                                                CSD015
<Remittance Information>                                                                      CSD015
</Remittance Information>                                                                     CSD015
<Sending Institution>                                                                         CSD015
</Sending Institution>                                                                        CSD015
<Destination>                                                                                 CSD015
</Destination>                                                                                CSD015
<Sender's Correspondent>                                                                      CSD015
</Sender's Correspondent>                                                                     CSD015
<Receiver's Correspondent>                                                                    CSD015
</Receiver's Correspondent>                                                                   CSD015
<Ordering Customer>                                                                           CSD015
</Ordering Customer>                                                                          CSD015
<Ordering Institution>                                                                        CSD015
</Ordering Institution>                                                                       CSD015
