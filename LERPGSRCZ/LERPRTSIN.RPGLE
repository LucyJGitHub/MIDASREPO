     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Risk participant screen input')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LERPRTSIN - Risk Participant Screen Input                    *
      *                                                               *
      *  Function:  This program allows entry and maintenance of      *
      *             the risk participant members within a syndicate.  *
      *             This could be run in any of the two modes         *
      *             available, depending on the parameter passed to it*
      *                                                               *
      *               1. Interactive ('I') - The program is called    *
      *             from LE2020, facilities input.                    *
      *                                                               *
      *               2. Interactive Enquiry ('E') - The program is   *
      *             called from LE0170, facilities enquiry. It may    *
      *             also be called from LE2020, where it is appropriate
      *             to restrict the action to enquiry.                *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 28Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP069  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CAP069 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

      **  Facilities File
     FLEFCLTL0  IF   E           K DISK    INFSR(*PSSR)

      **  Risk Participant Details File
     FLEPARTL1  IF   E           K DISK    INFSR(*PSSR)

     FLERPRTDDF CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(LERPRTS1:RRN1)
      *****************************************************************
      *                                                               *
      *    F U N C T I O N   O F   I N D I C A T O R S                *
      *                                                               *
      *    03      F3 PRESSED EXIT PROGRAM                            *
      *    05      F5 PRESSED REFRESH SCREEN                          *
      *    09      F9 PRESSED GO TO ADD MODE                          *
      *    10      F10 PRESSED GO TO DELETE                           *
      *    12      F12 PRESSED GO TO PREVIOUS SCREEN                  *
      *    14      F14 PRESSED GO TO SETTLEMENT SCREEN                *
      *                                                               *
      *    25      Message subfile                                    *
      *                                                               *
      *    30      Subfile display (SFLDSP)                           *
      *    31      SFLDSPCTL                                          *
      *    32      SFLEND(*MORE)                                      *
      *    35      SFLNXTCHG                                          *
      *    36      Invalid subfile selection                          *
      *                                                               *
      *    41      Invalid primary facility customer                  *
      *    42      Invalid primary facility type                      *
      *    43      Invalid primary facility number                    *
      *    44      Invalid Syndicate member                           *
      *    45      Invalid introducing customer                       *
      *    46      Invalid joining date                               *
      *    48      Invalid Share type                                 *
      *    49      Invalid Share (amount/percentage)                  *
      *    50      Invalid fee base rate code                         *
      *    51      Invalid fee rate/spread                            *
      *    52      Invalid fee rate/spread sign                       *
      *    53      Invalid risk loan type                             *
      *    54      Invalid risk loan sub type                         *
      *                                                               *
      *    65      No Records Found in Subfile                        *
      *    66      Enquiry Mode                                       *
      *    67      Protect Fields                                     *
      *    68      Enable F10                                         *
      *    69      Enable Settlements Screen                          *
      *                                                               *
      *    70      READ and/or CHAIN Files                            *
      *    90-99   Used by standard subroutine                        *
      *****************************************************************
      /SPACE 5
      **----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **----------------------------------------------------------------

      **----------------------------------------------------------------
      ** The following /COPY includes the standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **----------------------------------------------------------------

      **----------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **----------------------------------------------------------------

      **----------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **----------------------------------------------------------------

      ** Error indicators
     D #EI             S              1    DIM(25)

      ** Risk Participant Details in screen format
     D RPRT          E DS                  EXTNAME(LERPRTPD)

      ** Risk Participant Details OK indicator
     D RPRT_OK       E DS                  EXTNAME(LEERPRTPD)

      ** Risk Participant Details in file format
     D LEPARTPDFmt   E DS                  EXTNAME(LEPARTPD)
     D***LeRPRTREC             72    140                                                      CGL029
     D***LeRPRTPAY            141    699                                                      CGL029
     D  LeRPRTREC1            72     73                                                       CGL029
     D  LeRPRTREC2            86    140                                                       CGL029
     D  LeRPRTPAY1           141    142                                                       CGL029
     D  LeRPRTPAY2           155    699                                                       CGL029

      ** New Risk Participant Details in file format
     D LEVRPRTPD     E DS                  EXTNAME(LEVRPRTPD)
     D***V_REC                 72    140                                                      CGL029
     D***V_PAY                141    699                                                      CGL029
     D  VLREC1                72     73                                                       CGL029
     D  VLREC2                86    140                                                       CGL029
     D  VLPAY1               141    142                                                       CGL029
     D  VLPAY2               155    699                                                       CGL029

      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D  FLREC1                 1      2                                                       CGL029
     D  FLREC2                21     75                                                       CGL029

      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D  FLPAY1                 1      2                                                       CGL029
     D  FLPAY2                21    565                                                       CGL029

      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Module details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** Retail details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Data structure for passing a parameter to synon screen
      ** handling program.
     D SETLIB        E DS                  EXTNAME(SETLIAB) INZ
     D SETLIBRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D SETLIBPONS    E                     EXTFLD(QQPONS)                                     CGL029

      ** Data structure for passing a parameter to synon screen
      ** handling program.
     D SETLIZ        E DS                  EXTNAME(SETLIAZ)
                                                                                              222373
     D @PARM3        E DS                  EXTNAME(SDSETLPD)                                  222373

      ** IN Message Format
     D P#INMF        E DS                  EXTNAME(LER1MFPD)
     D P#INMFRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D P#INMFPONS    E                     EXTFLD(QQPONS)                                     CGL029

      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LER2MFPD)

     D SP_RPRT         DS
     D  S#ActPrFc              1     12
      *
     D SLNRF           S              6                                                       222373
      *
      ** Data to be passed to window program
     I/COPY QWINDSRC,LERPRTGDTA
      *
      /SPACE 5

      * Initialisation
     C                   EXSR      INITPR

      * Access primary facility

     C                   MOVE      R1CNUM        S#PRCU
     C                   MOVE      R1CNUM        S#PMFC
     C                   MOVE      R1FACT        S#PMFT
     C                   MOVE      R1FCNO        S#PMFN

     C                   EXSR      ACSPFA

      * End if any errors

     C     Idx           IFNE      0
     C                   MOVEL     'FCLTYFM '    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     S#PMFC        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      * Populate primary facility fields

     C                   MOVE      FcbrBranch    S#BRCA
     C                   MOVE      FccyFCCY      S#FCCY

      ** If insert or amend
      ** Default the risk participants on a tranche from the
      ** risk participants present for the credit agreement

     C     R1ACTN        IFEQ      'I'
     C     R1ACTN        OREQ      'A'
     C     R1ACTN        OREQ      ' '
     C     FctrTRCA      IFEQ      'TR'
     C                   EXSR      DFLT_MBRS
     C                   ENDIF
     C                   ENDIF

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

      * Reset subfile RRN
     C                   Z-ADD     *ZEROS        RRN1              4 0

      * Reset total participant share amount
     C                   Z-ADD     0             W#SHAM           13 0

      * Reset Settlement Screen Setup indicator
     C                   MOVE      'N'           SSCR_SetUp

      **  Clear subfile
     C                   MOVEA     '000'         *IN(30)
     C                   WRITE     LERPRTC1

      **  Read all syndicate members

     C                   MOVE      FcbrBranch    K#BRCA
     C                   MOVE      S#PMFC        K#PMFC
     C                   MOVE      S#PMFT        K#PMFT
     C                   MOVE      S#PMFN        K#PMFN
     C     PFCLTK        SETLL     LEPARTL1
     C     PFCLTK        READE     LEPARTL1                               70
      *
     C     *IN70         DOWEQ     *OFF
      *
     C                   MOVE      *BLANKS       S#SEL
     C                   MOVE      *OFF          *IN36

      * Risk Participant Convert

     C                   EXSR      RPRTCVT

      ** Accumulate participant share amount

     C                   ADD       SHAM          W#SHAM

      * Increment subfile RRN
     C                   ADD       1             RRN1
      *
     C                   WRITE     LERPRTS1
     C     PFCLTK        READE     LEPARTL1                               70
      *
     C                   ENDDO

      ** Set on subfile display indicators.

     C     RRN1          IFGT      0

      ** Format percentage sold
     C     W#FAMT        IFNE      0
     C     W#SHAM        DIV       W#FAMT        W#PCSD           15 9
     C                   MULT      100           W#PCSD
     C                   ELSE
     C                   Z-ADD     0             W#PCSD
     C                   ENDIF
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      W#PCSD        ZFIELD
     C                   Z-ADD     9             ZADEC
     C                   EXSR      ZEDIT2
     C                   MOVE      ZFIELD        S#PCSD

     C                   MOVEA     '111'         *IN(30)

      *  Records found
     C                   MOVE      *OFF          *IN65

      *  Position subfile
     C                   Z-ADD     1             ##SFRC
      *
     C                   ELSE

      *  Records not found
     C                   MOVE      *BLANK        S#PCSD
     C                   MOVEA     '010'         *IN(30)
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
     C                   WRITE     LERPRTF2
     C                   WRITE     LERPRTF5
     C                   WRITE     #MSGCTL
     C   65              WRITE     LERPRTF4
     C                   EXFMT     LERPRTC1

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
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ
     C                   PARM                    SLNRF                                        222373
     C                   PARM                    @PARM3                                       222373
      *
     C     *IN12         IFEQ      *OFF
     C                   MOVE      'T'           R2MSGS
     C                   ELSE
     C     EarlyExit     IFEQ      'N'
     C                   MOVE      'P'           R2MSGS
     C                   ENDIF
     C                   ENDIF
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
     C     1             CHAIN     LERPRTS1                           70
     C     *IN70         DOWEQ     *OFF
     C                   MOVE      ' '           S#SEL
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN36
     C                   UPDATE    LERPRTS1
     C                   READC     LERPRTS1                               70
     C                   ENDDO
     C                   ENDIF

      ** Position to first page

     C                   Z-ADD     1             ##SFRC
      *
     C                   ELSE

      ** If the current screen is the Insert screen
      ** Clear screen fields and reset screen error indicators

     C     CurrentSCR    IFEQ      'INS'
     C                   EXSR      CLR_SYN
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
     C                   EXSR      CLR_SYN
      *
     C                   MOVE      'I'           S#ACTN
     C                   MOVE      *OFF          *IN12
     C                   MOVE      *OFF          *IN67
     C                   MOVE      *OFF          *IN68

     C                   Z-ADD     0             P_WIdx
     C                   MOVE      'Y'           Valid_Set
      *
     C                   MOVE      'INS'         CurrentSCR        3

      ** Display the screen until CF/3 or CF/12 taken

     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LERPRTF2
     C                   WRITE     LERPRTF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LERPRTF3

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

      **  Enter Key Processing - Validate the syndicate member details
     C                   CAS                     VAL_SYND
      *
     C                   ENDCS
      *
     C                   ENDDO

      * Setoff 'add' and 'previous screen' indicators
     C                   MOVE      *OFF          *IN09
     C                   MOVE      *OFF          *IN12
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Process the deletion screen                                   *
      *****************************************************************
     C     CF10          BEGSR

      ** Clear Message subfile

     C                   EXSR      CLEARM

      ** Update the database

     C                   MOVEL     LEPARTPDFmt   LEVRPRTPD

     C                   EXSR      UPD_DBASE

      ** If there were errors in database update
      ** report them

     C     RetCodeOut    IFEQ      '*RECUPD'

     C                   ROLBK
     C                   MOVEL     'LEP0026'     ZAMSID
     C                   EXSR      ZASNMS

     C                   ELSE

     C     RetCodeOut    IFNE      *BLANK
     C                   ROLBK
     C     MsgIDArr(1)   IFNE      *BLANK
     C                   MOVEL     MsgIDArr(1)   ZAMSID
     C                   ELSE
     C                   MOVEL     'LEL0035'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS

     C                   ELSE

      ** Commit the database changes

     C                   COMMIT

      **  Display Message (Record deleted)

     C                   MOVEL     'LEK0023'     ZAMSID
     C                   EXSR      ZASNMS

     C                   ENDIF
     C                   ENDIF

      ** Rebuild the subfile

     C                   EXSR      BLDSFL

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
     C                   MOVE      'N'           SSCR_SetUp

      ** Reset subfile error indicators

     C     *IN65         IFEQ      *OFF
     C     S#ACTN        ANDNE     'I'
     C     ##RRN1        CHAIN     LERPRTS1                           70
     C                   MOVE      *ON           *IN35
     C                   MOVE      *ON           *IN36
     C                   UPDATE    LERPRTS1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Extended Settlement Details                                   *
      *****************************************************************
     C     CF14          BEGSR

      ** Setup the settlement screen fields (SETLIAB/SETLIAZ)

     C     SSCR_SetUp    IFEQ      'N'
     C                   EXSR      SETUP_SSCR
     C                   MOVE      'Y'           SSCR_SetUp        1
     C                   ENDIF

      ** Call extended settlements input

     C                   CALL      'SD2400'
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ
     C                   PARM                    SLNRF                                        222373
     C                   PARM                    @PARM3                                       222373

      ** Terminate the program if database error returned

     C     PMDBSE        IFNE      *ZERO
     C                   MOVEL     '*ERROR'      RetCodeIn
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
     C     PMERCD        IFNE      *BLANK
     C                   MOVEL     'LEA1020'     ZAMSID
     C                   ELSE
     C                   MOVEL     'LEX9991'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS

     C                   ELSE
     C                   MOVE      'Y'           Valid_Set         1
     C                   EXSR      SET_SC2FL
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

     C                   EXSR      VLDSFL

      **  If no errors in the subfile, execute the valid option subroutine

     C     SubfilErr     IFEQ      'N'
      *
     C                   SELECT
     C     S#ACTN        WHENEQ    'E'
     C                   EXSR      ENQRYS
     C     S#ACTN        WHENEQ    'D'
     C                   EXSR      DELETE
     C     S#ACTN        WHENEQ    'A'
     C                   EXSR      AMENDS
     C                   ENDSL
      *
     C                   MOVE      *OFF          *IN12
      *
     C                   ENDIF
     C                   ENDIF

      * If this function is being called on facility authorisation
      * and there are no subfile records, end now

     C     R1ACTN        IFEQ      'X'
     C     *IN65         IFEQ      *ON
     C     ##CNT1        OREQ      *ZEROS
     C                   MOVE      *ON           *IN12
     C                   MOVE      'Y'           EarlyExit
     C                   EXSR      CF03
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate subfile selection                                    *
      *****************************************************************
     C     VLDSFL        BEGSR
      *
     C                   Z-ADD     *ZEROS        ##CNT1            3 0

      **  Read all changed records
     C                   READC     LERPRTS1                               70
     C     *IN70         DOWEQ     *OFF
      *
     C     S#SEL         IFNE      ' '
     C     P#MODE        IFEQ      'E'
     C                   EXSR      VLDENQ
     C                   ELSE
     C                   EXSR      VLDALL
     C                   ENDIF
     C                   ENDIF
      *
     C     S#SEL         IFEQ      ' '
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN36
     C                   ELSE
     C                   MOVE      *ON           *IN35
     C                   MOVE      *ON           *IN36
     C                   ADD       1             ##CNT1
     C                   ENDIF
      *
     C     S#SEL         IFNE      ' '
     C                   Z-ADD     RRN1          ##RRN1            4 0
     C                   Z-ADD     RRN1          ##SFRC
     C                   MOVE      S#SEL         S#ACTN
     C                   ENDIF
      *
     C                   UPDATE    LERPRTS1

      **  Read next changed record
     C                   READC     LERPRTS1                               70
      *
     C                   ENDDO

      **  More than one selection
     C     ##CNT1        IFGT      1
      *
     C                   MOVE      'Y'           SubfilErr

      **  Display Message
     C                   MOVEL     'LEP0027'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ELSE

      **  No selection made therefore do nothing
     C     ##CNT1        IFEQ      0
     C                   MOVEL     'Y'           SubfilErr
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate subfile selection for Enquiry                        *
      *****************************************************************
     C     VLDENQ        BEGSR

      **  Only 'E' can be used to make a valid selection

     C     S#SEL         IFNE      'E'

     C                   MOVE      *ON           *IN36

      **  Display Error Message if not already displayed
     C     SubfilErr     IFEQ      'N'
     C                   MOVEL     'LEK0030'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           SubfilErr
     C                   ENDIF

     C                   ELSE

     C                   EXSR      RPRTRTV

      * If an error was detected
     C     Idx           IFNE      0
     C                   MOVE      *ON           *IN36

      * Send messages to the screen
     C     SubfilErr     IFEQ      'N'
     C                   CLEAR                   RPRT_OK
     C                   EXSR      SET_SCEI
     C                   MOVEL     'Y'           SubfilErr
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate subfile selection - Amend, Delete and Enquire
      *****************************************************************
     C     VLDALL        BEGSR

      **  Only 'A' 'E' or 'D' can be used to make a valid selection

     C     S#SEL         IFNE      'E'
     C     S#SEL         ANDNE     'A'
     C     S#SEL         ANDNE     'D'

     C                   MOVE      *ON           *IN36

      **  Display Error Message if not already displayed
     C     SubfilErr     IFEQ      'N'
     C                   MOVEL     'LEK0030'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           SubfilErr
     C                   ENDIF

     C                   ELSE

     C                   EXSR      RPRTRTV

      * If an error was detected
     C     Idx           IFNE      0
     C                   MOVE      *ON           *IN36

      * Send messages to the screen
     C     SubfilErr     IFEQ      'N'
     C                   CLEAR                   RPRT_OK
     C                   EXSR      SET_SCEI
     C                   MOVEL     'Y'           SubfilErr
     C                   ENDIF
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
     C                   MOVE      *ON           *IN67
     C                   MOVE      *OFF          *IN68

      ** Display the screen until CF/3 or CF/12 taken

     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LERPRTF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LERPRTF3

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
     C                   MOVE      *OFF          *IN67
     C                   MOVE      *OFF          *IN68

     C                   Z-ADD     0             P_WIdx
     C                   MOVE      'Y'           Valid_Set

     C                   MOVE      'AMD'         CurrentSCR        3

      ** Display the screen until CF/3 or CF/12 taken

     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LERPRTF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LERPRTF3

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

      **  Enter Key Processing
     C                   CAS                     VAL_SYND
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
     C                   MOVE      *ON           *IN67
     C                   MOVE      *ON           *IN68

      **  Display the screen until CF/3, CF/10 or CF/12 taken

     C     *IN03         DOWEQ     *OFF
     C     *IN10         ANDEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LERPRTF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LERPRTF3

      **  Clear Message subfile
     C                   EXSR      CLEARM

      **  F3  - Exit
     C     *IN03         CASEQ     '1'           CF03

      **  F10- Delete
     C     *IN10         CASEQ     '1'           CF10

      **  F12- Previous
     C     *IN12         CASEQ     '1'           CF12

      **  F14 - Settlements
     C     *IN14         CASEQ     '1'           CF14

      **  Enter Processing
     C                   CAS                     ENTER
      *
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Enter processing                                              *
      *****************************************************************
     C     ENTER         BEGSR

      **  Display Message
     C                   MOVEL     'LEK0027'     ZAMSID
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
     C     ##RRN1        CHAIN     LERPRTS1                           70

      ** Risk Participant Retrieve

     C                   EXSR      RPRTRTV

      ** Risk Participant settlement instructions

     C**********         MOVEL     LeRPRTREC     F_REC                                        CGL029
     C**********         MOVEL     LeRPRTPAY     F_PAY                                        CGL029
     C                   MOVEL     LeRPRTREC1    FLREC1                                       CGL029
     C                   MOVEL     RONS          FLRONS                                       CGL029
     C                   MOVEL     LeRPRTREC2    FLREC2                                       CGL029
     C                   MOVEL     LeRPRTPAY1    FLPAY1                                       CGL029
     C                   MOVEL     PONS          FLPONS                                       CGL029
     C                   MOVEL     LeRPRTPAY2    FLPAY2                                       CGL029
     C                   MOVE      CVMR          FLCVMR
     C                   MOVE      OMDB          FLPOBR
     C                   MOVE      OSDB          FLROBR
     C                   MOVE      SCCY          FLPSCY
     C                   MOVE      SCCY          FLRSCY
     C                   MOVE      ICCY          FLIC72

      * Risk Participant Convert

     C                   EXSR      RPRTCVT
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Syndicate member details                             *
      *****************************************************************
     C     VAL_SYND      BEGSR

      ** Reset screen error indicators

     C                   EXSR      RESET_SCEI

      ** Clear Message subfile

     C                   EXSR      CLEARM

      ** Validate risk participant details

     C                   EXSR      RPRTVAL

      ** If there are errors in the risk participant details screen
      ** or if there are warnings that haven't been output
      ** set screen error indicators (and send messages to the screen)

     C     Idx           IFNE      0
     C     WIdx          ORNE      P_WIdx
     C                   Z-ADD     WIdx          P_WIdx            3 0
     C                   EXSR      SET_SCEI
     C                   GOTO      EVAL_SYND
     C                   ENDIF

      ** If this is an insert and the settlements screen has not been called
      ** display the settlements screen
      ** (If CF/3 is taken from the settlements screen, then exit)

     C     S#ACTN        IFEQ      'I'
     C     SSCR_SetUp    ANDEQ     'N'
     C                   EXSR      CF14
     C     *in03         IFEQ      '1'
     C                   GOTO      EVAL_SYND
     C                   ENDIF
     C                   ENDIF

     C     SSCR_SetUp    IFEQ      'Y'

      ** Risk Participant settlement instructions

     C**********         MOVEL     F_REC         V_REC                                        CGL029
     C**********         MOVEL     F_PAY         V_PAY                                        CGL029
     C                   MOVEL     FLREC1        VLREC1                                       CGL029
     C                   MOVEL     FLRONS        ASRONS                                       CGL029
     C                   MOVEL     FLREC2        VLREC2                                       CGL029
     C                   MOVEL     FLPAY1        VLPAY1                                       CGL029
     C                   MOVEL     FLPONS        ASPONS                                       CGL029
     C                   MOVEL     FLPAY2        VLPAY2                                       CGL029
     C                   MOVE      FLCVMR        ASCVMR
     C                   MOVE      FLPOBR        ASOMDB
     C                   MOVE      FLROBR        ASOSDB
     C                   MOVE      FLPSCY        ASSCCY
     C                   MOVE      FLRSCY        ASSCCY
     C                   MOVE      FLIC72        ASICCY
     C                   ENDIF

      ** If there are errors in the settlement screen
      ** send a message to the current screen

     C     Valid_Set     IFNE      'Y'
     C                   MOVEL     'LEA1020'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      EVAL_SYND
     C                   ENDIF

      ** Call the window

     C                   EXSR      SRWNDW
      *
      * CF/3 taken from the window
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   MOVE      '1'           *IN03
     C                   GOTO      EVAL_SYND
     C                   ELSE
      *
      *  CF/12 taken from the window
      *
     C     #RTRN         IFEQ      'USR0790'
     C                   GOTO      EVAL_SYND
     C                   ENDIF
     C                   ENDIF

      ** Update the database

     C                   EXSR      UPD_DBASE

      ** If there were errors in database update
      ** report them

     C     RetCodeOut    IFEQ      '*RECUPD'

     C                   ROLBK
     C                   MOVEL     'LEP0026'     ZAMSID
     C                   EXSR      ZASNMS

     C                   ELSE

     C     RetCodeOut    IFNE      *BLANK
     C                   ROLBK
     C     MsgIDArr(1)   IFNE      *BLANK
     C                   MOVEL     MsgIDArr(1)   ZAMSID
     C                   ELSE
     C                   MOVEL     'LEL0035'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS

     C                   ELSE

      ** Commit the database changes

     C                   COMMIT

      **  Display Message (Record added or updated)

     C     S#ACTN        IFEQ      'I'
     C                   MOVEL     'LEK0021'     ZAMSID
     C                   ELSE
     C                   MOVEL     'LEK0022'     ZAMSID
     C                   ENDIF
     C                   EXSR      ZASNMS

     C                   ENDIF
     C                   ENDIF

      ** Rebuild the subfile

     C                   EXSR      BLDSFL

      **  Move to previous screen
     C                   MOVE      *ON           *IN12
      *
     C     EVAL_SYND     ENDSR
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
     C                   Z-ADD     BJRDNB        PMDTRC
     C                   Z-ADD     BJRDNB        PMDTPY
     C                   MOVE      FccyFCCY      PMRCCY
     C                   MOVE      FccyFCCY      PMPCCY
     C                   MOVE      *BLANK        PMFFND
     C                   MOVE      FcbrBranch    PMBRCA
     C                   MOVE      *BLANK        PMCMDP
     C                   Z-ADD     0             PMDBSE
     C                   MOVE      *BLANKS       PMERCD
     C                   MOVE      'Y'           PMFRST
     C                   MOVE      'N'           PMVALO
     C                   Z-ADD     BJRDNB        PMRUND

      ** Determine if pay & receive settlement screen will be protected

     C     S#ACTN        IFEQ      'E'
     C     S#ACTN        OREQ      'D'
     C                   MOVE      'Y'           PMPRCV
     C                   MOVE      'Y'           PMPPAY
     C                   ELSE
     C                   MOVE      'N'           PMPRCV
     C                   MOVE      'N'           PMPPAY
     C                   ENDIF

      ** Set settlement details valid flag

     C     S#ACTN        IFEQ      'E'
     C     S#ACTN        OREQ      'D'
     C                   MOVE      'Y'           PMSDTV
     C                   ELSE
     C                   MOVE      'N'           PMSDTV
     C                   ENDIF

      ** If amend, enquire or delete
      ** move settlement file fields to screen fields
      ** Else clear settlement screen fields

     C     S#ACTN        IFEQ      'A'
     C     S#ACTN        OREQ      'E'
     C     S#ACTN        OREQ      'D'
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
     C                   PARM      *BLANK        RetCodeIn

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
     C                   PARM      *BLANK        RetCodeIn

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

      ** Risk Participant settlement instructions

     C**********         MOVEL     F_REC         LeRPRTREC                                    CGL029
     C**********         MOVEL     F_PAY         LeRPRTPAY                                    CGL029
     C                   MOVEL     FLREC1        LeRPRTREC1                                   CGL029
     C                   MOVEL     FLRONS        RONS                                         CGL029
     C                   MOVEL     FLREC2        LeRPRTREC2                                   CGL029
     C                   MOVEL     FLPAY1        LeRPRTPAY1                                   CGL029
     C                   MOVEL     FLPONS        PONS                                         CGL029
     C                   MOVEL     FLPAY2        LeRPRTPAY2                                   CGL029
     C                   MOVE      FLCVMR        CVMR
     C                   MOVE      FLPOBR        OMDB
     C                   MOVE      FLROBR        OSDB
     C                   MOVE      FLPSCY        SCCY
     C                   MOVE      FLRSCY        SCCY
     C                   MOVE      FLIC72        ICCY

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Clear Syndicate member screen fields                          *
      *****************************************************************
     C     CLR_SYN       BEGSR
      *
     C                   MOVE      *BLANK        S#CSSN
     C                   MOVE      *BLANK        S#INUM
     C                   MOVE      *BLANK        S#JDTE
     C                   MOVE      *BLANK        S#SHTP
     C                   MOVE      *BLANK        S#SHAR
     C                   MOVE      *BLANK        S#FEBR
     C                   MOVE      *BLANK        S#FERA
     C                   MOVE      *BLANK        S#FERS
     C                   MOVE      *BLANK        S#DRTP
     C                   MOVE      *BLANK        S#DRST
     C                   MOVE      *BLANK        S#DRCL                                       CLE042
      *
     C                   MOVE      *BLANK        S#SRNM
     C                   MOVE      *BLANK        S#SRTN
     C                   MOVE      *BLANK        S#IRNM
     C                   MOVE      *BLANK        S#IRTN
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

     C                   MOVEA     RPRT_OK       #EI

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
      * Window processing subroutine                                  *
      *****************************************************************
     C     SRWNDW        BEGSR
      *
     C/COPY QWINDSRC,LERPRTMOV1

      **  Call window manager WN0010
     C                   CALL      'WN0010'
     C                   PARM      'LERPRTSIN'   #PGM             10
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
      * Update the Database                                           *
      *****************************************************************
     C     UPD_DBASE     BEGSR
      *
     C                   CALLB     'LERPRTUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut

      * Mode
     C                   PARM                    P#MODE            1

      * Action Code
     C                   PARM                    S#ACTN

      * Risk Participant Details in file format
     C                   PARM                    LEVRPRTPD
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    RPRT_OK
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
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Risk participant retrieve                                    *
      *****************************************************************
     C     RPRTRTV       BEGSR

     C                   CALLB     'LERPRTRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn

      * Mode
     C                   PARM                    P#MODE            1
      * Response mode
     C                   PARM      'S'           RESPMODE          1

      * Action and customer
     C                   PARM      S#SEL         S#ACTN
     C                   PARM      S#CSNM        S#CSSN

      * Primary facility customer, type & number
     C                   PARM                    S#PMFC
     C                   PARM                    S#PMFT
     C                   PARM                    S#PMFN

      * Prime facility branch
     C                   PARM                    FcbrBranch
      *
      * OUTPUTS

      * Participant Details in file format
     C                   PARM                    LEPARTPDFmt

      * Action and customer OK indicators
     C                   PARM                    S#ACTNok
     C                   PARM                    S#CSSNok

      * Customer number
     C                   PARM                    S#CNUM            6
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
      *  Risk participant validation                                  *
      *****************************************************************
     C     RPRTVAL       BEGSR

     C                   CALLB     'LERPRTVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn

      * Mode
     C                   PARM                    P#MODE            1

      * Risk Participant Details in screen format
     C                   PARM                    RPRT

      * Agent number
     C                   PARM                    S#ANUM            6

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
     C                   PARM      *BLANKS       R1PCOB            3
     C                   PARM      *BLANKS       R1TNRF           15
      *
      * OUTPUTS

      * Field OK flags
     C                   PARM                    RPRT_OK
      *
      * Syndicate customer number
     C                   PARM                    S#CNUM            6
      * Syndicate member customer name/town
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10
      * Introducing customer name/town
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10
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
      * Valid Risk Participant
     C                   PARM                    LEVRPRTPD

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Risk Participant Convert                                     *
      *****************************************************************
     C     RPRTCVT       BEGSR

     C                   CALLB     'LERPRTCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Risk participant details in file format
     C                   PARM                    LEPARTPDFmt

      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY
     C                   PARM                    FccyNBDP
      *
      * OUTPUTS
      *
      * Risk Participant Details in screen format
     C                   PARM                    RPRT

      * Syndicate member details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10

      * Introducing customer details
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10

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

      * Screen fields
     C                   MOVE      PSUser        S#USER
     C                   MOVE      PSJobName     S#WSID
     C                   MOVE      BJMRDT        S#RUNA

     C                   MOVE      PSProcName    ##PGM

      * Subfile indicators
     C                   MOVE      *ON           *IN25
     C                   Z-ADD     1             ##SFRC

      * Enquiry mode
     C     P#MODE        IFEQ      'E'
     C                   MOVE      *ON           *IN66
     C                   ENDIF

      * Enable settlements screen
     C                   MOVE      *ON           *IN69

      ** SETLIAZ parameters

     C                   MOVE      BGRTBN        PMRETP
     C                   MOVE      BMRANR        PMRETS

     C                   MOVE      'N'           EarlyExit         1

     C                   MOVEL     'LERMSGF '    ZAMSGF

      ** Key fields

     C     *LIKE         DEFINE    BRCA          K#BRCA
     C     *LIKE         DEFINE    CNUM          K#PMFC
     C     *LIKE         DEFINE    FACT          K#PMFT
     C     *LIKE         DEFINE    FCNO          K#PMFN

     C     *LIKE         DEFINE    BRCA          K#BRNC
     C     *LIKE         DEFINE    CNUM          K#CUNO
     C     *LIKE         DEFINE    FACT          K#CUFA
     C     *LIKE         DEFINE    FCNO          K#CFNO

      ** Key lists

     C     PFCLTK        KLIST
     C                   KFLD                    K#BRCA
     C                   KFLD                    K#PMFC
     C                   KFLD                    K#PMFT
     C                   KFLD                    K#PMFN

     C     PARTK         KLIST
     C                   KFLD                    K#BRNC
     C                   KFLD                    K#CUNO
     C                   KFLD                    K#CUFA
     C                   KFLD                    K#CFNO

     C     CFCLTK        KLIST
     C                   KFLD                    K#CUNO
     C                   KFLD                    K#CUFA
     C                   KFLD                    K#CFNO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Access Primary Facility                                       *
      *****************************************************************
     C     ACSPFA        BEGSR

     C                   CALLB     'LE002520'
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
      * Prime Facility tranche/credit agreement Ind
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
     C                   PARM      *zero         Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0

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
      * Default members                                               *
      *****************************************************************
     C     DFLT_MBRS     BEGSR

     C                   MOVE      S#BRCA        K#BRNC
     C                   MOVE      S#PMFC        K#CUNO
     C                   MOVE      S#PMFT        K#CUFA
     C                   MOVE      S#PMFN        K#CFNO

     C     PARTK         CHAIN     LEPARTL1                           80

      * If no risk participants exist, create them

     C     *IN80         IFEQ      *ON

     C                   MOVE      FccaCANM      K#CUNO
     C                   MOVE      FccaCAFT      K#CUFA
     C                   MOVE      FccaCAFN      K#CFNO

     C     CFCLTK        CHAIN     LEFCLTL0                           80

     C     *IN80         IFEQ      *OFF

     C                   MOVE      BRCA          K#BRNC

     C     PARTK         SETLL     LEPARTL1
     C     PARTK         READE     LEPARTL1                               80

     C     *IN80         DOWEQ     *OFF

      ** Only use syndicate members if their share type is percentage
      ** or if their share type is amount and their currency
      ** matches the current primary facility currency

     C     SHTP          IFEQ      'P'
     C     SHTP          OREQ      'A'
     C     CCY           ANDEQ     S#FCCY

      ** Risk Participant settlement instructions

     C     CCY           IFEQ      S#FCCY
     C**********         MOVEL     LeRPRTREC     F_REC                                        CGL029
     C**********         MOVEL     LeRPRTPAY     F_PAY                                        CGL029
     C                   MOVEL     LeRPRTREC1    FLREC1                                       CGL029
     C                   MOVEL     RONS          FLRONS                                       CGL029
     C                   MOVEL     LeRPRTREC2    FLREC2                                       CGL029
     C                   MOVEL     LeRPRTPAY1    FLPAY1                                       CGL029
     C                   MOVEL     PONS          FLPONS                                       CGL029
     C                   MOVEL     LeRPRTPAY2    FLPAY2                                       CGL029
     C                   MOVE      CVMR          FLCVMR
     C                   MOVE      OMDB          FLPOBR
     C                   MOVE      OSDB          FLROBR
     C                   MOVE      SCCY          FLPSCY
     C                   MOVE      SCCY          FLRSCY
     C                   MOVE      ICCY          FLIC72
     C                   ELSE
     C                   CLEAR                   F_REC
     C                   CLEAR                   F_PAY
     C                   ENDIF

      * Risk Participant Convert

     C                   MOVEL     RPRT          SP_RPRT
     C                   EXSR      RPRTCVT
     C                   MOVEL     SP_RPRT       RPRT
     C                   MOVEL     'I'           S#ACTN

      ** Update the database

     C                   EXSR      UPD_DBASE

      ** If there were errors in the database update
      ** rollback the database changes
      ** Otherwise, commit the database changes

     C     RetCodeOut    IFNE      *BLANK
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
     C                   ENDIF

     C     PARTK         READE     LEPARTL1                               80
     C                   ENDDO

     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZEDIT2        BEGSR
     C                   CALLB     'ZEDIT2'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             2 0
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
     C                   MOVE      'D'           R2MSGS
     C                   CALL      'DBERRCTL'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
