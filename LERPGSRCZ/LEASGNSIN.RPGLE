     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Assignment screen input')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEASGNSIN - Assignment Screen Input                          *
      *                                                               *
      *  Function:  This program allows entry and maintenance of      *
      *             the assignments within a syndicate.               *
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
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE025             DAte 20May04               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 02Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP070  *CREATE    Date 28Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Recompiled over changed LEVASGNPD file.             *
      *           Do not set up ASTYLC, not on LEASGNPD.              *
      *           Recompiled over changed LEASGNPD format.            *
      *  CAP070 - Conversion of Mn inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

      **  Facilities File
     FLEFCLTL0  IF   E           K DISK    INFSR(*PSSR)

      **  Assignment Details File
     FLEPARTL2  IF   E           K DISK    INFSR(*PSSR)

      **  Assignment Details File
     FLEPARTPD  O    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEPARTD0:LEPARTWRT)

     FLEASGNDDF CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(LEASGNS1:RRN1)
      *****************************************************************
      *                                                               *
      *    F U N C T I O N   O F   I N D I C A T O R S                *
      *                                                               *
      *    03      F3 PRESSED EXIT PROGRAM                            *
      *    05      F5 PRESSED REFRESH SCREEN                          *
      *    09      F9 PRESSED GO TO ADD MODE                          *
      *    10      F10 PRESSED GO TO REVERSE                          *
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
      *    44      Invalid assigned to customer                       *
      *    45      Invalid assigned from customer                     *
      *    46      Invalid assignment date                            *
      *    47      Invalid Share type                                 *
      *    48      Invalid Share (amount/percentage)                  *
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
      ** Error indicators
     D #EI             S              1    DIM(25)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

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

      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Module details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** Retail details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** IN Message Format
     D P#INMF        E DS                  EXTNAME(LER1MFPD)
     D QQPONSX       E                     EXTFLD(QQPONS)                                     CGL029
     D QQRONSX       E                     EXTFLD(QQRONS)                                     CGL029

      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LER2MFPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SKASGNS001

      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      /COPY WNCPYSRC,LSASGNS002
     C
      * Initialisation
     C                   EXSR      INITPR

      * Access primary facility

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

      * Reset Settlement Screen Setup indicator
     C                   MOVE      'N'           SSCR_SetUp

      **  Clear subfile
     C                   MOVEA     '000'         *IN(30)
     C                   WRITE     LEASGNC1

      **  Read all syndicate members

     C                   MOVE      FcbrBranch    K#BRCA
     C                   MOVE      S#PMFC        K#PMFC
     C                   MOVE      S#PMFT        K#PMFT
     C                   MOVE      S#PMFN        K#PMFN
     C     PFCLTK        SETLL     LEPARTL2
     C     PFCLTK        READE     LEPARTL2                               70
      *
     C     *IN70         DOWEQ     *OFF
      *
     C                   MOVE      *BLANKS       S#SEL
     C                   MOVE      *OFF          *IN36

      * History Flag

     C     VDTC          IFLT      BJRDNB
     C                   MOVE      'H'           S#HIST
     C                   ELSE
     C                   MOVE      *BLANKS       S#HIST
     C                   ENDIF

      * Assignment Convert

     C                   EXSR      ASGNCVT

      * Hidden fields in subfile record

     C                   MOVEL     S#ASFS        H#ASFS
     C                   Z-ADD     VDTC          H#VDTC

      * Increment subfile RRN
     C                   ADD       1             RRN1
      *
     C                   WRITE     LEASGNS1
     C     PFCLTK        READE     LEPARTL2                               70
      *
     C                   ENDDO

      ** Set on subfile display indicators.

     C     RRN1          IFGT      0

     C                   MOVEA     '111'         *IN(30)

      *  Records found
     C                   MOVE      *OFF          *IN65

      *  Position subfile
     C                   Z-ADD     1             ##SFRC
      *
     C                   ELSE

      *  Records not found
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
     C                   WRITE     LEASGNF2
     C                   WRITE     LEASGNF5
     C                   WRITE     #MSGCTL
     C   65              WRITE     LEASGNF4
     C                   EXFMT     LEASGNC1

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
     C     1             CHAIN     LEASGNS1                           70
     C     *IN70         DOWEQ     *OFF
     C                   MOVE      ' '           S#SEL
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN36
     C                   UPDATE    LEASGNS1
     C                   READC     LEASGNS1                               70
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
      *
     C                   MOVE      'INS'         CurrentSCR        3

      ** Display the screen until CF/3 or CF/12 taken

     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LEASGNF2
     C                   WRITE     LEASGNF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEASGNF3

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
      * Process the reversal screen                                   *
      *****************************************************************
     C     CF10          BEGSR

      ** Clear Message subfile

     C                   EXSR      CLEARM
     C                   MOVEL     LEPARTPDFmt   LEVASGNPD
     C**********         MOVEL     S#ACTN        ASTYLC                         CAP084

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
     C     ##RRN1        CHAIN     LEASGNS1                           70
     C                   MOVE      *ON           *IN35
     C                   MOVE      *ON           *IN36
     C                   UPDATE    LEASGNS1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Extended Settlement Details                                   *
      *****************************************************************
     C     CF14          BEGSR
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
     C     *IN03         CASEQ     '1'           CF03
      *
      * CK/12 - CANCEL ON SETTLEMENT DETAILS
      *
     C     *IN12         CASEQ     '1'           CF12
      *
      * Set fields on insert and amend

     C     S#ACTN        CASEQ     'I'           SETF_IA
     C     S#ACTN        CASEQ     'A'           SETF_IA
     C                   END
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
     C     S#ACTN        WHENEQ    'R'
     C                   EXSR      REVERS
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
     C                   READC     LEASGNS1                               70
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
     C                   UPDATE    LEASGNS1

      **  Read next changed record
     C                   READC     LEASGNS1                               70
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

     C                   EXSR      ASGNRTV

      * If an error was detected
     C     Idx           IFNE      0
     C                   MOVE      *ON           *IN36

      * Send messages to the screen
     C     SubfilErr     IFEQ      'N'
     C                   CLEAR                   ASGN_OK
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
      * Validate subfile selection - Amend, Reverse and Enquire
      *****************************************************************
     C     VLDALL        BEGSR

      **  Only 'A' 'E' or 'R' can be used to make a valid selection

     C     S#SEL         IFNE      'E'
     C     S#SEL         ANDNE     'A'
     C     S#SEL         ANDNE     'R'

     C                   MOVE      *ON           *IN36

      **  Display Error Message if not already displayed
     C     SubfilErr     IFEQ      'N'
     C                   MOVEL     'LEK0030'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           SubfilErr
     C                   ENDIF

     C                   ELSE

     C                   EXSR      ASGNRTV

      * If an error was detected
     C     Idx           IFNE      0
     C                   MOVE      *ON           *IN36

      * Send messages to the screen
     C     SubfilErr     IFEQ      'N'
     C                   CLEAR                   ASGN_OK
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
     C                   WRITE     LEASGNF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEASGNF3

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

     C                   MOVE      'AMD'         CurrentSCR        3

      ** Display the screen until CF/3 or CF/12 taken

     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   WRITE     LEASGNF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEASGNF3

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
      * Process reversal screen                                       *
      *****************************************************************
     C     REVERS        BEGSR

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
     C                   WRITE     LEASGNF1
     C                   WRITE     #MSGCTL
     C                   EXFMT     LEASGNF3

      **  Clear Message subfile
     C                   EXSR      CLEARM

      **  F3  - Exit
     C     *IN03         CASEQ     '1'           CF03

      **  F10- Reverse
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
     C     ##RRN1        CHAIN     LEASGNS1                           70

      ** Assignment Retrieve

     C                   EXSR      ASGNRTV

      ** Assignment settlement instructions

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

      * Assignment Convert

     C                   EXSR      ASGNCVT
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

      ** Validate assignment details

     C                   EXSR      ASGNVAL

      ** If there are errors in the assignment details screen
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

      ** If there are errors in the settlement screen
      ** or if there are warnings that haven't been output
      ** set screen error indicators (and send messages to the screen)

     C     Idx           IFNE      0
     C     WIdx          ORNE      P_WIdx
     C                   Z-ADD     WIdx          P_WIdx            3 0
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
     C                   ENDIF
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
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Clear Syndicate member screen fields                          *
      *****************************************************************
     C     CLR_SYN       BEGSR
      *
     C                   MOVE      *BLANK        S#ASTS
     C                   MOVE      *BLANK        S#ASFS
     C                   MOVE      *BLANK        S#ADTE
     C                   MOVE      *BLANK        S#SHTP
     C                   MOVE      *BLANK        S#SHAR
      *
     C                   MOVE      *BLANK        S#ATNM
     C                   MOVE      *BLANK        S#ATTN
     C                   MOVE      *BLANK        S#AFNM
     C                   MOVE      *BLANK        S#AFTN
      *
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
      * Window processing subroutine                                  *
      *****************************************************************
     C     SRWNDW        BEGSR
      *
     C/COPY QWINDSRC,LEASGNMOV1

      **  Call window manager WN0010
     C                   CALL      'WN0010'
     C                   PARM      'LEASGNSIN'   #PGM             10
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
     C                   CALLB     'LEASGNUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut

      * Mode
     C                   PARM                    P#MODE            1

      * Action Code
     C                   PARM                    S#ACTN

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
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Assignment retrieve                                          *
      *****************************************************************
     C     ASGNRTV       BEGSR

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
     C                   PARM      S#SEL         S#ACTN
     C                   PARM      S#ASTX        S#ASTS
     C                   PARM      H#ASFS        S#ASFS

      * Primary facility customer, type & number
     C                   PARM                    S#PMFC
     C                   PARM                    S#PMFT
     C                   PARM                    S#PMFN

      * Prime facility branch
     C                   PARM                    FcbrBranch

      * Value date of change
     C                   PARM      H#VDTC        In_VDTC           5 0
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
      *  Assignment validation                                        *
      *****************************************************************
     C     ASGNVAL       BEGSR

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
     C                   PARM      *BLANKS       R1PCOB            3
     C                   PARM      *BLANKS       R1TNRF           15
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
     C                   PARM      *zero         Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx

      * Valid Assignment
     C                   PARM                    LEVASGNPD

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Assignment Convert                                           *
      *****************************************************************
     C     ASGNCVT       BEGSR

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
     C                   PARM                    ASGN

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

     C                   MOVE      'N'           EarlyExit         1

     C                   MOVEL     'LERMSGF '    ZAMSGF

      ** Key fields

     C     *LIKE         DEFINE    BRCA          K#BRCA
     C     *LIKE         DEFINE    CNUM          K#PMFC
     C     *LIKE         DEFINE    FACT          K#PMFT
     C     *LIKE         DEFINE    FCNO          K#PMFN

      ** Key lists

     C     PFCLTK        KLIST
     C                   KFLD                    K#BRCA
     C                   KFLD                    K#PMFC
     C                   KFLD                    K#PMFT
     C                   KFLD                    K#PMFN
      *
     C                   ENDSR
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
