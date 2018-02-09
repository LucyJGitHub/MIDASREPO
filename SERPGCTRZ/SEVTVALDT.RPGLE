     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate trade value date')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Validation Module                         *
      *                                                               *
      *  SEVTVALDT - Validate Trade Value Date                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14806A          Date 14Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 230608             Date 01Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 232543             Date 16Mar05               *
      *                 CGL031             Date 05Jul04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 203395             Date 20Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 154772             Date  3Feb99               *
      *                 CAP003  *CREATE    Date 10Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  BUG14806A - Recompile Program due to Decimal Error           *
      *  230608 - LF to open file SECEO. Apply 212282.                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  232543 - Fix for CGL031                                      *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  203395 - Check settlement ccy is not blank before calling    *
      *           HOL_SETC. Otherwise get database error, because     *
      *           DDSETC could be blank at this point. This is        *
      *           feasible as the settlement ccy is on a subsequent   *
      *           screen.                                             *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  154772 - Trades input fails on value date default            *
      *           (ZFWDT used is in TISRVPGM)                         *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     F**SECEO     IF   E           K DISK                                             230608
     FSECEO2    IF   E           K DISK                                               230608
     F                                     RENAME(SEDEVDF:SEDEVDO)
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D  SESETX       E                     EXTFLD(SETX)                                       232543
 
      ** External data structure for currency details.
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      **Second DS for access programs, long data structure.
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
     ISNDEVDF
     I              RECI                        SNDE_RECI
     ISEDEVDO
     I              RECI                        SEDE_RECI
     I              NMCY                        SEDE_NMCY
     I              SETX                        SEDE_SETX                                     CGL035
 
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
      ** Clear output trade fields
 
     C                   Z-ADD     *ZERO         TDVD
      *
      ** DEFAULT if not entered
      *
     C     Default       IFEQ      'Y'
     C     DDTDVD        ANDEQ     *BLANKS
     C                   EXSR      TDVDD
      *
      ** Determine value date in screen format
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      TDVD          ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZDATE         DDTDVD
 
     C                   ENDIF
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      TDVDV
     C                   ENDIF
      *
      ** If no errors, determine coupon rate and current factor
      *
     C     DDTDVDOK      IFNE      'N'
     C                   EXSR      DETCRCF
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDTDVDOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     TDVDV         BEGSR
      *
      **  It must be a valid date
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDTDVD        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
     C                   END
 
      * If either ZALIGN and ZDATE1 errors
 
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   MOVE      'N'           DDTdvdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTDVD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0485'     MsgIdXAr(Idx)
     C                   GOTO      ETDVDV
     C                   END
      *
      * Update trade value date
      *
     C                   Z-ADD     ZDAYNO        TDVD
      *                                                                                       CAP067
      ** If transaction comes from buy-sell back API and is the first leg,                    CAP067
      ** store trade value date                                                               CAP067
      *                                                                                       CAP067
     C     PFBYSL        IFEQ      'Y'                                                        CAP067
     C                   MOVEL     TDVD          PFTDVD                                       CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
      ** If transaction comes from buy-sell back API and is the second leg,                   CAP067
      ** value date should not be the same as the first leg's value date                      CAP067
      *                                                                                       CAP067
     C     PFBYSL        IFEQ      'N'                                                        CAP067
     C     PFTDVD        ANDEQ     TDVD                                                       CAP067
     C                   MOVEL     'N'           ddTDVDok                                     CAP067
     C                   ADD       1             Idx                                          CAP067
     C                   MOVEL     'DDTDVD'      FldNamXAr(Idx)                               CAP067
     C                   MOVEL     'MMA1220'     MsgIdXAr(Idx)                                CAP067
     C                   ENDIF                                                                CAP067
      *
      **   It must not be after maturity date or
      **   or before issue date of the security
      *
     C     MATY          IFNE      *ZEROS
     C     TDVD          ANDGT     MATY
     C     TDVD          ORLT      ISSD
     C                   MOVE      'N'           DDTdvdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTDVD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0486'     MsgIdXAr(Idx)
     C                   END
      *
      **  It must fall within the back value period
      *
     C     TDVD          IFLT      BckValDte
     C                   MOVE      'N'           DDTdvdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTDVD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0487'     MsgIdXAr(Idx)
     C                   END
      *
      **  If security is partly paid, it must not
      **  be before the most recent call date
      *
     C     PPDI          IFEQ      'Y'
     C     TDVD          ANDLT     SLCA
     C                   MOVE      'N'           DDTdvdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTDVD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0487'     MsgIdXAr(Idx)
     C                   END
      *
      **   If Clearance Type '1' or '2', must not be
      **   holiday in Euroclear currency
      *
     C     DDCLTY        IFEQ      '1'
     C     DDCLTY        OREQ      '2'
 
     C                   EXSR      HOL_EUCY
 
     C     ZIND          IFEQ      'H'
     C     DDTdvdOK      IFNE      'N'
     C                   MOVE      'W'           DDTdvdOK
     C                   END
     C                   ADD       1             WIx
     C                   MOVEL     'DDTDVD'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0488'     WMsgIdXAr(WIx)
     C                   END
     C                   END
      *
      **   If Clearance Type '3' or '4', must not be
      **   holiday in Cedel currency
      *
     C     DDCLTY        IFEQ      '3'
     C     DDCLTY        OREQ      '4'
 
     C                   EXSR      HOL_CCCY
 
     C     ZIND          IFEQ      'H'
     C     DDTdvdOK      IFNE      'N'
     C                   MOVE      'W'           DDTdvdOK
     C                   END
     C                   ADD       1             WIx
     C                   MOVEL     'DDTDVD'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0489'     WMsgIdXAr(WIx)
     C                   END
     C                   END
      *
      **   If Clearance Type '2','4' or '5', must not
      **   be holiday in settlement currency
      *
     C     DDCLTY        IFEQ      '2'
     C     DDCLTY        OREQ      '4'
     C     DDCLTY        OREQ      '5'
 
     C                   EXSR      CHKSETC
 
     C     SETC_OK       IFNE      'N'
     C                   EXSR      HOL_SETC
 
     C     ZIND          IFEQ      'H'
     C     DDTdvdOK      IFNE      'N'
     C                   MOVE      'W'           DDTdvdOK
     C                   END
     C                   ADD       1             WIx
     C                   MOVEL     'DDTDVD'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0490'     WMsgIdXAr(WIx)
     C                   END
     C                   END
     C                   END
      *
      **   Must not be a holiday in value currency
      *
     C                   EXSR      HOL_VLCY
 
     C     ZIND          IFEQ      'H'
     C     DDTdvdOK      IFNE      'N'
     C                   MOVE      'W'           DDTdvdOK
     C                   END
     C                   ADD       1             WIx
     C                   MOVEL     'DDTDVD'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0491'     WMsgIdXAr(WIx)
     C                   END
 
     C     ETDVDV        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** DEFAULT
      *****************************************************************
     C     TDVDD         BEGSR
      *
      *  Split value date default into days and basis
      *
     C                   MOVEL     VDFT          ValDteDys         2 0
     C                   MOVE      VDFT          ValDteBas         1
      *
      *  If the Default number of days is 'Working Days', then call
      *  ZFWDT  to calculate the Default Value Date. Else default is
      *  actual days, so add the number of days to the Run Date.
      *
     C     ValDteBas     IFEQ      'W'
     C                   CALLB     'ZFWDT'
     C                   PARM      BJRDNB        ZDAYNO
     C*******************PARM      NMCY          ZCCY                           154772
     C*******************PARM      *BLANKS       ZLOC                           154772
     C                   PARM      ValDteDys     ZNRDYS            2 0
     C                   PARM      *ZERO         ZDYNBR            5 0
     C                   PARM      NMCY          ZCCY                           154772
     C                   PARM      *BLANKS       ZLOC                           154772
     C                   Z-ADD     ZDYNBR        TDVD
     C                   ELSE
     C     BJRDNB        ADD       ValDteDys     TDVD
     C                   END
      *
      *  It must not be before the issue date of the security
      *
     C     TDVD          IFLT      ISSD
     C                   Z-ADD     ISSD          TDVD
     C                   END
      *
      *  If the security is partly paid, it must not be
      *  before the most recent call date
      *
     C     PPDI          IFEQ      'Y'
     C     TDVD          ANDLT     SLCA
     C                   Z-ADD     SLCA          TDVD
     C                   END
      *
      *  Bypass if date is not based on working days
      *
     C     ValDteBas     IFNE      'W'
     C                   GOTO      ETDVDD
     C                   END
      *
      * Do while date is not a holiday in one of the currencies involved
      *
     C                   MOVEL     'H'           ZIND
     C     ZIND          DOWEQ     'H'
      *
      * Value date can't be greater than maturity date
      *
     C     MATY          IFGT      *ZEROS
     C     TDVD          ANDGT     MATY
     C                   MOVEL     *BLANK        ZIND
     C                   Z-ADD     MATY          TDVD
     C                   ELSE
      *
      **   If Clearance Type '1' or '2', must not be
      **   holiday in Euroclear currency
      *
     C     DDCLTY        IFEQ      '1'
     C     DDCLTY        OREQ      '2'
     C*
     C                   EXSR      HOL_EUCY
     C*
     C     ZIND          IFEQ      'H'
     C                   ADD       1             TDVD
     C                   END
     C*
     C**   If Clearance Type '3' or '4', must not be
     C**   holiday in Cedel currency
     C*
     C                   ELSE
     C     DDCLTY        IFEQ      '3'
     C     DDCLTY        OREQ      '4'
     C*
     C                   EXSR      HOL_CCCY
     C*
     C     ZIND          IFEQ      'H'
     C                   ADD       1             TDVD
     C                   END
     C*
     C**   If Clearance Type '2','4' or '5', must not
     C**   be holiday in settlement currency
     C*
     C                   ELSE
     C     DDCLTY        IFEQ      '2'
     C     DDCLTY        OREQ      '4'
     C     DDCLTY        OREQ      '5'
      *                                                                                       203395
      ** If the settlement currency is blank set ZIND to 'W' and do                           203395
      ** not execute subroutine HOL_SETC since it will fail.                                  203395
      *                                                                                       203395
     C     DDSETC        IFEQ      *BLANKS                                                    203395
     C                   MOVE      'W'           ZIND                                         203395
     C                   ELSE                                                                 203395
     C*
     C                   EXSR      HOL_SETC
     C*
     C     ZIND          IFEQ      'H'
     C                   ADD       1             TDVD
     C                   END
     C                   ENDIF                                                                203395
     C*
     C**   Must not be a holiday in value currency
     C*
     C                   ELSE
 
     C                   EXSR      HOL_VLCY
 
     C     ZIND          IFEQ      'H'
     C                   ADD       1             TDVD
     C                   END
 
     C                   END
     C                   END
     C                   END
     C                   END
     C                   ENDDO
 
     C     ETDVDD        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** HOL_EUCY - Check for holiday in Euroclear currency
      *****************************************************************
     C     HOL_EUCY      BEGSR
     C                   CALLB     'ZCHKH'
     C                   PARM      TDVD          ZDAYNO
     C                   PARM      BVEUCY        ZCCY              3
     C                   PARM      *BLANK        ZLOC              3
     C                   PARM                    ZIND              1
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** HOL_CCCY - Check for holiday in Cedel currency
      *****************************************************************
     C     HOL_CCCY      BEGSR
     C                   CALLB     'ZCHKH'
     C                   PARM      TDVD          ZDAYNO
     C                   PARM      BVCCCY        ZCCY
     C                   PARM      *BLANK        ZLOC
     C                   PARM                    ZIND
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** HOL_SETC - Check for holiday in settlement currency
      *****************************************************************
     C     HOL_SETC      BEGSR
     C                   CALLB     'ZCHKH'
     C                   PARM      TDVD          ZDAYNO
     C                   PARM      DDSETC        ZCCY
     C                   PARM      *BLANK        ZLOC
     C                   PARM                    ZIND
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** HOL_VLCY - Check for holiday in value currency
      *****************************************************************
     C     HOL_VLCY      BEGSR
     C*
     C** If S01509 is active, must not be a holiday in nominal currency
     C** otherwise, must not be a holiday in value currency
     C*
     C     S01509        IFEQ      'Y'
     C                   MOVE      NMCY          ZCCY
     C                   ELSE
     C                   MOVE      VLCY          ZCCY
     C                   END
     C*
     C                   CALLB     'ZCHKH'
     C                   PARM      TDVD          ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM      *BLANK        ZLOC
     C                   PARM                    ZIND
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** CHKSETC - Check settlement currency is OK
      *****************************************************************
     C     CHKSETC       BEGSR
 
      * Get settlement currency details
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDSETC        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           SETC_OK           1
     C                   ELSE
     C                   MOVEL     'N'           SETC_OK           1
     C                   END
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** DETERMINE COUPON RATE AND CURRENT FACTOR
      *****************************************************************
     C     DETCRCF       BEGSR
      *
      * Coupon rate
      *
     C                   MOVE      SESN          SDSN
     C                   MOVE      'IR'          SDET
     C                   Z-ADD     TDVD          SDED
     C     KLEVD         SETLL     SEDEVDO
     C                   READ      SEDEVDO                                44
     C     *IN44         IFEQ      '0'
     C     SDSN          ANDEQ     SESN
     C     SDET          ANDEQ     'IR'
     C                   Z-ADD     SDNC          TDCR
     C                   ELSE
     C                   Z-ADD     CPNR          TDCR
     C                   END
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      TDCR          ZFLD15
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      7             ZDECS             1 0
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
 
     C                   MOVE      ZOUT21        DDCPNR
      *
      * Current Factor
      *
     C     PROT          IFEQ      '8'
     C                   MOVE      SESN          SDSN
     C                   MOVE      'MP'          SDET
     C                   Z-ADD     TDVD          SDED
     C     KLEVD         SETLL     SEDEVDO
     C                   READ      SEDEVDO                                44
     C     *IN44         IFEQ      '0'
     C     SDSN          ANDEQ     SESN
     C     SDET          ANDEQ     'MP'
     C                   Z-ADD     SDCP          TCFC
     C                   ELSE
     C                   Z-ADD     CFCT          TCFC
     C                   END
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      TCFC          ZFLD15
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      9             ZDECS             1 0
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
 
     C                   MOVE      ZOUT21        DDCFCT
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDTDVD            7
     C                   PARM                    DDCLTY            1
     C                   PARM                    DDSETC            3
      *
      ** Security Details
      *
     C                   PARM                    SECTY
     C                   PARM                    PROT              1
      *
      ** ICD
     C                   PARM                    S01509            1
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    BVBVP             3 0
     C                   PARM                    BVEUCY            3
     C                   PARM                    BVCCCY            3
      *                                                                                       CAP067
      ** First Buy-sell back indicator                                                        CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      ** First Buy-sell trade type                                                            CAP067
     C                   PARM                    PFTDVD            5 0                        CAP067
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Trade Value Date - OK
     C                   PARM                    DDTDVDOK          1
      *
      ** Trade Value Date
     C                   PARM                    TDVD              5 0
      *
      ** Trade Coupon Rate
      ** Trade Current Factor
     C                   PARM                    TDCR             11 7
     C                   PARM                    TCFC             10 9
 
      ** Trade Coupon Rate    - screen format
      ** Trade Current Factor - screen format
     C                   PARM                    DDCPNR           13
     C                   PARM                    DDCFCT           12
      *
      *  Calculate the back value date
      *
     C     BJRDNB        SUB       BVBVP         BckValDte         5 0
      *
      * Define key list for SECEO (SEDEVDO) Security Diary Events.
      *
     C     KLEVD         KLIST
     C                   KFLD                    SDSN
     C                   KFLD                    SDET
     C                   KFLD                    SDED
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
