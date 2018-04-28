     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate value date')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVVALDATE - Validate value date                             *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             value date and confirms whether it has a valid    *
      *             value. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
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
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 245491             Date 08Feb07               *
      *                 249967             Date 13Sep07               *
      *                 BUG12893A          Date 14Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12893           Date 14Dec06               *
      *                 240486             Date 26Sep06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG4828            Date 17Nov04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 10Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245491 - Remove DB error on CALL AONOSTR0. Settlement        *
      *           instructions may be not valid yet.                  *
      *  249967 - Restrict validation of VDAT to insert               *
      *  BUG12893A- Reopened for additional deliveries - recompile.   *
      *  BUG12893 - Start/Last Int Date must not be entered for a     *
      *             a deal type not eq to 'C2','BP','BD'.             *
      *  240486 - Validate the value date against the back value      *
      *           period defined in PF/SDBANKPD                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG4828- Serious Midas error displayed when Sett account     *
      *           is full nostro                                      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *           N.B. *INL1 processing has been stripped on the      *
      *           assumption that conditioning will be done at a      *
      *           higher level.                                       *
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
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for book codes file
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** EXTERNAL DS FOR BANK DETAILS                                                         240486
     D SDBANK        E DS                  EXTNAME(SDBANKPD) PREFIX(XX:2)                     240486
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D ZAVDATE         C                   CONST('ZAVDATE')
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @KEYC           S             10A                                                      CGL029
     D @VDYNO          S              5P 0
     D BJDFIN          S              1A
     D BJLCCY          S              3A
     D BJRDNB          S              5P 0
     D BJSLCD          S              3A
     D DDCCY           S              3A
     D DDTYPE          S              2A
     D DDVDAT          S              6A
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
     D WMsgid1         S                   LIKE(#MsgID)
     D WMsgid2         S                   LIKE(#MsgID)
 
      ** Deal file version of value date
     D IKDVSD          S                   LIKE(@VDYNO)
 
      ** Deal file version of start/last interest date
     D IKSLID          S                   LIKE(@VDYNO)
     D PMERCD          S            150A
     D***PMPONS*         S             12A                                                    CGL029
     D PMPONS          S             18A                                                      CGL029
     D PMPSTM          S              2S 0
     D***PMRONS*         S             12A                                                    CGL029
     D PMRONS          S             18A                                                      CGL029
     D PMRSTM          S              2S 0
     D @DAT            S              6P 0                                                    240486
     D @RTCDE          S              1A                                                      240486
     D BVDYNO          S                   LIKE(BJRDNB)                                       240486
     D DDACTN          S              1A                                                      249967
 
      ** Location code for holiday checking
     D ZLOC            S              3A
 
      ** Holiday indicator
     D ZIND            S              1A
                                                                                CDL006
     D CDL006          S              1A   IMPORT                               CDL006
 
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound
     C                   RESET                   Msgid1
 
      **  The field must be entered.
     C     DDVDAT        IFEQ      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0123'     Msgid1
     C*
     C**  Validate that the value date is a valid date.
     C                   ELSE
     C                   RESET                   ReturnCode
     C                   CALLB     ZAVDATE
     C                   PARM                    ReturnCode
     C                   PARM                    DDVdat
     C                   PARM                    BJDfin
     C                   PARM                    @Vdyno
     C*
     C**  If the return code is 'Error' then the input date is invalid or
     C**  non-numeric.
     C     ReturnCode    IFEQ      'Error'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0125'     Msgid1
     C*
     C**  If the date is valid, carry out further validation.
     C                   ELSE
     C*
      *                                                                                       240486
      **  Get the day number format of the value date into @VDYNO                             240486
      *                                                                                       240486
     C                   MOVE      DDVDAT        @DAT                                         240486
     C                   CALLB     'ZA0270'                                                   240486
     C                   PARM                    @DAT                                         240486
     C                   PARM                    BJDFIN                                       240486
     C                   PARM                    @RTCDE                                       240486
     C                   PARM                    @VDYNO                                       240486
      *                                                                                       240486
      ** Access Bank details via access program                                               240486
      *                                                                                       240486
     C                   CALLB     'AOBANKR0'                                                 240486
     C                   PARM      '*DBERR '     @RTCD             7                          240486
     C                   PARM      '*FIRST '     @OPTN             7                          240486
     C     SDBANK        PARM      SDBANK        DSFDY                                        240486
      *                                                                                       240486
      ** Check if value date is within back-value period                                      240486
      *                                                                                       240486
     C                   EVAL      BVDYNO = BJRDNB - XXBVPD                                   240486
     C                   IF        @VDYNO  < BVDYNO                                           240486
     C**********                   AND DDACTN = 'I'                                           240486
     C                             AND DDACTN = 'I'                                           249967
     C                   EVAL      ErrorFound = 'Y'                                           240486
     C                   EVAL      WarnFound  = 'Y'                                           240486
     C                   MOVEL     'MMM2625'     Msgid1                                       240486
     C                   ENDIF                                                                240486
      *                                                                                       240486
     C**  If the date is not a working day in the deal currency and the
     C****receive*method*is*01,07,08,*and*the*deal*type*is*IT,CD,CI or******    CDL006
     C****TD,*this*is*an*error.*********************************************    CDL006
      ** receive method is 01,07,08, and the deal type is IT,CD,CI,TD,          CDL006
      ** DT,LT, or FT, this is an error.                                        CDL006
 
      ** NOTE: the deal type check here is only applicable for Loans,
      ** Deposits and Negotiable Assets Issued.  To allow this module
      ** to be used for other types of Money Market transaction, a check
      ** on the TransType parameter is now included below.  This is
      ** slightly messy, but keeps the disruption of the code to a
      ** minimum.
     C     DDTYPE        IFEQ      'IT'
     C     DDTYPE        OREQ      'CD'
     C     DDTYPE        OREQ      'CI'
     C     DDTYPE        OREQ      'TD'
     C     DDTYPE        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'FT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     TransType     ORNE      'LDNI'
 
     C     PMRSTM        IFEQ      01
     C     PMRSTM        OREQ      07
     C     PMRSTM        OREQ      08
     C*
     C**  Find whether the date is a holiday in the deal currency
     C**  at the receive nostro location.
     C**  First find receive nostro location.
      *  (database error handling done in access program)
     C* IF ERRORS OUTSTANDING IN SETTL.DETAILS, DON'T CALL ACCESS OBJ
     C*
                                                                                             BUG4828
      ** Make sure that the 1st 2 character of PMRONS is numeric before                      BUG4828
      ** calling AONOSTR0                                                                    BUG4828
                                                                                             BUG4828
     C                   MOVEL     PMRONS        @KEYE                                       BUG4828
     C                   TESTN                   @KEYE                05                     BUG4828
                                                                                             BUG4828
     C     PMERCD        IFEQ      *BLANKS
     C     *IN05         ANDEQ     *ON                                                       BUG4828
     C*
     C                   CALLB     'AONOSTR0'
     C*******            PARM      '*DBERR '     @RTCD             7                          245491
     C                   PARM      *BLANKS       @RTCD             7                          245491
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      DDCCY         @KEYB             3
     C**********         PARM      *BLANKS       @KEYC             4                          CGL029
     C                   PARM      *BLANKS       @KEYC                                        CGL029
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      PMRONS        @KEYE             2
     C                   PARM      *BLANKS       @KEYF             3
     C                   PARM      *BLANKS       @KEYG            10
     C                   PARM      *BLANKS       @KEYH             1
     C     SDNOST        PARM      SDNOST        DSFDY
     C*
     C     @RTCD         IFEQ      *BLANKS                                                    245491
     C                   MOVE      A7NOSN        ZLOC
     C                   ELSE                                                                 245491
     C                   MOVE      *BLANKS       ZLOC                                         245491
     C                   END                                                                  245491
     C*
     C                   ELSE
     C                   MOVE      *BLANKS       ZLOC
     C                   END
     C*
     C                   CALLB     'ZCHKH'
     C                   PARM                    @VDYNO
     C                   PARM                    DDCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
     C*
     C**  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   EVAL      WarnFound    = 'Y'
     C                   MOVEL     'MMM0129'     WMsgid1
     C                   END
     C                   END
     C*
     C**  If the date is not a working day in the deal currency and the
     C**  pay method is 01,07,08, and the deal type is not IT,CD,CI or
     C**  TD, this is an error.
     C                   ELSE
     C     PMPSTM        IFEQ      01
     C     PMPSTM        OREQ      07
     C     PMPSTM        OREQ      08
     C*
     C**  Find whether the date is a holiday in the deal currency
     C**  at the pay nostro location.
     C**  First find pay nostro location.
      *  (database error handling done in access program)
     C* IF ERRORS OUTSTANDING IN SETTL.DETAILS, DON'T CALL ACCESS OBJ
     C*
                                                                                             BUG4828
      ** Make sure that the 1st 2 character of PMRONS is numeric before                      BUG4828
      ** calling AONOSTR0                                                                    BUG4828
                                                                                             BUG4828
     C                   MOVEL     PMPONS        @KEYE                                       BUG4828
     C                   TESTN                   @KEYE                05                     BUG4828
                                                                                             BUG4828
     C     PMERCD        IFEQ      *BLANKS
     C     *IN05         ANDEQ     *ON                                                       BUG4828
     C*
     C                   CALLB     'AONOSTR0'
     C*******            PARM      '*DBERR '     @RTCD             7                          245491
     C                   PARM      *BLANKS       @RTCD             7                          245491
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      DDCCY         @KEYB             3
     C**********         PARM      *BLANKS       @KEYC             4                          CGL029
     C                   PARM      *BLANKS       @KEYC                                        CGL029
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      PMPONS        @KEYE             2
     C                   PARM      *BLANKS       @KEYF
     C                   PARM      *BLANKS       @KEYG
     C                   PARM      *BLANKS       @KEYH
     C     SDNOST        PARM      SDNOST        DSFDY
     C*
     C     @RTCD         IFEQ      *BLANKS                                                    245491
     C                   MOVE      A7NOSN        ZLOC
     C                   ELSE                                                                 245491
     C                   MOVE      *BLANKS       ZLOC                                         245491
     C                   END                                                                  245491
     C*
     C                   ELSE
     C                   MOVE      *BLANKS       ZLOC
     C                   END
     C*
     C                   CALLB     'ZCHKH'
     C                   PARM                    @VDYNO
     C                   PARM                    DDCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
     C*
     C*
     C**  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   EVAL      WarnFound    = 'Y'
     C                   MOVEL     'MMM0129'     WMsgid1
     C                   END
     C                   END
     C                   END
     C*
     C**  Find whether the date is a holiday in the local currency.
     C*
     C                   CALLB     'ZCHKH'
     C                   PARM                    @VDYNO
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
     C*
     C*
     C**  If settlement method is not 01,07 or 08 and it is
     C**  not a working day in the local currency, it is an error.
     C**  (Only if not settled through a nostro)
     C*
     C** Maturity date is checked against receive settlement
     C** instructions only when deal is not a deposit.
     C*
     C     DDTYPE        IFNE      'CD'
     C     DDTYPE        ANDNE     'CI'
     C     DDTYPE        ANDNE     'TD'
     C     DDTYPE        ANDNE     'IT'
     C     CDL006        ANDEQ     'N'                                          CDL006
     C     DDTYPE        ORNE      'CD'                                         CDL006
     C     DDTYPE        ANDNE     'CI'                                         CDL006
     C     DDTYPE        ANDNE     'TD'                                         CDL006
     C     DDTYPE        ANDNE     'IT'                                         CDL006
     C     DDTYPE        ANDNE     'DT'                                         CDL006
     C     DDTYPE        ANDNE     'FT'                                         CDL006
     C     DDTYPE        ANDNE     'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C*
     C     PMRSTM        IFNE      01
     C     PMRSTM        ANDNE     07
     C     PMRSTM        ANDNE     08
     C     PMPSTM        ORNE      01
     C     PMPSTM        ANDNE     07
     C     PMPSTM        ANDNE     08
     C*
     C**  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   EVAL      WarnFound    = 'Y'
     C                   MOVEL     'MMM0131'     WMsgid2
     C                   END
     C                   END
     C*
     C                   END
     C                   END
     C                   END
 
      **  Output value date
 
     C     ErrorFound    IFEQ      'N'
     C     ErrorFound    OREQ      'Y'
     C     WarnFound     ANDEQ     'Y'
     C                   Z-ADD     @VDYNO        IKDVSD
     C**********         Z-ADD     @VDYNO        IKSLID                                     BUG12893
     C                   ELSE
     C                   Z-ADD     0             IKDVSD
     C**********         Z-ADD     0             IKSLID                                     BUG12893
     C                   END
 
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
     C                   PARM                    WMsgid2
     C                   PARM                    IKDVSD
     C                   PARM                    IKSLID
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
     C                   PARM                    BJRDNB
     C                   PARM                    BJSLCD
     C                   PARM                    DDCCY
     C                   PARM                    DDTYPE
     C                   PARM                    DDVDAT
     C                   PARM                    PMERCD
     C                   PARM                    PMPONS
     C                   PARM                    PMPSTM
     C                   PARM                    PMRONS
     C                   PARM                    PMRSTM
      ** Transaction type (4A, from caller)
     C                   PARM                    TransType
     C                   PARM                    DDACTN                                       249967
 
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
