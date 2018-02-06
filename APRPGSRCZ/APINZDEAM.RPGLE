     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Initialise deal amendments')                  *
      *****************************************************************
      *                                                               *
      *  Midas - APIs module                                          *
      *                                                               *
      *  APINZDEAM - Switchable features initialisation for deal      *
      *              amendments.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 27Jul98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it. Recompile du to changes in MMDEAMPP.*
      *  CAP004 - APIs phase 3.                                       *
      *                                                               *
      *****************************************************************
 
     FMMDEAMPP  UP   E             DISK
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND
 
     D @MMDL         E DS                  EXTNAME(MMDEAMPP)
     D  @DVSD                 49     56  0
 
     D                 DS
     D  @@DTIN                 1      8  0
     D  @@YYYY                 1      4  0
     D  @@YY                   3      4  0
     D  @@CC                   1      2  0
     D  @@MTH                  5      6  0
     D  @@DAY                  7      8  0
 
      * Parameters
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
 
      * Value Date
     C                   MOVE      @DVSD         @@DTIN
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        HNDVSD
 
      * UPDATE DEAL AMENDMENT
     C                   EXCEPT    MMDEAM
 
      *******************************************************************
      /EJECT
      *******************************************************************
      *
      * ZA0680 - THIS SUBROUTINE CONVERTS YYYYMMDD FORMAT DATE TO
      *          MIDAS DAY NUMBER FORMAT (NO. DAYS FROM 31/12/71)
      *
      *******************************************************************
 
     C     ZA0680        BEGSR
 
      **  CLEAR OUT ANY 'OLD' DATA IN FIELD
     C                   Z-ADD     0             @@MDNO            5 0
 
      **   IF DATE GREATER THAN 31/12/2071 NEED EXTRA PROCESSING
     C     @@YYYY        IFGE      2072
 
      **    MULTIPLY BY NUMBER OF DAYS IN CENTURY (SINCE 1971)
     C     @@CC          SUB       19            @@WK2             2 0
     C     @@WK2         MULT      36524         @@MDNO
 
      **  YEAR 2000 IS A LEAP YEAR MUST ALLOW EXTRA DAY
     C                   ADD       1             @@MDNO
     C                   END
 
     C     @@YYYY        ADD       28            @@WK2
 
     C     @@WK2         DIV       4             @@WK2
     C                   MVR                     @@REM             1 0
 
      **    MULTIPLY BY NUMBER OF DAYS IN FOUR YEAR PERIOD
     C     @@WK2         MULT      1461          @@WK5             5 0
     C                   ADD       @@WK5         @@MDNO
 
      **  CHECK REMAINDER AND MONTH NUMBER
     C     @@REM         IFEQ      0
     C     @@MTH         ANDGT     2
     C                   ADD       1             @@MDNO
     C                   END
 
      **  YEAR NOT LEAP YEAR,  ADD CUMULATIVE DAYS FOR YEAR
     C     @@REM         IFNE      0
     C                   ADD       @YD(@@REM)    @@MDNO
     C                   END
 
      **  ADD MONTHS THIS YEAR
     C                   ADD       @MD(@@MTH)    @@MDNO
 
      **  ADD DAYS THIS MONTH
     C                   ADD       @@DAY         @@MDNO
 
     C     ZA0689        ENDSR
 
      *****************************************************************
 
     OMMDEAMP0  E            MMDEAM
     O                       HNDVSD
 
**  CPY@
(c) Finastra International Limited 2001
** @YD  USED BY SR. ZA0680 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZA0680 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
