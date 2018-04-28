     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Read')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDCUSDRED - CUSTOMER DETAILS READ                            *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Customer file.                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 249076             Date 03Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12342           Date 27Oct06               *
      *                 BUG11934           Date 21Aug06               *
      *                 BUG11828           Date 13Aug06               *
      *                 CSD027             Date 05Jan06               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 215524             Date 19Jun03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034   *CREATE   Date 25May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249076 - Enhance error message S270004 to show character     *
      *           and position that is not allowed in SDSVALPD.       *
      *  BUG12342 - Database Error when accepting Customer            *
      *  BUG11934 - Screen did not move when pressing F8              *
      *  BUG11828 - If CSD031 is on, System Values are defined        *
      *             centrally.                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  215524 - Amendment possible to closed customers. Skipped     *
      *           closed customers when action is amend.              *
      *  CAP034 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      * Customer Details File
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BBREBF:CUSNUM)
                                                                                            BUG12342
      ** Customder Details Acceptance File                                                  BUG12342
     FSDACSTL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG12342
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG11828
      ** External DS for Switchable Feature Details                                         BUG11828
                                                                                            BUG11828
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for calling AOSVALR0 (Midas System Value Access Object)                   CSD027
     D PRetCode        S              7A                                                      CSD027
     D PSysValK1       S             20A                                                      CSD027
     D PSysVal1        S            200A                                                      CSD027
     D PSysValK2       S             20A                                                      CSD027
     D PSysVal2        S            200A                                                      CSD027
     D PSysValK3       S             20A                                                      CSD027
     D PSysVal3        S            200A                                                      CSD027
     D PSysValK4       S             20A                                                      CSD027
     D PSysVal4        S            200A                                                      CSD027
     D PSysValK5       S             20A                                                      CSD027
     D PSysVal5        S            200A                                                      CSD027
     D PSysValK6       S             20A                                                      CSD027
     D PSysVal6        S            200A                                                      CSD027
     D PSysValK7       S             20A                                                      CSD027
     D PSysVal7        S            200A                                                      CSD027
     D PSysValK8       S             20A                                                      CSD027
     D PSysVal8        S            200A                                                      CSD027
     D PSysValK9       S             20A                                                      CSD027
     D PSysVal9        S            200A                                                      CSD027
     D PSysValK10      S             20A                                                      CSD027
     D PSysVal10       S            200A                                                      CSD027
      *                                                                                       CSD027
      * For holding the system values                                                         CSD027
     DWCusAlphaAllow   S            200A                                                      CSD027
     DWCusAlphaSupNum  S            200A                                                      CSD027
      *                                                                                       CSD027
      ** Parameters for calling SDCUSTISO (Validate Customer Number)                          CSD027
     D PCust           S              6A                                                      CSD027
     D PValid          S              6A                                                      CSD027
     D PCheckDigit     S              1A                                                      CSD027
                                                                                            BUG11828
      ** Access Object Parameters                                                           BUG11828
     D PRtcd           S              7A                                                    BUG11828
     D POptn           S              7A                                                    BUG11828
     D PSARD           S              6A                                                    BUG11828
                                                                                            BUG11828
      ** Switchable Features                                                                BUG11828
     D CSD037          S              1A                                                    BUG11828
 
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
      *
      * INITIALIZE OUTPUTS
      *
     C                   MOVEL     *BLANK        @ERRMS
     C                   MOVEL     *BLANK        @CURED
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * VALIDATE CUSTOMER REF. (FOR POINTER)
      *
     C                   EXSR      VALTRF
      *
      ** Initialize work variable for closure status.                                         215524
      *                                                                                       215524
     C                   MOVEL     *BLANK        WCLOSE            1                          215524
      *                                                                                       215524
      * READ FORWARDS
      *
     C     @RDFWD        IFEQ      'Y'
     C                   EXSR      RDFWD
     C                   ELSE
      *
      * READ BACKWARDS
      *
     C     @RDBCK        IFEQ      'Y'
     C                   EXSR      RDBCK
     C                   END
     C                   END
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDFWD - READ FORWARDS THROUGH CUSTOMER FILE
      *****************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
      *
     C                   IF        PAccMde <> 'A'                                           BUG12342
     C     @@CUST        SETGT     CUSNUM
     C                   ELSE                                                               BUG12342
     C     @@CUST        SETGT     SDCUSTD0                                                 BUG12342
     C                   ENDIF                                                              BUG12342
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     BBCUST        ORNE      *BLANKS
     C     @@ERR         ANDEQ     *ZERO
     C     BBDTDL        ANDEQ     *ZERO
     C     WCLOSE        ANDNE     'Y'                                                        215524
      *
      * Read
     C                   IF        PAccMde <> 'A'                                           BUG12342
     C                   READ      CUSNUM                                 99
     C                   ELSE                                                               BUG12342
     C                   READ      SDCUSTD0                               99                BUG12342
     C                   ENDIF                                                              BUG12342
      *
     C                   MOVE      *BLANK        WCLOSE                                       215524
     C     BBCLST        IFEQ      'Y'                                                        215524
     C     DDACTN        ANDEQ     'A'                                                        215524
     C                   MOVE      'Y'           WCLOSE                                       215524
     C                   ENDIF                                                                215524
     C                   ENDDO
      *
      * If end of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C     DDCUSN        IFEQ      *BLANKS
     C                   MOVEL     'MMM1006'     @ERRMS
     C                   ELSE
     C                   MOVEL     'MMM1002'     @ERRMS
     C                   END
      *
      * Else, return the custo reference read
      *
     C                   ELSE
     C                   MOVE      BBCUST        @CURED
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - READ BACKWARDS THROUGH CUSTOMER FILE
      *****************************************************************
     C     RDBCK         BEGSR
      *
      * Position to current record on file
      *
     C                   IF        PAccMde <> 'A'                                           BUG12342
     C     @@CUST        SETLL     CUSNUM
     C                   ELSE                                                               BUG12342
     C     @@CUST        SETLL     SDCUSTD0                                                 BUG12342
     C                   ENDIF                                                              BUG12342
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     BBCUST        ORNE      *BLANKS
     C     @@ERR         ANDEQ     *ZERO
     C     BBDTDL        ANDEQ     *ZERO
     C     WCLOSE        ANDNE     'Y'                                                        215524
      *
      * Read authorized/not authorized
      *
     C                   IF        PAccMde <> 'A'                                           BUG12342
     C                   READP     CUSNUM                                 99
     C                   ELSE                                                               BUG12342
     C                   READP     SDCUSTD0                               99                BUG12342
     C                   ENDIF                                                              BUG12342
      *
     C                   MOVE      *BLANK        WCLOSE                                       215524
     C     BBCLST        IFEQ      'Y'                                                        215524
     C     DDACTN        ANDEQ     'A'                                                        215524
     C                   MOVE      'Y'           WCLOSE                                       215524
     C                   ENDIF                                                                215524
     C                   END
      *
      * If start of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'MMM1003'     @ERRMS
      *
      * Else, return the custo reference read
      *
     C                   ELSE
     C                   MOVE      BBCUST        @CURED
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALTRF - VALIDATE CUSTO REFERENCE POINTER
      *****************************************************************
     C     VALTRF        BEGSR
      *
      **  Validate that the custo ref is numeric or blank.
      *
     C                   TESTN                   DDCUSN               98
     C                   MOVE      DDCUSN        @@TEST            1
     C                   TESTZ                   @@TEST                   99
      *
      ** If Alphanumeric Customer Numbers are enabled                                         CSD027
     C                   If        WCusAlphaAllow = 'Y'                                       CSD027
     C                   Eval      PCust = DDCUSN                                             CSD027
     C                   Eval      PValid = *BLANKS                                           CSD027
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO                                  CSD027
      * If Error                                                                              CSD027
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)                    CSD027
     C                   Eval      DBFILE = 'SDCUSTISO'                                       CSD027
     C                   Eval      DBASE = 902                                                CSD027
     C                   Eval      DBKEY = PCust                                              CSD027
     C                   ExSr      *PSSR                                                      CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C*****DDCUSN        IFEQ      *BLANKS                                                    CSD027
     C******IN98         OREQ      '1'                                                        CSD027
     C******IN99         ANDEQ     '1'                                                        CSD027
     C**********         MOVE      DDCUSN        @@CUST            6                          CSD027
      **********                                                                              CSD027
      * RETURN ERROR MESSAGE                                                                  CSD027
      **********                                                                              CSD027
     C**********         ELSE                                                                 CSD027
     C**********         MOVEL     'MMM0162'     @ERRMS                                       CSD027
     C**********         RETURN                                                               CSD027
     C**********         END                                                                  CSD027
      *                                                                                       CSD027
      * Check if Customer# is valid                                                           CSD027
     C                   If        DDCUSN = *BLANKS                                           CSD027
     C                             Or                                                         CSD027
     C                             (WCusAlphaAllow = 'N' And                                  CSD027
     C                              *IN98 = *ON And *IN99 = *ON)                              CSD027
     C                             Or                                                         CSD027
     C                             (WCusAlphaAllow = 'Y' And                                  CSD027
     C                              WCusAlphaSupNum = 'Y' And                                 CSD027
     C                              *IN98 = *ON And *IN99 = *ON)                              CSD027
     C                             Or                                                         CSD027
     C                             (WCusAlphaAllow = 'Y' And                                  CSD027
     C                              WCusAlphaSupNum = 'N' And                                 CSD027
     C                              PValid = *BLANKS)                                         CSD027
     C                             Or                                                       BUG11934
     C                             (WCusAlphaAllow = 'Y' And                                BUG11934
     C                              WCusAlphaSupNum = 'Y' And                               BUG11934
     C                              PValid = *BLANKS)                                       BUG11934
     C                   Move      DDCUSN        @@CUST            6                          CSD027
      * If invalid Customer#, return error message                                            CSD027
     C                   Else                                                                 CSD027
      *                                                                                       CSD027
     C                   If        WCusAlphaAllow = 'N'                                       CSD027
     C                   Eval      @ERRMS = 'S270003'                                         CSD027
     C                   Else                                                                 CSD027
     C                   Eval      @ERRMS = 'S270004'                                         CSD027
     C                   move      *blanks       @data                                        249076
     C                   movel     @datarcv      @data                                        249076
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   Return                                                               CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return Code
      * Action Code
      * Custo Ref. pointer
      * Read Forwards
      * Read Backwards
     C                   PARM                    RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    DDCUSN            6
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
     C                   PARM                    PAccMde           1                        BUG11934
      * OUTPUT PARAMETERS :
      * Error meassage
      * Custo Ref. Read
     C                   PARM                    @ERRMS            7
     C                   PARM                    @data            45                          249076
     C                   PARM                    @CURED            6
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUSDRED'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                            BUG11828
      ** Check if CSD037 is on.                                                             BUG11828
                                                                                            BUG11828
     C                   CALL      'AOSARDR0'                                               BUG11828
     C                   PARM      *BLANKS       PRtCd                                      BUG11828
     C                   PARM      '*VERIFY'     POptn                                      BUG11828
     C                   PARM      'CSD037'      PSARD                                      BUG11828
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG11828
                                                                                            BUG11828
     C                   IF        PRtCd = *BLANKS                                          BUG11828
     C                   EVAL      CSD037 = 'Y'                                             BUG11828
     C                   ELSE                                                               BUG11828
                                                                                            BUG11828
     C                   IF        PRtCd <> '*NRF   '                                       BUG11828
     C     *LOCK         IN        LDA                                                      BUG11828
     C                   EVAL      DBFile = 'SCSARDPD'                                      BUG11828
     C                   EVAL      DBKey = POptn                                            BUG11828
     C                   EVAL      DBase = 101                                              BUG11828
     C                   OUT       LDA                                                      BUG11828
     C                   EXSR      *PSSR                                                    BUG11828
     C                   ENDIF                                                              BUG11828
                                                                                            BUG11828
     C                   ENDIF                                                              BUG11828
      *
      ** Parameter list for calling AOSVALR0                                                  CSD027
     C     P_AOSVALR0    PList                                                                CSD027
      * Return Code (Output)                                                                  CSD027
     C                   Parm                    PRetCode                                     CSD027
      * System Value to be retrieved (Input)                                                  CSD027
     C                   Parm                    PSysValK1                                    CSD027
      * Value returned (Output)                                                               CSD027
     C                   Parm                    PSysVal1                                     CSD027
     C                   Parm                    PSysValK2                                    CSD027
     C                   Parm                    PSysVal2                                     CSD027
     C                   Parm                    PSysValK3                                    CSD027
     C                   Parm                    PSysVal3                                     CSD027
     C                   Parm                    PSysValK4                                    CSD027
     C                   Parm                    PSysVal4                                     CSD027
     C                   Parm                    PSysValK5                                    CSD027
     C                   Parm                    PSysVal5                                     CSD027
     C                   Parm                    PSysValK6                                    CSD027
     C                   Parm                    PSysVal6                                     CSD027
     C                   Parm                    PSysValK7                                    CSD027
     C                   Parm                    PSysVal7                                     CSD027
     C                   Parm                    PSysValK8                                    CSD027
     C                   Parm                    PSysVal8                                     CSD027
     C                   Parm                    PSysValK9                                    CSD027
     C                   Parm                    PSysVal9                                     CSD027
     C                   Parm                    PSysValK10                                   CSD027
     C                   Parm                    PSysVal10                                    CSD027
      *                                                                                       CSD027
      ** Parameter list for calling SDCUSTISO                                                 CSD027
     C     P_SDCUSTISO   PList                                                                CSD027
      ** Customer Number (Input)                                                              CSD027
     C                   Parm                    PCust                                        CSD027
      ** Validity Flags (Output)                                                              CSD027
     C                   Parm                    PValid                                       CSD027
      ** Check Digit (Output)                                                                 CSD027
     C                   Parm                    PCheckDigit                                  CSD027
     C                   Parm                    @datarcv          2                          249076
      *                                                                                       CSD027
      * Retrieve System Value 'CustAlphaAllow' & 'CustAlphaSupNumeric'                        CSD027
     C                   Eval      PRetCode = *BLANKS                                         CSD027
     C                   Eval      PSysValK1 = 'CustAlphaAllow'                               CSD027
     C                   Eval      PSysVal1 = *BLANKS                                         CSD027
     C                   Eval      PSysValK2 = 'CustAlphaSupNumeric'                          CSD027
     C                   Eval      PSysVal2 = *BLANKS                                         CSD027
     C**********         CallB(E)  'AOSVALR0'    P_AOSVALR0                          CSD027 BUG11828
                                                                                            BUG11828
     C                   IF        CSD037 = 'Y'                                             BUG11828
     C                   CALL (E)  'GPAOSVALR0'  P_AOSVALR0                                 BUG11828
     C                   ELSE                                                               BUG11828
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                 BUG11828
     C                   ENDIF                                                              BUG11828
      *                                                                                       CSD027
      * If Error retrieving the System value                                                  CSD027
     C                   If        %Error Or PRetCode <> *BLANKS                              CSD027
     C                             Or (*INU7 = *ON And *INU8 = *ON)                           CSD027
     C                   Eval      DBFILE = 'SDSVALPD'                                        CSD027
     C                   Eval      DBASE = 903                                                CSD027
     C                   Eval      DBKEY = 'CustAlpha(Allow/SupNumeric)'                      CSD027
     C                   ExSr      *PSSR                                                      CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   Eval      WCusAlphaAllow  = PSysVal1                                 CSD027
     C                   Eval      WCusAlphaSupNum = PSysVal2                                 CSD027
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
