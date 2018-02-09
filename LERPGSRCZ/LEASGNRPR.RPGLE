     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Assignment repair')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEASGNRPR - Assignment Repair                                *
      *                                                               *
      *  Function:  This function allows invalid assignments to       *
      *             be 'repaired' and applied to the Midas database.  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE134             Date 01Aug12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE025             Date 20May04               *
      *                 CDL018             Date 03Feb04               *
      *                 CAP084             Date 02Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP070  *CREATE    Date 28Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CAP084 - Recompiled over changed LEVASGNPD file.             *
      *           Recompiled over changed LEASGNPD format.            *
      *  CAP070 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FLEIASGNL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEIASGND0 : LEIASGNX0)
     FLEIASGNL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FAPILSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APILSETD0:APILSETX0)
     FAPILSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** API Invalid log file by Type/FO Id/Time
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
 
     FLEASGNDDF CF   E             WORKSTN INFSR(*PSSR)
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      /SPACE 5
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
 
     D #EI             S              1    DIM(25)
 
 
      ** Assignment Details in screen format
     D ASGN          E DS                  EXTNAME(LEASGNPD)
 
      ** Assignment Details OK indicator
     D ASGN_OK       E DS                  EXTNAME(LEEASGNPD)
 
 
      ** Assignment Details in file format
     D LEPARTPDFmt   E DS                  EXTNAME(LEPARTPD)
     D  LepartREC             72    140
     D  LepartPAY            141    699
 
      ** New Assignment Details in file format
     D LEVASGNPD     E DS                  EXTNAME(LEVASGNPD)
     D  V_REC                 72    140
     D  V_PAY                141    699
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D  FLREC                  1     69
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D  FLPAY                  1    559
 
      * File Fra/irs instructions
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
 
      * Screen Receive instructions
     D S_REC         E DS                  EXTNAME(SDESSRPD)
 
      * Screen Payment instructions
     D S_PAY         E DS                  EXTNAME(SDESSPPD)
 
      * Screen Fra/irs instructions
     D S_FRI         E DS                  EXTNAME(SDESSFPD)
 
 
      ** Current Assignment Details in screen format
     D C_ASGN        E DS                  EXTNAME(LEASGNPD)
     D                                     PREFIX(C_)
 
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status data area
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Module details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Retail details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
 
      ** API details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** EXTERNAL DS FOR SAR DETAILS
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_TYLC      E                     EXTFLD(TYLC)                                       CLE042
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Timestamp
     D @XTMSTSEL       S             26Z
     D @XREPNSEL       S              5S 0
     D CSC011          S              1A   INZ('N')
     D KMsgType        S              8A
     D KFrntOffID      S             20A
     D KTimeStamp      S                   LIKE(@XTMSTSEL)
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
 
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * DO SCREEN: BROWSE INVALID TRANSACTIONS
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   END
 
      * READ NEXT BROWSE SUBFILE RECORD
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
 
      * DO WHILE SCREEN: MAIN DETAILS
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
 
      * SCREEN: WINDOW
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END
 
      * DO WHILE SCREEN: SETTLEMENT DETAILS
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
 
      * DO FILE UPDATES
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
 
      * TERMINATE PROGRAM
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SCRN@B - BROWSE INVALID TRANSACTIONS
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'LEASGNRPB'
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
      * Error in update of previous assignment
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
      * REPAIR NUMBER OF TRANSACTION SELECTED
     C                   PARM                    @XREPNSEL
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @XTMSTSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ** Successful Insert ID
      *
     C                   PARM                    @SIID             6
      *
     C                   PARM                    CSC011
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
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@B       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'LEASGNRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
      *
      * Error in update of previous assignment
     C                   PARM                    @ERRUP            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM      *BLANK        @ACSEL            1
      *
      * REPAIR NUMBER OF TRANSACTION SELECTED
     C                   PARM      *ZERO         @XREPNSEL
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @XTMSTSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ** Successful Insert ID
      *
     C                   PARM                    @SIID
      *
     C                   PARM                    CSC011
      *
      * If CK/3 taken within invalid transaction deletion function,
      * End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   END
      *
      * IF INVALID TRANSACTION READ FROM SUBFILE
      *
     C     @OPSEL        IFNE      *BLANK
      *
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        ASGN
     C                   MOVEL     *BLANK        S#ATNM
     C                   MOVEL     *BLANK        S#ATTN
     C                   MOVEL     *BLANK        S#AFNM
     C                   MOVEL     *BLANK        S#AFTN
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       ASGN_OK
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   Z-ADD     0             Idx
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   Z-ADD     0             WIdx
      *
      * Retrieve assignment details
      *
     C     LEIASGNX      CHAIN     LEIASGNX0                          99
      *
      * Access invalid lending settlement instructions
      *
     C                   CLEAR                   F_REC
     C                   CLEAR                   F_PAY
     C     APILSETX      CHAIN     APILSETX0                          99
 
      * Access primary facility
 
     C                   EXSR      ACSPFA
     C                   MOVEL     FcbrBranch    S#BRCA
     C                   MOVEL     FccyFCCY      S#FCCY
      *
      * If errors occurred in access of primary facility
      * blank out action code so that the input cannot proceed
      * and send the error messages to the main details screen
      *
     C     Idx           IFNE      0
     C                   MOVEL     *BLANK        S#ACTN
     C                   ELSE
 
      * Retrieve current transaction
 
     C                   EXSR      RTVTRAN
      *
      * If errors occurred in access of current transaction
      * blank out action code so that the input cannot proceed
      *
     C     Idx           IFNE      0
     C                   MOVEL     *BLANK        S#ACTN
     C                   ENDIF
     C                   ENDIF
 
      * Send the error messages to the main details screen
 
     C                   EXSR      SNDM@M
     C                   EXSR      SET_SCEI
 
      * Reset Settlement Screen Setup indicator
 
     C                   MOVE      'N'           SSCR_SetUp
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
      *
      * ELSE IF NO INVALID DEAL READ FROM SUBFILE
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'B'           @SCRN
     C                   END
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     S#ACTN        IFEQ      *BLANK
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'LEX9990'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialise error indicators
      *
     C                   MOVEA     ASGN_OK       #EI
      *
      ** Read error messages for transaction
      *
     C                   EVAL      ABFOTRNID  = DDFRNT
     C     ZATRNK        SETLL     ZATRNERRD0
     C     ZATRNK        READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C     F             IFLT      1
     C     F             ORGT      19
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           #EI(F)
     C     ZATRNK        READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     #EI           ASGN_OK
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      * Issue rollback to clear any possible updates in window function
      *
     C     BGWDPR        IFEQ      'Y'
     C                   ROLBK
     C                   END
      *
      * Enable/disable detail fields on main details screen
      * if changes to the data are allowed
      * (Action code can only be 'I', 'A', or 'R')
      *
     C     S#ACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'
     C     S#ACTN        OREQ      'A'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     '0'           *IN67
     C                   ELSE
     C                   MOVEL     '1'           *IN67
     C                   END
 
     C     S#ACTN        IFEQ      'I'
     C                   MOVEL     '1'           *IN09
     C                   ELSE
     C                   MOVEL     '0'           *IN09
     C                   END
      *
      * KJ = COMMAND KEY 10 = CONFIRM REVERSE
      *
     C     S#ACTN        IFEQ      'R'
     C                   MOVEL     '1'           *IN68
     C                   ELSE
     C                   MOVEL     '0'           *IN68
     C                   END
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   WRITE     LEASGNF2
     C                   WRITE     LEASGNF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEASGNF3
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       ASGN_OK
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   Z-ADD     0             Idx
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   Z-ADD     0             WIdx
 
      ** Reset screen error indicators
 
     C                   EXSR      RESET_SCEI
 
      **  Clear Message subfile
 
     C                   EXSR      CLEARM
      *
      * CK/3 - END PROGRAM
      *
     C     *INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
      *
     C     *INKL         CASEQ     '1'           CANC@M
      *
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
      *
     C                   CAS                     VAL@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
      *
      * Retrieve transaction details
      *
     C                   EXSR      RTVTRAN
      *
      * If errors returned
      * Re-output screen with error messages on it
      *
     C     Idx           IFNE      0
     C                   EXSR      SET_SCEI
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF REVERSE
      *
     C     S#ACTN        IFEQ      'R'
      *
      * Update Transaction
      *
     C                   MOVEL     LepartREC     F_REC
     C                   MOVEL     LepartPAY     F_PAY
     C                   MOVE      CVMR          FLCVMR
     C                   MOVE      OMDB          FLPOBR
     C                   MOVE      OSDB          FLROBR
     C                   MOVE      SCCY          FLPSCY
     C                   MOVE      SCCY          FLRSCY
     C                   MOVE      ICCY          FLIC72
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     REXR          FLREXR                                       CLE031
     C                   Z-ADD     PEXR          FLPEXR                                       CLE031
     C                   MOVE      REXI          FLREXI                                       CLE031
     C                   MOVE      PEXI          FLPEXI                                       CLE031
     C                   MOVE      SCCY          FLRSCY                                       CLE031
     C                   MOVE      PSCY          FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     *INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     S#ACTN        IFEQ      'I'
     C     S#ACTN        OREQ      'A'
      *
      * IF AMEND
      *
     C     S#ACTN        IFEQ      'A'
      *
      * Validate whether non-amendable fields have been changed
      *
     C                   CALLB     'LEASGNCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Assignment details in file format
     C                   PARM                    LEPARTPDFmt
 
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY
     C                   PARM                    FccyNBDP
      *
      * OUTPUTS
      *
      * Assignment Details in screen format
     C                   PARM                    C_ASGN
 
      * Assigned to customer details
     C                   PARM                    S#ASTN            6
     C                   PARM                    S#ASTX           10
     C                   PARM                    S#ATNM           20
     C                   PARM                    S#ATTN           10
 
      * Assigned from customer details
     C                   PARM                    S#ASFN            6
     C                   PARM                    S#ASFX           10
     C                   PARM                    S#AFNM           20
     C                   PARM                    S#AFTN           10
 
     C                   CALLB     'LEASGNAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * New assignment in Screen Format
     C                   PARM                    ASGN
      *
      * Current assignment in Screen Format
     C                   PARM                    C_ASGN
      *
      * Current assignment in File Format
     C                   PARM                    LEPARTPDFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    ASGN_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
      *
      * If errors returned
      * set screen error indicators (and send messages to the screen)
      *
     C     Idx           IFNE      0
     C                   EXSR      SET_SCEI
     C                   GOTO      EVAL@M
     C                   END
     C                   END
      *
      * Validate deal details
      *
     C                   CALLB     'LEASGNVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Assignment Details in screen format
     C                   PARM                    ASGN
 
      * Prime Facility amount
      * Prime Facility branch
      * Prime Facility branch details
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
 
      * Front office inputs (if mode = 'B')
     C                   PARM                    R1PCOB            3
     C                   PARM                    R1TNRF           15
      *
      * OUTPUTS
 
      * Field OK flags
     C                   PARM                    ASGN_OK
      *
      * Assigned to customer number
     C                   PARM                    S#ASTN            6
      *
      * Assigned from customer number
     C                   PARM                    S#ASFN            6
      * Assigned to customer name/town
     C                   PARM                    S#ATNM           20
     C                   PARM                    S#ATTN           10
      * Assigned from customer name/town
     C                   PARM                    S#AFNM           20
     C                   PARM                    S#AFTN           10
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
 
      * Valid Assignment
     C                   PARM                    LEVASGNPD
      *
      * If errors returned
      * set screen error indicators (and send messages to the screen)
      *
     C     Idx           IFNE      0
     C                   EXSR      SET_SCEI
     C                   GOTO      EVAL@M
     C                   END
      *
      * If windows processing on, call window routine
      * otherwise, continue to settlements screen
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
     C                   END
      *
     C                   END
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
     C     WINDOW        BEGSR
      *
     C/COPY QWINDSRC,LEASGNSMV1
      *
     C                   CALL      'WN0010'
     C                   PARM      'LEASGNRPR'   #PGM             10
     C                   PARM                    FKEY              2
     C                   PARM      S#ACTN        ACTION            1
     C                   PARM                    DATA           1024
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
      *
      * Process returned command keys
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
      *
      *  If Cmd12 pressed, return to main details screen;
      *  otherwise, go to settlements screen
      *
     C     #RTRN         IFEQ      'USR0790'
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   END
     C                   ELSE
     C                   EVAL      @SCRN = 'S'
     C                   ENDIF
     C                   ENDIF
      *
     C     WIND          ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SCRN@S - PROCESS SCREEN: SETTLEMENT DETAILS
      *****************************************************************
     C     SCRN@S        BEGSR
      *
      ** PAYMENT DATE & RECEIVE DATE = RUN DATE
      *
     C                   Z-ADD     BJRDNB        ##DATP
     C                   Z-ADD     BJRDNB        ##DATR
 
      ** Setup the settlement screen fields
 
     C     SSCR_SetUp    IFEQ      'N'
     C                   EXSR      SETUP_SSCR
     C                   MOVE      'Y'           SSCR_SetUp        1
     C                   ENDIF
     C                   MOVE      *BLANKS       ##DLNO
     C                   EVAL      ##DLNO = S#PMFT + S#PMFN
      *
      * SETTLEMENT INSTRUCTIONS INPUT
      *
     C                   CALLB     'ZASETINSIN'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        ##RTCD           10
      *
      * Action code
     C                   PARM      S#ACTN        ##ACTN            1
      *
      * Deal number
     C                   PARM                    ##DLNO            6
      *
      * Protect Payment
     C                   PARM                    ##PPAY            1
      *
      * Protect Receive
     C                   PARM                    ##PREC            1
      *
      * Calling program
     C                   PARM      'LEND'        ##CALP            4
      *
      * Payment currency
     C                   PARM      FccyFCCY      ##PCCY            3
      *
      * Receive currency
     C                   PARM      FccyFCCY      ##RCCY            3
      *
      * Customer shortname
     C                   PARM      S#ASTN        ##CSNM           10
      *
      * Transaction Type
     C                   PARM      *BLANKS       ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND            1
      *
      * Booking branch
     C                   PARM      FcbrBranch    ##BRCA            3
      *
      * Receipt Date
     C                   PARM                    ##DATR            5 0
      *
      * Payment Date
     C                   PARM                    ##DATP            5 0
      *
      * Payment instructions
     C                   PARM                    S_PAY
      *
      * Receive instructions
     C                   PARM                    S_REC
      *
      * FRA/IRS instructions
     C                   PARM                    S_FRI
      *
      * OUTPUTS
      *
      * Payment instructions
     C                   PARM                    F_PAY
      *
      * Receive instructions
     C                   PARM                    F_REC
      *
      * FRA/IRS instructions
     C                   PARM                    F_FRI
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
     C                   MOVEL     @INKC         *IN03
     C                   MOVEL     @INKL         *IN12
      *
      * CK/3 - END PROGRAM
      *
     C     *INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON SETTLEMENT DETAILS
      *
     C     *INKL         CASEQ     '1'           CANC@S
      *
      * Set fields on insert and amend
 
     C     S#ACTN        CASEQ     'I'           SETF_IA
     C     S#ACTN        CASEQ     'A'           SETF_IA
     C                   END
      *
      * EXIT FROM SETTLEMENT DETAILS
      *
     C                   EXSR      EXIT@S
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SETF_IA  : Set fields on insert and amend                     *
      *****************************************************************
     C     SETF_IA       BEGSR
 
      ** Receive Settlement details
 
     C                   MOVE      FLREC         V_REC
     C                   MOVE      FLROBR        ASOSDB
 
      ** Payment Settlement details
 
     C                   MOVE      FLPAY         V_PAY
     C                   MOVE      FLPOBR        ASOMDB
     C                   MOVE      FLCVMR        ASCVMR
     C                   MOVE      FLPSCY        ASSCCY
     C                   MOVE      FLIC72        ASICCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        ASREXR                                       CLE031
     C                   Z-ADD     FLPEXR        ASPEXR                                       CLE031
     C                   MOVE      FLREXI        ASREXI                                       CLE031
     C                   MOVE      FLPEXI        ASPEXI                                       CLE031
     C                   MOVE      FLRSCY        ASSCCY                                       CLE031
     C                   MOVE      FLPSCY        ASPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * EXIT@S - EXIT FROM SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      * DO UPDATES
      *
     C                   MOVEL     'U'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
      * Include Header fields that need to be o/p to the valid file
      * If there is no front office ID, use the PCREF created by LEASGNVAL.
     C     DDFRNT        Ifeq      *Blank
     C                   MOVEL     ASPCRF        ASFRNT
     C                   Else
     C                   MOVEL     DDFRNT        ASFRNT
     C                   EndIf
 
     C                   EVAL      ASAFRT = DDAFRT
     C                   EVAL      ASREPA = DDREPA
     C                   EVAL      ASSTMP = XTMST
      *
      * DATABASE UPDATES
      *
     C                   CALLB     'LEASGNUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Action Code
     C                   PARM                    S#ACTN            1
 
      * Assignment Details in file format
     C                   PARM                    LEVASGNPD
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    ASGN_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID TRANSACTION & COMMIT THE UPDATES
      *
     C     RetCodeOut    IFNE      *BLANK
     C                   ROLBK
     C     RetCodeOut    IFNE      '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   ELSE
     C     LEIASGNK      CHAIN     LEIASGND0                          99
     C  N99              DELETE    LEIASGND0
     C     APILSETK      CHAIN     APILSETD0                          99
     C  N99              DELETE    APILSETD0
 
      ** Delete invalid record from the log file
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EVAL      KMsgType = 'LEASGN'
     C                   EVAL      KFrntOffID = DDFRNT
     C                   EVAL      KTimeStamp = XTMST
 
     C     KAPLOG        CHAIN     APILOGL0                           99
 
     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   COMMIT
     C                   END
      *
      * If error occurred in updating last transaction set on flag to
      * display message on 'browse' screen.
     C     RetCodeOut    IFEQ      '*RECUPD'
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
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
     C     ENDP          BEGSR
 
     C                   MOVEL     'T'           @SCRN
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Setup the settlement screen fields                            *
      *****************************************************************
     C     SETUP_SSCR    BEGSR
 
      ** Determine if pay & receive settlement screen will be protected
 
     C     S#ACTN        IFEQ      'E'
     C     S#ACTN        OREQ      'R'
     C                   MOVE      'Y'           ##PREC
     C                   MOVE      'Y'           ##PPAY
     C                   ELSE
     C                   MOVE      'N'           ##PREC
     C                   MOVE      'N'           ##PPAY
     C                   ENDIF
 
      ** If amend, enquire or reverse
      ** move settlement file fields to screen fields
      ** Else clear settlement screen fields
 
     C     S#ACTN        IFEQ      'A'
     C     S#ACTN        OREQ      'E'
     C     S#ACTN        OREQ      'R'
      *
      * SET UP PAYMENT INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVEL     V_PAY         FLPAY
     C                   MOVEL     ASOMDB        FLPOBR
     C                   MOVEL     ASCVMR        FLCVMR
     C                   MOVEL     ASSCCY        FLPSCY
     C                   MOVEL     ASICCY        FLIC72
      *
      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVEL     V_REC         FLREC
     C                   MOVEL     ASOSDB        FLROBR
     C                   MOVEL     ASSCCY        FLRSCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     ASREXR        FLREXR                                       CLE031
     C                   Z-ADD     ASPEXR        FLPEXR                                       CLE031
     C                   MOVE      ASREXI        FLREXI                                       CLE031
     C                   MOVE      ASPEXI        FLPEXI                                       CLE031
     C                   MOVE      ASSCCY        FLRSCY                                       CLE031
     C                   MOVE      ASPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *
      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
      * AND PAYMENT/RECEIPT DATES ARE NOT IN THE PAST, DEFAULT THEM
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
     C     S#ACTN        ANDNE     'E'
      *
     C                   CALLB     'ZASETINDFT'
      *
      * INPUTS
      *
      * Calling program
     C                   PARM      'LEND'        ##CALP            4
      *
      * Payment currency
     C                   PARM      FccyFCCY      ##PCCY            3
      *
      * Receive currency
     C                   PARM      FccyFCCY      ##RCCY            3
      *
      * Customer shortname
     C                   PARM      S#ASTN        ##CSNM           10
      *
      * Transaction Type
     C                   PARM      *BLANKS       ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM      *BLANK        ##FFND            1
      *
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA            4
      *
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY            6
      *
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT            6
      *
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV            2
      ** Version of ISDA Agreement century
     C                   PARM                    Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** OUTPUTS
      *
      * Payment instructions
     C                   PARM                    F_PAY
      *
      * Receive instructions
     C                   PARM                    F_REC
      *
      * FRA/IRS instructions
     C                   PARM                    F_FRI
      *
     C                   END
      *
      * CONVERT SETTLEMENT DETAILS FROM FILE TO SCREEN FORMAT
      *
     C                   CALLB     'ZASETINCVT'
      *
      ** INPUTS
      *
      ** File Payment Settlement Instruction
     C                   PARM                    F_PAY
      *
      ** File Receipt Settlement Instruction
     C                   PARM                    F_REC
      *
      ** File FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        F_FRI
      *
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
     C                   PARM      *BLANK        S_PAY
      *
      ** Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        S_REC
      *
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        S_FRI
     C                   PARM      FccyFCCY      #TRCCY                                      CSF011A
     C                   PARM      FccyFCCY      #TPCCY                                      CSF011A
      *
     C     EDETP@S       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Access Primary Facility                                       *
      *****************************************************************
     C     ACSPFA        BEGSR
 
     C                   CALLB     'LE002500'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Primary facility customer, type & number
     C                   PARM                    S#PMFC            6
     C                   PARM                    S#PMFT            3
     C                   PARM                    S#PMFN            2
      *
      * OUTPUTS
      *
 
      * Prime Facility amount
      * Prime Facility branch
      * Prime Facility branch details
      * Prime Facility currency
      * Prime Facility currency decimal places
      * Prime Facility tranche/credit agreement ind
      * Prime Facility credit agreement customer, type & number
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C**********         PARM                    FccaCANM          6 0                        CSD027
     C                   PARM                    FccaCANM          6                          CSD027
     C                   PARM                    FccaCAFT          3 0
     C                   PARM                    FccaCAFN          2 0
 
      * Primary customer name & town
     C                   PARM                    S#PRNM           20
     C                   PARM                    S#PRTN           10
 
      * Agent customer number, name & town
     C                   PARM                    S#ANUM            6
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Primary facility amount edited
     C                   PARM                    S#FAMT           14
 
      * Field OK flags
     C                   PARM                    S#PMFCOK          1
     C                   PARM                    S#PMFTOK          1
     C                   PARM                    S#PMFNOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * RTVTRAN - Retrieve transaction
      *****************************************************************
     C     RTVTRAN       BEGSR
 
     C                   CALLB     'LEASGNRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
      * Response mode
     C                   PARM      'S'           RESPMODE          1
 
      * Action and assigned to and assigned from customers
     C                   PARM                    S#ACTN
     C                   PARM                    S#ASTS
     C                   PARM                    S#ASFS
 
      * Primary facility customer, type & number
     C                   PARM                    S#PMFC
     C                   PARM                    S#PMFT
     C                   PARM                    S#PMFN
 
      * Prime facility branch
     C                   PARM                    FcbrBranch
 
      * Value date of change
     C                   PARM      *ZERO         In_VDTC           5 0
      *
      * OUTPUTS
 
      * Assignment Details in file format
     C                   PARM                    LEPARTPDFmt
 
      * Action and customer OK indicators
     C                   PARM                    S#ACTNok
     C                   PARM                    S#ASTSok
     C                   PARM                    S#ASFSok
 
      * Assigned to customer number
     C                   PARM                    S#ASTN            6
 
      * Assigned from customer number
     C                   PARM                    S#ASFN            6
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Set screen error indicators                                   *
      *****************************************************************
     C     SET_SCEI      BEGSR
 
      * Move 'OK' flags into array (for checking)
 
     C                   MOVEA     ASGN_OK       #EI
 
      * Set screen error indicators according to status of 'OK' flags
 
     C                   Z-ADD     2             #C                2 0
     C                   Z-ADD     41            #E                2 0
      *
     C     #C            DOUGT     25
     C     #EI(#C)       IFEQ      'N'
     C     #EI(#C)       OREQ      'W'
     C                   MOVEL     '1'           *IN(#E)
     C                   END
     C                   ADD       1             #C
     C                   ADD       1             #E
     C                   END
 
      *  Do while error messages found
      *  Write error messages to subfile
 
     C                   Z-ADD     1             #C
     C     #C            DOWLE     ArrayMax
     C     FldNameArr(#C)ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(#C)  ZAMSID
     C                   EXSR      ZASNMS
     C                   ADD       1             #C
     C                   ENDDO
 
      *  Do while warning messages found
      *  Write warning messages to subfile
 
     C                   Z-ADD     1             #C
     C     #C            DOWLE     ArrayMax
     C     WFldNamArr(#C)ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(#C) ZAMSID
     C                   EXSR      ZASNMS
     C                   ADD       1             #C
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Reset screen error indicators                                 *
      *****************************************************************
     C     RESET_SCEI    BEGSR
     C                   SETOFF                                       414243
     C                   SETOFF                                       444546
     C                   SETOFF                                       474849
     C                   SETOFF                                       505152
     C                   SETOFF                                       535455
     C                   SETOFF                                       565758
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Clear the message queue                                       *
      *****************************************************************
     C     CLEARM        BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSProcName    ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      *  Send messages to the program's message queue                 *
      *****************************************************************
     C     ZASNMS        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     PSProcName    ZAPGMQ
     C                   END
 
     C                   CALL      'Y2SNMGC'                            9999
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialise program name
      *
     C                   MOVEL     'LEASGNRPR'   DBPGM
      *
      ** Mode
      *
     C                   MOVEL     'B'           P#MODE
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access retail details
      *
     C     BGRTBN        IFEQ      'Y'
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDRETLPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Access API ICD Details
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      * Start on Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
 
      * Screen fields
     C                   MOVE      PSUser        S#USER
     C                   MOVE      PSJobName     S#WSID
     C                   MOVE      BJMRDT        S#RUNA
     C                   MOVE      PSProcName    ##PGM
 
      * Subfile indicators
     C                   MOVE      *ON           *IN25
 
      * Disable settlements screen
     C                   MOVE      *OFF          *IN69
 
      * Message file
     C                   MOVEL     'LERMSGF   '  ZAMSGF
 
      ** Message Type
     C                   MOVEL     'LEASGN'      @MSGTYPE         32
 
      ** Check if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
 
     C                   EVAL      CSC011 = 'Y'
 
     C                   OPEN      APILOGL0
 
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C                   ELSE
 
      ** Database error
 
     C                   IF        PRTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 904
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD             6                          CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
     C     @RTCD         IFEQ      '*NRF'                                                     CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
                                                                                              CLE031
      ** Database error                                                                       CLE031
                                                                                              CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE031
     C                   MOVEL     '908'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *
      * Key Lists
      *
     C     ZATRNK        KLIST
     C                   KFLD                    ABFOTRNID
     C                   KFLD                    @XTMSTSEL
     C     LEIASGNK      KLIST
     C                   KFLD                    @XREPNSEL
     C                   KFLD                    @XTMSTSEL
     C     LEIASGNX      KLIST
     C                   KFLD                    @XTMSTSEL
     C                   KFLD                    @XREPNSEL
     C     APILSETK      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    @XTMSTSEL
     C                   KFLD                    DDFRNT
     C     APILSETX      KLIST
     C                   KFLD                    @MSGTYPE
     C                   KFLD                    DDFRNT
     C                   KFLD                    @XTMSTSEL
 
     C     KAPLOG        KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
