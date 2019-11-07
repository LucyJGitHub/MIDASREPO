     H
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Initialise loans/deposits')                   *
      *****************************************************************
      *                                                               *
      *  Midas - APIs module                                          *
      *                                                               *
      *  APINZFSDL - Switchable features initialisation for FX deals  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 207875             Date 13Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 161999             Date 07Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 27Jul98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it. Recompile du to changes in MMLDNIPP.*
      *  207875 - Numeric fields introduced by CDL006, CDL007, CGL011 *
      *           and SC145001 are not being initialised to zero.     *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  161999 - Errors in API initialization function               *
      *           (HKRACD not initialized on MMDELDPP in APINZLDNI)   *
      *  CAP004 - APIs phase 3.                                       *
      *                                                               *
      *****************************************************************

     FMMDELDPP  UP   E             DISK
     FBKRAT     IF   E           K DISK                                         161999

     D/COPY ZACPYSRC,STD_D_SPEC

     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND

     D @MMDL         E DS                  EXTNAME(MMDELDPP)
     D  @DVSD                 50     57  0
     D  @DDND                111    118  0
     D  @SLID                179    186  0
     D  @NIPD                205    212  0
     D  @MATD                252    259  0

     D                 DS
     D  @@DTIN                 1      8  0
     D  @@YYYY                 1      4  0
     D  @@YY                   3      4  0
     D  @@CC                   1      2  0
     D  @@MTH                  5      6  0
     D  @@DAY                  7      8  0

      * PARAMETERS
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode

      * Deal Date
     C                   MOVE      @DDND         @@DTIN
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        HKDDND

      * Value Date
     C                   MOVE      @DVSD         @@DTIN
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        HKDVSD

      * Next Int Date
     C     @NIPD         IFNE      *ZERO
     C                   MOVE      @NIPD         @@DTIN
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        HKNIPD
     C                   ELSE
     C                   Z-ADD     *ZERO         HKNIPD
     C                   END

      * Last Int Date
     C     @SLID         IFNE      *ZERO
     C                   MOVE      @SLID         @@DTIN
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        HKSLID
     C                   ELSE
     C                   Z-ADD     *ZERO         HKSLID
     C                   END

      * Maturity Date
     C     @MATD         IFNE      *ZERO
     C                   MOVE      @MATD         @@DTIN
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        HKMATD
     C                   ELSE
     C                   Z-ADD     *ZERO         HKMATD
     C                   END
      *                                                                         161999
      * Check if broker rate/amount indicator is present                        161999
      *                                                                         161999
     C     HKDN38        CHAIN     BKRAT                              99        161999
     C  N99              MOVE      RACD          HKRACD                         161999

      * Initialise Original Rollover Amount                                                   207875
                                                                                              207875
     C                   EVAL      HKORDA = 0                                                 207875
                                                                                              207875
      * Initialise Fiduciary Charge Amount                                                    207875
                                                                                              207875
     C                   EVAL      HKFCGA = 0                                                 207875
                                                                                              207875
      * Initialise Fiduciary Tax On Charge Amount                                             207875
                                                                                              207875
     C                   EVAL      HKFCGT = 0                                                 207875
                                                                                              207875
      * Initialise Fiduciary Commission Amount                                                207875
                                                                                              207875
     C                   EVAL      HKFCMA = 0                                                 207875
                                                                                              207875
      * Initialise Fiduciary Tax On Commission Amount                                         207875
                                                                                              207875
     C                   EVAL      HKFCMT = 0                                                 207875
                                                                                              207875
      * Initialise Original Maturity Date                                                     207875
                                                                                              207875
     C                   EVAL      HKOMDT = 0                                                 207875
                                                                                              207875
      * Initialise Penalty Charged                                                            207875
                                                                                              207875
     C                   EVAL      HKPENA = 0                                                 207875
                                                                                              207875
      * Initialise Collateral Amount                                                          207875
                                                                                              207875
     C                   EVAL      HKCOLA = 0                                                 207875
                                                                                              207875
      * If Front Office Id is blank then initialise with deal number                          207875
                                                                                              207875
     C     HKFRNT        IFEQ      *BLANK                                                     207875
     C                   MOVEL     HKDN38        HKFRNT                                       207875
     C                   ENDIF                                                                207875
                                                                                              207875
      * UPDATE DEAL
     C                   EXCEPT    MMDELD

     C*******************************************************************
     C/EJECT
     C*******************************************************************
     C*
     C* ZA0680 - THIS SUBROUTINE CONVERTS YYYYMMDD FORMAT DATE TO
     C*          MIDAS DAY NUMBER FORMAT (NO. DAYS FROM 31/12/71)
     C*
     C*******************************************************************

     C     ZA0680        BEGSR
     C*
     C**  CLEAR OUT ANY 'OLD' DATA IN FIELD
     C                   Z-ADD     0             @@MDNO            5 0
     C*
     C**   IF DATE GREATER THAN 31/12/2071 NEED EXTRA PROCESSING
     C     @@YYYY        IFGE      2072
     C*
     C**    MULTIPLY BY NUMBER OF DAYS IN CENTURY (SINCE 1971)
     C     @@CC          SUB       19            @@WK2             2 0
     C     @@WK2         MULT      36524         @@MDNO
     C*
     C**  YEAR 2000 IS A LEAP YEAR MUST ALLOW EXTRA DAY
     C                   ADD       1             @@MDNO
     C                   END
     C*
     C     @@YYYY        ADD       28            @@WK2
     C*
     C     @@WK2         DIV       4             @@WK2
     C                   MVR                     @@REM             1 0
     C*
     C**    MULTIPLY BY NUMBER OF DAYS IN FOUR YEAR PERIOD
     C     @@WK2         MULT      1461          @@WK5             5 0
     C                   ADD       @@WK5         @@MDNO
     C*
     C**  CHECK REMAINDER AND MONTH NUMBER
     C     @@REM         IFEQ      0
     C     @@MTH         ANDGT     2
     C                   ADD       1             @@MDNO
     C                   END
     C*
     C**  YEAR NOT LEAP YEAR,  ADD CUMULATIVE DAYS FOR YEAR
     C     @@REM         IFNE      0
     C                   ADD       @YD(@@REM)    @@MDNO
     C                   END
     C*
     C**  ADD MONTHS THIS YEAR
     C                   ADD       @MD(@@MTH)    @@MDNO
     C*
     C**  ADD DAYS THIS MONTH
     C                   ADD       @@DAY         @@MDNO
     C*
     C     ZA0689        ENDSR

     C*****************************************************************

     OMMDELDP0  E            MMDELD
     O                       HKDVSD
     O                       HKDDND
     O                       HKNIPD
     O                       HKSLID
     O                       HKMATD
     O                       HKRACD                                             161999
     O                       HKFRNT                                                           207875
     O                       HKORDA                                                           207875
     O                       HKFCGA                                                           207875
     O                       HKFCGT                                                           207875
     O                       HKFCMA                                                           207875
     O                       HKFCMT                                                           207875
     O                       HKOMDT                                                           207875
     O                       HKPENA                                                           207875
     O                       HKCOLA                                                           207875

**  CPY@
(c) Finastra International Limited 2001
** @YD  USED BY SR. ZA0680 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZA0680 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
