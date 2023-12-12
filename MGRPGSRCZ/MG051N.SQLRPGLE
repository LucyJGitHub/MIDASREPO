     H********1**                                                         140440
     H DEBUG FTRANS
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056560
/*STD *  RPGSQLBND                                                    *                     MD056560
/*EXI *  TEXT('Midas MG Format MT515 and MT518 messages')             *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  MG051N - MG Format MT515 and MT518 Messages                  *
      *                                                               *
      *  Function:  This program will generate MT515 and MT518        *
      *  (IC)       messages from the extract file (MGF51NPD)         *
      *             and output them to MGOMSGPD and MGOREFPD          *
      *                                                               *
      *  Called By: SEC0304 - Input Cycle Confirmation Print          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061161           Date 21Nov23               *
      *  Prev Amend No. MD058081           Date 11May21               *
      *                 MD056560           Date 31Aug20               *
      *                 MD046248           Date 27Oct17               *
      *                 CSW216             Date 14Mar16               *
      *                 261402             Date 11May16               *
      *                 CSW214             Date 25Nov14               *
      *                 CFT050             Date 03Jun13               *
      *                 MD019844           Date 05Apr13               *
      *                 AR589164           Date 13Aug10               *
      *                 AR581757           Date 26Jul10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25073           Date 21Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG21097           Date 18Sep08               *
      *                 BUG20950           Date 10Sep08               *
      *                 BUG20437           Date 10Sep08               *
      *                 BUG19907           Date 10Jul08               *
      *                 BUG19304           Date 18Jun08               *
      *                 CSW208             Date 15Apr08               *
      *                 BUG18526A          Date 12May08               *
      *                 BUG18526           Date 02May08               *
      *                 248680             Date 28Jul07               *
      *                 CSW207             Date 07Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 234140             Date 26Sep06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2381            Date 13May04               *
      *                 CGL029             Date 01Sep03               *
      *                 222385             Date 23Oct03               *
      *                 221145             Date 08Sep03               *
      *                 219242             Date 01Jul03               *
      *                 219241             Date 01Jul03               *
      *                 CSW203             Date 26May03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 202330             Date 15Apr02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 208890             Date 22Aug02               *
      *                 CSW202             Date 20May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW025             Date 26Mar02               *
      *                 196628             Date 10Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 20Sep00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSW200             Date 21Aug00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 07Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 140966             Date 19Aug98               *
      *                 140440             Date 05Aug98               *
      *                 CSW014             Date 19Jun98               *
      *                 CSW098  *CREATE    Date 16Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061161 - MT518 reference number is incorrect for Repo deals*
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  261402 - If location code of the branch is blank, flag as    *
      *           not MiFID compliant.                                *
      *         - Applied for MD-37893.                               *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CFT050 - SWIFTRef Directories upload (Recompile)             *
      *  MD019844 - Generate field :17B::ACRU// only for :19A::SETT// *
      *  AR589164 - Additional fix to cater //XX input                *
      *  AR581757 - One MT518 is not generated for a repo transaction *
      *  CSW210 - Swift 2010 Changes                                  *
      *  BUG25073 - MSC0501 00001 failed in COB                       *
      *  BUG21097 - Missing field 22F INFI in MT518.                  *
      *             Applied BUG18526A.                                *
      *  BUG20950 - MT518 should not have 22F INFI if destination     *
      *             customer is not MFID compliant                    *
      *  BUG20437 - MT515 field 98E value is incorrect                *
      *  BUG19907 - For Pledge loan on start date 22F should be COLI  *
      *             and on maturity date it should be COLO.           *
      *             Reverse would be for Pledge deposit.              *
      *  BUG19304 - GMT not reflected in 98E tag                      *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *  BUG18526A- MT518 field tag 22F is missing. Change the access *
      *             object being called.                              *
      *  BUG18526 - MT518 field tag 22F is missing. Applied BUG14851  *
      *             fix                                               *
      *  248680 - For MGDYBS and MGDVBS combinations that are not     *
      *           found in the table, value should be 'OTHR' for MICO.*
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  234140 - EU witholding tax                                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
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
      *  202330 - Extend 196628 to cover CINDV.                       *
      *  208890 - Various Core Fixes in SWIFT                         *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  CSW025 - Midas Message Manager                               *
      *           - Pass original change type                         *
      *  196628 - Assigned value to Century Indicator to correct Y2K  *
      *           problem.                                            *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  CSE023 - Treaty Withholding Tax                              *
      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
      *  CSW200 - SWIFT 2000 Changes                                  *
      *  CSE006 - Repurchase Agreements (REPOs) enhancement           *
      *  140966 - SWIFT98 fix                                         *
      *           Negative sign on amounts should be represented      *
      *           by a 'N' rather than '-'.                           *
      *  140440 - SWIFT98 fix                                         *
      *           Include translation table SWIFTRANS                 *
      *  CSW014 - ERI Information for non-EMU users.                  *
      *         - Output Original Currency and Amount                 *
      *  CSW098 - SWIFT 1998 Changes                                  *
      *                                                               *
      *****************************************************************
     FMGF51NPD  UF   E           K DISK    INFSR(*PSSR)
     F*SDMTAGL0* IF   E           K DISK    INFSR(*PSSR)                                    MD056560
     FSECRTNL1  IF   E           K DISK    INFSR(*PSSR)
     FTRADS     IF   E           K DISK    INFSR(*PSSR)
     FTRADSDY1  IF   E           K DISK    INFSR(*PSSR)
     FTRADSDY2  IF   E           K DISK    INFSR(*PSSR)
     FSEMKC     IF   E           K DISK    INFSR(*PSSR)
     FMGOREFL1  IF   E           K DISK    INFSR(*PSSR)                                     MD061161
     F                                     RENAME(MGOREFD0:MGREFL0)                         MD061161
     F                                     PREFIX(M_)                                       MD061161
     FMGOREFPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     FMGOMSGPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F*MEISOCL1* IF   E           K DISK    INFSR(*PSSR)                                    MD058081
     FDPTMVDL1  IF   E           K DISK    INFSR(*PSSR)
     FMG051NA1  O    E             PRINTER INFDS(OVRFL1)
     F                                     INFSR(*PSSR)
     FMG051NA2  O    E             PRINTER INFDS(OVRFL2)
     F                                     USROPN
     F                                     INFSR(*PSSR)
     FMG051NAU  O    E             PRINTER USROPN
     F/COPY WNCPYSRC,MG051NF001
      *****************************************************************
      /TITLE FUNCTION OF INCICATORS
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *    21  - MG5900 not found                                     *
      *    22  - MG5910 not found                                     *
      *    23  - ZM1100 not found                                     *
      *    24  - ZM1190 not found                                     *
      *    25  - ZM1240 not found                                     *
      *    26  - ZM1150 not found                                     *
      *    27  - ZM1140 not found                                     *
      *    28  - ZM1050 not found                                     *
      *    29  - MT0579 not found                                     *
      *                                                               *
      *    50  - End of MGF51NPD                                      *
      *    51  - End of SDMTAGL0                                      *
      *    52  - Charge/Commission Code found in array CCS            *
      *    53  - Message Type found in array @ST                      *
      *    54  - End of SECRTNLN1                                     *
      *    55  - Record not found in TRADS                            *                       CSW201
      *    56  - Record not found in MEISOCL1                         *                       CSW207
      *    58  - Record not found in DPTMVDL1                         *                       CSW208
      *                                                               *
      *    60  - PRTF/MG051NA2 has been opened                        *
      *    61  - Error in write to PF/MGOMSGPD                        *
      *    62  - Error in write to PF/MGOREFPD                        *
      *                                                               *
      *    98  - Date Format: DDMMYY (off); MMDDYY (on)               *
      *  90-99 - Used by Standard Subroutines                         *
      *                                                               *
      *  U7+U8 - Database Error                                       *
      *                                                               *
      *****************************************************************
      /TITLE SUBROUTINE INDEX
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Initial Processing                                  *
      *  SRINTF - Initialise non-constant fields                      *
      *  SRROUT - Determine message routing                           *
      *  SRFMT  - Format MT515 or MT518 for message output            *
      *  SRGENL - Format MT515 or MT518 Seq A fields                  *
      *  SRLINK - Format MT515 Subsequence A1 fields                  *
      *  SRCDET - Format MT515 Seq C or MT518 Seq B fields            *
      *  SRCPTY - Format MT515 Subseq C1 or MT518 Subseq B1           *
      *  SRFFIA - Format MT515 Subseq C2 or MT518 Subseq B2           *
      *  SRSDET - Format Mt515 Seq D MT518 Seq C fields               *
      *  SR5SPY - Format MT515 Subseq D1                              *
      *  SR8SPY - Format MT518 Subseq C1                              *
      *  SRCSHP - Format MT515 Subseq D2 or MT518 Subseq C2           *
      *  SRFAMT - Format MT515 Subseq D3 or MT518 Subseq C3           *
      *  SRRDET - Format of additional REPO block after subsequence D *   CSE006
      *  SRPERR - Print message not generated (i.e. in error)         *
      *  SROMSG - Output to PF/MGOMSGPD                               *
      *  SROREF - Output to PF/MGOREFPD                               *
      *  SRPGEN - Print message generated                             *
      *  SRSWCY - Retrieve the SWIFT Currency Code                    *
      *  SRSTAT - Determine message status                            *
      *  SRF95  - Format field :95a: - Party                          *
      *  SR#ZA  - Format addresses                                    *
      *  SRMTAG - Access tag/field description                        *
      *  SRUPDT - Update transaction record                           *
      *                                                               *
      *  *PSSR  - Program error handling routine                      *
      *                                                               *
      *****************************************************************
      /TITLE E-SPECIFICATIONS
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D**********          ERRA    1  20 50                                                    CSW203
     D ERRA            S             80    DIM(20) CTDATA PERRCD(1)
      *
      ** Array used to format error msg field on Mult Occur DS
      *
     D TYPA            S             20    DIM(2) CTDATA PERRCD(1)
      *
      ** Array used to format Trade Type Description on Report
      *
     D CCA             S             13  0 DIM(10)
      *
      ** Array for Charges and Commision Amount
      ** (Will be used to accumulate the amount of charges
      **  and commissions with the same SWIFT ID)
      *
     D CCS             S              4    DIM(10)
      *
      ** Array for Charges and Commision SWIFT ID
      ** (Will be used to accumulate the amount of charges
      **  and commissions with the same SWIFT ID)
      *
      *
      ** Array for Charges and Commision amount
      *
      *
      ** Array for Charges and Commision ID's
      *
     D @ST             S              3    DIM(15)
     D WRKACT          S              1    DIM(35)
     D WRKSFE          S              1    DIM(40)
      *
      ** Array used to set message status
      *
      /SPACE 3
     D OVRFL1          DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
      *
      ** File Information Date Structure for MG051NA1
      *
     D OVRFL2          DS
     D  WWOFL2               188    189B 0
     D  WWPTL2               367    368B 0
      *
      ** File Information Date Structure for MG051NA2
      *
     D MULT            DS                  OCCURS(500)
     D  MDES                   1     36
     D  MTAG                  37     41
     D  MDAT                  42     91
     D  MERR                  92    141
     D  RDAT                 142    191
     D  MSEQ                 192    194
      *
      ** Multiple occurrence data structure for message
      *
     D CRLFDS          DS             2
     D  CTRC                   1      2
     D  WWCR                   1      1
     D  WWLF                   2      2
      *
      ** Date Structure for CRLF control character
      *
     D CCDEDS          DS
     D  CDE                    1     40
     D                                     DIM(10)
     D  MGTBCI                 1      4
     D  MGTCCI                 5      8
     D  MGTCI1                 9     12
     D  MGTCI2                13     16
     D  MGTCI3                17     20
     D  MGTCI4                21     24
     D  MGTCI5                25     28
     D  MGTCI6                29     32
     D  MGTCI7                33     36
     D  MGTAX1                37     40
      *
      ** Charges and Commissions ID Data Structure
      *
     D CAMTDS          DS
     D  AMT                    1    130  0
     D                                     DIM(10)
     D  MGTBCA                 1     13  0
     D  MGTCCA                14     26  0
     D  MGTCA1                27     39  0
     D  MGTCA2                40     52  0
     D  MGTCA3                53     65  0
     D  MGTCA4                66     78  0
     D  MGTCA5                79     91  0
     D  MGTCA6                92    104  0
     D  MGTCA7               105    117  0
     D  MGTAXA               118    130  0
      *
      ** Charges and Commissions  Amount Data Structure
      *
     D DBERR           DS            20
     D  @MODI                  1      2
     D  WW0317                 3     17
      *
      ** Data Structure for DB Error
      *
     D DBERR1          DS            26
     D  @SNDR                  1      6
     D  @SCSD                  7     18
     D  @DEST                 19     24
     D  @SETP                 25     26
      *
      ** Data Structure for DB Error in PGM/ZM1100
      *
     D DBERR2          DS            16
     D  WWAMT                  1     13  0
     D  ZCCY                  14     16
      *                                                                                       CSW203
     D WT2FIN          DS            35
     D  W01CHR                 1      1
     D  WKFINF                 2     35
      *                                                                                       CSW203
     D WMPRAC          DS            12
     D  WBICCD                 1      8
     D  WKMRPR                 5      6
     D  WBICBR                 9     11
      *
      ** Data Structure for DB Error in PGM/ZM1240
      *
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
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *                                                                                       CSD015
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Data structure for SAR - Switchable features file                                    CSD015
      *                                                                                       CSD015
     D WLTDS         E DS                  EXTNAME(SDWLTOPD)
      ** DS For Watch List Transaction Details File                                           CSD015
      *                                                                                       CSD015
     D PSTRNG          DS          9999
      *                                                                                       CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)
      ** Watch list checking details                                                          222385
      *                                                                                       222385
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First Data Structure for Access Objects
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Second Data Structure for Access Objects
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *                                                                                       CSW036
      ** Very Large Data Structure for Access Objects                                         CSW036
      *                                                                                       CSW036
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Bank Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Currency Details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Branch Details
      *
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      *
      ** Branch Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)
      *
      ** Customer Details
      *
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *                                                                                       CSW207
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      *                                                                                       CSW207
      ** Location Code Details                                                                CSW207
      *                                                                                       CSW207
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *                                                                                       CSW207
      ** Midas SD Securities clients                                                          CSW207
      *                                                                                       CSW207
     D SDCSSW        E DS                  EXTNAME(SDCSSWPD)
      *                                                                                       CSW207
      ** Midas SD Customer Extensions SWIFT Details                                           CSW207
      *                                                                                       CSW207
      ** Variable declaration for ZADTMCVT                                                    CSW208
     D                 DS
     D  PFRTM                  1      6  0
     D  PMKTM                 11     16  0
     D  PMKTOF                21     24  0
     D  PLCTM                 31     36  0
     D  PLCTOF                41     44  0
     D  PSYTM                 51     56  0
     D  PSYTOF                61     64  0
      *                                                                                     MD061161
      ** DS for MGOREFPD Transaction Number                                                 MD061161
      *                                                                                     MD061161
     D MGOKEY          DS            16                                                     MD061161
     D  TRANNO                 1     10                                                     MD061161
     D  SEQNUM                11     16  0                                                  MD061161
      *                                                                                     BUG19304
     D PGMF            C                   CONST('SDMFID-                                         BU
     D                                     TIM')                                                  BU
      *                                                                                       CSW210
     D ALPHAN          C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ0123456789')
      *                                                                                       CSW210
     D SDMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
     D MEISOC        E DS                  EXTNAME(MEISOJW0)                                MD058081
      *****************************************************************
      /TITLE Main Processing
      *****************************************************************
      *  P R O G R A M     S T A R T                                  *
      *****************************************************************
      *
      ** Initial Processing
      *
     C                   EXSR      SRINIT
      *
      ** Read the first record in MGF51NPD
      *
     C                   READ      MGF51NPD                               50
      *
      ** Do while there are records read in PF/MGF51NPD
      *
     C     *IN50         DOWEQ     *OFF
      *
      ** Initialise non-constant fields
      *
     C                   EXSR      SRINTF
      *
      ** Determine message routing
      *
     C                   EXSR      SRROUT
      *
      ** Format MT515 or MT518 message fields
      *
     C                   EXSR      SRFMT
      *
      ** If any error whilst formatting message fields
      *
     C     @ERR          IFEQ      'Y'
      *
      **   ... print error message
      *
     C                   EXSR      SRPERR
      *
      ** Otherwise,
      *
     C                   ELSE
      *
      **   ... output to PF/MGOMSGPD and PF/MGOREFPD
      *
     C                   EXSR      SROMSG
      *
      **   ... print message generated details
      *
     C                   EXSR      SRPGEN
     C                   MOVE      'Y'           WMSGEN            1
      *
     C                   ENDIF
      *
      ** Delete record in MGF51NPD
      *
     C                   DELETE    MGF51ND0
      *
      ** If record succesfully generated, update transaction record
      *
     C     @ERR          IFNE      'Y'
     C                   EXSR      SRUPDT
     C                   ENDIF
      *
      ** Comit all changes to file
      *
     C                   COMMIT
      *                                                                   221145
      **  Call Compliance Watch:Watch List Checking                       221145
      *                                                                   221145
     C     CSD015        IFEQ      'Y'                                                         22114
     C     W1EWLC        ANDEQ     'Y'
     C     CSW025        ANDEQ     'N'                                                         22114
     C                   EXSR      WLCDQ                                                       22114
     C                   ENDIF                                                                 22114
      *
      ** Read next PF/MGF51NPD record
      *
     C                   READ      MGF51NPD                               50
      *
     C                   ENDDO
      *
      ** Write trailer on SWIFT Messages Generated Report
      ** (PRTF/MG051NA1) only if messages generated
      *
     C     WMSGEN        IFNE      'Y'
      *
     C                   WRITE     HEADER1
     C                   WRITE     NODETS
      *
     C                   ELSE
      *
      ** ... Check for Overflow
      *
     C     WWOFL1        SUB       WWPTL1        WWLINE            2 0
      *
     C     WWLINE        IFLT      4
     C                   WRITE     HEADER1
     C                   ENDIF
      *
     C                   WRITE     EOREPT1
     C                   ENDIF
      *
      ** Write trailer on SWIFT Messages not Generated Report
      ** (PRTF/MG051NA2) only if the printer file has been opened
      *
     C     *IN60         IFEQ      '1'
      *
      ** ... Check for overflow
      *
     C     WWOFL2        SUB       WWPTL2        WWLINE
      *
     C     WWLINE        IFLT      4
     C                   WRITE     HEADER2
     C                   ENDIF
      *
     C                   WRITE     EOREPT2
      *
     C                   ENDIF
      *
      *****************************************************************
      *  P R O G R A M     E N D                                      *
      *****************************************************************
      *                                                               *
     C/COPY WNCPYSRC,MG051NC001
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
      *****************************************************************
      /TITLE SR/SRINIT
      *****************************************************************
      *                                                               *
      *  SRINIT - Subroutine to do program initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *                                                                                       CSW207
      ** Defining work Variables                                                              CSW207
      *                                                                                       CSW207
     C                   MOVEL     *BLANKS       WUTC              5
     C                   MOVEL     *BLANKS       WDEST             1
     C                   MOVEL     *BLANKS       WBRCA             1
     C                   MOVEL     *BLANKS       WMFID             1
     C                   MOVEL     *BLANKS       WFINCA            1
     C                   MOVEL     *BLANKS       WFTRCA            1
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Data base error in file (SDBANKPD)
      *
     C     WRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     001           DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         *DB ERROR 001 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Access SDMGMEPD for message management data
      *
     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG   '     WRTCD
     C                   PARM      '*FIRST '     WOPTN
     C     SDMGME        PARM      SDMGME        DSFDY
      *
     C     WRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     002           DBASE                          ***************
     C                   MOVEL     'SDMGMEPD'    DBFILE                         *DB ERROR 002 *
     C                   MOVEL     *BLANKS       DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check if (CSW003) MT5XX - Phase 2 Message Generation is On
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '*BLANKS'     WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSW003'      WSARD             6
      *
     C     WRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSW003            1
     C                   ELSE
     C                   MOVE      'N'           CSW003
     C                   ENDIF
      *
      ** Check if (CEU005) SE Settlement Ccy conversion
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '*BLANKS'     WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CEU005'      WSARD             6
      *
     C     WRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU005            1
     C                   ELSE
     C                   MOVE      'N'           CEU005
     C                   ENDIF
      *                                                                   CSW014
      *** Check if SAR CSW014 is present                                  CSW014
      *                                                                   CSW014
     C                   CALL      'AOSARDR0'                                                  CSW01
     C                   PARM      '*BLANKS'     WRTCD                                         CSW01
     C                   PARM      '*VERIFY'     WOPTN                                         CSW01
     C                   PARM      'CSW014'      WSARD                                         CSW01
      *                                                                   CSW014
     C     WRTCD         IFEQ      *BLANKS                                                     CSW01
     C                   MOVE      'Y'           CSW014            1                           CSW01
     C                   ELSE                                                                  CSW01
     C                   MOVE      'N'           CSW014                                        CSW01
     C                   ENDIF                                                                 CSW01
     C/COPY WNCPYSRC,MG051NC002
      *                                                                   CSE006
      *** Check if SAR CSE006 is present                                  CSE006
      *                                                                   CSE006
     C                   CALL      'AOSARDR0'                                                  CSE00
     C                   PARM      '*BLANKS'     WRTCD                                         CSE00
     C                   PARM      '*VERIFY'     WOPTN                                         CSE00
     C                   PARM      'CSE006'      WSARD                                         CSE00
      *                                                                   CSE006
     C     WRTCD         IFEQ      *BLANKS                                                     CSE00
     C                   MOVE      'Y'           CSE006            1                           CSE00
     C                   ELSE                                                                  CSE00
     C                   MOVE      'N'           CSE006                                        CSE00
     C                   ENDIF                                                                 CSE00
      *                                                                   CSW200
      * Check if SWIFT 2000 is active                                     CSW200
      *                                                                   CSW200
     C                   CALL      'SWIF2000'                           9090                   CSW20
     C                   PARM      *BLANKS       CSW200            7            B:Return code  CSW20
      *                                                                   CSW200
      *  If return with an error (LR seton in called program) then        CSW200
      *  process for database error.                                      CSW200
      *                                                                   CSW200
     C     *IN90         IFEQ      '1'                                                         CSW20
     C                   Z-ADD     040           DBASE                          ***************CSW20
     C                   MOVEL     'SWIF2000'    DBFILE                         *DB ERROR 040 *CSW20
     C                   MOVE      '*CALL   '    DBKEY                          ***************CSW20
     C                   OUT       LDA                                                         CSW20
     C                   EXSR      *PSSR                                                       CSW20
     C                   END                                                                   CSW20
      *                                                                   CSW200
      *                                                                                       CSW201
      ** Call SWIF2001 to check if CSW201 is switched on.                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                           9090
     C                   PARM      *BLANKS       PRTCD             7
      *                                                                                       CSW201
      ** If return with an error (LR seton in called program) then                            CSW201
      ** process for database error.                                                          CSW201
      *                                                                                       CSW201
     C     *IN90         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     041           DBASE
     C                   MOVEL     'SWIF2001'    DBFILE
     C                   MOVE      '*CALL   '    DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CSW201
     C     PRTCD         IFEQ      'CSW2001'
     C                   MOVE      'Y'           CSW201            1
     C                   ELSE
     C                   MOVE      'N'           CSW201
     C                   ENDIF
      *                                                                                       CSW201
     C                   ENDIF
      *                                                                                       CSW202
      ** Check if CSW202 is installed                                                         CSW202
      *                                                                                       CSW202
     C                   CALL      'SWIF2002'
     C                   PARM      *BLANKS       PRTCD
      *                                                                                       CSW202
     C     PRTCD         IFEQ      'CSW2002'
     C                   MOVE      'Y'           CSW202            1
     C                   ELSE
     C                   MOVE      'N'           CSW202
     C                   ENDIF
      *                                                                                       CSW203
      ** Check if Swift 2003 Standards Update is installed                                    CSW203
      *                                                                                       CSW203
     C                   CALL      'SWIF2003'
     C                   PARM      *BLANKS       PRTCD
      *                                                                                       CSW203
     C     PRTCD         IFEQ      'CSW2003'
     C                   MOVE      'Y'           CSW203            1
     C                   ELSE
     C                   MOVE      'N'           CSW203
     C                   ENDIF
      *                                                                                       CSD015
      ** Access SAR Details file to determine if CSD015 is installed                          CSD015
      *                                                                                       CSD015
     C                   MOVE      'N'           CSD015            1
     C                   MOVEL     'N'           W1EWLC
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD015'      WSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '043'         DBASE
     C                   MOVEL     PRTCD         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSD015
      *                                                                                       222385
      ** Access AOWLCCR0 to check if function code MESSGENT is available                      222385
      *                                                                                       222385
     C                   CALL      'AOWLCCR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        WOPTN
     C                   PARM      'MESSGENT'    PFUNC             8
     C     SDWLCC        PARM      SDWLCC        DSFDY
      *                                                                                       222385
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF'
     C                   MOVEL     'SDWLCCPD'    DBFILE
     C                   MOVEL     PFUNC         DBKEY
     C                   Z-ADD     32            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       222385
     C                   ENDIF
      *                                                                                       CSD015
      ** Access SAR details file to determine if Midas Message Manager                        CSD015
      ** (CSW025) is installed                                                                CSD015
      *                                                                                       CSD015
     C                   MOVE      'N'           CSW025            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSW025'      WSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '044'         DBASE
     C                   MOVEL     PRTCD         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSW025
     C                   ENDIF
      *                                                                                       CSD036
      ** Access SAR details file to determine if second SWIFT BIC                             CSD036
      ** (CSW036) is installed                                                                CSD036
      *                                                                                       CSD036
     C                   MOVE      'N'           CSW036            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSW036'      WSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '045'         DBASE
     C                   MOVEL     PRTCD         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSW036
     C                   ENDIF
      *                                                                                       CSW207
      ** Check if SWIFT Changes 2007 (CSW207) is installed                                    CSW207
      *                                                                                       CSW207
     C                   CALL      'SWIF2007'
     C                   PARM      *BLANKS       PRTCD             7
     C*                                                                                       CSW207
     C     PRTCD         IFEQ      'CSW2007'
     C                   MOVE      'Y'           CSW207            1
     C                   ELSE
     C                   MOVE      'N'           CSW207
     C                   ENDIF
      *                                                                                       CSW208
      ** Check if SWIFT Changes 2008 (CSW208) is installed                                    CSW208
      *                                                                                       CSW208
     C                   CALL      'SWIF2008'
     C                   PARM      *BLANKS       PRTCD
      *                                                                                       CSW208
     C     PRTCD         IFEQ      'CSW2008'
     C                   MOVE      'Y'           CSW208            1
     C                   ELSE
     C                   MOVE      'N'           CSW208
     C                   ENDIF
      *                                                                                       CSW210
      ** Check if SWIFT Changes 2010 (CSW210) is installed.                                   CSW210
      *                                                                                       CSW210
     C                   CALL      'SWIF2010'
     C                   PARM      *BLANKS       PRTCD
      *                                                                                       CSW210
     C     PRTCD         IFEQ      'CSW2010'
     C                   MOVE      'Y'           CSW210            1
     C                   ELSE
     C                   MOVE      'N'           CSW210
     C                   ENDIF
      *                                                                                       CSW214
      ** Check if SWIFT Changes 2014 (CSW214) is installed.                                   CSW214
      *                                                                                       CSW214
     C                   CALL      'SWIF2014'
     C                   PARM      *BLANKS       PRTCD
      *                                                                                       CSW214
     C     PRTCD         IFEQ      'CSW2014'
     C                   MOVE      'Y'           CSW214            1
     C                   ELSE
     C                   MOVE      'N'           CSW214
     C                   ENDIF
      *                                                                                       CSW210
      ** Access Switchable SAR details for the existence of CFT004                            CSW210
      *                                                                                       CSW210
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CFT004'      WSARD
     C     WRTCD         IFNE      *BLANKS
     C     WRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     13            DBASE
     C                   MOVEL     'AOSARDR0'    DBFILE
     C                   MOVE      '*CALL   '    DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C     WRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CFT004            1
     C                   ELSE
     C                   MOVE      'N'           CFT004
     C                   ENDIF
      *
      ** Set up KLIST for SDMTAGL0
      *
     C     KMTAG         KLIST
     C                   KFLD                    MTAG
     C                   KFLD                    KTYP              3
     C                   KFLD                    KSEQ              3
      *
     C     KCRTN         KLIST
     C                   KFLD                    KTDRF             6
      *
      ** Set CRLF control character
      *
     C                   MOVE      *LOVAL        CTRC
     C                   BITON     '457'         WWCR
     C                   BITON     '257'         WWLF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRINTF
      *****************************************************************
      *                                                               *
      *  SRINTF - Initialise non-constant fields                      *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRINTF        BEGSR
      *
      ** Obtain Sequence Numbers from transaction record
      ** format @TRAN as follows:
      **   Chars 01-06 equal to leftmost 6 chars from MGTNUM
      **   Chars 07-13 equal to blanks
      **   Chars 14-15 equal to MGTTYP
      *
     C                   MOVE      *BLANKS       WWTRAN           15
     C                   MOVE      *BLANKS       WWFL06            6
     C                   MOVEL     MGTNUM        WWFL06
     C                   MOVEL     WWFL06        WWTRAN
     C                   MOVE      MGTTYP        WWTRAN
      *
     C                   CALL      'MG5900'                             21
     C                   PARM      MGMODI        @MODI             2
     C                   PARM      WWTRAN        @TRAN            15
     C                   PARM      'CE'          @PROG             2
     C                   PARM      *BLANKS       @MODE             1
     C                   PARM      *ZEROS        @LSWS             7 0
     C                   PARM      *BLANKS       @ERCD             1
     C                   PARM                    CSW003
      *
      ** If program not found, perform DB Error processing
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     0003          DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 003 *
     C                   MOVEL     'MG5900'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If an error occurred in MG5900, perform DB Error processing
      *
     C     @ERCD         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   MOVEL     @TRAN         WW0317
     C                   Z-ADD     004           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 004 *
     C                   MOVEL     DBERR         DBKEY                          * * * * * * * *
     C                   MOVEL     'MG5900'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Obtain Confirmation Generated Indicator format @TREF as follows:
      **   Chars 01-06 equal to leftmost 6 chars from MGTNUM
      **   Chars 07-13 equal to blanks
      **   Chars 14-15 equal to MGTTYP
      *
     C                   MOVE      *BLANKS       WWTREF           15
     C                   MOVE      *BLANKS       WWFL06            6
     C                   MOVEL     MGTNUM        WWFL06
     C                   MOVEL     WWFL06        WWTREF
     C                   MOVE      MGTTYP        WWTREF
      *
     C                   CALL      'MG5910'                             22
     C                   PARM      MGMODI        @MODI             2
     C                   PARM      WWTREF        @TREF            15
     C                   PARM      'CE'          @PROG             2
     C                   PARM      *BLANKS       @MODE             1
     C                   PARM      *BLANKS       @CONG             1
     C                   PARM      *BLANKS       @RCDG             1
     C                   PARM      *BLANKS       @ERCD             1
     C                   PARM                    CSW003
      *
      ** If program not found, perform DB Error processing
      *
     C     *IN22         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     005           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 005 *
     C                   MOVEL     'MG5910'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If an error occured in MG5910, perform DB Error processing
      *
     C     @ERCD         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   MOVEL     @TREF         WW0317
     C                   Z-ADD     006           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 006 *
     C                   MOVEL     DBERR         DBKEY                          * * * * * * * *
     C                   MOVEL     'MG5910'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If @CONG parameter is 'Y', perform DB Error processing
      *
     C     MGTTYP        IFEQ      'TR'
     C     @CONG         ANDEQ     'Y'
     C     *LOCK         IN        LDA
     C                   MOVEL     @TREF         WW0317
     C                   Z-ADD     007           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 007 *
     C                   MOVEL     DBERR         DBKEY                          * * * * * * * *
     C                   MOVEL     'MG5910'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Clear multiple occurence data structure
      *
     C                   Z-ADD     1             X                 2 0
     C     X             OCCUR     MULT
      *
     C     X             DOWLE     500
     C     MULT          ANDNE     *BLANKS
     C                   CLEAR                   MULT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDDO
      *
      ** Access the first occurence in MULT
      *
     C                   Z-ADD     1             X
     C     X             OCCUR     MULT
      *
      ** Set flag for message correctly generated, destination
      ** and network error workfields to blank
      *
     C                   MOVE      *BLANKS       @ERR              1
     C                   MOVE      *BLANKS       DSERR            50
     C                   MOVE      *BLANKS       NWERR            50
      *
      ** Retrieve the SWIFT Ccy Code for the Nominal Currency
      *
     C                   MOVE      *BLANK        WNSWCY            3
     C                   MOVEL     MGNMCY        WCYCD
     C                   EXSR      SRSWCY
     C                   MOVEL     A6SWCY        WNSWCY
      *
      ** Retrieve the SWIFT Ccy Code of the Settlement Ccy
      *
     C                   MOVE      *BLANK        WSSWCY            3
     C                   MOVEL     MGSTCY        WCYCD
     C                   EXSR      SRSWCY
     C                   MOVEL     A6SWCY        WSSWCY
      *
      ** Retrieve the SWIFT Ccy Code of the Original Ccy
      *
     C     MGOTRC        IFNE      *BLANKS
     C                   MOVE      *BLANK        WOSWCY            3
     C                   MOVEL     MGOTRC        WCYCD
     C                   EXSR      SRSWCY
     C                   MOVEL     A6SWCY        WOSWCY
     C                   ENDIF
      *
      ** Set up indicator to suppress fields on condition:
      **     1) CSW003 is off
      **     2) Transaction is from Depot Movement
      ** This is because information is not available with the feature
      ** off.
      *
     C     CSW003        IFNE      'Y'
     C     MGTTYP        ANDNE     'TR'
     C                   MOVE      'Y'           WSUPP             1
     C                   ELSE
     C                   MOVE      'N'           WSUPP
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRROUT
      *****************************************************************
      *                                                               *
      *  SRROUT - Determine message routing                           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRROUT        BEGSR
      *
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG   '     WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      MGSNBR        WBRCH             3
     C********** SDBRCH    PARM SDBRCH    DSFDY                                               CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      ** Database Error in SDBRCHPD
      *
     C     WRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     008           DBASE                          ***************
     C                   MOVEL     'SDBRCHPD'    DBFILE                         *DB ERROR 008 *
     C                   MOVEL     WBRCH         DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Determine the Network Routing and Addresses
      *
     C                   MOVE      A8BICN        @SNDR             6
     C                   MOVE      A8BTID        @SCSD            12
     C                   MOVE      MGDEST        @DEST             6
     C                   MOVEL     MGSETP        @SETP             2
     C                   MOVE      *BLANKS       @NWSN            20
     C                   MOVE      *BLANKS       @NWDS            22
     C                   MOVE      *BLANKS       @NWRK             6
     C                   MOVE      *BLANKS       @ERRC             1
     C                   MOVE      *BLANKS       @SRNM            20
     C                   MOVE      *BLANKS       @SRTN            10
     C                   MOVE      *BLANKS       @DRNM            20
     C                   MOVE      *BLANKS       @DRTN            10
      *
     C*********************CALL 'ZM1100'               23                                     CSW036
     C                   CALL      'ZM1101'                             23
     C                   PARM                    @SNDR
     C                   PARM                    @SCSD
     C                   PARM                    @DEST
     C                   PARM                    @SETP
     C                   PARM                    @NWSN
     C                   PARM                    @NWDS
     C                   PARM                    @NWRK
     C                   PARM                    @ERRC
     C                   PARM                    @SRNM
     C                   PARM                    @SRTN
     C                   PARM                    @DRNM
     C                   PARM                    @DRTN
      *
      ** If program not found, perform DB Error processing
      *
     C     *IN23         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     009           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 009 *
     C*********************MOVEL'ZM1100'  DBPGM            * * * * * * * *                    CSW036
     C                   MOVEL     'ZM1101'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If an error occured in ZM1100, perform DB Error processing
      *
     C     @ERRC         IFEQ      'S'
     C     *LOCK         IN        LDA
     C                   Z-ADD     010           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 010 *
     C                   MOVEL     DBERR1        DBKEY                          * * * * * * * *
     C*********************MOVEL'ZM1100'  DBPGM                                               CSW036
     C                   MOVEL     'ZM1101'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Format Destination Error Message
      *
     C     @ERRC         IFEQ      'D'
     C                   MOVE      *BLANKS       DSERR            50
     C                   MOVEL     ERRA(1)       DSERR
     C                   MOVE      'Y'           @ERR
     C                   ENDIF
      *
      ** Format Network Error Message
      *
     C     @NWRK         IFEQ      'UNROUT'
     C                   MOVEL     ERRA(2)       NWERR
     C                   MOVE      'Y'           @ERR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRFMT
      *****************************************************************
      *                                                               *
      *  SRFMT  - Format MT515 or MT518 message fields                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRFMT         BEGSR
      *
      ** Format Sequence A fields - General Information
      *
     C                   EXSR      SRGENL
      *
      ** Format Confirmation Details for MT515 Seq C or MT518 Seq B
      *
     C                   EXSR      SRCDET
      *
      ** Format Settlement Details for MT515 Seq D or MT518 Seq C
      *
     C                   EXSR      SRSDET
      *                                                                   CSE006
      *** If there is an associated deal number then process additional   CSE006
      *** REPO block.                                                     CSE006
      *                                                                   CSE006
     C     CSE006        IFEQ      'Y'                                                         CSE00
     C     MGARF         ANDNE     *BLANKS                                                     CSE00
     C                   EXSR      SRRDET                                                      CSE00
     C                   ENDIF                                                                 CSE00
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRGENL
      *****************************************************************
      *                                                               *
      *  SRGENL - Format MT515 and MT518 Sequence A - General Info.   *
      *                                                               *
      *  Called By: SR/SRFMT                                          *
      *  Calls    : SR/SRLINK                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRGENL        BEGSR
      *
      ** Set up Message Sequence workfield
      *
     C                   MOVEL     'A  '         WSEQ              3
      *
      ** Format field :16R: - Start of Block
      *
     C                   MOVEL     ':16R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'GENL'        MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format field :20C: - Sender's Reference
      *
     C                   MOVEL     ':20C:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':SEME//'     MDAT
      *
     C                   MOVE      *BLANKS       WWMDAT           16
      *
     C     MGMODI        IFEQ      'SE'
      *
     C                   SELECT
     C     MGTTYP        WHENEQ    'TR'
     C                   MOVEL     'SET'         WWMDAT
     C     MGTTYP        WHENEQ    'DM'
     C                   MOVEL     'SED'         WWMDAT
     C     MGTTYP        WHENEQ    'DN'
     C                   MOVEL     'SEE'         WWMDAT
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       REPOFLAG          1                        MD061161
     C     CSE006        IFEQ      'Y'                                                      MD061161
     C     MGARF         ANDNE     *BLANKS                                                  MD061161
     C                   MOVE      'Y'           REPOFLAG                                   MD061161
     C                   ENDIF                                                              MD061161
      *                                                                                     MD061161
     C     REPOFLAG      IFEQ      'Y'                                                      MD061161
     C     WWMDAT        CAT       MGARF:0       WWMDAT                                     MD061161
     C                   ELSE                                                               MD061161
     C     WWMDAT        CAT       MGTNUM:0      WWMDAT
     C                   ENDIF                                                              MD061161
      *
     C     @LSWS         IFEQ      9999999
     C                   Z-ADD     1             WWLSWS            7 0
     C                   ELSE
     C     @LSWS         ADD       1             WWLSWS
     C                   ENDIF
      *
     C                   MOVEL     WWLSWS        WALSWS            7
      *
     C     WWMDAT        CAT       WALSWS:0      WWMDAT
      *                                                                                     MD061161
     C     REPOFLAG      IFEQ      'Y'                                                      MD061161
     C                   MOVE      *BLANKS       MGOKEY                                     MD061161
     C                   MOVEL     WWMDAT        MGOKEY                                     MD061161
      *                                                                                     MD061161
     C     MGOKEY        CHAIN(N)  MGOREFL1                           70                    MD061161
     C     *IN70         DOWEQ     *OFF                                                     MD061161
     C                   ADD       1             SEQNUM                                     MD061161
     C     MGOKEY        READE(N)  MGOREFL1                               70                MD061161
     C                   ENDDO                                                              MD061161
      *                                                                                     MD061161
     C                   MOVE      *BLANKS       WWMDAT                                     MD061161
     C                   MOVEL     MGOKEY        WWMDAT                                     MD061161
     C                   ENDIF                                                              MD061161
      *                                                                                     MD061161
     C     MDAT          CAT       WWMDAT:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format field :23G: - Function of the Message
      *
     C                   MOVEL     ':23G:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'NEWM'        MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format field :22F: - Trade Transaction Type Indicator
      *
     C                   MOVEL     ':22F:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':TRTR//'     MDAT
     C     MDAT          CAT       'TRAD':0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** If Message Type is '515', format Subsequence A1 - Linkages
      *
     C     MGMTYP        IFEQ      '515'
     C                   MOVEL     'A1 '         WSEQ
     C                   EXSR      SRLINK
     C                   MOVEL     'A  '         WSEQ
     C                   ENDIF
      *
      ** Format field :16S: - End of Block
      *
     C                   MOVEL     ':16S:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'GENL'        MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRLINK
      *****************************************************************
      *                                                               *
      *  SRLINK - Format MT515 Subsequence A1 - Linkages              *
      *                                                               *
      *  Called By: SRGENL                                            *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRLINK        BEGSR
      *
      ** Format field :16R: - Start of Block
      *
     C                   MOVEL     ':16R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'LINK'        MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format field :20C: - Sender's Reference
      *
     C                   MOVEL     ':20C:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':RELA//'     MDAT
     C     MDAT          CAT       'NONREF':0    MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format field :16S: - End of Block
      *
     C                   MOVEL     ':16S:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'LINK'        MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRCDET
      *****************************************************************
      *                                                               *
      *  SRCDET - Format Confirmation Details for MT515 Sequence C or *
      *           MF518 Sequence B                                    *
      *                                                               *
      *  Called By: SR/SRFMT                                          *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRCDET        BEGSR
      *
      ** Set up Message Sequence workfield
      *
     C     MGMTYP        IFEQ      '515'
     C                   MOVEL     'C  '         WSEQ
     C                   ELSE
     C                   MOVEL     'B  '         WSEQ
     C                   ENDIF
      *
      ** Save the content WSEQ workfield
      *
     C                   MOVE      WSEQ          SV@SEQ            3
      *
      ** Format field :16R: - Start of Block
      *
     C                   MOVEL     ':16R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'CONFDET'     MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ***Format*field*:98A:*or*:98C:*-*Trade*Date                                             CSW208
      ** Format field :98A:, :98C: or :98E: - Trade Date                                      CSW208
      *
     C                   EXSR      SRMFID
      *                                                                                       CSW208
      ** Retrieve trade time from MiFID Database                                              CSW208
      *                                                                                       CSW208
     C                   MOVEL     ':TRAD//'     MDAT
      *
      ** Convert Trade Date to CCYYMMDD (ZSDATC) format
      *
     C                   Z-ADD     MGTDAT        ZMDAY
     C                   CALL      'ZM0065'
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZSDATE            6
     C                   PARM                    ZSDATC            8
      *
      ***Append*the*formatted*date*to*MULT/MDAT                                               CSW208
      *
     C********** MDAT      CAT  ZSDATC:0  MDAT                                                CSW208
      *
      ** If Trade Time is blanks, format field :98A:
      *
     C                   MOVEL     MGTRTT        W#TRTT            4
     C********** MGTRTT    IFEQ *BLANKS                                                       CSW208
     C     W#TRTT        IFEQ      *BLANKS
      *
     C                   MOVEL     ':98A:'       MTAG
      *                                                                                       CSW208
      ** Append the formatted date to MULT/MDAT                                               CSW208
      *                                                                                       CSW208
     C     MDAT          CAT       ZSDATC:0      MDAT
      *
     C                   ELSE
      *                                                                                       CSW208
     C                   MOVE      ZSDATC        WSDATE            8
     C                   MOVE      MGTRTT        WSTIME            6
     C                   MOVE      *BLANKS       PMRKT
      *                                                                                       CSW208
      ** If SWIFT 2008 is switched on, convert system date/time to                            CSW208
      ** market date/time                                                                     CSW208
      *                                                                                       CSW208
     C     CSW208        IFEQ      'Y'
     C                   MOVEL     MGTNUM        WKTNUM            6
      *                                                                                       CSW208
     C     MGTTYP        IFEQ      'TR'
     C     WKTNUM        CHAIN     TRADS                              55
     C     *IN55         IFEQ      *OFF
     C                   MOVEL     TMKC          PMRKT
     C                   ENDIF
      *                                                                                       CSW208
     C                   ELSE
     C     WKTNUM        CHAIN     DPTMVDL1                           58
     C     *IN55         IFEQ      *OFF
     C                   MOVEL     MRKT          PMRKT
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW208
     C     PMRKT         IFNE      *BLANKS
     C                   MOVE      MGTRTT        PFRTM
     C                   MOVE      MGTDAT        PFRDT
     C                   CALL      'ZADTMCVT'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      'S'           PFRTZ             1
     C                   PARM                    PFRTM
     C                   PARM                    PFRDT             5 0
     C                   PARM      'SE'          PMODU             2
     C                   PARM      MGSNBR        PBRCA             3
     C                   PARM                    PMRKT             2
     C                   PARM      *BLANKS       PSESN            10
     C                   PARM      *BLANKS       PMICC             4
     C                   PARM      *ZEROS        PMKTM
     C                   PARM      *ZEROS        PMKDT             5 0
     C                   PARM      *ZEROS        PMKTOF
     C                   PARM      *BLANKS       PMKTOS            1
     C                   PARM      *ZEROS        PLCTM
     C                   PARM      *ZEROS        PLCDT             5 0
     C                   PARM      *ZEROS        PLCTOF
     C                   PARM      *BLANKS       PLCTOS            1
     C                   PARM      *ZEROS        PSYTM
     C                   PARM      *ZEROS        PSYDT             5 0
     C                   PARM      *ZEROS        PSYTOF
     C                   PARM      *BLANKS       PSYTOS            1
      *                                                                                       CSW208
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      PMKTM         WSTIME
     C                   Z-ADD     PMKDT         ZMDAY
     C                   CALL      'ZM0065'
     C                   PARM                    ZMDAY
     C                   PARM                    ZSDATE
     C                   PARM                    ZSDATC
     C                   MOVE      ZSDATC        WSDATE
     C                   ENDIF
      *                                                                                       CSW208
     C                   ELSE
      *                                                                                     BUG19304
      ** Get local time and offset here                                                     BUG19304
      *                                                                                     BUG19304
     C                   EXSR      SRLCTM
     C                   ENDIF
      *                                                                                       CSW208
     C                   ENDIF
      *                                                                                       CSW208
     C     MDAT          CAT       WSDATE:0      MDAT
     C     MDAT          CAT       WSTIME:0      MDAT
      *
      ** Otherwise, format field :98C:
      *
     C                   MOVEL     ':98C:'       MTAG
     C********** MDAT      CAT  MGTRTT:0  MDAT                                              BUG20437
      *                                                                                       CSW207
     C********** CSW207    IFEQ 'Y'                                                    CSW207 CSW208
     C**********           EXSR SRMFID                                                 CSW207 CSW208
     C********** WMFID     IFEQ 'Y'                                                    CSW207 CSW208
      *                                                                                       CSW208
      ** If SWIFT 2007 or SWIFT 2008 is installed and Branch and                              CSW208
      ** Recieving customer are MiFID compliant                                               CSW208
     C     CSW207        IFEQ      'Y'
     C     CSW208        OREQ      'Y'
      *                                                                                       CSW208
     C     WMFID         IFEQ      'Y'
     C                   MOVEL     ':98E:'       MTAG
     C                   MOVE      *BLANKS       WTMOF
     C                   MOVE      *BLANKS       WOSIGN
      *                                                                                       CSW207
      ** Format UTC if MiFID is 'Y'                                                           CSW207
      *                                                                                       CSW207
     C     CSW208        IFEQ      'Y'
     C********** PMKTOF    IFNE *ZEROS                                               CSW208 BUG19304
     C     PMRKT         IFNE      *BLANKS
     C                   MOVEL     PMKTOF        WTMOF
     C                   MOVE      PMKTOS        WOSIGN
     C                   ELSE
     C                   MOVEL     WBROF         WTMOF
     C                   MOVE      WBRSG         WOSIGN
     C                   ENDIF
     C**********           ENDIF                                                     CSW208 BUG19304
      *                                                                                       CSW208
     C                   ELSE
     C     A8TMOF        IFNE      *ZEROS
     C                   MOVEL     A8TMOF        WTMOF             4
     C                   MOVE      A8SIGN        WOSIGN            1
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW208
     C********** A8SIGN    IFEQ '-'                                                    CSW207 CSW208
     C     WTMOF         IFNE      *BLANKS
     C     WOSIGN        IFEQ      '-'
     C     'N'           CAT       WTMOF         WUTC
     C**********           ENDIF                                                       CSW207 CSW208
     C********** A8SIGN    IFEQ '+'                                                    CSW207 CSW208
     C                   ELSE
     C                   MOVEL     WTMOF         WUTC
     C                   ENDIF
      *                                                                                       CSW207
     C     '/'           CAT       WUTC          WMDATE            6
     C     MDAT          CAT       WMDATE:0      MDAT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format another :98A: - for Value Date
      *
     C                   MOVEL     ':98A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
      ** Convert Value Date to CCYYMMDD (ZSDATC) format
      *
     C                   Z-ADD     MGVDAT        ZMDAY
     C                   CALL      'ZM0065'
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZSDATE            6
     C                   PARM                    ZSDATC            8
      *
     C                   MOVEL     ':SETT//'     MDAT
     C     MDAT          CAT       ZSDATC:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Save ZSDATE for later file (PF/MGOREFPD) update
      *
     C                   MOVEL     ZSDATE        WWDATE            6
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format :90a: - Deal Price; where 'a' can be A or B depending
      **                            on the value of MGSPBS (Price Basis)
      *
     C     MGSPBS        IFEQ      'U'
     C     MGSPBS        OREQ      'P'
      *
     C                   MOVEL     ':DEAL//'     MDAT
      *
      ** Convert Price amount to SWIFT format
      *
     C                   Z-ADD     MGPRIC        ZPRIC            15 8
     C                   MOVE      *BLANKS       ZSPRIC           16
     C                   MOVE      *BLANKS       ZOPRIC           21
      *
     C                   CALL      'ZM1190'                             24
     C                   PARM                    ZPRIC
     C                   PARM                    ZSPRIC
     C                   PARM                    ZOPRIC
      *
      ** If program not found, perform DB Error processing
      *
     C     *IN24         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     012           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 012 *
     C                   MOVEL     'ZM1190'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   SELECT
      *
     C     MGSPBS        WHENEQ    'U'
      *
      ** Retrieve the SWIFT currency code of the Nominal Currency
      *
     C                   MOVEL     MGNMCY        WCYCD             3
     C                   EXSR      SRSWCY
      *
     C                   MOVEL     ':90B:'       MTAG
     C     MDAT          CAT       'ACTU/':0     MDAT
     C     MDAT          CAT       A6SWCY:0      MDAT
     C     MDAT          CAT       ZSPRIC:0      MDAT
      *
     C     MGSPBS        WHENEQ    'P'
      *
     C                   MOVEL     ':90A:'       MTAG
     C     MGSTBS        IFEQ      'P'
     C     MDAT          CAT       'PRCT/':0     MDAT
     C                   ELSE
     C     MGSTBS        IFEQ      'D'
     C     MDAT          CAT       'DISC/':0     MDAT
     C                   ELSE
     C     MGSTBS        IFEQ      'Y'
     C     MDAT          CAT       'YIEL/':0     MDAT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     MDAT          CAT       ZSPRIC:0      MDAT
      *
     C                   OTHER
      *
     C                   MOVEL     ':90a:'       MTAG
     C                   MOVEL     ERRA(3)       MERR
     C                   MOVEL     'Y'           @ERR
      *
     C                   ENDSL
      *
     C                   MOVEL     MDAT          RDAT
      *
      ** Access tag description
      *
     C     MGSPBS        IFEQ      'U'
     C     MGSPBS        OREQ      'P'
     C                   EXSR      SRMTAG
     C                   ENDIF
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format :99A: - Number of Days Accrued
      *
     C     MGCPNR        IFNE      *ZERO
     C     MGPROT        ANDNE     '6'
     C     WSUPP         ANDNE     'Y'
      *
     C                   MOVEL     ':99A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
      ** Move MGACND to alphanumeric
      *
     C                   MOVEL     MGACND        WACND             3
      *
     C                   MOVEL     ':DAAC//'     MDAT
     C     MDAT          CAT       WACND:0       MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *                                                                                       CSW203
      ** Format :94B:                                                                         CSW203
      *                                                                                       CSW203
     C     CSW203        IFEQ      'Y'
      *                                                                                       CSW203
     C                   MOVEL     MGTNUM        WKTNUM
      *                                                                                       CSW203
     C     WKTNUM        CHAIN     TRADS                              48
      *                                                                                       CSW203
     C     TMKC          IFNE      *BLANKS
      *                                                                                       CSW203
     C                   MOVEL     ':94B:'       MTAG
      *                                                                                       CSW203
      ** Access tag description                                                               CSW203
      *                                                                                       CSW203
     C                   EXSR      SRMTAG
      *                                                                                       CSW214
     C     CSW214        IFEQ      'Y'
     C                   MOVEL     ':TRAD//'     MDAT
     C     'EXCH/'       CAT       TMKC:0        WKMDAT
     C                   CAT       WKMDAT:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *                                                                                       CSW214
     C                   ELSE
      *                                                                                       CSW203
      ** Check if Market Centre exists                                                        CSW203
      *                                                                                       CSW203
     C     TMKC          CHAIN     SEMKC                              45
      *                                                                                       CSW203
     C     *IN45         IFEQ      *ON
     C                   MOVE      'Y'           @ERR
     C                   MOVEL     ERRA(12)      MERR
     C                   ELSE
     C                   MOVEL     ':TRAD//'     MDAT
     C     'EXCH/'       CAT       MKTN:0        WKMDAT           25
     C                   CAT       WKMDAT:0      MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ENDIF
      *                                                                                       CSW214
     C                   ENDIF
      *                                                                                       CSW203
      ** Access the next occurence in MULT                                                    CSW203
      *                                                                                       CSW203
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *                                                                                       CSW203
     C                   ENDIF
      *                                                                                       CSW203
     C                   EXSR      SRF94F
     C                   ENDIF
      *
      ** Format :22H: - Indicator
      *
     C                   MOVEL     ':22H:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':BUSE//'     MDAT
      *
     C     MGMTYP        IFEQ      '518'
      *
      ** If from TRADES file
      *
     C     MGTTYP        IFEQ      'TR'
     C     MGTSTP        IFEQ      'TP'
     C     MDAT          CAT       'BUYI':0      MDAT
     C                   ELSE
     C     MDAT          CAT       'SELL':0      MDAT
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If from Depot Movements file
      *
     C     MGTTYP        IFEQ      'DM'
     C     MGTSTP        ANDEQ     'RP'
     C     MGTTYP        OREQ      'DM'
     C     MGTSTP        ANDEQ     'PD'
      *
     C     MGTTYP        OREQ      'DN'
     C     MGTSTP        ANDEQ     'RR'
     C     MGTTYP        OREQ      'DN'
     C     MGTSTP        ANDEQ     'PL'
     C     MDAT          CAT       'SELL':0      MDAT
     C                   ELSE
     C     MDAT          CAT       'BUYI':0      MDAT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     MGTSTP        IFEQ      'TP'
     C     MDAT          CAT       'SELL':0      MDAT
     C                   ELSE
     C     MDAT          CAT       'BUYI':0      MDAT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format :22A: - Indicator                                         CSW200
      *                                                                   CSW200
     C     CSW200        IFEQ      'CSW200'                                                    CSW20
     C                   MOVEL     ':TTCO//'     WFLD07                                        CSW20
     C     MGPCOD        IFEQ      '5'                                                         CSW20
     C                   MOVEL     'GTDL'        WFLD08                                        CSW20
     C                   MOVEL     ':22F:'       MTAG                                          CSW20
      *                                                                   CSW200
      ** Access tag description                                           CSW200
      *                                                                   CSW200
     C                   EXSR      SRMTAG                                                      CSW20
      *                                                                   CSW200
     C                   MOVEL     WFLD07        MDAT                                          CSW20
     C     MDAT          CAT       WFLD08:0      MDAT                                          CSW20
     C                   MOVEL     MDAT          RDAT                                          CSW20
      *                                                                   CSW200
      ** Access the next occurence in MULT                                CSW200
      *                                                                   CSW200
     C                   ADD       1             X                                             CSW20
     C     X             OCCUR     MULT                                                        CSW20
      *                                                                   CSW200
     C                   ENDIF                                                                 CSW20
     C                   ENDIF                                                                 CSW20
      *                                                                   CSW200
     C     MGPROT        IFEQ      '4'
     C     MGPROT        OREQ      '7'
      *
     C     MGEXIN        IFEQ      'C'
      *
      *
     C                   MOVEL     ':22F:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':TTCO//'     MDAT
     C     MDAT          CAT       'CDIV':0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ELSE
      *
     C     MGEXIN        IFEQ      'X'
      *
     C                   MOVEL     ':22F:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':TTCO//'     MDAT
     C     MDAT          CAT       'XDIV':0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     MGPROT        IFEQ      '1'
     C     MGPROT        OREQ      '3'
     C     MGPROT        OREQ      '5'
     C     MGPROT        OREQ      '6'
     C     MGPROT        OREQ      '8'
      *
     C     MGACND        IFNE      *ZERO
      *
     C     MGEXIN        IFEQ      'C'
      *
     C                   MOVEL     ':22F:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
      *
     C                   MOVEL     ':TTCO//'     MDAT
     C     MDAT          CAT       'CCPN':0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ELSE
      *
     C     MGEXIN        IFEQ      'X'
      *
     C                   MOVEL     ':22F:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':TTCO//'     MDAT
     C     MDAT          CAT       'XCPN':0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     MGPCOD        IFEQ      '2'
     C     MGPCOD        OREQ      '3'
     C     MGPCOD        OREQ      '4'
      *
     C                   MOVEL     ':22H:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':PAYM//'     MDAT
     C     MDAT          CAT       'FREE':0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ELSE
      *
     C                   MOVEL     ':22H:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':PAYM//'     MDAT
     C     MDAT          CAT       'APMT':0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
      ** Format MT515 Subseq C1 or MT518 Subseq B1 - Conf Parties
      *
     C                   EXSR      SRCPTY
      *
      ** Restore the old value WSEQ
      *
     C                   MOVE      SV@SEQ        WSEQ
      *
      ** Format :36B: - Quantity of Financial Instrument
      *
     C                   MOVEL     ':36B:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C     MGQANT        IFEQ      *ZERO
      *
     C                   MOVEL     ERRA(5)       MERR
     C                   MOVEL     'Y'           @ERR
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ELSE
      *
      ** Convert Quantity of Securities to SWIFT format
      *
     C                   Z-ADD     MGQANT        ZAMNT            15 0
     C                   Z-ADD     MGNMDP        ZCDP              1 0
     C                   MOVE      *BLANKS       ZSAMNT           17
     C                   MOVE      *BLANKS       ZOAMNT           21
      *
     C                   CALL      'ZM1140'                             27
     C                   PARM                    ZAMNT
     C                   PARM                    ZCDP
     C                   PARM                    ZSAMNT
     C                   PARM                    ZOAMNT
      *
      ** If program not found, perform DB Error processing
      *
     C     *IN27         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     014           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 014 *
     C                   MOVEL     'ZM1140'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     ':CONF//'     MDAT
      *
     C     MGPROT        IFEQ      '2'
     C     MGPROT        OREQ      '4'
     C     MGPROT        OREQ      '7'
     C     MDAT          CAT       'UNIT/':0     MDAT
     C                   ELSE
     C     MDAT          CAT       'FAMT/':0     MDAT
     C                   ENDIF
      *
     C     MDAT          CAT       ZSAMNT:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
      ** Format :35B: - Identification of Financial Instrument
      *
     C                   MOVEL     ':35B:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
      ** ISIN/Common Code
      *
     C     MGISIN        IFNE      *BLANKS
     C                   MOVEL     'ISIN'        MDAT
     C     MDAT          CAT       MGISIN:1      MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *
      ** Security Full Name - 1
     C                   MOVEL     MGSFN1        MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Security Full Name - 2
      *
     C     MGSFN2        IFNE      *BLANKS
      *
     C                   MOVEL     MGSFN2        MDAT
     C                   MOVEL     WSEQ          MSEQ
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
      ** Format MT515 Subsequence C2 or MT518 Subsequence B2
      ** (Financial Instrument Attributes)
      *
     C                   EXSR      SRFFIA
      *
      ** Restore the old value WSEQ
      *
     C                   MOVE      SV@SEQ        WSEQ
      *
      ** If Certificate Number is required,
      *
     C     MGCRTN        IFEQ      'Y'
     C                   EXSR      SRCRTN
     C                   ENDIF
      *
      ** Format :16S: - End of Block
      *
      *
     C                   MOVEL     ':16S:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'CONFDET'     MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRCPTY
      *****************************************************************
      *                                                               *
      *  SRCPTY - Format MT515 Subsequence C1 or MT518 Subsequence B1 *
      *           Confirmation Parties                                *
      *                                                               *
      *  Called By: SR/SRCDET                                         *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRCPTY        BEGSR
      *
      ** Set up Message Sequence workfield
      *
     C     MGMTYP        IFEQ      '515'
     C                   MOVEL     'C1 '         WSEQ
     C                   ELSE
     C                   MOVEL     'B1 '         WSEQ
     C                   ENDIF
      *
      ** Format field :16R: - Start of Block
      *
     C                   MOVEL     ':16R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'CONFPRTY'    MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format :95a: - Party
      *
     C     MGTTYP        IFEQ      'TR'
      *
     C     MGTSTP        IFEQ      'TP'
     C                   MOVEL     ':SELL//'     WMDAT
     C                   ELSE
     C                   MOVEL     ':BUYR//'     WMDAT
     C                   ENDIF
      *
     C                   ELSE
      *
     C     MGTTYP        IFEQ      'DM'
     C     MGTSTP        ANDEQ     'RP'
     C     MGTTYP        OREQ      'DM'
     C     MGTSTP        ANDEQ     'PD'
      *
     C     MGTTYP        OREQ      'DN'
     C     MGTSTP        ANDEQ     'RR'
     C     MGTTYP        OREQ      'DN'
     C     MGTSTP        ANDEQ     'PL'
     C                   MOVEL     ':BUYR//'     WMDAT
     C                   ELSE
     C                   MOVEL     ':SELL//'     WMDAT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVEL     MGDEST        ZDEST            12
     C                   EXSR      SRF95
      *
      ** Format :97A: - Cash Account
      *
     C     MGMTYP        IFEQ      '515'
      *
     C     MGSA1L        IFNE      *BLANKS
      *
      *
     C                   MOVEL     ':97A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':SAFE//'     MDAT
     C     MDAT          CAT       MGSA1L:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      **********                                                                     CSW207 BUG18526
      ***Check*if CSW207 is installed                                                CSW207 BUG18526
      **********                                                                     CSW207 BUG18526
     C********** CSW207    IFEQ 'Y'                                                  CSW207 BUG18526
     C**********           EXSR SRN22F                                               CSW207 BUG18526
     C**********           ENDIF                                                     CSW207 BUG18526
      *
     C     MGAP1L        IFNE      *BLANKS
      *
      *
     C                   MOVEL     ':97A:'       MTAG
      *                                                                                       CSW210
      ** Check if Account for Payment Line 1 IBAN Flag= 'Y'                                   CSW210
      *                                                                                       CSW210
     C     CSW210        IFEQ      'Y'
     C     CFT004        ANDEQ     'Y'
     C     MGFAP1        ANDEQ     'Y'
     C                   MOVEL     ':97E:'       MTAG
     C                   ENDIF
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':CASH//'     MDAT
     C     MDAT          CAT       MGAP1L:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                     BUG18526
      ** Check if CSW207 is installed                                                       BUG18526
      *                                                                                     BUG18526
     C     CSW207        IFEQ      'Y'
     C     WMFID         ANDEQ     'Y'
     C                   EXSR      SRN22F
     C                   ENDIF
      *
      ** Format :16S: - End of Block
      *
     C                   MOVEL     ':16S:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'CONFPRTY'    MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** If MGINVE is not ZERO , output another Subsequence B1
      *
     C********** MGINVE    IFNE *ZERO                                                         CSD027
     C     MGINVE        IFNE      *BLANKS
      *
      ** Format :16R: - Start of Block
      *
     C                   MOVEL     ':16R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'CONFPRTY'    MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format :95a: - Party
      *
     C                   MOVEL     ':INVE//'     WMDAT
     C                   MOVEL     MGINVE        ZDEST            12
      *
     C                   EXSR      SRF95
      *
      ** Format :16S: - End of Block
      *
     C                   MOVEL     ':16S:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'CONFPRTY'    MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRFFIA
      *****************************************************************
      *                                                               *
      *  SRFFIA - Format MT515 Subsequence C2 or MT518 Subsequence B2 *
      *           (Financial Instrument Attributes)                   *
      *                                                               *
      *  Called By: SR/SRCDET                                         *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRFFIA        BEGSR
      *
      ** Set up Message Sequence workfield
      *
     C     MGMTYP        IFEQ      '515'
     C                   MOVEL     'C2 '         WSEQ
     C                   ELSE
     C                   MOVEL     'B2 '         WSEQ
     C                   ENDIF
      *
      ** Format :16R: - Start of Block
      *
     C                   MOVEL     ':16R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'FIA'         MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format :22F: - Method of Interest Computation
      *
     C     MGCPNR        IFNE      *ZERO
      *
     C                   MOVEL     ':22F:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':MICO//'     MDAT
      *
     C                   SELECT
      *
     C     MGDYBS        WHENEQ    '5'
     C     MGDVBS        ANDEQ     '1'
     C     MDAT          CAT       'A001':0      MDAT
      *
     C     MGDYBS        WHENEQ    '1'
     C     MGDVBS        ANDEQ     '2'
     C     MDAT          CAT       'A002':0      MDAT
      *
     C     MGDYBS        WHENEQ    '5'
     C     MGDVBS        ANDEQ     '3'
     C     MDAT          CAT       'A003':0      MDAT
      *
     C     MGDYBS        WHENEQ    '2'
     C     MGDYBS        OREQ      '3'
      *
     C     MGDVBS        IFEQ      '1'
     C     MDAT          CAT       'A004':0      MDAT
     C                   ELSE
     C     MGDVBS        IFEQ      '2'
     C     MDAT          CAT       'A005':0      MDAT
     C                   ELSE
     C     MGDVBS        IFEQ      '3'
     C     MDAT          CAT       'A006':0      MDAT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     MGDYBS        WHENEQ    '1'
     C     MGDVBS        ANDEQ     '1'
     C     MDAT          CAT       'A007':0      MDAT
      *
     C                   ENDSL
      *
     C     1             SUBST     MDAT:8        WK1               1
     C     WK1           IFEQ      *BLANK
     C     MGDYBS        ANDNE     *BLANK
     C     MGDVBS        ANDNE     *BLANK
     C     MDAT          CAT       'OTHR':0      MDAT
     C                   ENDIF
      *                                                                                       248680
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
     C     MGPFRE        IFNE      *BLANKS
      *
     C                   MOVEL     ':22F:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':PFRE//'     MDAT
     C     MDAT          CAT       MGPFRE:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
     C     MGPRTP        IFEQ      'Y'
      *
     C                   MOVEL     ':22F:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':PAYS//'     MDAT
     C     MDAT          CAT       'PART':0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
      ** Format :11A: - Currency of Denomination
      *
     C                   MOVEL     ':11A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':DENO//'     MDAT
     C     MDAT          CAT       WNSWCY:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format :98A: - Date
      *
     C     MGCPNR        IFNE      *ZERO
     C     MGNCDT        ANDNE     *ZERO
      *
     C                   MOVEL     ':98A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
      ** Convert Next Coupon Date CCYYMMDD format
      *
     C                   Z-ADD     MGNCDT        ZMDAY
     C                   CALL      'ZM0065'
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZSDATE            6
     C                   PARM                    ZSDATC            8
      *
     C                   MOVEL     ':COUP//'     MDAT
     C     MDAT          CAT       ZSDATC:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
     C     MGPROT        IFEQ      '3'
     C     MGNRDT        ANDNE     *ZERO
      *
     C                   MOVEL     ':98A:'       MTAG
      *
      ** Convert Next Rate Change Date CCYYMMDD format
      *
     C                   Z-ADD     MGNRDT        ZMDAY
     C                   CALL      'ZM0065'
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZSDATE            6
     C                   PARM                    ZSDATC            8
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':FRNR//'     MDAT
     C     MDAT          CAT       ZSDATC:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
     C     MGMDAT        IFNE      *ZERO
      *
     C                   MOVEL     ':98A:'       MTAG
      *
      ** Convert Maturity Date CCYYMMDD format
      *
     C                   Z-ADD     MGMDAT        ZMDAY
     C                   CALL      'ZM0065'
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZSDATE            6
     C                   PARM                    ZSDATC            8
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
      *
     C                   MOVEL     ':MATU//'     MDAT
     C     MDAT          CAT       ZSDATC:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
      ** Format :92A: - Rate
      *
     C     MGCUFC        IFNE      *ZERO
     C     MGPROT        ANDEQ     '8'
      *
     C                   MOVEL     ':92A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
      ** Convert Current Factor to SWIFT format
      *
     C                   Z-ADD     MGCUFC        ZPRIC
     C                   MOVE      *BLANKS       ZSPRIC
     C                   MOVE      *BLANKS       ZOPRIC
     C*
     C                   CALL      'ZM1190'                             24
     C                   PARM                    ZPRIC
     C                   PARM                    ZSPRIC
     C                   PARM                    ZOPRIC
      *
      ** If program not found, perform DB Error processing
      *
     C     *IN24         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     017           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 017 *
     C                   MOVEL     'ZM1190'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     ':CUFC//'     MDAT
     C     MDAT          CAT       ZSPRIC:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
     C     MGCPNR        IFNE      *ZERO
     C                   MOVEL     ':92A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
      ** Convert Coupon Rate to SWIFT format
      *
     C                   Z-ADD     MGCPNR        ZPRIC
     C                   MOVE      *BLANKS       ZSPRIC
     C                   MOVE      *BLANKS       ZOPRIC
     C*
     C                   CALL      'ZM1190'                             24
     C                   PARM                    ZPRIC
     C                   PARM                    ZSPRIC
     C                   PARM                    ZOPRIC
      *
      ** If program not found, perform DB Error processing
      *
     C     *IN24         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     018           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 018 *
     C                   MOVEL     'ZM1190'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     ':INTR//'     MDAT
      *
     C     MDAT          CAT       ZSPRIC:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
      ** Output EU witholding tax if present                                                  234140
     C     EUTS          IFNE      0
     C                   MOVEL     ':70E:'       MTAG
     C     ':FIAN//'     CAT       'TSMT'        W@15             15
     C                   MOVEL     W@15          MDAT
     C     MDAT          CAT       MGSTCY        MDAT
      *                                                                                       234140
      ** Convert tax amount to SWIFT format                                                   234140
     C                   Z-ADD     EUTS          ZPRIC
     C                   MOVE      *BLANKS       ZSPRIC
     C                   MOVE      *BLANKS       ZOPRIC
      *                                                                                       234140
     C                   CALL      'ZM1190'                             24
     C                   PARM                    ZPRIC
     C                   PARM                    ZSPRIC
     C                   PARM                    ZOPRIC
      *                                                                                       234140
     C     MDAT          CAT       ZSPRIC:0      MDAT
     C                   END
      *
      ** Format :16S: - End of Block
      *
     C                   MOVEL     ':16S:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'FIA'         MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRSDET
      *****************************************************************
      *                                                               *
      *  SRSDET - Format Settlement Details for MT515 Sequence D or   *
      *           MF518 Sequence C                                    *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRSDET        BEGSR
      *
      ** Set up Message Sequence workfield
      *
     C     MGMTYP        IFEQ      '515'
     C                   MOVEL     'D  '         WSEQ
     C                   ELSE
     C                   MOVEL     'C  '         WSEQ
     C                   ENDIF
      *
      ** Save the content WSEQ workfield
      *
     C                   MOVE      WSEQ          SV@SEQ
      *
      ** Format :16R: - Start of Block
      *
     C                   MOVEL     ':16R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'SETDET'      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   MOVE      *BLANK        WFLD07            7
     C                   MOVE      *BLANK        WFLD08            4
     C                   MOVEL     ':SETR//'     WFLD07
      *
     C     MGMTYP        IFEQ      '515'
     C     MGMTYP        OREQ      '518'
     C     MGTTYP        ANDEQ     'TR'
      *                                                                                       CSW201
     C     CSW201        IFEQ      'Y'
     C     CSE006        ANDEQ     'Y'
      *                                                                                       CSW201
     C                   MOVEL     MGTNUM        WTDRF             6
     C     WTDRF         CHAIN     TRADS                              55
      *                                                                                       CSW201
     C     *IN55         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     034           DBASE
     C                   MOVEL     'TRADSD'      DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CSW201
     C     LKRF          IFNE      *BLANKS
      *                                                                                       CSW201
     C     LKRF          CHAIN     TRADS                              55
      *                                                                                       CSW201
     C     *IN55         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     035           DBASE
     C                   MOVEL     'TRADSD'      DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CSW201
     C     CSW207        IFEQ      'N'
     C     MGTSTP        IFEQ      'TP'
     C     MGVDAT        ANDLT     TDVD
     C     MGTSTP        OREQ      'TS'
     C     MGVDAT        ANDLT     TDVD
     C                   MOVEL     'BSBO'        WFLD08
     C                   ELSE
     C                   MOVEL     'BSBC'        WFLD08
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'BSBK'        WFLD08
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW201
     C                   ELSE
      *                                                                                       CSW201
     C                   MOVEL     'TRAD'        WFLD08
      *                                                                                       CSW201
     C                   ENDIF
      *                                                                                       CSW201
     C                   ENDIF
      *                                                                                       CSW201
     C                   ELSE
      *                                                                                       CSW201
     C                   MOVEL     'TRAD'        WFLD08
      *                                                                                       CSW201
     C                   ENDIF
      *                                                                                       CSW201
     C                   EXSR      SRF22F
     C                   ENDIF
      *
     C     MGMTYP        IFEQ      '518'
      *
     C     MGTTYP        IFEQ      'DM'
     C     MGTSTP        ANDEQ     'RP'
     C     MGTTYP        OREQ      'DM'
     C     MGTSTP        ANDEQ     'RR'
     C                   MOVEL     'REPO'        WFLD08
     C     CSW202        IFEQ      'Y'
     C                   MOVEL     'REPU'        WFLD08
     C                   ENDIF
     C                   EXSR      SRF22F
     C                   ENDIF
      *
     C     MGTTYP        IFEQ      'DN'
     C     MGTSTP        ANDEQ     'RP'
     C     MGTTYP        OREQ      'DN'
     C     MGTSTP        ANDEQ     'RR'
     C                   MOVEL     'REPC'        WFLD08
     C     CSW202        IFEQ      'Y'
     C                   MOVEL     'REPU'        WFLD08
     C                   ENDIF
     C                   EXSR      SRF22F
     C                   ENDIF
      *
     C     MGTSTP        IFEQ      'BL'
     C     MGTSTP        OREQ      'BB'
     C                   MOVEL     'SECL'        WFLD08
     C                   EXSR      SRF22F
     C                   ENDIF
      *
     C     CSW208        IFEQ      'Y'
     C     MGTSTP        IFEQ      'PD'
     C     MGTTYP        ANDEQ     'DM'
     C                   MOVEL     'COLO'        WFLD08
     C                   EXSR      SRF22F
     C                   ENDIF
     C     MGTSTP        IFEQ      'PD'
     C     MGTTYP        ANDEQ     'DN'
     C                   MOVEL     'COLI'        WFLD08
     C                   EXSR      SRF22F
     C                   ENDIF
     C     MGTSTP        IFEQ      'PL'
     C     MGTTYP        ANDEQ     'DM'
     C                   MOVEL     'COLI'        WFLD08
     C                   EXSR      SRF22F
     C                   ENDIF
     C     MGTSTP        IFEQ      'PL'
     C     MGTTYP        ANDEQ     'DN'
     C                   MOVEL     'COLO'        WFLD08
     C                   EXSR      SRF22F
     C                   ENDIF
     C                   ELSE
     C     MGTSTP        IFEQ      'PD'
     C     MGTSTP        OREQ      'PL'
     C                   MOVEL     'COLL'        WFLD08
     C                   EXSR      SRF22F
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** GTDL is processed in sequence 'C' since SWIFT 1999 changes       CSW200
      *                                                                   CSW200
     C     CSW200        IFNE      'CSW200'                                                    CSW20
     C                   MOVEL     ':STCO//'     WFLD07
     C     MGPCOD        IFEQ      '5'
     C                   MOVEL     'GTDL'        WFLD08
     C                   EXSR      SRF22F
     C                   ENDIF
     C                   ENDIF                                                                 CSW20
      *
     C     CSW203        IFEQ      'Y'
     C                   MOVEL     ':STCO//'     WFLD07
     C                   ENDIF
      *                                                                                       CSW203
     C     MGINSS        IFEQ      'PHYSI'
     C                   MOVEL     'PHYS'        WFLD08
     C                   EXSR      SRF22F
     C                   ENDIF
      *                                                                                       CSW203
     C     CSW203        IFEQ      'Y'
      *                                                                                       CSW203
     C                   MOVEL     MGTNUM        WKTNUM            6
      *                                                                                       CSW203
     C     WKTNUM        CHAIN     TRADSDY1                           48
      *                                                                                       CSW203
      ** STAM Qualifier                                                                       CSW203
      *                                                                                       CSW203
     C     T1STMP        IFNE      *BLANKS
      *                                                                                       CSW203
     C                   MOVEL     T2PSET        @KEY
     C                   MOVE      *BLANKS       WMPRAC
      *                                                                                       CSW203
      ** Get customer details via access object                                               CSW203
      *                                                                                       CSW203
     C*********************CALL 'AOCUSTR0'                                              CSW203CSW036
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY
     C                   PARM      *BLANKS       @KYST
     C***********SDCUST    PARM SDCUST    DSSDY                                         CSW203CSW036
     C     SDCUST        PARM      SDCUST        DSLDY
      *                                                                                       CSW203
     C     @RTCD         IFEQ      *BLANKS
     C     BBCSI2        IFNE      *BLANKS
     C     CSW036        ANDEQ     'Y'
     C                   MOVEL     BBCSI2        WMPRAC
     C                   ELSE
     C                   MOVEL     BBCSID        WMPRAC
     C                   ENDIF
     C                   ELSE
      *                                                                                       CSW203
     C                   MOVEL     T2PSET        WMPRAC
      *                                                                                       CSW203
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    WBICCD
     C                   PARM                    WBICBR
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       W9CUST            1
     C                   PARM      *BLANKS       W9CNST            1
     C                   PARM      *BLANKS       W9BICD            1
      *                                                                                       CSW203
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     T2PSET        WMPRAC
     C                   ENDIF
      *                                                                                       CSW203
     C                   ENDIF
      *                                                                                       CSW203
     C                   SELECT
     C     WKMRPR        WHENEQ    'GB'
     C                   MOVEL     'CRST'        WRKDSS            4
     C     WKMRPR        WHENEQ    'AU'
     C                   MOVEL     'XASX'        WRKDSS
     C     WKMRPR        WHENEQ    'ZA'
     C                   MOVEL     'STRA'        WRKDSS
     C                   ENDSL
      *                                                                                       CSW203
     C                   MOVEL     ':22F:'       MTAG
      *                                                                                       CSW203
      ** Access tag description                                                               CSW203
      *                                                                                       CSW203
     C                   EXSR      SRMTAG
      *                                                                                       CSW203
     C                   MOVEL     ':STAM/'      MDAT
     C                   CAT       WRKDSS:0      MDAT
     C                   CAT       '/':0         MDAT
     C                   CAT       T1STMP:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *                                                                                       CSW203
      ** Access the next occurence in MULT                                                    CSW203
      *                                                                                       CSW203
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       CSW203
      ** NRTG/YRTG Qualifier                                                                  CSW203
      *                                                                                       CSW203
     C     T1INSS        IFEQ      'NRTG'
     C     T1INSS        OREQ      'YRTG'
     C                   MOVEL     ':RTGS//'     WFLD07
     C                   MOVEL     T1INSS        WFLD08
     C                   EXSR      SRF22F
     C                   ENDIF
      *                                                                                       CSW203
      ** REGT Qualifier                                                                       CSW203
      *                                                                                       CSW203
     C     T1SIOR        IFEQ      'Y'
     C     T1SIOR        OREQ      'N'
     C                   MOVEL     ':REGT//'     WFLD07
     C     T1SIOR        CAT       'REG':0       WFLD08
     C                   EXSR      SRF22F
     C                   ENDIF
      *                                                                                       CSW203
      ** Status Codes                                                                         CSW203
      *                                                                                       CSW203
     C     T1NEW         IFEQ      'Y'
      *                                                                                       CSW203
     C                   MOVE      *OFF          *IN47
     C                   MOVE      'N'           WPASS
     C                   MOVEL     T2FIN1        WT2FIN
      *                                                                                       CSW203
     C     W01CHR        IFEQ      '*'
     C                   MOVE      *ON           *IN47
     C                   Z-ADD     2             W1                3 0
     C                   Z-ADD     0             WSTORE
     C                   ENDIF
      *                                                                                       CSW203
     C     *IN47         DOWEQ     *ON
      *                                                                                       CSW203
     C                   MOVE      'N'           WFMT              1
      *                                                                                       CSW203
     C     '*'           SCAN      WT2FIN:W1     WS                3 0    47
      *                                                                                       CSW203
     C     *IN47         IFEQ      *ON
     C                   MOVEL     *BLANKS       WDAT             30
     C     WS            SUB       W1            WSTART            3 0
     C     WSTART        SUBST     WT2FIN:W1     WDAT
     C                   MOVE      'Y'           WFMT
     C                   ELSE
     C     WPASS         IFEQ      'Y'
     C                   MOVEL     *BLANKS       WDAT
     C                   Z-ADD     WSTORE        WS
     C     1             SUBST     T2FIN1:WS     WVAR              1
     C     WVAR          IFEQ      '*'
     C                   ADD       1             WS
     C                   ENDIF
     C     36            SUB       WS            WSTART
     C     WSTART        SUBST     T2FIN1:WS     WDAT
     C                   MOVE      'Y'           WFMT
     C                   MOVE      'N'           WPASS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW203
     C     WFMT          IFEQ      'Y'
     C                   MOVEL     ':22F:'       MTAG
      *                                                                                       CSW203
      ** Access tag description                                                               CSW203
      *                                                                                       CSW203
     C                   EXSR      SRMTAG
      *                                                                                       CSW203
     C     ':'           CAT       WDAT:0        MDAT
     C                   MOVEL     MDAT          RDAT
      *                                                                                       CSW203
      ** Access the next occurence in MULT                                                    CSW203
      *                                                                                       CSW203
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       CSW203
     C     *IN47         IFEQ      *ON
     C     '*'           SCAN      WT2FIN:W1     WS                       47
      *                                                                                       CSW203
     C     *IN47         IFEQ      *ON
     C                   MOVEL     *BLANKS       WTFIN2           35
     C                   MOVEL     WT2FIN        WTFIN2
     C                   MOVEL     *BLANKS       WT2FIN
     C     36            SUB       WS            WSTART
     C     WSTART        SUBST     WTFIN2:WS     WT2FIN
     C                   MOVE      'Y'           WPASS             1
     C                   ADD       WS            WSTORE            3 0
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW203
     C                   ENDDO
      *                                                                                       CSW203
     C                   MOVE      *OFF          *IN47
     C                   MOVE      'N'           WPASS
     C                   MOVEL     T2FIN2        WT2FIN
      *                                                                                       CSW203
     C     W01CHR        IFEQ      '*'
     C                   MOVE      *ON           *IN47
     C                   Z-ADD     2             W1
     C                   Z-ADD     0             WSTORE
     C                   ENDIF
      *                                                                                       CSW203
     C     *IN47         DOWEQ     *ON
      *                                                                                       CSW203
     C                   MOVE      'N'           WFMT
      *                                                                                       CSW203
     C     '*'           SCAN      WT2FIN:W1     WS                       47
      *                                                                                       CSW203
     C     *IN47         IFEQ      *ON
     C                   MOVEL     *BLANKS       WDAT
     C     WS            SUB       W1            WSTART
     C     WSTART        SUBST     WT2FIN:W1     WDAT
     C                   MOVE      'Y'           WFMT
     C                   ELSE
     C     WPASS         IFEQ      'Y'
     C                   MOVEL     *BLANKS       WDAT
     C                   Z-ADD     WSTORE        WS
     C     1             SUBST     T2FIN2:WS     WVAR
     C     WVAR          IFEQ      '*'
     C                   ADD       1             WS
     C                   ENDIF
     C     36            SUB       WS            WSTART
     C     WSTART        SUBST     T2FIN2:WS     WDAT
     C                   MOVE      'Y'           WFMT
     C                   MOVE      'N'           WPASS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW203
     C     WFMT          IFEQ      'Y'
     C                   MOVEL     ':22F:'       MTAG
      *                                                                                       CSW203
      ** Access tag description                                                               CSW203
      *                                                                                       CSW203
     C                   EXSR      SRMTAG
      *                                                                                       CSW203
     C     ':'           CAT       WDAT:0        MDAT
     C                   MOVEL     MDAT          RDAT
      *                                                                                       CSW203
      ** Access the next occurence in MULT                                                    CSW203
      *                                                                                       CSW203
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       CSW203
     C     *IN47         IFEQ      *ON
     C     '*'           SCAN      WT2FIN:W1     WS                       47
      *                                                                                       CSW203
     C     *IN47         IFEQ      *ON
     C                   MOVEL     *BLANKS       WTFIN2
     C                   MOVEL     WT2FIN        WTFIN2
     C                   MOVEL     *BLANKS       WT2FIN
     C     36            SUB       WS            WSTART
     C     WSTART        SUBST     WTFIN2:WS     WT2FIN
     C                   MOVE      'Y'           WPASS
     C                   ADD       WS            WSTORE
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW203
     C                   ENDDO
      *                                                                                       CSW203
     C                   ENDIF
      *                                                                                       CSW203
     C                   ENDIF
      *                                                                                       CSW203
     C     CSW203        IFEQ      'N'
      *                                                                                       CSW201
      ** S.W.I.F.T. 2001: Format 17B: Accrued Interest Flag                                   CSW201
      *                                                                                       CSW201
     C     CSW201        IFEQ      'Y'
      *                                                                                       CSW201
     C     MGCPNR        IFNE      *ZEROS
     C                   MOVEL     ':17B:'       MTAG
     C                   EXSR      SRMTAG
     C                   MOVEL     ':ACRU//Y'    MDAT
     C                   MOVEL     MDAT          RDAT
      *                                                                                       CSW201
      ** Access the next occurence in MULT                                                    CSW201
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       CSW201
     C                   ELSE
      *
      ** Format :17B: - Instruction Override
      *
     C                   MOVEL     ':17B:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':STAN//'     MDAT
      *
     C     MGSTAN        IFNE      *BLANKS
     C     MDAT          CAT       MGSTAN:0      MDAT
     C                   ELSE
     C     MDAT          CAT       'N':0         MDAT
     C                   ENDIF
      *
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *                                                                                       CSW201
     C                   ENDIF
      *                                                                                       CSW203
     C                   ENDIF
      *
      ** Format Settlement Parties only if MGDSSN or MGRSSS is not blank
      *
     C     MGDSSN        IFNE      *BLANKS
     C     MGRSSN        ORNE      *BLANKS
      *
     C     MGMTYP        IFEQ      '515'
     C                   EXSR      SR5SPY
     C                   ENDIF
      *
     C     MGMTYP        IFEQ      '518'
     C                   EXSR      SR8SPY
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Format MT515 Subsequence D2 or MT518 Subsequence C2
      *
     C     MGAWIN        IFNE      *BLANKS
     C     MGBOFN        ORNE      *BLANKS
     C     MGDIDN        ORNE      *BLANKS
     C     MGDAD1        ORNE      *BLANKS
     C                   EXSR      SRCSHP
     C                   ENDIF
      *
      ** Format MT515 Subsequence D3 or MT518 Subsequence C3
      *
     C                   EXSR      SRFAMT
      *
      ** Restore the old value WSEQ
      *
     C                   MOVE      SV@SEQ        WSEQ
      *
      ** Format :16S: - End of Block
     C                   MOVEL     ':16S:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'SETDET'      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRF22F
      *****************************************************************
      *                                                               *
      *  SRF22F - Subroutine to format tag :22F:                      *
      *                                                               *
      *  Called By: SR/SRSDET                                         *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRF22F        BEGSR
      *
     C                   MOVEL     ':22F:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     WFLD07        MDAT
     C     MDAT          CAT       WFLD08:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDSR
      *****************************************************************
      *****************************************************************                       CSW207
      /TITLE SR/SRN22F                                                                        CSW207
      *****************************************************************                       CSW207
      *                                                               *                       CSW207
      *  SRN22F - Subroutine to format tag :22F:                      *                       CSW207
      *                                                               *                       CSW207
      *****************************************************************                       CSW207
      *                                                                                       CSW207
     C     SRN22F        BEGSR
      *                                                                                       CSW207
     C                   MOVEL     'N'           WFINCA
     C                   MOVEL     'N'           WFTRCA
      *                                                                                       CSW207
      ** Check if 22F will be formatted for INCA                                              CSW207
      *                                                                                       CSW207
     C     MGDEST        IFNE      *ZEROS
     C                   MOVE      MGDEST        WCUST             6
     C**********           CALL 'AOCUSTR1'                                           CSW207 BUG21097
     C                   CALL      'AOCSSWR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCUST         @KEY
     C                   PARM      *BLANKS       @KYST
     C********** SDCUST    PARM SDCUST    DSLDY                                      CSW207 BUG21097
     C                   PARM                    DSLDY
      *                                                                                       CSW207
      ** Database Error                                                                       CSW207
      *                                                                                       CSW207
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     024           DBASE                          ***************
     C                   MOVEL     'SDCUSTPD'    DBFILE                         *DB ERROR 024 *
     C                   MOVE      @KEY          DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSW207
      ** extract SDCUSTPD and SDCSSWPD                                                        CSW207
      *                                                                                       CSW207
     C                   MOVEL     'SDCUSTPD'    P#FILN
     C                   EXSR      GETRCL
     C     P#RCDL        SUBST     DSLDY         SDCUST
     C     P#RCDL        ADD       1             S                 5 0
      *                                                                                       CSW207
     C                   MOVEL     'SDCSSWPD'    P#FILN
     C                   EXSR      GETRCL
     C     P#RCDL        SUBST     DSLDY:S       SDCSSW
      *                                                                                       CSW207
      ** If location code is not blank, check location code.                                  261402
      ** Otherwise, flag as not MiFID compliant.                                              261402
      *                                                                                       261402
     C     A8LCCD        IFNE      *BLANKS
      *                                                                                       261402
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      A8LCCD        @LOCN             3
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CSW207
      ** Database error proceesing                                                            CSW207
      *                                                                                       CSW207
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     023           DBASE                          ***************
     C                   MOVEL     'SDLOCNPD'    DBFILE                         *DB ERROR 023 *
     C                   MOVE      @LOCN         DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSW207
     C*****DVCNCD        CHAIN     MEISOCL1                           56                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :DVCNCD                                                              MD058081
     C/END-EXEC                                                                             MD058081
     C     M3MFID        IFEQ      'Y'
     C     BFCLAS        ANDEQ     'S'
     C     M3MFID        OREQ      'Y'
     C     BFCLAS        ANDEQ     'D'
     C                   MOVEL     'Y'           WFINCA
     C                   ENDIF
     C     M3MFID        IFEQ      'Y'
     C     BFCLAS        ANDEQ     'M'
     C                   MOVEL     'Y'           WFTRCA
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           M3MFID
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW207
      ** Format field :22F:                                                                   CSW207
      *                                                                                       CSW207
     C     WFINCA        IFEQ      'Y'
     C     CSCICI        ANDNE     *BLANKS
     C                   MOVEL     ':22F:'       MTAG
     C                   EXSR      SRMTAG
     C                   MOVEL     ':INCA//'     MDAT
     C     MDAT          CAT       CSCICI:0      MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       CSW207
     C     WFTRCA        IFEQ      'Y'
     C     CSCPCI        ANDNE     *BLANKS
     C                   MOVEL     ':22F:'       MTAG
     C                   EXSR      SRMTAG
     C     ':TRCA//'     CAT       CSCPCI:0      MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       CSW207
     C                   ENDSR
      *****************************************************************                       CSW207
      /TITLE SR/SR5SPY
      *****************************************************************
      *                                                               *
      *  SR5SPY - Format MT515 Subsequence D1 - Settlement Parties    *
      *                                                               *
      *  Called By: SR/SRSDET                                         *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SR5SPY        BEGSR
      *
      ** Set up Message Sequence workfield
      *
     C                   MOVEL     'D1 '         WSEQ
      *
      ** Format :16R: - Start of Block
      *
     C                   MOVEL     ':16R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'SETPRTY'     MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format field :95a: - Party ('a' can be 'P' or 'Q')
      *
     C                   MOVE      *BLANKS       WMDAT             7
     C                   MOVE      *BLANK        ERR95             1
      *
      ** If Trans Sub-Type = 'TP', format Deliverer of Securities
      *
     C     MGTSTP        IFEQ      'TP'
      *
     C     MGDSSN        IFNE      *BLANK
     C                   MOVEL     ':DEAG//'     WMDAT
     C                   MOVEL     MGDSSN        ZDEST            12
     C                   ELSE
     C                   MOVEL     ERRA(10)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           ERR95
     C                   ENDIF
      *
      ** Otherwise ('TS'), format Receiver of Securities
      *
     C                   ELSE
      *
     C     MGRSSN        IFNE      *BLANK
     C                   MOVEL     ':REAG//'     WMDAT
     C                   MOVEL     MGRSSN        ZDEST            12
     C                   ELSE
     C                   MOVEL     ERRA(11)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           ERR95
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ERR95         IFNE      'Y'
     C                   EXSR      SRF95
     C                   ELSE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *
      ** Format field :97A: - Safekeeping Account
      *
     C     MGSA1L        IFNE      *BLANKS
      *
     C                   MOVEL     ':97A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':SAFE//'     MDAT
     C     MDAT          CAT       MGSA1L:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ELSE
      *
     C     MGTSTP        IFEQ      'TP'
     C     MGDSS1        ANDNE     *BLANKS
      *
     C                   MOVEL     ':97A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':SAFE//'     MDAT
     C     MDAT          CAT       MGDSS1:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
     C     MGTSTP        IFEQ      'TS'
     C     MGRSS1        ANDNE     *BLANKS
      *
     C                   MOVEL     ':97A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':SAFE//'     MDAT
     C     MDAT          CAT       MGRSS1:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Format :16S: - End of Block
      *
     C                   MOVEL     ':16S:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'SETPRTY'     MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SR8SPY
      *****************************************************************
      *                                                               *
      *  SR8SPY - Format MT518 Subsequence C1 - Settlement Parties    *
      *                                                               *
      *  Called By: SR/SRSDET                                         *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SR8SPY        BEGSR
      *
      ** Set up Message Sequence workfield
      *
     C                   MOVEL     'C1 '         WSEQ
      *
      ** If Deliverer of Securities is not blank
      *
     C     MGDSSN        IFNE      *BLANKS
      *
      ** Format :16R: - Start of Block
     C                   MOVEL     ':16R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'SETPRTY'     MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format field :95a: - Party ('a' can be 'P' or 'Q')
      *
     C                   MOVEL     ':DEAG//'     WMDAT             7
     C                   MOVEL     MGDSSN        ZDEST            12
      *
     C                   EXSR      SRF95
      *
      ** Format field :97A: - Safekeeping Account
      *
     C     MGDSS1        IFNE      *BLANKS
      *
     C                   MOVEL     ':97A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':SAFE//'     MDAT
     C     MDAT          CAT       MGDSS1:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ELSE
      *
     C     MGSA1L        IFNE      *BLANKS
      *
     C                   MOVEL     ':97A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':SAFE//'     MDAT
     C     MDAT          CAT       MGSA1L:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Format :16S: - End of Block
      *
     C                   MOVEL     ':16S:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'SETPRTY'     MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
     C     MGRSSN        IFNE      *BLANKS
      *
      ** Format :16R: - Start of Block
      *
     C                   MOVEL     ':16R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'SETPRTY'     MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format field :95a: - Party ('a' can be 'P' or 'Q')
      *
     C                   MOVEL     ':REAG//'     WMDAT             7
     C                   MOVEL     MGRSSN        ZDEST            12
      *
     C                   EXSR      SRF95
      *
      ** Format field :97A: - Safekeeping Account
      *
     C     MGRSS1        IFNE      *BLANKS
      *
     C                   MOVEL     ':97A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':SAFE//'     MDAT
     C     MDAT          CAT       MGRSS1:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
      ** Format :16S: - End of Block
      *
     C                   MOVEL     ':16S:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'SETPRTY'     MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRCSHP
      *****************************************************************
      *                                                               *
      *  SRCSHP - Format MT515 Subsequence D2 or MT518 Subsequence C2 *
      *           (Cash Parties)                                      *
      *                                                               *
      *  Called By: SR/SRSDET                                         *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRCSHP        BEGSR
      *
      ** Set up Message Sequence workfield
      *
     C     MGMTYP        IFEQ      '515'
     C                   MOVEL     'D2 '         WSEQ
     C                   ELSE
     C                   MOVEL     'C2 '         WSEQ
     C                   ENDIF
      *
      ** If "Account with Institution" is present
     C     MGAWIN        IFNE      *BLANKS
      *
      ** Format :16R: - Start of Block
     C                   MOVEL     ':16R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'CSHPRTY'     MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format field :95a: - Party ('a' can be 'P', 'R' or 'Q')
      *
     C                   MOVE      *BLANK        W#95R             1
      *
      ** If A/c with Inst Issuer Code is present, format tag :95R:
     C     MGAWIC        IFNE      *BLANKS
      *
      ** Move 'Y' to field :95R: is output indicator
      *
     C                   MOVE      'Y'           W#95R
      *
     C                   MOVEL     ':95R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *                                                                                     AR589164
     C                   MOVE      *BLANKS       LGDSS            10
      *                                                                                     AR589164
     C     MGNMCY        IFEQ      'EUR'
     C     MGAWIC        IFEQ      'LATI'
     C                   MOVEL     'IBRCLATI'    LGDSS
     C                   ENDIF
     C                   ENDIF
      *                                                                                     AR589164
     C     MGNMCY        IFEQ      'USD'
     C                   SELECT
     C     MGAWIC        WHENEQ    'USCH'
     C                   MOVEL     'NYCHUSCH'    LGDSS
     C     MGAWIC        WHENEQ    'USCP'
     C                   MOVEL     'NYCHUSCP'    LGDSS
     C     MGAWIC        WHENEQ    'FINS'
     C                   MOVEL     'DTCYFINS'    LGDSS
     C     MGAWIC        WHENEQ    'PART'
     C                   MOVEL     'DTCYPART'    LGDSS
     C     MGAWIC        WHENEQ    'USER'
     C                   MOVEL     'DTCYUSER'    LGDSS
     C     MGAWIC        WHENEQ    'ID  '
     C                   MOVEL     'DTCYID'      LGDSS
     C                   ENDSL
     C                   ENDIF
      *
     C                   MOVEL     ':ACCW/'      MDAT
     C     LGDSS         IFEQ      *BLANKS
     C     MDAT          CAT       MGAWIC:0      MDAT
     C                   ELSE
     C     MDAT          CAT       LGDSS:0       MDAT
     C                   ENDIF
     C     MDAT          CAT       '/':0         MDAT
     C     MDAT          CAT       MGAWIL:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ELSE
      *
     C                   MOVEL     ':ACCW//'     WMDAT             7
     C                   MOVEL     MGAWIN        ZDEST            12
      *
     C     CSW201        IFEQ      'Y'
     C                   MOVE      'Y'           ZDBEI
     C                   ENDIF
      *                                                                                       CSW201
     C                   EXSR      SRF95
      *                                                                                       CSW201
     C                   MOVE      ' '           ZDBEI
      *
     C                   ENDIF
      *
      ** Format field :97A: - Safekeeping Account
      *
     C     MGAWIL        IFNE      *BLANKS
     C     W#95R         ANDNE     'Y'
      *
     C                   MOVEL     ':97A:'       MTAG
      *                                                                                       CSW210
      ** Check if Account with Institution Line IBAN Flag = 'Y'                               CSW210
      *                                                                                       CSW210
     C     CSW210        IFEQ      'Y'
     C     CFT004        ANDEQ     'Y'
     C     MGFAI1        ANDEQ     'Y'
     C                   MOVEL     ':97E:'       MTAG
     C                   ENDIF
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':CASH//'     MDAT
     C     MDAT          CAT       MGAWIL:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
      ** Format :16S: - End of Block
     C                   MOVEL     ':16S:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'CSHPRTY'     MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
      ** If "Beneficiary of Money" is present
     C     MGBOFN        IFNE      *BLANKS
      *
      ** Format :16R: - Start of Block
      *
     C                   MOVEL     ':16R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'CSHPRTY'     MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** Format field :95a: - Party ('a' can be 'P', 'R' or 'Q')
      *
     C                   MOVE      *BLANK        W#95R             1
      *
      ** If Ben of Money Issuer Code is present, format tag :95R:
     C     MGBOFC        IFNE      *BLANKS
      *
      ** Move 'Y' to field :95R: is output indicator
      *
     C                   MOVE      'Y'           W#95R
      *
     C                   MOVEL     ':95R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *                                                                                     AR589164
     C                   MOVE      *BLANKS       LGDSS            10
      *                                                                                     AR589164
     C     MGNMCY        IFEQ      'EUR'
     C     MGBOFC        IFEQ      'LATI'
     C                   MOVEL     'IBRCLATI'    LGDSS
     C                   ENDIF
     C                   ENDIF
      *                                                                                     AR589164
     C     MGNMCY        IFEQ      'USD'
     C                   SELECT
     C     MGBOFC        WHENEQ    'USCH'
     C                   MOVEL     'NYCHUSCH'    LGDSS
     C     MGBOFC        WHENEQ    'USCP'
     C                   MOVEL     'NYCHUSCP'    LGDSS
     C     MGBOFC        WHENEQ    'FINS'
     C                   MOVEL     'DTCYFINS'    LGDSS
     C     MGBOFC        WHENEQ    'PART'
     C                   MOVEL     'DTCYPART'    LGDSS
     C     MGBOFC        WHENEQ    'USER'
     C                   MOVEL     'DTCYUSER'    LGDSS
     C     MGBOFC        WHENEQ    'ID  '
     C                   MOVEL     'DTCYID'      LGDSS
     C                   ENDSL
     C                   ENDIF
      *
     C                   MOVEL     ':BENM/'      MDAT
     C     LGDSS         IFEQ      *BLANKS
     C     MDAT          CAT       MGBOFC:0      MDAT
     C                   ELSE
     C     MDAT          CAT       LGDSS:0       MDAT
     C                   ENDIF
     C     MDAT          CAT       '/':0         MDAT
     C     MDAT          CAT       MGBOF1:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ELSE
      *
     C                   MOVEL     ':BENM//'     WMDAT             7
     C                   MOVEL     MGBOFN        ZDEST            12
      *
     C                   EXSR      SRF95
      *
     C                   ENDIF
      *
      ** Format field :97A: - Safekeeping Account
      *
     C     MGBOF1        IFNE      *BLANKS
     C     W#95R         ANDNE     'Y'
      *
     C                   MOVEL     ':97A:'       MTAG
      *                                                                                       CSW210
      ** Check if Beneficiary of Money Line IBAN Flag = 'Y'                                   CSW210
      *                                                                                       CSW210
     C     CSW210        IFEQ      'Y'
     C     CFT004        ANDEQ     'Y'
     C     MGFBF1        ANDEQ     'Y'
     C                   MOVEL     ':97E:'       MTAG
     C                   ENDIF
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     ':CASH//'     MDAT
     C     MDAT          CAT       MGBOF1:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
      ** Format :16S: - End of Block
     C                   MOVEL     ':16S:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'CSHPRTY'     MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
     C     CSW210        IFEQ      'Y'
      *                                                                                       CSW210
     C     MGDIDN        IFNE      *BLANKS
     C     MGDAD1        ORNE      *BLANKS
     C     MGDLIN        ORNE      *BLANKS
      *                                                                                       CSW210
      ** Format :16R: - Start of Block                                                        CSW210
     C                   MOVEL     ':16R:'       MTAG
      *                                                                                       CSW210
      ** Access tag description                                                               CSW210
      *                                                                                       CSW210
     C                   EXSR      SRMTAG
      *                                                                                       CSW210
     C                   MOVEL     'CSHPRTY'     MDAT
     C                   MOVEL     MDAT          RDAT
      *                                                                                       CSW210
      ** Access the next occurence in MULT                                                    CSW210
      *                                                                                       CSW210
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *                                                                                       CSW210
      ** Format field :95a: - Party ('a' can be 'P', 'R' or 'Q')                              CSW210
      ** Check as Debtor ID                                                                   CSW210
      *                                                                                       CSW210
     C     MGDIDN        IFNE      *BLANKS
     C     MGDAD1        ANDEQ     *BLANKS
     C                   MOVEL     ':DEBT//'     WMDAT
     C                   MOVEL     MGDIDN        ZDEST
      *                                                                                       CSW210
     C     CSW201        IFEQ      'Y'
     C                   MOVE      'Y'           ZDBEI
     C                   ENDIF
      *                                                                                       CSW210
     C                   EXSR      SRF95
      *                                                                                       CSW210
     C                   MOVE      ' '           ZDBEI
     C                   ENDIF
      *                                                                                       CSW210
      ** Check as SWIFT address                                                               CSW210
      *                                                                                       CSW210
     C                   MOVEL     'N'           ##CSID
     C     MGDAD1        IFNE      *BLANKS
     C     MGDIDN        ANDEQ     *BLANKS
     C     MGDAD2        ANDEQ     *BLANKS
     C                   EXSR      SRSWFT
     C     ##CSID        IFEQ      'Y'
     C                   MOVEL     ':95P:'       MTAG
      *                                                                                       CSW210
      ** Access tag description                                                               CSW210
      *                                                                                       CSW210
     C                   EXSR      SRMTAG
      *                                                                                       CSW210
     C                   MOVEL     ':DEBT//'     MDAT
     C     MDAT          CAT       MGDAD1:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *                                                                                       CSW210
      ** Access the next occurence in MULT                                                    CSW210
      *                                                                                       CSW210
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW210
      ** Check as Codeword                                                                    CSW210
      *                                                                                       CSW210
     C     1             SUBST     MGDAD1:1      ##SLSH            1
     C     ##SLSH        IFEQ      '/'
     C     MGDAD2        ANDNE     *BLANKS
     C     MGDIDN        ANDEQ     *BLANKS
     C                   MOVEL     ':95R:'       MTAG
      *                                                                                       CSW210
      ** Access tag description                                                               CSW210
      *                                                                                       CSW210
     C                   EXSR      SRMTAG
      *                                                                                       CSW210
     C                   MOVEL     ':DEBT'       MDAT
     C     MDAT          CAT       MGDAD1:0      MDAT
     C     MDAT          CAT       MGDAD2:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *                                                                                       CSW210
      ** Access the next occurence in MULT                                                    CSW210
      *                                                                                       CSW210
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       CSW210
      ** Standard Address                                                                     CSW210
      *                                                                                       CSW210
     C     ##CSID        IFNE      'Y'
     C     ##SLSH        ANDNE     '/'
     C     MGDIDN        ANDEQ     *BLANKS
     C                   MOVEL     ':95Q:'       MTAG
      *                                                                                       CSW210
      ** Access tag description                                                               CSW210
      *                                                                                       CSW210
     C                   EXSR      SRMTAG
      *                                                                                       CSW210
     C                   MOVEL     ':DEBT//'     MDAT
     C     MDAT          CAT       MGDAD1:0      MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *                                                                                       CSW210
     C     MGDAD2        IFNE      *BLANKS
     C                   MOVEL     MGDAD2        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   MOVEL     WSEQ          MSEQ
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       CSW210
     C     MGDAD3        IFNE      *BLANKS
     C                   MOVEL     MGDAD3        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   MOVEL     WSEQ          MSEQ
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       CSW210
     C     MGDAD4        IFNE      *BLANKS
     C                   MOVEL     MGDAD4        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   MOVEL     WSEQ          MSEQ
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW210
      ** Debtor account line                                                                  CSW210
      *                                                                                       CSW210
     C     MGDLIN        IFNE      *BLANKS
     C                   MOVEL     ':97A:'       MTAG
      *                                                                                       CSW210
      ** Debtor Account Line IBAN Flag = 'Y'                                                  CSW210
      *                                                                                       CSW210
     C     CSW210        IFEQ      'Y'
     C     CFT004        ANDEQ     'Y'
     C     MGFDBT        ANDEQ     'Y'
     C                   MOVEL     ':97E:'       MTAG
     C                   ENDIF
      *                                                                                       CSW210
      ** Access tag description                                                               CSW210
      *                                                                                       CSW210
     C                   EXSR      SRMTAG
      *                                                                                       CSW210
     C                   MOVEL     ':CASH//'     MDAT
     C     MDAT          CAT       MGDLIN:0      MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       CSW210
      ** Format :16S: - End of Block                                                          CSW210
     C                   MOVEL     ':16S:'       MTAG
      *                                                                                       CSW210
      ** Access tag description                                                               CSW210
      *                                                                                       CSW210
     C                   EXSR      SRMTAG
      *                                                                                       CSW210
     C                   MOVEL     'CSHPRTY'     MDAT
     C                   MOVEL     MDAT          RDAT
      *                                                                                       CSW210
      ** Access the next occurence in MULT                                                    CSW210
      *                                                                                       CSW210
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *                                                                                       CSW210
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW210
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRFAMT
      *****************************************************************
      *                                                               *
      *  SRFAMT - Format MT515 Subsequence D3 or MT518 Subsequence C3 *
      *           (Amounts)                                           *
      *                                                               *
      *  Called By: SR/SRSDET                                         *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRFAMT        BEGSR
      *
      ** Set up Message Sequence workfield
      *
     C     MGMTYP        IFEQ      '515'
     C                   MOVEL     'D3 '         WSEQ
     C                   ELSE
     C                   MOVEL     'C3 '         WSEQ
     C                   ENDIF
      *
      ** Move 'Y' to WO16R workfield to allow output of tag :16R:
      *
     C                   MOVE      'Y'           WO16R             1
      *
      ** Move 'Y' to WO16S workfield to allow output of tag :16S:
      *
     C                   MOVE      'Y'           WO16S             1
      *
      ** Move the SWIFT Ccy Code of Nominal Ccy to workfield
      *
     C                   MOVEL     WNSWCY        WSWCD             3
      *
      ** Move Nominal Ccy Code to workfield
      *
     C                   MOVEL     MGNMCY        W@CYCD            3
      *
      ** Move Deal Amount to workfield
      *
     C                   Z-ADD     MGDLAM        W@AMNT           15 0
      *
      ** Set up the first 7 chars of MDAT
      *
     C                   MOVE      *BLANKS       WFLD07            7
     C                   MOVEL     ':DEAL//'     WFLD07
      *
      ** Format Seq D3 or C3 for Deal Amount (MGDLAM) field
      *
     C                   EXSR      SRF19A
      *
      ** If Coupon Rate <> *Zero, then,
      **    Format another Seq D3 or C3 for Int Amount (MGITRA)
      *
     C     MGCPNR        IFNE      *ZERO
     C     MGPROT        ANDNE     '6'
     C     WSUPP         ANDNE     'Y'
      *
     C                   Z-ADD     MGITRA        W@AMNT
      *
      ** Set up the first 7 chars of MDAT
      *
     C                   MOVE      *BLANKS       WFLD07            7
     C                   MOVEL     ':ACRU//'     WFLD07
      *
      ** Format 1 block of Seq D3 or C3
      *
     C                   EXSR      SRF19A
      *
     C                   ENDIF
      *
      ** If Reallowance Amount is not *zero, then,
      **    Format another block of Seq D3 or Seq C3
      *
     C     MGISDI        IFNE      *ZERO
      *
     C                   Z-ADD     MGISDI        W@AMNT
      *
      ** Set up the first 7 chars of MDAT
      *
     C                   MOVE      *BLANKS       WFLD07            7
     C                   MOVEL     ':ISDI//'     WFLD07
      *
      ** Format 1 block of Seq D3 or C3
      *
     C                   EXSR      SRF19A
      *
     C                   ENDIF
      *
      ** Format Charges and Commission Amounts
      *
     C                   Z-ADD     1             Y                 2 0
     C                   Z-ADD     *ZERO         E                 2 0
     C     Y             DOWLE     10
     C                   MOVE      *BLANK        CCS
     C                   Z-ADD     *ZERO         CCA
     C                   ADD       1             Y
     C                   ENDDO
      *
     C                   Z-ADD     1             Y
      *
      ** Total the amounts of Charges/Comm with the same SWIFT ID
      *
     C     Y             DOWLE     10
      *
     C     AMT(Y)        IFNE      *ZERO
      *
      ** Default blank SWIFT ID to 'CHAR'
      *
     C     CDE(Y)        IFEQ      *BLANKS
     C     CSW203        IFEQ      'N'
     C                   MOVEL     'CHAR'        CDE(Y)
     C                   ELSE
     C                   MOVEL     'OTHR'        CDE(Y)
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     1             Z                 1 0
     C     CDE(Y)        LOOKUP    CCS(Z)                                 52
      *
      ** If Charge/Commission Code not found in array CCS, then,
      **    Move Charge/Commission Code and Amount to the next element
     C     *IN52         IFEQ      *OFF
     C                   ADD       1             E
     C                   MOVEL     CDE(Y)        CCS(E)
     C                   Z-ADD     AMT(Y)        CCA(E)
      *
     C                   ELSE
      *
      ** Otherwise, (Charge/Comm Code was found in array CCS)
      **    Accummulate the amount for this Charge/Commission Code
     C                   ADD       AMT(Y)        CCA(Z)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ADD       1             Y
      *
     C                   ENDDO
      *
      ** Format the content of array CCS
      *
     C                   Z-ADD     1             Y
     C     Y             DOWLE     10
     C     CCS(Y)        ANDNE     *BLANKS
      *
     C                   Z-ADD     CCA(Y)        W@AMNT
      *
      ** Set up the first 7 chars of MDAT
      *
     C                   MOVE      *BLANKS       WFLD07            7
     C                   MOVEL     ':'           WFLD07
     C     WFLD07        CAT       CCS(Y):0      WFLD07
     C     WFLD07        CAT       '//':0        WFLD07
      *
      ** Format 1 block of Seq D3 or C3
      *
     C                   EXSR      SRF19A
      *
     C                   ADD       1             Y
      *
     C                   ENDDO
      *                                                                                       CSW203
     C     CSW203        IFEQ      'Y'
     C     MGTAXA        ANDNE     *ZEROS
     C                   Z-ADD     MGTAXA        W@AMNT
     C                   MOVEL     *BLANKS       WFLD07
     C                   MOVEL     ':TRAX//'     WFLD07
     C                   EXSR      SRF19A
     C                   ENDIF
      *                                                                   CSE023
      ** If Bachup withholding Tax <> 0                                   CSE023
      **    Format another Seq D3 or C3 for Tax Amount (MGWHTX)           CSE023
      *                                                                   CSE023
     C     MGWHTX        IFNE      *ZERO                                                       CSE02
      *                                                                   CSE023
     C                   Z-ADD     MGWHTX        W@AMNT                                        CSE02
      *                                                                   CSE023
      ** Set up the first 7 chars of MDAT                                 CSE023
      *                                                                   CSE023
     C                   MOVE      *BLANKS       WFLD07            7                           CSE02
     C                   MOVEL     ':WITH//'     WFLD07                                        CSE02
      *                                                                   CSE023
      ** Format 1 block of Seq D3 or C3                                   CSE023
      *                                                                   CSE023
     C                   EXSR      SRF19A                                                      CSE02
      *                                                                   CSE023
     C                   ENDIF                                                                 CSE02
      *
     C     WSUPP         IFNE      'Y'
      *
      ** Move 'N' to WO16S to inhibit output of tag :16S:
      *
     C                   MOVE      'N'           WO16S
      *
      ** Move the SWIFT Ccy Code of Settlement Ccy to workfield
     C                   MOVE      WSSWCY        WSWCD
      *
      ** Move Settlement Ccy Code to workfield
     C                   MOVEL     MGSTCY        W@CYCD
      *
      ** Format Settlement Amount
     C                   Z-ADD     MGSTAM        W@AMNT
      *
      ** Set up the first 7 chars of MDAT
      *
     C                   MOVE      *BLANKS       WFLD07
     C                   MOVEL     ':SETT//'     WFLD07
      *
      ** Format 1 block of Seq D3 or C3
      *
     C                   EXSR      SRF19A
      *
      ** If nominal ccy is different from the settlement currency,
      ** output another :19A using nominal currency equivalent
      ** of settlement amount
      *
     C     MGRESU        IFNE      0
      *
      ** Move 'N' to WO16R to inhibit output of tag :16R:
     C                   MOVE      'N'           WO16R
      ** Move the SWIFT Ccy Code of Nominal Ccy to workfield
     C                   MOVE      WNSWCY        WSWCD
      ** Move Nominal Ccy Code to workfield
     C                   MOVEL     MGNMCY        W@CYCD
      ** Move settlement amount equivalent to workfield
     C                   Z-ADD     MGRESU        W@AMNT
      ** Move codeword to use
     C                   MOVEL     ':RESU//'     WFLD07
      ** Format field
     C                   EXSR      SRF19A
      *
     C                   ENDIF
      *
      ** If EMU Securities Settlement Conversion feature is installed,
      ** and In Ccy in Fld 72 is defined on trade, output original
      ** amount.
      *
     C     CEU005        IFEQ      'Y'
     C     MGOTRC        ANDNE     *BLANKS
     C     CSW014        OREQ      'Y'
     C     MGOTRC        ANDNE     *BLANKS
      *
      ** Move 'N' to WO16R to inhibit output of tag :16R:
     C                   MOVE      'N'           WO16R
      ** Move the SWIFT Ccy Code of Origianl Ccy to workfield
     C                   MOVE      WOSWCY        WSWCD
      ** Move Origianl Ccy Code to workfield
     C                   MOVEL     MGOTRC        W@CYCD
      ** Move Original Amount to workfield
     C                   Z-ADD     MGOTRA        W@AMNT
      ** Move codeword to use
     C                   MOVEL     ':OCMT//'     WFLD07
      ** Format field
     C                   EXSR      SRF19A
      *
     C                   ENDIF
      *
      ** Format field :98A: - Value Date
      *
     C                   MOVEL     ':98A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
      ** Convert Value Date to CCYYMMDD format
      *
     C                   Z-ADD     MGVDAT        ZMDAY
     C                   CALL      'ZM0065'
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZSDATE            6
     C                   PARM                    ZSDATC            8
      *
     C                   MOVEL     ':VALU//'     MDAT
     C     MDAT          CAT       ZSDATC:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** If ((Orig Ccy <> Blank AND Orig CCy <> Sett Ccy)  OR
      **    Nominal Ccy <> Sett Ccy), then format tag :92B:
      *
     C     MGRESU        IFNE      0
     C     MGDAXR        ANDNE     0
      *
      ** Format field :92B: - Exchange Rate
      *
     C                   MOVEL     ':92B:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
      ** Convert Exchange Rate to SWIFT format
      *
     C                   Z-ADD     MGDAXR        ZPRIC
     C                   MOVE      *BLANKS       ZSPRIC
     C                   MOVE      *BLANKS       ZOPRIC
      *
     C                   CALL      'ZM1190'                             24
     C                   PARM                    ZPRIC
     C                   PARM                    ZSPRIC
     C                   PARM                    ZOPRIC
      *
      ** If program not found, perform DB Error processing
     C     *IN24         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     027           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 027 *
     C                   MOVEL     'ZM1190'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     ':EXCH//'     MDAT
      *
     C     MDAT          CAT       WNSWCY:0      MDAT
     C     MDAT          CAT       '/':0         MDAT
     C     MDAT          CAT       WSSWCY:0      MDAT
     C     MDAT          CAT       '/':0         MDAT
     C     MDAT          CAT       ZSPRIC:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
      *
      ** Format :16S: - End of Block
      *
     C                   MOVEL     ':16S:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'AMT'         MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************   CSE006
      /TITLE SR/SRRDET                                                    CSE006
      *****************************************************************   CSE006
      *                                                               *   CSE006
      *  SRRDET - Format of REPO BLOCK - Optional Subsequence E       *   CSE006
      *                                                               *   CSE006
      *  Called By: SRFMT                                             *   CSE006
      *  Calls    :                                                   *   CSE006
      *                                                               *   CSE006
      *****************************************************************   CSE006
      *                                                                   CSE006
     C     SRRDET        BEGSR                                                                 CSE00
      *                                                                   CSE006
      *** Set up Message Sequence workfield                               CSE006
      *                                                                   CSE006
     C                   MOVEL     'E  '         WSEQ                                          CSE00
      *                                                                   CSE006
      *** Save the content WSEQ workfield                                 CSE006
      *                                                                   CSE006
     C                   MOVE      WSEQ          SV@SEQ                                        CSE00
      *                                                                   CSE006
      *** Format 16R:REPO - Start of Block                                CSE006
      *                                                                   CSE006
     C                   MOVEL     ':16R:'       MTAG                                          CSE00
      *                                                                   CSE006
      *** Access tag description                                          CSE006
      *                                                                   CSE006
     C                   EXSR      SRMTAG                                                      CSE00
      *                                                                   CSE006
     C                   MOVEL     'REPO'        MDAT                                          CSE00
     C                   MOVEL     MDAT          RDAT                                          CSE00
      *                                                                   CSE006
      *** Access the next occurence in MULT                               CSE006
      *                                                                   CSE006
     C                   ADD       1             X                                             CSE00
     C     X             OCCUR     MULT                                                        CSE00
      *                                                                   CSE006
      *** Format field :22F: - Indicator                                  CSE006
      *                                                                   CSE006
     C                   MOVEL     ':22F:'       MTAG                                          CSE00
      *                                                                   CSE006
      *** Access tag description                                          CSE006
      *                                                                   CSE006
     C                   EXSR      SRMTAG                                                      CSE00
      *                                                                   CSE006
     C**********           MOVEL'RERT//'  MDAT                                         CSE006 208890
     C                   MOVEL     ':RERT//'     MDAT
     C     MDAT          CAT       'FIXE':0      MDAT                                          CSE00
     C                   MOVEL     MDAT          RDAT                                          CSE00
      *                                                                   CSE006
      *** Access the next occurence in MULT                               CSE006
      *                                                                   CSE006
     C                   ADD       1             X                                             CSE00
     C     X             OCCUR     MULT                                                        CSE00
      *                                                                   CSE006
      *** Format field :20C: - Reference                                  CSE006
      *                                                                   CSE006
     C                   MOVEL     ':20C:'       MTAG                                          CSE00
      *                                                                   CSE006
      *** Access tag description                                          CSE006
      *                                                                   CSE006
     C                   EXSR      SRMTAG                                                      CSE00
      *                                                                   CSE006
     C**********           MOVEL'SECO//'  MDAT                                         CSE006 208890
     C                   MOVEL     ':SECO//'     MDAT
     C     MDAT          CAT       MGARF:0       MDAT                                          CSE00
     C                   MOVEL     MDAT          RDAT                                          CSE00
      *                                                                   CSE006
      *** Access the next occurence in MULT                               CSE006
      *                                                                   CSE006
     C                   ADD       1             X                                             CSE00
     C     X             OCCUR     MULT                                                        CSE00
      *                                                                   CSE006
      *** Format :92A: - Rate                                             CSE006
      *                                                                   CSE006
     C     MGRR          IFNE      *ZERO                                                       CSE00
      *                                                                   CSE006
     C                   MOVEL     ':92A:'       MTAG                                          CSE00
      *                                                                   CSE006
      *** Access tag description                                          CSE006
      *                                                                   CSE006
     C                   EXSR      SRMTAG                                                      CSE00
      *                                                                   CSE006
      *** Convert Repo Rate to SWIFT format                               CSE006
      *                                                                   CSE006
     C                   Z-ADD     MGRR          ZPRIC                                         CSE00
     C                   MOVE      *BLANKS       ZSPRIC                                        CSE00
     C                   MOVE      *BLANKS       ZOPRIC                                        CSE00
     C*                                                                   CSE006
     C                   CALL      'ZM1190'                             24                     CSE00
     C                   PARM                    ZPRIC                                         CSE00
     C                   PARM                    ZSPRIC                                        CSE00
     C                   PARM                    ZOPRIC                                        CSE00
      *                                                                   CSE006
      *** If program not found, perform DB Error processing               CSE006
      *                                                                   CSE006
     C     *IN24         IFEQ      *ON                                                         CSE00
     C     *LOCK         IN        LDA                                                         CSE00
     C                   Z-ADD     021           DBASE                          * * * * * * * *CSE00
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 021 *CSE00
     C                   MOVEL     'ZM1190'      DBPGM                          * * * * * * * *CSE00
     C                   OUT       LDA                                                         CSE00
     C                   EXSR      *PSSR                                                       CSE00
     C                   ENDIF                                                                 CSE00
      *                                                                   CSE006
     C**********           MOVEL'REPO//'  MDAT                                         CSE006 208890
     C                   MOVEL     ':REPO//'     MDAT
      *                                                                   CSE006
     C     MDAT          CAT       ZSPRIC:0      MDAT                                          CSE00
     C                   MOVEL     MDAT          RDAT                                          CSE00
      *                                                                   CSE006
      *** Access the next occurence in MULT                               CSE006
      *                                                                   CSE006
     C                   ADD       1             X                                             CSE00
     C     X             OCCUR     MULT                                                        CSE00
      *                                                                   CSE006
     C                   ENDIF                                                                 CSE00
      *                                                                   CSE006
      *** Restore sequence value                                          CSE006
      *                                                                   CSE006
     C                   MOVE      SV@SEQ        WSEQ                                          CSE00
      *                                                                   CSE006
      *** Format :16S: - End of Block                                     CSE006
      *                                                                   CSE006
     C                   MOVEL     ':16S:'       MTAG                                          CSE00
      *                                                                   CSE006
      *** Access tag description                                          CSE006
      *                                                                   CSE006
     C                   EXSR      SRMTAG                                                      CSE00
      *                                                                   CSE006
     C                   MOVEL     'REPO'        MDAT                                          CSE00
     C                   MOVEL     MDAT          RDAT                                          CSE00
      *                                                                   CSE006
      *** Access the next occurence in MULT                               CSE006
      *                                                                   CSE006
     C                   ADD       1             X                                             CSE00
     C     X             OCCUR     MULT                                                        CSE00
      *                                                                   CSE006
     C                   ENDSR                                                                 CSE00
      *****************************************************************
      /TITLE SR/SRF19A
      *****************************************************************
      *                                                               *
      *  SRF19A - Subroutine to format tag :19A:                      *
      *                                                               *
      *  Called By: SRFAMT                                            *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRF19A        BEGSR
      *
      ** If WO16R workfield is 'Y', output tag :16R:
      *
     C     WO16R         IFEQ      'Y'
      *
      ** Format :16R: - Start of Block
      *
     C                   MOVEL     ':16R:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'AMT'         MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *                                                                                       CSW203
     C     CSW203        IFEQ      'Y'
      *                                                                                       CSW203
      ** S.W.I.F.T. 2001: Format 17B: Accrued Interest Flag                                   CSW203
      *                                                                                       CSW203
     C     WFLD07        IFEQ      ':SETT//'
     C     CSW201        IFEQ      'Y'
      *                                                                                       CSW203
     C     MGCPNR        IFNE      *ZEROS
     C                   MOVEL     ':17B:'       MTAG
     C                   EXSR      SRMTAG
     C                   MOVEL     ':ACRU//Y'    MDAT
     C                   MOVEL     MDAT          RDAT
      *                                                                                       CSW203
      ** Access the next occurence in MULT                                                    CSW203
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       CSW203
     C                   ELSE
      *                                                                                       CSW203
      ** Format :17B: - Instruction Override                                                  CSW203
      *                                                                                       CSW203
     C                   MOVEL     ':17B:'       MTAG
      *                                                                                       CSW203
      ** Access tag description                                                               CSW203
      *                                                                                       CSW203
     C                   EXSR      SRMTAG
      *                                                                                       CSW203
     C                   MOVEL     ':STAN//'     MDAT
      *                                                                                       CSW203
     C     MGSTAN        IFNE      *BLANKS
     C     MDAT          CAT       MGSTAN:0      MDAT
     C                   ELSE
     C     MDAT          CAT       'N':0         MDAT
     C                   ENDIF
      *                                                                                       CSW203
     C                   MOVEL     MDAT          RDAT
      *                                                                                       CSW203
      ** Access the next occurence in MULT                                                    CSW203
      *                                                                                       CSW203
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *                                                                                       CSW203
     C                   ENDIF
      *                                                                                       CSW203
     C                   ENDIF
      *                                                                                     MD019844
     C                   ENDIF
      *                                                                                       CSW203
      *
      ** Format :19A: - Amount
      *
     C                   MOVEL     ':19A:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
      ** Convert Amount to SWIFT format
      *
     C                   EXSR      SRCNVT
      *
     C                   MOVEL     WFLD07        MDAT
     C     W@AMNT        IFLT      *ZERO
     C***********MDAT      CAT  '-':0     MDAT                            140966
     C     MDAT          CAT       'N':0         MDAT                                          14096
     C                   ENDIF
     C     MDAT          CAT       WSWCD:0       MDAT
     C     MDAT          CAT       ZSAMT:0       MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
      ** If WO16S workfield is 'Y', output tag :16S:
      *
     C     WO16S         IFEQ      'Y'
      *
      ** Format :16S: - End of Block
      *
     C                   MOVEL     ':16S:'       MTAG
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
     C                   MOVEL     'AMT'         MDAT
     C                   MOVEL     MDAT          RDAT
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                       CSW203
      /TITLE SR/SRF94F                                                                        CSW203
      *****************************************************************                       CSW203
      *                                                               *                       CSW203
      *  SRF94F - Format Tag :94F:                                    *                       CSW203
      *                                                               *                       CSW203
      *****************************************************************                       CSW203
      *                                                                                       CSW203
     C     SRF94F        BEGSR
      *                                                                                       CSW203
     C                   MOVEL     MGTNUM        WKTNUM
      *                                                                                       CSW203
     C     WKTNUM        CHAIN     TRADSDY2                           48
      *                                                                                       CSW203
     C     *IN48         IFEQ      *OFF
      *                                                                                       CSW203
     C     T2SKAL        IFNE      *BLANKS
     C                   MOVEL     T2SKAL        WKACCT           35
     C                   ELSE
     C                   MOVEL     T2SKAN        WKACCT
     C                   ENDIF
      *                                                                                       CSW203
      ** Determine length of WKACCT                                                           CSW203
      *                                                                                       CSW203
     C                   Z-ADD     35            X1                3 0
     C                   MOVEA     WKACCT        WRKACT
     C********** WRKACT,X1 DOWEQ*BLANK                                                CSW203 BUG2381
     C********** X1        ANDGT0                                                     CSW203 BUG2381
     C     X1            DOWGT     0
     C     WRKACT(X1)    ANDEQ     *BLANK
     C                   SUB       1             X1
     C                   ENDDO
      *                                                                                       CSW203
     C                   MOVE      'N'           WFIN              1
     C                   Z-ADD     1             X2                3 0
      *                                                                                       CSW203
     C     X1            IFGT      4
      *                                                                                       CSW203
      ** Check if leading //XE or //XC is present                                             CSW203
      *                                                                                       CSW203
     C     WFIN          DOWNE     'Y'
     C     X2            ANDLE     35
      *                                                                                       CSW203
     C     WRKACT(X2)    IFEQ      *BLANK
     C                   ADD       1             X2
     C                   ENDIF
      *                                                                                       CSW203
     C     WRKACT(X2)    IFEQ      '/'
     C                   ADD       1             X2
     C     WRKACT(X2)    IFEQ      '/'
     C                   ADD       1             X2
     C     WRKACT(X2)    IFEQ      'X'
     C                   ADD       1             X2
     C     WRKACT(X2)    IFEQ      'E'
     C     WRKACT(X2)    OREQ      'C'
     C     35            SUB       X2            WS
     C                   ADD       1             X2
     C     X2            IFLE      35
     C     WS            SUBST     WKACCT:X2     WKACCT
     C                   ENDIF
     C                   MOVE      'Y'           WFIN
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'Y'           WFIN
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'Y'           WFIN
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'Y'           WFIN
     C                   ENDIF
      *                                                                                       CSW203
     C                   ENDDO
      *                                                                                       CSW203
     C                   ELSE
      *                                                                                       CSW203
      ** Check if leading / are present                                                       CSW203
      *                                                                                       CSW203
     C     WFIN          DOWNE     'Y'
     C     X2            ANDLE     35
      *                                                                                       CSW203
     C     WRKACT(X2)    IFNE      *BLANK
     C     WRKACT(X2)    ANDNE     '/'
     C                   MOVE      'Y'           WFIN
     C                   ELSE
     C                   ADD       1             X2
     C                   ENDIF
      *                                                                                       CSW203
     C                   ENDDO
      *                                                                                       CSW203
     C     X2            SUB       1             WX2               3 0
     C     WX2           IFGE      1
     C     35            SUB       WX2           WS
     C     X2            IFLE      35
     C     WS            SUBST     WKACCT:X2     WKACCT
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW203
     C                   ENDIF
      *                                                                                       CSW203
      ** Check if / is present within WKACCT                                                  CSW203
      *                                                                                       CSW203
     C     '/'           SCAN      WKACCT:1      WS                       47
      *                                                                                       CSW203
     C     *IN47         IFEQ      *ON
     C     36            SUB       WS            WSTART
     C     WSTART        SUBST     WKACCT:WS     WSAFEP           40
     C                   ELSE
     C                   MOVEL     *BLANKS       WSAFEP
     C                   ENDIF
      *                                                                                       CSW203
     C     WSAFEP        IFNE      *BLANKS
      *                                                                                       CSW203
     C                   MOVEA     WSAFEP        WRKSFE
      *                                                                                       CSW203
      ** Determine length of WSAFEP                                                           CSW203
      *                                                                                       CSW203
     C                   Z-ADD     40            X1
     C********** WRKSFE,X1 DOWEQ*BLANK                                                CSW203 BUG2381
     C********** X1        ANDGT0                                                     CSW203 BUG2381
     C     X1            DOWGT     0
     C     WRKSFE(X1)    ANDEQ     *BLANK
     C                   SUB       1             X1
     C                   ENDDO
      *                                                                                       CSW203
     C     X1            IFLT      6
     C                   MOVE      *BLANKS       WSAFEP
     C                   ENDIF
      *                                                                                       CSW203
     C                   MOVEL     WSAFEP        WSAFE4            4
      *                                                                                       CSW203
     C     WSAFE4        IFEQ      '/CU/'
     C                   MOVEL     '/CUST/'      WSAFE             6
     C     36            SUBST     WSAFEP:5      WKSAFE           40
     C     WSAFE         CAT       WKSAFE:0      WSAFEP
     C                   ENDIF
      *                                                                                       CSW203
     C     WSAFE4        IFEQ      '/IC/'
     C                   MOVEL     '/ICSD/'      WSAFE
     C     36            SUBST     WSAFEP:5      WKSAFE
     C     WSAFE         CAT       WKSAFE:0      WSAFEP
     C                   ENDIF
      *                                                                                       CSW203
     C     WSAFE4        IFEQ      '/NC/'
     C                   MOVEL     '/NCSD/'      WSAFE
     C     36            SUBST     WSAFEP:5      WKSAFE
     C     WSAFE         CAT       WKSAFE:0      WSAFEP
     C                   ENDIF
      *                                                                                       CSW203
     C     WSAFE4        IFEQ      '/SH/'
     C                   MOVEL     '/SHHE/'      WSAFE
     C     36            SUBST     WSAFEP:5      WKSAFE
     C     WSAFE         CAT       WKSAFE:0      WSAFEP
     C                   ENDIF
      *                                                                                       CSW203
     C                   MOVEL     ':94F:'       MTAG
      *                                                                                       CSW203
      ** Access tag description                                                               CSW203
      *                                                                                       CSW203
     C                   EXSR      SRMTAG
      *                                                                                       CSW203
     C     ':SAFE/'      CAT       WSAFEP:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *                                                                                       CSW203
      ** Access the next occurence in MULT                                                    CSW203
      *                                                                                       CSW203
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *                                                                                       CSW203
     C                   ENDIF
      *                                                                                       CSW203
     C                   ENDIF
      *                                                                                       CSW203
     C                   ENDSR
      *                                                                                       CSW203
      *****************************************************************
      /TITLE SR/SRCNVT
      *****************************************************************
      *                                                               *
      *  SRCNVT - Convert amount to SWIFT format                      *
      *                                                               *
      *  Called By: SRFAMT                                            *
      *  Calls    : ZM1240                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRCNVT        BEGSR
      *
     C                   Z-ADD     W@AMNT        ZAMT             13 0
     C                   MOVEL     W@CYCD        ZCCY              3
     C                   MOVE      *BLANKS       ZSAMT            17
     C                   MOVE      *BLANKS       ZOAMT            21
     C                   MOVE      *BLANKS       ZSCCY             3
     C                   MOVE      *BLANKS       ZERR
      *
     C                   CALL      'ZM1240'                             25
     C                   PARM                    ZAMT
     C                   PARM                    ZCCY
     C                   PARM                    ZSAMT
     C                   PARM                    ZOAMT
     C                   PARM                    ZSCCY
     C                   PARM                    ZERR
      *
      ** If program not found, perform DB Error processing
      *
     C     *IN25         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     020           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 020 *
     C                   MOVEL     'ZM1240'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If an error occured in ZM1240, then,
      **    Move 'Y' @ERR workfield to indicate error while
      **    formatting and format MULT/MERR field
      *
     C     ZERR          IFEQ      '1'
     C                   MOVEL     'Y'           @ERR
     C                   MOVEL     ERRA(9)       MERR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRPERR
      *****************************************************************
      *                                                               *
      *  SRPERR - Print message in error                              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRPERR        BEGSR
      *
      ** Initialise fields used in report
      *
     C                   CLEAR                   TEXT2
      *
      ** Open printer file
      *
     C     *IN60         IFEQ      *OFF
     C                   OPEN      MG051NA2
     C                   MOVE      '1'           *IN60
     C                   ENDIF
      *
      ** Format Message Type
      *
     C                   MOVEL     MGMTYP        R2MTYP
      *
      ** Format Trade Reference
      *
     C                   MOVEL     MGTNUM        R2REFE
      *
      ** Format Trade Type
      *
     C                   MOVEL     MGTSTP        R2TYP1
      *
      ** Format Trade Type Description
      *
     C     MGTSTP        IFEQ      'TS'
     C                   MOVEL     TYPA(1)       R2TYP2
     C                   ELSE
     C     MGTSTP        IFEQ      'TP'
     C                   MOVEL     TYPA(2)       R2TYP2
     C                   ENDIF
     C                   ENDIF
      *
      ** Format Sender Branch
      *
     C                   MOVEL     MGSNBR        R2SND1
      *
      ** Format Sender Customer Number
      *
     C                   MOVEL     @SNDR         R2SND2
      *
      ** Format Sender Network Address
      *
     C                   MOVEL     @NWSN         R2SND3
      *
      ** Format Destination Customer Number
      *
     C**********           Z-ADDMGDEST    R2DES1                                              CSD027
     C                   MOVE      MGDEST        R2DES1
      *
      ** Format Destination Network Address
      *
     C                   MOVEL     @NWDS         R2DES2
      *
      ** Format Destination error message
      *
     C                   MOVEL     DSERR         R2EMSG
      *
      ** Format Network
      *
     C                   MOVEL     @NWRK         R2NETW
      *
      ** Format Network Error message
      *
     C                   MOVEL     NWERR         R2NWER
      *
      ** Format Module Id
      *
     C                   MOVEL     MGMODI        R2MODI
      *
      ** Format Transaction Number
      *
     C                   MOVEL     MGTNUM        R2TNUM
      *
      ** Format Message Priority
      *
     C                   MOVEL     'N'           R2PRTY
      *
      ** Write the header and the main text for the report
      *
     C                   WRITE     HEADER2
     C                   WRITE     TEXT2
      *
      ** Process Multiple Occcurence Date Structure
      *
     C                   Z-ADD     0             I                 2 0
     C     I             DOWLE     X
      *
     C                   ADD       1             I
     C     I             OCCUR     MULT
      *
      ** Write a detail line to the report checking for overlfow
      *
     C     WWOFL2        SUB       WWPTL2        WWLINE            2 0
      *
     C     WWLINE        IFLT      3
     C                   WRITE     HEADER2
     C                   ENDIF
      *
     C                   WRITE     LINE2
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SROMSG
      *****************************************************************
      *                                                               *
      *  SROMSG - Output to MGOMSGPD                                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SROMSG        BEGSR
      *
      ** Initialise fields on PF/MGOREFPD
      *
     C                   CLEAR                   MGOREFD0
      *
      ** History Retention Date
      *
     C     MGVDAT        ADD       ENDSMN        WWHDAT            5 0
     C                   MOVE      WWHDAT        ZMDAY             5 0
     C                   MOVE      *BLANKS       ZSDATE            6
      *
     C                   CALL      'ZM0060'                             22
     C                   PARM                    ZMDAY
     C                   PARM                    ZSDATE
      *
      ** If program not found, perform DB Error processing
      *
     C     *IN22         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     029           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 029 *
     C                   MOVEL     'ZM0060'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set history retention date to output field
      *
     C                   MOVEL     ZSDATE        HRDT
      *
      ** Message generation date
      *
     C                   MOVE      BJRDNB        ZMDAY
     C                   MOVE      *BLANKS       ZSDATE
      *
     C                   CALL      'ZM0060'                             22
     C                   PARM                    ZMDAY
     C                   PARM                    ZSDATE
      *
      ** If program not found, perform DB Error processing
      *
     C     *IN22         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     030           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 030 *
     C                   MOVEL     'ZM0060'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set message generated date to output field
      *
     C                   MOVEL     ZSDATE        MGDE
      *
      ** Setup CIND to determine in which century the generation                              196628
      ** date falls - current or succeeding                                                   196628
      *                                                                                       196628
     C                   MOVEL     MGDE          YY                2 0
     C     YY            IFLT      72
     C                   MOVE      '2'           CIND
     C                   ELSE
     C                   MOVE      '1'           CIND
     C                   ENDIF
      *                                                                                       196628
      ** Convert Settlement Amount to SWIFT format
      *
     C                   Z-ADD     MGSTAM        ZAMT
     C                   MOVEL     MGSTCY        ZCCY
     C                   MOVE      *BLANKS       ZSAMT
     C                   MOVE      *BLANKS       ZOAMT
     C                   MOVE      *BLANKS       ZSCCY
     C                   MOVE      *BLANKS       ZERR
      *
     C                   CALL      'ZM1240'                             25
     C                   PARM                    ZAMT
     C                   PARM                    ZCCY
     C                   PARM                    ZSAMT
     C                   PARM                    ZOAMT
     C                   PARM                    ZSCCY
     C                   PARM                    ZERR
      *
      ** If program not found, perform DB Error processing
      *
     C     *IN25         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     031           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 031 *
     C                   MOVEL     'ZM1240'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If error occured in ZM1240, perform DB Error processing
      *
     C     ZERR          IFEQ      '1'
     C                   Z-ADD     ZAMT          WWAMT
     C     *LOCK         IN        LDA
     C                   Z-ADD     032           DBASE                          * * * * * * * *
     C                   MOVEL     DBERR2        DBKEY                          *DB ERROR 032 *
     C                   MOVEL     'ZM1240'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set SWIFT amount to output field
      *
     C                   MOVEL     ZSAMT         AMTS
      *
      ** Format fields on PF/MGOREFPD
      *
     C                   EXSR      SROREF
      *                                                                                       202330
      ** Setup CINDV to determine in which century the generation                             202330
      ** date falls - current or succeeding                                                   202330
      *                                                                                       202330
     C     SVDT          IFNE      *BLANKS
      *                                                                                       202330
     C                   MOVEL     SVDT          YY                2 0
     C     YY            IFLT      72
     C                   MOVE      '2'           CINDV
     C                   ELSE
     C                   MOVE      '1'           CINDV
     C                   ENDIF
      *                                                                                       202330
     C                   ENDIF
      *                                                                                       202330
     C/COPY WNCPYSRC,MG051NC003
      *
      ** Write record to PF/MGOREFPD
      *
     C                   MOVEL     MGCHG         AORR
     C                   WRITE     MGOREFD0                             62
      *
      ** If error on write of record, perform DB Error processing
      *
     C     *IN62         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     033           DBASE                          * * * * * * * *
     C                   MOVEL     MGTNUM        DBKEY                          *DB ERROR 033 *
     C                   MOVEL     'MGOREFPD'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MGF51N'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Process Multiple Occurence Data Structure
      *
     C                   Z-ADD     1             Y                 2 0
     C     Y             DOWLT     X
      *
     C     Y             OCCUR     MULT
      *
      ** Format fields on PF/MGOMSGPD
      *
     C                   MOVEL     MDAT          MFLD
     C                   MOVE      *BLANKS       PTDL
      *
      ** Write record to PF/MGOMSGPD
      *
     C                   WRITE     MGOMSGD0                             61
      *
      ** If error on write of record, perform DB Error processing
      *
     C     *IN61         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     028           DBASE                          * * * * * * * *
     C                   MOVEL     MGTNUM        DBKEY                          *DB ERROR 028 *
     C                   MOVEL     'MGOMSGPD'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0510'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Increment MULT index
      *
     C                   ADD       1             Y
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SROREF
      *****************************************************************
      *                                                               *
      *  SROREF - Format fields on PF/MGOREFPD                        *
      *                                                               *
      *  Called By: SR/SROMSG                                         *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SROREF        BEGSR
      *
     C                   MOVEL     MGMODI        MODI
     C                   MOVEL     WWMDAT        TRNO
     C                   MOVEL     MGTNUM        MTRN
     C                   MOVEL     MGTTYP        TNTP
     C                   MOVEL     MGTSTP        SBTP
     C                   MOVEL     @NWRK         NWRK
     C                   MOVEL     A8BICN        SECN
     C                   MOVEL     @NWSN         NWSN
     C**********           Z-ADDMGDEST    DECN                                                CSD027
     C                   MOVE      MGDEST        DECN
     C                   MOVEL     @NWDS         NWDS
     C                   MOVEL     MGDSSN        NWBN
     C                   MOVEL     MGMTYP        MTPY
     C                   MOVEL     'N'           MPRY
      *
     C                   EXSR      SRSTAT
      *                                                                                       CSD015
      ** Check if message type exists in the watch list                                       CSD015
      *                                                                                       CSD015
     C     CSD015        IFEQ      'Y'
     C     W1EWLC        ANDEQ     'Y'
     C     CSW025        ANDEQ     'N'
     C                   EXSR      SRWTCH
     C                   ENDIF
      *
     C                   TIME                    MGTM
     C                   MOVEL     BJMRDT        LADT
     C                   TIME                    LATM
     C                   MOVEL     WWDATE        SVDT
     C                   MOVEL     MGSNBR        BRCA
     C                   MOVEL     MGSTCY        CCY
     C                   MOVEL     'Y'           TSKS
      *
     C                   ENDSR
     C/COPY WNCPYSRC,MG051NC004
      *****************************************************************
      /TITLE SR/SRSTAT
      *****************************************************************
      *                                                               *
      *  SRSTAT - Determine message status                            *
      *                                                               *
      *  Called By: SR/SROMSG                                         *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRSTAT        BEGSR
      *
      ** Reset status array
      *
     C                   CLEAR                   @ST
      *
      ** Set key to destination customer number
      *
     C                   MOVEL(P)  DECN          @KEY
      *
      ** Get customer details via access object
      *
     C*********************CALL 'AOCUSTR0'                                                    CSW036
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEY             10
     C                   PARM      *BLANKS       @KYST             7
     C***********SDCUST    PARM SDCUST    DSSDY                                               CSW036
     C     SDCUST        PARM      SDCUST        DSLDY
      *
      ** Fill status array
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBDS01        @ST(1)
     C                   MOVEL     BBDS02        @ST(2)
     C                   MOVEL     BBDS03        @ST(3)
     C                   MOVEL     BBDS04        @ST(4)
     C                   MOVEL     BBDS05        @ST(5)
     C                   MOVEL     BBDS06        @ST(6)
     C                   MOVEL     BBDS07        @ST(7)
     C                   MOVEL     BBDS08        @ST(8)
     C                   MOVEL     BBDS09        @ST(9)
     C                   MOVEL     BBDS10        @ST(10)
     C                   MOVEL     BBDS11        @ST(11)
     C                   MOVEL     BBDS12        @ST(12)
     C                   MOVEL     BBDS13        @ST(13)
     C                   MOVEL     BBDS14        @ST(14)
     C                   MOVEL     BBDS15        @ST(15)
     C                   ENDIF
      *
      ** Is the message type in the array? Set on *IN60 if it is.
      *
     C     '510'         LOOKUP    @ST                                    53
     C  N53'51*'         LOOKUP    @ST                                    53
     C  N53'5**'         LOOKUP    @ST                                    53
      *
      ** If found, set status to 'ready to send', else set to 'created'
      *
     C     *IN53         IFEQ      *ON
     C                   MOVEL     'RSND'        MGST
     C                   MOVEL     '2'           MGSG
     C                   ELSE
     C                   MOVEL     'CRTD'        MGST
     C                   MOVEL     '1'           MGSG
     C                   ENDIF
      *                                                                                     BUG25073
     C     CSW025        IFEQ      'Y'
     C                   MOVEL     'RSND'        MGST
     C                   MOVEL     '2'           MGSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRPGEN
      *****************************************************************
      *                                                               *
      *  SRPGEN - Print message generated details                     *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRPGEN        BEGSR
      *
      ** Initialise fields used in report
      *
     C                   CLEAR                   TEXT1
      *
      ** Format Message Type
      *
     C                   MOVEL     MGMTYP        R1MTYP
      *
      ** Format Trade Reference
      *
     C                   MOVEL     MGTNUM        R1REFE
      *
      ** Format Trade Type
      *
     C                   MOVEL     MGTSTP        R1TYP1
      *
      ** Format Trade Type Description
      *
     C     MGTSTP        IFEQ      'TS'
     C                   MOVEL     TYPA(1)       R1TYP2
     C                   END
      *
     C     MGTSTP        IFEQ      'TP'
     C                   MOVEL     TYPA(2)       R1TYP2
     C                   END
      *
      ** Format Sender Branch
      *
     C                   MOVEL     MGSNBR        R1SND1
      *
      ** Format Sender Customer Number
      *
     C                   MOVEL     @SNDR         R1SND2
      *
      ** Format Sender Network Address
      *
     C                   MOVEL     @NWSN         R1SND3
      *
      ** Format Sender Report Name
      *
     C                   MOVEL     @SRNM         R1SRNM
      *
      ** Format Sender Report Town
      *
     C                   MOVEL     @SRTN         R1SRTN
      *
      ** Format Destination Report Name
      *
     C                   MOVEL     @DRNM         R1DRNM
      *
      ** Format Destination Report Town
      *
     C                   MOVEL     @DRTN         R1DRTN
      *
      ** Format Message Priority
      *
     C                   MOVEL     'N'           R1PRTY
      *
      ** Format Destination Customer Number
      *
     C**********           Z-ADDMGDEST    R1DES1                                              CSD027
     C                   MOVE      MGDEST        R1DES1
      *
      ** Format Destination Network Address
      *
     C                   MOVEL     @NWDS         R1DES2
      *
      ** Format Network
      *
     C                   MOVEL     @NWRK         R1NETW
      *
      ** Write the Header and the main test for the report
      *
     C                   WRITE     HEADER1
     C                   WRITE     TEXT1
      *
      ** Process Multiple Occurrence Data Structure
      *
     C                   Z-ADD     0             I                 2 0
     C     I             DOWLE     X
      *
     C                   ADD       1             I
     C     I             OCCUR     MULT
      *
      ** Write a detail line to the report checking for overflow
      *
     C     WWOFL1        SUB       WWPTL1        WWLINE
      *
     C     WWLINE        IFLT      3
     C                   WRITE     HEADER1
     C                   ENDIF
      *
     C                   WRITE     LINE1
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRF95
      *****************************************************************
      *                                                               *
      *  SRF95  - Format field :95a:                                  *
      *                                                               *
      *  Called By: SR/SR5SPY                                         *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRF95         BEGSR
      *
      ** Note that ZDEST must be set up before calling this subroutine
      *
     C                   MOVE      *BLANKS       ZSADD1           35
     C                   MOVE      *BLANKS       ZSADD2           35
     C                   MOVE      *BLANKS       ZSADD3           35
     C                   MOVE      *BLANKS       ZSADD4           35
     C                   MOVE      *BLANKS       ZSTAG             1
     C                   MOVE      *BLANKS       ZSTYPE            1
     C                   MOVE      *BLANKS       ZERR              1
     C                   MOVE      *BLANKS       ZCRNM            20
     C                   MOVE      *BLANKS       ZCRTN            10
      *
     C*********************CALL 'ZM1150'               26                                     CSW036
     C                   CALL      'ZM1151'                             26
     C                   PARM                    ZDEST
     C                   PARM                    ZSADD1
     C                   PARM                    ZSADD2
     C                   PARM                    ZSADD3
     C                   PARM                    ZSADD4
     C                   PARM                    ZSTAG
     C                   PARM                    ZSTYPE
     C                   PARM                    ZERR
     C                   PARM                    ZCRNM
     C                   PARM                    ZCRTN
     C                   PARM                    ZDBEI             1
      *                                                                                     AR581757
      ** Clear ZDEST field                                                                  AR581757
      *                                                                                     AR581757
     C                   MOVE      *BLANKS       ZDEST
      *
      ** If program not found, perform DB Error processing
      *
     C     *IN26         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     019           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 019 *
     C*********************MOVEL'ZM1150'  DBPGM            * * * * * *                        CSW036
     C                   MOVEL     'ZM1151'      DBPGM                          * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If an error occured in ZM1150
      *
     C     ZERR          IFEQ      '1'
      *
     C                   MOVEL     ERRA(4)       MERR
     C                   MOVE      'Y'           @ERR
      *
      ** Access the next occurence in MULT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   ELSE
      *
      ** If ZSTAG is 'A'
      *
     C     ZSTAG         IFEQ      'A'
     C                   MOVEL     ':95P:'       MTAG
     C                   ENDIF
      *
      ** If ZSTAG is 'D'
      *
     C     ZSTAG         IFEQ      'D'
     C                   MOVEL     ':95Q:'       MTAG
     C                   ENDIF
      *
      ** Access tag description
      *
     C                   EXSR      SRMTAG
      *
      ** Format Addresses
      *
     C                   EXSR      SR#ZA
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SR#ZA
      *****************************************************************
      *                                                               *
      *  SR#ZA  - Format Addresses                                    *
      *                                                               *
      *  Called By: SR/SRF95                                          *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SR#ZA         BEGSR
      *
      ** If ZSADD1 is not blank
      *
     C     ZSADD1        IFNE      *BLANKS
     C     WMDAT         CAT       ZSADD1:0      MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *
      ** If ZSADD2 is not blank
      *
     C     ZSADD2        IFNE      *BLANKS
     C                   MOVEL     ZSADD2        MDAT
     C                   MOVEL     WSEQ          MSEQ
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *
      ** If ZSADD3 is not blank
      *
     C     ZSADD3        IFNE      *BLANKS
     C                   MOVEL     ZSADD3        MDAT
     C                   MOVEL     WSEQ          MSEQ
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *
      ** If ZSADD4 is not blank
      *
     C     ZSADD4        IFNE      *BLANKS
     C                   MOVEL     ZSADD4        MDAT
     C                   MOVEL     WSEQ          MSEQ
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRSWCY
      *****************************************************************
      *                                                               *
      *  SRSWCY - Retrieve the SWIFT currency code                    *
      *                                                               *
      *  Called By: SR/SRCDET                                         *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRSWCY        BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM                    WCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Database Error in SDCURRPD
      *
     C     WRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     011           DBASE                          ***************
     C                   MOVEL     'SDCURRPD'    DBFILE                         *DB ERROR 011 *
     C                   MOVEL     WCYCD         DBKEY                          ***************
     C                   MOVEL     'MG051N'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRCRTN
      *****************************************************************
      *                                                               *
      *  SRCRTN - Subroutine to output Certificate Numbers (:13B:)    *
      *                                                               *
      *  Called By: SRCDET                                            *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRCRTN        BEGSR
      *
     C                   MOVEL     MGTNUM        KTDRF
     C     KCRTN         CHAIN     SECRTNL1                           54
     C     *IN54         DOWEQ     *OFF
      *
     C     CNRNG2        SUB       CNRNG1        WDIFF             6 0
      *
     C     WDIFF         DOULT     *ZERO
      *
     C                   MOVEL     ':13B:'       MTAG
     C                   EXSR      SRMTAG
      *
     C     CNRNG2        SUB       WDIFF         W@RNGN            6 0
     C                   MOVE      W@RNGN        W@RNGA            6
      *
     C     ':CERT//'     CAT       CNSERI:0      MDAT
     C     MDAT          CAT       '.':0         MDAT
     C     MDAT          CAT       W@RNGA:0      MDAT
     C                   MOVEL     MDAT          RDAT
      *
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *
     C                   SUB       1             WDIFF
     C                   ENDDO
      *
     C     KCRTN         READE     SECRTNL1                               54
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRMTAG
      *****************************************************************
      *                                                               *
      *  SRMTAG - Access tag/field description details                *
      *                                                               *
      *  Called By:                                                   *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRMTAG        BEGSR
      *
      ** CASE #1: XXXXX, XXX, XXX
      *
     C                   MOVE      MGMTYP        KTYP
     C                   MOVE      WSEQ          KSEQ
      *
     C*****KMTAG         CHAIN     SDMTAGL0                           51                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAG   and EFMTPY = :KTYP   and EFMSEQ = :KSEQ                      MD056560
     C/END-EXEC                                                                             MD056560
      *
      ** CASE #2: XXXXX, XXX, ___
      *
     C******IN51         IFEQ      *ON                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
      *
     C                   MOVE      MGMTYP        KTYP
     C                   MOVE      *BLANK        KSEQ
     C*****KMTAG         CHAIN     SDMTAGL0                           51                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAG   and EFMTPY = :KTYP   and EFMSEQ = :KSEQ                      MD056560
     C/END-EXEC                                                                             MD056560
      *
     C                   ENDIF
      *
      ** CASE #3: XXXXX, ALL, XXX
      *
     C******IN51         IFEQ      *ON                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
      *
     C                   MOVE      'ALL'         KTYP
     C                   MOVE      WSEQ          KSEQ
     C*****KMTAG         CHAIN     SDMTAGL0                           51                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAG   and EFMTPY = :KTYP   and EFMSEQ = :KSEQ                      MD056560
     C/END-EXEC                                                                             MD056560
      *
     C                   ENDIF
      *
      ** CASE #4: XXXXX, ALL, ___
      *
     C******IN51         IFEQ      *ON                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
      *
     C                   MOVE      'ALL'         KTYP
     C                   MOVE      *BLANK        KSEQ
     C*****KMTAG         CHAIN     SDMTAGL0                           51                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAG   and EFMTPY = :KTYP   and EFMSEQ = :KSEQ                      MD056560
     C/END-EXEC                                                                             MD056560
      *
     C                   ENDIF
      *
      ** If found, Move ISO field Desc to MULT/MDES
      *
     C******IN51         IFEQ      *OFF                                                     MD056560
     C                   IF        SQLCODE = 0                                              MD056560
      *
     C                   MOVEL     EFISFD        MDES
      *
      ** Otherwise, Move '<Tag Description not found>' MULT/MERR
      *
     C                   ELSE
      *
     C                   MOVEL     ERRA(8)       MERR
      *
     C                   ENDIF
      *
      ** Move Message Sequence (WSEQ) to MULT/MSEQ
      *
     C                   MOVE      WSEQ          MSEQ
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRUPDT
      *****************************************************************
      *                                                               *
      *  SRUPDT - Update transaction record                           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRUPDT        BEGSR
      *
      **   ... update sequence number on TRADSD/DPTMVD
      *
      **   Obtain Sequence Numbers from transaction record
      **   format @TRAN as follows:
      **     Chars 01-06 equal to leftmost 6 chars from MGTNUM
      **     Chars 07-13 equal to blanks
      **     Chars 14-15 equal to MGTTYP
      *
     C                   MOVE      *BLANKS       WWTRAN           15
     C                   MOVE      *BLANKS       WWFL06            6
     C                   MOVEL     MGTNUM        WWFL06
     C                   MOVEL     WWFL06        WWTRAN
     C                   MOVE      MGTTYP        WWTRAN
      *
     C                   CALL      'MG5900'                             21
     C                   PARM      MGMODI        @MODI             2
     C                   PARM      WWTRAN        @TRAN            15
     C                   PARM      'CE'          @PROG             2
     C                   PARM      'U'           @MODE             1
     C                   PARM      *ZEROS        @LSWS             7 0
     C                   PARM      *BLANKS       @ERCD             1
     C                   PARM                    CSW003
      *
      ** If program not found, perform DB Error processing
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     039           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 039 *
     C                   MOVEL     'MG5900'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If an error occurred in MG5900, perform DB Error processing
      *
     C     @ERCD         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   MOVEL     @TRAN         WW0317
     C                   Z-ADD     035           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 040 *
     C                   MOVEL     DBERR         DBKEY                          * * * * * * * *
     C                   MOVEL     'MG5900'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **   ... update confirmation generated indicator
      *
      **   Obtain Generation Generated Indicator format @TREF as follows:
      **     Chars 01-06 equal to leftmost 6 chars from MGTNUM
      **     Chars 07-13 equal to blanks
      **     Chars 14-15 equal to MGTTYP
      *
     C                   MOVE      *BLANKS       WWTREF           15
     C                   MOVE      *BLANKS       WWFL06            6
     C                   MOVEL     MGTNUM        WWFL06
     C                   MOVEL     WWFL06        WWTREF
     C                   MOVE      MGTTYP        WWTREF
      *
     C                   CALL      'MG5910'                             22
     C                   PARM      MGMODI        @MODI             2
     C                   PARM      WWTREF        @TREF            15
     C                   PARM      'CE'          @PROG             2
     C                   PARM      'U'           @MODE             1
     C                   PARM      *BLANKS       @CONG             1
     C                   PARM      *BLANKS       @RCDG             1
     C                   PARM      *BLANKS       @ERCD             1
     C                   PARM                    CSW003
      *
      ** If program not found, perform DB Error processing
      *
     C     *IN22         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     035           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 041 *
     C                   MOVEL     'MG5910'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If an error occured in MG5910, perform DB Error processing
      *
     C     @ERCD         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   MOVEL     @TREF         WW0317
     C                   Z-ADD     037           DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *DB ERROR 0042*
     C                   MOVEL     DBERR         DBKEY                          * * * * * * * *
     C                   MOVEL     'MG5910'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                       CSW207
      /TITLE SR/SRMFID                                                                        CSW207
      *****************************************************************                       CSW207
      *                                                               *                       CSW207
      *  SRMFID - Subroutine to check if Sending Branch and Customer  *                       CSW207
      *           are MiFID compliant                                 *                       CSW207
      *                                                               *                       CSW207
      *****************************************************************                       CSW207
      *                                                                                       CSW207
     C     SRMFID        BEGSR
     C                   MOVEL     'N'           WBRCA
     C                   MOVEL     'N'           WDEST
     C                   MOVEL     'N'           WMFID
      *                                                                                       CSW207
      ** Check if sending branch is MFID Compliant                                            CSW207
      *                                                                                       CSW207
     C     MGSNBR        IFNE      *BLANKS
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG   '     WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      MGSNBR        WBRCH             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *                                                                                       CSW207
      ** Database Error                                                                       CSW207
      *                                                                                       CSW207
     C     WRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     025           DBASE                          ***************
     C                   MOVEL     'SDBRCHPD'    DBFILE                         *DB ERROR 025 *
     C                   MOVE      WBRCH         DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSW207
      ** If location code is not blank, check location code.                                  261402
      ** Otherwise, flag sending branch as not MiFID compliant.                               261402
      *                                                                                       261402
     C     A8LCCD        IFNE      *BLANKS
      *                                                                                       261402
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      A8LCCD        @LOCN             3
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CSW207
      ** Database error proceesing                                                            CSW207
      *                                                                                       CSW207
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     047           DBASE                          ***************
     C                   MOVEL     'SDLOCNPD'    DBFILE                         *DB ERROR 047 *
     C                   MOVE      @LOCN         DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSW207
     C*****DVCNCD        CHAIN     MEISOCL1                           56                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :DVCNCD                                                              MD058081
     C/END-EXEC                                                                             MD058081
     C******IN56         IFEQ      '1'                                                      MD058081
     C     SQLCODE       IFNE      0                                                        MD058081
     C     *LOCK         IN        LDA
     C                   Z-ADD     048           DBASE                          ***************
     C                   MOVEL     'MEISOCPD'    DBFILE                         *DB ERROR 048 *
     C                   MOVE      DVCNCD        DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C     M3MFID        IFEQ      'Y'
     C                   MOVEL     'Y'           WBRCA
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      ** Check if Destination Customer is MiFID compliant                                     CSW207
      *                                                                                       CSW207
     C     MGDEST        IFNE      *ZEROS
     C                   MOVE      MGDEST        WCUST
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCUST         @KEY
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      SDCUST        DSLDY
      *                                                                                       CSW207
      ** Database Error                                                                       CSW207
      *                                                                                       CSW207
     C     WRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     049           DBASE                          ***************
     C                   MOVEL     'SDCUSTPD'    DBFILE                         *DB ERROR 049 *
     C                   MOVE      @KEY          DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSW207
     C*****BBCOLC        CHAIN     MEISOCL1                           56                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :BBCOLC                                                              MD058081
     C/END-EXEC                                                                             MD058081
     C******IN56         IFEQ      '1'                                                      MD058081
     C     SQLCODE       IFNE      0                                                        MD058081
     C     *LOCK         IN        LDA
     C                   Z-ADD     053           DBASE                          ***************
     C                   MOVEL     'MEISOCPD'    DBFILE                         *DB ERROR 053 *
     C                   MOVE      BBCOLC        DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C     M3MFID        IFEQ      'Y'
     C                   MOVEL     'Y'           WDEST
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW207
      ** Retrieve the classification of the customer                                          CSW207
      *                                                                                       CSW207
     C                   MOVE      MGDEST        WCUST
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCUST         @KEY
     C     SDSECS        PARM      SDSECS        DSSDY
      *                                                                                       CSW207
      ** Database Error                                                                       CSW207
      *                                                                                       CSW207
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     026           DBASE                          ***************
     C                   MOVEL     'SDSECSPD'    DBFILE                         *DB ERROR 026 *
     C                   MOVE      @KEY          DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSW207
      ** Check if both are MiFID compliant                                                    CSW207
      *                                                                                       CSW207
     C     WBRCA         IFEQ      'Y'
     C     WDEST         ANDEQ     'Y'
     C                   MOVEL     'Y'           WMFID
     C                   ENDIF
      *                                                                                       CSW207
     C                   ENDSR
      *****************************************************************                       CSW207
     C/EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  SRWTCH - Watch Processing                                    *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
      *                                                                                       CSD015
     C     SRWTCH        BEGSR
      *                                                                                       CSD015
      ** Check if message is for automatic release.                                           CSD015
      ** If yes, default to CRTD status and set Automatic Release Flag to 'Y'                 CSD015
      *                                                                                       CSD015
     C                   MOVE      'N'           PARLS             1
     C     MGST          IFEQ      'RSND'
     C     NWRK          IFEQ      'SWIFT '
     C     NWRK          OREQ      'TELEX '
     C     NWRK          OREQ      'STTX  '
     C                   MOVE      'CRTD'        MGST
     C                   MOVE      '1'           MGSG
     C                   MOVE      'Y'           PARLS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD015
     C                   CLEAR                   WLTDS
     C                   MOVE      *BLANKS       PSTRNG
     C                   MOVE      *ZEROS        W4VDAT
     C                   MOVE      *ZEROS        W4MDAT
     C                   MOVE      *ZEROS        W4AMT1
     C                   MOVE      *ZEROS        W4AMT2
      *                                                                                       CSD015
      ** Setup parameters for Compliance engine program                                       CSD015
      *                                                                                       CSD015
     C                   MOVEL     TRNO          W4IDEN
     C                   MOVEL     MTPY          W4ITEM
     C                   MOVEL     MGSNBR        W4BRCH
     C                   MOVEL     'MGOREF'      W4FUNT
     C                   MOVEL     DECN          W4CNUM
     C                   Z-ADD     BJRDNB        W4DDAT
     C                   MOVEL     PARLS         W4ARLS
      *                                                                                       CSD015
      ***Send*transaction*to compliance engine program                                 CSD015 221145
      *********************                                                            CSD015 221145
     C*********************CALL 'SDWLCLOP'                                             CSD015 221145
     C*********************PARM           WLTDS                                        CSD015 221145
     C*********************PARM *BLANKS   PSTRNG                                       CSD015 221145
      *                                                                                       CSD015
     C     EWATCH        ENDSR
      *                                                                                       CSD015
     C/EJECT                                                                                  221145
      *****************************************************************                       221145
      *                                                               *                       221145
      *  WLCDQ - Submit information to Watch List Check Dtaq          *                       221145
      *                                                               *                       221145
      *****************************************************************                       221145
      *                                                                                       221145
     C     WLCDQ         BEGSR
      *                                                                                       221145
      *  Send transaction to compliance engine program                                        221145
      *                                                                                       221145
     C                   CALL      'SDWLCLOP'
     C                   PARM                    WLTDS
     C                   PARM      *BLANKS       PSTRNG
      *                                                                                       221145
      *                                                                                       221145
     C                   ENDSR
      *                                                                                       221145
      *****************************************************************                       CSD015
      *****************************************************************                     BUG19304
      /TITLE SR/SRLCTM                                                                      BUG19304
      *****************************************************************                     BUG19304
      *                                                               *                     BUG19304
      *  SRLCTM - Subroutine to get local time and offset if Market   *                     BUG19304
      *           is not present                                      *                     BUG19304
      *                                                               *                     BUG19304
      *****************************************************************                     BUG19304
      *                                                                                     BUG19304
     C     SRLCTM        BEGSR
      *                                                                                     BUG19304
     C                   CALL      'ZA0140'
     C                   PARM      MGTDAT        SSDAYN            5 0
     C                   PARM      BJDFIN        SSDFMT            1
     C                   PARM      *ZERO         SSDATE            6 0
     C                   PARM      *BLANKS       SSDATA            7
     C                   PARM      *BLANKS       SSRTN             1
     C                   PARM      *ZERO         SSDAT8            8 0
     C                   MOVE      SSDATE        ZSDATE
      *                                                                                     BUG19304
      ** Get system offset                                                                  BUG19304
      *                                                                                     BUG19304
     C                   MOVEL     *BLANKS       WSYOF             4
     C                   MOVEL     *BLANKS       WSYSG             1
     C                   CALL      PGMF
     C                   PARM      '05'          POPTYP            2
     C                   PARM      ZSDATE        PDATE1            6
     C                   PARM      *BLANKS       PTIME1            6
     C     WSYSG         PARM      *BLANKS       PSIGN1            1
     C     WSYOF         PARM      *BLANKS       POFFS1            4
     C                   PARM      *BLANKS       PDATE2            6
     C                   PARM      *BLANKS       PTIME2            6
     C                   PARM      *BLANKS       PSIGN2            1
     C                   PARM      *BLANKS       POFFS2            4
     C                   PARM      *BLANKS       PBRCH             3
     C                   PARM      *BLANKS       PMICD             3
      *                                                                                     BUG19304
      ** Get branch offset                                                                  BUG19304
      *                                                                                     BUG19304
     C                   MOVEL     *BLANKS       WBROF             4
     C                   MOVEL     *BLANKS       WBRSG             1
     C                   CALL      PGMF
     C                   PARM      '04'          POPTYP
     C                   PARM      ZSDATE        PDATE1
     C                   PARM      *BLANKS       PTIME1
     C     WBRSG         PARM      *BLANKS       PSIGN1
     C     WBROF         PARM      *BLANKS       POFFS1
     C                   PARM      *BLANKS       PDATE2
     C                   PARM      *BLANKS       PTIME2
     C                   PARM      *BLANKS       PSIGN2
     C                   PARM      *BLANKS       POFFS2
     C                   PARM      MGSNBR        PBRCH
     C                   PARM      *BLANKS       PMICD
      *                                                                                     BUG19304
      ** Get converted branch time                                                          BUG19304
      *                                                                                     BUG19304
     C                   CALL      PGMF
     C                   PARM      '02'          POPTYP
     C                   PARM      ZSDATE        PDATE1
     C                   PARM      MGTRTT        PTIME1
     C                   PARM      WSYSG         PSIGN1
     C                   PARM      WSYOF         POFFS1
     C                   PARM      *BLANKS       PDATE2
     C                   PARM      *BLANKS       PTIME2
     C                   PARM      WBRSG         PSIGN2
     C                   PARM      WBROF         POFFS2
     C                   PARM      *BLANKS       PBRCH
     C                   PARM      *BLANKS       PMICD
      *                                                                                     BUG19304
     C                   MOVE      PDATE2        PZDATE
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM                    PZDATE            6 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PZDAYN            5 0
      *                                                                                     BUG19304
     C     PRTCD         IFEQ      *BLANKS
     C                   CALL      'ZM0065'
     C                   PARM      PZDAYN        ZMDAY
     C                   PARM                    ZSDATE
     C                   PARM      *BLANKS       ZSDATC
     C                   MOVE      ZSDATC        WSDATE
     C                   ENDIF
     C                   MOVE      PTIME2        WSTIME
      *                                                                                     BUG19304
     C                   ENDSR
      *****************************************************************                       CSW207
      /TITLE SR/GETRCL                                                                        CSW207
      *****************************************************************                       CSW207
      *                                                               *                       CSW207
      *  GETRCL- Get record length                                    *                       CSW207
      *                                                               *                       CSW207
      *****************************************************************                       CSW207
      *                                                                                       CSW207
     C     GETRCL        BEGSR
      *                                                                                       CSW207
     C     'UTGETRCD'    CAT       'LN'          P#PGM            10
      *                                                                                       CSW207
     C                   CALL      P#PGM
     C                   PARM                    P#RTCD           10
     C                   PARM                    P#RCDL            5 0
     C                   PARM                    P#FILN           10
     C                   PARM      '*LIBL'       P#LIBN           10
      *                                                                                       CSW207
     C     P#RTCD        IFNE      *BLANK
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSW207
     C                   ENDSR
      *                                                                                       CSW207
      *****************************************************************                       CSW210
      **                                                              *                       CSW210
      **  SRSWFT    - SWIFT Address validation                        *                       CSW210
      **                                                              *                       CSW210
      **  Calls     - ME1400                                          *                       CSW210
      **  Called By - SRCSHP                                          *                       CSW210
      **                                                              *                       CSW210
      *****************************************************************                       CSW210
      *                                                                                       CSW210
     C     SRSWFT        BEGSR
     C                   SETOFF                                       90
      *                                                                                       CSW210
      ** Test positions 1-8 for valid SWIFT Characters                                        CSW210
      ** Check how many characters are alphanumeric                                           CSW210
     C                   MOVEL     *BLANKS       FLD              35
     C                   MOVEL     MGDAD1        FLD
     C     ALPHAN        CHECK     FLD           X#                3 0    90
      *                                                                                       CSW210
      ** If the first 8 or 11 are ok proceed                                                  CSW210
     C     *IN90         IFEQ      *ON
     C     X#            ANDEQ     9
     C     *IN90         OREQ      *ON
     C     X#            ANDEQ     12
     C     ' '           CHECK     FLD:X#        ##001             1 0    90
      *                                                                                       CSW210
      ** Check for blanks if before 8 or 11 then assume address                               CSW210
     C     *IN90         IFEQ      *ON
     C     X#            ANDEQ     11
     C                   MOVE      'Y'           ##CSID            1
     C                   GOTO      ENDSWT
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW210
      ** Invalid format - Not a S.W.I.F.T.                                                    CSW210
     C     *IN90         IFEQ      *ON
     C                   MOVE      'N'           ##CSID
     C                   GOTO      ENDSWT
     C                   ENDIF
      *                                                                                       CSW210
      ** Call Access object to validate identifier                                            CSW210
     C                   MOVEL     FLD           W9BICC
     C     3             SUBST     FLD:9         W9BICB
      *                                                                                       CSW210
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       W9RTN             7
     C                   PARM                    W9BICC            8
     C                   PARM                    W9BICB            3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       W9CUST            1
     C                   PARM      *BLANKS       W9CNST            1
     C                   PARM      *BLANKS       W9BICD            1
      *                                                                                       CSW210
      ** Record found - BIC exists                                                            CSW210
     C     W9RTN         IFEQ      *BLANKS
     C                   MOVE      'Y'           ##CSID
     C                   ENDIF
      *                                                                                       CSW210
     C     ENDSWT        TAG
     C                   ENDSR
      *****************************************************************
      /TITLE SR/*PSSR
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
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
      ** Rollback all file changes
      *
     C                   ROLBK
      *
      ** Write Database Error to report
      *
     C                   OPEN      MG051NAU
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
     C*COPY*MGCPYSRC,SWIFTTRANS                                           140440            MD056560
     C/COPY MGCPYSRC,MGSWIFTRAN                                                             MD056560
**  CPY@
(c) Finastra International Limited 2001
** ERRA - Error Message Description
Destination Customer Number not found
*** Message is Unroutable ***
Price Basis (MGSPBS) field is not 'P' or 'U'
ZM1150 (format address) call ended in error
Quantity of Financial Instrument is zero
ISIN Code of Securities is blank
ZM1050 (format cert. no.) call ended in error
<Tag Description not found>
ZM1240 (format ccy and amount) call ended in error
Deliverer of Securities (MGDSSN) is blank
Receiver of Securities (MGRSSN) is blank
Market Centre does not refer to an active Market Centre in SE Standing data file              CSW203
** TYPA - Trade Type Description
TRADE SALE
TRADE PURCHASE
