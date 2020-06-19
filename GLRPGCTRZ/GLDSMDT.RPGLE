000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas GL Default Next Statement Date')                 *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - General Ledger Module                                *
000900200528      *                                                               *
001000200528      *  GLDSMDT    - Default Next Statement Date                     *
001100200528      *                                                               *
001200200528      *  (c) Finastra International Limited 2001                      *
001300200528      *                                                               *
001400200604      *  Last Amend No. 250822             Date 22May20               *
001500200528      *  Prev Amend No. MD046248           Date 27Oct17               *
001600200528      *                 CGL184             Date 07Dec16               *
001700200528      *                 AR702741           Date 02Feb11               *
001800200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
001900200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
002000200528      * Midas Plus 1.4 Base ------------------------------------------*
002100200528      * Midas Plus 1.3 ----------- Base ------------------------------*
002200200528      * Midas Release 4 --------------- Base -------------------------*
002300200528      * Midas DBA 3.05 -----------------------------------------------*
002400200528      *                 180721  *CREATE    Date 03May00               *
002500200528      *                                                               *
002600200528      *---------------------------------------------------------------*
002700200528      *                                                               *
002800200528      *  250822 - Used the day number from ToF and ensure that        *
002900200528      *           ZFREQB2 is called. Applied fix 210058.              *
003000200528      *  210058 - Next Debit Cap Date is still incorrect.             *
003100200528      *  MD046248 - Finastra Rebranding                               *
003200200528      *  CGL184 - New Frequencies for Account Statements              *
003300200528      *  AR702741 - Include location as parameter in ZFREQB to        *
003400200528      *             determine the next settlement date                *
003500200528      *             (Child: AR702742)                                 *
003600200528      *  180721 - Default "Next Statement Date" when opening          *
003700200528      *           Account coming from interface                       *
003800200528      *                                                               *
003900200528      *****************************************************************
004000200528      ** +--------------------------------------+
004100200528      ** ¦ F-specs                              ¦
004200200528      ** ¦ =======                              ¦
004300200528      ** +--------------------------------------+
004400200528      *****************************************************************
004500200528
004600200528      *****************************************************************
004700200528      ** +--------------------------------------+
004800200528      ** ¦ Automatically included D-specs       ¦
004900200528      ** ¦ ==============================       ¦
005000200528      ** +--------------------------------------+
005100200528      **
005200200528      ** Standard D-specs
005300200528      ** ================
005400200528      **
005500200528      ** The following /COPY line includes the LDA layout,
005600200528      ** the copyright array definition,
005700200528      ** and the following named constants:
005800200528      **    True       logical = *on (for indcator processing)
005900200528      **    False      logical = *off (for indcator processing)
006000200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
006100200528      **                                    handler)
006200200528      ** and the following variables:
006300200528      **    RunBefore  1A (for the PSSR)
006400200528
006500200528     D/COPY ZACPYSRC,STD_D_SPEC
006600200528
006700200528      ** Program Status Data Structure
006800200528      ** =============================
006900200528      ** The following /COPY line includes all the defined fields in the
007000200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
007100200528
007200200528     D/COPY ZACPYSRC,PSDS
007300200528
007400200528      ** +--------------------------------------+
007500200528      ** ¦ End of automatically included D-specs¦
007600200528      ** ¦ =====================================¦
007700200528      ** +--------------------------------------+
007800200528
007900200528      *****************************************************************
008000200528      /EJECT
008100200528      *****************************************************************
008200200528
008300200528      ** +--------------------------------------+
008400200528      ** ¦ Manually included D-specs            ¦
008500200528      ** ¦ =========================            ¦
008600200528      ** +--------------------------------------+
008700200528
008800200528      ** +--------------------------------------+
008900200528      ** ¦ Named constants                      ¦
009000200528      ** ¦ ===============                      ¦
009100200528      ** +--------------------------------------+
009200200528
009300200528      ** The maximum size of the appended error arrays
009400200528     D XArrayMax       C                   CONST(20)
009500200528
009600200528      ** +--------------------------------------+
009700200528      ** ¦ Arrays and Data Structures           ¦
009800200528      ** ¦ ==========================           ¦
009900200528      ** +--------------------------------------+
010000200528
010100200528      ** Array of Fields in error.
010200200528     D FldNamXAr       S             10A   DIM(XArrayMax)
010300200528
010400200528      ** Array of error message IDs
010500200528     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
010600200528
010700200528      ** Array of error message data.
010800200528     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
010900200528
011000200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
011100200528      ** EXTERNAL DS FOR BANK DETAILS
011200200528
011300200528     D SDGELR        E DS                  EXTNAME(SDGELRPD)
011400200528      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
011500200528
011600200528      ** +--------------------------------------+
011700200528      ** ¦ Named constants                      ¦
011800200528      ** ¦ ===============                      ¦
011900200528      ** +--------------------------------------+
012000200528
012100200528      ** +--------------------------------------+
012200200528      ** ¦ Declared variables                   ¦
012300200528      ** ¦ ==================                   ¦
012400200528      ** +--------------------------------------+
012500200528
012600200528      ** Index for arrays of error message ids etc
012700200528     D Idx             S              3P 0
012800200528
012900200528      ** +--------------------------------------+
013000200528      ** ¦ End of D-specs                       ¦
013100200528      ** ¦ ==============                       ¦
013200200528      ** +--------------------------------------+
013300200528      *****************************************************************
013400200528      /EJECT
013500200528      *****************************************************************
013600200528     C
013700200528      ** +--- Start of Main processing -----------------------------------+
013800200528      ** ¦                                                                ¦
013900200528      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
014000200528      ** ¦ executed at program activation.                                ¦
014100200528      ** ¦                                                                ¦
014200200528      ** +----------------------------------------------------------------+
014300200528
014400200528      ** Initialization
014500200528
014600200528     C                   Movel     *Blanks       RetCodeIn
014700200528     C                   Movel     *Blanks       FldNamXAr
014800200528     C                   Movel     *Blanks       MsgIDXAr
014900200528     C                   Movel     *Blanks       MsgDtaXAr
015000200528     C                   Z-add     0             Idx
015100200528      *
015200200528     C                   Exsr      SrNStD
015300200528      *
015400200528      ** If an error was found, set the return code appropriately
015500200528      *
015600200528     C     DDNStDOK      IfEq      'N'
015700200528     C                   Eval      RetCodeIn = 'Error'
015800200528     C                   EndIf
015900200528      *
016000200528      ** RETURN
016100200528      *
016200200528     C                   RETURN
016300200528      *****************************************************************
016400200528      /EJECT
016500200528      *****************************************************************
016600200528      *  SrNStD - Default Next Statement Date                         *
016700200528      *****************************************************************
016800200528     C     SrNStD        BEGSR
016900200528
017000200528     C     DDNStD        Ifeq      *Blanks
017100200528
017200200528     C     DDStFq        Ifeq      'D'
017300200528     C     CGL184        Andeq     'N'                                                        CGL184
017400200528     C     DDStFq        Orne      'D'                                                        CGL184
017500200528     C     DDStFq        Andne     'K'                                                        CGL184
017600200528     C     CGL184        Andeq     'Y'
017700200528     C                   Movel     DDNSDN        ZMDAY
017800200528     C                   Else
017900200528     C                   Z-add     *zeros        ZMDAY
018000200528     C                   Endif
018100200528
018200200528     C**********         CallB     'ZFREQB'                                                   210058
018300200528     C                   CallB     'ZFREQB2'                                                  210058
018400200528     C                   Parm      *blanks       RetCodeIn
018500200528     C                   Parm      DDStFq        ZFREQ             1
018600200528     C                   Parm      BJRDNB        ZDAYNO            5 0
018700200528     C                   Parm      DDCcy         ZCCY              3
018800200528     C                   Parm      *BLANKS       ZLOC              3                        AR702741
018900200528     C                   Parm                    ZMDAY             2 0
019000200528     C                   Parm                    BJDFIN
019100200528     C                   Parm      SDGELR        SDGELR
019200200528
019300200528     C     RetCodeIn     Ifeq      *blanks
019400200528     C     ZdayNo        Andne     *zeros
0195002005283676  *
0196002005283677  **   Convert Day Number to Date
0197002005283678 C                   Callb     'ZDATE2'
019800200528     C                   parm                    ZDAYNO
019900200528     C                   parm                    BJDFIN
020000200528     C                   parm                    ZNDATE            6 0
020100200528     C                   parm                    ZADATE            7
020200200528
020300200528     C                   movel     ZNDATE        DDNStd
020400200528     C                   Endif
020500200528
020600200528     C                   Move      *blanks       RetCodeIn
020700200528     C                   Endif
020800200528      *
020900200528     C                   ENDSR
021000200528      *****************************************************************
021100200528      /EJECT
021200200528      *****************************************************************
021300200528      * *INZSR - Program Initialisation routine                       *
021400200528      *****************************************************************
021500200528     C     *INZSR        BEGSR
021600200528
021700200528     C     *Entry        Plist
021800200528      *
021900200528      ** INPUTS
022000200528      *
022100200528      ** Return Code
022200200528     C                   Parm                    RetCodeIn
022300200528      *
022400200528      ** Account Screen fields
022500200528     C                   Parm                    DDCCY             3
022600200528     C                   Parm                    DDSTFQ            1
022700200528     C                   Parm                    DDNSDN            2
022800200528      *
022900200528      ** ICD
023000200528     C                   Parm                    SDBANK
023100200528     C                   Parm                    SDGELR
023200200528     C                   Parm                    CGL184            1                          CGL184
023300200528      *
023400200528      ** OUTPUTS
023500200528      *
023600200528      ** Next Statement Date
023700200528     C                   Parm                    DDNSTD            6
023800200528      *
023900200528      * Error fields/message IDs/message data (arrays) from/to caller
024000200528     C                   Parm                    FldNamXAr
024100200528     C                   Parm                    MsgIDXAr
024200200528     C                   Parm                    MsgDtaXAr
024300200528      *
024400200528      ** Next Statement Date - Ok
024500200528     C                   Parm                    DDNStDOk          1
024600200528      *
024700200528      ** Program, module and procedure names for database error processing.
024800200528      ** =================================================================
024900200528      ** The following /COPY sets these values, and also defines LDA as
025000200528      ** an external data area
025100200528
025200200528     C/COPY ZACPYSRC,DBFIELDS
025300200528
025400200528     C                   ENDSR                                                  *** InzEnd ***
025500200528      *****************************************************************
025600200528      /EJECT
025700200528      ********************************************************************
025800200528     C/COPY ZACPYSRC,PSSR_ILE
025900200528      ********************************************************************
026000200528**  CPY@
026100200528(c) Finastra International Limited 2001
