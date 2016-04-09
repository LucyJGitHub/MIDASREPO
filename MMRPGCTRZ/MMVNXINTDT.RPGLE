     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate next interest date')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVNXINTDT - Validate next interest date                     *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             next interest date and confirms whether it has a  *
      *             valid value. If it is valid the 10A return code   *
      *             will be blank; if it is not it will contain       *
      *             'Error'                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15
      *  Prev Amend No. CDL096I01               03Nov14
      *                 CDL096             Date 22Sep14               *
      *                 AR1078867          Date 29Jan13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245491             Date 08Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 209738             Date 20Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 10Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096I01 - Fix incorrect message data                       *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *  AR1078867 - More than 1 warning is shown on Field: Next      *
      *              Interest Date                                    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245491 - Remove DB error on CALL AONOSTR0. Settlement        *
      *           instructions may be not valid yet.                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  209738 - For Int Freq "N" deals the NIDT is being corrupted  *
      *           on amend action.  Fix is to apply 196996 and 206242 *
      *           from TCV.                                           *
      *           (206242)                                            *
      *           When amending Interest Pay Freq from blank to 'N',  *
      *           program dumps. This is due to a blank next interest *
      *           date being passed to array @M in SR/IDATE1.         *
      *           (196996)                                            *
      *           Interest freq 'N' deals incorrectly updated.        *
      *  CDL006 - Dealing Fiduciary.                                  *
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

      **  Array for SR. IDATE1 - Days in a month.  (Compile time array)
     D @M              S              2  0 DIM(12) CTDATA PERRCD(12)

      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External data structure for book codes file
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D ZAVDATE         C                   CONST('ZAVDATE')
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RTCDE          S              1A
     D @KEYF           S              3A
     D @KEYG           S             10A
     D @KEYH           S              1A
     D BJDFIN          S              1A
     D BJLCCY          S              3A
     D BJSLCD          S              3A
     D DDTYPE          S              2A
     D DDACTN          S              1A
     D DDCCY           S              3A

      ** Next intereset payment date received as a parameter
     D DDNDAT          S              6A

      ** Value date received as a parameter
     D DDVDAT          S              6A

      ** Intereset payment frequency received as a parameter
     D DDIPFQ          S              1A

      ** Error message code 1 returned to caller
     D Msgid1          S                   LIKE(#MsgID)

      ** Warning messages returned to caller
     D WMsgid1         S                   LIKE(#MsgID)
     D WMsgid2         S                   LIKE(#MsgID)

     D PMERCD          S            150A
     D***PMPONS*         S             12A                                                    CGL029
     D PMPONS          S             18A                                                      CGL029
     D PMPSTM          S              2S 0
     D***PMRONS*         S             12A                                                    CGL029
     D PMRONS          S             18A                                                      CGL029
     D PMRSTM          S              2S 0
     D @KEYC           S             10A                                                      CGL029

      ** Location code for holiday checking
     D ZLOC            S              3A

      ** Holiday indicator
     D ZIND            S              1A

      ** Next interest date converted to Midas day number format
     D @NDYNO          S              5  0

      ** Deal file version of next interest date
     D IKNIPD          S                   LIKE(@NDYNO)
                                                                                CDL006
     D CDL006          S              1A   IMPORT                               CDL006

     D IKSLID          S                   LIKE(@NDYNO)                         209738
     D BJRDNB          S                   LIKE(@NDYNO)                         209738
     D ValdateMDN      S                   LIKE(@NDYNO)                         209738
     D NexdateMDN      S                   LIKE(@NDYNO)                         209738
     D ErrorFlag       S              1A                                        209738
                                                                                              CDL096
     D CDL096          S              1A   IMPORT                                             CDL096
     D PCurrency       S              3A   Dim(10)                                            CDL096
     D FirstPass       S               N                                                      CDL096
     D MsgStr          DS                                                                     CDL096
     D                                     Qualified                                          CDL096
     D   MsgDta                      45    Inz                                                CDL096
     D                                     VARYING                                            CDL096
     D   Data                  1     47    Inz                                                CDL096
                                                                                              CDL096
      ** Warning error message passed back to calling program                                 CDL096
     D  WMsgId3        S                   LIKE(#Msgid)                                       CDL096
     D x               S              3U 0                                                    CDL096
                                                                                              CDL096
      ** Warning message data to be passed back to the calling module                         CDL096
     D  WMsgDta3       S                   LIKE(#MsgData)                                     CDL096
                                                                                              CDL096
      ** Prototype for ChkHoliday                                                             CDL096
     D ChkHoliday      PR                  EXTPROC('ZCHKH')                                   CDL096
     D   MidasDate                    5  0 Const                                              CDL096
     D   Currency                     3    Const                                              CDL096
     D   Location                     3    Const                                              CDL096
     D   Holiday                      1                                                       CDL096
                                                                                              CDL096
      ** Prototype for IsHoliday subprocedure                                                 CDL096
     D IsHoliday       PR              N                                                      CDL096
     D   MidasDate                    5  0 Const                                              CDL096
     D   Currency                     3    Const                                              CDL096
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
     C                   RESET                   WMsgid1
     C                   RESET                   WMsgid2
     C                   RESET                   WMsgid3                                      CDL096
     C                   RESET                   WMsgDta3                                     CDL096

     C**   Processing for interest frequency 'N'.
     C**   Calculate NDAT using VDAT.
     C*
     C     DDIPFQ        IFEQ      'N'
      *                                                                         209738
     C                   CALLB     'ZDATE1'                                     209738
     C                   PARM                    DDVDAT                         209738
     C                   PARM                    ValDateMDN                     209738
     C                   PARM                    BJDFIN                         209738
     C                   PARM                    ErrorFlag                      209738
     C                   CALLB     'ZDATE1'                                     209738
     C                   PARM                    DDNDAT                         209738
     C                   PARM                    NexDateMDN                     209738
     C                   PARM                    BJDFIN                         209738
     C                   PARM                    ErrorFlag                      209738
     C                                                                          209738
     C*****DDVDAT        IFNE      *BLANKS                                      209738
     C     DDACTN        IFEQ      'I'                                          209738
      *                                                                         209738
      ** For Backvalued transactions, check if value date falls on the          209738
      ** previous month. If it does, use rundate as the basis of calculating    209738
      ** the nest interest date. Otherwise, use the value date.                 209738
      *                                                                         209738
     C     ValDateMDN    IFLT      BJRDNB                                       209738
     C                   MOVE      DDVDAT        MMYY1             4 0          209738
     C                   MOVEL     MMYY1         MM1               2 0          209738
      *                                                                         209738
     C                   Z-ADD     BJRDNB        ZDAYNO                         209738
     C                   CALLB     'ZDATE2'                                     209738
     C                   PARM                    ZDAYNO            5 0          209738
     C                   PARM                    BJDFIN                         209738
     C                   PARM      *ZERO         ZDATE             6 0          209738
     C                   PARM      *BLANK        ZADATE            7            209738
      *                                                                         209738
     C                   MOVE      ZDATE         MMYY2             4 0          209738
     C                   MOVEL     MMYY2         MM2               2 0          209738
      *                                                                         209738
     C     MM1           IFLT      MM2                                          209738
     C                   MOVE      ZDATE         DMMYXX                         209738
     C                   ELSE                                                   209738
     C                   MOVE      DDVDAT        DMMYXX            6
     C                   END                                                    209738
      *                                                                         209738
     C                   ELSE                                                   209738
     C                   MOVE      DDVDAT        DMMYXX                         209738
     C                   END                                                    209738
      *                                                                         209738
     C                   EXSR      IDATE1
     C                   ELSE                                                   209738
      *                                                                         209738
     C     IKNIPD        IFNE      NexDateMDN                                   209738
     C     NexDateMDN    ANDGE     BJRDNB                                       209738
     C     IKNIPD        OREQ      0                                            209738
     C                   Z-ADD     BJRDNB        ZDAYNO                         209738
     C                   CALLB     'ZDATE2'                                     209738
     C                   PARM                    ZDAYNO            5 0          209738
     C                   PARM                    BJDFIN                         209738
     C                   PARM      *ZERO         ZDATE             6 0          209738
     C                   PARM      *BLANK        ZADATE            7            209738
     C                   MOVE      ZDATE         DMMYXX                         209738
     C                   ELSE                                                   209738
     C                   Z-ADD     IKNIPD        ZDAYNO                         209738
     C                   CALLB     'ZDATE2'                                     209738
     C                   PARM                    ZDAYNO            5 0          209738
     C                   PARM                    BJDFIN                         209738
     C                   PARM      *ZERO         ZDATE             6 0          209738
     C                   PARM      *BLANK        ZADATE            7            209738
     C                   MOVE      ZDATE         DMMYXX                         209738
     C                   END                                                    209738
      *                                                                         209738
     C                   EXSR      IDATE1                                       209738
      *                                                                         209738
     C                   END                                                    209738
      *                                                                         209738
     C**********         END                                                    209738
     C                   END
     C*
     C**  If the date was not invalidly amended, carry out further
     C**  validation.  (Only if the date was not blank.)
     C     ErrorFound    IFEQ      'N'
     C     DDNDAT        ANDNE     *BLANKS
     C*
     C**  Validate that the date is valid as a date.
     C                   RESET                   ReturnCode
     C                   CALLB     ZAVDATE
     C                   PARM                    ReturnCode
     C                   PARM                    DDNdat
     C                   PARM                    BJDfin
     C                   PARM                    @Ndyno
     C*
     C**  If not, it is an error.
     C     ReturnCode    IFEQ      'Error'
     C                   MOVEL     'MMM0438'     Msgid1
     C                   EVAL      ErrorFound = 'Y'
     C*
     C                   ELSE
     C*
     C**  If the deal type is non-blank.
     C     DDTYPE        IFNE      *BLANKS
     C     DDIPFQ        ANDNE     'N'
                                                                                              CDL096
      ** If CDL096 is On, validate holidays with Business Days                                CDL096
      ** Convention currencies and override core holiday validation                           CDL096
     C                   IF        CDL096 = 'Y'                                               CDL096
     C                   EXSR      VlBCDHoli                                                  CDL096
     C                   GOTO      SKCDL096                                                   CDL096
     C                   ENDIF                                                                CDL096
     C*
     C*
     C**  If the date is not a working day in the deal currency and the
     C**  pay method is 01,07,08, and the deal type is IT,CD,CI or
     C**  TD, this is an error.
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
     C     PMPSTM        IFEQ      01
     C     PMPSTM        OREQ      07
     C     PMPSTM        OREQ      08
     C*
     C**  Find whether the date is a holiday in the deal currency
     C**  at the pay nostro location.
     C**  First find pay nostro location.
      *  (database error handling done in access program)
     C*
     C     PMERCD        IFEQ      *BLANKS
     C*
     C                   CALL      'AONOSTR0'
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
     C                   PARM                    @NDYNO
     C                   PARM                    DDCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
     C*
     C**  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   EVAL      WarnFound = 'Y'
     C                   MOVEL     'MMM0444'     WMsgid1
     C                   END
     C                   END
     C*
     C**  If the date is not a working day in the deal currency and the
     C**  receive method is 01,07,08, and deal type is not IT,CD,CI or
     C**  TD, this is an error.
     C                   ELSE
     C     PMRSTM        IFEQ      01
     C     PMRSTM        OREQ      07
     C     PMRSTM        OREQ      08
     C*
     C**  Find whether the date is a holiday in the deal currency
     C**  at the receive nostro location.
     C**  First find receive nostro location.
      *  (database error handling done in access program)
     C*
     C     PMERCD        IFEQ      *BLANKS
     C*
     C                   CALL      'AONOSTR0'
     C*******            PARM      '*DBERR '     @RTCD             7                          245491
     C                   PARM      *BLANKS       @RTCD             7                          245491
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      DDCCY         @KEYB             3
     C**********         PARM      *BLANKS       @KEYC             4                          CGL029
     C                   PARM      *BLANKS       @KEYC                                        CGL029
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      PMRONS        @KEYE             2
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
     C                   PARM                    @NDYNO
     C                   PARM                    DDCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
     C*
     C*
     C**  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   EVAL      WarnFound = 'Y'
     C                   MOVEL     'MMM0444'     WMsgid1
     C                   END
     C                   END
     C                   END
     C*
     C**  Find whether the date is a holiday in the local currency.
     C                   CALLB     'ZCHKH'
     C                   PARM                    @NDYNO
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
     C*
     C*
     C**  If settlement method is not 01,07 or 08 and it is
     C**  not a working day in the local currency, it is an error.
     C**  (Only if not settled through a nostro)
     C     PMRSTM        IFNE      01
     C     PMRSTM        ANDNE     07
     C     PMRSTM        ANDNE     08
     C*
     C**  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   EVAL      WarnFound = 'Y'
     C**********         MOVEL     'MMM0445'     WMsgid2                                   AR1078867
     C                   MOVEL     '5045887'     WMsgid2                                   AR1078867
     C                   END
     C                   END
     C*
     C     PMPSTM        IFNE      01
     C     PMPSTM        ANDNE     07
     C     PMPSTM        ANDNE     08
     C*
     C**  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   EVAL      WarnFound = 'Y'
     C**********         MOVEL     'MMM0445'     WMsgid1                                   AR1078867
     C                   MOVEL     '5045886'     WMsgid1                                   AR1078867
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
                                                                                              CDL096
      ** Skip holiday core validations up to this point when                                  CDL096
      ** CDL096 is on                                                                         CDL096
     C     SKCDL096      TAG                                                                  CDL096
     C*
     C**  Output valid next interest date
     C     ErrorFound    IFEQ      'N'
     C     DDNDAT        ANDNE     *BLANKS
     C                   Z-ADD     @NDYNO        IKNIPD
     C                   ELSE
     C                   Z-ADD     0             IKNIPD
     C                   END
     C*
      ** Output invalid next interest date
     C     ErrorFound    IFEQ      'Y'
     C     WarnGlobal    ANDEQ     'Y'
     C     DDNDAT        ANDNE     *BLANKS
     C                   Z-ADD     @NDYNO        IKNIPD
     C                   END
     C*
     C     DDIPFQ        IFEQ      'N'
     C                   MOVE      *BLANKS       DDNDAT
     C                   END
     C*

      ** Return code set in /COPY
     C/COPY ZACPYSRC,SETRETCDE

     C                   RETURN

      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* IDATE1   - Set next Interest date For Frequency 'N' to last   *
     C*            date of current month                              *
     C*                                                               *
     C*****************************************************************
     C*
     C     IDATE1        BEGSR
     C*
     C                   MOVE      DMMYXX        DATEW1            4 0
     C                   MOVE      DMMYXX        DATEW2            2 0
     C                   MOVEL     DATEW1        MT                2 0
     C                   MOVE      @M(MT)        MT1               2 0
     C     MT            IFEQ      2
     C     DATEW2        DIV       4             YR1               2 0
     C                   MVR                     YR2               2 0
     C     YR2           IFEQ      0
     C                   Z-ADD     29            MT1
     C                   END
     C                   END
     C                   MOVE      DATEW1        DDNDAT
     C                   MOVEL     MT1           DDNDAT
     C                   ENDSR
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
      ** Return code (10A)
     C                   PARM                    ReturnCode
      ** Error message ID (7A)
     C                   PARM                    Msgid1
      ** Warning message IDs (both 7A)
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
      ** Deal File version of next interest payment date
     C                   PARM                    IKNIPD
      ** Date format (1A, from SDBANKPD)
     C                   PARM                    BJDFIN
      ** Local currency (3A, from SDBANKPD)
     C                   PARM                    BJLCCY
      ** Location code (3A, from SDBANKPD)
     C                   PARM                    BJSLCD
      ** Deal type (2A, from transaction)
     C                   PARM                    DDTYPE
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY
      ** Next interest date (6A, from transaction)
     C                   PARM                    DDNDAT
      ** Value date (6A, from transaction)
     C                   PARM                    DDVDAT
      ** Interest payment frequency (1A, from transaction)
     C                   PARM                    DDIPFQ
      ** Error codes (150A, from SETLIAZ)
     C                   PARM                    PMERCD
      ** Pay our nostro (12A, from SETLIAB)
     C                   PARM                    PMPONS
      ** Pay settlement method (2,0S, from SETLIAB)
     C                   PARM                    PMPSTM
      ** Receive our nostro (12A, from SETLIAB)
     C                   PARM                    PMRONS
      ** Receive settlement method (2,0S, from SETLIAB)
     C                   PARM                    PMRSTM
      ** Global warning flag (1A, from caller)
     C                   PARM                    WarnGlobal
     C                   PARM                    DDACTN                         209738
     C                   PARM                    BJRDNB                         209738
     C                   PARM                    IKSLID                         209738
     C                   Parm                    PCurrency                                    CDL096
     C                   PARM                    WMsgid3                                      CDL096
     C                   Parm                    WMsgDta3                                     CDL096

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
      /EJECT                                                                                  CDL096
     C*****************************************************************                       CDL096
     C*                                                               *                       CDL096
     C* VlBCDHoli- Validate if Holiday on Business Convention Day     *                       CDL096
     C*            Currencies                                         *                       CDL096
     C*                                                               *                       CDL096
     C*****************************************************************                       CDL096
     C*                                                                                       CDL096
     C     VlBCDHoli     BEGSR                                                                CDL096
                                                                                              CDL096
     C                   Clear                   MsgStr.Data                               CDL096I01
     C                   Clear                   MsgStr.MsgDta                                CDL096
     C                   Eval      FirstPass = *On                                            CDL096
                                                                                              CDL096
     C                   For       x = 1 TO %elem(PCurrency)                                  CDL096
                                                                                              CDL096
      ** First blank currency encountered                                                     CDL096
      ** means last currency have been processed, so stop                                     CDL096
     C                   If        PCurrency(x) = *BLANK                                      CDL096
     C                   Leave                                                                CDL096
     C                   EndIf                                                                CDL096
                                                                                              CDL096
     C                   If        IsHoliday(@NDYNO:PCurrency(x))                             CDL096
                                                                                              CDL096
     C                   If        FirstPass                                                  CDL096
     C                   Eval      MsgStr.MsgDta = PCurrency(x)                               CDL096
     C                   Eval      FirstPass = *Off                                           CDL096
     C                                                                                        CDL096
     C                   Else                                                                 CDL096
     C                   Eval      MsgStr.MsgDta = MsgStr.MsgDta + ','                        CDL096
     C                                           + PCurrency(x)                               CDL096
     C                   EndIf                                                                CDL096
                                                                                              CDL096
     C                   EndIf                                                                CDL096
                                                                                              CDL096
     C                   EndFor                                                               CDL096
                                                                                              CDL096
     C                   IF        MsgStr.MsgDta <> ' '                                       CDL096
     C                   EVAL      WarnFound = 'Y'                                            CDL096
     C                   EVAL      WMsgID3  = '5047404'                                       CDL096
     C                   EVAL      WMsgDta3 = MsgStr.Data                                     CDL096
     C                   EndIf                                                                CDL096
                                                                                              CDL096
     C                   ENDSR                                                                CDL096
      *****************************************************************                       CDL096
     C* IsHoliday - Check if Date is holiday in a currency                                    CDL096
      *****************************************************************                       CDL096
     P  IsHoliday      B                                                                      CDL096
     D   IsHoliday     PI              N                                                      CDL096
     D   MidasDate                    5  0 Const                                              CDL096
     D   Currency                     3    Const                                              CDL096
                                                                                              CDL096
     D   Location      S              3                                                       CDL096
     D   Holiday       S              1                                                       CDL096
                                                                                              CDL096
     C                   callp     ChkHoliday(MidasDate:                                      CDL096
     C                                        Currency:                                       CDL096
     C                                        Location:                                       CDL096
     C                                        Holiday)                                        CDL096
                                                                                              CDL096
     C                   Return    (Holiday = 'H')                                            CDL096
                                                                                              CDL096
     P                 E                                                                      CDL096
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @M  USED BY SR. IDATE1 - DAYS IN A MONTH
312831303130313130313031
