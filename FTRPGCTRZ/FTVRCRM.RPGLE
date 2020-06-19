000100200528     H DEBUG
000200200528      *****************************************************************
000300200528/*STD *  RPGBASEMOD                                                   *
000400200528/*EXI *  TEXT('Midas FT Validate OP receivers charges remitted')      *
000500200528      *****************************************************************
000600200528      *                                                               *
000700200528      *  Midas - Standard Subprograms                                 *
000800200528      *                                                               *
000900200528      *  FTVRCRM   - Validate OP Receiver's Charges Remitted          *
001000200528      *                                                               *
001100200528      *    This source is centrally supported and must ONLY be        *
001200200528      *    amended by Core Development Personnel                      *
001300200528      *                                                               *
001400200528      *    /COPY, Client or Country amendments must not be            *
001500200528      *    applied to this source.                                    *
001600200528      *                                                               *
001700200528      *  (c) Finastra International Limited 2001                      *
001800200528      *                                                               *
001900200604      *  Last Amend No. 250041A            Date 22May20               *
002000200528      *  Prev Amend No. MD046248           Date 27Oct17               *
002100200528      *                 CFT157             Date 29Aug14               *
002200200528      *                 MD000091           Date 06May13               *
002300200528      *                 CFT120             Date 28Sep12               *
002400200528      *                 CSF011A            Date 28Nov11               *
002500200528      *                 CRE067             Date 05Oct10               *
002600200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
002700200528      *                 BUG24724           Date 03Jul09               *
002800200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
002900200528      *                 256564             Date 17Sep08               *
003000200528      *                 255711             Date 31Jul08               *
003100200528      * Midas Plus 1.4 Base ------------------------------------------*
003200200528      * Midas Plus 1.3 ----------- Base ------------------------------*
003300200528      *                 200949             Date 05Oct06               *
003400200528      *                 CDL049             Date 06Jul06               *
003500200528      *                 208219             Date 27Apr06               *
003600200528      *                 CLE025             Date 20Oct03               *
003700200528      *                 CAP084             Date 13Jan04               *
003800200528      * Midas Release 4.01 -------------------------------------------*
003900200528      *                 CFT017             Date 19Nov01               *
004000200528      * Midas Release 4 --------------- Base -------------------------*
004100200528      * Midas DBA 3.05 -----------------------------------------------*
004200200528      *                 CFT009             Date 13Nov00               *
004300200528      * Midas DBA 3.04 -----------------------------------------------*
004400200528      *                 CFT014  *CREATE    Date 25May00               *
004500200528      *                                                               *
004600200528      *---------------------------------------------------------------*
004700200528      *                                                               *
004800200528      *  250041A - Increased the length of receiver charges wrkfield. *
004900200528      *  MD046248 - Finastra Rebranding                               *
005000200528      *  CFT157 - Stop FT Transaction after Authorisation             *
005100200528      *           (Recompile)                                         *
005200200528      *  MD000091 - Event Codes Substitution                          *
005300200528      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
005400200528      *           (Recompile)                                         *
005500200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
005600200528      *            (Recompile)                                        *
005700200528      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
005800200528      *           (Recompile)                                         *
005900200528      *  BUG24724 - Senders and receivers charge error                *
006000200528      *             (already applied by 208219)                       *
006100200528      *  256564 - Recompile due to PF changes done by fix 256330      *
006200200528      *  255711 - Field Ref rate does not record rate.(Recompile)     *
006300200528      *  200949 - Suppress FTM3244 if payment will not produce a      *
006400200528      *           MT103.  Applied core fix 197943.                    *
006500200528      *           Same fix as 208219.                                 *
006600200528      *  CDL049 - Addition of a Reference Rate field (recompile)      *
006700200528      *  208219 - MT103 mandatory fields.
006800200528      *  CLE025 - Credit Lines (Recompile)                            *
006900200528      *  CAP084 - Allow charge to be zero.                            *
007000200528      *  CFT017 - Multilateral Inter-bank Exchange Fee.               *
007100200528      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
007200200528      *  CFT014 - Straight-through Processing Phase 2 MT103           *
007300200528      *           Messages Generation for FT.                         *
007400200528      *                                                               *
007500200528      *****************************************************************
007600200528      ** +--------------------------------------+
007700200528      ** ¦ F-specs                              ¦
007800200528      ** ¦ =======                              ¦
007900200528      ** +--------------------------------------+
008000200528
008100200528      *****************************************************************
008200200528      /EJECT
008300200528      *****************************************************************
008400200528      ** +--------------------------------------+
008500200528      ** ¦ Automatically included D-specs       ¦
008600200528      ** ¦ ==============================       ¦
008700200528      ** +--------------------------------------+
008800200528      **
008900200528      ** Standard D-specs
009000200528      ** ================
009100200528      **
009200200528      ** The following /COPY line includes the LDA layout,
009300200528      ** the copyright array definition,
009400200528      ** and the following named constants:
009500200528      **    True       logical = *on (for indcator processing)
009600200528      **    False      logical = *off (for indcator processing)
009700200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
009800200528      **                                    handler)
009900200528      ** and the following variables:
010000200528      **    RunBefore  1A (for the PSSR)
010100200528
010200200528     D/COPY ZACPYSRC,STD_D_SPEC
010300200528
010400200528      ** Include the standard declares
010500200528     D/COPY ZACPYSRC,STDDECLARE
010600200528
010700200528      ** Program Status Data Structure
010800200528      ** =============================
010900200528      ** The following /COPY line includes all the defined fields in the
011000200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
011100200528
011200200528     D/COPY ZACPYSRC,PSDS
011300200528
011400200528      ** The following /COPY line includes definitions for the above fields
011500200528      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
011600200528      ** corresponding fields in the PSDS /COPY member, so that member
011700200528      ** must be included where this one is used.
011800200528
011900200528     D/COPY ZACPYSRC,PROCPARMS
012000200528
012100200528      **---------------------------------------------------------------
012200200528      ** The following /COPY line includes the definitions for error and
012300200528      ** warning message arrays.
012400200528     D/COPY ZACPYSRC,ERR_ARRAYS
012500200528
012600200528      ** +--------------------------------------+
012700200528      ** ¦ End of automatically included D-specs¦
012800200528      ** ¦ =====================================¦
012900200528      ** +--------------------------------------+
013000200528
013100200528      *****************************************************************
013200200528      /EJECT
013300200528      *****************************************************************
013400200528
013500200528      ** +--------------------------------------+
013600200528      ** ¦ Manually included D-specs            ¦
013700200528      ** ¦ =========================            ¦
013800200528      ** +--------------------------------------+
013900200528
014000200528      ** +--------------------------------------+
014100200528      ** ¦ Named constants                      ¦
014200200528      ** ¦ ===============                      ¦
014300200528      ** +--------------------------------------+
014400200528
014500200528      ** The maximum size of the appended error arrays
014600200528     D XArrayMax       C                   CONST(20)
014700200528
014800200528      ** +--------------------------------------+
014900200528      ** ¦ Arrays and Data Structures           ¦
015000200528      ** ¦ ==========================           ¦
015100200528      ** +--------------------------------------+
015200200528
015300200528      ** Array of Fields in error.
015400200528     D FldNamXAr       S             10A   DIM(XArrayMax)
015500200528
015600200528      ** Array of error message IDs
015700200528     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
015800200528
015900200528      ** Array of error message data.
016000200528     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
016100200528      *                                                                                       CFT017
016200200528      ** Array of Fields with warnings.                                                       CFT017
016300200528     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     CFT017
016400200528      *                                                                                       CFT017
016500200528      ** Array of warning message IDs                                                         CFT017
016600200528     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        CFT017
016700200528      *                                                                                       CFT017
016800200528      ** Array of warning message data.                                                       CFT017
016900200528     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      CFT017
017000200528
017100200528      ** Incoming Transaction (First screen level 1)
017200200528     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
017300200528
017400200528      ** Incoming Transaction (Fourth screen level 2)
017500200528     D TranInFour    E DS                  EXTNAME(FTOPY6PD)
017600200528
017700200528      ** Flags to indicate whether transaction fields are valid
017800200528     D OKFlagsDS     E DS                  EXTNAME(FTEOPY4PD)
017900200528
018000200528      ** Validation Work Fields
018100200528     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
018200200528
018300200528      ** +--------------------------------------+
018400200528      ** ¦ Declared variables                   ¦
018500200528      ** ¦ ==================                   ¦
018600200528      ** +--------------------------------------+
018700200528
018800200528      ** Index for arrays of error message ids etc
018900200528     D Idx             S              3P 0
019000200528
019100200528     D ZalignOK        S              1
019200200528     D ZFIELD          S             16
019300200528     D ZADIG           S              2  0
019400200528     D ZADEC           S              1  0
019500200528     D CFT017          S              1                                                       CFT017
019600200528     D WVMIFF          S              1                                                       CFT017
019700200528     D BTMIFE          S             11P 0                                                    CFT017
019800200528     D Wx              S              3P 0                                                    CFT017
019900200529      ** Workfield for receiver charges remitted                                             250041A
020000200528     D RCRM            S             12P 0                                                   250041A
020100200528                                                                                             250041A
020200200528                                                                                            MD000091
020300200528      **                                                                                    MD000091
020400200528     D BChar           DS                                                                   MD000091
020500200528     D   BLen                  1      2B 0                                                  MD000091
020600200528     D   LenStr                1      2                                                     MD000091
020700200528     D   MsgDtaTmp                   99                                                     MD000091
020800200528
020900200528      ** +--------------------------------------+
021000200528      ** ¦ End of D-specs                       ¦
021100200528      ** ¦ ==============                       ¦
021200200528      ** +--------------------------------------+
021300200528
021400200528      *****************************************************************
021500200528      /EJECT
021600200528      *****************************************************************
021700200528     C
021800200528      ** +--- Start of Main processing -----------------------------------+
021900200528      ** ¦                                                                ¦
022000200528      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
022100200528      ** ¦ executed at program activation.                                ¦
022200200528      ** ¦                                                                ¦
022300200528      ** +----------------------------------------------------------------+
022400200528
022500200528      ** Initialization
022600200528
022700200528     C                   Eval      RetCodeIn = *Blanks
022800200528     C                   Eval      FldNamXAr = *Blanks
022900200528     C                   Eval      MsgIDXAr  = *Blanks
023000200528     C                   Eval      MsgDtaXAr = *Blanks
023100200528     C                   Eval      Idx = 0
023200200528     C                   Eval      Wx = 0                                                     CFT017
023300200528
023400200528      ** Receiver's Charges Remitted validation
023500200528
023600200528     C                   ExSr      SrRcvChg
023700200528
023800200528      ** If an error was found, set the return code appropriately
023900200528
024000200528     C                   If        OKRCRM = 'N'
024100200528     C                   Eval      RetCodeIn = 'Error'
024200200528     C                   EndIf
024300200528
024400200528     C                   Return
024500200528
024600200528      *****************************************************************
024700200528      /Title Sr/SrRcvChg
024800200528      *****************************************************************
024900200528      *                                                               *
025000200528      * SR/SrRcvChg   - Validate Receiver's Charges Remitted          *
025100200528      *                                                               *
025200200528      * Called By: Main Routine                                       *
025300200528      *                                                               *
025400200528      * Calls:                                                        *
025500200528      * ZALIGN      - Validate and align fields.                      *
025600200528      * ZEDIT       - Converts numeric value to screen value.         *
025700200528      *                                                               *
025800200528      *****************************************************************
025900200528
026000200528     C     SrRcvChg      BegSr
026100200528
026200200528      ** Receiver's Charges Remitted is optional.
026300200528      ** If entered must be valid for payment currency details
026400200528
026500200528     C                   Eval      @RCRM = *Zero
026600200528
026700200528      ** Receiver's charges remitted entered while the Detail of Charges
026800200528      ** is 'BEN', or Detail of Charges is 'OUR' and the add/deduct indica
026900200528      ** tor is not 'A' or Details of Charges is 'SHA', error.
027000200528
027100200528     C**********         Move(P)   SRCRM         @RCRM                                CAP084 250041A
027200200528     C                   Move(P)   SRCRM         RCRM                                        250041A
027300200528     C                   If        SRCRM <> *Blank
027400200528     C                             And RCRM  <> *Zero                                        250041A
027500200528     C**********                   And @RCRM <> *Zero                                 CAP084 250041A
027600200528     C                   If        (SDTCH = 'BEN') Or (SDTCH = 'SHA') Or
027700200528     C                             (SDTCH = 'OUR') And (SADDC <> 'A')
027800200528     C
027900200528     C                   Move      'N'           OKRCRM
028000200528     C                   Add       1             Idx
028100200528     C                   Movel     'SRCRM'       FldNamXAr(Idx)
028200200528     C                   Movel     'FTM3231'     MsgIdXAr(Idx)
028300200528     C                   EndIf
028400200528
028500200528     C                   Eval      ZFIELD = *Blank
028600200528     C                   Eval      ZFIELD = SRCRM
028700200528     C                   Eval      ZADIG = 11 - @RCDP
028800200528     C                   Eval      ZADEC = @RCDP
028900200528
029000200528     C                   CallB     'ZALIGN'
029100200528     C                   Parm                    ZalignOK
029200200528     C                   Parm                    ZFIELD
029300200528     C                   Parm                    ZADEC
029400200528     C                   Parm                    ZADIG
029500200528
029600200528     C                   If        ZalignOK = 'N'
029700200528     C                   Move      'N'           OKRCRM
029800200528     C                   Add       1             Idx
029900200528     C                   Movel     'SRCRM'       FldNamXAr(Idx)
030000200528     C                   Movel     'FTM3232'     MsgIdXAr(Idx)
030100200528     C*****SPCCY         Cat       SRCRM         MsgDtaXAr(Idx)                             MD000091
030200200528     C                   EVAL      BLen = %Len(%Trim(SPCCY))                                MD000091
030300200528     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(SPCCY)                    MD000091
030400200528     C                   EVAL      BLen = %Len(%Trim(SRCRM))                                MD000091
030500200528     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
030600200528     C                                            + LenStr +%TRIM(SRCRM)                    MD000091
030700200528     C                   Else
030800200528     C                   Move      ZFIELD        @RCRM
030900200528     C                   CallB     'ZEDIT'
031000200528     C                   Parm                    ZFIELD
031100200528     C                   Parm                    ZADEC
031200200528     C                   Move      ZFIELD        SRCRM
031300200528      *                                                                                       CFT017
031400200528      ** Compare amount computed to Multilateral Inter-change Fee                             CFT017
031500200528      ** defined in FT ICD. Generate warning message if Receiver's                            CFT017
031600200528      ** charges is less than the Multilateral Interchange Fee.                               CFT017
031700200528      *                                                                                       CFT017
031800200528     C                   IF        CFT017 = 'Y' AND                                           CFT017
031900200528     C                             WVMIFF = 'Y' AND                                           CFT017
032000200528     C                             @RCRM < BTMIFE                                             CFT017
032100200528     C                   MOVE      'W'           OKRCRM                                       CFT017
032200200528     C                   ADD       1             Wx                                           CFT017
032300200528     C                   MOVEL     'SRCRM'       WFldNmXAr(Wx)                                CFT017
032400200528     C                   MOVEL     'FTM6000'     WMsgIdXAr(Wx)                                CFT017
032500200528     C                   ENDIF                                                                CFT017
032600200528      *                                                                                       CFT017
032700200528     C                   EndIf
032800200528
032900200528      ** If Receiver's charges is entered, instructed amount must not be
033000200528      ** zero
033100200528
033200200528     C                   If        @PDAM = *Zero  And SPYTP <> 'RP'
033300200528     C                   If        @MT103='Y'                                                 208219
033400200528     C                             And (SSTTP <> '02')                                        208219
033500200528     C                   Move      'N'           OKRCRM
033600200528     C                   Add       1             Idx
033700200528     C                   Movel     'SRCRM'       FldNamXAr(Idx)
033800200528     C                   Movel     'FTM3244'     MsgIdXAr(Idx)
033900200528     C                   Endif                                                                208219
034000200528     C                   EndIf
034100200528     C                   EndIf
034200200528
034300200528     C                   EndSr
034400200528
034500200528      *****************************************************************
034600200528      /Title Sr/*InzSr
034700200528      *****************************************************************
034800200528      *                                                               *
034900200528      * SR/*InzSr     - Program Initialisation Routine                *
035000200528      *                                                               *
035100200528      * Called By: Automatically executed when program starts.        *
035200200528      *                                                               *
035300200528      * Calls:                                                        *
035400200528      *                                                               *
035500200528      *****************************************************************
035600200528
035700200528     C     *InzSr        BegSr
035800200528
035900200528     C     *Entry        Plist
036000200528     C                   Parm                    RetCodeIn
036100200528     C                   Parm                    TranInPrim
036200200528     C                   Parm                    TranInFour
036300200528     C                   Parm                    FldNamXAr
036400200528     C                   Parm                    MsgIDXAr
036500200528     C                   Parm                    MsgDtaXAr
036600200528     C                   PARM                    WFldNmXAr                                    CFT017
036700200528     C                   PARM                    WMsgIdXAr                                    CFT017
036800200528     C                   PARM                    WMsgDtXAr                                    CFT017
036900200528     C                   Parm                    OKFlagsDS
037000200528     C                   Parm                    Val@Fields
037100200528     C                   PARM                    CFT017                                       CFT017
037200200528     C                   PARM                    WVMIFF                                       CFT017
037300200528     C                   PARM                    BTMIFE                                       CFT017
037400200528
037500200528     C                   EndSr
037600200528
037700200528      *****************************************************************
037800200528      /EJECT
037900200528      *****************************************************************
038000200528      ** Program, module and procedure names for database error processing.
038100200528      ** =================================================================
038200200528      ** The following /COPY sets these values, and also defines LDA as
038300200528      ** an external data area
038400200528     C/COPY ZACPYSRC,PSSR_ILE
038500200528      ********************************************************************
038600200528**  CPY@
038700200528(c) Finastra International Limited 2001
