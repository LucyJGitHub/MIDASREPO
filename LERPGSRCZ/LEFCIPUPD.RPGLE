     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*  OVRDBF FILE(FCLTYX) TOFILE(FCLTY) SHARE(*NO)                 *
/*XBIB*  OVRDBF FILE(FCLTYXFN) TOFILE(FCLTY) SHARE(*NO)               *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facilty database update')                     *
      *****************************************************************
      *                                                               *
      *  Midas - LE Customer Lending                                  *
      *                                                               *
      *  LEFCIPUPD - Facility Database Update                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD031337           Date 25Feb15               *
      *                 MD024398           Date 11May14               *
      *                 MD025467           Date 08May14               *
      *                 MD024342B          Date 08May14               *
      *                 MD024342           Date 08May14               *
      *                 AR937578A          Date 02Apr12               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239211             Date 31Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG8550            Date 15Jun06               *
      *                 BUG8540            Date 30Sep05               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 BUG8291            Date 26Aug05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5865            Date 14Feb05               *
      *                 CLE041             Date 15Oct04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4555            Date 19Oct04               *
      *                 BUG4478            Date 07Oct04               *
      *                 BUG4313            Date 23Sep04               *
      *                 BUG2515            Date 07Jun04               *
      *                 BUG2449            Date 1Jun04                *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 11Oct02               *
      *                 CLE029             Date 04Sep02               *
      *                 CLE023             Date 27Aug02               *
      *                 CAP073  *CREATE    Date 18Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD031337 - Component LEC06 10011 failed, FCLTY out of balance*
      *  MD024398 - API Performance Optimisation                      *
      *  MD025467 - API locking issues Redesign Approach              *
      *  MD024342B - API issue. Trailer file allocation problem.      *
      *  MD024342 - FCLTYZZ allocation problem.                       *
      *  AR937578A - In Collateral and Credit Lines Enquiry, availed  *
      *              loans are both in reservation and exposure       *
      *              columns                                          *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  239211 - Amending user is not captured during closure        *
      *           of facility.                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  BUG8540 - Include closed facilities in the number of         *
      *            deletions in FCLTYZZ.                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompiled)                                        *
      *  BUG8291- FCLTYZZ is not updated when closing a facility      *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5865 - Additional fix for Bug2449. Include FCLTYFN        *
      *            Ensure timestamp is setup for every action code    *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4555 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs. Additional fix for BUG3760.          *
      *  BUG4478 - Do not clear the warning error arrays just         *
      *            prior to the database update.                      *
      *  BUG4313 - FOOB in LEC06. ZAMT is not initialised.            *
      *  BUG2515 - Setup authorising user when action code is 'X'     *
      *  BUG2449- Ensure timestamp is setup for every action code     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Midas Plus API development                          *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CLE023 - Lending Facility History Improvements.              *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *****************************************************************

     FFCLTYX    UF A E           K DISK    INFSR(*PSSR) IGNORE(FCLTYFNF)
     F                                     USROPN
     F                                     COMMIT
     FFCLTYXFN  UF A E           K DISK    INFSR(*PSSR) PREFIX(F@)
     F                                     USROPN
     F                                     COMMIT
     F                                     IGNORE(FCLTYFMF:FCLTYHHF:FCLTYZZF)
      **  Funding Participant Details file
     FLEFCLTL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFL2)
     F                                     COMMIT
      **  Credit Agreement File
     FLEFCLTL9  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFL9)
     F                                     PREFIX(LE)
     F                                     COMMIT
     FSDCWHTL1  IF   E           K DISK    INFSR(SRERR)                                      BUG4555
      ** Compliance Watch Hit List                                                           BUG4555
      *                                                                                     MD024342
     F***SDAPDRL0  IF   E           K DISK    INFSR(*PSSR)                         MD024342 MD025467
      ***Midas*SD*API*Driving*File*************************************            MD024342 MD025467
      *****************************************************************            MD024342 MD025467
     F***FLTYZZX  O    E             DISK    COMMIT                               MD024342B MD025467
     F**********                           RENAME(FCLTYZZF:FCLTYZZFX)             MD024342B MD025467
      ***API:*Midas*LE*FACILITIES*FILE*TRAILER*************************           MD024342B MD025467
     FLEFCTZTD  O    E             DISK    COMMIT                                           MD025467
     F                                     RENAME(FCLTYZZF:FCLTYZZFX)                       MD025467
      ***API: Midas LE FACILITIES FILE*TRAILER                                              MD025467
      *****************************************************************           MD024342B MD025467
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

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID LOAN/DEPOSIT
     D LEVFCIM       E DS                  EXTNAME(LEVFCIMPD)
     D LEVFCIN       E DS                  EXTNAME(LEVFCINPD)

      **  FCLTY FM FILE
     D FCLYM         E DS                  EXTNAME(FCLTYFM)

      **  FCLTY FN FILE
     D FCLYN         E DS                  EXTNAME(FCLTYFN) PREFIX(F@)

      ** Facility Details OK indicator
     D FCIP_OK       E DS                  EXTNAME(LEEFCIPPD)

      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS

      ** DATA AREA TO READ PREVIOUS RUN DATE
     D JNSTAT          DS           200
     D  PRUN                 103    105P 0

     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea

     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ** Midas API Message Header Format Definition
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG4555
     D  SCLCD        E                     EXTFLD(LCD)                                       BUG4555
      ** Switchable Feature Details                                                          BUG4555
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    BUG4555
      ***  First DS for access programs, short data structure                                BUG4555
     D DSSDY         E DS                  EXTNAME(DSSDY)                                    BUG4555
      ***  Second DS for access programs, long data structure                                BUG4555

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D TRANSDTL        S           5800A
     D WTimestamp      S             26A
     D Timestamp       S             26Z                                                      CAP084
     D***PDealNo         S             18A                                                    CGL029
     D***PADealNo        S             18A                                                    CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D WDealNo         S              6A

     D OVRDBF          C                   'OVRDBF FILE(FCLTYX)-
     D                                       TOFILE(FCLTY) SHARE(*NO)'
     D OVRDBFB         C                   'OVRDBF FILE(FCLTYXFN)-
     D                                       TOFILE(FCLTY) SHARE(*NO)'
     D OVRDBF2         C                   'OVRDBF FILE(FCLTYX)-                              CLE041
     D                                       TOFILE(LEAGFCL0) SHARE(*NO)'                     CLE041
     D OVRDBFB2        C                   'OVRDBF FILE(FCLTYXFN)-                            CLE041
     D                                       TOFILE(LEAGFCL0) SHARE(*NO)'                     CLE041
                                                                                             BUG2515
      ** Java user information                                                               BUG2515
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                    BUG2515
     D XOT             S             25A   DIM(Elements) PERRCD(1) CTDATA                    BUG4555
      ** XML Opening Tags for the Compliance Engine                                          BUG4555
                                                                                             BUG4555
     D XCT             S             25A   DIM(Elements) PERRCD(1) CTDATA                    BUG4555
      ** XML Closing Tags for the Compliance Engine                                          BUG4555
     D fclfm         E DS                  EXTNAME(FCLTYFM)                                  BUG4555
     D                                     PREFIX(CH)                                        BUG4555
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 BUG4555
     D QQDFAC2       E                     EXTFLD(QQDFAC)                                    BUG4555
      ***  Customer Details                                                                  BUG4555
                                                                                             BUG4555
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG4555
      ** Midas Functions for Watch List Checking Details File                                BUG4555
      *                                                                                      BUG4555
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                 BUG4555
      ** Midas SD Watch List Configuration Data File                                         BUG4555
      *                                                                                      BUG4555
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                 BUG4555
      ** Watch List Transaction details file                                                 BUG4555
      *                                                                                      BUG4555
     D PFreeFmtStr     S          30000A                                                     BUG4555
      ** Compliance Engine Free Format String Parameter                                      BUG4555
                                                                                             BUG4555
     D Elements        C                   CONST(13)                                         BUG4555
      ** Array Size Definition                                                               BUG4555
                                                                                             BUG4555
     D WLF             S             18A   DIM(Elements)                                     BUG4555
      ** Watch List Fields Array.                                                            BUG4555
     D CSD015          S              1    INZ('N')                                          BUG4555
     D CCF001          S              1    INZ('N')                                          BUG4555
     D WFuncType       S              8                                                      BUG4555
     D WIdntifier      S             40                                                      BUG4555
     D WBranch         S              3                                                      BUG4555
     D WLChgFlg        S              1    INZ('N')                                          BUG4555
     D WLOkFlg         S              1    INZ('N')                                          BUG4555
     D WXMLPacket      S            310                                                      BUG4555
     D WData           S            216                                                      BUG4555
     D Ctr             S              2P 0                                                   BUG4555
     D PRetCode        S              7                                                      BUG4555
     D POption         S              7                                                      BUG4555
     D PFunc           S              8                                                      BUG4555
     D PCust           S             10                                                      BUG4555
     D PStKey          S              7                                                      BUG4555
     D PFmtCCY         S              3                                                      BUG4555
     D PDummy6         S              6                                                      BUG4555
     D PDummy16        S             16                                                      BUG4555
     D PDummy35        S             35                                                      BUG4555
     D PZARtCd         S              7                                                      BUG4555
     D PZADayNo        S              5                                                      BUG4555
     D PZADDT          S               D                                                     BUG4555
     D PZACvtDt        S             10                                                      BUG4555
     D WDDT            S               D                                                     BUG4555
     D WDtlOPay        S              1                                                      BUG4555
     D WPtyp           S              2A                                                     BUG4555
     D*W#FRNT***       S              8A                                           MD024342 MD025467
     D CAP086          S              1A   INZ('N')                                           CAP086

      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************

      ** If the user is connected via a browser, the job user name is QUSER -                BUG8550
      ** their user name is stored in ZMUSER                                                 BUG8550
     C                   IN        ZMUSER                                                    BUG8550

     C                   EXSR      SROVRD                                                     CLE041
                                                                                              CLE041
      ** Check whether user is a web browser user, if so overwrite              CAP084
     C**********         CALL      'SFC000026'                                       CAP084 MD024398
     C**********         PARM      *BLANKS       USER             10                 CAP084 MD024398
      **********                                                                     CAP084 MD024398
     C**********         IF        USER <> *BLANKS                                   CAP084 MD024398
     C**********         EVAL      PSUSER = USER                                     CAP084 MD024398
     C                   IF        USRID <> *BLANKS                                         MD024398
     C                   EVAL      PSUSER = USRID                                           MD024398
     C                   ENDIF                                                  CAP084
      *
      ** Clear output fields
      *
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIDArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
                                                                                             BUG4478
      ** Only clear warning error details if not coming from MidasPlus                       BUG4478
                                                                                             BUG4478
     C     USRID         IFEQ      *BLANKS                                                   BUG4478
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx
     C                   ENDIF                                                               BUG4478

      ** Save facility amount before updating it to use in updating
      ** trailer
     C                   Z-ADD     FPFAMT        W#SFAMT
      *                                                                                      BUG2449
      ** Get the timestamp                                                                   BUG2449
     C                   CALLB     'ZAGENTMSTM'                                              BUG2449
     C                   PARM                    TimeStamp                                   BUG2449

     C                   SELECT

      **  Write facility record
      **  =====================

     C     FPCHTP        WHENEQ    'I'
     C                   EXSR      WRITER

      **  Update facility record
      **  ======================

     C     FPCHTP        WHENEQ    'A'
     C                   EXSR      AMENDR

      **  Authorise facility
      **  =======================
     C     FPCHTP        WHENEQ    'X'
     C                   EXSR      AUTHOR

      **  Reverse facility record
      **  =======================

     C     FPCHTP        WHENEQ    'R'
     C                   EXSR      REVESR

      **  Close facility record
      **  =======================

     C     FPCHTP        WHENEQ    'C'
     C                   EXSR      CLOSER
      *
     C                   ENDSL

      ** If 24x7 Midas Availability is installed, write to the standard
      ** log file when support system is active

     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR

      ** Setup Facility support log

     C                   CALLB     'LEFCIPLOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    FPCHTP
     C                   PARM                    FCLYM
     C                   PARM                    FCLYN
     C                   PARM                    TRANSDTL

      ** Write to support database log file

     C                   IF        RetCodeOut = *BLANKS

     C                   EVAL      APTGTTYPE = 'LEFCIP'
     C                   EVAL      APUSERID = PSUser
     C                   MOVEL     FPPCRF        APFOTRANID
     C                   MOVEL     FPCNUM        W@FPCNUM          6
     C                   MOVEL     FPFACT        W@FPFACT          3
     C                   MOVEL     FPFCNO        W@FPFCNO          2
     C                   EVAL      PDealNo = W@FPCNUM + W@FPFACT +
     C                                       W@FPFCNO
     C                   EVAL      PADealNo = *BLANKS

     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       WTimestamp
     C                   PARM                    PDealNo
     C                   PARM                    PADealNo

     C                   ENDIF

      ** If error occured,

     C                   IF        RetCodeOut <> *BLANKS

     C                   EVAL      @@RTCD    = '*ERROR'

     C                   ENDIF

     C                   ENDIF

      **  Update the trailer if no errors
      **  Else report an error

     C     Ix            IFEQ      0
     C                   EXSR      UPDTRL
     C                   ELSE
     C     @@RTCD        IFEQ      *BLANK
     C                   MOVEL     '*ERROR    '  @@RTCD
     C                   ENDIF
     C                   ENDIF
                                                                                              CLE041
      ** Close open files                                                                     CLE041
     C                   CLOSE     FCLTYX                                                     CLE041
     C                   CLOSE     FCLTYXFN                                                   CLE041
      *
      * EXIT FROM PROGRAM
     C                   RETURN
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
      * WRITER   : Write a record to facility file                    *
      *****************************************************************
     C     WRITER        BEGSR

      * INITIALISE FCLTY
     C                   CLEAR                   FCLYM
     C                   CLEAR                   FCLYN

      * SET UP FIELDS FROM FCLTYFM

     C                   MOVEL     LEVFCIM       FCLYM

     C                   MOVEL     'D'           RECI
     C                   MOVE      'A'           RCTP

      * OTHER DETAILS
     C                   Z-ADD     0             RVCD

     C                   Z-ADD     0             MTDH
     C                   Z-ADD     0             MTDL
     C                   Z-ADD     0             MTDA
     C                   Z-ADD     0             QTDA
     C                   Z-ADD     0             YTDA
     C                   MOVEL     *BLANKS       ZZ001
     C                   MOVEL     *BLANKS       ZZ002A

     C                   MOVEL     FPPRTR        PRTR
     C**********         Z-ADD     0             PMFC                                         CLE106
     C**********         Z-ADD     0             PMFT                                         CLE106
     C**********         Z-ADD     0             PMFN                                         CLE106
     C**********         Z-ADD     0             INUM                                         CLE106
     C**********         Z-ADD     0             JDTE                                         CLE106
     C**********         MOVEL     *BLANKS       SHTP                                         CLE106
     C**********         Z-ADD     0             SHPC                                         CLE106
     C**********         MOVEL     *BLANKS       RCSI                                         CLE106
     C**********         Z-ADD     0             SKIR                                         CLE106
     C**********         MOVEL     *BLANKS       SKIS                                         CLE106
     C**********         Z-ADD     0             SKFR                                         CLE106
     C**********         MOVEL     *BLANKS       SKFS                                         CLE106
     C                   Z-ADD     0             VDTC
     C                   MOVEL     *BLANKS       PFTI
     C**********         MOVEL     *BLANKS       SCCY                                         CLE106
     C**********         MOVEL     *BLANKS       ICCY                                         CLE106
     C**********         MOVEL     *BLANKS       PASI                                         CLE106
     C                   MOVEL     *BLANKS       REPI
      *
      * ORIGINAL ENTRY DATE, LAST CHANGE DATE & LAST CHANGE TYPE
      *
     C                   Z-ADD     BJRDNB        ORED
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      FPCHTP        CHTP
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    NATN              5 0
     C                   Z-ADD     NATN          TNLU
      *                                                                                       CAP084
      ** Set up the timestamp                                                                 CAP084
     C**********         CALLB     'ZAGENTMSTM'                                       CAP084 BUG2449
     C**********         PARM                    TimeStamp                            CAP084 BUG2449
      *                                                                                       CAP084
     C                   EVAL      STMP  = TimeStamp                                          CAP084
                                                                                             BUG4555
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                             BUG4555
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                         BUG4555
     C                             AND LIBR = S1MAIN)                                        BUG4555
                                                                                             BUG4555
                                                                                             BUG4555
     C                   EXSR      SrWatch                                                   BUG4555
                                                                                             BUG4555
     C                   ENDIF                                                               BUG4555
                                                                                             BUG4555
     C                   IF        FPAUTH = 'Y'                                               CAP086
     C                             AND CAP086 = 'Y'                                           CAP086
     C                   EVAL      FSTS = 'A'                                                 CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      AUTH = FPAUTH                                              CAP086
     C                   ENDIF                                                                CAP086
      *
      * WRITE FCLTYFM FILE
     C                   WRITE     FCLTYFMF

      *
      * SET UP FIELDS FROM FCLTYFN

     C                   MOVEL     LEVFCIN       FCLYN

      * OTHER DETAILS
     C                   Z-ADD     *ZEROS        F@OAM1
     C                   Z-ADD     *ZEROS        F@OAM2
     C                   Z-ADD     *ZEROS        F@OAM3
     C                   Z-ADD     *ZEROS        F@OAM4
     C                   Z-ADD     *ZEROS        F@OAM5
     C                   Z-ADD     *ZEROS        F@OAM6
     C                   Z-ADD     *ZEROS        F@OAM7
     C                   Z-ADD     *ZEROS        F@OAM8
     C                   Z-ADD     *ZEROS        F@OAM9
     C                   Z-ADD     *ZEROS        F@OA10
     C                   MOVE      *BLANKS       F@CMFT
     C                   Z-ADD     0             F@CALC
     C                   MOVE      *BLANKS       F@SPRD
     C**********         Z-ADD     0             F@BCOD                                       CSD103
     C                   MOVE      *BLANKS       F@BCOD                                       CSD103
     C                   Z-ADD     0             F@BRAT
     C                   Z-ADD     0             F@STDT
     C                   Z-ADD     0             F@EDDT
     C                   Z-ADD     0             F@DUDT
     C                   MOVE      *BLANKS       F@BLFR
     C                   Z-ADD     0             F@BLDN
     C                   Z-ADD     0             F@SETT
     C                   MOVE      *BLANKS       F@OBAC
     C                   MOVE      *BLANKS       F@TNAC
     C                   Z-ADD     0             F@SLCD
     C                   Z-ADD     0             F@ACCD
     C                   Z-ADD     0             F@ADNP
     C                   Z-ADD     0             F@PDTD
     C                   Z-ADD     0             F@AFPD
     C                   Z-ADD     0             F@ADJP
     C                   Z-ADD     0             F@ADJN
     C                   Z-ADD     0             F@TOTD
     C                   Z-ADD     0             F@CAMD
     C                   Z-ADD     0             F@LSWSC
     C                   MOVE      *BLANKS       F@BITS
     C                   Z-ADD     0             F@PEXP
     C                   MOVE      *BLANKS       F@ZZ003
     C                   MOVE      *BLANKS       F@CFBR
     C                   MOVE      *BLANKS       F@ZZ002
     C                   Z-ADD     0             F@CEXP                                  CLE023
      *
      * ORIGINAL ENTRY DATE, LAST CHANGE DATE & LAST CHANGE TYPE
      *
     C                   MOVEL     'D'           F@RECI
     C                   MOVE      'B'           F@RCTP

     C                   Z-ADD     BJRDNB        F@ORED
     C                   Z-ADD     BJRDNB        F@LCD
     C                   MOVE      FNCHTP        F@CHTP
     C                   Z-ADD     NATN          F@TNLU
      *
     C                   EXSR      DRWAMT
      *                                                                                       CAP084
     C                   EVAL      F@STMP  = TimeStamp                                        CAP084
      *
      * WRITE FCLTYFN FILE
     C                   WRITE     FCLTYFNF

     C                   ENDSR
      ***********************************************************
      /EJECT
      ***********************************************************
      *  DRWAMT :
      ***********************************************************
     C     DRWAMT        BEGSR
      *
      **  Determine 'DRAWN AMOUNT' days and read data area JNSTAT
      **  for previous run date
     C                   IN        JNSTAT
      *
     C                   Z-ADD     PRUN          F@RUN0
      *
      *  Check for holidays in local currency:
     C                   Z-ADD     PRUN          ZDAYNO
     C                   MOVE      BJLCCY        ZCCY
     C**********         MOVE      *BLANKS       ZLOC                                      AR937578A
     C                   MOVE      BJSLCD        ZLOC                                      AR937578A
      *
     C                   Z-ADD     1             ZNRDYS
     C                   CALLB     'ZFWDT'                              99
     C                   PARM                    ZDAYNO            5 0          Midas day number
     C                   PARM                    ZNRDYS            2 0          Nber of days forward
     C                   PARM                    ZDYNBR            5 0          Working day nber
     C                   PARM                    ZCCY              3            Currency
     C                   PARM                    ZLOC              3            Location
     C     *IN99         IFEQ      '1'
     C                   EXSR      SRERR
     C                   ENDIF
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   Z-ADD     ZDYNBR        F@RUN1
      *
     C                   Z-ADD     1             ZNRDYS
     C                   CALLB     'ZFWDT'                              99
     C                   PARM                    ZDAYNO                         Midas day number
     C                   PARM                    ZNRDYS                         Nber of days forward
     C                   PARM                    ZDYNBR                         Working day nber
     C                   PARM                    ZCCY                           Currency
     C                   PARM                    ZLOC                           Location
     C     *IN99         IFEQ      '1'
     C                   EXSR      SRERR
     C                   ENDIF
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   Z-ADD     ZDYNBR        F@RUN2
      *
     C                   Z-ADD     1             ZNRDYS
     C                   CALLB     'ZFWDT'                              99
     C                   PARM                    ZDAYNO                         Midas day number
     C                   PARM                    ZNRDYS                         Nber of days forward
     C                   PARM                    ZDYNBR                         Working day nber
     C                   PARM                    ZCCY                           Currency
     C                   PARM                    ZLOC                           Location
     C     *IN99         IFEQ      '1'
     C                   EXSR      SRERR
     C                   ENDIF
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   Z-ADD     ZDYNBR        F@RUN3
      *
     C                   Z-ADD     1             ZNRDYS
     C                   CALLB     'ZFWDT'                              99
     C                   PARM                    ZDAYNO                         Midas day number
     C                   PARM                    ZNRDYS                         Nber of days forward
     C                   PARM                    ZDYNBR                         Working day nber
     C                   PARM                    ZCCY                           Currency
     C                   PARM                    ZLOC                           Location
     C     *IN99         IFEQ      '1'
     C                   EXSR      SRERR
     C                   ENDIF
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   Z-ADD     ZDYNBR        F@RUN4
      *
     C                   Z-ADD     1             ZNRDYS
     C                   CALLB     'ZFWDT'                              99
     C                   PARM                    ZDAYNO                         Midas day number
     C                   PARM                    ZNRDYS                         Nber of days forward
     C                   PARM                    ZDYNBR                         Working day nber
     C                   PARM                    ZCCY                           Currency
     C                   PARM                    ZLOC                           Location
     C     *IN99         IFEQ      '1'
     C                   EXSR      SRERR
     C                   ENDIF
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   Z-ADD     ZDYNBR        F@RUN5
      *
     C                   Z-ADD     1             ZNRDYS
     C                   CALLB     'ZFWDT'                              99
     C                   PARM                    ZDAYNO                         Midas day number
     C                   PARM                    ZNRDYS                         Nber of days forward
     C                   PARM                    ZDYNBR                         Working day nber
     C                   PARM                    ZCCY                           Currency
     C                   PARM                    ZLOC                           Location
     C     *IN99         IFEQ      '1'
     C                   EXSR      SRERR
     C                   ENDIF
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   Z-ADD     ZDYNBR        F@RUN6
      *
     C                   Z-ADD     1             ZNRDYS
     C                   CALLB     'ZFWDT'                              99
     C                   PARM                    ZDAYNO                         Midas day number
     C                   PARM                    ZNRDYS                         Nber of days forward
     C                   PARM                    ZDYNBR                         Working day nber
     C                   PARM                    ZCCY                           Currency
     C                   PARM                    ZLOC                           Location
     C     *IN99         IFEQ      '1'
     C                   EXSR      SRERR
     C                   ENDIF
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   Z-ADD     ZDYNBR        F@RUN7
      *
     C                   Z-ADD     1             ZNRDYS
     C                   CALLB     'ZFWDT'                              99
     C                   PARM                    ZDAYNO                         Midas day number
     C                   PARM                    ZNRDYS                         Nber of days forward
     C                   PARM                    ZDYNBR                         Working day nber
     C                   PARM                    ZCCY                           Currency
     C                   PARM                    ZLOC                           Location
     C     *IN99         IFEQ      '1'
     C                   EXSR      SRERR
     C                   ENDIF
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   Z-ADD     ZDYNBR        F@RUN8
      *
     C                   Z-ADD     1             ZNRDYS
     C                   CALLB     'ZFWDT'                              99
     C                   PARM                    ZDAYNO                         Midas day number
     C                   PARM                    ZNRDYS                         Nber of days forward
     C                   PARM                    ZDYNBR                         Working day nber
     C                   PARM                    ZCCY                           Currency
     C                   PARM                    ZLOC                           Location
     C     *IN99         IFEQ      '1'
     C                   EXSR      SRERR
     C                   ENDIF
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   Z-ADD     ZDYNBR        F@RUN9
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
      * AMENDR   : Update Facility File                               *
      *****************************************************************
     C     AMENDR        BEGSR

      ** Set up the key to the facility file

     C                   MOVE      FPCNUM        K#CNUM
     C                   MOVE      FPFACT        K#FACT
     C                   MOVE      FPFCNO        K#FCNO

      ** Access facility record type 'A'

     C                   MOVE      'A'           K#RCTP
     C     K#FCTY        CHAIN     FCLTYFMF                           70
      *
     C     P#MODE        IFEQ      'B'
     C                   MOVE      TNLU          H#TNLU
     C                   ENDIF

      ** End in error if record has been updated by another workstation
      *
     C     *IN70         IFEQ      *ON
     C     H#TNLU        ORNE      TNLU
     C                   MOVE      'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0026'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  @@RTCD
     C                   GOTO      EAMENDR
     C                   ENDIF

      ** Update facility record type 'A'

     C                   MOVEL     LEVFCIM       FCLYM

     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      FPCHTP        CHTP
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    NATN
     C                   Z-ADD     NATN          TNLU
                                                                                             BUG2449
     C                   EVAL      STMP  = TimeStamp                                         BUG2449

      *                                                                                      BUG4555
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                             BUG4555
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                         BUG4555
     C                             AND LIBR = S1MAIN)                                        BUG4555
                                                                                             BUG4555
     C                   EVAL      WFuncType ='FCLTYFM'                                      BUG4555
     C                   MOVEL     '/'           Wrk3              3                         BUG4555
     C                   MOVE      FCNO          Wrk3                                        BUG4555
     C                   MOVEL     FACT          FCNbr             6                         BUG4555
     C                   MOVE      Wrk3          FCNbr                                       BUG4555
     C                   MOVEL     CNUM          FIdentfr         13                         BUG4555
     C                   MOVE      FCNbr         FIdentfr                                    BUG4555
     C                   EVAL      WIdntifier = FIdentfr                                     BUG4555
     C                   EVAL      WBranch = BRCA                                            BUG4555
                                                                                             BUG4555
     C     KCwFld        CHAIN     SDCWHTL1                                                  BUG4555
     C                   IF        NOT %FOUND(SDCWHTL1)                                      BUG4555
     C                   EXSR      SRWatch                                                   BUG4555
     C                   ENDIF                                                               BUG4555
                                                                                             BUG4555
     C                   ENDIF                                                               BUG4555
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y' AND FPAUTH = 'Y'                              CAP086
     C                   EVAL      AUTH = FPAUTH                                              CAP086
     C                   EVAL      FSTS = 'A'                                                 CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   UPDATE    FCLTYFMF

      **  Check for the existence of funding participant/internal
      **  facilities, if any are found, update the expiry dates on
      **  these with the value of the prime facility
      **  also update them with multi-ccy indicator
      **  Also update the loan adminstrator id
      *
      * Key K#KY10 set up for use after the read of LEFCLTL2
      *
     C                   MOVE      CNUM          K0CANM
     C                   MOVE      FACT          K0CAFT
     C                   MOVE      FCNO          K0CAFN
      *
     C     SYIN          IFEQ      'Y'
     C     FPTRCA        ANDNE     'AG'                                                       CLE041
      *
     C                   MOVE      BRCA          K4BRCA
     C                   MOVE      CNUM          K4CNUM
     C                   MOVE      FACT          K4FACT
     C                   MOVE      FCNO          K4FCNO
     C     *LIKE         DEFINE    FAMT          W@FAMT
     C                   Z-ADD     FAMT          W@FAMT
      *
     C     K#KY04        CHAIN     LEFCLTL2                           80
     C     *IN80         DOWEQ     *OFF
     C                   MOVE      FPDTEX        DTEX
     C                   MOVE      FPAVLD        AVLD
     C                   MOVE      FPMCCY        MCCY
      *
     C     CLE008        IFEQ      'Y'
     C                   MOVE      FPLAID        LAID
     C                   ENDIF
      *
     C                   UPDATE    FCLTYFL2
     C     K#KY04        READE     LEFCLTL2                               80
     C                   ENDDO
      *
     C                   Z-ADD     W@FAMT        FAMT
     C                   ENDIF
      *
      ** If amended on Credit Agreement Facility, it must update all
      ** associated Tranches with the same value
      *
     C     P#MODE        IFNE      'B'
     C     CLE008        IFEQ      'Y'
     C     FPTRCA        ANDEQ     'CA'
     C     K#KY10        CHAIN     LEFCLTL9                           80
     C     *IN80         DOWEQ     *OFF
     C                   MOVE      FPLAID        LAID
     C                   UPDATE    FCLTYFL9
     C     K#KY10        READE     LEFCLTL9                               80
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
      ** Access facility record type 'B'

     C                   MOVE      'B'           K#RCTP
     C     K#FCTY        CHAIN     FCLTYFNF                           70

      ** Update facility record type 'B'

     C                   MOVEL     LEVFCIN       FCLYN

     C                   Z-ADD     BJRDNB        F@LCD
     C                   MOVE      FPCHTP        F@CHTP
     C                   Z-ADD     NATN          F@TNLU

     C                   EVAL      F@STMP  = TimeStamp                                       BUG5865
                                                                                             BUG5865
     C                   UPDATE    FCLTYFNF
      *
     C     EAMENDR       ENDSR
      ***********************************************************
      /EJECT
      ***********************************************************
      *  AUTHOR :   Authorise facility
      ***********************************************************
     C     AUTHOR        BEGSR
      *
     C                   MOVE      FPCNUM        K#CNUM
     C                   MOVE      FPFACT        K#FACT
     C                   MOVE      FPFCNO        K#FCNO
     C                   MOVE      'A'           K#RCTP
      *
     C     K#FCTY        CHAIN     FCLTYFMF                           70
      *
     C     P#MODE        IFEQ      'B'
     C                   MOVE      TNLU          H#TNLU
     C                   ENDIF

      ** End in error if record has been updated by another workstation
      *
     C     *IN70         IFEQ      *ON
     C     H#TNLU        ORNE      TNLU
     C                   MOVE      'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0026'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  @@RTCD
     C                   GOTO      EAUTHOR
     C                   ENDIF

     C                   MOVE      'A'           FSTS
      *
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    NATN
     C                   Z-ADD     NATN          TNLU

     C                   Z-ADD     BJRDNB        LCD
                                                                                             BUG2449
     C                   EVAL      STMP  = TimeStamp                                         BUG2449
     C                   EVAL      XUSR = USRID                                              BUG2515
      *
     C                   UPDATE    FCLTYFMF
      *
     C                   MOVE      'B'           K#RCTP
      *
     C     K#FCTY        CHAIN     FCLTYFNF                           70
     C                   Z-ADD     NATN          F@TNLU
     C                   Z-ADD     BJRDNB        F@LCD
      *
     C                   EVAL      F@STMP  = TimeStamp                                       BUG5865
                                                                                             BUG5865
     C                   UPDATE    FCLTYFNF
      *
     C     EAUTHOR       ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
      * REVESR   : Reverse a record                                   *
      *****************************************************************
     C     REVESR        BEGSR
      *
     C                   MOVE      FPCNUM        K#CNUM
     C                   MOVE      FPFACT        K#FACT
     C                   MOVE      FPFCNO        K#FCNO
     C                   MOVE      'A'           K#RCTP
      *
     C     K#FCTY        CHAIN     FCLTYFMF                           70
      *
     C     P#MODE        IFEQ      'B'
     C                   MOVE      TNLU          H#TNLU
     C                   ENDIF

      ** End in error if record has been updated by another workstation
      *
     C     *IN70         IFEQ      *ON
     C     H#TNLU        ORNE      TNLU
     C                   MOVE      'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0026'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  @@RTCD
     C                   GOTO      EREVESR
     C                   ENDIF
      *
     C                   MOVE      'A'           FSTS
     C                   MOVE      'R'           RECI
     C                   EVAL      AUSR  = FPAUSR                                             239211
     C                   EVAL      XUSR  = USRID                                              239211
      *
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    NATN
     C                   Z-ADD     NATN          TNLU

     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      FPCHTP        CHTP
     C                   MOVE      *BLANKS       LMTI                           CLE029
                                                                                             BUG2449
     C                   EVAL      STMP  = TimeStamp                                         BUG2449
      *
     C                   UPDATE    FCLTYFMF
      *
     C                   MOVE      'B'           K#RCTP
      *
     C     K#FCTY        CHAIN     FCLTYFNF                           70
      *
     C                   MOVE      'R'           F@RECI
     C                   Z-ADD     NATN          F@TNLU
     C                   Z-ADD     BJRDNB        F@LCD
     C                   MOVE      FPCHTP        F@CHTP
      *
     C                   EVAL      F@STMP  = TimeStamp                                       BUG5865
                                                                                             BUG5865
     C                   UPDATE    FCLTYFNF

     C     EREVESR       ENDSR
      ***********************************************************
      /EJECT
      ***********************************************************
      *  CLOSER :   Close facility
      ***********************************************************
     C     CLOSER        BEGSR
      *
     C                   MOVE      FPCNUM        K#CNUM
     C                   MOVE      FPFACT        K#FACT
     C                   MOVE      FPFCNO        K#FCNO
     C                   MOVE      'A'           K#RCTP
      *
     C     K#FCTY        CHAIN     FCLTYFMF                           70
      *
     C     P#MODE        IFEQ      'B'
     C                   MOVE      TNLU          H#TNLU
     C                   ENDIF

     C     *IN70         IFEQ      *ON
     C     H#TNLU        ORNE      TNLU
     C                   MOVE      'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN      'FldNameArr(Ix)
     C                   MOVEL     'LEP0026'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  @@RTCD
     C                   GOTO      ECLOSER
     C                   ENDIF
      *
     C                   MOVE      'A'           FSTS
     C                   MOVE      'C'           RECI
      *
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    NATN
     C                   Z-ADD     NATN          TNLU

     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      FPCHTP        CHTP
                                                                                             BUG2449
     C                   EVAL      STMP  = TimeStamp                                         BUG2449
     C                   EVAL      AUSR  = FPAUSR                                             239211
     C                   EVAL      XUSR  = USRID                                              239211
      *
     C                   UPDATE    FCLTYFMF
      *
     C                   MOVE      'B'           K#RCTP
      *
     C     K#FCTY        CHAIN     FCLTYFNF                           70
     C                   MOVE      'C'           F@RECI
     C                   Z-ADD     NATN          F@TNLU
     C                   Z-ADD     BJRDNB        F@LCD
     C                   MOVE      FPCHTP        F@CHTP
      *
     C                   EVAL      F@STMP  = TimeStamp                                       BUG5865
                                                                                             BUG5865
     C                   UPDATE    FCLTYFNF

     C     ECLOSER       ENDSR
      *****************************************************************                      BUG4555
      /EJECT                                                                                 BUG4555
      *****************************************************************                      BUG4555
      *                                                               *                      BUG4555
      * SRWatch - Initiates the Midas Compliance Engine.              *                      BUG4555
      *                                                               *                      BUG4555
      *****************************************************************                      BUG4555
                                                                                             BUG4555
     C     SRWatch       BEGSR                                                               BUG4555
                                                                                             BUG4555
      ** Initialise the Transaction Details parameter.                                       BUG4555
                                                                                             BUG4555
     C                   CLEAR                   SDWLTD                                      BUG4555
                                                                                             BUG4555
      ** Setup First Parameter                                                               BUG4555
                                                                                             BUG4555
      ** Item Type Code                                                                      BUG4555
     C                   EVAL      W4ITEM = 'LEFCIP'                                         BUG4555
      *                                                                                      BUG4555
     C                   MOVEL     '/'           Wrk3              3                         BUG4555
     C                   MOVE      FCNO          Wrk3                                        BUG4555
     C                   MOVEL     FACT          FCNbr             6                         BUG4555
     C                   MOVE      Wrk3          FCNbr                                       BUG4555
     C                   MOVEL     CNUM          FIdentfr         13                         BUG4555
     C                   MOVE      FCNbr         FIdentfr                                    BUG4555
     C                   EVAL      W4IDEN = FIdentfr                                         BUG4555
      *                                                                                      BUG4555
     C                   EVAL      W4BRCH = BRCA                                             BUG4555
      *                                                                                      BUG4555
     C                   IF        CSC011 = 'Y'                                              BUG4555
     C                   EVAL      W4SYSM = S1MAIN                                           BUG4555
     C                   ELSE                                                                BUG4555
     C                   EVAL      W4SYSM = LIBR                                             BUG4555
     C                   ENDIF                                                               BUG4555
                                                                                             BUG4555
     C                   EVAL      W4FUNT = 'FCLTYFM'                                        BUG4555
                                                                                             BUG4555
     C                   MOVEL     CNUM          PCUST                                       BUG4555
     C                   CALLB     'AOCUSTR0'                                                BUG4555
     C                   PARM      *BLANKS       PRTCD                                       BUG4555
     C                   PARM      '*KEY'        POPTN                                       BUG4555
     C                   Parm                    PCUST                                       BUG4555
     C                   PARM      *BLANKS       PSTKEY                                      BUG4555
     C     SDCUST        PARM      SDCUST        DSSDY                                       BUG4555
                                                                                             BUG4555
     C                   IF        PRTCD <> *BLANKS                                          BUG4555
     C                             AND PRTCD <> '*NRF   '                                    BUG4555
     C                   EVAL      DBKEY = POPTN                                             BUG4555
     C                   EVAL      DBFILE = 'SDCUSTPD'                                       BUG4555
     C                   EVAL      DBASE = 908                                               BUG4555
     C                   EXSR      SRERR                                                     BUG4555
     C                   ENDIF                                                               BUG4555
                                                                                             BUG4555
     C                   MOVE      CNUM          W4CNUM                                      BUG4555
                                                                                             BUG4555
      ** Determine Counterparty Type                                                         BUG4555
                                                                                             BUG4555
     C                   IF        CCF001 = 'Y' AND                                          BUG4555
     C                             BBCRPC = 'Y'                                              BUG4555
     C                   EVAL      W4CTYP = 'C'                                              BUG4555
     C                   ELSE                                                                BUG4555
     C                   EVAL      W4CTYP = 'I'                                              BUG4555
     C                   ENDIF                                                               BUG4555
                                                                                             BUG4555
     C                   EVAL      W4CUST = BBCRNM + BBCRTN                                  BUG4555
                                                                                             BUG4555
      ** Convert Dates                                                                       BUG4555
                                                                                             BUG4555
     C                   MOVE      '0001-01-01'  W4DDAT                                      BUG4555
     C                   MOVE      DTAP          PZADayNo                                    BUG4555
     C                   EXSR      SRDateToDDT                                               BUG4555
     C                   EVAL      W4DDAT = WDDT                                             BUG4555
                                                                                             BUG4555
     C                   MOVE      '0001-01-01'  W4VDAT                                      BUG4555
     C                   MOVE      DTAP          PZADayNo                                    BUG4555
     C                   EXSR      SRDateToDDT                                               BUG4555
     C                   EVAL      W4VDAT = WDDT                                             BUG4555
                                                                                             BUG4555
     C                   MOVE      '0001-01-01'  W4MDAT                                      BUG4555
     C                   MOVE      DTEX          PZADayNo                                    BUG4555
     C                   EXSR      SRDateToDDT                                               BUG4555
     C                   EVAL      W4MDAT = WDDT                                             BUG4555
                                                                                             BUG4555
     C                   EVAL      W4DEN1 = FCCY                                             BUG4555
     C                   EVAL      W4DEN2 = *BLANKS                                          BUG4555
                                                                                             BUG4555
     C                   EVAL      W4AMT1 = FAMT                                             BUG4555
     C                   EVAL      W4AMT2 = 0                                                BUG4555
                                                                                             BUG4555
      ** Build the free format string (2nd parameter)                                        BUG4555
                                                                                             BUG4555
     C                   EVAL      Ctr = 1                                                   BUG4555
     C                   EVAL      PFreeFmtStr = *BLANKS                                     BUG4555
     C                   EVAL      WXMLPacket = *BLANKS                                      BUG4555
     C                   EVAL      WData = *BLANKS                                           BUG4555
     C                   MOVEL     W4CUST        WLF(1)                                      BUG4555
                                                                                             BUG4555
     C                   DOU       Ctr >= Elements                                           BUG4555
                                                                                             BUG4555
     C                   IF        WLF(Ctr) <> *BLANKS                                       BUG4555
     C                             AND WLF(Ctr) <> '000000'                                  BUG4555
                                                                                             BUG4555
     C                   EVAL      PFmtCCY = FCCY                                            BUG4555
                                                                                             BUG4555
     C                   CALL      'SDCWLFMT'                                                BUG4555
     C                   PARM                    PRTCD                                       BUG4555
     C                   PARM                    WLF(Ctr)                                    BUG4555
     C                   PARM                    PDummy35                                    BUG4555
     C                   PARM                    PDummy35                                    BUG4555
     C                   PARM                    PDummy35                                    BUG4555
     C                   PARM                    PDummy35                                    BUG4555
     C                   PARM                    PDummy35                                    BUG4555
     C                   PARM                    PFmtCCY                                     BUG4555
     C                   PARM                    WData                                       BUG4555
     C                   PARM                    PDummy6                                     BUG4555
                                                                                             BUG4555
     C                   CAT       XOT(Ctr):0    WXMLPacket                                  BUG4555
     C                   CAT       WData:0       WXMLPacket                                  BUG4555
                                                                                             BUG4555
     C                   CAT       XCT(Ctr):0    WXMLPacket                                  BUG4555
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                 BUG4555
                                                                                             BUG4555
     C                   EVAL      WXMLPacket = *BLANKS                                      BUG4555
     C                   EVAL      WData = *BLANKS                                           BUG4555
     C                   ENDIF                                                               BUG4555
                                                                                             BUG4555
     C                   EVAL      Ctr = Ctr + 1                                             BUG4555
     C                   ENDDO                                                               BUG4555
                                                                                             BUG4555
      ** Check for compliance.                                                               BUG4555
                                                                                             BUG4555
     C                   CALL      'SDCWLCHK'                                                BUG4555
     C                   PARM                    SDWLTD                                      BUG4555
     C                   PARM                    PFreeFmtStr                                 BUG4555
                                                                                             BUG4555
     C                   ENDSR                                                               BUG4555
      *****************************************************************                      BUG4555
      /EJECT                                                                                 BUG4555
      *****************************************************************                      BUG4555
      *                                                               *                      BUG4555
      * SRDateToDDT - Converts a date into Date Data Type format.     *                      BUG4555
      *                                                               *                      BUG4555
      *****************************************************************                      BUG4555
                                                                                             BUG4555
     C     SRDateToDDT   BEGSR                                                               BUG4555
                                                                                             BUG4555
      ** Convert the derived Midas Day Number into Date Data Type.                           BUG4555
                                                                                             BUG4555
     C                   CALL      'ZACVTDATE'                                               BUG4555
     C                   PARM      *BLANKS       PZARtCd                                     BUG4555
     C                   PARM                    PZADayNo                                    BUG4555
     C                   PARM                    PZADDT                                      BUG4555
     C                   PARM                    PZACvtDt                                    BUG4555
                                                                                             BUG4555
     C                   EVAL      WDDT = PZADDT                                             BUG4555
                                                                                             BUG4555
     C                   ENDSR                                                               BUG4555
                                                                                             BUG4555
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDTRL- UPDATE THE FCLTY FILE TRAILER                        *
     C*                                                              *
     C****************************************************************
     C     UPDTRL        BEGSR
      *
      ** Update the file controls on LF/FCLTY
     C                   EXSR      Initialise                                               MD031337
     C                   Z-ADD     0             ZAMT                                        BUG4313
     C**********         Z-ADD     999999        K#CNUM                                       CSD027
     C                   EVAL      K#CNUM = '999999'                                          CSD027
     C                   Z-ADD     999           K#FACT
     C                   Z-ADD     99            K#FCNO
     C                   MOVE      'Z'           K#RCTP

     C*****MTHREAD       IFEQ      'N'                                             MD024342 MD025467
     C*****K#FCTY        CHAIN     FCLTYZZF                           70                    MD025467

     C******IN70         IFEQ      '1'                                                      MD025467
     C******IN70         OREQ      '0'                                                      MD025467
     C*****RECI*         ANDNE     'T'                                                      MD025467
     C**********         MOVEL     'FCLTYZZ '    DBFILE                                     MD025467
     C**********         MOVEL     '800'         DBASE                                      MD025467
     C**********         MOVEL     K#CNUM        DBKEY                                      MD025467
     C**********         EXSR      *PSSR                                                    MD025467
     C**********         ENDIF                                                              MD025467
     C**********         ENDIF                                                     MD024342 MD025467
      *
     C                   SELECT
      *
      **  Inserts
     C     FPCHTP        WHENEQ    'I'
                                                                                            MD024342
     C**********         IF        MTHREAD = 'Y'                                   MD024342 MD025467
     C                   EXSR      Initialise                                               MD024342
     C                   MOVE      'I'           RCTP                                       MD024342
     C**********         ENDIF                                                     MD024342 MD025467

     C                   ADD       2             NORE
     C                   ADD       2             NINS
     C                   ADD       2             NLRA
      *
      ** Set up amount fields
     C     FPFAMT        DIV       1000          ZZAMT            15 3
      *
     C                   Z-ADD     VRIF          ZZTOTI
     C                   Z-ADD     VRIL          ZZTOTD
     C                   EXSR      SRZADD
     C                   Z-ADD     ZZTOTI        VRIF
     C                   Z-ADD     ZZTOTD        VRIL
      *
      **  Save it to calculate totals
     C                   Z-ADD     FPFAMT        ZAMT             15 0
      *
      **  Amend
     C     FPCHTP        WHENEQ    'A'
                                                                                            MD024342
     C**********         IF        MTHREAD = 'Y'                                   MD024342 MD025467
     C                   EXSR      Initialise                                               MD024342
     C                   MOVE      'E'           RCTP                                       MD024342
     C**********         ENDIF                                                     MD024342 MD025467
      *
     C                   Z-ADD     VRAF          ZZTOTI
     C                   Z-ADD     VRAL          ZZTOTD
     C     FPFAMT        SUB       W#SFAMT       W#ADJ            15 0
     C                   MOVE      W#ADJ         ZZAMT
     C     W#ADJ         DIV       1000          ZZAMT            15 3
     C                   EXSR      SRZADD
     C                   Z-ADD     ZZTOTI        VRAF
     C                   Z-ADD     ZZTOTD        VRAL
      *
     C                   Z-ADD     W#ADJ         ZAMT
      *
      **  Reverse
      **  or close                                                                           BUG8291
     C     FPCHTP        WHENEQ    'R'
     C     FPCHTP        OREQ      'C'                                                       BUG8291
      *                                                                                     MD024342
     C**********         IF        MTHREAD = 'Y'                                   MD024342 MD025467
     C                   EXSR      Initialise                                               MD024342
     C                   MOVE      'R'           RCTP                                       MD024342
     C**********         ENDIF                                                     MD024342 MD025467
      *
      **  Only update number of live records
     C                   ADD       2             NDEL
     C                   SUB       2             NLRA
      *
      ** Set up amount fields
     C     W#SFAMT       DIV       1000          ZZAMT            15 3
      *
     C                   Z-ADD     VRDF          ZZTOTI
     C                   Z-ADD     VRDL          ZZTOTD
     C                   EXSR      SRZADD
     C                   Z-ADD     ZZTOTI        VRDF
     C                   Z-ADD     ZZTOTD        VRDL
      *
     C                   Z-SUB     W#SFAMT       ZAMT
      *
     C                   ENDSL
      *
      ** Calculate Totals
      *
     C     ZAMT          DIV       1000          ZZAMT
     C                   Z-ADD     VLAF          ZZTOTI
     C                   Z-ADD     VLAL          ZZTOTD
     C                   EXSR      SRZADD
     C                   Z-ADD     ZZTOTI        VLAF
     C                   Z-ADD     ZZTOTD        VLAL
      *
     C**********         IF        MTHREAD = 'N'                                   MD024342 MD025467
     C**********         Z-ADD     BJRDNB        LCD                                        MD025467
     C**********         MOVE      FPCHTP        CHTP                                       MD025467
     C**********         Z-ADD     NATN          TNLU                                       MD025467
     C**********         UPDATE    FCLTYZZF                                                 MD025467
     C**********         ELSE                                                      MD024342 MD025467
     C                   MOVEL     'D'           RECI                                       MD024342
     C                   Z-ADD     BJRDNB        LCD                                        MD024342
     C                   MOVE      'I'           CHTP                                       MD024342
     C                   Z-ADD     NATN          TNLU                                       MD024342
     C**********         WRITE     FCLTYZZF                                       MD024342 MD024342B
     C                   WRITE     FCLTYZZFX                                               MD024342B
     C**********         ENDIF                                                     MD024342 MD025467
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRZADD   : Adds an amount (ZZAMT) to the total (ZZTOTI,ZZTOTD)*
      *****************************************************************
     C     SRZADD        BEGSR
      *
      ** Split ZZAMT into integer and decimal fields
      *
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0
     C                   MOVE      ZZAMT         ZZAMTD            3 0
      *
      ** Both ZZAMTI and ZZAMTD contain a 'sign' zone now
      *
     C                   EXSR      SRZSUM
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRZSUM   : Carries out the addition of the amounts            *
      *****************************************************************
     C     SRZSUM        BEGSR
      *
      ** Save values of indicators to be used in the program
     C                   MOVE      *IN91         WIN91             1
     C                   MOVE      *IN92         WIN92             1
     C                   MOVE      *IN93         WIN93             1
     C                   MOVE      *IN94         WIN94             1
     C                   MOVE      *IN95         WIN95             1
     C                   MOVEA     '00000'       *IN(91)
     C                   MOVE      '0'           *IN99
      *
     C                   DO
      *
      ** Determine sign of ZZAMTI and ZZAMTD, 92 IF NEG
      ** If both are zero, bypass processing
      *
     C     ZZAMTI        IFEQ      *ZEROS
     C     ZZAMTD        ANDEQ     *ZEROS
     C                   LEAVE
     C                   ELSE
     C     ZZAMTI        IFLT      *ZEROS
     C     ZZAMTD        ORLT      *ZEROS
     C                   MOVE      '1'           *IN92
     C                   ENDIF
     C                   ENDIF
      *
      ** Determine sign of ZZTOTI and ZZTOTD, 91 IF NEG.
      ** If ZZTOTAL is ZERO, return ZZAMOUNT.
      *
     C     ZZTOTI        IFEQ      *ZEROS
     C     ZZTOTD        ANDEQ     *ZEROS
     C                   Z-ADD     ZZAMTI        ZZTOTI           15 0
     C                   Z-ADD     ZZAMTD        ZZTOTD            3 0
     C                   LEAVE
     C                   ELSE
     C     ZZTOTI        IFLT      *ZEROS
     C     ZZTOTD        ORLT      *ZEROS
     C                   MOVE      '1'           *IN91
     C                   ENDIF
     C                   ENDIF
      *
      ** If signs differ, bypass overflow checks
      *
     C     *IN91         IFEQ      '0'
     C     *IN92         ANDEQ     '0'
     C     *IN91         OREQ      '1'
     C     *IN92         ANDEQ     '1'
      *
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         IFGT      999
     C     ZZWK2         ORLE      999
     C     ZZWK2         ANDLT     -999
      *
     C     *IN92         IFEQ      '0'
     C     ZZAMTI        ADD       1             ZZWK3            15 0
     C                   ELSE
     C     ZZAMTI        SUB       1             ZZWK3
     C                   ENDIF
     C     ZZTOTI        ADD       ZZWK3         ZZWK3
      *
     C                   ELSE
     C     ZZTOTI        ADD       ZZAMTI        ZZWK3
     C                   ENDIF
      *
      ** If the modulus of ZZWK3 is less than the modulus of ZZTOTI,
      ** then overflow has occurred
      *
     C     *IN92         IFEQ      '0'
     C     ZZWK3         COMP      ZZTOTI                               99
     C                   ELSE
     C     ZZWK3         COMP      ZZTOTI                             99
     C                   ENDIF
      *
      ** If overflow occurs, zeroise ZZAMT
      *
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     0             ZZAMT            15 3
     C                   ELSE
     C                   Z-ADD     ZZWK2         ZZTOTD
     C                   Z-ADD     ZZWK3         ZZTOTI
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
      *
      ** the signs are different
      *
     C     *IN91         IFEQ      '1'
     C     *IN92         ANDEQ     '0'
     C     *IN91         OREQ      '0'
     C     *IN92         ANDEQ     '1'
      *
      ** If ZZAMT was negative, make it positive to compare with ZZTOT
      *
     C     *IN92         IFEQ      '1'
     C                   Z-SUB     ZZAMTI        ZZAMTI           15 0
     C                   Z-SUB     ZZAMTD        ZZAMTD            3 0
     C                   ENDIF
      *
      ** If ZZTOT was negative, make it positive to compare with ZZAMT
      *
     C     *IN91         IFEQ      '1'
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
      *
      ** Both ZZAMT and ZZTOT are now positive
      ** If ZZTOT equals ZZAMT, return zero
      *
     C                   MOVE      '0'           *IN93
     C     ZZTOTI        IFEQ      ZZAMTI
     C     ZZTOTD        ANDEQ     ZZAMTD
     C                   Z-ADD     0             ZZTOTI
     C                   Z-ADD     0             ZZTOTD
     C                   LEAVE
     C                   ELSE
     C     ZZTOTI        IFGT      ZZAMTI
     C     ZZTOTD        OREQ      ZZAMTD
     C                   MOVE      '1'           *IN93
     C                   ENDIF
     C                   ENDIF
      *
      ** If ZZTOT greater than ZZAMT
      *
     C     *IN93         IFEQ      '1'
     C     ZZAMTD        IFGT      ZZTOTD
     C     ZZTOTI        SUB       1             ZZTOTI
     C     ZZTOTD        ADD       1000          ZZWK2
     C     ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C     ZZWK2         SUB       ZZAMTD        ZZTOTD
     C                   ELSE
     C     ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C     ZZTOTD        SUB       ZZAMTD        ZZTOTD
     C                   ENDIF
      *
      ** If ZZAMT greater than ZZAMT
      *
     C                   ELSE
     C     ZZTOTD        IFGT      ZZAMTD
     C     ZZAMTI        SUB       1             ZZWK3            15 0
     C     ZZAMTD        ADD       1000          ZZWK2
     C     ZZWK3         SUB       ZZTOTI        ZZTOTI
     C     ZZWK2         SUB       ZZTOTD        ZZTOTD
     C                   ELSE
     C     ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C     ZZAMTD        SUB       ZZTOTD        ZZTOTD
     C                   ENDIF
     C                   ENDIF
      *
      ** Reverse sign of ZZTOT if larger input fields were negative
      *
     C     *IN93         IFEQ      '1'
     C     *IN91         ANDEQ     '1'
     C     *IN93         OREQ      '0'
     C     *IN92         ANDEQ     '1'
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
      *
      ** Restore sign of ZZAMTI & ZZAMTD if reversed
      *
     C     *IN92         IFEQ      '1'
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** If ZZTOTD is zero, and ZZTOTI is negative, setup  ZZNEGD
      *
     C     ZZTOTD        IFEQ      *ZEROS
     C     ZZTOTI        ANDLT     *ZEROS
     C                   MOVE      '.000-'       ZZNEGD            5
     C                   ENDIF
      *
      ** Restore previous indicator values
      *
     C                   MOVE      WIN91         *IN91
     C                   MOVE      WIN92         *IN92
     C                   MOVE      WIN93         *IN93
     C                   MOVE      WIN94         *IN94
     C                   MOVE      WIN95         *IN95
      *
     C                   ENDSR
      *****************************************************************                       CLE041
      /SPACE 5                                                                                CLE041
      *****************************************************************                       CLE041
      * SROVRD   : Perform overrides                                  *                       CLE041
      *****************************************************************                       CLE041
     C     SROVRD        BEGSR                                                                CLE041
                                                                                              CLE041
     C                   IF        FPTRCA = 'AG'                                              CLE041
                                                                                              CLE041
      ** OVRDBF FCLTYX to LEAGFCL0 then OPEN FCLTYX                                           CLE041
                                                                                              CLE041
     C                   EVAL      LENGTH = %SIZE(OVRDBF2)                                    CLE041
     C                   CALL      'QCMDEXC'                                                  CLE041
     C                   PARM      OVRDBF2       QCMD             70                          CLE041
     C                   PARM                    LENGTH           15 5                        CLE041
                                                                                              CLE041
      ** OVRDBF FCLTYX to LEAGFCL0 then OPEN FCLTYX                                           CLE041
                                                                                              CLE041
     C                   EVAL      LENGTH = %SIZE(OVRDBFB2)                                   CLE041
     C                   CALL      'QCMDEXC'                                                  CLE041
     C                   PARM      OVRDBFB2      QCMD                                         CLE041
     C                   PARM                    LENGTH                                       CLE041
     C                   ELSE                                                                 CLE041
                                                                                              CLE041
      ** OVRDBF FCLTYX to FCLTY then OPEN FCLTYX                                              CLE041
                                                                                              CLE041
     C                   EVAL      LENGTH = %SIZE(OVRDBF)                                     CLE041
     C                   CALL      'QCMDEXC'                                                  CLE041
     C                   PARM      OVRDBF        QCMD                                         CLE041
     C                   PARM                    LENGTH                                       CLE041
                                                                                              CLE041
      ** OVRDBF FCLTYX to FCLTY then OPEN FCLTYX                                              CLE041
                                                                                              CLE041
     C                   EVAL      LENGTH = %SIZE(OVRDBFB)                                    CLE041
     C                   CALL      'QCMDEXC'                                                  CLE041
     C                   PARM      OVRDBFB       QCMD                                         CLE041
     C                   PARM                    LENGTH                                       CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
     C                   OPEN      FCLTYX                                                     CLE041
     C                   OPEN      FCLTYXFN                                                   CLE041
                                                                                              CLE041
     C                   ENDSR                                                                CLE041
      *****************************************************************                     MD024342
      /EJECT                                                                                MD024342
      *****************************************************************                     MD024342
      * Initialise - Initialise trailer fields                        *                     MD024342
      *****************************************************************                     MD024342
     C     Initialise    BEGSR                                                              MD024342
      *                                                                                     MD024342
     C                   EVAL      NORE = 0                                                 MD024342
     C                   EVAL      NLRB = 0                                                 MD024342
     C                   EVAL      NINS = 0                                                 MD024342
     C                   EVAL      NDEL = 0                                                 MD024342
     C                   EVAL      NLRA = 0                                                 MD024342
     C                   EVAL      VLBF = 0                                                 MD024342
     C                   EVAL      VLBL = 0                                                 MD024342
     C                   EVAL      VRIF = 0                                                 MD024342
     C                   EVAL      VRIL = 0                                                 MD024342
     C                   EVAL      VRDF = 0                                                 MD024342
     C                   EVAL      VRDL = 0                                                 MD024342
     C                   EVAL      VRAF = 0                                                 MD024342
     C                   EVAL      VRAL = 0                                                 MD024342
     C                   EVAL      VLAF = 0                                                 MD024342
     C                   EVAL      VLAL = 0                                                 MD024342
      *                                                                                     MD024342
     C                   ENDSR                                                              MD024342
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    P#MODE            1
     C                   PARM                    LEVFCIM
     C                   PARM                    LEVFCIN
     C                   PARM                    CLE008            1
     C                   PARM                    CSC011            1
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJSLCD            3                       AR937578A
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    H#TNLU            5 0
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FCIP_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx                3 0

     C     *LIKE         DEFINE    CNUM          K#CNUM
     C     *LIKE         DEFINE    FACT          K#FACT
     C     *LIKE         DEFINE    FCNO          K#FCNO
     C     *LIKE         DEFINE    RCTP          K#RCTP
     C     *LIKE         DEFINE    CNUM          K0CANM
     C     *LIKE         DEFINE    FACT          K0CAFT
     C     *LIKE         DEFINE    FCNO          K0CAFN
      **
     C     *LIKE         DEFINE    CNUM          K3CNUM
     C     *LIKE         DEFINE    FACT          K3FACT
     C     *LIKE         DEFINE    FCNO          K3FCNO
     C     *LIKE         DEFINE    RCTP          K3RCTP

     C     *LIKE         DEFINE    CNUM          K4CNUM
     C     *LIKE         DEFINE    FACT          K4FACT
     C     *LIKE         DEFINE    FCNO          K4FCNO
     C     *LIKE         DEFINE    BRCA          K4BRCA

     C     *LIKE         DEFINE    FAMT          W#SFAMT

      **  Define key to access Facilty file
     C     KFAC01        KLIST
     C                   KFLD                    FPCNUM
     C                   KFLD                    FPFACT
     C                   KFLD                    FPFCNO

     C     K#FCTY        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#RCTP
      *
      **  Facility
     C     K#KY03        KLIST
     C                   KFLD                    K3CNUM
     C                   KFLD                    K3FACT
     C                   KFLD                    K3FCNO
     C                   KFLD                    K3RCTP
      *
      **  Facility participant (LEFCLTL2)
     C     K#KY04        KLIST
     C                   KFLD                    K4BRCA
     C                   KFLD                    K4CNUM
     C                   KFLD                    K4FACT
     C                   KFLD                    K4FCNO

      **  Used for LEFCLTL9
     C     K#KY10        KLIST
     C                   KFLD                    K0CANM
     C                   KFLD                    K0CAFT
     C                   KFLD                    K0CAFN
      *                                                                                      BUG4555
     C     KCwFld        KLIST                                                               BUG4555
     C                   KFLD                    WFuncType                                   BUG4555
     C                   KFLD                    WIdntifier                                  BUG4555
     C                   KFLD                    WBranch                                     BUG4555
      *                                                                                     MD024342
     C*****KAPILST       KLIST                                                     MD024342 MD025467
     C**********         KFLD                    WAPIC             4               MD024342 MD025467
     C**********         KFLD                    WFILN            10               MD024342 MD025467
      *                                                                                     MD024342
      ***Get*MPHAS*dataarea.******************************************             MD024342 MD025467
      *                                                                            MD024342 MD025467
     C******DTAARA       DEFINE                  MPHAS                             MD024342 MD025467
     C**********         IN        MPHAS                                           MD024342 MD025467
     C**********         UNLOCK    MPHAS                                           MD024342 MD025467
      *                                                                                     MD024342
     C**********         MOVEL     FPFRNT        W#FRNT                            MD024342 MD025467

      **  DEFINE DTAARA JNSTAT
     C     *DTAARA       DEFINE                  JNSTAT

     C     CSC011        IFEQ      'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   END

      ** OVRDBF FCLTYX to FCLTY then OPEN FCLTYX

     C**********         EVAL      LENGTH = %SIZE(OVRDBF)                                     CLE041
     C**********         CALL      'QCMDEXC'                                                  CLE041
     C**********         PARM      OVRDBF        QCMD             70                          CLE041
     C**********         PARM                    LENGTH           15 5                        CLE041
     C**********         OPEN      FCLTYX                                                     CLE041

      ** OVRDBF FCLTYXFN to FCLTY

     C**********         EVAL      LENGTH = %SIZE(OVRDBFB)                                    CLE041
     C**********         CALL      'QCMDEXC'                                                  CLE041
     C**********         PARM      OVRDBFB       QCMD             70                          CLE041
     C**********         PARM                    LENGTH           15 5                        CLE041
     C**********         OPEN      FCLTYXFN                                                   CLE041

      * If the user is connected via a browser, the job user name is QUSER -                 BUG2515
      * their user name is stored in ZMUSER                                                  BUG2515
     C**********         IN        ZMUSER                                            BUG2515 BUG8550
                                                                                             BUG2515
      ** Access SAR details to see if CSD015 is switched on.                                 BUG4555
      *                                                                                      BUG4555
     C                   IN        SDSTAT                                                    BUG4555
      *                                                                                      BUG4555
     C                   CALL      'AOSARDR0'                                                BUG4555
     C                   PARM      *BLANKS       PRetCode                                    BUG4555
     C                   PARM      '*VERIFY'     POption                                     BUG4555
     C                   PARM      'CSD015'      PSARD                                       BUG4555
     C     SCSARD        PARM      *BLANKS       DSFDY                                       BUG4555
                                                                                             BUG4555
     C                   IF        PRetCode = *BLANKS                                        BUG4555
                                                                                             BUG4555
     C                   EVAL      CSD015 = 'Y'                                              BUG4555
     C                   ELSE                                                                BUG4555
                                                                                             BUG4555
     C                   IF        PRetCode <> '*NRF'                                        BUG4555
     C     *LOCK         IN        LDA                                                       BUG4555
     C                   EVAL      DBKey = 'CSD015'                                          BUG4555
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG4555
     C                   EVAL      DBase = 903                                               BUG4555
     C                   OUT       LDA                                                       BUG4555
     C                   EXSR      *PSSR                                                     BUG4555
     C                   ENDIF                                                               BUG4555
                                                                                             BUG4555
     C                   ENDIF                                                               BUG4555
                                                                                             BUG4555
     C                   IF        CSD015 = 'Y'                                              BUG4555
                                                                                             BUG4555
      ** Check if transactions are being monitored by Compliance Watch.                      BUG4555
                                                                                             BUG4555
     C                   CALL      'AOWLCCR0'                                                BUG4555
     C                   PARM      *BLANKS       PRetCode                                    BUG4555
     C                   PARM      '*KEY   '     POption                                     BUG4555
     C                   PARM      'LENDING '    PFunc                                       BUG4555
     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG4555
                                                                                             BUG4555
     C                   IF        PRetCode <> *BLANKS AND                                   BUG4555
     C                             PRetCode <> '*NRF'                                        BUG4555
     C     *LOCK         IN        LDA                                                       BUG4555
     C                   EVAL      DBKey = 'LENDING'                                         BUG4555
     C                   EVAL      DBFile = 'SDWLCCPD'                                       BUG4555
     C                   EVAL      DBase = 904                                               BUG4555
     C                   OUT       LDA                                                       BUG4555
     C                   EXSR      *PSSR                                                     BUG4555
     C                   ENDIF                                                               BUG4555
                                                                                             BUG4555
     C                   CALL      'AOCWCDR0'                                                BUG4555
     C                   PARM      *BLANKS       PRetCode                                    BUG4555
     C                   PARM      '*FIRST '     POption                                     BUG4555
     C     SDCWCD        PARM      SDCWCD        DSSDY                                       BUG4555
                                                                                             BUG4555
     C                   IF        PRetCode <> *BLANKS                                       BUG4555
     C     *LOCK         IN        LDA                                                       BUG4555
     C                   EVAL      DBKey = POption                                           BUG4555
     C                   EVAL      DBFile = 'SDCWCDPD'                                       BUG4555
     C                   EVAL      DBase = 905                                               BUG4555
     C                   OUT       LDA                                                       BUG4555
     C                   EXSR      *PSSR                                                     BUG4555
     C                   ENDIF                                                               BUG4555
                                                                                             BUG4555
     C                   ENDIF                                                               BUG4555
                                                                                             BUG4555
      ** Access SAR details to see if CCF001 is switched on.                                 BUG4555
                                                                                             BUG4555
     C                   CALL      'AOSARDR0'                                                BUG4555
     C                   PARM      *BLANKS       PRetCode                                    BUG4555
     C                   PARM      '*VERIFY'     POption                                     BUG4555
     C                   PARM      'CCF001'      PSARD                                       BUG4555
     C     SCSARD        PARM      *BLANKS       DSFDY                                       BUG4555
                                                                                             BUG4555
     C                   IF        PRetCode = *BLANKS                                        BUG4555
                                                                                             BUG4555
     C                   EVAL      CCF001 = 'Y'                                              BUG4555
     C                   ELSE                                                                BUG4555
                                                                                             BUG4555
     C                   IF        PRetCode <> '*NRF'                                        BUG4555
     C     *LOCK         IN        LDA                                                       BUG4555
     C                   EVAL      DBKey = 'CCF001'                                          BUG4555
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG4555
     C                   EVAL      DBase = 907                                               BUG4555
     C                   OUT       LDA                                                       BUG4555
     C                   EXSR      *PSSR                                                     BUG4555
     C                   ENDIF                                                               BUG4555
                                                                                             BUG4555
     C                   ENDIF                                                               BUG4555
                                                                                              CAP086
      ** Check if CAP086 is enabled                                                           CAP086
                                                                                              CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PRtCd                                        CAP086
     C                   PARM      '*VERIFY'     POptn                                        CAP086
     C                   PARM      'CAP086'      PSARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRtCd = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ELSE                                                                 CAP086
                                                                                              CAP086
     C                   IF        PRtCd <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBase = 22                                                 CAP086
     C                   EVAL      DBKey = 'CAP086'                                           CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      SRErr                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRtCd                                        CSD083
     C                   PARM      '*VERIFY'     POptn                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRtCd <> *BLANKS AND                                       CSD083
     C                             PRtCd <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 23                                                 CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      SRErr                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRtCd = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
      *                                                                                     MD024342
     C**********         MOVEL     'N'           MTHREAD           1               MD024342 MD025467
     C**********         MOVE      'FCIP'        WAPIC                             MD024342 MD025467
     C**********         MOVEL     'FCLTYZZ'     WFILN                             MD024342 MD025467
     C**********         IF        MPHAS = 'A' AND                                 MD024342 MD025467
     C**********                   W#FRNT <> 'LE000473'                            MD024342 MD025467
     C*****KAPILST       CHAIN     SDAPDRL0                           99           MD024342 MD025467
     C******IN99         IFEQ      '0'                                             MD024342 MD025467
     C**********         MOVEL     A8MULT        MTHREAD                           MD024342 MD025467
     C**********         ENDIF                                                     MD024342 MD025467
     C**********         ENDIF                                                     MD024342 MD025467
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'LEFCIPUPD'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
     C****************************************************************
**  CPY@
(c) Finastra International Limited 2002
** XOT - OPEN TAGS for XML                                                                   BUG4555
<Customer>                                                                                   BUG4555
** XCT - CLOSE TAGS for XML                                                                  BUG4555
</Customer>                                                                                  BUG4555
