     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Base rate codes database update')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Date Module                                 *
      *                                                               *
      *  SDBSRTUPD - SD BASE RATE DATABASE UPDATE                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CTI006             Date 31Mar14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG22792           Date 23Feb08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245028             Date 02Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12718           Date 24Nov06               *
      *                 BUG11299           Date 27Apr06               *
      *                 BG4254             Date 16Nov04               *
      *                 BUG4660            Date 05Nov04               *
      *                 CTI004             Date 12Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 16Jul03               *
      *                 CSD012             Date 15Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 19May01               *
      *                 CAP038  *CREATE    Date 24Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface                *
      *  BUG22792 - Apply fix 258440                                  *
      *  258440   - Value date of current rate must not be updated    *
      *             during amend                                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245028 - TI date should be updated with new date - 1.        *
      *  BUG12718 - Errorneous loan interest accrual calculation      *
      *             due to zero current base rate.                    *
      *  BUG11299 - New base rate is not updated during amend.        *
      *             Recompiled this module.                           *
      *  BG4254 - Standing Data Authorisation user is wrong (QUSER)   *
      *  BUG4660 - Current Base Rate must not be updated during amend.*
      *  CTI004 - MidasPlus-TI Integration Enhancements               *
      *           Base Rates Integration                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Allow synchronous insert; create timestamp          *
      *  CSD012 - Standing Data Authorisation                         *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP038 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************
      * Midas SD Base Rate File
     FSDBSRTL0  UF A E           K DISK
     F                                     COMMIT
      * Midas SD Controls File
     FSDFCTLL0  UF A E           K DISK
     F                                     COMMIT

      * Market Data Feed Requests Details File                                                CSD006
     FSDMDFRL0  UF A E           K DISK    COMMIT                                             CSD006
                                                                                              CSD006
      * Market Data Feed Requested Details Items File                                         CSD006
     FSDMDFIL0  UF A E           K DISK    COMMIT                                             CSD006
                                                                                              CSD006
      * Market Data Feed Rate/Price History File                                              CSD006
     FSDMDFHPD  UF A E           K DISK    COMMIT                                             CSD006
                                                                                              CSD006
     FSDAULGL0  UF A E           K DISK    COMMIT                                             CSD012
      * RTV : Authorisation Log - by Key                                                      CSD012
                                                                                              CSD012
     FSDBRSHL0  UF A E           K DISK    COMMIT                                             CSD012
     F                                     RENAME(SDBSRTD0:SDBRSHD0)                          CSD012
      * UPD : Base Rate Codes Shadow file by key                                              CSD012
      *                                                                                       CSD012
     F/COPY WNCPYSRC,SDH00531
     FSDBSHSL1  IF   E           K DISK    INFSR(*PSSR)                                       245028
      ** Midas SD Base Rate History File                                                      245028
     F/COPY WNCPYSRC,SDH00518
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

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID BASE RATE
     D SDVBSRT       E DS                  EXTNAME(SDVBSRTPD)

      ** Rename fields for Timestamp checking
     D ChkBSRTFmt    E DS                  EXTNAME(SDBSRTPD)
     D                                     PREFIX(CH)

      **  Midas Base Rate File
     D BaseRate      E DS                  EXTNAME(SDBSRTPD)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Midas Modules details accessed via access program

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure

      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** Midas API Message Header Format Definition                                           CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
                                                                                              CSC011
      * Data Structure for SAR Details                                                        CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
                                                                                              CSC011
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
                                                                                              CSD012
      ** Fields defined for Enhancement CSD012 used for SDAULGL0                              CSD012
     D***@AULG**         DS            20                                              CSD012 CGL029
     D @AULG           DS            26                                                       CGL029
     D @DDCYCD                 1      3                                                       CSD012
     D @DDBSRC                 4      5                                                       CSD012
     D FUNCD           C                   CONST('BASE RATE DETAILS')                         CSD012
      ** Override SDBRSHL0                                                                    CSD012
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
                                                                                              CSC011
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PDealNum        S             18A                                                      CSC011
     D PADealNo        S             18A                                                      CSC011
     D PTimestamp      S             26A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011

      ** Data structure passed to SD0520X
     D WUDELR          DS
     D  WUDR01                 1    250
     D  WUDR02               251    500
     D  WUDR03               501    750
     D  WUDR04               751   1000
     D  WUDR05              1001   1250
     D  WUDR06              1251   1500
     D  WUDR07              1501   1750
     D  WUDR08              1751   2000
     D  WUDR09              2001   2250
     D  WUDR00              2251   2500
     D  WUDR11              2501   2750
     D  WUDR12              2751   3000
      * Outward parameters
     D***PARC***         DS          3064                                                     CGL029
     D*PARC*****       DS          3070                                                CGL029 CTI006
     D PARC            DS          3064                                                       CTI006
      * RCD : Midas SD Deleted records file retrieval
      * I :  File name
     D  PAFNME                 1     10
      * I :  Long Key
     D***PALKEY*               11     60                                                      CGL029
     D**PALKEY**              11     66                                                CGL029 CTI006
     D  PALKEY                11     60                                                       CTI006
      * I :  Deleted Data Record Pt1
     D***PADR01*               61    310                                                      CGL029
     D**PADR01**              67    316                                                CGL029 CTI006
     D  PADR01                61    310                                                       CTI006
      * I :  Deleted Data Record Pt2
     D***PADR02*              311    560                                                      CGL029
     D**PADR02**             317    566                                                CGL029 CTI006
     D  PADR02               311    560                                                       CTI006
      * I :  Deleted Data Record Pt3
     D***PADR03*              561    810                                                      CGL029
     D**PADR03**             567    816                                                CGL029 CTI006
     D  PADR03               561    810                                                       CTI006
      * I :  Deleted Data Record Pt4
     D***PADR04*              811   1060                                                      CGL029
     D**PADR04**             817   1066                                                CGL029 CTI006
     D  PADR04               811   1060                                                       CTI006
      * I :  Deleted Data Record Pt5
     D***PADR05*             1061   1310                                                      CGL029
     D**PADR05**            1067   1316                                                CGL029 CTI006
     D  PADR05              1061   1310                                                       CTI006
      * I :  Deleted Data Record Pt6
     D***PADR06*             1311   1560                                                      CGL029
     D**PADR06**            1317   1566                                                CGL029 CTI006
     D  PADR06              1311   1560                                                       CTI006
      * I :  Deleted Data Record Pt7
     D***PADR07*             1561   1810                                                      CGL029
     D**PADR07**            1567   1816                                                CGL029 CTI006
     D  PADR07              1561   1810                                                       CTI006
      * I :  Deleted Data Record Pt8
     D***PADR08*             1811   2060                                                      CGL029
     D**PADR08**            1817   2066                                                CGL029 CTI006
     D  PADR08              1811   2060                                                       CTI006
      * I :  Deleted Data Record Pt9
     D***PADR09*             2061   2310                                                      CGL029
     D**PADR09**            2067   2316                                                CGL029 CTI006
     D  PADR09              2061   2310                                                       CTI006
      * I :  Deleted Data Record Pt10
     D**PADR00*             2311   2560                                                      CGL029
     D**PADR00**            2317   2566                                                CGL029 CTI006
     D  PADR00              2311   2560                                                       CTI006
      * I :  Deleted Data Record Pt11
     D***PADR11*             2561   2810                                                      CGL029
     D**PADR11**            2567   2816                                                CGL029 CTI006
     D  PADR11              2561   2810                                                       CTI006
      * I :  Deleted Data Record Pt12
     D***PADR12*             2811   3060                                                      CGL029
     D**PADR12**            2817   3066                                                CGL029 CTI006
     D  PADR12              2811   3060                                                       CTI006
      * I :  Last Change Date
     D***PALCD**             3061   3063P 0                                                   CGL029
     D**PALCD***            3067   3069P 0                                             CGL029 CTI006
     D  PALCD               3061   3063P 0                                                    CTI006
      * I :  Type of Last Change
     D***PATYLC*             3064   3064                                                      CGL029
     D**PATYLC**            3070   3070                                                CGL029 CTI006
     D  PATYLC              3064   3064                                                       CTI006
      *                                                                                       CAP084
      ***  Timestamp                                                                          CAP084
     D TimeStamp       S               Z                                                      CAP084
                                                                                             BUG4660
     D WOBACBSR        S                   LIKE(BACBSR)                                      BUG4660
      *                                                                                       258440
     D WOBAVDRC        S                   LIKE(BAVDRC)                                       258440

      *  User / Branch data area                                                              BG4254
     D ZMUSER          DS            17                                                       BG4254
     D  WUSRID                 1     10                                                       BG4254
                                                                                              245028
      ** DEFINE FIELDS FOR ZDATE9                                                             245028
     D @DAYN           S              5P 0                                                    245028
     D @YMD            S              8S 0                                                    245028
     D @RETN           S              1A                                                      245028
     D/COPY WNCPYSRC,SDH00519
                                                                                              245028
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
     C                   EXSR      CHKOTHUPD

     C     ReturnCode    IFNE      *BLANKS
     C                   RETURN
     C                   END

      * EXIT IF NOT INSERTION, AMENDMENT, DELETION

     C     BVTYLC        IFNE      'I'
     C     BVTYLC        ANDNE     'A'
     C     BVTYLC        ANDNE     'D'
     C                   RETURN
     C                   END

      ***  Get timestamp                                                                      CAP084
     C                   CALLB     'ZAGENTMSTM'                                               CAP084
     C                   PARM                    TimeStamp                                    CAP084
                                                                                              CAP084
      * Auth Req is ON and Auth Mode is not 'X' .                                             CSD012
     C     AUTHRQ        IFEQ      'Y'                                                        CSD012
     C     AUTHMD        ANDNE     'X'                                                        CSD012
      *                                                                                       CSD012
     C                   MOVEL     BVTYLC        WorkCHTP          1                          CSD012
     C                   Z-ADD     BVLCD         WorkLCD           5 0                        CSD012
     C                   MOVEL     *BLANK        BVTYLC                                       CSD012
     C                   Z-ADD     *ZERO         BVLCD                                        CSD012
      *                                                                                       CSD012
     C     @KBSRT0       CHAIN     SDBSRTL0                           99                      CSD012
      *                                                                                       CSD012
     C     *IN99         IFEQ      *OFF                                                       CSD012
      *                                                                                       CSD012
     C     BATYLC        IFEQ      'I'                                                        CSD012
     C                   MOVEL     BVSYLL        WorkSYLL          1                          CSD012
     C                   MOVEL     BVSYLR        WorkSYLR          1                          CSD012
     C                   Z-ADD     BVCBSR        WorkCBSR         11 7                        CSD012
     C                   MOVEL     *BLANK        BVSYLL                                       CSD012
     C                   MOVEL     *BLANK        BVSYLR                                       CSD012
     C                   Z-ADD     *ZERO         BVCBSR                                       CSD012
     C                   ENDIF                                                                CSD012
     C                   MOVEL     BATYLC        WorkTYLC          1                          CSD012
     C                   MOVEL     *BLANK        BATYLC                                       CSD012
     C                   Z-ADD     *ZERO         BALCD                                        CSD012
     C     BaseRate      IFEQ      SDVBSRT                                                    CSD012
     C     WORKCHTP      ANDEQ     'A'                                                        CSD012
     C                   GOTO      NOUPDAT                                                    CSD012
     C                   ENDIF                                                                CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   MOVEL     WorkCHTP      BVTYLC                                       CSD012
     C                   Z-ADD     WorkLCD       BVLCD                                        CSD012
     C     WorkTYLC      IFEQ      'I'                                                        CSD012
     C                   MOVEL     WorkSYLL      BVSYLL                                       CSD012
     C                   MOVEL     WorkSYLR      BVSYLR                                       CSD012
     C                   Z-ADD     WorkCBSR      BVCBSR                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     @KBSRT0       CHAIN     SDBRSHL0                           91                      CSD012
      * If record does not exist write details to shadow file                                 CSD012
     C     *IN91         IFEQ      *ON                                                        CSD012
      *                                                                                       CSD012
     C                   MOVEL     BVCYCD        BACYCD                                       CSD012
     C                   MOVEL     BVBSRC        BABSRC                                       CSD012
     C                   MOVEL     BVLCD         BALCD                                        CSD012
     C                   MOVEL     BVTYLC        BATYLC                                       CSD012
     C                   MOVEL     BVCBSR        BACBSR                                       CSD012
     C                   MOVEL     BVVDRC        BAVDRC                                       CSD012
     C                   MOVEL     BVBSRN        BABSRN                                       CSD012
     C                   MOVEL     BVNBRT        BANBRT                                       CSD012
     C                   MOVEL     BVVDNR        BAVDNR                                       CSD012
     C                   MOVEL     BVBSRS        BABSRS                                       CSD012
     C                   MOVEL     BVDLLC        BADLLC                                       CSD012
     C                   MOVEL     BVSYLL        BASYLL                                       CSD012
     C                   MOVEL     BVCSLL        BACSLL                                       CSD012
     C                   MOVEL     BVACLT        BAACLT                                       CSD012
     C                   MOVEL     BVACRC        BAACRC                                       CSD012
     C                   MOVEL     BVDLRC        BADLRC                                       CSD012
     C                   MOVEL     BVSYLR        BASYLR                                       CSD012
     C                   MOVEL     BVCSLR        BACSLR                                       CSD012
     C                   MOVEL     BVBSCD        BABSCD                                       CSD012
     C                   MOVEL     BVSCDD        BASCDD                                       CSD012
     C                   MOVEL     BVDGMA        BADGMA                                       CSD012
     C                   MOVEL     BVOMD1        BAOMD1                                       CSD012
     C                   MOVEL     BVOMD2        BAOMD2                                       CSD012
      *                                                                                       CSD012
      ** If CSC011 is installed, supply a Front Office ID for the                             CSD012
      ** transaction even if it originated from SIN module.                                   CSD012
                                                                                              CSD012
     C     BVTYLC        IFEQ      'I'                                                        CSD012
     C     CSC011        ANDEQ     'Y'                                                        CSD012
     C     BAFRNT        ANDEQ     *BLANKS                                                    CSD012
     C                   EVAL      BAFRNT = 'MD' + BACYCD + BABSRC                            CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     BVFOTRANID    BAFRNT                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   MOVEL     BVRPRLOCN     BAREPA                                       CSD012
      *                                                                                       CSD012
      ** If a Front Office transaction set timestamp to that of                               CSD012
      ** original record's to prevent timestamp problems when authorising.                    CSD012
     C     ModeofOp      IFEQ      '*FRONT'                                                   CSD012
     C     BVTYLC        ANDNE     'I'                                                        CSD012
     C                   MOVEL     CHBATMST      BATMST                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     BVTMESTMP     BATMST                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   MOVEL     BVBRDS        BABRDS                                       CSD012
     C                   MOVEL     BVDFTS        BADFTS                                       CSD012
     C                   MOVEL     BVDTFR        BADTFR                                       CSD012
     C                   MOVEL     BVTLEX        BATLEX                                       CSD012
      *                                                                                       CSD012
     C                   WRITE     SDBRSHD0                                                   CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   MOVEL     BVCYCD        @DDCYCD                                      CSD012
     C                   MOVEL     BVBSRC        @DDBSRC                                      CSD012
      * If Authorisation check is on,                                                         CSD012
      * check if unathorised record exists on Authorisation Log.                              CSD012
     C     @AULG         CHAIN     SDAULGL0                           92                      CSD012
      *                                                                                       CSD012
      * If record does not exist write details to Authoristion Log                            CSD012
     C     *IN92         IFEQ      *ON                                                        CSD012
     C                   MOVEL     @AULG         ALKEY                                        CSD012
     C                   MOVEL     FUNCD         ALFUNC                                       CSD012
     C                   MOVE      BVTYLC        ALACTN                                       CSD012
      *                                                                                       BG4254
      * If the user is connected via a browser, the job user name is QUSER -                  BG4254
      * the actual user name is stored in ZMUSER                                              BG4254
     C                   If        PSUser = 'QUSER'                                           BG4254
      *                                                                                       BG4254
      ** Retrieve ZMUSER details.                                                             BG4254
     C     *DTAARA       DEFINE                  ZMUSER                                       BG4254
     C                   IN        ZMUSER                                                     BG4254
     C                   MOVE      WUSRID        ALUSER                                       BG4254
     C                   Else                                                                 BG4254
     C                   MOVE      PSUser        ALUSER                                       CSD012
     C                   EndIf                                                                BG4254
     C                   WRITE     SDAULGD0                                                   CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   RETURN                                                               CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C     NOUPDAT       TAG                                                                  CSD012

      * INSERT OR AMEND THE BASE RATE

     C     BVTYLC        CASEQ     'I'           BSRTINS
     C     BVTYLC        CASEQ     'A'           BSRTAMD
     C     BVTYLC        CASEQ     'D'           BSRTDLT
     C                   END

      ** Maintain Market Data Feed files                                                      CSD006
     C     CSD006F       IFEQ      'Y'                                                        CSD006
     C                   EXSR      MNTMDFF                                                    CSD006
     C                   END                                                                  CSD006
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   CALLB     'SDBSRTLOG'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    BaseRate                                     CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If there is no error, write the log file                                             CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *BLANKS                                       CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'SDBSRT'                                       CSC011
     C                   EVAL      APFOTRANID = BAFRNT                                        CSC011
     C                   EVAL      APRPRLOCN  = BAREPA                                        CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
                                                                                              CSC011
     C                   EVAL      PDealNum = BACYCD + BABSRC                                 CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTimestamp                                   CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *BLANKS                                      CSC011
     C                   EVAL      ReturnCode = '*ERROR'                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSD006
      * EXIT FROM PROGRAM
      *
     C                   RETURN
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKOTHUPD - Check for update by another workstation           *
      *                                                               *
      *****************************************************************
     C     CHKOTHUPD     BEGSR

      ** Retrieve current details


      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1
      *
      *  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C     @Type         IFEQ      '0'
     C                   MOVE      '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVE      *BLANKS       ModeofOp
     C                   END

     C                   CALLB     'SDBSRTRTV'
     C                   PARM                    RetCodeIn
     C                   PARM                    ModeofOp          6
     C                   PARM      ' '           RespMode          1
     C                   PARM      BVTYLC        DDACTN            1
     C                   PARM      BVFOTRANID    FOTRID           20
     C                   PARM      BVCYCD        DDCYCD            3
     C                   PARM      BVBSRC        DDBSRC            2
     C                   PARM                    ChkBSRTFmt
     C                   PARM                    OKACTN            1
     C                   PARM                    OKCYCD            1
     C                   PARM                    OKBSRC            1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx               3 0
      * ICD
     C                   PARM                    BGN4ST
     C                   PARM                    DDBSRS            5
     C                   PARM                    DDBSRN           30
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
      *
      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)

      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original record was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.

      ** Interactive mode:

     C     @TYPE         IFEQ      '1'
     C     BVTYLC        IFNE      'I'                                                        CAP084

     C     CHBATMST      IFNE      BVTMESTMP
     C                   MOVEL     '*RECUPD'     ReturnCode
     C                   ENDIF                                                                CAP084
     C                   END

      ** Batch mode:
     C                   ELSE
     C     OKACTN        IFEQ      'N'
     C     OKCYCD        OREQ      'N'
     C     OKBSRC        OREQ      'N'
     C                   MOVEL     '*RECUPD'     ReturnCode
     C                   Z-ADD     1             C                 2 0

     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       DBError          28
     C                   MOVEL     MsgIDArr(C)   DBError
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   END

     C                   END

     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* BSRTINS - INSERT A NEW BASE RATE                             *
     C*                                                              *
     C****************************************************************
     C     BSRTINS       BEGSR
      *

      * INITIALIZE BASE RATE

     C                   CLEAR                   BaseRate
      *
     C                   MOVEL     SDVBSRT       BaseRate
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        BAFRNT = *BLANKS                                           CSC011
     C                   EVAL      BAFRNT = 'MD' + BACYCD + BABSRC                            CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      * Timestamp                                                                             CAP084
     C                   EVAL      BATMST=TimeStamp                                           CAP084
      *                                                                                       CTI004
      ** Date Current Rate effective to: 2599 Dec 31                                          CTI004
      ** Current Base Rate is rate at the start of the day                                    CTI004
      *                                                                                       CTI004
     C                   EVAL      BAVDTO = 6991231                                           CTI004
     C                   IF        BACBSR = *ZEROS                                            CTI004
     C                   EVAL      BACBRT = BANBRT                                            CTI004
     C                   EVAL      BACBSR = BANBRT                                          BUG12718
     C                   ELSE                                                                 CTI004
     C                   EVAL      BACBRT = BACBSR                                            CTI004
     C                   ENDIF                                                                CTI004
      *
      *  WRITE DEAL
      *
     C                   WRITE     @BAREDG
      *
      * INSERT A RECORD IN THE TABLE TABLETK
     C                   EXSR      UPDTABL
     C/COPY WNCPYSRC,SDH00520
      *
      * UPDATE SD STANDING DATA CONTROL FILE
     C                   EXSR      UPDCTRL
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* BSRTAMD - AMEND A BASE RATE                                  *
     C*                                                              *
     C****************************************************************
     C     BSRTAMD       BEGSR
      *
      * ACCESS BASE RATE
      *
     C     @KBSRT0       CHAIN     SDBSRTL0                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     BVCYCD        DBKEY
     C                   MOVEL     'SDBSRTPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      SRERR
     C                   END
      *                                                                                      BUG4660
      ** Save the original current base rate                                                 BUG4660
      *                                                                                      BUG4660
     C                   EVAL      WOBACBSR = BACBSR                                         BUG4660
      *                                                                                       258440
      ** Save the original value date of current rate                                         258440
      *                                                                                       258440
     C                   EVAL      WOBAVDRC = BAVDRC                                          258440
      *                                                                                       CTI004
      ** Date Current Rate effective to: 2599 Dec 31                                          CTI004
      ** Current Base Rate is rate at the start of the day, this                              CTI004
      ** field will no change within the day.                                                 CTI004
      *                                                                                       CTI004
     C                   EVAL      BAVDTO = 6991231                                           CTI004
     C                   IF        BALCD < BJRDNB                                             CTI004
     C                   IF        BACBSR = *ZEROS                                            CTI004
     C                   EVAL      BACBRT = BANBRT                                            CTI004
     C                   ELSE                                                                 CTI004
     C                   EVAL      BACBRT = BACBSR                                            CTI004
     C                   ENDIF                                                                CTI004
     C                   ENDIF                                                                CTI004
      *
     C                   MOVEL     SDVBSRT       BaseRate
     C/COPY WNCPYSRC,SDH00521
      *                                                                                      BUG4660
      ** Put the original value of the current base rate back.                               BUG4660
      ** This field should not change during amend.                                          BUG4660
      *                                                                                      BUG4660
     C                   EVAL      BACBSR = WOBACBSR                                         BUG4660
                                                                                              245028
     C                   EVAL      BAVDTO = 6991231                                           245028
     C                   EVAL      BACBRT = BACBSR                                            245028
                                                                                              245028
      ** If AMENDED today, set TI Date to (Value Date of New Rate - 1)                        245028
      ** Set to 6991231 if Back Valued base rate change and earlier than current date         245028
      ** Convert Midas Date to TI Date - CYYMMDD                                              245028
                                                                                              245028
     C     BATYLC        IFEQ      'A'                                                        245028
     C     BACBSR        ANDNE     BANBRT                                                     245028
     C     BACBSR        ANDNE     *ZEROS                                                     245028
     C     BAVDRC        ORNE      BAVDNR                                                     245028
     C     BAVDNR        ANDNE     *ZEROS                                                     245028
                                                                                              245028
     C     BAVDNR        SUB       1             W#PREV            5 0                        245028
                                                                                              245028
      **  Convert date from day number to YMD                                                 245028
                                                                                              245028
     C                   Z-ADD     W#PREV        @DAYN                                        245028
     C                   CALLB     'ZDATE9'                                                   245028
     C                   PARM                    @DAYN                                        245028
     C                   PARM                    @YMD                                         245028
     C                   PARM                    @RETN                                        245028
                                                                                              245028
     C                   MOVEL     @YMD          W#YY              2 0                        245028
                                                                                              245028
      ** Get century                                                                          245028
                                                                                              245028
     C                   SELECT                                                               245028
     C     W#YY          WHENEQ    20                                                         245028
     C                   MOVEL     1             W#CYYMMDD         7                          245028
     C     W#YY          WHENEQ    21                                                         245028
     C                   MOVEL     2             W#CYYMMDD                                    245028
     C     W#YY          WHENEQ    22                                                         245028
     C                   MOVEL     3             W#CYYMMDD                                    245028
     C     W#YY          WHENEQ    23                                                         245028
     C                   MOVEL     4             W#CYYMMDD                                    245028
     C     W#YY          WHENEQ    24                                                         245028
     C                   MOVEL     5             W#CYYMMDD                                    245028
     C     W#YY          WHENEQ    25                                                         245028
     C                   MOVEL     6             W#CYYMMDD                                    245028
     C                   OTHER                                                                245028
     C                   MOVEL     1             W#CYYMMDD                                    245028
     C                   ENDSL                                                                245028
                                                                                              245028
     C                   MOVE      @YMD          W#YYMMDD          6                          245028
     C                   MOVE      W#YYMMDD      W#CYYMMDD                                    245028
     C                   MOVE      W#CYYMMDD     W#WORK7N          7 0                        245028
     C                   Z-ADD     W#WORK7N      BAVDTO                                       245028
                                                                                              245028
     C                   ENDIF                                                                245028
                                                                                              245028
      ** If SDBSRT's BAVDNR is backvalued, get previous day rate from                         245028
      ** SDBSHSPD.  This is for new field BACBRT.                                             245028
                                                                                              245028
     C     BAVDNR        IFLE      BAVDRC                                                     245028
     C                   MOVE      BACYCD        WCYCD             3                          245028
     C                   MOVE      BABSRC        WBSRC             2 0                        245028
     C     BAVDNR        SUB       1             WVDNR             5 0                        245028
                                                                                              245028
     C     BSHSKY        SETGT     SDBSHSL1                                                   245028
     C     BSHSK         READPE    SDBSHSL1                               85                  245028
                                                                                              245028
     C     *IN85         IFEQ      '0'                                                        245028
     C                   Z-ADD     G0CBSR        BACBRT                                       245028
     C                   ENDIF                                                                245028
     C                   ENDIF                                                                245028
      *                                                                                       258440
      ** Put the original value date of current rate back.                                    258440
      ** This field should not change during amend.                                           258440
      *                                                                                       258440
     C                   EVAL      BAVDRC = WOBAVDRC                                          258440
      *                                                                                       CAP084
      * Timestamp                                                                             CAP084
     C                   EVAL      BATMST=TimeStamp                                           CAP084
      *
      * UPDATE DEAL
      *
     C                   UPDATE    @BAREDG
      *
      * AMEND THE CORRESPONDING RECORD ON TABLETK
     C                   EXSR      UPDTABL
     C/COPY WNCPYSRC,SDH00522
      *
      * UPDATE SD STANDING DATA CONTROL FILE
     C                   EXSR      UPDCTRL
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* BSRTDLT - DELETE A BASE RATE                                 *
     C*                                                              *
     C****************************************************************
     C     BSRTDLT       BEGSR
      *
      * ACCESS BASE RATE
      *
     C     @KBSRT0       CHAIN     SDBSRTL0                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     BVCYCD        DBKEY
     C                   MOVEL     'SDBSRTPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      * DELETE BASE RATE
      *
     C                   DELETE    @BAREDG
      *
      * WRITE DELETED RECORD IN STANDING DATA DELETED FILE
     C                   EXSR      WRTDLRC
      *
      * DELETE THE CORRESPONDING RECORD ON TABLETK
     C                   MOVEL     SDVBSRT       BaseRate
     C                   EXSR      UPDTABL
     C/COPY WNCPYSRC,SDH00523
      *
      * UPDATE SD STANDING DATA CONTROL FILE
     C                   EXSR      UPDCTRL
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* WRTDLRC - WRITE DELETED RECORD IN STANDING DATA FILE         *
     C*                                                              *
     C****************************************************************
     C     WRTDLRC       BEGSR
     C**********         MOVEL     *BLANK        WULKEY           50                          CGL029
     C**********         MOVEL     *BLANK        WULKEY           56                   CGL029 CTI006
     C                   MOVEL     *BLANK        WULKEY           50                          CTI006
     C                   MOVEL     SDVBSRT       WUDELR
      * Concat the two part key into one field
     C     BACYCD        CAT(P)    BABSRC        WULKEY
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDBSRTPD'    PAFNME
     C                   MOVEL     WULKEY        PALKEY
     C                   MOVEL     WUDR01        PADR01
     C                   MOVEL     WUDR02        PADR02
     C                   MOVEL     WUDR03        PADR03
     C                   MOVEL     WUDR04        PADR04
     C                   MOVEL     WUDR05        PADR05
     C                   MOVEL     WUDR06        PADR06
     C                   MOVEL     WUDR07        PADR07
     C                   MOVEL     WUDR08        PADR08
     C                   MOVEL     WUDR09        PADR09
     C                   MOVEL     WUDR00        PADR00
     C                   MOVEL     WUDR11        PADR11
     C                   MOVEL     WUDR12        PADR12
     C                   Z-ADD     BJRDNB        PALCD
     C                   MOVEL     'D'           PATYLC
      *
     C                   CALL      'SD0520X'                            90
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC
      *
     C     *IN90         IFEQ      '1'
     C     W0RTN         ORNE      *BLANK
     C                   MOVEL     WULKEY        DBKEY
     C                   MOVEL     'SD0520X'     DBFILE
     C                   MOVEL     '006'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************                        CSD006
     C*                                                              *                        CSD006
     C* MNTMDFF - MAINTAIN MARKET DATA FEED FILES                    *                        CSD006
     C*                                                              *                        CSD006
     C****************************************************************                        CSD006
     C     MNTMDFF       BEGSR                                                                CSD006
                                                                                              CSD006
      * If the Data Feed Request ID is not blank,                                             CSD006
      * write a new record to MDF Rate/Price History file...                                  CSD006
                                                                                              CSD006
     C                   IF        BVDTFR <> *Blank                                           CSD006
     C                   MOVEL     BVDTFR        RHDFRI                                       CSD006
     C                   EVAL      RHDITM = BVCYCD + BVBSRC                                   CSD006
     C                   MOVEL     BVDFTS        RHDFTS                                       CSD006
     C                   MOVEL     BVFOTRANID    RHTREF                                       CSD006
     C                   MOVEL     BJRDNB        RHPRCD                                       CSD006
     C                   MOVEL     BVTLEX        RHTLEX                                       CSD006
     C                   MOVEL     *BLANK        RHAUDT                                       CSD006
     C                   MOVEL     'SDBSRTPD'    RHFILE                                       CSD006
     C                   MOVEL     ChkBSRTFmt    RHBIMG                                       CSD006
     C                   MOVEL     SDVBSRT       RHAIMG                                       CSD006
     C                   WRITE     SDMDFHD0                                                   CSD006
                                                                                              CSD006
      * and if the Tolerance Exceeded flag is on, update the MDF Requests                     CSD006
      * Details and MDF Requested Items files                                                 CSD006
                                                                                              CSD006
     C                   IF          BVTLEX = 'Y'                                             CSD006
     C                   MOVEL     BVDTFR        WKREQI                                       CSD006
     C                   EVAL      WKDITM = BVCYCD + BVBSRC                                   CSD006
     C     KLMDFI        CHAIN     SDMDFIL0                                                   CSD006
     C                   IF        %FOUND(SDMDFIL0)                                           CSD006
     C                   EVAL      MITOLX = 'Y'                                               CSD006
     C                   UPDATE    SDMDFID0                                                   CSD006
     C                                                                                        CSD006
     C     BVDTFR        CHAIN     SDMDFRL0                                                   CSD006
     C                   IF        %FOUND(SDMDFRL0)                                           CSD006
     C                   EVAL      MRTOLX = 'Y'                                               CSD006
     C                   UPDATE    SDMDFRD0                                                   CSD006
     C                   ELSE                                                                 CSD006
     C                   UNLOCK    SDMDFRL0                                                   CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   ELSE                                                                 CSD006
     C                   UNLOCK    SDMDFIL0                                                   CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   ENDIF                                                                CSD006
     C                   ENDSR                                                                CSD006
     C****************************************************************                        CSD006
      /EJECT                                                                                  CSD006
     C****************************************************************
     C*                                                              *
     C* UPDTABL - UPDATE TABLE TABLETK                               *
     C*                                                              *
     C****************************************************************
     C     UPDTABL       BEGSR
      *
      * TABLETK - Base Rate Codes  *
     C                   CALL      'TABLETK'                            90
     C                   PARM      *BLANKS       WQ0001            7
     C                   PARM      BACYCD        WQ0002            3
     C                   PARM      BABSRC        WQ0003            2
     C                   PARM      BACBSR        WQ0004           11 7
     C                   PARM      BAVDRC        WQ0005            5 0
     C                   PARM      BABSRN        WQ0006           30
     C                   PARM      BANBRT        WQ0007           11 7
     C                   PARM      BAVDNR        WQ0008            5 0
     C                   PARM      BABSRS        WQ0009            5
     C                   PARM      BATYLC        WQ0010            1
     C                   PARM      BJRDNB        WQ0011            5 0
      *
     C     *IN90         IFEQ      *ON
     C                   MOVEL     BVCYCD        DBKEY
     C                   MOVEL     'SDBSRTPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     WQ0001        IFNE      *BLANKS
     C                   MOVEL     '*ERTBTK'     ReturnCode
     C                   MOVEL     BVCYCD        DBKEY
     C                   MOVEL     'SDBSRTPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   ENDIF
      *
     C                   ENDSR
     C****************************************************************
     C/COPY WNCPYSRC,SDH00524
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDCTRL - UPDATE STANDING DATA CONTROL FILE                  *
     C*                                                              *
     C****************************************************************
     C     UPDCTRL       BEGSR
      *
     C                   MOVE      *BLANKS       WKFLNM           10
     C                   MOVEL     'SDBSRTPD'    WKFLNM
     C     WKFLNM        CHAIN     @AHREAU                            9899
      *
      * Record not found
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'SDBSRTPD'    DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      * Record locked
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'SDBSRTPD'    DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
     C                   SELECT
      * Input
     C     BVTYLC        WHENEQ    'I'
     C                   EVAL      AHNORC = (AHNORC + 1)
     C                   EVAL      AHNOIN = (AHNOIN + 1)
      *
      * Amend
     C     BVTYLC        WHENEQ    'A'
     C                   EVAL      AHNOAM = (AHNOAM + 1)
      *
      * Delete
     C     BVTYLC        WHENEQ    'D'
     C                   EVAL      AHNORC = (AHNORC - 1)
     C                   EVAL      AHNODL = (AHNODL + 1)
     C                   ENDSL
      *
     C                   UPDATE    @AHREAU
      *
     C                   ENDSR
     C****************************************************************
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
      *                                                                                       CSD012
     C* Override SDBRSHL0                                                                     CSD012
     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD                                          CSD012
     C                   PARM                    CMDLEN                                       CSD012
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    SDVBSRT
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ                                       CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD                                       CSD012
      *
      * Key list to chain base rate file SDBSRTL0
     C     @KBSRT0       KLIST
     C                   KFLD                    BVCYCD
     C                   KFLD                    BVBSRC
                                                                                              245028
      ** Key list to access Base Rate History file                                            245028
                                                                                              245028
     C     BSHSKY        KLIST                                                                245028
     C                   KFLD                    WCYCD                                        245028
     C                   KFLD                    WBSRC                                        245028
     C                   KFLD                    WVDNR                                        245028
                                                                                              245028
     C     BSHSK         KLIST                                                                245028
     C                   KFLD                    WCYCD                                        245028
     C                   KFLD                    WBSRC                                        245028
      *
      ** Key list for accessing Market Data Feed Requested Items Details

     C     KLMDFI        KLIST
     C                   KFLD                    WKREQI           32
     C                   KFLD                    WKDITM           20
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      *
      ** Access switchable features file - Market data feed                                   CSD006
      *                                                                                       CSD006
     C                   CALL      'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
      *                                                                                       CSD006
     C     @RTCD         IFEQ      *BLANKS                                                    CSD006
     C                   MOVE      'Y'           CSD006F           1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVE      'N'           CSD006F                                      CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        (PRtCd <> *BLANKS) and                                     CSC011
     C                             (PRtCd <> '*NRF   ')                                       CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 903                                                CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ENDIF                                                                CSC011

     C/COPY WNCPYSRC,SDH00525
      *
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
     C                   MOVEL     '*ERROR '     ReturnCode
     C                   MOVEL     'SDBSRTUPD'   DBPGM
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
     C****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
**  CPY@
(c) Finastra International Limited 2001
** CMD
OVRDBF FILE(SDBRSHL0) TOFILE(SDBRSHL0) SHARE(*NO)
