000100211110     H DEBUG
000200211110     H COPYRIGHT('(c) Finastra International Limited 2002')
000300211110      *****************************************************************
000400211110/*STD *  RPGBASEMOD                                                   *
000500211110/*EXI *  TEXT('Midas MM Validate customer number (Repos)')
000600211110      *****************************************************************
000700211110      *                                                               *
000800211110      *  Midas - Common Validation Routine                            *
000900211110      *                                                               *
001000211110      *  MMVLDNICUS - Validate Customer Shortname or number (Repos)   *
001100211110      *                                                               *
001200211110      *  Function:  This module receives a parameter containing the   *
001300211110      *             customer shortname or number and confirms if      *
001400211110      *             valid. If it is valid the 10A return code will be *
001500211110      *             blank; if it is not it will contain 'Error'       *
001600211110      *                                                               *
001700211110      *  (c) Finastra International Limited 2001                      *
001800211110      *                                                               *
001900211110      *    This source is centrally supported and must ONLY be        *
002000211110      *    amended by Core Development Personnel                      *
002100211110      *                                                               *
002200211110      *    /COPY, Client or Country amendments must not be            *
002300211110      *    applied to this source.                                    *
002400211110      *                                                               *
002500211110      *  Last Amend No. CDL036             Date 02Nov21               *
002600211110      *  Prev Amend No. MD046248           Date 27Oct17               *
002700211110      * Bank Fusion Midas 1.4 Base -----------------------------------*
002800211110      * Midas Plus 1.4 Base 04 ---------------------------------------*
002900211110      * Midas Plus 1.4 Base ------------------------------------------*
003000211110      * Midas Plus 1.3 ----------- Base ------------------------------*
003100211110      *                 CSD031             Date 10Apr06               *
003200211110      *                 CSD027             Date 09Dec05               *
003300211110      *                 CSW037A            Date 02May05               *
003400211110      *                 CSD025             Date 11Jan05               *
003500211110      *                 CSW037             Date 15Dec04               *
003600211110      *                 CSW036             Date 15Dec04               *
003700211110      *                 BUG3122            Date 17Jul04               *
003800211110      *                 CLE025             Date 20Oct03               *
003900211110      * Midas Release 4 --------------- Base -------------------------*
004000211110      *                 CSE022             Date 29Mar01               *
004100211110      * Midas DBA 3.02 -----------------------------------------------*
004200211110      *                 CSE006  *CREATE    Date 28Feb00               *
004300211110      *                 XXXnnn             Date ddmmmyy               *
004400211110      *                                                               *
004500211110      *---------------------------------------------------------------*
004600211110      *                                                               *
004700211110      *  CDL063 - Allow non-bank/bank counterparty on certain         *
004800211110      *           deal types                                          *
004900211110      *  MD046248 - Finastra Rebranding                               *
005000211110      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
005100211110      *  CSD027 - Conversion Of Customer Number to Alpha              *
005200211110      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
005300211110      *  CSD025 - Customer De-Activation                              *
005400211110      *  CSW037 - Additional Field Data on MT300/MT320                *
005500211110      *  CSW036 - Dual SWIFT BIC held on Client Details               *
005600211110      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
005700211110      *  CLE025 - Credit Lines (Recompile)                            *
005800211110      *  CSE022 - Depository Definition Enhancement                   *
005900211110      *  CSE006 - Repos enhancement - new module to similar to        *
006000211110      *           MMVLDNICUS but also checks for Securities customers *
006100211110      *                                                               *
006200211110      *****************************************************************
006300211110
006400211110      *****************************************************************
006500211110      ** +----------------------------+
006600211110      ** ¦ Manually Included F-Specs  ¦
006700211110      ** ¦ =========================  ¦
006800211110      ** +----------------------------+
006900211110      **
007000211110      **
007100211110      ** +-----------------------------------+
007200211110      ** ¦ End of Manually Included F-Specs  ¦
007300211110      ** ¦ ================================  ¦
007400211110      ** +-----------------------------------+
007500211110      **
007600211110      ** +--------------------------------------+
007700211110      ** ¦ Automatically included D-specs       ¦
007800211110      ** ¦ ==============================       ¦
007900211110      ** +--------------------------------------+
008000211110      **
008100211110      ** Standard D-specs
008200211110      ** ================
008300211110      **
008400211110      ** The following /COPY line includes the LDA layout,
008500211110      ** the copyright array definition,
008600211110      ** and the following named constants:
008700211110      **    True       logical = *on (for indcator processing)
008800211110      **    False      logical = *off (for indcator processing)
008900211110      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
009000211110      **                                    handler)
009100211110      ** and the following variables:
009200211110      **    RunBefore  1A (for the PSSR)
009300211110
009400211110     D/COPY ZACPYSRC,STD_D_SPEC
009500211110
009600211110      ** Include the MM standard declares
009700211110     D/COPY ZACPYSRC,STDDECLARE
009800211110
009900211110      ** Program Status Data Structure
010000211110      ** =============================
010100211110      ** The following /COPY line includes all the defined fields in the
010200211110      ** PSDS.  They have meaningful names, prefixed by 'PS'.
010300211110
010400211110     D/COPY ZACPYSRC,PSDS
010500211110
010600211110      ** Program, procedure and module names for parameters
010700211110      ** ==================================================
010800211110
010900211110      ** +--------------------------------------+
011000211110      ** ¦ End of automatically included D-specs¦
011100211110      ** ¦ =====================================¦
011200211110      ** +--------------------------------------+
011300211110
011400211110      *****************************************************************
011500211110      /EJECT
011600211110      *****************************************************************
011700211110
011800211110      ** +--------------------------------------+
011900211110      ** ¦ Manually included D-specs            ¦
012000211110      ** ¦ =========================            ¦
012100211110      ** +--------------------------------------+
012200211110
012300211110      ** +--------------------------------------+
012400211110      ** ¦ Arrays and Data Structures           ¦
012500211110      ** ¦ ==========================           ¦
012600211110      ** +--------------------------------------+
012700211110
012800211110      ** External data structure for access programs (short)
012900211110     D DSSDY         E DS                  EXTNAME(DSSDY)
013000211110                                                                                CDL006
013100211110      ** External data structure for access programs (2000 chars long)          CDL006
013200211110     D DSLDY         E DS                  EXTNAME(DSLDY)                       CDL006
013300211110
013400211110      ** External data structure for Customer Details file
013500211110     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
013600211110
013700211110      ** External data structure for Securities Customer Details file
013800211110     D SDSECS        E DS                  EXTNAME(SDSECSPD)
013900211110                                                                                              CSD025
014000211110      ** DS for Access Objects - short data structure                                         CSD025
014100211110     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSD025
014200211110                                                                                              CSD025
014300211110      ** Externally described DS for SAR details                                              CSD025
014400211110     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD025
014500211110
014501211110     D SysVal1         C                   'AllowBankNBankCpty'                               CDL063
014502211110
014600211110      ** +--------------------------------------+
014700211110      ** ¦ Named constants                      ¦
014800211110      ** ¦ ===============                      ¦
014900211110      ** +--------------------------------------+
015000211110
015100211110      ** +--------------------------------------+
015200211110      ** ¦ Declared variables                   ¦
015300211110      ** ¦ ==================                   ¦
015400211110      ** +--------------------------------------+
015500211110
015600211110      ** Error message code 1 received as a parameter
015700211110     D Msgid1          S                   LIKE(#Msgid)
015800211110
015900211110      ** Error Message code 2 received as a parameter
016000211110     D Msgid2          S                   LIKE(#Msgid)
016100211110
016200211110      ** Customer Number/Shortname received as a paramaterr
016300211110     D DDCUST          S             10A
016400211110
016500211110      ** Deal Type received as a paramater
016600211110     D DDTYPE          S              2A
016700211110
016800211110      ** Output Customer Number passed as parameter
016900211110     D*IKCNUM***       S              6S 0                                                    CSD027
017000211110     D IKCNUM          S              6A                                                      CSD027
017100211110
017200211110      ** Customer Shortname field passed as a parameter
017300211110     D IKCSNM          S             10A
017400211110      *
017500211110      ** System Values field passed as a parameter
017600211110      *
017700211110     D SValK1          S             20                                                       CDL063
017800211110     D SVal1           S            200                                                       CDL063
017900211110     D SValK2          S             20                                                       CDL063
018000211110     D SVal2           S            200                                                       CDL063
018100211110     D SValK3          S             20                                                       CDL063
018200211110     D SVal3           S            200                                                       CDL063
018300211110     D SValK4          S             20                                                       CDL063
018400211110     D SVal4           S            200                                                       CDL063
018500211110     D SValK5          S             20                                                       CDL063
018600211110     D SVal5           S            200                                                       CDL063
018700211110     D SValK6          S             20                                                       CDL063
018800211110     D SVal6           S            200                                                       CDL063
018900211110     D SValK7          S             20                                                       CDL063
019000211110     D SVal7           S            200                                                       CDL063
019100211110     D SValK8          S             20                                                       CDL063
019200211110     D SVal8           S            200                                                       CDL063
019300211110     D SValK9          S             20                                                       CDL063
019400211110     D SVal9           S            200                                                       CDL063
019500211110     D SValK0          S             20                                                       CDL063
019600211110     D SVal10          S            200                                                       CDL063
019700211110      *
019800211110     D AllowBNBCpty    S              1                                                       CDL063
019900211110      **
020000211110      ** +--------------------------------------+
020100211110      ** ¦ End of D-specs                       ¦
020200211110      ** ¦ ==============                       ¦
020300211110      ** +--------------------------------------+
020400211110      *****************************************************************
020500211110      /EJECT
020600211110      *****************************************************************
020700211110
020800211110     C
020900211110      ** +--- Start of Main processing -----------------------------------+
021000211110      ** ¦                                                                ¦
021100211110      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
021200211110      ** ¦ executed at program activation.                                ¦
021300211110      ** ¦                                                                ¦
021400211110      ** +----------------------------------------------------------------+
021500211110
021600211110      ** Reset the error flag to prevent problems on subsequent calls
021700211110     C                   RESET                   ErrorFound
021800211110     C                   RESET                   Msgid1
021900211110      *
022000211110      **  Customer must not be blank
022100211110      *
022200211110     C     DDCUST        IFEQ      *BLANKS
022300211110     C                   MOVE      'Y'           ErrorFound
022400211110     C                   MOVEL     'MMM0204'     Msgid1
022500211110     C                   ENDIF
022600211110      *
022700211110      * If '?' entered, display securities customers
022800211110      *
022900211110     C     DDCUST        IFEQ      '?'
023000211110     C                   MOVEL     *BLANK        DDCUST
023100211110     C                   CALLB     'AOSECSR0'
023200211110     C                   PARM      *BLANKS       @RTCD                                         S0111
023300211110     C                   PARM      '*KEY   '     @OPTN                                         S0111
023400211110     C                   PARM      '?      '     @SCKY                                         S0111
023500211110     C     SDSECS        PARM      SDSECS        DSSDY                                         S0111
023600211110      *
023700211110     C     @RTCD         IFEQ      *BLANKS
023800211110     C                   MOVEL     BFCUST        DDCUST
023900211110     C                   ENDIF
024000211110      *
024100211110     C                   ENDIF
024200211110      *
024300211110      **  If customer is not blank, validate it.
024400211110      *
024500211110     C     DDCUST        IFNE      *BLANKS
024600211110      *
024700211110      * Call Access Prog. for Customer Details...
024800211110     C                   CALL      'AOCUSTR1'                                   CDL006
024900211110      *
025000211110     C                   PARM      *BLANKS       @RTCD             7
025100211110     C                   PARM      '*KEY   '     @OPTN             7
025200211110     C                   PARM      DDCUST        @KEY1            10
025300211110     C                   PARM      *BLANKS       @KYST             7
025400211110     C     SDCUST        PARM      SDCUST        DSLDY                          CDL006
025500211110     C*
025600211110     C     @RTCD         IFNE      *BLANKS
025700211110     C     @KYST         OREQ      '*ERROR '
025800211110     C                   MOVE      'Y'           ErrorFound
025900211110     C                   MOVEL     'MMM0205'     Msgid1
026000211110     C                   ELSE
026100211110      *
026200211110      ** .. and must be a valid client number on SDSECSPD
026300211110      *
026400211110     C                   CALLB     'AOSECSR0'
026500211110     C                   PARM      *BLANKS       @RTCD                                         S0111
026600211110     C                   PARM      '*KEY   '     @OPTN                                         S0111
026700211110     C                   PARM      BBCUST        @SCKY             6                           S0111
026800211110     C     SDSECS        PARM      SDSECS        DSSDY                                         S0111
026900211110      *
027000211110     C     @RTCD         IFNE      *BLANKS
027100211110     C     @KYST         OREQ      '*ERROR '
027200211110     C                   MOVE      'Y'           ErrorFound
027300211110     C                   MOVEL     'MMA0116'     Msgid1
027400211110     C                   ELSE
027500211110      *
027600211110      ** Must be a valid classification
027700211110      *
027800211110     C     BFCLAS        IFEQ      'I'
027900211110     C     DDACTN        ANDEQ     'I'
028000211110     C     BFCLAS        OREQ      'C'
028100211110     C*****BFCLAS        OREQ      'K'                                                        CSE022
028200211110     C     BFCLAS        OREQ      'E'
028300211110     C     BFCLAS        OREQ      'X'
028400211110     C                   MOVE      'Y'           ErrorFound
028500211110     C                   MOVEL     'MMA0116'     Msgid1
028600211110     C                   ELSE
028700211110      *
028800211110     C     CustFormat    IFEQ      'N'
028900211110     C                   MOVEL     *BLANKS       DDCUST
029000211110     C                   MOVEL     BBCUST        DDCUST
029100211110     C                   ELSE
029200211110     C                   MOVEL     BBCSSN        DDCUST
029300211110     C                   ENDIF
029400211110      *
029500211110     C                   ENDIF
029600211110      *                  (End of 'If invalid Classification')
029700211110      *
029800211110     C                   ENDIF
029900211110      *                  (End of 'If Rtrn Code from AOSECSR0 <> Blank')
030000211110      *
030100211110     C                   ENDIF
030200211110      *                  (End of 'If Rtrn Code from AOCUSTR1 <> Blank')
030300211110      *
030400211110     C                   IF        CSD025 = 'Y'                                               CSD025
030500211110     C                             and BBDEAC = 'Y' and DDACTN = 'I'                          CSD025
030600211110                                                                                              CSD025
030700211110     C                   EVAL      ErrorFound = 'Y'                                           CSD025
030800211110     C                   MOVEL     'ABM0028'     MSGID1                                       CSD025
030900211110                                                                                              CSD025
031000211110     C                   ENDIF                                                                CSD025
031100211110                                                                                              CSD025
031200211110      **  If no errors so far
031300211110      *
031400211110     C     ErrorFound    IFNE      'Y'
031500211110      *
031600211110      **  Check that the customer is not a parent
031700211110      *
031800211110     C     BBPAIN        IFEQ      'P'
031900211110     C                   MOVE      'Y'           ErrorFound
032000211110     C                   MOVEL     'MMM0206'     Msgid1
032100211110     C                   ENDIF
032200211110      *
032300211110      ** Check for bank/non bank and deal types
032400211110      *
032500211110     C     BBBNBI        IFEQ      'Y'
032600211110      *
032700211110      ** Customer is a bank
032800211110      ** If AllowBNBCpty is 'Y, bypass the validation for bank                                CDL063
032900211110      *
033000211110     C     AllowBNBCpty  IFNE      'Y'                                                        CDL063
033100211110     C     DDTYPE        IFEQ      'TD'
033200211110     C     DDTYPE        OREQ      'TI'
033300211110     C                   MOVE      'Y'           ErrorFound
033400211110     C                   MOVEL     'MMM1064'     Msgid2
033500211110     C                   ENDIF
033600211110     C                   ENDIF                                                                CDL063
033700211110      *
033800211110     C                   ELSE
033900211110      *
034000211110      ** If AllowBNBCpty is 'Y, bypass the validation for non-bank                            CDL063
034100211110      *                                                                                       CDL063
034200211110     C     AllowBNBCpty  IFNE      'Y'                                                        CDL063
034300211110     C     DDTYPE        IFEQ      'IP'
034400211110     C     DDTYPE        OREQ      'IT'
034500211110     C                   MOVE      'Y'           ErrorFound
034600211110     C                   MOVEL     'MMM1065'     Msgid2
034700211110     C                   ENDIF
034800211110     C                   ENDIF                                                                CDL063
034900211110     C                   ENDIF
035000211110      *                  (End of 'If customer is a bank')
035100211110      *
035200211110     C                   ENDIF
035300211110      *                  (End of 'If no errors found so far')
035400211110      *
035500211110      **  If the customer is valid, update output fields
035600211110      *
035700211110     C     ErrorFound    IFNE      'Y'
035800211110     C                   MOVEL     BBCUST        IKCNUM
035900211110     C                   MOVE      BBCSSN        IKCSNM
036000211110     C                   ELSE
036100211110     C**********         Z-ADD     0             IKCNUM                                       CSD027
036200211110     C                   EVAL      IKCNUM = *BLANKS                                           CSD027
036300211110     C                   MOVE      *BLANKS       IKCSNM
036400211110     C                   ENDIF
036500211110      *
036600211110     C                   ENDIF
036700211110      *                  (End of 'If Customer not blank')
036800211110      *
036900211110     C                   IF        ErrorFound = 'Y'
037000211110     C                   EVAL      RetCodeIn = 'Error'
037100211110     C                   ENDIF
037200211110      *
037300211110     C                   RETURN
037400211110
037500211110      *****************************************************************
037600211110      /EJECT
037700211110      *****************************************************************
037800211110      *                                                               *
037900211110      * *INZSR - Program Initialisation routine                       *
038000211110      *                                                               *
038100211110      * Called by: Main processing                                    *
038200211110      *                                                               *
038300211110      * Calls: None                                                   *
038400211110      *                                                               *
038500211110      *****************************************************************
038600211110
038700211110     C     *INZSR        BEGSR
038800211110
038900211110     C     *entry        PLIST
039000211110     C                   PARM                    RetCodeIn
039100211110     C                   PARM                    Msgid1
039200211110     C                   PARM                    Msgid2
039300211110     C                   PARM                    CustFormat        1
039400211110     C                   PARM                    DDACTN            1
039500211110     C                   PARM                    DDCUST
039600211110     C                   PARM                    DDTYPE
039700211110     C                   PARM                    IKCNUM
039800211110     C                   PARM                    IKCSNM
039900211110     C                   PARM                    SDCUST
040000211110
040100211110      ** Check if CSD025 (Customer De-Activation) is active                                   CSD025
040200211110      *                                                                                       CSD025
040300211110     C                   CALLB     'AOSARDR0'                                                 CSD025
040400211110     C                   PARM      *BLANKS       PRtCd             7                          CSD025
040500211110     C                   PARM      '*VERIFY'     POptn             7                          CSD025
040600211110     C                   PARM      'CSD025'      PSARD             6                          CSD025
040700211110     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD025
040800211110                                                                                              CSD025
040900211110     C                   MOVE      'N'           CSD025            1                          CSD025
041000211110     C                   IF        PRtCd = *Blanks                                            CSD025
041100211110     C                   EVAL      CSD025 = 'Y'                                               CSD025
041200211110     C                   ENDIF                                                                CSD025
041300211110                                                                                              CSD025
041400211110      ** Check current setting for 'AllowBankNBankCpty' system value  is active               CDL063
041500211110      *                                                                                       CDL063
041600211110     C                   CALL      'AOSVALR0'                                                 CDL063
041700211110     C                   PARM      *BLANKS       PRtcd                                        CDL063
041800211110     C                   PARM      SysVal1       SValK1                                       CDL063
041900211110     C                   PARM                    SVal1                                        CDL063
042000211110     C                   PARM                    SValK2                                       CDL063
042100211110     C                   PARM                    SVal2                                        CDL063
042200211110     C                   PARM                    SValK3                                       CDL063
042300211110     C                   PARM                    SVal3                                        CDL063
042400211110     C                   PARM                    SValK4                                       CDL063
042500211110     C                   PARM                    SVal4                                        CDL063
042600211110     C                   PARM                    SValK5                                       CDL063
042700211110     C                   PARM                    SVal5                                        CDL063
042800211110     C                   PARM                    SValK6                                       CDL063
042900211110     C                   PARM                    SVal6                                        CDL063
043000211110     C                   PARM                    SValK7                                       CDL063
043100211110     C                   PARM                    SVal7                                        CDL063
043200211110     C                   PARM                    SValK8                                       CDL063
043300211110     C                   PARM                    SVal8                                        CDL063
043400211110     C                   PARM                    SValK9                                       CDL063
043500211110     C                   PARM                    SVal9                                        CDL063
043600211110     C                   PARM                    SValK0                                       CDL063
043700211110     C                   PARM                    SVal10                                       CDL063
043800211110                                                                                              CDL063
043900211111     C                   IF        PRtcd = *Blanks                                            CDL063
044000211111     C                   EVAL      AllowBNBCpty = SVal1                                       CDL063
044700211111     C                   ENDIF                                                                CDL063
044701211111                                                                                              CDL063
044800211111
045000211110      ** Program, module and procedure names for database error processing.
045100211110      ** =================================================================
045200211110      ** The following /COPY sets these values, and also defines LDA as
045300211110      ** an external data area
045400211110
045500211110     C/COPY ZACPYSRC,DBFIELDS
045600211110
045700211110     C                   ENDSR                                                  *** InzEnd ***
045800211110      *****************************************************************
045900211110      /EJECT
046000211110      ********************************************************************
046100211110     C/COPY ZACPYSRC,PSSR_ILE
046200211110      ********************************************************************
046300211110**  CPY@
046400211110(c) Finastra International Limited 2001
