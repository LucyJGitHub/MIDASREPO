000100211110     H DEBUG
000200211110     H COPYRIGHT('(c) Finastra International Limited 2002')
000300211110      *****************************************************************
000400211110/*STD *  RPGBASEMOD                                                   *
000500211110/*EXI *  TEXT('Midas MM Validate Customer number (Loans/Deposits)')
000600211110      *****************************************************************
000700211110      *                                                               *
000800211110      *  Midas - Common Validation Routine                            *
000900211110      *                                                               *
001000211110      *  MMVLDNICUS - Validate Customer Shortname or number           *
001100211110      *               (Loans and Deposits)
001200211110      *                                                               *
001300211110      *  Function:  This module receives a parameter containing the   *
001400211110      *             customer shortname or number and confirms if      *
001500211110      *             valid. If it is valid the 10A return code will be *
001600211110      *             blank; if it is not it will contain 'Error'       *
001700211110      *                                                               *
001800211110      *  (c) Finastra International Limited 2001                      *
001900211110      *                                                               *
002000211110      *    This source is centrally supported and must ONLY be        *
002100211110      *    amended by Core Development Personnel                      *
002200211110      *                                                               *
002300211110      *    /COPY, Client or Country amendments must not be            *
002400211110      *    applied to this source.                                    *
002500211110      *                                                               *
002600211110      *  Last Amend No. CDL036             Date 02Nov21               *
002700211110      *  Prev Amend No. MD046248           Date 27Oct17               *
002800211110      * Bank Fusion Midas 1.4 Base -----------------------------------*
002900211110      * Midas Plus 1.4 Base 04 ---------------------------------------*
003000211110      * Midas Plus 1.4 Base ------------------------------------------*
003100211110      * Midas Plus 1.3 ----------- Base ------------------------------*
003200211110      *                 CSD031             Date 10Apr06               *
003300211110      *                 CSD027             Date 09Dec05               *
003400211110      *                 CSW037A            Date 02May05               *
003500211110      *                 CSD025             Date 11Jan05               *
003600211110      *                 CSW037             Date 15Dec04               *
003700211110      *                 CSW036             Date 15Dec04               *
003800211110      *                 CLE025             Date 20Oct03               *
003900211110      * Midas Release 4 --------------- Base -------------------------*
004000211110      * Midas DBA 3.02 -----------------------------------------------*
004100211110      *                 CPB001             Date 02Sep99               *
004200211110      * Midas DBA 3.01 -----------------------------------------------*
004300211110      *                 CDL006             Date 26Apr99               *
004400211110      * Midas DBA 3.00 ---------------- Base -------------------------*
004500211110      *                 CAP002  *CREATE    Date 03Sep97               *
004600211110      *                                    Date ddmmmyy               *
004700211110      *                                                               *
004800211110      *---------------------------------------------------------------*
004900211110      *                                                               *
005000211110      *  CDL063 - Allow non-bank/bank counterparty on certain         *
005100211110      *           deal types                                          *
005200211110      *  MD046248 - Finastra Rebranding                               *
005300211110      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
005400211110      *  CSD027 - Conversion Of Customer Number to Alpha              *
005500211110      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
005600211110      *  CSD025 - Customer De-Activation                              *
005700211110      *  CSW037 - Additional Field Data on MT300/MT320                *
005800211110      *  CSW036 - Dual SWIFT BIC held on Client Details               *
005900211110      *  CLE025 - Credit Lines (Recompile)                            *
006000211110      *  CPB001 - 'Private Banking' Module                            *
006100211110      *           (Just Recompile)                                    *
006200211110      *  CDL006 - Dealing Fiduciary.                                  *
006300211110      *  CAP002 - Conversion of inputs into modular structure to      *
006400211110      *           use as APIs.                                        *
006500211110      *                                                               *
006600211110      *****************************************************************
006700211110
006800211110      *****************************************************************
006900211110      ** +----------------------------+
007000211110      ** ¦ Manually Included F-Specs  ¦
007100211110      ** ¦ =========================  ¦
007200211110      ** +----------------------------+
007300211110      **
007400211110      **
007500211110      ** +-----------------------------------+
007600211110      ** ¦ End of Manually Included F-Specs  ¦
007700211110      ** ¦ ================================  ¦
007800211110      ** +-----------------------------------+
007900211110      **
008000211110      ** +--------------------------------------+
008100211110      ** ¦ Automatically included D-specs       ¦
008200211110      ** ¦ ==============================       ¦
008300211110      ** +--------------------------------------+
008400211110      **
008500211110      ** Standard D-specs
008600211110      ** ================
008700211110      **
008800211110      ** The following /COPY line includes the LDA layout,
008900211110      ** the copyright array definition,
009000211110      ** and the following named constants:
009100211110      **    True       logical = *on (for indcator processing)
009200211110      **    False      logical = *off (for indcator processing)
009300211110      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
009400211110      **                                    handler)
009500211110      ** and the following variables:
009600211110      **    RunBefore  1A (for the PSSR)
009700211110
009800211110     D/COPY ZACPYSRC,STD_D_SPEC
009900211110
010000211110      ** Include the MM standard declares
010100211110     D/COPY ZACPYSRC,STDDECLARE
010200211110
010300211110      ** Program Status Data Structure
010400211110      ** =============================
010500211110      ** The following /COPY line includes all the defined fields in the
010600211110      ** PSDS.  They have meaningful names, prefixed by 'PS'.
010700211110
010800211110     D/COPY ZACPYSRC,PSDS
010900211110
011000211110      ** Program, procedure and module names for parameters
011100211110      ** ==================================================
011200211110
011300211110      ** +--------------------------------------+
011400211110      ** ¦ End of automatically included D-specs¦
011500211110      ** ¦ =====================================¦
011600211110      ** +--------------------------------------+
011700211110
011800211110      *****************************************************************
011900211110      /EJECT
012000211110      *****************************************************************
012100211110
012200211110      ** +--------------------------------------+
012300211110      ** ¦ Manually included D-specs            ¦
012400211110      ** ¦ =========================            ¦
012500211110      ** +--------------------------------------+
012600211110
012700211110      ** +--------------------------------------+
012800211110      ** ¦ Arrays and Data Structures           ¦
012900211110      ** ¦ ==========================           ¦
013000211110      ** +--------------------------------------+
013100211110
013200211110      ** External data structure for access programs (short)
013300211110     D DSSDY         E DS                  EXTNAME(DSSDY)
013400211110                                                                                CDL006
013500211110      ** External data structure for access programs (2000 chars long)          CDL006
013600211110     D DSLDY         E DS                  EXTNAME(DSLDY)                       CDL006
013700211110
013800211110      ** External data structure for Customer Details file
013900211110     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
014000211110                                                                                              CSD025
014100211110      ** Externally described DS for SAR details                                              CSD025
014200211110     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD025
014300211110                                                                                              CSD025
014400211110      ** External data structure for access programs (short)                                  CSD025
014500211110     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSD025
014600211110                                                                                              CDL063
014700211110     D SysVal1         C                   'AllowBankNBankCpty'                               CDL063
014800211110
014900211110      ** +--------------------------------------+
015000211110      ** ¦ Named constants                      ¦
015100211110      ** ¦ ===============                      ¦
015200211110      ** +--------------------------------------+
015300211110
015400211110      ** +--------------------------------------+
015500211110      ** ¦ Declared variables                   ¦
015600211110      ** ¦ ==================                   ¦
015700211110      ** +--------------------------------------+
015800211110
015900211110      ** Error message code 1 received as a parameter
016000211110     D Msgid1          S                   LIKE(#Msgid)
016100211110
016200211110      ** Error Message code 2 received as a parameter
016300211110     D Msgid2          S                   LIKE(#Msgid)
016400211110
016500211110      ** Customer Number/Shortname received as a paramaterr
016600211110     D DDCUST          S             10A
016700211110
016800211110      ** Deal Type received as a paramater
016900211110     D DDTYPE          S              2A
017000211110
017100211110      ** Output Customer Number passed as parameter
017200211110     D*IKCNUM***       S              6S 0                                                    CSD027
017300211110     D IKCNUM          S              6A                                                      CSD027
017400211110
017500211110      ** Customer Shortname field passed as a parameter
017600211110     D IKCSNM          S             10A
017700211110      *
017800211110      **
017900211110      *
018000211110     D SValK1          S             20                                                       CDL063
018100211110     D SVal1           S            200                                                       CDL063
018200211110     D SValK2          S             20                                                       CDL063
018300211110     D SVal2           S            200                                                       CDL063
018400211110     D SValK3          S             20                                                       CDL063
018500211110     D SVal3           S            200                                                       CDL063
018600211110     D SValK4          S             20                                                       CDL063
018700211110     D SVal4           S            200                                                       CDL063
018800211110     D SValK5          S             20                                                       CDL063
018900211110     D SVal5           S            200                                                       CDL063
019000211110     D SValK6          S             20                                                       CDL063
019100211110     D SVal6           S            200                                                       CDL063
019200211110     D SValK7          S             20                                                       CDL063
019300211110     D SVal7           S            200                                                       CDL063
019400211110     D SValK8          S             20                                                       CDL063
019500211110     D SVal8           S            200                                                       CDL063
019600211110     D SValK9          S             20                                                       CDL063
019700211110     D SVal9           S            200                                                       CDL063
019800211110     D SValK0          S             20                                                       CDL063
019900211110     D SVal10          S            200                                                       CDL063
020000211110     D AllowBNBCpty    S              1                                                       CDL063
020100211110      **
020200211110      ** +--------------------------------------+
020300211110      ** ¦ End of D-specs                       ¦
020400211110      ** ¦ ==============                       ¦
020500211110      ** +--------------------------------------+
020600211110      *****************************************************************
020700211110      /EJECT
020800211110      *****************************************************************
020900211110
021000211110     C
021100211110      ** +--- Start of Main processing -----------------------------------+
021200211110      ** ¦                                                                ¦
021300211110      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
021400211110      ** ¦ executed at program activation.                                ¦
021500211110      ** ¦                                                                ¦
021600211110      ** +----------------------------------------------------------------+
021700211110
021800211110      ** Reset the error flag to prevent problems on subsequent calls
021900211110     C                   RESET                   ErrorFound
022000211110     C                   RESET                   Msgid1
022100211110      *
022200211110      **  Customer must not be blank
022300211110      *
022400211110     C     DDCUST        IFEQ      *BLANKS
022500211110     C                   MOVE      'Y'           ErrorFound
022600211110     C                   MOVEL     'MMM0204'     Msgid1
022700211110     C                   END
022800211110      *
022900211110      **  If customer is not blank, validate it.
023000211110      *
023100211110     C     DDCUST        IFNE      *BLANKS
023200211110      *
023300211110      * Call Access Prog. for Customer Details.
023400211110     C***********        CALL      'AOCUSTR0'                                   CDL006
023500211110     C                   CALL      'AOCUSTR1'                                   CDL006
023600211110      *
023700211110     C                   PARM      *BLANKS       @RTCD             7
023800211110     C                   PARM      '*KEY   '     @OPTN             7
023900211110     C                   PARM      DDCUST        @KEY1            10
024000211110     C                   PARM      *BLANKS       @KYST             7
024100211110     C*****SDCUST        PARM      SDCUST        DSSDY                          CDL006
024200211110     C     SDCUST        PARM      SDCUST        DSLDY                          CDL006
024300211110     C*
024400211110     C     @RTCD         IFNE      *BLANKS
024500211110     C     @KYST         OREQ      '*ERROR '
024600211110     C                   MOVE      'Y'           ErrorFound
024700211110     C                   MOVEL     'MMM0205'     Msgid1
024800211110     C                   ELSE
024900211110     C     CustFormat    IFEQ      'N'
025000211110     C                   MOVEL     *BLANKS       DDCUST
025100211110     C                   MOVEL     BBCUST        DDCUST
025200211110     C                   ELSE
025300211110     C                   MOVEL     BBCSSN        DDCUST
025400211110     C                   END
025500211110                                                                                              CSD025
025600211110     C                   IF        CSD025 = 'Y'                                               CSD025
025700211110     C                             and BBDEAC = 'Y' and DDACTN = 'I'                          CSD025
025800211110                                                                                              CSD025
025900211110     C                   EVAL      ErrorFound = 'Y'                                           CSD025
026000211110     C                   MOVEL     'ABM0028'     MSGID1                                       CSD025
026100211110                                                                                              CSD025
026200211110     C                   ENDIF                                                                CSD025
026300211110     C                   END
026400211110      *
026500211110      **  If no errors so far
026600211110      *
026700211110     C     ErrorFound    IFNE      'Y'
026800211110      *
026900211110      **  Check that the customer is not a parent
027000211110      *
027100211110     C     BBPAIN        IFEQ      'P'
027200211110     C                   MOVE      'Y'           ErrorFound
027300211110     C                   MOVEL     'MMM0206'     Msgid1
027400211110     C                   END
027500211110      *
027600211110      ** Check for bank/non bank and deal types
027700211110      *
027800211110     C     BBBNBI        IFEQ      'Y'
027900211110      *
028000211110      ** Customer is a bank
028100211110      ** If AllowBNBCpty is 'Y, bypass the validation for bank                                CDL063
028200211110      *
028300211110     C     AllowBNBCpty  IFNE      'Y'                                                        CDL063
028400211110     C
028500211110     C     DDTYPE        IFEQ      'TD'
028600211110     C     DDTYPE        OREQ      'TI'
028700211110     C                   MOVE      'Y'           ErrorFound
028800211110     C                   MOVEL     'MMM1064'     Msgid2
028900211110     C                   END
029000211110     C                   ENDIF                                                                CDL063
029100211110     C*
029200211110     C                   ELSE
029300211110      *
029400211110      ** If AllowBNBCpty is 'Y, bypass the validation for non-bank                            CDL063
029500211110      *                                                                                       CDL063
029600211110     C     AllowBNBCpty  IFNE      'Y'                                                        CDL063
029700211110     C     DDTYPE        IFEQ      'IP'
029800211110     C     DDTYPE        OREQ      'IT'
029900211110     C                   MOVE      'Y'           ErrorFound
030000211110     C                   MOVEL     'MMM1065'     Msgid2
030100211110     C                   END
030200211110     C                   ENDIF                                                                CDL063
030300211110     C                   END
030400211110
030500211110     C                   END
030600211110      *
030700211110      **  If the customer is valid, update output fields
030800211110      *
030900211110     C     ErrorFound    IFNE      'Y'
031000211110     C                   MOVEL     BBCUST        IKCNUM
031100211110     C                   MOVE      BBCSSN        IKCSNM
031200211110     C                   ELSE
031300211110     C**********         Z-ADD     0             IKCNUM                                       CSD027
031400211110     C                   EVAL      IKCNUM = *BLANKS                                           CSD027
031500211110     C                   MOVE      *BLANKS       IKCSNM
031600211110     C                   END
031700211110
031800211110     C                   END
031900211110
032000211110     C                   IF        ErrorFound = 'Y'
032100211110     C                   EVAL      RetCodeIn = 'Error'
032200211110     C                   ENDIF
032300211110
032400211110     C                   RETURN
032500211110
032600211110      *****************************************************************
032700211110      /EJECT
032800211110      *****************************************************************
032900211110      *                                                               *
033000211110      * *INZSR - Program Initialisation routine                       *
033100211110      *                                                               *
033200211110      * Called by: Main processing                                    *
033300211110      *                                                               *
033400211110      * Calls: None                                                   *
033500211110      *                                                               *
033600211110      *****************************************************************
033700211110
033800211110     C     *INZSR        BEGSR
033900211110
034000211110     C     *entry        PLIST
034100211110     C                   PARM                    RetCodeIn
034200211110     C                   PARM                    Msgid1
034300211110     C                   PARM                    Msgid2
034400211110     C                   PARM                    CustFormat        1
034500211110     C                   PARM                    DDCUST
034600211110     C                   PARM                    DDTYPE
034700211110     C                   PARM                    IKCNUM
034800211110     C                   PARM                    IKCSNM
034900211110     C                   PARM                    SDCUST
035000211110     C                   PARM                    DDACTN            1                          CSD025
035100211110
035200211110      ** Check if CSD025 (Customer De-Activation) is active                                   CSD025
035300211110      *                                                                                       CSD025
035400211110     C                   CALLB     'AOSARDR0'                                                 CSD025
035500211110     C                   PARM      *BLANKS       PRtCd             7                          CSD025
035600211110     C                   PARM      '*VERIFY'     POptn             7                          CSD025
035700211110     C                   PARM      'CSD025'      PSARD             6                          CSD025
035800211110     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD025
035900211110                                                                                              CSD025
036000211110     C                   MOVE      'N'           CSD025            1                          CSD025
036100211110     C                   IF        PRtCd = *Blanks                                            CSD025
036200211110     C                   EVAL      CSD025 = 'Y'                                               CSD025
036300211110     C                   ENDIF                                                                CSD025
036400211110                                                                                              CSD025
036500211110      ** Check current setting for 'AllowBankNBankCpty' system value  is active               CDL063
036600211110      *                                                                                       CDL063
036700211110     C                   CALL      'AOSVALR0'                                                 CDL063
036800211110     C                   PARM      *BLANKS       PRtcd                                        CDL063
036900211110     C                   PARM      SysVal1       SValK1                                       CDL063
037000211110     C                   PARM                    SVal1                                        CDL063
037100211110     C                   PARM                    SValK2                                       CDL063
037200211110     C                   PARM                    SVal2                                        CDL063
037300211110     C                   PARM                    SValK3                                       CDL063
037400211110     C                   PARM                    SVal3                                        CDL063
037500211110     C                   PARM                    SValK4                                       CDL063
037600211110     C                   PARM                    SVal4                                        CDL063
037700211110     C                   PARM                    SValK5                                       CDL063
037800211110     C                   PARM                    SVal5                                        CDL063
037900211110     C                   PARM                    SValK6                                       CDL063
038000211110     C                   PARM                    SVal6                                        CDL063
038100211110     C                   PARM                    SValK7                                       CDL063
038200211110     C                   PARM                    SVal7                                        CDL063
038300211110     C                   PARM                    SValK8                                       CDL063
038400211110     C                   PARM                    SVal8                                        CDL063
038500211110     C                   PARM                    SValK9                                       CDL063
038600211110     C                   PARM                    SVal9                                        CDL063
038700211110     C                   PARM                    SValK0                                       CDL063
038800211110     C                   PARM                    SVal10                                       CDL063
038900211110                                                                                              CDL063
039000211111     C                   IF        PRtcd = *Blanks                                            CDL063
039001211111     C                   EVAL      AllowBNBCpty = SVal1                                       CDL063
039100211111     C                   ENDIF                                                                CDL063
040000211110                                                                                              CDL063
040100211110      ** Program, module and procedure names for database error processing.
040200211110      ** =================================================================
040300211110      ** The following /COPY sets these values, and also defines LDA as
040400211110      ** an external data area
040500211110
040600211110     C/COPY ZACPYSRC,DBFIELDS
040700211110
040800211110     C                   ENDSR                                                  *** InzEnd ***
040900211110      *****************************************************************
041000211110      /EJECT
041100211110      ********************************************************************
041200211110     C/COPY ZACPYSRC,PSSR_ILE
041300211110      ********************************************************************
041400211110**  CPY@
041500211110(c) Finastra International Limited 2001
