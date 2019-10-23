     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee settlement screen input')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFESTSIN - Fee Settlement Screen Input                      *
      *                                                               *
      *  Function:  This program allows entry and maintenance of      *
      *             fee settlements.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD054354           Date 23Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 CLE025             Date 20May04               *
      *                 TDA077             Date 16Apr04               *
      *                 CDL018             Date 03Feb04               *
      *                 CAAA03             Date 01Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 04Nov03               *
      *                 CAP084             Date 21Jul03               *
      *                 CLE031             Date 10Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072  *CREATE    Date 28Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054354 - Settlement of fee accrual for prior period for    *
      *             backdated notional change                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TDA077 - The Default settlement being passed by SD2400 is    *
      *            incorrect.                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CAAA03 - Webfacing changes. F5 appears on enquiry, delete and*
      *           authorise screens though no details are amendable.  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - Midas Plus API development                          *
      *         - Valid file does not match LEFEEAD                   *
      *         - Use 24x7 runday                                     *
      *         - parms changed for LEFESTVAL                         *
      *         - Missing fields on display                           *
      *         - Correct spelling mistakes in comments etc.          *
      *         - Pressing F5 should refresh the browser subfile.     *
      *         - Always display Settlement screen if action A or X.  *
      *         - AOOUFAU0 failed with decimal data error if the User *
      *           did not validate the settlement instructions the    *
      *           first time around.                                  *
      *         - Amending an authorised Fee Settlement changed its   *
      *           status to 'Complete' and cleared the User profiles. *
      *  CLE031 - Lending Enhancements.                               *
      *           LEFEED & LEFEEAD changed  - recompile               *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

     FLEFEEAL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEADF:LEFEEAD1)

     FLEFEEAL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEADF:LEFEEAD0)

     FLEFESTDDF CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(LEFESTS1:RRN1)
      *****************************************************************
      *                                                               *
      *    F U N C T I O N   O F   I N D I C A T O R S                *
      *                                                               *
      *    03      F3 PRESSED EXIT PROGRAM                            *
      *    05      F5 PRESSED REFRESH SCREEN                          *
      *    09      F9 PRESSED GO TO ADD MODE                          *
      *    10      F10 PRESSED GO TO DELETE                           *
      *    11      F11 PRESSED GO TO AUTHORISE                        *
      *    12      F12 PRESSED GO TO PREVIOUS SCREEN                  *
      *    14      F14 PRESSED GO TO SETTLEMENT SCREEN                *
      *                                                               *
      *    25      Message subfile                                    *
      *                                                               *
      *    30      Subfile display (SFLDSP)                           *
      *    31      SFLDSPCTL                                          *
      *    32      SFLEND(*MORE)                                      *
      *    33      ROLLUP                                             *
      *    35      SFLNXTCHG                                          *
      *    36      Invalid subfile selection                          *
      *    37      Invalid 'review from' customer number              *
      *    38      Invalid 'review from' facility type                *
      *    39      Invalid 'review from' facility number              *
      *                                                               *
      *    40      Invalid action code                                *
      *    41      Invalid customer number                            *
      *    42      Invalid facility type                              *
      *    43      Invalid facility number                            *
      *    44      Invalid fee sequence                               *
      *    45      Invalid value date                                 *
      *    46      Invalid amount                                     *
      *    47      Invalid type                                       *
      *                                                               *
      *    63      Enable Settlements Screen                          *
      *    64      Authorisation allowed                              *
      *    65      No Records Found in Subfile                        *
      *    66      Enable F11                                         *
      *    67      Protect Fields                                     *
      *    68      Enable F10                                         *
      *    69      Protect 'key' fields                               *
      *                                                               *
      *    70      READ and/or CHAIN Files                            *
      *    90-99   Used by standard subroutine                        *
      *****************************************************************
      /SPACE 5

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------

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
      ** Error indicators
     D #EI             S              1    DIM(25)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      *  Array for job name                                                                   CSC022
     D ARRJBNAM        S             10A   DIM(10)                                            CSC022
      ** Fee Settlement Details in screen format
     D FEST          E DS                  EXTNAME(LEFESTPD)

      ** Fee Settlement Details OK indicator
     D FEST_OK       E DS                  EXTNAME(LEEFESTPD)


      ** Fee Settlement Details in file format
     D LEFEESTFmt    E DS                  EXTNAME(LEFEEAD)
     D***LefeeaREC            124    192                                                      CGL029
     D***LefeeaPAY            193    751                                                      CGL029
     D  LefeeaREC1           124    125                                                       CGL029
     D  LefeeaREC2           138    192                                                       CGL029
     D  LefeeaPAY1           193    194                                                       CGL029
     D  LefeeaPAY2           207    751                                                       CGL029

      ** New Fee Settlement Details in file format
     D LEVFESTPD     E DS                  EXTNAME(LEVFESTPD)
     D  LEVFESTOURS  E                     EXTFLD(QQOURS)                                     CGL029
     D  V_REC                 72    140
     D  V_PAY                141    699


      ** Review from fields
     D R#Flds          DS
     D  R#CSSN                 1     10
     D  R#FACT                11     13
     D  R#FCNO                14     15
     D  R#UNAU                16     16


      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D***FLREC**                1     69                                                      CGL029
     D  FLREC1                 1      2                                                       CGL029
     D  FLREC2                21     75                                                       CGL029

      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY1                 1      2                                                       CGL029
     D  FLPAY2                21    565                                                       CGL029

      * File Fra/irs instructions
     D F_FRI         E DS                  EXTNAME(SDESFFPD)

      * Screen Receive instructions
     D S_REC         E DS                  EXTNAME(SDESSRPD)

      * Screen Payment instructions
     D S_PAY         E DS                  EXTNAME(SDESSPPD)

      * Screen Fra/irs instructions
     D S_FRI         E DS                  EXTNAME(SDESSFPD)

      *                                                                                       CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
     D  COMITNOM               1      3S 0                                                    CSC022
     D  COMITJOB               4    103                                                       CSC022
      *                                                                                       CSC022
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Module details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** Retail details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)

      ** Customer lending Details
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)

      ** SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Data structure for passing a parameter to synon screen
      ** handling program.
     D SETLIB        E DS                  EXTNAME(SETLIAB) INZ
     D  SETLIBRONS   E                     EXTFLD(QQRONS)                                     CGL029
     D  SETLIBPONS   E                     EXTFLD(QQPONS)                                     CGL029

      ** Data structure for passing a parameter to synon screen
      ** handling program.
     D SETLIZ        E DS                  EXTNAME(SETLIAZ)
                                                                                              222373
     D P@ARM3        E DS                  EXTNAME(SDSETLPD)                                  222373


      ** IN Message Format
     D P#INMF        E DS                  EXTNAME(LEF5MFPD)
     D  P#INMFRONS   E                     EXTFLD(QQRONS)                                     CGL029
     D  P#INMFPONS   E                     EXTFLD(QQPONS)                                     CGL029

      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LEF6MFPD)
                                                                                              CAP084
      ** 24X7 status dataarea                                                                 CAP084
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CAP084
                                                                                              CAP084
      ** SD data area                                                                         CAP084
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CAP084

      ** +--------------------------------------+                                             CSC022
      ** ¦ Use of Indicator                     ¦                                             CSC022
      ** ¦ ================                     ¦                                             CSC022
      ** |                                      |                                             CSC022
      ** | 17      Used by LOOKUP               |                                             CSC022
      ** +--------------------------------------+                                             CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CAP084
     D CSC011          S              1A   INZ('N')                                           CAP084
     D WProcDate       S                   LIKE(BJRDNB)                                       CAP084
     D PRTCD           S              7A                                                      CAP084
     D POPTN           S              7A                                                      CAP084
     D PSARD           S              6A                                                      CAP084

     D CSC022          S              1A   INZ('N')                                           CSC022
      ** Counter variable                                                                     CSC022
     D WCMT01          S              1A                                                      CSC022
      ** Commitment Flag                                                                      CSC022
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SKFESTS001

      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      /COPY WNCPYSRC,LSFESTS002
     C
      * Initialisation
     C                   EXSR      INITPR

      * Build Subfile
     C                   EXSR      BLDSFL

      * Display Screen
     C                   EXSR      REVIEW

      *  Terminate program
     C                   EXSR      CF03

      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Build subfile                                                 *
      *****************************************************************
     C     BLDSFL        BEGSR

      * If not rollup

     C     *IN33         IFEQ      *OFF
     C     R#Flds        ORNE      P_R#Flds

      * Reset subfile RRN
     C                   Z-ADD     *ZEROS        RRN1              4 0

      ** Validate 'review from' fields

     C                   EXSR      VAL_R#Flds

      ** Highlight 'review from' fields in error

     C     R#CSSNok      COMP      'Y'                                3737
     C     R#FACTok      COMP      'Y'                                3838
     C     R#FCNOok      COMP      'Y'                                3939

     C     R#UNAU        IFNE      'Y'
     C                   MOVEL     'N'           R#UNAU
     C                   ENDIF

     C     *IN37         IFEQ      *OFF
     C     *IN38         ANDEQ     *OFF
     C     *IN39         ANDEQ     *OFF
     C                   MOVEL     R#Flds        P_R#Flds         16
     C                   ELSE
     C                   MOVEL     *ALL'!'       P_R#Flds
     C                   ENDIF

      * Send messages to the screen
     C                   CLEAR                   FEST_OK
     C                   EXSR      SET_SCEI

      **  Clear subfile
     C                   MOVEA     '000'         *IN(30)
     C                   WRITE     LEFESTC1

     C                   MOVEL     R_CNUM        K#CNUM
     C                   MOVEL     R_FACT        K#FACL
     C                   MOVE      R_FCNO        K#FACL
     C**********         Z-ADD     *ZERO         K#LOAN                                       CLE148
     C                   MOVEL     *BLANKS       K#LOAN                                       CLE148
     C                   Z-ADD     *ZERO         K#FSEQ
     C                   Z-ADD     *ZERO         K#VDAT

     C                   ELSE

     C                   Z-ADD     HI_RRN1       RRN1

     C                   ENDIF

     C     R#UNAU        IFEQ      'Y'
     C     FEEAKY        SETGT     LEFEEAL3
     C                   ELSE
     C     FEEAKY        SETGT     LEFEEAL2
     C                   ENDIF

      * Read from file

     C     R#UNAU        IFEQ      'Y'
     C                   READ      LEFEEAL3                               32
     C                   ELSE
     C                   READ      LEFEEAL2                               32
     C                   ENDIF

      * Do until EOF or 10 records read

     C                   Z-ADD     0             Count_Read        4 0

     C     *IN32         DOWEQ     *OFF
     C     Count_Read    ANDLT     10
      *
     C                   MOVE      *BLANKS       S#SEL

      * If multi-branching
      * Check whether user is authorised to view this branch

     C                   Z-ADD     *ZERO         @ERR
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVBBU'
     C                   PARM                    FABRCA
     C                   PARM                    @ERR              1 0
     C                   ENDIF

      * If authorised to view this branch

     C     @ERR          IFEQ      *ZERO

      * Fee Settlement Convert

     C                   EXSR      FESTCVT

      * Increment subfile RRN
     C                   ADD       1             RRN1

      * Increment count of records read
     C                   ADD       1             Count_Read
      *
     C                   WRITE     LEFESTS1

     C                   ENDIF

      * Point read to
     C                   MOVEL     FACNUM        K#CNUM
     C                   MOVEL     FAFACL        K#FACL
     C**********         Z-ADD     FALOAN        K#LOAN                                       CLE148
     C                   MOVEL     FALOAN        K#LOAN                                       CLE148
     C                   Z-ADD     FAFSEQ        K#FSEQ
     C                   Z-ADD     FAVDAT        K#VDAT

      * Read from file

     C     R#UNAU        IFEQ      'Y'
     C                   READ      LEFEEAL3                               32
     C                   ELSE
     C                   READ      LEFEEAL2                               32
     C                   ENDIF
      *
     C                   ENDDO

      * Highest subfile record

     C                   Z-ADD     RRN1          HI_RRN1           4 0

      ** Set on subfile display indicators.

     C     RRN1          IFGT      0

     C                   MOVEA     '11'          *IN(30)

      *  Records found
     C                   MOVE      *OFF          *IN65

      *  Position subfile
     C                   Z-ADD     RRN1          ##SFRC
      *
     C                   ELSE

      *  Records not found
     C                   MOVEA     '01'          *IN(30)
     C                   MOVE      *ON           *IN65
     C                   Z-ADD     0             ##SFRC

     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Process Review Screen                                         *
      *****************************************************************
     C     REVIEW        BEGSR

      **  Clear Message subfile

     C                   EXSR      CLEARM

      ** Display the screen until CF/3 or CF/12 taken

     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LEFESTF2
     C                   WRITE     LEFESTF5
     C                   WRITE     #MSGCTL
     C   65              WRITE     LEFESTF4
     C                   EXFMT     LEFESTC1

      ** Set off 'review from' fields error indicators
     C                   SETOFF                                       373839

      **  Clear Message subfile

     C                   EXSR      CLEARM

      **  Record current screen

     C                   MOVE      'SFL'         CurrentSCR        3

      **  F3  - Exit
     C     *IN03         CASEQ     '1'           CF03

      **  F5 - Refresh
     C     *IN05         CASEQ     '1'           CF05

      **  F9 - Add
     C     *IN09         CASEQ     '1'           CF09

      **  F12 - Previous
     C     *IN12         CASEQ     '1'           CF03

      **  Rollup
     C     *IN33         CASEQ     '1'           BLDSFL

      **  Reposition review
     C     R#Flds        CASNE     P_R#Flds      BLDSFL

      **  Enter Key Processing - Process subfile selection
     C                   CAS                     PROSEL
      *
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Exit program                                                  *
      *****************************************************************
     C     CF03          BEGSR

      ** Close the extended settlements program and end processing

     C                   MOVE      'T'           PMTERM
     C                   CALL      'SD2400'
     C                   PARM                    @RTCD
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ
     C**********         PARM                    SLNREF            6 0                 222373 CLE148
     C                   PARM                    SLNREF            6                          CLE148
     C                   PARM                    P@ARM3                                       222373
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Refresh Screen                                                *
      *****************************************************************
     C     CF05          BEGSR

      ** Clear Message subfile
     C                   EXSR      CLEARM

      ** If the current screen is the Subfile

     C     CurrentSCR    IFEQ      'SFL'

      ** Clear Selection field

     C     *IN65         IFEQ      *OFF
     C     1             CHAIN     LEFESTS1                           70
     C     *IN70         DOWEQ     *OFF
     C                   MOVE      ' '           S#SEL
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN36
     C                   UPDATE    LEFESTS1
     C                   READC     LEFESTS1                               70
     C                   ENDDO
     C                   ENDIF

      ** Position to first page

     C                   Z-ADD     1             ##SFRC
     C                   EXSR      BLDSFL                                                     CAP084
      *
     C                   ELSE

      ** If the current screen is the Insert screen
      ** Clear screen fields and reset screen error indicators

     C     CurrentSCR    IFEQ      'INS'
     C                   EXSR      CLR_FAS
     C                   EXSR      RESET_SCEI
      *
     C                   ELSE

      ** If the current screen is the Amend screen
      ** Re-display the screen fields and reset screen error indicators

     C     CurrentSCR    IFEQ      'AMD'
     C                   EXSR      POPSCR
     C                   EXSR      RESET_SCEI
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Insert a record                                               *
      *****************************************************************
     C     CF09          BEGSR

      **  Clear screen fields
     C                   EXSR      CLR_FAS
      *
     C                   MOVE      'I'           S#ACTN
     C                   MOVE      *OFF          *IN12
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *OFF          *IN67
     C                   MOVE      *OFF          *IN68
     C                   MOVE      *OFF          *IN69
     C                   MOVE      *ON           *IN62                                        CAAA03

      * Disable settlements screen
     C                   MOVE      *OFF          *IN63

     C                   MOVE      'N'           SSCR_SetUp

     C                   Z-ADD     0             P_WIdx
     C                   MOVE      'Y'           Valid_Set
      *
     C                   MOVE      'INS'         CurrentSCR        3

      ** Display the screen until CF/3 or CF/12 taken

     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LEFESTF2
     C                   WRITE     LEFESTF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEFESTF3

      **  Clear Message subfile
     C                   EXSR      CLEARM

      **  F3  - Exit
     C     *IN03         CASEQ     '1'           CF03

      **  F5  - Refresh
     C     *IN05         CASEQ     '1'           CF05

      **  F12 - Previous
     C     *IN12         CASEQ     '1'           CF12

      **  F14 - Settlements
     C     *IN14         CASEQ     '1'           CF14

      **  Enter Key Processing - Validate the fee settlement details
     C                   CAS                     VAL_FEST
      *
     C                   ENDCS
      *
     C                   ENDDO

      ** Rebuild the subfile

     C                   EXSR      BLDSFL

      * Setoff 'add' and 'previous screen' indicators
     C                   MOVE      *OFF          *IN09
     C                   MOVE      *OFF          *IN12
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Process the deletion and authorisation screens                *
      *****************************************************************
     C     CF10_11       BEGSR

      ** Clear Message subfile

     C                   EXSR      CLEARM
     C                   MOVEL     LEFEESTFmt    LEVFESTPD
     C*******            MOVEL     S#ACTN        STTYLC                                       CAP084

      ** Update the database

     C                   EXSR      UPD_DBASE

      ** If there were errors in database update
      ** report them

     C     RetCodeOut    IFEQ      '*RECUPD'

     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     WCMT01        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   MOVEL     'LEP0026'     ZAMSID
     C                   EXSR      ZASNMS

     C                   ELSE

     C     RetCodeOut    IFNE      *BLANK
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     WCMT01        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C     MsgIDArr(1)   IFNE      *BLANK
     C                   MOVEL     MsgIDArr(1)   ZAMSID
     C                   ELSE
     C                   MOVEL     'LEL0035'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS

     C                   ELSE

      ** Commit the database changes

     C     CSC022        IFEQ      'N'                                                        CSC022
     C     WCMT01        OREQ      'N'                                                        CSC022
     C     CSC022        ANDEQ     'Y'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022

     C                   ENDIF
     C                   ENDIF

      ** Update status on subfile record
     C     S#ACTN        IFEQ      'X'
     C                   MOVEL     'LEF0287'     ZAMSID
     C                   ELSE
     C                   MOVEL     'LEF0288'     ZAMSID
     C                   ENDIF
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        S#STAT

      **  Move to previous screen
     C                   MOVE      *ON           *IN12

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Previous screen                                               *
      *****************************************************************
     C     CF12          BEGSR

      ** Clear Message subfile

     C                   EXSR      CLEARM

      ** Reset screen error indicators

     C                   EXSR      RESET_SCEI
      *
     C                   MOVEL     S_S#SADE      S#SADE
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Extended Settlement Details                                   *
      *****************************************************************
     C     CF14          BEGSR

      * Enable settlements screen
     C                   MOVE      *ON           *IN63

      * Protect key fields
     C                   MOVE      *ON           *IN69

      ** Setup the settlement screen fields (SETLIAB/SETLIAZ)

     C     SSCR_SetUp    IFEQ      'N'
     C                   EXSR      SETUP_SSCR
     C                   MOVE      'Y'           SSCR_SetUp        1
     C                   ENDIF
                                                                                              TDA077
     C     S#ACTN        IFEQ      'I'                                                        TDA077
     C                   MOVE      'A'           PMACTC                                       TDA077
     C                   ENDIF                                                                TDA077

      ** Call extended settlements input

     C                   CALL      'SD2400'
     C                   PARM                    @RTCD
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ
     C**********         PARM                    SLNREF            6 0                 222373 CLE148
     C                   PARM                    SLNREF            6                          CLE148
     C                   PARM                    P@ARM3                                       222373

      ** Terminate the program if database error returned

     C     PMDBSE        IFNE      *ZERO
     C                   MOVEL     PMDBFL        DBFILE
     C                   MOVE      PMDBSE        DBASE
     C                   MOVEL     PMDBKY        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVE      'N'           PMFRST

      ** If CF/3 taken in settlements screen, end the program

     C     PMCMDP        IFEQ      '03'
     C                   MOVE      '1'           *IN03
     C                   MOVE      '0'           *IN14
      *
     C                   ELSE

      ** If settlement details not valid (or no validation done)
      ** return to the main screen and send a message
      ** Otherwise, update the file fields with the screen fields

     C     PMSDTV        IFNE      'Y'

     C                   MOVE      'N'           Valid_Set
     C                   MOVE      '0'           *IN63                                       CAP084
     C     PMERCD        IFNE      *BLANK
     C                   MOVEL     'LEA1020'     ZAMSID
     C                   ELSE
     C                   MOVEL     'LEX9991'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS

     C                   ELSE
     C                   MOVE      'Y'           Valid_Set         1
     C                   EXSR      SET_SC2FL
     C                   EXSR      SETTLEINS
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Process selection from subfile screen                         *
      *****************************************************************
     C     PROSEL        BEGSR

      **  Process selection only if records exist on subfile

     C     *IN65         IFEQ      *OFF

      **  Clear Message subfile
     C                   EXSR      CLEARM

      **  Validate all changes in the subfile

     C                   MOVE      'N'           SubfilErr         1
     C                   Z-ADD     1             ##SFRC
      *
     C                   READC     LEFESTS1                               70
     C     *IN70         DOWEQ     *OFF
      *
     C     S#SEL         IFNE      ' '

      * Validate subfile selection

     C                   EXSR      VLDALL

     C                   Z-ADD     RRN1          ##RRN1            4 0
     C                   Z-ADD     RRN1          ##SFRC

      **  If no errors in the subfile, execute the valid option subroutine

     C     SubfilErr     IFEQ      'N'
     C                   SELECT
     C     S#ACTN        WHENEQ    'E'
     C                   EXSR      ENQRYS
     C     S#ACTN        WHENEQ    'A'
     C                   EXSR      AMENDS
     C     S#ACTN        WHENEQ    'D'
     C                   EXSR      DELETE
     C     S#ACTN        WHENEQ    'X'
     C                   EXSR      AUTHOR
     C                   ENDSL
     C                   MOVE      *BLANK        S#SEL
     C                   ELSE
     C                   MOVE      *ON           *IN35
     C                   ENDIF

     C                   ENDIF
      *
     C                   UPDATE    LEFESTS1
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN36

      **  Read next changed record
     C                   READC     LEFESTS1                               70
      *
     C                   ENDDO
      *
     C                   MOVE      *OFF          *IN12
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate subfile selection
      *****************************************************************
     C     VLDALL        BEGSR

      *  'I' is not a valid selection

     C     S#SEL         IFEQ      'I'

     C                   MOVE      *ON           *IN36

      *  Display error message
     C                   MOVEL     'LEP0002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           SubfilErr

     C                   ELSE

     C                   EXSR      FESTRTV

      * If an error was detected
     C     Idx           IFNE      0
     C                   MOVE      *ON           *IN36

      * Send messages to the screen
     C                   CLEAR                   FEST_OK
     C                   EXSR      SET_SCEI
     C                   MOVEL     'Y'           SubfilErr
     C                   ENDIF

     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Process enquiry screen                                        *
      *****************************************************************
     C     ENQRYS        BEGSR

      **  Move file fields to screen fields

     C                   EXSR      POPSCR
      *
     C                   MOVE      *OFF          *IN12
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *ON           *IN67
     C                   MOVE      *OFF          *IN68
     C                   MOVE      *ON           *IN69
     C                   MOVE      *OFF          *IN62                                        CAAA03

      * Enable settlements screen
     C     W#PTFI        IFNE      'I'
     C                   MOVE      *ON           *IN63
     C                   ELSE
     C                   MOVE      *OFF          *IN63
     C                   ENDIF

     C                   MOVE      'N'           SSCR_SetUp

      ** Display the screen until CF/3 or CF/12 taken

     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LEFESTF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEFESTF3

      **  Clear Message subfile
     C                   EXSR      CLEARM

      **  F3  - Exit
     C     *IN03         CASEQ     '1'           CF03

      **  F12- Previous
     C     *IN12         CASEQ     '1'           CF12

      **  F14 - Settlements
     C     *IN14         CASEQ     '1'           CF14

      **  Process Window
     C                   CAS                     SRWNDW
      *
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Process Amend Screen                                          *
      *****************************************************************
     C     AMENDS        BEGSR

      **  Move file fields to screen fields

     C                   EXSR      POPSCR
      *
     C                   MOVE      *OFF          *IN12
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *OFF          *IN67
     C                   MOVE      *OFF          *IN68
     C                   MOVE      *ON           *IN69
     C                   MOVE      *ON           *IN62                                        CAAA03

      * Enable settlements screen
     C     W#PTFI        IFNE      'I'
     C                   MOVE      *ON           *IN63
     C                   ELSE
     C                   MOVE      *OFF          *IN63
     C                   ENDIF

     C                   MOVE      'N'           SSCR_SetUp

     C                   Z-ADD     0             P_WIdx
     C                   MOVE      'Y'           Valid_Set

     C                   MOVE      'AMD'         CurrentSCR        3

      ** Display the screen until CF/3 or CF/12 taken

     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LEFESTF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEFESTF3

      **  Clear Message subfile
     C                   EXSR      CLEARM

      **  F3  - Exit
     C     *IN03         CASEQ     '1'           CF03

      **  F5  - Refresh
     C     *IN05         CASEQ     '1'           CF05

      **  F12 - Previous
     C     *IN12         CASEQ     '1'           CF12

      **  F14 - Settlements
     C     *IN14         CASEQ     '1'           CF14

      **  Enter Key Processing - Validate the fee settlement details
     C                   CAS                     VAL_FEST
      *
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Process deletion screen                                       *
      *****************************************************************
     C     DELETE        BEGSR

      **  Move file fields to screen fields

     C                   EXSR      POPSCR
      *
     C                   MOVE      *OFF          *IN10
     C                   MOVE      *OFF          *IN12
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *ON           *IN67
     C                   MOVE      *ON           *IN68
     C                   MOVE      *ON           *IN69
     C                   MOVE      *OFF          *IN62                                        CAAA03

      * Enable settlements screen
     C     W#PTFI        IFNE      'I'
     C                   MOVE      *ON           *IN63
     C                   ELSE
     C                   MOVE      *OFF          *IN63
     C                   ENDIF

     C                   MOVE      'N'           SSCR_SetUp

      **  Display the screen until CF/3, CF/10 or CF/12 taken

     C     *IN03         DOWEQ     *OFF
     C     *IN10         ANDEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LEFESTF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEFESTF3

      **  Clear Message subfile
     C                   EXSR      CLEARM

      **  F3  - Exit
     C     *IN03         CASEQ     '1'           CF03

      **  F10- Delete
     C     *IN10         CASEQ     '1'           CF10_11

      **  F12- Previous
     C     *IN12         CASEQ     '1'           CF12

      **  F14 - Settlements
     C     *IN14         CASEQ     '1'           CF14

      **  Enter Processing when F10 required
     C                   CAS                     ENTERF10
      *
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Process authorise screen                                      *
      *****************************************************************
     C     AUTHOR        BEGSR

      **  Move file fields to screen fields

     C                   EXSR      POPSCR
      *
     C                   MOVE      *OFF          *IN11
     C                   MOVE      *OFF          *IN12
     C                   MOVE      *ON           *IN66
     C                   MOVE      *ON           *IN67
     C                   MOVE      *OFF          *IN68
     C                   MOVE      *ON           *IN69
     C                   MOVE      *OFF          *IN62                                        CAAA03

      * Enable settlements screen
     C     W#PTFI        IFNE      'I'
     C                   MOVE      *ON           *IN63
     C                   ELSE
     C                   MOVE      *OFF          *IN63
     C                   ENDIF

     C                   MOVE      'N'           SSCR_SetUp

      **  Display the screen until CF/3, CF/11 or CF/12 taken

     C     *IN03         DOWEQ     *OFF
     C     *IN11         ANDEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LEFESTF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEFESTF3

      **  Clear Message subfile
     C                   EXSR      CLEARM

      **  F3  - Exit
     C     *IN03         CASEQ     '1'           CF03

      **  F11- Authorise
     C     *IN11         CASEQ     '1'           CF10_11

      **  F12- Previous
     C     *IN12         CASEQ     '1'           CF12

      **  F14 - Settlements
     C     *IN14         CASEQ     '1'           CF14

      **  Enter Processing when F11 required
     C                   CAS                     ENTERF11
      *
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Enter processing when F10 required                            *
      *****************************************************************
     C     ENTERF10      BEGSR

      **  Display Message
     C                   MOVEL     'LEF0232'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Enter processing when F11 required                            *
      *****************************************************************
     C     ENTERF11      BEGSR

      **  Display Message
     C                   MOVEL     'LEF0233'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Move file fields to screen fields                             *
      *****************************************************************
     C     POPSCR        BEGSR

      **  Chain to subfile
     C     ##RRN1        CHAIN     LEFESTS1                           70

      ** Fee Settlement Retrieve

     C                   EXSR      FESTRTV

      ** Fee Settlement settlement instructions

     C**********         MOVEL     LefeeaREC     F_REC                                        CGL029
     C**********         MOVEL     LefeeaPAY     F_PAY                                        CGL029
     C                   MOVEL     LefeeaREC1    FLREC1                                       CGL029
     C                   MOVEL     RONS          FLRONS                                       CGL029
     C                   MOVEL     LefeeaREC2    FLREC2                                       CGL029
     C                   MOVEL     LefeeaPAY1    FLPAY1                                       CGL029
     C                   MOVEL     PONS          FLPONS                                       CGL029
     C                   MOVEL     LefeeaPAY2    FLPAY2                                       CGL029
     C                   MOVE      CVMR          FLCVMR
     C                   MOVE      OMDB          FLPOBR
     C                   MOVE      OSDB          FLROBR
     C                   MOVE      FASCCY        FLPSCY
     C                   MOVE      FASCCY        FLRSCY
     C                   MOVE      FAICCY        FLIC72
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FAREXR        FLREXR                                       CLE031
     C                   Z-ADD     FAPEXR        FLPEXR                                       CLE031
     C                   MOVE      FAREXI        FLREXI                                       CLE031
     C                   MOVE      FAPEXI        FLPEXI                                       CLE031
     C                   MOVE      FASCCY        FLRSCY                                       CLE031
     C                   MOVE      FAPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031

      ** TNLU used in 'record updated by another WS' checking

     C                   Z-ADD     FATNLU        H#TNLU

      * Fee Settlement Convert

     C                   EXSR      FESTCVT
      *
     C                   MOVEL     S#SADE        S_S#SADE         19
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Fee Settlement details                               *
      *****************************************************************
     C     VAL_FEST      BEGSR

      ** Reset screen error indicators

     C                   CLEAR                   FEST_OK
     C                   EXSR      RESET_SCEI

      ** Clear Message subfile

     C                   EXSR      CLEARM

      ** Validate fee settlement key details

     C                   MOVEL     S#ACTN        S#SEL
     C                   EXSR      FESTRTV

      ***If*there*are*errors*in*the*fee*settlement*key*details**************                  CAP084
      ** If there are no errors in the fee settlement key details,                            CAP084
      ** Validate fee settlement details

     C     Idx           IFEQ      0
     C                   EXSR      FESTVAL
     C                   ENDIF

      ** If there are errors in the fee settlement details screen
      ** or if there are warnings that haven't been output
      ** set screen error indicators (and send messages to the screen)

     C     Idx           IFNE      0
     C     WIdx          ORNE      P_WIdx
     C                   Z-ADD     WIdx          P_WIdx            3 0
     C                   EXSR      SET_SCEI
     C                   GOTO      EVAL_FEST
     C                   ENDIF

      ***If*this*is*an*insert*and*the*settlements*screen*has*not*been*called****              CAP084
      ***display*the*settlements*screen*****************************************              CAP084
      ***(If*CF/3*is*taken*from*the*settlements*screen,*then*exit)**************              CAP084

     C*****S#ACTN        IFEQ      'I'                                                        CAP084
     C*****W#PTFI        ANDNE     'I'                                                        CAP084
     C*****SSCR_SetUp    ANDEQ     'N'                                                        CAP084
      * If not an internal fee, & action is insert, amend or authorise                        CAP084
     C     W#PTFI        IFNE      'I'                                                        CAP084
     C     S#ACTN        IFEQ      'I'                                                        CAP084
     C     S#ACTN        OREQ      'A'                                                        CAP084
     C     S#ACTN        OREQ      'X'                                                        CAP084
      ** If settlements have not yet been validated                                           CAP084
     C     SSCR_SetUp    IFEQ      'N'                                                        CAP084
     C     SSCR_SetUp    OREQ      'Y'                                                        CAP084
     C     Valid_Set     ANDNE     'Y'                                                        CAP084
      ** Display the settlements screen:                                                      CAP084
     C                   EXSR      CF14                                                       CAP084
      ** (If CF/3 is taken from the settlements screen, then exit)                            CAP084
     C     *in03         IFEQ      '1'
     C                   GOTO      EVAL_FEST
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  'I' or 'A'    CAP084
     C                   ENDIF                                                  Not internal  CAP084

      ** If there are errors in the settlement screen
      ** send a message to the current screen

     C     Valid_Set     IFNE      'Y'
     C                   MOVEL     'LEA1020'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      EVAL_FEST
     C                   ENDIF

      ** Call the window

     C                   EXSR      SRWNDW
      *
      * CF/3 taken from the window
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   MOVE      '1'           *IN03
     C                   GOTO      EVAL_FEST
     C                   ELSE
      *
      *  CF/12 taken from the window
      *
     C     #RTRN         IFEQ      'USR0790'
     C                   GOTO      EVAL_FEST
     C                   ENDIF
     C                   ENDIF

      ** Update the database

     C                   EXSR      UPD_DBASE

      ** If there were errors in database update
      ** report them

     C     RetCodeOut    IFEQ      '*RECUPD'

     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     WCMT01        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   MOVEL     'LEP0026'     ZAMSID
     C                   EXSR      ZASNMS

     C                   ELSE

     C     RetCodeOut    IFNE      *BLANK
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     WCMT01        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C     MsgIDArr(1)   IFNE      *BLANK
     C                   MOVEL     MsgIDArr(1)   ZAMSID
     C                   ELSE
     C                   MOVEL     'LEL0035'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS

     C                   ELSE

      ** Commit the database changes

     C     CSC022        IFEQ      'N'                                                        CSC022
     C     WCMT01        OREQ      'N'                                                        CSC022
     C     CSC022        ANDEQ     'Y'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022

      ** If insert, display message 'Record added'

     C     S#ACTN        IFEQ      'I'
     C                   MOVEL     'LEK0021'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** Update status on subfile record
     C     CLE002        IFEQ      'Y'
     C     BPFSAU        ANDEQ     'Y'
     C     S#ACTN        ANDEQ     'A'
     C     SSTS          ANDEQ     'A'
     C                   MOVEL     'LEF0285'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        S#STAT
     C                   ENDIF

      **  Move to previous screen
     C                   MOVE      *ON           *IN12
      *
     C     EVAL_FEST     ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Setup the settlement screen fields (SETLIAB/SETLIAZ)          *
      *****************************************************************
     C     SETUP_SSCR    BEGSR

      ** Set action, customer, currencies and branch for settlement screen

     C                   MOVE      S#ACTN        PMACTC
     C                   MOVE      'LEND'        PMCPGM
     C                   MOVEL     S#CNUM        PMCSNM
     C                   Z-ADD     W#VDAT        PMDTRC
     C                   Z-ADD     W#VDAT        PMDTPY
     C                   MOVE      S#FCCY        PMRCCY
     C                   MOVE      S#FCCY        PMPCCY
     C                   MOVE      *BLANK        PMFFND
     C                   MOVE      FcbrBranch    PMBRCA
     C                   MOVE      *BLANK        PMCMDP
     C                   Z-ADD     0             PMDBSE
     C                   MOVE      *BLANKS       PMERCD
     C                   MOVE      'Y'           PMFRST
     C                   MOVE      'N'           PMVALO
     C*******            Z-ADD     BJRDNB        PMRUND                                       CAP084
     C                   Z-ADD     WProcDate     PMRUND                                       CAP084

      ** Determine if pay & receive settlement screen will be protected

     C     S#ACTN        IFEQ      'E'
     C     S#ACTN        OREQ      'D'
     C     S#ACTN        OREQ      'X'
     C                   MOVE      'Y'           PMPRCV
     C                   MOVE      'Y'           PMPPAY
     C                   ELSE
     C     W#PTFI        IFEQ      *BLANK
     C                   MOVE      'N'           PMPRCV
     C                   MOVE      'Y'           PMPPAY
     C                   ELSE
     C                   MOVE      'Y'           PMPRCV
     C                   MOVE      'N'           PMPPAY
     C                   ENDIF
     C                   ENDIF

      ** Set settlement details valid flag

     C     S#ACTN        IFEQ      'E'
     C     S#ACTN        OREQ      'D'
     C     S#ACTN        OREQ      'X'
     C                   MOVE      'Y'           PMSDTV
     C                   ELSE
     C                   MOVE      'N'           PMSDTV
     C                   ENDIF

      ** If amend, enquire, delete or authorise
      ** move settlement file fields to screen fields
      ** Else clear settlement screen fields

     C     S#ACTN        IFEQ      'A'
     C     S#ACTN        OREQ      'E'
     C     S#ACTN        OREQ      'D'
     C     S#ACTN        OREQ      'X'
     C                   EXSR      SET_FL2SC
     C                   ELSE
     C                   EXSR      CLR_SSCR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Move settlement file fields to screen fields (SETLIAB/SETLIAZ)*
      *****************************************************************
     C     SET_FL2SC     BEGSR

     C                   CALLB     'LESTFL2SC'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn

      * File Receive instructions
     C                   PARM                    F_REC

      * File Payment instructions
     C                   PARM                    F_PAY
      *
      * OUTPUTS
      *
      * Screen receive and payment instructions
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Move settlement screen fields to file fields                  *
      *****************************************************************
     C     SET_SC2FL     BEGSR

     C                   CALLB     'LESTSC2FL'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn

      * Screen receive and payment instructions
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ
      *
      * OUTPUTS
      *

      * File Receive instructions
     C                   PARM                    F_REC

      * File Payment instructions
     C                   PARM                    F_PAY

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SETTLEINS: Settlement instructions                            *
      *****************************************************************
     C     SETTLEINS     BEGSR

      ** Receive Settlement details

     C     W#PTFI        IFEQ      *BLANK

     C                   MOVE      FLRSTM        STMETH
     C                   MOVE      FLRONS        STOURS
     C                   MOVEL     FLRIBN        STTHER
     C                   MOVE      FLROBR        STOSBR

     C                   MOVE      FLRSTM        STRSTM
     C                   MOVE      FLRONS        STRONS
     C                   MOVEL     FLRIBN        STRIBN
     C                   MOVEL     FLRIBA        STRIBA
     C                   MOVE      FLROBN        STROBN
     C                   MOVE      FLROCN        STROCN
     C                   MOVE      FLROBR        STOSDB
     C                   MOVE      FLRSCY        STSCCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        STREXR                                       CLE031
     C                   MOVE      FLREXI        STREXI                                       CLE031
     C                   ENDIF                                                                CLE031

      ** Payment Settlement details

     C                   ELSE
     C     W#PTFI        IFEQ      'P'
     C     W#PTFI        OREQ      'S'                                                        CLE106
     C     W#PTFI        OREQ      'R'                                                        CLE106

     C                   MOVE      FLPSTM        STMETH
     C                   MOVE      FLPONS        STOURS
     C                   MOVE      FLPIBN        STTHER
     C                   MOVE      FLPOBR        STOSBR
      *
     C                   MOVE      FLPSTM        STPSTM
     C                   MOVE      FLPONS        STPONS
     C                   MOVE      FLPIBN        STPIBN
     C                   MOVE      FLPIBA        STPIBA
     C                   MOVE      FLPOBN        STPOBN
     C                   MOVE      FLPOCN        STPOCN
     C                   MOVE      FLRCRN        STRCRN
     C                   MOVE      FLRCRA        STRCRA
     C                   MOVE      FLRVNO        STRVNO
     C                   MOVEL     FLAWBN        STAWBN
     C                   MOVE      FLAWBA        STAWBA
     C                   MOVEL     FLBENN        STBENN
     C                   MOVE      FLBENA        STBENA
     C                   MOVE      FLDTP1        STDTP1
     C                   MOVE      FLDTP2        STDTP2
     C                   MOVE      FLDTP3        STDTP3
     C                   MOVE      FLDTP4        STDTP4
     C                   MOVE      FLDCHG        STDCHG
     C                   MOVEL     FLBTB1        STBTB1
     C                   MOVEL     FLBTB2        STBTB2
     C                   MOVEL     FLBTB3        STBTB3
     C                   MOVEL     FLBTB4        STBTB4
     C                   MOVEL     FLBTB5        STBTB5
     C                   MOVEL     FLBTB6        STBTB6
     C                   MOVE      FLPOBR        STOMDB
     C                   MOVE      FLCVMR        STCVMR
     C                   MOVE      FLPSCY        STSCCY
     C                   MOVE      FLIC72        STICCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLPEXR        STPEXR                                       CLE031
     C                   MOVE      FLPEXI        STPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Clear fee settlement screen fields                            *
      *****************************************************************
     C     CLR_FAS       BEGSR
      *
     C                   MOVE      *BLANK        S#CSSN
     C                   MOVE      *BLANK        S#FACT
     C                   MOVE      *BLANK        S#FCNO
     C                   MOVE      *BLANK        S#FSEQ
     C                   MOVE      *BLANK        S#VDAT
     C                   MOVE      *BLANK        S#SADJ
     C                   MOVE      *BLANK        S#TYPE
      *
     C                   MOVE      *BLANK        S#FCCY
     C                   MOVE      *BLANK        S#FTYP
     C                   MOVE      *BLANK        S#FCOD
     C                   MOVE      *BLANK        S#FENV
     C                   MOVE      *BLANK        S#DUPD
     C                   MOVE      *BLANK        S#STAT
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Clear settlement screen fields                                *
      *****************************************************************
     C     CLR_SSCR      BEGSR
      *
     C                   Z-ADD     0             PMRSTM
     C                   MOVE      *BLANKS       PMRONS
     C                   MOVE      *BLANKS       PARIBN
     C                   MOVE      *BLANKS       PMRIBN
     C                   MOVE      *BLANKS       PMRIBA
     C                   MOVE      *BLANKS       PAROBN
     C                   MOVE      *BLANKS       PMROBN
     C                   MOVE      *BLANKS       PAROCN
     C                   MOVE      *BLANKS       PMROCN
     C                   MOVE      *BLANKS       PMROBR
     C                   MOVE      *BLANKS       PMRSCY

     C                   Z-ADD     0             PMPSTM
     C                   MOVE      *BLANKS       PMPONS
     C                   MOVE      *BLANKS       PAPIBN
     C                   MOVE      *BLANKS       PMPIBN
     C                   MOVE      *BLANKS       PMPIBA
     C                   MOVE      *BLANKS       PAPOBN
     C                   MOVE      *BLANKS       PMPOBN
     C                   MOVE      *BLANKS       PAPOCN
     C                   MOVE      *BLANKS       PMPOCN
     C                   MOVE      *BLANKS       PMCVMR
     C                   MOVE      *BLANKS       PARCRN
     C                   MOVE      *BLANKS       PMRCRN
     C                   MOVE      *BLANKS       PMRCRA
     C                   MOVE      *BLANKS       PARVNO
     C                   MOVE      *BLANKS       PMRVNO
     C                   MOVE      *BLANKS       PAAWBN
     C                   MOVE      *BLANKS       PMAWBN
     C                   MOVE      *BLANKS       PMAWBA
     C                   MOVE      *BLANKS       PABENN
     C                   MOVE      *BLANKS       PMBENN
     C                   MOVE      *BLANKS       PMBENA
     C                   MOVE      *BLANKS       PMDTP1
     C                   MOVE      *BLANKS       PMDTP2
     C                   MOVE      *BLANKS       PMDTP3
     C                   MOVE      *BLANKS       PMDTP4
     C                   MOVE      *BLANKS       PMDCHG
     C                   MOVE      *BLANKS       PMBTB1
     C                   MOVE      *BLANKS       PMBTB2
     C                   MOVE      *BLANKS       PMBTB3
     C                   MOVE      *BLANKS       PMBTB4
     C                   MOVE      *BLANKS       PMBTB5
     C                   MOVE      *BLANKS       PMBTB6
     C                   MOVE      *BLANKS       PMPOBR
     C                   MOVE      *BLANKS       PMPSCY
     C                   MOVE      *BLANKS       PMIC72
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Set screen error indicators                                   *
      *****************************************************************
     C     SET_SCEI      BEGSR

      * Move 'OK' flags into array (for checking)

     C                   MOVEA     FEST_OK       #EI

      * Set screen error indicators according to status of 'OK' flags

     C                   Z-ADD     1             #C                2 0
     C                   Z-ADD     40            #E                2 0
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
     C                   SETOFF                                       40
     C                   SETOFF                                       414243
     C                   SETOFF                                       444546
     C                   SETOFF                                       47
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Window processing subroutine                                  *
      *****************************************************************
     C     SRWNDW        BEGSR
      *
     C/COPY QWINDSRC,LEFESTMOV1

      **  Call window manager WN0010
     C                   CALL      'WN0010'
     C                   PARM      'LEFESTSIN'   #PGM             10
     C                   PARM                    KEY               2
     C                   PARM      S#ACTN        ACTION            1
     C                   PARM                    DATA           1024
     C                   PARM      *BLANK        #RTRN             7
     C                   PARM                    SPAREX          256

      ** Process return code
     C     #RTRN         IFNE      *BLANK
     C                   MOVEL     #RTRN         ZAMSID
     C                   MOVEL     'WNMSGF  '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'LERMSGF'     ZAMSGF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate 'review from' fields                                 *
      *****************************************************************
     C     VAL_R#Flds    BEGSR
      *
     C                   CALLB     'LEFCRFVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn

      * Customer, facility type and facility number
     C                   PARM                    R#CSSN
     C                   PARM                    R#FACT
     C                   PARM                    R#FCNO
      *
      * OUTPUTS

      * Customer, facility type and facility number OK indicators
     C                   PARM                    R#CSSNok          1
     C                   PARM                    R#FACTok          1
     C                   PARM                    R#FCNOok          1

      * Customer number, facility type and facility number
     C                   PARM                    R_CNUM            6
     C                   PARM                    R_FACT            3
     C                   PARM                    R_FCNO            2
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update the Database                                           *
      *****************************************************************
     C     UPD_DBASE     BEGSR
      *
     C                   CALLB     'LEFESTUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut

      * Mode
     C                   PARM                    P#MODE            1

      * Action Code
     C                   PARM                    S#ACTN

      * Fee Settlement Details in file format
     C                   PARM                    LEVFESTPD

      * File Receive instructions
     C                   PARM                    F_REC

      * File Payment instructions
     C                   PARM                    F_PAY

      * Fee currency
     C                   PARM                    S#FCCY            3

      * Value date
     C                   PARM                    W#VDAT            5 0

      * Settlement amount
     C                   PARM                    W#SADJ           13 0

      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0

      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1

      * TNLU of fee settlement record on LEFEEAD
     C                   PARM                    H#TNLU            5 0

      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0

      * Front office inputs (if mode = 'B')
     C                   PARM                    F5PCOB            3
     C                   PARM                    F5TNRF           15
     C                   PARM                    F5IUSR           10
     C                   PARM                    F5XUSR           10
     C                   PARM                    F5AUSR           10
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FEST_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Fee settlement retrieve                                      *
      *****************************************************************
     C     FESTRTV       BEGSR

     C                   CALLB     'LEFESTRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn

      * Mode
     C                   PARM                    P#MODE            1
      * Response Code
     C                   PARM      'S'           RESPMODE          1

      * Action, customer, facility type, facility number,
      * fee sequence number and value date
     C                   PARM      S#SEL         S#ACTN            1
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FSEQ            2
     C                   PARM                    S#VDAT            6

      *
      * OUTPUTS

      * Fee Settlement Details in file format
     C                   PARM                    LEFEESTFmt

      * Action, customer, facility type, facility number,
      * fee sequence number and value date OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FSEQok          1
     C                   PARM                    S#VDATok          1

      * Customer number
     C                   PARM                    S#CNUM            6

      * Fee currency and decimal places
     C                   PARM                    S#FCCY            3
     C                   PARM                    FecyNBDP          1 0

      * Fee type, fee code, fee narrative, fee amount due/past due
     C                   PARM                    S#FTYP           10
     C                   PARM                    S#FCOD            2
     C                   PARM                    S#FENV           20
     C                   PARM                    S#DUPD           18

      * Value date
     C                   PARM                    W#VDAT            5 0

      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0

      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1

      * Fee amount past due
     C                   PARM                    W#CPAM           13 0

      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Fee settlement validation                                    *
      *****************************************************************
     C     FESTVAL       BEGSR

     C                   CALLB     'LEFESTVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn

      * Mode
     C                   PARM                    P#MODE            1

      * Fee Settlement Details in screen format
     C                   PARM                    FEST

      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0

      * Value date
     C                   PARM                    W#VDAT            5 0

      * Settlement settlement due date
     C                   PARM                    W#SADD            5 0

      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1

      * Fee amount past due
     C                   PARM                    W#CPAM           13 0

      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0

      * Front Office Inputs (if mode = 'B')
     C                   PARM                    F5PCOB            3
     C                   PARM                    F5TNRF           15
     C                   PARM                    F5IUSR           10
     C                   PARM                    F5XUSR           10
     C                   PARM                    F5AUSR           10
     C                   PARM                    LEFEESTFmt                                   CAP084
     C                   PARM                    P_SIGN                                     MD054354
      *
      * OUTPUTS
      * Status                                                                                CAP084
     C                   PARM                    S#STAT           10                          CAP084
      * Fee Type                                                                              CAP084
     C                   PARM                    S#FTYP           10                          CAP084
      * Fee Code                                                                              CAP084
     C                   PARM                    S#FCOD            2                          CAP084
      * Fee Code description                                                                  CAP084
     C                   PARM                    S#FENV           20                          CAP084
      * Fee Amount Due/Past Due                                                               CAP084
     C                   PARM                    S#DUPD           18                          CAP084
      * Field OK flags
     C                   PARM                    FEST_OK

      * Settlement amount
     C                   PARM                    W#SADJ           13 0

      * Settlement amount edited
     C                   PARM                    S#SADE           19

      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0

      * Valid Fee Settlements
     C                   PARM                    LEVFESTPD

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Fee Settlement Convert                                       *
      *****************************************************************
     C     FESTCVT       BEGSR

     C                   CALLB     'LEFESTCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Fee Settlement details in file format
     C                   PARM                    LEFEESTFmt
      *
      * OUTPUTS
      *
      * Fee Settlement Details in screen format
     C                   PARM                    FEST

      * Customer details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10

      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0

      * Value date (alpha)
     C                   PARM                    S#VDTA            7

      * Settlement amount edited
     C                   PARM                    S#SADE           19

      * Record status
     C                   PARM                    S#STAT           10
      * Fee Amount Sign                                                                     MD054354
     C                   PARM                    P_SIGN            1                        MD054354

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Initial Processing                                            *
      *****************************************************************
     C     INITPR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#MODE            1
     C                   PARM                    P#INMF
     C                   PARM                    P#OUMF
      *
      ** Access Bank Details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     901           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access module details
      *  ~~~~~~~~~~~~~~~~~~~~~
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     902           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access retail details
      *  ~~~~~~~~~~~~~~~~~~~~~
      *
     C     BGRTBN        IFEQ      'Y'
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDRETLPD'    DBFILE
     C                   Z-ADD     903           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

      ** Check if CLE002 - Lending Authorisations - is Installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      'CLE002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CLE002
     C                   ELSE
     C                   MOVEL     'N'           CLE002            1
     C                   ENDIF

      ** Retrieve customer lending data, if CLE002 is Installed

     C     CLE002        IFEQ      'Y'
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C     BPFSAU        IFEQ      'Y'
     C                   MOVEL     *ON           *IN64
     C                   ENDIF
     C                   ENDIF

      * Screen fields
     C                   MOVE      PSUser        S#USER
     C                   MOVE      PSJobName     S#WSID
     C                   MOVE      BJMRDT        S#RUNA

     C                   MOVE      PSProcName    ##PGM

      * Subfile indicators
     C                   MOVE      *ON           *IN25
     C                   Z-ADD     1             ##SFRC

      ** SETLIAZ parameters

     C                   MOVE      BGRTBN        PMRETP
     C                   MOVE      BMRANR        PMRETS

     C                   MOVEL     'LERMSGF '    ZAMSGF
                                                                                              CAP084
      ** Check if CSC011 is installed                                                         CAP084
     C                   CALL      'AOSARDR0'                                                 CAP084
     C                   PARM      *BLANKS       PRTCD                                        CAP084
     C                   PARM      '*VERIFY'     POPTN                                        CAP084
     C                   PARM      'CSC011'      PSARD                                        CAP084
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP084
                                                                                              CAP084
     C                   IF        PRTCD = *Blanks                                            CAP084
                                                                                              CAP084
     C                   EVAL      CSC011 = 'Y'                                               CAP084
                                                                                              CAP084
     C                   IN        SC24X7                                                     CAP084
     C                   IN        SDSTAT                                                     CAP084
                                                                                              CAP084
     C                   ELSE                                                                 CAP084
                                                                                              CAP084
      ** Database error                                                                       CAP084
     C                   IF        PRTCD <> '*NRF'                                            CAP084
     C     *LOCK         IN        LDA                                                        CAP084
     C                   EVAL      DBKEY = 'CSC011'                                           CAP084
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP084
     C                   EVAL      DBASE = 900                                                CAP084
     C                   OUT       LDA                                                        CAP084
     C                   EXSR      *PSSR                                                      CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
      ** If 24X7 Midas availability is installed and support system is                        CAP084
      ** active, used processing date from dataarea SC24X7 as the                             CAP084
      ** rundate.                                                                             CAP084
     C                   IF        CSC011 = 'Y' AND                                           CAP084
     C                             S1SUPP = LIBR                                              CAP084
     C                   EVAL      WProcDate = S1DATE                                         CAP084
     C                   ELSE                                                                 CAP084
     C                   EVAL      WProcDate = BJRDNB                                         CAP084
     C                   ENDIF                                                                CAP084

      ** Key fields

     C     *LIKE         DEFINE    FACNUM        K#CNUM
     C     *LIKE         DEFINE    FAFACL        K#FACL
     C     *LIKE         DEFINE    FALOAN        K#LOAN
     C     *LIKE         DEFINE    FAFSEQ        K#FSEQ
     C     *LIKE         DEFINE    FAVDAT        K#VDAT

      ** Key lists

     C     FEEAKY        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACL
     C                   KFLD                    K#LOAN
     C                   KFLD                    K#FSEQ
     C                   KFLD                    K#VDAT

      * Determine if CSC022 is switched on                                                    CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
     C                   IF        @RTCD = *BLANK                                             CSC022
     C                   EVAL      CSC022 ='Y'                                                CSC022
     C                   EVAL      WCMT01 ='N'                                                CSC022
      * SCCMTJOB data area                                                                    CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      * Move data area to commitment array                                                    CSC022
     C                   IF        COMITNOM > 0                                               CSC022
     C                   MOVEA     COMITJOB      ARRJBNAM                                     CSC022
      *                                                                                       CSC022
      * Check if PSJOBNAME exist.                                                             CSC022
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17                  CSC022
     C                   IF        *IN17 = *ON                                                CSC022
     C                   EVAL      WCMT01= 'Y'                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CSC022
     C                   ELSE                                                                 CSC022
      * @rtcd not found                                                                       CSC022
     C                   IF        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBPGM = 'LEFESTSIN'                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC022
     C                   EVAL      DBASE  = 905                                               CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
     C     @RTCD         IFEQ      '*NRF'                                                     CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
      *                                                                                       CLE031
      ** Database error                                                                       CLE031
      *                                                                                       CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE031
     C                   MOVEL     '008'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDSR
      *****************************************************************
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
      * SRTEXT  -  Set up text from message file                      *
      *****************************************************************
     C     SRTEXT        BEGSR

     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTX          132

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
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Program exception error routine                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   CALL      'DBERRCTL'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
