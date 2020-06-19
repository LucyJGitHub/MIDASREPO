000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2003')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas MM Deal amendments retrieve a record')           *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - Money Market                                         *
000900200528      *                                                               *
001000200528      *  MMDEAMR - MM Deal Amendments retrieve a record               *
001100200528      *                                                               *
001200200528      *  Function:  This module retrieves a record from the file      *
001300200528      *                                                               *
001400200528      *  (c) Finastra International Limited 2003                      *
001500200528      *                                                               *
001600200604      *  Last Amend No. 260173             Date 22May20               *
001700200528      *  Prev Amend No. MD046248           Date 27Oct17               *
001800200528      *                 CGL165             Date 17Feb15               *
001900200528      *                 CDL096             Date 22Sep14               *
002000200528      *                 CDL094             Date 30May14               *
002100200528      *                 CSF011A            Date 28Nov11               *
002200200528      *                 CRE073             Date 06Dec10               *
002300200528      *                 CER059             Date 19Jul10               *
002400200528      *                 CER043             Date 19May08               *
002500200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
002600200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
002700200528      * Midas Plus 1.4 Base ------------------------------------------*
002800200528      * Midas Plus 1.3 ----------- Base ------------------------------*
002900200528      *                 239400             Date 26Jun06               *
003000200528      *                 CSD027             Date 09Dec05               *
003100200528      *                 BUG9891            Date 16Jan06               *
003200200528      *                 CLE031             Date 26Apr05               *
003300200528      *                 CDL038             Date 10May05               *
003400200528      *                 BUG6534            Date 08Apr05               *
003500200528      *                 BUG6012            Date 18Feb05               *
003600200528      *                 BUG4146            Date 31Aug04               *
003700200528      *                 BUG2774            Date 25May04               *
003800200528      *                 CDL022             Date 03Feb04               *
003900200528      *                 CDL020             Date 03Feb04               *
004000200528      *                 CDL017             Date 03Feb04               *
004100200528      *                 TCA002             Date 26Mar04               *
004200200528      *                 CAP084  *CREATE    Date 07Sep03               *
004300200528      *                                                               *
004400200528      *---------------------------------------------------------------*
004500200528      *                                                               *
004600200528      *  260173 - Introduce new parameter in DEAM API to be used in   *
004700200528      *           the validation of action code during reversal       *
004800200528      *           authorization. Apply fix 258724. (Recompile)
004900200528      *  MD046248 - Finastra Rebranding                               *
005000200528      *  CGL165 - Dual Withholding Tax (Recompile)                    *
005100200528      *  CDL096 - Business Day Conventions on MM Deals                *
005200200528      *           (Recompile)                                         *
005300200528      *  CDL094 - Enhance Receive Settlement Instructions             *
005400200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
005500200528      *  CRE073 - Interest Rate Rounding (Recompile)                  *
005600200528      *  CER059 - German Feature Upgrade to Delhi                     *
005700200528      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
005800200528      *  239400 - Add Front Office ID to be used by SOAP Interface    *
005900200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
006000200528      *  BUG9891 - Recompile                                          *
006100200528      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
006200200528      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
006300200528      *  BUG6534 - Condition settlement tabs on a Loan/Deposit        *
006400200528      *            indicator LONDEP.                                  *
006500200528      *  BUG6012 - Add interface and extension data to buffer         *
006600200528      *  BUG4146 - Stopping two users to update the same record at the*
006700200528      *            same time.                                         *
006800200528      *  BUG2774 - Error in Settlement Details.                       *
006900200528      *  CDL022 - Deal Amendment Changes (Recompile)                  *
007000200528      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
007100200528      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
007200200528      *           (Recompile)                                         *
007300200528      *  TCA002 - 10-Digit Account Code Errors - Retrieve a/c details.*
007400200528      *  CAP084 - API wrapper project                                 *
007500200528      *                                                               *
007600200528      *****************************************************************
007700200528
007800200528     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)                                      BUG6534
007900200528      ** +--------------------------------------+
008000200528      ** ¦ F-specs                              ¦
008100200528      ** ¦ =======                              ¦
008200200528      ** +--------------------------------------+
008300200528
008400200528      **-----------------------------------------------------------------------
008500200528     D/COPY ZACPYSRC,STD_D_SPEC
008600200528      **-----------------------------------------------------------------------
008700200528
008800200528      ** Program Status Data Structure                                                       BUG6534
008900200528      ** =============================                                                       BUG6534
009000200528      ** The following /COPY line includes all the defined fields in the                     BUG6534
009100200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.                                BUG6534
009200200528                                                                                             BUG6534
009300200528     D/COPY ZACPYSRC,PSDS                                                                    BUG6534
009400200528      ** The following /COPY line includes definitions for the above fields                  BUG6534
009500200528      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the                         BUG6534
009600200528      ** corresponding fields in the PSDS /COPY member, so that member                       BUG6534
009700200528      ** must be included where this one is used.                                            BUG6534
009800200528                                                                                             BUG6534
009900200528     D/COPY ZACPYSRC,PROCPARMS                                                               BUG6534
010000200528                                                                                             BUG6534
010100200528      **-----------------------------------------------------------------------
010200200528     D/COPY ZACPYSRC,ERR_ARRAYS
010300200528      **-----------------------------------------------------------------------
010400200528
010500200528      **-----------------------------------------------------------------------
010600200528      ** SCREEN FORMATS
010700200528      **-----------------------------------------------------------------------
010800200528
010900200528     D DealScnFmt    E DS                  EXTNAME(MMDEAMPD)
011000200528      * Deal in Screen Format
011100200528
011200200528     D InfData       E DS                  EXTNAME(MMDAIFPD)                                 BUG6012
011300200528      * Interface file data                                                                  BUG6012
011400200528                                                                                             BUG6012
011500200528     D ExtData       E DS                  EXTNAME(MMDAEXPD)                                 BUG6012
011600200528      * Extension data                                                                       BUG6012
011700200528                                                                                             BUG6012
011800200528     D TranInCust    E DS                  EXTNAME(SDCUCUPD)                                  CER043
011900200528      ** Customers Extension Screen Format based on SDCUCUPD                                  CER043
012000200528                                                                                              CER043
012100200528     D ##RECS        E DS                  EXTNAME(SDESSRPD)
012200200528      ** SCREEN RECEIVE INSTRUCTIONS
012300200528
012400200528     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
012500200528      ** SCREEN PAYMENT INSTRUCTIONS
012600200528
012700200528     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
012800200528      ** SCREEN FRA/IRS INSTRUCTIONS
012900200528
013000200528      **-----------------------------------------------------------------------
013100200528      ** FILE FORMATS
013200200528      **-----------------------------------------------------------------------
013300200528
013400200528     D DealFilFmt    E DS                  EXTNAME(MMDEAMPP)
013500200528      ** Deal in File Format
013600200528
013700200528     D*MMVDRecIns***         314    368                                               TCA002 BUG2774
013800200528     D*MMVDPayIns***         383    927                                               TCA002 BUG2774
013900200528     D MMVDRecIns            314    382                                                      BUG2774
014000200528     D MMVDPayIns            383    941                                                      BUG2774
014100200528     D*MMVDRecIns************300    368                                                       TCA002
014200200528     D*MMVDPayIns************369    927                                                       TCA002
014300200528      * Large fields to include
014400200528      * - Receive instructions (xxRSTM to xxROCN)
014500200528      * - Pay     instructions (xxPSTM to xxBTB6)
014600200528
014700200528     D**FHREC****************400    468                                                       TCA002
014800200528     D**FHPAY****************469   1027                                                       TCA002
014900200528
015000200528     D ##RECF        E DS                  EXTNAME(SDESFRPD)
015100200528     D**FLREC******************1     69                                                       TCA002
015200200528     D  FLREC2                21     75                                                       TCA002
015300200528      ** FILE RECEIVE INSTRUCTIONS
015400200528
015500200528     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
015600200528     D**FLPAY******************1    559                                                       TCA002
015700200528     D  FLPAY2                21    565                                                       TCA002
015800200528      *** FILE PAYMENT INSTRUCTIONS
015900200528
016000200528     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
016100200528      ** FILE FRA/IRS INSTRUCTIONS
016200200528
016300200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER043
016400200528      ** External DS for SAR details                                                          CER043
016500200528                                                                                              CER043
016600200528     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER043
016700200528      * First DS for Access programs - short data structure                                   CER043
016800200528                                                                                              CER043
016900200528     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CER043
017000200528      * Second DS for Access programs - long data structure                                   CER043
017100200528                                                                                              CER043
017200200528     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER043
017300200528      ** External DS for Customer Details                                                     CER043
017400200528                                                                                              CER043
017500200528      **-----------------------------------------------------------------------
017600200528
017700200528     D CER043          S              1A                                                      CER043
017800200528      *                                                                                       CER043
017900200528      ** Parameters for Calling AOCUSTR0                                                      CER043
018000200528     D PRtcd           S              7A                                                      CER043
018100200528     D POptn           S              7A                                                      CER043
018200200528     D PCNum           S             10A                                                      CER043
018300200528     D PKey7           S              7A                                                      CER043
018400200528                                                                                              CER043
018500200528      ** Index for arrays of of error message ids etc
018600200528     D Idx             S              3P 0
018700200528
018800200528      ** Index for arrays of warning message ids etc
018900200528     D WIdx            S              3P 0
019000200528     D LONDEP          S              1                                                      BUG6534
019100200528     D DEALNR          S              6  0                                                   BUG6534
019200200528     D DDFOID          S             20                                                       239400
019300200528     D InRCCY          S              3A                                                     CSF011A
019400200528     D InPCCY          S              3A                                                     CSF011A
019500200528
019600200528      **-----------------------------------------------------------------------
019700200528
019800200528     C                   CLEAR                   DealFilFmt
019900200528     C     DDACTN        IFEQ      *BLANK
020000200528     C     AuthComp      IFEQ      'X'
020100200528     C                   MOVEL     'X'           DDACTN
020200200528     C                   ELSE
020300200528     C                   MOVEL     'E'           DDACTN
020400200528     C                   ENDIF
020500200528     C                   ENDIF
020600200528
020700200528     C     FwdBck        IFEQ      'F'
020800200528     C                   MOVEL     'Y'           @RDFWD
020900200528     C                   MOVEL     'N'           @RDBCK
021000200528     C                   ELSE
021100200528     C     FwdBck        IFEQ      'B'
021200200528     C                   MOVEL     'N'           @RDFWD
021300200528     C                   MOVEL     'Y'           @RDBCK
021400200528     C                   ELSE
021500200528     C                   MOVEL     'N'           @RDFWD
021600200528     C                   MOVEL     'N'           @RDBCK
021700200528     C                   ENDIF
021800200528     C                   ENDIF
021900200528
022000200528     C     @RDFWD        IFEQ      'Y'
022100200528     C     @RDBCK        OREQ      'Y'
022200200528     C                   EXSR      MMDEAMRED
022300200528     C                   ELSE
022400200528     C                   MOVEL     DDDLNO_In     @DLRED
022500200528     C                   MOVEL     DDVDAT_IN     @VDRED
022600200528     C                   MOVEL     DDDS38_In     @SQRED
022700200528     C                   MOVEL     *BLANK        @ERRMS
022800200528     C                   ENDIF
022900200528      *
023000200528      * If deal read
023100200528      * and no error message returned
023200200528      *
023300200528     C     @DLRED        IFNE      *BLANK
023400200528     C     @ERRMS        ANDEQ     *BLANK
023500200528      *
023600200528      * Retrieve deal details
023700200528      *
023800200528     C                   MOVEL     @DLRED        DDDLNO
023900200528     C                   MOVEL     @FTRED        APFOTranID
024000200528     C                   MOVEL     @FARED        APFOAsocID
024100200528     C                   MOVEL     @VDRED        DDVDAT
024200200528     C                   MOVEL     @SQRED        DDDS38
024300200528     C                   EXSR      MMDEAMRTV
024400200528      *
024500200528      * Convert to screeen format
024600200528      *
024700200528     C     Idx           IFEQ      0
024800200528     C                   EXSR      MMDEAMCVT
024900200528     C                   EXSR      ZASETINCVT
025000200528      *                                                                                      BUG6534
025100200528      * Distinguish loans from deposits for conditioning settlement tabs.                    BUG6534
025200200528     C                   MOVEL     ' '           LONDEP                                      BUG6534
025300200528     C                   IF        DDDLNO    <> *BLANKS                                      BUG6534
025400200528     C                   MOVEL     DDDLNO        DEALNR                                      BUG6534
025500200528     C     DEALNR        CHAIN     MMDEALLL                           30                     BUG6534
025600200528      *                                                                                      BUG6534
025700200528     C                   IF        HKMTYP = 'IT' OR HKMTYP = 'TD'                            BUG6534
025800200528     C                             OR HKMTYP = 'CI' OR HKMTYP = 'CD'                         BUG6534
025900200528     C                   MOVEL     'D'           LONDEP                                      BUG6534
026000200528     C                   ELSE                                                                BUG6534
026100200528     C                   MOVEL     'L'           LONDEP                                      BUG6534
026200200528     C                   ENDIF                                                               BUG6534
026300200528     C                   ENDIF                                                               BUG6534
026400200528      *                                                                                      BUG6534
026500200528     C                   ENDIF
026600200528
026700200528     C                   ENDIF
026800200528
026900200528     C     @ERRMS        IFNE      *BLANK
027000200528     C                   MOVEL     '0'           APIRetc
027100200528     C                   MOVEL     'DDDLNO'      FldNameArr(1)
027200200528     C                   MOVEL     @ERRMS        MsgIDArr(1)
027300200528     C                   ENDIF
027400200528
027500200528     C                   MOVEL     HNTMST        @TimeStamp       26                         BUG4146
027600200528      *                                                                                       CER043
027700200528      ** Population of Customer Details                                                       CER043
027800200528     C                   IF        CER043 = 'Y'                                               CER043
027900200528     C                   EXSR      SrPopCust                                                  CER043
028000200528     C                   ENDIF                                                                CER043
028100200528      *                                                                                       CER043
028200200528     C                   EVAL                    Buffer = DealScnfmt
028300200528     C**********                                          + @TimeStamp               BUG4146 BUG6534
028400200528     C**********                                 + @TimeStamp + LONDEP                BUG6534 CER043
028500200528     C                                           + @TimeStamp                                 CER043
028600200528     C                                           + TranIncust                                 CER043
028700200528     C                                           + LONDEP                                     CER043
028800200528     C                                           + DDFOID                                     239400
028900200528     C                                           + @ACTRV                                     260173
029000200528     C                                           + ##RECS  + ##PAYS
029100200528     C                                           + InfData                                   BUG6012
029200200528     C                                           + ExtData                                   BUG6012
029300200528
029400200528     C                   SETON                                        LR
029500200528     C                   RETURN
029600200528      **********************************************************************
029700200528      /EJECT
029800200528      *****************************************************************
029900200528      *                                                               *
030000200528      *  *INZSR - Program Initialisation                              *
030100200528      *         - This subroutine runs automatically for program      *
030200200528      *           initialisation.                                     *
030300200528      *                                                               *
030400200528      *****************************************************************
030500200528     C     *INZSR        BEGSR
030600200528
030700200528     C     *ENTRY        PLIST
030800200528     C                   PARM                    AuthComp          1
030900200528     C                   PARM                    FwdBck            1
031000200528     C                   PARM                    DDDLNO_In         6
031100200528     C                   PARM                    DDVDAT_In         6
031200200528     C                   PARM                    DDDS38_In         3
031300200528     C                   PARM                    Buffer         6000
031400200528     C                   PARM                    FldNameArr
031500200528     C                   PARM                    MsgIDArr
031600200528     C                   PARM                    MsgDtaArr
031700200528     C                   PARM                    MsgFArray
031800200528     C                   PARM                    APIRetc           1
031900200528     C                   PARM                    @ACTRV            1                          260173
032000200528
032100200528      * Set up the name of the primary and secondary message files from
032200200528      * which the message handler will get the messages
032300200528     C                   EVAL      MsgFArray(1) = 'DRSMM'
032400200528
032500200528      *                                                                                       CER043
032600200528      ** Check if CER043 is switched on                                                       CER043
032700200528                                                                                              CER043
032800200528     C                   CALL      'AOSARDR0'                                                 CER043
032900200528     C                   PARM      *BLANKS       PRTCD                                        CER043
033000200528     C                   PARM      '*VERIFY'     POPTN                                        CER043
033100200528     C                   PARM      'CER043'      PSARD             6                          CER043
033200200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
033300200528                                                                                              CER043
033400200528     C                   IF        PRTCD = *BLANKS                                            CER043
033500200528     C                   EVAL      CER043 = 'Y'                                               CER043
033600200528     C                   ELSE                                                                 CER043
033700200528     C                   EVAL      CER043 = 'N'                                               CER043
033800200528                                                                                              CER043
033900200528     C                   IF        PRTCD <> '*NRF'                                            CER043
034000200528     C     *LOCK         IN        LDA                                                        CER043
034100200528     C                   EVAL      DBKEY = 'CER043'                                           CER043
034200200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
034300200528     C                   EVAL      DBASE = 901                                                CER043
034400200528     C                   OUT       LDA                                                        CER043
034500200528     C                   EXSR      *PSSR                                                      CER043
034600200528     C                   ENDIF                                                                CER043
034700200528                                                                                              CER043
034800200528     C                   ENDIF                                                                CER043
034900200528      *  Hook to enable non-core message files to be included
035000200528     C/COPY WNCPYSRC,MMDEAMM01
035100200528
035200200528     C                   ENDSR
035300200528
035400200528      **********************************************************************
035500200528      /EJECT
035600200528      **********************************************************************
035700200528     C     MMDEAMRED     BEGSR
035800200528      *
035900200528     C                   CALLB     'MMDEAMRED'
036000200528      *
036100200528      * INPUT PARAMETERS
036200200528      *
036300200528      * RETURN CODE
036400200528     C                   PARM      *BLANK        RetCodeOut
036500200528      *
036600200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
036700200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
036800200528      *
036900200528     C                   PARM      '      '      @@MODE            6
037000200528      *
037100200528      * ACTION CODE
037200200528     C                   PARM                    DDACTN            1
037300200528      *
037400200528      * DEAL NUMBER POINTER
037500200528     C                   PARM      DDDLNO_In     DDDLNO            6
037600200528      *
037700200528      * Front Office ID
037800200528     C                   PARM                    DDFRTN           20
037900200528     C                   PARM      DDVDAT_In     DDVDAT            6
038000200528     C                   PARM      DDDS38_In     DDDS38            3
038100200528      *
038200200528      * READ FORWARDS
038300200528     C                   PARM                    @RDFWD            1
038400200528      *
038500200528      * READ BACKWARDS
038600200528     C                   PARM                    @RDBCK            1
038700200528      *
038800200528      * OUTPUT PARAMETERS
038900200528      *
039000200528      * ERROR MESSAGE
039100200528     C                   PARM      *BLANK        @ERRMS            7
039200200528      *
039300200528      * DEAL NUMBER READ
039400200528     C                   PARM      *BLANK        @DLRED            6
039500200528      *
039600200528      * Front Office ID READ
039700200528     C                   PARM      *BLANK        @FTRED           20
039800200528      *
039900200528      * Front Office Associated ID READ
040000200528     C                   PARM      *BLANK        @FARED           20
040100200528      *
040200200528      * VALUE DATE READ
040300200528     C                   PARM      *BLANK        @VDRED            6
040400200528      *
040500200528      * SEQUENCE NUMBER READ
040600200528     C                   PARM      *BLANK        @SQRED            3
040700200528
040800200528     C                   ENDSR
040900200528      **********************************************************************
041000200528     C     MMDEAMRTV     BEGSR
041100200528
041200200528     C                   CALLB     'MMDEAMRTV'
041300200528
041400200528      * INPUTS
041500200528
041600200528      * Return code
041700200528     C                   PARM                    ReturnCode
041800200528
041900200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
042000200528      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
042100200528     C                   PARM                    ModeofOp          6
042200200528      *
042300200528      * Response mode
042400200528     C                   PARM      'S'           APRESPMODE        1
042500200528
042600200528      * Action Code
042700200528     C                   PARM                    DDACTN            1
042800200528
042900200528      * Front Office Transaction ID
043000200528     C                   PARM                    APFOTranID       20
043100200528
043200200528      * Front Office Associated Transaction Id
043300200528     C                   PARM                    APFOAsocID       20
043400200528
043500200528      * (Midas) Deal Number
043600200528     C                   PARM                    DDDLNO
043700200528
043800200528      * Value Date
043900200528     C                   PARM                    DDVDAT
044000200528      *
044100200528      * Sequence Number
044200200528     C                   PARM                    DDDS38
044300200528      *
044400200528      * Deal Amendment Amount
044500200528     C                   PARM                    DDAMNP
044600200528      *
044700200528      * Deal Amendment Type
044800200528     C                   PARM                    DDMTYP
044900200528      * Action Code (Reversal transaction)                                                    260173
045000200528     C                   PARM                    @ACTRV                                       260173
045100200528
045200200528      * OUTPUTS
045300200528
045400200528      * (Current) deal in file format
045500200528     C                   PARM                    DealFilFmt
045600200528
045700200528      * OK - Action code
045800200528     C                   PARM                    DDActnOK          1
045900200528
046000200528      * OK - Deal Number
046100200528     C                   PARM                    DDDlnoOK          1
046200200528
046300200528      * OK - Value Date
046400200528     C                   PARM                    DDVDatOK          1
046500200528
046600200528      * OK - Sequence Number
046700200528     C                   PARM                    DDDS38OK          1
046800200528
046900200528      * Error fields/message IDs/message data (arrays) from/to caller
047000200528     C                   PARM                    FldNameArr
047100200528     C                   PARM                    MsgIDArr
047200200528     C                   PARM                    MsgDtaArr
047300200528
047400200528      * Array index (3P0) from/to caller
047500200528     C                   PARM                    Idx
047600200528
047700200528     C                   ENDSR
047800200528      *****************************************************************
047900200528     C     MMDEAMCVT     BEGSR
048000200528
048100200528     C                   CALLB     'MMDEAMCVT'
048200200528
048300200528      * INPUTS
048400200528      * Return Code
048500200528     C                   PARM                    ReturnCode
048600200528      * (Current) Deal in file format
048700200528     C                   PARM                    DealFilfmt
048800200528
048900200528      * OUTPUTS
049000200528      * (Current) Deal in screen format
049100200528     C                   PARM                    DealScnfmt
049200200528      * Deal Status
049300200528     C                   PARM                    DDSTS            24
049400200528
049500200528      ** AMEND CHECKING
049600200528     C                   RESET                   ReturnCode
049700200528
049800200528     C                   EVAL      DDFOID = HNFRNT                                            239400
049900200528                                                                                              239400
050000200528     C                   ENDSR
050100200528      *****************************************************************
050200200528      /EJECT
050300200528      *****************************************************************
050400200528     C     ZASETINCVT    BEGSR
050500200528      *
050600200528      * SET UP PAYMENT INSTRUCTIONS FROM DEAL
050700200528      *
050800200528     C*******************MOVEL     MMVDPayIns    FLPAY                                        TCA002
050900200528     C                   MOVEL     HNPSTM        FLPSTM                                       TCA002
051000200528     C                   MOVEL     HNPONS        FLPONS                                       TCA002
051100200528     C                   MOVEL     MMVDPayIns    FLPAY2                                       TCA002
051200200528     C                   MOVEL     HNOSBR        FLPOBR
051300200528     C                   MOVEL     HNCVMR        FLCVMR
051400200528     C                   MOVEL     HNSTCY        FLPSCY
051500200528     C                   MOVEL     HNIC72        FLIC72
051600200528      *
051700200528      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
051800200528      *
051900200528     C*******************MOVEL     MMVDRecIns    FLREC                                        TCA002
052000200528     C                   MOVEL     HNRSTM        FLRSTM                                       TCA002
052100200528     C                   MOVEL     HNRONS        FLRONS                                       TCA002
052200200528     C                   MOVEL     MMVDRecIns    FLREC2                                       TCA002
052300200528     C                   MOVEL     HNOSBR        FLROBR
052400200528     C                   MOVEL     HNSTCY        FLRSCY
052500200528     C                   MOVEL     HNRBB1        FLRBB1                                       CDL094
052600200528     C                   MOVEL     HNRBB2        FLRBB2                                       CDL094
052700200528     C                   MOVEL     HNRBB3        FLRBB3                                       CDL094
052800200528     C                   MOVEL     HNRBB4        FLRBB4                                       CDL094
052900200528     C                   MOVEL     HNRBB5        FLRBB5                                       CDL094
053000200528     C                   MOVEL     HNRBB6        FLRBB6                                       CDL094
053100200528      *
053200200528     C                   CALLB     'ZASETINCVT'
053300200528      *
053400200528      ** INPUTS
053500200528      *
053600200528      ** File Payment Settlement Instruction
053700200528     C                   PARM                    ##PAYF
053800200528      *
053900200528      ** File Receipt Settlement Instruction
054000200528     C                   PARM                    ##RECF
054100200528      *
054200200528      ** File FRA/IRS Settlement Instruction
054300200528     C                   PARM      *BLANK        ##FRIF
054400200528      *
054500200528      ** OUTPUTS
054600200528      ** Screen Payment Settlement Instruction
054700200528     C                   PARM      *BLANK        ##PAYS
054800200528      *
054900200528      ** Screen Receipt Settlement Instruction
055000200528     C                   PARM      *BLANK        ##RECS
055100200528      *
055200200528      ** Screen FRA/IRS Settlement Instruction
055300200528     C                   PARM      *BLANK        ##FRIS
055400200528     C                   PARM      DDCCY         InRCCY                                      CSF011A
055500200528     C                   PARM      DDCCY         InPCCY                                      CSF011A
055600200528      *
055700200528     C                   ENDSR
055800200528      *****************************************************************
055900200528      /EJECT                                                                                 BUG6534
056000200528     C/COPY ZACPYSRC,PSSR_ILE                                                                BUG6534
056100200528      ********************************************************************                   BUG6534
056200200528      /EJECT                                                                                  CER043
056300200528      *****************************************************************                       CER043
056400200528      *                                                               *                       CER043
056500200528      *  SrPopCust - Subroutine to Populate Customer Details          *                       CER043
056600200528      *                                                               *                       CER043
056700200528      *  Called by: MAIN Processing                                   *                       CER043
056800200528      *                                                               *                       CER043
056900200528      *  Calls: SrRtvCust                                             *                       CER043
057000200528      *                                                               *                       CER043
057100200528      *****************************************************************                       CER043
057200200528      *                                                                                       CER043
057300200528     C     SrPopCust     BEGSR                                                                CER043
057400200528      *                                                                                       CER043
057500200528     C                   CLEAR                   TranInCust                                   CER043
057600200528      *                                                                                       CER043
057700200528      ** Retrieve Customer Details                                                            CER043
057800200528     C                   IF        DDCSNM <> *BLANKS                                          CER043
057900200528     C                   EVAL      PCNum = DDCSNM                                             CER043
058000200528      *                                                                                       CER043
058100200528     C                   EXSR      SrRtvCust                                                  CER043
058200200528     C                   IF        PRtcd = *BLANKS                                            CER043
058300200528     C                   EVAL      DDCSSN = BBCSSN                                            CER043
058400200528     C                   EVAL      DDCRNM = BBCRNM                                            CER043
058500200528     C                   EVAL      DDCRTN = BBCRTN                                            CER043
058600200528     C                   ENDIF                                                                CER043
058700200528      *                                                                                       CER043
058800200528     C                   ENDIF                                                                CER043
058900200528      *                                                                                       CER043
059000200528     C                   ENDSR                                                                CER043
059100200528      *****************************************************************                       CER043
059200200528      /EJECT                                                                                  CER043
059300200528      *****************************************************************                       CER043
059400200528      *                                                               *                       CER043
059500200528      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                       CER043
059600200528      *                                                               *                       CER043
059700200528      *  Called by: SrPopCust                                         *                       CER043
059800200528      *                                                               *                       CER043
059900200528      *  Calls: None                                                  *                       CER043
060000200528      *                                                               *                       CER043
060100200528      *****************************************************************                       CER043
060200200528     C     SrRtvCust     BEGSR                                                                CER043
060300200528      *                                                                                       CER043
060400200528      ** Call AOCUSTR0 to get Customer Details                                                CER043
060500200528     C                   CALLB     'AOCUSTR0'                                                 CER043
060600200528     C                   PARM      *BLANKS       PRtcd                                        CER043
060700200528     C                   PARM      '*KEY   '     POptn                                        CER043
060800200528     C                   PARM                    PCNum                                        CER043
060900200528     C                   PARM      *BLANKS       PKey7                                        CER043
061000200528     C     SDCUST        PARM      SDCUST        DSSDY                                        CER043
061100200528      *                                                                                       CER043
061200200528     C                   ENDSR                                                                CER043
061300200528      *****************************************************************                       CER043
061400200528      /EJECT                                                                                  CER043
061500200528      *****************************************************************                       CER043
061600200528**  CPY@
061700200528(c) Finastra International Limited 2003
