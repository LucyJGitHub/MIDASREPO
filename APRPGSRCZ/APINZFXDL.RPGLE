     H
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Initialise FX deals')                         *
      *****************************************************************
      *                                                               *
      *  Midas - APIs module                                          *
      *                                                               *
      *  APINZFXDL - Switchable features initialisation for FX deals  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      *  Prev Amend No. CSW212             Date 03May12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 161999             Date 07Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 27Jul98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it. Recompile du to changes in FXDEALPP.*
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CDL008 - Continuous Linked Settlement (Recompiled FXDEALPP)  *
      *  161999 - Errors in API initialization function               *
      *           (Decimal data error in APINZFXDL with invalid fields)
      *  CAP004 - APIs phase 3.                                       *
      *                                                               *
      *****************************************************************
 
     FFXDEALPP  UP   E             DISK
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND
 
     D @FXDL         E DS                  EXTNAME(FXDEALPP)
     D  @VDDN                 30     37  0
     D  @OTDN                 46     53  0
     D  @DDDN                161    168  0
     D  FHMGPTA             1042   1045                                         161999
     D                 DS
     D  @@DTIN                 1      8  0
     D  @@YYYY                 1      4  0
     D  @@YY                   3      4  0
     D  @@CC                   1      2  0
     D  @@MTH                  5      6  0
     D  @@DAY                  7      8  0
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      * PARAMETERS
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
 
      * RESET UNUSED FIELDS  (only if S01453 is off)
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01453'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANK
     C     FHMGPTA       OREQ      '    '                                       161999
     C                   Z-ADD     *ZERO         FHMGPT
     C                   Z-ADD     *ZERO         FHMGAM
     C                   Z-ADD     *ZERO         FHOSRT
     C                   Z-ADD     *ZERO         FHBFPA
     C                   Z-ADD     *ZERO         FHSFPA
     C                   Z-ADD     *ZERO         FHBDBS
     C                   Z-ADD     *ZERO         FHSDBS
     C                   Z-ADD     *ZERO         FHSDBE
     C                   Z-ADD     *ZERO         FHBDBF
     C                   Z-ADD     *ZERO         FHSDBF
     C                   Z-ADD     *ZERO         FHBDFA
     C                   Z-ADD     *ZERO         FHSDFA
     C                   ENDIF
 
      * Deal Date
     C                   MOVE      @DDDN         @@DTIN
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        FHDDDN
 
      * Value Date
     C                   MOVE      @VDDN         @@DTIN
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        FHVDDN
 
      * Option End Date
     C     @OTDN         IFNE      *ZERO
     C                   MOVE      @OTDN         @@DTIN
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        FHOTDN
     C                   ELSE
     C                   Z-ADD     *ZERO         FHOTDN
     C                   END
 
      * UPDATE DEAL
     C                   EXCEPT    FXDEAL
 
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
 
     OFXDEALP0  E            FXDEAL
     O                       FHMGPT
     O                       FHMGAM
     O                       FHOSRT
     O                       FHBFPA
     O                       FHSFPA
     O                       FHBDBS
     O                       FHSDBS
     O                       FHSDBE
     O                       FHBDBF
     O                       FHSDBF
     O                       FHBDFA
     O                       FHSDFA
     O                       FHDDDN
     O                       FHVDDN
     O                       FHOTDN
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @YD  USED BY SR. ZA0680 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZA0680 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
