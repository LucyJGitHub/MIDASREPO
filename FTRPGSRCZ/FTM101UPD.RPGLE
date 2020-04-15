     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas FT Update RFT header and details')                    *
      **********************************************************************
      *                                                                    *
      *  Midas - Funds Transfer Module                                     *
      *                                                                    *
      *  FTM101UPD - Request For Transfert Database Update                 *
      *                                                                    *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSW220             Date 09Mar20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15235           Date 06Nov07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA020             Date 14Apr04               *
      *                 221761             Date 13Apr04               *
      *                 CRE020             Date 20Jan04               *
      *                 CSC022             Date 24Feb04               *
      *                 CAP084             Date 25Jun03               *
      *                 220004             Date 24Jul03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185660             Date 31Oct00               *
      *                 185107             Date 17Oct00                    *
      *                 184191             Date 02OCT00                    *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178751             Date 09May00                    *
      *                 178384             Date 02May00                    *
      *                 178186             Date 25Apr00                    *
      *                 177973             Date 18Apr00                    *
      *                 177866             Date 17Apr00                    *
      *                 177809             Date 14Apr00                    *
      *                 177677             Date 13Apr00                    *
      *                 177673             Date 12Apr00                    *
      *                 CFT006  *CREATE    Date 14Sep99                    *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  CSW220 - SWIFT Changes 2020 (Recompile)                      *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15235 - Authorising user is the same as input user        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                                   *
      *  CSW037 - Additional Field Data on MT300/MT320                     *
      *  CSW036 - Dual SWIFT BIC held on Client Details                    *
      *  CLE025 - Credit Lines (Recompile)                                 *
      *  TDA020 - Rename RSEQNO in FT101HPD as it conflicts with READVCPD  *
      *  221761 - Incorrect routing of multiple MT101s.                    *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)              *
      *  CSC022 - Commitment Control Changes for MidasPlus                 *
      *  CAP084 - Creation of wrappers for use with front end.             *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.          *
      *  CSD015 - Midas Compliance Watch - Watch List Checking             *
      *  CFT009 - Addition of fields for FT fees and charges               *
      *           Recompile                                                *
      *  185660 - When routing using ?,all message parts should be         *
      *         - processed                                                *
      *  185107 - Mapping of details from swift message                    *
      *  184191 - Incorrect commit.                                        *
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
      *  CFT006 - Swift Messages MT101/MT102                               *
      *                                                                    *
      **********************************************************************
      *                                                                    *
      * ID F  C  H  L    FUNCTION OF INDICATORS                            *
      *                                                                    *
      * 48 - Record found / not found for SDCWHTL1                         *                  CSD015
      * 49 - Record found / not found for FT101DL2                         *                  CSD015
      * 50 - Record found / not found for FT101HLB                         *                  CSD015
      * 90 - Record found / not found                                      *
      * 91 - Record locked                                                 *
      **********************************************************************
      * SUBROUTINE INDEX                                                   *
      *                                                                    *
      * *INZSR (for first call)                                            *
      * SrIni - INITIALIZE                                                 *
      * SrIns - INSERT A RFT PAYMENT                                       *
      * SrAmd - AMEND A RFT PAYMENT                                        *
      * SrAmdX - AUTHORISE A PAYMENT                                       *
      * SrDel - DELETE A RFT PAYMENT                                       *
      * SrReass - REASSIGN A RFT PAYMENT                                   *
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
      * UpdateH - UPDATE HEADER RECORD                                     *
      * UpdateD - UPDATE DETAIL RECORD                                     *
      * SrFtst - UPDATE INCOMING MESSAGE FT TRANSACTION STATUS             *
      * RlsMsg - DELETE MESSAGE RESERVED                                   *
      * Sr1stParm - Setup first paramater for Compliance Engine Pgm   *                       CSD015
      * Sr2ndHParm - Setup 2nd header parm for Compliance Engine Pgm  *                       CSD015
      * Sr2ndDParm - Setup 2nd detail parm for Compliance Engine Pgm  *                       CSD015
      * Sr2ndH2Parm - Setup 2nd header parm for Compliance Engine Pgm *                       CSD015
      * Sr2ndD2Parm - Setup 2nd detail parm for Compliance Engine Pgm *                       CSD015
      * SrCallWatch - Send transaction details to Compliance Watch    *                       CSD015
      * SrConvrt - Convert Customer to Customer Name and Address      *                       CSD015
      * SrGetCntrPty - Get Report Name of Counterparty                *                       CSD015
      * SrCvtDate - Convert dates to be used for Watch Engine Program *                       CSD015
      * SrCvtAmt - Convert amounts for Watch Engine Program           *                       CSD015
      **********************************************************************
      /EJECT
      * RFT header
     FFT101HL4  UF A E           K DISK    COMMIT
     F                                     RENAME(FT101HD0:FT101HD4)
     FFT101HL3  UF   E           K DISK    COMMIT
      * RFT details
     FFT101DL0  UF A E           K DISK    COMMIT
                                                                                              CSD015
     FSDCWHTL1  IF   E           K DISK                                                       CSD015
      ** Compliance Watch Hit List File                                                       CSD015
                                                                                              CSD015
     FFT101DL2  IF A E           K DISK    RENAME(FT101DD0:FT101DD2)                          CSD015
     F                                     PREFIX(PD_)                                        CSD015
      * RFT details                                                                           CSD015
                                                                                              CSD015
     FFT101HLB  IF A E           K DISK    RENAME(FT101HD0:FT101HD2)                          CSD015
     F                                     PREFIX(PH_)                                        CSD015
      * RFT header                                                                            CSD015
                                                                                              CSD015
     FREADVCL1  UF A E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
      ** MIDAS RE Settled Transaction Index file                                              CRE020
                                                                                              CRE020
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

      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT101HPD) PREFIX(SH_)
     D DtlRcdIn      E DS                  EXTNAME(FT101DPD) PREFIX(SD_)

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

      ** External DS for MT101 MT102 control file
     D MEIRFT        E DS                  EXTNAME(MEIRFTPD) PREFIX(CK_)

      ** External DS for message status
     D MEINFT        E DS                  EXTNAME(MEINFTPD)
      *
      **                                                                                      CSC022
      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      **                                                                                      CSC022
      ** Datastructure for FTM1012GN (creation of unique RFTID)
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

      ** Parameters for FTM1013GN                                               178751
     D TrnType         S              2                                         178751
     D TrnId           S             15                                         178751
     D SeqNo           S              3                                         178751
                                                                                178751
      ** WORKING VARIABLES
      ** -----------------

      ** Old RFT id
     D OldRftID        S                   Like(RFTID)

      ** Old Transaction reference
     D OldTransID      S                   Like(TRNSID)

      ** Calling Program (for Message Management and STP)
     D CallingPgm      S             10

      ** Network (for Message Management and STP)
     D Network         S                   Like(PNWRK)

      ** RFT Id (13 long)                                                       178751
     D RFTID13         S             13                                         178751

      ** Message reference (ME1070 parameter)                                   185660
     D W0MSGREF        S              8P 0                                      185660
                                                                                185660
      ** Message part (ME1070 parameter)                                        185660
     D W0MSGPRT        S              3P 0                                      185660

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

      ** INDEX
      ** -----
     D E               S              3P 0
     D IdxErr          S                   Like(E)
                                                                                              CSD015
      ** Variables for CSD015 Enhancement                                                     CSD015
                                                                                              CSD015
     D ArrWatch        S             35    DIM(24) CTDATA PERRCD(1)                           CSD015
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
     D PCOutput        S              6A                                                      CSD015
     D POutput         S            216A                                                      CSD015
     D POption         S              7A                                                      CSD015
     D PInAmt          S             15A                                                      CSD015
     D POutAmt         S             16A                                                      CSD015
     D PCurr           S              3A                                                      CSD015
     D PInDate         S              5A                                                      CSD015
     D PKey            S             10A                                                      CSD015
     D PStatus         S             10A                                                      CSD015
     D PAMDate         S               D                                                      CSD015
     D PAMFlot         S             18  3                                                    CSD015
     D POutDate        S             10A                                                      CSD015
     D PRtnCode        S              7A                                                      CSD015
     D PSard           S              6A                                                      CSD015
     D PWatchString    S          30000A                                                      CSD015
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
     D PRtCd           S              7A                                                      CRE020
     D PSValOpt        S             20A   INZ('InRequestForTransfer')                        CRE020
     D PSysVal         S            200A   INZ(' ')                                           CRE020
     D PSValOptB       S             20A   INZ(' ')                                           CRE020
     D PSysValB        S            200A   INZ(' ')                                           CRE020
                                                                                              CRE020
      ** Working Variables                                                                    CRE020
     D WSeqno          S              3S 0                                                    CRE020
                                                                                              CRE020
      ** Rename Field                                                                         TDA020
     IFT101HD0                                                                                TDA020
     I              RSEQNO                      RSEQNOX                                       TDA020
     IFT101HD4                                                                                TDA020
     I              RSEQNO                      RSEQNOX                                       TDA020
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

     C                   Movel     'Y'           CommitChg                      177866
     C                   Z-add     0             E
     C                   Movel     *BLANK        FldNameArr
     C                   Movel     *BLANK        MsgIdArr
     C                   Movel     *BLANK        MsgDtaArr

      **  Unwind subroutine stack name
     C     SrIni_End     Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q

     C                   Exsr      RtvJob                                                   BUG15235
     C     UserPrf       Ifeq      '*STP'                                                   BUG15235
     C                   Movel     'Y'           DumpReq                                    BUG15235
     C                   Else                                                               BUG15235
     C                   Movel     'N'           DumpReq                                    BUG15235
     C                   Endif                                                              BUG15235
     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* SrIns - INSERT A RFT PAYMENT                                       *
     C*                                                                    *
     C**********************************************************************
     C     SrIns         BegSr

      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrIns'       SrStack(q)

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
     C* SrAmd - AMEND A RFT PAYMENT                                        *
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

     C                   Callb     'FTM101CFM'                          90
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode
     C                   Parm      'X'           ActionCode
     C                   Parm                    SH_RFTID
     C                   Parm      SH_SNDREF     CK_SNDREF
     C                   Parm      SH_STID       CK_SNDIST

     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FTM101CFM'   DBFILE
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
      ** update READVCPD                                                                      CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                             AND PSysVal = 'Y'                                          CRE020
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
     C* SrDel - DELETE A RFT PAYMENT                                       *
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
     C* SrReass - REASSIGN A RFT PAYMENT                                   *
     C*                                                                    *
     C**********************************************************************
     C     SrReass       BegSr

      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SrReass'     SrStack(q)
                                                                                177673
     C                   Movel     'Y'           Unlocked                       177673
     C                   Movel     DumpReq       RtvDump                        177673
     C                   Movel     SD_RFTID      Rft_ID                         177673
     C                   Exsr      RtvHdr2                                      177673
                                                                                177673
     C     HdrFound      Ifeq      'Y'                                          177673

     C*******************Movel     'N'           Unlocked                       177673
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SD_RFTID      Rft_Id
     C                   Movel     SD_TRNSID     TransId
     C*******************Exsr      RtvDtl                                       177673
     C                   Exsr      DtlNfnd                                      177673
     C     DtlFound      Ifeq      'N'                                          177673
     C*****DtlFound      Ifeq      'Y'                                          177673
     C*******************Add       1             E                              177673
     C*******************Movel     SrStack(q)    FldNameArr(E)                  177673
     C*******************Movel     'RFU0005'     MsgIdArr(E)                    177673
     C*******************Else                                                   177673
     C*******************Eval      E=0                                          177673
     C                   Movel     OldRftID      Rft_ID
     C                   Movel     OldTransID    TransID
     C                   Movel     'N'           Unlocked                       177673
     C                   Movel     DumpReq       RtvDump                        177673
     C                   Exsr      RtvDtl                                       177673
     C     DtlFound      Ifeq      'Y'                                          177673
     C*****KRftDtl1      Chain     FT101DL0                           97        177673
     C                   Eval      RFTID = SD_RFTID
     C*******************Eval      TRNSID = SD_TRNSID                           178751
      *                                                                         178751
      ** Default transaction reference                                          178751
      *                                                                         178751
     C                   Exsr      RtvSeq                                       178751
     C                   Movel     RFTID         RFTID13                        178751
     C     RFTID13       Cat       SEQNO         TRNSID                         178751
     C                   Movel     SEQNO         TSEQNO                         178751
     C*******************Update    FT101DD0                                     177673
     C                   Exsr      UpdateD                                      177673
     C     RFTMSG        Ifne      0                                            177673
     C     RFTMSQ        andne     0                                            177673
      **  Reassign the message to the new transaction                           177673
     C                   Movel     SH_PYTP       PayType                        177673
     C                   Z-add     RFTMSG        MsgRefI                        177673
     C                   Z-add     RFTMSQ        MsgPartI                       177673
     C                   Movel     'MIN0030'     MsgStat                        177673
     C                   Exsr      SrFtst                                       177673
     C                   Endif                                                  177673
                                                                                177673
     C                   Endif                                                  177673
                                                                                177673
     C                   Endif

     C                   Endif

      **  Unwind subroutine stack name
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
     C                   Movel     SH_SNDREF     SenderRef
     C                   Movel     SH_STID       SwiftID
     C                   Exsr      HdrNfnd

     C     HdrFound      Ifeq      'N'
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
     C                   Movel     SH_SNDREF     SenderRef
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
     C                   Movel     SH_SNDREF     SenderRef                      177809
     C                   Movel     SH_STID       SwiftID                        177809
     C                   Exsr      RtvHdr                                       177809
                                                                                177809
     C                   Endif                                                  177809
                                                                                177809
     C     HdrFound      Ifeq      'Y'                                          177809
                                                                                177809
      ** For S/R SrMapD, we need to store the ID of the request for
      ** transfer for each detail we want to insert.
     C                   Movel     RFTID         SH_RFTID

     C     SH_PYTP       Ifne      PYTP
     C     SH_PYST       orne      PYST
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
     C     SH_PYTP       Ifne      PYTP                                         177973
     C                   Add       1             E                              177973
     C                   Movel     SrStack(q)    FldNameArr(E)                  177973
     C                   Movel     'RFU0007'     MsgIdArr(E)                    177973
     C                   Endif                                                  177973
     C     SH_PYST       Ifne      PYST                                         177973
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
     C                   Movel     SD_RFTID      Rft_ID
     C                   Movel     SD_TRNSID     TransID
     C                   Exsr      DtlNfnd

     C     DtlFound      Ifeq      'N'
     C                   Exsr      SrMapD
     C                   Exsr      WriteD

      ** If payment created through a message MT102
      ** Update status of the message
     C     SD_RFTMSG     Ifne      0
     C     SD_RFTMSQ     andne     0
     C                   Movel     SH_PYTP       PayType
     C                   Z-add     SD_RFTMSG     MsgRefI
     C                   Z-add     SD_RFTMSQ     MsgPartI
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

     C                   Movel     'Y'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SH_SNDREF     SenderRef
     C                   Movel     SH_STID       SwiftID
     C                   Exsr      RtvHdr

     C     HdrFound      Ifeq      'Y'
      ** For S/R SrMapD, we need to store the ID of the request for
      ** transfert for each detail we want to insert.
     C                   Movel     DumpReq       NfndDump
     C                   Movel     RFTID         SH_RFTID
     C                   Movel     RFTID         Rft_ID
     C                   Movel     SD_TRNSID     TransID
     C                   Exsr      DtlNfnd

     C     DtlFound      Ifeq      'N'
     C                   Exsr      SrMapD
     C                   Exsr      WriteD

      ** If payment created through a message MT102
      ** Update status of the message
     C     SD_RFTMSG     Ifne      0
     C     SD_RFTMSQ     andne     0
     C                   Movel     SH_PYTP       PayType
     C                   Z-add     SD_RFTMSG     MsgRefI
     C                   Z-add     SD_RFTMSQ     MsgPartI
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
     C                   Movel     SH_SNDREF     SenderRef
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
     C                   EVAL      KIden = SH_RFTID                                           CSD015
     C                   EVAL      KBranch = SH_BRCA                                          CSD015
     C                   EVAL      W3UNCF = *BLANKS                                           CSD015
                                                                                              CSD015
     C     KFuncKey      CHAIN     SDCWHTL1                           48                      CSD015
                                                                                              CSD015
     C                   IF        ((*IN48 = *OFF AND W3UNCF = 'Y') OR                        CSD015
     C                             ((SH_HOCUS1 <> *BLANKS AND                                 CSD015
     C                             SH_HOCUS1 <> HOCUS1) OR (SH_HOCUS2 <> *BLANKS              CSD015
     C                             AND SH_HOCUS2 <> HOCUS2) OR                                CSD015
     C                             (SH_HOCUS3 <> *BLANKS AND                                  CSD015
     C                             SH_HOCUS3 <> HOCUS3) OR (SH_HOCUS4 <> *BLANKS              CSD015
     C                             AND SH_HOCUS4 <> HOCUS4) OR                                CSD015
     C                             (SH_HOCUS5 <> *BLANKS AND                                  CSD015
     C                             SH_HOCUS5 <> HOCUS5) OR (SH_HACSV1 <> *BLANKS              CSD015
     C                             AND SH_HACSV1 <> HACSV1) OR                                CSD015
     C                             (SH_SINST <> *BLANKS AND                                   CSD015
     C                             SH_SINST <> SINST) OR (SH_RFTDST <> *BLANKS                CSD015
     C                             AND SH_RFTDST <> RFTDST) OR                                CSD015
     C                             (SH_HACSV2 <> *BLANKS AND                                  CSD015
     C                             SH_HACSV2 <> HACSV2)))                                     CSD015
                                                                                              CSD015
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
     C     SH_RFTID      SETLL     FT101DL2                               49                  CSD015
     C     SH_RFTID      READE     FT101DL2                               49                  CSD015
     C                   DOW       *IN49 = *OFF                                               CSD015
     C                   EXSR      Sr2ndD2Parm                                                CSD015
     C                   EVAL      SD_TRNCCY = PD_TRNCCY                                      CSD015
     C                   EVAL      SD_PAYCCY = PD_PAYCCY                                      CSD015
     C                   EXSR      Sr2ndHParm                                                 CSD015
                                                                                              CSD015
     C                   IF        PWatchString <> *BLANKS                                    CSD015
     C                   EXSR      Sr1stParm                                                  CSD015
     C                   EXSR      SrCallWatch                                                CSD015
     C                   ENDIF                                                                CSD015
     C     SH_RFTID      READE     FT101DL2                               49                  CSD015
     C                   ENDDO                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
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
     C                   Movel     SH_SNDREF     SenderRef
     C                   Movel     SH_STID       SwiftID
     C                   Exsr      RtvHdr

     C     HdrFound      Ifeq      'Y'
     C                   Movel     'N'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SD_RFTID      Rft_ID
     C                   Movel     SD_TRNSID     TransID
     C                   Exsr      RtvDtl

     C     DtlFound      Ifeq      'Y'
                                                                                              CSD015
      ** If Function Code is being monitored by Compliance Watch                              CSD015
      ** and Watch List Checking Applied                                                      CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'N' OR Libr = S1Main                              CSD015
                                                                                              CSD015
     C                   EVAL      KIden = SH_RFTID                                           CSD015
     C                   EVAL      KBranch = SH_BRCA                                          CSD015
     C                   EVAL      W3UNCF = *BLANKS                                           CSD015
                                                                                              CSD015
     C     KFuncKey      CHAIN     SDCWHTL1                           48                      CSD015
                                                                                              CSD015
     C                   IF        ((*IN48 = *OFF AND W3UNCF = 'Y') OR                        CSD015
     C                             ((SH_HINPTY <> *BLANKS AND                                 CSD015
     C                             SH_HINPTY <> HINPTY) OR                                    CSD015
     C                             (SH_HOCUS1 <> *BLANKS AND                                  CSD015
     C                             SH_HOCUS1 <> HOCUS1) OR (SH_HOCUS2 <> *BLANKS              CSD015
     C                             AND SH_HOCUS2 <> HOCUS2) OR                                CSD015
     C                             (SH_HOCUS3 <> *BLANKS AND                                  CSD015
     C                             SH_HOCUS3 <> HOCUS3) OR (SH_HOCUS4 <> *BLANKS              CSD015
     C                             AND SH_HOCUS4 <> HOCUS4) OR                                CSD015
     C                             (SH_HOCUS5 <> *BLANKS AND                                  CSD015
     C                             SH_HOCUS5 <> HOCUS5) OR (SH_HACSV1 <> *BLANKS              CSD015
     C                             AND SH_HACSV1 <> HACSV1) OR                                CSD015
     C                             (SH_HACSV2 <> *BLANKS AND                                  CSD015
     C                             SH_HACSV2 <> HACSV2) OR (SH_SINST <> *BLANKS               CSD015
     C                             AND SH_SINST <> SINST) OR                                  CSD015
     C                             (SD_TINPTY <> *BLANKS AND                                  CSD015
     C                             SD_TINPTY <> TINPTY) OR (SD_TOCUS1 <> *BLANKS              CSD015
     C                             AND SD_TOCUS1 <> TOCUS1) OR                                CSD015
     C                             (SD_TOCUS2 <> *BLANKS AND                                  CSD015
     C                             SD_TOCUS2 <> TOCUS2) OR (SD_TOCUS3 <> *BLANKS              CSD015
     C                             AND SD_TOCUS3 <> TOCUS3) OR                                CSD015
     C                             (SD_TOCUS4 <> *BLANKS AND                                  CSD015
     C                             SD_TOCUS4 <> TOCUS4) OR (SD_TOCUS5 <> *BLANKS              CSD015
     C                             AND SD_TOCUS5 <> TOCUS5) OR                                CSD015
     C                             (SD_TASI35 <> *BLANKS AND                                  CSD015
     C                             SD_TASI35 <> TASI35) OR (SD_TACC11 <> *BLANKS              CSD015
     C                             AND SD_TACC11 <> TACC11) OR                                CSD015
     C                             (SD_TINST1 <> *BLANKS AND                                  CSD015
     C                             SD_TINST1 <> TINST1) OR (SD_TINST2 <> *BLANKS              CSD015
     C                             AND SD_TINST2 <> TINST2) OR                                CSD015
     C                             (SD_TINST3 <> *BLANKS AND                                  CSD015
     C                             SD_TINST3 <> TINST3) OR (SD_TINST4 <> *BLANKS              CSD015
     C                             AND SD_TINST4 <> TINST4) OR                                CSD015
     C                             (SD_TINST5 <> *BLANKS AND                                  CSD015
     C                             SD_TINST5 <> TINST5) OR (SD_TACA11 <> *BLANKS              CSD015
     C                             AND SD_TACA11 <> TACA11) OR                                CSD015
     C                             (SD_TACA35 <> *BLANKS AND                                  CSD015
     C                             SD_TACA35 <> TACA35) OR (SD_TACB35 <> *BLANKS              CSD015
     C                             AND SD_TACB35 <> TACB35) OR                                CSD015
     C                             (SD_TACC35 <> *BLANKS AND                                  CSD015
     C                             SD_TACC35 <> TACC35) OR (SD_TACD35 <> *BLANKS              CSD015
     C                             AND SD_TACD35 <> TACD35) or                                CSD015
     C                             (SD_TACE35 <> *BLANKS AND                                  CSD015
     C                             SD_TACE35 <> TACE35) OR (SD_TBNA35 <> *BLANKS              CSD015
     C                             AND SD_TBNA35 <> TBNA35) OR                                CSD015
     C                             (SD_TBNB35 <> *BLANKS AND                                  CSD015
     C                             SD_TBNB35 <> TBNB35) OR (SD_TBNC35 <> *BLANKS              CSD015
     C                             AND SD_TBNC35 <> TBNC35) OR                                CSD015
     C                             (SD_TBND35 <> *BLANKS AND                                  CSD015
     C                             SD_TBND35 <> TBND35) OR (SD_TBNE35 <> *BLANKS              CSD015
     C                             AND SD_TBNE35 <> TBNE35) OR                                CSD015
     C                             (SD_TRMA35 <> *BLANKS AND                                  CSD015
     C                             SD_TRMA35 <> TRMA35) OR (SD_TRMB35 <> *BLANKS              CSD015
     C                             AND SD_TRMB35 <> TRMB35) OR                                CSD015
     C                             (SD_TRMC35 <> *BLANKS AND                                  CSD015
     C                             SD_TRMC35 <> TRMC35) OR (SD_TRMD35 <> *BLANKS              CSD015
     C                             AND SD_TRMD35 <> TRMD35) OR                                CSD015
     C                             (SD_TINSTA <> *BLANKS AND                                  CSD015
     C                             SD_TINSTA <> TINSTA)))                                     CSD015
                                                                                              CSD015
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
     C     SH_RFTID      SETLL     FT101DL2                               49                  CSD015
     C     SH_RFTID      READE     FT101DL2                               49                  CSD015
     C                   DOW       *IN49 = *OFF                                               CSD015
     C                   EXSR      Sr2ndD2Parm                                                CSD015
     C                   EXSR      Sr2ndH2Parm                                                CSD015
                                                                                              CSD015
     C                   IF        PWatchString <> *BLANKS                                    CSD015
     C                   EXSR      Sr1stParm                                                  CSD015
     C                   EXSR      SrCallWatch                                                CSD015
     C                   ENDIF                                                                CSD015
     C     SH_RFTID      READE     FT101DL2                               49                  CSD015
     C                   ENDDO                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   Exsr      SrMapH
     C                   Exsr      UpdateH
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
     C                   Movel     SD_RFTID      Rft_ID
     C                   Exsr      RtvHdr2

     C     HdrFound      Ifeq      'Y'
     C                   Movel     'N'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SD_RFTID      Rft_ID
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
     C                   EVAL      KIden = SH_RFTID                                           CSD015
     C                   EVAL      KBranch = SH_BRCA                                          CSD015
     C                   EVAL      W3UNCF = *BLANKS                                           CSD015
                                                                                              CSD015
     C     KFuncKey      CHAIN     SDCWHTL1                           48                      CSD015
                                                                                              CSD015
     C                   IF        ((*IN48 = *OFF AND W3UNCF = 'Y') OR                        CSD015
     C                             ((SH_HINPTY <> *Blanks and                                 CSD015
     C                             SH_HINPTY <> HINPTY) OR                                    CSD015
     C                             (SH_HOCUS1 <> *BLANKS AND                                  CSD015
     C                             SH_HOCUS1 <> HOCUS1) OR (SH_HOCUS2 <> *BLANKS              CSD015
     C                             AND SH_HOCUS2 <> HOCUS2) or                                CSD015
     C                             (SH_HOCUS3 <> *BLANKS AND                                  CSD015
     C                             SH_HOCUS3 <> HOCUS3) OR (SH_HOCUS4 <> *BLANKS              CSD015
     C                             AND SH_HOCUS4 <> HOCUS4) OR                                CSD015
     C                             (SH_HOCUS5 <> *BLANKS AND                                  CSD015
     C                             SH_HOCUS5 <> HOCUS5) OR (SH_HACSV1 <> *BLANKS              CSD015
     C                             AND SH_HACSV1 <> HACSV1) OR                                CSD015
     C                             (SH_HACSV2 <> *BLANKS AND                                  CSD015
     C                             SH_HACSV2 <> HACSV2) OR (SH_SINST <> *BLANKS               CSD015
     C                             AND SH_SINST <> SINST) OR                                  CSD015
     C                             (SD_TINPTY <> *BLANKS AND                                  CSD015
     C                             SD_TINPTY <> TINPTY) OR (SD_TOCUS1 <> *BLANKS              CSD015
     C                             AND SD_TOCUS1 <> TOCUS1) OR                                CSD015
     C                             (SD_TOCUS2 <> *BLANKS AND                                  CSD015
     C                             SD_TOCUS2 <> TOCUS2) OR (SD_TOCUS3 <> *BLANKS              CSD015
     C                             AND SD_TOCUS3 <> TOCUS3) OR                                CSD015
     C                             (SD_TOCUS4 <> *BLANKS AND                                  CSD015
     C                             SD_TOCUS4 <> TOCUS4) OR (SD_TOCUS5 <> *BLANKS              CSD015
     C                             AND SD_TOCUS5 <> TOCUS5) OR                                CSD015
     C                             (SD_TASI35 <> *BLANKS AND                                  CSD015
     C                             SD_TASI35 <> TASI35) OR (SD_TACC11 <> *BLANKS              CSD015
     C                             AND SD_TACC11 <> TACC11) OR                                CSD015
     C                             (SD_TINST1 <> *BLANKS AND                                  CSD015
     C                             SD_TINST1 <> TINST1) OR (SD_TINST2 <> *BLANKS              CSD015
     C                             AND SD_TINST2 <> TINST2) OR                                CSD015
     C                             (SD_TINST3 <> *BLANKS AND                                  CSD015
     C                             SD_TINST3 <> TINST3) OR (SD_TINST4 <> *BLANKS              CSD015
     C                             AND SD_TINST4 <> TINST4) OR                                CSD015
     C                             (SD_TINST5 <> *BLANKS AND                                  CSD015
     C                             SD_TINST5 <> TINST5) OR (SD_TACA11 <> *BLANKS              CSD015
     C                             AND SD_TACA11 <> TACA11) OR                                CSD015
     C                             (SD_TACA35 <> *BLANKS AND                                  CSD015
     C                             SD_TACA35 <> TACA35) OR (SD_TACB35 <> *BLANKS              CSD015
     C                             AND SD_TACB35 <> TACB35) OR                                CSD015
     C                             (SD_TACC35 <> *BLANKS AND                                  CSD015
     C                             SD_TACC35 <> TACC35) OR (SD_TACD35 <> *BLANKS              CSD015
     C                             AND SD_TACD35 <> TACD35) OR                                CSD015
     C                             (SD_TACE35 <> *BLANKS AND                                  CSD015
     C                             SD_TACE35 <> TACE35) OR (SD_TBNA35 <> *BLANKS              CSD015
     C                             AND SD_TBNA35 <> TBNA35) OR                                CSD015
     C                             (SD_TBNB35 <> *BLANKS AND                                  CSD015
     C                             SD_TBNB35 <> TBNB35) OR (SD_TBNC35 <> *BLANKS              CSD015
     C                             AND SD_TBNC35 <> TBNC35) OR                                CSD015
     C                             (SD_TBND35 <> *BLANKS AND                                  CSD015
     C                             SD_TBND35 <> TBND35) OR (SD_TBNE35 <> *BLANKS              CSD015
     C                             AND SD_TBNE35 <> TBNE35) OR                                CSD015
     C                             (SD_TRMA35 <> *BLANKS AND                                  CSD015
     C                             SD_TRMA35 <> TRMA35) or (SD_TRMB35 <> *BLANKS              CSD015
     C                             AND SD_TRMB35 <> TRMB35) OR                                CSD015
     C                             (SD_TRMC35 <> *BLANKS AND                                  CSD015
     C                             SD_TRMC35 <> TRMC35) OR (SD_TRMD35 <> *BLANKS              CSD015
     C                             AND SD_TRMD35 <> TRMD35) OR                                CSD015
     C                             (SD_TINSTA <> *BLANKS AND                                  CSD015
     C                             SD_TINSTA <> TINSTA)))                                     CSD015
                                                                                              CSD015
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
     C     SH_RFTID      SETLL     FT101DL2                               49                  CSD015
     C     SH_RFTID      READE     FT101DL2                               49                  CSD015
     C                   DOW       *IN49 = *OFF                                               CSD015
     C                   EXSR      Sr2ndD2Parm                                                CSD015
     C                   EXSR      Sr2ndH2Parm                                                CSD015
     C     SH_RFTID      READE     FT101DL2                               49                  CSD015
                                                                                              CSD015
     C                   IF        PWatchString <> *BLANKS                                    CSD015
     C                   EXSR      Sr1stParm                                                  CSD015
     C                   EXSR      SrCallWatch                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDDO                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
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
     C                   Movel     SH_RFTID      Rft_ID
     C                   Exsr      RtvHdr2

     C     HdrFound      Ifeq      'Y'
     C                   Delete    FT101HL3                             90
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101HL3'    DBFILE
     C                   Z-add     04            DBASE
     C                   Movel     '*DELETE'     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif

     C                   Movel     'N'           Unlocked
     C                   Movel     DumpReq       RtvDump
     C                   Movel     SH_RFTID      Rft_ID
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

     C                   Movel     SH_RFTID      Rft_ID
     C     *IN90         Doweq     '0'
     C                   Exsr      DeleteD
     C     RFTMSG        Ifne      0
     C     RFTMSQ        andne     0
      **  Detach the message from the payment
     C                   Movel     SH_PYTP       PayType
     C                   Z-add     RFTMSG        MsgRefI
     C                   Z-add     RFTMSQ        MsgPartI
     C                   Movel     *BLANK        MsgStat
     C                   Exsr      SrFtst
     C                   Endif

     C     Rft_ID        Reade     FT101DL0                             9190
     C     *IN91         Ifeq      '1'
     C                   Unlock    FT101DL0
     C     DumpReq       Ifeq      'Y'
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101DL0'    DBFILE
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
     C                   Movel     'FTM101UPD'   DBPGM
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
     C                   Movel     SD_RFTID      Rft_ID
     C                   Movel     SD_TRNSID     TransID
     C                   Exsr      RtvDtl

     C     DtlFound      Ifeq      'Y'
     C                   Exsr      DeleteD
     C     SD_RFTMSG     Ifne      0
     C     SD_RFTMSQ     andne     0
      **  Detach the message from the payment
     C                   Movel     SH_PYTP       PayType
     C                   Z-add     SD_RFTMSG     MsgRefI
     C                   Z-add     SD_RFTMSQ     MsgPartI
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

     C     ActionCode    Ifeq      'I'
     C                   Clear                   FT101HD4
      *
      ** Call FTM1012GN to create unique RFT identifier
      ** Only call if it has not already created a RFTID
      *
     C                   IF        SH_RFTID = *BLANKS
     C
      ** Retrieve Transaction Number                                             177677
     C                   Eval      Trns_Type =  SH_PYTP                          177677
     C                   Exsr      RtvTrn                                        177677
     C                   Eval      SH_RFTID = P_Ref_Ds                           177677
     C                   Endif                                                   177677
     C*******************CALLB     'FTM1012GN'                                   177677
      ***OUTPUT*PARAMETERS                                                       177677
     C*******************PARM                    RetCodeIn                       177677
      ***INPUT*PARAMETERS                                                        177677
     C*******************PARM                    SH_PYTP                         177677
     C*******************PARM                    P_Ref_Ds                        177677
      *******************                                                        177677
     C*******************MOVEL     P_Ref_Ds      SH_RFTID                        177677
      *******************                                                        177677
     C*******************ENDIF                                                   177677

      ***Retrieve*Transaction*Number**                                     177677
     C*****UserPrf       Ifeq      '*STP'                                  177677
     C*******************Move      SH_PYTP       Trns_Type                 177677
     C*******************Exsr      RtvTrn                                  177677
     C*******************Move      P_Ref_Ds      SH_RFTID                  177677
     C*******************Endif                                             177677

     C                   Move      SH_RFTID      RFTID
      *                                                                          178751
      ** If sender's reference is blank, default it to RFT Id                    178751
      *                                                                          178751
     C                   If        SH_SNDREF = *blanks                           178751
     C                   Movel     RFTID         SH_SNDREF                       178751
     C                   Endif                                                   178751
      *                                                                          178751
     C                   Move      SH_SNDREF     SNDREF

     C                   Endif

     C                   Move      SH_STID       STID
     C                   Move      SH_PYTP       PYTP
     C                   Move      SH_PYST       PYST
     C                   Move      SH_BRCA       BRCA
     C                   Move      SH_ORBR       ORBR
     C                   Move      SH_BOKC       BOKC
     C                   Move      SH_PRFC       PRFC
     C                   Move      SH_CUSTRF     CUSTRF
     C                   Move      SH_HINPTY     HINPTY
     C                   Move      SH_HOCUS1     HOCUS1
     C                   Move      SH_HOCUS2     HOCUS2
     C                   Move      SH_HOCUS3     HOCUS3
     C                   Move      SH_HOCUS4     HOCUS4
     C                   Move      SH_HOCUS5     HOCUS5
     C                   Move      SH_CUSTTP     CUSTTP
     C                   Move      SH_ASITTP     ASITTP
     C                   Move      SH_HACSV1     HACSV1
     C                   Move      SH_HACSV2     HACSV2
     C                   Move      SH_SINST      SINST
     C                   Move      SH_EXDATE     EXDATE
     C                   Move      SH_DBTVDT     DBTVDT
     C                   Move      SH_AUTHTX     AUTHTX
     C                   Move      SH_HANDCG     HANDCG
     C                   Move      SH_HANDCY     HANDCY
     C                   Move      SH_HANDAC     HANDAC
     C                   Move      SH_SWPRIO     SWPRIO
     C                   Move      SH_RFTDST     RFTDST
     C                   MOVE      SH_RHMSGR     RHMSGR                         185107
     C**********         MOVE      SH_RSEQNO     RSEQNO                                221761 TDA020
     C                   MOVE      SH_RSEQNO     RSEQNOX                                      TDA020

     C     ActionCode    Ifeq      'I'
     C                   Move      UserPrf       INUSER
     C                   Z-add     BJRDNB        INDATE
     C                   Z-add     PSRuntime     INTIME
     C                   Move      UserPrf       SH_INUSER
     C                   Z-add     BJRDNB        SH_INDATE
     C                   Z-add     PSRuntime     SH_INTIME
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
      *                                                                         178384
     C                   Move      PSRuntime     UPDTIM
     C                   Move      UserPrf       SH_UPDUSR
     C*******            Move      PSDate        SH_UPDDTE                      178384
     C                   Move      PSRunDate     DateIn                         178384
     C                   CALLB     'ZDATE1'                                     178384
     C                   PARM                    DateIn                         178384
     C                   PARM      *ZEROS        DaynoOut                       178384
     C                   PARM      'M'           DatFmt                         178384
     C                   PARM      *BLANKS       ErrorFlag                      178384
                                                                                178384
     C                   Z-ADD     DaynoOut      SH_Upddte                      178384
      *                                                                         178384
     C                   Move      PSRuntime     SH_UPDTIM
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
     C                   Clear                   FT101DD0

     C                   Move      SH_RFTID      RFTID
      *                                                                         178751
      ** Retrieve sequence number                                               178751
      *                                                                         178751
     C                   Exsr      RtvSeq                                       178751
     C                   Movel     SEQNO         TSEQNO                         178751
      *                                                                         178751
      ** If transaction reference is blank, default it to RFTID + seqno         178751
      *                                                                         178751
     C                   If        SD_TRNSID = *blanks                          178751
     C                   Movel     RFTID         RFTID13                        178751
     C     RFTID13       Cat       SEQNO         SD_TRNSID                      178751
     C                   Endif                                                  178751
      *                                                                         178751
     C                   Move      SD_TRNSID     TRNSID

     C                   Endif

     C                   Move      SD_FXDREF     FXDREF
     C                   Move      SD_INSCA4     INSCA4
     C                   Move      SD_INSCB4     INSCB4
     C                   Move      SD_INSCC4     INSCC4
     C                   Move      SD_INSCD4     INSCD4
     C                   Move      SD_INSCE4     INSCE4
     C                   Move      SD_INSA31     INSA31
     C                   Move      SD_INSB31     INSB31
     C                   Move      SD_TRNCCY     TRNCCY
     C                   Move      SD_TRNAMT     TRNAMT
     C                   Move      SD_PAYCCY     PAYCCY
     C                   Move      SD_PAYAMT     PAYAMT
     C                   Move      SD_XRATE      XRATE
     C                   Move      SD_XRATEO     XRATEO
     C                   Move      SD_CRDVDT     CRDVDT
     C                   Move      SD_TINPTY     TINPTY
     C                   Move      SD_TOCUS1     TOCUS1
     C                   Move      SD_TOCUS2     TOCUS2
     C                   Move      SD_TOCUS3     TOCUS3
     C                   Move      SD_TOCUS4     TOCUS4
     C                   Move      SD_TOCUS5     TOCUS5
     C                   Move      SD_DCUSTP     DCUSTP
     C                   Move      SD_TASI35     TASI35
     C                   Move      SD_TACC11     TACC11
     C                   Move      SD_TINST1     TINST1
     C                   Move      SD_TINST2     TINST2
     C                   Move      SD_TINST3     TINST3
     C                   Move      SD_TINST4     TINST4
     C                   Move      SD_TINST5     TINST5
     C                   Move      SD_TINSTA     TINSTA
     C                   Move      SD_TACA35     TACA35
     C                   Move      SD_TACB35     TACB35
     C                   Move      SD_TACC35     TACC35
     C                   Move      SD_TACD35     TACD35
     C                   Move      SD_TACE35     TACE35
     C                   Move      SD_TACA11     TACA11
     C                   Move      SD_TBNA35     TBNA35
     C                   Move      SD_TBNB35     TBNB35
     C                   Move      SD_TBNC35     TBNC35
     C                   Move      SD_TBND35     TBND35
     C                   Move      SD_TBNE35     TBNE35
     C                   Move      SD_TRMA35     TRMA35
     C                   Move      SD_TRMB35     TRMB35
     C                   Move      SD_TRMC35     TRMC35
     C                   Move      SD_TRMD35     TRMD35
     C                   Move      SD_TRGA35     TRGA35
     C                   Move      SD_TRGB35     TRGB35
     C                   Move      SD_TRGC35     TRGC35
     C                   Move      SD_TOCCY      TOCCY
     C                   Move      SD_TOOAMT     TOOAMT
     C                   Move      SD_TDCHGS     TDCHGS
     C                   Move      SD_RCVCHG     RCVCHG
     C                   Move      SD_RCTCHG     RCTCHG
     C                   Move      SD_RCPCHG     RCPCHG
     C                   Move      SD_CHGACC     CHGACC
     C                   Move      SD_RCHCCY     RCHCCY
     C                   Move      SD_RCPCCY     RCPCCY
     C                   Move      SD_RCTCCY     RCTCCY
     C                   Move      SD_GOPFLG     GOPFLG
     C                   Move      SD_TFTRNT     TFTRNT
     C                   Move      SD_TFTREF     TFTREF
     C                   Move      SD_BENTTP     BENTTP
     C                   Move      SD_AWITTP     AWITTP
     C                   Move      SD_INTTTP     INTTTP
     C                   Move      SD_PYBCQS     PYBCQS
     C                   Move      SD_RFTMSQ     RFTMSQ
     C                   Move      SD_RFTMSG     RFTMSG

      ** Retrieve the spot rate of the PAY currency
     C                   If        SD_PAYCCY <> *Blanks
     C                   Move      SD_PAYCCY     CcyIn
     C                   Exsr      RtvCcy
     C                   Z-add     A6SPRT        PYBCQS
     C                   Endif

      ** Retrieve the spot rate of the Transfer currency
     C                   If        SD_TRNCCY <> *Blanks
     C                   Move      SD_TRNCCY     CcyIn
     C                   Exsr      RtvCcy
     C                   Z-add     A6SPRT        TFBCQS
     C                   Endif

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
                                                                                178384
     C                   Z-ADD     DaynoOut      Upddte                         178384
      *                                                                         178384
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
     C     *Like         Define    SH_PYTP       Trns_Type
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
     C                   Movel     'FTM101UPD'   DBPGM
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
     C                   Parm      PYTP          TrnType                        178751
     C                   Parm      RFTID         TrnId                          178751
     C                   Parm                    SeqNo                          178751
                                                                                178751
     C     *IN90         Ifeq      *On                                          178751
      ** *ERROR                                                                 178751
     C                   Movel     '*ERROR'      RetCodeIn                      178751
     C                   Movel     'FTM101UPD'   DBPGM                          178751
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
     C                   Movel     'FTM101UPD'   DBPGM
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
     C                   Movel     'FTM101UPD'   DBPGM
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
      ** Sender's Reference
      **                                         SenderRef
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
     C     KRftHdr1      Klist
     C                   Kfld                    SwiftID
     C                   Kfld                    SenderRef

     C     KRftHdr1      Setll     FT101HL4                               90
     C     *IN90         Ifeq      '1'
     C                   Movel     'Y'           HdrFound
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0003'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C     NfndDump      Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101HL4'    DBFILE
     C                   Z-add     11            DBASE
     C                   Movel     SenderRef     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif

      ** Reset input variables
     C                   Movel     *BLANK        NfndDump
     C                   Movel     *BLANK        SenderRef
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
      ** Sender's Reference
     C     *Like         Define    SH_SNDREF     SenderRef
      ** Swift identifier
     C     *Like         Define    SH_STID       SwiftID
      ** Lock/Unlock indicator
      **                                         Unlocked
      ** Dump if not found
     C     *Like         Define    DumpReq       RtvDump
      ** Outputs
      ** -------
      ** Fields of FT101HPD
      ** Header found
      **                                         HdrFound

      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtvHdr'      SrStack(q)

     C                   Clear                   FT101HD4
     C                   Movel     'Y'           HdrFound          1

     C     KRftHdr1      Setll     FT101HL4                               90
     C     *IN90         Ifeq      '0'
     C                   Movel     'N'           HdrFound
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0001'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C     RtvDump       Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101HL4'    DBFILE
     C                   Z-add     12            DBASE
     C                   Movel     SenderRef     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif

     C                   Else

     C     KRftHdr1      Reade     FT101HL4                             9190
     C     Unlocked      Ifeq      'Y'
     C                   Unlock    FT101HL4
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
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101HL4'    DBFILE
     C                   Z-add     13            DBASE
     C                   Movel     SenderRef     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
     C                   Endif

      ** Reset input variables
     C                   Movel     *BLANK        Unlocked
     C                   Movel     *BLANK        SenderRef
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
     C     *Like         Define    SH_RFTID      Rft_ID
      ** Lock/Unlock indicator
      **                                         Unlocked
      ** Dump if not found
      **                                         RtvDump
      ** Outputs
      ** -------
      ** Fields of FT101HPD
      ** Header found
      **                                         HdrFound

      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtvHdr2'     SrStack(q)

     C                   Clear                   FT101HD0
     C                   Movel     'Y'           HdrFound          1

     C     Rft_ID        Setll     FT101HL3                               90
     C     *IN90         Ifeq      '0'
     C                   Movel     'N'           HdrFound
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0001'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C     RtvDump       Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101HL3'    DBFILE
     C                   Z-add     14            DBASE
     C                   Movel     Rft_ID        DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
     C                   Else
     C     Rft_ID        Reade     FT101HL3                             9190
     C     Unlocked      Ifeq      'Y'
     C                   Unlock    FT101HL3
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
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101HL3'    DBFILE
     C                   Z-add     15            DBASE
     C                   Movel     SenderRef     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
     C                   Endif

      ** Reset input variables
     C                   Movel     *BLANK        Unlocked
     C                   Movel     *BLANK        Rft_ID

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
      ** RFT identifier
      **                                         Rft_ID
      ** Transaction ID
     C     *Like         Define    SD_TRNSID     TransID
      ** Lock/Unlock indicator
      **                                         Unlocked
      ** Dump if not found
      **                                         RtvDump
      ** Outputs
      ** -------
      ** Fields of FT101DPD
      ** Detail found
      **                                         DtlFound

      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtvDtl'      SrStack(q)

     C                   Clear                   FT101DD0
     C                   Movel     'Y'           DtlFound

     C     KRftDtl1      Setll     FT101DL0                               90
     C     *IN90         Ifeq      '0'
     C                   Movel     'N'           DtlFound
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0001'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C     RtvDump       Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101DL0'    DBFILE
     C                   Z-add     16            DBASE
     C                   Movel     TransID       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif

     C                   Else

     C     KRftDtl1      Reade     FT101DL0                             9190
     C     Unlocked      Ifeq      'Y'
     C                   Unlock    FT101DL0
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
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101DL0'    DBFILE
     C                   Z-add     17            DBASE
     C                   Movel     TransID       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
     C                   Endif

      ** Reset input variables
     C                   Movel     *BLANK        Unlocked          1
     C                   Movel     *BLANK        Rft_ID
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
      **                                         Rft_ID
      ** Lock/Unlock indicator
      **                                         Unlocked
      ** Dump if not found
      **                                         RtvDump
      ** Outputs
      ** -------
      ** Fields of FT101DPD
      ** Detail found
      **                                         DtlFound

      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtvDtl2'     SrStack(q)

     C                   Clear                   FT101DD0
     C                   Movel     'Y'           DtlFound          1

     C     Rft_ID        Setll     FT101DL0                               90
     C     *IN90         Ifeq      '0'
     C                   Movel     'N'           DtlFound
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0001'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C     RtvDump       Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101DL0'    DBFILE
     C                   Z-add     18            DBASE
     C                   Movel     Rft_ID        DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif

     C                   Else

     C     Rft_ID        Reade     FT101DL0                             9190
     C     Unlocked      Ifeq      'Y'
     C                   Unlock    FT101DL0
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
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101DL0'    DBFILE
     C                   Z-add     19            DBASE
     C                   Movel     Rft_ID        DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
     C                   Endif

      ** Reset input variables
     C                   Movel     *BLANK        Unlocked
     C                   Movel     *BLANK        Rft_ID
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
      ** RFT identifier
      **                                         Rft_ID
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
     C     KRftDtl1      Klist
     C                   Kfld                    Rft_ID
     C                   Kfld                    TransID

     C     KRftDtl1      Setll     FT101DL0                               90
     C     *IN90         Ifeq      '1'
     C                   Movel     'Y'           DtlFound
     C                   Add       1             E
     C                   Movel     SrStack(q)    FldNameArr(E)
     C                   Movel     'RFU0003'     MsgIdArr(E)
     C                   Movel     'N'           CommitChg                      177866
     C     NfndDump      Ifeq      'Y'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101DL0'    DBFILE
     C                   Z-add     20            DBASE
     C                   Movel     TransID       DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif

      ** Reset input variables
     C                   Movel     *BLANK        NfndDump
     C                   Movel     *BLANK        Rft_ID
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
     C                   EVAL      KIden = SH_RFTID                                           CSD015
     C                   EVAL      KBranch = SH_BRCA                                          CSD015
     C                   EVAL      W3UNCF = *BLANKS                                           CSD015
                                                                                              CSD015
     C     KFuncKey      CHAIN     SDCWHTL1                           48                      CSD015
                                                                                              CSD015
     C                   IF        (*IN48 = *OFF AND W3UNCF = 'Y') OR                         CSD015
     C                             (SH_HOCUS1 <> *BLANKS OR SH_HOCUS2 <> *BLANKS              CSD015
     C                             OR SH_HOCUS3 <> *BLANKS OR                                 CSD015
     C                             SH_HOCUS4 <> *BLANKS OR SH_HOCUS5 <> *BLANKS               CSD015
     C                             OR SH_HACSV1 <> *BLANKS OR                                 CSD015
     C                             SH_HACSV2 <> *BLANKS OR SH_SINST <> *BLANKS                CSD015
     C                             OR SH_RFTDST <> *BLANKS)                                   CSD015
                                                                                              CSD015
     C                   EXSR      Sr2ndHParm                                                 CSD015
     C                   IF        PWatchString <> *BLANKS                                    CSD015
     C                   EXSR      Sr1stParm                                                  CSD015
     C                   EXSR      SrCallWatch                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015

     C                   Write     FT101HD4                             90
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101HL4'    DBFILE
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
     C                   EVAL      KIden = SH_RFTID                                           CSD015
     C                   EVAL      KBranch = SH_BRCA                                          CSD015
     C                   EVAL      W3UNCF = *BLANKS                                           CSD015
                                                                                              CSD015
     C     KFuncKey      CHAIN     SDCWHTL1                           48                      CSD015
                                                                                              CSD015
     C                   IF        (*IN48 = *OFF AND W3UNCF = 'Y') OR                         CSD015
     C                             (SH_HOCUS1 <> *BLANKS OR SH_HOCUS2 <> *BLANKS              CSD015
     C                             OR SH_HOCUS3 <> *BLANKS OR                                 CSD015
     C                             SH_HOCUS4 <> *BLANKS OR SH_HOCUS5 <> *BLANKS               CSD015
     C                             OR SH_HACSV1 <> *BLANKS OR                                 CSD015
     C                             SH_HACSV2 <> *BLANKS OR SH_SINST <> *BLANKS                CSD015
     C                             OR SH_RFTDST <> *BLANKS OR                                 CSD015
     C                             SD_TOCUS1 <> *BLANKS OR SD_TOCUS2 <> *BLANKS               CSD015
     C                             OR SD_TOCUS3 <> *BLANKS OR                                 CSD015
     C                             SD_TOCUS4 <> *BLANKS OR SD_TOCUS5 <> *BLANKS               CSD015
     C                             OR SD_TASI35 <> *BLANKS OR                                 CSD015
     C                             SD_TACC11 <> *BLANKS OR SD_TINST1 <> *BLANKS               CSD015
     C                             OR SD_TINST2 <> *BLANKS OR                                 CSD015
     C                             SD_TINST3 <> *BLANKS OR SD_TINST4 <> *BLANKS               CSD015
     C                             OR SD_TINST5 <> *BLANKS OR                                 CSD015
     C                             SD_TACA11 <> *BLANKS OR SD_TACA35 <> *BLANKS               CSD015
     C                             OR SD_TACB35 <> *BLANKS OR                                 CSD015
     C                             SD_TACC35 <> *BLANKS OR SD_TACD35 <> *BLANKS               CSD015
     C                             OR SD_TACE35 <> *BLANKS OR                                 CSD015
     C                             SD_TBNA35 <> *BLANKS OR SD_TBNB35 <> *BLANKS               CSD015
     C                             OR SD_TBNC35 <> *BLANKS OR                                 CSD015
     C                             SD_TBND35 <> *BLANKS OR SD_TBNE35 <> *BLANKS               CSD015
     C                             OR SD_TRMA35 <> *BLANKS OR                                 CSD015
     C                             SD_TRMB35 <> *BLANKS OR SD_TRMC35 <> *BLANKS               CSD015
     C                             OR SD_TRMD35 <> *BLANKS)                                   CSD015
                                                                                              CSD015
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
     C     SH_RFTID      SETLL     FT101DL2                               49                  CSD015
     C     SH_RFTID      READE     FT101DL2                               49                  CSD015
     C                   DOW       *IN49 = *OFF                                               CSD015
     C                   EXSR      Sr2ndD2Parm                                                CSD015
     C                   EXSR      Sr2ndH2Parm                                                CSD015
                                                                                              CSD015
     C                   IF        PWatchString <> *BLANKS                                    CSD015
     C                   EXSR      Sr1stParm                                                  CSD015
     C                   EXSR      SrCallWatch                                                CSD015
     C                   ENDIF                                                                CSD015
     C     SH_RFTID      READE     FT101DL2                               49                  CSD015
     C                   ENDDO                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015

     C                   Write     FT101DD0                             90
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101DL0'    DBFILE
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

     C                   Update    FT101HD4                             90
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101HL4'    DBFILE
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

     C                   Update    FT101DD0                             90
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101DL0'    DBFILE
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
     C* UpdateH2 - UPDATE HEADER RECORD                                    *
     C*                                                                    *
     C**********************************************************************
     C     UpdateH2      BegSr

      ** Inputs
      ** -------
      ** *NONE

      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'UpdateH2'    SrStack(q)

     C                   Update    FT101HD0                             90
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101HL3'    DBFILE
     C                   Z-add     25            DBASE
     C                   Movel     '*UPDATE'     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif

      **  Unwind subroutine stack name
     C     UpdtH2_End    Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q

     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C*                                                                    *
     C* UpdateD2 - UPDATE DETAIL RECORD                                    *
     C*                                                                    *
     C**********************************************************************
     C     UpdateD2      BegSr

      ** Inputs
      ** -------
      ** *NONE

      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'UpdateD2'    SrStack(q)

     C                   Update    FT101DD0                             90
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101DL0'    DBFILE
     C                   Z-add     26            DBASE
     C                   Movel     '*UPDATE'     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif

      **  Unwind subroutine stack name
     C     UpdtD2_End    Tag
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

     C                   Delete    FT101DL0                             90
     C     *IN90         Ifeq      '1'
      ** *ERROR                                                            *
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'FT101DL0'    DBFILE
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
     C     *Like         Define    PYTP          PayType
      ** Message reference
     C     *Like         Define    SD_RFTMSG     MsgRefI
      ** Message part
     C     *Like         Define    SD_RFTMSQ     MsgPartI
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
     C                   Z-add     MsgRefI       FTMSGR
     C                   Z-add     MsgPartI      FTKPRT
      **  If the status of the message is blank we detach
      **  the message from the payment by removing the transaction ID
     C     PayType       Ifeq      'RI'
     C                   Movel     '*FT INC '    TypeTrn
     C                   Movel     MsgStat       FTINFG
     C     MsgStat       Ifne      *BLANK
     C     MsgStat       andne     'MIN0083'
     C                   Movel     BRCA          FTBRCA
     C                   Movel     RFTID         FTIPRF
     C                   Endif
     C                   Else
     C                   Movel     '*FT OUT '    TypeTrn
     C                   Movel     MsgStat       FTOTFG
     C     MsgStat       Ifne      *BLANK
     C     MsgStat       andne     'MIN0083'
     C                   Movel     BRCA          FTBRCA
     C                   Movel     RFTID         FTOPRF
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
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'ME1050  '    DBFILE
     C                   Z-add     27            DBASE
     C                   Movel     SD_RFTMSG     DBKEY
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

     C                   Z-ADD     SD_RFTMSG     W0MSGREF                       185660
     C                   Z-ADD     SD_RFTMSQ     W0MSGPRT                       185660

     C                   Call      'ME1070'                             90
     C                   Parm      '*DEL   '     Request           7
     C*******************Parm                    SD_RFTMSG                      185660
     C*******************Parm                    SD_RFTMSQ                      185660
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
     C                   Movel     'FTM101UPD'   DBPGM
     C                   Movel     'ME1070  '    DBFILE
     C                   Z-add     28            DBASE
     C                   Movel     SD_RFTMSG     DBKEY
     C                   Movel     SrStack(q)    DBPROC
     C                   Exsr      *PSSR
     C                   Endif

      **  Unwind subroutine stack name
     C     RMsg_End      Tag
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             Q

     C                   EndSr
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
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
     C                   EVAL      W4ITEM = 'FTREQT'                                          CSD015
     C                   EVAL      W4IDEN = SH_RFTID                                          CSD015
     C                   EVAL      W4BRCH = SH_BRCA                                           CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   EVAL      W4FUNT = 'FT101HPD'                                        CSD015
     C                   EXSR      SrGetCntrPty                                               CSD015
     C                   MOVE      *BLANKS       PInDate                                      CSD015
     C                   EXSR      SrCvtDate                                                  CSD015
     C                   MOVE      PAMDate       W4DDAT                                       CSD015
     C                   MOVE      SH_DBTVDT     PInDate                                      CSD015
     C                   EXSR      SrCvtDate                                                  CSD015
     C                   MOVE      PAMDate       W4VDAT                                       CSD015
     C                   MOVE      *BLANKS       PInDate                                      CSD015
     C                   EXSR      SrCvtDate                                                  CSD015
     C                   MOVE      PAMDate       W4MDAT                                       CSD015
     C                   IF        HdrInfo = 'Y'                                              CSD015
     C                   EVAL      W4DEN1 = SH_HANDCY                                         CSD015
     C                   MOVE      SH_HANDCG     PInAmt                                       CSD015
     C                   EVAL      PCurr = W4DEN1                                             CSD015
     C                   EXSR      SrCvtAmt                                                   CSD015
     C                   EVAL      W4AMT1 = PAMFlot                                           CSD015
     C                   EVAL      W4DEN2 = *BLANKS                                           CSD015
     C                   Z-ADD     *ZEROS        W4AMT2                                       CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4DEN1 = SD_TRNCCY                                         CSD015
     C                   MOVE      SD_TRNAMT     PInAmt                                       CSD015
     C                   EVAL      PCurr = W4DEN1                                             CSD015
     C                   EXSR      SrCvtAmt                                                   CSD015
     C                   EVAL      W4AMT1 = PAMFlot                                           CSD015
     C                   EVAL      W4DEN2 = SD_PAYCCY                                         CSD015
     C                   EVAL      PCurr = W4DEN2                                             CSD015
     C                   MOVE      SD_PAYAMT     PInAmt                                       CSD015
     C                   EXSR      SrCvtAmt                                                   CSD015
     C                   EVAL      W4AMT2 = PAMFlot                                           CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
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
     C                   IF        SH_RFTDST <> *BLANKS AND (ActionCode = 'I' OR              CSD015
     C                             ActionCode = 'A' AND                                       CSD015
     C                             (SH_RFTDST <> RFTDST OR W3UNCF = 'Y'))                     CSD015
     C                   EVAL      Pinput1 = SH_RFTDST                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(23))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(24))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        SH_HINPTY <> *BLANKS AND (ActionCode = 'I' OR              CSD015
     C                             ActionCode = 'A' AND                                       CSD015
     C                             (SH_HINPTY <> HINPTY OR W3UNCF = 'Y'))                     CSD015
     C                   EVAL      Pinput1 = SH_HINPTY                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(1))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(2))                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (SH_HOCUS1 <> *BLANKS OR SH_HOCUS2 <> *BLANKS              CSD015
     C                             OR SH_HOCUS3 <> *BLANKS OR                                 CSD015
     C                             SH_HOCUS4 <> *BLANKS OR SH_HOCUS5 <> *BLANKS)              CSD015
     C                   IF        ActionCode = 'I' OR (ActionCode = 'A' AND                  CSD015
     C                             (SH_HOCUS1 <> HOCUS1 OR SH_HOCUS2 <> HOCUS2                CSD015
     C                             OR SH_HOCUS3 <> HOCUS3 OR SH_HOCUS4 <> HOCUS4              CSD015
     C                             OR SH_HOCUS5 <> HOCUS5)) OR W3UNCF = 'Y'                   CSD015
     C                   EVAL      Pinput1 = SH_HOCUS1                                        CSD015
     C                   EVAL      Pinput2 = SH_HOCUS2                                        CSD015
     C                   EVAL      Pinput3 = SH_HOCUS3                                        CSD015
     C                   EVAL      Pinput4 = SH_HOCUS4                                        CSD015
     C                   EVAL      Pinput5 = SH_HOCUS5                                        CSD015
     C                   EVAL      PInCcy = SD_TRNCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(3))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(4))                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        SH_HACSV1 <> *BLANKS OR SH_HACSV2 <> *BLANKS               CSD015
     C                   IF        (ActionCode = 'I' AND SH_HACSV1 <> *BLANKS)                CSD015
     C                             OR (ActionCode = 'A' AND SH_HACSV1 <> HACSV1)              CSD015
     C                             OR (W3UNCF = 'Y' AND SH_HACSV1 <> *BLANKS)                 CSD015
     C                   EVAL      Pinput1 = SH_HACSV1                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(5))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))                      CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        (ActionCode = 'I' AND SH_HACSV2 <> *BLANKS)                CSD015
     C                             OR (ActionCode = 'A' AND SH_HACSV2 <> HACSV2)              CSD015
     C                             OR (W3UNCF = 'Y' AND SH_HACSV2 <> *BLANKS)                 CSD015
     C                   EVAL      Pinput1 = SH_HACSV2                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(5))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        SH_SINST <> *BLANKS AND (ActionCode = 'I' OR               CSD015
     C                             ActionCode = 'A' AND                                       CSD015
     C                             (SH_SINST <> SINST OR W3UNCF = 'Y'))                       CSD015
     C                   EVAL      Pinput1 = SH_SINST                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(21))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(22))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
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
     C     KRftID        CHAIN     FT101HLB                             50                    CSD015
     C                   IF        *IN50 = *OFF                                               CSD015
     C                   EVAL      PD_PAYCCY = SD_PAYCCY                                      CSD015
     C                   EVAL      PD_TRNCCY = SD_TRNCCY                                      CSD015
     C                   EXSR      Sr2ndH2Parm                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Setup second Detail parameter for Compliance Engine Program                          CSD015
                                                                                              CSD015
     C                   IF        SD_TINPTY <> *BLANKS AND (ActionCode = 'I' OR              CSD015
     C                             ActionCode = 'A' AND                                       CSD015
     C                             (SD_TINPTY <> TINPTY OR W3UNCF = 'Y'))                     CSD015
     C                   EVAL      Pinput1 = SD_TINPTY                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(15))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(16))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (SD_TOCUS1 <> *BLANKS OR SD_TOCUS2 <> *BLANKS              CSD015
     C                             OR SD_TOCUS3 <> *BLANKS OR                                 CSD015
     C                             SD_TOCUS4 <> *BLANKS OR SD_TOCUS5 <> *BLANKS)              CSD015
     C                   IF        ActionCode = 'I' OR (ActionCode = 'A' AND                  CSD015
     C                             SD_TOCUS1 <> TOCUS1 OR SD_TOCUS2 <> TOCUS2 OR              CSD015
     C                             SD_TOCUS3 <> TOCUS3 OR SD_TOCUS4 <> TOCUS4 OR              CSD015
     C                             SD_TOCUS5 <> TOCUS5) OR W3UNCF = 'Y'                       CSD015
     C                   EVAL      Pinput1 = SD_TOCUS1                                        CSD015
     C                   EVAL      Pinput2 = SD_TOCUS2                                        CSD015
     C                   EVAL      Pinput3 = SD_TOCUS3                                        CSD015
     C                   EVAL      Pinput4 = SD_TOCUS4                                        CSD015
     C                   EVAL      Pinput5 = SD_TOCUS5                                        CSD015
     C                   EVAL      PInCcy = SD_TRNCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(17))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(18))                     CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        SD_TASI35 <> *BLANKS OR SD_TACC11 <> *BLANKS               CSD015
     C                   IF        (ActionCode = 'I' AND SD_TASI35 <> *BLANKS)                CSD015
     C                             OR (ActionCode = 'A' AND SD_TASI35 <> TASI35)              CSD015
     C                             OR (W3UNCF = 'Y' AND SD_TASI35 <> *BLANKS)                 CSD015
     C                   EVAL      Pinput1 = SD_TASI35                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(5))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))                      CSD015
     C                   ELSE                                                                 CSD015
     C                   If        (ActionCode = 'I' and SD_TACC11 <> *Blanks)                CSD015
     C                             OR (ActionCode = 'A' and SD_TACC11 <> TACC11)              CSD015
     C                             or (W3UNCF = 'Y' and SD_TACC11 <> *Blanks)                 CSD015
     C                   Eval      Pinput1 = SD_TACC11                                        CSD015
     C                   Exsr      SrConvrt                                                   CSD015
     C                   Eval      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(19))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(20))                     CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (SD_TINST1 <> *BLANKS OR SD_TINST2 <> *BLANKS              CSD015
     C                             OR SD_TINST3 <> *BLANKS OR                                 CSD015
     C                             SD_TINST4 <> *BLANKS OR SD_TINST5 <> *BLANKS               CSD015
     C                             OR SD_TINSTA <> *BLANKS)                                   CSD015
     C                   IF        (ActionCode = 'I' AND SD_TINSTA <> *BLANKS)                CSD015
     C                             OR (ActionCode = 'A' AND SD_TINSTA <> TINSTA)              CSD015
     C                             OR (W3UNCF = 'Y' AND SD_TINSTA <> *BLANKS)                 CSD015
     C                   EVAL      Pinput1 = SD_TINSTA                                        CSD015
     C                   EVAL      Pinput1 = SD_PAYCCY                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(7))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(8))                      CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        ActionCode = 'I' OR (ActionCode = 'A' AND                  CSD015
     C                             (SD_TINST1 <> TINST1 OR SD_TINST2 <> TINST2                CSD015
     C                             OR SD_TINST3 <> TINST3 OR SD_TINST4 <> TINST4              CSD015
     C                             OR SD_TINST5 <> TINST5)) OR W3UNCF = 'Y'                   CSD015
     C                   EVAL      Pinput1 = SD_TINST1                                        CSD015
     C                   EVAL      Pinput2 = SD_TINST2                                        CSD015
     C                   EVAL      Pinput3 = SD_TINST3                                        CSD015
     C                   EVAL      Pinput4 = SD_TINST4                                        CSD015
     C                   EVAL      Pinput5 = SD_TINST5                                        CSD015
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(7))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(8))                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        SD_TACA35 <> *BLANKS OR SD_TACB35 <> *BLANKS               CSD015
     C                             OR SD_TACC35 <> TACC35 OR                                  CSD015
     C                             SD_TACD35 <> *BLANKS OR SD_TACE35 <> *BLANKS               CSD015
     C                             OR SD_TACA11 <> *BLANKS                                    CSD015
                                                                                              CSD015
     C                   IF        SD_TACA11 <> *BLANKS AND (ActionCode = 'I' OR              CSD015
     C                             ActionCode = 'A' AND                                       CSD015
     C                             (SD_TACA11 <> TACA11 OR W3UNCF = 'Y'))                     CSD015
     C                   EVAL      Pinput1 = SD_TACA11                                        CSD015
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(9))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(10))                     CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        ActionCode = 'I' OR (ActionCode = 'A' AND                  CSD015
     C                             ((SD_TACA35 <> TACA35 OR SD_TACB35 <> TACB35               CSD015
     C                             OR SD_TACC35 <> TACC35 OR SD_TACD35 <> TACD35              CSD015
     C                             OR SD_TACE35 <> TACE35)                                    CSD015
     C                             OR W3UNCF = 'Y'))                                          CSD015
     C                   EVAL      Pinput1 = SD_TACA35                                        CSD015
     C                   EVAL      Pinput2 = SD_TACB35                                        CSD015
     C                   EVAL      Pinput3 = SD_TACC35                                        CSD015
     C                   EVAL      Pinput4 = SD_TACD35                                        CSD015
     C                   EVAL      Pinput5 = SD_TACE35                                        CSD015
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(9))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(10))                     CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (SD_TBNA35 <> *BLANKS OR SD_TBNB35 <> *BLANKS              CSD015
     C                             or SD_TBNC35 <> *BLANKS OR                                 CSD015
     C                             SD_TBND35 <> *BLANKS OR SD_TBNE35 <> *BLANKS)              CSD015
     C                   IF        ActionCode = 'I' OR (ActionCode = 'A' AND                  CSD015
     C                             ((SD_TBNA35 <> TBNA35 OR SD_TBNB35 <> TBNB35               CSD015
     C                             OR SD_TBNC35 <> TBNC35 OR SD_TBND35 <> TBND35              CSD015
     C                             OR SD_TBNE35 <> TBNE35) OR W3UNCF = 'Y'))                  CSD015
     C                   EVAL      Pinput1 = SD_TBNA35                                        CSD015
     C                   EVAL      Pinput2 = SD_TBNB35                                        CSD015
     C                   EVAL      Pinput3 = SD_TBNC35                                        CSD015
     C                   EVAL      Pinput4 = SD_TBND35                                        CSD015
     C                   EVAL      Pinput5 = SD_TBNE35                                        CSD015
     C                   EVAL      PInCcy = SD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(11))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(12))                     CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (SD_TRMA35 <> *BLANKS OR SD_TRMB35 <> *BLANKS              CSD015
     C                             OR SD_TRMC35 <> *BLANKS OR                                 CSD015
     C                             SD_TRMD35 <> *BLANKS)                                      CSD015
     C                   IF        ActionCode = 'I' OR (ActionCode = 'A' AND                  CSD015
     C                             ((SD_TRMA35 <> TRMA35 OR SD_TRMB35 <> TRMB35               CSD015
     C                             OR SD_TRMC35 <> TRMC35 OR                                  CSD015
     C                             SD_TRMD35 <> TRMD35) or W3UNCF = 'Y'))                     CSD015
     C                   EVAL      Pinput1 = SD_TRMA35                                        CSD015
     C                   EVAL      Pinput2 = SD_TRMB35                                        CSD015
     C                   EVAL      Pinput3 = SD_TRMC35                                        CSD015
     C                   EVAL      Pinput4 = SD_TRMD35                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(13))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(14))                     CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
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
     C                   IF        PD_TINPTY <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PD_TINPTY                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(15))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(16))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PD_TOCUS1 <> *BLANKS OR PD_TOCUS2 <> *BLANKS               CSD015
     C                             OR PD_TOCUS3 <> *BLANKS OR                                 CSD015
     C                             PD_TOCUS4 <> *BLANKS OR PD_TOCUS5 <> *BLANKS               CSD015
     C                   EVAL      Pinput1 = PD_TOCUS1                                        CSD015
     C                   EVAL      Pinput2 = PD_TOCUS2                                        CSD015
     C                   EVAL      Pinput3 = PD_TOCUS3                                        CSD015
     C                   EVAL      Pinput4 = PD_TOCUS4                                        CSD015
     C                   EVAL      Pinput5 = PD_TOCUS5                                        CSD015
     C                   EVAL      PInCcy = PD_TRNCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(17))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(18))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PD_TASI35 <> *Blanks                                       CSD015
     C                   EVAL      Pinput1 = PD_TASI35                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(5))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))                      CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        PD_TACC11 <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PD_TACC11                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(19))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(20))                     CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PD_TINSTA <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PD_TINSTA                                        CSD015
     C                   EVAL      PInCcy = PD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(7))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(8))                      CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        (PD_TINST1 <> *BLANKS OR PD_TINST2 <> *BLANKS              CSD015
     C                             OR PD_TINST3 <> *BLANKS OR                                 CSD015
     C                             PD_TINST4 <> *BLANKS OR PD_TINST5 <> *BLANKS)              CSD015
     C                   EVAL      Pinput1 = PD_TINST1                                        CSD015
     C                   EVAL      Pinput2 = PD_TINST2                                        CSD015
     C                   EVAL      Pinput3 = PD_TINST3                                        CSD015
     C                   EVAL      Pinput4 = PD_TINST4                                        CSD015
     C                   EVAL      Pinput5 = PD_TINST5                                        CSD015
     C                   EVAL      PInCcy = PD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(7))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(8))                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PD_TACA11 <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PD_TACA11                                        CSD015
     C                   EVAL      PInCcy = PD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(9))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(10))                     CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        PD_TACA35 <> TACA35 OR PD_TACB35 <> TACB35                 CSD015
     C                             OR PD_TACC35 <> TACC35 OR PD_TACD35 <> TACD35              CSD015
     C                             OR PD_TACE35 <> TACE35                                     CSD015
     C                   EVAL      Pinput1 = PD_TACA35                                        CSD015
     C                   EVAL      Pinput2 = PD_TACB35                                        CSD015
     C                   EVAL      Pinput3 = PD_TACC35                                        CSD015
     C                   EVAL      Pinput4 = PD_TACD35                                        CSD015
     C                   EVAL      Pinput5 = PD_TACE35                                        CSD015
     C                   EVAL      PInCcy = PD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(9))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(10))                     CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (PD_TBNA35 <> *BLANKS OR PD_TBNB35 <> *BLANKS              CSD015
     C                             OR PD_TBNC35 <> *BLANKS OR                                 CSD015
     C                             PD_TBND35 <> *BLANKS OR PD_TBNE35 <> *BLANKS)              CSD015
     C                   EVAL      Pinput1 = PD_TBNA35                                        CSD015
     C                   EVAL      Pinput2 = PD_TBNB35                                        CSD015
     C                   EVAL      Pinput3 = PD_TBNC35                                        CSD015
     C                   EVAL      Pinput4 = PD_TBND35                                        CSD015
     C                   EVAL      Pinput5 = PD_TBNE35                                        CSD015
     C                   EVAL      PInCcy = PD_PAYCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(11))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(12))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (PD_TRMA35 <> *BLANKS OR PD_TRMB35 <> *BLANKS              CSD015
     C                             OR PD_TRMC35 <> *BLANKS OR                                 CSD015
     C                             PD_TRMD35 <> *BLANKS)                                      CSD015
     C                   EVAL      Pinput1 = PD_TRMA35                                        CSD015
     C                   EVAL      Pinput2 = PD_TRMB35                                        CSD015
     C                   EVAL      Pinput3 = PD_TRMC35                                        CSD015
     C                   EVAL      Pinput4 = PD_TRMD35                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(13))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(14))                     CSD015
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
     C                   IF        PH_RFTDST <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PH_RFTDST                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(23))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(24))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PH_HINPTY <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PH_HINPTY                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(1))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(2))                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (PH_HOCUS1 <> *BLANKS OR PH_HOCUS2 <> *BLANKS              CSD015
     C                             OR PH_HOCUS3 <> *BLANKS OR                                 CSD015
     C                             PH_HOCUS4 <> *BLANKS OR PH_HOCUS5 <> *BLANKS)              CSD015
     C                   EVAL      Pinput1 = PH_HOCUS1                                        CSD015
     C                   EVAL      Pinput2 = PH_HOCUS2                                        CSD015
     C                   EVAL      Pinput3 = PH_HOCUS3                                        CSD015
     C                   EVAL      Pinput4 = PH_HOCUS4                                        CSD015
     C                   EVAL      Pinput5 = PH_HOCUS5                                        CSD015
     C                   EVAL      PInCcy = PD_TRNCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(3))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(4))                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PH_HACSV1 <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PH_HACSV1                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(5))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))                      CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        PH_HACSV2 <> *BLANKS                                       CSD015
     C                   EVAL      Pinput1 = PH_HACSV2                                        CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(5))                                       CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PH_SINST <> *BLANKS                                        CSD015
     C                   EVAL      Pinput1 = PH_SINST                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      PWatchString = %Trim(PWatchString)                         CSD015
     C                             + %Trim(Arrwatch(21))                                      CSD015
     C                             + %Trim(POutput) + %Trim(ArrWatch(22))                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
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
      ** Clear variable strings and input paramaters                                          CSD015
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
     C                   PARM      *BLANKS       POutDate                                     CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  SrCvtAmt - Convert amounts for Watch Engine Program          *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrCvtAmt      BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CALL      'ZACVTAMT'                                                 CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM                    PCurr                                        CSD015
     C                   PARM                    PInAmt                                       CSD015
     C                   PARM                    PAMFLOT                                      CSD015
     C                   PARM      *ZEROS        POutAmt                                      CSD015
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
     C                   IF        SH_PYTP = 'RI'                                             CSD015
     C                   EVAL      PInput1 = SH_HOCUS1                                        CSD015
     C                   EVAL      PInCcy = SD_TRNCCY                                         CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      W4CNUM = PCOutput                                          CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      PInput1 = SH_RFTDST                                        CSD015
     C                   EVAL      PInCcy = *BLANKS                                           CSD015
     C                   EXSR      SrConvrt                                                   CSD015
     C                   EVAL      W4CNUM = PCOutput                                          CSD015
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
     C                   MOVE      *BLANKS       PKey                                         CSD015
     C                   MOVEL     W4CNUM        PKey                                         CSD015
                                                                                              CSD015
     C                   CALL      'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM      '*KEY   '     POption                                      CSD015
     C                   PARM                    PKey                                         CSD015
     C                   PARM      *BLANKS       PStatus                                      CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank, then issue database error                                  CSD015
                                                                                              CSD015
     C                   IF        PRtnCode <> *BLANKS AND PRtnCode <> '*NRF'                 CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = W4CNUM                                             CSD015
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        CSD015
     C                   EVAL      DBASE = 34                                                 CSD015
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
     C                             AND W1IND2 <> BBLICD AND W1IND3 <> BBLICD                  CSD015
     C                             AND W1IND4 <> BBLICD AND W1IND5 <> BBLICD                  CSD015
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
     C                   EVAL      RPRGMN = 'FTM101UPD'                                       CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   EVAL      RCHTYP = 'I'                                               CRE020
     C                   EVAL      RSEQNO = '000'                                             CRE020
     C                   EVAL      RREFNO = SH_RFTID                                          CRE020
     C                   EVAL      RTRTYP = SH_PYTP                                           CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   WRITE     READVCD0                                                   CRE020
                                                                                              CRE020
      ** Also write the transaction details to the Advice File                                CRE020
                                                                                              CRE020
     C     SH_RFTID      SETLL     FT101DL0                                                   CRE020
     C     SH_RFTID      READE     FT101DL0                                                   CRE020
                                                                                              CRE020
     C                   DOW       NOT %EOF(FT101DL0)                                         CRE020
                                                                                              CRE020
     C                   EVAL      RSEQNO = %SUBST(TRNSID:14:3)                               CRE020
     C                   WRITE     READVCD0                                                   CRE020
                                                                                              CRE020
     C     SH_RFTID      READE     FT101DL0                                                   CRE020
                                                                                              CRE020
     C                   ENDDO                                                                CRE020
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

      ** Return Code
     C                   Parm                    RetCodeIn

      ** Action Code
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
     C                   Parm                    OldRftID

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

     C**********         Exsr      RtvJob                                                   BUG15235
     C*****UserPrf       Ifeq      '*STP'                                                   BUG15235
     C**********         Movel     'Y'           DumpReq                                    BUG15235
     C**********         Else                                                               BUG15235
     C**********         Movel     'N'           DumpReq                                    BUG15235
     C**********         Endif                                                              BUG15235

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
                                                                                              CSD015
      ** Check if Compliance Watch Enhancement (CSD015) is installed                          CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRtnCode <> *BLANKS AND                                    CSD015
     C                             PRtnCode <> '*NRF'                                         CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 030                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtnCode = *BLANKS                                         CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   EVAL      KFuncCode = 'FT101HPD'                                     CSD015
                                                                                              CSD015
      ** Check if function code is being monitored by the compliance watch                    CSD015
                                                                                              CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM      '*KEY'        POption                                      CSD015
     C                   PARM      'TRANSREQ'    PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank, then issue database error                                  CSD015
                                                                                              CSD015
     C                   IF        PRtnCode <> *BLANKS AND PRtnCode <> '*NRF'                 CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'TRANSREQ'                                         CSD015
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBASE = 031                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check for Watch List Configuration Data File                                         CSD015
                                                                                              CSD015
     C                   CALLB     'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM      '*FIRST'      POption                                      CSD015
     C     SDCWCD        PARM      SDCWCD        DSFDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank, then issue database error                                  CSD015
                                                                                              CSD015
     C                   IF        PRtnCode <> *BLANKS AND PRtnCode <> '*NRF'                 CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = '*FIRST'                                           CSD015
     C                   EVAL      DBFILE = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBASE = 032                                                CSD015
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
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSC011'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRtnCode <> *BLANKS AND PRtnCode <> '*NRF'                 CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSC011'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 033                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtnCode = *BLANKS                                         CSD015
     C                   EVAL      CSC011 = 'Y'                                               CSD015
     C                   IN        SC24X7                                                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
      **                                                                                      CSC022
      ** Access SAR details to see if CSC022 is switched on                                   CSC022
      **                                                                                      CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *Blanks       PRtnCode                                     CSC022
     C                   Parm      '*VERIFY'     POption                                      CSC022
     C                   Parm      'CSC022'      PSard                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      ** Initialize CSC022 and Skip Commit Flags                                              CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpComtRolbk = 'N'                                        CSC022
      **                                                                                      CSC022
     C                   If        PRtnCode = *BLANKS                                         CSC022
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
     C                   If        PRtnCode <> '*NRF'                                         CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBPgm  = 'FTM101UPD'                                       CSC022
     C                   Eval      DBKey  = 'CSC022'                                          CSC022
     C                   Eval      DBase  = 35                                                CSC022
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
     C                   PARM      '*VERIFY'     POption                                      CRE020
     C                   PARM      'CRE020'      PSard                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   IF        PRtnCode = *BLANKS                                         CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Database Error for SAR File                                                          CRE020
                                                                                              CRE020
     C                   IF        PRtnCode <> *BLANKS AND                                    CRE020
     C                             PRtnCode <> '*NRF'                                         CRE020
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBASE = 036                                                CRE020
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
     C                   EVAL      DBASE = 037                                                CRE020
     C                   EVAL      DBKEY = PsValOpt                                           CRE020
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
      ** Key list for FT101HLB                                                                CSD015
                                                                                              CSD015
     C     KRftId        KLIST                                                                CSD015
     C                   KFLD                    SH_PYTP                                      CSD015
     C                   KFLD                    SH_RFTID                                     CSD015

     C                   EndSr
     C**********************************************************************
      /EJECT
     C**********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      **********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  ArrWatch                                                                                  CSD015
<Header Instructing Party>                                                                    CSD015
</Header Instructing Party>                                                                   CSD015
<Header Ordering Customer>                                                                    CSD015
</Header Ordering Customer>                                                                   CSD015
<Header Acc Servicing Inst>                                                                   CSD015
</Header Acc Servicing Inst>                                                                  CSD015
<Intermediary>                                                                                CSD015
</Intermediary>                                                                               CSD015
<Account With Institution>                                                                    CSD015
</Account With Institution>                                                                   CSD015
<Beneficiary>                                                                                 CSD015
</Beneficiary>                                                                                CSD015
<Remittance Information>                                                                      CSD015
</Remittance Information>                                                                     CSD015
<Instructing Party>                                                                           CSD015
</Instructing Party>                                                                          CSD015
<Ordering Customer>                                                                           CSD015
</Ordering Customer>                                                                          CSD015
<Account Servicing Inst>                                                                      CSD015
</Account Servicing Inst>                                                                     CSD015
<Header Sending Institution>                                                                  CSD015
</Header Sending Institution>                                                                 CSD015
<Header Destination>                                                                          CSD015
</Header Destination>                                                                         CSD015
