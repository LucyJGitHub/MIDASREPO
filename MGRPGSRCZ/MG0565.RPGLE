     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MG Format MT565 message')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  MG0565 - Generation of MT565 Message                         *
      *                                                               *
      *  Function:  This program will generate MT565 messages         *
      *             from extract file and output them to              *
      *             MGOMSGPD and MGOREFPD                             *
      *                                                               *
      *  Component of: SEC7610 SE Treaty Withholding Tax Extract      *
      *                and Report Generation.                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW216             Date 14Mar16               *
      *                 MD027477A          Date 26Jun14               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001             Date 18Dec03               *
      *                 CGL029             Date 01Sep03               *
      *                 222385             Date 23Oct03               *
      *                 221145             Date 08Sep03               *
      *                 219242             Date 01Jul03               *
      *                 219241             Date 01Jul03               *
      *                 CSW203             Date 26May03               *
      *                 CSD015             Date 03Mar02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209547             Date 17Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW025             Date 26Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 197311             Date 29Aug01               *
      *                 CSE028             Date 06Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 187622             Date 05Jan01               *
      *                 187801             Date 18Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186790             Date 23Nov00               *
      *                 185915             Date 06Nov00               *
      *                 185792             Date 02Nov00               *
      *                 185770             Date 01Nov00               *
      *                 185763             Date 01Nov00               *
      *                 185733             Date 01Nov00               *
      *                 185719             Date 31Oct00               *
      *                 185740             Date 25Oct00               *
      *                 185397             Date 24Oct00               *
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW216 - SWIFT Changes 2016                                  *
      *  MD027477A - No MT565 generated in MMM after COB              *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing (Recompiled)                      *
      *  222385 - SWIFT msgs are Watch List checked regardless of     *
      *           configuration file setting                          *
      *  221145 - Compliance Watch WLC: Move compliance check to      *
      *           after COMIT to MGOMSGPD                             *
      *  219242 - Not possible to create MT103+ payment msg from      *
      *           non-FT transaction (Recompile)                      *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value (Recompile)                            *
      *  CSW203 - SWIFT 2003 Standards Update                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  209547 - Market Centre parameter added to SESSIR0 by CSE034  *
      *           is missing from call.                               *
      *  CSW025 - Midas Message Manager                               *
      *           - Pass original change type                         *
      *  197311 - Field 20C in seq D should be omitted.               *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *  187622 - Incorrect and unable to format Total nominal        *
      *           holding for field 93B:                              *
      *  187801 - Correct message format for OID maturity.            *
      *  186790 - Invalid text tag and missing ':' in some of the     *
      *           fields.                                             *
      *  185915 - Safe custody account only allow 6 alpha. Change to  *
      *           20 alpha.                                           *
      *  185792 - Total Nominal incorrect in :36B                     *
      *  185770 - Nominal Amount is 100x too small                    *
      *  185763 - For Share, TAB 36B should be 'UNIT'                 *
      *  185733 - Additional use of Safekeeping A/C from SSI          *
      *  185719 - MG0565 unable to show up on message management      *
      *           enquiry.                                            *
      *  185740 - DBERR at 008 file SDSECSPD key *KEY                 *
      *  185397 - Problem with manual deletion position settlement.   *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Main input file READ                            *
      *   02-03       File processing (CHAIN/READ)                    *
      *    04         SET pointer in file                             *
      *    05         Call to ZM1100                                  *
      *    06         Call to ZM0060                                  *
      *    07         LOOKUP 'ARDICD' array                           *
      *               LOOKUP 'ARMSGT' array                           *
      *    08         Call to ZM1240                                  *
      *    09         Write to MGOREFPD                               *
      *    10         Write to MGOMSGPD                               *
      *    11         Error reading POSETW4 file                      *
      *    12         Call to MG9505                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProc - Detail Processing                                   *
      *  SRGenNewMsg - Generate New Message                           *
      *  SRRout - Determine Message Routing                           *
      *  SRFmtSeqA - Format Sequence A message                        *
      *  SRFmtSeqB - Format Sequence B message                        *
      *  SRFmtSeqB2 - Format Sequence B2 message                      *
      *  SRSfKpAcc - Get Safekeeping account                          *
      *  SRGetSecDet - Get Security Details                           *
      *  SRFmtSeqC - Format Sequence C message                        *
      *  SRBeneDet - Get Beneficiary Owner Details                    *
      *  SRTaxRate - Get Tax Rate                                     *
      *  SRFmtSeqD - Format Sequence D message                        *
      *  SRMTag - Access tag/field description details                *
      *  SRPError - Process for errors                                *
      *  SRPMsgGen - Print message generated details                  *
      *  SRUpdPos - Update Position Settlement                        *
      *  SRORef - Output to PF/MGOREFPD                               *
      *  SROMsg - Output to PF/MGOMSGPD                               *
      *  SREdtAmt - Edit amount to have comma and decimal point       *
      *  SREdtNoml - Edit Nominal Amount in SWIFT Format              *         185770
      *  *INZSR - Initialise                                          *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FMGF565L0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(MG_)
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     FINVTP     IF   E           K DISK    iNFSR(*PSSR)                         185763
     FSDBNFOL2  IF   E           K DISK    INFSR(*PSSR)
     FSDMTAGL0  IF   E           K DISK    INFSR(*PSSR)
     FSDEXEML1  IF   E           K DISK    INFSR(*PSSR)
     FSDINCCL1  IF   E           K DISK    INFSR(*PSSR)
     FSDRPCDL1  IF   E           K DISK    INFSR(*PSSR)
     FSTDSED    IF   E           K DISK                                         185733
     FPOSETW2   UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(POSETDF:W2POSETDF)
     F                                     PREFIX(W2_)
     FMGOMSGLA  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MGOMSGD0:MGMSGLA)
     F                                     PREFIX(A)
     FMGOREFL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MGOREFD0:MGREFL0)
     F                                     PREFIX(I)
     FMGOREFPD  O    E             DISK    INFSR(*PSSR)
     FMGOMSGPD  O    E             DISK    INFSR(*PSSR)
     FMG0565A1  O    E             PRINTER INFDS(OVRFL1)
     F                                     INFSR(*PSSR)
     FMG0565A2  O    E             PRINTER INFDS(OVRFL2)
     F                                     INFSR(*PSSR)
     F                                     USROPN
     FMG0565AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
     F                                     USROPN
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     DARDICD           S              6    DIM(10)
      ** Array holding the Depot Reference from SE ICD record.
 
     DARSEDET          S              6    DIM(10)
      ** Array holding the Depot Reference from SE Customer record.
 
     DARMSGST          S              3    DIM(15)
      ** Array holding the default status released from PF/SDCUSTPD
 
     DARERR            S             50    DIM(6) CTDATA PERRCD(1)
      ** Array holding the error narratives
 
     D OVRFL1          DS
     D   WWOfl1              188    189B 0
     D   WWPtl1              367    368B 0
      ** File Information Data Structure for MG0565A1.
 
     D OVRFL2          DS
     D   WWOfl2              188    189B 0
     D   WWPtl2              367    368B 0
      ** File Information Data Structure for MG0565A2.
 
     D SPOOLU          DS
     D   WFileU               83     92
     D   WFNumU              123    124B 0
      ** File Information Data Structure for MG0565AU.
 
     D WMultOcur       DS                  OCCURS(500)
     D   WMDes                 1     36
     D   WMTag                37     41
     D   WMDat                42     91
     D   WMErr                92    141
     D   WRDat               142    191
     D   WMSeq               192    194
      ** Multiple occurrence data structure for message
 
     D WMultOcur2      DS                  OCCURS(500)
     D   MTAG                  1      5
     D   MFLD                  6     55
     D   CTRC                 56     57
     D   TRNOX                58     73
     D   PTDL                 74     74
     D   MSEQ                 75     77
      ** Multiple occurrence data structure for PF/MGOMSGPD
 
     D DBERR           DS            20
     D   WModi                 1      2
     D   WW0317                3     17
      ** Data Structure for DB Error
 
     D DBERR1          DS            26
     D   PSndr                 1      6
     D   PScsd                 7     18
     D   PDest                19     24
     D   PSetp                25     26
      ** Data Structure for DB Error in PGM/ZM1100
 
     D DBERR2          DS            16
     D   WAmt                  1     13
     D   WCcy                 14     16
      ** Data Structure for DB Error in PGM/ZM1240
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Externally described DS for currency details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Externally described DS for branch details
 
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      ** Externally described DS for message management details
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** Externally described DS for bank details
 
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      ** Externally described DS for security customer details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D A_QQDFAC      E                     EXTFLD(QQDFAC)                                     CGL029
      ** Externally described DS for customer details
 
      ** Externam DS SC Switchable Features                                                   CSE028
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE028
     D                                     PREFIX(W_)                                         CSE028
                                                                                              CSE028
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access objects - short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access objects - long data structure
 
      ** DS for input file
     D InPoset       E DS                  EXTNAME(MGF565PD)
     D                                     PREFIX(MG_)
 
      ** DS for PF/MGOREFPD
     D MGRefPDDS     E DS                  EXTNAME(MGOREFPD)
 
      ** DS for PF/MGOREFL0
     D MGRefL0DS     E DS                  EXTNAME(MGOREFL0)
     D                                     PREFIX(I)
 
      ** DS for work file
     D WrkPoset      E DS                  EXTNAME(MGF565PD)
     D                                     PREFIX(WK_)
                                                                                              CSE028
      ** DS for customer/book standard settlement instruction                                 CSE028
      **  to be passed to SESSIR0                                                             CSE028
     D PCBStd        E DS                  EXTNAME(STDSED)                                    CSE028
     D                                     OCCURS(2)                                          CSE028
                                                                                              CSE028
      ** Data structure for standard additional settlement details                            CSE028
      ** for customer/book to be passed to SESSIR0                                            CSE028
     D PCBStdAd      E DS                  EXTNAME(STDADSED)                                  CSE028
     D                                     OCCURS(8)                                          CSE028
 
     D                 DS
     D   WCrlf                 1      2
     D   WWCr                  1      1
     D   WWLf                  2      2
 
     D WLTDS         E DS                  EXTNAME(SDWLTDPD)                                  CSD015
      ** DS For Watch List Transaction Details File                                           CSD015
                                                                                              CSD015
     D PString         DS          9999                                                       CSD015
                                                                                              CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  222385
      ** Watch list checking details                                                          222385
                                                                                              222385
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters used in the program
 
     D PRtcd           S              7
     D POptn           S              7
     D PSard           S              6                                                       CSE028
     D PBrcd           S              3
     D PNwsn           S             20
     D PNWds           S             22
     D PNwrk           S              6
     D PErrc           S              1
     D PSrnm           S             20
     D PSrtn           S             10
     D PDrnm           S             20
     D PDrtn           S             10
     D PCust           S              6
     D PCustK          S             10
     D PKySt           S              7
     D PCrtx           S              2
     D PTxbs           S              2
     D PPsvl           S              5  0
     D PNarr           S             15
     D PTxrt           S              6  4
     D PDayNo          S              5  0
     D PDateOut        S              6  0
     D PADateOut       S              7A
     D PMDay           S              5  0
     D PWDate          S              6
     D PAmt            S             13  0
     D PCcy            S              3
     D PCurr           S              3                                                       187801
     D PSAmt           S             17
     D POAmt           S             21
     D PSCcy           S              3
     D PErr            S              1
     D PWSeq           S              5
     D PWSenty         S              3
     D PSNumu          S              6  0
     D PSErr           S              1
     D PTNum           S             16
     D PRtnc           S              1
     D POType          S              1                                                       CSE028
     D PRetCode        S              5                                                       CSE028
 
      ** Work variables
 
     D KSequence       S              3
     D KType           S              3
     D KBenOwnNo       S             26
     D KCtyTty         S              2
     D KCustNo         S              6
     D KCrtt           S              2
     D KCode           S              2
 
     D*WIdx1*****      S              2  0                                      186790
     D WIdx1           S              3  0                                      186790
     D*WIdx2*****      S              2  0                                      185792
     D*WIdx3*****      S              2  0                                      185792
     D WIdx2           S              3  0                                      185792
     D WIdx3           S              3  0                                      185792
     D WIdx4           S              3  0
     D WOcurIdx        S              3  0
     D WOcurIdx2       S              3  0
     D WBenOwnNme      S             35
     D WBenAdd1        S             35
     D WBenAdd2        S             35
     D WBenAdd3        S             35
     D*WCntPty**       S              6  0                                                    CSD027
     D WCntPty         S              6                                                       CSD027
     D WDepo           S              6
     D WPcpy           S              6
     D WDserr          S             50
     D WNwerr          S             50
     D WError          S              1
     D WEvnType        S              2
     D WPCntPty        S              6  0
     D WPSecurity      S             10
     D WSecurity       S             10
     D WPValDat        S              5  0
     D WValDat         S              5  0
     D WPEvnType       S              2
     D WPosSetRefNum   S              6  0
     D WPtnSet         S              6
     D WHDate          S              5  0
     D WMsgGenFlg      S              1
     D WPrtErrFlg      S              1
     D WCanFlg         S              1
     D WRun            S              1
     D*WSafKpAcc*******S              6                                         185915
     D WSafKpAcc       S             20                                         185915
     D WTaxRate        S             11  7
     D WTaxRateC       S             12
     D WTPnmp          S             15  0
     D WWMDat          S             50
     D WWLine          S              2  0
     D WSequence       S              2
     D WPSeq           S              3
     D WPSeq2          S              3
     D WPSeq3          S              3  0
     D WPref           S              6
     D WPPref          S              6
     D WPsvl           S              5
     D WMsgKey         S             16
     D WOMsgKey        S             16
     D*WBlock*******   S              4                                                       186790
     D W_SITP          S                   LIKE(SITP)                                         186790
     D W_KeyWord       S              5                                                       186790
     D CSE028          S              1                                                       CSE028
     D CSD015          S              1                                                       CSD015
     D CSW025          S              1                                                       CSD015
     D PARLS           S              1                                                       CSD015
 
      ** Parameter for ZACVTDATE                                                              CSD015
     D ReturnCode      S             10                                                       CSD015
     D PInDate         S              5                                                       CSD015
     D POutDate        S               D                                                      CSD015
     D PCvtdDate       S             10                                                       CSD015
                                                                                              CSD015
     D WBenAdd4        S             35                                                       CSW203
     D CSW203          S              1                                                       CSW203
                                                                                              CSW203
     D CSW216          S              1                                                       CSW216
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Process inputs.
 
     C                   EXSR      SRProc
 
      ** End the program
 
     C                   EVAL      *INLR = *ON
 
      ** Return.
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Detail processing                                   *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
 
     C                   EVAL      *IN01 = *OFF
     C     *LOVAL        SETLL     MGF565L0                               01
     C                   DOW       *IN01 = *OFF
 
     C                   READ      MGF565L0                               01
 
     C                   EVAL      WPref = MG_PREF
 
      ** If EOF or change of key and Sequence C already being written
 
     C                   IF        WPref <> WPPref AND
     C                             WSequence = 'C' OR
     C                             *IN01 = *ON AND WSequence = 'C'
 
      ** Format Sequence D
 
     C                   EXSR      SRFmtSeqD
 
      ** If no error in formatting of message fields
 
     C                   IF        WError = 'N'
 
      ** ... output to PF/MGOREFPD
 
     C                   EXSR      SRORef
 
      ** ... output to PF/MGOMSGPD
 
     C                   EXSR      SROMsg
 
      ** ... print message generated details
 
     C                   EXSR      SRPMsgGen
     C                   EVAL      WMsgGenFlg = 'Y'
 
      ** ... update Position record
 
     C                   EXSR      SRUpdPos
 
      ** Comit all changes to file
 
     C                   COMMIT
      *                                                                         221145
      **  Call Compliance Watch:Watch List Checking                             221145
      *                                                                         221145
     C                   IF        CSD015 = 'Y' and CSW025 = 'N'                221145
     C                             AND W1EWLC = 'Y'                                           222385
     C                   EXSR      WLCDQ                                        221145
     C                   ENDIF                                                  221145
 
     C                   EVAL      WCanFlg = 'N'
 
      ** Otherwise,
 
     C                   ELSE
 
      ** ... print error message
 
     C                   EXSR      SRPError
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN01 = *OFF
 
      ** If Change of key
 
     C                   IF        WPref <> WPPref
 
     C                   EVAL      WrkPoset = InPoset
 
      ** Initialise non-constant fields
 
     C                   EXSR      SRInitF
 
     C                   EVAL      WPSeq3 = MG_PSEQ - 1
     C                   MOVE      WPSeq3        WPSeq2
     C                   EVAL      WMsgKey = 'SEP' + WPref + WPseq2
 
     C                   IF        WMsgKey <> WOMsgKey and MG_MT5G = 'R'
     C                             OR WMsgKey <> WOMsgKey and MG_MT5G = 'C'
     C                   EXSR      SRGenCanMsg
     C                   EVAL      WOMsgKey = WMsgKey
     C                   EXSR      SRInitF
     C                   ENDIF
 
     C                   IF        MG_MT5G = 'N' or MG_MT5G = 'R' AND
     C                             MG_CHTP <> 'D'
 
     C                   IF        MG_MT5G = 'R' AND WCanFlg = 'Y'
     C                   EVAL      MG_PSEQ = MG_PSEQ + 1
     C                   EVAL      WK_PSEQ = MG_PSEQ
     C                   ENDIF
 
     C                   EXSR      SRGenNewMsg
     C                   EXSR      SRFmtSeqA
     C                   EXSR      SRFmtSeqB
 
     C                   EVAL      WPPref = WPref
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        MG_MT5G = 'N' or MG_MT5G = 'R' AND
     C                             MG_CHTP <> 'D'
 
     C                   EXSR      SRFmtSeqC
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** Write trailer on SWIFT Messages Generated Report
      ** (PRTF/MG0565A1) only if messages generated
 
     C                   IF        WMsgGenFlg <> 'Y'
 
     C                   WRITE     HEAD1P1
     C                   WRITE     NODETS1
 
     C                   ELSE
 
      ** Check for overflow
 
     C                   EVAL      WWLine = WWOfl1 - WWPtl1
 
     C                   IF        WWLine < 4
 
     C                   WRITE     HEAD1P1
 
     C                   ENDIF
 
     C                   WRITE     EOREPT1
 
     C                   ENDIF
 
      ** Write trailer on SWIFT Messages not Generated Report
      ** (PRTF/MG051NA2) only if the printer file has been opened
 
     C                   IF        WPrtErrFlg = 'Y'
 
      ** Check for overflow
 
     C                   EVAL      WWLine = WWOfl2 - WWPtl2
 
     C                   IF        WWLine < 4
 
     C                   WRITE     HEAD2P1
 
     C                   ENDIF
 
     C                   WRITE     EOREPT2
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitF - Initialise non-constant field                      *
      *                                                               *
      *****************************************************************
     C     SRInitF       BEGSR
 
      ** Clear multiple occurence data structure WMultOcur
 
     C                   EVAL      WOcurIdx = 1
     C     WOcurIdx      OCCUR     WMultOcur
 
     C                   DOW       WOcurIdx <= 500  AND
     C                             WMultOcur <> *BLANKS
     C                   CLEAR                   WMultOcur
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
     C                   ENDDO
 
      ** Access the first occurrence in WMultOcur
 
     C                   EVAL      WOcurIdx = 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Clear multiple occurence data structure WMultOcur2
 
     C                   EVAL      WOcurIdx2 = 1
     C     WOcurIdx2     OCCUR     WMultOcur2
 
     C                   DOW       WOcurIdx2 <= 500  AND
     C                             WMultOcur2 <> *BLANKS
     C                   CLEAR                   WMultOcur2
     C                   EVAL      WOcurIdx2 = WOcurIdx2 + 1
     C     WOcurIdx2     OCCUR     WMultOcur2
     C                   ENDDO
 
      ** Access the first occurrence in WMultOcur
 
     C                   EVAL      WOcurIdx2 = 1
     C     WOcurIdx2     OCCUR     WMultOcur2
 
     C                   EVAL      WError = 'N'
     C                   EVAL      WDserr = *BLANKS
     C                   EVAL      WNwerr = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGenNewMsg - Generate New Message                           *
      *                                                               *
      *****************************************************************
     C     SRGenNewMsg   BEGSR
 
      ** Determine message routing
 
     C                   EXSR      SRRout
 
      ** Get Security Information
 
     C     MG_PSSH       CHAIN     SECTYDF                            02
 
     C                   IF        *IN02 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SECTY  '
     C                   EVAL      DBKEY = MG_PSSH
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                185763
     C     InvtpK        CHAIN     INVTPDF                            02        185763
                                                                                185763
     C                   IF        *IN02 = *ON                                  185763
     C     *LOCK         IN        LDA                                          185763
     C                   EVAL      DBASE = 25                                   185763
     C                   EVAL      DBFILE = 'INVTPD '                           185763
     C                   EVAL      DBKEY = NMCY + SITP                          185763
     C                   EVAL      *INU7 = '1'                                  185763
     C                   EVAL      *INU8 = '1'                                  185763
     C                   OUT       LDA                                          185763
     C                   EXSR      *PSSR                                        185763
     C                   ENDIF                                                  185763
 
      ** Get Total Depot Position
 
     C                   EVAL      WSecurity = MG_PSSH
     C                   EVAL      WValDat = MG_PSVL
     C                   EVAL      WEvnType = MG_PEVT
     C                   EVAL      WCntPty = MG_PCPY
     C                   EVAL      WTPNmp = 0                                   185763
     C     KPosSet       SETLL     POSETW2                                04
     C                   IF        *IN04 = *ON
     C                   EVAL      *IN03 = *OFF
     C                   DOW       *IN03 = *OFF
     C     KPosSet       READE     POSETW2                                03
     C                   IF        *IN03 = *OFF
      *                                                                         185792
      ***Only*add*record*with*RECI*=*'D'*or*'S'***                       185792 187622
      ** Only add record with RECI not equal to '*'                             187622
      *                                                                         185792
     C***********        IF        W2_RECI = 'D' or W2_RECI = 'S'        185792 187622
     C                   IF        W2_RECI <> '*'                               187622
     C                   EVAL      WTPNmp = WTPNmp + W2_PNMP
     C                   ENDIF                                                  185792
     C                   ENDIF
                                                                                185792
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRout - Determine Message Routing                           *
      *                                                               *
      *****************************************************************
     C     SRRout        BEGSR
 
      ** Get Branch Details
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      MG_PBCA       PBrcd
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
      ** Database error in file SDBRCHPD
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Determine the Network Routing and Addresses
 
     C                   EVAL      PSndr = A8BICN
     C                   EVAL      PScsd = A8BTID
     C                   MOVE      MG_PCPY       PDest
     C                   EVAL      PSetp = '  '
     C                   EVAL      PNwsn = *BLANKS
     C                   EVAL      PNwds = *BLANKS
     C                   EVAL      PErrc = *BLANKS
     C                   EVAL      PSrnm = *BLANKS
     C                   EVAL      PSrtn = *BLANKS
     C                   EVAL      PDrnm = *BLANKS
     C                   EVAL      PDrtn = *BLANKS
 
     C                   CALL      'ZM1100'                             05
     C                   PARM                    PSndr
     C                   PARM                    PScsd
     C                   PARM                    PDest
     C                   PARM                    PSetp
     C                   PARM                    PNwsn
     C                   PARM                    PNwds
     C                   PARM                    PNwrk
     C                   PARM                    PErrc
     C                   PARM                    PSrnm
     C                   PARM                    PSrtn
     C                   PARM                    PDrnm
     C                   PARM                    PDrtn
 
      ** If program not found, perform DB error processing
 
     C                   IF        *IN05 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
     C                   EVAL      DBPGM = 'ZM1100'
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  If an error occured in ZM1100, perform DB Error processing
 
     C                   IF        PErrc = 'S'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 7
     C                   EVAL      DBPGM = 'ZM1100'
     C                   EVAL      DBKEY = DBERR1
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Format Destination Error Message
 
     C                   IF        PErrc = 'D'
     C                   EVAL      WDserr = *BLANKS
     C                   EVAL      WDserr = ARERR(1)
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
      ** Format Network Error Message
 
     C                   IF        PNwrk = 'UNROUT'
     C                   EVAL      WNwerr =  ARERR(2)
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtSeqA - Format Sequence A                                *
      *                                                               *
      *****************************************************************
     C     SRFmtSeqA     BEGSR
 
      ** Set up Message Sequence workfield
 
     C                   EVAL      WSequence = 'A'
 
      ** Format field :16R: - Start of Block
 
     C                   EVAL      WMTag = ':16R:'
 
      ** Access tag description
 
     C                   EXSR      SRMTAG
 
     C                   EVAL      WMDat = 'GENL'
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
                                                                                              186790
      ** Format field :20C: - Reference for Corporate Action (No used)                        186790
                                                                                              186790
     C                   EVAL      WMTag = ':20C:'                                            186790
                                                                                              186790
      ** Access tag description                                                               186790
                                                                                              186790
     C                   EXSR      SRMTag                                                     186790
     C                   EVAL      WMDat = ':CORP//NONREF'                                    186790
     C                   EVAL      WRDat = WMDat                                              186790
                                                                                              186790
      ** Access the next occurence in WMultOcur                                               186790
                                                                                              186790
     C                   EVAL      WOcurIdx = WOcurIdx + 1                                    186790
     C     WOcurIdx      OCCUR     WMultOcur                                                  186790
 
      ** Format field :20C: - Reference
 
     C                   EVAL      WMTag = ':20C:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C                   MOVE      MG_PSEQ       WPSeq
     C                   EVAL      WWMDat = 'SEP' + WPref + WPSeq
 
     C*************      EVAL      WMDat = 'SEME//' + WWMDat                                  186790
     C                   EVAL      WMDat = ':SEME//' + WWMDat                                 186790
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Format field :23G: - Function of the Message
 
     C                   EVAL      WMTag = ':23G:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C                   EVAL      WMDat = 'NEWM'
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Format field :22F: - Indicator Corporate Action Event Ind.
 
     C                   EVAL      WMTag  = ':22F:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C                   IF        MG_PEVT = 'DV'
     C*************      EVAL      WMDat = 'CAEV//DVCA'                                       186790
     C                   EVAL      WMDat = ':CAEV//DVCA'                                      186790
     C                   ENDIF
 
     C                   IF        MG_PEVT = 'CP'
     C*************      EVAL      WMDat = 'CAEV//INTR'                                       186790
     C                   EVAL      WMDat = ':CAEV//INTR'                                      186790
     C                   ENDIF
 
     C                   IF        MG_PEVT = 'MT'
     C************       EVAL      WMDat = 'CAEV//REDM'                                       186790
     C                   EVAL      WMDat = ':CAEV//REDM'                                      186790
     C                   ENDIF
 
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Format field :16S: - End of Block
 
     C                   EVAL      WMTag = ':16S:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C                   EVAL      WMDat = 'GENL'
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtSeqB - Format Sequence B                                *
      *                                                               *
      *****************************************************************
     C     SRFmtSeqB     BEGSR
 
      ** Set up Message Sequence workfield
 
     C                   EVAL      WSequence = 'B'
 
      ** Format field :16R: - Start of Block
 
     C                   EVAL      WMTag = ':16R:'
 
      ** Access tag description
 
     C                   EXSR      SRMTAG
 
     C                   EVAL      WMDat = 'USECU'
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Format field :35B: - Reference
 
     C                   EVAL      WMTag = ':35B:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
      ** ISIN/Common Code
 
     C                   IF        ISIN <> *BLANKS
     C                   EVAL      WMDat = 'ISIN'
     C     WMDat         CAT       ISIN:1        WMDat
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
     C                   ENDIF
 
      ** Security Full Name - 1
 
     C                   IF        SFN1 <> *BLANKS
 
     C                   EVAL      WMDat = SFN1
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Security Full Name - 2
 
     C                   IF        SFN2 <> *BLANKS                                            186790
                                                                                              186790
     C                   EVAL      WMDat = SFN2
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
     C                   ENDIF                                                                186790
 
     C                   ELSE
 
      ** Security Shortname
 
     C                   EVAL      WMDat = SESN
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Security Report Name
 
     C                   IF        SRPN <> *BLANKS                                            186790
                                                                                              186790
     C                   EVAL      WMDat = SRPN
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
     C                   ENDIF                                                                186790
 
     C                   ENDIF
 
      ** Format Subsequence B2 Account Information
 
     C                   EXSR      SRFmtSeqB2
 
     C                   EVAL      WSequence = 'B'
 
      ** Format field :16S: - End of Block
 
     C                   EVAL      WMTag = ':16S:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C                   EVAL      WMDat = 'USECU'
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtSeqB2 - Format Subsequence B2                           *
      *                                                               *
      *****************************************************************
     C     SRFmtSeqB2    BEGSR
 
      ** Set up Message Sequence workfield
 
     C                   EVAL      WSequence = 'B2'
 
      ** Format field :16R: - Start of Block
 
     C                   EVAL      WMTag = ':16R:'
 
      ** Access tag description
 
     C                   EXSR      SRMTAG
 
     C                   EVAL      WMDat = 'ACCTINFO'
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Format field :97A: - Safekeeping Account
 
     C                   EVAL      WMTag = ':97A:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
      ** Safekeeping Account
 
     C*************      EVAL      WMDat = 'SAFE//'                                           186790
     C                   EVAL      WMDat = ':SAFE//'                                          186790
 
     C                   EXSR      SRSfKpAcc
 
     C                   CAT       WSafKpAcc:0   WMDat
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Format field :93B: - Balance
 
     C                   EVAL      WMTag = ':93B:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C                   IF        WTPnmp = *ZERO
     C                   EVAL      WMErr = ARERR(6)
     C                   EVAL      WError = 'Y'
 
     C                   ELSE
 
     C***********        IF        SPBS = 'U'                                   185763
     C                   IF        PROT = '2' OR                                185763
     C                             PROT = '4' OR                                185763
     C                             PROT = '7'                                   185763
     C************       EVAL      WMDat = 'ELIG//UNIT/'                                      186790
     C                   EVAL      WMDat = ':ELIG//UNIT/'                                     186790
     C                   ELSE
     C************       EVAL      WMDAT ='ELIG//FAMT/'                                       186790
     C                   EVAL      WMDAT =':ELIG//FAMT/'                                      186790
     C                   ENDIF
 
      ** Edit WTPnmp to have comma and decimal place
 
     C************       EVAL      PAmt = WTPnmp                                185770
     C************       EVAL      PCcy = MG_PNCY                               185770
     C************       EXSR      SREdtAmt                                     185770
     C                   EVAL      ZAMNT = WTPnmp                               185770
     C                   EVAL      ZCDP = NMDP                                  185770
     C                   EXSR      SREdtNoml                                    185770
 
     C                   EVAL      WRDat = WMDat
     C************       CAT       PSAmt:0       WMDat                          185770
     C************       CAT       POAmt:0       WRDat                          185770
     C                   CAT       ZSAMNT:0      WMDat                          185770
     C                   CAT       ZOAMNT:0      WRDat                          185770
 
     C                   ENDIF
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Format field :16S: - End of Block
 
     C                   EVAL      WMTag = ':16S:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C                   EVAL      WMDat = 'ACCTINFO'
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSfKpAcc  - Get Safekeeping account                         *
      *                                                               *
      *****************************************************************
     C     SRSfKpAcc     BEGSR
      *                                                                         185733
      ** Get Safekeeping Account from SSI                                       185733
      *                                                                         185733
     C                   EVAL      W_SITP = SITP                                              186790
                                                                                              CSE028
      ** If CSE028 is on, call SESSIR0 for default of MT5xx information                       CSE028
                                                                                              CSE028
     C                   IF        CSE028 = 'Y'                                               CSE028
                                                                                              CSE028
     C                   MOVEL     MG_PCPY       PCust                                        CSE028
     C                   CALL      'SESSIR0'                                                  CSE028
     C                   PARM      'D'           POType                                       CSE028
     C                   PARM                    MG_PBCA                                      CSE028
     C                   PARM                    PCust                                        CSE028
     C                   PARM                    MG_PBCD                                      CSE028
     C                   PARM                    MG_PNCY                                      CSE028
     C                   PARM                    SMCC                                         209547
     C                   PARM                    W_SITP                                       CSE028
     C                   PARM                    MG_PTFR                                      CSE028
     C                   PARM                    PCBStd                                       CSE028
     C                   PARM                    PCBStdAd                                     CSE028
     C                   PARM      *BLANKS       PRetCode                                     CSE028
                                                                                              CSE028
     C                   EVAL      *IN07 = '0'                                                CSE028
     C                   IF        PRetCode <> '*NCRF' AND PRetCode <> '*NRF '                CSE028
     C     2             OCCUR     PCBSTD                                                     CSE028
     C                   ELSE                                                                 CSE028
     C                   IF        PRetCode <> '*NBRF' AND PRetCode <> '*NRF '                CSE028
     C     1             OCCUR     PCBSTD                                                     CSE028
     C                   ELSE                                                                 CSE028
     C                   EVAL      *IN07 = '1'                                                CSE028
     C                   ENDIF                                                                CSE028
     C                   ENDIF                                                                CSE028
                                                                                              CSE028
     C                   ELSE                                                                 CSE028
                                                                                              CSE028
     C                   EVAL      MG_PBCD = *BLANKS                                          CSE028
     C                   EVAL      MG_PTFR = *BLANKS                                          CSE028
                                                                                              CSE028
     C     KLSTD         CHAIN     STDSED                             07        185733
      *                                                                                       186790
      ** If record not found, then get record without investment type                         186790
      *                                                                                       186790
     C                   IF        *IN07 = '1'                                                186790
     C                   EVAL      W_SITP = '   '                                             186790
     C     KLSTD         CHAIN     STDSED                             07                      186790
     C                   ENDIF                                                                186790
                                                                                              CSE028
     C                   ENDIF                                                                CSE028
                                                                                              CSE028
                                                                                185733
     C                   EVAL      WSafkpAcc = *BLANKS                          185733
     C                   IF        *IN07 = '0'                                  185733
     C                   EVAL      WSafKpAcc = SKAC                             185733
     C                   ENDIF                                                  185733
                                                                                185733
     C                   IF        WSafKpAcc = *BLANKS                          185733
      ** LOOKUP if Counterparty in POSETD is in ARDICD
 
     C                   EVAL      WIdx1 = 1
     C                   MOVE      MG_PCPY       WPcpy
     C     WPcpy         LOOKUP    ARDICD(WIdx1)                          07
     C                   IF        *IN07 = *ON
     C                   EVAL      WDepo = A8BICN
 
     C                   EXSR      SRGetSecDet
 
     C                   EVAL      WDepo = ARSEDET(WIdx1)
 
     C                   IF        WDepo <> *BLANKS                             185740
     C                   EXSR      SRGetSecDet
 
     C************       EVAL      WSafKpAcc = ARSEDET(WIdx1)                                 186790
     C                   MOVEL     ARSEDET(WIdx1)WSafKpAcc                                    186790
     C                   ENDIF                                                  185740
 
     C                   ENDIF
 
     C                   IF        *IN07 = *OFF OR WSafKpAcc = *BLANKS
     C
     C************       EVAL      WSafKpAcc = A8BICN                                         186790
     C                   MOVEL     A8BICN        WSafKpAcc                                    186790
 
     C                   ENDIF
     C                   ENDIF                                                  185733
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetSecDet - Get Security Details                           *
      *                                                               *
      *****************************************************************
     C     SRGetSecDet   BEGSR
 
      ** Get Security Clients Details
 
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WDepo         PCust
     C     SDSECS        PARM      SDSECS        DSFDY
 
      ** Database error in file SDSECSPD
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 8
     C                   EVAL      DBFILE = 'SDSECSPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Copy depot reference to array ARSEDET
 
     C                   EVAL      ARSEDET(1) = BFDRF1
     C                   EVAL      ARSEDET(2) = BFDRF2
     C                   EVAL      ARSEDET(3) = BFDRF3
     C                   EVAL      ARSEDET(4) = BFDRF4
     C                   EVAL      ARSEDET(5) = BFDRF5
     C                   EVAL      ARSEDET(6) = BFDRF6
     C                   EVAL      ARSEDET(7) = BFDRF7
     C                   EVAL      ARSEDET(8) = BFDRF8
     C                   EVAL      ARSEDET(9) = BFDRF9
     C                   EVAL      ARSEDET(10) = BFDRF0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtSeqC - Format Subsequence C                             *
      *                                                               *
      *****************************************************************
     C     SRFmtSeqC     BEGSR
 
      ** Set up Message Sequence workfield
 
     C                   EVAL      WSequence = 'C'
 
      ** Format field :16R: - Start of Block
 
     C                   EVAL      WMTag = ':16R:'
 
      ** Access tag description
 
     C                   EXSR      SRMTAG
 
     C                   EVAL      WMDat = 'BENODET'
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Format field :95Q: - Party
 
     C                   IF        CSW203 = 'N'                                               CSW203
     C                   EVAL      WMTag = ':95Q:'
     C                   ELSE                                                                 CSW203
     C                   EVAL      WMTag = ':95V:'                                            CSW203
     C                   ENDIF                                                                CSW203
 
      ** Access tag description
 
     C                   EXSR      SRMTAG
 
     C************       EVAL      WMDat = 'OWND//'                                           186790
     C                   EVAL      WMDat = ':OWND//'                                          186790
 
     C                   EXSR      SRBeneDet
 
     C                   CAT       WBenOwnNme:0  WMDat
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Beneficial Owner's Address1
 
     C                   IF        WBenAdd1 <> *BLANKS
 
     C                   EVAL      WMDat = WBenAdd1
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
     C                   ENDIF
 
      ** Beneficial Owner's Address2
 
     C                   IF        WBenAdd2 <> *BLANKS
 
     C                   EVAL      WMDat = WBenAdd2
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
     C                   ENDIF
 
      ** Beneficial Owner's Address3
 
     C                   IF        WBenAdd3 <> *BLANKS
 
     C                   EVAL      WMDat = WBenAdd3
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
     C                   ENDIF
                                                                                              CSW203
      ** Beneficial Owner's Address 4                                                         CSW203
                                                                                              CSW203
     C                   IF        WBenAdd4 <> *BLANKS and                                    CSW203
     C                             CSW203 = 'Y'                                               CSW203
                                                                                              CSW203
     C                   EVAL      WMDat = WBenAdd4                                           CSW203
     C                   EVAL      WRDat = WMDat                                              CSW203
                                                                                              CSW203
      ** Access the next occurence in WMultOcur                                               CSW203
                                                                                              CSW203
     C                   EVAL      WOcurIdx = WOcurIdx + 1                                    CSW203
     C     WOcurIdx      OCCUR     WMultOcur                                                  CSW203
                                                                                              CSW203
     C                   ENDIF                                                                CSW203
 
      ** Format field :36B: - Balance
 
     C                   EVAL      WMTag = ':36B:'
 
      ** Access tag description
 
     C                   EXSR      SRMTAG
 
     C                   IF        MG_PNMP = *ZERO
     C                   EVAL      WMErr = ARERR(5)
     C                   EVAL      WError = 'Y'
 
     C                   ELSE
 
     C************       IF        STBS = 'U'
     C***********        IF        SPBS = 'U'                           185763  185763
     C                   IF        PROT = '2' OR                                185763
     C                             PROT = '4' OR                                185763
     C                             PROT = '7'                                   185763
     C************       EVAL      WMDat = 'OWND//UNIT/'                                      186790
     C                   EVAL      WMDat = ':OWND//UNIT/'                                     186790
     C                   ELSE
     C************       EVAL      WMDAT ='OWND//FAMT/'                                       186790
     C                   EVAL      WMDAT =':OWND//FAMT/'                                      186790
     C                   ENDIF
 
      ** Edit PNMP to have comma and decimal place
 
     C************       EVAL      PAmt = MG_PNMP                               185770
     C************       EVAL      PCcy = MG_PNCY                               185770
     C************       EXSR      SREdtAmt                                     185770
     C                   EVAL      ZAMNT = MG_PNMP                              185770
     C                   EVAL      ZCDP = NMDP                                  185770
     C                   EXSR      SREdtNoml
 
     C                   EVAL      WRDat = WMDat
 
     C*****WMDat**       CAT       PSAmt:0       WMDat                          185770
     C*****WRDat**       CAT       POAmt:0       WRDat                          185770
     C     WMDat         CAT       ZSAMNT:0      WMDat                          185770
     C     WRDat         CAT       ZOAMNT:0      WRDat                          185770
 
     C                   ENDIF
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Format field :70E: - Declaration Detail
 
     C                   EVAL      WMTag = ':70E:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C************       EVAL      WMDat = 'DECL//WITHHOLDING TAX'                            186790
      *                                                                                       CSW216
      ** If SWIFT 2016 is enabled, use CETI qualifier                                         CSW216
      *                                                                                       CSW216
     C                   IF        CSW216 = 'Y'                                               CSW216
     C                   EVAL      WMDat = ':CETI//TAXR'                                      CSW216
     C                   ELSE                                                                 CSW216
     C                   EVAL      WMDat = ':DECL//TAXR'                                      186790
     C                   ENDIF                                                                CSW216
 
     C                   EXSR      SRTaxRate
 
     C     WMDat         CAT       WTaxRateC:1   WMDat
     C     WMDat         CAT       'PCT':1       WMDat
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Output discount amount for OID Maturity.                                             187801
                                                                                              187801
     C                   IF        MG_PEVT = 'MT'                                             187801
                                                                                              187801
     C                   EVAL      WMDAT ='/AMOR/'                                            187801
                                                                                              187801
      ** Edit DAMT to have comma and decimal place                                            187801
                                                                                              187801
     C                   EVAL      ZAMNT = MG_DAMT                                            187801
     C                   EVAL      PCurr = MG_PNCY                                            187801
     C                   CALL      'AOCURRR0'                                                 187801
     C                   PARM      *BLANKS       PRtcd                                        187801
     C                   PARM      '*KEY   '     POptn                                        187801
     C                   PARM                    PCurr                                        187801
     C     SDCURR        PARM      SDCURR        DSSDY                                        187801
                                                                                              187801
      ** Database error.                                                                      187801
                                                                                              187801
     C                   IF        PRtcd <> *BLANKS                                           187801
     C     *LOCK         IN        LDA                                                        187801
     C                   EVAL      DBKEY = PCurr                                              187801
     C                   EVAL      DBFILE = 'SDCURRPD'                                        187801
     C                   EVAL      DBASE = 026                                                187801
     C                   OUT       LDA                                                        187801
     C                   EXSR      *PSSR                                                      187801
     C                   ENDIF                                                                187801
     C                   EVAL      ZCDP = A6NBDP                                              187801
     C                   EXSR      SREdtNoml                                                  187801
                                                                                              187801
     C                   EVAL      WRDat = WMDat                                              187801
                                                                                              187801
     C     WMDat         CAT       ZSAMNT:0      WMDat                                        187801
     C     WRDat         CAT       ZOAMNT:0      WRDat                                        187801
                                                                                              187801
      ** Access the next occurence in WMultOcur                                               187801
                                                                                              187801
     C                   EVAL      WOcurIdx = WOcurIdx + 1                                    187801
     C     WOcurIdx      OCCUR     WMultOcur                                                  187801
                                                                                              187801
     C                   ENDIF                                                                187801
                                                                                              187801
      ** Type  of excemption
 
     C                   IF        MG_EXCD <> *BLANKS
 
     C                   EVAL      KCrtt = MG_CRTX
     C                   EVAL      KCode = MG_EXCD
 
     C     Wkey1         CHAIN     SDEXEML1                           02
 
     C                   IF        *IN02 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 23
     C                   EVAL      DBFILE = 'SDEXEML1'
     C                   EVAL      DBKEY = MG_CRTX + ' ' + MG_EXCD
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C************       EVAL      WMDat = EXEXCD
     C*****WMDat**       CAT       EXNARR:1      WMDat
     C                   EVAL      WMDat = '/ETYP/' + EXEXCD                                  186790
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
     C                   ENDIF
 
      ** Type  of income
 
     C                   IF        MG_ICTP <> *BLANKS
 
     C                   EVAL      KCrtt = MG_CRTX
     C                   EVAL      KCode = MG_ICTP
 
     C     Wkey1         CHAIN     SDINCCL1                           02
 
     C                   IF        *IN02 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 24
     C                   EVAL      DBFILE = 'SDINCCL1'
     C                   EVAL      DBKEY = MG_CRTX + ' ' + MG_ICTP
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C************       EVAL      WMDat = ININCC                                             186790
     C*****WMDat**       CAT       INNARR:1      WMDat                                        186790
     C                   EVAL      WMDat = '/ITYP/' + ININCC                                  186790
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
     C                   ENDIF
 
      ** Type  of recipient
 
     C                   IF        MG_RPCD <> *BLANKS
 
     C                   EVAL      KCrtt = MG_CRTX
     C                   EVAL      KCode = MG_RPCD
 
     C     Wkey1         CHAIN     SDRPCDL1                           02
 
     C                   IF        *IN02 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 24
     C                   EVAL      DBFILE = 'SDINCCL1'
     C                   EVAL      DBKEY = MG_CRTX + ' ' + MG_RPCD
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C************       EVAL      WMDat = RPNARR                                             186790
     C                   EVAL      WMDat = '/RECT/' + MG_RPCD                                 186790
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
     C                   ENDIF
 
      ** Format field :16S: - End of Block
 
     C                   EVAL      WMTag = ':16S:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C                   EVAL      WMDat = 'BENODET'
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBeneDet - Get Benefeciary Owner Detail                     *
      *                                                               *
      *****************************************************************
     C     SRBeneDet     BEGSR
 
     C                   IF        MG_BNFO <> *BLANKS
 
     C                   MOVE      MG_PCPY       KCustNo
     C                   EVAL      KCtyTty = MG_CRTX
     C                   EVAL      KBenOwnNo = MG_BNFO
 
     C     KBnfOwn       CHAIN     SDBNFOL2                           02
 
     C                   IF        *IN02 = *ON
 
     C                   MOVEL     MG_BNFO       KCustNo
 
     C     KBnfOwn       CHAIN     SDBNFOL2                           02
 
     C                   IF        *IN02 = *ON
 
      ** Database error if data not in SDBNFOL2
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 16
     C                   EVAL      DBFILE = 'SDBNFOL2'
     C                   EVAL      DBKEY = KCustNo + KCtyTty + KBenOwnNo
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      WBenOwnNme = BNBONM
     C                   EVAL      WBenAdd1 = BNBOA1
     C                   EVAL      WBenAdd2 = BNBOA2
     C                   EVAL      WBenAdd3 = BNBOA3
     C                   IF        CSW203 = 'Y'                                               CSW203
     C                   EVAL      WBenAdd4 = BBCNA4                                          CSW203
     C                   ENDIF                                                                CSW203
 
     C                   ELSE
 
      ** Use Internal Customer Name
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      A8BICN        PCustK
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database error in file SDCUSTPD
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 9
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WBenOwnNme = BBCSSN
     C                   EVAL      WBenAdd1 = BBCNA1
     C                   EVAL      WBenAdd2 = BBCNA2
     C                   EVAL      WBenAdd3 = BBCNA3
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTaxRate - Get Tax Rate                                     *
      *                                                               *
      *****************************************************************
     C     SRTaxRate     BEGSR
 
     C                   IF        MG_TXBS <> *BLANKS
     C                   CALLB     'AOTXBSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      MG_CRTX       PCrtx
     C                   PARM      MG_TXBS       PTxbs
     C                   PARM      MG_PSVL       PPsvl
     C                   PARM      *BLANKS       PNarr
     C                   PARM      *ZERO         PTxrt
 
      ** Database error in file SDTXBSPD
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 10
     C                   EVAL      DBFILE = 'SDTXBSPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      PTxrt = 0
     C                   ENDIF
 
     C                   MOVE      *BLANKS       WTaxRateC
     C                   EVAL      WTaxRate = PTxrt
     C                   CALL      'ZM0010'
     C                   PARM                    WTaxRate
     C                   PARM                    WTaxRateC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtSeqD - Format Subsequence D                             *
      *                                                               *
      *****************************************************************
     C     SRFmtSeqD     BEGSR
 
      ** Set up Message Sequence workfield
 
     C                   EVAL      WSequence = 'D'
 
      ** Format field :16R: - Start of Block
 
     C                   EVAL      WMTag = ':16R:'
 
      ** Access tag description
 
     C                   EXSR      SRMTAG
 
     C                   EVAL      WMDat = 'CAINST'
     C                   EVAL      WRDat = WMDat
 
     C                   IF        CSW203 = 'Y'                                               CSW203
                                                                                              CSW203
     C                   EVAL      WOcurIdx = WOcurIdx + 1                                    CSW203
     C     WOcurIdx      OCCUR     WMultOcur                                                  CSW203
                                                                                              CSW203
      ** Format field :13A: - Reference                                                       CSW203
                                                                                              CSW203
     C                   EVAL      WMTag = ':13A:'                                            CSW203
                                                                                              CSW203
      ** Access tag description                                                               CSW203
                                                                                              CSW203
     C                   EXSR      SRMTag                                                     CSW203
                                                                                              CSW203
      ** Setup format                                                                         CSW203
                                                                                              CSW203
     C                   EVAL      WMDat = ':CAON//UNS'                                       CSW203
     C                   EVAL      WRDat = WMDat                                              CSW203
                                                                                              CSW203
     C                   ENDIF                                                                CSW203
      *                                                                                       197311
      ** When SWIFT 2001 is installed, field 20C will no longer be                            197311
      ** displayed.                                                                           197311
      *                                                                                       197311
     C                   IF        CSW201 = 'N'                                               197311
                                                                                              197311
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Format field :20C: - Reference
 
     C                   EVAL      WMTag = ':20C:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C                   MOVE      WK_PSEQ       WPSeq
     C                   EVAL      WWMDat = 'SEP' + WK_PREF + WPSeq
 
     C*************      EVAL      WMDat = 'SEME//' + WWMDat                                  186790
     C*************      EVAL      WMDat = ':SEME//' + WWMDat                          186790 187801
     C                   EVAL      WMDat = ':CAIN//' + WWMDat                                 187801
     C                   EVAL      WRDat = WMDat
 
     C                   ENDIF                                                                197311
                                                                                              197311
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Format field :22H: - Indicator
 
     C                   EVAL      WMTag = ':22H:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C*************      EVAL      WMDat = 'CAOP//CASH'                                       186790
     C                   EVAL      WMDat = ':CAOP//CASH'                                      186790
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Format field :11A: - Currency
 
     C                   EVAL      WMTag = ':11A:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C*************      EVAL      WMDat = 'OPTN//'                                           186790
     C                   EVAL      WMDat = ':OPTN//'                                          186790
 
     C     WMDat         CAT       WK_PNCY:0     WMDat
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
     ****Format*field*:36B:*-*Instructed*Quantity********************
      ** Format field :36C: - Instructed Quantity
 
     C*************      EVAL      WMTag  = ':36B:'                                           186790
     C                   EVAL      WMTag  = ':36C:'                                           186790
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C*************      EVAL      WMDat = 'QINS//QALL'                                       186790
     C                   EVAL      WMDat = ':QINS//QALL'                                      186790
 
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
      ** Format field :16S: - End of Block
 
     C                   EVAL      WMTag = ':16S:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C                   EVAL      WMDat = 'CAINST'
     C                   EVAL      WRDat = WMDat
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx = WOcurIdx + 1
     C     WOcurIdx      OCCUR     WMultOcur
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMTag - Access tag/field description details                *
      *                                                               *
      *****************************************************************
     C     SRMTag        BEGSR
 
      ** Case #1: XXXXX, XXX, XXX
 
     C                   EVAL      KType = '565'
     C                   EVAL      KSequence = WSequence
 
     C     KTag          CHAIN     SDMTAGL0                           02
 
      ** Case #2: XXXXX, XXX, ___
 
     C                   IF        *IN02 = *ON
 
     C                   EVAL      KType = '565'
     C                   EVAL      KSequence = *BLANK
 
     C     KTag          CHAIN     SDMTAGL0                           02
 
     C                   ENDIF
 
      ** Case #3: XXXXX, ALL, XXX
 
     C                   IF        *IN02 = *ON
 
     C                   EVAL      KType = 'ALL'
     C                   EVAL      KSequence = WSequence
 
     C     KTag          CHAIN     SDMTAGL0                           02
 
     C                   ENDIF
 
      ** Case #4: XXXXX, ALL, ___
 
     C                   IF        *IN02 = *ON
 
     C                   EVAL      KType = 'ALL'
     C                   EVAL      KSequence = *BLANK
 
     C     KTag          CHAIN     SDMTAGL0                           02
 
     C                   ENDIF
 
      ** If found, move ISO field Description to WMultOcur/WMDes
 
     C                   IF        *IN02 = *OFF
 
     C                   EVAL      WMDes = EFISFD
 
      ** Otherwise, move '<Tag Description not found>' WMultOcur/WMErr
 
     C                   ELSE
 
     C                   EVAL      WMErr = ARERR(3)
     C                   EVAL      WError = 'Y'
 
     C                   ENDIF
 
      ** Move message sequence (WSequence) to WMultOcur/WMSeq
 
     C                   EVAL      WMSeq = WSequence
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREdtAmt - Edit amount to have comma and decimal point       *
      *                                                               *
      *****************************************************************
     C     SREdtAmt      BEGSR
 
     C                   EVAL      PSAmt = *BLANKS
     C                   EVAL      POAmt = *BLANKS
     C                   EVAL      PSCcy = *BLANKS
     C                   EVAL      PErr  = *BLANKS
 
     C                   CALL      'ZM1240'                             08
     C                   PARM                    PAmt
     C                   PARM                    PCcy
     C                   PARM                    PSAmt
     C                   PARM                    POAmt
     C                   PARM                    PSCcy
     C                   PARM                    PErr
 
      ** If program not found, perform DB error processing
 
     C                   IF        *IN08 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 13
     C                   EVAL      DBPGM = 'ZM1240'
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If error occured in ZM1240, perform DB Error processing
 
     C                   IF        PErr = '1'
     C                   EVAL      WMErr = ARERR(4)
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    185770
      *****************************************************************         185770
      *                                                               *         185770
      *  SREdtNoml - Edit Nominal Amount in SWIFT Format              *         185770
      *                                                               *         185770
      *****************************************************************         185770
     C     SREdtNoml     BEGSR                                                  185770
                                                                                185770
     C                   MOVE      *BLANKS       ZSAMNT           17            185770
     C                   MOVE      *BLANKS       ZOAMNT           21            185770
                                                                                185770
     C                   CALL      'ZM1140'                             08      185770
     C                   PARM                    ZAMNT            15 0          185770
     C                   PARM                    ZCDP              1 0          185770
     C                   PARM                    ZSAMNT                         185770
     C                   PARM                    ZOAMNT                         185770
                                                                                185770
      ** If program not found, perform DB error processing                      185770
                                                                                185770
     C                   IF        *IN08 = *ON                                  185770
     C     *LOCK         IN        LDA                                          185770
     C                   EVAL      DBASE = 13                                   185770
     C                   EVAL      DBPGM = 'ZM1240'                             185770
     C                   EVAL      DBKEY = *BLANKS                              185770
     C                   EVAL      *INU7 = '1'                                  185770
     C                   EVAL      *INU8 = '1'                                  185770
     C                   OUT       LDA                                          185770
     C                   EXSR      *PSSR                                        185770
     C                   ENDIF                                                  185770
                                                                                185770
      ** If error occured in ZM1240, perform DB Error processing                185770
                                                                                185770
     C                   IF        PErr = '1'                                   185770
     C                   EVAL      WMErr = ARERR(4)                             185770
     C                   EVAL      WError = 'Y'                                 185770
     C                   ENDIF                                                  185770
                                                                                185770
     C                   ENDSR                                                  185770
      *****************************************************************         185770
      *****************************************************************
      *                                                               *
      *  SRPError - Process for errors.                               *
      *                                                               *
      *****************************************************************
     C     SRPError      BEGSR
 
      ** Initialise fields used in report
 
     C                   CLEAR                   HEAD2P2
 
      ** Open printer file
 
     C                   IF        WPrtErrFlg = 'N'
     C                   OPEN      MG0565A2
     C                   EVAL      WPrtErrFlg = 'Y'
     C                   ENDIF
 
     ** Format Message Type
 
     C                   EVAL      R2MTYP = '565'
 
      ** Format Security
 
     C                   EVAL      R2RSECT = WK_PSSH
 
      ** Format Date of Payment
 
     C                   EVAL      PDayNo = WK_PSVL
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    PDateOut
     C                   PARM                    PADateOut
 
     C                   EVAL      R2RDATE = PDateOut
 
      ** Format Event Type
 
     C                   EVAL      R2REVNT = WK_PEVT
 
      ** Format Counterparty
 
     C                   MOVE      WK_PCPY       R2CTPY
 
      ** Format Destination Customer Number
 
     C**********         EVAL      R2DES1 = WK_PCPY                                           CSD027
     C                   Move      WK_PCPY       R2DES1                                       CSD027
 
      ** Format Destination Network Address
 
     C                   EVAL      R2DES2 = PNwds
 
      ** Format Destination Error Message
 
     C                   EVAL      R2EMSG = WDserr
 
      ** Format Network
 
     C                   EVAL      R2NETW = PNwrk
 
      ** Format Network Error Message
 
     C                   EVAL      R2NWER = WNwerr
 
      ** Write the header for the report
 
     C                   WRITE     HEAD2P1
     C                   WRITE     HEAD2P2
 
      ** Process Multiple Occcurence Date Structure
 
     C                   EVAL      WIdx2 = 0
 
     C                   DOW       WIdx2 <= WOcurIdx
 
     C                   EVAL      WIdx2 = WIdx2 + 1
     C     WIdx2         OCCUR     WMultOcur
 
     C                   EVAL      R2MTAG = WMTag
     C                   EVAL      R2RDAT = WRDat
     C                   EVAL      R2MERR = WMErr
 
      ** Write a detail line to the report checking for overlfow
 
     C                   EVAL      WWLine = WWOfl2 - WWPtl2
 
     C                   IF        WWLine < 3
     C                   WRITE     HEAD2P1
     C                   ENDIF
 
     C                   WRITE     DETL2
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPMsgGen - Print message generated details                  *
      *                                                               *
      *****************************************************************
     C     SRPMsgGen     BEGSR
 
      ** Initialise fields used in report
 
     C                   CLEAR                   HEAD1P2
 
     ** Format Message Type
 
     C                   EVAL      R1MTYP = '565'
 
      ** Format Security
 
     C                   EVAL      R1RSECT = WK_PSSH
 
      ** Format Date of Payment
 
     C                   EVAL      PDayNo = WK_PSVL
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    PDateOut
     C                   PARM                    PADateOut
 
     C                   EVAL      R1RDATE = PDateOut
 
      ** Format Event Type
 
     C                   EVAL      R1REVNT = WK_PEVT
 
      ** Format Counterparty
 
     C                   MOVE      WK_PCPY       R1CTPY
 
      ** Format Destination Customer Number
 
     C                   MOVE      WK_PCPY       R1DES1
 
      ** Format Destination Network Address
 
     C                   EVAL      R1DES2 = PNwds
 
      ** Format Destination Report Name
 
     C                   EVAL      R1DRNM = PDrnm
 
      ** Format Destination Report Town
 
     C                   EVAL      R1DRTN = PDrtn
 
      ** Format Network
 
     C                   EVAL      R1NETW = PNwrk
 
      ** Write the header for the report
 
     C                   WRITE     HEAD1P1
     C                   WRITE     HEAD1P2
 
      ** Process Multiple Occcurence Date Structure
 
     C                   EVAL      WIdx4 = 0
 
     C                   DOW       WIdx4 <= WOcurIdx
 
     C                   EVAL      WIdx4 = WIdx4 + 1
     C     WIdx4         OCCUR     WMultOcur
 
     C                   EVAL      R1MDES = WMDes
     C                   EVAL      R1MTAG = WMTag
     C                   EVAL      R1RDAT = WRDat
 
      ** Write a detail line to the report checking for overlfow
 
     C                   EVAL      WWLine = WWOfl1 - WWPtl1
 
     C                   IF        WWLine < 3
     C                   WRITE     HEAD1P1
     C                   ENDIF
 
     C                   WRITE     DETL1
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdPos - Update Position Settlement                        *
      *                                                               *
      *****************************************************************
     C     SRUpdPos      BEGSR
 
     C     KPosSet       SETLL     POSETW2                                04
     C                   IF        *IN04 = *ON
     C                   EVAL      *IN03 = *OFF
     C                   DOW       *IN03 = *OFF
     C     KPosSet       READE     POSETW2                                03
     C                   IF        *IN03 = *OFF
     C                   EVAL      W2_MT5G = 'Y'
 
     C                   IF        WCanFlg = 'Y'
     C                   EVAL      W2_PSEQ = W2_PSEQ + 2
     C                   ELSE
     C                   EVAL      W2_PSEQ = W2_PSEQ + 1
     C                   ENDIF
 
      ** Update LF/POSETW2
 
     C                   UPDATE    W2POSETDF
 
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRORef - Output to PF/MGOREFPD                               *
      *                                                               *
      *****************************************************************
     C     SRORef        BEGSR
 
      ** Initialise fields on PF/MGOREFPD
 
     C                   CLEAR                   MGOREFD0
 
     C                   EVAL      MODI = 'SE'
     C                   EVAL      TRNO = WWMDAT
     C                   EVAL      TNTP = 'PS'
     C                   EVAL      SBTP = ' '
     C                   EVAL      EVTP = WK_PEVT
     C                   EVAL      NWRK = PNwrk
     C                   MOVE      A8BICN        SECN
     C                   EVAL      NWSN = PNwsn
     C                   MOVE      PDest         DECN
     C                   EVAL      NWDS = PNwds
     C                   EVAL      MTPY = '565'
     C                   EVAL      MPRY = 'N'
     C                   EVAL      CIND = '2'                                   185719
     C                   EVAL      CINDV = '2'                                  185719
 
     ** Message Status
 
     ** ... reset status array
 
     C                   CLEAR                   ARMSGST
 
      ** ... set key to destination customer number
 
     C                   MOVEL     DECN          PCustK
 
      ** ... get customer details via access object
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCustK
     C                   PARM      *BLANKS       PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** ... database error in file SDCUSTPD
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 17
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** ... fill status array
 
     C                   EVAL      ARMSGST(1) = BBDS01
     C                   EVAL      ARMSGST(2) = BBDS02
     C                   EVAL      ARMSGST(3) = BBDS03
     C                   EVAL      ARMSGST(4) = BBDS04
     C                   EVAL      ARMSGST(5) = BBDS05
     C                   EVAL      ARMSGST(6) = BBDS06
     C                   EVAL      ARMSGST(7) = BBDS07
     C                   EVAL      ARMSGST(8) = BBDS08
     C                   EVAL      ARMSGST(9) = BBDS09
     C                   EVAL      ARMSGST(10) = BBDS10
     C                   EVAL      ARMSGST(11) = BBDS11
     C                   EVAL      ARMSGST(12) = BBDS12
     C                   EVAL      ARMSGST(13) = BBDS13
     C                   EVAL      ARMSGST(14) = BBDS14
     C                   EVAL      ARMSGST(15) = BBDS15
 
      ** .. is the message type in the array? Set on *IN15 if it is.
 
     C     '565'         LOOKUP    ARMSGST                                11
 
      ** .. if found, set status to 'ready to send', else set to 'created'
 
     C                   IF        *IN11 = *ON
     C                   EVAL      MGST  = 'RSND'
     C                   EVAL      MGSG  = '2'
     C                   ELSE
     C                   EVAL      MGST  = 'CRTD'
     C                   EVAL      MGSG  = '1'
     C                   ENDIF
 
      ** History Retention Date
 
     C                   EVAL      WHDate = WK_PSVL + ENDSMN
     C                   EVAL      PMDay = WHDate
     C                   EVAL      PWDate = *BLANKS
 
     C                   CALL      'ZM0060'                             06
     C                   PARM                    PMDay
     C                   PARM                    PWDate
 
      ** If program not found, perform DB error processing
 
     C                   IF        *IN06 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 11
     C                   EVAL      DBPGM = 'ZM0060'
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set history retention date to output field
 
     C                   EVAL      HRDT = PWDate
 
      ** Message generation date
 
     C                   EVAL      PMDay = BJRDNB
     C                   EVAL      PWDate = *BLANKS
 
     C                   CALL      'ZM0060'                             06
     C                   PARM                    PMDay
     C                   PARM                    PWDate
 
      ** If program not found, perform DB error processing
 
     C                   IF        *IN06 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 12
     C                   EVAL      DBPGM = 'ZM0060'
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set message generated date to output field
 
     C                   MOVE      PWDate        MGDE
 
      ** Convert Settlement Amount to SWIFT format
 
     C                   EVAL      PAmt  = WK_PSAT
     C                   EVAL      PCcy  = WK_PSCU
     C                   EXSR      SREdtAmt
 
      ** Set SWIFT amount to output field
 
     C                   EVAL      AMTS  = PSAmt
 
     C                   TIME                    MGTM
     C                   EVAL      LADT = BJMRDT
     C                   TIME                    LATM
     C                   MOVE      PDateOut      SVDT
     C                   EVAL      BRCA = WK_PBCA
     C                   EVAL      CCY  = WK_PSCU
     C                   EVAL      TSKS = 'Y'
                                                                                              CSD015
      ** .. check if message type exists in the watch list                                    CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' and CSW025 = 'N'                              CSD015
     C                             AND W1EWLC = 'Y'                                           222385
     C                   EXSR      SRWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
 
      ** Write record to PF/MGOREFPD
 
     C                   MOVEL     MG_MGCHG      AORR                                         CSW025
     C                   WRITE     MGOREFD0                             09
 
      ** If error on write of record, perform DB Error processing
 
     C                   IF        *IN09 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 14
     C                   EVAL      DBFILE = 'MGOREFPD'
     C                   EVAL      DBKEY  = WWMDAT
     C                   EVAL      DBPGM  = 'MG0565'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROMsg - Output to PF/MGOMSGPD                               *
      *                                                               *
      *****************************************************************
     C     SROMsg        BEGSR
 
      ** Process Multiple Occurence Data Structure
 
     C                   EVAL      WIdx3 = 1
     C************       DOW       WIdx3 < WOcurIdx                                           186790
     C**********         DOW       WIdx3 <= WOcurIdx                                186790 MD027477A
     C                   DOW       WIdx3 < WOcurIdx                                        MD027477A
 
     C     WIdx3         OCCUR     WMultOcur
 
      ** Format fields on PF/MGOMSGPD
 
     C                   EVAL      MTAG = WMTag
     C                   EVAL      MFLD = WMDat
     C                   EVAL      CTRC = WCrlf
     C                   EVAL      PTDL = *BLANKS
     C                   EVAL      MSEQ = WMSeq
     C                   EVAL      TRNO = WWMDAT
 
      ** Write record to PF/MGOMSGPD
 
     C                   WRITE     MGOMSGD0                             10
 
      ** If error on write of record, perform DB Error processing
 
     C                   IF        *IN10 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 15
     C                   EVAL      DBFILE = 'MGOMSGPD'
     C                   EVAL      DBKEY  = WWMDAT
     C                   EVAL      DBPGM  = 'MG0565'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Increment WMultOcur index
 
     C                   EVAL      WIdx3  = WIdx3 + 1
 
     C                   ENDDO
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGenCanMsg - Generate Cancellation Message                  *
      *                                                               *
      *****************************************************************
 
     C     SRGenCanMsg   BEGSR
 
     C     WMsgKey       Chain(N)  MGOREFL0                           02
 
     C                   IF        *IN02 = *OFF
 
     C                   IF        IMTPY = '565'
 
     C                   IF        IMGST = 'CRTD' AND ILSCC <> 'CANCEL  ' OR
     C                             IMGST = 'AMND' AND ILSCC <> 'CANCEL  '
 
      ** Update PF/MGOREFPD record with MGST='DLTD' and MGSG='4'
 
     C                   CALL      'MG9505'                             12
     C                   PARM      ITRNO         PTNum
     C                   PARM      *BLANKS       PRtnc
 
      ** If program not found, perform DB error processing
 
     C                   IF        *IN12 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 18
     C                   EVAL      DBPGM = 'MG9505'
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If program ended abnormally
 
     C                   IF        PRtnc = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 19
     C                   EVAL      DBPGM = 'MG9505'
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBKEY = PTNum
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        IMGSG = '2' OR IMGSG = '3'
 
     C                   IF        ICARQ <> 'Y' AND ILSCC <> 'CANCEL  '
 
      ** Output cancellation record to PF/MGOMSGPD
 
     C                   EXSR      SRCOMsg
 
      ** Output cancellation record to PF/MGOREFPD
 
     C                   EXSR      SRCORef
 
     C                   EVAL      WCanFlg = 'Y'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCOMsg - Output cancellation record to PF/MGOMSGPD          *
      *                                                               *
      *****************************************************************
 
     C     SRCOMsg       BEGSR
 
     C                   EVAL      WPSeq3 = WPSeq3 + 1
     C                   MOVE      WPSeq3        WPSeq2
     C                   EVAL      WOcurIdx2 = 0
 
     C     ITRNO         CHAIN     MGOMSGLA                           02
 
      ** Process all records in MGOMSGLA with the same
      ** Transaction Reference Number
 
     C                   DOW       *IN02 = *OFF AND ITRNO = ATRNO
 
     C************       IF        AMTAG = ':16R:'                                            186790
 
     C************       IF        AMFLD = 'GENL'                                             186790
     C************       EVAL      WBlock = 'GENL'                                            186790
     C************       ELSE                                                                 186790
     C************       EVAL      WBlock = *BLANKS                                           186790
     C************       ENDIF                                                                186790
 
     C************       ENDIF                                                                186790
 
      ** Set up TRNO field
 
     C
     C                   EVAL      WWMDAT = 'SEP' + WPRef + WPseq2
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx2 = WOcurIdx2 + 1
     C     WOcurIdx2     OCCUR     WMultOcur2
 
     C                   EVAL      MTAG = AMTAG
     C                   EVAL      MFLD = AMFLD
     C                   EVAL      TRNOX = WWMDAT
     C                   EVAL      CTRC = WCrlf
     C                   EVAL      MSEQ = AMSEQ
 
     C************       IF        AMTAG = ':20C:' AND                                        186790
     C************                 WBlock = 'GENL'                                            186790
     C                   IF        AMTAG = ':20C:'                                            186790
     C                   MOVEL     AMFLD         W_KeyWord                                    186790
     C                   IF        W_Keyword = ':SEME'                                        186790
     C                   EVAL      MFLD = *BLANKS
     C************       EVAL      MFLD = 'SEME//' + TRNO                                     186790
     C                   EVAL      MFLD = ':SEME//' + TRNOX                                   186790
     C                   ENDIF
     C                   ENDIF                                                                186790
 
     C                   IF        AMTAG = ':23G:'
     C                   EVAL      MFLD = *BLANKS
     C                   EVAL      MFLD = 'CANC'
     C                   ENDIF
 
     C************       IF        AMTAG = ':22F:' AND                                        186790
     C************                 WBlock = 'GENL'                                            186790
     C                   IF        AMTAG = ':22F:'                                            186790
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx2 = WOcurIdx2 + 1
     C     WOcurIdx2     OCCUR     WMultOcur2
 
      ** Format field :16R: - Start of Block
 
     C                   EVAL      MTAG = ':16R:'
 
      ** Access tag description
 
     C                   EXSR      SRMTAG
 
     C                   EVAL      MFLD = 'LINK'
     C                   EVAL      TRNOX = WWMDAT
     C                   EVAL      CTRC = WCrlf
     C                   EVAL      MSEQ = 'A1'
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx2 = WOcurIdx2 + 1
     C     WOcurIdx2     OCCUR     WMultOcur2
 
      ** Format field :20C: - Reference
 
     C                   EVAL      MTAG = ':20C:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C************       EVAL      MFLD = 'SEME//' + WMsgKey                                  186790
     C                   EVAL      MFLD = ':SEME//' + WMsgKey                                 186790
     C                   EVAL      TRNOX = WWMDAT
     C                   EVAL      CTRC = WCrlf
     C                   EVAL      MSEQ = 'A1'
 
      ** Access the next occurence in WMultOcur
 
     C                   EVAL      WOcurIdx2 = WOcurIdx2 + 1
     C     WOcurIdx2     OCCUR     WMultOcur2
 
      ** Format field :16S: - End of Block
 
     C                   EVAL      MTAG  = ':16S:'
 
      ** Access tag description
 
     C                   EXSR      SRMTag
 
     C                   EVAL      MFLD = 'LINK'
     C                   EVAL      TRNOX = WWMDAT
     C                   EVAL      CTRC = WCrlf
     C                   EVAL      MSEQ = 'A1'
 
     C                   ENDIF
 
      ** Read the next record on LF/MGOMSGLA
 
     C                   READ      MGOMSGLA                               02
 
     C                   ENDDO
 
      ** Write multiple occurence data structure to PF/MGOMSGPD
 
     C                   EVAL      WIdx3 = 1
     C                   DOW       WIdx3 < WOcurIdx2
 
     C     WIdx3         OCCUR     WMultOcur2
 
     C                   EVAL      TRNO = TRNOX
     C                   WRITE     MGOMSGD0                             10
 
      ** If error on write of record, perform DB Error processing
 
     C                   IF        *IN10 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 20
     C                   EVAL      DBFILE = 'MGOMSGPD'
     C                   EVAL      DBKEY  = WWMDAT
     C                   EVAL      DBPGM  = 'MG0565'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Increment WMultOcur index
 
     C                   EVAL      WIdx3  = WIdx3 + 1
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCORef - Output cancellation record to PF/MGOREFPD          *
      *                                                               *
      *****************************************************************
 
     C     SRCORef       BEGSR
 
      ** Update LF/MGOREFL0
 
     C     WMsgKey       CHAIN     MGREFL0                            02
 
     C                   IF        *IN02 = *OFF
 
     C                   EVAL      ICARQ = 'Y'
     C                   EVAL      ILADT = BJMRDT
     C                   TIME                    ILATM
 
     C                   UPDATE    MGREFL0
 
     C                   ENDIF
 
      ** Set up MGOREFPD fields
 
     C                   EVAL      MGRefPDDS = MGRefL0DS
     C                   EVAL      TRNO = WWMDAT
     C                   EVAL      LADT = BJMRDT
     C                   TIME                    LATM
 
      ** Message generation date
 
     C                   EVAL      PMDay = BJRDNB
     C                   EVAL      PWDate = *BLANKS
 
     C                   CALL      'ZM0060'                             06
     C                   PARM                    PMDay
     C                   PARM                    PWDate
 
      ** If program not found, perform DB error processing
 
     C                   IF        *IN06 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 21
     C                   EVAL      DBPGM = 'ZM0060'
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set message generated date to output field
 
     C                   MOVE      PWDate        MGDE
     C                   TIME                    LATM
 
     C                   EVAL      MGSG = '1'
     C                   EVAL      MGST = 'CRTD'
     C                   EVAL      CARQ = *BLANK
     C                   EVAL      LSCC = '        '
 
      ** Write record to PF/MGOREFPD
 
     C                   MOVEL     MG_MGCHG      AORR                                         CSW025
     C                   WRITE     MGOREFD0                             09
 
      ** If error on write of record, perform DB Error processing
 
     C                   IF        *IN09 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 22
     C                   EVAL      DBFILE = 'MGOREFPD'
     C                   EVAL      DBKEY  = WWMDAT
     C                   EVAL      DBPGM  = 'MG0565'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                              CSW097
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRWatch - Watch Processing                                    *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
                                                                                              CSD015
     C     SRWatch       BEGSR                                                                CSD015
                                                                                              CSD015
      ** Check if message is for automatic release.                                           CSD015
      ** If yes, default to CRTD status and set Automatic Release Flag to 'Y'                 CSD015
                                                                                              CSD015
     C                   EVAL      PARLS = 'N'                                                CSD015
     C                   IF        MGST = 'RSND' and (NWRK = 'SWIFT ' or                      CSD015
     C                              NWRK = 'TELEX ' or NWRK = 'STTX  ')                       CSD015
     C                   EVAL      MGST = 'CRTD'                                              CSD015
     C                   EVAL      MGSG = '1'                                                 CSD015
     C                   EVAL      PARLS = 'Y'                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   CLEAR                   WLTDS                                        CSD015
     C                   EVAL      W4AMT1 = 0                                                 CSD015
     C                   EVAL      W4AMT2 = 0                                                 CSD015
                                                                                              CSD015
     C                   MOVE      *ZEROS        PInDate                                      CSD015
     C                   EXSR      SrCvtDate                                                  CSD015
     C                   EVAL      W4VDAT = POutDate                                          CSD015
     C                   EVAL      W4MDAT = POutDate                                          CSD015
                                                                                              CSD015
      ** Setup parameters for Compliance engine program                                       CSD015
                                                                                              CSD015
     C                   EVAL      W4IDEN = TRNO                                              CSD015
     C                   EVAL      W4ITEM = MTPY                                              CSD015
     C                   EVAL      W4BRCH = BRCA                                              CSD015
     C                   EVAL      W4FUNT = 'MGOREF'                                          CSD015
     C                   MOVE      DECN          W4CNUM                                       CSD015
     C                   EVAL      W4ARLS = PARLS                                             CSD015
                                                                                              CSD015
     C                   MOVE      BJRDNB        PInDate                                      CSD015
     C                   EXSR      SrCvtDate                                                  CSD015
     C                   EVAL      W4DDAT = POutDate                                          CSD015
                                                                                              CSD015
      ***Send*transaction to compliance engine program                                 CSD015 221145
      *******************                                                              CSD015 221145
     C*******************CALL      'SDCWLCHK'                                          CSD015 221145
     C*******************PARM                    WLTDS                                 CSD015 221145
     C*******************PARM      *BLANKS       PString                               CSD015 221145
                                                                                              CSD015
     C     EWatch        ENDSR                                                                CSD015
      *****************************************************************                       221145
      /EJECT                                                                                  221145
      *****************************************************************                       221145
      *                                                               *                       221145
      * WLCDQ   - Submit information to Watch List Checking           *                       221145
      *                                                               *                       221145
      *****************************************************************                       221145
                                                                                              221145
     C     WLCDQ         BEGSR                                                                221145
                                                                                              221145
                                                                                              221145
      ** Send transaction to compliance engine program                                        221145
                                                                                              221145
     C                   CALL      'SDCWLCHK'                                                 221145
     C                   PARM                    WLTDS                                        221145
     C                   PARM      *BLANKS       PString                                      221145
                                                                                              221145
     C                   ENDSR                                                                221145
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  SrCvtDate - Convert dates to be used for Watch Engine Pgm    *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrCvtDate     BegSr                                                                CSD015
                                                                                              CSD015
     C                   CALLB     'ZACVTDATE'                                                CSD015
     C                   PARM      *Blanks       ReturnCode                                   CSD015
     C                   PARM                    PInDate                                      CSD015
     C                   PARM                    POutDate                                     CSD015
     C                   PARM                    PCvtdDate                                    CSD015
                                                                                              CSD015
     C                   Endsr                                                                CSD015
                                                                                              CSD015
      *****************************************************************                       CSD015
      /EJECT
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
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SDMGMEPD for message management data
 
     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG    '    PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDMGME        PARM      SDMGME        DSFDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDMGMEPD'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SE ICD details
 
     C                   CALLB     'AOSTRDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDSTRD        PARM      SDSTRD        DSFDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDSTRDPD'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Copy depot reference to array ARDICD
 
     C                   EVAL      ARDICD(1) = BVDR1
     C                   EVAL      ARDICD(2) = BVDR2
     C                   EVAL      ARDICD(3) = BVDR3
     C                   EVAL      ARDICD(4) = BVDR4
     C                   EVAL      ARDICD(5) = BVDR5
     C                   EVAL      ARDICD(6) = BVDR6
     C                   EVAL      ARDICD(7) = BVDR7
     C                   EVAL      ARDICD(8) = BVDR8
     C                   EVAL      ARDICD(9) = BVDR9
     C                   EVAL      ARDICD(10) = BVDR10
                                                                                              CSE028
      ** Check if CSE028 is installed                                                         CSE028
                                                                                              CSE028
     C                   EVAL      CSE028 = 'N'                                               CSE028
     C                   CALLB     'AOSARDR0'                                                 CSE028
     C                   PARM      *Blanks       PRtcd                                        CSE028
     C                   PARM      '*VERIFY'     POptn                                        CSE028
     C                   PARM      'CSE028'      PSard                                        CSE028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE028
                                                                                              CSE028
      ** Database error.                                                                      CSE028
                                                                                              CSE028
     C                   IF        PRtcd <> *BLANKS  AND                                      CSE028
     C                             PRtcd <> '*NRF   '                                         CSE028
     C                   EVAL      DBKEY = PSard                                ************  CSE028
     C                   EVAL      DBFILE = 'SCSARDPD'                          * DBASE 003*  CSE028
     C                   EVAL      DBASE  =  004                                ************  CSE028
     C                   EXSR      *PSSR                                                      CSE028
     C                   ENDIF                                                                CSE028
                                                                                              CSE028
     C                   IF        PRtcd = *Blanks                                            CSE028
     C                   EVAL      CSE028 = 'Y'                                               CSE028
     C                   ELSE                                                                 CSE028
     C                   EVAL      CSE028 = 'N'                                               CSE028
     C                   ENDIF                                                                CSE028
      *                                                                                       197311
      ** Check if Swift 2001 Standards Update is installed                                    197311
      *                                                                                       197311
     C                   CALL      'SWIF2001'                                                 197311
     C                   PARM      *BLANKS       PRTCD                                        197311
      *                                                                                       197311
     C     PRTCD         IFEQ      'CSW2001'                                                  197311
     C                   MOVE      'Y'           CSW201            1                          197311
     C                   ELSE                                                                 197311
     C                   MOVE      'N'           CSW201                                       197311
     C                   ENDIF                                                                197311
 
      ** Access SAR details file to determine if Compliance Watch                             CSD015
      ** (CSD015) is installed                                                                CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
     C                   EVAL      W1EWLC = 'N'                                               222385
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *Blanks       PRtcd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error.                                                                      CSD015
                                                                                              CSD015
     C                   IF        PRtcd <> *BLANKS  AND                                      CSD015
     C                             PRtcd <> '*NRF   '                                         CSD015
     C                   EVAL      DBKEY = PSard                                              CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE  =  027                                              CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtcd = *Blanks                                            CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
      *                                                                                       222385
      ** Access AOWLCCR0 to check if function code MESSGENT is available                      222385
      *                                                                                       222385
     C                   CALLB     'AOWLCCR0'                                                 222385
     C                   PARM      *BLANKS       PRtcd                                        222385
     C                   PARM      '*KEY   '     POptn                                        222385
     C                   PARM      'MESSGENT'    Pfunc             8                          222385
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        222385
                                                                                              222385
      ** Database error                                                                       222385
                                                                                              222385
     C                   IF        PRtcd <> *BLANKS AND                                       222385
     C                             PRtcd <> '*NRF'                                            222385
     C     *LOCK         IN        LDA                                                        222385
     C                   EVAL      DBKEY = 'MESSGENT'                                         222385
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        222385
     C                   EVAL      DBASE = 24                                                 222385
     C                   OUT       LDA                                                        222385
     C                   EXSR      *PSSR                                                      222385
     C                   ENDIF                                                                222385
                                                                                              222385
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Access SAR details file to determine if Midas Message Manager                        CSD015
      ** (CSW025) is installed                                                                CSD015
                                                                                              CSD015
     C                   EVAL      CSW025 = 'N'                                               CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *Blanks       PRtcd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CSW025'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error.                                                                      CSD015
                                                                                              CSD015
     C                   IF        PRtcd <> *BLANKS  AND                                      CSD015
     C                             PRtcd <> '*NRF   '                                         CSD015
     C                   EVAL      DBKEY = PSard                                              CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE  =  028                                              CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtcd = *Blanks                                            CSD015
     C                   EVAL      CSW025 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSW203
      ** Check if Swift 2003 Standards Update is installed                                    CSW203
      *                                                                                       CSW203
     C                   CALL      'SWIF2003'                                                 CSW203
     C                   PARM      *BLANKS       PRTCD                                        CSW203
      *                                                                                       CSW203
     C     PRTCD         IFEQ      'CSW2003'                                                  CSW203
     C                   MOVE      'Y'           CSW203                                       CSW203
     C                   ELSE                                                                 CSW203
     C                   MOVE      'N'           CSW203                                       CSW203
     C                   ENDIF                                                                CSW203
      *                                                                                       CSW216
      ** Check if Swift 2016 Standards Update is installed                                    CSW216
      *                                                                                       CSW216
     C                   CALL      'SWIF2016'                                                 CSW216
     C                   PARM      *BLANKS       PRTCD                                        CSW216
      *                                                                                       CSW216
     C     PRTCD         IFEQ      'CSW2016'                                                  CSW216
     C                   EVAL      CSW216 = 'Y'                                               CSW216
     C                   ELSE                                                                 CSW216
     C                   EVAL      CSW216 = 'N'                                               CSW216
     C                   ENDIF                                                                CSW216
                                                                                              CSD015
      ** Report Work fields.
 
     C                   EVAL      WWPtl1 = 0
     C                   EVAL      WWPtl2 = 0
 
      ** Set WCrlf control character
 
     C                   EVAL      WPrtErrFlg = 'N'
     C                   EVAL      WCrlf = *LOVAL
     C                   BITON     '457'         WWCr
     C                   BITON     '257'         WWLf
 
      ** Key List
 
     C     KBnfOwn       KLIST
     C                   KFLD                    KCustNo
     C                   KFLD                    KCtyTty
     C                   KFLD                    KBenOwnNo
 
     C     KPosSet       KLIST
     C                   KFLD                    WSecurity
     C                   KFLD                    WValDat
     C                   KFLD                    WEvnType
     C                   KFLD                    WCntPty
 
     C     KTag          KLIST
     C                   KFLD                    WMTag
     C                   KFLD                    KType
     C                   KFLD                    KSequence
 
     C     WKey1         KLIST
     C                   KFLD                    KCrtt
     C                   KFLD                    KCode
                                                                                185763
     C     InvtpK        KLIST                                                  185763
     C                   KFLD                    NMCY                           185763
     C                   KFLD                    SITP                           185763
                                                                                185763
      *                                                                         185733
      ** Define key list for PF/STDSED                                          185733
      *                                                                         185733
     C     KLSTD         KLIST                                                  185733
     C                   KFLD                    MG_PBCA                        185733
     C                   KFLD                    MG_PCPY                        185733
     C                   KFLD                    MG_PBCD                                      CSE028
     C                   KFLD                    MG_PNCY                        185733
     C************       KFLD                    SITP                           185733        186790
     C                   KFLD                    W_SITP                                       186790
     C                   KFLD                    MG_PTFR                                      CSE028
      *                                                                         185733
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
     C                   ROLBK
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   OPEN      MG0565AU
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
** ARERR - Error Message Description
Destination Customer Number not found
*** Message is Unroutable ***
<Tag Description not found>
ZM1240 (format ccy and amount) call ended in error
Quantity of Nominal Position Amount is zero
Quantity of Total Nominal Position Amount is zero
