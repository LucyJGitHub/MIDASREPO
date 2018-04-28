     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility amendment screen input   DEBUG')     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFAMDSIN - Facility Amendment Screen Input                  *
      *                                                               *
      *  Function:  This program allows entry and maintenance of      *
      *             facility amendments.                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG10384           Date 06Feb06               *
      *                 CAP086             Date 07Jul05               *
      *                 CLE041             Date 11Oct04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAAA03             Date 01Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 CAP084             Date 20Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP071  *CREATE    Date 19Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00259                                 *
      *             WNCPYSRC,LEH00260                                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10384 - Display Facility UTN and Facility Event UTN       *
      *             correctly.                                        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAAA03 - Webfacing changes. F5 appears on enquiry, delete and*
      *           authorise screens though no details are amendable.  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CAP084 - Change S#CNUM to be 10 long                         *
      *  CAP071 - Conversion of Mn inputs into modular structure to   *
      *           use as API's.                                       *
      *                                                               *
      *****************************************************************
 
     FLEFCAML5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFCAMPF:LEFCAMP5)
                                                                                              CLE041
     FLEAGAML5  IF   E           K DISK    INFSR(*PSSR)                                       CLE041
     F                                     RENAME(LEFCAMPF:LEAGAMP5)                          CLE041
 
     FLEFCAML6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFCAMPF:LEFCAMP6)
                                                                                              CLE041
     FLEAGAML2  IF   E           K DISK    INFSR(*PSSR)                                       CLE041
     F                                     RENAME(LEFCAMPF:LEAGAMP2)                          CLE041
 
     FLEFAMDDDF CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(LEFAMDS1:RRN1)
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
      *    17      Used by LOOKUP                                     *                       CSC022
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
      *    44      Invalid amendment type                             *
      *    45      Invalid value date                                 *
      *    46      Invalid sequence number                            *
      *    47      Invalid currency                                   *
      *    48      Invalid amount                                     *
      *    49      Invalid sign                                       *
      *    50      Invalid revolving credit indicator                 *
      *    51      Invalid revolving credit indicator                 *
      *                                                               *
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
 
      ** Error indicators
     D #EI             S              1    DIM(25)
 
     D CSC022          S              1A   INZ('N')                                           CSC022
      ** Counter variable                                                                     CSC022
     D WCMT01          S              1A                                                      CSC022
      ** Commitment Flag                                                                      CSC022
                                                                                              CSC022
      *  Array for job name                                                                   CSC022
     D ARRJBNAM        S             10A   DIM(10)                                            CSC022
      ** Facility Amendment Details in screen format
     D FAMD          E DS                  EXTNAME(LEFAMDPD)
 
      ** Facility Amendment Details OK indicator
     D FAMD_OK       E DS                  EXTNAME(LEEFAMDPD)
 
      ** Facility Amendment Details in file format
     D LEFCAMPDFmt   E DS                  EXTNAME(LEFCAMPD)
 
      ** New Facility Amendment Details in file format
     D LEVFAMDPD     E DS                  EXTNAME(LEVFAMDPD)
     D  V_REC                 72    140
     D  V_PAY                141    699
 
      ** Review from fields
     D R#Flds          DS
     D  R#CSSN                 1     10
     D  R#FACT                11     13
     D  R#FCNO                14     15
     D  R#UNAU                16     16
 
      * Facility run dates
     D  @RUNA          DS            50
 
      * Facility drawn amounts
     D  @OAMA          DS           130
 
      *                                                                                       CSC022
     D SCCMTJOB      E DS                  DTAARA(SCCMTJOB)                                   CSC022
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
 
      ** IN Message Format
     D P#INMF        E DS                  EXTNAME(LEA5MFPD)
 
      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LEA6MFPD)
                                                                                              CLE041
      ** Work variable                                                                        CLE041
     D CLE025          S              1                                                       CLE041
      *
      ** Data to be passed to window program
     I/COPY QWINDSRC,LEFAMDGDTA
      *
      /SPACE 5
 
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
     C                   CLEAR                   FAMD_OK
     C                   EXSR      SET_SCEI
 
      **  Clear subfile
     C                   MOVEA     '000'         *IN(30)
     C                   WRITE     LEFAMDC1
 
     C                   MOVEL     R_CNUM        K#CNUM
     C                   MOVEL     R_FACT        K#FACT
     C                   MOVEL     R_FCNO        K#FCNO
     C                   Z-ADD     *ZERO         K#VLDT
     C                   Z-ADD     *ZERO         K#SQNO
 
     C                   ELSE
 
     C                   Z-ADD     HI_RRN1       RRN1
 
     C                   ENDIF
 
     C                   IF        CLE025 = 'Y'                                               CLE041
     C     R#UNAU        IFEQ      'Y'                                                        CLE041
     C     FCAMKY        SETGT     LEAGAML5                                                   CLE041
     C                   ELSE                                                                 CLE041
     C     FCAMKY        SETGT     LEAGAML2                                                   CLE041
     C                   ENDIF                                                                CLE041
     C                   ELSE                                                                 CLE041
     C     R#UNAU        IFEQ      'Y'
     C     FCAMKY        SETGT     LEFCAML5
     C                   ELSE
     C     FCAMKY        SETGT     LEFCAML6
     C                   ENDIF
     C                   ENDIF                                                                CLE041
 
      * Read from file
 
     C                   IF        CLE025 = 'Y'                                               CLE041
     C     R#UNAU        IFEQ      'Y'                                                        CLE041
     C                   READ      LEAGAML5                               32                  CLE041
     C                   ELSE                                                                 CLE041
     C                   READ      LEAGAML2                               32                  CLE041
     C                   ENDIF                                                                CLE041
     C                   ELSE                                                                 CLE041
     C     R#UNAU        IFEQ      'Y'
     C                   READ      LEFCAML5                               32
     C                   ELSE
     C                   READ      LEFCAML6                               32
     C                   ENDIF
     C                   ENDIF                                                                CLE041
 
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
     C                   PARM                    BRCA
     C                   PARM                    @ERR              1 0
     C                   ENDIF
 
      * If authorised to view this branch
 
     C     @ERR          IFEQ      *ZERO
 
      * Facility Amendment Convert
 
     C                   EXSR      FAMDCVT
 
      * Increment subfile RRN
     C                   ADD       1             RRN1
 
      * Increment count of records read
     C                   ADD       1             Count_Read
      *
     C                   WRITE     LEFAMDS1
 
     C                   ENDIF
 
      * Point read to
     C                   MOVEL     CNUM          K#CNUM
     C                   MOVEL     FACT          K#FACT
     C                   MOVEL     FCNO          K#FCNO
     C                   Z-ADD     VLDT          K#VLDT
     C                   Z-ADD     SQNO          K#SQNO
 
      * Read from file
 
     C                   IF        CLE025 = 'Y'                                               CLE041
     C     R#UNAU        IFEQ      'Y'                                                        CLE041
     C                   READ      LEAGAML5                               32                  CLE041
     C                   ELSE                                                                 CLE041
     C                   READ      LEAGAML2                               32                  CLE041
     C                   ENDIF                                                                CLE041
     C                   ELSE                                                                 CLE041
     C     R#UNAU        IFEQ      'Y'
     C                   READ      LEFCAML5                               32
     C                   ELSE
     C                   READ      LEFCAML6                               32
     C                   ENDIF
     C                   ENDIF                                                                CLE041
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
     C                   WRITE     LEFAMDF2
     C                   WRITE     LEFAMDF5
     C                   WRITE     #MSGCTL
     C   65              WRITE     LEFAMDF4
     C                   EXFMT     LEFAMDC1
 
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
     C     1             CHAIN     LEFAMDS1                           70
     C     *IN70         DOWEQ     *OFF
     C                   MOVE      ' '           S#SEL
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN36
     C                   UPDATE    LEFAMDS1
     C                   READC     LEFAMDS1                               70
     C                   ENDDO
     C                   ENDIF
 
      ** Position to first page
 
     C                   Z-ADD     1             ##SFRC
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
 
     C                   Z-ADD     0             P_WIdx
      *
     C                   MOVE      'INS'         CurrentSCR        3
 
      ** Display the screen until CF/3 or CF/12 taken
 
     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LEFAMDF2
     C                   WRITE     LEFAMDF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEFAMDF3
 
      **  Clear Message subfile
     C                   EXSR      CLEARM
 
      **  F3  - Exit
     C     *IN03         CASEQ     '1'           CF03
 
      **  F5  - Refresh
     C     *IN05         CASEQ     '1'           CF05
 
      **  F12 - Previous
     C     *IN12         CASEQ     '1'           CF12
 
      **  Enter Key Processing - Validate the facility amendment details
     C                   CAS                     VAL_FAMD
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
 
      ** Update the database
 
     C                   MOVEL     LEFCAMPDFmt   LEVFAMDPD
 
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
     C                   READC     LEFAMDS1                               70
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
     C                   UPDATE    LEFAMDS1
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN36
 
      **  Read next changed record
     C                   READC     LEFAMDS1                               70
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
 
     C                   EXSR      FAMDRTV
 
      * If an error was detected
     C     Idx           IFNE      0
     C                   MOVE      *ON           *IN36
 
      * Send messages to the screen
     C                   CLEAR                   FAMD_OK
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
 
      ** Display the screen until CF/3 or CF/12 taken
 
     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LEFAMDF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEFAMDF3
 
      **  Clear Message subfile
     C                   EXSR      CLEARM
 
      **  F3  - Exit
     C     *IN03         CASEQ     '1'           CF03
 
      **  F12- Previous
     C     *IN12         CASEQ     '1'           CF12
 
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
 
     C                   Z-ADD     0             P_WIdx
 
     C                   MOVE      'AMD'         CurrentSCR        3
 
      ** Display the screen until CF/3 or CF/12 taken
 
     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LEFAMDF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEFAMDF3
 
      **  Clear Message subfile
     C                   EXSR      CLEARM
 
      **  F3  - Exit
     C     *IN03         CASEQ     '1'           CF03
 
      **  F5  - Refresh
     C     *IN05         CASEQ     '1'           CF05
 
      **  F12 - Previous
     C     *IN12         CASEQ     '1'           CF12
 
      **  Enter Key Processing - Validate the facility amendment details
     C                   CAS                     VAL_FAMD
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
 
      **  Display the screen until CF/3, CF/10 or CF/12 taken
 
     C     *IN03         DOWEQ     *OFF
     C     *IN10         ANDEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LEFAMDF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEFAMDF3
 
      **  Clear Message subfile
     C                   EXSR      CLEARM
 
      **  F3  - Exit
     C     *IN03         CASEQ     '1'           CF03
 
      **  F10- Delete
     C     *IN10         CASEQ     '1'           CF10_11
 
      **  F12- Previous
     C     *IN12         CASEQ     '1'           CF12
 
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
 
      **  Display the screen until CF/3, CF/11 or CF/12 taken
 
     C     *IN03         DOWEQ     *OFF
     C     *IN11         ANDEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LEFAMDF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEFAMDF3
 
      **  Clear Message subfile
     C                   EXSR      CLEARM
 
      **  F3  - Exit
     C     *IN03         CASEQ     '1'           CF03
 
      **  F11- Authorise
     C     *IN11         CASEQ     '1'           CF10_11
 
      **  F12- Previous
     C     *IN12         CASEQ     '1'           CF12
 
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
     C     ##RRN1        CHAIN     LEFAMDS1                           70
 
      ** Facility Amendment Retrieve
 
     C                   EXSR      FAMDRTV
 
      * Facility Amendment Convert
 
     C                   EXSR      FAMDCVT
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Facility Amendment details                           *
      *****************************************************************
     C     VAL_FAMD      BEGSR
 
      ** Reset screen error indicators
 
     C                   CLEAR                   FAMD_OK
     C                   EXSR      RESET_SCEI
 
      ** Clear Message subfile
 
     C                   EXSR      CLEARM
 
      ** Validate facility amendment key details
 
     C                   MOVEL     S#ACTN        S#SEL
     C                   EXSR      FAMDRTV
 
      ** If there are errors in the facility amendment key details
      ** Validate facility amendment details
 
     C     Idx           IFEQ      0
     C                   EXSR      FAMDVAL
     C                   ENDIF
 
      ** If there are errors in the facility amendment details screen
      ** or if there are warnings that haven't been output
      ** set screen error indicators (and send messages to the screen)
 
     C     Idx           IFNE      0
     C     WIdx          ORNE      P_WIdx
     C                   Z-ADD     WIdx          P_WIdx            3 0
     C                   EXSR      SET_SCEI
     C                   GOTO      EVAL_FAMD
     C                   ENDIF
 
      ** Call the window
 
     C                   EXSR      SRWNDW
      *
      * CF/3 taken from the window
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   MOVE      '1'           *IN03
     C                   GOTO      EVAL_FAMD
     C                   ELSE
      *
      *  CF/12 taken from the window
      *
     C     #RTRN         IFEQ      'USR0790'
     C                   GOTO      EVAL_FAMD
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
 
      ** If insert, display message 'Record with sequence number &1 added'
 
     C     S#ACTN        IFEQ      'I'
     C                   MOVEL     'LEX9992'     ZAMSID
     C                   MOVEL     A_SQNO        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Update status on subfile record
     C     CLE002        IFEQ      'Y'
     C     BPFAAM        ANDEQ     'Y'
     C     S#ACTN        ANDEQ     'A'
     C     ASTS          ANDEQ     'A'
     C                   MOVEL     'LEF0285'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTX        S#STAT
     C                   ENDIF
 
      **  Move to previous screen
     C                   MOVE      *ON           *IN12
      *
     C     EVAL_FAMD     ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Clear facility amendment screen fields                        *
      *****************************************************************
     C     CLR_FAS       BEGSR
      *
     C                   MOVE      *BLANK        S#CSSN
     C                   MOVE      *BLANK        S#FACT
     C                   MOVE      *BLANK        S#FCNO
     C                   MOVE      *BLANK        S#FATP
     C                   MOVE      *BLANK        S#VLDT
     C                   MOVE      *BLANK        S#SQNO
     C                   MOVE      *BLANK        S#ACCY
     C                   MOVE      *BLANK        S#AAMT
     C                   MOVE      *BLANK        S#SIGN
     C                   MOVE      *BLANK        S#RVCR
     C                   MOVE      *BLANK        S#NDEX
     C                   MOVE      *BLANK        S#STAT
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Set screen error indicators                                   *
      *****************************************************************
     C     SET_SCEI      BEGSR
 
      * Move 'OK' flags into array (for checking)
 
     C                   MOVEA     FAMD_OK       #EI
 
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
     C                   SETOFF                                       474849
     C                   SETOFF                                       5051
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Window processing subroutine                                  *
      *****************************************************************
     C     SRWNDW        BEGSR
      *
     C/COPY QWINDSRC,LEFAMDMOV1
 
      **  Call window manager WN0010
     C                   CALL      'WN0010'
     C                   PARM      'LEFAMDSIN'   #PGM             10
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
     C                   PARM                    Ix                3 0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update the Database                                           *
      *****************************************************************
     C     UPD_DBASE     BEGSR
      *
     C                   CALLB     'LEFAMDUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Action Code
     C                   PARM                    S#ACTN
 
      * Facility Amendment Details in file format
     C                   PARM                    LEVFAMDPD
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FAMD_OK
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
 
      * Sequence assigned
     C                   PARM                    A_SQNO            3
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Facility amendment retrieve                                  *
      *****************************************************************
     C     FAMDRTV       BEGSR
 
     C                   CALLB     'LEFAMDRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
      * Response Code
     C                   PARM      'S'           RESPMODE          1
 
      * Action, customer, facility type, facility number, facility
      * amendment type, value date and sequence number
     C                   PARM      S#SEL         S#ACTN            1
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FATP            2
     C                   PARM                    S#VLDT            6
     C                   PARM                    S#SQNO            3
 
      *
      * OUTPUTS
 
      * Facility Amendment Details in file format
     C                   PARM                    LEFCAMPDFmt
 
      * Action, customer, facility type, facility number, facility
      * amendment type, value date and sequence number OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FATPok          1
     C                   PARM                    S#VLDTok          1
     C                   PARM                    S#SQNOok          1
 
      * Customer number
     C**********         PARM                    S#CNUM            6                          CAP084
     C                   PARM                    S#CNUM           10                          CAP084
 
      * Value date of amendment
     C                   PARM                    W#VLDT            5 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
      * Facility tranche/credit agreement ind
      * Facility revolving credit indicator
      * Facility record ID
      * Facility date of expiry
      * Facility closure date
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C                   PARM                    FcrvRVCR          1
     C                   PARM                    FcRECI            1
     C                   PARM                    FcDTEX            5 0
     C                   PARM                    FcCDTE            5 0
     C/COPY WNCPYSRC,LEH00259
 
      * Facility run dates
      * Facility drawn amounts
     C                   PARM                    @RUNA
     C                   PARM                    @OAMA
                                                                                            BUG10384
      ** Facility UTN                                                                       BUG10384
     C                   PARM                    S#FUTN           15                        BUG10384
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
      *  Facility amendment validation                                *
      *****************************************************************
     C     FAMDVAL       BEGSR
 
     C                   CALLB     'LEFAMDVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Facility Amendment Details in screen format
     C                   PARM                    FAMD
 
      * Value date of amendment
     C                   PARM                    W#VLDT            5 0
 
      * Generated by assignment
     C                   PARM                    A5GASS            1
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
      * Facility tranche/credit agreement ind
      * Facility revolving credit indicator
      * Facility record ID
      * Facility date of expiry
      * Facility closure date
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C                   PARM                    FcrvRVCR          1
     C                   PARM                    FcRECI            1
     C                   PARM                    FcDTEX            5 0
     C                   PARM                    FcCDTE            5 0
     C/COPY WNCPYSRC,LEH00260
 
      * Front office inputs (if mode ='B')
     C                   PARM      *BLANKS       R1PCOB            3
     C                   PARM      *BLANKS       A5TNRF           15
 
      * Facility run dates
      * Facility drawn amount
     C                   PARM                    @RUNA
     C                   PARM                    @OAMA
      *
      * OUTPUTS
 
      * Amendment amount
     C                   PARM                    W#AAMT           13 0
 
      * Field OK flags
     C                   PARM                    FAMD_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZEROS        Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZEROS        WIdx              3 0
 
      * Valid Facility Amendment
     C                   PARM                    LEVFAMDPD
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Facility Amendment Convert                                   *
      *****************************************************************
     C     FAMDCVT       BEGSR
 
     C                   CALLB     'LEFAMDCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      * Facility Amendment details in file format
     C                   PARM                    LEFCAMPDFmt
 
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * OUTPUTS
      *
      * Facility Amendment Details in screen format
     C                   PARM                    FAMD
 
      * Customer details
     C**********         PARM                    S#CNUM            6                          CAP084
     C                   PARM                    S#CNUM           10                          CAP084
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Facility amendment type narrative
      * Record status
      * Value date in alpha format
     C                   PARM                    S#FATN           24
     C                   PARM                    S#STAT           10
     C                   PARM                    S#VLDA            7
 
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
      ** Access Bank details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR'      RetCodeIn
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
     C                   MOVEL     '*ERROR'      RetCodeIn
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
     C                   MOVEL     '*ERROR'      RetCodeIn
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
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVEL     'SDCLNDPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C     BPFAAM        IFEQ      'Y'
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
 
     C                   MOVEL     'LERMSGF '    ZAMSGF
 
      ** Key fields
 
     C     *LIKE         DEFINE    CNUM          K#CNUM
     C     *LIKE         DEFINE    FACT          K#FACT
     C     *LIKE         DEFINE    FCNO          K#FCNO
     C     *LIKE         DEFINE    VLDT          K#VLDT
     C     *LIKE         DEFINE    SQNO          K#SQNO
 
      ** Key lists
 
     C     FCAMKY        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#VLDT
     C                   KFLD                    K#SQNO
 
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
     C                   EVAL      DBPGM = 'LEFAMDSIN'                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC022
     C                   EVAL      DBASE  = 905                                               CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
      ** Check if CLE025 is installed                                                         CLE041
                                                                                              CLE041
     C                   CALLB     'AOSARDR0'                                                 CLE041
     C                   PARM      *BLANK        @RTCD                                        CLE041
     C                   PARM      '*VERIFY'     @OPTN                                        CLE041
     C                   PARM      'CLE025'      @SARD                                        CLE041
                                                                                              CLE041
     C                   IF        @RTCD = *BLANK                                             CLE041
     C                   EVAL      CLE025 = 'Y'                                               CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
      ** Database Error                                                                       CLE041
                                                                                              CLE041
     C                   IF        @RTCD <> *BLANKS AND                                       CLE041
     C                             @RTCD <> '*NRF   '                                         CLE041
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE041
     C                   EVAL      DBASE  = 906                                               CLE041
     C                   EVAL      DBKEY  = @SARD                                             CLE041
     C                   EXSR      *PSSR                                                      CLE041
     C                   ENDIF                                                                CLE041
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
(c) Misys International Banking Systems Ltd. 2002
