     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate next interest date             ')
      *****************************************************************
      *                                                               *
      *  Midas - Standard routines                                    *
      *                                                               *
      *  MMVNABNIDT - Validate next interest date for NAs purchased   *
      *                                                               *
      *  Function:  This module validates the next interest date      *
      *             field for NAs purchased                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP002  *CREATE    Date 18Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters
      ** ==========
 
      ** Message ID
     D MsgID1          S                   LIKE(#MsgID)
 
      ** Warning ID
     D WMsgID1         S                   LIKE(#MsgID)
 
      ** Deal type
     D DDMTYP          S              2A
 
      ** Deal value date in Midas day number format
     D @VDYNO          S              5P 0
 
      ** Local Currency code (3A, from SDBANKPD via caller)
     D BJLCCY          S              3A
 
      ** Deal currency (3A, from transaction)
     D DDCCY           S                   LIKE(BJLCCY)
 
      ** Receive - settlement currency (3A, from caller)
     D PMRSCY          S              3A
 
      ** Receive - settlement method (2,0S, from caller)
     D PMRSTM          S              2S 0
 
     ** Start/Last Int date OK ***
     D DdslidOK        S              1A
 
     ** Value date field OK
     D ValDateOK       S              1A
 
     ** Maturity date in Midas day number format (5,0P, from caller)
     D @MDYNO          S                   LIKE(@VDYNO)
 
     ** Maturity date field OK
     D MatDateOK       S              1A
 
      ** System Location Code from SDBANKPD received as paramater
     D BJSLCD          S              3A
 
      ** Receive Nostro Location Code received as paramater
     D RLOC            S              3A
 
     ** Int Rate OK ***
     D DDINTROK        S              1A
 
     ** Next Int Date **
     D DDNDAT          S              6A
 
     ** Int Rate      **
     D DDINTR          S             12A
 
     ** Next Int Payment Date **
     D IHNIPD          S              5  0
 
 
      ** End of parameters
      ** =================
 
      ** Beginning of interest period
     D ZZBEG           S                   LIKE(@VDYNO)
 
      ** End of interest period
     D ZZEND           S                   LIKE(@VDYNO)
 
      ** Interest work field
     D @@INTR          S             15P 0
 
      ** Alpha field for numeric validation
     D @@ALPH          S             16A
 
      ** Number of integers in amount
     D @@IINT          S              3P 0
 
      ** Millions/Thousands id (Y=function on)
     D @@MTID          S              1A
 
      ** Error code for ZA0840
     D @@ERCD          S              1P 0
 
      ** Amount after numeric checking
     D @@AMT           S             15P 0
 
      ** Difference between input and calculated rate
     D @DIFI           S             15P 0
 
      ** 13,0P amount field for passing into ZA0920
     D Amount13        S             13P 0
 
      ** Packed version of number of decimal places for passing into ZA0920
     D NbrDecPl1       S              1P 0
 
      ** Packed version of number of decimal places for passing into ZA0840
     D NbrDecPl3       S              3P 0
 
      ** Formatted amount returned from ZA0920
     D AmountOut       S             14A
 
     D  ZDAYNO         S              5P 0
     D  ZCCY           S              3
     D  ZLOC           S              3
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
 
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound
     C                   RESET                   MSGID1
     C                   RESET                   WMSGID1
      *
      * Effective settlement currency
      *
     C     PMRSCY        IFNE      *BLANKS
     C                   MOVEL     PMRSCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     DDCCY         EffSetCcy         3
     C                   ENDIF
 
      *  *-----------------------------*
      *  * Validate Next Interest Date *
      *  *-----------------------------*
      *
      **  Only validate if the date is not blank.
      *
     C     DDNDAT        IFNE      *BLANKS
      *
      **  Validate that the date is valid as a date.
     C                   TESTN                   DDNDAT               6263
     C                   MOVE      DDNDAT        @TEST             1
     C                   TESTZ                   @TEST                    73
     C     *IN62         IFEQ      '1'
     C     *IN73         ANDEQ     '1'
     C     *IN63         OREQ      '1'
     C     *IN73         ANDEQ     '1'
     C                   MOVE      DDNDAT        @DAT
     C                   CALLB     'ZA0270'
      *                  ~~~~~~~~~~~~~~~~~
     C                   PARM                    @DAT              6 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    @RTCDE            1
     C                   PARM                    @NDYNO            5 0
     C                   END
      *
      **  If not, it is an error.
     C     *IN62         IFEQ      '0'
     C     *IN63         ANDEQ     '0'
     C     *IN73         OREQ      '0'
     C     @RTCDE        OREQ      '1'
     C                   MOVEL     'MMM0438'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
      *
      **  If the interest rate is blank then the next interest date
      **  should be blank.
     C                   ELSE
     C     DDINTR        IFEQ      *BLANKS
     C     DdintrOK      ANDNE     'N'
     C     DDNDAT        ANDEQ     *BLANKS                                      ??
     C                   MOVEL     'MMM0439'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
      *
      **  Check that the next interest date is after the value date.
      **  (If the value date has been entered and is valid.)
     C     @VDYNO        IFNE      *ZERO
     C     ValDateOK     ANDNE     'N'
     C     @NDYNO        ANDLE     @VDYNO
     C                   MOVEL     'MMM0440'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
      *
      **  Check that the next interest date is after the maturity date.
      **  (If the maturity date has been entered and is valid.)
     C     @MDYNO        IFNE      *ZERO
     C     MatDateOK     ANDNE     'N'
     C     @NDYNO        ANDGE     @MDYNO
     C                   MOVEL     'MMM0441'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
      *
      **  If the deal type is non-blank.
      *
     C     DDMTYP        IFNE      *BLANKS
      *
      **  For settlement THROUGH a NOSTRO, using nostro location
      **  Find whether the date is a holiday in the deal currency.
     C     PMRSTM        IFEQ      1
     C     PMRSTM        OREQ      7
     C     PMRSTM        OREQ      8
     C                   MOVE      RLOC          ZLOC
     C                   MOVE      EffSetCcy     ZCCY
     C                   Z-ADD     @NDYNO        ZDAYNO
      *
     C                   CALLB     'ZCHKH'
      *                  ~~~~~~~~~~~~~~~~
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND              1
      *
      ** If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   MOVEL     'MMM0444'     WMSGID1
     C                   EVAL      WarnFound = 'Y'
     C                   END
     C                   END
      *
      **  For settlement NOT THROUGH a NOSTRO, using local location
      **  Find whether the date is a holiday in the local currency.
     C     PMRSTM        IFNE      1
     C     PMRSTM        ANDNE     7
     C     PMRSTM        ANDNE     8
     C                   MOVE      BJSLCD        ZLOC
     C                   MOVE      BJLCCY        ZCCY
     C                   Z-ADD     @NDYNO        ZDAYNO
      *
     C                   CALLB     'ZCHKH'
      *                  ~~~~~~~~~~~~~~~~
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
      *
      **  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   MOVEL     'MMM0445'     WMSGID1
     C                   EVAL      WarnFound = 'Y'
     C                   END
     C                   END
      *
     C                   END
     C                   END
     C                   END
      *
      **  Output valid next interest date
     C     DDNDAT        IFNE      *BLANKS
     C                   Z-ADD     @NDYNO        IHNIPD
     C                   ELSE
     C                   Z-ADD     0             IHNIPD
     C                   END
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
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
 
     C     *entry        PLIST
      ** Incoming return code (10A)
     C                   PARM                    ReturnCode
      ** Message ID (7A)
     C                   PARM                    MsgID1
      ** Warning ID (7A)
     C                   PARM                    WMsgID1
      ** Deal type (2A, from transaction)
     C                   PARM                    DDMTYP            2
      ** Deal value date in Midas day number format (5,0P, from caller)
     C                   PARM                    @VDYNO            5 0
      ** Local Currency code (3A, from SDBANKPD via caller)
     C                   PARM                    BJLCCY            3
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY             3                    LIKE(BJLCCY)
      ** Receive - settlement currency (3A, from caller)
     C                   PARM                    PMRSCY            3           12A
      ** Receive - settlement method (2,0S, from caller)
     C                   PARM                    PMRSTM            2 0
      ** Value date field OK (1A, from caller)
     C                   PARM                    ValDateOK         1
      ** Maturity date in Midas day number format (5,0P, from caller)
     C                   PARM                    @MDYNO            5 0
      ** Maturity date field OK (1A, from caller)
     C                   PARM                    MatDateOK         1
      ** System Location Code from SDBANKPD received as paramater
     C                   PARM                    BJSLCD            3            3A
      ** Date Fmt Ind. from SDBANKPD received as paramater
     C                   PARM                    BJDFIN            1            3A
      ** Receive Nostro Location Code received as paramater
     C                   PARM                    RLOC              3            3A
     ** Int Rate OK ***
     C                   PARM                    DDINTROK          1            1A
     ** Next Int Date **
     C                   PARM                    DDNDAT            6            6A
     ** Int Rate      **
     C                   PARM                    DDINTR           12           12A
     ** Next Int Payment Date **
     C                   PARM                    IHNIPD            5 0         15A 0
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
