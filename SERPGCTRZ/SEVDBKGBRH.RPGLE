000100200604     H DEBUG
000200200604     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200604      *****************************************************************
000400200604/*STD *  RPGBASEMOD                                                   *
000500200604/*EXI *  TEXT('Midas SE Validate Booking Branch Code')
000600200604      *****************************************************************
000700200604      *                                                               *
000800200604      *  Midas - Security Trading Module                              *
000900200604      *                                                               *
001000200604      *  SEVDBKGBRH - Validate Booking Brancd Code field.             *
001100200604      *                                                               *
001200200604      *  Function:  This module performs the validation for the       *
001300200604      *             Booking Branch Code field.                        *
001400200604      *                                                               *
001500200604      *  This module is an ILE/RPG IV conversion of the validation    *
001600200604      *  routine for the said field. This routine has been retrieved  *
001700200604      *  from SE0070 and has been converted to ILE RPG and copied into*
001800200604      *  this member.  Necessary code to make this compileable has    *
001900200604      *  been added (entry and exit points and some declares).        *
002000200604      *                                                               *
002100200604      *  Component of: SE0070 (Depot Movements Maintenance)           *
002200200604      *                                                               *
002300200604      *  (c) Finastra International Limited 2001                      *
002400200604      *                                                               *
002500200604      *    This source is centrally supported and must ONLY be        *
002600200604      *    amended by Core Development Personnel                      *
002700200604      *                                                               *
002800200604      *    /COPY, Client or Country amendments must not be            *
002900200604      *    applied to this source.                                    *
003000200604      *                                                               *
003100200604      *  Last Amend No. 259591             Date 22May20               *
003200200604      *  Prev Amend No. MD046248           Date 27Oct17               *
003300200604      * Bank Fusion Midas 1.4 Base -----------------------------------*
003400200604      * Midas Plus 1.4 Base 04 ---------------------------------------*
003500200604      * Midas Plus 1.4 Base ------------------------------------------*
003600200604      * Midas Plus 1.3 ----------- Base ------------------------------*
003700200604      *                 CSD031             Date 10Apr06               *
003800200604      *                 CSD027             Date 09Dec05               *
003900200604      *                 CGL029             Date 01Sep03               *
004000200604      * Midas Release 4 --------------- Base -------------------------*
004100200604      * Midas DBA 3.00 ---------------- Base -------------------------*
004200200604      *                 CAP003  *CREATE    Date 22Apr98               *
004300200604      *                                    Date DDMmmYY               *
004400200604      *                                                               *
004500200604      *---------------------------------------------------------------*
004600200604      *                                                               *
004700200604      *  259591 - From the Depot Walk In/Out, users intermittently    *
004800200604      *           encounter booking branch validation error message.  *
004900200604      *  MD046248 - Finastra Rebranding                               *
005000200604      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
005100200604      *  CSD027 - Conversion Of Customer Number to Alpha              *
005200200604      *  CGL029 - Increase Account Code to 10 digits                  *
005300200604      *  CAP003 - Conversion of SE inputs into modular structure to   *
005400200604      *           use as APIs.                                        *
005500200604      *                                                               *
005600200604      *****************************************************************
005700200604
005800200604      ** +--------------------------------------+
005900200604      ** ¦ F-specs                              ¦
006000200604      ** ¦ =======                              ¦
006100200604      ** +--------------------------------------+
006200200604
006300200604      *****************************************************************
006400200604      ** +--------------------------------------+
006500200604      ** ¦ Automatically included D-specs       ¦
006600200604      ** ¦ ==============================       ¦
006700200604      ** +--------------------------------------+
006800200604      **
006900200604      **--------------------------------------------------------------------------------------------
007000200604      ** The following /COPY line includes (among others) the LDA layout
007100200604      ** and the copyright array definition:
007200200604     D/COPY ZACPYSRC,STD_D_SPEC
007300200604      **--------------------------------------------------------------------------------------------
007400200604
007500200604      **--------------------------------------------------------------------------------------------
007600200604      ** The following /COPY includes the MM standard declares:
007700200604     D/COPY ZACPYSRC,STDDECLARE
007800200604      **--------------------------------------------------------------------------------------------
007900200604
008000200604      **--------------------------------------------------------------------------------------------
008100200604      ** The following /COPY line includes all the defined fields in the
008200200604      ** Program Status Data Structures.  They have meaningful
008300200604      ** names, prefixed by 'PS'.
008400200604     D/COPY ZACPYSRC,PSDS
008500200604      **--------------------------------------------------------------------------------------------
008600200604
008700200604      ** +--------------------------------------+
008800200604      ** ¦ End of automatically included D-specs¦
008900200604      ** ¦ =====================================¦
009000200604      ** +--------------------------------------+
009100200604
009200200604      *****************************************************************
009300200604      /EJECT
009400200604      *****************************************************************
009500200604
009600200604      ** +--------------------------------------+
009700200604      ** ¦ Manually included D-specs            ¦
009800200604      ** ¦ =========================            ¦
009900200604      ** +--------------------------------------+
010000200604
010100200604
010200200604      ** +--------------------------------------+
010300200604      ** ¦ Named constants                      ¦
010400200604      ** ¦ ===============                      ¦
010500200604      ** +--------------------------------------+
010600200604
010700200604      ** The maximum size of the appended error arrays
010800200604     D XArrayMax       C                   CONST(20)
010900200604
011000200604      ** +--------------------------------------+
011100200604      ** ¦ Arrays and Data Structures           ¦
011200200604      ** ¦ ==========================           ¦
011300200604      ** +--------------------------------------+
011400200604
011500200604      ** Array of Fields in error.
011600200604      ** Array of error message IDs
011700200604      ** Array of error message data.
011800200604     D FldNamXAr       S             10A   DIM(XArrayMax)
011900200604     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
012000200604     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
012100200604
012200200604      ** Branch Details Data Structure
012300200604      ** DS used for Access Objects pgm
012400200604     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
012500200604     D DSFDY         E DS                  EXTNAME(DSFDY)
012600200604
012700200604
012800200604
012900200604      ** +--------------------------------------+
013000200604      ** ¦ Declared variables                   ¦
013100200604      ** ¦ ==================                   ¦
013200200604      ** +--------------------------------------+
013300200604
013400200604
013500200604     ** Input field(s)
013600200604     ** --------------
013700200604
013800200604      ** Screen Field(s)
013900200604     D  DDDPBA         S              3A
014000200604
014100200604      ** ICD
014200200604      ** System Details
014300200604
014400200604     D  MBIN           S              1A
014500200604     D  USRBCH         S              3A
014600200604
014700200604      ** Output field(s)
014800200604      ** ---------------
014900200604
015000200604     D DDDPBAOk        S              1A
015100200604     D DPBA            S              3A
015200200604
015300200604      ** Working Variables
015400200604      ** -----------------
015500200604
015600200604     D @DSNB           S              3A
015700200604     D @ERR            S              1P 0
015800200604     D @ZBR            S              3A
015900200604
016000200604      ** Index for arrays of error message ids etc
016100200604     D Idx             S              3P 0
016200200604      *                                                                                       CGL029
016300200604     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
016400200604      *                                                                                       CGL029
016500200604
016600200604      ** +--------------------------------------+
016700200604      ** ¦ End of D-specs                       ¦
016800200604      ** ¦ ==============                       ¦
016900200604      ** +--------------------------------------+
017000200604      *****************************************************************
017100200604      /EJECT
017200200604      *****************************************************************
017300200604
017400200604
017500200604      ** +--- Start of Main processing -----------------------------------+
017600200604      ** ¦                                                                ¦
017700200604      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
017800200604      ** ¦ executed at program activation.                                ¦
017900200604      ** ¦                                                                ¦
018000200604      ** +----------------------------------------------------------------+
018100200604      *
018200200604      ** Initialization
018300200604      *
018400200604     C                   MOVE      *BLANK        RetCodeIn
018500200604
018600200604     C                   MOVE      *BLANK        FldNamXAr
018700200604     C                   MOVE      *BLANK        MsgIDXAr
018800200604     C                   MOVE      *BLANK        MsgDtaXAr
018900200604     C                   Z-ADD     0             Idx
019000200604
019100200604     C                   MOVE      *Blanks       DPBA
019200200604      *
019300200604      ** Validation
019400200604      *
019500200604     C                   EXSR      DPBAV
019600200604      *
019700200604      ** If an error was found, set the return code appropriately
019800200604      *
019900200604     C     DDDPBAOK      IFEQ      'N'
020000200604     C                   EVAL      RetCodeIn = 'Error'
020100200604     C                   ENDIF
020200200604      *
020300200604      * Return
020400200604      *
020500200604     C                   RETURN
020600200604
020700200604      *****************************************************************
020800200604      /EJECT
020900200604      *****************************************************************
021000200604      *                                                               *
021100200604      * DPBAV - Validation routine for Booking Branch                 *
021200200604      *                                                               *
021300200604      * Called by: MAIN                                               *
021400200604      *                                                               *
021500200604      * Calls: None                                                   *
021600200604      *                                                               *
021700200604      *****************************************************************
021800200604
021900200604     C     DPBAV         BEGSR
022000200604      *
022100200604      ** MultiBranch = ON
022200200604      *
022300200604     C     MBIN          IFEQ      'Y'
022400200604      *
022500200604      ** Booking Branch code
022600200604      *
022700200604     C     DDDPBA        IFNE      '   '
022800200604      *
022900200604      ** must reference an active Branch Code
023000200604      *
023100200604     C**********         CALLB     'AOBRCHR0'                                                 CGL029
023200200604     C                   CALL      'AOBRCHR1'                                                 CGL029
023300200604     C                   PARM      *BLANKS       @RTCD
023400200604     C                   PARM      '*KEY   '     @OPTN
023500200604     C                   PARM      DDDPBA        @DSNB
023600200604     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
023700200604     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
023800200604      *
023900200604      **  Invalid Branch
024000200604      *
024100200604     C     @RTCD         IFNE      *BLANKS
024200200604      *
024300200604      ** Error 212
024400200604      *
024500200604     C                   ADD       1             Idx
024600200604     C                   MOVEL     'DDDPBA'      FldNamXAr(Idx)
024700200604     C                   MOVEL     'MMA0342'     MsgIdXAr(Idx)
024800200604     C                   MOVE      'N'           DDDPBAOK
024900200604     C                   ELSE
025000200604      *
025100200604      ** Update Screen/File
025200200604      *
025300200604     C                   MOVE      A8BRCD        DDDPBA
025400200604     C                   MOVE      A8BRCD        DPBA
025500200604     C                   END
025600200604      *
025700200604      ** Update file
025800200604      *
025900200604
026000200604     C                   ELSE
026100200604      *
026200200604      ** No branch entered
026300200604      ** - Use default branch
026400200604      *
026500200604     C                   MOVE      USRBCH        DPBA
026600200604      *
026700200604      ** Fetch default Branch Internal Customer Number for default branch
026800200604      *
026900200604     C**********         CALLB     'AOBRCHR0'                                                 CGL029
027000200604     C                   CALL      'AOBRCHR1'                                                 CGL029
027100200604     C                   PARM      '*DBERR '     @RTCD
027200200604     C                   PARM      '*KEY   '     @OPTN
027300200604     C                   PARM      DPBA          @DSNB
027400200604     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
027500200604     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
027600200604     C                   END
027700200604      *
027800200604      **  Validate SPF - User's authority to booking branch
027900200604      *
028000200604     C     RespMode      IFEQ      'S'
028100200604
028200200604     C                   CALL      'ZVBBU'
028300200604     C                   PARM      DPBA          @ZBR
028400200604     C                   PARM                    @ERR
028500200604      *
028600200604     C*****@ERR*         IFEQ      2                                                          259591
028700200604     C     @ERR          IFEQ      1                                                          259591
028800200604      *
028900200604      ** Error 307
029000200604      *
029100200604     C                   ADD       1             Idx
029200200604     C                   MOVEL     'DDDPBA'      FldNamXAr(Idx)
029300200604     C                   MOVEL     'MMA0343'     MsgIdXAr(Idx)
029400200604     C                   MOVE      'N'           DDDPBAOK
029500200604     C                   END
029600200604     C*
029700200604     C*****@ERR*         IFEQ      1                                                          259591
029800200604     C     @ERR          IFEQ      2                                                          259591
029900200604      *
030000200604      ** Error 308
030100200604      *
030200200604     C                   ADD       1             Idx
030300200604     C                   MOVEL     'DDDPBA'      FldNamXAr(Idx)
030400200604     C                   MOVEL     'MMA0344'     MsgIdXAr(Idx)
030500200604     C                   MOVE      'N'           DDDPBAOK
030600200604     C                   END
030700200604
030800200604     C                   END
030900200604      *
031000200604      ** Fetch default Branch Internal Customer Number for single branch
031100200604      ** environment.
031200200604      *
031300200604     C                   ELSE
031400200604      *
031500200604      ** - Use default branch
031600200604      *
031700200604     C                   MOVE      USRBCH        DPBA
031800200604      *
031900200604      ** Fetch default Branch Internal Customer Number for default branch
032000200604      *
032100200604     C**********         CALLB     'AOBRCHR0'                                                 CGL029
032200200604     C                   CALL      'AOBRCHR1'                                                 CGL029
032300200604     C                   PARM      '*DBERR '     @RTCD
032400200604     C                   PARM      '*KEY   '     @OPTN
032500200604     C                   PARM      DPBA          @DSNB
032600200604     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
032700200604     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
032800200604
032900200604     C                   END
033000200604
033100200604     C                   ENDSR
033200200604
033300200604      *****************************************************************
033400200604      /EJECT
033500200604      *****************************************************************
033600200604      *                                                               *
033700200604      * *inzsr - Program Initialisation routine                       *
033800200604      *                                                               *
033900200604      * Called by: Implicitly on program activation                   *
034000200604      *                                                               *
034100200604      * Calls: None                                                   *
034200200604      *                                                               *
034300200604      *****************************************************************
034400200604
034500200604     C     *inzsr        BEGSR
034600200604
034700200604     C     *entry        PLIST
034800200604
034900200604      ** Return Error code Indicator
035000200604     C                   PARM                    RetCodeIn
035100200604
035200200604      ** Received parameters
035300200604      ** -------------------
035400200604
035500200604      ** Screen Fields
035600200604      *  Booking Branch Code (3A)
035700200604     C                   PARM                    DDDPBA
035800200604
035900200604      ** System Details
036000200604      *  Multi-Branch Indicator  (1A)
036100200604      *  Default User's Branch (3A)
036200200604      *  Response Mode (1A) (A/S)
036300200604     C                   PARM                    MBIN
036400200604     C                   PARM                    USRBCH
036500200604     C                   PARM                    RespMode          1
036600200604
036700200604      ** Returned parameters
036800200604      ** -------------------
036900200604
037000200604      * Error fields/message IDs/message data (arrays) from/to caller
037100200604
037200200604     C                   PARM                    FldNamXAr
037300200604     C                   PARM                    MsgIDXAr
037400200604     C                   PARM                    MsgDtaXAr
037500200604
037600200604      ** Data structure for the branch details
037700200604     C                   PARM                    SDBRCH
037800200604
037900200604      ** Branch Code Ok Indicator (1A)
038000200604      ** Branch Code (3A)
038100200604     C                   PARM                    DDDPBAOk
038200200604     C                   PARM                    DPBA
038300200604
038400200604
038500200604      **--------------------------------------------------------------------------------------------
038600200604      ** The following /COPY sets the values of program, module and
038700200604      ** procedure names for database error processing.
038800200604     C/COPY ZACPYSRC,DBFIELDS
038900200604      **--------------------------------------------------------------------------------------------
039000200604
039100200604     C                   ENDSR
039200200604
039300200604      *****************************************************************
039400200604      /EJECT
039500200604      *****************************************************************
039600200604      **--------------------------------------------------------------------------------------------
039700200604      ** The following /COPY contains the standard program status
039800200604      ** subroutine, including a bound call to the DBERRCTL module.
039900200604     C/COPY ZACPYSRC,PSSR_ILE
040000200604      **--------------------------------------------------------------------------------------------
040100200604      ********************************************************************
040200200604**  CPY@
040300200604(c) Finastra International Limited 2001
