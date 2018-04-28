     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate booking and originating branch')     *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABVBRANCHS - Validate Booking and Originating Branch         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD000091           Date 09May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG11679           Date 04Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004  *CREATE    Date 08Sep98               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  BUG11679 - Additional Conversion of Customer Number to Alpha.*
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP004 - API's Phase 3.                                      *
      *                                                               *
      *****************************************************************
 
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** External data structure for branch codes file
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External data structure for customer details file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                     CGL029
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for access programs (very long)                              CSD025
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CSD025
                                                                                              CSD025
      ** Externally described DS for SAR details                                              CSD025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD025
                                                                                              CSD025
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Deal Customer
     D*JUDCNO********* S              6S 0                                                  BUG11679
     D JUDCNO          S              6A                                                    BUG11679
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      ** Clear output deal fields
 
     C                   MOVEL     *BLANK        JUDBRC
     C                   MOVEL     *BLANK        JUMBCA
     C                   MOVEL     *BLANK        JUORBR
     C**********         Z-ADD     *ZERO         JUDCNO                                     BUG11679
     C                   MOVEL     *BLANK        JUDCNO                                     BUG11679
 
      *
      * BOOKING BRANCH VALIDATION - SINGLE BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      BRCDVS
     C                   END
      *
      * BOOKING BRANCH VALIDATION - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   EXSR      BRCDVM
     C                   END
      *
      * ORIGINATING BRANCH VALIDATION - SINGLE BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      ORBRVS
     C                   END
      *
      * ORIGINATING BRANCH VALIDATION - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   EXSR      ORBRVM
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDBRCDOK      OREQ      'N'
     C     DDORBROK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * BRCDVS - BOOKING BRANCH VALIDATION - SINGLE BRANCHING
      *****************************************************************
     C     BRCDVS        BEGSR
      *
      * If branch is not yet defined
      * Default booking branch
      *
     C     DDBRCD        IFEQ      *BLANKS
     C                   MOVE      BJSBRC        DDBRCD
     C                   END
      *
      * Get booking branch details
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBRCD        @DSNB
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      * Update deal customer & booking branch round-down ind. & location
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A8BICN        JUDCNO
     C                   MOVEL     A8RDFC        BkgBrRDFC
     C                   MOVE      A8LCCD        BkgBrLCCD
      *                                                                                       CSD025
     C     CSD025        IFEQ      'Y'                                                        CSD025
      *                                                                                       CSD025
      * Get branch internal customer details                                                  CSD025
      *                                                                                       CSD025
     C                   CALL      'AOCUSTR1'                                                 CSD025
     C                   PARM      *BLANKS       @RTCD                                        CSD025
     C                   PARM      '*KEY   '     @OPTN                                        CSD025
     C                   PARM      A8BICN        @BBKEY           10                          CSD025
     C                   PARM      *BLANKS       @BBKY2            7                          CSD025
     C     SDCUST        PARM      SDCUST        DSLDY                                        CSD025
      *                                                                                       CSD025
     C     @RTCD         IFNE      *BLANKS                                                    CSD025
     C     @BBKY2        OREQ      'ERROR  '                                                  CSD025
     C                   MOVE      'N'           DDBRCDOK                                     CSD025
     C                   ADD       1             Idx                                          CSD025
     C                   MOVEL     'DDBRCD'      FldNamXAr(Idx)                               CSD025
     C                   MOVEL     'FXM0205'     MsgIDXAr(Idx)                                CSD025
     C                   ENDIF                                                                CSD025
      *                                                                                       CSD025
     C     @RTCD         IFEQ      *BLANKS                                                    CSD025
     C     BBDEAC        ANDEQ     'Y'                                                        CSD025
     C     DDACTN        ANDEQ     'I'                                                        CSD025
     C                   MOVE      'N'           DDBRCDOK                                     CSD025
     C                   ADD       1             Idx                                          CSD025
     C                   MOVEL     'DDBRCD'      FldNamXAr(Idx)                               CSD025
     C                   EVAL      MsgIdXAr(IDx) = 'ABM0027'                                  CSD025
     C**********         EVAL      MsgDtaXAr(IDx) = BBCUST                           CSD025 MD000091
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(BBCUST)                   MD000091
     C                   ENDIF                                                                CSD025
      *                                                                                       CSD025
     C                   ENDIF                                                                CSD025
      *                                                                                       CSD025
     C                   END
      *
      * Update booking branch(es) on deal
      *
     C                   MOVE      DDBRCD        JUDBRC
     C                   MOVE      DDBRCD        JUMBCA
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * BRCDVM - BOOKING BRANCH VALIDATION - MULTI-BRANCHING
      *****************************************************************
     C     BRCDVM        BEGSR
      *
      * Default booking branch
      *
     C     DDBRCD        IFEQ      *BLANKS
     C                   MOVE      BRC           DDBRCD
     C                   END
      *
      * Check that booking branch exists
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBRCD        @DSNB
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      * Error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDBRCDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRCD'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0013'     MsgIDXAr(Idx)
     C                   GOTO      EBRCDVM
     C                   END
      *
      * Update screen branch if branch selected
      *
     C                   MOVEL     A8BRCD        DDBRCD
      *
      * Update deal customer & booking branch round-down ind. & location
      *
     C                   MOVEL     A8BICN        JUDCNO
     C                   MOVEL     A8RDFC        BkgBrRDFC
     C                   MOVE      A8LCCD        BkgBrLCCD
      *
      * Get branch internal customer details
      *
     C*****              CALL      'AOCUSTR0'                                                 CSD025
     C                   CALL      'AOCUSTR1'                                                 CSD025
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      A8BICN        @BBKEY           10
     C                   PARM      *BLANKS       @BBKY2            7
     C*****SDCUST        PARM      SDCUST        DSSDY                                        CSD025
     C     SDCUST        PARM      SDCUST        DSLDY                                        CSD025
     C     @RTCD         IFNE      *BLANKS
     C     @BBKY2        OREQ      'ERROR  '
     C                   MOVE      'N'           DDBRCDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRCD'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0205'     MsgIDXAr(Idx)
     C                   GOTO      EBRCDVM
     C                   END
      *                                                                                       CSD025
     C     CSD025        IFEQ      'Y'                                                        CSD025
      *                                                                                       CSD025
     C     @RTCD         IFEQ      *BLANKS                                                    CSD025
     C     BBDEAC        ANDEQ     'Y'                                                        CSD025
     C     DDACTN        ANDEQ     'I'                                                        CSD025
     C                   MOVE      'N'           DDBRCDOK                                     CSD025
     C                   ADD       1             Idx                                          CSD025
     C                   MOVEL     'DDBRCD'      FldNamXAr(Idx)                               CSD025
     C                   EVAL      MsgIdXAr(IDx) = 'ABM0027'                                  CSD025
     C**********         EVAL      MsgDtaXAr(IDx) = BBCUST                           CSD025 MD000091
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(BBCUST)                   MD000091
     C                   ENDIF                                                                CSD025
      *                                                                                       CSD025
     C                   ENDIF                                                                CSD025
      *
      * Update booking branch customer & account officer.
      *
     C                   MOVEL     BBCUST        BkgBrCUST
     C                   MOVEL     BBACOC        BkgBrACOC
      *
      * Check that authorities to booking branch exist for action code
      * if this function is operating is synchronous mode.
      *
     C     RespMode      IFEQ      'S'
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM      DDBRCD        ZBRCDX            3
     C                   PARM                    ERR               1 0
      *
      * No valid action codes for user/branch combination
      *
     C     ERR           IFEQ      1
     C                   MOVE      'N'           DDACTNOK
     C                   MOVE      'N'           DDBRCDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRCD'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0290'     MsgIDXAr(Idx)
     C                   END
      *
      * This action code invalid for user/branch combination
      *
     C     ERR           IFEQ      2
     C                   MOVE      'N'           DDACTNOK
     C                   MOVE      'N'           DDBRCDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRCD'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0291'     MsgIDXAr(Idx)
     C                   END
     C                   END
      *
      * Update booking branch(es) on deal
      *
     C                   MOVE      DDBRCD        JUDBRC
     C                   MOVE      DDBRCD        JUMBCA
      *
     C     EBRCDVM       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ORBRVS - ORIGINATING BRANCH VALIDATION - SINGLE BRANCHING
      *****************************************************************
     C     ORBRVS        BEGSR
      *
      * Default originating branch to booking branch (if valid)
      *
     C     DDORBR        IFEQ      *BLANKS
     C     DDBRCDOK      ANDEQ     'Y'
     C                   MOVE      DDBRCD        DDORBR
     C                   END
      *
      * Update originating branch on deal
      *
     C                   MOVEL     DDORBR        JUORBR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ORBRVM - ORIGINATING BRANCH VALIDATION - MULTI-BRANCHING
      *****************************************************************
     C     ORBRVM        BEGSR
      *
      * Default originating branch to booking branch (if valid)
      *
     C     DDORBR        IFEQ      *BLANKS
     C     DDBRCDOK      ANDEQ     'Y'
     C                   MOVE      DDBRCD        DDORBR
     C                   END
      *
      * If originating branches used
      * Check that originating branch exists
      *
     C     BKOBRU        IFEQ      'Y'
     C     DDORBR        ANDNE     *BLANKS
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDORBR        @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      * Error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDORBROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0289'     MsgIDXAr(Idx)
     C                   GOTO      EORBRVM
     C                   END
      *
      * Update screen branch if branch selected
      *
     C                   MOVEL     A8BRCD        DDORBR
      *
      * If originating branch/user validation
      * and if this function is operating is synchronous mode.
      *
     C     RespMode      IFEQ      'S'
     C     BKOBUV        ANDEQ     'Y'
     C                   CALL      'ZVOBU'
     C                   PARM      DDORBR        ZOBRX             3
     C                   PARM                    ERR               1 0
      *
      * No valid origination branches for this user
      *
     C     ERR           IFEQ      1
     C                   MOVE      'N'           DDORBROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0287'     MsgIDXAr(Idx)
     C                   END
      *
      * This originating branch invalid for user
      *
     C     ERR           IFEQ      2
     C                   MOVE      'N'           DDORBROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0288'     MsgIDXAr(Idx)
     C                   END
      *
     C                   END
     C                   END
      *
      * Update originating branch on deal
      *
     C                   MOVEL     DDORBR        JUORBR
      *
     C     EORBRVM       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Action
      ** Booking branch
      ** Originating branch
     C                   PARM                    DDACTN            1
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDORBR            3
      *
      ** ICD
     C                   PARM                    BJSBRC            3
     C                   PARM                    BKOBRU            1
     C                   PARM                    BKOBUV            1
      *
      ** Response mode (from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    RespMode          1
      *
      ** Default branch code from ZMUSER
     C                   PARM                    BRC               3
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Action code - OK
      ** Booking branch - OK
      ** Originating branch - OK
     C                   PARM                    DDACTNOK          1
     C                   PARM                    DDBRCDOK          1
     C                   PARM                    DDORBROK          1
      *
      ** Deal Booking Branch(es), Originating Branch, Customer
     C                   PARM                    JUDBRC            3
     C                   PARM                    JUMBCA            3
     C                   PARM                    JUORBR            3
     C                   PARM                    JUDCNO
      *
      ** Booking branch round down indicator
      ** Booking branch location
      ** Booking branch customer
      ** Booking branch account officer
     C                   PARM                    BkgBrRDFC         1
     C                   PARM                    BkgBrLCCD         3
     C                   PARM                    BkgBrCUST         6
     C                   PARM                    BkgBrACOC         2
      *                                                                                       CSD025
      ** Check if CSD025 (Customer De-Activation) is active                                   CSD025
      *                                                                                       CSD025
     C                   CALLB     'AOSARDR0'                                                 CSD025
     C                   PARM      *BLANKS       PRtCd             7                          CSD025
     C                   PARM      '*VERIFY'     POptn             7                          CSD025
     C                   PARM      'CSD025'      PSARD             6                          CSD025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD025
                                                                                              CSD025
     C                   MOVE      'N'           CSD025            1                          CSD025
     C                   IF        PRtCd = *Blanks                                            CSD025
     C                   EVAL      CSD025 = 'Y'                                               CSD025
     C                   ENDIF                                                                CSD025
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
