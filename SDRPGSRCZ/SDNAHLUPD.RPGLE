     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - Database Update')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHLUPD - Non-A/C Holders Database Update                  *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD100             Date 03Aug17               *
      *  Prev Amend No. MD052399           Date 05Dec18               *
      *                 CSD102             Date 08Jan19               *
      *                 MD040876           Date 13Sep16               *
      *                 CGL177             Date 11Jan16               *
      *                 MD036311           Date 01Nov15               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 MD033947           Date 28Apr15               *
      *                 MD029836           Date 22Aug14               *
      *                 MD027473           Date 11Jun14               *
      *                 MD027115           Date 22May14               *
      *                 MD026752           Date 19May14               *
      *                 CGL132             Date 01May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26384           Date 13Oct09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD100 - Patronymic and Gender Fields for Non-Account Holder *
      *  MD052399 - FATCA+CRS - Non-A/C Holder Maintenance  -Federal  *
      *             State Code is mandatory (even CER054 is OFF) and  *
      *             mandatory "Industry Code" field is protected      *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD036311 - Database error on existing Customer and Non-Acct  *
      *             Holder                                            *
      *  CGL157 - CRS Reporting                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033947 - Database Error occurred when amending US Indicia  *
      *             details of Non-account Holder                     *
      *  MD029836 - OCBC FATCA - US Indicia Comments History          *
      *           - Apply fix MD027525                                *
      *  MD027473 - Unable to Override US Account Authority Holder    *
      *  MD027115 - Joint Account Exception updates                   *
      *  MD026752 - Unable to create a Non-Account Holder due to in-  *
      *             valid/missing fields.                             *
      *           - Update the value of the fields removed from the   *
      *             display file.                                     *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26384 - Input in 'Federal State Code' is missing          *
      *  CER054 - German Features - Church Tax                        *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Standard Changes                         *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information.                  *
      *                                                               *
      *****************************************************************

      ** Midas SD Non-A/C Holders Details Master File
     FSDNAHOL0  UF A E           K DISK    COMMIT

      ** Midas SD Non-A/C Holders Details Master File - CRS                                   CGL157
     FSDCRNHL0  UF A E           K DISK    COMMIT                                             CGL157
                                                                                              CGL157
      ** Midas SD Standing Data Controls index
     FSDFCTLL0  UF A E           K DISK    COMMIT
                                                                                              CGL132
      ** FATCA Customer details file                                                          CGL132
     FSDFTNHL0  UF A E           K DISK    COMMIT                                             CGL132
                                                                                              CGL132
      ** US Indicia Comment History                                                           CGL132
     FSDINCNL0  UF A E           K DISK    COMMIT                                             CGL132
                                                                                            MD027115
      ** US Indicia Comment History                                                         MD027115
     FSDJACCL7  IF A E           K DISK                                                     MD027115
                                                                                              CGL157
      * Midas SD CRS Details File                                                             CGL157
     FSDCRSNL1  UF A E           K DISK    COMMIT                                             CGL157

      *****************************************************************
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

      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

      ** Timestamp for the transaction
     D TimeStamp       S               Z
                                                                                              CGL132
     D SysVal1         C                   'FATCADftCLsNewCustNH'                             CGL132

      ** Rename fields for Timestamp checking
     D ChkNahlFmt    E DS                  Extname(SDNAHOPD)
     D                                     Prefix(CH)

      **  Externally described data structure for Valid Non-A/C Holder
     D SDVNAHL       E DS                  Extname(SDVNAHLPD)
     D                                     Prefix(A_)
                                                                                              CGL132
      ** Externally described data structure for valid                                        CGL132
      ** FATCA customer details file                                                          CGL132
     D SDVFTNH       E DS                  EXTNAME(SDVFTNHPD)                                 CGL132
     D                                     PREFIX(A_)                                         CGL132

      ** CRS Non-Acct Holder Details File                                                     CGL157
     D SDVCRNH       E DS                  EXTNAME(SDVCRNHPD)                                 CGL157
     D                                     PREFIX(A_)                                         CGL157
                                                                                              CGL157
      ** Externally desc'd DS for valid CRS detail                                            CGL157
     D SDVCRSN       E DS                  EXTNAME(SDVCRSNPD)                                 CGL157
     D                                     PREFIX(D_)                                         CGL157

      ** Error indicators
     D SDENAHL       E DS                  Extname(SDENAHLPD)

      **  Externally described data structure for 'Before Update' Non-A/C Holder
     D B_NAHOD       E DS                  Extname(SDNAHOPD)
     D                                     Prefix(B_)

      **  Non-A/C Holders file
     D NAHODF        E DS                  Extname(SDNAHOPD)
     D NAHODF2       E DS                  EXTNAME(SDNAHOPD)                                  CGL132
     D                                     PREFIX(N_)                                         CGL132

      ** CRS Non-Account Holder Detail file                                                   CGL157
     D SDCRNH        E DS                  Extname(SDCRNHPD)                                  CGL157
                                                                                              CGL157
      **  Transaction Details File                                                            CGL157
     D SDCRSN        E DS                  EXTNAME(SDCRSNPD)                                  CGL157
                                                                                              CGL157
      ** DS for Bank details
     D SDBANK        E DS                  Extname(SDBANKPD)

      ** First DS for access programs, Short Data Structure
     D DSFDY         E DS                  Extname(DSFDY)

      ** Second DS for access programs, Long Data Structure
     D DSSDY         E DS                  Extname(DSSDY)

      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)

      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** Midas API Message Header Format Definition
     D APHEAD        E DS                  EXTNAME(APHEADPD)

      ** Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** External DS for Midas modules details                                                CSW207
     D SDMMOD        E DS                  Extname(SDMMODPD)                                  CSW207
                                                                                              CSW207
      ** FATCA Non Account Holder details                                                     CGL132
     D SDFTNH        E DS                  EXTNAME(SDFTNHPD)                                  CGL132
                                                                                              CGL132
      ** FATCA Customer Details in file format                                                CGL132
     D CuFaFilFmt    E DS                  EXTNAME(SDFTNHPD)                                  CGL132
     D                                     PREFIX(C_)                                         CGL132
                                                                                              CGL132
      ** CRS Non-Account Holder Details File Format                                           CGL157
     D CuCrhFlFmt    E DS                  EXTNAME(SDCRNHPD)                                  CGL157
     D                                     PREFIX(C_)                                         CGL157
                                                                                              CGL157
     D CuFoFilFmt      DS                                                                     CGL132
     D  WCDESC                 1     50                                                       CGL132
     D  WPDESC                51    100                                                       CGL132
     D  WWBRTH               101    105                                                       CGL132
     D  WWCBTH               106    107                                                       CGL132
     D  WWBTHT               108    142                                                       CGL132
     D  WWCNCZ               143    144                                                       CGL132
     D  WWCDOM               145    146                                                       CGL132
     D  WWACCZ               147    148                                                       CGL132
                                                                                              CGL132
     D CMDNH           S             50    DIM(1) CTDATA PERRCD(1)                          MD027115
     D CMDIN           S             50    DIM(1) CTDATA PERRCD(1)                          MD027115
                                                                                            MD027115
     D CMDLEN          S             15  5 INZ(50)                                          MD027115
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   Like(#MsgID)
     D DummyMsgF       S             10A
     D MsgSndRtn       S             10
     D PCrsdF          S            222A   DIM(30)                                            CGL177
     D PCrsdX          S            222A   DIM(30)                                            CGL177
     D PCrsdZ          S            222A                                                      CGL177

      ** Outward parameters
      ** RCD : Midas SD Deleted records file retrieval
     D PBRC            DS          3064

      ** I :  File name

     D    PBFNME               1     10

      ** I :  Long Key

     D    PBLKEY              11     60

      ** I :  Deleted Data Record Pt1

     D    PBDR01              61    310

      ** I :  Deleted Data Record Pt2

     D    PBDR02             311    560

      ** I :  Deleted Data Record Pt3

     D    PBDR03             561    810

      ** I :  Deleted Data Record Pt4

     D    PBDR04             811   1060

      ** I :  Deleted Data Record Pt5

     D    PBDR05            1061   1310

      ** I :  Deleted Data Record Pt6

     D    PBDR06            1311   1560

      ** I :  Deleted Data Record Pt7

     D    PBDR07            1561   1810

      ** I :  Deleted Data Record Pt8

     D    PBDR08            1811   2060

      ** I :  Deleted Data Record Pt9

     D    PBDR09            2061   2310

      ** I :  Deleted Data Record Pt10

     D    PBDR10            2311   2560

      ** I :  Deleted Data Record Pt11

     D    PBDR11            2561   2810

      ** I :  Deleted Data Record Pt12

     D    PBDR12            2811   3060

      ** I :  Last Change Date

     D    PBLCD             3061   3063P 0

      ** I :  Type of Last Change

     D    PBTYLC            3064   3064

     D WUDELR          DS          3000
     D    WUDR01               1    250
     D    WUDR02             251    500
     D    WUDR03             501    750
     D    WUDR04             751   1000
     D    WUDR05            1001   1250
     D    WUDR06            1251   1500
     D    WUDR07            1501   1750
     D    WUDR08            1751   2000
     D    WUDR09            2001   2250
     D    WUDR10            2251   2500
     D    WUDR11            2501   2750
     D    WUDR12            2751   3000

     D @Timestamp      S             26Z

     D                 DS
     D TDATE                   1      6
     D TDAY                    1      2
     D TMONTH                  3      4
     D TYEAR                   5      6

     D                 DS
     D  DATE                   1      6
     D  DAY                    1      2  0
     D  MONTH                  3      4  0
     D  YEAR                   5      6  0
                                                                                              CGL132
      ** Parameter variables for AOSVALR0 string                                              CGL132
     D SValK1          S             20                                                       CGL132
     D SVal1           S            200                                                       CGL132
     D SValK2          S             20                                                       CGL132
     D SVal2           S            200                                                       CGL132
     D SValK3          S             20                                                       CGL132
     D SVal3           S            200                                                       CGL132
     D SValK4          S             20                                                       CGL132
     D SVal4           S            200                                                       CGL132
     D SValK5          S             20                                                       CGL132
     D SVal5           S            200                                                       CGL132
     D SValK6          S             20                                                       CGL132
     D SVal6           S            200                                                       CGL132
     D SValK7          S             20                                                       CGL132
     D SVal7           S            200                                                       CGL132
     D SValK8          S             20                                                       CGL132
     D SVal8           S            200                                                       CGL132
     D SValK9          S             20                                                       CGL132
     D SVal9           S            200                                                       CGL132
     D SValK0          S             20                                                       CGL132
     D SVal10          S            200                                                       CGL132
     D KCUST           S              6A                                                      CGL132
     D KSCDT           S              5P 0                                                    CGL132
     D KSEQN           S              3S 0                                                    CGL132
     D AVSEQN          S              3S 0                                                    CGL132
     D WWTMST          S             26Z                                                      CGL132
     D CGL157          S              1A                                                      CGL157
     D KNAHO           S             10A                                                      CGL157
     D KCTRY           S              2A                                                      CGL157
     D X               S              2S 0                                                    CGL157

      ** Fields defined for Calling SDNAHLLOG

     D CSC011          S              1A
     D TRANSDTL        S           5800A
     D PNahoNum        S             18A
     D PANahoNo        S             18A
     D PTimestamp      S             26A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A

      ** Fields defined for Calling ZARTVJOBA

     D @Return         S              6
     D @type           S              1

      ** Fields defined for Calling RTV pgm

     D @@MODE          S              6
     D @@RSMD          S              1
     D ACTN            S              1
     D FOTRID          S             20
     D @IN36           S              1
     D IDX             S              3  0

      ** Parameter Fields for ZDATE1

     D ZDATEA          S              6
     D ZDAYNO          S              5  0
     D ErrorFlag       S              1

      ** Parameter Fields for ZDATE2

     D ZDATEB          S              6  0
     D ZADATE          S              7

     D C               S              2  0
     D MidasTrNum      S             10
     D DBError         S             28
     D WUNORC          S              5  0
     D WUNOAM          S              5  0
     D WUNODL          S              5  0
     D WUNOIN          S              5  0
     D WFLNAME         S              8
     D W0RTN           S              7
     D @@RTCD          S              7
     D CGL132          S              1A                                                      CGL132
     D WWHVAC          S              1A                                                      CGL132
     D WTime           S               T                                                      CGL132
     D WWTIME          S              6A                                                      CGL132
     D PCommitCUSD     S              1A                                                    MD033947
     D PCommitNAHL     S              1A                                                    MD033947
                                                                                              CSW207
      ** SWIFT 2007 feature                                                                   CSW207
                                                                                              CSW207
     D CSW207          S              1A   INZ('N')                                           CSW207
     D wPrivBank       S              1A   INZ('N')                                           CSW207

     D CER047          S              1A                                                      CER047
     D CER048          S              1A                                                      CER048
     D CER054          S              1A                                                      CER054
                                                                                              CER048
      /EJECT
      *****************************************************************
      ** MAIN - Main Body                                             *
      *****************************************************************

      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.

     C                   EXSR      SRChkOthUpd

     C     @@RTCD        IFNE      *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF

      ** Insert, Amend or Delete the Non-A/C Holder

     C     A_NACHTP      CASEQ     'I'           SRInsert
     C     A_NACHTP      CASEQ     'A'           SRAmend
     C     A_NACHTP      CASEQ     'D'           SRDelete
     C                   ENDCS

      ** If 24x7 Midas Availability is installed
      ** and Support System is active

     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)

     C                   CALLB     'SDNAHLLOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NAHODF
     C                   PARM                    TRANSDTL

      ** If there is no error, write the log file

     C                   IF        RetCodeOut = *BLANKS

     C                   EVAL      APTGTTYPE = 'SDNAHO'
     C                   EVAL      APFOTRANID = NHFRNT
     C                   EVAL      APRPRLOCN  = NHREPA
     C                   EVAL      APUSERID   = PSUser
     C                   EVAL      APMIDUSR   = PSUser

     C                   MOVEL     NHNAHO        PNahoNum

     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       PTimestamp
     C                   PARM                    PNahoNum
     C                   PARM      *BLANKS       PANahoNo

     C                   ENDIF

      ** If there is an error in either log file, end program

     C                   IF        RetCodeOut <> *BLANKS
     C                   EVAL      @@RTCD = '*ERROR'
     C                   ENDIF

     C                   ENDIF

      ** Exit from program

     C     EXIT          TAG

     C                   RETURN

      ****************************************************************
      /EJECT
      *****************************************************************
      ** SRChkOthUpd - Check for update by another workstation        *
      *****************************************************************

     C     SRChkOthUpd   BEGSR

      ** Retrieve current Non-A/C Holder details

     C                   MOVE      A_NANAHO      MidasTrNum

      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)

     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return
     C                   PARM                    @type

      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      **  if insert
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas transaction ID).

     C*****A_NACHTP      IFNE      'I'                                                        232543
     C**********         MOVEL     *On           @TYPE                                        232543
     C**********         ENDIF                                                                232543

     C     @Type         IFEQ      *Off
     C     A_NACHTP      IFEQ      'I'
     C                   MOVE      '*FRONT'      @@MODE
     C                   ELSE
     C                   MOVE      *BLANKS       @@MODE
     C                   ENDIF

     C                   ELSE
     C     A_NACHTP      IFEQ      'I'                                                        232543
     C     A_NAFRNT      ANDNE     *BLANKS                                                    232543
     C                   MOVE      '*FRONT'      @@MODE                                       232543
     C                   ELSE                                                                 232543
     C                   MOVE      *BLANKS       @@MODE
     C                   ENDIF                                                                232543
     C                   ENDIF

     C                   CALLB     'SDNAHLRTV'

      ** INPUTS
      ** Return code
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      ** Response mode
      ** Action Code
      ** Front Office Transaction ID
      ** (Midas) Customer Reference

     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@MODE
     C                   PARM      ' '           @@RSMD
     C                   PARM      A_NACHTP      ACTN
     C                   PARM      A_NAFRNT      FOTRID
     C                   PARM                    MidasTrNum
als  C                   PARM                    @In36

      ** OUTPUTS
      ** (Current) CUSTOMER in file format
      ** OK - Action code
      ** OK - Customer Number
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller

     C                   PARM                    ChkNahlFmt
     C                   PARM                    CuFaFilFmt                                   CGL132
     C                   PARM                    CuFoFilFmt                                   CGL132
     C                   PARM                    CuCrhFlFmt                                   CGL157
      ** CRS Country Details                                                                  CGL157
     C                   PARM                    PCrsdX                                       CGL157
     C                   PARM      *BLANK        OkActn
     C                   PARM                    OkNaho
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
     C                   PARM      *ZERO         Idx

      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)

      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original Customer was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.

      ** Interactive mode:

     C     @TYPE         IFEQ      *On

     C*****CHNHTMST      IFNE      A_NATMST                                                   232543
     C     A_NACHTP      IFNE      'I'                                                        232543
     C     CHNHTMST      ANDNE     A_NATMST                                                   232543
     C                   MOVEL     '*RECUPD'     @@RTCD
     C                   ENDIF

      ** Batch mode:

     C                   ELSE
     C     OkActn        IFEQ      'N'
     C     OkNaho        OREQ      'N'
     C                   MOVEL     '*RECUPD'     @@RTCD
     C                   Z-ADD     1             C

     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS

     C                   MOVEL     *BLANKS       DBError
     C                   MOVEL     MsgIDArr(C)   DBError

     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF

     C                   ADD       1             C
     C                   Enddo

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      ****************************************************************
      ** SRInsert - Insert a Non-A/C Holder                          *
      ****************************************************************

     C     SRInsert      BEGSR

      ** Access Non-A/C Holder

     C     A_NANAHO      CHAIN     SDNAHOL0                           99

      ** Database error

     C     *In99         IFEQ      *Off
     C                   MOVEL     A_NANAHO      DBKEY
     C                   MOVEL     'SDNAHOPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF

      ** Initialise Non-A/C Holder

     C                   CLEAR                   NAHODF

      ** Store Old fields for comparisons

     C                   MOVEL(P)  NAHODF        B_NAHOD

      ** Set Non-A/C Holder fields on Insert

     C                   EVAL      NHNAHO = A_NANAHO
     C                   EVAL      NHNARN = A_NANARN
     C                   EVAL      NHNATW = A_NANATW
     C                   EVAL      NHTINO = A_NATINO
     C                   EVAL      NHIDTP = A_NAIDTP
     C                   EVAL      NHISCT = A_NAISCT
     C                   EVAL      NHISDT = A_NAISDT
     C                   EVAL      NHBTHC = A_NABTHC
     C                   EVAL      NHBTHT = A_NABTHT
     C                   EVAL      NHDBTH = A_NADBTH
     C                   EVAL      NHCNA1 = A_NACNA1
     C                   EVAL      NHCNA2 = A_NACNA2
     C                   EVAL      NHCNA3 = A_NACNA3
     C                   EVAL      NHCNA4 = A_NACNA4
     C                   EVAL      NHIDE1 = A_NAIDE1
     C                   EVAL      NHIDE2 = A_NAIDE2
     C                   EVAL      NHIDE3 = A_NAIDE3
     C                   EVAL      NHIDE4 = A_NAIDE4
     C                   EVAL      NHCITY = A_NACITY
     C                   EVAL      NHZIPC = A_NAZIPC
     C                   EVAL      NHCOLC = A_NACOLC
     C                   EVAL      NHPIND = A_NAPIND
                                                                                              CSW207
      ** Issuing Authority                                                                    CSW207
                                                                                              CSW207
     C                   IF        CSW207 = 'Y' or wPrivBank = 'Y'                            CSW207
     C                   EVAL      NHISAU = A_NAISAU                                          CSW207
     C                   ENDIF                                                                CSW207

      ** Country of Citizenship                                                               CGL132
      ** Alternative Country of Citizenship                                                   CGL132
      ** TIN 2-5                                                                              CGL132
      ** Country of TIN 2-5                                                                   CGL132
      ** Creation Date                                                                        CGL132
      ** User Name                                                                            CGL132
                                                                                              CGL132
     C                   EVAL      NHCOCZ = A_NACOCZ                                          CGL132
     C                   EVAL      NHACCZ = A_NAACCZ                                          CGL132
     C                   EVAL      NHTIN2 = A_NATIN2                                          CGL132
     C                   EVAL      NHTIN3 = A_NATIN3                                          CGL132
     C                   EVAL      NHTIN4 = A_NATIN4                                          CGL132
     C                   EVAL      NHTIN5 = A_NATIN5                                          CGL132
     C                   EVAL      NHCTN2  = A_NACTIN2                                        CGL132
     C                   EVAL      NHCTN3  = A_NACTIN3                                        CGL132
     C                   EVAL      NHCTN4  = A_NACTIN4                                        CGL132
     C                   EVAL      NHCTN5  = A_NACTIN5                                        CGL132
     C                   EVAL      NHCRDT = A_NACRDT                                          CGL132
     C                   EVAL      NHLUSR = A_NALUSR                                          CGL132
                                                                                              CGL132
     C                   IF        CER047 = 'Y'                                               CER047
      *                                                                                       CER047
     C                   EVAL      NHTITL = A_NATITL                                          CER047
     C                   EVAL      NHMDNM = A_NAMDNM                                          CER047
     C                   EVAL      NHISUP = A_NAISUP                                          CER047
     C                   EVAL      NHRMK1 = A_NARMK1                                          CER047
     C                   EVAL      NHRMK2 = A_NARMK2                                          CER047
     C                   EVAL      NHRMK3 = A_NARMK3                                          CER047
     C                   EVAL      NHSHNM = A_NASHNM                                          CER047
     C                   EVAL      NHDOCN = A_NADOCN                                          CER047
     C                   EVAL      NHINDC = A_NAINDC                                          CER047
     C**********         EVAL      NHCTYC = A_NACTYC                                 CER047 MD026752
     C**********         EVAL      NHCTYD = A_NACTYD                                 CER047 MD026752
     C                   EVAL      NHCTYC = A_NACOCZ                                        MD026752
     C                   EVAL      NHCTYD = A_NACOLC                                        MD026752
     C                   EVAL      NHEXDT = A_NAEXDT                                          CER047
     C                   EVAL      NHPHON = A_NAPHON                                          CER047
     C                   EVAL      NHSREF = A_NASREF                                          CER047
      *                                                                                       CER047
     C                   ELSEIF    CER048 = 'Y'                                               CER048
     C                   EVAL      NHTITL = A_NATITL                                          CER048
     C                   EVAL      NHMDNM = A_NAMDNM                                          CER048
     C                   EVAL      NHISUP = A_NAISUP                                          CER048
     C                   EVAL      NHDOCN = A_NADOCN                                          CER048
     C                   EVAL      NHINDC = A_NAINDC                                          CER048
     C                   EVAL      NHSREF = A_NASREF                                        BUG22580
     C                   EVAL      NHEXDT = A_NAEXDT                                        MD052399
      *                                                                                       CER048
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
     C                   EVAL      NHCHTP = 'I'
     C                   EVAL      NHLCDT = BJRDNB
     C                   EVAL      NHREPI = ' '

      ** Front Office ID

     C                   EVAL      NHFRNT = A_NAFRNT

      ** Repair Location

     C                   EVAL      NHREPA = A_NAREPA

      ** Timestamp

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   EVAL      NHTMST  = TimeStamp

      ** If CSC011 is installed, supply a Front Office ID for the
      ** transaction even if it originated from SIN module.

     C                   IF        CSC011 = 'Y'
     C                   IF        NHFRNT = *BLANKS
     C                   EVAL      NHFRNT = 'MD' + NHNAHO
     C                   ENDIF
     C                   ENDIF
                                                                                              CER054
     C                   IF        CER048 = 'Y'                                             BUG26384
     C                   EVAL      NHSTCD = A_NASTCD                                        BUG26384
     C                   ENDIF                                                              BUG26384
                                                                                            BUG26384
     C                   IF        CER054 = 'Y'                                               CER054
     C**********         EVAL      NHSTCD = A_NASTCD                                 CER054 BUG26384
     C                   EVAL      NHRLAF = A_NARLAF                                          CER054
     C                   ENDIF                                                                CER054
                                                                                              CGL157
     C                   EVAL      NHEFF1 = A_NAEFF1                                          CGL157
     C                   EVAL      NHEXP1 = A_NAEXP1                                          CGL157
     C                   EVAL      NHEFF2 = A_NAEFF2                                          CGL157
     C                   EVAL      NHEXP2 = A_NAEXP2                                          CGL157
     C                   EVAL      NHEFF3 = A_NAEFF3                                          CGL157
     C                   EVAL      NHEXP3 = A_NAEXP3                                          CGL157
     C                   EVAL      NHEFF4 = A_NAEFF4                                          CGL157
     C                   EVAL      NHEXP4 = A_NAEXP4                                          CGL157
     C                   EVAL      NHEFF5 = A_NAEFF5                                          CGL157
     C                   EVAL      NHEXP5 = A_NAEXP5                                          CGL157
     C                   EVAL      NHTIN6 = A_NATIN6                                          CGL157
     C                   EVAL      NHCTN6 = A_NACTN6                                          CGL157
     C                   EVAL      NHEFF6 = A_NAEFF6                                          CGL157
     C                   EVAL      NHEXP6 = A_NAEXP6                                          CGL157
     C                   EVAL      NHTIN7 = A_NATIN7                                          CGL157
     C                   EVAL      NHCTN7 = A_NACTN7                                          CGL157
     C                   EVAL      NHEFF7 = A_NAEFF7                                          CGL157
     C                   EVAL      NHEXP7 = A_NAEXP7                                          CGL157
     C                   EVAL      NHTIN8 = A_NATIN8                                          CGL157
     C                   EVAL      NHCTN8 = A_NACTN8                                          CGL157
     C                   EVAL      NHEFF8 = A_NAEFF8                                          CGL157
     C                   EVAL      NHEXP8 = A_NAEXP8                                          CGL157
     C                   EVAL      NHTIN9 = A_NATIN9                                          CGL157
     C                   EVAL      NHCTN9 = A_NACTN9                                          CGL157
     C                   EVAL      NHEFF9 = A_NAEFF9                                          CGL157
     C                   EVAL      NHEXP9 = A_NAEXP9                                          CGL157
     C                   EVAL      NHTIN0 = A_NATIN0                                          CGL157
     C                   EVAL      NHCTN0 = A_NACTN0                                          CGL157
     C                   EVAL      NHEFF0 = A_NAEFF0                                          CGL157
     C                   EVAL      NHEXP0 = A_NAEXP0                                          CGL157
     C                   EVAL      NHMCT1 = A_NAMCT1                                          CGL157
     C                   EVAL      NHMCT2 = A_NAMCT2                                          CGL157
     C                   EVAL      NHMCT3 = A_NAMCT3                                          CGL157
     C                   EVAL      NHMCT4 = A_NAMCT4                                          CGL157
     C                   EVAL      NHMCT5 = A_NAMCT5                                          CGL157
     C                   EVAL      NHPCT1 = A_NAPCT1                                          CGL157
     C                   EVAL      NHPCT2 = A_NAPCT2                                          CGL157
     C                   EVAL      NHPCT3 = A_NAPCT3                                          CGL157
     C                   EVAL      NHPCT4 = A_NAPCT4                                          CGL157
     C                   EVAL      NHPCT5 = A_NAPCT5                                          CGL157

     C                   EVAL      NHGENR = A_NAGENR                                          CSD100
     C                   EVAL      NHPNYC = A_NAPNYC                                          CSD100
      ** Write New Non-A/C Holder

     C                   WRITE     SDNAHOD0
                                                                                              CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
     C                   CLEAR                   SDCRNH                                       CGL157
                                                                                              CGL157
     C                   EVAL      NRNAHO = A_NANAHO                                          CGL157
     C                   EVAL      NRTYPE = A_NVTYPE                                          CGL157
     C                   EVAL      NRSTYP = A_NVSTYP                                          CGL157
     C                   EVAL      NRHVAL = A_NVHVAL                                          CGL157
     C                   EVAL      NREXMP = A_NVEXMP                                          CGL157
     C                   EVAL      NREXMR = A_NVEXMR                                          CGL157
     C                   EVAL      NREXMD = A_NVEXMD                                          CGL157
     C                   EVAL      NREXMT = A_NVEXMT                                          CGL157
     C                   EVAL      NREXMU = A_NVEXMU                                          CGL157
     C                   EVAL      NRINFO = A_NVINFO                                          CGL157
     C                   EVAL      NREXMG = A_NVEXMG                                          CGL157
     C                   EVAL      NREXMI = A_NVEXMI                                          CGL157
     C                   EVAL      NRCHTP = 'I'                                               CGL157
     C                   EVAL      NRLCDT = BJRDNB                                            CGL157
     C                   EVAL      NRLUSR = A_NALUSR                                          CGL157
                                                                                              CGL157
      ** Write new Transaction Detail                                                         CGL157
                                                                                              CGL157
     C                   WRITE     SDCRNHD0                                                   CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
     C                   EVAL      X = 1                                                      CGL157
     C                   DOW       X < 31                                                     CGL157
     C                   IF        %SUBST(PCrsdF(X):3:1) <> '*'                               CGL177
     C                   EVAL      SDVCRSN =  PCrsdF(X)                                       CGL157
     C                   EVAL      PCrsdZ = PCrsdF(X)                                         CGL157
     C                   IF        D_RVCTRY <> *Blanks                                        CGL157
     C                   EVAL      CNNAHO = A_NANAHO                                          CGL157
     C                   EVAL      CNCTRY = D_RVCTRY                                          CGL157
     C                   EVAL      CNREPT = D_RVREPT                                          CGL157
     C                   EVAL      CNREPR = D_RVREPR                                          CGL157
     C                   IF        %SUBST(PCrsdZ:142:3) = *Blanks                             CGL157
     C                   EVAL      CNREPD = *Zero                                             CGL157
     C                   ELSE                                                                 CGL157
     C                   MOVE      D_RVREPD      CNREPD                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   EVAL      CNREPM = D_RVREPM                                          CGL157
     C                   IF        CNREPM = '******'                                          CGL177
     C                   MOVE      TimeStamp     WTime                                        CGL177
     C     *HMS0         MOVE      WTime         CNREPM                                       CGL177
     C                   ENDIF                                                                CGL177
     C                   EVAL      CNREPU = D_RVREPU                                          CGL157
     C                   EVAL      CNEVE1 = D_RVEVE1                                          CGL157
     C                   EVAL      CNEVS1 = D_RVEVS1                                          CGL157
     C                   EVAL      CNEVE2 = D_RVEVE2                                          CGL157
     C                   EVAL      CNEVS2 = D_RVEVS2                                          CGL157
     C                   EVAL      CNEVE3 = D_RVEVE3                                          CGL157
     C                   EVAL      CNEVS3 = D_RVEVS3                                          CGL157
     C                   EVAL      CNEVE4 = D_RVEVE4                                          CGL157
     C                   EVAL      CNEVS4 = D_RVEVS4                                          CGL157
     C                   EVAL      CNEVE5 = D_RVEVE5                                          CGL157
     C                   EVAL      CNEVS5 = D_RVEVS5                                          CGL157
     C                   EVAL      CNTINN = D_RVTINN                                          CGL157
     C                   EVAL      CNCODO = D_RVCODO                                          CGL157
     C                   EVAL      CNJACM = D_RVJACM                                          CGL157
     C                   EVAL      CNMAIL = D_RVMAIL                                          CGL157
     C                   EVAL      CNPHON = D_RVPHON                                          CGL157
     C                   EVAL      CNRPAY = D_RVRPAY                                          CGL157
     C                   EVAL      CNTINS = D_RVTINS                                          CGL177
     C                   IF        %SUBST(PCrsdZ:211:3) = *Blanks                             CGL157
     C                   EVAL      CNEFFD = *Zero                                             CGL157
     C                   ELSE                                                                 CGL157
     C                   MOVE      D_RVEFFD      CNEFFD                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   IF        %SUBST(PCrsdZ:214:3) = *Blanks                             CGL157
     C                   EVAL      CNEXPD = *Zero                                             CGL157
     C                   ELSE                                                                 CGL157
     C                   MOVE      D_RVEXPD      CNEXPD                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   WRITE     SDCRSND0                                                   CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL177
     C                   EVAL      X = X + 1                                                  CGL157
     C                   ENDDO                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   CLEAR                   SDFTNH                                       CGL132
     C                   EVAL      FNNAHO = NHNAHO                                            CGL132
     C                   EVAL      FNCLAC = A_FVCLAC                                          CGL132
     C                   EVAL      FNCLAD = A_FVCLAD                                          CGL132
     C                   EVAL      FNPCLA = A_FVPCLA                                          CGL132
     C                   EVAL      FNHMSV = A_FVHMSV                                          CGL132
     C                   EVAL      FNHMSD = A_FVHMSD                                          CGL132
     C                   EVAL      FNHMOV = A_FVHMOV                                          CGL132
     C                   EVAL      FNHMD1 = A_FVHMD1                                          CGL132
     C                   EVAL      FNHMD2 = A_FVHMD2                                          CGL132
     C                   EVAL      FNHMD3 = A_FVHMD3                                          CGL132
     C                   EVAL      FNHMD4 = A_FVHMD4                                          CGL132
     C                   EVAL      FNHMD5 = A_FVHMD5                                          CGL132
     C                   EVAL      FNHMS1 = A_FVHMS1                                          CGL132
     C                   EVAL      FNHMS2 = A_FVHMS2                                          CGL132
     C                   EVAL      FNHMS3 = A_FVHMS3                                          CGL132
     C                   EVAL      FNHMS4 = A_FVHMS4                                          CGL132
     C                   EVAL      FNHMS5 = A_FVHMS5                                          CGL132
     C                   EVAL      FNHMCO = A_FVHMCO                                          CGL132
     C                   EVAL      FNMCSV = A_FVMCSV                                          CGL132
     C                   EVAL      FNMCSD = A_FVMCSD                                          CGL132
     C                   EVAL      FNMCOV = A_FVMCOV                                          CGL132
     C                   EVAL      FNMCD1 = A_FVMCD1                                          CGL132
     C                   EVAL      FNMCD2 = A_FVMCD2                                          CGL132
     C                   EVAL      FNMCD3 = A_FVMCD3                                          CGL132
     C                   EVAL      FNMCD4 = A_FVMCD4                                          CGL132
     C                   EVAL      FNMCD5 = A_FVMCD5                                          CGL132
     C                   EVAL      FNMCS1 = A_FVMCS1                                          CGL132
     C                   EVAL      FNMCS2 = A_FVMCS2                                          CGL132
     C                   EVAL      FNMCS3 = A_FVMCS3                                          CGL132
     C                   EVAL      FNMCS4 = A_FVMCS4                                          CGL132
     C                   EVAL      FNMCS5 = A_FVMCS5                                          CGL132
     C                   EVAL      FNMCCO = A_FVMCCO                                          CGL132
     C                   EVAL      FNRPSV = A_FVRPSV                                          CGL132
     C                   EVAL      FNRPSD = A_FVRPSD                                          CGL132
     C                   EVAL      FNRPOV = A_FVRPOV                                          CGL132
     C                   EVAL      FNRPD1 = A_FVRPD1                                          CGL132
     C                   EVAL      FNRPD2 = A_FVRPD2                                          CGL132
     C                   EVAL      FNRPD3 = A_FVRPD3                                          CGL132
     C                   EVAL      FNRPD4 = A_FVRPD4                                          CGL132
     C                   EVAL      FNRPD5 = A_FVRPD5                                          CGL132
     C                   EVAL      FNRPS1 = A_FVRPS1                                          CGL132
     C                   EVAL      FNRPS2 = A_FVRPS2                                          CGL132
     C                   EVAL      FNRPS3 = A_FVRPS3                                          CGL132
     C                   EVAL      FNRPS4 = A_FVRPS4                                          CGL132
     C                   EVAL      FNRPS5 = A_FVRPS5                                          CGL132
     C                   EVAL      FNRPCO = A_FVRPCO                                          CGL132
     C                   EVAL      FNCISV = A_FVCISV                                          CGL132
     C                   EVAL      FNCISD = A_FVCISD                                          CGL132
     C                   EVAL      FNCIOV = A_FVCIOV                                          CGL132
     C                   EVAL      FNCID1 = A_FVCID1                                          CGL132
     C                   EVAL      FNCID2 = A_FVCID2                                          CGL132
     C                   EVAL      FNCID3 = A_FVCID3                                          CGL132
     C                   EVAL      FNCID4 = A_FVCID4                                          CGL132
     C                   EVAL      FNCID5 = A_FVCID5                                          CGL132
     C                   EVAL      FNCIS1 = A_FVCIS1                                          CGL132
     C                   EVAL      FNCIS2 = A_FVCIS2                                          CGL132
     C                   EVAL      FNCIS3 = A_FVCIS3                                          CGL132
     C                   EVAL      FNCIS4 = A_FVCIS4                                          CGL132
     C                   EVAL      FNCIS5 = A_FVCIS5                                          CGL132
     C                   EVAL      FNCICO = A_FVCICO                                          CGL132
     C                   EVAL      FNCBSV = A_FVCBSV                                          CGL132
     C                   EVAL      FNCBSD = A_FVCBSD                                          CGL132
     C                   EVAL      FNCBOV = A_FVCBOV                                          CGL132
     C                   EVAL      FNCBD1 = A_FVCBD1                                          CGL132
     C                   EVAL      FNCBD2 = A_FVCBD2                                          CGL132
     C                   EVAL      FNCBD3 = A_FVCBD3                                          CGL132
     C                   EVAL      FNCBD4 = A_FVCBD4                                          CGL132
     C                   EVAL      FNCBD5 = A_FVCBD5                                          CGL132
     C                   EVAL      FNCBS1 = A_FVCBS1                                          CGL132
     C                   EVAL      FNCBS2 = A_FVCBS2                                          CGL132
     C                   EVAL      FNCBS3 = A_FVCBS3                                          CGL132
     C                   EVAL      FNCBS4 = A_FVCBS4                                          CGL132
     C                   EVAL      FNCBS5 = A_FVCBS5                                          CGL132
     C                   EVAL      FNCBCO = A_FVCBCO                                          CGL132
     C                   EVAL      FNCDSV = A_FVCDSV                                          CGL132
     C                   EVAL      FNCDSD = A_FVCDSD                                          CGL132
     C                   EVAL      FNCDOV = A_FVCDOV                                          CGL132
     C                   EVAL      FNCDD1 = A_FVCDD1                                          CGL132
     C                   EVAL      FNCDD2 = A_FVCDD2                                          CGL132
     C                   EVAL      FNCDD3 = A_FVCDD3                                          CGL132
     C                   EVAL      FNCDD4 = A_FVCDD4                                          CGL132
     C                   EVAL      FNCDD5 = A_FVCDD5                                          CGL132
     C                   EVAL      FNCDS1 = A_FVCDS1                                          CGL132
     C                   EVAL      FNCDS2 = A_FVCDS2                                          CGL132
     C                   EVAL      FNCDS3 = A_FVCDS3                                          CGL132
     C                   EVAL      FNCDS4 = A_FVCDS4                                          CGL132
     C                   EVAL      FNCDS5 = A_FVCDS5                                          CGL132
     C                   EVAL      FNCDCO = A_FVCDCO                                          CGL132
     C                   EVAL      FNGCSV = A_FVGCSV                                          CGL132
     C                   EVAL      FNGCSD = A_FVGCSD                                          CGL132
     C                   EVAL      FNGCOV = A_FVGCOV                                          CGL132
     C                   EVAL      FNGCD1 = A_FVGCD1                                          CGL132
     C                   EVAL      FNGCD2 = A_FVGCD2                                          CGL132
     C                   EVAL      FNGCD3 = A_FVGCD3                                          CGL132
     C                   EVAL      FNGCD4 = A_FVGCD4                                          CGL132
     C                   EVAL      FNGCD5 = A_FVGCD5                                          CGL132
     C                   EVAL      FNGCS1 = A_FVGCS1                                          CGL132
     C                   EVAL      FNGCS2 = A_FVGCS2                                          CGL132
     C                   EVAL      FNGCS3 = A_FVGCS3                                          CGL132
     C                   EVAL      FNGCS4 = A_FVGCS4                                          CGL132
     C                   EVAL      FNGCS5 = A_FVGCS5                                          CGL132
     C                   EVAL      FNGCCO = A_FVGCCO                                          CGL132
     C                   EVAL      FNIDSV = A_FVIDSV                                          CGL132
     C                   EVAL      FNIDSD = A_FVIDSD                                          CGL132
     C                   EVAL      FNIDOV = A_FVIDOV                                          CGL132
     C                   EVAL      FNIDD1 = A_FVIDD1                                          CGL132
     C                   EVAL      FNIDD2 = A_FVIDD2                                          CGL132
     C                   EVAL      FNIDD3 = A_FVIDD3                                          CGL132
     C                   EVAL      FNIDD4 = A_FVIDD4                                          CGL132
     C                   EVAL      FNIDD5 = A_FVIDD5                                          CGL132
     C                   EVAL      FNIDS1 = A_FVIDS1                                          CGL132
     C                   EVAL      FNIDS2 = A_FVIDS2                                          CGL132
     C                   EVAL      FNIDS3 = A_FVIDS3                                          CGL132
     C                   EVAL      FNIDS4 = A_FVIDS4                                          CGL132
     C                   EVAL      FNIDS5 = A_FVIDS5                                          CGL132
     C                   EVAL      FNIDCO = A_FVIDCO                                          CGL132
     C                   EVAL      FNJASV = A_FVJASV                                          CGL132
     C                   EVAL      FNJASD = A_FVJASD                                          CGL132
     C                   EVAL      FNJAOV = A_FVJAOV                                          CGL132
     C                   EVAL      FNJAD1 = A_FVJAD1                                          CGL132
     C                   EVAL      FNJAD2 = A_FVJAD2                                          CGL132
     C                   EVAL      FNJAD3 = A_FVJAD3                                          CGL132
     C                   EVAL      FNJAD4 = A_FVJAD4                                          CGL132
     C                   EVAL      FNJAD5 = A_FVJAD5                                          CGL132
     C                   EVAL      FNJAS1 = A_FVJAS1                                          CGL132
     C                   EVAL      FNJAS2 = A_FVJAS2                                          CGL132
     C                   EVAL      FNJAS3 = A_FVJAS3                                          CGL132
     C                   EVAL      FNJAS4 = A_FVJAS4                                          CGL132
     C                   EVAL      FNJAS5 = A_FVJAS5                                          CGL132
     C                   EVAL      FNJACO = A_FVJACO                                          CGL132
     C                   EVAL      FNTESV = A_FVTESV                                          CGL132
     C                   EVAL      FNTESD = A_FVTESD                                          CGL132
     C                   EVAL      FNTEOV = A_FVTEOV                                          CGL132
     C                   EVAL      FNTED1 = A_FVTED1                                          CGL132
     C                   EVAL      FNTED2 = A_FVTED2                                          CGL132
     C                   EVAL      FNTED3 = A_FVTED3                                          CGL132
     C                   EVAL      FNTED4 = A_FVTED4                                          CGL132
     C                   EVAL      FNTED5 = A_FVTED5                                          CGL132
     C                   EVAL      FNTES1 = A_FVTES1                                          CGL132
     C                   EVAL      FNTES2 = A_FVTES2                                          CGL132
     C                   EVAL      FNTES3 = A_FVTES3                                          CGL132
     C                   EVAL      FNTES4 = A_FVTES4                                          CGL132
     C                   EVAL      FNTES5 = A_FVTES5                                          CGL132
     C                   EVAL      FNTECO = A_FVTECO                                          CGL132
     C                   EVAL      FNTXSV = A_FVTXSV                                          CGL132
     C                   EVAL      FNTXSD = A_FVTXSD                                          CGL132
     C                   EVAL      FNTXOV = A_FVTXOV                                          CGL132
     C                   EVAL      FNTXD1 = A_FVTXD1                                          CGL132
     C                   EVAL      FNTXD2 = A_FVTXD2                                          CGL132
     C                   EVAL      FNTXD3 = A_FVTXD3                                          CGL132
     C                   EVAL      FNTXD4 = A_FVTXD4                                          CGL132
     C                   EVAL      FNTXD5 = A_FVTXD5                                          CGL132
     C                   EVAL      FNTXS1 = A_FVTXS1                                          CGL132
     C                   EVAL      FNTXS2 = A_FVTXS2                                          CGL132
     C                   EVAL      FNTXS3 = A_FVTXS3                                          CGL132
     C                   EVAL      FNTXS4 = A_FVTXS4                                          CGL132
     C                   EVAL      FNTXS5 = A_FVTXS5                                          CGL132
     C                   EVAL      FNTXCO = A_FVTXCO                                          CGL132
     C                   EVAL      FNEXEM = A_FVEXEM                                          CGL132
     C                   EVAL      FNEXER = A_FVEXER                                          CGL132
     C                   EVAL      FNEXED = A_FVEXED                                          CGL132
     C                   EVAL      FNEXET = A_FVEXET                                          CGL132
     C                   EVAL      FNEXEU = A_FVEXEU                                          CGL132
     C                   EVAL      FNREPT = A_FVREPT                                          CGL132
     C                   EVAL      FNGIIN = A_FVGIIN                                          CGL132
     C                   EVAL      FNGIID = A_FVGIID                                          CGL132
     C                   EVAL      FNGIIO = A_FVGIIO                                          CGL132
     C                   EVAL      FNUTIN = A_FVUTIN                                          CGL132
     C                   EVAL      FNGREC = A_FVGREC                                          CGL132
     C                   EVAL      FNMAIL = A_FVMAIL                                          CGL132
     C                   EVAL      FNPHON = A_FVPHON                                          CGL132
     C                   EVAL      FNNHTY = A_FVNHTY                                          CGL132
     C                   EVAL      FNNHST = A_FVNHST                                          CGL132
     C                   EVAL      FNRPTT = A_FVRPTT                                          CGL132
     C                   EVAL      FNRPTR = A_FVRPTR                                          CGL132
     C                   EVAL      FNRPTD = A_FVRPTD                                          CGL132
     C                   EVAL      FNRPTM = A_FVRPTM                                          CGL132
     C                   IF        FNRPTM = '******'                                        MD033947
     C                   MOVE      TimeStamp     WTime                                      MD033947
     C     *HMS0         MOVE      WTime         FNRPTM                                     MD033947
     C                   ENDIF                                                              MD033947
     C                   EVAL      FNRPTU = A_FVRPTU                                          CGL132
     C                   EVAL      FNHVAC = A_FVHVAC                                          CGL132
     C                   EVAL      FNINFC = A_FVINFC                                          CGL132
     C                   EVAL      FNEXMA = A_FVEXMA                                          CGL132
     C                   EVAL      FNEXID = A_FVEXID                                          CGL132
     C                   EVAL      FNLDAT = BJRDNB                                            CGL132
     C                   EVAL      FNLCTP = 'I'                                               CGL132
     C                   EVAL      FNLUSR = PSUSER                                            CGL132
     C                   EVAL      FNREPA = A_FVREPA                                          CGL132
     C                   EVAL      FNFOID = A_FVFOID                                          CGL132
     C                   EVAL      FNREPI = A_FVREPI                                          CGL132
     C                   EVAL      FNAUSV = A_FVAUSV                                        MD027473
     C                   EVAL      FNAUSD = A_FVAUSD                                        MD027473
     C                   EVAL      FNAUOV = A_FVAUOV                                        MD027473
     C                   EVAL      FNAUD1 = A_FVAUD1                                        MD027473
     C                   EVAL      FNAUD2 = A_FVAUD2                                        MD027473
     C                   EVAL      FNAUD3 = A_FVAUD3                                        MD027473
     C                   EVAL      FNAUD4 = A_FVAUD4                                        MD027473
     C                   EVAL      FNAUD5 = A_FVAUD5                                        MD027473
     C                   EVAL      FNAUS1 = A_FVAUS1                                        MD027473
     C                   EVAL      FNAUS2 = A_FVAUS2                                        MD027473
     C                   EVAL      FNAUS3 = A_FVAUS3                                        MD027473
     C                   EVAL      FNAUS4 = A_FVAUS4                                        MD027473
     C                   EVAL      FNAUS5 = A_FVAUS5                                        MD027473
     C                   EVAL      FNAUCO = A_FVAUCO                                        MD027473
                                                                                              CGL132
     C                   WRITE     SDFTNHD0                                                   CGL132
     C                   ENDIF                                                                CGL132

     C                   Z-ADD     1             WUNORC
     C                   Z-ADD     *ZERO         WUNOAM
     C                   Z-ADD     *ZERO         WUNODL
     C                   Z-ADD     1             WUNOIN

     C                   MOVEL     'SDNAHOPD'    WFLNAME

     C                   EXSR      SRSnChrC

     C                   ENDSR

      ****************************************************************
      /EJECT
      ****************************************************************
      ** SRAmend  - Amend a Non-A/C Holder                           *
      ****************************************************************

     C     SRAmend       BEGSR

      ** Access Non-A/C Holder details record

     C     A_NANAHO      CHAIN     SDNAHOL0                           99

      ** Database error

     C     *In99         IFEQ      *On
     C                   MOVEL     A_NANAHO      DBKEY
     C                   MOVEL     'SDNAHOPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF

      ** Update 'BEFORE' status

     C                   MOVEL(P)  NAHODF        B_NAHOD

      ** Set Non-A/C Holder fields on Amend

      ** Move Non-key fields

     C                   EVAL      NHNAHO = A_NANAHO
     C                   EVAL      NHNARN = A_NANARN
     C                   EVAL      NHNATW = A_NANATW
     C                   EVAL      NHTINO = A_NATINO
     C                   EVAL      NHIDTP = A_NAIDTP
     C                   EVAL      NHISCT = A_NAISCT
     C                   EVAL      NHISDT = A_NAISDT
     C                   EVAL      NHBTHC = A_NABTHC
     C                   EVAL      NHBTHT = A_NABTHT
     C                   EVAL      NHDBTH = A_NADBTH
     C                   EVAL      NHCNA1 = A_NACNA1
     C                   EVAL      NHCNA2 = A_NACNA2
     C                   EVAL      NHCNA3 = A_NACNA3
     C                   EVAL      NHCNA4 = A_NACNA4
     C                   EVAL      NHIDE1 = A_NAIDE1
     C                   EVAL      NHIDE2 = A_NAIDE2
     C                   EVAL      NHIDE3 = A_NAIDE3
     C                   EVAL      NHIDE4 = A_NAIDE4
     C                   EVAL      NHCITY = A_NACITY
     C                   EVAL      NHZIPC = A_NAZIPC
     C                   EVAL      NHCOLC = A_NACOLC
     C                   EVAL      NHPIND = A_NAPIND
                                                                                              CSW207
      ** Issuing Authority                                                                    CSW207
                                                                                              CSW207
     C                   IF        CSW207 = 'Y' or wPrivBank = 'Y'                            CSW207
     C                   EVAL      NHISAU = A_NAISAU                                          CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CGL132
      ** Country of Citizenship                                                               CGL132
      ** Alternative Country of Citizenship                                                   CGL132
      ** TIN 2-5                                                                              CGL132
      ** Country of TIN 2-5                                                                   CGL132
      ** Creation Date                                                                        CGL132
      ** User Name                                                                            CGL132
                                                                                              CGL132
     C                   EVAL      NHCOCZ = A_NACOCZ                                          CGL132
     C                   EVAL      NHACCZ = A_NAACCZ                                          CGL132
     C                   EVAL      NHTIN2 = A_NATIN2                                          CGL132
     C                   EVAL      NHTIN3 = A_NATIN3                                          CGL132
     C                   EVAL      NHTIN4 = A_NATIN4                                          CGL132
     C                   EVAL      NHTIN5 = A_NATIN5                                          CGL132
     C                   EVAL      NHCTN2  = A_NACTIN2                                        CGL132
     C                   EVAL      NHCTN3  = A_NACTIN3                                        CGL132
     C                   EVAL      NHCTN4  = A_NACTIN4                                        CGL132
     C                   EVAL      NHCTN5  = A_NACTIN5                                        CGL132
     C                   EVAL      NHCRDT = A_NACRDT                                          CGL132
     C                   EVAL      NHLUSR = A_NALUSR                                          CGL132

     C                   IF        CER047 = 'Y'                                               CER047
      *                                                                                       CER047
     C                   EVAL      NHTITL = A_NATITL                                          CER047
     C                   EVAL      NHMDNM = A_NAMDNM                                          CER047
     C                   EVAL      NHISUP = A_NAISUP                                          CER047
     C                   EVAL      NHRMK1 = A_NARMK1                                          CER047
     C                   EVAL      NHRMK2 = A_NARMK2                                          CER047
     C                   EVAL      NHRMK3 = A_NARMK3                                          CER047
     C                   EVAL      NHSHNM = A_NASHNM                                          CER047
     C                   EVAL      NHDOCN = A_NADOCN                                          CER047
     C                   EVAL      NHINDC = A_NAINDC                                          CER047
     C**********         EVAL      NHCTYC = A_NACTYC                                 CER047 MD026752
     C**********         EVAL      NHCTYD = A_NACTYD                                 CER047 MD026752
     C                   EVAL      NHCTYC = A_NACOCZ                                        MD026752
     C                   EVAL      NHCTYD = A_NACOLC                                        MD026752
     C                   EVAL      NHEXDT = A_NAEXDT                                          CER047
     C                   EVAL      NHPHON = A_NAPHON                                          CER047
     C                   EVAL      NHSREF = A_NASREF                                          CER047
      *                                                                                       CER047
     C                   ELSEIF    CER048 = 'Y'                                               CER048
     C                   EVAL      NHTITL = A_NATITL                                          CER048
     C                   EVAL      NHMDNM = A_NAMDNM                                          CER048
     C                   EVAL      NHISUP = A_NAISUP                                          CER048
     C                   EVAL      NHDOCN = A_NADOCN                                          CER048
     C                   EVAL      NHINDC = A_NAINDC                                          CER048
     C                   EVAL      NHSREF = A_NASREF                                        BUG22580
     C                   EVAL      NHEXDT = A_NAEXDT                                        MD052399
      *                                                                                       CER048
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
     C                   EVAL      NHCHTP = 'A'
     C                   EVAL      NHLCDT = BJRDNB
     C**********         EVAL      NHREPI = ' '                                               232543
     C                   EVAL      NHREPI = A_NAREPI                                          232543

      ***Front*Office ID                                                                      232543

     C**********         EVAL      NHFRNT = *BLANKS                                           232543
     C**********         EVAL      NHREPA = ' '                                               232543
     C                   EVAL      NHFRNT = A_NAFRNT                                          232543
     C                   EVAL      NHREPA = A_NAREPA                                          232543
                                                                                              CGL157
     C                   EVAL      NHEFF1 = A_NAEFF1                                          CGL157
     C                   EVAL      NHEXP1 = A_NAEXP1                                          CGL157
     C                   EVAL      NHEFF2 = A_NAEFF2                                          CGL157
     C                   EVAL      NHEXP2 = A_NAEXP2                                          CGL157
     C                   EVAL      NHEFF3 = A_NAEFF3                                          CGL157
     C                   EVAL      NHEXP3 = A_NAEXP3                                          CGL157
     C                   EVAL      NHEFF4 = A_NAEFF4                                          CGL157
     C                   EVAL      NHEXP4 = A_NAEXP4                                          CGL157
     C                   EVAL      NHEFF5 = A_NAEFF5                                          CGL157
     C                   EVAL      NHEXP5 = A_NAEXP5                                          CGL157
     C                   EVAL      NHTIN6 = A_NATIN6                                          CGL157
     C                   EVAL      NHCTN6 = A_NACTN6                                          CGL157
     C                   EVAL      NHEFF6 = A_NAEFF6                                          CGL157
     C                   EVAL      NHEXP6 = A_NAEXP6                                          CGL157
     C                   EVAL      NHTIN7 = A_NATIN7                                          CGL157
     C                   EVAL      NHCTN7 = A_NACTN7                                          CGL157
     C                   EVAL      NHEFF7 = A_NAEFF7                                          CGL157
     C                   EVAL      NHEXP7 = A_NAEXP7                                          CGL157
     C                   EVAL      NHTIN8 = A_NATIN8                                          CGL157
     C                   EVAL      NHCTN8 = A_NACTN8                                          CGL157
     C                   EVAL      NHEFF8 = A_NAEFF8                                          CGL157
     C                   EVAL      NHEXP8 = A_NAEXP8                                          CGL157
     C                   EVAL      NHTIN9 = A_NATIN9                                          CGL157
     C                   EVAL      NHCTN9 = A_NACTN9                                          CGL157
     C                   EVAL      NHEFF9 = A_NAEFF9                                          CGL157
     C                   EVAL      NHEXP9 = A_NAEXP9                                          CGL157
     C                   EVAL      NHTIN0 = A_NATIN0                                          CGL157
     C                   EVAL      NHCTN0 = A_NACTN0                                          CGL157
     C                   EVAL      NHEFF0 = A_NAEFF0                                          CGL157
     C                   EVAL      NHEXP0 = A_NAEXP0                                          CGL157
     C                   EVAL      NHMCT1 = A_NAMCT1                                          CGL157
     C                   EVAL      NHMCT2 = A_NAMCT2                                          CGL157
     C                   EVAL      NHMCT3 = A_NAMCT3                                          CGL157
     C                   EVAL      NHMCT4 = A_NAMCT4                                          CGL157
     C                   EVAL      NHMCT5 = A_NAMCT5                                          CGL157
     C                   EVAL      NHPCT1 = A_NAPCT1                                          CGL157
     C                   EVAL      NHPCT2 = A_NAPCT2                                          CGL157
     C                   EVAL      NHPCT3 = A_NAPCT3                                          CGL157
     C                   EVAL      NHPCT4 = A_NAPCT4                                          CGL157
     C                   EVAL      NHPCT5 = A_NAPCT5                                          CGL157

      ** Timestamp

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      NHTMST = TimeStamp

     C                   IF        CER048 = 'Y'                                             BUG26384
     C                   EVAL      NHSTCD = A_NASTCD                                        BUG26384
     C                   ENDIF                                                              BUG26384
                                                                                            BUG26384
     C                   IF        CER054 = 'Y'                                               CER054
     C**********         EVAL      NHSTCD = A_NASTCD                                 CER054 BUG26384
     C                   EVAL      NHRLAF = A_NARLAF                                          CER054
     C                   ENDIF                                                                CER054
                                                                                              CER054
     C                   EVAL      NHGENR = A_NAGENR                                          CSD100
     C                   EVAL      NHPNYC = A_NAPNYC                                          CSD100
      ** Update Record

     C                   UPDATE    SDNAHOD0
      ** Access CRS Transaction Details if CGL157 is *ON                                      CGL157
                                                                                              CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
     C     A_NANAHO      CHAIN     SDCRNHL0                             99                    CGL157
                                                                                              CGL157
      ** Initialize Transaction Detail                                                        CGL157
                                                                                              CGL157
     C                   CLEAR                   SDCRNH                                       CGL157
                                                                                              CGL157
     C                   EVAL      NRNAHO = A_NANAHO                                          CGL157
     C                   EVAL      NRTYPE = A_NVTYPE                                          CGL157
     C                   EVAL      NRSTYP = A_NVSTYP                                          CGL157
     C                   EVAL      NRHVAL = A_NVHVAL                                          CGL157
     C                   EVAL      NREXMP = A_NVEXMP                                          CGL157
     C                   EVAL      NREXMR = A_NVEXMR                                          CGL157
     C                   EVAL      NREXMD = A_NVEXMD                                          CGL157
     C                   EVAL      NREXMT = A_NVEXMT                                          CGL157
     C                   EVAL      NREXMU = A_NVEXMU                                          CGL157
     C                   EVAL      NRINFO = A_NVINFO                                          CGL157
     C                   EVAL      NREXMG = A_NVEXMG                                          CGL157
     C                   EVAL      NREXMI = A_NVEXMI                                          CGL157
     C                   EVAL      NRCHTP = 'A'                                               CGL157
     C                   EVAL      NRLCDT = BJRDNB                                            CGL157
     C                   EVAL      NRLUSR = PSUSER                                            CGL157
                                                                                              CGL157
     C                   IF        NOT %FOUND(SDCRNHL0)                                     MD036311
      ** Write Record                                                                       MD036311
     C                   WRITE     SDCRNHD0                                                 MD036311
     C                   ELSE                                                               MD036311
      ** Update Record                                                                        CGL157
     C                   UPDATE    SDCRNHD0                                                   CGL157
     C                   ENDIF                                                              MD036311
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
     C     A_NANAHO      SETLL     SDCRSNL1                                                   CGL157
     C     A_NANAHO      READE     SDCRSNL1                                                   CGL157
     C                   DOW       %FOUND(SDCRSNL1)                                           CGL157
     C                             AND A_NANAHO = CNNAHO                                      CGL157
     C                   DELETE    SDCRSND0                                                   CGL157
     C                   CLEAR                   SDCRSN                                       CGL157
     C     A_NANAHO      READE     SDCRSNL1                                                   CGL157
     C                   ENDDO                                                                CGL157
     C                   EVAL      X = 1                                                      CGL157
     C                   DOW       X < 31                                                     CGL157
     C                   IF        %SUBST(PCrsdF(X):3:1) <> '*'                               CGL177
     C                   EVAL      SDVCRSN = PCrsdF(X)                                        CGL157
     C                   EVAL      PCrsdZ = PCrsdF(X)                                         CGL157
     C                   IF        D_RVCTRY <> *Blanks                                        CGL157
     C                   EVAL      CNNAHO = A_NANAHO                                          CGL157
     C                   EVAL      CNCTRY = D_RVCTRY                                          CGL157
     C                   EVAL      CNREPT = D_RVREPT                                          CGL157
     C                   EVAL      CNREPR = D_RVREPR                                          CGL157
     C                   IF        %SUBST(PCrsdZ:142:3) = *Blanks                             CGL157
     C                   EVAL      CNREPD = *Zero                                             CGL157
     C                   ELSE                                                                 CGL157
     C                   MOVE      D_RVREPD      CNREPD                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   EVAL      CNREPM = D_RVREPM                                          CGL157
     C                   IF        CNREPM = '******'                                          CGL177
     C                   MOVE      TimeStamp     WTime                                        CGL177
     C     *HMS0         MOVE      WTime         CNREPM                                       CGL177
     C                   ENDIF                                                                CGL177
     C                   EVAL      CNREPU = D_RVREPU                                          CGL157
     C                   EVAL      CNEVE1 = D_RVEVE1                                          CGL157
     C                   EVAL      CNEVS1 = D_RVEVS1                                          CGL157
     C                   EVAL      CNEVE2 = D_RVEVE2                                          CGL157
     C                   EVAL      CNEVS2 = D_RVEVS2                                          CGL157
     C                   EVAL      CNEVE3 = D_RVEVE3                                          CGL157
     C                   EVAL      CNEVS3 = D_RVEVS3                                          CGL157
     C                   EVAL      CNEVE4 = D_RVEVE4                                          CGL157
     C                   EVAL      CNEVS4 = D_RVEVS4                                          CGL157
     C                   EVAL      CNEVE5 = D_RVEVE5                                          CGL157
     C                   EVAL      CNEVS5 = D_RVEVS5                                          CGL157
     C                   EVAL      CNTINN = D_RVTINN                                          CGL157
     C                   EVAL      CNCODO = D_RVCODO                                          CGL157
     C                   EVAL      CNJACM = D_RVJACM                                          CGL157
     C                   EVAL      CNMAIL = D_RVMAIL                                          CGL157
     C                   EVAL      CNPHON = D_RVPHON                                          CGL157
     C                   EVAL      CNRPAY = D_RVRPAY                                          CGL157
     C                   EVAL      CNTINS = D_RVTINS                                          CGL177
     C                   IF        %SUBST(PCrsdZ:211:3) = *Blanks                             CGL157
     C                   EVAL      CNEFFD = *Zero                                             CGL157
     C                   ELSE                                                                 CGL157
     C                   MOVE      D_RVEFFD      CNEFFD                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   IF        %SUBST(PCrsdZ:214:3) = *Blanks                             CGL157
     C                   EVAL      CNEXPD = *Zero                                             CGL157
     C                   ELSE                                                                 CGL157
     C                   MOVE      D_RVEXPD      CNEXPD                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   WRITE     SDCRSND0                                                   CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL177
     C                   EVAL      X = X + 1                                                  CGL157
     C                   ENDDO                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   CLEAR                   SDFTNH                                       CGL132
                                                                                              CGL132
      ** Access customer details recrod                                                       CGL132
                                                                                              CGL132
     C     A_NANAHO      CHAIN     SDFTNHL0                           99                      CGL132
                                                                                              CGL132
      ** Database error                                                                       CGL132
                                                                                              CGL132
     C     *IN99         IFEQ      '1'                                                        CGL132
     C                   MOVEL     A_NANAHO      DBKEY                                        CGL132
     C                   MOVEL     'SDFTNHPD'    DBFILE                                       CGL132
     C                   MOVEL     '005'         DBASE                                        CGL132
     C                   EXSR      SRERR                                                      CGL132
     C                   END                                                                  CGL132
                                                                                              CGL132
     C                   MOVE      TimeStamp     WTime                                        CGL132
     C     *HMS0         MOVE      WTime         WWTIME                                       CGL132
     C                   EVAL      WWHVAC = FNHVAC                                            CGL132
     C                   EVAL      FNNAHO = NHNAHO                                            CGL132
                                                                                              CGL132
     C                   IF        FNCIOV <> A_FVCIOV                                         CGL132
     C                             OR FNCICO <> A_FVCICO                                    MD027525
     C                   EVAL      INNAHO = FNNAHO                                            CGL132
     C                   EVAL      INUSIN = 'US CITIZENSHIP'                                  CGL132
     C                   EVAL      INUSSV = FNCISV                                            CGL132
     C                   EVAL      INUSSD = FNCISD                                            CGL132
     C                   EVAL      INUSSM = FNCIST                                            CGL132
     C                   EVAL      INUSOV = FNCIOV                                            CGL132
     C                   EVAL      INUSUN = FNCION                                            CGL132
     C                   EVAL      INUSDT = FNCIOD                                            CGL132
     C                   EVAL      INUSTM = FNCIOT                                            CGL132
     C                   EVAL      INUSCO = FNCICO                                            CGL132
     C                   IF        FNCIOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCND0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FNCIOD = BJRDNB                                            CGL132
     C                   EVAL      FNCION = PSUSER                                            CGL132
     C                   MOVE      WWTIME        FNCIOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNTXOV <> A_FVTXOV                                         CGL132
     C                             OR FNTXCO <> A_FVTXCO                                    MD027525
     C                   EVAL      INNAHO = NHNAHO                                            CGL132
     C                   EVAL      INUSIN = 'US TIN'                                          CGL132
     C                   EVAL      INUSSV = FNTXSV                                            CGL132
     C                   EVAL      INUSSD = FNTXSD                                            CGL132
     C                   EVAL      INUSSM = FNTXST                                            CGL132
     C                   EVAL      INUSOV = FNTXOV                                            CGL132
     C                   EVAL      INUSUN = FNTXON                                            CGL132
     C                   EVAL      INUSDT = FNTXOD                                            CGL132
     C                   EVAL      INUSTM = FNTXOT                                            CGL132
     C                   EVAL      INUSCO = FNTXCO                                            CGL132
     C                   IF        FNTXOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCND0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FNTXOD = BJRDNB                                            CGL132
     C                   EVAL      FNTXON = PSUSER                                            CGL132
     C                   MOVE      WWTIME        FNTXOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNCDOV <> A_FVCDOV                                         CGL132
     C                             OR FNCDCO <> A_FVCDCO                                    MD027525
     C                   EVAL      INNAHO = FNNAHO                                            CGL132
     C                   EVAL      INUSIN = 'US COUNTRY OF +                                  CGL132
     C                                      DOMICILE'                                         CGL132
     C                   EVAL      INUSSV = FNCDSV                                            CGL132
     C                   EVAL      INUSSD = FNCDSD                                            CGL132
     C                   EVAL      INUSSM = FNCDST                                            CGL132
     C                   EVAL      INUSOV = FNCDOV                                            CGL132
     C                   EVAL      INUSUN = FNCDON                                            CGL132
     C                   EVAL      INUSDT = FNCDOD                                            CGL132
     C                   EVAL      INUSTM = FNCDOT                                            CGL132
     C                   EVAL      INUSCO = FNCDCO                                            CGL132
     C                   IF        FNCDOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCND0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FNCDOD = BJRDNB                                            CGL132
     C                   EVAL      FNCDON = PSUSER                                            CGL132
     C                   MOVE      WWTIME        FNCDOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNTEOV <> A_FVTEOV                                         CGL132
     C                             OR FNTECO <> A_FVTECO                                    MD027525
     C                   EVAL      INNAHO = FNNAHO                                            CGL132
     C                   EVAL      INUSIN = 'US TELEPHONE'                                    CGL132
     C                   EVAL      INUSSV = FNTESV                                            CGL132
     C                   EVAL      INUSSD = FNTESD                                            CGL132
     C                   EVAL      INUSSM = FNTEST                                            CGL132
     C                   EVAL      INUSOV = FNTEOV                                            CGL132
     C                   EVAL      INUSUN = FNTEON                                            CGL132
     C                   EVAL      INUSDT = FNTEOD                                            CGL132
     C                   EVAL      INUSTM = FNTEOT                                            CGL132
     C                   EVAL      INUSCO = FNTECO                                            CGL132
     C                   IF        FNTEOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCND0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FNTEOD = BJRDNB                                            CGL132
     C                   EVAL      FNTEON = PSUSER                                            CGL132
     C                   MOVE      WWTIME        FNTEOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNGCOV <> A_FVGCOV                                         CGL132
     C                             OR FNGCCO <> A_FVGCCO                                    MD027525
     C                   EVAL      INNAHO = FNNAHO                                            CGL132
     C                   EVAL      INUSIN = 'US GREEN CARD'                                   CGL132
     C                   EVAL      INUSSV = FNGCSV                                            CGL132
     C                   EVAL      INUSSD = FNGCSD                                            CGL132
     C                   EVAL      INUSSM = FNGCST                                            CGL132
     C                   EVAL      INUSOV = FNGCOV                                            CGL132
     C                   EVAL      INUSUN = FNGCON                                            CGL132
     C                   EVAL      INUSDT = FNGCOD                                            CGL132
     C                   EVAL      INUSTM = FNGCOT                                            CGL132
     C                   EVAL      INUSCO = FNGCCO                                            CGL132
     C                   IF        FNGCOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCND0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FNGCOD = BJRDNB                                            CGL132
     C                   EVAL      FNGCON = PSUSER                                            CGL132
     C                   MOVE      WWTIME        FNGCOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNCBOV <> A_FVCBOV                                         CGL132
     C                             OR FNCBCO <> A_FVCBCO                                    MD027525
     C                   EVAL      INNAHO = FNNAHO                                            CGL132
     C                   EVAL      INUSIN = 'US COUNTRY OF +                                  CGL132
     C                                      BIRTH'                                            CGL132
     C                   EVAL      INUSSV = FNCBSV                                            CGL132
     C                   EVAL      INUSSD = FNCBSD                                            CGL132
     C                   EVAL      INUSSM = FNCBST                                            CGL132
     C                   EVAL      INUSOV = FNCBOV                                            CGL132
     C                   EVAL      INUSUN = FNCBON                                            CGL132
     C                   EVAL      INUSDT = FNCBOD                                            CGL132
     C                   EVAL      INUSTM = FNCBOT                                            CGL132
     C                   EVAL      INUSCO = FNCBCO                                            CGL132
     C                   IF        FNCBOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCND0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FNCBOD = BJRDNB                                            CGL132
     C                   EVAL      FNCBON = PSUSER                                            CGL132
     C                   MOVE      WWTIME        FNCBOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNJAOV <> A_FVJAOV                                         CGL132
     C                             OR FNJACO <> A_FVJACO                                    MD027525
     C                   EVAL      INNAHO = FNNAHO                                            CGL132
     C                   EVAL      INUSIN = 'US JOINT ACCOUNT +                               CGL132
     C                                      MEMBER'                                           CGL132
     C                   EVAL      INUSSV = FNJASV                                            CGL132
     C                   EVAL      INUSSD = FNJASD                                            CGL132
     C                   EVAL      INUSSM = FNJAST                                            CGL132
     C                   EVAL      INUSOV = FNJAOV                                            CGL132
     C                   EVAL      INUSUN = FNJAON                                            CGL132
     C                   EVAL      INUSDT = FNJAOD                                            CGL132
     C                   EVAL      INUSTM = FNJAOT                                            CGL132
     C                   EVAL      INUSCO = FNJACO                                            CGL132
     C                   IF        FNJAOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCND0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FNJAOD = BJRDNB                                            CGL132
     C                   EVAL      FNJAON = PSUSER                                            CGL132
     C                   MOVE      WWTIME        FNJAOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNHMOV <> A_FVHMOV                                         CGL132
     C                             OR FNHMCO <> A_FVHMCO                                    MD027525
     C                   EVAL      INNAHO = FNNAHO                                            CGL132
     C                   EVAL      INUSIN = 'HOLD MAIL'                                       CGL132
     C                   EVAL      INUSSV = FNHMSV                                            CGL132
     C                   EVAL      INUSSD = FNHMSD                                            CGL132
     C                   EVAL      INUSSM = FNHMST                                            CGL132
     C                   EVAL      INUSOV = FNHMOV                                            CGL132
     C                   EVAL      INUSUN = FNHMON                                            CGL132
     C                   EVAL      INUSDT = FNHMOD                                            CGL132
     C                   EVAL      INUSTM = FNHMOT                                            CGL132
     C                   EVAL      INUSCO = FNHMCO                                            CGL132
     C                   IF        FNHMOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCND0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FNHMOD = BJRDNB                                            CGL132
     C                   EVAL      FNHMON = PSUSER                                            CGL132
     C                   MOVE      WWTIME        FNHMOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNRPOV <> A_FVRPOV                                         CGL132
     C                             OR FNRPCO <> A_FVRPCO                                    MD027525
     C                   EVAL      INNAHO = FNNAHO                                            CGL132
     C                   EVAL      INUSIN = 'REG PAYMENT +                                    CGL132
     C                                      INST TO US'                                       CGL132
     C                   EVAL      INUSSV = FNRPSV                                            CGL132
     C                   EVAL      INUSSD = FNRPSD                                            CGL132
     C                   EVAL      INUSSM = FNRPST                                            CGL132
     C                   EVAL      INUSOV = FNRPOV                                            CGL132
     C                   EVAL      INUSUN = FNRPON                                            CGL132
     C                   EVAL      INUSDT = FNRPOD                                            CGL132
     C                   EVAL      INUSTM = FNRPOT                                            CGL132
     C                   EVAL      INUSCO = FNRPCO                                            CGL132
     C                   IF        FNRPOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCND0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FNRPOD = BJRDNB                                            CGL132
     C                   EVAL      FNRPON = PSUSER                                            CGL132
     C                   MOVE      WWTIME        FNRPOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNIDOV <> A_FVIDOV                                         CGL132
     C                             OR FNIDCO <> A_FVIDCO                                    MD027525
     C                   EVAL      INNAHO = FNNAHO                                            CGL132
     C                   EVAL      INUSIN = 'US IDENTITY +                                    CGL132
     C                                      DOCUMENT'                                         CGL132
     C                   EVAL      INUSSV = FNIDSV                                            CGL132
     C                   EVAL      INUSSD = FNIDSD                                            CGL132
     C                   EVAL      INUSSM = FNIDST                                            CGL132
     C                   EVAL      INUSOV = FNIDOV                                            CGL132
     C                   EVAL      INUSUN = FNIDON                                            CGL132
     C                   EVAL      INUSDT = FNIDOD                                            CGL132
     C                   EVAL      INUSTM = FNIDOT                                            CGL132
     C                   EVAL      INUSCO = FNIDCO                                            CGL132
     C                   IF        FNIDOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCND0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FNIDOD = BJRDNB                                            CGL132
     C                   EVAL      FNIDON = PSUSER                                            CGL132
     C                   MOVE      WWTIME        FNIDOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        FNMCOV <> A_FVMCOV                                         CGL132
     C                             OR FNMCCO <> A_FVMCCO                                    MD027525
     C                   EVAL      INNAHO = FNNAHO                                            CGL132
     C                   EVAL      INUSIN = 'MAILING +                                        CGL132
     C                                      COUNTRY'                                          CGL132
     C                   EVAL      INUSSV = FNMCSV                                            CGL132
     C                   EVAL      INUSSD = FNMCSD                                            CGL132
     C                   EVAL      INUSSM = FNMCST                                            CGL132
     C                   EVAL      INUSOV = FNMCOV                                            CGL132
     C                   EVAL      INUSUN = FNMCON                                            CGL132
     C                   EVAL      INUSDT = FNMCOD                                            CGL132
     C                   EVAL      INUSTM = FNMCOT                                            CGL132
     C                   EVAL      INUSCO = FNMCCO                                            CGL132
     C                   IF        FNMCOT <> *BLANKS                                          CGL132
     C                   WRITE     SDINCND0                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      FNMCOD = BJRDNB                                            CGL132
     C                   EVAL      FNMCON = PSUSER                                            CGL132
     C                   MOVE      WWTIME        FNMCOT                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                            MD027473
     C                   IF        FNAUOV <> A_FVAUOV                                       MD027473
     C                   EVAL      INNAHO = FNNAHO                                          MD027473
     C                   EVAL      INUSIN = 'US ACCOUNT +                                   MD027473
     C                                      AUTHORITY +                                     MD027473
     C                                      HOLDER'                                         MD027473
     C                   EVAL      INUSSV = FNAUSV                                          MD027473
     C                   EVAL      INUSSD = FNAUSD                                          MD027473
     C                   EVAL      INUSSM = FNAUST                                          MD027473
     C                   EVAL      INUSOV = FNAUOV                                          MD027473
     C                   EVAL      INUSUN = FNAUON                                          MD027473
     C                   EVAL      INUSDT = FNAUOD                                          MD027473
     C                   EVAL      INUSTM = FNAUOT                                          MD027473
     C                   EVAL      INUSCO = FNAUCO                                          MD027473
     C                   IF        FNAUOT <> *BLANKS                                        MD027473
     C                   WRITE     SDINCND0                                                 MD027473
     C                   ENDIF                                                              MD027473
     C                   EVAL      FNAUOD = BJRDNB                                          MD027473
     C                   EVAL      FNAUON = PSUSER                                          MD027473
     C                   MOVE      WWTIME        FNAUOT                                     MD027473
     C                   ENDIF                                                              MD027473
                                                                                              CGL132
     C                   EVAL      FNCLAC = A_FVCLAC                                          CGL132
     C                   EVAL      FNCLAD = A_FVCLAD                                          CGL132
     C                   EVAL      FNPCLA = A_FVPCLA                                          CGL132
     C                   EVAL      FNHMSV = A_FVHMSV                                          CGL132
     C                   EVAL      FNHMSD = A_FVHMSD                                          CGL132
     C                   EVAL      FNHMOV = A_FVHMOV                                          CGL132
     C                   EVAL      FNHMD1 = A_FVHMD1                                          CGL132
     C                   EVAL      FNHMD2 = A_FVHMD2                                          CGL132
     C                   EVAL      FNHMD3 = A_FVHMD3                                          CGL132
     C                   EVAL      FNHMD4 = A_FVHMD4                                          CGL132
     C                   EVAL      FNHMD5 = A_FVHMD5                                          CGL132
     C                   EVAL      FNHMS1 = A_FVHMS1                                          CGL132
     C                   EVAL      FNHMS2 = A_FVHMS2                                          CGL132
     C                   EVAL      FNHMS3 = A_FVHMS3                                          CGL132
     C                   EVAL      FNHMS4 = A_FVHMS4                                          CGL132
     C                   EVAL      FNHMS5 = A_FVHMS5                                          CGL132
     C                   EVAL      FNHMCO = A_FVHMCO                                          CGL132
     C                   EVAL      FNMCSV = A_FVMCSV                                          CGL132
     C                   EVAL      FNMCSD = A_FVMCSD                                          CGL132
     C                   EVAL      FNMCOV = A_FVMCOV                                          CGL132
     C                   EVAL      FNMCD1 = A_FVMCD1                                          CGL132
     C                   EVAL      FNMCD2 = A_FVMCD2                                          CGL132
     C                   EVAL      FNMCD3 = A_FVMCD3                                          CGL132
     C                   EVAL      FNMCD4 = A_FVMCD4                                          CGL132
     C                   EVAL      FNMCD5 = A_FVMCD5                                          CGL132
     C                   EVAL      FNMCS1 = A_FVMCS1                                          CGL132
     C                   EVAL      FNMCS2 = A_FVMCS2                                          CGL132
     C                   EVAL      FNMCS3 = A_FVMCS3                                          CGL132
     C                   EVAL      FNMCS4 = A_FVMCS4                                          CGL132
     C                   EVAL      FNMCS5 = A_FVMCS5                                          CGL132
     C                   EVAL      FNMCCO = A_FVMCCO                                          CGL132
     C                   EVAL      FNRPSV = A_FVRPSV                                          CGL132
     C                   EVAL      FNRPSD = A_FVRPSD                                          CGL132
     C                   EVAL      FNRPOV = A_FVRPOV                                          CGL132
     C                   EVAL      FNRPD1 = A_FVRPD1                                          CGL132
     C                   EVAL      FNRPD2 = A_FVRPD2                                          CGL132
     C                   EVAL      FNRPD3 = A_FVRPD3                                          CGL132
     C                   EVAL      FNRPD4 = A_FVRPD4                                          CGL132
     C                   EVAL      FNRPD5 = A_FVRPD5                                          CGL132
     C                   EVAL      FNRPS1 = A_FVRPS1                                          CGL132
     C                   EVAL      FNRPS2 = A_FVRPS2                                          CGL132
     C                   EVAL      FNRPS3 = A_FVRPS3                                          CGL132
     C                   EVAL      FNRPS4 = A_FVRPS4                                          CGL132
     C                   EVAL      FNRPS5 = A_FVRPS5                                          CGL132
     C                   EVAL      FNRPCO = A_FVRPCO                                          CGL132
     C                   EVAL      FNCISV = A_FVCISV                                          CGL132
     C                   EVAL      FNCISD = A_FVCISD                                          CGL132
     C                   EVAL      FNCIOV = A_FVCIOV                                          CGL132
     C                   EVAL      FNCID1 = A_FVCID1                                          CGL132
     C                   EVAL      FNCID2 = A_FVCID2                                          CGL132
     C                   EVAL      FNCID3 = A_FVCID3                                          CGL132
     C                   EVAL      FNCID4 = A_FVCID4                                          CGL132
     C                   EVAL      FNCID5 = A_FVCID5                                          CGL132
     C                   EVAL      FNCIS1 = A_FVCIS1                                          CGL132
     C                   EVAL      FNCIS2 = A_FVCIS2                                          CGL132
     C                   EVAL      FNCIS3 = A_FVCIS3                                          CGL132
     C                   EVAL      FNCIS4 = A_FVCIS4                                          CGL132
     C                   EVAL      FNCIS5 = A_FVCIS5                                          CGL132
     C                   EVAL      FNCICO = A_FVCICO                                          CGL132
     C                   EVAL      FNCBSV = A_FVCBSV                                          CGL132
     C                   EVAL      FNCBSD = A_FVCBSD                                          CGL132
     C                   EVAL      FNCBOV = A_FVCBOV                                          CGL132
     C                   EVAL      FNCBD1 = A_FVCBD1                                          CGL132
     C                   EVAL      FNCBD2 = A_FVCBD2                                          CGL132
     C                   EVAL      FNCBD3 = A_FVCBD3                                          CGL132
     C                   EVAL      FNCBD4 = A_FVCBD4                                          CGL132
     C                   EVAL      FNCBD5 = A_FVCBD5                                          CGL132
     C                   EVAL      FNCBS1 = A_FVCBS1                                          CGL132
     C                   EVAL      FNCBS2 = A_FVCBS2                                          CGL132
     C                   EVAL      FNCBS3 = A_FVCBS3                                          CGL132
     C                   EVAL      FNCBS4 = A_FVCBS4                                          CGL132
     C                   EVAL      FNCBS5 = A_FVCBS5                                          CGL132
     C                   EVAL      FNCBCO = A_FVCBCO                                          CGL132
     C                   EVAL      FNCDSV = A_FVCDSV                                          CGL132
     C                   EVAL      FNCDSD = A_FVCDSD                                          CGL132
     C                   EVAL      FNCDOV = A_FVCDOV                                          CGL132
     C                   EVAL      FNCDD1 = A_FVCDD1                                          CGL132
     C                   EVAL      FNCDD2 = A_FVCDD2                                          CGL132
     C                   EVAL      FNCDD3 = A_FVCDD3                                          CGL132
     C                   EVAL      FNCDD4 = A_FVCDD4                                          CGL132
     C                   EVAL      FNCDD5 = A_FVCDD5                                          CGL132
     C                   EVAL      FNCDS1 = A_FVCDS1                                          CGL132
     C                   EVAL      FNCDS2 = A_FVCDS2                                          CGL132
     C                   EVAL      FNCDS3 = A_FVCDS3                                          CGL132
     C                   EVAL      FNCDS4 = A_FVCDS4                                          CGL132
     C                   EVAL      FNCDS5 = A_FVCDS5                                          CGL132
     C                   EVAL      FNCDCO = A_FVCDCO                                          CGL132
     C                   EVAL      FNGCSV = A_FVGCSV                                          CGL132
     C                   EVAL      FNGCSD = A_FVGCSD                                          CGL132
     C                   EVAL      FNGCOV = A_FVGCOV                                          CGL132
     C                   EVAL      FNGCD1 = A_FVGCD1                                          CGL132
     C                   EVAL      FNGCD2 = A_FVGCD2                                          CGL132
     C                   EVAL      FNGCD3 = A_FVGCD3                                          CGL132
     C                   EVAL      FNGCD4 = A_FVGCD4                                          CGL132
     C                   EVAL      FNGCD5 = A_FVGCD5                                          CGL132
     C                   EVAL      FNGCS1 = A_FVGCS1                                          CGL132
     C                   EVAL      FNGCS2 = A_FVGCS2                                          CGL132
     C                   EVAL      FNGCS3 = A_FVGCS3                                          CGL132
     C                   EVAL      FNGCS4 = A_FVGCS4                                          CGL132
     C                   EVAL      FNGCS5 = A_FVGCS5                                          CGL132
     C                   EVAL      FNGCCO = A_FVGCCO                                          CGL132
     C                   EVAL      FNIDSV = A_FVIDSV                                          CGL132
     C                   EVAL      FNIDSD = A_FVIDSD                                          CGL132
     C                   EVAL      FNIDOV = A_FVIDOV                                          CGL132
     C                   EVAL      FNIDD1 = A_FVIDD1                                          CGL132
     C                   EVAL      FNIDD2 = A_FVIDD2                                          CGL132
     C                   EVAL      FNIDD3 = A_FVIDD3                                          CGL132
     C                   EVAL      FNIDD4 = A_FVIDD4                                          CGL132
     C                   EVAL      FNIDD5 = A_FVIDD5                                          CGL132
     C                   EVAL      FNIDS1 = A_FVIDS1                                          CGL132
     C                   EVAL      FNIDS2 = A_FVIDS2                                          CGL132
     C                   EVAL      FNIDS3 = A_FVIDS3                                          CGL132
     C                   EVAL      FNIDS4 = A_FVIDS4                                          CGL132
     C                   EVAL      FNIDS5 = A_FVIDS5                                          CGL132
     C                   EVAL      FNIDCO = A_FVIDCO                                          CGL132
     C                   EVAL      FNJASV = A_FVJASV                                          CGL132
     C                   EVAL      FNJASD = A_FVJASD                                          CGL132
     C                   EVAL      FNJAOV = A_FVJAOV                                          CGL132
     C                   EVAL      FNJAD1 = A_FVJAD1                                          CGL132
     C                   EVAL      FNJAD2 = A_FVJAD2                                          CGL132
     C                   EVAL      FNJAD3 = A_FVJAD3                                          CGL132
     C                   EVAL      FNJAD4 = A_FVJAD4                                          CGL132
     C                   EVAL      FNJAD5 = A_FVJAD5                                          CGL132
     C                   EVAL      FNJAS1 = A_FVJAS1                                          CGL132
     C                   EVAL      FNJAS2 = A_FVJAS2                                          CGL132
     C                   EVAL      FNJAS3 = A_FVJAS3                                          CGL132
     C                   EVAL      FNJAS4 = A_FVJAS4                                          CGL132
     C                   EVAL      FNJAS5 = A_FVJAS5                                          CGL132
     C                   EVAL      FNJACO = A_FVJACO                                          CGL132
     C                   EVAL      FNTESV = A_FVTESV                                          CGL132
     C                   EVAL      FNTESD = A_FVTESD                                          CGL132
     C                   EVAL      FNTEOV = A_FVTEOV                                          CGL132
     C                   EVAL      FNTED1 = A_FVTED1                                          CGL132
     C                   EVAL      FNTED2 = A_FVTED2                                          CGL132
     C                   EVAL      FNTED3 = A_FVTED3                                          CGL132
     C                   EVAL      FNTED4 = A_FVTED4                                          CGL132
     C                   EVAL      FNTED5 = A_FVTED5                                          CGL132
     C                   EVAL      FNTES1 = A_FVTES1                                          CGL132
     C                   EVAL      FNTES2 = A_FVTES2                                          CGL132
     C                   EVAL      FNTES3 = A_FVTES3                                          CGL132
     C                   EVAL      FNTES4 = A_FVTES4                                          CGL132
     C                   EVAL      FNTES5 = A_FVTES5                                          CGL132
     C                   EVAL      FNTECO = A_FVTECO                                          CGL132
     C                   EVAL      FNTXSV = A_FVTXSV                                          CGL132
     C                   EVAL      FNTXSD = A_FVTXSD                                          CGL132
     C                   EVAL      FNTXOV = A_FVTXOV                                          CGL132
     C                   EVAL      FNTXD1 = A_FVTXD1                                          CGL132
     C                   EVAL      FNTXD2 = A_FVTXD2                                          CGL132
     C                   EVAL      FNTXD3 = A_FVTXD3                                          CGL132
     C                   EVAL      FNTXD4 = A_FVTXD4                                          CGL132
     C                   EVAL      FNTXD5 = A_FVTXD5                                          CGL132
     C                   EVAL      FNTXS1 = A_FVTXS1                                          CGL132
     C                   EVAL      FNTXS2 = A_FVTXS2                                          CGL132
     C                   EVAL      FNTXS3 = A_FVTXS3                                          CGL132
     C                   EVAL      FNTXS4 = A_FVTXS4                                          CGL132
     C                   EVAL      FNTXS5 = A_FVTXS5                                          CGL132
     C                   EVAL      FNTXCO = A_FVTXCO                                          CGL132
     C                   EVAL      FNEXEM = A_FVEXEM                                          CGL132
     C                   EVAL      FNEXER = A_FVEXER                                          CGL132
     C                   EVAL      FNEXED = A_FVEXED                                          CGL132
     C                   EVAL      FNEXET = A_FVEXET                                          CGL132
     C                   EVAL      FNEXEU = A_FVEXEU                                          CGL132
     C                   EVAL      FNREPT = A_FVREPT                                          CGL132
     C                   EVAL      FNGIIN = A_FVGIIN                                          CGL132
     C                   EVAL      FNGIID = A_FVGIID                                          CGL132
     C                   EVAL      FNGIIO = A_FVGIIO                                          CGL132
     C                   EVAL      FNUTIN = A_FVUTIN                                          CGL132
     C                   EVAL      FNGREC = A_FVGREC                                          CGL132
     C                   EVAL      FNMAIL = A_FVMAIL                                          CGL132
     C                   EVAL      FNPHON = A_FVPHON                                          CGL132
     C                   EVAL      FNNHTY = A_FVNHTY                                          CGL132
     C                   EVAL      FNNHST = A_FVNHST                                          CGL132
     C                   EVAL      FNRPTT = A_FVRPTT                                          CGL132
     C                   EVAL      FNRPTR = A_FVRPTR                                          CGL132
     C                   EVAL      FNRPTD = A_FVRPTD                                          CGL132
     C                   EVAL      FNRPTM = A_FVRPTM                                          CGL132
     C                   IF        FNRPTM = '******'                                        MD033947
     C                   MOVE      TimeStamp     WTime                                      MD033947
     C     *HMS0         MOVE      WTime         FNRPTM                                     MD033947
     C                   ENDIF                                                              MD033947
     C                   EVAL      FNRPTU = A_FVRPTU                                          CGL132
     C                   EVAL      FNHVAC = A_FVHVAC                                          CGL132
     C                   EVAL      FNINFC = A_FVINFC                                          CGL132
     C                   EVAL      FNEXMA = A_FVEXMA                                          CGL132
     C                   EVAL      FNEXID = A_FVEXID                                          CGL132
     C                   EVAL      FNLDAT = BJRDNB                                            CGL132
     C                   EVAL      FNLCTP = 'A'                                               CGL132
     C                   EVAL      FNLUSR = PSUSER                                            CGL132
     C                   EVAL      FNAUSV = A_FVAUSV                                        MD027473
     C                   EVAL      FNAUSD = A_FVAUSD                                        MD027473
     C                   EVAL      FNAUOV = A_FVAUOV                                        MD027473
     C                   EVAL      FNAUD1 = A_FVAUD1                                        MD027473
     C                   EVAL      FNAUD2 = A_FVAUD2                                        MD027473
     C                   EVAL      FNAUD3 = A_FVAUD3                                        MD027473
     C                   EVAL      FNAUD4 = A_FVAUD4                                        MD027473
     C                   EVAL      FNAUD5 = A_FVAUD5                                        MD027473
     C                   EVAL      FNAUS1 = A_FVAUS1                                        MD027473
     C                   EVAL      FNAUS2 = A_FVAUS2                                        MD027473
     C                   EVAL      FNAUS3 = A_FVAUS3                                        MD027473
     C                   EVAL      FNAUS4 = A_FVAUS4                                        MD027473
     C                   EVAL      FNAUS5 = A_FVAUS5                                        MD027473
     C                   EVAL      FNAUCO = A_FVAUCO                                        MD027473
     C                   UPDATE    SDFTNHD0                                                   CGL132
                                                                                              CGL132
      ** Update exceptions on Joint Account                                                 MD027115
                                                                                            MD027115
     C     NHNAHO        SETLL     SDJACCL7                                                 MD027115
     C     NHNAHO        READE     SDJACCL7                                                 MD027115
                                                                                            MD027115
      * Override SDFTCSL0                                                                   MD027115
     C                   CALL      'QCMDEXC'                                                MD027115
     C                   PARM                    CMDNH                                      MD027115
     C                   PARM                    CMDLEN                                     MD027115
                                                                                            MD027115
     C                   CALL      'QCMDEXC'                                                MD027115
     C                   PARM                    CMDIN                                      MD027115
     C                   PARM                    CMDLEN                                     MD027115
                                                                                            MD027115
     C                   DOW       NOT %EOF(SDJACCL7)                                       MD027115
     C                   CALL      'SD000715'                                               MD027115
     C                   PARM                    JCJANO                                     MD027115
     C                   PARM      '0'           PCommitCUSD                                MD033947
     C                   PARM      '1'           PCommitNAHL                                MD033947
                                                                                            MD027115
     C     NHNAHO        READE     SDJACCL7                                                 MD027115
     C                   ENDDO                                                              MD027115
                                                                                            MD027115
     C                   ENDIF                                                                CGL132

     C                   Z-ADD     *ZERO         WUNORC
     C                   Z-ADD     1             WUNOAM
     C                   Z-ADD     *ZERO         WUNOIN
     C                   Z-ADD     *ZERO         WUNODL

     C                   MOVEL     'SDCUSTPD'    WFLNAME
     C                   EXSR      SRSnChrC

     C                   ENDSR

      ****************************************************************
      /EJECT
      ****************************************************************
      ** SRDelete - Delete a Non-A/C Holder                          *
      ****************************************************************

     C     SRDelete      BEGSR

      ** Access Non-A/C Holder

     C     A_NANAHO      CHAIN     SDNAHOL0                           99

      ** Database Error

     C     *In99         IFEQ      *On
     C                   MOVEL     A_NANAHO      DBKEY
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '013'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF

      ** Update 'BEFORE' Status

     C                   MOVEL(P)  NAHODF        B_NAHOD

      ** Set Non-A/C Holder fields on delete

     C                   EVAL      NHLCDT = BJRDNB
     C                   EVAL      NHCHTP = 'D'
     C                   EVAL      NHLUSR = A_NALUSR                                          CGL132

      ** Timestamp

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   EVAL      NHTMST = TimeStamp

      ** Front Office ID

     C                   EVAL      NHFRNT = A_NAFRNT

      ** Update Record

     C                   UPDATE    SDNAHOD0
                                                                                              CGL157
      ** Access CRS Transaction Details if CGL157 is *ON                                      CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
     C     A_NANAHO      CHAIN     SDCRNHL0                             99                    CGL157
                                                                                              CGL157
      ** Database error                                                                       CGL157
     C                   IF        NOT %FOUND(SDCRNHL0)                                       CGL157
     C                   EVAL      DBKEY  = A_NANAHO                                          CGL157
     C                   EVAL      DBFILE = 'SDCRNHPD'                                        CGL157
     C                   EVAL      DBASE  =  903                                              CGL157
     C                   EXSR      SRErr                                                      CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      NRLCDT = BJRDNB                                            CGL157
     C                   EVAL      NRCHTP = 'D'                                               CGL157
     C                   EVAL      NRLUSR = PSUSER                                            CGL157
                                                                                              CGL157
     C                   UPDATE    SDCRNHD0                                                   CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
                                                                                              CGL132
      ** Access customer details recrod                                                       CGL132
                                                                                              CGL132
     C     A_NANAHO      CHAIN     SDFTNHL0                           99                      CGL132
                                                                                              CGL132
      ** Database error                                                                       CGL132
                                                                                              CGL132
     C     *IN99         IFEQ      '1'                                                        CGL132
     C                   MOVEL     A_NANAHO      DBKEY                                        CGL132
     C                   MOVEL     'SDFTNHPD'    DBFILE                                       CGL132
     C                   MOVEL     '005'         DBASE                                        CGL132
     C                   EXSR      SRERR                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   EVAL      FNLDAT = BJRDNB                                            CGL132
     C                   EVAL      FNLCTP = 'D'                                               CGL132
     C                   EVAL      FNLUSR = PSUSER                                            CGL132
                                                                                              CGL132
     C                   UPDATE    SDFTNHD0                                                   CGL132
                                                                                              CGL132
     C                   ENDIF                                                                CGL132

     C                   MOVEL     NAHODF        WUDELR

      ** Write Deleted Record - SD Deleted Records File

     C                   CLEAR                   PBRC
     C                   MOVEL     'SDNAHOPD'    PBFNME
     C                   MOVEL     A_NANAHO      PBLKEY
     C                   MOVEL     WUDR01        PBDR01
     C                   MOVEL     WUDR02        PBDR02
     C                   MOVEL     WUDR03        PBDR03
     C                   MOVEL     WUDR04        PBDR04
     C                   MOVEL     WUDR05        PBDR05
     C                   MOVEL     WUDR06        PBDR06
     C                   MOVEL     WUDR07        PBDR07
     C                   MOVEL     WUDR08        PBDR08
     C                   MOVEL     WUDR09        PBDR09
     C                   MOVEL     WUDR10        PBDR10
     C                   MOVEL     WUDR11        PBDR11
     C                   MOVEL     WUDR12        PBDR12
     C                   MOVEL     BJRDNB        PBLCD
     C                   MOVEL     'D'           PBTYLC

     C                   CALL      'SD0520X'
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    PBRC

      ** Error detected?

     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        Dbkey
     C                   MOVEL     A_NANAHO      Dbkey
     C                   MOVEL     'SDDELRL0'    Dbfile
     C                   MOVEL     '014'         Dbase
     C                   EXSR      SRERR
     C                   ENDIF

     C                   Z-ADD     -1            WUNORC
     C                   Z-ADD     *ZERO         WUNOAM
     C                   Z-ADD     *ZERO         WUNOIN
     C                   Z-ADD     1             WUNODL

     C                   MOVEL     'SDNAHOPD'    WFLNAME
     C                   EXSR      SRSnChrC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSnChrC - Change Standing Data Controls                     *
      *****************************************************************
     C     SRSnChrC      BEGSR

     C                   MOVEL     *BLANK        W0RTN

      ** Move key fields to @AHREAU

     C                   MOVEL     *BLANK        AHFLNM
     C                   MOVEL     WFLNAME       AHFLNM

     C     Klchsn        KLIST
     C                   KFLD                    AHFLNM
     C     Klchsn        CHAIN     @AHREAU                            90

      ** Database Error

     C     *In90         IFEQ      *On
     C                   MOVEL     AHFLNM        DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     '017'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF

     C                   ADD       AHNORC        WUNORC
     C                   ADD       AHNOIN        WUNOIN
     C                   ADD       AHNOAM        WUNOAM
     C                   ADD       AHNODL        WUNODL

     C                   Z-ADD     WUNORC        AHNORC
     C                   Z-ADD     WUNOIN        AHNOIN
     C                   Z-ADD     WUNOAM        AHNOAM
     C                   Z-ADD     WUNODL        AHNODL

      ** Update record

     C                   UPDATE    @AHREAU

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR

      **  Program parameters

     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD
     C                   PARM                    SDVNAHL
     C                   PARM                    SDVFTNH                                      CGL132
     C                   PARM                    SDVCRNH                                      CGL157
     C                   PARM                    PCrsdF                                       CGL157

      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         Dbkey
     C                   MOVEL     'SDBANKPD'    Dbfile
     C                   MOVEL     '900'         Dbase
     C                   EXSR      SRERR
     C                   ENDIF

      ** Check if CSC011 is installed

     C                   EVAL      CSC011 = 'N'

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error

     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 905
     C                   EXSR      SRERR
     C                   ENDIF

     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
                                                                                              CGL157
      ** Check if enhancement CGL157 is on                                                    CGL157
                                                                                              CGL157
     C                   CALLB     'AOSARDR0'                                                 CGL157
     C                   PARM      *BLANKS       PRtCd                                        CGL157
     C                   PARM      '*VERIFY'     POptn                                        CGL157
     C                   PARM      'CGL157'      PSARD                                        CGL157
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL157
                                                                                              CGL157
     C                   IF        PRtCd <> *BLANKS AND                                       CGL157
     C                             PRtCd <> '*NRF   '                                         CGL157
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL157
     C                   EVAL      DBKEY  = 'CGL157'                                          CGL157
     C                   EVAL      DBASE  = 903                                               CGL157
     C                   EXSR      SRERR                                                      CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        PRtCd = *BLANKS                                            CGL157
     C                   EVAL      CGL157 = 'Y'                                               CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      CGL157 = 'N'                                               CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL132
      ** Check if CGL132 is installed                                                         CGL132
                                                                                              CGL132
     C                   EVAL      CGL132 = 'N'                                               CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       PRtCd                                        CGL132
     C                   PARM      '*VERIFY'     POptn                                        CGL132
     C                   PARM      'CGL132'      PSard                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
      ** Database error                                                                       CGL132
                                                                                              CGL132
     C                   IF        (Prtcd <> *BLANKS) and                                     CGL132
     C                             (Prtcd <> '*NRF   ')                                       CGL132
     C                   EVAL      DBKEY = 'CGL132'                                           CGL132
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL132
     C                   EVAL      DBASE = 906                                                CGL132
     C                   EXSR      SRERR                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        PRtCd = *BLANKS                                            CGL132
     C                   EVAL      CGL132 = 'Y'                                               CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *Blanks       PRtCd                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Check if Private Banking Module is available                                         CSW207
                                                                                              CSW207
     C                   CALL      'AOMMODR0'                                                 CSW207
     C                   PARM                    PRtCd                                        CSW207
     C                   PARM      '*FIRST'      POptn                                        CSW207
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *Blanks                                           CSW207
     C                   MOVEL     'SDMMODPD'    Dbfile                                       CSW207
     C                   MOVEL     '901'         Dbase                                        CSW207
     C                   MOVEL     POptn         Dbkey                                        CSW207
     C                   EXSR      SRERR                                                      CSW207
     C                   ELSE                                                                 CSW207
     C                   IF        BGN4ST = 'Y'                                               CSW207
     C                   EVAL      wPrivBank = 'Y'                                            CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
                                                                                              CGL132
     C                   CALL      'AOSVALR0'                                                 CGL132
     C                   PARM      *BLANKS       PRtcd                                        CGL132
     C                   PARM      SysVal1       SValK1                                       CGL132
     C                   PARM                    SVal1                                        CGL132
     C                   PARM                    SValK2                                       CGL132
     C                   PARM                    SVal2                                        CGL132
     C                   PARM                    SValK3                                       CGL132
     C                   PARM                    SVal3                                        CGL132
     C                   PARM                    SValK4                                       CGL132
     C                   PARM                    SVal4                                        CGL132
     C                   PARM                    SValK5                                       CGL132
     C                   PARM                    SVal5                                        CGL132
     C                   PARM                    SValK6                                       CGL132
     C                   PARM                    SVal6                                        CGL132
     C                   PARM                    SValK7                                       CGL132
     C                   PARM                    SVal7                                        CGL132
     C                   PARM                    SValK8                                       CGL132
     C                   PARM                    SVal8                                        CGL132
     C                   PARM                    SValK9                                       CGL132
     C                   PARM                    SVal9                                        CGL132
     C                   PARM                    SValK0                                       CGL132
     C                   PARM                    SVal10                                       CGL132
                                                                                              CGL132
     C                   IF        PRtcd <> *Blanks  AND                                      CGL132
     C                             PRtcd <> '*NRF   '                                         CGL132
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CGL132
     C                   EVAL      DBKEY = SValK1                                             CGL132
     C                   EVAL      DBASE = 907                                                CGL132
     C                   EVAL      DBPGM = 'SDNAHLUPD'                                        CGL132
     C                   EXSR      SRERR                                                      CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132

      *                                                                                       CER047
      ** Call AOSARDR0 to check for CER047                                                    CER047
      *                                                                                       CER047
     C                   CALL      'AOSARDR0'                                                 CER047
     C                   PARM      *BLANKS       PRtCd                                        CER047
     C                   PARM      '*VERIFY'     POptn                                        CER047
     C                   PARM      'CER047'      PSard                                        CER047
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER047
      *                                                                                       CER047
     C                   IF        PRtCd = *BLANKS                                            CER047
      *                                                                                       CER047
     C                   EVAL      CER047 = 'Y'                                               CER047
      *                                                                                       CER047
     C                   ELSE                                                                 CER047
      *                                                                                       CER047
     C                   EVAL      CER047 = 'N'                                               CER047
      *                                                                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
     C                   IF        ((PRtCd  <> *BLANKS) AND                                   CER047
     C                             (PRtCd <> '*NRF   '))                                      CER047
      *                                                                                       CER047
     C     *LOCK         IN        LDA                                                        CER047
     C                   EVAL      DBase =  902                                               CER047
     C                   EVAL      DBkey =  'CER047'                                          CER047
     C                   EVAL      DBfile = 'SCSARDPD'                                        CER047
     C                   OUT       LDA                                                        CER047
     C                   EXSR      SRERR                                                      CER047
      *                                                                                       CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER048
      ** Call AOSARDR0 to check for CER048                                                    CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'N'                                               CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        ((PRtcd <> *BLANKS) AND                                    CER048
     C                             (PRtcd <> '*NRF   '))                                      CER048
      *                                                                                       CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBase = 903                                                CER048
     C                   EVAL      DBkey =  'CER048'                                          CER048
     C                   EVAL      DBfile = 'SCSARDPD'                                        CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      SRERR                                                      CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER054
      ** Call AOSARDR0 to check for CER054                                                    CER054
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtcd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   IF        PRtcd = *BLANKS                                            CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
     C                   ELSE                                                                 CER054
     C                   EVAL      CER054 = 'N'                                               CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   IF        ((PRtcd <> *BLANKS) AND                                    CER054
     C                             (PRtcd <> '*NRF   '))                                      CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBase = 904                                                CER054
     C                   EVAL      DBkey =  'CER054'                                          CER054
     C                   EVAL      DBfile = 'SCSARDPD'                                        CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      SRERR                                                      CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER048
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      **                                                              *
      **  SRZDate1 - Validate & convert date to a day number          *
      **                                                              *
      *****************************************************************
     C     SRZDate1      BEGSR

     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRZDate2 - Format a date for output                          *
      *****************************************************************
     C     SRZDate2      BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATEB
     C                   PARM                    ZADATE

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRERR - Exception errors                                    *
      ****************************************************************
     C     SRERR         BEGSR

     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'SDNAHLUPD'   Dbpgm
     C                   MOVE      *On           *InU7
     C                   MOVE      *On           *InU8
     C                   MOVE      *On           *InLR

     C                   DUMP

      **  Terminate the program

     C                   RETURN

     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2004
** CMDNH                                                                                    MD027115
OVRDBF FILE(SDFTNHL0) TOFILE(SDFTNHL0) SHARE(*NO)                                           MD027115
** CMDIN                                                                                    MD027115
OVRDBF FILE(SDINCNL0) TOFILE(SDINCNL0) SHARE(*NO)                                           MD027115
