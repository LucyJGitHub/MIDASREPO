000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SE Trade settlement instruction validation')     *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Security Trading Module.                             *
000900200529      *                                                               *
001000200529      *  SETSETIVAL - Trade Settlement Instruction Validation         *
001100200529      *                                                               *
001200200529      *  Function:  This module performs the validation for the       *
001300200529      *             settlement instruction details.                   *
001400200529      *                                                               *
001500200529      *  (c) Finastra International Limited 2001                      *
001600200529      *                                                               *
001700200604      *  Last Amend No. AR706553           Date 22May20               *
001800200529      *  Prev Amend No. MD046248           Date 27Oct17               *
001900200529      *                 CSF011A            Date 28Nov11               *
002000200529      *                 CSW210             Date 04May10               *
002100200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
002200200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
002300200529      *                 162270 (180358)    Date 19Dec06               *
002400200529      *                 BUG13248A          Date 16Feb07               *
002500200529      *                 BUG13286A          Date 14Feb07               *
002600200529      *                 BUG13286           Date 12Feb07               *
002700200529      * Midas Plus 1.3 ----------- Base ------------------------------*
002800200529      *                 CSD031             Date 10Apr06               *
002900200529      *                 CSD027             Date 09Dec05               *
003000200529      *                 CGL031             Date 05Jul04               *
003100200529      *                 CSE071             Date 19Jul05               *
003200200529      *                 225161             Date 30Apr04               *
003300200529      *                 CSW037A            Date 02May05               *
003400200529      *                 CSD025             Date 11Jan05               *
003500200529      *                 CSW037             Date 15Dec04               *
003600200529      *                 CSW036             Date 15Dec04               *
003700200529      *                 BUG3122            Date 17Jul04               *
003800200529      *                 BUG2582            Date 07Jul04               *
003900200529      *                 BUG3145            Date 15Jun04               *
004000200529      *                 CGL014             Date 20Oct03               *
004100200529      *                 CLE025             Date 20Oct03               *
004200200529      *                 BUG1603            Date 25Mar04               *
004300200529      *                 CGL029             Date 01Sep03               *
004400200529      *                 CAP084             Date 10Jul03               *
004500200529      *                 CSE039             Date 21Jan03               *
004600200529      * Midas Release 4.01.03 ----------------------------------------*
004700200529      *                 211554             Date 26Nov02               *
004800200529      * Midas Release 4.01.02 ----------------------------------------*
004900200529      *                 188320             Date 24Apr02               *
005000200529      * Midas Release 4.01 -------------------------------------------*
005100200529      *                 204757             Date 19Apr02               *
005200200529      * Midas Release 4 --------------- Base -------------------------*
005300200529      *                 CSW201             Date 02May01               *
005400200529      *                 CSE022             Date 29Mar01               *
005500200529      * Midas DBA 3.05 -----------------------------------------------*
005600200529      *                 175718             Date 28Feb00               *
005700200529      * Midas DBA 3.03 -----------------------------------------------*
005800200529      * Midas DBA 3.02 -----------------------------------------------*
005900200529      *                 CPB001             Date 31Aug99               *
006000200529      *                 167953             Date 28Oct99               *
006100200529      *                 167488             Date 19OCT99               *
006200200529      *                 165014             Date 29Jul99               *
006300200529      * Midas DBA 3.00 ---------------- Base -------------------------*
006400200529      *                 CPL002             Date 08Mar99               *
006500200529      *                 CSE013             Date 29Jul98               *
006600200529      *                 CA0016 *CREATE     Date 25Mar98               *
006700200529      *                                                               *
006800200529      *---------------------------------------------------------------*
006900200529      *                                                               *
007000200529      *  AR706553 - Trades Input API processing error, incorrect Pay  *
007100200529      *             To/From branch is defaulted. Patterned after fix  *
007200200529      *             245195. (Child: AR706554)                         *
007300200529      *  MD046248 - Finastra Rebranding                               *
007400200529      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
007500200529      *            (Recompile)                                        *
007600200529      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
007700200529      *  162270 - Amended program such that for TP trades with a pay  *
007800200529      *           code of 1, clearance type of 3 or 4, a 'pay from'   *
007900200529      *           customer different to the 'delivered to' customer   *
008000200529      *           will be allowed to be inserted.                     *
008100200529      *           In fact, it is fix for 180358.                      *
008200200529      *  BUG13248A - For book transfer, disregard validation for      *
008300200529      *              Deliver From/To fields.
008400200529/*    *  BUG13286A - Incorrect error message.                         *
008500200529/*    *  BUG13286 - Incorrect error message.                          *
008600200529      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
008700200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
008800200529      *  CGL031 - Taxation of Savings Income (Recompiled)             *
008900200529      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
009000200529      *  225161 - Remove some of the validations as swift is expected *
009100200529      *           to cover these validations.                         *
009200200529      *         - Deliver From and Deliver To accounts not setup and  *
009300200529      *           is set to blank.                                    *
009400200529      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
009500200529      *  CSD025 - Customer De-Activation                              *
009600200529      *  CSW037 - Additional Field Data on MT300/MT320                *
009700200529      *  CSW036 - Dual SWIFT BIC held on Client Details               *
009800200529      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
009900200529      *  BUG2582 - allow blank clearence type, pay code and           *
010000200529      *            settlement method for book transfer.               *
010100200529      *  BUG3145 - Charges and Commission are being missed out of the *
010200200529      *            calculation of countervalue.                       *
010300200529      *  CGL014 - Collaterals Processing                              *
010400200529      *  CLE025 - Credit Lines (Recompile)                            *
010500200529      *  BUG1603- Allow Pay from/Pay to if settlement method is '04'  *
010600200529      *  CGL029 - Increase Account Code to 10 digits                  *
010700200529      *  CAP084 - Only Pay to/from branch if settlement method is not *
010800200529      *           '00'                                                *
010900200529      *  CSE039 - Auto-settlement of trades                           *
011000200529      *  211554 - Error message shown when amending a trade if trade  *
011100200529      *           is complete and settlement method is '00'. This     *
011200200529      *           must not happen if the security's market type is 'G'*
011300200529      *  188320 - Error code 607 appears even if user inputs no Profit*
011400200529      *           Centre. Only show error if default/entered Profit   *
011500200529      *           Centre does not exist.                              *
011600200529      *  204757 - Deliver From account of not being set up.           *
011700200529      *  CSW201 - SWIFT 2001 Standards Update                         *
011800200529      *  CSE022 - Depository Definition Enhancement                   *
011900200529      *  175718 - Setup of FldNamXAr with Clearance Type is wrong.    *
012000200529      *           There are 2 clearance type, one on Primary trade    *
012100200529      *           and the second on settlement                        *
012200200529      *  CPB001 - 'Private Banking' Module                            *
012300200529      *           /COPY SE_CUSTDT Changed                             *
012400200529      *  167953 - Correct Profit Centre defaulting                    *
012500200529      *  167488 - Profit Centre defaulting not working on ? validation*
012600200529      *  165014 - Change Profit Centre defaulting                     *
012700200529      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
012800200529      *  CSE013 - Short Position Warning                              *
012900200529      *  CA0016 - Conversion of SE inputs into modular structure to   *
013000200529      *           use as APIs.                                        *
013100200529      *                                                               *
013200200529      *****************************************************************
013300200529
013400200529      ** +--------------------------------------+
013500200529      ** ¦ F-specs                              ¦
013600200529      ** ¦ =======                              ¦
013700200529      ** +--------------------------------------+
013800200529
013900200529     FACCNT     IF   E           K DISK
014000200529     FACNUM     IF   E           K DISK
014100200529     F                                     RENAME(ACCNTABF:ACNUMF)
014200200529     FSEPCBD    IF   E           K DISK                                         S01117
014300200529     FSEPCCD    IF   E           K DISK                                         S01117
014400200529
014500200529     F/COPY WNCPYSRC,SETSETIVF1
014600200529      *****************************************************************
014700200529      ** +--------------------------------------+
014800200529      ** ¦ Automatically included D-specs       ¦
014900200529      ** ¦ ==============================       ¦
015000200529      ** +--------------------------------------+
015100200529      **
015200200529      **--------------------------------------------------------------------------------------------
015300200529      ** The following /COPY line includes (among others) the LDA layout
015400200529      ** and the copyright array definition:
015500200529     D/COPY ZACPYSRC,STD_D_SPEC
015600200529      **--------------------------------------------------------------------------------------------
015700200529
015800200529      **--------------------------------------------------------------------------------------------
015900200529      ** The following /COPY includes the MM standard declares:
016000200529     D/COPY ZACPYSRC,STDDECLARE
016100200529      **--------------------------------------------------------------------------------------------
016200200529
016300200529      **--------------------------------------------------------------------------------------------
016400200529      ** The following /COPY line includes all the defined fields in the
016500200529      ** Program Status Data Structures.  They have meaningful
016600200529      ** names, prefixed by 'PS'.
016700200529     D/COPY ZACPYSRC,PSDS
016800200529      **--------------------------------------------------------------------------------------------
016900200529
017000200529      **--------------------------------------------------------------------------------------------
017100200529      ** The following /COPY line includes all the definitions of the
017200200529      ** appended error arrays, including the named constant giving the size
017300200529      ** of the arrays.
017400200529     D/COPY ZACPYSRC,ERR_XARRYS
017500200529      **--------------------------------------------------------------------------------------------
017600200529
017700200529      ** +--------------------------------------+
017800200529      ** ¦ End of automatically included D-specs¦
017900200529      ** ¦ =====================================¦
018000200529      ** +--------------------------------------+
018100200529
018200200529      *****************************************************************
018300200529      /EJECT
018400200529      *****************************************************************
018500200529
018600200529      ** +--------------------------------------+
018700200529      ** ¦ Manually included D-specs            ¦
018800200529      ** ¦ =========================            ¦
018900200529      ** +--------------------------------------+
019000200529
019100200529      ** +--------------------------------------+
019200200529      ** ¦ Named constants                      ¦
019300200529      ** ¦ ===============                      ¦
019400200529      ** +--------------------------------------+
019500200529
019600200529      ** +--------------------------------------+
019700200529      ** ¦ Arrays and Data Structures           ¦
019800200529      ** ¦ ==========================           ¦
019900200529      ** +--------------------------------------+
020000200529
020100200529      ** Trade Settlement Instructions in screen format
020200200529     D TrSett        E DS                  EXTNAME(SETRSTPD)
020300200529
020400200529      ** Trade Settlement Instructions OK indicators
020500200529     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
020600200529
020700200529
020800200529      ** The following /COPY includes the customer details data structure
020900200529     D/COPY SECPYSRC,SE_CUSTDT
021000200529      ** The following /COPY includes the currency details data structures
021100200529     D/COPY SECPYSRC,SE_CCYDT
021200200529
021300200529
021400200529      ** Special Instruction line
021500200529     D SIL             S              1    DIM(35)
021600200529
021700200529      ** Valid codeword characters
021800200529     D UPA             S              1    DIM(27) CTDATA PERRCD(27)
021900200529
022000200529      ** Valid codeword characters for Swift 2001                                             CSW201
022100200529     D UPB             S              1    DIM(37) CTDATA PERRCD(37)                          CSW201
022200200529                                                                                              CSW201
022300200529      ** Valid SWIFT ISO characters
022400200529     D SWCH            S              1    DIM(47) CTDATA PERRCD(47)
022500200529
022600200529     D APF             S              1    DIM(16)
022700200529
022800200529
022900200529      ** Branch details
023000200529     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
023100200529
023200200529      ** Nostro details
023300200529     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
023400200529
023500200529      ** Customer details
023600200529     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
023700200529     D QQDFC1        E                     EXTFLD(QQDFAC)                                     CGL029
023800200529
023900200529      ** Security Customer details
024000200529     D SDSECS        E DS                  EXTNAME(SDSECSPD)
024100200529     D QQACC1        E                     EXTFLD(QQACCD)                                     CGL029
024200200529
024300200529      ** Counterparty nostros
024400200529     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
024500200529
024600200529      ** Currencies
024700200529     D SDCURR        E DS                  EXTNAME(SDCURRPD)
024800200529
024900200529      ** Profit Centres
025000200529     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
025100200529
025200200529      ** Account Officers                                                                     188320
025300200529     D SDACOF        E DS                  EXTNAME(SDACOFPD)                                  188320
025400200529
025500200529      ** DS for customer/book standard settlement instruction                                 CSE039
025600200529      **  to be passed to SESSIR0                                                             CSE039
025700200529     D PCBSTD        E DS                  EXTNAME(STDSED) OCCURS(2)                          CSE039
025800200529     D                                     PREFIX(X1)                                         CSE039
025900200529      *                                                                                       CSE039
026000200529      ** Data structure for standard additional settlement details                            CSE039
026100200529      ** for customer/book to be passed to SESSIR0                                            CSE039
026200200529     D PCBSAD        E DS                  EXTNAME(STDADSED) OCCURS(8)                        CSE039
026300200529     D                                     PREFIX(X2)                                         CSE039
026400200529                                                                                              188320
026500200529      **  Short DS for access programs
026600200529     D DSFDY         E DS                  EXTNAME(DSFDY)
026700200529
026800200529      **  Long DS for access programs
026900200529     D DSSDY         E DS                  EXTNAME(DSSDY)
027000200529
027100200529      ** External DS for Switchable features details                                          162270
027200200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  162270
027300200529                                                                                              162270
027400200529     D/COPY WNCPYSRC,SETSETIVD1
027500200529
027600200529     D DSACCT          DS
027700200529     D**CNUM****               1      6  0                                                    CSD027
027800200529     D  CNUM                   1      6                                                       CSD027
027900200529     D  CCY                    7      9
028000200529     D**ACODD***              100    133 00                                                   CGL029
028100200529     D**ACSQQ***              144    155 00                                                   CGL029
028200200529     D**BRCAA***              166    188                                                      CGL029
028300200529     D  ACOD                  10     19  0                                                    CGL029
028400200529     D  ACSQ                  20     21  0                                                    CGL029
028500200529     D  BRCA                  22     24                                                       CGL029
028600200529
028700200529      ** +--------------------------------------+
028800200529      ** ¦ Declared variables                   ¦
028900200529      ** ¦ ==================                   ¦
029000200529      ** +--------------------------------------+
029100200529
029200200529      ** Output field(s)
029300200529      ** ---------------
029400200529
029500200529     D*TCNR*****       S              6S 0                                                    CSD027
029600200529     D*SDC1*****       S              6S 0                                                    CSD027
029700200529     D*SDC2*****       S              6S 0                                                    CSD027
029800200529     D*SDC3*****       S              6S 0                                                    CSD027
029900200529     D TCNR            S              6A                                                      CSD027
030000200529     D SDC1            S              6A                                                      CSD027
030100200529     D SDC2            S              6A                                                      CSD027
030200200529     D SDC3            S              6A                                                      CSD027
030300200529
030400200529      ** Output field(s)
030500200529      ** ---------------
030600200529
030700200529     D SMTH            S              2S 0
030800200529     D ASNM            S              2S 0
030900200529     D*DELF*****       S              6S 0                                                    CSD027
031000200529     D*DELT*****       S              6S 0                                                    CSD027
031100200529     D DELF            S              6A                                                      CSD027
031200200529     D DELT            S              6A                                                      CSD027
031300200529
031400200529      ** Working Variables
031500200529      ** -----------------
031600200529
031700200529      ** Index for arrays of of error message ids etc
031800200529     D Idx             S              3P 0
031900200529      ** Index for arrays of of Warning message ids etc
032000200529     D WIx             S              3P 0
032100200529
032200200529     D @ERR            S              1P 0
032300200529     D @DSNB           S              3A
032400200529     D @SCKY           S              6A
032500200529     D @QRY            S              1A
032600200529     D @CPNC           S              8A
032700200529     D @KEY1           S             10A
032800200529     D @KYST           S              7A
032900200529     D @ZOBRX          S              3A
033000200529     D CUL             S              1A
033100200529     D SSF             S              1A
033200200529     D FC1DI           S              1A
033300200529     D TC1DI           S              1A
033400200529     D USRCB           S              5A
033500200529     D SCKY            S              6A
033600200529     D***P@ACCD*         S              4A                                                    CGL029
033700200529     D P@ACCD          S             10A                                                      CGL029
033800200529     D P@ACSN          S              2A
033900200529     D P@BRCD          S              3A
034000200529     D P@CSSN          S             10A
034100200529     D P@CUST          S              6A
034200200529     D P@CYCD          S              3A
034300200529     D P@NONB          S              2A
034400200529     D P@PNOI          S              1A
034500200529     D WPF10           S             10A
034600200529     D*WPYFM****       S              6P 0                                                    CSD027
034700200529     D WPYFM           S              6A                                                      CSD027
034800200529     D***WCOSQ**         S              6A                                                    CGL029
034900200529     D***WPRAC**         S             12A                                                    CGL029
035000200529     D WCOSQ           S             12A                                                      CGL029
035100200529     D WPRAC           S             18A                                                      CGL029
035200200529     D*WWCNUM***       S              6P 0                                                    CSD027
035300200529     D*WDELF****       S              6P 0                                                    CSD027
035400200529     D*WDELT****       S              6P 0                                                    CSD027
035500200529     D WWCNUM          S              6A                                                      CSD027
035600200529     D WDELF           S              6A                                                      CSD027
035700200529     D WDELT           S              6A                                                      CSD027
035800200529     D WCHECK          S              1A
035900200529     D WFL10           S             10A
036000200529     D***WFLD6**         S              6A                                                    CGL029
036100200529     D WFLD6           S             12A                                                      CGL029
036200200529     D WPYFB           S              3A
036300200529     D*WPAYT****       S              6P 0                                                    CSD027
036400200529     D WPAYT           S              6A                                                      CSD027
036500200529     D WPY10           S             10A
036600200529     D WPT10           S             10A
036700200529     D WPYTB           S              3A
036800200529     D KEY10           S             10P 0
036900200529     D WCSNM           S             10A
037000200529     D WCUST           S              6A
037100200529     D***WOUT06*         S              6A                                                    CGL029
037200200529     D WOUT06          S             12A                                                      CGL029
037300200529     D ErrInd          S              1A
037400200529     D ZDAYNO          S              5P 0
037500200529     D ZCCY            S              3A
037600200529     D ZLOC            S              3A
037700200529     D ZIND            S              1A
037800200529     D ShortFlag       S              1A                                        CSE013
037900200529     D WRtnCd          S              7A                                                      CSW201
038000200529     D CSW201          S              1A                                                      CSW201
038100200529     D BMACCD          S             10A                                                      CGL029
038200200529     D PAYT            S             18A                                                      CGL029
038300200529     D PYFM            S             18A                                                      CGL029
038400200529
038500200529     D POTYP           S              1A   INZ('D')                                           CSE039
038600200529     D PBRCH           S              3A                                                      CSE039
038700200529     D PCUST           S              6A                                                      CSE039
038800200529     D PBOOK           S              2A                                                      CSE039
038900200529     D PCURR           S              3A                                                      CSE039
039000200529     D PMRKT           S              2A                                                      CSE039
039100200529     D PINVT           S              3A                                                      CSE039
039200200529     D PPTFR           S              4A                                                      CSE039
039300200529     D PRTCD           S              5A                                                      CSE039
039400200529                                                                                              CSE039
039500200529     D*CGL014**********S              1                                               CGL014 BUG3145
039600200529     D*TCTR************S             15  0                                            CGL014 BUG3145
039700200529     D*PTAMNT**********S             15  0                                            CGL014 BUG3145
039800200529     D*PTCCY***********S              3                                               CGL014 BUG3145
039900200529     D*PABRCA**********S              3                                               CGL014 BUG3145
040000200529     D*PACNUM**********S              6                                               CGL014 BUG3145
040100200529     D*PACCY***********S              3                                               CGL014 BUG3145
040200200529     D*PAACOD**********S             10                                               CGL014 BUG3145
040300200529     D*PAACSQ**********S              2                                               CGL014 BUG3145
040400200529     D*PAACNO**********S             10  0                                            CGL014 BUG3145
040500200529     D*PRTNCD**********S              7                                               CGL014 BUG3145
040600200529                                                                                      CGL014 BUG3145
040700200529     D IdX1            S              2P 0
040800200529     D IdY1            S              2P 0
040900200529     D IdL             S              3P 0
041000200529
041100200529      ** +--------------------------------------+
041200200529      ** ¦ End of D-specs                       ¦
041300200529      ** ¦ ==============                       ¦
041400200529      ** +--------------------------------------+
041500200529
041600200529      *****************************************************************
041700200529      /EJECT
041800200529      *****************************************************************
041900200529
042000200529
042100200529      ** +--- Start of Main processing -----------------------------------+
042200200529      ** ¦                                                                ¦
042300200529      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
042400200529      ** ¦ executed at program activation.                                ¦
042500200529      ** ¦                                                                ¦
042600200529      ** +----------------------------------------------------------------+
042700200529      *
042800200529      ** Initialization
042900200529      *
043000200529     C                   MOVE      *BLANK        FldNamXAr
043100200529     C                   MOVE      *BLANK        MsgIDXAr
043200200529     C                   MOVE      *BLANK        MsgDtaXAr
043300200529     C                   Z-ADD     0             Idx
043400200529     C                   MOVE      *BLANK        WFldNmXAr
043500200529     C                   MOVE      *BLANK        WMsgIDXAr
043600200529     C                   MOVE      *BLANK        WMsgDtXAr
043700200529     C                   Z-ADD     0             WIx
043800200529
043900200529      ** Clear output trade fields
044000200529
044100200529     C                   Z-ADD     0             SMTH
044200200529     C                   MOVE      *BLANK        PYFM
044300200529     C                   MOVE      *BLANK        PYFA
044400200529     C                   MOVE      *BLANK        PAYT
044500200529     C                   MOVE      *BLANK        PYTA
044600200529     C                   MOVE      *BLANK        TDFA
044700200529     C                   Z-ADD     0             ASNM
044800200529     C                   MOVE      *BLANK        CLTY
044900200529     C**********         Z-ADD     0             DELT                                         CSD027
045000200529     C                   EVAL      DELT = *BLANKS                                             CSD027
045100200529     C                   MOVE      *BLANK        DTFA
045200200529     C**********         Z-ADD     0             DELF                                         CSD027
045300200529     C                   EVAL      DELF = *BLANKS                                             CSD027
045400200529     C                   MOVE      *BLANK        DFFA
045500200529     C                   MOVE      *BLANK        TDSI
045600200529     C                   MOVE      *BLANK        PRYC
045700200529     C                   MOVE      *BLANK        PCOD
045800200529     C                   MOVE      *BLANK        AUTS
045900200529      *
046000200529      ** Process all fields with '?' entry
046100200529      *
046200200529     C                   EXSR      SRProcQRY
046300200529      *
046400200529      ** Perform validation
046500200529      *
046600200529     C                   EXSR      SRValidate
046700200529
046800200529     C                   RETURN
046900200529      *****************************************************************
047000200529      /EJECT
047100200529      *****************************************************************
047200200529      *                                                               *
047300200529      * SRProcQRY - Subroutine to perform the process input for '?'   *
047400200529      *             entries.  (D3QRY)                                 *
047500200529      *                                                               *
047600200529      *****************************************************************
047700200529     C     SRProcQRY     BEGSR
047800200529
047900200529      *
048000200529      ** Originating Branch
048100200529      ** ------------------
048200200529      *
048300200529     C                   MOVEL     DDORBR        @QRY
048400200529
048500200529     C     @QRY          IFEQ      '?'
048600200529
048700200529     C                   MOVE      DDORBR        @DSNB
048800200529
048900200529     C                   EXSR      AOBRCH
049000200529
049100200529     C     @RTCD         IFEQ      '*NOSEL '
049200200529     C                   MOVE      *BLANKS       DDORBR
049300200529     C                   ELSE
049400200529     C                   MOVE      A8BRCD        DDORBR
049500200529     C                   END
049600200529
049700200529     C                   END
049800200529      *
049900200529      ** Pay From (a/c)
050000200529      ** --------------
050100200529      *
050200200529     C                   MOVEL     DDPYFM        @QRY
050300200529
050400200529     C     @QRY          IFEQ      '?'
050500200529      *
050600200529     C     DDTDTP        IFEQ      'TP'
050700200529
050800200529     C     DDSMTH        IFEQ      '01'
050900200529     C     DDSMTH        OREQ      '02'
051000200529     C     DDSMTH        OREQ      '07'
051100200529     C     DDSMTH        OREQ      '08'
051200200529     C     DDSMTH        OREQ      '12'
051300200529     C                   MOVEL     DDPYFM        P@NONB
051400200529     C                   MOVEL     DDSETC        P@CYCD
051500200529
051600200529     C                   EXSR      AONOST
051700200529
051800200529     C     @RTCD         IFNE      *BLANKS
051900200529     C                   MOVE      *BLANKS       DDPYFM
052000200529
052100200529     C                   ELSE
052200200529     C                   MOVE      *BLANKS       DDPYFM
052300200529     C                   MOVEL     A7NONB        DDPYFM
052400200529     C                   END
052500200529
052600200529     C                   END
052700200529
052800200529     C     DDSMTH        IFEQ      '15'
052900200529     C                   MOVEL     DDPYFM        WCSNM
053000200529
053100200529     C                   EXSR      AOCUST
053200200529
053300200529     C     @RTCD         IFEQ      '*NOSEL '
053400200529     C                   MOVE      *BLANKS       DDPYFM
053500200529     C                   ELSE
053600200529     C                   MOVE      *BLANKS       DDPYFM
053700200529     C                   MOVEL     BBCUST        DDPYFM
053800200529     C                   END
053900200529
054000200529     C                   END
054100200529     C                   END
054200200529
054300200529     C     DDTDTP        IFEQ      'TS'
054400200529     C     DDSMTH        IFEQ      '01'
054500200529     C     DDSMTH        OREQ      '07'
054600200529     C     DDSMTH        OREQ      '08'
054700200529     C                   MOVEL     DDPYFM        WCSNM
054800200529
054900200529     C                   EXSR      AOCUST
055000200529
055100200529     C     @RTCD         IFEQ      '*NOSEL '
055200200529     C                   MOVE      *BLANKS       DDPYFM
055300200529     C                   ELSE
055400200529     C                   MOVE      *BLANKS       DDPYFM
055500200529     C                   MOVEL     BBCUST        DDPYFM
055600200529     C                   END
055700200529
055800200529     C                   END
055900200529     C                   END
056000200529     C                   END
056100200529      *
056200200529      ** Pay From Branch
056300200529      ** ---------------
056400200529      *
056500200529     C                   MOVEL     DDPYFB        @QRY
056600200529     C     @QRY          IFEQ      '?'
056700200529     C                   MOVE      DDPYFB        @DSNB
056800200529
056900200529     C                   EXSR      AOBRCH
057000200529
057100200529     C     @RTCD         IFEQ      '*NOSEL '
057200200529     C                   MOVE      *BLANKS       DDPYFB
057300200529     C                   ELSE
057400200529     C                   MOVE      A8BRCD        DDPYFB
057500200529     C                   END
057600200529
057700200529     C                   END
057800200529      *
057900200529      ** Pay To (a/c)
058000200529      ** ------------
058100200529      *
058200200529     C                   MOVEL     DDPAYT        @QRY
058300200529     C     @QRY          IFEQ      '?'
058400200529
058500200529     C     DDTDTP        IFEQ      'TS'
058600200529     C     DDSMTH        IFEQ      '01'
058700200529     C     DDSMTH        OREQ      '02'
058800200529     C     DDSMTH        OREQ      '07'
058900200529     C     DDSMTH        OREQ      '08'
059000200529     C     DDSMTH        OREQ      '12'
059100200529     C                   MOVEL     DDPAYT        P@NONB
059200200529     C                   MOVEL     DDSETC        P@CYCD
059300200529
059400200529     C                   EXSR      AONOST
059500200529
059600200529     C     @RTCD         IFNE      *BLANKS
059700200529     C                   MOVE      *BLANKS       DDPAYT
059800200529     C                   ELSE
059900200529     C                   MOVE      *BLANKS       DDPAYT
060000200529     C                   MOVEL     A7NONB        DDPAYT
060100200529     C                   END
060200200529
060300200529     C                   END
060400200529
060500200529     C     DDSMTH        IFEQ      '15'
060600200529     C                   MOVEL     DDPAYT        WCSNM
060700200529
060800200529     C                   EXSR      AOCUST
060900200529
061000200529     C     @RTCD         IFEQ      '*NOSEL '
061100200529     C                   MOVE      *BLANKS       DDPAYT
061200200529     C                   ELSE
061300200529     C                   MOVE      *BLANKS       DDPAYT
061400200529     C                   MOVEL     BBCUST        DDPAYT
061500200529     C                   END
061600200529     C                   END
061700200529     C                   END
061800200529     C*
061900200529     C     DDTDTP        IFEQ      'TP'
062000200529     C     DDSMTH        IFEQ      '01'
062100200529     C     DDSMTH        OREQ      '07'
062200200529     C     DDSMTH        OREQ      '08'
062300200529     C                   MOVEL     DDPAYT        WCSNM
062400200529
062500200529     C                   EXSR      AOCUST
062600200529
062700200529     C     @RTCD         IFEQ      '*NOSEL '
062800200529     C                   MOVE      *BLANKS       DDPAYT
062900200529     C                   ELSE
063000200529     C                   MOVE      *BLANKS       DDPAYT
063100200529     C                   MOVEL     BBCUST        DDPAYT
063200200529     C                   END
063300200529     C                   END
063400200529     C                   END
063500200529     C                   END
063600200529      *
063700200529      ** Pay To Branch
063800200529      ** -------------
063900200529      *
064000200529     C                   MOVEL     DDPYTB        @QRY
064100200529
064200200529     C     @QRY          IFEQ      '?'
064300200529     C                   MOVE      DDPYTB        @DSNB
064400200529
064500200529     C                   EXSR      AOBRCH
064600200529
064700200529     C     @RTCD         IFEQ      '*NOSEL '
064800200529     C                   MOVE      *BLANKS       DDPYTB
064900200529     C                   ELSE
065000200529     C                   MOVE      A8BRCD        DDPYTB
065100200529     C                   END
065200200529
065300200529     C                   END
065400200529      *
065500200529      ** Pay For A/C Of
065600200529      ** --------------
065700200529      *
065800200529     C                   MOVEL     DDTDFA        @QRY
065900200529
066000200529     C     @QRY          IFEQ      '?'
066100200529     C                   MOVEL     DDTDFA        WCSNM
066200200529     C                   EXSR      AOCUST
066300200529
066400200529     C     @RTCD         IFEQ      '*NOSEL '
066500200529     C                   MOVE      *BLANKS       DDTDFA
066600200529     C                   ELSE
066700200529     C                   MOVE      *BLANKS       DDTDFA
066800200529     C                   MOVEL     BBCUST        DDTDFA
066900200529     C                   END
067000200529
067100200529     C                   END
067200200529      *
067300200529      ** Deliver From
067400200529      ** ------------
067500200529      *
067600200529     C                   MOVEL     DDDELF        @QRY
067700200529
067800200529     C     @QRY          IFEQ      '?'
067900200529     C                   MOVEL     DDDELF        WCUST
068000200529
068100200529     C                   EXSR      AOSECS
068200200529
068300200529     C     @RTCD         IFEQ      '*NOSEL '
068400200529     C                   MOVE      *BLANKS       DDDELF
068500200529     C                   ELSE
068600200529     C                   MOVE      *BLANKS       DDDELF
068700200529     C                   MOVEL     BFCUST        DDDELF
068800200529     C                   END
068900200529
069000200529     C                   END
069100200529      *
069200200529      ** Deliver To
069300200529      ** ----------
069400200529      *
069500200529     C                   MOVEL     DDDELT        @QRY
069600200529
069700200529     C     @QRY          IFEQ      '?'
069800200529     C                   MOVEL     DDDELT        WCUST
069900200529
070000200529     C                   EXSR      AOSECS
070100200529
070200200529     C     @RTCD         IFEQ      '*NOSEL '
070300200529     C                   MOVE      *BLANKS       DDDELT
070400200529     C                   ELSE
070500200529     C                   MOVE      *BLANKS       DDDELT
070600200529     C                   MOVEL     BFCUST        DDDELT
070700200529     C                   END
070800200529
070900200529     C                   END
071000200529      *
071100200529      ** Deliver From - For A/C Of
071200200529      ** -------------------------
071300200529      *
071400200529     C                   MOVEL     DDDFFA        @QRY
071500200529
071600200529     C     @QRY          IFEQ      '?'
071700200529     C                   MOVEL     DDDFFA        WCUST
071800200529
071900200529     C                   EXSR      AOSECS
072000200529
072100200529     C     @RTCD         IFEQ      '*NOSEL '
072200200529     C                   MOVE      *BLANKS       DDDFFA
072300200529     C                   ELSE
072400200529     C                   MOVE      *BLANKS       DDDFFA
072500200529     C                   MOVEL     BFCUST        DDDFFA
072600200529     C                   END
072700200529
072800200529     C                   END
072900200529      *
073000200529      ** Deliver To - For A/C Of
073100200529      ** -----------------------
073200200529      *
073300200529     C                   MOVEL     DDDTFA        @QRY
073400200529
073500200529     C     @QRY          IFEQ      '?'
073600200529     C                   MOVEL     DDDTFA        WCUST
073700200529
073800200529     C                   EXSR      AOSECS
073900200529
074000200529     C     @RTCD         IFEQ      '*NOSEL '
074100200529     C                   MOVE      *BLANKS       DDTDFA
074200200529     C                   ELSE
074300200529     C                   MOVE      *BLANKS       DDTDFA
074400200529     C                   MOVEL     BFCUST        DDTDFA
074500200529     C                   END
074600200529
074700200529     C                   END
074800200529      *
074900200529      ** 'In' Currency in Field 72
075000200529      ** -------------------------
075100200529      *
075200200529     C                   MOVEL     DDICCY        @QRY
075300200529
075400200529     C     @QRY          IFEQ      '?'
075500200529     C                   MOVE      DDICCY        @AJCD
075600200529     C                   EXSR      AOCURR
075700200529
075800200529     C     @RTCD         IFEQ      '*NOSEL '
075900200529     C                   MOVE      *BLANKS       DDICCY
076000200529     C                   ELSE
076100200529     C                   MOVE      A6CYCD        DDICCY
076200200529     C                   END
076300200529
076400200529     C                   END
076500200529
076600200529      *
076700200529      ** 'Profit centre
076800200529      ** ---------------
076900200529      *
077000200529     C                   MOVEL     DDPRFC        @QRY                                         167488
077100200529     C     @QRY          IFEQ      '?'                                                        167488
077200200529     C                   MOVE      DDPRFC        @PCCD                                        167488
077300200529     C                   EXSR      AOPRFC                                                     167488
077400200529     C     @RTCD         IFEQ      '*NOSEL '                                                  167488
077500200529     C                   MOVE      *BLANKS       DDPRFC                                       167488
077600200529     C                   ELSE                                                                 167488
077700200529     C                   MOVE      DSPCCD        DDPRFC                                       167488
077800200529     C                   ENDIF                                                                167488
077900200529     C                   ENDIF                                                                167488
078000200529     C                   ENDSR
078100200529      *****************************************************************
078200200529      /EJECT
078300200529      *****************************************************************
078400200529      *                                                               *
078500200529      * SRValidate - Subroutine to perform the validation of the      *
078600200529      *              settlement fields.                               *
078700200529      *                                                               *
078800200529      *****************************************************************
078900200529     C     SRValidate    BEGSR
079000200529      *
079100200529      ** Validate Settlement Method
079200200529      ** --------------------------
079300200529      *
079400200529     C                   EXSR      ValSetMet
079500200529      *
079600200529      ** Validate Originating Branch
079700200529      ** ---------------------------
079800200529      *
079900200529     C                   EXSR      ValOrgBrh
080000200529      *
080100200529      ** Validate Pay From (Purchases)
080200200529      ** -----------------------------
080300200529      *
080400200529     C     DDTDTP        IFEQ      'TP'
080500200529     C                   EXSR      ValPayFrmP
080600200529     C                   ENDIF
080700200529      *
080800200529      ** Validate Pay From (Sales)
080900200529      ** -------------------------
081000200529      *
081100200529     C     DDTDTP        IFEQ      'TS'
081200200529     C                   EXSR      ValPayFrmS
081300200529     C                   ENDIF
081400200529      *
081500200529      ** Validate Pay From Branch
081600200529      ** ------------------------
081700200529      *
081800200529     C                   EXSR      ValPyFrBrh
081900200529      *
082000200529      ** Validate Pay To (Purchases)
082100200529      ** ---------------------------
082200200529      *
082300200529     C     DDTDTP        IFEQ      'TP'
082400200529     C                   EXSR      ValPayToP
082500200529     C                   END
082600200529      *
082700200529      ** Validate Pay To (Sales)
082800200529      ** ---------------------------
082900200529      *
083000200529     C     DDTDTP        IFEQ      'TS'
083100200529     C                   EXSR      ValPayToS
083200200529     C                   END
083300200529      *
083400200529      ** Validate Pay To Branch
083500200529      ** ----------------------
083600200529      *
083700200529     C                   EXSR      ValPyToBrh
083800200529
083900200529      *                                                                                     AR706553
084000200529      ** Default  Pay To/From branch                                                        AR706553
084100200529      ** ---------------------------                                                        AR706553
084200200529      *                                                                                     AR706553
084300200529     C     DDSMTH        IFNE      '00'                                                     AR706553
084400200529     C     DDPYFB        IFEQ      *BLANKS                                                  AR706553
084500200529     C                   EXSR      DEFPYFRBR                                                AR706553
084600200529     C                   MOVE      DDPYFB        PYFA                                       AR706553
084700200529     C                   ENDIF                                                              AR706553
084800200529     C     DDPYTB        IFEQ      *BLANKS                                                  AR706553
084900200529     C                   EXSR      DEFPYTOBR                                                AR706553
085000200529     C                   MOVE      DDPYTB        PYTA                                       AR706553
085100200529     C                   ENDIF                                                              AR706553
085200200529     C                   ENDIF                                                              AR706553
085300200529      *                                                                                     AR706553
085400200529      ** Defaulting Procedure for Pay To, Pay From
085500200529      ** For Settlement type 04 (Prime Retail Account)
085600200529
085700200529     C     DDSMTH        IFEQ      '04'
085800200529     C     DDSMTHok      ANDNE     'N'
085900200529     C                   EXSR      SetPrimRet
086000200529     C                   END
086100200529      *
086200200529      ** Validate For Account of (Pay To)
086300200529      ** --------------------------------
086400200529      *
086500200529     C                   EXSR      ValFrAcPyT
086600200529      *
086700200529      ** Validate For A/C Sequence No.
086800200529      ** -----------------------------
086900200529      *
087000200529     C                   EXSR      ValAcSeq
087100200529      *
087200200529      ** Validate Deliver From entry
087300200529      ** ---------------------------
087400200529      *
087500200529     C                   EXSR      ValDelvrFm
087600200529      *
087700200529      ** Validate Deliver to entry
087800200529      ** -------------------------
087900200529      *
088000200529     C                   EXSR      ValDelvrTo
088100200529      *
088200200529      ** Validate Deliver To/Deliver From entries - Purchases
088300200529      ** ----------------------------------------------------
088400200529      *
088500200529     C     DDDFFA        IFEQ      *BLANKS
088600200529     C     CustClass     ANDNE     'S'
088700200529     C     CustClass     ANDNE     'D'
088800200529     C     CustClass     ANDNE     'I'                                                     BUG13248A
088900200529     C     DDTDTP        ANDEQ     'TP'
089000200529     C                   EXSR      ValDTDF_P
089100200529     C                   END
089200200529      *
089300200529      ** Validate Deliver To/Deliver From entries - Sales
089400200529      ** ------------------------------------------------
089500200529      *
089600200529     C     DDDTFA        IFEQ      *BLANKS
089700200529     C     CustClass     ANDNE     'S'
089800200529     C     CustClass     ANDNE     'D'
089900200529     C     CustClass     ANDNE     'I'                                                     BUG13248A
090000200529     C     DDTDTP        ANDEQ     'TS'
090100200529     C                   EXSR      ValDTDF_S
090200200529     C                   END
090300200529      *****************************************************************                       CSE022
090400200529      ***Validate*Deliver*To/Deliver*From*entries*-*KassenVerein*******                       CSE022
090500200529      ***-------------------------------------------------------*******                       CSE022
090600200529      *****************************************************************                       CSE022
090700200529     C**********         EXSR      ValDTDF_K                                                  CSE022
090800200529      *
090900200529      ** Validate For Account of (Deliver to)
091000200529      ** ------------------------------------
091100200529      *
091200200529     C                   EXSR      ValFrAcDlT
091300200529      *
091400200529      ** Validate For Account of (Deliver From)
091500200529      ** --------------------------------------
091600200529      *
091700200529     C**********         EXSR      ValFrAcDlT                                                 204757
091800200529     C                   EXSR      ValFrAcDF                                                  204757
091900200529      *
092000200529      ** Validate Special Instruction field
092100200529      ** ----------------------------------
092200200529      *
092300200529     C                   EXSR      ValSplInst
092400200529     C/COPY WNCPYSRC,SETSETIVK6
092500200529      *
092600200529      ** Validate Clearance Type
092700200529      ** -----------------------
092800200529      *
092900200529     C                   EXSR      ValClearTp
093000200529      *
093100200529      ** Validate 'In' Currency in Field 72
093200200529      ** ----------------------------------
093300200529      *
093400200529     C     CEU005        IFEQ      'Y'
093500200529     C     DDICCY        ANDNE     *BLANK
093600200529     C                   EXSR      ValICcy72
093700200529     C                   END
093800200529      *
093900200529      ** Validate Profit Centre
094000200529      ** ----------------------
094100200529      **  If Profit Centres used
094200200529      **  and Profit Centre Accounting Module is not installed
094300200529      *
094400200529     C     BKPRCU        IFEQ      'Y'
094500200529     C     BGN0ST        ANDNE     'Y'
094600200529     C                   EXSR      ValProfitC
094700200529     C                   END
094800200529      *
094900200529      ** Validate Priority Code
095000200529      ** ----------------------
095100200529      *
095200200529     C                   EXSR      ValPriorit
095300200529      *
095400200529      ** Validate Pay Code
095500200529      ** -----------------
095600200529      *
095700200529     C                   EXSR      ValPayCode
095800200529      *
095900200529      ** Validate Auto-Settle Ind
096000200529      ** ------------------------
096100200529      *
096200200529     C                   EXSR      ValAutoSet
096300200529
096400200529     C                   ENDSR
096500200529      *****************************************************************
096600200529      /EJECT
096700200529      *****************************************************************
096800200529      *                                                               *
096900200529      * ValSetMet -  Subroutine to perform the validation for the     *
097000200529      *              settlement method.                               *
097100200529      *                                                               *
097200200529      *****************************************************************
097300200529     C     ValSetMet     BEGSR
097400200529      *
097500200529      ** Validate Settlement Method
097600200529     C/COPY WNCPYSRC,SETSETIVC8
097700200529      *
097800200529      **   .. if Market Ind. is 'G', must be blank or '00'
097900200529      *
098000200529     C     DDTDMI        IFEQ      'G'
098100200529
098200200529     C     DDSMTH        IFNE      *BLANKS
098300200529     C     DDSMTH        ANDNE     '00'
098400200529     C                   ADD       1             Idx
098500200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0251'
098600200529     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
098700200529     C                   EVAL      DDSMTHok = 'N'
098800200529     C                   GOTO      EValSetMet
098900200529     C                   END
099000200529      *
099100200529      ** If Market Ind. not 'G', must be a valid MIDAS settlement method
099200200529      *
099300200529     C                   ELSE
099400200529
099500200529     C     DDSMTH        IFLT      '00'
099600200529     C     DDSMTH        OREQ      '09'
099700200529     C     DDSMTH        OREQ      '10'
099800200529     C     DDSMTH        OREQ      '11'
099900200529     C     DDSMTH        OREQ      '13'
100000200529     C     DDSMTH        ORGT      '15'
100100200529     C/COPY WNCPYSRC,SETSETIVC3
100200200529     C                   ADD       1             Idx
100300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0251'
100400200529     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
100500200529     C                   EVAL      DDSMTHok = 'N'
100600200529     C                   GOTO      EValSetMet
100700200529     C                   END
100800200529     C/COPY WNCPYSRC,SETSETIVK7
100900200529
101000200529     C                   END
101100200529
101200200529     C     S01496        IFEQ      'Y'
101300200529     C     CustClass     ANDNE     'I'                                                       BUG2582
101400200529      *
101500200529      ****If*'00'*and*not*incomplete***********************************                       211554
101600200529      *
101700200529      ** If the Settlement Method is '00', the security's market type                         211554
101800200529      ** is not 'G' and the trade is not incomplete - error message                           211554
101900200529      *                                                                                       211554
102000200529     C     DDSMTH        IFEQ      '00'
102100200529     C     DDINCS        ANDNE     'I'
102200200529     C     DDTDMI        ANDNE     'G'                                                        211554
102300200529     C                   ADD       1             Idx
102400200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0252'
102500200529     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
102600200529     C                   EVAL      DDSMTHok = 'N'
102700200529     C                   GOTO      EValSetMet
102800200529     C                   END
102900200529      *
103000200529      ** If settlement method not '00', then for customers
103100200529      ** of bank only settl. method 04,05,14,15 allowed
103200200529      *
103300200529   1 C                   MOVE      'N'           WCHECK
103400200529
103500200529     C     DDSMTH        IFNE      '00'
103600200529
103700200529     C     CustClass     IFEQ      'S'
103800200529     C     CustClass     OREQ      'D'
103900200529
104000200529     C     DDSMTH        IFEQ      '04'
104100200529     C     DDSMTH        OREQ      '05'
104200200529     C     DDSMTH        OREQ      '14'
104300200529     C     DDSMTH        OREQ      '15'
104400200529      *
104500200529      **   .. only for those customer and settl. methods will be
104600200529      **   .. checked, if the same cust. (Warn) and portfolio (Warn)
104700200529      **   .. at the counterparty and at the settlement account
104800200529      *
104900200529   1 C                   MOVE      'Y'           WCHECK
105000200529     C                   ELSE
105100200529     C                   ADD       1             WIx
105200200529     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0253'
105300200529     C                   EVAL      WFldNmXAr(WIx) = 'DDSMTH'
105400200529     C                   EVAL      DDSMTHok = 'W'
105500200529     C                   ENDIF
105600200529
105700200529     C                   ENDIF
105800200529     C                   ENDIF
105900200529
106000200529     C                   ENDIF
106100200529      *
106200200529      ** If '04' or '14' the Retail Module must be present
106300200529      *
106400200529     C     DDSMTH        IFEQ      '04'
106500200529     C     DDSMTH        OREQ      '14'
106600200529
106700200529     C     BGRTBN        IFNE      'Y'
106800200529     C                   ADD       1             Idx
106900200529     C                   EVAL      MsgIDXAr(Idx) = 'ESM0903'
107000200529     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
107100200529     C                   EVAL      DDSMTHok = 'N'
107200200529     C                   GOTO      EValSetMet
107300200529     C                   END
107400200529
107500200529     C                   END
107600200529      *
107700200529      ** If '07' settlement currency must equal US dollar currency code
107800200529      *
107900200529     C     DDSMTH        IFEQ      '07'
108000200529
108100200529     C     DDSETC        IFNE      BLUSCY
108200200529     C                   ADD       1             Idx
108300200529     C                   EVAL      MsgIDXAr(Idx) = 'ESM0905'
108400200529     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
108500200529     C                   EVAL      DDSMTHok = 'N'
108600200529     C                   GOTO      EValSetMet
108700200529     C                   END
108800200529
108900200529     C                   END
109000200529      *
109100200529      ** .. if '06' Clearance Type must be '5'
109200200529      *
109300200529     C     DDCLTY        IFNE      '5'
109400200529     C     DDSMTH        ANDEQ     '06'
109500200529     C                   ADD       1             Idx
109600200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0254'
109700200529     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
109800200529     C                   EVAL      DDSMTHok = 'N'
109900200529     C                   GOTO      EValSetMet
110000200529     C                   END
110100200529      *
110200200529      **   .. if '04' must reference an active ACCNT record
110300200529      *
110400200529     C     DDSMTH        IFEQ      '04'
110500200529     C     CustNum       IFNE      *BLANKS
110600200529     C                   MOVE      CustNum       CNUM
110700200529     C                   MOVEL     DDSETC        CCY
110800200529     C                   MOVE      BMACCD        ACOD
110900200529     C                   Z-ADD     1             ACSQ
111000200529     C                   MOVE      DDBRCD        BRCA
111100200529
111200200529     C     KLACCT        KLIST
111300200529     C                   KFLD                    CNUM
111400200529     C                   KFLD                    CCY
111500200529     C                   KFLD                    ACOD
111600200529     C                   KFLD                    ACSQ
111700200529     C                   KFLD                    BRCA
111800200529
111900200529     C     KLACCT        CHAIN     ACCNTABF                           44
112000200529     C                   END
112100200529
112200200529     C     CustNum       IFEQ      *BLANKS
112300200529     C     *IN44         OREQ      '1'
112400200529     C     RECI          OREQ      '*'
112500200529     C     DACO          ORGT      TDVD
112600200529     C     ACST          OREQ      'C'
112700200529     C                   ADD       1             Idx
112800200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0255'
112900200529     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
113000200529     C                   EVAL      DDSMTHok = 'N'
113100200529     C                   GOTO      EValSetMet
113200200529
113300200529     C                   ELSE
113400200529
113500200529     C                   TESTB     '2'           RETB                     99
113600200529
113700200529     C     DDTDTP        IFEQ      'TP'
113800200529     C     *IN99         ANDEQ     '1'
113900200529     C                   ADD       1             Idx
114000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0255'
114100200529     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
114200200529     C                   EVAL      DDSMTHok = 'N'
114300200529     C                   GOTO      EValSetMet
114400200529     C                   END
114500200529
114600200529     C                   TESTB     '3'           RETB                     99
114700200529
114800200529     C     DDTDTP        IFEQ      'TS'
114900200529     C     *IN99         ANDEQ     '1'
115000200529     C                   ADD       1             Idx
115100200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0255'
115200200529     C                   EVAL      FldNamXAr (Idx) = 'DDSMTH'
115300200529     C                   EVAL      DDSMTHok = 'N'
115400200529     C                   GOTO      EValSetMet
115500200529     C                   END
115600200529
115700200529     C                   END
115800200529     C                   END
115900200529
116000200529      *   if not a nostro settlement, must not be a holiday in local
116100200529      *     currency/system location
116200200529
116300200529     C     DDSMTH        IFNE      '01'
116400200529     C     DDSMTH        ANDNE     '02'
116500200529     C     DDSMTH        ANDNE     '07'
116600200529     C     DDSMTH        ANDNE     '08'
116700200529     C     DDSMTH        ANDNE     '12'
116800200529     C/COPY WNCPYSRC,SETSETIVC4
116900200529     C                   MOVE      BJSLCD        ZLOC
117000200529     C                   Z-ADD     TDVD          ZDAYNO
117100200529     C                   MOVE      BJLCCY        ZCCY
117200200529
117300200529     C                   CALLB     'ZCHKH'
117400200529     C                   PARM                    ZDAYNO
117500200529     C                   PARM                    ZCCY
117600200529     C                   PARM                    ZLOC
117700200529     C                   PARM                    ZIND
117800200529
117900200529     C     ZIND          IFEQ      'H'
118000200529     C                   ADD       1             WIx
118100200529     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0256'
118200200529     C                   EVAL      WFldNmXAr(WIx) = 'DDSMTH'
118300200529     C                   EVAL      DDSMTHok = 'W'
118400200529     C                   END
118500200529
118600200529     C                   END
118700200529
118800200529      * If valid, update trade field
118900200529
119000200529     C     DDSMTHok      IFNE      'N'
119100200529     C/COPY WNCPYSRC,SETSETIVC9
119200200529     C                   MOVEL (P) DDSMTH        SMTH
119300200529     C/COPY WNCPYSRC,SETSETIVK1
119400200529     C                   END
119500200529
119600200529     C     EValSetMet    ENDSR
119700200529      *****************************************************************
119800200529      /EJECT
119900200529      *****************************************************************
120000200529      *                                                               *
120100200529      * ValOrgBrh - Subroutine to perform the validation for the      *
120200200529      *             Originating Branch Field                          *
120300200529      *                                                               *
120400200529      *****************************************************************
120500200529     C     ValOrgBrh     BEGSR
120600200529
120700200529     C     BKOBRU        IFEQ      'Y'
120800200529      *
120900200529     C     DDORBR        IFEQ      *BLANKS
121000200529     C                   MOVE      DDBRCD        DDORBR
121100200529     C                   ELSE
121200200529     C                   MOVE      DDORBR        @DSNB
121300200529
121400200529     C                   EXSR      AOBRCH
121500200529
121600200529     C     @RTCD         IFNE      *BLANKS
121700200529     C                   ADD       1             Idx
121800200529     C                   EVAL      MsgIDXAr(Idx) = 'MMM0013'
121900200529     C                   EVAL      FldNamXAr (Idx) = 'DDORBR'
122000200529     C                   EVAL      DDORBRok = 'N'
122100200529     C                   END
122200200529
122300200529     C                   END
122400200529     C*
122500200529     C     BKOBUV        IFEQ      'Y'
122600200529     C     RespMode      ANDEQ     'S'
122700200529
122800200529     C                   Z-ADD     *ZERO         @ERR
122900200529
123000200529     C                   CALL      'ZVOBU'
123100200529     C                   PARM      DDORBR        @ZOBRX
123200200529     C                   PARM                    @ERR
123300200529     C*
123400200529     C     @ERR          IFEQ      1
123500200529     C                   ADD       1             Idx
123600200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0198'
123700200529     C                   EVAL      FldNamXAr (Idx) = 'DDORBR'
123800200529     C                   EVAL      DDORBRok = 'N'
123900200529
124000200529     C                   ELSE
124100200529
124200200529     C     @ERR          IFEQ      2
124300200529     C                   ADD       1             Idx
124400200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0199'
124500200529     C                   EVAL      FldNamXAr (Idx) = 'DDORBR'
124600200529     C                   EVAL      DDORBRok = 'N'
124700200529     C                   END
124800200529     C                   END
124900200529     C                   END
125000200529     C*
125100200529     C                   ELSE
125200200529     C                   MOVE      DDBRCD        DDORBR
125300200529     C                   END
125400200529
125500200529      * If valid, update trade field
125600200529
125700200529     C     DDORBRok      IFNE      'N'
125800200529     C                   MOVE      DDORBR        ORBR
125900200529     C                   END
126000200529
126100200529     C                   ENDSR
126200200529      *****************************************************************
126300200529      /EJECT
126400200529      *****************************************************************
126500200529      *                                                               *
126600200529      * ValPayFrmP - Subroutine to perform the validation for the     *
126700200529      *              Pay From field if trade is a purchase            *
126800200529      *                                                               *
126900200529      *****************************************************************
127000200529     C     ValPayFrmP    BEGSR
127100200529      *
127200200529      **   .. entry only allowed for certain Settlement Methods
127300200529      *
127400200529     C     DDPYFM        IFNE      *BLANKS
127500200529     C     DDSMTH        ANDNE     '01'
127600200529     C     DDSMTH        ANDNE     '02'
127700200529     C     DDSMTH        ANDNE     '03'
127800200529     C     DDSMTH        ANDNE     '05'
127900200529     C     DDSMTH        ANDNE     '07'
128000200529     C     DDSMTH        ANDNE     '08'
128100200529     C     DDSMTH        ANDNE     '12'
128200200529     C     DDSMTH        ANDNE     '14'
128300200529     C     DDSMTH        ANDNE     '15'
128400200529      *                                                                                      BUG1603
128500200529     C     BGRTBN        IFNE      'Y'                                                       BUG1603
128600200529     C     DDPYFM        ANDNE     *BLANKS                                                   BUG1603
128700200529     C     DDSMTH        ANDNE     '04'                                                      BUG1603
128800200529      *                                                                                      BUG1603
128900200529     C/COPY WNCPYSRC,SETSETIVC5
129000200529
129100200529     C                   ADD       1             Idx
129200200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0257'
129300200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
129400200529     C                   EVAL      DDPYFMok = 'N'
129500200529     C                   GOTO      EValPayFrP
129600200529     C                   END
129700200529      *                                                                                      BUG1603
129800200529     C                   END                                                                 BUG1603
129900200529      *
130000200529      ** if Settlement Method '01' '02' '07' '08' or '12' must
130100200529      ** reference an active Nostro on SDNOSTPD and Pay From
130200200529      ** branch must match branch of Nostro
130300200529      *
130400200529     C     DDSMTH        IFEQ      '01'
130500200529     C     DDSMTH        OREQ      '02'
130600200529     C     DDSMTH        OREQ      '07'
130700200529     C     DDSMTH        OREQ      '08'
130800200529     C     DDSMTH        OREQ      '12'
130900200529     C/COPY WNCPYSRC,SETSETIVC6
131000200529
131100200529     C                   MOVE      DDPYFM        WFL10
131200200529     C                   MOVE      *BLANKS       @RTCD
131300200529     C                   MOVE      DDSETC        P@CYCD
131400200529     C                   MOVEL     DDPYFM        P@NONB
131500200529
131600200529     C                   EXSR      AONOST
131700200529
131800200529     C                   MOVEL     DDPYFM        PYFM
131900200529
132000200529     C     @RTCD         IFNE      *BLANKS
132100200529     C     WFL10         ORNE      *BLANKS
132200200529     C                   ADD       1             Idx
132300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0258'
132400200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
132500200529     C                   EVAL      DDPYFMok = 'N'
132600200529     C                   GOTO      EValPayFrP
132700200529      *
132800200529      **  Find Nostro location code for holiday validation
132900200529      *
133000200529     C                   ELSE
133100200529     C                   MOVE      '*DBERR '     @RTCD
133200200529     C                   MOVE      A7BRCD        @DSNB
133300200529
133400200529     C                   EXSR      AOBRCH
133500200529
133600200529     C                   MOVE      A8LCCD        ZLOC
133700200529      *
133800200529      ** If Clearance Type '1' or '2', must not be holiday in
133900200529      ** Euroclear currency
134000200529      *
134100200529     C     DDCLTY        IFEQ      '1'
134200200529     C     DDCLTY        OREQ      '2'
134300200529     C                   Z-ADD     TDVD          ZDAYNO
134400200529     C                   MOVE      BVEUCY        ZCCY
134500200529
134600200529     C                   CALLB     'ZCHKH'
134700200529     C                   PARM                    ZDAYNO
134800200529     C                   PARM                    ZCCY
134900200529     C                   PARM                    ZLOC
135000200529     C                   PARM                    ZIND
135100200529
135200200529     C     ZIND          IFEQ      'H'
135300200529     C                   ADD       1             WIx
135400200529     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0259'
135500200529     C                   EVAL      WFldNmXAr(WIx) = 'DDPYFM'
135600200529     C                   EVAL      DDPYFMok = 'W'
135700200529     C                   END
135800200529
135900200529     C                   END
136000200529      *
136100200529      ** If Clearance Type '3' or '4', must not be holiday in
136200200529      ** Cedel currency.
136300200529      *
136400200529     C     DDCLTY        IFEQ      '3'
136500200529     C     DDCLTY        OREQ      '4'
136600200529     C                   Z-ADD     TDVD          ZDAYNO
136700200529     C                   MOVE      BVCCCY        ZCCY
136800200529
136900200529     C                   CALLB     'ZCHKH'
137000200529     C                   PARM                    ZDAYNO
137100200529     C                   PARM                    ZCCY
137200200529     C                   PARM                    ZLOC
137300200529     C                   PARM                    ZIND
137400200529
137500200529     C     ZIND          IFEQ      'H'
137600200529     C                   ADD       1             WIx
137700200529     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0260'
137800200529     C                   EVAL      WFldNmXAr(WIx) = 'DDPYFM'
137900200529     C                   EVAL      DDPYFMok = 'W'
138000200529     C                   END
138100200529     C                   END
138200200529      *
138300200529      ** If Clearance Type '2','4' or '5', must not be holiday in
138400200529      ** settlement currency
138500200529      *
138600200529     C     DDCLTY        IFEQ      '2'
138700200529     C     DDCLTY        OREQ      '4'
138800200529     C     DDCLTY        OREQ      '5'
138900200529
139000200529     C     DDSETC        IFNE      *BLANKS
139100200529     C                   Z-ADD     TDVD          ZDAYNO
139200200529     C                   MOVE      DDSETC        ZCCY
139300200529     C                   ELSE
139400200529
139500200529     C     CustCurr      IFNE      *BLANKS
139600200529     C                   MOVE      CustCurr      ZCCY
139700200529     C                   ELSE
139800200529     C                   MOVE      NMCY          ZCCY
139900200529     C                   END
140000200529
140100200529     C                   END
140200200529
140300200529     C                   CALLB     'ZCHKH'
140400200529     C                   PARM                    ZDAYNO
140500200529     C                   PARM                    ZCCY
140600200529     C                   PARM                    ZLOC
140700200529     C                   PARM                    ZIND
140800200529
140900200529     C     ZIND          IFEQ      'H'
141000200529     C                   ADD       1             WIx
141100200529     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0261'
141200200529     C                   EVAL      WFldNmXAr(WIx) = 'DDPYFM'
141300200529     C                   EVAL      DDPYFMok = 'W'
141400200529     C                   END
141500200529
141600200529     C                   END
141700200529
141800200529     C                   END
141900200529     C                   MOVE      A7CUST        WPYFM
142000200529
142100200529     C                   END
142200200529      *
142300200529      ** If Settlement Method is '03' may contain a Trade Ref. number.
142400200529      *
142500200529     C     DDSMTH        IFEQ      '03'
142600200529
142700200529     C     DDPYFM        IFNE      *BLANKS
142800200529      *
142900200529     C                   MOVEA     *BLANKS       APF
143000200529     C                   MOVEA     DDPYFM        APF
143100200529     C                   SETOFF                                           99
143200200529      *
143300200529      ** Find first non blank character
143400200529      *
143500200529     C                   Z-ADD     1             IdX1
143600200529     C     IdX1          DOWLE     13
143700200529     C     APF(IdX1)     ANDEQ     ' '
143800200529     C                   ADD       1             IdX1
143900200529     C                   END
144000200529      *
144100200529      **          Ensure each character is numeric
144200200529      *
144300200529     C                   Z-ADD     0             IdY1
144400200529     C     IdX1          DOWLE     13
144500200529     C     APF(IdX1)     ANDNE     *BLANK
144600200529     C     *IN99         ANDNE     '1'
144700200529      *
144800200529     C     APF(IdX1)     COMP      '0'                                  99
144900200529     C  N99APF(IdX1)     COMP      '9'                                99
145000200529     C  N99              ADD       1             IdX1
145100200529     C  N99              ADD       1             IdY1
145200200529      *
145300200529     C                   END
145400200529      *
145500200529      **          Ensure than number is 6 digits
145600200529      *
145700200529     C  N99IdY1          COMP      6                                  9999
145800200529      *
145900200529     C     *IN99         IFEQ      '1'
146000200529     C                   ADD       1             Idx
146100200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0264'
146200200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
146300200529     C                   EVAL      DDPYFMok = 'N'
146400200529     C                   GOTO      EValPayFrP
146500200529     C                   END
146600200529
146700200529     C     DDPYFMok      IFNE      'N'
146800200529     C                   MOVEL     DDPYFM        PYFM
146900200529     C                   END
147000200529      *
147100200529      **   Pay from must not be blank.
147200200529      *
147300200529     C                   ELSE
147400200529
147500200529     C                   ADD       1             Idx
147600200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0264'
147700200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
147800200529     C                   EVAL      DDPYFMok = 'N'
147900200529     C                   GOTO      EValPayFrP
148000200529     C                   END
148100200529
148200200529     C                   END
148300200529      *
148400200529      ** If Settlement Method '05' must reference an active ACCNT record
148500200529      ** for Pay From Branch
148600200529      *
148700200529     C     DDSMTH        IFEQ      '05'
148800200529     C**********         TESTN                   DDPYFM               35                      CSD027
148900200529      *
149000200529      ** If not multi-branching then use single branch code.
149100200529      *
149200200529     C     @MBIN         IFEQ      'N'
149300200529     C     DDPYFB        IFEQ      *BLANK
149400200529     C                   MOVEL     BJSBRC        DDPYFB
149500200529     C                   END
149600200529     C                   END
149700200529
149800200529     C******IN35         IFEQ      '1'                                                        CSD027
149900200529      *
150000200529     C                   MOVE      DDPYFM        WFLD6
150100200529     C                   MOVEL     DDPYFM        CNUM
150200200529     C                   MOVEL     DDSETC        CCY
150300200529     C                   MOVEL     WFLD6         ACOD
150400200529     C                   MOVE      WFLD6         ACSQ
150500200529     C                   MOVE      DDPYFB        BRCA
150600200529
150700200529     C     KLACCT        CHAIN     ACCNTABF                           44
150800200529     C**********         END                                                                  CSD027
150900200529
151000200529     C******IN35         IFEQ      '0'                                                        CSD027
151100200529     C******IN44         OREQ      '1'                                                        CSD027
151200200529     C     *IN44         IFEQ      '1'                                                        CSD027
151300200529     C     RECI          OREQ      '*'
151400200529     C     DACO          ORGT      TDVD
151500200529     C     ACST          OREQ      'C'
151600200529     C                   ADD       1             Idx
151700200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0262'
151800200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
151900200529     C                   EVAL      DDPYFMok = 'N'
152000200529     C                   GOTO      EValPayFrP
152100200529      *
152200200529      ** Else check account is not blocked
152300200529      *
152400200529     C                   ELSE
152500200529     C                   TESTB     '2'           RETB                     99
152600200529
152700200529     C     DDTDTP        IFEQ      'TP'
152800200529     C     *IN99         ANDEQ     '1'
152900200529     C                   ADD       1             Idx
153000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0262'
153100200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
153200200529     C                   EVAL      DDPYFMok = 'N'
153300200529     C                   GOTO      EValPayFrP
153400200529     C                   END
153500200529
153600200529     C                   END
153700200529     C**********         Z-ADD     CNUM          WPYFM                                        CSD027
153800200529     C                   EVAL      WPYFM = CNUM                                               CSD027
153900200529     C                   MOVEL     DDPYFM        PYFM
154000200529     C                   END
154100200529      *
154200200529      ** If Settlement Method '14' must reference an active
154300200529      ** account on ACNUM
154400200529      *
154500200529     C     DDSMTH        IFEQ      '14'
154600200529      *
154700200529      ** If not multibranching then use single branch code.
154800200529      *
154900200529     C     @MBIN         IFEQ      'N'
155000200529     C     DDPYFB        IFEQ      *BLANK
155100200529     C                   MOVEL     BJSBRC        DDPYFB
155200200529     C                   END
155300200529     C                   END
155400200529
155500200529     C                   MOVE      DDPYFB        WPYFB
155600200529     C                   MOVEL     DDPYFM        WPF10
155700200529     C**********         TESTN                   WPF10                35                      CSD027
155800200529
155900200529     C******IN35         IFEQ      '1'                                                        CSD027
156000200529     C                   MOVEL     DDPYFM        KEY10
156100200529     C     KEY10         CHAIN     ACNUMF                             44
156200200529
156300200529     C     *IN44         IFEQ      '0'
156400200529     C     RECI          ANDNE     '*'
156500200529     C     KLACCT        CHAIN     ACCNTABF                           44
156600200529     C                   END
156700200529     C**********         END                                                                  CSD027
156800200529      *
156900200529     C******IN35         IFEQ      '0'                                                        CSD027
157000200529     C******IN44         OREQ      '1'                                                        CSD027
157100200529     C     *IN44         IFEQ      '1'                                                        CSD027
157200200529     C     RECI          OREQ      '*'
157300200529     C     DACO          ORGT      TDVD
157400200529     C     ACST          OREQ      'C'
157500200529     C*****CCY**         ORNE      DDSETC                                                  BUG13286A
157600200529     C*****BRCA*         ORNE      WPYFB                                                   BUG13286A
157700200529     C*****WPYFB         ANDNE     *BLANK                                                  BUG13286A
157800200529     C                   ADD       1             Idx
157900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0263'
158000200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
158100200529     C                   EVAL      DDPYFMok = 'N'
158200200529     C                   GOTO      EValPayFrP
158300200529      *
158400200529      ** Else check account is not blocked
158500200529      *
158600200529     C                   ELSE
158700200529
158800200529     C                   TESTB     '2'           RETB                     99
158900200529
159000200529     C     DDTDTP        IFEQ      'TP'
159100200529     C     *IN99         ANDEQ     '1'
159200200529     C                   ADD       1             Idx
159300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0263'
159400200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
159500200529     C                   EVAL      DDPYFMok = 'N'
159600200529     C                   GOTO      EValPayFrP
159700200529     C                   END
159800200529      *
159900200529     C                   END
160000200529     C**********         Z-ADD     CNUM          WPYFM                                        CSD027
160100200529     C     CCY           IFNE      DDSETC                                                  BUG13286A
160200200529     C     *IN44         ANDEQ     '0'                                                     BUG13286A
160300200529     C                   ADD       1             Idx                                       BUG13286A
160400200529     C                   EVAL      MsgIDXAr(Idx) = 'USR9379'                               BUG13286A
160500200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'                              BUG13286A
160600200529     C                   EVAL      DDPYFMok = 'N'                                          BUG13286A
160700200529     C                   GOTO      EValPayFrP                                              BUG13286A
160800200529     C                   ENDIF                                                             BUG13286A
160900200529      *                                                                                    BUG13286A
161000200529     C     BRCA          IFNE      WPYFB                                                   BUG13286A
161100200529     C     WPYFB         ANDNE     *BLANK                                                  BUG13286A
161200200529     C     *IN44         ANDEQ     '0'                                                     BUG13286A
161300200529     C                   ADD       1             Idx                                       BUG13286A
161400200529     C                   EVAL      MsgIDXAr(Idx) = 'USR9381'                               BUG13286A
161500200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'                              BUG13286A
161600200529     C                   EVAL      DDPYFMok = 'N'                                          BUG13286A
161700200529     C                   GOTO      EValPayFrP                                              BUG13286A
161800200529     C                   ENDIF                                                             BUG13286A
161900200529      *                                                                                    BUG13286A
162000200529     C                   EVAL      WPYFM = CNUM                                               CSD027
162100200529     C                   MOVEL     DDPYFM        PYFM
162200200529     C                   END
162300200529      *
162400200529      ** If Settlement Method '15' may reference an active
162500200529      ** account on ACCNT for Booking Branch.
162600200529      *
162700200529     C     DDSMTH        IFEQ      '15'
162800200529     C     DDPYFM        ANDNE     *BLANKS
162900200529     C                   MOVEL     DDPYFM        WCSNM
163000200529     C                   MOVE      *BLANKS       @RTCD
163100200529
163200200529     C                   EXSR      AOCUST
163300200529
163400200529     C     @RTCD         IFNE      *BLANKS
163500200529
163600200529     C                   MOVEL     DDPYFM        WCUST
163700200529     C**********         TESTN                   WCUST                35                      CSD027
163800200529
163900200529     C******IN35         IFEQ      '0'                                                        CSD027
164000200529     C**********         MOVE      *BLANKS       WCUST                                        CSD027
164100200529     C**********         END                                                                  CSD027
164200200529      *
164300200529      **  Convert shortname to customer number
164400200529      *
164500200529     C                   ELSE
164600200529     C                   MOVE      *BLANKS       DDPYFM
164700200529     C                   MOVEL     BBCUST        DDPYFM
164800200529     C                   MOVEL     BBCUST        WCUST
164900200529     C                   END
165000200529
165100200529     C                   MOVE      *BLANKS       @RTCD
165200200529     C                   EXSR      AOSECS
165300200529
165400200529     C     @RTCD         IFNE      *BLANKS
165500200529     C                   ADD       1             Idx
165600200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0265'
165700200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
165800200529     C                   EVAL      DDPYFMok = 'N'
165900200529     C                   GOTO      EValPayFrP
166000200529     C                   ELSE
166100200529     C                   MOVEL     DDSETC        CCY
166200200529     C                   MOVE      BFCUST        CNUM
166300200529     C                   MOVEL     BFACCD        ACOD
166400200529     C                   Z-ADD     BFACSN        ACSQ
166500200529
166600200529     C     DDPYFB        IFNE      *BLANKS
166700200529     C                   MOVE      DDPYFB        BRCA
166800200529     C                   ELSE
166900200529     C                   MOVE      DDBRCD        BRCA
167000200529     C                   END
167100200529
167200200529     C     KLACCT        CHAIN     ACCNTABF                           44
167300200529      *
167400200529     C     *IN44         IFEQ      '1'
167500200529     C     RECI          OREQ      '*'
167600200529     C     DACO          ORGT      TDVD
167700200529     C     ACST          OREQ      'C'
167800200529     C                   ADD       1             Idx
167900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0265'
168000200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
168100200529     C                   EVAL      DDPYFMok = 'N'
168200200529     C                   GOTO      EValPayFrP
168300200529      *
168400200529      ** Else check account is not blocked
168500200529      *
168600200529     C                   ELSE
168700200529     C                   TESTB     '2'           RETB                     99
168800200529
168900200529     C     DDTDTP        IFEQ      'TP'
169000200529     C     *IN99         ANDEQ     '1'
169100200529     C                   ADD       1             Idx
169200200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0265'
169300200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
169400200529     C                   EVAL      DDPYFMok = 'N'
169500200529     C                   GOTO      EValPayFrP
169600200529     C                   END
169700200529
169800200529     C                   END
169900200529     C**********         Z-ADD     CNUM          WPYFM                                        CSD027
170000200529     C                   EVAL      WPYFM = CNUM                                               CSD027
170100200529
170200200529     C     BFACCD        IFNE      *BLANKS
170300200529     C                   MOVEL     BFACCD        WOUT06
170400200529     C                   ELSE
170500200529     C**********         MOVEL     '0000'        WOUT06                                       CGL029
170600200529     C                   MOVEL     '0000000000'  WOUT06                                       CGL029
170700200529     C                   END
170800200529     C                   MOVE      BFACSN        WOUT06
170900200529
171000200529     C                   MOVE      WOUT06        DDPYFM
171100200529     C                   MOVEL     DDPYFM        PYFM
171200200529     C                   END
171300200529     C                   END
171400200529      *
171500200529      ** If Settlement Method is 15 and PAY FROM is Blank, Output error
171600200529      *
171700200529     C     DDSMTH        IFEQ      '15'
171800200529     C     DDPYFM        ANDEQ     *BLANKS
171900200529     C                   ADD       1             Idx
172000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0266'
172100200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
172200200529     C                   EVAL      DDPYFMok = 'N'
172300200529     C                   GOTO      EValPayFrP
172400200529     C                   END
172500200529      *
172600200529     C     S01496        IFEQ      'Y'
172700200529      *
172800200529      ** If settlement method is 04/05/14/15 and counterparty was
172900200529      ** entered, settlement a/c customer must be the same
173000200529      *
173100200529     C     WCHECK        IFEQ      'Y'
173200200529     C                   MOVE      CustNum       WWCNUM
173300200529
173400200529     C     WPYFM         IFNE      WWCNUM
173500200529     C*****WPYFM         ANDNE     *ZERO                                                      CSD027
173600200529     C     WPYFM         ANDNE     *BLANKS                                                    CSD027
173700200529     C                   ADD       1             WIx
173800200529     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0267'
173900200529     C                   EVAL      WFldNmXAr(WIx) = 'DDPYFM'
174000200529     C                   EVAL      DDPYFMok = 'W'
174100200529     C                   ENDIF
174200200529
174300200529     C                   ENDIF
174400200529     C                   ENDIF
174500200529     C/COPY WNCPYSRC,SETSETIVK8
174600200529
174700200529     C     EValPayFrP    ENDSR
174800200529      *****************************************************************
174900200529      /EJECT
175000200529      *****************************************************************
175100200529      *                                                               *
175200200529      * ValPayFrmS - Subroutine to perform the validation for the     *
175300200529      *              Pay From field if trade is a sale                *
175400200529      *                                                               *
175500200529      *****************************************************************
175600200529     C     ValPayFrmS    BEGSR
175700200529      *
175800200529      ** Entry only allowed for Settlement Methods '01' '07' '08'
175900200529      *
176000200529     C     DDPYFM        IFNE      *BLANKS
176100200529
176200200529     C     DDSMTH        IFNE      '01'
176300200529     C     DDSMTH        ANDNE     '07'
176400200529     C     DDSMTH        ANDNE     '08'
176500200529     C                   ADD       1             Idx
176600200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0268'
176700200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
176800200529     C                   EVAL      DDPYFMok = 'N'
176900200529     C                   GOTO      EValPayFrS
177000200529     C                   END
177100200529      *
177200200529      ** If entered, must be a valid Customer, Shortname or
177300200529      ** Counterparty Nostro
177400200529      *
177500200529     C                   MOVEL     DDPYFM        WCSNM
177600200529     C                   MOVE      *BLANKS       @RTCD
177700200529
177800200529     C                   EXSR      AOCUST
177900200529
178000200529     C     @RTCD         IFNE      *BLANKS
178100200529     C                   MOVEL     DDPYFM        @CPNC
178200200529
178300200529     C                   EXSR      AOCNST
178400200529
178500200529     C     @RTCD         IFEQ      *BLANKS
178600200529     C                   MOVEL     DDPYFM        PYFM
178700200529     C                   ELSE
178800200529     C                   ADD       1             Idx
178900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0269'
179000200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
179100200529     C                   EVAL      DDPYFMok = 'N'
179200200529     C                   GOTO      EValPayFrS
179300200529     C                   END
179400200529      *
179500200529      **  Convert shortname to customer number
179600200529      *
179700200529     C                   ELSE
179800200529     C                   MOVEL     BBCUST        PYFM
179900200529     C                   MOVE      *BLANKS       DDPYFM
180000200529     C                   MOVEL     BBCUST        DDPYFM
180100200529     C                   MOVE      BBCUST        WPYFM
180200200529     C                   END
180300200529
180400200529     C                   END
180500200529
180600200529     C     EValPayFrS    ENDSR
180700200529      *****************************************************************
180800200529      /EJECT
180900200529      *****************************************************************
181000200529      *                                                               *
181100200529      * ValPyFrBrh -  Subroutine to perform the validation for the    *
181200200529      *               Pay From Branch field.                          *
181300200529      *                                                               *
181400200529      *****************************************************************
181500200529     C     ValPyFrBrh    BEGSR
181600200529      *
181700200529      ** For Settlement Method 01, 02, 07, 08 and 12,
181800200529      ** Pay From branch must equal branch of the Nostro
181900200529      *
182000200529     C     DDSMTH        IFEQ      '01'
182100200529     C     DDSMTH        OREQ      '02'
182200200529     C     DDSMTH        OREQ      '07'
182300200529     C     DDSMTH        OREQ      '08'
182400200529     C     DDSMTH        OREQ      '12'
182500200529     C/COPY WNCPYSRC,SETSETIVK2
182600200529
182700200529     C     DDPYFB        IFNE      A7BRCD
182800200529     C     DDPYFB        ANDNE     *BLANK
182900200529     C     DDTDTP        ANDEQ     'TP'
183000200529     C                   ADD       1             Idx
183100200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0270'
183200200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFB'
183300200529     C                   EVAL      DDPYFBok = 'N'
183400200529     C                   END
183500200529
183600200529     C                   END
183700200529      *
183800200529      ** For Settlement Method 14
183900200529      ** Pay From branch must equal branch of the account
184000200529      *
184100200529     C     DDSMTH        IFEQ      '14'
184200200529     C     DDSMTH        OREQ      '15'
184300200529
184400200529     C     DDPYFB        IFNE      BRCA
184500200529     C     DDPYFB        ANDNE     *BLANK
184600200529     C     DDTDTP        ANDEQ     'TP'
184700200529     C                   ADD       1             Idx
184800200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0270'
184900200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFB'
185000200529     C                   EVAL      DDPYFBok = 'N'
185100200529     C                   END
185200200529
185300200529     C                   END
185400200529      *
185500200529      ** For Settlement Method other than 01, 02, 05, 07, 08, 12 & 14, & 15
185600200529      ** Pay From branch must equal Trade Booking branch
185700200529      *
185800200529     C     DDPYFB        IFNE      DDBRCD
185900200529     C     DDPYFB        ANDNE     *BLANK
186000200529     C     DDTDTP        ANDEQ     'TP'
186100200529     C     DDSMTH        ANDNE     '01'
186200200529     C     DDSMTH        ANDNE     '02'
186300200529     C     DDSMTH        ANDNE     '05'
186400200529     C     DDSMTH        ANDNE     '07'
186500200529     C     DDSMTH        ANDNE     '08'
186600200529     C     DDSMTH        ANDNE     '12'
186700200529     C     DDSMTH        ANDNE     '14'
186800200529     C     DDSMTH        ANDNE     '15'
186900200529     C     DDTDMI        ANDNE     'G'
187000200529     C                   ADD       1             Idx
187100200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0271'
187200200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFB'
187300200529     C                   EVAL      DDPYFBok = 'N'
187400200529     C                   END
187500200529      *
187600200529      **   .. if entered must exist on SDBRCHPD
187700200529      *
187800200529     C     DDPYFB        IFNE      *BLANKS
187900200529     C                   MOVE      DDPYFB        @DSNB
188000200529
188100200529     C                   EXSR      AOBRCH
188200200529
188300200529     C     @RTCD         IFNE      *BLANKS
188400200529     C                   ADD       1             Idx
188500200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0272'
188600200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFB'
188700200529     C                   EVAL      DDPYFBok = 'N'
188800200529     C                   END
188900200529
189000200529     C                   END
189100200529
189200200529     C     DDTDTP        IFEQ      'TP'
189300200529     C     @MBIN         ANDEQ     'Y'
189400200529     C     DDSMTH        ANDEQ     '05'
189500200529     C     DDPYFB        ANDEQ     *BLANKS
189600200529     C                   ADD       1             Idx
189700200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0325'
189800200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFB'
189900200529     C                   EVAL      DDPYFBok = 'N'
190000200529     C                   END
190100200529      *
190200200529      ** Determine default
190300200529      *
190400200529     C*****DDSMTH        IFNE      '00'                                              CAP084 AR706553
190500200529     C*****DDPYFB        IFEQ      *BLANKS                                                  AR706553
190600200529     C**********         EXSR      DefPyFrBr                                                AR706553
190700200529     C**********         END                                                                AR706553
190800200529     C**********         ENDIF                                                       CAP084 AR706553
190900200529
191000200529      * Update trade field
191100200529
191200200529     C                   MOVE      DDPYFB        PYFA
191300200529
191400200529     C                   ENDSR
191500200529      *****************************************************************
191600200529      /EJECT
191700200529      *****************************************************************
191800200529      *                                                               *
191900200529      * ValPayToP -  Subroutine to perform the validation for the Pay *
192000200529      *              To field if trade is a purchase                  *
192100200529      *                                                               *
192200200529      *****************************************************************
192300200529     C     ValPayToP     BEGSR
192400200529      *
192500200529      ** Entry only allowed if Settlement Methods '01' '07' '08'
192600200529      *
192700200529     C     DDPAYT        IFNE      *BLANKS
192800200529      *
192900200529     C     DDSMTH        IFNE      '01'
193000200529     C     DDSMTH        ANDNE     '07'
193100200529     C     DDSMTH        ANDNE     '08'
193200200529     C/COPY WNCPYSRC,SETSETIVC7
193300200529     C                   ADD       1             Idx
193400200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0273'
193500200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
193600200529     C                   EVAL      DDPAYTok = 'N'
193700200529     C                   GOTO      EValPayToP
193800200529     C                   END
193900200529      *
194000200529      ** If entered, must be a valid Customer, Shortname or
194100200529      ** Counterparty Nostro
194200200529      *
194300200529     C                   MOVEL     DDPAYT        WCSNM
194400200529     C                   MOVE      *BLANKS       @RTCD
194500200529
194600200529     C                   EXSR      AOCUST
194700200529
194800200529     C     @RTCD         IFNE      *BLANKS
194900200529     C                   MOVEL     DDPAYT        @CPNC
195000200529
195100200529     C                   EXSR      AOCNST
195200200529
195300200529     C     @RTCD         IFEQ      *BLANKS
195400200529     C                   MOVEL     DDPAYT        PAYT
195500200529     C                   ELSE
195600200529     C                   ADD       1             Idx
195700200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0274'
195800200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
195900200529     C                   EVAL      DDPAYTok = 'N'
196000200529     C                   GOTO      EValPayToP
196100200529     C                   END
196200200529      *
196300200529      **  convert shortname to customer number
196400200529      *
196500200529     C                   ELSE
196600200529     C                   MOVEL     BBCUST        PAYT
196700200529     C                   MOVE      *BLANKS       DDPAYT
196800200529     C                   MOVEL     BBCUST        DDPAYT
196900200529     C                   MOVE      BBCUST        WPAYT
197000200529     C                   END
197100200529
197200200529     C                   END
197300200529
197400200529     C     EValPayToP    ENDSR
197500200529      *****************************************************************
197600200529      /EJECT
197700200529      *****************************************************************
197800200529      *                                                               *
197900200529      * ValPayToS -  Subroutine to perform the validation for the Pay *
198000200529      *              To field if trade is a sale                      *
198100200529      *                                                               *
198200200529      *****************************************************************
198300200529     C     ValPayToS     BEGSR
198400200529      *
198500200529      **   .. entry only allowed for certain Settlement Methods
198600200529      *
198700200529     C     DDPAYT        IFNE      *BLANKS
198800200529     C     DDSMTH        ANDNE     '01'
198900200529     C     DDSMTH        ANDNE     '02'
199000200529     C     DDSMTH        ANDNE     '03'
199100200529     C     DDSMTH        ANDNE     '05'
199200200529     C     DDSMTH        ANDNE     '07'
199300200529     C     DDSMTH        ANDNE     '08'
199400200529     C     DDSMTH        ANDNE     '12'
199500200529     C     DDSMTH        ANDNE     '14'
199600200529     C     DDSMTH        ANDNE     '15'
199700200529
199800200529     C     BGRTBN        IFNE      'Y'                                                       BUG1603
199900200529     C     DDPYFM        ANDNE     *BLANKS                                                   BUG1603
200000200529     C     DDSMTH        ANDNE     '04'                                                      BUG1603
200100200529      *                                                                                      BUG1603
200200200529     C                   ADD       1             Idx
200300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0275'
200400200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
200500200529     C                   EVAL      DDPAYTok = 'N'
200600200529     C                   GOTO      EValPayToS
200700200529     C                   END
200800200529      *                                                                                      BUG1603
200900200529     C                   END                                                                 BUG1603
201000200529      *
201100200529      ** if Settlement Method '01' '02' '07' '08' or '12' must
201200200529      ** reference an active Nostro on SDNOSTPD and Pay To
201300200529      ** branch must match branch of Nostro
201400200529      *
201500200529     C     DDSMTH        IFEQ      '01'
201600200529     C     DDSMTH        OREQ      '02'
201700200529     C     DDSMTH        OREQ      '07'
201800200529     C     DDSMTH        OREQ      '08'
201900200529     C     DDSMTH        OREQ      '12'
202000200529
202100200529     C                   MOVE      DDPAYT        WFL10
202200200529     C                   MOVE      *BLANKS       @RTCD
202300200529     C                   MOVEL     DDSETC        P@CYCD
202400200529     C                   MOVEL     DDPAYT        P@NONB
202500200529
202600200529     C                   EXSR      AONOST
202700200529
202800200529     C                   MOVEL     DDPAYT        PAYT
202900200529
203000200529     C     @RTCD         IFNE      *BLANKS
203100200529     C     WFL10         ORNE      *BLANKS
203200200529     C                   ADD       1             Idx
203300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0276'
203400200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
203500200529     C                   EVAL      DDPAYTok = 'N'
203600200529     C                   GOTO      EValPayToS
203700200529      *
203800200529      **  Find nostro location code for holiday validation
203900200529      *
204000200529     C                   ELSE
204100200529     C                   MOVE      '*DBERR '     @RTCD
204200200529     C                   MOVE      A7BRCD        @DSNB
204300200529
204400200529     C                   EXSR      AOBRCH
204500200529
204600200529     C                   MOVE      A8LCCD        ZLOC
204700200529      *
204800200529      ** If Clearance Type '1' or '2', must not be holiday in
204900200529      ** Euroclear currency
205000200529      *
205100200529     C     DDCLTY        IFEQ      '1'
205200200529     C     DDCLTY        OREQ      '2'
205300200529     C                   Z-ADD     TDVD          ZDAYNO
205400200529     C                   MOVE      BVEUCY        ZCCY
205500200529
205600200529     C                   CALLB     'ZCHKH'
205700200529     C                   PARM                    ZDAYNO
205800200529     C                   PARM                    ZCCY
205900200529     C                   PARM                    ZLOC
206000200529     C                   PARM                    ZIND
206100200529
206200200529     C     ZIND          IFEQ      'H'
206300200529     C                   ADD       1             WIx
206400200529     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0277'
206500200529     C                   EVAL      WFldNmXAr(WIx) = 'DDPAYT'
206600200529     C                   EVAL      DDPAYTok = 'W'
206700200529     C                   END
206800200529
206900200529     C                   END
207000200529      *
207100200529      ** If Clearance Type '3' or '4', must not be holiday in
207200200529      ** Cedel currency.
207300200529      *
207400200529     C     DDCLTY        IFEQ      '3'
207500200529     C     DDCLTY        OREQ      '4'
207600200529     C                   Z-ADD     TDVD          ZDAYNO
207700200529     C                   MOVE      BVCCCY        ZCCY
207800200529
207900200529     C                   CALLB     'ZCHKH'
208000200529     C                   PARM                    ZDAYNO
208100200529     C                   PARM                    ZCCY
208200200529     C                   PARM                    ZLOC
208300200529     C                   PARM                    ZIND
208400200529
208500200529     C     ZIND          IFEQ      'H'
208600200529     C                   ADD       1             WIx
208700200529     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0278'
208800200529     C                   EVAL      WFldNmXAr(WIx) = 'DDPAYT'
208900200529     C                   EVAL      DDPAYTok = 'W'
209000200529     C                   END
209100200529     C                   END
209200200529      *
209300200529      ** If Clearance Type '2','4' or '5', must not be holiday in
209400200529      ** settlement currency
209500200529      *
209600200529     C     DDCLTY        IFEQ      '2'
209700200529     C     DDCLTY        OREQ      '4'
209800200529     C     DDCLTY        OREQ      '5'
209900200529
210000200529     C     DDSETC        IFNE      *BLANKS
210100200529     C                   Z-ADD     TDVD          ZDAYNO
210200200529     C                   MOVE      DDSETC        ZCCY
210300200529     C                   ELSE
210400200529      *
210500200529     C     CustCurr      IFNE      *BLANKS
210600200529     C                   MOVE      CustCurr      ZCCY
210700200529     C                   ELSE
210800200529     C                   MOVE      NMCY          ZCCY
210900200529     C                   END
211000200529      *
211100200529     C                   END
211200200529
211300200529     C                   CALLB     'ZCHKH'
211400200529     C                   PARM                    ZDAYNO
211500200529     C                   PARM                    ZCCY
211600200529     C                   PARM                    ZLOC
211700200529     C                   PARM                    ZIND
211800200529
211900200529     C     ZIND          IFEQ      'H'
212000200529     C                   ADD       1             WIx
212100200529     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0279'
212200200529     C                   EVAL      WFldNmXAr(WIx) = 'DDPAYT'
212300200529     C                   EVAL      DDPAYTok = 'W'
212400200529     C                   END
212500200529
212600200529     C                   END
212700200529
212800200529     C                   END
212900200529     C                   MOVE      A7CUST        WPAYT
213000200529
213100200529     C                   END
213200200529      *
213300200529      ** If Settlement Method is '03' may contain a Trade Ref. Number
213400200529      *
213500200529     C     DDSMTH        IFEQ      '03'
213600200529
213700200529     C     DDPAYT        IFNE      *BLANKS
213800200529      *
213900200529     C                   MOVEA     *BLANKS       APF
214000200529     C                   MOVEA     DDPAYT        APF
214100200529     C                   SETOFF                                           99
214200200529      *
214300200529      ** Find first non blank character
214400200529      *
214500200529     C                   Z-ADD     1             IdX1
214600200529     C     IdX1          DOWLE     13
214700200529     C     APF(IdX1)     ANDEQ     ' '
214800200529     C                   ADD       1             IdX1
214900200529     C                   END
215000200529      *
215100200529      **          Ensure each character is numeric
215200200529      *
215300200529     C                   Z-ADD     0             IdY1
215400200529     C     IdX1          DOWLE     13
215500200529     C     APF(IdX1)     ANDNE     *BLANK
215600200529     C     *IN99         ANDNE     '1'
215700200529      *
215800200529     C     APF(IdX1)     COMP      '0'                                  99
215900200529     C  N99APF(IdX1)     COMP      '9'                                99
216000200529     C  N99              ADD       1             IdX1
216100200529     C  N99              ADD       1             IdY1
216200200529      *
216300200529     C                   END
216400200529      *
216500200529      **          Ensure than number is 6 digits
216600200529      *
216700200529     C  N99IdY1          COMP      6                                  9999
216800200529      *
216900200529     C     *IN99         IFEQ      '1'
217000200529     C                   ADD       1             Idx
217100200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0280'
217200200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
217300200529     C                   EVAL      DDPAYTok = 'N'
217400200529     C                   GOTO      EValPayToS
217500200529     C                   END
217600200529
217700200529     C     DDPAYTok      IFNE      'N'
217800200529     C                   MOVEL     DDPAYT        PAYT
217900200529     C                   END
218000200529      *
218100200529      **  Pay to must not be blank.
218200200529      *
218300200529     C                   ELSE
218400200529
218500200529     C                   ADD       1             Idx
218600200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0280'
218700200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
218800200529     C                   EVAL      DDPAYTok = 'N'
218900200529     C                   GOTO      EValPayToS
219000200529     C                   END
219100200529
219200200529     C                   END
219300200529      *
219400200529      ** If Settlement Method '05' must reference an active ACCNT record
219500200529      ** for Pay To Branch
219600200529      *
219700200529     C     DDSMTH        IFEQ      '05'
219800200529     C**********         TESTN                   DDPAYT               35                      CSD027
219900200529      *
220000200529      ** If not multi-branching then use single branch code.
220100200529      *
220200200529     C     @MBIN         IFEQ      'N'
220300200529     C     DDPYTB        IFEQ      *BLANK
220400200529     C                   MOVEL     BJSBRC        DDPYTB
220500200529     C                   END
220600200529     C                   END
220700200529
220800200529     C******IN35         IFEQ      '1'                                                        CSD027
220900200529
221000200529     C                   MOVE      DDPAYT        WFLD6
221100200529     C                   MOVEL     DDPAYT        CNUM
221200200529     C                   MOVEL     DDSETC        CCY
221300200529     C                   MOVEL     WFLD6         ACOD
221400200529     C                   MOVE      WFLD6         ACSQ
221500200529     C                   MOVE      DDPYTB        BRCA
221600200529
221700200529     C     KLACCT        CHAIN     ACCNTABF                           44
221800200529     C**********         END                                                                  CSD027
221900200529
222000200529     C******IN35         IFEQ      '0'                                                        CSD027
222100200529     C******IN44         OREQ      '1'                                                        CSD027
222200200529     C     *IN44         IFEQ      '1'                                                        CSD027
222300200529     C     RECI          OREQ      '*'
222400200529     C     DACO          ORGT      TDVD
222500200529     C     ACST          OREQ      'C'
222600200529     C                   ADD       1             Idx
222700200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0281'
222800200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
222900200529     C                   EVAL      DDPAYTok = 'N'
223000200529     C                   GOTO      EValPayToS
223100200529      *
223200200529      ** else check account is not blocked
223300200529      *
223400200529     C                   ELSE
223500200529     C                   TESTB     '3'           RETB                     99
223600200529
223700200529     C     DDTDTP        IFEQ      'TS'
223800200529     C     *IN99         ANDEQ     '1'
223900200529     C                   ADD       1             Idx
224000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0281'
224100200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
224200200529     C                   EVAL      DDPAYTok = 'N'
224300200529     C                   GOTO      EValPayToS
224400200529     C                   END
224500200529
224600200529     C                   END
224700200529     C**********         Z-ADD     CNUM          WPAYT                                        CSD027
224800200529     C                   EVAL      WPAYT = CNUM                                               CSD027
224900200529     C                   MOVE      DDPAYT        PAYT
225000200529     C                   END
225100200529      *
225200200529      ** If Settlement Method '14' must reference an active
225300200529      ** account on ACNUM
225400200529      *
225500200529     C     DDSMTH        IFEQ      '14'
225600200529      *
225700200529      ** If not multibranching then use single branch code.
225800200529      *
225900200529     C     @MBIN         IFEQ      'N'
226000200529     C     DDPYTB        IFEQ      *BLANK
226100200529     C                   MOVEL     BJSBRC        DDPYTB
226200200529     C                   END
226300200529     C                   END
226400200529
226500200529     C                   MOVE      DDPYTB        WPYTB
226600200529     C                   MOVEL     DDPAYT        WPT10
226700200529     C**********         TESTN                   WPT10                35                      CSD027
226800200529
226900200529     C******IN35         IFEQ      '1'                                                        CSD027
227000200529     C                   MOVEL     DDPAYT        KEY10
227100200529     C     KEY10         CHAIN     ACNUMF                             44
227200200529
227300200529     C     *IN44         IFEQ      '0'
227400200529     C     RECI          ANDNE     '*'
227500200529     C     KLACCT        CHAIN     ACCNTABF                           44
227600200529     C                   END
227700200529     C**********         END                                                                  CSD027
227800200529
227900200529     C******IN35         IFEQ      '0'                                                        CSD027
228000200529     C******IN44         OREQ      '1'                                                        CSD027
228100200529     C     *IN44         IFEQ      '1'                                                        CSD027
228200200529     C     RECI          OREQ      '*'
228300200529     C     DACO          ORGT      TDVD
228400200529     C     ACST          OREQ      'C'
228500200529     C*****CCY**         ORNE      DDSETC                                                  BUG13286A
228600200529     C*****BRCA*         ORNE      WPYTB                                                    BUG13286
228700200529     C*****WPYTB         ANDNE     *BLANK                                                   BUG13286
228800200529     C                   ADD       1             Idx
228900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0282'
229000200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
229100200529     C                   EVAL      DDPAYTok = 'N'
229200200529     C                   GOTO      EValPayToS
229300200529      *
229400200529      ** Else check account is not blocked
229500200529      *
229600200529     C                   ELSE
229700200529
229800200529     C                   TESTB     '3'           RETB                     99
229900200529
230000200529     C     DDTDTP        IFEQ      'TS'
230100200529     C     *IN99         ANDEQ     '1'
230200200529     C                   ADD       1             Idx
230300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0282'
230400200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
230500200529     C                   EVAL      DDPAYTok = 'N'
230600200529     C                   GOTO      EValPayToS
230700200529     C                   END
230800200529      *
230900200529     C                   END
231000200529      *                                                                                     BUG13286
231100200529     C     BRCA          IFNE      WPYTB                                                    BUG13286
231200200529     C     WPYTB         ANDNE     *BLANK                                                   BUG13286
231300200529     C     *IN44         ANDEQ     '0'                                                     BUG13286A
231400200529     C                   ADD       1             Idx                                        BUG13286
231500200529     C                   EVAL      MsgIDXAr(Idx) = 'USR9380'                                BUG13286
231600200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'                               BUG13286
231700200529     C                   EVAL      DDPAYTok = 'N'                                           BUG13286
231800200529     C                   GOTO      EValPayToS                                               BUG13286
231900200529     C                   ENDIF                                                              BUG13286
232000200529      *                                                                                     BUG13286
232100200529     C     CCY           IFNE      DDSETC                                                  BUG13286A
232200200529     C     *IN44         ANDEQ     '0'                                                     BUG13286A
232300200529     C                   ADD       1             Idx                                       BUG13286A
232400200529     C                   EVAL      MsgIDXAr(Idx) = 'USR9379'                               BUG13286A
232500200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'                              BUG13286A
232600200529     C                   EVAL      DDPayTok = 'N'                                          BUG13286A
232700200529     C                   GOTO      EValPayToS                                              BUG13286A
232800200529     C                   ENDIF                                                             BUG13286A
232900200529      *                                                                                    BUG13286A
233000200529     C**********         Z-ADD     CNUM          WPAYT                                        CSD027
233100200529     C                   EVAL      WPAYT = CNUM                                               CSD027
233200200529     C                   MOVE      DDPAYT        PAYT
233300200529                                                                                             BUG3145
233400200529      ** Move this additional validation into a new module SETRADAVAL                        BUG3145
233500200529                                                                                      CGL014 BUG3145
233600200529     C**********         IF        CGL014 = 'Y'  AND  DDPAYTok <> 'N'                 CGL014 BUG3145
233700200529     C**********         MOVE      CNUM          PACNUM                               CGL014 BUG3145
233800200529     C**********         MOVE      ACOD          PAACOD                               CGL014 BUG3145
233900200529     C**********         MOVE      ACSQ          PAACSQ                               CGL014 BUG3145
234000200529                                                                                      CGL014 BUG3145
234100200529     C**********         CALLB     'GL006000'                                         CGL014 BUG3145
234200200529     C**********         PARM      TCTR          PTAMNT                               CGL014 BUG3145
234300200529     C**********         PARM      NMCY          PTCCY                                CGL014 BUG3145
234400200529     C**********         PARM      BRCA          PABRCA                               CGL014 BUG3145
234500200529     C**********         PARM                    PACNUM                               CGL014 BUG3145
234600200529     C**********         PARM      CCY           PACCY                                CGL014 BUG3145
234700200529     C**********         PARM                    PAACOD                               CGL014 BUG3145
234800200529     C**********         PARM                    PAACSQ                               CGL014 BUG3145
234900200529     C**********         PARM      ACNO          PAACNO                               CGL014 BUG3145
235000200529     C**********         PARM      *BLANKS       PRTNCD                               CGL014 BUG3145
235100200529                                                                                      CGL014 BUG3145
235200200529      ***Error:**Available*balance*is*not*sufficient*******************               CGL014 BUG3145
235300200529      ***to*cover*blocked*amount***************************************               CGL014 BUG3145
235400200529                                                                                      CGL014 BUG3145
235500200529     C**********         IF        PRTNCD = '*BLKERR'                                 CGL014 BUG3145
235600200529     C**********         ADD       1             Idx                                  CGL014 BUG3145
235700200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0862'                          CGL014 BUG3145
235800200529     C**********         EVAL      FldNamXAr(Idx) = 'DDPAYT'                          CGL014 BUG3145
235900200529     C**********         EVAL      DDPAYTok = 'N'                                     CGL014 BUG3145
236000200529     C**********         GOTO      EValPayToS                                         CGL014 BUG3145
236100200529     C**********         ENDIF                                                        CGL014 BUG3145
236200200529                                                                                      CGL014 BUG3145
236300200529      ***Warning:**Balance*is*greater*than*blocked*amount*but*less*****               CGL014 BUG3145
236400200529      ***than*minimum*balance;*minimum*balance*will*be*exceeded********               CGL014 BUG3145
236500200529                                                                                      CGL014 BUG3145
236600200529     C**********         IF        PRTNCD = '*WARN  '                                 CGL014 BUG3145
236700200529     C**********         ADD       1             WIx                                  CGL014 BUG3145
236800200529     C**********         EVAL      WMsgIDXAr(WIx) = 'MMA0863'                         CGL014 BUG3145
236900200529     C**********         EVAL      WFldNmXAr(WIx) = 'DDPAYT'                          CGL014 BUG3145
237000200529     C**********         EVAL      DDPAYTok = 'W'                                     CGL014 BUG3145
237100200529     C**********         ENDIF                                                        CGL014 BUG3145
237200200529                                                                                      CGL014 BUG3145
237300200529     C**********         ENDIF                                                        CGL014 BUG3145
237400200529                                                                                      CGL014 BUG3145
237500200529     C                   END
237600200529      *
237700200529      ** If Settlement Method '15' may reference an active
237800200529      ** account on ACCNT for Booking Branch.
237900200529      *
238000200529     C     DDSMTH        IFEQ      '15'
238100200529     C     DDPAYT        ANDNE     *BLANKS
238200200529     C                   MOVEL     DDPAYT        WCSNM
238300200529     C                   MOVE      *BLANKS       @RTCD
238400200529
238500200529     C                   EXSR      AOCUST
238600200529
238700200529     C     @RTCD         IFNE      *BLANKS
238800200529      *
238900200529     C                   MOVEL     DDPAYT        WCUST
239000200529     C**********         TESTN                   WCUST                35                      CSD027
239100200529
239200200529     C******IN35         IFEQ      '0'                                                        CSD027
239300200529     C**********         MOVE      *BLANKS       WCUST                                        CSD027
239400200529     C**********         END                                                                  CSD027
239500200529      *
239600200529      ** Convert shortname to customer number
239700200529      *
239800200529     C                   ELSE
239900200529     C                   MOVE      *BLANKS       DDPAYT
240000200529     C                   MOVEL     BBCUST        DDPAYT
240100200529     C                   MOVEL     BBCUST        WCUST
240200200529     C                   END
240300200529
240400200529     C                   MOVE      *BLANKS       @RTCD
240500200529     C                   EXSR      AOSECS
240600200529
240700200529     C     @RTCD         IFNE      *BLANKS
240800200529     C                   ADD       1             Idx
240900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0286'
241000200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
241100200529     C                   EVAL      DDPAYTok = 'N'
241200200529     C                   GOTO      EValPayToS
241300200529     C                   ELSE
241400200529     C                   MOVEL     DDSETC        CCY
241500200529     C                   MOVE      BFCUST        CNUM
241600200529     C                   MOVEL     BFACCD        ACOD
241700200529     C                   Z-ADD     BFACSN        ACSQ
241800200529
241900200529     C     DDPYTB        IFNE      *BLANKS
242000200529     C                   MOVE      DDPYTB        BRCA
242100200529     C                   ELSE
242200200529     C                   MOVE      DDBRCD        BRCA
242300200529     C                   END
242400200529
242500200529     C     KLACCT        CHAIN     ACCNTABF                           44
242600200529
242700200529     C     *IN44         IFEQ      '1'
242800200529     C     RECI          OREQ      '*'
242900200529     C     DACO          ORGT      TDVD
243000200529     C     ACST          OREQ      'C'
243100200529     C                   ADD       1             Idx
243200200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0282'
243300200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
243400200529     C                   EVAL      DDPAYTok = 'N'
243500200529     C                   GOTO      EValPayToS
243600200529      *
243700200529      ** else check account is not blocked
243800200529      *
243900200529     C                   ELSE
244000200529     C                   TESTB     '3'           RETB                     99
244100200529
244200200529     C     DDTDTP        IFEQ      'TS'
244300200529     C     *IN99         ANDEQ     '1'
244400200529     C                   ADD       1             Idx
244500200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0282'
244600200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
244700200529     C                   EVAL      DDPAYTok = 'N'
244800200529     C                   GOTO      EValPayToS
244900200529     C                   END
245000200529
245100200529     C                   END
245200200529     C**********         Z-ADD     CNUM          WPAYT                                        CSD027
245300200529     C                   EVAL      WPAYT = CNUM                                               CSD027
245400200529
245500200529     C     BFACCD        IFNE      *BLANKS
245600200529     C                   MOVEL     BFACCD        WOUT06
245700200529     C                   ELSE
245800200529     C**********         MOVEL     '0000'        WOUT06                                       CGL029
245900200529     C                   MOVEL     '0000000000'  WOUT06                                       CGL029
246000200529     C                   END
246100200529     C                   MOVE      BFACSN        WOUT06
246200200529
246300200529     C                   MOVE      WOUT06        DDPAYT
246400200529     C                   MOVEL     DDPAYT        PAYT
246500200529     C                   END
246600200529     C                   END
246700200529      *
246800200529      ** If settlement method is 15 and Pay To is Blank output Error
246900200529      *
247000200529     C     DDSMTH        IFEQ      '15'
247100200529     C     DDPAYT        ANDEQ     *BLANKS
247200200529     C                   ADD       1             Idx
247300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0284'
247400200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
247500200529     C                   EVAL      DDPAYTok = 'N'
247600200529     C                   GOTO      EValPayToS
247700200529     C                   END
247800200529
247900200529     C     S01496        IFEQ      'Y'
248000200529      *
248100200529      ** If settlement method is 04/05/14/15 and counterparty was
248200200529      ** entered, settlement a/c customer must be the same
248300200529      *
248400200529     C     WCHECK        IFEQ      'Y'
248500200529     C                   MOVE      CustNum       WWCNUM
248600200529
248700200529     C     WPAYT         IFNE      WWCNUM
248800200529     C*****WPAYT         ANDNE     *ZERO                                                      CSD027
248900200529     C     WPAYT         ANDNE     *BLANKS                                                    CSD027
249000200529     C                   ADD       1             WIx
249100200529     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0285'
249200200529     C                   EVAL      WFldNmXAr(WIx) = 'DDPAYT'
249300200529     C                   EVAL      DDPAYTok = 'W'
249400200529     C                   ENDIF
249500200529
249600200529     C                   ENDIF
249700200529     C                   ENDIF
249800200529
249900200529     C     EValPayToS    ENDSR
250000200529      *****************************************************************
250100200529      /EJECT
250200200529      *****************************************************************
250300200529      *                                                               *
250400200529      * ValPyToBrh- Subroutine to perform the validation for the Pay  *
250500200529      *             To Branch field.                                  *
250600200529      *                                                               *
250700200529      *****************************************************************
250800200529     C     ValPyToBrh    BEGSR
250900200529      *
251000200529      ** For Settlement Method 01, 02, 07, 08 and 12,
251100200529      ** Pay To branch must equal branch of the Nostro
251200200529      *
251300200529     C     DDSMTH        IFEQ      '01'
251400200529     C     DDSMTH        OREQ      '02'
251500200529     C     DDSMTH        OREQ      '07'
251600200529     C     DDSMTH        OREQ      '08'
251700200529     C     DDSMTH        OREQ      '12'
251800200529
251900200529     C     DDPYTB        IFNE      A7BRCD
252000200529     C     DDPYTB        ANDNE     *BLANK
252100200529     C     DDTDTP        ANDEQ     'TS'
252200200529     C                   ADD       1             Idx
252300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0287'
252400200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYTB'
252500200529     C                   EVAL      DDPYTBok = 'N'
252600200529     C                   END
252700200529
252800200529     C                   END
252900200529      *
253000200529      ** For Settlement Method 14
253100200529      ** Pay To branch must equal branch of the account
253200200529      *
253300200529     C     DDSMTH        IFEQ      '14'
253400200529     C     DDSMTH        OREQ      '15'
253500200529
253600200529     C     DDPYTB        IFNE      BRCA
253700200529     C     DDPYTB        ANDNE     *BLANK
253800200529     C     DDTDTP        ANDEQ     'TS'
253900200529     C                   ADD       1             Idx
254000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0288'
254100200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYTB'
254200200529     C                   EVAL      DDPYTBok = 'N'
254300200529     C                   END
254400200529
254500200529     C                   END
254600200529      *
254700200529      ** For Settlement Method other than 01, 02, 05, 07, 08, 12 & 14, & 15
254800200529      ** Pay To branch must equal Trade Booking branch
254900200529      *
255000200529     C     DDPYTB        IFNE      DDBRCD
255100200529     C     DDPYTB        ANDNE     *BLANK
255200200529     C     DDTDTP        ANDEQ     'TS'
255300200529     C     DDSMTH        ANDNE     '01'
255400200529     C     DDSMTH        ANDNE     '02'
255500200529     C     DDSMTH        ANDNE     '05'
255600200529     C     DDSMTH        ANDNE     '07'
255700200529     C     DDSMTH        ANDNE     '08'
255800200529     C     DDSMTH        ANDNE     '12'
255900200529     C     DDSMTH        ANDNE     '14'
256000200529     C     DDSMTH        ANDNE     '15'
256100200529     C     DDTDMI        ANDNE     'G'
256200200529     C                   ADD       1             Idx
256300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0289'
256400200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYTB'
256500200529     C                   EVAL      DDPYTBok = 'N'
256600200529     C                   END
256700200529      *
256800200529      ** If entered must exist on SDBRCHPD
256900200529      *
257000200529     C     DDPYTB        IFNE      *BLANKS
257100200529     C                   MOVE      DDPYTB        @DSNB
257200200529
257300200529     C                   EXSR      AOBRCH
257400200529
257500200529     C     @RTCD         IFNE      *BLANKS
257600200529     C                   ADD       1             Idx
257700200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0290'
257800200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYTB'
257900200529     C                   EVAL      DDPYTBok = 'N'
258000200529     C                   END
258100200529
258200200529     C                   END
258300200529
258400200529     C     DDTDTP        IFEQ      'TS'
258500200529     C     @MBIN         ANDEQ     'Y'
258600200529     C     DDSMTH        ANDEQ     '05'
258700200529     C     DDPYTB        ANDEQ     *BLANKS
258800200529     C                   ADD       1             Idx
258900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0324'
259000200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYTB'
259100200529     C                   EVAL      DDPYTBok = 'N'
259200200529     C                   END
259300200529      *
259400200529      ** Determine default
259500200529      *
259600200529      *
259700200529     C*****DDSMTH        IFNE      '00'                                              CAP084 AR706553
259800200529     C*****DDPYTB        IFEQ      *BLANKS                                                  AR706553
259900200529     C**********         EXSR      DefPyToBr                                                AR706553
260000200529     C**********         END                                                                AR706553
260100200529     C**********         ENDIF                                                       CAP084 AR706553
260200200529
260300200529      * Update trade field
260400200529
260500200529     C                   MOVE      DDPYTB        PYTA
260600200529
260700200529     C                   ENDSR
260800200529      *****************************************************************
260900200529      /EJECT
261000200529      *****************************************************************
261100200529      *                                                               *
261200200529      * ValFrAcPyT- Subroutine to perform the validation for the      *
261300200529      *             For Account of (Pay To).                          *
261400200529      *                                                               *
261500200529      *****************************************************************
261600200529     C     ValFrAcPyT    BEGSR
261700200529
261800200529     C     DDTDFA        IFNE      *BLANKS
261900200529
262000200529     C/COPY WNCPYSRC,SETSETIVK9
262100200529     C     DDTDTP        IFNE      'TP'
262200200529     C     DDTDTP        OREQ      'TP'
262300200529     C     DDSMTH        ANDNE     '01'
262400200529     C     DDSMTH        ANDNE     '07'
262500200529     C     DDSMTH        ANDNE     '08'
262600200529     C                   ADD       1             Idx
262700200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0291'
262800200529     C                   EVAL      FldNamXAr (Idx) = 'DDTDFA'
262900200529     C                   EVAL      DDTDFAok = 'N'
263000200529     C                   END
263100200529     C/COPY WNCPYSRC,SETSETIVM1
263200200529      *
263300200529      ** If entered, must be a valid Customer, Shortname or counterparty
263400200529      ** Nostro
263500200529      *
263600200529     C                   MOVEL     *BLANKS       WCSNM
263700200529     C                   MOVEL     DDTDFA        WCSNM
263800200529     C                   MOVE      *BLANKS       @RTCD
263900200529
264000200529     C                   EXSR      AOCUST
264100200529
264200200529     C     @RTCD         IFEQ      *BLANKS
264300200529     C                   MOVEL     BBCUST        TDFA
264400200529     C                   MOVEL     *BLANK        DDTDFA
264500200529     C                   MOVEL     BBCUST        DDTDFA
264600200529     C                   ELSE
264700200529     C                   MOVEL     DDTDFA        @CPNC
264800200529
264900200529     C                   EXSR      AOCNST
265000200529
265100200529     C     @RTCD         IFEQ      *BLANKS
265200200529     C                   MOVEL     DDTDFA        TDFA
265300200529     C                   ELSE
265400200529     C                   ADD       1             Idx
265500200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0292'
265600200529     C                   EVAL      FldNamXAr (Idx) = 'DDTDFA'
265700200529     C                   EVAL      DDTDFAok = 'N'
265800200529     C                   END
265900200529
266000200529     C                   END
266100200529     C                   END
266200200529
266300200529     C                   ENDSR
266400200529      *****************************************************************
266500200529      /EJECT
266600200529      *****************************************************************
266700200529      *                                                               *
266800200529      * ValAcSeq  - Subroutine to perform the validation for the      *
266900200529      *             Account Sequence field.                           *
267000200529      *                                                               *
267100200529      *****************************************************************
267200200529     C     ValAcSeq      BEGSR
267300200529
267400200529      *
267500200529      ** If entered, must be numeric
267600200529      *
267700200529     C     DDASNM        IFNE      *BLANKS
267800200529     C                   TESTN                   DDASNM               35
267900200529
268000200529     C     *IN35         IFEQ      '0'
268100200529     C                   ADD       1             Idx
268200200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0293'
268300200529     C                   EVAL      FldNamXAr (Idx) = 'DDASNM'
268400200529     C                   EVAL      DDASNMok = 'N'
268500200529     C                   ELSE
268600200529     C                   MOVEL     DDASNM        ASNM
268700200529     C                   END
268800200529
268900200529     C                   END
269000200529
269100200529     C                   ENDSR
269200200529      *****************************************************************
269300200529      /EJECT
269400200529      *****************************************************************
269500200529      *                                                               *
269600200529      * ValDelvrFm - Subroutine to perform the validation for the     *
269700200529      *              Deliver From field.                              *
269800200529      *                                                               *
269900200529      *****************************************************************
270000200529     C     ValDelvrFm    BEGSR
270100200529      *
270200200529      ** - For Complete trade (not Grey Market)
270300200529      ** - Mandatory if portfolio customer or market client if sale
270400200529      *
270500200529     C     DDINCS        IFEQ      'C'
270600200529     C     DDTDMI        ANDNE     'G'
270700200529
270800200529     C     CustClass     IFEQ      'S'
270900200529     C     CustClass     OREQ      'D'
271000200529     C     CustClass     OREQ      'M'
271100200529     C     DDTDTP        ANDEQ     'TS'
271200200529
271300200529     C     DDDELF        IFEQ      *BLANKS
271400200529     C                   ADD       1             Idx
271500200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0294'
271600200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
271700200529     C                   EVAL      DDDELFok = 'N'
271800200529     C                   GOTO      EValDelFm
271900200529     C                   END
272000200529     C                   END
272100200529     C                   END
272200200529      *
272300200529      ** If entered, must be a valid Customer or Shortname
272400200529      *
272500200529     C     DDDELF        IFNE      *BLANKS
272600200529     C                   MOVEL     DDDELF        WCSNM
272700200529     C                   MOVE      *BLANKS       @RTCD
272800200529
272900200529     C                   EXSR      AOCUST
273000200529
273100200529     C     @RTCD         IFNE      *BLANKS
273200200529     C                   ADD       1             Idx
273300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0294'
273400200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
273500200529     C                   EVAL      DDDELFok = 'N'
273600200529     C                   GOTO      EValDelFm
273700200529     C                   ELSE
273800200529     C                   MOVE      BBCUST        WCUST
273900200529     C                   MOVE      *BLANKS       @RTCD
274000200529
274100200529     C                   EXSR      AOSECS
274200200529
274300200529     C     @RTCD         IFNE      *BLANKS
274400200529     C                   ADD       1             Idx
274500200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0294'
274600200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
274700200529     C                   EVAL      DDDELFok = 'N'
274800200529     C                   GOTO      EValDelFm
274900200529      *
275000200529      ** Portfolio customers are not valid for Deliver From entry.
275100200529      *
275200200529     C                   ELSE
275300200529
275400200529     C     BFCLAS        IFEQ      'S'
275500200529     C     BFCLAS        OREQ      'D'
275600200529     C                   ADD       1             Idx
275700200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0295'
275800200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
275900200529     C                   EVAL      DDDELFok = 'N'
276000200529     C                   GOTO      EValDelFm
276100200529     C                   END
276200200529
276300200529     C                   END
276400200529     C                   END
276500200529     C                   MOVE      BFCLAS        FC1DI
276600200529     C                   MOVE      BFCUST        WDELF
276700200529     C                   MOVEL     WDELF         DELF
276800200529     C                   ELSE
276900200529     C                   MOVE      *BLANK        FC1DI
277000200529     C**********         Z-ADD     *ZEROS        WDELF                                        CSD027
277100200529     C                   EVAL      WDELF = *BLANKS                                            CSD027
277200200529     C                   MOVEL     WDELF         DELF
277300200529     C                   END
277400200529      *
277500200529      ** Check combinations of clearance type/discretionary ind.
277600200529      *
277700200529     C     DDCLTY        IFEQ      '0'
277800200529     C     DDDELF        ANDNE     *BLANKS
277900200529     C                   ADD       1             Idx
278000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
278100200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
278200200529     C                   EVAL      DDDELFok = 'N'
278300200529     C                   GOTO      EValDelFm
278400200529     C                   END
278500200529      *
278600200529     C     DDCLTY        IFEQ      '1'
278700200529     C     FC1DI         ANDNE     'E'
278800200529     C                   ADD       1             Idx
278900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
279000200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
279100200529     C                   EVAL      DDDELFok = 'N'
279200200529     C                   GOTO      EValDelFm
279300200529     C                   END
279400200529      *
279500200529     C     DDCLTY        IFEQ      '2'
279600200529
279700200529     C     DDTDTP        IFEQ      'TS'
279800200529     C     FC1DI         ANDNE     'E'
279900200529     C                   ADD       1             Idx
280000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
280100200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
280200200529     C                   EVAL      DDDELFok = 'N'
280300200529     C                   GOTO      EValDelFm
280400200529     C                   END
280500200529     C                   END
280600200529      *
280700200529     C     DDCLTY        IFEQ      '2'
280800200529
280900200529     C     DDTDTP        IFEQ      'TP'
281000200529     C     FC1DI         ANDEQ     'E'
281100200529     C                   ADD       1             Idx
281200200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
281300200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
281400200529     C                   EVAL      DDDELFok = 'N'
281500200529     C                   GOTO      EValDelFm
281600200529     C                   END
281700200529
281800200529     C                   END
281900200529      *
282000200529     C     DDCLTY        IFEQ      '3'
282100200529     C     FC1DI         ANDNE     'C'
282200200529     C                   ADD       1             Idx
282300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
282400200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
282500200529     C                   EVAL      DDDELFok = 'N'
282600200529     C                   GOTO      EValDelFm
282700200529     C                   END
282800200529      *
282900200529     C     DDCLTY        IFEQ      '4'
283000200529
283100200529     C     DDTDTP        IFEQ      'TS'
283200200529     C     FC1DI         ANDNE     'C'
283300200529     C                   ADD       1             Idx
283400200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
283500200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
283600200529     C                   EVAL      DDDELFok = 'N'
283700200529     C                   GOTO      EValDelFm
283800200529     C                   END
283900200529
284000200529     C                   END
284100200529      *
284200200529     C     DDCLTY        IFEQ      '4'
284300200529
284400200529     C     DDTDTP        IFEQ      'TP'
284500200529     C     FC1DI         ANDEQ     'C'
284600200529     C                   ADD       1             Idx
284700200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
284800200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
284900200529     C                   EVAL      DDDELFok = 'N'
285000200529     C                   GOTO      EValDelFm
285100200529     C                   END
285200200529
285300200529     C                   END
285400200529      *
285500200529     C     DDCLTY        IFEQ      '5'
285600200529     C     DDTDTP        ANDEQ     'TS'
285700200529
285800200529     C     FC1DI         IFEQ      'E'
285900200529     C     FC1DI         OREQ      'C'
286000200529     C                   ADD       1             Idx
286100200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0296'
286200200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
286300200529     C                   EVAL      DDDELFok = 'N'
286400200529     C                   GOTO      EValDelFm
286500200529     C                   END
286600200529
286700200529     C                   END
286800200529      *
286900200529      **  Warning error if depot is not on investment type for security
287000200529      **  or there is no security reference code for the depot
287100200529      *
287200200529     C     DDTDTP        IFEQ      'TS'
287300200529      *
287400200529     C     FC1DI         IFEQ      'E'
287500200529     C     FC1DI         OREQ      'C'
287600200529     C*****FC1DI         OREQ      'K'                                                        CSE022
287700200529     C     FC1DI         OREQ      'X'
287800200529      *
287900200529      ** For Clearance Types 1 - 4, output warning message if there is
288000200529      ** no security reference code for the depot.
288100200529      *
288200200529     C     DDCLTY        IFNE      '5'
288300200529
288400200529     C     WDELF         IFEQ      SDC1
288500200529     C     DASR          ANDNE     *BLANKS
288600200529     C     WDELF         OREQ      SDC2
288700200529     C     DCSR          ANDNE     *BLANKS
288800200529     C     WDELF         OREQ      SDC3
288900200529     C     DDSR          ANDNE     *BLANKS
289000200529     C                   ELSE
289100200529     C                   ADD       1             WIx
289200200529     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0297'
289300200529     C                   EVAL      WFldNmXAr(WIx) = 'DDDELF'
289400200529     C                   EVAL      DDDELFok = 'W'
289500200529     C                   END
289600200529
289700200529     C                   END
289800200529      *
289900200529     C                   END
290000200529     C                   END
290100200529     C/COPY WNCPYSRC,SETSETIVM2
290200200529      *
290300200529      ** If Pay Code is '1' & Clearance Type 1 - 4, Pay To (Sales)
290400200529      ** must refer to same customer as Deliver From
290500200529      ** - not if settlement method is '00'
290600200529      ** - not if settkement method is '04'
290700200529      *
290800200529     C     DDTDTP        IFEQ      'TS'
290900200529
291000200529     C     DDPCOD        IFEQ      '1'
291100200529     C     DDPCOD        OREQ      '5'
291200200529
291300200529     C     DDCLTY        IFGE      '1'
291400200529     C     DDCLTY        ANDLE     '4'
291500200529     C     WPAYT         ANDNE     WDELF
291600200529     C     DDSMTH        ANDNE     '00'
291700200529     C     DDSMTH        ANDNE     '04'
291800200529      *
291900200529      ** This validation for the Pay To field is palced on this
292000200529      ** subroutine to gain access on the delivery details. (Err 334)
292100200529      *
292200200529     C                   ADD       1             Idx
292300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0298'
292400200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
292500200529     C                   EVAL      DDPAYTok = 'N'
292600200529     C                   GOTO      EValDelFm
292700200529     C                   END
292800200529
292900200529     C                   END
293000200529     C                   END
293100200529     C/COPY WNCPYSRC,SETSETIVM3
293200200529
293300200529      *                                                                         CSE013
293400200529      ** If CSE013 present, call Short Position Warning module                  CSE013
293500200529     C     CSE013        IFEQ      'Y'                                          CSE013
293600200529     C     DDDELFok      ANDNE     'N'
293700200529                                                                                CSE013
293800200529     C     DDTDTP        IFEQ      'TP'                                         CSE013
293900200529     C     CustClass     ANDEQ     'S'                                          CSE013
294000200529                                                                                CSE013
294100200529     C     DDTDTP        OREQ      'TP'                                         CSE013
294200200529     C     Custclass     ANDEQ     'D'                                          CSE013
294300200529                                                                                CSE013
294400200529     C                   CALLB     'SESHPOSWN'                                  CSE013
294500200529      *                                                                         CSE013
294600200529      ** INPUTS                                                                 CSE013
294700200529      *                                                                         CSE013
294800200529      ** Return Code                                                            CSE013
294900200529     C                   PARM                    ReturnCode                     CSE013
295000200529      ** Branch Code (3A)                                                       CSE013
295100200529      ** Customer number (6A)                                                   CSE013
295200200529      ** Security Shortname (10A)                                               CSE013
295300200529      ** Nominal Amount (11P 0)                                                 CSE013
295400200529      ** Deliver From (6 0)                                                     CSE013
295500200529      ** Trade/Value Date Valuation (1A)                                        CSE013
295600200529     C                   PARM                    DDBRCD                         CSE013
295700200529     C                   PARM                    CustNum                        CSE013
295800200529     C                   PARM                    DDSESN                         CSE013
295900200529     C                   PARM                    NOML                           CSE013
296000200529     C                   PARM                    DELF                           CSE013
296100200529     C                   PARM                    BVTVDV                         CSE013
296200200529      *                                                                         CSE013
296300200529      ** OUTPUT                                                                 CSE013
296400200529      *                                                                         CSE013
296500200529     C                   PARM                    ShortFlag                      CSE013
296600200529      *                                                                         CSE013
296700200529      ** Setup Warning message                                                  CSE013
296800200529     C     ShortFlag     IFEQ      '1'                                          CSE013
296900200529     C                   ADD       1             WIx                            CSE013
297000200529     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0663'                   CSE013
297100200529     C                   EVAL      WFldNmXAr(WIx) = 'DDDELF'                    CSE013
297200200529     C                   EVAL      DDDELFok = 'W'                               CSE013
297300200529     C                   ENDIF                                                  CSE013
297400200529     C                   ENDIF                                                  CSE013
297500200529      *                                                                         CSE013
297600200529      ** CSE013 End                                                             CSE013
297700200529     C                   ENDIF                                                  CSE013
297800200529                                                                                CSE013
297900200529     C     EValDelFm     ENDSR
298000200529      *****************************************************************
298100200529      /EJECT
298200200529      *****************************************************************
298300200529      *                                                               *
298400200529      * ValDelvrTo - Subroutine to perform the validation for the     *
298500200529      *              Delivery To field.                               *
298600200529      *                                                               *
298700200529      *****************************************************************
298800200529     C     ValDelvrTo    BEGSR
298900200529      *
299000200529      ** - For Complete trade (not Grey Market) ..
299100200529      ** - Mandatory if portfolio customer  or market client if purchase
299200200529      *
299300200529     C     DDINCS        IFEQ      'C'
299400200529     C     DDTDMI        ANDNE     'G'
299500200529
299600200529     C     CustClass     IFEQ      'S'
299700200529     C     CustClass     OREQ      'D'
299800200529     C     CustClass     OREQ      'M'
299900200529     C     DDTDTP        ANDEQ     'TP'
300000200529
300100200529     C     DDDELT        IFEQ      *BLANKS
300200200529     C                   ADD       1             Idx
300300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0299'
300400200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
300500200529     C                   EVAL      DDDELTok = 'N'
300600200529     C                   GOTO      EValDelTo
300700200529     C                   END
300800200529     C                   END
300900200529     C                   END
301000200529      *
301100200529      ** If entered, must be a valid Customer or Shortname
301200200529      *
301300200529     C     DDDELT        IFNE      *BLANKS
301400200529     C                   MOVEL     DDDELT        WCSNM
301500200529     C                   MOVE      *BLANKS       @RTCD
301600200529
301700200529     C                   EXSR      AOCUST
301800200529
301900200529     C     @RTCD         IFNE      *BLANKS
302000200529     C                   ADD       1             Idx
302100200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0299'
302200200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
302300200529     C                   EVAL      DDDELTok = 'N'
302400200529     C                   GOTO      EValDelTo
302500200529
302600200529     C                   ELSE
302700200529     C                   MOVE      BBCUST        WCUST
302800200529     C                   MOVE      *BLANKS       @RTCD
302900200529
303000200529     C                   EXSR      AOSECS
303100200529
303200200529     C     @RTCD         IFNE      *BLANKS
303300200529     C                   ADD       1             Idx
303400200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0299'
303500200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
303600200529     C                   EVAL      DDDELTok = 'N'
303700200529     C                   GOTO      EValDelTo
303800200529      *
303900200529      ** Portfolio Customers are not valid for DELIVER TO.
304000200529      *
304100200529     C                   ELSE
304200200529
304300200529     C     BFCLAS        IFEQ      'S'
304400200529     C     BFCLAS        OREQ      'D'
304500200529     C                   ADD       1             Idx
304600200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0300'
304700200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
304800200529     C                   EVAL      DDDELTok = 'N'
304900200529     C                   GOTO      EValDelTo
305000200529     C                   END
305100200529
305200200529     C                   END
305300200529     C                   END
305400200529
305500200529     C                   MOVE      BFCLAS        TC1DI
305600200529     C                   MOVE      BFCUST        WDELT
305700200529     C                   MOVEL     WDELT         DELT
305800200529     C                   ELSE
305900200529     C                   MOVE      *BLANK        TC1DI
306000200529     C**********         Z-ADD     *ZEROS        WDELT                                        CSD027
306100200529     C                   EVAL      WDELT = *BLANKS                                            CSD027
306200200529     C                   MOVEL     WDELT         DELT
306300200529     C                   END
306400200529      *
306500200529      ** Check combinations of clearance type/discretionary ind.
306600200529      *
306700200529     C     DDCLTY        IFEQ      '0'
306800200529     C     DDDELT        ANDNE     *BLANKS
306900200529     C                   ADD       1             Idx
307000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
307100200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
307200200529     C                   EVAL      DDDELTok = 'N'
307300200529     C                   GOTO      EValDelTo
307400200529     C                   END
307500200529      *
307600200529     C     DDCLTY        IFEQ      '1'
307700200529     C     TC1DI         ANDNE     'E'
307800200529     C                   ADD       1             Idx
307900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
308000200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
308100200529     C                   EVAL      DDDELTok = 'N'
308200200529     C                   GOTO      EValDelTo
308300200529     C                   END
308400200529      *
308500200529     C     DDCLTY        IFEQ      '2'
308600200529     C     DDTDTP        IFEQ      'TP'
308700200529     C     TC1DI         ANDNE     'E'
308800200529     C                   ADD       1             Idx
308900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
309000200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
309100200529     C                   EVAL      DDDELTok = 'N'
309200200529     C                   GOTO      EValDelTo
309300200529     C                   END
309400200529     C                   END
309500200529      *
309600200529     C     DDCLTY        IFEQ      '2'
309700200529     C     DDTDTP        ANDEQ     'TS'
309800200529
309900200529     C     TC1DI         IFEQ      'E'
310000200529     C                   ADD       1             Idx
310100200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
310200200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
310300200529     C                   EVAL      DDDELTok = 'N'
310400200529     C                   GOTO      EValDelTo
310500200529     C                   END
310600200529     C                   END
310700200529      *
310800200529     C     DDCLTY        IFEQ      '3'
310900200529     C     TC1DI         ANDNE     'C'
311000200529     C                   ADD       1             Idx
311100200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
311200200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
311300200529     C                   EVAL      DDDELTok = 'N'
311400200529     C                   GOTO      EValDelTo
311500200529     C                   END
311600200529      *
311700200529     C     DDCLTY        IFEQ      '4'
311800200529
311900200529     C     DDTDTP        IFEQ      'TP'
312000200529     C     TC1DI         ANDNE     'C'
312100200529     C                   ADD       1             Idx
312200200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
312300200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
312400200529     C                   EVAL      DDDELTok = 'N'
312500200529     C                   GOTO      EValDelTo
312600200529     C                   END
312700200529
312800200529     C                   END
312900200529      *
313000200529     C     DDCLTY        IFEQ      '4'
313100200529
313200200529     C     DDTDTP        IFEQ      'TS'
313300200529     C     TC1DI         ANDEQ     'C'
313400200529     C                   ADD       1             Idx
313500200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
313600200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
313700200529     C                   EVAL      DDDELTok = 'N'
313800200529     C                   GOTO      EValDelTo
313900200529     C                   END
314000200529
314100200529     C                   END
314200200529      *
314300200529     C     DDCLTY        IFEQ      '5'
314400200529     C     DDTDTP        ANDEQ     'TP'
314500200529
314600200529     C     TC1DI         IFEQ      'E'
314700200529     C     TC1DI         OREQ      'C'
314800200529     C                   ADD       1             Idx
314900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0301'
315000200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
315100200529     C                   EVAL      DDDELTok = 'N'
315200200529     C                   GOTO      EValDelTo
315300200529     C                   END
315400200529
315500200529     C                   END
315600200529      *
315700200529      ** Warning error if depot is not on investment type for security
315800200529      ** or there is no security reference code for the depot
315900200529      *
316000200529     C     DDTDTP        IFEQ      'TP'
316100200529      *
316200200529     C     TC1DI         IFEQ      'E'
316300200529     C     TC1DI         OREQ      'C'
316400200529     C*****TC1DI         OREQ      'K'                                                        CSE022
316500200529     C     TC1DI         OREQ      'X'
316600200529      *
316700200529      ** For Clearance Types 1 - 4, output warning message if there is
316800200529      ** no security reference code for the depot.
316900200529      *
317000200529     C     DDCLTY        IFNE      '5'
317100200529
317200200529     C     WDELT         IFEQ      SDC1
317300200529     C     DASR          ANDNE     *BLANKS
317400200529     C     WDELT         OREQ      SDC2
317500200529     C     DCSR          ANDNE     *BLANKS
317600200529     C     WDELT         OREQ      SDC3
317700200529     C     DDSR          ANDNE     *BLANKS
317800200529     C                   ELSE
317900200529     C                   ADD       1             WIx
318000200529     C                   EVAL      WMsgIDXAr(WIx) = 'MMA0302'
318100200529     C                   EVAL      WFldNmXAr(WIx) = 'DDDELT'
318200200529     C                   EVAL      DDDELTok = 'W'
318300200529     C                   END
318400200529
318500200529     C                   END
318600200529      *
318700200529     C                   END
318800200529     C                   END
318900200529      *
319000200529      ** If receiving from outside Euroclear/Cedel to Euroclear Pay To
319100200529      ** is mandatory
319200200529      *
319300200529     C     DDTDTP        IFEQ      'TP'
319400200529     C     TC1DI         ANDEQ     'E'
319500200529     C     FC1DI         ANDNE     'E'
319600200529     C     FC1DI         ANDNE     'C'
319700200529     C     DDSMTH        ANDEQ     '01'
319800200529     C     DDPCOD        ANDNE     '2'
319900200529     C     DDPCOD        ANDNE     '3'
320000200529     C     DDPCOD        ANDNE     '4'
320100200529      *
320200200529     C     DDPAYT        IFEQ      *BLANKS
320300200529     C                   ADD       1             Idx
320400200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0303'
320500200529     C                   EVAL      FldNamXAr (Idx) = 'DDPAYT'
320600200529     C                   EVAL      DDPAYTok = 'N'
320700200529     C                   GOTO      EValDelTo
320800200529     C                   END
320900200529
321000200529     C                   END
321100200529      *
321200200529      ** If Pay Code is '1' & Clearance Type 1 - 4, Pay From (Purch)
321300200529      ** must refer to same customer as Deliver To
321400200529      **  - not if settlement method is 00
321500200529      **  - not if settlement method is 04
321600200529      *
321700200529     C     DDTDTP        IFEQ      'TP'
321800200529
321900200529     C/COPY WNCPYSRC,SETSETIVK3
322000200529     ** If CSE099 is switched on, ...                                                         162270
322100200529     ** For TP trades with a pay code of 1, clearance type of 3 or 4,                         162270
322200200529     ** a 'pay from' customer different to the 'delivered to' customer                        162270
322300200529     ** will be allowed to be inserted.                                                       162270
322400200529     C     WPYFM         IFNE      WDELT                                                      162270
322500200529     C     DDPCOD        ANDEQ     '1'                                                        162270
322600200529     C     DDCLTY        ANDEQ     '3'                                                        162270
322700200529     C     CSE099        ANDEQ     'Y'                                                        162270
322800200529     C     WPYFM         ORNE      WDELT                                                      162270
322900200529     C     DDPCOD        ANDEQ     '1'                                                        162270
323000200529     C     DDCLTY        ANDEQ     '4'                                                        162270
323100200529     C     CSE099        ANDEQ     'Y'                                                        162270
323200200529     C                   ELSE                                                                 162270
323300200529      *                                                                                       162270
323400200529     C     DDPCOD        IFEQ      '1'
323500200529     C     DDPCOD        OREQ      '5'
323600200529
323700200529     C     DDCLTY        IFGE      '1'
323800200529     C     DDCLTY        ANDLE     '4'
323900200529     C     WPYFM         ANDNE     WDELT
324000200529     C     DDSMTH        ANDNE     '00'
324100200529     C     DDSMTH        ANDNE     '04'
324200200529     C                   ADD       1             Idx
324300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0304'
324400200529     C                   EVAL      FldNamXAr (Idx) = 'DDPYFM'
324500200529     C                   EVAL      DDPYFMok = 'N'
324600200529     C                   GOTO      EValDelTo
324700200529     C                   END
324800200529
324900200529     C                   END
325000200529     C/COPY WNCPYSRC,SETSETIVK5
325100200529     C                   END                                                                  162270
325200200529     C                   END
325300200529     C/COPY WNCPYSRC,SETSETIVK4
325400200529
325500200529     C     EValDelTo     ENDSR
325600200529      *****************************************************************
325700200529      /EJECT
325800200529      *****************************************************************
325900200529      *                                                               *
326000200529      * ValDTDF_P - Subroutine to perform the validation for the      *
326100200529      *             Delivery To and Deliver From fields - Purchases   *
326200200529      *                                                               *
326300200529      *****************************************************************
326400200529     C     ValDTDF_P     BEGSR
326500200529      *
326600200529      ** Reset Error indicator
326700200529      *
326800200529     C                   MOVE      '0'           ErrInd
326900200529      *
327000200529     C     TC1DI         IFEQ      'E'
327100200529     C     FC1DI         ANDEQ     'E'
327200200529
327300200529     C     CustPNp1      IFNE      'P '
327400200529
327500200529     C     ErrInd        IFNE      '1'
327600200529     C                   MOVE      '1'           ErrInd
327700200529      ** Deliver To
327800200529     C                   ADD       1             Idx
327900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0305'
328000200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
328100200529     C                   EVAL      DDDELTok = 'N'
328200200529      ** Deliver From
328300200529     C                   ADD       1             Idx
328400200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0305'
328500200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
328600200529     C                   EVAL      DDDELFok = 'N'
328700200529     C                   END
328800200529
328900200529     C                   END
329000200529     C                   END
329100200529      *
329200200529     C     CustPNp1      IFNE      'P '
329300200529     C     CustPNp1      ANDNE     'NP'
329400200529
329500200529     C     TC1DI         IFEQ      'E'
329600200529     C     FC1DI         ANDNE     'C'
329700200529
329800200529     C     ErrInd        IFNE      '1'
329900200529     C                   MOVE      '1'           ErrInd
330000200529
330100200529      ** Deliver To
330200200529     C                   ADD       1             Idx
330300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0306'
330400200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
330500200529     C                   EVAL      DDDELTok = 'N'
330600200529
330700200529      ** Deliver From
330800200529     C                   ADD       1             Idx
330900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0306'
331000200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
331100200529     C                   EVAL      DDDELFok = 'N'
331200200529     C                   END
331300200529
331400200529     C                   END
331500200529
331600200529     C                   END
331700200529      *
331800200529     C     DDCLTY        IFEQ      '5'
331900200529
332000200529     C     FC1DI         IFEQ      'C'
332100200529     C     CustPNp2      ANDNE     'P '
332200200529     C     FC1DI         OREQ      'E'
332300200529     C     CustPNp1      ANDNE     'P '
332400200529
332500200529     C     ErrInd        IFNE      '1'
332600200529     C                   MOVE      '1'           ErrInd
332700200529      ** Deliver From
332800200529     C                   ADD       1             Idx
332900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0307'
333000200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
333100200529     C                   EVAL      DDDELFok = 'N'
333200200529     C                   END
333300200529
333400200529     C                   END
333500200529     C                   END
333600200529      *
333700200529     C     CustPNp2      IFNE      'P '
333800200529
333900200529     C     FC1DI         IFEQ      'C'
334000200529
334100200529     C     ErrInd        IFNE      '1'
334200200529     C                   MOVE      '1'           ErrInd
334300200529      ** Deliver To
334400200529     C                   ADD       1             Idx
334500200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0308'
334600200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
334700200529     C                   EVAL      DDDELTok = 'N'
334800200529
334900200529      ** Deliver From
335000200529     C                   ADD       1             Idx
335100200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0308'
335200200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
335300200529     C                   EVAL      DDDELFok = 'N'
335400200529     C                   END
335500200529
335600200529     C                   END
335700200529     C                   END
335800200529      *
335900200529     C     CustPNp1      IFNE      'P '
336000200529
336100200529     C     FC1DI         IFEQ      'E'
336200200529     C     TC1DI         ANDEQ     'C'
336300200529
336400200529     C     ErrInd        IFNE      '1'
336500200529     C                   MOVE      '1'           ErrInd
336600200529
336700200529      ** Deliver To
336800200529     C                   ADD       1             Idx
336900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0309'
337000200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
337100200529     C                   EVAL      DDDELTok = 'N'
337200200529
337300200529      ** Deliver From
337400200529     C                   ADD       1             Idx
337500200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0309'
337600200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
337700200529     C                   EVAL      DDDELFok = 'N'
337800200529     C                   END
337900200529
338000200529     C                   END
338100200529     C                   END
338200200529
338300200529     C                   ENDSR
338400200529      *****************************************************************
338500200529      /EJECT
338600200529      *****************************************************************
338700200529      *                                                               *
338800200529      * ValDTDF_S - Subroutine to perform the validation for the      *
338900200529      *             Delivery To and Deliver From fields - Sales       *
339000200529      *                                                               *
339100200529      *****************************************************************
339200200529     C     ValDTDF_S     BEGSR
339300200529      *
339400200529      ** Reset Error Indicator
339500200529      *
339600200529     C                   MOVE      '0'           ErrInd
339700200529      *
339800200529     C     TC1DI         IFEQ      'E'
339900200529     C     FC1DI         ANDEQ     'E'
340000200529
340100200529     C     CustPNp1      IFNE      'P '
340200200529
340300200529     C     ErrInd        IFNE      '1'
340400200529     C                   MOVE      '1'           ErrInd
340500200529
340600200529      ** Deliver To
340700200529     C                   ADD       1             Idx
340800200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0305'
340900200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
341000200529     C                   EVAL      DDDELTok = 'N'
341100200529      ** Deliver From
341200200529     C                   ADD       1             Idx
341300200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0305'
341400200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
341500200529     C                   EVAL      DDDELFok = 'N'
341600200529
341700200529     C                   END
341800200529
341900200529     C                   END
342000200529     C                   END
342100200529      *
342200200529     C     CustPNp1      IFNE      'P '
342300200529     C     CustPNp1      ANDNE     'NP'
342400200529
342500200529     C     FC1DI         IFEQ      'E'
342600200529     C     TC1DI         ANDNE     'C'
342700200529
342800200529     C     ErrInd        IFNE      '1'
342900200529     C                   MOVE      '1'           ErrInd
343000200529      ** Deliver To
343100200529     C                   ADD       1             Idx
343200200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0310'
343300200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
343400200529     C                   EVAL      DDDELTok = 'N'
343500200529      ** Deliver From
343600200529     C                   ADD       1             Idx
343700200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0310'
343800200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
343900200529     C                   EVAL      DDDELFok = 'N'
344000200529
344100200529     C                   END
344200200529
344300200529     C                   END
344400200529     C                   END
344500200529      *
344600200529     C     CustPNp2      IFNE      'P '
344700200529
344800200529     C     TC1DI         IFEQ      'C'
344900200529
345000200529     C     ErrInd        IFNE      '1'
345100200529     C                   MOVE      '1'           ErrInd
345200200529      ** Deliver To
345300200529     C                   ADD       1             Idx
345400200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0311'
345500200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
345600200529     C                   EVAL      DDDELTok = 'N'
345700200529      ** Deliver From
345800200529     C                   ADD       1             Idx
345900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0311'
346000200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
346100200529     C                   EVAL      DDDELFok = 'N'
346200200529     C                   END
346300200529
346400200529     C                   END
346500200529     C                   END
346600200529      *
346700200529     C     CustPNp1      IFNE      'P '
346800200529
346900200529     C     TC1DI         IFEQ      'E'
347000200529     C     FC1DI         ANDEQ     'C'
347100200529
347200200529     C     ErrInd        IFNE      '1'
347300200529     C                   MOVE      '1'           ErrInd
347400200529      ** Deliver To
347500200529     C                   ADD       1             Idx
347600200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0312'
347700200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
347800200529     C                   EVAL      DDDELTok = 'N'
347900200529      ** Deliver From
348000200529     C                   ADD       1             Idx
348100200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0312'
348200200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELF'
348300200529     C                   EVAL      DDDELFok = 'N'
348400200529     C                   END
348500200529
348600200529     C                   END
348700200529     C                   END
348800200529      *
348900200529     C     DDCLTY        IFEQ      '5'
349000200529
349100200529     C     TC1DI         IFEQ      'C'
349200200529     C     CustPNp2      ANDNE     'P '
349300200529     C     TC1DI         OREQ      'E'
349400200529     C     CustPNp1      ANDNE     'P '
349500200529
349600200529     C     ErrInd        IFNE      '1'
349700200529     C                   MOVE      '1'           ErrInd
349800200529      ** Deliver To
349900200529     C                   ADD       1             Idx
350000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0313'
350100200529     C                   EVAL      FldNamXAr (Idx) = 'DDDELT'
350200200529     C                   EVAL      DDDELTok = 'N'
350300200529     C                   END
350400200529
350500200529     C                   END
350600200529     C                   END
350700200529      *
350800200529     C                   ENDSR
350900200529      *****************************************************************
351000200529      */EJECT**********************************************************                       CSE022
351100200529      *****************************************************************                       CSE022
351200200529      *****************************************************************                       CSE022
351300200529      **ValDTDF_K*-*Subroutine*to*perform*the*validation*for*the*******                       CSE022
351400200529      **************Delivery*To*and*Deliver*From*fields*-*KassenVerein*                       CSE022
351500200529      *****************************************************************                       CSE022
351600200529      *****************************************************************                       CSE022
351700200529     C*****ValDTDF_K     BEGSR                                                                CSE022
351800200529      *****************************************************************                       CSE022
351900200529     C*****TC1DI         IFEQ      'K'                                                        CSE022
352000200529      *****************************************************************                       CSE022
352100200529     C*****SetCcySWCY    IFNE      'DEM'                                                      CSE022
352200200529      ***Deliver*To****************************************************                       CSE022
352300200529     C**********         ADD       1             Idx                                          CSE022
352400200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0315'                                  CSE022
352500200529     C**********         EVAL      FldNamXAr (Idx) = 'DDDELT'                                 CSE022
352600200529     C**********         EVAL      DDDELTok = 'N'                                             CSE022
352700200529     C**********         END                                                                  CSE022
352800200529      *****************************************************************                       CSE022
352900200529     C**********         END                                                                  CSE022
353000200529      *****************************************************************                       CSE022
353100200529     C*****FC1DI         IFEQ      'K'                                                        CSE022
353200200529      *****************************************************************                       CSE022
353300200529     C*****SetCcySWCY    IFNE      'DEM'                                                      CSE022
353400200529      ***Deliver*From**************************************************                       CSE022
353500200529     C**********         ADD       1             Idx                                          CSE022
353600200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0314'                                  CSE022
353700200529     C**********         EVAL      FldNamXAr (Idx) = 'DDDELF'                                 CSE022
353800200529     C**********         EVAL      DDDELFok = 'N'                                             CSE022
353900200529     C**********         END                                                                  CSE022
354000200529      *****************************************************************                       CSE022
354100200529     C**********         END                                                                  CSE022
354200200529      *****************************************************************                       CSE022
354300200529     C**********         ENDSR                                                                CSE022
354400200529      *****************************************************************                       CSE022
354500200529      /EJECT
354600200529      *****************************************************************
354700200529      *                                                               *
354800200529      * ValFrAcDlT - Subroutine to perform the validation for the     *
354900200529      *              For Account of (Delivery To) field.              *
355000200529      *                                                               *
355100200529      *****************************************************************
355200200529     C     ValFrAcDlT    BEGSR
355300200529      *
355400200529      ** If entered, must be a valid Customer or Shortname
355500200529      *
355600200529     C     DDDTFA        IFNE      *BLANKS
355700200529
355800200529     C                   MOVEL     *BLANKS       WCSNM
355900200529     C                   MOVEL     DDDTFA        WCSNM
356000200529     C                   MOVE      *BLANKS       @RTCD
356100200529
356200200529     C                   EXSR      AOCUST
356300200529
356400200529     C     @RTCD         IFNE      *BLANKS
356500200529
356600200529     C                   ADD       1             Idx
356700200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0316'
356800200529     C                   EVAL      FldNamXAr (Idx) = 'DDDTFA'
356900200529     C                   EVAL      DDDTFAok = 'N'
357000200529
357100200529     C                   ELSE
357200200529
357300200529     C                   MOVE      BBCUST        WCUST
357400200529     C                   MOVE      *BLANKS       @RTCD
357500200529
357600200529     C                   EXSR      AOSECS
357700200529
357800200529     C     @RTCD         IFEQ      *BLANKS
357900200529     C                   MOVEL     BFCUST        DTFA
358000200529     C                   MOVE      *BLANKS       DDDTFA
358100200529     C                   MOVEL     BFCUST        DDDTFA
358200200529     C                   ELSE
358300200529     C                   ADD       1             Idx
358400200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0316'
358500200529     C                   EVAL      FldNamXAr (Idx) = 'DDDTFA'
358600200529     C                   EVAL      DDDTFAok = 'N'
358700200529     C                   END
358800200529
358900200529     C                   END
359000200529     C                   END
359100200529      *
359200200529      ** EUCLID Changes
359300200529      *
359400200529     C     DDTDTP        IFEQ      'TP'
359500200529     C     DDDTFA        ANDNE     *BLANKS
359600200529     C                   ADD       1             Idx
359700200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0317'
359800200529     C                   EVAL      FldNamXAr (Idx) = 'DDDTFA'
359900200529     C                   EVAL      DDDTFAok = 'N'
360000200529     C                   END
360100200529      *
360200200529     C*****DDTDTP        IFEQ      'TS'                                                       225161
360300200529     C*****DDDTFA        ANDNE     *BLANKS                                                    225161
360400200529      **********                                                                              225161
360500200529     C*****DDCLTY        IFEQ      '0'                                                        225161
360600200529     C*****DDDTFA        ANDNE     *BLANKS                                                    225161
360700200529     C**********         ADD       1             Idx                                          225161
360800200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0318'                                  225161
360900200529     C**********         EVAL      FldNamXAr (Idx) = 'DDDTFA'                                 225161
361000200529     C**********         EVAL      DDDTFAok = 'N'                                             225161
361100200529     C**********         END                                                                  225161
361200200529      **********                                                                              225161
361300200529     C*****DDCLTY        IFEQ      '1'                                                        225161
361400200529     C*****BFPNP1        ANDNE     'P '                                                       225161
361500200529     C**********         ADD       1             Idx                                          225161
361600200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0318'                                  225161
361700200529     C**********         EVAL      FldNamXAr (Idx) = 'DDDTFA'                                 225161
361800200529     C**********         EVAL      DDDTFAok = 'N'                                             225161
361900200529     C**********         END                                                                  225161
362000200529      **********                                                                              225161
362100200529     C*****DDCLTY        IFEQ      '2'                                                        225161
362200200529      **********                                                                              225161
362300200529     C*****BFPNP1        IFNE      'P '                                                       225161
362400200529     C*****BFPNP1        ANDNE     'NP'                                                       225161
362500200529     C*****TC1DI         ANDNE     'C'                                                        225161
362600200529     C**********         ADD       1             Idx                                          225161
362700200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0318'                                  225161
362800200529     C**********         EVAL      FldNamXAr (Idx) = 'DDDTFA'                                 225161
362900200529     C**********         EVAL      DDDTFAok = 'N'                                             225161
363000200529     C**********         END                                                                  225161
363100200529      **********                                                                              225161
363200200529     C**********         END                                                                  225161
363300200529      **********                                                                              225161
363400200529     C*****DDCLTY        IFEQ      '3'                                                        225161
363500200529     C*****BFPNP2        ANDNE     'P '                                                       225161
363600200529     C**********         ADD       1             Idx                                          225161
363700200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0318'                                  225161
363800200529     C**********         EVAL      FldNamXAr (Idx) = 'DDDTFA'                                 225161
363900200529     C**********         EVAL      DDDTFAok = 'N'                                             225161
364000200529     C**********         END                                                                  225161
364100200529      **********                                                                              225161
364200200529     C*****DDCLTY        IFEQ      '4'                                                        225161
364300200529     C*****TC1DI         ANDEQ     'E'                                                        225161
364400200529      **********                                                                              225161
364500200529     C*****BFPNP1        IFNE      'P '                                                       225161
364600200529     C**********         ADD       1             Idx                                          225161
364700200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0318'                                  225161
364800200529     C**********         EVAL      FldNamXAr (Idx) = 'DDDTFA'                                 225161
364900200529     C**********         EVAL      DDDTFAok = 'N'                                             225161
365000200529     C**********         END                                                                  225161
365100200529      **********                                                                              225161
365200200529     C**********         END                                                                  225161
365300200529      **********                                                                              225161
365400200529     C*****DDCLTY        IFEQ      '5'                                                        225161
365500200529      **********                                                                              225161
365600200529     C*****TC1DI         IFEQ      'C'                                                        225161
365700200529     C*****BFPNP2        ANDNE     'P '                                                       225161
365800200529     C*****TC1DI         OREQ      'E'                                                        225161
365900200529     C*****BFPNP1        ANDNE     'P '                                                       225161
366000200529     C**********         ADD       1             Idx                                          225161
366100200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0318'                                  225161
366200200529     C**********         EVAL      FldNamXAr (Idx) = 'DDDTFA'                                 225161
366300200529     C**********         EVAL      DDDTFAok = 'N'                                             225161
366400200529     C**********         END                                                                  225161
366500200529      **********                                                                              225161
366600200529     C**********         END                                                                  225161
366700200529      **********                                                                              225161
366800200529     C**********         END                                                                  225161
366900200529
367000200529     C                   ENDSR
367100200529      *****************************************************************
367200200529      /EJECT
367300200529      *****************************************************************
367400200529      *                                                               *
367500200529      * ValFrAcDF - Subroutine to perform the validation for the      *
367600200529      *             For Account of (Deliver From).                    *
367700200529      *                                                               *
367800200529      *****************************************************************
367900200529     C     ValFrAcDF     BEGSR
368000200529      *
368100200529      ** If entered, must be a valid Customer or Shortname
368200200529      *
368300200529     C     DDDFFA        IFNE      *BLANKS
368400200529     C                   MOVEL     *BLANKS       WCSNM
368500200529     C                   MOVEL     DDDFFA        WCSNM
368600200529     C                   MOVE      *BLANKS       @RTCD
368700200529
368800200529     C                   EXSR      AOCUST
368900200529
369000200529     C     @RTCD         IFNE      *BLANKS
369100200529     C                   ADD       1             Idx
369200200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0319'
369300200529     C                   EVAL      FldNamXAr (Idx) = 'DDDFFA'
369400200529     C                   EVAL      DDDFFAok = 'N'
369500200529     C                   ELSE
369600200529     C                   MOVE      BBCUST        WCUST
369700200529     C                   MOVE      *BLANKS       @RTCD
369800200529
369900200529     C                   EXSR      AOSECS
370000200529
370100200529     C     @RTCD         IFEQ      *BLANKS
370200200529     C                   MOVEL     BFCUST        DFFA
370300200529     C                   MOVEL     *BLANK        DDDFFA
370400200529     C                   MOVEL     BFCUST        DDDFFA
370500200529     C                   ELSE
370600200529     C                   ADD       1             Idx
370700200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0319'
370800200529     C                   EVAL      FldNamXAr (Idx) = 'DDDFFA'
370900200529     C                   EVAL      DDDFFAok = 'N'
371000200529     C                   END
371100200529
371200200529     C                   END
371300200529     C                   END
371400200529      *
371500200529      ** EUCLID Changes
371600200529      *
371700200529     C     DDTDTP        IFEQ      'TS'
371800200529     C     DDDFFA        ANDNE     *BLANKS
371900200529     C                   ADD       1             Idx
372000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0320'
372100200529     C                   EVAL      FldNamXAr (Idx) = 'DDDFFA'
372200200529     C                   EVAL      DDDFFAok = 'N'
372300200529     C                   END
372400200529     C*
372500200529     C*****DDTDTP        IFEQ      'TP'                                                       225161
372600200529     C*****DDDFFA        ANDNE     *BLANKS                                                    225161
372700200529     C**********                                                                              225161
372800200529     C*****DDCLTY        IFEQ      '0'                                                        225161
372900200529     C*****DDDFFA        ANDNE     *BLANKS                                                    225161
373000200529     C**********         ADD       1             Idx                                          225161
373100200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0321'                                  225161
373200200529     C**********         EVAL      FldNamXAr (Idx) = 'DDDFFA'                                 225161
373300200529     C**********         EVAL      DDDFFAok = 'N'                                             225161
373400200529     C**********         END                                                                  225161
373500200529     C**********                                                                              225161
373600200529     C*****DDCLTY        IFEQ      '1'                                                        225161
373700200529     C*****BFPNP1        ANDNE     'P '                                                       225161
373800200529     C**********         ADD       1             Idx                                          225161
373900200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0321'                                  225161
374000200529     C**********         EVAL      FldNamXAr (Idx) = 'DDDFFA'                                 225161
374100200529     C**********         EVAL      DDDFFAok = 'N'                                             225161
374200200529     C**********         END                                                                  225161
374300200529     C**********                                                                              225161
374400200529     C*****DDCLTY        IFEQ      '2'                                                        225161
374500200529      **********                                                                              225161
374600200529     C*****BFPNP1        IFNE      'P '                                                       225161
374700200529     C*****BFPNP1        ANDNE     'NP'                                                       225161
374800200529     C*****FC1DI         ANDNE     'C'                                                        225161
374900200529     C**********         ADD       1             Idx                                          225161
375000200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0321'                                  225161
375100200529     C**********         EVAL      FldNamXAr (Idx) = 'DDDFFA'                                 225161
375200200529     C**********         EVAL      DDDFFAok = 'N'                                             225161
375300200529     C**********         END                                                                  225161
375400200529      **********                                                                              225161
375500200529     C**********         END                                                                  225161
375600200529     C**********                                                                              225161
375700200529     C*****DDCLTY        IFEQ      '3'                                                        225161
375800200529     C*****BFPNP2        ANDNE     'P '                                                       225161
375900200529     C**********         ADD       1             Idx                                          225161
376000200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0321'                                  225161
376100200529     C**********         EVAL      FldNamXAr (Idx) = 'DDDFFA'                                 225161
376200200529     C**********         EVAL      DDDFFAok = 'N'                                             225161
376300200529     C**********         END                                                                  225161
376400200529     C**********                                                                              225161
376500200529     C*****DDCLTY        IFEQ      '4'                                                        225161
376600200529     C*****FC1DI         ANDEQ     'E'                                                        225161
376700200529      **********                                                                              225161
376800200529     C*****BFPNP1        IFNE      'P '                                                       225161
376900200529     C**********         ADD       1             Idx                                          225161
377000200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0321'                                  225161
377100200529     C**********         EVAL      FldNamXAr (Idx) = 'DDDFFA'                                 225161
377200200529     C**********         EVAL      DDDFFAok = 'N'                                             225161
377300200529     C**********         END                                                                  225161
377400200529      **********                                                                              225161
377500200529     C**********         END                                                                  225161
377600200529     C**********                                                                              225161
377700200529     C*****DDCLTY        IFEQ      '5'                                                        225161
377800200529      **********                                                                              225161
377900200529     C*****FC1DI         IFEQ      'C'                                                        225161
378000200529     C*****BFPNP2        ANDNE     'P '                                                       225161
378100200529     C*****FC1DI         OREQ      'E'                                                        225161
378200200529     C*****BFPNP1        ANDNE     'P '                                                       225161
378300200529     C**********         ADD       1             Idx                                          225161
378400200529     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0321'                                  225161
378500200529     C**********         EVAL      FldNamXAr (Idx) = 'DDDFFA'                                 225161
378600200529     C**********         EVAL      DDDFFAok = 'N'                                             225161
378700200529     C**********         END                                                                  225161
378800200529      **********                                                                              225161
378900200529     C**********         END                                                                  225161
379000200529     C**********                                                                              225161
379100200529     C**********         END                                                                  225161
379200200529
379300200529     C                   ENDSR
379400200529      *****************************************************************
379500200529      /EJECT
379600200529      *****************************************************************
379700200529      *                                                               *
379800200529      * ValSplInst - Subroutine to perform the validation for the     *
379900200529      *              Special Instruction field.                       *
380000200529      *                                                               *
380100200529      *****************************************************************
380200200529     C     ValSplInst    BEGSR
380300200529      *
380400200529      ** Validate the format of the special instruction field
380500200529      ** for an electronic pay settlement method
380600200529      *
380700200529     C     DDTDSI        IFNE      *BLANKS
380800200529
380900200529     C     DDSMTH        IFEQ      '01'
381000200529     C     DDSMTH        OREQ      '08'
381100200529     C                   MOVEA     *BLANKS       SIL
381200200529     C                   MOVEA     DDTDSI        SIL
381300200529
381400200529     C                   EXSR      SEPTVS
381500200529
381600200529     C     CUL           IFEQ      'E'
381700200529     C                   ADD       1             Idx
381800200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0652'
381900200529     C                   EVAL      FldNamXAr (Idx) = 'DDTDSI'
382000200529     C                   EVAL      DDTDSIok = 'N'
382100200529     C                   END
382200200529
382300200529     C     CUL           IFEQ      'X'
382400200529     C                   ADD       1             Idx
382500200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0653'
382600200529     C                   EVAL      FldNamXAr (Idx) = 'DDTDSI'
382700200529     C                   EVAL      DDTDSIok = 'N'
382800200529     C                   ENDIF
382900200529
383000200529     C                   END
383100200529     C                   END
383200200529
383300200529      * Update trade field
383400200529
383500200529     C                   MOVEL     DDTDSI        TDSI
383600200529
383700200529     C                   ENDSR
383800200529      *****************************************************************
383900200529      /EJECT
384000200529      *****************************************************************
384100200529      *                                                               *
384200200529      * SEPTVS -  Subroutine to perform the primary validation for    *
384300200529      *           the special instruction field.                      *
384400200529      *                                                               *
384500200529      *****************************************************************
384600200529     C     SEPTVS        BEGSR
384700200529
384800200529      *
384900200529     C                   Z-ADD     1             IdL
385000200529     C                   MOVE      *BLANK        CUL
385100200529     C                   MOVE      'F'           SSF
385200200529
385300200529     C                   SETOFF                                       88
385400200529      *
385500200529      ** First position must be a '/'
385600200529      *
385700200529     C     SIL(IdL)      IFNE      '/'
385800200529     C                   MOVE      'E'           CUL
385900200529     C                   END
386000200529      *
386100200529     C                   Z-ADD     2             IdL
386200200529      *
386300200529      ** The first special instruction line cannot have '/'
386400200529      ** in position 2
386500200529      *
386600200529     C     SIL(IdL)      IFEQ      '/'
386700200529     C                   MOVE      'E'           CUL
386800200529     C                   END
386900200529      *
387000200529      ** Check the line for '8a/', where 8a represents
387100200529      ** up to eight upper case alphabetic charaters
387200200529      ** ... alphanumeric characters, if CSW201 is installed                                  CSW201
387300200529      *
387400200529     C     SSF           DOUEQ     'T'
387500200529     C     IdL           ORGT      10
387600200529     C     CUL           OREQ      'E'
387700200529      *
387800200529     C     CSW201        IFEQ      'Y'                                                        CSW201
387900200529     C     SIL(IdL)      LOOKUP    UPB                                    88                  CSW201
388000200529     C                   ELSE                                                                 CSW201
388100200529     C     SIL(IdL)      LOOKUP    UPA                                    88
388200200529     C                   ENDIF                                                                CSW201
388300200529      *
388400200529     C     *IN88         IFNE      '1'
388500200529     C                   MOVE      'E'           CUL
388600200529     C                   END
388700200529      *
388800200529     C     SIL(IdL)      IFEQ      '/'
388900200529     C                   MOVE      'T'           SSF
389000200529     C                   END
389100200529      *
389200200529     C                   ADD       1             IdL
389300200529      *
389400200529     C                   END
389500200529      *
389600200529      ** Invalid if a second slash is not found
389700200529      ** within the first ten characters of the
389800200529      ** field being checked
389900200529      *
390000200529     C     SSF           IFEQ      'F'
390100200529     C                   MOVE      'E'           CUL
390200200529     C                   END
390300200529      *
390400200529      ** Test the rest of the line for ISO format characters
390500200529      *
390600200529     C     IdL           DOUGT     35
390700200529     C     CUL           OREQ      'E'
390800200529      *
390900200529     C     SIL(IdL)      LOOKUP    SWCH                                   88
391000200529      *
391100200529     C     *IN88         IFEQ      '0'
391200200529     C                   MOVE      'E'           CUL
391300200529     C                   END
391400200529      *
391500200529     C                   ADD       1             IdL
391600200529      *
391700200529     C                   END
391800200529      *
391900200529      ** Check for "/RCB/"
392000200529      *
392100200529     C                   MOVEL     *BLANKS       USRCB
392200200529     C                   MOVEA     SIL(1)        USRCB
392300200529
392400200529     C     USRCB         IFEQ      '/RCB/'
392500200529     C                   MOVE      'X'           CUL
392600200529     C                   ENDIF
392700200529
392800200529     C                   ENDSR
392900200529      *****************************************************************
393000200529      /EJECT
393100200529      *****************************************************************
393200200529      *                                                               *
393300200529      * ValClearTp - Subroutine to perform the validation for the     *
393400200529      *              Clearance Type field.                            *
393500200529      *                                                               *
393600200529      *****************************************************************
393700200529     C     ValClearTp    BEGSR
393800200529      *
393900200529      ** Clearance type
394000200529      ** must be in the range 0 - 5
394100200529      *
394200200529      ** Only if it is not a book transfer                                                   BUG2582
394300200529     C     CustClass     IFNE      'I'                                                       BUG2582
394400200529                                                                                             BUG2582
394500200529     C     DDCLTY        IFLT      '0'
394600200529     C     DDCLTY        ORGT      '5'
394700200529     C                   ADD       1             Idx
394800200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0654'
394900200529     C*******            EVAL      FldNamXAr (Idx) = 'DDCLTY'                   175718
395000200529     C                   EVAL      FldNamXAr (Idx) = 'DDCLTY2'                  175718
395100200529     C                   EVAL      DDCLTYok = 'N'
395200200529     C                   END
395300200529     C                   ENDIF                                                               BUG2582
395400200529      *
395500200529      **  .. if Market indicator is 'G', must be '0'
395600200529      *
395700200529     C     DDTDMI        IFEQ      'G'
395800200529     C     DDCLTY        ANDNE     '0'
395900200529     C                   ADD       1             Idx
396000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0654'
396100200529     C*******            EVAL      FldNamXAr (Idx) = 'DDCLTY'                   175718
396200200529     C                   EVAL      FldNamXAr (Idx) = 'DDCLTY2'                  175718
396300200529     C                   EVAL      DDCLTYok = 'N'
396400200529     C                   END
396500200529      *
396600200529      ** .. if Market indicator is not 'G' must not be '0' for a
396700200529      **    complete trade
396800200529      *
396900200529     C     DDTDMI        IFNE      'G'
397000200529     C     DDINCS        ANDEQ     'C'
397100200529     C     DDCLTY        ANDEQ     '0'
397200200529     C     CustClass     ANDNE     'I'                                                       BUG2582
397300200529     C                   ADD       1             Idx
397400200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0655'
397500200529     C*******            EVAL      FldNamXAr (Idx) = 'DDCLTY'                   175718
397600200529     C                   EVAL      FldNamXAr (Idx) = 'DDCLTY2'                  175718
397700200529     C                   EVAL      DDCLTYok = 'N'
397800200529     C                   END
397900200529      *
398000200529      * Update trade field
398100200529      *
398200200529     C                   MOVE      DDCLTY        CLTY
398300200529      *
398400200529     C                   ENDSR
398500200529      *****************************************************************
398600200529      /EJECT
398700200529      *****************************************************************
398800200529      *                                                               *
398900200529      * ValICcy72 -  Validate 'In' Currency in Field 72               *
399000200529      *                                                               *
399100200529      *****************************************************************
399200200529     C     ValICcy72     BEGSR
399300200529      *
399400200529      * It must be a valid currency
399500200529      *
399600200529     C                   MOVE      DDICCY        @AJCD
399700200529     C                   EXSR      AOCURR
399800200529     C     @RTCD         IFNE      *BLANKS
399900200529     C                   ADD       1             Idx
400000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0664'
400100200529     C                   EVAL      FldNamXAr (Idx) = 'DDICCY'
400200200529     C                   EVAL      DDICCYok = 'N'
400300200529     C                   ENDIF
400400200529      *
400500200529      * It must be an 'in' currency
400600200529      *
400700200529     C     A6INCY        IFNE      'Y'
400800200529     C                   ADD       1             Idx
400900200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0665'
401000200529     C                   EVAL      FldNamXAr (Idx) = 'DDICCY'
401100200529     C                   EVAL      DDICCYok = 'N'
401200200529     C                   ENDIF
401300200529      *
401400200529      * It must be equal to nominal currency or nominal currency
401500200529      * must equal EURO currency.
401600200529      *
401700200529     C     DDICCY        IFNE      NMCY
401800200529     C     NMCY          ANDNE     BKEURO
401900200529     C                   ADD       1             Idx
402000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0666'
402100200529     C                   EVAL      FldNamXAr (Idx) = 'DDICCY'
402200200529     C                   EVAL      DDICCYok = 'N'
402300200529     C                   ENDIF
402400200529      *
402500200529      * Settlement method must be 01 or 08.
402600200529      *
402700200529     C     DDSMTH        IFNE      '01'
402800200529     C     DDSMTH        ANDNE     '08'
402900200529     C                   ADD       1             Idx
403000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0667'
403100200529     C                   EVAL      FldNamXAr (Idx) = 'DDICCY'
403200200529     C                   EVAL      DDICCYok = 'N'
403300200529     C                   ENDIF
403400200529      *
403500200529      * Update trade field
403600200529      *
403700200529     C                   MOVE      DDICCY        ICCY
403800200529
403900200529     C                   ENDSR
404000200529      *****************************************************************
404100200529      /EJECT
404200200529      *****************************************************************
404300200529      *                                                               *
404400200529      * ValProfitC - Subroutine to perform the validation for the     *
404500200529      *              Profit Centre field.                             *
404600200529      *                                                               *
404700200529      *****************************************************************
404800200529     C     ValProfitC    BEGSR
404900200529      *
405000200529      * Define key list for file SEPCBD
405100200529      *
405200200529     C     KLSPCB        KLIST
405300200529     C                   KFLD                    BOKC
405400200529     C                   KFLD                    BRCA
405500200529     C                   KFLD                    SESN
405600200529     C                   KFLD                    MKTI
405700200529      *
405800200529      * Define key list for file SEPCCD
405900200529      *
406000200529     C     KLSPCC        KLIST
406100200529     C                   KFLD                    CNUM
406200200529     C                   KFLD                    BRCA
406300200529     C                   KFLD                    SESN
406400200529      *
406500200529      * Set up keys for SEPCBD and SEPCCD
406600200529      *
406700200529     C                   MOVEL     DDBPBK        BOKC
406800200529     C                   MOVEL     DDBRCD        BRCA
406900200529     C                   MOVEL     DDSESN        SESN
407000200529     C                   MOVEL     DDTDMI        MKTI
407100200529     C**********         Z-ADD     TCNR          CNUM                                         CSD027
407200200529     C                   EVAL      CNUM = TCNR                                                CSD027
407300200529      *
407400200529      *  If book position/profit centres are to be reconciled
407500200529     C*                                                                                       167488
407600200529     C*   If Profit Centre used                                                               167488
407700200529     C*   and Analytical Accounting Module is off and profit centre                           167488
407800200529     C*   blank.                                                                              167488
407900200529     C*                                                                                       167488
408000200529     C     BKPRCU        IFEQ      'Y'                                                        167488
408100200529     C     BGN0ST        ANDNE     'Y'                                                        167488
408200200529     C     DDPRFC        ANDEQ     *BLANK                                                     167488
408300200529     C*                                                                                       167488
408400200529      *
408500200529     C     BVTBRC        IFEQ      'Y'
408600200529      *
408700200529      *  Access book position profit centre record
408800200529      *
408900200529     C     KLSPCB        CHAIN     SEPCBD                             99
409000200529      *
409100200529      * If record found, default the profit cente to that on it
409200200529      *
409300200529     C     *IN99         IFEQ      '0'
409400200529     C                   MOVE      PCBK          DDPRFC
409500200529      *
409600200529      *  Else, default from the matrix
409700200529      *
409800200529     C                   ELSE
409900200529     C     BKPCDU        IFEQ      'Y'
410000200529     C                   EXSR      AOPRFM
410100200529     C     #RTCD         IFEQ      '0'
410200200529     C                   MOVE      @PRFC         DDPRFC
410300200529     C                   END
410400200529     C                   END
410500200529     C                   END
410600200529     C                   END
410700200529      *
410800200529      *  If book position/profit centres are NOT to be reconciled
410900200529      *  Only need to default if the profit centre has not been entered                       165014
411000200529      *
411100200529     C     BVTBRC        IFNE      'Y'
411200200529     C     DDPRFC        ANDEQ     *BLANK                                                     165014
411300200529      *
411400200529      *  Access customer position profit centre record
411500200529      *
411600200529     C     KLSPCC        CHAIN     SEPCCD                             99
411700200529      *
411800200529      * If record found, default the profit cente to that on it
411900200529      *
412000200529     C     *IN99         IFEQ      '0'
412100200529     C                   MOVE      PCCU          DDPRFC
412200200529      *
412300200529      *  Else, default from the matrix
412400200529      *
412500200529     C                   ELSE
412600200529     C     BKPCDU        IFEQ      'Y'
412700200529     C                   EXSR      AOPRFM
412800200529     C     #RTCD         IFEQ      '0'
412900200529     C                   MOVE      @PRFC         DDPRFC
413000200529     C                   END
413100200529     C                   END
413200200529     C                   END
413300200529     C                   END
413400200529      *
413500200529     C                   END                                                                  167488
413600200529      * Profit centre must be valid
413700200529      *
413800200529     C     DDPRFC        IFNE      *BLANK                                                     165014
413900200529     C                   EXSR      AOPRFC
414000200529     C     @RTCD         IFEQ      '*NOSEL '                                                  165014
414100200529     C                   MOVE      *BLANK        @RTCD                                        165014
414200200529     C                   MOVE      *BLANK        DDPRFC                                       165014
414300200529     C                   END                                                                  165014
414400200529     C**********         END                                                           165014 188320
414500200529      *
414600200529      * Error if not found
414700200529      *
414800200529     C     @RTCD         IFNE      *BLANKS
414900200529     C                   ADD       1             Idx
415000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0660'
415100200529     C                   EVAL      FldNamXAr (Idx) = 'DDPRFC'
415200200529     C                   EVAL      DDPRFCok = 'N'
415300200529     C                   END
415400200529     C                   ENDIF                                                                188320
415500200529      *
415600200529      *  If book position/profit centres are to be reconciled
415700200529      *
415800200529     C     BVTBRC        IFEQ      'Y'
415900200529
416000200529     C     KLSPCB        CHAIN     SEPCBD                             99
416100200529      *
416200200529      ** Error if the trade profit centre does not match
416300200529      ** the position profit centre.
416400200529      *
416500200529     C     *IN99         IFEQ      '0'
416600200529     C     DDPRFC        ANDNE     PCBK
416700200529     C                   ADD       1             Idx
416800200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0661'
416900200529     C                   EVAL      FldNamXAr (Idx) = 'DDPRFC'
417000200529     C                   EVAL      DDPRFCok = 'N'
417100200529     C                   END
417200200529     C                   END
417300200529      *
417400200529      * Update trade field
417500200529      *
417600200529     C                   MOVE      DDPRFC        PRFC
417700200529      *
417800200529     C                   ENDSR
417900200529      *****************************************************************
418000200529      /EJECT
418100200529      *****************************************************************
418200200529      *                                                               *
418300200529      * ValPriorit - Subroutine to perform the validation for the     *
418400200529      *              Priority field.                                  *
418500200529      *                                                               *
418600200529      *****************************************************************
418700200529     C     ValPriorit    BEGSR
418800200529      *
418900200529      ** DEFAULT to 'R' (Normal)
419000200529      *
419100200529     C     DDPRYC        IFEQ      *BLANKS
419200200529     C                   MOVE      'R'           DDPRYC
419300200529     C                   END
419400200529      *
419500200529      ** Validate priority code
419600200529      *
419700200529     C     DDPRYC        IFNE      'R'
419800200529     C     DDPRYC        ANDNE     'P'
419900200529     C     DDPRYC        ANDNE     'W'
420000200529     C     DDPRYC        ANDNE     'L'
420100200529     C                   ADD       1             Idx
420200200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0657'
420300200529     C                   EVAL      FldNamXAr (Idx) = 'DDPRYC'
420400200529     C                   EVAL      DDPRYCok = 'N'
420500200529     C                   END
420600200529      *
420700200529      * Update trade field
420800200529      *
420900200529     C                   MOVE      DDPRYC        PRYC
421000200529      *
421100200529     C                   ENDSR
421200200529      *****************************************************************
421300200529      /EJECT
421400200529      *****************************************************************
421500200529      *                                                               *
421600200529      * ValPayCode - Subroutine to perform the validation for the     *
421700200529      *              Pay Code field.                                  *
421800200529      *                                                               *
421900200529      *****************************************************************
422000200529     C     ValPayCode    BEGSR
422100200529      *
422200200529      ** Pay code
422300200529      **    .. must be in the range 0 - 5
422400200529      *
422500200529      ** Only if it is not a book transfer                                                   BUG2582
422600200529     C     CustClass     IFNE      'I'                                                       BUG2582
422700200529                                                                                             BUG2582
422800200529     C     DDPCOD        IFLT      '0'
422900200529     C     DDPCOD        ORGT      '5'
423000200529     C                   ADD       1             Idx
423100200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0658'
423200200529     C                   EVAL      FldNamXAr (Idx) = 'DDPCOD'
423300200529     C                   EVAL      DDPCODok = 'N'
423400200529     C                   END
423500200529     C                   ENDIF                                                               BUG2582
423600200529      *
423700200529      **  .. if settle method is '03', pay code must be '2', '3' or '4'.
423800200529      *
423900200529     C     DDSMTH        IFEQ      '03'
424000200529
424100200529     C     DDPCOD        IFNE      '2'
424200200529     C     DDPCOD        ANDNE     '3'
424300200529     C     DDPCOD        ANDNE     '4'
424400200529     C                   ADD       1             Idx
424500200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0658'
424600200529     C                   EVAL      FldNamXAr (Idx) = 'DDPCOD'
424700200529     C                   EVAL      DDPCODok = 'N'
424800200529     C                   END
424900200529
425000200529     C                   END
425100200529      *
425200200529      * Update trade field
425300200529      *
425400200529     C                   MOVE      DDPCOD        PCOD
425500200529      *
425600200529     C                   ENDSR
425700200529      *****************************************************************
425800200529      /EJECT
425900200529      *****************************************************************
426000200529      *                                                               *
426100200529      * ValAutoSet - Subroutine to perform the validation for the     *
426200200529      *              Auto-Settle indicator.                           *
426300200529      *                                                               *
426400200529      *****************************************************************
426500200529     C     ValAutoSet    BEGSR
426600200529      *
426700200529     C                   IF        CSE039 = 'Y' AND CustClass = 'M'                           CSE039
426800200529     C                             AND DDAUTS = *BLANKS                                       CSE039
426900200529                                                                                              CSE039
427000200529      ** Default the Auto-Settle indicator with the value held for the                        CSE039
427100200529      *  Depo Customer.                                                                       CSE039
427200200529      *                                                                                       CSE039
427300200529     C                   EVAL      PCUST = *BLANKS                                            CSE039
427400200529      *                                                                                       CSE039
427500200529      ** If Trade Purchase use Deliver To Customer                                            CSE039
427600200529      *  If Trade Sale use Deliver From Customer                                              CSE039
427700200529     C                   IF        DDTDTP = 'TP'                                              CSE039
427800200529     C                   IF        DDDELT <> *BLANKS                                          CSE039
427900200529     C                   MOVEL     DDDELT        PCUST                                        CSE039
428000200529     C                   ENDIF                                                                CSE039
428100200529     C                   ELSE                                                                 CSE039
428200200529     C                   IF        DDDELF <> *BLANKS                                          CSE039
428300200529     C                   MOVEL     DDDELF        PCUST                                        CSE039
428400200529     C                   ENDIF                                                                CSE039
428500200529     C                   ENDIF                                                                CSE039
428600200529      *                                                                                       CSE039
428700200529     C                   IF        PCUST <> *BLANKS                                           CSE039
428800200529     C                   CALL      'SESSIR0'                                                  CSE039
428900200529     C                   PARM                    POTYP                                        CSE039
429000200529     C                   PARM      DDBRCD        PBRCH                                        CSE039
429100200529     C                   PARM                    PCUST                                        CSE039
429200200529     C                   PARM      DDBPBK        PBOOK                                        CSE039
429300200529     C                   PARM      DDSETC        PCURR                                        CSE039
429400200529     C                   PARM      DDMRKT        PMRKT                                        CSE039
429500200529     C                   PARM      DDINVT        PINVT                                        CSE039
429600200529     C                   PARM      DDPTFR        PPTFR                                        CSE039
429700200529     C                   PARM                    PCBSTD                                       CSE039
429800200529     C                   PARM                    PCBSAD                                       CSE039
429900200529     C                   PARM      *BLANKS       PRTCD                                        CSE039
430000200529      *                                                                                       CSE039
430100200529      ** Retrieve DS for Customer.                                                            CSE039
430200200529     C                   IF        PRTCD <> '*NRF ' AND PRTCD <> '*NCRF'                      CSE039
430300200529     C     2             OCCUR     PCBSTD                                                     CSE039
430400200529     C                   IF        X1RECI = 'D'                                               CSE039
430500200529     C                   MOVE      X1SASI        DDAUTS                                       CSE039
430600200529     C                   ENDIF                                                                CSE039
430700200529     C                   ENDIF                                                                CSE039
430800200529      *                                                                                       CSE039
430900200529     C                   IF        PRTCD = '*NRF ' OR PRTCD = '*NCRF'                         CSE039
431000200529     C                             OR X1RECI <> 'D'                                           CSE039
431100200529      ** If no record found then use the Aut-Sett indicator from SDSEC                        CSE039
431200200529     C                   MOVE      PCUST         WCUST                                        CSE039
431300200529     C                   EXSR      AOSECS                                                     CSE039
431400200529     C                   MOVE      BFASIN        DDAUTS                                       CSE039
431500200529     C                   ENDIF                                                                CSE039
431600200529      *                                                                                       CSE039
431700200529     C                   ENDIF                                                                CSE039
431800200529     C                   ENDIF                                                                CSE039
431900200529      *                                                                                       CSE039
432000200529      *                                                                                       CSE039
432100200529      **  Default Auto-Settle Indicator
432200200529      *
432300200529     C     DDAUTS        IFEQ      *BLANKS
432400200529     C     DDTDMI        IFNE      'G'
432500200529     C                   MOVE      CustAuts      DDAUTS
432600200529     C                   ELSE
432700200529     C                   MOVE      'N'           DDAUTS
432800200529     C                   END
432900200529     C                   END
433000200529      *
433100200529      **  Autosettle indicator    ...  must be 'Y' or 'N'
433200200529      *
433300200529     C     DDAUTS        IFNE      'Y'
433400200529     C     DDAUTS        ANDNE     'N'
433500200529     C     CSE039        ANDEQ     'N'                                                        CSE039
433600200529     C     DDAUTS        OREQ      'Y'
433700200529     C     DDTDMI        ANDEQ     'G'
433800200529     C     CSE039        ANDEQ     'N'                                                        CSE039
433900200529     C                   ADD       1             Idx
434000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0659'
434100200529     C                   EVAL      FldNamXAr (Idx) = 'DDAUTS'
434200200529     C                   EVAL      DDAUTSok = 'N'
434300200529     C                   END
434400200529      *
434500200529     C     CSE039        IFEQ      'Y'                                                        CSE039
434600200529     C     DDAUTS        ANDNE     'Y'                                                        CSE039
434700200529     C     DDAUTS        ANDNE     'N'                                                        CSE039
434800200529     C     DDAUTS        ANDNE     'A'                                                        CSE039
434900200529     C                   ADD       1             Idx                                          CSE039
435000200529     C                   EVAL      MsgIDXAr(Idx) = 'MMA0794'                                  CSE039
435100200529     C                   EVAL      FldNamXAr (Idx) = 'DDAUTS'                                 CSE039
435200200529     C                   EVAL      DDAUTSok = 'N'                                             CSE039
435300200529     C                   END                                                                  CSE039
435400200529      *                                                                                       CSE039
435500200529      * Update trade field
435600200529      *
435700200529     C                   MOVE      DDAUTS        AUTS
435800200529      *
435900200529     C                   ENDSR
436000200529      *****************************************************************
436100200529      /EJECT
436200200529      *****************************************************************
436300200529      *                                                               *
436400200529      * SetPrimRet - Subroutine to build the Prime Retail Account     *
436500200529      *              for Settlement method 04.                        *
436600200529      *                                                               *
436700200529      *****************************************************************
436800200529     C     SetPrimRet    BEGSR
436900200529      *
437000200529     C                   MOVEL     ACOD          WCOSQ
437100200529     C                   MOVE      ACSQ          WCOSQ
437200200529     C                   MOVEL     CNUM          WPRAC
437300200529     C                   MOVE      WCOSQ         WPRAC
437400200529      *
437500200529     C     DDTDTP        IFEQ      'TP'
437600200529     C                   MOVEL     WPRAC         PYFM
437700200529     C                   ELSE
437800200529     C                   MOVEL     WPRAC         PAYT
437900200529     C                   END
438000200529
438100200529     C                   ENDSR
438200200529      *****************************************************************
438300200529      /EJECT
438400200529      *****************************************************************
438500200529      *                                                               *
438600200529      * DefPyFrBr -  Subroutine to perform the defaulting procedure   *
438700200529      *              for the Pay From Branch field.                   *
438800200529      *                                                               *
438900200529      *****************************************************************
439000200529     C     DefPyFrBr     BEGSR
439100200529
439200200529     C     DDSMTH        IFEQ      '01'
439300200529     C     DDSMTH        OREQ      '02'
439400200529     C     DDSMTH        OREQ      '07'
439500200529     C     DDSMTH        OREQ      '08'
439600200529     C     DDSMTH        OREQ      '12'
439700200529     C                   MOVEL     A7BRCD        DDPYFB
439800200529     C                   ELSE
439900200529
440000200529     C     DDSMTH        IFEQ      '14'
440100200529     C     DDSMTH        OREQ      '15'
440200200529     C                   MOVEL     BRCA          DDPYFB
440300200529     C                   ELSE
440400200529
440500200529     C     DDSMTH        IFNE      '05'
440600200529     C                   MOVEL     DDBRCD        DDPYFB
440700200529     C                   END
440800200529
440900200529     C                   END
441000200529     C                   END
441100200529
441200200529     C                   ENDSR
441300200529      *****************************************************************
441400200529      /EJECT
441500200529      *****************************************************************
441600200529      *                                                               *
441700200529      * DefPytoBr -  Subroutine to perform the defaulting procedure   *
441800200529      *              for the Pay To Branch field.                     *
441900200529      *                                                               *
442000200529      *****************************************************************
442100200529     C     DefPyToBr     BEGSR
442200200529
442300200529     C     DDSMTH        IFEQ      '01'
442400200529     C     DDSMTH        OREQ      '02'
442500200529     C     DDSMTH        OREQ      '07'
442600200529     C     DDSMTH        OREQ      '08'
442700200529     C     DDSMTH        OREQ      '12'
442800200529     C                   MOVEL     A7BRCD        DDPYTB
442900200529     C                   ELSE
443000200529
443100200529     C     DDSMTH        IFEQ      '14'
443200200529     C     DDSMTH        OREQ      '15'
443300200529     C                   MOVEL     BRCA          DDPYTB
443400200529     C                   ELSE
443500200529
443600200529     C     DDSMTH        IFNE      '05'
443700200529     C                   MOVEL     DDBRCD        DDPYTB
443800200529     C                   END
443900200529
444000200529     C                   END
444100200529     C                   END
444200200529
444300200529     C                   ENDSR
444400200529      *****************************************************************
444500200529      /EJECT
444600200529      *****************************************************************
444700200529      *                                                               *
444800200529      * AOBRCH -  Subroutine to retrieve branch details.              *
444900200529      *                                                               *
445000200529      *****************************************************************
445100200529     C     AOBRCH        BEGSR
445200200529      *
445300200529     C**********         CALL      'AOBRCHR0'                                                 CGL029
445400200529     C                   CALL      'AOBRCHR1'                                                 CGL029
445500200529     C                   PARM                    @RTCD
445600200529     C                   PARM      '*KEY   '     @OPTN
445700200529     C                   PARM                    @DSNB
445800200529     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
445900200529     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
446000200529      *
446100200529     C                   ENDSR
446200200529      *****************************************************************
446300200529      /EJECT
446400200529      *****************************************************************
446500200529      *                                                               *
446600200529      * AOCUST -  Subroutine to accsess customer details.             *
446700200529      *                                                               *
446800200529      *****************************************************************
446900200529     C     AOCUST        BEGSR
447000200529
447100200529     C                   CALLB     'AOCUSTR0'
447200200529     C                   PARM                    @RTCD
447300200529     C                   PARM      '*KEY   '     @OPTN
447400200529     C                   PARM      WCSNM         @KEY1
447500200529     C                   PARM                    @KYST
447600200529     C     SDCUST        PARM      SDCUST        DSSDY
447700200529
447800200529     C                   ENDSR
447900200529      *****************************************************************
448000200529      /EJECT
448100200529      *****************************************************************
448200200529      *                                                               *
448300200529      * AOSECS -   Subroutine to access Security Customer details     *
448400200529      *                                                               *
448500200529      *****************************************************************
448600200529     C     AOSECS        BEGSR
448700200529
448800200529     C                   CALLB     'AOSECSR0'
448900200529     C                   PARM                    @RTCD
449000200529     C                   PARM      '*KEY   '     @OPTN
449100200529     C                   PARM      WCUST         @SCKY
449200200529     C     SDSECS        PARM      SDSECS        DSSDY
449300200529
449400200529     C                   ENDSR
449500200529      *****************************************************************
449600200529      /EJECT
449700200529      *****************************************************************
449800200529      *                                                               *
449900200529      * AOCNST - Subroutine to retrieved Counterparty Nostro details. *
450000200529      *                                                               *
450100200529      *****************************************************************
450200200529     C     AOCNST        BEGSR
450300200529
450400200529     C                   CALL      'AOCNSTR0'
450500200529     C                   PARM                    @RTCD
450600200529     C                   PARM      '*KEY   '     @OPTN
450700200529     C                   PARM                    @CPNC
450800200529     C     SDCNST        PARM      SDCNST        DSFDY
450900200529
451000200529     C                   ENDSR
451100200529      *****************************************************************
451200200529      /EJECT
451300200529      *****************************************************************
451400200529      *                                                               *
451500200529      * AOPRFM - Subroutine to default profit centres.                *
451600200529      *                                                               *
451700200529      *****************************************************************
451800200529     C     AOPRFM        BEGSR
451900200529      *                                                                                       167953
452000200529      ** Get account officer for matrix defaulting                                            167953
452100200529      *                                                                                       167953
452200200529     C                   MOVEL     TCNR          WCSNM                                        167953
452300200529     C                   EXSR      AOCUST                                                     167953
452400200529                                                                                              167953
452500200529     C                   MOVE      *BLANKS       @ACOC                                        167953
452600200529     C     @RTCD         IFEQ      *BLANKS                                                    167953
452700200529     C                   MOVEL     BBACOC        @ACOC                                        167953
452800200529      *                                                                                       188320
452900200529      ** Get Department code for matrix defaulting                                            188320
453000200529      *                                                                                       188320
453100200529     C                   EXSR      AOACOF                                                     188320
453200200529     C     @RTCD         IFEQ      *BLANKS                                                    188320
453300200529     C                   MOVEL     AZDPCD        @DPCD                                        188320
453400200529     C                   ENDIF                                                                188320
453500200529     C                   ENDIF                                                                167953
453600200529
453700200529     C                   MOVEL     DDTDTP        @TRTY
453800200529     C                   MOVEL     TCNR          @CUST
453900200529
454000200529     C                   CALL      'AOPRFMR0'
454100200529     C                   PARM      *BLANK        #RTCD             1
454200200529     C                   PARM      DDBPBK        @BKCD             2
454300200529     C                   PARM                    @TRTY             5
454400200529     C                   PARM      DDTSUB        @SBTY             2
454500200529     C                   PARM      DDBRCD        @BRCD             3
454600200529     C**********         PARM      *BLANKS       @DPCD             3                          188320
454700200529     C                   PARM                    @DPCD             3                          188320
454800200529     C                   PARM      PSUser        @USID            10
454900200529     C*******************PARM      *BLANKS       @ACOC             2                          167953
455000200529     C                   PARM                    @ACOC             2                          167953
455100200529     C                   PARM                    @CUST             6
455200200529     C                   PARM                    @PRFC             4
455300200529
455400200529     C                   ENDSR
455500200529      *****************************************************************
455600200529      /EJECT
455700200529      *****************************************************************
455800200529      *                                                               *
455900200529      * AOPRFC - Subroutine to validate profit centres.               *
456000200529      *                                                               *
456100200529      *****************************************************************
456200200529     C     AOPRFC        BEGSR
456300200529
456400200529     C                   CALL      'AOPRFCR0'
456500200529     C                   PARM      *BLANKS       @RTCD
456600200529     C                   PARM      '*KEY   '     @OPTN
456700200529     C**********         PARM      DDPRFC        @PCCD             4                          165014
456800200529     C     DDPRFC        PARM      DDPRFC        @PCCD             4                          165014
456900200529     C     SDPRFC        PARM      SDPRFC        DSFDY
457000200529
457100200529     C                   ENDSR
457200200529      *****************************************************************
457300200529      /EJECT
457400200529      *****************************************************************                       188320
457500200529      *                                                               *                       188320
457600200529      * AOACOF - Subroutine to access Account Officer details.        *                       188320
457700200529      *                                                               *                       188320
457800200529      *****************************************************************                       188320
457900200529     C     AOACOF        BEGSR                                                                188320
458000200529                                                                                              188320
458100200529     C                   CALL      'AOACOFR0'                                                 188320
458200200529     C                   PARM      *BLANKS       @RTCD                                        188320
458300200529     C                   PARM      '*KEY   '     @OPTN                                        188320
458400200529     C                   PARM                    @ACOC             2                          188320
458500200529     C     SDACOF        PARM      SDACOF        DSFDY                                        188320
458600200529                                                                                              188320
458700200529     C                   ENDSR                                                                188320
458800200529      *****************************************************************                       188320
458900200529      /EJECT                                                                                  188320
459000200529      *****************************************************************
459100200529      *                                                               *
459200200529      * AONOST - Subroutine to retrieve Nosto Details                 *
459300200529      *                                                               *
459400200529      *****************************************************************
459500200529     C     AONOST        BEGSR
459600200529
459700200529     C                   CALLB     'AONOSTR0'
459800200529     C                   PARM                    @RTCD
459900200529     C                   PARM      '*KEY   '     @OPTN
460000200529     C                   PARM      *BLANKS       P@CUST
460100200529     C                   PARM                    P@CYCD
460200200529     C                   PARM      *BLANKS       P@ACCD
460300200529     C                   PARM      *BLANKS       P@ACSN
460400200529     C                   PARM                    P@NONB
460500200529     C                   PARM      *BLANKS       P@BRCD
460600200529     C                   PARM      *BLANKS       P@CSSN
460700200529     C                   PARM      *BLANKS       P@PNOI
460800200529     C     SDNOST        PARM      SDNOST        DSFDY
460900200529
461000200529     C                   ENDSR
461100200529      *****************************************************************
461200200529      /EJECT
461300200529      *****************************************************************
461400200529      *                                                               *
461500200529      * AOCURR - Subroutine to retrieve Currency Details              *
461600200529      *                                                               *
461700200529      *****************************************************************
461800200529     C     AOCURR        BEGSR
461900200529
462000200529     C                   CALLB     'AOCURRR0'
462100200529     C                   PARM      *BLANK        @RTCD
462200200529     C                   PARM      '*KEY   '     @OPTN
462300200529     C                   PARM                    @AJCD             3
462400200529     C     SDCURR        PARM      SDCURR        DSSDY
462500200529
462600200529     C                   ENDSR
462700200529      *****************************************************************
462800200529      /EJECT
462900200529      *****************************************************************
463000200529      *                                                               *
463100200529      * *inzsr - Program Initialisation routine                       *
463200200529      *                                                               *
463300200529      *****************************************************************
463400200529     C     *inzsr        BEGSR
463500200529
463600200529     C     *entry        PLIST
463700200529
463800200529      * INPUTS
463900200529
464000200529      * Response mode
464100200529     C                   PARM                    RespMode          1
464200200529
464300200529      ** Trade Settlement Instructions
464400200529     C                   PARM                    TrSett
464500200529
464600200529      ** OTHER SCREEN FIELDS
464700200529      ** Security
464800200529      ** Incomplete Ind
464900200529      ** Trade Type
465000200529      ** Book
465100200529      ** Trade Sub Type
465200200529      ** Market Indicator
465300200529      ** Booking branch
465400200529      ** Settlement Currency
465500200529      ** Market Centre                                                                        CSE039
465600200529      ** Portfolio Reference                                                                  CSE039
465700200529     C                   PARM                    DDSESN           10
465800200529     C                   PARM                    DDINCS            1
465900200529     C                   PARM                    DDTDTP            2
466000200529     C                   PARM                    DDBPBK            2
466100200529     C                   PARM                    DDTSUB            2
466200200529     C                   PARM                    DDTDMI            1
466300200529     C                   PARM                    DDBRCD            3
466400200529     C                   PARM                    DDSETC            3
466500200529     C                   PARM                    DDMRKT            2                          CSE039
466600200529     C                   PARM                    DDPTFR            4                          CSE039
466700200529
466800200529      ** TRADE FIELDS
466900200529      ** Counterparty
467000200529      ** Value Date
467100200529      ** Nominal
467200200529      ***Countervalue********                                                         CGL014 BUG3145
467300200529     C                   PARM                    TCNR
467400200529     C                   PARM                    TDVD              5 0
467500200529     C                   PARM                    NOML             11 0          CSE013
467600200529     C**********         PARM                    TCTR                                 CGL014 BUG3145
467700200529
467800200529      ** Nominal Currency Details
467900200529      ** Settlement Currency Details
468000200529     C                   PARM                    NomCcyDts
468100200529     C                   PARM                    SetCcyDts
468200200529
468300200529      ** Security Info (from SECTYD)
468400200529      ** Nominal Currency
468500200529      ** Depot 1 Security Reference
468600200529      ** Depot 2 Security Reference
468700200529      ** Depot 3 Security Reference
468800200529
468900200529     C                   PARM                    NMCY              3
469000200529     C                   PARM                    DASR             12
469100200529     C                   PARM                    DCSR             12
469200200529     C                   PARM                    DDSR             12
469300200529
469400200529      ** Investment Type Info (from INVTPD)
469500200529      ** Settlement depots 1,2,3
469600200529      ** Investment Type                                                                      CSE039
469700200529     C                   PARM                    SDC1
469800200529     C                   PARM                    SDC2
469900200529     C                   PARM                    SDC3
470000200529     C                   PARM                    DDINVT            3                          CSE039
470100200529      *
470200200529      ** Customer (Counterparty) Details
470300200529     C                   PARM                    CustDts                                       S0111
470400200529
470500200529      ** ICD
470600200529      ** Multi-branching Ind
470700200529      ** Local currency
470800200529      ** System branch
470900200529      ** System location
471000200529      ** Originating branches used
471100200529      ** Originating branches v. user validation
471200200529      ** Profit centres used
471300200529      ** Profit centre defaulting
471400200529      ** Profit Centre Accounting installed
471500200529      ** Euro Currency Code
471600200529      ** Retail installed
471700200529      ** US dollar currency code
471800200529      ** Retail current a/c code
471900200529      ** Cedel currency code
472000200529      ** Euroclear currency code
472100200529      ** Trade & Book Positions Reconciliable
472200200529      ** Trade/Value Date Valuation
472300200529      ** CSE013 - Short position warning
472400200529      ** S01496 - Private Banking SE enhancements
472500200529      ** CEU005 - EMU SE Settlement Currency Conversion
472600200529
472700200529     C                   PARM                    @MBIN             1
472800200529     C                   PARM                    BJLCCY            3
472900200529     C                   PARM                    BJSBRC            3
473000200529     C                   PARM                    BJSLCD            3
473100200529     C                   PARM                    BKOBRU            1
473200200529     C                   PARM                    BKOBUV            1
473300200529     C                   PARM                    BKPRCU            1
473400200529     C                   PARM                    BKPCDU            1
473500200529     C                   PARM                    BKEURO            3
473600200529     C                   PARM                    BGN0ST            1
473700200529     C                   PARM                    BGRTBN            1
473800200529     C                   PARM                    BLUSCY            3
473900200529     C**********         PARM                    BMACCD            4                          CGL029
474000200529     C                   PARM                    BMACCD                                       CGL029
474100200529     C                   PARM                    BVCCCY            3
474200200529     C                   PARM                    BVEUCY            3
474300200529     C                   PARM                    BVTBRC            1
474400200529     C                   PARM                    BVTVDV            1            CSE013
474500200529     C                   PARM                    CSE013            1            CSE013
474600200529     C                   PARM                    S01496            1
474700200529     C                   PARM                    CEU005            1
474800200529     C**********         PARM                    CGL014                               CGL014 BUG3145
474900200529      *
475000200529      * OUTPUTS
475100200529      *
475200200529      ** Trade details
475300200529      ** Originating branch
475400200529      ** Settlement Method
475500200529      ** Pay From
475600200529      ** Pay From Branch
475700200529      ** Pay To
475800200529      ** Pay To Branch
475900200529      ** For Account of (Pay to)
476000200529      ** Account Sequence Number
476100200529      ** Clearance Type
476200200529      ** Deliver to
476300200529      ** For Account of (Deliver to)
476400200529      ** Deliver From
476500200529      ** For Account of-Deliver From
476600200529      ** Special Instructions
476700200529      ** In Currency in Field 72
476800200529      ** Profit Centre
476900200529      ** Priority Code
477000200529      ** Pay Code
477100200529      ** Auto-settle Indicator
477200200529     C                   PARM                    ORBR              3
477300200529     C                   PARM                    SMTH
477400200529     C**********         PARM                    PYFM             12                          CGL029
477500200529     C                   PARM                    PYFM                                         CGL029
477600200529     C                   PARM                    PYFA              3
477700200529     C**********         PARM                    PAYT             12                          CGL029
477800200529     C                   PARM                    PAYT                                         CGL029
477900200529     C                   PARM                    PYTA              3
478000200529     C                   PARM                    TDFA              8
478100200529     C                   PARM                    ASNM
478200200529     C                   PARM                    CLTY              1
478300200529     C                   PARM                    DELT
478400200529     C                   PARM                    DTFA              8
478500200529     C                   PARM                    DELF
478600200529     C                   PARM                    DFFA              8
478700200529     C                   PARM                    TDSI             35
478800200529     C                   PARM                    ICCY              3
478900200529     C                   PARM                    PRFC              4
479000200529     C                   PARM                    PRYC              1
479100200529     C                   PARM                    PCOD              1
479200200529     C                   PARM                    AUTS              1
479300200529      *
479400200529      ** Trade Settlement Instructions OK
479500200529     C                   PARM                    OKTrSett
479600200529
479700200529      * Error fields/message IDs/message data (arrays) from/to caller
479800200529     C                   PARM                    FldNamXAr
479900200529     C                   PARM                    MsgIDXAr
480000200529     C                   PARM                    MsgDtaXAr
480100200529
480200200529      * Warning fields/message IDs/message data (arrays) from/to caller
480300200529     C                   PARM                    WFldNmXAr
480400200529     C                   PARM                    WMsgIDXAr
480500200529     C                   PARM                    WMsgDtXAr
480600200529                                                                                              CSW201
480700200529     C     *LOCK         IN        LDA                                                        CSW201
480800200529     C                   EVAL      DBPGM = 'SETSETIVAL'                                       CSW201
480900200529     C                   OUT       LDA                                                        CSW201
481000200529                                                                                              CSW201
481100200529      ** Check if CSW201 - Swift 2001 Standards Update is installed                           CSW201
481200200529                                                                                              CSW201
481300200529     C                   CALL      'SWIF2001'                           9090                  CSW201
481400200529     C                   PARM      *BLANKS       WRtnCd                                       CSW201
481500200529                                                                                              CSW201
481600200529     C                   IF        *IN90 = *ON                                                CSW201
481700200529     C     *LOCK         IN        LDA                                                        CSW201
481800200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSW201
481900200529     C                   EVAL      DBASE = 001                                                CSW201
482000200529     C                   EVAL      DBKEY = 'CSW201'                                           CSW201
482100200529     C                   OUT       LDA                                                        CSW201
482200200529     C                   EXSR      *PSSR                                                      CSW201
482300200529                                                                                              CSW201
482400200529     C                   ELSE                                                                 CSW201
482500200529     C                   IF        WRtnCd = 'CSW2001'                                         CSW201
482600200529     C                   EVAL      CSW201 = 'Y'                                               CSW201
482700200529     C                   ELSE                                                                 CSW201
482800200529     C                   EVAL      CSW201 = 'N'                                               CSW201
482900200529     C                   ENDIF                                                                CSW201
483000200529     C                   ENDIF                                                                CSW201
483100200529                                                                                              CSE039
483200200529      ** Check if CSE039 is installed                                                         CSE039
483300200529     C                   CALL      'AOSARDR0'                                                 CSE039
483400200529     C                   PARM      *BLANKS       @RTCD             7                          CSE039
483500200529     C                   PARM      '*VERIFY'     @OPTN             7                          CSE039
483600200529     C                   PARM      'CSE039'      @SARD             6                          CSE039
483700200529      *                                                                                       CSE039
483800200529     C     @RTCD         IFEQ      *BLANKS                                                    CSE039
483900200529     C                   MOVE      'Y'           CSE039            1                          CSE039
484000200529     C                   ELSE                                                                 CSE039
484100200529     C                   MOVE      'N'           CSE039                                       CSE039
484200200529     C                   ENDIF                                                                CSE039
484300200529
484400200529      ** Access SAR details file to determine if CSE099 installed.                            162270
484500200529      *                                                                                       162270
484600200529     C                   CALLB     'AOSARDR0'                                                 162270
484700200529     C                   PARM      *BLANKS       @RTCD                                        162270
484800200529     C                   PARM      '*VERIFY'     @OPTN                                        162270
484900200529     C                   PARM      'CSE099'      @SARD                                        162270
485000200529     C     SCSARD        PARM      SCSARD        DSFDY                                        162270
485100200529      *                                                                                       162270
485200200529     C     @RTCD         IFEQ      *BLANK                                                     162270
485300200529     C                   MOVEL     'Y'           CSE099            1                          162270
485400200529     C                   ELSE                                                                 162270
485500200529     C                   MOVEL     'N'           CSE099                                       162270
485600200529     C                   ENDIF                                                                162270
485700200529      *                                                                                       162270
485800200529      **--------------------------------------------------------------------------------------
485900200529      ** The following /COPY sets the values of program, module and
486000200529      ** procedure names for database error processing.
486100200529     C/COPY ZACPYSRC,DBFIELDS
486200200529      **--------------------------------------------------------------------------------------------
486300200529     C/COPY WNCPYSRC,SETSETIVC1
486400200529
486500200529     C                   ENDSR
486600200529      *****************************************************************
486700200529      /EJECT
486800200529     C/COPY WNCPYSRC,SETSETIVC2
486900200529      *****************************************************************
487000200529      **--------------------------------------------------------------------------------------------
487100200529      ** The following /COPY contains the standard program status
487200200529      ** subroutine, including a bound call to the DBERRCTL module.
487300200529     C/COPY ZACPYSRC,PSSR_ILE
487400200529      **--------------------------------------------------------------------------------------------
487500200529      ********************************************************************
487600200529**  CPY@
487700200529(c) Finastra International Limited 2001
487800200529**   UPA   -  Valid codeword characters
487900200529ABCDEFGHIJKLMNOPQRSTUVWXYZ/
488000200529**   UPB   -  Valid codeword characters for Swift 2001                                        CSW201
488100200529ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789                                                         CSW201
488200200529**   SWCH  -  Valid SWIFT ISO fromat characters
488300200529ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890/-?:().,'+
