     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate trade ex dividend')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTEXDIV - Validate Trade ex dividend                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGP001             Date 11Sep03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08MAR99               *
      *                 CAP003  *CREATE    Date 23Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGP001 - Global Processing. Field name clash.                *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
     D CDArr                 183    230
 
 
      ** Event details
     D FDDIV1        E DS                  EXTNAME(SEDEVD)
     D  SED_RECI     E                     EXTFLD(RECI)
     D  SED_ZZ005    E                     EXTFLD(ZZ005)
     D  SED_NMCY     E                     EXTFLD(NMCY)
     D  SED_LCD      E                     EXTFLD(LCD)
     D  SED_CHTP     E                     EXTFLD(CHTP)
     D  SED_TNLU     E                     EXTFLD(TNLU)
     D  SED_FRNT     E                     EXTFLD(FRNT)                                       CSD006
     D  SED_REPA     E                     EXTFLD(REPA)                                       CSD006
     D  SED_TMST     E                     EXTFLD(TMST)                                       CSD006
     D  SED_SEZONE   E                     EXTFLD(SEZONE)                                     CGP001
     D  SED_SETX     E                     EXTFLD(SETX)                                       CGL031
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input Fields
      ** ------------
 
      ** Screen fields
      * Ex-Dividend indicator
 
     D DDEXDV          S              1A
 
      ** System Info
      * Event Control Date
      * S01510 SAR indicator
      * Date Format
 
     D S01510          S              1A
     D BJDFIN          S              1A
 
      ** Output
      ** ------
 
     D DDEXDVOK        S              1A
     D EXDV            S              1A
 
      ** Working Variables
      ** -----------------
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D ZNRDYS          S              2P 0
     D ZDAYNO          S              5P 0
     D ZDYNBR          S              5P 0
     D ZCCY            S              3A
     D ZLOC            S              3A
     D WEDFT           S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** Rename fields from Diary events file to avoid conflict with SECTYD
      *
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      ** Clear output trade fields
 
     C                   MOVE      *BLANKS       EXDV
      *
      ** Perform Defaulting
      *
     C     Default       IFEQ      'Y'
     C     DDEXDV        ANDEQ     *BLANKS
     C                   EXSR      EXDVD
     C                   END
      *
      ** Perform Validation
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      EXDVV
     C                   END
      *
      ** Set Return Code
      *
     C     DDEXDVok      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * EXDVD - Ex-Dividend indicator defaulting                      *
      *                                                               *
      *****************************************************************
     C     EXDVD         BEGSR
 
     C                   MOVE      'C'           DDEXDV
      *
      **  Calculate Next Dividend Date using ZNDD.
      *
     C     NDVD          IFEQ      *ZEROS
     C     S01510        OREQ      'Y'
 
     C                   CALLB     'ZNDD'
     C                   PARM                    SECTY
     C                   PARM      TDVD          ECD               5 0
     C                   PARM                    BJDFIN
     C                   PARM                    NDD               5 0
     C                   PARM                    EventPre          1
     C                   PARM                    FDDIV1
 
     C                   Z-ADD     NDD           NDVD
     C                   END
      *
     C     NDVD          IFEQ      *ZEROS
     C                   MOVE      'C'           DDEXDV
     C                   ELSE
      *
     C                   SELECT
     C     S01510        WHENEQ    'Y'
     C                   Z-ADD     0             ZDYNBR
      *
      ** If diary event found, use ex-date from it.
      *
     C     EventPre      IFEQ      'Y'
     C                   Z-ADD     SDXD          ZDYNBR
     C                   ELSE
      *
      ** Otherwise, calculate ex-date using default days from security.
      *
     C                   MOVEL     EDFT          ZNRDYS
 
     C     ZNRDYS        IFNE      *ZEROS
     C                   MOVE      EDFT          WEDFT
 
     C     WEDFT         IFEQ      'W'
      *
      **   .. if working days
      *
     C                   Z-ADD     NDVD          ZDAYNO
     C                   MOVE      VLCY          ZCCY
     C                   MOVE      *BLANKS       ZLOC
 
     C                   CALLB     'ZBKDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZNRDYS
     C                   PARM                    ZDYNBR
 
     C                   ELSE
      *
      **   .. if actual days
      *
     C     NDVD          SUB       ZNRDYS        ZDYNBR
     C                   END
     C                   END
     C                   END
 
     C     TDDT          IFLT      NDVD
     C     TDDT          ANDGE     ZDYNBR
     C     ZDYNBR        ANDNE     0
     C                   MOVE      'X'           DDEXDV
     C                   END
 
     C     S01510        WHENEQ    'N'
     C                   MOVEL     EDFT          ZNRDYS
     C     ZNRDYS        IFNE      *ZEROS
     C                   MOVE      EDFT          WEDFT
     C     WEDFT         IFEQ      'W'
      *
      **   .. if working days
      *
     C                   Z-ADD     NDVD          ZDAYNO
     C                   MOVE      NMCY          ZCCY
     C                   MOVE      *BLANKS       ZLOC
 
     C                   CALLB     'ZBKDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZNRDYS
     C                   PARM                    ZDYNBR
 
     C                   ELSE
      *
      **   .. if actual days
      *
     C     NDVD          SUB       ZNRDYS        ZDYNBR
     C                   END
 
     C     TDDT          IFLT      NDVD
     C     TDDT          ANDGE     ZDYNBR
     C                   MOVE      'X'           DDEXDV
     C                   END
 
     C                   END
     C                   ENDSL
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * EXDVV - Ex-Dividend indicator validation                      *
      *                                                               *
      *****************************************************************
     C     EXDVV         BEGSR
      *
      ** Ex dividend ind. must be 'cum' or 'ex'
      *
     C     DDEXDV        IFNE      'C'
     C     DDEXDV        ANDNE     'X'
     C                   MOVE      'N'           DDEXDVOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDEXDV'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0522'     MsgidXAr(Idx)
     C                   ELSE
      *
      ** Update Trade
      *
     C                   MOVE      DDEXDV        EXDV
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
 
      ** Screen fields
      ** -------------
      * Ex-Dividend Indicator (1A)
     C                   PARM                    DDEXDV
 
      ** Trade Details
      ** -------------
      * Value Date (5P 0)
      * Trade Date (5P 0)
     C                   PARM                    TDVD              5 0
     C                   PARM                    TDDT              5 0
 
      ** Security Details
      ** ----------------
     C                   PARM                    SECTY
 
      ** System Info
      ** -----------
      * S01510 indicator
      * Date Format (1A)
     C                   PARM                    S01510
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Ex-Dividend Ok indicator (1A)
      ** Ex-Dividend indicator  (1A)
 
     C                   PARM                    DDEXDVOK
     C                   PARM                    EXDV
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
