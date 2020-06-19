000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas MM Validate value date')
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Money Market Dealing Module                          *
000900200529      *                                                               *
001000200529      *  MMVVALDATE - Validate value date                             *
001100200529      *                                                               *
001200200529      *  Function:  This module receives a parameter containing the   *
001300200529      *             value date and confirms whether it has a valid    *
001400200529      *             value. If it is valid the 10A return code will be *
001500200529      *             blank; if it is not it will contain 'Error'       *
001600200529      *                                                               *
001700200529      *  Component of: MMVALIDTE - MM validation service program      *
001800200529      *                                                               *
001900200529      *  (c) Finastra International Limited 2001                      *
002000200529      *                                                               *
002100200529      *    This source is centrally supported and must ONLY be        *
002200200529      *    amended by Core Development Personnel                      *
002300200529      *                                                               *
002400200529      *    /COPY, Client or Country amendments must not be            *
002500200529      *    applied to this source.                                    *
002600200529      *                                                               *
002700200604      *  Last Amend No. MD036225           Date 22May20               *
002800200529      *  Prev Amend No. MD046248           Date 27Oct17               *
002900200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
003000200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
003100200529      *                 256564             Date 17Sep08               *
003200200529      *                 245491             Date 08Feb07               *
003300200529      *                 249967             Date 13Sep07               *
003400200529      *                 BUG12893A          Date 14Dec06               *
003500200529      * Midas Plus 1.3 ----------- Base ------------------------------*
003600200529      *                 BUG12893           Date 14Dec06               *
003700200529      *                 240486             Date 26Sep06               *
003800200529      *                 CSD027             Date 09Dec05               *
003900200529      *                 BUG4828            Date 17Nov04               *
004000200529      *                 CGL029             Date 01Sep03               *
004100200529      * Midas Release 4 --------------- Base -------------------------*
004200200529      * Midas DBA 3.01 -----------------------------------------------*
004300200529      *                 CDL006             Date 26Apr99               *
004400200529      * Midas DBA 3.00 ---------------- Base -------------------------*
004500200529      *                 CAP002  *CREATE    Date 10Sep97               *
004600200529      *                                                               *
004700200529      *---------------------------------------------------------------*
004800200529      *                                                               *
004900200529      *  MD036225 - MM deals in Repair Q. Make sure validation for    *
005000200529      *             value date is only for retail accounts.           *
005100200529      *  MD046248 - Finastra Rebranding                               *
005200200529      *  256564 - Recompile due to PF changes done by fix 256330      *
005300200529      *  245491 - Remove DB error on CALL AONOSTR0. Settlement        *
005400200529      *           instructions may be not valid yet.                  *
005500200529      *  249967 - Restrict validation of VDAT to insert               *
005600200529      *  BUG12893A- Reopened for additional deliveries - recompile.   *
005700200529      *  BUG12893 - Start/Last Int Date must not be entered for a     *
005800200529      *             a deal type not eq to 'C2','BP','BD'.             *
005900200529      *  240486 - Validate the value date against the back value      *
006000200529      *           period defined in PF/SDBANKPD                       *
006100200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
006200200529      *  BUG4828- Serious Midas error displayed when Sett account     *
006300200529      *           is full nostro                                      *
006400200529      *  CGL029 - Increase Account Code to 10 digits                  *
006500200529      *  CDL006 - Dealing Fiduciary.                                  *
006600200529      *  CAP002 - Conversion of MM inputs into modular structure to   *
006700200529      *           use as APIs.                                        *
006800200529      *           N.B. *INL1 processing has been stripped on the      *
006900200529      *           assumption that conditioning will be done at a      *
007000200529      *           higher level.                                       *
007100200529      *                                                               *
007200200529      *****************************************************************
007300200529     FREHISBL   IF   E           K DISK    PREFIX(R_)                                       MD036225
007400200529
007500200529      *****************************************************************
007600200529      ** +--------------------------------------+
007700200529      ** ¦ Automatically included D-specs       ¦
007800200529      ** ¦ ==============================       ¦
007900200529      ** +--------------------------------------+
008000200529      **
008100200529      ** Standard D-specs
008200200529      ** ================
008300200529      **
008400200529      ** The following /COPY line includes the LDA layout,
008500200529      ** the copyright array definition,
008600200529      ** and the following named constants:
008700200529      **    True       logical = *on (for indcator processing)
008800200529      **    False      logical = *off (for indcator processing)
008900200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
009000200529      **                                    handler)
009100200529      ** and the following variables:
009200200529      **    RunBefore  1A (for the PSSR)
009300200529
009400200529     D/COPY ZACPYSRC,STD_D_SPEC
009500200529
009600200529      ** Include the MM standard declares
009700200529     D/COPY ZACPYSRC,STDDECLARE
009800200529
009900200529      ** Program Status Data Structure
010000200529      ** =============================
010100200529      ** The following /COPY line includes all the defined fields in the
010200200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
010300200529
010400200529     D/COPY ZACPYSRC,PSDS
010500200529
010600200529      ** +--------------------------------------+
010700200529      ** ¦ End of automatically included D-specs¦
010800200529      ** ¦ =====================================¦
010900200529      ** +--------------------------------------+
011000200529
011100200529      *****************************************************************
011200200529      /EJECT
011300200529      *****************************************************************
011400200529
011500200529      ** +--------------------------------------+
011600200529      ** ¦ Manually included D-specs            ¦
011700200529      ** ¦ =========================            ¦
011800200529      ** +--------------------------------------+
011900200529
012000200529      ** +--------------------------------------+
012100200529      ** ¦ Arrays and Data Structures           ¦
012200200529      ** ¦ ==========================           ¦
012300200529      ** +--------------------------------------+
012400200529
012500200529      ** External data structure for access programs (short)
012600200529     D DSFDY         E DS                  EXTNAME(DSFDY)
012700200529     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
012800200529     D DSSDY         E DS                  EXTNAME(DSSDY)
012900200529      ** External data structure for Account Details file                                   MD036225
013000200529     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                 MD036225
013100200529
013200200529      ** External data structure for book codes file
013300200529     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
013400200529      ** EXTERNAL DS FOR BANK DETAILS                                                         240486
013500200529     D SDBANK        E DS                  EXTNAME(SDBANKPD) PREFIX(XX:2)                     240486
013600200529     D P@ACSQ          DS                                                                   MD036225
013700200529      * Account sequence key character->numeric conversion data structure                   MD036225
013800200529     D  W@ACSQ                 1      2  0                                                  MD036225
013900200529     D P@RETL          DS                                                                   MD036225
014000200529      * Retail account character->numeric conversion data structure                         MD036225
014100200529     D  W@RETL                 1     10  0                                                  MD036225
014200200529
014300200529      ** +--------------------------------------+
014400200529      ** ¦ Named constants                      ¦
014500200529      ** ¦ ===============                      ¦
014600200529      ** +--------------------------------------+
014700200529
014800200529     D ZAVDATE         C                   CONST('ZAVDATE')
014900200529      ** +--------------------------------------+
015000200529      ** ¦ Declared variables                   ¦
015100200529      ** ¦ ==================                   ¦
015200200529      ** +--------------------------------------+
015300200529
015400200529     D @KEYC           S             10A                                                      CGL029
015500200529     D @VDYNO          S              5P 0
015600200529     D BJDFIN          S              1A
015700200529     D BJLCCY          S              3A
015800200529     D BJRDNB          S              5P 0
015900200529     D BJSLCD          S              3A
016000200529     D DDCCY           S              3A
016100200529     D DDTYPE          S              2A
016200200529     D DDVDAT          S              6A
016300200529      ** Error message code 1 received as a parameter
016400200529     D Msgid1          S                   LIKE(#MsgID)
016500200529     D WMsgid1         S                   LIKE(#MsgID)
016600200529     D WMsgid2         S                   LIKE(#MsgID)
016700200529
016800200529      ** Deal file version of value date
016900200529     D IKDVSD          S                   LIKE(@VDYNO)
017000200529
017100200529      ** Deal file version of start/last interest date
017200200529     D IKSLID          S                   LIKE(@VDYNO)
017300200529     D PMERCD          S            150A
017400200529     D***PMPONS*         S             12A                                                    CGL029
017500200529     D PMPONS          S             18A                                                      CGL029
017600200529     D PMPSTM          S              2S 0
017700200529     D***PMRONS*         S             12A                                                    CGL029
017800200529     D PMRONS          S             18A                                                      CGL029
017900200529     D PMRSTM          S              2S 0
018000200529     D @DAT            S              6P 0                                                    240486
018100200529     D @RTCDE          S              1A                                                      240486
018200200529     D BVDYNO          S                   LIKE(BJRDNB)                                       240486
018300200529     D DDACTN          S              1A                                                      249967
018400200529
018500200529      ** Location code for holiday checking
018600200529     D ZLOC            S              3A
018700200529
018800200529      ** Holiday indicator
018900200529     D ZIND            S              1A
019000200529                                                                                CDL006
019100200529     D CDL006          S              1A   IMPORT                               CDL006
019200200529
019300200529      ** +--------------------------------------+
019400200529      ** ¦ End of D-specs                       ¦
019500200529      ** ¦ ==============                       ¦
019600200529      ** +--------------------------------------+
019700200529      *****************************************************************
019800200529      /EJECT
019900200529      *****************************************************************
020000200529
020100200529     C
020200200529      ** +--- Start of Main processing -----------------------------------+
020300200529      ** ¦                                                                ¦
020400200529      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
020500200529      ** ¦ executed at program activation.                                ¦
020600200529      ** ¦                                                                ¦
020700200529      ** +----------------------------------------------------------------+
020800200529
020900200529      ** Reset the error flag to prevent problems on subsequent calls
021000200529     C                   RESET                   ErrorFound
021100200529     C                   RESET                   WarnFound
021200200529     C                   RESET                   Msgid1
021300200529     C                   MOVEL     'N'           RETACC            1                        MD036225
021400200529     C                   MOVEL     *BLANKS       P@RETL                                     MD036225
021500200529     C                   Z-ADD     0             W@RETL                                     MD036225
021600200529     C                   Z-ADD     0             RHISD                                      MD036225
021700200529     C                   MOVEL     *BLANKS       P@CNUM                                     MD036225
021800200529     C                   MOVEL     *BLANKS       P@CUCD                                     MD036225
021900200529     C                   MOVEL     *BLANKS       P@ACCD                                     MD036225
022000200529     C                   MOVEL     *BLANKS       P@ACSQ                                     MD036225
022100200529     C                   MOVEL     *BLANKS       P@BRCA                                     MD036225
022200200529     C                   MOVEL     *BLANKS       BRCA                                       MD036225
022300200529     C****               Z-ADD     0             CNUM                                       MD036225
022400200529     C                   MOVEL     *BLANKS       CNUM                                       MD036225
022500200529     C                   MOVEL     *BLANKS       CCY                                        MD036225
022600200529     C                   Z-ADD     0             ACOD                                       MD036225
022700200529     C                   Z-ADD     0             ACSQ                                       MD036225
022800200529      *                                                                                     MD036225
022900200529      ** Define KLIST to access REHISDL                                                     MD036225
023000200529      *                                                                                     MD036225
023100200529     C     KREHIS        KLIST                                                              MD036225
023200200529     C                   KFLD                    BRCA                                       MD036225
023300200529     C                   KFLD                    CNUM                                       MD036225
023400200529     C                   KFLD                    CCY                                        MD036225
023500200529     C                   KFLD                    ACOD                                       MD036225
023600200529     C                   KFLD                    ACSQ                                       MD036225
023700200529      *                                                                                     MD036225
023800200529
023900200529      **  The field must be entered.
024000200529     C     DDVDAT        IFEQ      *BLANKS
024100200529     C                   EVAL      ErrorFound = 'Y'
024200200529     C                   MOVEL     'MMM0123'     Msgid1
024300200529     C*
024400200529     C**  Validate that the value date is a valid date.
024500200529     C                   ELSE
024600200529     C                   RESET                   ReturnCode
024700200529     C                   CALLB     ZAVDATE
024800200529     C                   PARM                    ReturnCode
024900200529     C                   PARM                    DDVdat
025000200529     C                   PARM                    BJDfin
025100200529     C                   PARM                    @Vdyno
025200200529     C*
025300200529     C**  If the return code is 'Error' then the input date is invalid or
025400200529     C**  non-numeric.
025500200529     C     ReturnCode    IFEQ      'Error'
025600200529     C                   EVAL      ErrorFound = 'Y'
025700200529     C                   MOVEL     'MMM0125'     Msgid1
025800200529     C*
025900200529     C**  If the date is valid, carry out further validation.
026000200529     C                   ELSE
026100200529     C*
026200200529      *                                                                                       240486
026300200529      **  Get the day number format of the value date into @VDYNO                             240486
026400200529      *                                                                                       240486
026500200529     C                   MOVE      DDVDAT        @DAT                                         240486
026600200529     C                   CALLB     'ZA0270'                                                   240486
026700200529     C                   PARM                    @DAT                                         240486
026800200529     C                   PARM                    BJDFIN                                       240486
026900200529     C                   PARM                    @RTCDE                                       240486
027000200529     C                   PARM                    @VDYNO                                       240486
027100200529      *                                                                                       240486
027200200529      ** Access Bank details via access program                                               240486
027300200529      *                                                                                       240486
027400200529     C                   CALLB     'AOBANKR0'                                                 240486
027500200529     C                   PARM      '*DBERR '     @RTCD             7                          240486
027600200529     C                   PARM      '*FIRST '     @OPTN             7                          240486
027700200529     C     SDBANK        PARM      SDBANK        DSFDY                                        240486
027800200529      *                                                                                       240486
027900200529      ** Check if value date is within back-value period                                      240486
028000200529      *                                                                                       240486
028100200529     C                   EVAL      BVDYNO = BJRDNB - XXBVPD                                   240486
028200200529     C     PMRSTM        IFEQ      14                                                       MD036225
028300200529     C     PMRONS        ANDNE     *BLANKS                                                  MD036225
028400200529     C                   MOVEL     PMRONS        P@RETL                                     MD036225
028500200529     C                   EXSR      SRACCT                                                   MD036225
028600200529     C     P@RTCD        IFEQ      *BLANKS                                                  MD036225
028700200529     C                   MOVEL     'Y'           RETACC                                     MD036225
028800200529     C                   Z-ADD     DACO          ACOPDT            5 0                      MD036225
028900200529     C                   EXSR      SREHIS                                                   MD036225
029000200529     C                   ENDIF                                                              MD036225
029100200529     C                   ELSE                                                               MD036225
029200200529     C     PMPSTM        IFEQ      14                                                       MD036225
029300200529     C     PMPONS        ANDNE     *BLANKS                                                  MD036225
029400200529     C                   MOVEL     PMPONS        P@RETL                                     MD036225
029500200529     C                   EXSR      SRACCT                                                   MD036225
029600200529     C     P@RTCD        IFEQ      *BLANKS                                                  MD036225
029700200529     C                   MOVEL     'Y'           RETACC                                     MD036225
029800200529     C                   Z-ADD     DACO          ACOPDT                                     MD036225
029900200529     C                   EXSR      SREHIS                                                   MD036225
030000200529     C                   ENDIF                                                              MD036225
030100200529     C                   ENDIF                                                              MD036225
030200200529     C                   ENDIF                                                              MD036225
030300200529     C**********         IF        @VDYNO  < BVDYNO                                  240486 MD036225
030400200529     C**********                   AND DDACTN = 'I'                                           240486
030500200529     C**********         EVAL      ErrorFound = 'Y'                                  240486 MD036225
030600200529     C**********         EVAL      WarnFound  = 'Y'                                  240486 MD036225
030700200529     C**********         MOVEL     'MMM2625'     Msgid1                              240486 MD036225
030800200529     C**********         ENDIF                                                       240486 MD036225
030900200529      *                                                                                       240486
031000200529     C**  If the date is not a working day in the deal currency and the
031100200529     C****receive*method*is*01,07,08,*and*the*deal*type*is*IT,CD,CI or******    CDL006
031200200529     C****TD,*this*is*an*error.*********************************************    CDL006
031300200529      ** receive method is 01,07,08, and the deal type is IT,CD,CI,TD,          CDL006
031400200529      ** DT,LT, or FT, this is an error.                                        CDL006
031500200529
031600200529      ** NOTE: the deal type check here is only applicable for Loans,
031700200529      ** Deposits and Negotiable Assets Issued.  To allow this module
031800200529      ** to be used for other types of Money Market transaction, a check
031900200529      ** on the TransType parameter is now included below.  This is
032000200529      ** slightly messy, but keeps the disruption of the code to a
032100200529      ** minimum.
032200200529     C     DDTYPE        IFEQ      'IT'
032300200529     C     DDTYPE        OREQ      'CD'
032400200529     C     DDTYPE        OREQ      'CI'
032500200529     C     DDTYPE        OREQ      'TD'
032600200529     C     DDTYPE        OREQ      'DT'                                         CDL006
032700200529     C     CDL006        ANDEQ     'Y'                                          CDL006
032800200529     C     DDTYPE        OREQ      'LT'                                         CDL006
032900200529     C     CDL006        ANDEQ     'Y'                                          CDL006
033000200529     C     DDTYPE        OREQ      'FT'                                         CDL006
033100200529     C     CDL006        ANDEQ     'Y'                                          CDL006
033200200529     C     TransType     ORNE      'LDNI'
033300200529
033400200529     C     PMRSTM        IFEQ      01
033500200529     C     PMRSTM        OREQ      07
033600200529     C     PMRSTM        OREQ      08
033700200529     C*
033800200529     C**  Find whether the date is a holiday in the deal currency
033900200529     C**  at the receive nostro location.
034000200529     C**  First find receive nostro location.
034100200529      *  (database error handling done in access program)
034200200529     C* IF ERRORS OUTSTANDING IN SETTL.DETAILS, DON'T CALL ACCESS OBJ
034300200529     C*
034400200529                                                                                             BUG4828
034500200529      ** Make sure that the 1st 2 character of PMRONS is numeric before                      BUG4828
034600200529      ** calling AONOSTR0                                                                    BUG4828
034700200529                                                                                             BUG4828
034800200529     C                   MOVEL     PMRONS        @KEYE                                       BUG4828
034900200529     C                   TESTN                   @KEYE                05                     BUG4828
035000200529                                                                                             BUG4828
035100200529     C     PMERCD        IFEQ      *BLANKS
035200200529     C     *IN05         ANDEQ     *ON                                                       BUG4828
035300200529     C*
035400200529     C                   CALLB     'AONOSTR0'
035500200529     C*******            PARM      '*DBERR '     @RTCD             7                          245491
035600200529     C                   PARM      *BLANKS       @RTCD             7                          245491
035700200529     C                   PARM      '*KEY   '     @OPTN             7
035800200529     C                   PARM      *BLANKS       @KEYA             6
035900200529     C                   PARM      DDCCY         @KEYB             3
036000200529     C**********         PARM      *BLANKS       @KEYC             4                          CGL029
036100200529     C                   PARM      *BLANKS       @KEYC                                        CGL029
036200200529     C                   PARM      *BLANKS       @KEYD             2
036300200529     C                   PARM      PMRONS        @KEYE             2
036400200529     C                   PARM      *BLANKS       @KEYF             3
036500200529     C                   PARM      *BLANKS       @KEYG            10
036600200529     C                   PARM      *BLANKS       @KEYH             1
036700200529     C     SDNOST        PARM      SDNOST        DSFDY
036800200529     C*
036900200529     C     @RTCD         IFEQ      *BLANKS                                                    245491
037000200529     C                   MOVE      A7NOSN        ZLOC
037100200529     C                   ELSE                                                                 245491
037200200529     C                   MOVE      *BLANKS       ZLOC                                         245491
037300200529     C                   END                                                                  245491
037400200529     C*
037500200529      *                                                                                     MD036225
037600200529      ** Check if settlement is retail only if RETACC='N'                                   MD036225
037700200529      *                                                                                     MD036225
037800200529     C     RETACC        IFEQ      'N'                                                      MD036225
037900200529     C                   MOVE      A7CUST        P@CNUM                                     MD036225
038000200529     C                   MOVE      A7CYCD        P@CUCD                                     MD036225
038100200529     C                   MOVE      A7ACCD        P@ACCD                                     MD036225
038200200529     C                   Z-ADD     A7ACSN        W@ACSQ                                     MD036225
038300200529     C                   MOVE      A7BRCD        P@BRCA                                     MD036225
038400200529      *                                                                                     MD036225
038500200529     C                   EXSR      SRACCT                                                   MD036225
038600200529      *                                                                                     MD036225
038700200529     C     P@RTCD        IFEQ      *BLANKS                                                  MD036225
038800200529     C     P@RETL        IFNE      *BLANKS                                                  MD036225
038900200529     C                   MOVEL     'Y'           RETACC                                     MD036225
039000200529     C                   EXSR      SREHIS                                                   MD036225
039100200529     C                   ENDIF                                                              MD036225
039200200529     C                   Z-ADD     DACO          ACOPDT                                     MD036225
039300200529     C                   ENDIF                                                              MD036225
039400200529      *                                                                                     MD036225
039500200529     C                   ENDIF                                                              MD036225
039600200529     C                   ELSE
039700200529     C                   MOVE      *BLANKS       ZLOC
039800200529     C                   END
039900200529     C
040000200529     C*
040100200529     C                   CALLB     'ZCHKH'
040200200529     C                   PARM                    @VDYNO
040300200529     C                   PARM                    DDCCY
040400200529     C                   PARM                    ZLOC
040500200529     C                   PARM                    ZIND
040600200529     C*
040700200529     C**  If ZIND = 'H' then the date is a holiday.
040800200529     C     ZIND          IFEQ      'H'
040900200529     C                   EVAL      WarnFound    = 'Y'
041000200529     C                   MOVEL     'MMM0129'     WMsgid1
041100200529     C                   END
041200200529     C                   END
041300200529     C*
041400200529     C**  If the date is not a working day in the deal currency and the
041500200529     C**  pay method is 01,07,08, and the deal type is not IT,CD,CI or
041600200529     C**  TD, this is an error.
041700200529     C                   ELSE
041800200529     C     PMPSTM        IFEQ      01
041900200529     C     PMPSTM        OREQ      07
042000200529     C     PMPSTM        OREQ      08
042100200529     C*
042200200529     C**  Find whether the date is a holiday in the deal currency
042300200529     C**  at the pay nostro location.
042400200529     C**  First find pay nostro location.
042500200529      *  (database error handling done in access program)
042600200529     C* IF ERRORS OUTSTANDING IN SETTL.DETAILS, DON'T CALL ACCESS OBJ
042700200529     C*
042800200529                                                                                             BUG4828
042900200529      ** Make sure that the 1st 2 character of PMRONS is numeric before                      BUG4828
043000200529      ** calling AONOSTR0                                                                    BUG4828
043100200529                                                                                             BUG4828
043200200529     C                   MOVEL     PMPONS        @KEYE                                       BUG4828
043300200529     C                   TESTN                   @KEYE                05                     BUG4828
043400200529                                                                                             BUG4828
043500200529     C     PMERCD        IFEQ      *BLANKS
043600200529     C     *IN05         ANDEQ     *ON                                                       BUG4828
043700200529     C*
043800200529     C                   CALLB     'AONOSTR0'
043900200529     C*******            PARM      '*DBERR '     @RTCD             7                          245491
044000200529     C                   PARM      *BLANKS       @RTCD             7                          245491
044100200529     C                   PARM      '*KEY   '     @OPTN             7
044200200529     C                   PARM      *BLANKS       @KEYA             6
044300200529     C                   PARM      DDCCY         @KEYB             3
044400200529     C**********         PARM      *BLANKS       @KEYC             4                          CGL029
044500200529     C                   PARM      *BLANKS       @KEYC                                        CGL029
044600200529     C                   PARM      *BLANKS       @KEYD             2
044700200529     C                   PARM      PMPONS        @KEYE             2
044800200529     C                   PARM      *BLANKS       @KEYF
044900200529     C                   PARM      *BLANKS       @KEYG
045000200529     C                   PARM      *BLANKS       @KEYH
045100200529     C     SDNOST        PARM      SDNOST        DSFDY
045200200529     C*
045300200529     C     @RTCD         IFEQ      *BLANKS                                                    245491
045400200529     C                   MOVE      A7NOSN        ZLOC
045500200529     C                   ELSE                                                                 245491
045600200529     C                   MOVE      *BLANKS       ZLOC                                         245491
045700200529     C                   END                                                                  245491
045800200529     C*
045900200529      *                                                                                     MD036225
046000200529      ** Check if settlement is retail only if RETACC='N'                                   MD036225
046100200529      *                                                                                     MD036225
046200200529     C     RETACC        IFEQ      'N'                                                      MD036225
046300200529     C                   MOVEL     A7CUST        P@CNUM                                     MD036225
046400200529     C                   MOVEL     A7CYCD        P@CUCD                                     MD036225
046500200529     C                   MOVEL     A7ACCD        P@ACCD                                     MD036225
046600200529     C                   Z-ADD     A7ACSN        W@ACSQ                                     MD036225
046700200529     C                   MOVEL     A7BRCD        P@BRCA                                     MD036225
046800200529      *                                                                                     MD036225
046900200529     C                   EXSR      SRACCT                                                   MD036225
047000200529      *                                                                                     MD036225
047100200529     C     P@RTCD        IFEQ      *BLANKS                                                  MD036225
047200200529     C     P@RETL        IFNE      *BLANKS                                                  MD036225
047300200529     C                   MOVEL     'Y'           RETACC                                     MD036225
047400200529     C                   EXSR      SREHIS                                                   MD036225
047500200529     C                   ENDIF                                                              MD036225
047600200529     C                   Z-ADD     DACO          ACOPDT                                     MD036225
047700200529     C                   ENDIF                                                              MD036225
047800200529      *                                                                                     MD036225
047900200529     C                   ENDIF                                                              MD036225
048000200529     C                   ELSE
048100200529     C                   MOVE      *BLANKS       ZLOC
048200200529     C                   END
048300200529     C*
048400200529     C                   CALLB     'ZCHKH'
048500200529     C                   PARM                    @VDYNO
048600200529     C                   PARM                    DDCCY
048700200529     C                   PARM                    ZLOC
048800200529     C                   PARM                    ZIND
048900200529     C*
049000200529     C*
049100200529     C**  If ZIND = 'H' then the date is a holiday.
049200200529     C     ZIND          IFEQ      'H'
049300200529     C                   EVAL      WarnFound    = 'Y'
049400200529     C                   MOVEL     'MMM0129'     WMsgid1
049500200529     C                   END
049600200529     C                   END
049700200529     C                   END
049800200529      *                                                                                     MD036225
049900200529      ** Check if value date is within back-value period & retail.                          MD036225
050000200529      ** If backvalue period is 999 it means *NOMAX and value date                          MD036225
050100200529      ** can be beyond backvalue period but >= earliest retail history.                     MD036225
050200200529      *                                                                                     MD036225
050300200529     C     RETACC        IFEQ      'Y'                                                      MD036225
050400200529      *                                                                                     MD036225
050500200529     C     XXBVPD        IFNE      999                                                      MD036225
050600200529     C     @VDYNO        ANDLT     BVDYNO                                                   MD036225
050700200529      *                                                                                     MD036225
050800200529     C                   EVAL      ErrorFound = 'Y'                                         MD036225
050900200529     C                   EVAL      WarnFound  = 'Y'                                         MD036225
051000200529     C                   MOVEL     'MMM2625'     Msgid1                                     MD036225
051100200529      *                                                                                     MD036225
051200200529     C                   ELSE                                                               MD036225
051300200529      *                                                                                     MD036225
051400200529     C     XXBVPD        IFEQ      999                                                      MD036225
051500200529     C     @VDYNO        ANDLT     RHISD                                                    MD036225
051600200529     C     XXBVPD        ORNE      999                                                      MD036225
051700200529     C     @VDYNO        ANDLT     RHISD                                                    MD036225
051800200529     C                   EVAL      ErrorFound = 'Y'                                         MD036225
051900200529     C                   EVAL      WarnFound  = 'Y'                                         MD036225
052000200529     C                   MOVEL     'MMM2627'     Msgid1                                     MD036225
052100200529     C                   ENDIF                                                              MD036225
052200200529     C                   ENDIF                                                              MD036225
052300200529      *                                                                                     MD036225
052400200529     C                   ENDIF                                                              MD036225
052500200529      *                                                                                     MD036225
052600200529      ** Issue a warning message if *NOMAX (999) and before backvalue                       MD036225
052700200529      ** period for retail. For non-retail issue a warning if before                        MD036225
052800200529      ** backvalue period.                                                                  MD036225
052900200529      *                                                                                     MD036225
053000200529     C     RETACC        IFEQ      'Y'                                                      MD036225
053100200529     C     XXBVPD        ANDEQ     999                                                      MD036225
053200200529     C     @VDYNO        ANDLT     BVDYNO                                                   MD036225
053300200529     C     RETACC        OREQ      'N'                                                      MD036225
053400200529     C     @VDYNO        ANDLT     BVDYNO                                                   MD036225
053500200529     C                   EVAL      WarnFound  = 'Y'                                         MD036225
053600200529     C                   MOVEL     'MMM2626'     WMSGid1                                    MD036225
053700200529     C                   ENDIF                                                              MD036225
053800200529     C*
053900200529     C**  Find whether the date is a holiday in the local currency.
054000200529     C*
054100200529     C                   CALLB     'ZCHKH'
054200200529     C                   PARM                    @VDYNO
054300200529     C                   PARM                    BJLCCY
054400200529     C                   PARM                    BJSLCD
054500200529     C                   PARM                    ZIND
054600200529     C*
054700200529     C*
054800200529     C**  If settlement method is not 01,07 or 08 and it is
054900200529     C**  not a working day in the local currency, it is an error.
055000200529     C**  (Only if not settled through a nostro)
055100200529     C*
055200200529     C** Maturity date is checked against receive settlement
055300200529     C** instructions only when deal is not a deposit.
055400200529     C*
055500200529     C     DDTYPE        IFNE      'CD'
055600200529     C     DDTYPE        ANDNE     'CI'
055700200529     C     DDTYPE        ANDNE     'TD'
055800200529     C     DDTYPE        ANDNE     'IT'
055900200529     C     CDL006        ANDEQ     'N'                                          CDL006
056000200529     C     DDTYPE        ORNE      'CD'                                         CDL006
056100200529     C     DDTYPE        ANDNE     'CI'                                         CDL006
056200200529     C     DDTYPE        ANDNE     'TD'                                         CDL006
056300200529     C     DDTYPE        ANDNE     'IT'                                         CDL006
056400200529     C     DDTYPE        ANDNE     'DT'                                         CDL006
056500200529     C     DDTYPE        ANDNE     'FT'                                         CDL006
056600200529     C     DDTYPE        ANDNE     'LT'                                         CDL006
056700200529     C     CDL006        ANDEQ     'Y'                                          CDL006
056800200529     C*
056900200529     C     PMRSTM        IFNE      01
057000200529     C     PMRSTM        ANDNE     07
057100200529     C     PMRSTM        ANDNE     08
057200200529     C     PMPSTM        ORNE      01
057300200529     C     PMPSTM        ANDNE     07
057400200529     C     PMPSTM        ANDNE     08
057500200529     C*
057600200529     C**  If ZIND = 'H' then the date is a holiday.
057700200529     C     ZIND          IFEQ      'H'
057800200529     C                   EVAL      WarnFound    = 'Y'
057900200529     C                   MOVEL     'MMM0131'     WMsgid2
058000200529     C                   END
058100200529     C                   END
058200200529     C*
058300200529     C                   END
058400200529     C                   END
058500200529     C                   END
058600200529
058700200529      **  Output value date
058800200529
058900200529     C     ErrorFound    IFEQ      'N'
059000200529     C     ErrorFound    OREQ      'Y'
059100200529     C     WarnFound     ANDEQ     'Y'
059200200529     C                   Z-ADD     @VDYNO        IKDVSD
059300200529     C**********         Z-ADD     @VDYNO        IKSLID                                     BUG12893
059400200529     C                   ELSE
059500200529     C                   Z-ADD     0             IKDVSD
059600200529     C**********         Z-ADD     0             IKSLID                                     BUG12893
059700200529     C                   END
059800200529
059900200529      ** Return code set in /COPY
060000200529     C/COPY ZACPYSRC,SETRETCDE
060100200529
060200200529     C                   RETURN
060300200529
060400200529      *****************************************************************
060500200529      *****************************************************************                     MD036225
060600200529      /EJECT                                                                                MD036225
060700200529      *****************************************************************                     MD036225
060800200529      *                                                               *                     MD036225
060900200529      * SRACCT - Call ACCNTAB access object program                   *                     MD036225
061000200529      *                                                               *                     MD036225
061100200529      * Called by: Main processing                                    *                     MD036225
061200200529      *                                                               *                     MD036225
061300200529      * Calls: None                                                   *                     MD036225
061400200529      *                                                               *                     MD036225
061500200529      *****************************************************************                     MD036225
061600200529      *                                                                                     MD036225
061700200529     C     SRACCT        BEGSR                                                              MD036225
061800200529      *                                                                                     MD036225
061900200529     C                   CALLB     'AOACCTR0'                                               MD036225
062000200529     C                   PARM                    P@RTCD            7                        MD036225
062100200529     C                   PARM      '*KEY   '     P@OPTN            7                        MD036225
062200200529     C                   PARM                    P@RETL           10                        MD036225
062300200529     C                   PARM                    P@CNUM            6                        MD036225
062400200529     C                   PARM                    P@CUCD            3                        MD036225
062500200529     C                   PARM                    P@ACCD           10                        MD036225
062600200529     C                   PARM                    P@ACSQ            2                        MD036225
062700200529     C                   PARM                    P@BRCA            3                        MD036225
062800200529     C     ACCNT         PARM      ACCNT         DSSDY                                      MD036225
062900200529      *                                                                                     MD036225
063000200529     C                   ENDSR                                                              MD036225
063100200529      *                                                                                     MD036225
063200200529      *****************************************************************                     MD036225
063300200529      /EJECT                                                                                MD036225
063400200529      *****************************************************************                     MD036225
063500200529      *                                                               *                     MD036225
063600200529      * SREHIS - Access REHISPD to check earliest retail history      *                     MD036225
063700200529      *                                                               *                     MD036225
063800200529      * Called by: Main processing                                    *                     MD036225
063900200529      *                                                               *                     MD036225
064000200529      * Calls: None                                                   *                     MD036225
064100200529      *                                                               *                     MD036225
064200200529      *****************************************************************                     MD036225
064300200529      *                                                                                     MD036225
064400200529     C     SREHIS        BEGSR                                                              MD036225
064500200529      *                                                                                     MD036225
064600200529     C     KREHIS        CHAIN     REHISBL                            01                    MD036255
064700200529      *                                                                                     MD036225
064800200529     C     *IN01         IFEQ      '0'                                                      MD036225
064900200529     C                   Z-ADD     R_HISD        RHISD             5 0                      MD036225
065000200529     C                   ELSE                                                               MD036225
065100200529     C                   Z-ADD     0             RHISD                                      MD036225
065200200529     C                   ENDIF                                                              MD036225
065300200529      *                                                                                     MD036225
065400200529     C                   ENDSR                                                              MD036225
065500200529      *                                                                                     MD036225
065600200529      /EJECT
065700200529      *****************************************************************
065800200529      *                                                               *
065900200529      * *INZSR - Program Initialisation routine                       *
066000200529      *                                                               *
066100200529      * Called by: Main processing                                    *
066200200529      *                                                               *
066300200529      * Calls: None                                                   *
066400200529      *                                                               *
066500200529      *****************************************************************
066600200529
066700200529     C     *INZSR        BEGSR
066800200529
066900200529     C     *entry        PLIST
067000200529     C                   PARM                    ReturnCode
067100200529     C                   PARM                    Msgid1
067200200529     C                   PARM                    WMsgid1
067300200529     C                   PARM                    WMsgid2
067400200529     C                   PARM                    IKDVSD
067500200529     C                   PARM                    IKSLID
067600200529     C                   PARM                    BJDFIN
067700200529     C                   PARM                    BJLCCY
067800200529     C                   PARM                    BJRDNB
067900200529     C                   PARM                    BJSLCD
068000200529     C                   PARM                    DDCCY
068100200529     C                   PARM                    DDTYPE
068200200529     C                   PARM                    DDVDAT
068300200529     C                   PARM                    PMERCD
068400200529     C                   PARM                    PMPONS
068500200529     C                   PARM                    PMPSTM
068600200529     C                   PARM                    PMRONS
068700200529     C                   PARM                    PMRSTM
068800200529      ** Transaction type (4A, from caller)
068900200529     C                   PARM                    TransType
069000200529     C                   PARM                    DDACTN                                       249967
069100200529
069200200529      ** Program, module and procedure names for database error processing.
069300200529      ** =================================================================
069400200529      ** The following /COPY sets these values, and also defines LDA as
069500200529      ** an external data area
069600200529
069700200529     C/COPY ZACPYSRC,DBFIELDS
069800200529
069900200529     C                   ENDSR                                                  *** InzEnd ***
070000200529
070100200529      *****************************************************************
070200200529      /EJECT
070300200529      ********************************************************************
070400200529     C/COPY ZACPYSRC,PSSR_ILE
070500200529      ********************************************************************
070600200529**  CPY@
070700200529(c) Finastra International Limited 2001
