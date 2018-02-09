     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover Instructions read')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELERIRED - LE Rollover Instructions read                    *
      *                                                               *
      *  Function:  This module reads forwards and backwards stomer   *
      *             through the loans file.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9737            Date 29Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 CAP084             Date 09Jan04               *
      *                 CAP076  *CREATE    Date 16Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9737- Must included in CLE106 delivery due to changes made*
      *           CLE036 in loans file.(Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CAP084 - Loan details from CLOANCL have not been set up      *
      *           before checking authorisation so branch is not set  *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ***  LE Live rollover details
     FLELOANL2  IF   E           K DISK    INFSR(*PSSR)
      *
      ***  LE Rollovers requiring authorisation details
      *
     FLELOANL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CloanckF:CloanCk3)
      ***  LE Live rollover details by Front Office Id.
     FLELERIL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CloanckF:CloanFO1)
      *
      ***  LE Rollovers requiring authorisation details by Front Office Id.
     FLELERIL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CloanckF:CloanFO2)
      *
      ***  Customer Loans file - by Loan Number.
     FLECLIPL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CloanclF:CloancWl)
     F                                     RENAME(CloanckF:ClaoncWk)
      *
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
      ******True*******logical*=**on*(for*indcator*processing)*********                       CAP084
      ******False******logical*=**off*(for*indcator*processing)********                       CAP084
      **    True       logical = *on (for indicator processing)                               CAP084
      **    False      logical = *off (for indicator processing)                              CAP084
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *                                                                                       CLE148
      ** Parameters for calling LELOANISO (Validate Loan Number)                              CLE148
      *                                                                                       CLE148
     D PLNRF           S              6A                                                      CLE148
     D PValid          S              6A                                                      CLE148
     D PChkDigit       S              1A                                                      CLE148
     D PData           S              2A                                                      CLE148
      *                                                                                       CLE148
     D wLoanAlpha      S              1A                                                      CLE148
     D @ERRDTA         S              2A                                                      CLE148
     D @@LNRF          S              6A                                                      CLE148
      *
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
      ***  Initialize outputs
      *
     C                   MOVEL     *BLANK        @ERRMS
     C                   MOVEL     *BLANK        @ERRDTA                                      CLE148
     C                   MOVEL     *BLANK        @LNRED
     C                   MOVEL     *BLANK        @FTRED
      *
      ***  Check for user authority to browse if not multi-branching
      *
     C     BJSBRC        IFNE      *BLANK
      *
      * Access CLOAN record CL to obtain branch code
     C                   MOVE      DDLNRF        @@LNRF
     C     @@LNRF        CHAIN     LECLIPL2                           85
      *
     C                   EXSR      CHAUTN
     C                   END
      *
      ***  Validate loan number (for pionter)
      *
     C                   EXSR      VALDLN
      *
      ***  Read forwards
      *
     C     @RDFWD        IFEQ      'Y'
     C                   EXSR      RDFWD
     C                   ELSE
      *
      ***  Read backwards
      *
     C     @RDBCK        IFEQ      'Y'
     C                   EXSR      RDBCK
     C                   END
     C                   END
      *
      ***  Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDFWD - Read forwards through loans file
      *****************************************************************
     C     RDFWD         BEGSR
      *
      ***  Position to current record on file
      *
      *
      ***  If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      ***  Do position with front office ID on file
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C     @@FRNT        SETGT     LELERIL2
     C                   ELSE
     C     @@FRNT        SETGT     LELERIL1
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C     @@LNRF        SETGT     LELOANL3
     C                   ELSE
     C     @@LNRF        SETGT     LELOANL2
     C                   END
     C                   END
      *
      ***  Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     RECI          OREQ      'D'
     C     @@ERR         ANDEQ     *ZERO
      *
      ***  Read from complete or requires authorization
      ***  or from authorized
      *
      *
      ***  If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C                   READ      LELERIL2                               99
     C                   ELSE
     C                   READ      LELERIL1                               99
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C                   READ      LELOANL3                               99
     C                   ELSE
     C                   READ      LELOANL2                               99
     C                   END
     C                   ENDIF
      *
      ***  If multi-branching, check if authorized to look at loan (based
      ***  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
                                                                                              CAP084
      ** Access CLOAN record CL to obtain branch code                                         CAP084
     C                   MOVE      LNRF          @@LNRF                                       CAP084
     C     @@LNRF        CHAIN     LECLIPL2                           85                      CAP084
                                                                                              CAP084
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   END
      *
     C                   END
      *
      ***  If end of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C     DDLNRF        IFEQ      *BLANKS
     C     FOTRID        ANDEQ     *BLANKS
     C                   MOVEL     'LEV9000'     @ERRMS
     C                   ELSE
     C                   MOVEL     'LEV9001'     @ERRMS
     C                   END
      *
      ***  Else, return the loan number read
      *
     C                   ELSE
     C                   MOVE      LNRF          @LNRED
     C                   MOVE      FRNT          @FTRED
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - Read backwards through loans file
      *****************************************************************
     C     RDBCK         BEGSR
      *
      ***  Position to current record on file
      *
      *
      ***  If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C     @@FRNT        SETLL     LELERIL2
     C                   ELSE
     C     @@FRNT        SETLL     LELERIL1
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C     @@LNRF        SETLL     LELOANL3
     C                   ELSE
     C     @@LNRF        SETLL     LELOANL2
     C                   END
     C                   END
      *
      ***  Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     RECI          OREQ      'D'
     C     @@ERR         ANDEQ     *ZERO
      *
      ***  Read from complete or requires authorization
      ***  or from authorized
      *
      *
      ***  If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C                   READP     LELERIL2                               99
     C                   ELSE
     C                   READP     LELERIL1                               99
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C                   READP     LELOANL3                               99
     C                   ELSE
     C                   READP     LELOANL2                               99
     C                   END
     C                   ENDIF
      *
      ***  If multi-branching, check if authorized to look at loan (based
      ***  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
                                                                                              CAP084
      ** Access CLOAN record CL to obtain branch code                                         CAP084
     C                   MOVE      LNRF          @@LNRF                                       CAP084
     C     @@LNRF        CHAIN     LECLIPL2                           85                      CAP084
                                                                                              CAP084
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   END
      *
     C                   END
      *
      ***  If start of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'LEV9002'     @ERRMS
      *
      ***  Else, return the loan number read
      *
     C                   ELSE
     C                   MOVE      LNRF          @LNRED
     C                   MOVE      FRNT          @FTRED
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - Check for user authority if not multi-branching
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ***  Return error message
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'LEV9003'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALDLN - Validate loan number pointer
      *****************************************************************
     C     VALDLN        BEGSR
      *
     C                   MOVE      FOTRID        @@FRNT           20
      *
      ***  Validate that the Loan number is numeric or blank.
      *
     C                   TESTN                   DDLNRF               98
     C                   MOVE      DDLNRF        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C*****DDLNRF        IFEQ      *BLANKS                                                    CLE148
     C******IN98         OREQ      '1'                                                        CLE148
     C******IN99         ANDEQ     '1'                                                        CLE148
     C**********         MOVE      DDLNRF        @@LNRF            6 0                        CLE148
      *
      *****Return*error*message****************************************                       CLE148
      *
     C**********         ELSE                                                                 CLE148
     C**********         MOVEL     'LEV9004'     @ERRMS                                       CLE148
     C**********         RETURN                                                               CLE148
     C**********         END                                                                  CLE148
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'Y'                                           CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLNRF                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANK                                         CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
      *                                                                                       CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        DDLNRF = *BLANKS                                           CLE148
     C                              OR (wLoanAlpha = 'N' AND *IN98 = *ON                      CLE148
     C                              AND *IN99 = *ON) OR (wLoanAlpha = 'Y'                     CLE148
     C                              AND PValid = *BLANKS)                                     CLE148
     C                   MOVEL     DDLNRF        @@LNRF                                       CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'N'                                           CLE148
     C                   MOVEL     '5045550'     @ERRMS                                       CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C                   MOVEL     '5045548'     @ERRMS                                       CLE148
     C                   MOVEL     PData         @ERRDTA                                      CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   RETURN                                                               CLE148
     C                   ENDIF                                                                CLE148
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *ENTRY        PLIST
      *
      ***  INPUT PARAMETERS
 
      * Return code
     C                   PARM                    RetCodeIn
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      * Action code
     C                   PARM                    DDACTN            1
      * Loan number pointer
     C                   PARM                    DDLNRF            6
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * Read forwards
     C                   PARM                    @RDFWD            1
      * Read backwards
     C                   PARM                    @RDBCK            1
      *
      ***  OUTPUT PARAMETERS
 
      * Error message
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM                    @ERRMS            7
     C                   PARM                    @ERRDTA                                      CLE148
      * Loan number read
     C                   PARM                    @LNRED            6
      * Front Office Loan Read
     C                   PARM                    @FTRED           20
      *
      *** Initialize program name
      *
     C                   MOVEL     'LELERIRED'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *                                                                                       CLE148
      ** Parameter list for calling LELOANISO                                                 CLE148
      *                                                                                       CLE148
     C     P_LELOANISO   PLIST                                                                CLE148
      *                                                                                       CLE148
      ** Loan Number (Input)                                                                  CLE148
      *                                                                                       CLE148
     C                   PARM                    PLNRF                                        CLE148
      *                                                                                       CLE148
      ** Validity Flags (Output)                                                              CLE148
      *                                                                                       CLE148
     C                   PARM                    PValid                                       CLE148
      *                                                                                       CLE148
      ** Check Digit (Output)                                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PChkDigit                                    CLE148
     C                   PARM                    PData                                        CLE148
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
(c) Finastra International Limited 2002
