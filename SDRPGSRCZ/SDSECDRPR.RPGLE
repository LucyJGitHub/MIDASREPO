     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Invalid securities clients details repair')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSECDRPR - INVALID SECURITY CUSTOMER DETAILS                *
      *              REPAIR FUNCTION                                  *
      *                                                               *
      *  Function:  This function allows invalid Customer details to  *
      *             be 'repaired' and applied to the Midas database.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR1029381          Date 26Sep12               *      
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 243070             Date 10Jul06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK024             Date 13Feb06               *
      *                 CSE070             Date 15Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2254            Date 06May04               *
      *                 CGL029             Date 03Sep01               *
      *                 CSE042             Date 05Feb03               *
      *                 CSE041             Date 05Feb03               *
      *                 CSE039             Date 05Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 193883             Date 20Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP011             Date 31Mar00               *
      *                 CAP013             Date 31Mar00               *
      *                 CAP014             Date 31Mar00               *
      *                 CAP039  *CREATE    Date 26Oct99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1029381 - Any change to Narrative by option "U" is not     *
      *              updated to file. (Child: AR1029382)              *      
      *  243070 - Recompile over changed PF/SDVSECDPD                 *
      *  CPK024 - Packaging of MPLUS 1.2.1. No need to rename QQACCD  *
      *           as it was already removed by 7453 from SEDECDPD.    *
      *  CSE070 - Repo Coupon Claims Report                           *
      *  CSD025 - Customer De-Activation                              *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG2254 - Recompile over changed PF/SDISECDPD                *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE042 - Auto Feed of Trades and Movements                   *
      *  CSE041 - DVP/RVP Processing                                  *
      *  CSE039 - Automatic Settlement of Trades                      *
      *  CSC011 - 24x7 Midas Availability                             *
      *  193883 - Recompile over changed SDSECDUPD.                   *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP014 - Repair function enhancements                        *
      *  CAP039 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FSDISECDL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDISECDD0:SDISECDX0)
     FSDISECDL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSE022
      ** Midas SD Invalid Customer Depository Reference by Customer no.                       CSE022
     FSDICSDRL0 UF   E           K DISK    INFSR(*PSSR)                                       CSE022
     F                                     COMMIT                                             CSE022
                                                                                              CSC011
      ** API Invalid Log File from Support Database                                           CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDSECDR001
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D @EI             S              1    DIM(60)
 
      ** Array of Fields in error, temporary store
     D TmpFldNmAr      S             10A   DIM(ArrayMax)
      ** Array of error message IDs, temporary store
     D TmpMsgIdAr      S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      * Current Security Customer in File Format
     D CrSCFilFmt    E DS                  EXTNAME(SDSECSPD)
     D                                     PREFIX(C_)
 
      * Current Security Customer in Screen Format
     D CurCuSecd     E DS                  EXTNAME(SDSECDPD)
     D                                     PREFIX(@)
 
      * New Security Customer in File Format
     D NwSCFilFmt    E DS                  EXTNAME(SDVSECDPD)
 
      * New Security Customer in Screen Format
     D NewCuSecd     E DS                  EXTNAME(SDSECDPD)
     D*NwCuSeACCD    E                     EXTFLD(QQACCD)                              CGL029 CPK024
 
 
 
      * Previous Security Customer in Screen Format
     D*PrvCuSecd     E DS                  EXTNAME(SDCUPRPD)                                  CSE022
     D PrvCuSecd     E DS                  EXTNAME(SDSECDPD)                                  CSE022
     D                                     PREFIX(@P)
 
     D OKSecDets2    E DS                  EXTNAME(SDESECD2PD)                                CSE039
      * Error indicators                                                                      CSE039
                                                                                              CSE039
 
      * Error indicators
     D OKCuSecd      E DS                  EXTNAME(SDESECDPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** EXTERNAL DS FOR API ICD                                                CAP011
                                                                                CAP011
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D DepotSn         S             10    DIM(10)
      ** Depot shortnames array
 
     D ExtData       E DS                  EXTNAME(SDSEEXPD)
      * SD Custom Extra Data - File (D/B) format
 
      ** Changed Party Names Array
     D ChgNamArr       S              1    DIM(5)
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Customer Shortname
     D DDCSSN          S             10A
 
      ** Customer Number / Shortname
     D DDCSST          S             10A
 
      ** Customer Report Town
     D DDCRTN          S             10A
 
      ** Customer Report Name
     D DDCRNM          S             20A
                                                                                              CSE022
      ** Depository Definition Enhancement Indicator                                          CSE022
     D CSE022          S              1A                                                      CSE022
                                                                                              CSE022
      ** Automatic Setllement of Trades Indicator                                             CSE039
     D CSE039          S              1A                                                      CSE039
                                                                                              CSE039
      ** DVP/RVP Processing Indicator                                                         CSE041
     D CSE041          S              1A                                                      CSE041
                                                                                              CSE041
      ** Auto Feed of Trades and Movements Indicator                                          CSE042
     D CSE042          S              1A                                                      CSE042
                                                                                              CSE042
      ** F11 Depot Reference                                                                  CSE022
     D @INKK           S              1A                                                      CSE022
                                                                                              CSE022
      ** Condition availability of F11 (Depot References)                                     CSE022
     D @EINKK          S              1A                                                      CSE022
                                                                                              CSE022
      ** Return code for SDC100001                                                            CSE022
     D PRTCD           S             10A                                                      CSE022
     D PModeOfOp       S              3A   INZ('RPR')                                         CSE022
                                                                                              CSE022
      ** Work Variable for CSE022                                                             CSE022
     D WActnOk         S              1A   INZ('Y')                                           CSE022
     D WCustOk         S              1A   INZ('Y')                                           CSE022
     D WkCnt           S              3P 0                                                    CSE022
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D FormatA         S             10A   INZ('SDSECDPD')
 
     D FieldA          S             10A   INZ('DDCLAS')
 
     D FldOffsetA      S              5P 0
 
     D FieldNo         S              5P 0
 
      ** End of fields for getting starting field number
 
      ** -------------------------------------------------------------------
 
     D WKCUST          S                   LIKE(DDCUSN)
                                                                                CAP011
      ** Flags to indicate whether substitution is required in                  CAP011
      ** each of the various parts the transaction                              CAP011
     D RepSecd         S              1A   inz('N')                             CAP011
                                                                                              CSC011
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
                                                                                              CSC011
      ** -------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDSECDR002
 
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
      /COPY WNCPYSRC,SDSECDR003
      *
      * Issue rollback to clear any possible updates in window functions
      *
     C     @INKL         IFEQ      '1'
     C                   ROLBK
     C                   END
      *
      /COPY WNCPYSRC,SDSECDR004
      *
      * DO SCREEN: BROWSE INVALID Inputs
      *
     C     @SCRN         IFEQ      'I'
     C                   EXSR      SCRN@I
     C                   END
      *
      /COPY WNCPYSRC,SDSECDR005
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDSECDR006
      *
      ** DO WHILE screen
      *
     C                   EXSR      SNDM@A
     C     @SCRN         DOWEQ     'A'
     C                   EXSR      SCRN@A
     C                   ENDDO
      *                                                                                       CSE039
      ** Do while screen: Securities Clients Detail Screen 2                                  CSE039
      *                                                                                       CSE039
     C     @SCRN         DOWEQ     'F'                                                        CSE039
     C                   EXSR      SCRN@F                                                     CSE039
     C                   ENDDO                                                                CSE039
      *
      /COPY WNCPYSRC,SDSECDR011
      *
      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDSECDR012
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDSECDR013
 
      /EJECT
      *****************************************************************
      * SCRN@I - BROWSE INVALID CUSTOMERS
      *****************************************************************
     C     SCRN@I        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'SDSECDRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *
      * Error in update of previous deal
     C                   PARM                    @ERRUP            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM                    @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM                    @FOTRANSEL       20
      *
      * Customer Number
     C                   PARM      *blanks       DDCUSN
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
                                                                                              CSC011
      ** CSC011 Enhancement is installed                                                      CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      * If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   END
      *
      * If CK/3 or CK/12 taken in browse, or error message
      * End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDA
     C                   GOTO      ESCRN@I
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@I       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'SDSECDRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL
      *
      * Error in update of previous deal
     C                   PARM                    @ERRUP
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL
      *
      * ACTION SELECTED
     C                   PARM      *BLANK        @ACSEL
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOTRANSEL
      *
      * CUSTOMER NUMBER
     C                   PARM      *BLANK        DDCUSN
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
                                                                                              CSC011
      ** CSC011 Enhancement is installed                                                      CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      * If CK/3 taken within invalid transaction deletion function,
      * End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDA
     C                   GOTO      ERDNBRW
     C                   END
      *
      * IF INVALID CUSTOMER READ FROM SUBFILE
      *
     C     @OPSEL        IFNE      *BLANK
      *
      * Clear file formats
     C                   CLEAR                   NwSCFilFmt
      *
      * BLANK THE SCREENS
      *
     C                   Eval      WKCUST = DDCUSN
     C                   CLEAR                   NewCuSecd
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       OKCuSecd
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      * Retrieve Customer details
      *
     C                   Eval      DDCUSN =WKCUST
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    SEFRNT
     C*******************MOVEL     '*FRONT'      @@MODE                         CAP013
      *                                                                         163820
      * Make sure Invalid transaction's  details are passed to 'Retreive'       163820
      * module for SPF checking .                                               163820
      *                                                                         163820
     C     ZATRNKX0      CHAIN     SDISECDX0                          99        163820
      *                                                                         163820
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C     DDCUSN        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      @@MODE                         CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   EXSR      RTVCUS
      *
      * If Security Customer details were retrieved
      * Convert to screen format.
      *
     C     C_BFCUST      IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C                   EXSR      CVTCUS
     C                   MOVEL     CrSCFilFmt    NwSCFilFmt
     C                   END
      *
      * Now overwite the fields on the main details screen with those
      * on the invalid Customers file (except for the Midas Customer
      * reference retrieved above using the front office transaction ID).
      * Access invalid deal with timestamp and front office transaction ID.
      *
      * Customer details:
     C                   MOVEL     DDCUSN        ##DDCUSN          6
     C     ZATRNKX0      CHAIN     SDISECDX0                          99
     C                   MOVEL     DDNDR1        DDDRF1                                       CSE022
     C                   MOVEL     DDNDR2        DDDRF2                                       CSE022
      *                                                                         CAP011
      * If Customer details were retrieved and this is an amendment             CAP011
      *                                                                         CAP011
     C     C_BFCUST      IFNE      *BLANK                                       CAP011
     C     DDACTN        ANDEQ     'A'                                          CAP011
                                                                                CAP011
      * Data Substitution - Transaction Details                                 CAP011
                                                                                CAP011
     C     GHSUBS        ifne      *blank                                       CAP011
                                                                                CAP011
     C     GHSUBS        SCAN      NewCuSecD                              99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepSecD = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
      ** If any of the flags set above is true, do the data                     CAP011
      ** substution subroutine.                                                 CAP011
     C                   if        (RepSecD = 'Y')                              CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   END                                                    CAP011
                                                                                CAP011
                                                                                CAP011
     C                   END                                                    CAP011
      *
      * If action code, or Customer reference were NOT OK
      * blank out action code so that the input cannot proceed
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
      *
      * Send the Customers error messages to the details screen
      * and GO TO DETAILS SCREEN
      *
     C                   EXSR      SNDM@A
     C                   MOVE      'A'           @SCRN
 
      * ELSE IF NO INVALID Customer READ FROM SUBFILE
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'I'           @SCRN
     C                   END
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@A - SEND A MESSAGE TO DETAILS SCREEN
      *****************************************************************
     C     SNDM@A        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C                   ADD       1             E
      *
      * Ensure that the message 'TRANSACTION CANNOT PROCEED' is seen
      * first by the user
      *
     C                   Eval      TmpfldNmAr = *BLANKS
     C                   Eval      TmpMsgIdAr = *BLANKS
     C                   MOVEA     FldNameArr    TmpFldNmAr
     C                   MOVE      *BLANKS       FldNameArr(1)
     C                   MOVEA     TmpFldNmAr    FldNameArr(2)
     C                   MOVEA     MsgIdArr      TmpMsgIdAr
     C                   MOVE      *BLANKS       MsgIdArr(1)
     C                   MOVEA     TmpMsgIdAr    MsgIdArr(2)
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM0110'     MsgIdArr(1)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKCuSecd      @EI
      *
      ** Read error messages for Customer
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    FormatA
     C                   PARM                    ABFIELDNAM
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetA    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
      *
     C                   MOVEA     @EI           OKCuSecd
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@A - PROCESS SCREEN
      *****************************************************************
     C     SCRN@A        BEGSR
      *
      * Enable/disable detail fields on primary details screen
      * if changes to the data are allowed                                      CAP014
      * (key fields = action code & Customer reference; detail fields = rest)
      * (Action code can only be 'I', 'A', 'D', or 'E')                         CAP014
      *
     C     DDACTN        IFEQ      'I'                                          CAP014
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C     DDACTN        OREQ      'A'                                          CAP014
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C                   MOVEL     'Y'           @EDTFD                         CAP014
     C                   ELSE                                                   CAP014
     C                   MOVEL     'N'           @EDTFD                         CAP014
     C                   END                                                    CAP014
      *                                                                         CAP014
      * KJ = COMMAND KEY 10 = CONFIRM DELETE                                    CAP014
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
 
      * Update 'previous' screen
     C                   MOVEL     NewCuSecd     PrvCuSecd
      *
      * Set function key status on PRIMARY screen
     C                   EXSR      SFKEYS
      *
      ** WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'SDSECDDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Customer (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewCuSecd
      *
      * Fields in error
     C                   PARM                    OKCuSecd
 
      ** Customer Shortname
     C                   PARM                    DDCSSN
 
      ** Customer Report Name
     C                   PARM                    DDCRNM
 
      ** Customer Report Town
     C                   PARM                    DDCRTN
 
      ** Depot Shortnames Array
     C                   PARM                    DepotSn
 
      ** Called from customer details module or direct from Midas menu
     C                   PARM      *blanks       SDSECDcall        1
 
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *                                                                         CAP014
      * ENABLED KEY & DETAIL FIELDS                                             CAP014
      *                                                                         CAP014
     C                   PARM      'N'           @EKYFD            1            CAP014
     C                   PARM                    @EDTFD            1            CAP014
      *                                                                         CAP014
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KX = COMMAND KEY 23 = FURTHER DETAILS
      * KK = Other Depot References details                                                   CSE022
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKK                                       CSE022
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKK                                        CSE022
     C                   PARM      '0'           @INKL             1
      *
      * RESET ERRORS ....
      *
                                                                                              CSE022
     C                   EVAL      WActnOk = DDACTNOK                                         CSE022
     C                   EVAL      WCustOk = DDCUSNOK                                         CSE022
     C                   MOVE      *ALL'Y'       OKCuSecd
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDA
                                                                                              CSE022
      ** F11 - Other Depot References details                                                 CSE022
     C     @INKK         CASEQ     '1'           SRDepRef                                     CSE022
      *
      * F12 - Cancel on Screen
     C     @INKL         CASEQ     '1'           CANC@A
      *
      * Validate input to screen
     C                   CAS                     VAL@A
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@A  - VALIDATE INPUT TO DETAILS SCREEN
      *****************************************************************
     C     VAL@A         BEGSR
      *
      * Retrieve Security Customer details
      *
     C                   EXSR      RTVCUS
      *
      * If action code, or Customer reference are NOT OK
      * Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C                   GOTO      EndVAL@A
     C                   END
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EndVAL@A
     C                   END
      *
      *----------------------------------------------------------------
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Customer in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   MOVE      *ALL'Y'       OKCuSecd
     C                   CLEAR                   NwSCFilFmt
      *
      * Validate Security Customer details
      *
     C                   CALLB     'SDSECDVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
 
      * Response mode
     C                   PARM                    RespMode
 
      ** Customer Primary Details
     C                   PARM                    NewCuSecd
                                                                                              CSE039
      ** Automatic Settlement of Trades                                                       CSE039
     C                   PARM                    CSE039                                       CSE039
 
      * OUTPUTS :
 
      ** Customer Primary Details OK inds
     C                   PARM                    OKCuSecd
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Valid Customer layout (DS) from/to caller
     C                   PARM                    NwSCFilFmt
      *
      * If errors returned
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@A
     C                   END
      *
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      * re-display the screen
      *
     C     NewCuSecd     IFNE      PrvCuSecd
     C                   GOTO      EndVAL@A
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKCuSecd
     C                   MOVE      'U'           @SCRN
      *                                                                                       CSE039
      * Display second screen if feature is on                                                CSE039
      *                                                                                       CSE039
     C     CSE039        IFEQ      'Y'                                                        CSE039
     C     CSE041        OREQ      'Y'                                                        CSE041
     C     CSE042        OREQ      'Y'                                                        CSE042
      *                                                                                       CSE039
      * Display second screen if Classification is 'S' or 'D'                                 CSE039
     C     SECLAS        IFEQ      'S'                                                        CSE039
     C     SECLAS        OREQ      'D'                                                        CSE039
     C                   MOVE      'F'           @SCRN                                        CSE039
     C                   ENDIF                                                                CSE039
     C                   ENDIF                                                                CSE039
      *
     C     EndVAL@A      ENDSR
      *****************************************************************
      /EJECT                                                                                  CSE039
      *****************************************************************                       CSE039
      * SCRN@F - PROCESS DETAIL SCREEN 2                                                      CSE039
      *****************************************************************                       CSE039
     C     SCRN@F        BEGSR                                                                CSE039
                                                                                              CSE039
      ** WRITE/READ DISPLAY SCREEN 2 - Secondary Details                                      CSE039
                                                                                              CSE039
     C                   CALLB     'SDSECD2DP'                                                CSE039
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                                CSE039
      * INPUT PARAMETERS :                                                                    CSE039
                                                                                              CSE039
      * Return code                                                                           CSE039
     C                   PARM      *BLANKS       RetCodeOut                                   CSE039
                                                                                              CSE039
      ** Security Details in screen format                                                    CSE039
     C                   PARM                    NewCuSecd                                    CSE039
                                                                                              CSE039
      ** Security Details screen 2 OK indicators                                              CSE039
     C                   PARM                    OKSecDets2                                   CSE039
                                                                                              CSE039
      ** Customer Shortname                                                                   CSE039
     C                   PARM                    DDCSSN                                       CSE039
                                                                                              CSE039
      ** Customer Report Name                                                                 CSE039
     C                   PARM                    DDCRNM                                       CSE039
                                                                                              CSE039
      ** Customer Report Town                                                                 CSE039
     C                   PARM                    DDCRTN                                       CSE039
                                                                                              CSE039
      ** Called from Customer Details Module                                                  CSE039
     C                   PARM                    SDSECDcall                                   CSE039
                                                                                              CSE039
      ** Automatic Settlement of Trades                                                       CSE039
     C                   PARM                    CSE039                                       CSE039
                                                                                              CSE039
      ** DVP/RVP Processing                                                                   CSE041
     C                   PARM                    CSE041                                       CSE041
                                                                                              CSE041
      ** Auto Feed of Trades and Movements                                                    CSE042
     C                   PARM                    CSE042                                       CSE042
                                                                                              CSE039
                                                                                              CSE039
      * ERRORS                                                                                CSE039
     C                   PARM                    FldNameArr                                   CSE039
     C                   PARM                    MsgIdArr                                     CSE039
     C                   PARM                    MsgDtaArr                                    CSE039
                                                                                              CSE039
      *                                                                                       CSE039
      * ENABLED KEY & DETAIL FIELDS                                                           CSE039
      *                                                                                       CSE039
     C                   PARM                    @EKYFD            1                          CSE039
     C                   PARM                    @EDTFD            1                          CSE039
                                                                                              CSE039
      * OUTPUT PARAMETERS :                                                                   CSE039
                                                                                              CSE039
      * Function Keys                                                                         CSE039
     C                   PARM      '0'           @INKC                                        CSE039
     C                   PARM      '0'           @INKL                                        CSE039
                                                                                              CSE039
      * Reset Errors                                                                          CSE039
                                                                                              CSE039
     C                   MOVE      *ALL'Y'       OKSecDets2                                   CSE039
     C                   MOVEL     *BLANK        FldNameArr                                   CSE039
     C                   MOVEL     *BLANK        MsgIdArr                                     CSE039
     C                   MOVEL     *BLANK        MsgDtaArr                                    CSE039
                                                                                              CSE039
      *                                                                                       CSE039
      * F3 - End Program                                                                      CSE039
     C     @INKC         CASEQ     '1'           ENDA                                         CSE039
      *                                                                                       CSE039
      * F12 - Cancel on Details Screen 2                                                      CSE039
     C     @INKL         CASEQ     '1'           CANC@F                                       CSE039
      *                                                                                       CSE039
      * Validate Input to Details Screen 2                                                    CSE039
     C                   CAS                     VAL@F                                        CSE039
                                                                                              CSE039
     C                   ENDCS                                                                CSE039
                                                                                              CSE039
                                                                                              CSE039
     C                   ENDSR                                                                CSE039
      *****************************************************************                       CSE039
      /EJECT                                                                                  CSE039
      *****************************************************************                       CSE039
      * VAL@F  - VALIDATE INPUT TO DETAILS SCREEN 2                                           CSE039
      *****************************************************************                       CSE039
     C     VAL@F         BEGSR                                                                CSE039
      *                                                                                       CSE039
      * Prior to validation, initialize error indicators as 'OK'                              CSE039
      *                                                                                       CSE039
     C                   Z-ADD     *ZERO         Idx                                          CSE039
     C                   MOVE      *ALL'Y'       OKSecDets2                                   CSE039
     C                   CLEAR                   NwSCFilFmt                                   CSE039
      *                                                                                       CSE039
      * Validate Securities Clients Detail screen 2                                           CSE039
      *                                                                                       CSE039
     C                   CALLB     'SDSECD2VL'                                                CSE039
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                               CSE039
      * INPUTS                                                                                CSE039
                                                                                              CSE039
      * Response mode                                                                         CSE039
     C                   PARM      *BLANK        RespMode                                     CSE039
                                                                                              CSE039
      ** Security Details                                                                     CSE039
     C                   PARM                    NewCuSecd                                    CSE039
                                                                                              CSE039
      ** Automatic Settlement of Trades                                                       CSE039
     C                   PARM                    CSE039                                       CSE039
                                                                                              CSE039
      ** DVP/RVP Processing                                                                   CSE041
     C                   PARM                    CSE041                                       CSE041
                                                                                              CSE041
      ** Auto Feed of Trades and Movements                                                    CSE042
     C                   PARM                    CSE042                                       CSE042
                                                                                              CSE039
      * OUTPUTS                                                                               CSE039
                                                                                              CSE039
      ** Security Details screen 2 OK inds                                                    CSE039
     C                   PARM                    OKSecDets2                                   CSE039
                                                                                              CSE039
      * Error fields/message IDs/message data (arrays) from/to caller                         CSE039
     C                   PARM                    FldNameArr                                   CSE039
     C                   PARM                    MsgIDArr                                     CSE039
     C                   PARM                    MsgDtaArr                                    CSE039
                                                                                              CSE039
      * Array index (3P0) from/to caller                                                      CSE039
     C                   PARM                    Idx                                          CSE039
                                                                                              CSE039
      * Valid Securities Clients details layout (DS) from/to caller                           CSE039
     C                   PARM                    NwSCFilFmt                                   CSE039
                                                                                              CSE039
      *                                                                                       CSE039
      * If errors returned                                                                    CSE039
      *                                                                                       CSE039
     C     Idx           IFNE      0                                                          CSE039
     C                   GOTO      EndVAL@F                                                   CSE039
     C                   END                                                                  CSE039
      *                                                                                       CSE039
      * If the screen has changed in the course of the validation                             CSE039
      * or if there are warnings which have not been displayed                                CSE039
      * re-display the screen                                                                 CSE039
      *                                                                                       CSE039
     C     NewCuSecd     IFNE      PrvCuSecd                                                  CSE039
     C                   GOTO      EndVAL@F                                                   CSE039
     C                   END                                                                  CSE039
      *                                                                                       CSE039
      * Clear any warning messages                                                            CSE039
      *                                                                                       CSE039
     C                   MOVE      *ALL'Y'       OKSecDets2                                   CSE039
                                                                                              CSE039
     C                   MOVE      'U'           @SCRN                                        CSE039
                                                                                              CSE039
     C     EndVAL@F      ENDSR                                                                CSE039
      *****************************************************************                       CSE039
      /EJECT
      *****************************************************************
      * RTVCUS - RETRIEVE Customer
      *****************************************************************
     C     RTVCUS        BEGSR
      *
      * RETRIEVE Customer
      *
     C                   CALLB     'SDSECDRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM      @FOTRANSEL    SEFRNT
      *
      * (Midas) Customer number
     C                   PARM                    DDCUSN            6
      *
      * Key Screen customer number / shortname entry
     C                   PARM                    DDCSST           10
      *
      * OUTPUTS :
      * (Current) Customer in file format
     C                   PARM                    CrSCFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      * OK - Customer Reference
     C                   PARM      *BLANK        DDCUSNOK
      *
      ** Customer Shortname
     C                   PARM                    DDCSSN
 
      ** Customer Report Name
     C                   PARM                    DDCRNM
 
      ** Customer Report Town
     C                   PARM                    DDCRTN
      ** Depot Shortnames Array
     C                   PARM                    DepotSn
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
     C     EndRTVCUS     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTCUS - PUT A Customer ON THE SCREEN
      *****************************************************************
     C     CVTCUS        BEGSR
      *
      * Call program to fill screen fields with data
      *
     C                   CALLB     'SDSECDCVT'
      *
      * INPUTS :
      * Return Code
      * Customer in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrSCFilFmt
      * OUTPUTS
      * Customer - screen formats
     C                   PARM                    NewCuSecd
 
      *
      * Update 'Current' Customer with Customer in Screen Format
      *
     C                   EVAL      DDCUSN =WKCUST                                             CSE022
     C                   EVAL      DDACTN = @ACSEL                                            CSE022
     C                   MOVEL     NewCuSecd     CurCuSecd
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@A - CANCEL ON DETAILS SCREEN
      *****************************************************************
     C     CANC@A        BEGSR
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'I'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSE039
      *****************************************************************                       CSE039
      * CANC@F - CANCEL ON SECOND SCREEN                                                      CSE039
      *****************************************************************                       CSE039
     C     CANC@F        BEGSR                                                                CSE039
      *                                                                                       CSE039
      * Return to previous screen                                                             CSE039
     C                   MOVEL     'A'           @SCRN                                        CSE039
      *                                                                                       CSE039
     C                   ENDSR                                                                CSE039
      *****************************************************************                       CSE039
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
      * Update valid customer: customer reference
      *
     C                   MOVEL     DDCUSN        SECUST
     C                   MOVEL     DDACTN        SETYLC
      *
      ** Carry forward file data to valid file
     C                   Eval      SESRCD = @DDSRCD
     C                   Eval      SENARR = @DDNARR
      *                                                                                    AR1029381
      ** @DDNARR is always empty                                                           AR1029381
      *                                                                                    AR1029381
     C                   Eval      SESRCD = DDSRCD                                         AR1029381
     C                   Eval      SENARR = DDNARR                                         AR1029381
      *
     C     DDACTN        IFEQ      'A'
      ** Carry forward number of trades value to valid file field
     C                   Eval      SENTFC = C_BFNTFC
 
     C                   ELSE
 
     C     DDACTN        IFEQ      'I'
 
      ** Initialise number of trades field for Insert
     C                   Eval      SENTFC = 0
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     *BLANK        @RTCD
      *
      * SECURITIES CUSTOMERS DETAILS UPDATES
      *
     C                   CALLB     'SDSECDUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    NwSCFilFmt
      *
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID Customer ACTIONED & COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'                                    6
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C     ZATRNKD0      CHAIN     SDISECDD0                          99
                                                                                              CSE022
     C                   IF        CSE022 = 'Y' AND *IN99 = *OFF                              CSE022
                                                                                              CSE022
     C                   EVAL      *IN02 = *OFF                                               CSE022
     C                   DOW       *IN02 = *OFF                                               CSE022
                                                                                              CSE022
     C     SECUST        CHAIN     SDICSDRL0                          02                      CSE022
                                                                                              CSE022
     C                   IF        *IN02 = *OFF                                               CSE022
     C                   DELETE    SDICSDRD0                                                  CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE022
     C                   ENDDO                                                                CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE022
     C  N99              DELETE    SDISECDD0
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') and (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'SDSECD'                                        CSC011
     C                   EVAL      KFrntOffID = @FOTRANSEL                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   COMMIT
     C                   END
      *
      * If error occurred in updating last transaction set on flag to
      * display message on 'browse' screen.
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVE      'Y'           @ERRUP
     C                   ELSE
     C                   MOVE      'N'           @ERRUP
     C                   END
     C
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'I'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKEYS - SET FUNCTION KEY STATUS ON SCREEN
      *****************************************************************
     C     SFKEYS        BEGSR
      *
      * Enable/disable function keys
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS CUSTOMER
      * KH = COMMAND KEY 08 = READ NEXT CUSTOMER
      *
     C                   MOVEL     '0'           @INKG
     C                   MOVEL     '0'           @INKH
                                                                                              CSE022
      ** Enable/Disable function key F11 (Other Depot Reference)                              CSE022
                                                                                              CSE022
     C                   IF        CSE022 = 'Y'                                               CSE022
                                                                                              CSE022
     C                   EVAL      @EINKK = 'Y'                                               CSE022
                                                                                              CSE022
     C                   ELSE                                                                 CSE022
                                                                                              CSE022
     C                   EVAL      @EINKK = 'N'                                               CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDA - End Program
      *****************************************************************
     C     ENDA          BEGSR
      *
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     TDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
      ** Substitute the data for the various parts of the transaction,          CAP011
      ** dependent on the flags that were set earlier.                          CAP011
                                                                                CAP011
     C                   if        RepSecD = 'Y'                                CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewCuSecD     IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurCuSecD     CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewCuSecD                      CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************                       CSE022
      /EJECT                                                                                  CSE022
      *****************************************************************                       CSE022
      * SRDepRef - Other Depot Reference                                                      CSE022
      *****************************************************************                       CSE022
                                                                                              CSE022
     C     SRDepRef      BEGSR                                                                CSE022
                                                                                              CSE022
     C                   IF        WCustOk  = 'N' OR WActnOk = 'N'                            CSE022
                                                                                              CSE022
     C                   GOTO      ESRDepRef                                                  CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE022
      ** If classification is 'E' or 'C' F11 not allowed.                                     CSE022
                                                                                              CSE022
     C                   IF        DDCLAS = 'C' OR DDCLAS = 'E'                               CSE022
     C                   EVAL      Idx = 1                                                    CSE022
     C                   EVAL      E = Idx                                                    CSE022
     C                   MOVEL     'USR9117'     MsgIdArr(E)                                  CSE022
     C                   MOVEL     '*ANY'        FldNameArr(E)                                CSE022
     C                   GOTO      ESRDepRef                                                  CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE022
      ** Check if all ten depot reference has been entered.                                   CSE022
                                                                                              CSE022
     C                   EVAL      WkCnt = 1                                                  CSE022
     C                   DOW       WkCnt <= 10                                                CSE022
                                                                                              CSE022
     C                   IF        DepotSn(WkCnt) = *BLANKS                                   CSE022
     C                   EVAL      Idx = 1                                                    CSE022
     C                   EVAL      E = Idx                                                    CSE022
     C                   MOVEL     'USR9117'     MsgIdArr(E)                                  CSE022
     C                   MOVEL     '*ANY'        FldNameArr(E)                                CSE022
     C                   GOTO      ESRDepRef                                                  CSE022
     C                   ENDIF                                                                CSE022
     C                   EVAL      WkCnt = WkCnt + 1                                          CSE022
                                                                                              CSE022
     C                   ENDDO                                                                CSE022
                                                                                              CSE022
     C                   CALL      'SDC100001'                                                CSE022
     C                   PARM                    DDACTN                                       CSE022
     C                   PARM                    NewCuSecd                                    CSE022
     C                   PARM      *BLANKS       PRTCD                                        CSE022
     C                   PARM                    PModeOfOp                                    CSE022
                                                                                              CSE022
     C                   IF        PRTCD = 'SDA0002'                                          CSE022
                                                                                              CSE022
     C                   EXSR      ENDA                                                       CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE022
     C     ESRDepRef     ENDSR                                                                CSE022
                                                                                              CSE022
      *****************************************************************         CAP011
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
      *
      * GO TO PRIMARY SCREEN
     C                   MOVEL     'A'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDSECDRPR'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
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
      *
      ** Access SAR details file to determine if CAP050
      ** (Midas/ToF Interface) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP050'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '909'         DBASE
     C                   MOVEL     'CAP050'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP050            1
     C                   ELSE
     C                   MOVEL     'N'           CAP050
     C                   END
                                                                                              CSE022
      ** Access SAR details file to determine if CSE022                                       CSE022
      ** (Depository Definition Enhancement) is on.                                           CSE022
                                                                                              CSE022
     C                   CALLB     'AOSARDR0'                                                 CSE022
     C                   PARM      *BLANKS       @RTCD                                        CSE022
     C                   PARM      '*VERIFY'     @OPTN                                        CSE022
     C                   PARM      'CSE022'      @SARD                                        CSE022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE022
                                                                                              CSE022
      ** Database Error                                                                       CSE022
                                                                                              CSE022
     C                   IF        @RTCD <> *BLANKS AND                                       CSE022
     C                             @RTCD <> '*NRF   '                                         CSE022
                                                                                              CSE022
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE022
     C                   MOVEL     '902'         DBASE                                        CSE022
     C                   MOVEL     'CSE022'      DBKEY                                        CSE022
     C                   EXSR      *PSSR                                                      CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE022
     C                   IF        @RTCD = *BLANK                                             CSE022
                                                                                              CSE022
     C                   EVAL      CSE022 = 'Y'                                               CSE022
                                                                                              CSE022
     C                   ELSE                                                                 CSE022
                                                                                              CSE022
     C                   EVAL      CSE022 = 'N'                                               CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   OPEN      APILOGL0                                                   CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        (PRtCd <> '*NRF') and                                      CSC011
     C                             (PRtCd <> *Blanks)                                         CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 905                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSE039
      ** Access SAR details file to determine if CSE039                                       CSE039
      ** (Automatic Setllement of Trades) is on                                               CSE039
                                                                                              CSE039
     C                   CALLB     'AOSARDR0'                                                 CSE039
     C                   PARM      *BLANKS       @RTCD                                        CSE039
     C                   PARM      '*VERIFY'     @OPTN                                        CSE039
     C                   PARM      'CSE039'      @SARD                                        CSE039
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE039
      *                                                                                       CSE039
     C                   IF        @RTCD = *BLANKS                                            CSE039
     C                   EVAL      CSE039 = 'Y'                                               CSE039
     C                   ELSE                                                                 CSE039
     C                   EVAL      CSE039 = 'N'                                               CSE039
     C                   ENDIF                                                                CSE039
                                                                                              CSE041
      ** Access SAR details file to determine if CSE041                                       CSE041
      ** (DVP/RVP Processing) is on                                                           CSE041
                                                                                              CSE041
     C                   CALLB     'AOSARDR0'                                                 CSE041
     C                   PARM      *BLANKS       @RTCD                                        CSE041
     C                   PARM      '*VERIFY'     @OPTN                                        CSE041
     C                   PARM      'CSE041'      @SARD                                        CSE041
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE041
      *                                                                                       CSE041
     C                   IF        @RTCD = *BLANKS                                            CSE041
     C                   EVAL      CSE041 = 'Y'                                               CSE041
     C                   ELSE                                                                 CSE041
     C                   EVAL      CSE041 = 'N'                                               CSE041
     C                   ENDIF                                                                CSE041
                                                                                              CSE042
      ** Access SAR details file to determine if CSE042                                       CSE042
      ** (Auto Feed of Trades and Movements) is on                                            CSE042
                                                                                              CSE042
     C                   CALLB     'AOSARDR0'                                                 CSE042
     C                   PARM      *BLANKS       @RTCD                                        CSE042
     C                   PARM      '*VERIFY'     @OPTN                                        CSE042
     C                   PARM      'CSE042'      @SARD                                        CSE042
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE042
      *                                                                                       CSE042
     C                   IF        @RTCD = *BLANKS                                            CSE042
     C                   EVAL      CSE042 = 'Y'                                               CSE042
     C                   ELSE                                                                 CSE042
     C                   EVAL      CSE042 = 'N'                                               CSE042
     C                   ENDIF                                                                CSE042
      *
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
 
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
 
      ** Get the field number for the action code field; the primary
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatA
     C                   PARM                    FieldA
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetA = FieldNo - 3
     C                   ENDIF
      *
      * Start on Browse Screen
      *
     C                   MOVEL     'I'           @SCRN             1
      *
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDSECDR014
 
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
