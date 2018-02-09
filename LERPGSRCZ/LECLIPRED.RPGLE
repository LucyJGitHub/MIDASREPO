     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans Read')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIPRED - LE Customer Loans Read                           *
      *                                                               *
      *  Function:  This module reads forwards and backwards stomer   *
      *             through the loans file.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 CAP074  *CREATE    Date 15Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLECLIPL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCKF:CLOANKL0)
     F                                     RENAME(CLOANCLF:CLOANCL0)
     FLECLIPL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCKF:CLOANKL1)
     F                                     RENAME(CLOANCLF:CLOANCL1)
     FLECLIPL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCKF:CLOANKL2)
     F                                     RENAME(CLOANCLF:CLOANCL2)
     FLECLIPL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCKF:CLOANKL3)
     F                                     RENAME(CLOANCLF:CLOANCL3)
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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
     C     @@FRNT        SETGT     CLOANCL1
     C                   ELSE
     C     @@FRNT        SETGT     CLOANCL0
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C     @@LNRF        SETGT     CLOANCL3
     C                   ELSE
     C     @@LNRF        SETGT     CLOANCL2
     C                   END
     C                   END
      *
      ***  Initialize the check record flag
      *
     C                   MOVEL     'N'           @@FND             1
      *
      ***  Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     RECI          OREQ      'D'
     C     @@ERR         ANDEQ     *ZERO
     C     @@FND         ANDEQ     'Y'
      *
      ***  Read from complete or requires authorization
      ***  or from authorized
      *
      *
      ***  If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C                   READ      CLOANCL1                               99
     C                   EXSR      CHKRCD
     C                   ELSE
     C                   READ      CLOANCL0                               99
     C                   EXSR      CHKRCD
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C                   READ      CLOANCL3                               99
     C                   EXSR      CHKRCD
     C                   ELSE
     C                   READ      CLOANCL2                               99
     C                   EXSR      CHKRCD
     C                   END
     C                   ENDIF
      *
      ***  If multi-branching, check if authorized to look at loan (based
      ***  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
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
     C     @@FRNT        SETLL     CLOANCL1
     C                   ELSE
     C     @@FRNT        SETLL     CLOANCL0
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C     @@LNRF        SETLL     CLOANCL3
     C                   ELSE
     C     @@LNRF        SETLL     CLOANCL2
     C                   END
     C                   END
      *
      ***  Initialize the check record flag
      *
     C                   MOVEL     'N'           @@FND
      *
      ***  Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     RECI          OREQ      'D'
     C     @@ERR         ANDEQ     *ZERO
     C     @@FND         ANDEQ     'Y'
      *
      ***  Read from complete or requires authorization
      ***  or from authorized
      *
      *
      ***  If the Mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     DDACTN        IFEQ      'X'
     C                   READP     CLOANCL1                               99
     C                   EXSR      CHKRCD
     C                   ELSE
     C                   READP     CLOANCL0                               99
     C                   EXSR      CHKRCD
     C                   ENDIF
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C                   READP     CLOANCL3                               99
     C                   EXSR      CHKRCD
     C                   ELSE
     C                   READP     CLOANCL2                               99
     C                   EXSR      CHKRCD
     C                   END
     C                   ENDIF
      *
      ***  If multi-branching, check if authorized to look at loan (based
      ***  on branch) but if invalid continue searching for valid branch
      *
     C     BJSBRC        IFEQ      *BLANK
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
      * CHKRCD - Check for allowed records
      *****************************************************************
     C     CHKRCD        BEGSR
      *
      ***  Loans displayed must correspond to loan type
      *
     C                   SELECT
     C     LoanType      WHENEQ    'LOAN'
     C     PTYP          IFEQ      61
     C     PTYP          OREQ      62
     C     PTYP          OREQ      63
     C     PTYP          OREQ      70
     C     PTYP          OREQ      80                                                        BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   MOVE      'Y'           @@FND
     C                   END
      *
     C     LoanType      WHENEQ    'PTPU'
     C     PTYP          IFEQ      64
     C     PTYP          OREQ      65
     C     PTYP          OREQ      68
     C     CLE005        ANDEQ     'Y'
     C     PTYP          OREQ      71
     C     CLE005        ANDEQ     'Y'
     C                   MOVE      'Y'           @@FND
     C                   END
      *
     C     LoanType      WHENEQ    'PTSO'
     C     PTYP          IFEQ      66
     C     PTYP          OREQ      67
     C     PTYP          OREQ      69
     C     CLE005        ANDEQ     'Y'
     C     PTYP          OREQ      72
     C     CLE005        ANDEQ     'Y'
     C                   MOVE      'Y'           @@FND
     C                   END
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
      ***  Validate that the deal number is numeric or blank.
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
                                                                                              CLE148
     C                   IF        wLoanAlpha = 'Y'                                           CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLNRF                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANK                                         CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
                                                                                              CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C                   IF        DDLNRF = *BLANK                                            CLE148
     C                              OR (wLoanAlpha = 'N' AND *IN98 = *ON                      CLE148
     C                              AND *IN99 = *ON) OR (wLoanAlpha = 'Y'                     CLE148
     C                              AND PValid = *BLANKS)                                     CLE148
     C                   MOVEL     DDLNRF        @@LNRF            6                          CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'N'                                           CLE148
     C                   MOVEL     '5045550'     @ERRMS                                       CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C                   MOVEL     '5045548'     @ERRMS                                       CLE148
     C                   MOVEL     PData         @ERRDTA                                      CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
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
      *
      ***  RETURN CODE
     C                   PARM                    RetCodeIn
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      ***  Action code
     C                   PARM                    DDACTN            1
      *
      ***  Deal number pointer
     C                   PARM                    DDLNRF            6
      *
      ***  Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      ***  Calling type
     C                   PARM                    LoanType          4
      *
      ***  Read forwards
     C                   PARM                    @RDFWD            1
      *
      ***  Read backwards
     C                   PARM                    @RDBCK            1
                                                                                             BUG3721
      ** Switchable Features                                                                 BUG3721
     C                   PARM                    CLE028            1                         BUG3721
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM                    @ERRMS            7
     C                   PARM                    @ERRDTA                                      CLE148
      *
      ***  Loan number read
     C                   PARM                    @LNRED            6
      *
      ***  Front Office Loan Read
     C                   PARM                    @FTRED           20
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LECLIPRED'   DBPGM
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
      *
      ***  Determine if Customer Lending Enhancements - Others
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   ENDIF
      *                                                                                       CLE148
      ** Parameter list for calling LELOANISO                                                 CLE148
      *                                                                                       CLE148
     C     P_LELOANISO   PLIST                                                                CLE148
      ** Loan Number (Input)                                                                  CLE148
     C                   PARM                    PLNRF                                        CLE148
      ** Validity Flags (Output)                                                              CLE148
     C                   PARM                    PValid                                       CLE148
      ** Check Digit (Output)                                                                 CLE148
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
