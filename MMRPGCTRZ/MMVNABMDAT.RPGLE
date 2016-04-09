     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Maturity Date                  ')
      *****************************************************************
      *                                                               *
      *  Midas - Standard routines                                    *
      *                                                               *
      *  MMVNABMDAT - Validate Maturity Date                          *
      *               **** FOR NA'S PURCHASED ****                    *
      *                                                               *
      *  Function:  This module validates the Maturity Date field     *
      *               **** FOR NA'S PURCHASED ****                    *
      *                                                               *
      *  Component of:                 modules service program        *
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
      *  Last Amend No. BUG22205           Date 19Jan09               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 18Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG22205 - "A serious Midas error has occured" message       *
      *             displayed after clicking the Repair button from   *
      *             Repair Queue view.                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
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
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for nostros file
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ==========
      ** Parameters
      ** ==========
 
      ** Message ID
     D MsgID1          S                   LIKE(#MsgID)
      ** Warning ID
     D WMsgID1         S                   LIKE(#MsgID)
      ** Maturity Date
     D DDMDAT          S              6A
      ** Deal type
     D DDMTYP          S              2A
      ** Decimal separator
     D BNDCSP          S              1A
     *** Maturity Date - Std. Deal file
     D IHMATD          S              5  0
     ** Interest Rate
     D DDINTR          S             12A
      ** Deal value date in Midas day number format
     D @VDYNO          S              5P 0
      ** Location Code sent as paramater (from SDNOSTPD)
     D RLOC            S              3A
 
     D  ZDAYNO         S              5P 0
     D  ZCCY           S              3
     D  ZLOC           S              3
     D  ZDAT           S              6  0
 
      ** Deal currency (3A, from transaction)
     D DDCCY           S                   LIKE(BJLCCY)
 
      ** Receive - settlement currency (3A, from caller)
     D PMRSCY          S              3A
 
      ** Receive - settlement method (2,0S, from caller)
     D PMRSTM          S              2S 0
 
      ** Receive - our nostro
     D***PMRONS*         S             12A                                                    CGL029
     D PMRONS          S             18A                                                      CGL029
 
      ** Local Currency code (3A, from SDBANKPD via caller)
     D BJLCCY          S              3A
 
      ** System Location Code from SDBANKPD received as paramater
     D BJSLCD          S              3A
     D @NKYC           S             10A                                                      CGL029
 
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
 
      *  *------------------------*
      *  * Validate Maturity Date *
      *  *------------------------*
 
      **  Maturity date must entered.
     C     DDMDAT        IFEQ      *BLANK
     C                   MOVEL     'MMM0110'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   ELSE
      *
      **  Validate that the maturity date is valid as a date.
     C                   TESTN                   DDMDAT               6263
     C                   MOVE      DDMDAT        @TEST             1
     C                   TESTZ                   @TEST                    73
     C     *IN62         IFEQ      '1'
     C     *IN73         ANDEQ     '1'
     C     *IN63         OREQ      '1'
     C     *IN73         ANDEQ     '1'
     C                   MOVE      DDMDAT        ZDAT
     C                   CALLB     'ZA0270'
      *                  ~~~~~~~~~~~~~~~~~
     C                   PARM                    ZDAT
     C                   PARM                    BJDFIN            1
     C                   PARM                    @RTCDE            1
     C                   PARM                    @MDYNO            5 0
     C                   END
      *
      **  If not, it is an error.
     C     *IN62         IFEQ      '0'
     C     *IN63         ANDEQ     '0'
     C     *IN73         OREQ      '0'
     C     @RTCDE        OREQ      '1'
     C                   MOVEL     'MMM0128'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
      *
      **  Check that the maturity date is after the value date.
     C                   ELSE
     C     @MDYNO        IFLE      @VDYNO
     C                   MOVEL     'MMM0130'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
      *
      *   For settlement THROUGH a NOSTRO, using nostro location,
      **  Find whether the date is a holiday in the deal currency.
     C     PMRSTM        IFEQ      1
     C     PMRSTM        OREQ      7
     C     PMRSTM        OREQ      8
      *
      * CALL ACCESS PROG. FOR NOSTRO DETAILS.(LOCATION)
     C                   MOVEL     PMRONS        @2                2
     C                   CALLB     'AONOSTR0'
      *                  ~~~~~~~~~~~~~~~~~~~
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @NKYA             6
     C                   PARM      EffSetCcy     @NKYB             3
     C**********         PARM      *BLANKS       @NKYC             4                          CGL029
     C                   PARM      *BLANKS       @NKYC                                        CGL029
     C                   PARM      *BLANKS       @NKYD             2
     C                   PARM      @2            @NKYE             2
     C                   PARM      *BLANKS       @KKYF             3
     C                   PARM      *BLANKS       @KKYG            10
     C                   PARM      *BLANKS       @KKYH             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C*****@RTCD         IFNE      *BLANK                                                   BUG22205
     C**********         MOVE      '1'           *INLR                                      BUG22205
     C**********         MOVE      '1'           *INKC                                      BUG22205
     C**********         MOVE      '1'           *INU7                                      BUG22205
     C**********         MOVE      '1'           *INU8                                      BUG22205
     C**********         MOVEL     'SDNOSTPD'    DBFILE                    * DB ERROR 993 * BUG22205
     C**********         MOVEL     @NKYB         DBKEY                                      BUG22205
     C**********         MOVE      @NKYE         DBKEY                                      BUG22205
     C**********         MOVE      '993'         DBASE                                      BUG22205
     C**********         DUMP                                                               BUG22205
     C**********         EXSR      *PSSR                                                    BUG22205
     C**********         END                                                                BUG22205
      *
     C                   MOVE      A7NOSN        RLOC              3
     C                   MOVE      RLOC          ZLOC
     C                   MOVE      EffSetCcy     ZCCY
     C                   Z-ADD     @MDYNO        ZDAYNO
 
     C                   CALLB     'ZCHKH'
      *                  ~~~~~~~~~~~~~~~~
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND              1
      *
      **  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   MOVEL     'MMM0134'     WMSGID1
     C                   EVAL      WarnFound = 'Y'
     C                   END
     C                   END
      *
      *   For settlement NOT through a NOSTRO, using local location,
      **  Find whether the date is a holiday in the local currency
     C     PMRSTM        IFNE      1
     C     PMRSTM        ANDNE     7
     C     PMRSTM        ANDNE     8
     C                   MOVE      BJSLCD        ZLOC
     C                   MOVE      BJLCCY        ZCCY
     C                   Z-ADD     @MDYNO        ZDAYNO
     C                   CALLB     'ZCHKH'
      *                  ~~~~~~~~~~~~~~~~
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND              1
      *
      **  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   MOVEL     'MMM0135'     WMSGID1
     C                   EVAL      WarnFound = 'Y'
     C                   END
     C                   END
     C                   END
      *
     C                   END
      *
      **  Output valid maturity date
     C     ErrorFound    IFNE      'Y'
     C     DDMDAT        ANDNE     *BLANKS
     C     ErrorFound    OREQ      'Y'
     C     WarnGlobal    ANDEQ     'Y'
     C     DDMDAT        ANDNE     *BLANKS
     C                   Z-ADD     @MDYNO        IHMATD
     C                   ELSE
     C                   Z-ADD     0             IHMATD
     C                   END
 
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
 
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
      ** Message ID
     C                   PARM                    MsgID1
      ** Warning ID
     C                   PARM                    WMsgID1
      ** Maturity Date
     C                   PARM                    DDMDAT            6
      ** Deal type
     C                   PARM                    DDMTYP            2
      ** Decimal separator (1A, from SDDEALPD)
     C                   PARM                    BNDCSP            1
      ** Maturity Date - Std. Deal file
     C                   PARM                    IHMATD            5 0         12A
      ** Interest Rate, from transaction
     C                   PARM                    DDINTR           12           12A
      ** Deal value date in Midas day number format
     C                   PARM                    @VDYNO            5 0         12A
      ** Location Code received as paramater
     C                   PARM                    RLOC              3           12A
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY             3           12A
      ** Receive - settlement currency (3A, from caller)
     C                   PARM                    PMRSCY            3           12A
      ** Receive - settlement method (2,0S, from caller)
     C                   PARM                    PMRSTM            2 0         12A
      ** Receive - our nostro
     C**********         PARM                    PMRONS           12           12A            CGL029
     C                   PARM                    PMRONS                                       CGL029
      ** Global Warning indicator
     C                   PARM                    WarnGlobal        1
      ** Local Currency code (3A, from SDBANKPD via caller)
     C                   PARM                    BJLCCY            3
      ** System Location Code from SDBANKPD received as paramater
     C                   PARM                    BJSLCD            3
      ** Date Format Ind. from SDBANKPD received as paramater
     C                   PARM                    BJDFIN            1
 
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
