     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Start/Last Interest date       ')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVSLINTDT - Validate Start/Last Interest Date               *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Start/Last Interest date and checks whether it    *
      *             has a valid value.                                *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
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
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 136430             Date 10Jun98               *
      *                 CAP002  *CREATE    Date 03Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  136430 - Amendment of NA purchased deal disallowed           *
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
 
      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for Customer Details file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      * Data structure to define variables used in holiday sub-routines
      *
     D  ZIND                   1      1
     D  ZINDX                  2      4  0
     D  ZDAYNO                 5      7P 0
     D  ZDYNBR                 8     10P 0
     D  ZNRDYS                11     12  0
     D  @ZWRDY                13     14  0
      *
     D  ZCCY                  15     17
     D  ZLOC                  18     20
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error messages field received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
     D Msgid3          S                   LIKE(#MsgID)
     D WMsgid1         S                   LIKE(#MsgID)
      ** Start/Last Int date is received as a parameter
     D DDSLID          S              6A
      ** Deal Type  - received as a parameter
     D DDMTYP          S              2A
      ** Next Interest date Received as a parameter
     D DDNDAT          S              6A
      ** Value date received as a parameter
     D DDVdat          S              6A
      ** Value date OK  - received as a parameter
     D DDVdatOK        S              1A
      ** Value date (Midas number fmt) received as a parameter
     D @VDYNO          S              5  0
      ** Next Interest date (Midas number fmt) received as a parameter
     D @NDYNO          S              5  0
      ** Receive - settlement currency (3A, from caller)
     D PMRSCY          S              3A
      ** Receive - settlement method (2,0S, from caller)
     D PMRSTM          S              2S 0
      ** Receive Nostro Location   received as a parameter
     D RLOC            S              3A
      ** Location           received as a parameter
     D BJSLCD          S              3A
      **                    received as a parameter
     D BJLCCY          S              3A
      ** Start/Last Int date received as a parameter
     D IHSLID          S              5  0
      ** CURRENCY CODE received as a parameter
     D DDCCY           S              3A
 
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
      ** ¦ Initial processing is performed automatically: the *INZ        ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound
     C                   RESET                   Msgid1
     C                   RESET                   wMsgid1
      *
      * Effective settlement currency
      *
     C     PMRSCY        IFNE      *BLANKS
     C                   MOVEL     PMRSCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     DDCCY         EffSetCcy         3
     C                   ENDIF
      *
      *  *------------------------------------------*
      *  * Validate Start/Last Int. Date            *
      *  *------------------------------------------*
      *
     C                   Z-ADD     0             @SDYNO
      *
      **  If the deal type is 'C2' 'BP' 'BD' then SLID must be entered.
     C     DDMTYP        IFEQ      'C2'
     C     DDMTYP        OREQ      'BP'
     C     DDMTYP        OREQ      'BD'
      *
      **  If SLID is blank, this is an error.
     C     DDSLID        IFEQ      *BLANKS
     C                   MOVEL     'MMM0446'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
      *
      **  Validate that the start/last int. date is a valid date.
     C                   ELSE
     C                   TESTN                   DDSLID               6263
     C                   MOVE      DDSLID        @TEST             1
     C                   TESTZ                   @TEST                    73
     C     *IN62         IFEQ      '1'
     C     *IN73         ANDEQ     '1'
     C     *IN63         OREQ      '1'
     C     *IN73         ANDEQ     '1'
     C                   MOVE      DDSLID        @DAT              6 0
      *
     C                   CALLB     'ZA0270'
      *
     C                   PARM                    @DAT              6 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    @RTCDE            1
     C                   PARM                    @SDYNO            5 0
      *
     C                   END
      *
      **  If the return code is 1 then the input date is invalid or
      **  non-numeric.
     C     @RTCDE        IFEQ      '1'
     C     *IN73         OREQ      '0'
     C     *IN62         OREQ      '0'
     C     *IN63         ANDEQ     '0'
     C                   MOVEL     'MMM0448'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
      *
      **  If the date is valid, carry out further validation.
     C                   ELSE
      *
      ****If*SLID*date*is*>*value*date*it*is*an*error.*****************         136430
      **  If SLID date is > value date on insertions, it is an error.           136430
     C     DDVdatOK      IFNE      'N'
     C     @SDYNO        ANDGT     @VDYNO
     C     DDACTN        ANDEQ     'I'                                          136430
     C                   MOVEL     'MMM0449'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
     C                   END
     C                   END
      *
      **  If the deal type is not 'C2' 'BP' 'BD', but is 'C1' then
      **  SLID should be blank or equal to value date.
     C                   ELSE
     C     DDMTYP        IFEQ      'C1'
     C     DDSLID        IFNE      *BLANKS
     C     DDSLID        ANDNE     DDVDAT
     C                   MOVEL     'MMM0447'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
      *
      **  If the deal type is not 'C2' 'BP' 'BD' 'C1' then SLID
      **  should be blank. (NB. discounted, non-interest bearing
      **  NAs cannot have a Start/Last Interest Date).
     C                   ELSE
     C     DDSLID        IFNE      *BLANKS
     C                   MOVEL     'MMM0447'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
     C                   END
     C                   END
      *
      ** SLID SHOULD BE LESS THEN NDAT
      *
      **  If the deal type is non-blank.
     C     DDMTYP        IFNE      *BLANKS
      **  For settlement THROUGH a NOSTRO, using nostro location
      **  Find whether the date is a holiday in the deal currency.
     C     PMRSTM        IFEQ      1
     C     PMRSTM        OREQ      7
     C     PMRSTM        OREQ      8
     C                   MOVE      RLOC          ZLOC
     C                   MOVE      EffSetCcy     ZCCY
     C                   Z-ADD     @SDYNO        ZDAYNO
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
      *
      *   If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   MOVEL     'MMM2546'     WMSGID1
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
     C                   Z-ADD     @SDYNO        ZDAYNO
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
      **  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   MOVEL     'MMM2545'     WMSGID1
     C                   EVAL      WarnFound = 'Y'
     C                   END
     C                   END
     C                   END
      *
      **  Output valid Start/last interest date
     C     DDSLID        IFNE      *BLANKS
     C                   Z-ADD     @SDYNO        IHSLID
     C                   ELSE
     C                   Z-ADD     0             IHSLID
     C                   END
      *
 
      ** Return code set in /COPY
     C/COPY ZACPYSRC,SETRETCDE
 
     C                   RETURN
 
      *****************************************************************
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
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid1
     C                   PARM                    WMsgid1
      ** Start/Last Int date
     C                   PARM                    DDSLID            6
      ** Action Code                                                            136430
     C                   PARM                    DDACTN            1            136430
      ** Deal Type
     C                   PARM                    DDMTYP            2
      ** Next Interest date
     C                   PARM                    DDNDAT            6
      ** Value date
     C                   PARM                    DDVDAT            6
      ** Value date OK
     C                   PARM                    DDVdatOK          1
      ** Value date (Midas number format)
     C                   PARM                    @VDYNO            5 0
      ** Next Interest date (Midas number format)
     C                   PARM                    @NDYNO            5 0
     C                   PARM                    PMRSCY
     C                   PARM                    PMRSTM
      ** Receive nostro location
     C                   PARM                    RLOC              3
     C                   PARM                    BJSLCD            3
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJDFIN            1
      ** Start/Last Int date (MMSTDBPP - Midas number format)
     C                   PARM                    IHSLID            5 0
      ** Currency Code
     C                   PARM                    DDCCY             3
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
