     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR: Validate Customer ShortName/Number')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRVCUSTNUM - Validate Customer Shortname or number           *
      *                                                               *
      *                                                               *
      *  Function:  This module receives a paramater containing the   *
      *             customer shortname or number and confirms if      *
      *             valid. If it is the 10A return code will be       *
      *             blank; if not it will contain error.              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 BUG5443            Date 24Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP055             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5443- Apply changes for feature CDL005                    *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors. Error message *
      *           for Parent customer still shows in next iterations. *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for customer details via access programs
     D  SDCUST       E DS                  EXTNAME(SDCUSTPD)
 
      **External dummy data structure
     D  DSSDY        E DS                  EXTNAME(DSSDY)
 
      **External dummy data structure (very long)                                             CSD025
     D  DSLDY        E DS                  EXTNAME(DSLDY)                                     CSD025
                                                                                              CSD025
      **External dummy data structure (short)                                                 CSD025
     D  DSFDY        E DS                  EXTNAME(DSFDY)                                     CSD025
                                                                                              CSD025
      ** Externally described DS for SAR details                                              CSD025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD025
                                                                                              CSD025
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Customer No/Shortname received as parameter
     D  SCNUM          S             10A
 
      **Error message code 1 received as a parameter
     D  Msgid1         S                   LIKE(#Msgid)
 
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   Errorfound
     C                   RESET                   Msgid1
 
      ** Customer Shortname and Number Validation
      ** Customer name or number must be entered
 
     C     SCNUM         IFEQ      *BLANKS
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'MMM0204'     Msgid1
     C                   ELSE
 
      *Call access programme to determine whether number or shortname
      *entered is valid.
 
     C*****              CALLB     'AOCUSTR0'                                                 CSD025
     C                   CALLB     'AOCUSTR1'                                                 CSD025
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY      '  @OPTN
     C                   PARM      SCNUM         @CNUM            10
     C                   PARM      *BLANK        @KYST             7
     C*****SDCUST        PARM      SDCUST        DSSDY                                        CSD025
     C     SDCUST        PARM      SDCUST        DSLDY                                        CSD025
 
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'MMM0205'     Msgid1
     C                   ELSE
                                                                                              CSD025
      * Check for De-Activation if CSD025 is active                                           CSD025
                                                                                              CSD025
     C                   IF        CSD025 = 'Y'                                               CSD025
     C                             and BBDEAC = 'Y' and ACTNCD = 'I'                          CSD025
                                                                                              CSD025
     C                   EVAL      ErrorFound = 'Y'                                           CSD025
     C                   MOVEL     'ABM0028'     Msgid1                                       CSD025
                                                                                              CSD025
     C                   ENDIF                                                                CSD025
                                                                                              CAP055
      ** If the customer details are found, check that it is not a parent                     CAP055
                                                                                              CAP055
     C     BBPAIN        IFEQ      'P'                                                        CAP055
     C                   EVAL      ErrorFound = 'Y'                                           CAP055
     C                   EVAL      Msgid1 = 'MMM0206'                                         CAP055
     C                   ENDIF                                                                CAP055
                                                                                              CAP055
     C                   MOVEL     SCNUM         @QMARK            1
     C     @QMARK        IFEQ      '?'
     C                   MOVE      *BLANKS       SCNUM
     C                   MOVEL     BBCUST        SCNUM
     C                   END
     C     CustFormat    IFEQ      'S'                                                       BUG5443
     C                   MOVEL     BBCSSN        SCNUM                                       BUG5443
     C                   ENDIF                                                               BUG5443
     C                   END
     C                   END
 
      *
      *If*the*customer*details*are*found*,check*that*it*is*not*a*parent.                      CAP055
      **********                                                                              CAP055
     C*****BBPAIN        IFEQ      'P'                                                        CAP055
     C**********         MOVE      'Y'           Errorfound                                   CAP055
     C**********         MOVEL     'MMM0206'     Msgid1                                       CAP055
     C**********         END                                                                  CAP055
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    SCNUM
     C     SDCUST        PARM                    SDCUST
     C                   PARM                    ACTNCD            1                          CSD025
     C                   PARM                    CustFormat        1                         BUG5443
 
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
                                                                                              CSD025
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
