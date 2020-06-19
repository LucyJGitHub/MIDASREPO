000100200528     H COPYRIGHT('(c) Finastra International Limited 2003')
000200200528      *****************************************************************
000300200528/*STD *  RPGBASEMOD                                                   *
000400200528/*EXI *  TEXT('Midas AP Transaction Retrieve')                        *
000500200528      *****************************************************************
000600200528      *                                                               *
000700200528      *  Midas - Application Programming Interfaces module            *
000800200528      *                                                               *
000900200528      *  APTRANR - Transaction Retrieve                               *
001000200528      *                                                               *
001100200528      *  Function: This module is used to retrieve transaction        *
001200200528      *            details from the Midas database.                   *
001300200528      *                                                               *
001400200528      *  (c) Finastra International Limited 2003                      *
001500200528      *                                                               *
001600200604      *  Last Amend No. 260173             Date 22May20               *
001700200528      *  Prev Amend No. MD054906           Date 15Jan20               *
001800200528      *                 CSD102             Date 08Jan19               *
001900200528      *                 MD052550           Date 07Jan19               *
002000200528      *                 MD044880           Date 15Jan18               *
002100200528      *               . MD046248           Date 27Oct17               *
002200200528      *                 MD039986           Date 10Aug16               *
002300200528      *                 AR1090283          Date 10Aug16               *
002400200528      *                 AR701789           Date 26Sep16               *
002500200528      *                 AR702532           Date 13Jan15               *
002600200528      *                 CAP212             Date 15Sep14               *
002700200528      *                 CGL165             Date 23Feb15               *
002800200528      *                 CGL132             Date 01May13               *
002900200528      *                 CSD092             Date 01Apr13               *
003000200528      *                 CSD093             Date 10Mar14               *
003100200528      *                 AR1086546          Date 18Jun13               *
003200200528      *                 CSW213             Date 03Jun13               *
003300200528      *                 MD000091           Date 03May13               *
003400200528      *                 AR1060863A         Date 06Apr13               *
003500200528      *                 AR804863           Date 07Feb13               *
003600200528      *                 CAP210             Date 28Sep12               *
003700200528      *                 AR1078092          Date 20Jan13               *
003800200528      *                 264044             Date 01Aug12               *
003900200528      *                 CLE134             Date 01Aug12               *
004000200528      *                 AR971184           Date 28May12               *
004100200528      *                 CSF011A            Date 28Nov11               *
004200200528      *                 AR833200           Date 22Sep11               *
004300200528      *                 CSF011             Date 12Sep11               *
004400200528      *                 AR885527           Date 05Jan12               *
004500200528      *                 CBF011             Date 04Jul11               *
004600200528      *                 CLE073             Date 12May08               *
004700200528      *                 CER059             Date 19Jul10               *
004800200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
004900200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
005000200528      *                 BUG14485           Date 31Jul07               *
005100200528      *                 BUG13297A          Date 26Feb07               *
005200200528      * Midas Plus 1.4 Base ------------------------------------------*
005300200528      *                 CSD079             Date 05Feb07               *
005400200528      *                 CRE026             Date 24May06               *
005500200528      * Midas Plus 1.3 ----------- Base ------------------------------*
005600200528      *                 240684             Date 26Jun06               *
005700200528      *                 BUG9009            Date 03Nov05               *
005800200528      *                 BUG9994            Date 19Jan06               *
005900200528      *                 CAP087             Date 23Aug05               *
006000200528      *                 CLE106             Date 01Aug04               *
006100200528      *                 CDL038             Date 10May05               *
006200200528      *                 CSE071             Date 26May05               *
006300200528      *                 CAS011             Date 16May05               *
006400200528      *                 CDL033             Date 10Feb05               *
006500200528      *                 BUG6417            Date 28Mar05               *
006600200528      *                 CDL028             Date 07Feb05               *
006700200528      *                 CGP010             Date 17Jan05               *
006800200528      *                 BUG5671            Date 01Feb05               *
006900200528      *                 BUG5403            Date 10Jan05               *
007000200528      *                 BUG5449            Date 10Jan05               *
007100200528      *                 BUG4646            Date 04Nov04               *
007200200528      *                 BUG3721 (CLE028)   Date 04Aug04               *
007300200528      *                 CDL018             Date 16May04               *
007400200528      *                 BG1105             Date 15Dec03               *
007500200528      *                 BUG19  (CAP084)    Date 26Jan04               *
007600200528      *                 BUG1100            Date 04May04               *
007700200528      *                 BUG1057            Date 04May04               *
007800200528      *                 BUG1055            Date 16Apr04               *
007900200528      *                 CGL029             Date 11Mar04               *
008000200528      *                 CSC021             Date 15Dec03               *
008100200528      *                 CAP084  *CREATE    Date 26Apr02               *
008200200528      *                                                               *
008300200528      *---------------------------------------------------------------*
008400200528      *                                                               *
008500200528      *  260173 - Introduce new parameter in DEAM API to be used in   *
008600200528      *           the validation of action code during reversal       *
008700200528      *           authorization. Apply fix 258724. (Recompile)        *
008800200528      *  MD054906 - CBS-2882 fix extenstion for Principal Change      *
008900200528      *             Schedule                                          *
009000200528      *           - Passed ACTRJ to IRSIRSR and IRCIRSR to match      *
009100200528      *             receiving parameters.                             *
009200200528      *  CSD102 - Password Length Extension                           *
009300200528      *  MD052550 - Missed out line of code during reversal of        *
009400200528      *             fix MD-51830.                                     *
009500200528      *  MD044880 - BOE Switched On Testing and Fixing                *
009600200528      *  MD046248 - Finastra Rebranding                               *
009700200528      *  MD039986 - Additional codes to upgrade AR1090283.            *
009800200528      *  AR1090283 - Customer details not visible for enquire.        *
009900200528      *              (Child: AR1090284)                               *
010000200528      *            - Applied for MD-39986.                            *
010100200528      *  AR701789 - Unable to reject a deal amendment. Add a new      *
010200200528      *             parameter to indicate reject transaction.         *
010300200528      *             Applied for MD041482                              *
010400200528      *  AR702532 - After rejection, there is no WIP record but RSTS  *
010500200528      *             is still 'R'. Pass reject action parameter to     *
010600200528      *             skip validation during rejection to prevent the   *
010700200528      *             error. Applied fix 262574. (Child: AR702533)      *
010800200528      *           - Applied for MD023814                              *
010900200528      *  CAP212 - FT Nostro Transfer API                              *
011000200528      *  CGL165 - Dual Withholding Tax (Recompile)                    *
011100200528      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
011200200528      *           Classification - Master (Recompile)                 *
011300200528      *  CSD092 - Account Review                                      *
011400200528      *  CSW093 - Document Management                                 *
011500200528      *  AR1086546 - Upgrade of CDL025 to MP 1.4 (Child: AR1086547).  *
011600200528      *              Applied for MD021813 (Recompile)                 *
011700200528      *  CSW213 - SWIFT Changes 2013                                  *
011800200528      *  MD000091 - Event Codes Substitution (Recompile)              *
011900200528      *  AR1060863A - Add missing parameter in MMLDNIR                *
012000200528      *             - Applied for AR1097090                           *
012100200528      *  AR804863 - Details are not correctly reverted back when the  *
012200200528      *             amended transaction is rejected in WIP. Pass      *
012300200528      *             reject button to correctly revert back amended    *
012400200528      *             details. (Child: AR804864)                        *
012500200528      *           - Applied for AR910559 (Child: AR910560)            *
012600200528      *  CAP210 - Adjustment to Accrued Interests API                 *
012700200528      *  AR1078092 - Event Code of 45021706 (settlement account is    *
012800200528      *              (blocked) is not user configurable               *
012900200528      *  264044 - CLE134 Test PDCL SOAP API                           *
013000200528      *  CLE134 - Past Due Call Loan Processing                       *
013100200528      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
013200200528      *             Office Id is no more updated in master database   *
013300200528      *             files which provokes some big problems in third   *
013400200528      *             party product such as TOF.(Child:AR971185)        *
013500200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
013600200528      *  AR833200 - Outgoing payment enquiry issue                    *
013700200528      *  CSF011 - Customer Name on Inputs                             *
013800200528      *  AR885527 - Cannot Enquire, Edit, Action any transactions     *
013900200528      *             in FX and MM                                      *
014000200528      *  CBF011 - BF Infrastructure: Error Message Handling           *
014100200528      *           (Recompile)                                         *
014200200528      *  CLE073 - Calculated Loan Based Fees                          *
014300200528      *  CER059 - German Feature Upgrade to Delhi                     *
014400200528      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
014500200528      *  BUG14485 - MidasPlus Definition for CUSD is not in synch     *
014600200528      *             with that of API XML definition (Recompile)       *
014700200528      *  BUG13297A - Add DDPATH field.                                *
014800200528      *  CSD079 - Enhanced Customer Maintenance API                   *
014900200528      *  CRE026 - Consumer Banking                                    *
015000200528      *  240684 - Applied fix BUG9009.                                *
015100200528      *  BUG9009 - Implement CGL037                                   *
015200200528      *  BUG9994 - DPWI/DPWO Enquiry - Details cannot be enquired;    *
015300200528      *            Complete/Delete button disabled                    *
015400200528      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
015500200528      *           TRANSID has increased due to addition of Security   *
015600200528      *           Shortname. Need to extract DDDPSS, DDDPRN and       *
015700200528      *           DDDPMV correctly.                                   *
015800200528      *  CLE106 - Syndications Manager (Recompile)                    *
015900200528      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
016000200528      *  CSE071 - Multiple Holidays Re Securities (Recompile)         *
016100200528      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
016200200528      *  CDL033 - Floating Rate CDs Issued.                           *
016300200528      *  BUG6417- Cash management components are missing in MidasPlus *
016400200528      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
016500200528      *  CGP010 - Global BSPL                                         *
016600200528      *  BUG5671- Add Sequence number to detail record CLS2           *
016700200528      *  BUG5403 - Principle Change Schedule missing in CACF          *
016800200528      *  BUG5449 -Schedules for CIRS api                              *
016900200528      *  BUG4646- Completion of SIRS api                              *
017000200528      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
017100200528      *  CDL018 - Recompiled due to changes in MMLDNIR.               *
017200200528      *  BG1105 - Bug1105 Make MSGARROUT a variable length string     *
017300200528      *  BUG19  - LERI API processing.                                *
017400200528      *  BUG1100- Added FEEM processing.                              *
017500200528      *  BUG1057- Added PRCS API.                                     *
017600200528      *  BUG1055- Added SEDE API.                                     *
017700200528      *  CGL029 - Increase Account Code to 10 digits                  *
017800200528      *  CSC021 - Add call to SCHELPR to processing                   *
017900200528      *  CAP084 - Synchronous calling of APIs                         *
018000200528      *                                                               *
018100200528      *****************************************************************
018200200528      ** +--------------------------------------+
018300200528      ** ¦ Automatically included D-specs       ¦
018400200528      ** ¦ ==============================       ¦
018500200528      ** +--------------------------------------+
018600200528      **
018700200528      **---------------------------------------------------------------
018800200528      ** The following /COPY line includes (among others) the LDA layout
018900200528      ** and the copyright array definition:
019000200528     D/COPY ZACPYSRC,STD_D_SPEC
019100200528      **---------------------------------------------------------------
019200200528
019300200528      **---------------------------------------------------------------
019400200528      ** The following /COPY line includes all the defined fields in the
019500200528      ** Program Status Data Structures.  They have meaningful
019600200528      ** names, prefixed by 'PS'.
019700200528     D/COPY ZACPYSRC,PSDS
019800200528      **---------------------------------------------------------------
019900200528
020000200528      **---------------------------------------------------------------
020100200528      ** The following /COPY line includes all the definitions of the
020200200528      ** error arrays, including the named constant giving the size of
020300200528      ** the arrays.
020400200528     D/COPY ZACPYSRC,FVAL_ARRAY
020500200528      **---------------------------------------------------------------
020600200528
020700200528      ** +--------------------------------------+
020800200528      ** ¦ End of automatically included D-specs¦
020900200528      ** ¦ =====================================¦
021000200528      ** +--------------------------------------+
021100200528
021200200528      ** The maximum size of the error arrays
021300200528     D ArrayMax        C                   CONST(75)
021400200528
021500200528      ** Array of Fields in error.
021600200528     D FldNameArr      S             10A   DIM(ArrayMax)
021700200528
021800200528      ** Array of error message IDs
021900200528     D MsgIDArr        S                   DIM(ArrayMax)
022000200528     D                                     LIKE(#MsgID)
022100200528
022200200528      ** Array of error message data.
022300200528     D MsgDtaArr       S                   DIM(ArrayMax)
022400200528     D                                     LIKE(#MsgData)
022500200528
022600200528      ** Array of Fields with warnings.
022700200528     D WFldNamArr      S             10A   DIM(ArrayMax)
022800200528
022900200528      ** Array of warning message IDs
023000200528     D WMsgIDArr       S                   DIM(ArrayMax)
023100200528     D                                     LIKE(#MsgID)
023200200528
023300200528      ** Array of warning message data.
023400200528     D WMsgDtaArr      S                   DIM(ArrayMax)
023500200528     D                                     LIKE(#MsgData)
023600200528
023700200528      ** Entry parameters
023800200528     D TransType       S              4
023900200528     D Parm            S           1000
024000200528     D Buffer          S           6000
024100200528     D***ApHead*         S            200                                            AR971184 CSD102
024200200528     D ApHead          S            318                                                       CSD102
024300200528      * In order to allow for growing and variable buffers, this buffer must be split up
024400200528      * Any APIs requiring more than 6000 buffer should use buffer2
024500200528     D BufferTotal     S           9999
024600200528     D Buffer9999      S           9999                                                       CER059
024700200528     D Buffer2         S           3999
024800200528     D BufferEx2       S           9999                                                      BUG4646
024900200528     D BufferEx3       S           9999                                                      BUG4646
025000200528     D BufferEx4       S           9999                                                      BUG4646
025100200528     D BufferEx5       S           9999                                                      BUG4646
025200200528     D BufferEx6       S           9999                                                      BUG4646
025300200528     D BufferEx7       S           9999                                                      BUG4646
025400200528     D BufferEx8       S           9999                                                      BUG4646
025500200528     D BufferEx9       S           9999                                                      BUG4646
025600200528     D*******MsgArrOUT       S           2000                                                 BG1105
025700200528     D MsgArrOUT       S           9999                                                       BG1105
025800200528     D APIRetC         S              1
025900200528     D DDCUST_In       S              6                                                       CSD079
026000200528     D DDCSNO_In       S              6                                                       CSD079
026100200528     D APINam          S             20                                                     AR885527
026200200528     D DDORLN_In       S              6                                                       CLE134
026300200528     D DDFECU_In       S              6                                                       CLE134
026400200528     D DDFFAC_In       S              5                                                       CLE134
026500200528     D***DDFESQ_In       S              2                                              CLE134 264044
026600200528     D DDFSE2_In       S              2                                                       264044
026700200528     D DDFLNO_In       S              6                                                       CLE134
026800200528     D DDPLON_In       S              6                                                       264044
026900200528     D DDPLO2_In       S              6                                                       264044
027000200528     D ModeofOp        S              6                                                       CAP210
027100200528     D RespMode        S              1                                                       CAP210
027200200528     D FOTRID          S             20                                                       CAP210
027300200528     D OKACTN          S              1                                                       CAP210
027400200528     D OKTRNN          S              1                                                       CAP210
027500200528     D BtnPressed      S             10                                                    AR1090283
027600200528
027700200528      ** DS/variables to split up incoming parameter
027800200528     D APParm          DS          1000
027900200528     D  AuthComp               1      1
028000200528     D  FwdBck                 2      2
028100200528     D*********TransID                3    103                                                CSC021
028200200528     D  TransID                3    303                                                       CSC021
028300200528      * Incoming Header                                                                    AR1078092
028400200528     D HeadIn        E DS                  EXTNAME(APHEADPD)                               AR1078092
028500200528
028600200528      **********************************************************************
028700200528      /SPACE 5
028800200528      **********************************************************************
028900200528      * Start of main processing
029000200528      **********************************************************************
029100200528     C     *ENTRY        PLIST
029200200528     C                   PARM                    TransType
029300200528     C                   PARM                    Parm
029400200528     C                   PARM                    BufferTotal
029500200528     C                   PARM                    BufferEx2                                   BUG4646
029600200528     C                   PARM                    BufferEx3                                   BUG4646
029700200528     C                   PARM                    BufferEx4                                   BUG4646
029800200528     C                   PARM                    BufferEx5                                   BUG4646
029900200528     C                   PARM                    BufferEx6                                   BUG4646
030000200528     C                   PARM                    BufferEx7                                   BUG4646
030100200528     C                   PARM                    BufferEx8                                   BUG4646
030200200528     C                   PARM                    BufferEx9                                   BUG4646
030300200528     C                   PARM                    MsgArrOUT
030400200528     C                   PARM                    APIRetC
030500200528     C                   PARM                    ApHead                                     AR971184
030600200528      *
030700200528      * Extract entry parameters
030800200528     C                   Eval      APParm = Parm
030900200528
031000200528      * Clear down buffers
031100200528     C                   Eval      Buffer = *BLANKS
031200200528     C                   Eval      Buffer2 = *BLANKS
031300200528     C                   Eval      BufferTotal = *BLANKS
031400200528     C                   Eval      BufferEx2 = *BLANKS                                       BUG4646
031500200528     C                   Eval      BufferEx3 = *BLANKS                                       BUG4646
031600200528     C                   Eval      BufferEx4 = *BLANKS                                       BUG4646
031700200528     C                   Eval      BufferEx5 = *BLANKS                                       BUG4646
031800200528     C                   Eval      BufferEx6 = *BLANKS                                       BUG4646
031900200528     C                   Eval      BufferEx7 = *BLANKS                                       BUG4646
032000200528     C                   Eval      BufferEx8 = *BLANKS                                       BUG4646
032100200528     C                   Eval      BufferEx9 = *BLANKS                                       BUG4646
032200200528
032300200528      **--------------------------------------------------------------
032400200528      ** The following /COPY sets the values of program, module and
032500200528      ** procedure names for database error processing.
032600200528     C/COPY ZACPYSRC,DBFIELDS
032700200528      **--------------------------------------------------------------
032800200528
032900200528     C                   EVAL      HeadIn = ApHead                                         AR1078092
033000200528      * Call the required API
033100200528
033200200528     C                   EXSR      CALLAPI
033300200528
033400200528      * Move the buffers into the full buffer
033500200528     C                   EVAL      BufferTotal = Buffer + Buffer2
033600200528
033700200528      * Edit the Messages for output
033800200528     C                   EXSR      EDTMSGS
033900200528
034000200528     C                   SETON                                        LR
034100200528     C                   RETURN
034200200528      ****************************************************************
034300200528      /SPACE 5
034400200528      ****************************************************************
034500200528      * Call the required API
034600200528      ****************************************************************
034700200528     C     CALLAPI       BEGSR
034800200528
034900200528     C                   SELECT
035000200528
035100200528      * FX deals
035200200528     C     TransTYPE     WHENEQ    'FXDL'
035300200528
035400200528     C                   MOVEL     TransID       DDDLNO_In
035500200528
035600200528     C                   CALL      'FXFXDLR'
035700200528     C                   PARM                    AuthComp
035800200528     C                   PARM                    FwdBck
035900200528     C                   PARM                    DDDLNO_In         6
036000200528     C                   PARM                    Buffer
036100200528     C                   PARM                    FldNameArr
036200200528     C                   PARM                    MsgIDArr
036300200528     C                   PARM                    MsgDtaArr
036400200528     C                   PARM                    MsgFArray
036500200528     C                   PARM                    APIRetC
036600200528
036700200528      * MM Loan/Deposit deals
036800200528
036900200528     C     TransTYPE     WHENEQ    'LDNI'
037000200528
037100200528     C                   MOVEL     TransID       DDDLNO_In
037200200528
037300200528     C                   CALL      'MMLDNIR'
037400200528     C                   PARM                    AuthComp
037500200528     C                   PARM                    FwdBck
037600200528     C                   PARM                    DDDLNO_In
037700200528     C                   PARM                    Buffer
037800200528     C                   PARM                    Buffer2                                      CDL033
037900200528     C                   PARM                    BufferEx2                                    CDL033
038000200528     C                   PARM                    BufferEx3                                AR1060863A
038100200528     C                   PARM                    FldNameArr
038200200528     C                   PARM                    MsgIDArr
038300200528     C                   PARM                    MsgDtaArr
038400200528     C                   PARM                    MsgFArray
038500200528     C                   PARM                    APIRetC
038600200528     C                   PARM                    ACTRJ             1                        AR701789
038700200528
038800200528      * Incoming payments
038900200528
039000200528     C     TransTYPE     WHENEQ    'IPAY'
039100200528
039200200528     C                   MOVEL     TransID       DDPREF_In        15
039300200528     C*****1****         SUBST     TransID:16    DDACTN_In         1                        AR833200
039400200528     C*****1             SUBST     TransID:19    DDACTN_In         1               AR833200 MD039986
039500200528     C     10            SUBST     TransID:19    BtnPressed                                AR1090283
039600200528     C     1             SUBST     TransID:29    DDACTN_In         1                        MD039986
039700200528
039800200528     C                   CALL      'FTIPAYR'
039900200528     C                   PARM                    FwdBck
040000200528     C                   PARM                    DDPREF_In
040100200528     C                   PARM                    DDACTN_In
040200200528     C                   PARM                    Buffer
040300200528     C                   PARM                    FldNameArr
040400200528     C                   PARM                    MsgIDArr
040500200528     C                   PARM                    MsgDtaArr
040600200528     C                   PARM                    MsgFArray
040700200528     C                   PARM                    APIRetC
040800200528     C                   PARM                    BtnPressed                                AR1090283
040900200528
041000200528      * Outgoing payments
041100200528
041200200528     C     TransTYPE     WHENEQ    'OPAY'
041300200528
041400200528     C                   MOVEL     TransID       DDPREF_In
041500200528     C*****1****         SUBST     TransID:16    DDACTN_In         1                        AR833200
041600200528     C*****1             SUBST     TransID:19    DDACTN_In         1               AR833200 MD039986
041700200528     C     10            SUBST     TransID:19    BtnPressed                                 MD039986
041800200528     C     1             SUBST     TransID:29    DDACTN_In         1                        MD039986
041900200528
042000200528     C                   CALL      'FTOPAYR'
042100200528     C                   PARM                    FwdBck
042200200528     C                   PARM                    DDPREF_In
042300200528     C                   PARM                    DDACTN_In
042400200528     C                   PARM                    Buffer
042500200528     C                   PARM                    Buffer2                                      CSF011
042600200528     C                   PARM                    FldNameArr
042700200528     C                   PARM                    MsgIDArr
042800200528     C                   PARM                    MsgDtaArr
042900200528     C                   PARM                    MsgFArray
043000200528     C                   PARM                    APIRetC
043100200528     C                   PARM                    BtnPressed                                AR1090283
043200200528
043300200528     C     TransTYPE     WHENEQ    'AMAD'
043400200528     C     TransTYPE     OREQ      'ACMC'                                                     CRE026
043500200528     C     TransTYPE     OREQ      'ACMI'                                                     CRE026
043600200528     C     TransTYPE     OREQ      'ACMN'                                                     CRE026
043700200528
043800200528     C                   MOVEL     TransID       DDACRF_In
043900200528
044000200528     C                   CALL      'GLAMADR'
044100200528     C                   PARM                    FwdBck
044200200528     C**********         PARM                    DDACRF_In        18                          CGL029
044300200528     C                   PARM                    DDACRF_In        24                          CGL029
044400200528     C**********         PARM                    Buffer                                     MD044880
044500200528     C**********         PARM                    Buffer2                             CSF011 MD044880
044600200528     C                   PARM                    Buffer9999                                 MD044880
044700200528     C                   PARM                    FldNameArr
044800200528     C                   PARM                    MsgIDArr
044900200528     C                   PARM                    MsgDtaArr
045000200528     C                   PARM                    MsgFArray
045100200528     C                   PARM                    APIRetC
045200200528
045300200528     C                   MOVEL     Buffer9999    Buffer                                     MD044880
045400200528     C                   MOVE      Buffer9999    Buffer2                                    MD044880
045500200528
045600200528      * SD Customers
045700200528
045800200528     C     TransTYPE     WHENEQ    'CUSD'
045900200528     C     TransTYPE     OREQ      'CSDU'                                                     CSD079
046000200528     C     TransTYPE     OREQ      'CSDV'                                                     CSD079
046100200528
046200200528     C                   MOVEL     TransID       DDCUSN_In
046300200528
046400200528     C                   CALL      'SDCUSDR'
046500200528     C                   PARM                    AuthComp
046600200528     C                   PARM                    FwdBck
046700200528     C                   PARM                    DDCUSN_In         6
046800200528     C**********         PARM                    Buffer                                       CER059
046900200528     C                   PARM                    Buffer9999                                   CER059
047000200528     C                   PARM                    BufferEx2                                    CSW213
047100200528     C                   PARM                    BufferEx3                                    CSW213
047200200528     C                   PARM                    BufferEx4                                    CSW213
047300200528     C                   PARM                    FldNameArr
047400200528     C                   PARM                    MsgIDArr
047500200528     C                   PARM                    MsgDtaArr
047600200528     C                   PARM                    MsgFArray
047700200528     C                   PARM                    APIRetC
047800200528
047900200528     C                   MOVEL     Buffer9999    Buffer                                       CER059
048000200528     C                   MOVE      Buffer9999    Buffer2                                      CER059
048100200528      * SD Securities Customers
048200200528
048300200528     C     TransTYPE     WHENEQ    'SECD'
048400200528
048500200528     C                   MOVEL     TransID       DDCUSN_In
048600200528
048700200528     C                   CALL      'SDSECDR'
048800200528     C                   PARM                    AuthComp
048900200528     C                   PARM                    FwdBck
049000200528     C                   PARM                    DDCUSN_In         6
049100200528     C                   PARM                    Buffer
049200200528     C                   PARM                    FldNameArr
049300200528     C                   PARM                    MsgIDArr
049400200528     C                   PARM                    MsgDtaArr
049500200528     C                   PARM                    MsgFArray
049600200528     C                   PARM                    APIRetC
049700200528
049800200528      * PM Portfolio Definition
049900200528
050000200528     C     TransTYPE     WHENEQ    'PFDM'
050100200528
050200200528     C                   MOVEL     TransID       DDCUSN_In
050300200528     C                   EVAL      DDPTFR_In = %SUBST(TransID:7:4)
050400200528
050500200528     C                   CALL      'PMPFDMR'
050600200528     C                   PARM                    AuthComp
050700200528     C                   PARM                    FwdBck
050800200528     C                   PARM                    DDCUSN_In         6
050900200528     C                   PARM                    DDPTFR_In         4
051000200528     C                   PARM                    Buffer
051100200528     C                   PARM                    FldNameArr
051200200528     C                   PARM                    MsgIDArr
051300200528     C                   PARM                    MsgDtaArr
051400200528     C                   PARM                    MsgFArray
051500200528     C                   PARM                    APIRetC
051600200528
051700200528      * MM Deal Amendments
051800200528
051900200528     C     TransTYPE     WHENEQ    'DEAM'
052000200528
052100200528     C                   MOVEL     TransID       DDDLNO_In
052200200528     C                   EVAL      DDVDAT_In = %SUBST(TransID:7:6)
052300200528     C                   EVAL      DDDS38_In = %SUBST(TransID:13:3)
052400200528
052500200528     C                   CALL      'MMDEAMR'
052600200528     C                   PARM                    AuthComp
052700200528     C                   PARM                    FwdBck
052800200528     C                   PARM                    DDDLNO_In
052900200528     C                   PARM                    DDVDAT_In         6
053000200528     C                   PARM                    DDDS38_In         3
053100200528     C                   PARM                    Buffer
053200200528     C                   PARM                    FldNameArr
053300200528     C                   PARM                    MsgIDArr
053400200528     C                   PARM                    MsgDtaArr
053500200528     C                   PARM                    MsgFArray
053600200528     C                   PARM                    APIRetC
053700200528     C                   PARM      *BLANK        @ACTRV            1                          260173
053800200528
053900200528      * GL Collateral Details
054000200528
054100200528     C     TransTYPE     WHENEQ    'COLL'
054200200528
054300200528     C                   MOVEL     TransID       DDCREF_In
054400200528
054500200528     C                   CALL      'GLCOLLR'
054600200528     C                   PARM                    AuthComp
054700200528     C                   PARM                    FwdBck
054800200528     C                   PARM                    DDCREF_In        10
054900200528     C                   PARM                    Buffer
055000200528     C                   PARM                    FldNameArr
055100200528     C                   PARM                    MsgIDArr
055200200528     C                   PARM                    MsgDtaArr
055300200528     C                   PARM                    MsgFArray
055400200528     C                   PARM                    APIRetC
055500200528
055600200528      ** GL Collateral Allocations
055700200528
055800200528     C     TransTYPE     WHENEQ    'COLA'
055900200528
056000200528     C                   EVAL      ADBRCA_IN = %SUBST(TransID:1:3)
056100200528     C                   EVAL      ADCUSN_IN = %SUBST(TransID:4:10)
056200200528     C                   EVAL      ADMODI_IN = %SUBST(TransID:14:2)
056300200528     C                   EVAL      ADFCTY_IN = %SUBST(TransID:16:11)
056400200528     C                   EVAL      ADLNLM_IN = %SUBST(TransID:27:6)
056500200528     C**********         EVAL      ADREAC_IN = %SUBST(TransID:33:18)                          CGL029
056600200528     C**********         EVAL      ADCREF_IN = %SUBST(TransID:51:10)                          CGL029
056700200528     C                   EVAL      ADREAC_IN = %SUBST(TransID:33:24)                          CGL029
056800200528     C                   EVAL      ADCREF_IN = %SUBST(TransID:57:10)                          CGL029
056900200528
057000200528     C                   CALL      'GLCOLAR'
057100200528     C                   PARM                    AuthComp          1
057200200528     C                   PARM                    FwdBck            1
057300200528     C                   PARM                    ADBRCA_IN         3
057400200528     C                   PARM                    ADCUSN_IN        10
057500200528     C                   PARM                    ADMODI_IN         2
057600200528     C                   PARM                    ADFCTY_IN        11
057700200528     C                   PARM                    ADLNLM_IN         6
057800200528     C**********         PARM                    ADREAC_IN        18                          CGL029
057900200528     C                   PARM                    ADREAC_IN        24                          CGL029
058000200528     C                   PARM                    ADCREF_IN        10
058100200528     C                   PARM                    Buffer
058200200528     C                   PARM                    FldNameArr
058300200528     C                   PARM                    MsgIDArr
058400200528     C                   PARM                    MsgDtaArr
058500200528     C                   PARM                    MsgFArray
058600200528     C                   PARM                    APIRetC
058700200528
058800200528      * LE Facilities Details
058900200528
059000200528     C     TransTYPE     WHENEQ    'FCIP'
059100200528
059200200528     C                   MOVEL     TransID       DDCSSN_In
059300200528     C                   EVAL      DDFACT_In = %SUBST(TransID:11:3)
059400200528     C                   EVAL      DDFCNO_In = %SUBST(TransID:14:2)
059500200528
059600200528     C                   CALL      'LEFCIPR'
059700200528     C                   PARM                    AuthComp
059800200528     C                   PARM                    FwdBck
059900200528     C                   PARM                    DDCSSN_In         6
060000200528     C                   PARM                    DDFACT_In         3
060100200528     C                   PARM                    DDFCNO_In         2
060200200528     C                   PARM                    DDBRCA_In         3
060300200528     C                   PARM                    Buffer
060400200528     C                   PARM                    FldNameArr
060500200528     C                   PARM                    MsgIDArr
060600200528     C                   PARM                    MsgDtaArr
060700200528     C                   PARM                    MsgFArray
060800200528     C                   PARM                    APIRetC
060900200528     C                   PARM                    DDPATH          200                       BUG13297A
061000200528
061100200528      * LE Loan Details
061200200528
061300200528     C     TransTYPE     WHENEQ    'CLIP'
061400200528
061500200528     C                   MOVEL     TransID       DDLNRF_In
061600200528     C     1             SUBST     TransID:7     DDACTN_In                                   BUG3721
061700200528
061800200528     C                   CALL      'LECLIPR'
061900200528     C                   PARM                    AuthComp
062000200528     C                   PARM                    FwdBck
062100200528     C                   PARM                    DDLNRF_In         6
062200200528     C                   PARM                    DDACTN_In         1                         BUG3721
062300200528     C                   PARM                    Buffer
062400200528     C                   PARM                    FldNameArr
062500200528     C                   PARM                    MsgIDArr
062600200528     C                   PARM                    MsgDtaArr
062700200528     C                   PARM                    MsgFArray
062800200528     C                   PARM                    APIRetC
062900200528      *                                                                                     AR804863
063000200528      ** Action Code (Reject transaction)                                                   AR804863
063100200528      *                                                                                     AR804863
063200200528     C                   PARM      *BLANK        @ACTRV            1                        AR804863
063300200528     C                   PARM      *BLANK        @DEPI             1                        MD044880
063400200528
063500200528      * LE Rollover Details
063600200528
063700200528     C     TransTYPE     WHENEQ    'LERI'
063800200528
063900200528     C                   MOVEL     TransID       DDLNRF_In
064000200528     C     1             SUBST     TransID:7     DDACTN_In                                     BUG19
064100200528
064200200528     C                   CALL      'LELERIR'
064300200528     C                   PARM                    AuthComp
064400200528     C                   PARM                    FwdBck
064500200528     C                   PARM                    DDLNRF_In         6
064600200528     C                   PARM                    DDACTN_In         1                           BUG19
064700200528     C                   PARM                    Buffer
064800200528     C                   PARM                    FldNameArr
064900200528     C                   PARM                    MsgIDArr
065000200528     C                   PARM                    MsgDtaArr
065100200528     C                   PARM                    MsgFArray
065200200528     C                   PARM                    APIRetC
065300200528     C                   PARM      *BLANK        @ACTRV            1                        AR702532
065400200528
065500200528      * LE Repayment Schedules
065600200528
065700200528     C     TransTYPE     WHENEQ    'RPSC'
065800200528
065900200528     C                   EVAL      DDLNRF_In = TransID
066000200528     C                   EVAL      DDVDAT_In = %SUBST(TransID:7:6)
066100200528     C                   EVAL      DDSEQN_In = %SUBST(TransID:13:3)
066200200528
066300200528     C                   CALL      'LERPSCR'
066400200528     C                   PARM                    AuthComp
066500200528     C                   PARM                    FwdBck
066600200528     C                   PARM                    DDLNRF_In
066700200528     C                   PARM                    DDSEQN_In         3
066800200528     C                   PARM                    DDVDAT_In
066900200528     C                   PARM                    Buffer
067000200528     C                   PARM                    FldNameArr
067100200528     C                   PARM                    MsgIDArr
067200200528     C                   PARM                    MsgDtaArr
067300200528     C                   PARM                    MsgFArray
067400200528     C                   PARM                    APIRetC
067500200528
067600200528      * LE Loan Amendments
067700200528
067800200528     C     TransTYPE     WHENEQ    'LOAM'
067900200528
068000200528     C                   EVAL      DDLNRF_In = TransID
068100200528     C                   EVAL      DDVDAT_In = %SUBST(TransID:7:6)
068200200528     C                   EVAL      DDSEQN_In = %SUBST(TransID:13:3)
068300200528
068400200528     C                   CALL      'LELOAMR'
068500200528     C                   PARM                    AuthComp
068600200528     C                   PARM                    FwdBck
068700200528     C                   PARM                    DDLNRF_In
068800200528     C                   PARM                    DDVDAT_In
068900200528     C                   PARM                    DDSEQN_In
069000200528     C                   PARM                    Buffer
069100200528     C                   PARM                    FldNameArr
069200200528     C                   PARM                    MsgIDArr
069300200528     C                   PARM                    MsgDtaArr
069400200528     C                   PARM                    MsgFArray
069500200528     C                   PARM                    APIRetC
069600200528
069700200528      * LE Manual Repayment
069800200528
069900200528     C     TransTYPE     WHENEQ    'MAPY'
070000200528
070100200528     C                   EVAL      DDLNRF_In = TransID
070200200528     C                   EVAL      DDVDAT_In = %SUBST(TransID:7:6)
070300200528     C                   EVAL      DDSEQN_In = %SUBST(TransID:13:3)
070400200528
070500200528     C                   CALL      'LEMAPYR'
070600200528     C                   PARM                    AuthComp
070700200528     C                   PARM                    FwdBck
070800200528     C                   PARM                    DDLNRF_In
070900200528     C                   PARM                    DDSEQN_In         3
071000200528     C                   PARM                    DDVDAT_In
071100200528     C                   PARM                    Buffer
071200200528     C                   PARM                    FldNameArr
071300200528     C                   PARM                    MsgIDArr
071400200528     C                   PARM                    MsgDtaArr
071500200528     C                   PARM                    MsgFArray
071600200528     C                   PARM                    APIRetC
071700200528
071800200528      * SD Base rates
071900200528     C     TransTYPE     WHENEQ    'BSRT'
072000200528
072100200528     C                   EVAL      DDCYCD_IN = %SUBST(TransID:1:3)
072200200528     C                   EVAL      DDBSRC_IN = %SUBST(TransID:4:2)
072300200528
072400200528     C                   CALL      'SDBSRTR'
072500200528     C                   PARM                    FwdBck
072600200528     C                   PARM                    DDCYCD_IN         3
072700200528     C                   PARM                    DDBSRC_IN         2
072800200528     C                   PARM                    Buffer
072900200528     C                   PARM                    FldNameArr
073000200528     C                   PARM                    MsgIDArr
073100200528     C                   PARM                    MsgDtaArr
073200200528     C                   PARM                    MsgFArray
073300200528     C                   PARM                    APIRetC
073400200528
073500200528      ** LE Fees                                                                             BUG1100
073600200528     C     TransTYPE     WHENEQ    'FEEM'                                                    BUG1100
073700200528                                                                                             BUG1100
073800200528     C                   EVAL      DDCNUM_IN = %SUBST(TransID:1:10)                          BUG1100
073900200528     C                   EVAL      DDFACT_IN = %SUBST(TransID:11:3)                          BUG1100
074000200528     C                   EVAL      DDFACN_IN = %SUBST(TransID:14:2)                          BUG1100
074100200528     C                   EVAL      DDLNRF_IN = %SUBST(TransID:16:6)                          BUG1100
074200200528     C                   EVAL      DDFSEQ_IN = %SUBST(TransID:22:2)                          BUG1100
074300200528                                                                                             BUG1100
074400200528     C                   CALL      'LEFEEMR'                                                 BUG1100
074500200528     C                   PARM                    AuthComp                                    BUG1100
074600200528     C                   PARM                    FwdBck                                      BUG1100
074700200528     C                   PARM                    DDCNUM_IN                                   BUG1100
074800200528     C                   PARM                    DDFACT_IN                                   BUG1100
074900200528     C                   PARM                    DDFACN_IN         2                         BUG1100
075000200528     C                   PARM                    DDLNRF_IN                                   BUG1100
075100200528     C                   PARM                    DDFSEQ_IN         3                         BUG1100
075200200528     C                   PARM                    Buffer                                      BUG1100
075300200528     C                   PARM                    FldNameArr                                  BUG1100
075400200528     C                   PARM                    MsgIDArr                                    BUG1100
075500200528     C                   PARM                    MsgDtaArr                                   BUG1100
075600200528     C                   PARM                    MsgFArray                                   BUG1100
075700200528     C                   PARM                    APIRetC                                     BUG1100
075800200528                                                                                             BUG1100
075900200528      * LE Fee Adjustment
076000200528     C     TransTYPE     WHENEQ    'FEAD'
076100200528
076200200528     C                   EVAL      DDCNUM_IN = %SUBST(TransID:1:10)
076300200528     C                   EVAL      DDFACT_IN = %SUBST(TransID:11:3)
076400200528     C                   EVAL      DDFACN_IN = %SUBST(TransID:14:2)
076500200528     C                   EVAL      DDFSEQ_IN = %SUBST(TransID:16:2)
076600200528      *                                                                                       CLE073
076700200528     C                   EVAL      DDLOAN_IN = %SUBST(TransID:18:23)                          CLE073
076800200528      *                                                                                       CLE073
076900200528
077000200528     C                   CALL      'LEFEADR'
077100200528     C                   PARM                    AuthComp
077200200528     C                   PARM                    FwdBck
077300200528     C                   PARM                    DDCNUM_IN
077400200528     C                   PARM                    DDFACT_IN
077500200528     C                   PARM                    DDFACN_IN         2
077600200528     C                   PARM                    DDFSEQ_IN         3
077700200528      *                                                                                       CLE073
077800200528     C                   PARM                    DDLOAN_IN         6                          CLE073
077900200528      *                                                                                       CLE073
078000200528     C                   PARM                    Buffer
078100200528     C                   PARM                    FldNameArr
078200200528     C                   PARM                    MsgIDArr
078300200528     C                   PARM                    MsgDtaArr
078400200528     C                   PARM                    MsgFArray
078500200528     C                   PARM                    APIRetC
078600200528
078700200528      * LE Fee settlement
078800200528     C     TransTYPE     WHENEQ    'FEST'
078900200528
079000200528     C                   EVAL      DDCNUM_IN = %SUBST(TransID:1:10)
079100200528     C                   EVAL      DDFACT_IN = %SUBST(TransID:11:3)
079200200528     C                   EVAL      DDFACN_IN = %SUBST(TransID:14:2)
079300200528     C                   EVAL      DDFSEQ_IN = %SUBST(TransID:16:2)
079400200528     C                   EVAL      DDVDAT_IN = %SUBST(TransID:18:6)
079500200528      *                                                                                       CLE073
079600200528     C                   EVAL      DDLOAN_IN = %SUBST(TransID:24:29)                          CLE073
079700200528      *                                                                                       CLE073
079800200528
079900200528     C                   CALL      'LEFESTR'
080000200528     C                   PARM                    AuthComp
080100200528     C                   PARM                    FwdBck
080200200528     C                   PARM                    DDCNUM_IN
080300200528     C                   PARM                    DDFACT_IN
080400200528     C                   PARM                    DDFACN_IN         2
080500200528     C                   PARM                    DDFSEQ_IN         3
080600200528     C                   PARM                    DDVDAT_IN
080700200528      *                                                                                       CLE073
080800200528     C                   PARM                    DDLOAN_IN         6                          CLE073
080900200528      *                                                                                       CLE073
081000200528     C                   PARM                    Buffer
081100200528     C                   PARM                    FldNameArr
081200200528     C                   PARM                    MsgIDArr
081300200528     C                   PARM                    MsgDtaArr
081400200528     C                   PARM                    MsgFArray
081500200528     C                   PARM                    APIRetC
081600200528
081700200528      * LE Funding Participant
081800200528     C     TransTYPE     WHENEQ    'FPRT'
081900200528
082000200528     C                   EVAL      DDPMFC_IN = %SUBST(TransID:1:6)
082100200528     C                   EVAL      DDPMFT_IN = %SUBST(TransID:7:3)
082200200528     C                   EVAL      DDPMFN_IN = %SUBST(TransID:10:2)
082300200528     C                   EVAL      DDCNUM_IN = %SUBST(TransID:12:10)
082400200528     C                   EVAL      DDFACT_IN = %SUBST(TransID:22:3)
082500200528     C                   EVAL      DDFCNO_IN = %SUBST(TransID:25:2)
082600200528
082700200528     C                   CALL      'LEFPRTR'
082800200528     C                   PARM                    AuthComp
082900200528     C                   PARM                    FwdBck
083000200528     C                   PARM                    DDPMFC_IN         6
083100200528     C                   PARM                    DDPMFT_IN         3
083200200528     C                   PARM                    DDPMFN_IN         2
083300200528     C                   PARM                    DDCNUM_IN        10
083400200528     C                   PARM                    DDFACT_IN         3
083500200528     C                   PARM                    DDFCNO_IN         2
083600200528     C                   PARM                    Buffer
083700200528     C                   PARM                    FldNameArr
083800200528     C                   PARM                    MsgIDArr
083900200528     C                   PARM                    MsgDtaArr
084000200528     C                   PARM                    MsgFArray
084100200528     C                   PARM                    APIRetC
084200200528
084300200528      * LE Assignments
084400200528     C     TransTYPE     WHENEQ    'ASGN'
084500200528
084600200528     C                   EVAL      DDBRCA_IN = %SUBST(TransID:1:3)
084700200528     C                   EVAL      DDCNAM_IN = %SUBST(TransID:4:6)
084800200528     C                   EVAL      DDFACT_IN = %SUBST(TransID:10:3)
084900200528     C                   EVAL      DDFCNO_IN = %SUBST(TransID:13:2)
085000200528     C                   EVAL      DDMNUM_IN = %SUBST(TransID:15:10)
085100200528     C                   EVAL      DDINUM_IN = %SUBST(TransID:25:10)
085200200528     C                   EVAL      DDVDTC_IN = %SUBST(TransID:35:6)
085300200528
085400200528     C                   CALL      'LEASGNR'
085500200528     C                   PARM                    AuthComp          1
085600200528     C                   PARM                    FwdBck            1
085700200528     C                   PARM                    DDBRCA_IN         3
085800200528     C                   PARM                    DDCNAM_IN         6
085900200528     C                   PARM                    DDFACT_IN         3
086000200528     C                   PARM                    DDFCNO_IN         2
086100200528     C                   PARM                    DDMNUM_IN        10
086200200528     C                   PARM                    DDINUM_IN        10
086300200528     C                   PARM                    DDVDTC_IN         6
086400200528     C                   PARM                    Buffer
086500200528     C                   PARM                    FldNameArr
086600200528     C                   PARM                    MsgIDArr
086700200528     C                   PARM                    MsgDtaArr
086800200528     C                   PARM                    MsgFArray
086900200528     C                   PARM                    APIRetC
087000200528
087100200528      * LE Facility Amendments
087200200528     C     TransTYPE     WHENEQ    'FAMD'
087300200528
087400200528     C                   EVAL      DDCCSN_IN = %SUBST(TransID:1:10)
087500200528     C                   EVAL      DDFACT_IN = %SUBST(TransID:11:3)
087600200528     C                   EVAL      DDFCNO_IN = %SUBST(TransID:14:2)
087700200528     C                   EVAL      DDFATP_IN = %SUBST(TransID:16:2)
087800200528     C                   EVAL      DDVLDT_IN = %SUBST(TransID:18:6)
087900200528     C                   EVAL      DDSQNO_IN = %SUBST(TransID:24:3)
088000200528
088100200528     C                   CALL      'LEFAMDR'
088200200528     C                   PARM                    AuthComp          1
088300200528     C                   PARM                    FwdBck            1
088400200528     C                   PARM                    DDCCSN_IN        10
088500200528     C                   PARM                    DDFACT_IN         3
088600200528     C                   PARM                    DDFCNO_IN         2
088700200528     C                   PARM                    DDFATP_IN         2
088800200528     C                   PARM                    DDVLDT_IN         6
088900200528     C                   PARM                    DDSQNO_IN         3
089000200528     C                   PARM                    Buffer
089100200528     C                   PARM                    FldNameArr
089200200528     C                   PARM                    MsgIDArr
089300200528     C                   PARM                    MsgDtaArr
089400200528     C                   PARM                    MsgFArray
089500200528     C                   PARM                    APIRetC
089600200528
089700200528      * FRA - Forward Rate Agreement deals
089800200528     C     TransTYPE     WHENEQ    'FRA '
089900200528
090000200528     C                   EVAL      DDDLNO_IN = %SUBST(TransID:1:6)
090100200528
090200200528     C                   CALL      'IRFRAR'
090300200528     C                   PARM                    AuthComp
090400200528     C                   PARM                    FwdBck
090500200528     C                   PARM                    DDDLNO_IN         6
090600200528     C                   PARM                    Buffer
090700200528     C                   PARM                    FldNameArr
090800200528     C                   PARM                    MsgIDArr
090900200528     C                   PARM                    MsgDtaArr
091000200528     C                   PARM                    MsgFArray
091100200528     C                   PARM                    APIRetC
091200200528
091300200528      ** Single Currency IRS (SIRS)
091400200528
091500200528     C     TransTYPE     WHENEQ    'SIRS'
091600200528
091700200528     C                   EVAL      DDDLNO_IN = %SUBST(TransID:1:6)
091800200528
091900200528     C                   CALL      'IRSIRSR'
092000200528     C                   PARM                    AuthComp
092100200528     C                   PARM                    FwdBck
092200200528     C                   PARM                    DDDLNO_IN
092300200528     C                   PARM                    Buffer
092400200528     C                   PARM                    Buffer2                                     BUG4646
092500200528     C                   PARM                    BufferEx2                                   BUG4646
092600200528     C                   PARM                    BufferEx3                                   BUG4646
092700200528     C                   PARM                    BufferEx4                                   BUG4646
092800200528     C                   PARM                    BufferEx5                                   BUG4646
092900200528     C                   PARM                    BufferEx6                                   BUG4646
093000200528     C                   PARM                    BufferEx7                                   BUG4646
093100200528     C                   PARM                    BufferEx8                                   BUG4646
093200200528     C                   PARM                    BufferEx9                                   BUG4646
093300200528     C                   PARM                    FldNameArr
093400200528     C                   PARM                    MsgIDArr
093500200528     C                   PARM                    MsgDtaArr
093600200528     C                   PARM                    MsgFArray
093700200528     C                   PARM                    APIRetC
093800200528     C                   PARM                    ACTRJ                                      MD054906
093900200528
094000200528      ** Cross Currency IRS (CIRS)
094100200528
094200200528     C     TransTYPE     WHENEQ    'CIRS'
094300200528
094400200528     C                   EVAL      DDDLNO_IN = %SUBST(TransID:1:6)
094500200528
094600200528     C                   CALL      'IRCIRSR'
094700200528     C                   PARM                    AuthComp
094800200528     C                   PARM                    FwdBck
094900200528     C                   PARM                    DDDLNO_IN
095000200528     C                   PARM                    Buffer
095100200528     C                   PARM                    Buffer2                                     BUG5449
095200200528     C                   PARM                    BufferEx2                                   BUG5449
095300200528     C                   PARM                    BufferEx3                                   BUG5449
095400200528     C                   PARM                    BufferEx4                                   BUG5449
095500200528     C                   PARM                    BufferEx5                                   BUG5449
095600200528     C                   PARM                    BufferEx6                                   BUG5449
095700200528     C                   PARM                    BufferEx7                                   BUG5449
095800200528     C                   PARM                    BufferEx8                                   BUG5449
095900200528     C                   PARM                    BufferEx9                                   BUG5449
096000200528     C                   PARM                    FldNameArr
096100200528     C                   PARM                    MsgIDArr
096200200528     C                   PARM                    MsgDtaArr
096300200528     C                   PARM                    MsgFArray
096400200528     C                   PARM                    APIRetC
096500200528     C                   PARM                    ACTRJ                                      MD054906
096600200528
096700200528      * SE Securities Details
096800200528     C     TransTYPE     WHENEQ    'SECS'
096900200528
097000200528     C                   MOVEL     TransID       DDSESN_IN
097100200528
097200200528     C                   CALL      'SESECSR'
097300200528     C                   PARM                    AuthComp
097400200528     C                   PARM                    FwdBck
097500200528     C                   PARM                    DDSESN_IN        10
097600200528     C                   PARM                    Buffer
097700200528     C                   PARM                    FldNameArr
097800200528     C                   PARM                    MsgIDArr
097900200528     C                   PARM                    MsgDtaArr
098000200528     C                   PARM                    MsgFArray
098100200528     C                   PARM                    APIRetC
098200200528
098300200528      * SE Securities Trades
098400200528     C     TransTYPE     WHENEQ    'TRAD'
098500200528
098600200528     C                   MOVEL     TransID       DDTDRF_IN
098700200528
098800200528     C                   CALL      'SETRADR'
098900200528     C                   PARM                    AuthComp
099000200528     C                   PARM                    FwdBck
099100200528     C                   PARM                    DDTDRF_IN         6
099200200528     C                   PARM                    Buffer
099300200528     C                   PARM                    Buffer2                                     CSF011A
099400200528     C                   PARM                    FldNameArr
099500200528     C                   PARM                    MsgIDArr
099600200528     C                   PARM                    MsgDtaArr
099700200528     C                   PARM                    MsgFArray
099800200528     C                   PARM                    APIRetC
099900200528
100000200528      * Data areas
100100200528
100200200528     C     TransTYPE     WHENEQ    'DTAA'
100300200528
100400200528     C                   MOVEL     TransID       DataArea
100500200528
100600200528     C                   CALL      'AOCDTAAR0'
100700200528     C                   PARM                    DataArea         10
100800200528     C                   PARM                    Value          2000
100900200528     C                   MOVEL     Value         Buffer
101000200528
101100200528      * RFT - Request for Transfer
101200200528     C     TransTYPE     WHENEQ    'RFTD'
101300200528
101400200528     C                   MOVEL     TransID       DDRFTID_In
101500200528
101600200528     C                   CALL      'FTM1011R'
101700200528     C                   PARM                    AuthComp
101800200528     C                   PARM                    FwdBck
101900200528     C                   PARM                    DDRFTID_IN       15
102000200528     C                   PARM                    Buffer
102100200528     C                   PARM                    FldNameArr
102200200528     C                   PARM                    MsgIDArr
102300200528     C                   PARM                    MsgDtaArr
102400200528     C                   PARM                    MsgFArray
102500200528     C                   PARM                    APIRetC
102600200528
102700200528      * RFT - Request for Transfer details
102800200528     C     TransTYPE     WHENEQ    'RFT2'
102900200528
103000200528     C                   EVAL      DDRFTID_IN = %SUBST(TransID:1:15)
103100200528     C                   EVAL      DDTRANR_IN = %SUBST(TransID:16:16)
103200200528
103300200528     C                   CALL      'FTM1012R'
103400200528     C                   PARM                    AuthComp
103500200528     C                   PARM                    FwdBck
103600200528     C                   PARM                    DDRFTID_IN       15
103700200528     C                   PARM                    DDTRANR_IN       16
103800200528     C                   PARM                    Buffer
103900200528     C                   PARM                    FldNameArr
104000200528     C                   PARM                    MsgIDArr
104100200528     C                   PARM                    MsgDtaArr
104200200528     C                   PARM                    MsgFArray
104300200528     C                   PARM                    APIRetC
104400200528
104500200528      ** CCT - Customer Credit Transfer
104600200528
104700200528     C     TransTYPE     WHENEQ    'CCTD'
104800200528
104900200528     C                   MOVEL     TransID       DDCCTID_In
105000200528
105100200528     C                   CALL      'FTM1021R'
105200200528     C                   PARM                    AuthComp
105300200528     C                   PARM                    FwdBck
105400200528     C                   PARM                    DDCCTID_IN       15
105500200528     C                   PARM                    Buffer
105600200528     C                   PARM                    FldNameArr
105700200528     C                   PARM                    MsgIDArr
105800200528     C                   PARM                    MsgDtaArr
105900200528     C                   PARM                    MsgFArray
106000200528     C                   PARM                    APIRetC
106100200528
106200200528      ** CCT - Customer Credit Transfer details
106300200528
106400200528     C     TransTYPE     WHENEQ    'CCT2'
106500200528
106600200528     C                   EVAL      DDCCTID_IN = %SUBST(TransID:1:15)
106700200528     C                   EVAL      DDTRANR_IN = %SUBST(TransID:16:16)
106800200528
106900200528     C                   CALL      'FTM1022R'
107000200528     C                   PARM                    AuthComp
107100200528     C                   PARM                    FwdBck
107200200528     C                   PARM                    DDCCTID_IN       15
107300200528     C                   PARM                    DDTRANR_IN       16
107400200528     C                   PARM                    Buffer
107500200528     C                   PARM                    FldNameArr
107600200528     C                   PARM                    MsgIDArr
107700200528     C                   PARM                    MsgDtaArr
107800200528     C                   PARM                    MsgFArray
107900200528     C                   PARM                    APIRetC
108000200528
108100200528      ** OTCC - Futures and Options Currency OTC
108200200528
108300200528     C     TransTYPE     WHENEQ    'OTCC'
108400200528
108500200528     C                   MOVEL     TransID       DDTRNO_In
108600200528
108700200528     C                   CALL      'FFOTCCR'
108800200528     C                   PARM                    AuthComp
108900200528     C                   PARM                    FwdBck
109000200528     C                   PARM                    DDTRNO_IN         6
109100200528     C                   PARM                    Buffer
109200200528     C                   PARM                    FldNameArr
109300200528     C                   PARM                    MsgIDArr
109400200528     C                   PARM                    MsgDtaArr
109500200528     C                   PARM                    MsgFArray
109600200528     C                   PARM                    APIRetC
109700200528
109800200528      ** OTCO - Futures and Options Non currency OTC
109900200528
110000200528     C     TransTYPE     WHENEQ    'OTCO'
110100200528
110200200528     C                   MOVEL     TransID       DDTRNO_In
110300200528
110400200528     C                   CALL      'FFOTCOR'
110500200528     C                   PARM                    AuthComp
110600200528     C                   PARM                    FwdBck
110700200528     C                   PARM                    DDTRNO_IN
110800200528     C                   PARM                    Buffer
110900200528     C                   PARM                    FldNameArr
111000200528     C                   PARM                    MsgIDArr
111100200528     C                   PARM                    MsgDtaArr
111200200528     C                   PARM                    MsgFArray
111300200528     C                   PARM                    APIRetC
111400200528
111500200528      ** EXTR - Futures and Options Exchange-Traded Transactions
111600200528
111700200528     C     TransTYPE     WHENEQ    'EXTR'
111800200528
111900200528     C                   MOVEL     TransID       DDTRNO_In
112000200528
112100200528     C                   CALL      'FFEXTRR'
112200200528     C                   PARM                    AuthComp
112300200528     C                   PARM                    FwdBck
112400200528     C                   PARM                    DDTRNO_IN         6
112500200528     C                   PARM                    Buffer
112600200528     C                   PARM                    FldNameArr
112700200528     C                   PARM                    MsgIDArr
112800200528     C                   PARM                    MsgDtaArr
112900200528     C                   PARM                    MsgFArray
113000200528     C                   PARM                    APIRetC
113100200528
113200200528      * SE Depot Movements
113300200528     C     TransTYPE     WHENEQ    'DPWI'
113400200528     C     TransTYPE     OREQ      'DPWO'
113500200528     C     TransTYPE     OREQ      'DPMV'                                                     CAP087
113600200528
113700200528     C*******************MOVEL     TransID       TempWork          8                          CAP087
113800200528     C*******************MOVEL     TempWork      DDDPRN_IN                                    CAP087
113900200528     C*******************MOVE      TempWork      DDDPMV_IN                                    CAP087
114000200528     C                   MOVEL     TransID       TempWork         18                          CAP087
114100200528     C     10            SUBST     TransID:1     DDDPSS_In        10                          CAP087
114200200528     C     6             SUBST     TransID:11    DDDPRN_In                                    CAP087
114300200528     C     2             SUBST     TransID:17    DDDPMV_In                                    CAP087
114400200528
114500200528     C                   CALL      'SEDPMVR'
114600200528     C                   PARM                    AuthComp
114700200528     C                   PARM                    FwdBck
114800200528     C                   PARM                    DDDPMV_IN         2
114900200528     C                   PARM                    DDDPRN_IN         6
115000200528     C                   PARM                    DDDPSS_In                                   BUG9994
115100200528     C                   PARM                    Buffer
115200200528     C                   PARM                    FldNameArr
115300200528     C                   PARM                    MsgIDArr
115400200528     C                   PARM                    MsgDtaArr
115500200528     C                   PARM                    MsgFArray
115600200528     C                   PARM                    APIRetC
115700200528
115800200528      * MM Negotiable Assets Purchased
115900200528
116000200528     C     TransTYPE     WHENEQ    'NASP'
116100200528
116200200528     C                   MOVEL     TransID       DDDLNO_In
116300200528
116400200528     C                   CALL      'MMNASPR'
116500200528     C                   PARM                    AuthComp
116600200528     C                   PARM                    FwdBck
116700200528     C                   PARM                    DDDLNO_In
116800200528     C                   PARM                    Buffer
116900200528     C                   PARM                    FldNameArr
117000200528     C                   PARM                    MsgIDArr
117100200528     C                   PARM                    MsgDtaArr
117200200528     C                   PARM                    MsgFArray
117300200528     C                   PARM                    APIRetC
117400200528
117500200528      * MM Negotiable Assets Sold
117600200528
117700200528     C     TransTYPE     WHENEQ    'NASS'
117800200528
117900200528     C                   MOVEL     TransID       DDDLNO_In
118000200528
118100200528     C                   CALL      'MMNASSR'
118200200528     C                   PARM                    AuthComp
118300200528     C                   PARM                    FwdBck
118400200528     C                   PARM                    DDDLNO_In
118500200528     C                   PARM                    Buffer
118600200528     C                   PARM                    FldNameArr
118700200528     C                   PARM                    MsgIDArr
118800200528     C                   PARM                    MsgDtaArr
118900200528     C                   PARM                    MsgFArray
119000200528     C                   PARM                    APIRetC
119100200528
119200200528     C     TransTYPE     WHENEQ    'RODL'
119300200528
119400200528     C                   MOVEL     TransID       DDDLNO_In
119500200528
119600200528     C                   CALL      'MMRODLR'
119700200528     C                   PARM                    AuthComp
119800200528     C                   PARM                    FwdBck
119900200528     C                   PARM                    DDDLNO_In
120000200528     C                   PARM                    Buffer
120100200528     C                   PARM                    FldNameArr
120200200528     C                   PARM                    MsgIDArr
120300200528     C                   PARM                    MsgDtaArr
120400200528     C                   PARM                    MsgFArray
120500200528     C                   PARM                    APIRetC
120600200528
120700200528     C     TransTYPE     WHENEQ    'CACF'
120800200528
120900200528     C                   MOVEL     TransID       DDDLNO_In
121000200528
121100200528     C                   CALL      'IRCACFR'
121200200528     C                   PARM                    AuthComp
121300200528     C                   PARM                    FwdBck
121400200528     C                   PARM                    DDDLNO_In
121500200528     C                   PARM                    Buffer
121600200528     C                   PARM                    Buffer2                                     BUG5403
121700200528     C                   PARM                    BufferEx2                                   BUG5403
121800200528     C                   PARM                    FldNameArr
121900200528     C                   PARM                    MsgIDArr
122000200528     C                   PARM                    MsgDtaArr
122100200528     C                   PARM                    MsgFArray
122200200528     C                   PARM                    APIRetC
122300200528
122400200528      ** CLS Pay-in Schedules Header
122500200528
122600200528     C     TransTYPE     WHENEQ    'CLSP'
122700200528
122800200528     C                   MOVEL     TransID       PCcy_In
122900200528     C                   EVAL      PNost_In = %SUBST(TransID:4:2)
123000200528     C                   EVAL      PVDate_In = %SUBST(TransID:6:6)
123100200528     C                   EVAL      PSeq_In = %SUBST(TransID:12:2)
123200200528
123300200528     C                   CALL      'FXCLSPR'
123400200528     C                   PARM                    AuthComp
123500200528     C                   PARM                    FwdBck
123600200528     C                   PARM                    PCCy_In           3
123700200528     C                   PARM                    PNost_In          2
123800200528     C                   PARM                    PVDate_In         6
123900200528     C                   PARM                    PSeq_In           2
124000200528     C                   PARM                    Buffer
124100200528     C                   PARM                    FldNameArr
124200200528     C                   PARM                    MsgIDArr
124300200528     C                   PARM                    MsgDtaArr
124400200528     C                   PARM                    MsgFArray
124500200528     C                   PARM                    APIRetC
124600200528
124700200528      ** CLS Pay-in Schedules Detail
124800200528
124900200528     C     TransTYPE     WHENEQ    'CLS2'
125000200528
125100200528     C                   MOVEL     TransID       PCcy_In
125200200528     C                   EVAL      PNost_In = %SUBST(TransID:4:2)
125300200528     C                   EVAL      PVDate_In = %SUBST(TransID:6:6)
125400200528     C                   EVAL      PSeq_In = %SUBST(TransID:12:2)
125500200528     C                   EVAL      PTime_In = %SUBST(TransID:14:4)
125600200528      *******************EVAL      PAmt_In = %SUBST(TransID:18:18)                           BUG5671
125700200528     C                   EVAL      PDSeq_In = %SUBST(TransID:18:2)                           BUG5671
125800200528
125900200528     C                   CALL      'FXCLSPR2'
126000200528     C                   PARM                    AuthComp
126100200528     C                   PARM                    FwdBck
126200200528     C                   PARM                    PCCy_In           3
126300200528     C                   PARM                    PNost_In          2
126400200528     C                   PARM                    PVDate_In         6
126500200528     C                   PARM                    PSeq_In           2
126600200528     C                   PARM                    PTime_In          4
126700200528      *******************PARM                    PAmt_In          18                         BUG5671
126800200528     C                   PARM                    PDSeq_In          2                         BUG5671
126900200528     C                   PARM                    Buffer
127000200528     C                   PARM                    FldNameArr
127100200528     C                   PARM                    MsgIDArr
127200200528     C                   PARM                    MsgDtaArr
127300200528     C                   PARM                    MsgFArray
127400200528     C                   PARM                    APIRetC
127500200528
127600200528      ** INTC Internal Contracts
127700200528
127800200528     C     TransTYPE     WHENEQ    'INTC'
127900200528
128000200528     C                   EVAL      DDL1DN_IN = %SUBST(TransID:1:6)
128100200528     C                   EVAL      DDL2DN_IN = %SUBST(TransID:7:12)
128200200528     C                   EVAL      DDBRCD_IN = %SUBST(TransID:13:15)
128300200528     C                   EVAL      DDORBR_IN = %SUBST(TransID:16:18)
128400200528
128500200528     C                   CALL      'ABINTCR'
128600200528     C                   PARM                    AuthComp
128700200528     C                   PARM                    FwdBck
128800200528     C                   PARM                    DDL1DN_In         6
128900200528     C                   PARM                    DDL2DN_In         6
129000200528     C                   PARM                    DDBRCD_In         3
129100200528     C                   PARM                    DDORBR_In         3
129200200528     C                   PARM                    Buffer
129300200528     C                   PARM                    FldNameArr
129400200528     C                   PARM                    MsgIDArr
129500200528     C                   PARM                    MsgDtaArr
129600200528     C                   PARM                    MsgFArray
129700200528     C                   PARM                    APIRetC
129800200528
129900200528      ** AB Internal Funding Deals
130000200528
130100200528     C     TransTYPE     WHENEQ    'FUND'
130200200528
130300200528     C                   MOVEL     TransID       DDDLNO_In
130400200528
130500200528     C                   CALL      'ABFUNDR'
130600200528     C                   PARM                    AuthComp
130700200528     C                   PARM                    FwdBck
130800200528     C                   PARM                    DDDLNO_In
130900200528     C                   PARM                    Buffer
131000200528     C                   PARM                    FldNameArr
131100200528     C                   PARM                    MsgIDArr
131200200528     C                   PARM                    MsgDtaArr
131300200528     C                   PARM                    MsgFArray
131400200528     C                   PARM                    APIRetC
131500200528
131600200528      ** GL Batch Headers
131700200528      ** GL Journal Header Maintenance - Non-retail                                          BUG9009
131800200528
131900200528     C     TransTYPE     WHENEQ    'BITH'
132000200528     C     TransTYPE     OrEq      'BINH'                                                    BUG9009
132100200528
132200200528     C                   MOVEL     TransID       DDBTNB_In
132300200528
132400200528     C                   CALL      'GLBITHR'
132500200528     C                   PARM                    AuthComp
132600200528     C                   PARM                    FwdBck
132700200528     C                   PARM                    DDBTNB_In         3
132800200528     C                   PARM                    Buffer
132900200528     C                   PARM                    FldNameArr
133000200528     C                   PARM                    MsgIDArr
133100200528     C                   PARM                    MsgDtaArr
133200200528     C                   PARM                    MsgFArray
133300200528     C                   PARM                    APIRetC
133400200528
133500200528      ** GL Batch Items
133600200528      ** GL Journal Entry Item Maintenance - Non-retail                                      BUG9009
133700200528
133800200528     C     TransTYPE     WHENEQ    'BITP'
133900200528     C     TransTYPE     OrEq      'BINP'                                                    BUG9009
134000200528
134100200528     C                   MOVEL     TransID       DDBTNB_In
134200200528     C                   EVAL      DDBTNB_IN = %SUBST(TransID:1:3)
134300200528     C                   EVAL      DDBINB_IN = %SUBST(TransID:4:6)
134400200528
134500200528     C                   CALL      'GLBITPR'
134600200528     C                   PARM                    AuthComp
134700200528     C                   PARM                    FwdBck
134800200528     C                   PARM                    DDBTNB_In         3
134900200528     C                   PARM                    DDBINB_In         3
135000200528     C                   PARM                    Buffer
135100200528     C                   PARM                    FldNameArr
135200200528     C                   PARM                    MsgIDArr
135300200528     C                   PARM                    MsgDtaArr
135400200528     C                   PARM                    MsgFArray
135500200528     C                   PARM                    APIRetC
135600200528
135700200528      ** SD Spot Rates
135800200528
135900200528     C     TransTYPE     WHENEQ    'SPTR'
136000200528
136100200528     C                   MOVEL     TransID       DDCYCD_In
136200200528
136300200528     C                   CALL      'SDSPTRR'
136400200528     C                   PARM                    AuthComp
136500200528     C                   PARM                    FwdBck
136600200528     C                   PARM                    DDCYCD_In
136700200528     C                   PARM                    Buffer
136800200528     C                   PARM                    FldNameArr
136900200528     C                   PARM                    MsgIDArr
137000200528     C                   PARM                    MsgDtaArr
137100200528     C                   PARM                    MsgFArray
137200200528     C                   PARM                    APIRetC
137300200528
137400200528      ** IPAY SWIFT API
137500200528     C     TransTYPE     WHENEQ    'IPSW'
137600200528
137700200528     C                   MOVEL     TransID       DDMSGR_In         8
137800200528     C     3             SUBST     TransID:9     DDPART_In         3
137900200528
138000200528     C                   CALL      'FTIPSWR'
138100200528     C                   PARM                    DDMSGR_In
138200200528     C                   PARM                    DDPART_In
138300200528     C                   PARM                    Buffer
138400200528     C                   PARM                    FldNameArr
138500200528     C                   PARM                    MsgIDArr
138600200528     C                   PARM                    MsgDtaArr
138700200528     C                   PARM                    MsgFArray
138800200528     C                   PARM                    APIRetc
138900200528                                                                                              CSC021
139000200528      ** Help Link API                                                                        CSC021
139100200528     C     TransTYPE     WHENEQ    'HELP'                                                     CSC021
139200200528                                                                                              CSC021
139300200528     C                   EVAL      CallFm_IN = %SUBST(APParm:3:1)                             CSC021
139400200528     C                   EVAL      KeyInf_IN = %SUBST(APParm:4:200)                           CSC021
139500200528                                                                                              CSC021
139600200528     C                   CALL      'SCHELPR'                                                  CSC021
139700200528     C                   PARM                    CallFm_In         1                          CSC021
139800200528     C                   PARM                    KeyInf_In       200                          CSC021
139900200528     C                   PARM                    Buffer                                       CSC021
140000200528     C                   PARM                    FldNameArr                                   CSC021
140100200528     C                   PARM                    MsgIDArr                                     CSC021
140200200528     C                   PARM                    MsgDtaArr                                    CSC021
140300200528     C                   PARM                    MsgFArray                                    CSC021
140400200528     C                   PARM                    APIRetc                                      CSC021
140500200528
140600200528      ** FD Forward rates API
140700200528
140800200528     C     TransTYPE     WHENEQ    'FWRT'
140900200528
141000200528     C                   MOVEL     TransID       DDCCY_In          3
141100200528
141200200528     C                   CALL      'FDFWRTR'
141300200528     C                   PARM                    AuthComp
141400200528     C                   PARM                    FwdBck
141500200528     C                   PARM                    DDCCY_In
141600200528     C                   PARM                    Buffer
141700200528     C                   PARM                    FldNameArr
141800200528     C                   PARM                    MsgIDArr
141900200528     C                   PARM                    MsgDtaArr
142000200528     C                   PARM                    MsgFArray
142100200528     C                   PARM                    APIRetC
142200200528
142300200528     C     TransTYPE     WHENEQ    'INTR'
142400200528
142500200528     C                   MOVEL     TransID       DDCYCD_In
142600200528
142700200528     C                   CALL      'FDINTRR'
142800200528     C                   PARM                    AuthComp
142900200528     C                   PARM                    FwdBck
143000200528     C                   PARM                    DDCYCD_In
143100200528     C                   PARM                    Buffer
143200200528     C                   PARM                    FldNameArr
143300200528     C                   PARM                    MsgIDArr
143400200528     C                   PARM                    MsgDtaArr
143500200528     C                   PARM                    MsgFArray
143600200528     C                   PARM                    APIRetC
143700200528                                                                                             BUG1055
143800200528      ** SE Security Diary Events                                                            BUG1055
143900200528                                                                                             BUG1055
144000200528     C     TransTYPE     WHENEQ    'SEDE'                                                    BUG1055
144100200528                                                                                             BUG1055
144200200528     C                   EVAL      DDSDSN_IN = %SUBST(TransID:1:10)                          BUG1055
144300200528     C                   EVAL      DDSDED_IN = %SUBST(TransID:11:6)                          BUG1055
144400200528     C                   EVAL      DDSDET_IN = %SUBST(TransID:17:2)                          BUG1055
144500200528                                                                                             BUG1055
144600200528     C                   CALL      'SESEDER'                                                 BUG1055
144700200528     C                   PARM                    AuthComp                                    BUG1055
144800200528     C                   PARM                    FwdBck                                      BUG1055
144900200528     C                   PARM                    DDSDSN_In        10                         BUG1055
145000200528     C                   PARM                    DDSDED_In         6                         BUG1055
145100200528     C                   PARM                    DDSDET_In         2                         BUG1055
145200200528     C                   PARM                    Buffer                                      BUG1055
145300200528     C                   PARM                    FldNameArr                                  BUG1055
145400200528     C                   PARM                    MsgIDArr                                    BUG1055
145500200528     C                   PARM                    MsgDtaArr                                   BUG1055
145600200528     C                   PARM                    MsgFArray                                   BUG1055
145700200528     C                   PARM                    APIRetC                                     BUG1055
145800200528                                                                                             BUG1055
145900200528                                                                                             BUG1057
146000200528      ** SE Securities Prices                                                                BUG1057
146100200528                                                                                             BUG1057
146200200528     C     TransTYPE     WHENEQ    'PRCS'                                                    BUG1057
146300200528                                                                                             BUG1057
146400200528     C                   EVAL      DDPSSN_In = %SUBST(TransID:1:10)                          BUG1057
146500200528     C                   EVAL      DDPCNM_In = %SUBST(TransID:11:10)                         BUG1057
146600200528     C                   EVAL      DDPMKT_In = %SUBST(TransID:21:1)                          BUG1057
146700200528     C                   EVAL      DDPBRA_In = %SUBST(TransID:22:3)                          BUG1057
146800200528     C                   EVAL      DDPBOK_In = %SUBST(TransID:25:2)                          BUG1057
146900200528     C                   EVAL      DDPPRT_In = %SUBST(TransID:27:2)                          BUG1057
147000200528     C                   EVAL      DDPTFR_In = %SUBST(TransID:29:4)                          BUG1057
147100200528     C                                                                                       BUG1057
147200200528     C                   CALL      'SEPRCSR'                                                 BUG1057
147300200528     C                   PARM                    AuthComp                                    BUG1057
147400200528     C                   PARM                    FwdBck                                      BUG1057
147500200528     C                   PARM                    DDPSSN_In        10                         BUG1057
147600200528     C                   PARM                    DDPCNM_In        10                         BUG1057
147700200528     C                   PARM                    DDPMKT_In         1                         BUG1057
147800200528     C                   PARM                    DDPBRA_In         3                         BUG1057
147900200528     C                   PARM                    DDPBOK_In         2                         BUG1057
148000200528     C                   PARM                    DDPPRT_In         2                         BUG1057
148100200528     C                   PARM                    DDPTFR_In         4                         BUG1057
148200200528     C                   PARM                    Buffer                                      BUG1057
148300200528     C                   PARM                    FldNameArr                                  BUG1057
148400200528     C                   PARM                    MsgIDArr                                    BUG1057
148500200528     C                   PARM                    MsgDtaArr                                   BUG1057
148600200528     C                   PARM                    MsgFArray                                   BUG1057
148700200528     C                   PARM                    APIRetC                                     BUG1057
148800200528                                                                                             CGP010
148900200528      ** BSPL Requests                                                                       CGP010
149000200528                                                                                             CGP010
149100200528     C     TransTYPE     WHENEQ    'BSRQ'                                                    CGP010
149200200528                                                                                             CGP010
149300200528     C                   EVAL      DDRQTYP_In = %SUBST(TransID:1:1)                          CGP010
149400200528     C                   EVAL      DDRQID_In  = %SUBST(TransID:2:15)                         CGP010
149500200528     C                                                                                       CGP010
149600200528     C                   CALL      'GOBSRQR'                                                 CGP010
149700200528     C                   PARM                    DDRQTYP_In        1                         CGP010
149800200528     C                   PARM                    DDRQID_In        15                         CGP010
149900200528     C                   PARM                    Buffer                                      CGP010
150000200528     C                   PARM                    FldNameArr                                  CGP010
150100200528     C                   PARM                    MsgIDArr                                    CGP010
150200200528     C                   PARM                    MsgDtaArr                                   CGP010
150300200528     C                   PARM                    MsgFArray                                   CGP010
150400200528     C                   PARM                    APIRetC                                     CGP010
150500200528                                                                                             BUG6417
150600200528      ** Cash Management Interest Statement                                                  BUG6417
150700200528                                                                                             BUG6417
150800200528     C     TransTYPE     WHENEQ    'RISL'                                                    BUG6417
150900200528                                                                                             BUG6417
151000200528     C                   MOVEL     TransID       I_RACCID                                    BUG6417
151100200528     C                   EVAL      I_R_DR_CR = %subst(Buffer: 1 : 1 )                        BUG6417
151200200528     C                   EVAL      I_SPnt    = %subst(Buffer: 2 : 5 )                        BUG6417
151300200528                                                                                             BUG6417
151400200528     C                   CALL      'RE104001'                                                BUG6417
151500200528     C                   PARM                    I_RACCID         24                         BUG6417
151600200528     C                   PARM                    I_R_DR_CR         1                         BUG6417
151700200528     C                   PARM                    I_SPnt            5                         BUG6417
151800200528     C                   PARM                    Buffer                                      BUG6417
151900200528     C                   PARM                    FldNameArr                                  BUG6417
152000200528     C                   PARM                    MsgIDArr                                    BUG6417
152100200528     C                   PARM                    MsgDtaArr                                   BUG6417
152200200528     C                   PARM                    MsgFArray                                   BUG6417
152300200528     C                   PARM                    APIRetc           1                         BUG6417
152400200528                                                                                              CAS011
152500200528      ** DL Dealing Fees                                                                      CAS011
152600200528                                                                                              CAS011
152700200528     C     TransTYPE     WHENEQ    'DLFE'                                                     CAS011
152800200528                                                                                              CAS011
152900200528     C                   EVAL      DDDLNO_IN = %SUBST(TransID:1:6)                            CAS011
153000200528     C                   EVAL      DDDFSQ_IN = %SUBST(TransID:7:8)                            CAS011
153100200528                                                                                              CAS011
153200200528     C                   CALL      'DLDLFER'                                                  CAS011
153300200528     C                   PARM                    AuthComp                                     CAS011
153400200528     C                   PARM                    FwdBck                                       CAS011
153500200528     C                   PARM                    DDDLNO_IN                                    CAS011
153600200528     C                   PARM                    DDDFSQ_IN         2                          CAS011
153700200528     C                   PARM                    Buffer                                       CAS011
153800200528     C                   PARM                    FldNameArr                                   CAS011
153900200528     C                   PARM                    MsgIDArr                                     CAS011
154000200528     C                   PARM                    MsgDtaArr                                    CAS011
154100200528     C                   PARM                    MsgFArray                                    CAS011
154200200528     C                   PARM                    APIRetC                                      CAS011
154300200528      *
154400200528      ** Collateral Type Details Retrieval                                                    CRE026
154500200528      *                                                                                       CRE026
154600200528     C     TransTYPE     WHENEQ    'COTY'                                                     CRE026
154700200528                                                                                              CRE026
154800200528     C                   MOVEL     TransID       DDCOLT_In                                    CRE026
154900200528                                                                                              CRE026
155000200528     C                   CALL      'SDCOTYR'                                                  CRE026
155100200528     C                   PARM                    AuthComp                                     CRE026
155200200528     C                   PARM                    FwdBck                                       CRE026
155300200528     C                   PARM                    DDCOLT_In         5                          CRE026
155400200528     C                   PARM                    Buffer                                       CRE026
155500200528     C                   PARM                    FldNameArr                                   CRE026
155600200528     C                   PARM                    MsgIDArr                                     CRE026
155700200528     C                   PARM                    MsgDtaArr                                    CRE026
155800200528     C                   PARM                    MsgFArray                                    CRE026
155900200528     C                   PARM                    APIRetC                                      CRE026
156000200528      *                                                                                       CRE026
156100200528      ** Country Details Retrieval                                                            CRE026
156200200528      *                                                                                       CRE026
156300200528     C     TransTYPE     WHENEQ    'CNTY'                                                     CRE026
156400200528                                                                                              CRE026
156500200528     C                   MOVEL     TransID       DDCNCD_In                                    CRE026
156600200528                                                                                              CRE026
156700200528     C                   CALL      'SDCNTYR'                                                  CRE026
156800200528     C                   PARM                    AuthComp                                     CRE026
156900200528     C                   PARM                    FwdBck                                       CRE026
157000200528     C                   PARM                    DDCNCD_In         2                          CRE026
157100200528     C                   PARM                    Buffer                                       CRE026
157200200528     C                   PARM                    FldNameArr                                   CRE026
157300200528     C                   PARM                    MsgIDArr                                     CRE026
157400200528     C                   PARM                    MsgDtaArr                                    CRE026
157500200528     C                   PARM                    MsgFArray                                    CRE026
157600200528     C                   PARM                    APIRetC                                      CRE026
157700200528      *                                                                                       CRE026
157800200528      ** Alternate Name and Addresses Retrieval                                               CRE026
157900200528      *                                                                                       CRE026
158000200528     C     TransTYPE     WHENEQ    'ALNA'                                                     CRE026
158100200528     C     TransTYPE     OREQ      'ALNU'                                                     CRE026
158200200528                                                                                              CRE026
158300200528     C                   EVAL      DDCUST_In = %SUBST(TransID:1:6)                            CRE026
158400200528     C                   EVAL      DDADCD_In = %SUBST(TransID:7:1)                            CRE026
158500200528                                                                                              CRE026
158600200528     C                   CALL      'SDALNAR'                                                  CRE026
158700200528     C                   PARM                    AuthComp                                     CRE026
158800200528     C                   PARM                    FwdBck                                       CRE026
158900200528     C                   PARM                    DDCUST_In         6                          CRE026
159000200528     C                   PARM                    DDADCD_In         1                          CRE026
159100200528     C                   PARM                    Buffer                                       CRE026
159200200528     C                   PARM                    FldNameArr                                   CRE026
159300200528     C                   PARM                    MsgIDArr                                     CRE026
159400200528     C                   PARM                    MsgDtaArr                                    CRE026
159500200528     C                   PARM                    MsgFArray                                    CRE026
159600200528     C                   PARM                    APIRetC                                      CRE026
159700200528      *                                                                                       CRE026
159800200528      ** User Definitions + Menu Items Details Retrieval                                      CRE026
159900200528      *                                                                                       CRE026
160000200528     C     TransTYPE     WHENEQ    'AMUS'                                                     CRE026
160100200528                                                                                              CRE026
160200200528     C                   MOVEL     TransID       DDUSRP_In                                    CRE026
160300200528                                                                                              CRE026
160400200528     C                   CALL      'SFAMUSR'                                                  CRE026
160500200528     C                   PARM                    AuthComp                                     CRE026
160600200528     C                   PARM                    FwdBck                                       CRE026
160700200528     C                   PARM                    DDUSRP_In        10                          CRE026
160800200528     C                   PARM                    Buffer                                       CRE026
160900200528     C                   PARM                    Buffer2                                      CRE026
161000200528     C                   PARM                    FldNameArr                                   CRE026
161100200528     C                   PARM                    MsgIDArr                                     CRE026
161200200528     C                   PARM                    MsgDtaArr                                    CRE026
161300200528     C                   PARM                    MsgFArray                                    CRE026
161400200528     C                   PARM                    APIRetC                                      CRE026
161500200528      *                                                                                       CRE026
161600200528      ** Nostro Codes Detail Retrieval                                                        CRE026
161700200528      *                                                                                       CRE026
161800200528     C     TransTYPE     WHENEQ    'NOSR'                                                     CRE026
161900200528     C     TransTYPE     OREQ      'NOSU'                                                     CRE026
162000200528                                                                                              CRE026
162100200528     C                   EVAL      DDCYCD_In = %SUBST(TransID:1:3)                            CRE026
162200200528     C                   EVAL      DDNONB_In = %SUBST(TransID:4:2)                            CRE026
162300200528                                                                                              CRE026
162400200528     C                   CALL      'SDNOSRR'                                                  CRE026
162500200528     C                   PARM                    AuthComp                                     CRE026
162600200528     C                   PARM                    FwdBck                                       CRE026
162700200528     C                   PARM                    DDCYCD_In         3                          CRE026
162800200528     C                   PARM                    DDNONB_In         2                          CRE026
162900200528     C                   PARM                    Buffer                                       CRE026
163000200528     C                   PARM                    FldNameArr                                   CRE026
163100200528     C                   PARM                    MsgIDArr                                     CRE026
163200200528     C                   PARM                    MsgDtaArr                                    CRE026
163300200528     C                   PARM                    MsgFArray                                    CRE026
163400200528     C                   PARM                    APIRetC                                      CRE026
163500200528      *                                                                                       CRE026
163600200528      ** Yield Curve Detail Retrieval                                                         CRE026
163700200528      *                                                                                       CRE026
163800200528     C     TransTYPE     WHENEQ    'YLCU'                                                     CRE026
163900200528                                                                                              CRE026
164000200528     C                   MOVEL     TransID       DDYLDC_In                                    CRE026
164100200528                                                                                              CRE026
164200200528     C                   CALL      'SDYLCUR'                                                  CRE026
164300200528     C                   PARM                    AuthComp                                     CRE026
164400200528     C                   PARM                    FwdBck                                       CRE026
164500200528     C                   PARM                    DDYLDC_In         5                          CRE026
164600200528     C                   PARM                    Buffer                                       CRE026
164700200528     C                   PARM                    FldNameArr                                   CRE026
164800200528     C                   PARM                    MsgIDArr                                     CRE026
164900200528     C                   PARM                    MsgDtaArr                                    CRE026
165000200528     C                   PARM                    MsgFArray                                    CRE026
165100200528     C                   PARM                    APIRetC                                      CRE026
165200200528      *                                                                                       CRE026
165300200528      ** Yield Rate Detail Retrieval                                                          CRE026
165400200528      *                                                                                       CRE026
165500200528     C     TransTYPE     WHENEQ    'YRAT'                                                     CRE026
165600200528                                                                                              CRE026
165700200528     C                   EVAL      #0YLDC    = %SUBST(TransID:1:5)                            CRE026
165800200528     C                   EVAL      #0YCCY    = %SUBST(TransID:6:3)                            CRE026
165900200528     C                   EVAL      #0YICM    = %SUBST(TransID:9:1)                            CRE026
166000200528     C                   EVAL      #0YCFQ    = %SUBST(TransID:10:1)                           CRE026
166100200528     C                   EVAL      #0SPDY    = %SUBST(TransID:11:2)                           CRE026
166200200528                                                                                              CRE026
166300200528     C                   CALL      'SDYRATR'                                                  CRE026
166400200528     C                   PARM                    AuthComp                                     CRE026
166500200528     C                   PARM                    FwdBck                                       CRE026
166600200528     C                   PARM                    #0YLDC            5                          CRE026
166700200528     C                   PARM                    #0YCCY            3                          CRE026
166800200528     C                   PARM                    #0YICM            1                          CRE026
166900200528     C                   PARM                    #0YCFQ            1                          CRE026
167000200528     C                   PARM                    #0SPDY            2                          CRE026
167100200528     C                   PARM                    Buffer                                       CRE026
167200200528     C                   PARM                    FldNameArr                                   CRE026
167300200528     C                   PARM                    MsgIDArr                                     CRE026
167400200528     C                   PARM                    MsgDtaArr                                    CRE026
167500200528     C                   PARM                    MsgFArray                                    CRE026
167600200528     C                   PARM                    APIRetC                                      CRE026
167700200528      *                                                                                       CRE026
167800200528      ** Risk Weighted Asset Detail Retrieval                                                 CSD079
167900200528      *                                                                                       CSD079
168000200528     C     TransTYPE     WHENEQ    'RWAN'                                                     CSD079
168100200528                                                                                              CSD079
168200200528     C                   MOVEL     TransID       DDCUST_In                                    CSD079
168300200528                                                                                              CSD079
168400200528     C                   CALL      'SDRWANR'                                                  CSD079
168500200528     C                   PARM                    AuthComp                                     CSD079
168600200528     C                   PARM                    FwdBck                                       CSD079
168700200528     C                   PARM                    DDCUST_In                                    CSD079
168800200528     C                   PARM                    Buffer                                       CSD079
168900200528     C                   PARM                    FldNameArr                                   CSD079
169000200528     C                   PARM                    MsgIDArr                                     CSD079
169100200528     C                   PARM                    MsgDtaArr                                    CSD079
169200200528     C                   PARM                    MsgFArray                                    CSD079
169300200528     C                   PARM                    APIRetC                                      CSD079
169400200528      *                                                                                       CSD079
169500200528      ** Customer Withholding Tax Detail Retrieval                                            CSD079
169600200528      *                                                                                       CSD079
169700200528     C     TransTYPE     WHENEQ    'CUWT'                                                     CSD079
169800200528     C     TransTYPE     OREQ      'CUWU'                                                     CSD079
169900200528                                                                                              CSD079
170000200528     C                   EVAL      DDCSNO_In = %SUBST(TransID:1:6)                            CSD079
170100200528                                                                                              CSD079
170200200528     C                   CALL      'SDCUWTR'                                                  CSD079
170300200528     C                   PARM                    AuthComp                                     CSD079
170400200528     C                   PARM                    FwdBck                                       CSD079
170500200528     C                   PARM                    DDCSNO_In                                    CSD079
170600200528     C                   PARM                    Buffer                                       CSD079
170700200528     C                   PARM                    FldNameArr                                   CSD079
170800200528     C                   PARM                    MsgIDArr                                     CSD079
170900200528     C                   PARM                    MsgDtaArr                                    CSD079
171000200528     C                   PARM                    MsgFArray                                    CSD079
171100200528     C                   PARM                    APIRetC                                      CSD079
171200200528                                                                                              CSD079
171300200528     C     TransTYPE     WHENEQ    'PDCL'                                                     CLE134
171400200528      *                                                                                       CLE134
171500200528     C                   EVAL      DDORLN_In = %SUBST(TransID:01:06)                          CLE134
171600200528     C                   EVAL      DDFECU_In = %SUBST(TransID:07:12)                          CLE134
171700200528     C                   EVAL      DDFFAC_In = %SUBST(TransID:13:17)                          CLE134
171800200528     C**********         EVAL      DDFESQ_In = %SUBST(TransID:18:19)                   CLE134 264044
171900200528     C                   EVAL      DDFSE2_In = %SUBST(TransID:18:19)                          264044
172000200528     C                   EVAL      DDFLNO_In = %SUBST(TransID:20:25)                          CLE134
172100200528     C                   EVAL      DDPLON_In = %SUBST(TransID:26:31)                          264044
172200200528     C                   EVAL      DDPLO2_In = %SUBST(TransID:32:37)                          264044
172300200528     C**********         EVAL      DDACTN_In = %SUBST(TransID:26:26)                   CLE134 264044
172400200528     C                   EVAL      DDACTN_In = %SUBST(TransID:38:38)                          264044
172500200528      *                                                                                       CLE134
172600200528     C                   CALL      'LEPDCLR'                                                  CLE134
172700200528     C                   PARM                    AuthComp                                     CLE134
172800200528     C                   PARM                    FwdBck                                       CLE134
172900200528     C                   PARM                    HeadIn                                    AR1078092
173000200528      *                                                                                       CLE134
173100200528      ** Key fields                                                                           CLE134
173200200528      *                                                                                       CLE134
173300200528     C                   PARM                    DDORLN_In                                    CLE134
173400200528     C                   PARM                    DDFECU_In                                    CLE134
173500200528     C                   PARM                    DDFFAC_In                                    CLE134
173600200528     C**********         PARM                    DDFESQ_In                             CLE134 264044
173700200528     C                   PARM                    DDFSE2_In                                    264044
173800200528     C                   PARM                    DDFLNO_In                                    CLE134
173900200528     C                   PARM                    DDPLON_In                                    264044
174000200528     C                   PARM                    DDPLO2_In                                    264044
174100200528      *                                                                                       264044
174200200528     C                   PARM                    DDACTN_In                                    CLE134
174300200528      *                                                                                       CLE134
174400200528      ** Buffers                                                                              CLE134
174500200528      *                                                                                       CLE134
174600200528     C                   PARM                    Buffer                                       CLE134
174700200528     C                   PARM                    FldNameArr                                   CLE134
174800200528     C                   PARM                    MsgIDArr                                     CLE134
174900200528     C                   PARM                    MsgDtaArr                                    CLE134
175000200528     C                   PARM                    MsgFArray                                    CLE134
175100200528     C                   PARM                    APIRetC                                      CLE134
175200200528
175300200528      *                                                                                       CAP210
175400200528      ** Dealing Adjustment to Accrued Interest                                               CAP210
175500200528      *                                                                                       CAP210
175600200528     C     TransTYPE     WHENEQ    'DLAA'                                                     CAP210
175700200528                                                                                              CAP210
175800200528     C                   MOVEL     TransID       DDDLNO_In                                    CAP210
175900200528     C     1             SUBST     TransID:19    DDACTN_In                                    CAP210
176000200528                                                                                              CAP210
176100200528     C                   CALL      'DLDLAAR'                                                  CAP210
176200200528     C                   PARM                    AuthComp                                     CAP210
176300200528     C                   PARM                    FwdBck                                       CAP210
176400200528     C                   PARM                    DDDLNO_In                                    CAP210
176500200528     C                   PARM                    Buffer                                       CAP210
176600200528     C                   PARM                    FldNameArr                                   CAP210
176700200528     C                   PARM                    MsgIDArr                                     CAP210
176800200528     C                   PARM                    MsgDtaArr                                    CAP210
176900200528     C                   PARM                    MsgFArray                                    CAP210
177000200528     C                   PARM                    APIRetc                                      CAP210
177100200528      *                                                                                       CAP210
177200200528     C     TransTYPE     WHENEQ    'CTNM'                                                  AR1086546
177300200528     C     TransTYPE     OREQ      'CCTN'                                                  AR1086546
177400200528                                                                                           AR1086546
177500200528     C                   MOVEL     TransID       DDCUST_In                                 AR1086546
177600200528                                                                                           AR1086546
177700200528     C                   CALL      'SDCTNMR'                                               AR1086546
177800200528     C                   PARM                    AuthComp                                  AR1086546
177900200528     C                   PARM                    FwdBck                                    AR1086546
178000200528     C                   PARM                    DDCUST_In                                 AR1086546
178100200528     C                   PARM                    Buffer                                    AR1086546
178200200528     C                   PARM                    FldNameArr                                AR1086546
178300200528     C                   PARM                    MsgIDArr                                  AR1086546
178400200528     C                   PARM                    MsgDtaArr                                 AR1086546
178500200528     C                   PARM                    MsgFArray                                 AR1086546
178600200528     C                   PARM                    APIRetC                                   AR1086546
178700200528      *                                                                                    AR1086546
178800200528      ** Document Management Retrieval                                                        CSD093
178900200528                                                                                              CSD093
179000200528     C     TransTYPE     WHENEQ    'DCMT'                                                     CSD093
179100200528                                                                                              CSD093
179200200528     C                   EVAL      DDREFN_In = %SUBST(TransID:1:10)                           CSD093
179300200528     C                   EVAL      DDRTYP_In = %SUBST(TransID:11:1)                           CSD093
179400200528     C                   EVAL      DDCODE_In = %SUBST(TransID:12:2)                           CSD093
179500200528     C                   EVAL      DDSEQN_In = %SUBST(TransID:14:3)                           CSD093
179600200528                                                                                              CSD093
179700200528     C                   CALL      'SDDCMTR'                                                  CSD093
179800200528     C                   PARM                    DDREFN_In        10                          CSD093
179900200528     C                   PARM                    DDRTYP_In         1                          CSD093
180000200528     C                   PARM                    DDCODE_In         2                          CSD093
180100200528     C                   PARM                    DDSEQN_In         3                          CSD093
180200200528     C                   PARM                    Buffer                                       CSD093
180300200528     C                   PARM                    FldNameArr                                   CSD093
180400200528     C                   PARM                    MsgIDArr                                     CSD093
180500200528     C                   PARM                    MsgDtaArr                                    CSD093
180600200528     C                   PARM                    MsgFArray                                    CSD093
180700200528     C                   PARM                    APIRetC                                      CSD093
180800200528                                                                                              CSD093
180900200528      ** Account Review Retrievel                                                             CSD092
181000200528                                                                                              CSD092
181100200528     C     TransTYPE     WHENEQ    'ACRV'                                                     CSD092
181200200528                                                                                              CSD092
181300200528     C                   EVAL      DDARCU_In = %SUBST(TransID:1:6)                            CSD092
181400200528     C                   EVAL      DDARSD_In = %SUBST(TransID:7:6)                            CSD092
181500200528     C                   EVAL      DDARSQ_In = %SUBST(TransID:13:3)                           CSD092
181600200528                                                                                              CSD092
181700200528     C                   CALL      'SDACRVR'                                                  CSD092
181800200528     C                   PARM                    DDARCU_In         6                          CSD092
181900200528     C                   PARM                    DDARSD_In         6                          CSD092
182000200528     C                   PARM                    DDARSQ_In         3                          CSD092
182100200528     C                   PARM                    Buffer                                       CSD092
182200200528     C                   PARM                    FldNameArr                                   CSD092
182300200528     C                   PARM                    MsgIDArr                                     CSD092
182400200528     C                   PARM                    MsgDtaArr                                    CSD092
182500200528     C                   PARM                    MsgFArray                                    CSD092
182600200528     C                   PARM                    APIRetC                                      CSD092
182700200528                                                                                              CSD092
182800200528      * Nostro Transfers                                                                      CAP212
182900200528                                                                                              CAP212
183000200528     C     TransTYPE     WHENEQ    'FTNT'                                                     CAP212
183100200528                                                                                              CAP212
183200200528     C                   MOVEL     TransID       DDPREF_In                                    CAP212
183300200528     C     1             SUBST     TransID:19    DDACTN_In                                    CAP212
183400200528                                                                                              CAP212
183500200528     C                   CALL      'FTFTNTR'                                                  CAP212
183600200528     C                   PARM                    AuthComp                                     CAP212
183700200528     C                   PARM                    FwdBck                                       CAP212
183800200528     C                   PARM                    DDPREF_In                                    CAP212
183900200528     C                   PARM                    DDACTN_In                                    CAP212
184000200528     C                   PARM                    Buffer                                       CAP212
184100200528     C                   PARM                    FldNameArr                                   CAP212
184200200528     C                   PARM                    MsgIDArr                                     CAP212
184300200528     C                   PARM                    MsgDtaArr                                    CAP212
184400200528     C                   PARM                    MsgFArray                                    CAP212
184500200528     C                   PARM                    APIRetC                                      CAP212
184600200528                                                                                              CAP212
184700200528      * If unknown API requested, make sure this is reported back
184800200528     C                   OTHER
184900200528     C                   EXSR      *PSSR
185000200528
185100200528     C                   ENDSL
185200200528
185300200528     C                   ENDSR
185400200528      ****************************************************************
185500200528      /SPACE 5
185600200528      ****************************************************************
185700200528      * Edit the Messages for output
185800200528      ****************************************************************
185900200528     C     EDTMSGS       BEGSR
186000200528                                                                                            AR885527
186100200528     C                   EVAL      APINam = TransType                                       AR885527
186200200528     C                   CALLB     'APEDTMSGS'
186300200528     C                   PARM                    FldNameArr
186400200528     C                   PARM                    MsgIDArr
186500200528     C                   PARM                    MsgDtaArr
186600200528     C                   PARM                    WFldNamArr
186700200528     C                   PARM                    WMsgIDArr
186800200528     C                   PARM                    WMsgDtaArr
186900200528     C                   PARM                    MsgFArray
187000200528     C                   PARM                    MsgArrOUT
187100200528     C                   PARM                    APINam                                     AR885527
187200200528     C                   ENDSR
187300200528      ****************************************************************
187400200528      /EJECT
187500200528      *****************************************************************
187600200528      * *PSSR - Program exception error routine                       *
187700200528      *                                                               *
187800200528      *****************************************************************
187900200528      ** The following /COPY contains the standard program status
188000200528      ** subroutine, excluding a bound call to the DBERRCTL module.
188100200528     C/COPY ZACPYSRC,PSSR_ILENE
188200200528     C                   EVAL      APIRetC = '0'
188300200528     C                   RETURN
188400200528     C                   ENDSR
188500200528      ****************************************************************
188600200528**  CPY@
188700200528(c) Finastra International Limited 2003
