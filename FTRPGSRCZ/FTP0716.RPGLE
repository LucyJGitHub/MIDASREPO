     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0716 - Midas FT BIC Plus Enquiry (STP)                    *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 13Sep11               *
      *  Last Amend No. MK0504  *Create    Date 01Feb2005             *
      *  Prev Amend No. EEE065  *Create    Date 19May2004             *
      *  Prev Amend No. xxxxxx             Date ddmmmyyyy             *
      *                                                               *
      *  Only two entry modes currently used:                         *
      *  - Mode 'P' = Prompt Mode                                     *
      *  - Mode 'B' = Batch Mode                                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancement to Midas Plus level.      *
      *  MK0504 - Change open share to *no for MEBICPL0.              *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
     FFTP0716DF CF   E             WORKSTN USROPN
     F                                     SFILE(FTP716F0:@SFK)
     F*
     FMEBICPL0  IF   E           K DISK    USROPN
     F* BIC Plus file
     FMEZIPPL0  IF   E           K DISK
     F* ZIP placement and clearing code
     FMEBICCL0  IF   E           K DISK
     F* BIC Countries file
     F*
      /EJECT
      *
      *   INDICATOR USAGE
      *   ---------------
      *
      *   01      READ  operation on format
      *   02      READC operation on subfile
      *   22      HELP requested
      *   23      SFLCLR
      *   24      SFLDSP
      *   25      SFLEND
      *   29      ROLLUP requested
      *   30      SFLDSPCTL on subfile
      *   40      Switch between Branch and location
      *   41      Footer Indicator
      *   42      Stand alone enquiry mode
      *   50      SCAN Indicator
      *   51      SCAN Indicator
      *   72      MEBICPL0 is opened
      *   73      CHAIN FTP716F0
      *
      *   90 - 99 Used in validation/conversion routines (Z s/r's)
      *
      *   U7      Data base error
      *   U8      Data base error
      *
      /EJECT
      *
      *   SUB-ROUTINE DEFINITIONS
      *   -----------------------
      *
      *   INIT    Initialisation
      *   VALID   Validate field selection
      *   BLDQRY  Build command for the open query file
      *   BLDSFL  Build a subfile page
      *   SMODE   Stand alone enquiry mode
      *   PMODE   In line prompt mode
      *   SFMODE  In line search mode
      *   SWITCH  Switch between Location and branch
      *   DETAIL  Display details of a record
      *   DETAIL  Display details of a record
      *   EXIT    Close file and exit program
      *   DBERR   Error handling
      *
      /EJECT
      *
     D APOS            S              1    DIM(1) CTDATA PERRCD(1)
     D QRY             S             80    DIM(6) CTDATA PERRCD(1)                            array
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)                            MK0504
      *
      *  Array of QCMDEXC commands
      *
     D COM             S              1    DIM(250)                                           array
      * Working arrays for the seach criteria
     D WRD             S             35    DIM(5)                                             array
     D WSG             S              1    DIM(5)                                             array
     D WLN             S              2  0 DIM(5)                                             array
     D EDT             S              1    DIM(80)                                            MK0504
     D* Constant for query selection
     D CINDX           C                   CONST('(BSINDX *CT ')
     D CINST           C                   CONST('(BIINST *CT ')
     D CBNCH           C                   CONST('(BIBNCH *CT ')
     D CLOCN           C                   CONST('(BILOCN *CT ')
     D CBIC            C                   CONST('(BIBIC  *CT ')
     D CNATI           C                   CONST('(BINATI *CT ')
     D CCHIP           C                   CONST('(BICHIP *CT ')
     D CAND            C                   CONST('*AND ')
     D CANDN           C                   CONST('*AND^ ')
      /EJECT
      * Data structure for compilation - Copyright insertion
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *  Error reporting data structure
     D LDA             DS           256
     D  @DBFIL               134    141
     D  @DBKEY               142    170
     D  @DBPGM               171    180
     D  @DBASE               181    183  0
     D  @DBALL               134    183
      * Program data structure
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *  Data structure to insert variables into error message
     D @ERR            DS            76
     D  @SJOB                  6     14
      *
     D*     Data Structure for FTP716F2
     D SCRSEL          DS
     D  @2INSV                 1     35
     D  @2LBRV                36     70
     D  @2BICV                71     81
     D  @2NATV                82     96
     D  @2CHPV                97    102
     D* Data Structure for query selection
     D COMMD           DS           310
     D  COM1                   1     80
     D  COM2                  81    122
     D  COM3A                123    252
     D  COM3B                 81    310
     D  CMD                    1    310
     D                                     DIM(310)
     D                 DS
     D  QSLT                   1    210
     D                                     DIM(210)
     D  QSLT2                  1    210
     D @OADD           DS           175
      * Output Data Structure for reformatted address
     D  OADD1                  1     35
     D  OADD2                 36     70
     D  OADD3                 71    105
     D  OADD4                106    140
     D  OADD5                141    175
     D WKADD           DS           140
      * Working Data Structure for reformatted address
     D  WADD1                  1     35
     D  WADD2                 36     70
     D  WADD3                 71    105
     D  WADD4                106    140
     D*
      **  Data structure for search criteria
     D                 DS
     D  @2CRIV                 1     35
     D  SCH                    1     35
     D                                     DIM(35)
      *
      **  Data structure for BIC Plus return data
     D  @BICP          DS
     D  @INST                  1    105
     D  @BNCH                106    175
     D  @ADDR                176    315
     D  @CITY                316    350
     D  @ZIP                 351    365
     D  @CNTY                366    435
     D  @BIC                 436    446
     D  @NATI                447    457
     D  @CHIP                458    463
     D  @POBN                464    498
     D  @POBZ                499    513
     D  @POBL                514    583
     D  @CTRY                584    585
      *
      **  Data structure to retrieve Rundate
     D RUNDAT          DS            13
     D  SRUNA                  1      7
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      /EJECT
      *****************************************************************
      *  MAIN PROCESSING
      *****************************************************************
      *
      * Initialise program
     C                   MOVEA     CPY@          BIS@             80
     C                   EXSR      INIT
      *
     C     @IMODE        IFEQ      'S'
      * Provide additional function for the stand-alone enquiry
     C                   SETON                                        42
     C     @ICRIT        IFEQ      *BLANKS
     C                   EXSR      SMODE
     C                   ELSE
     C                   MOVE      @ICRIT        @2CRIV
     C                   ENDIF
     C                   ENDIF
      *
      * If Prompt or Batch Modes
     C     @IMODE        IFEQ      'P'
     C     @IMODE        OREQ      'B'
      * Provide the in-line prompt enquiry function
     C     @ICRIT        IFEQ      *BLANKS
     C                   EXSR      SMODE
     C                   ELSE
     C                   MOVE      @ICRIT        @2CRIV
     C                   ENDIF
     C     @RTCD         IFEQ      *BLANKS
     C                   EXSR      PMODE
     C                   ENDIF
     C                   ENDIF
      *
     C     @IMODE        IFEQ      'S'
     C     @IMODE        OREQ      'F'
     C     @IMODE        IFEQ      'F'
     C     @ICRIT        IFEQ      *BLANKS
     C                   EXSR      SMODE
     C                   ELSE
     C                   MOVE      @ICRIT        @2CRIV
     C                   EXSR      VALID
     C     WOK           IFNE      'Y'
     C                   EXSR      SMODE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * Provide the search enquiry function for the in-line search
      * and the stand-alone enquiry
     C     @RTCD         IFEQ      *BLANKS
     C                   EXSR      SFMODE
     C                   ENDIF
     C                   ENDIF
      *
      * Terminate program
     C                   EXSR      EXIT
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  SMODE    : Display and read Selection Screen                 *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     SMODE         BEGSR
      *
     C                   MOVE      'N'           WOK               1
     C                   SETOFF                                         1823
      *
     C     *INKC         DOWEQ     *OFF
     C     *INKL         ANDEQ     *OFF
     C     WOK           ANDEQ     'N'
      *
      * If not Batch mode then process screen function
     C     @IMODE        IfNe      'B'
      *
      * Display screen
     C                   TIME                    ##TIME
     C                   WRITE     FTP716F2
     C                   WRITE     #MSGCTL
     C                   WRITE     FTFOOTER
      *
      * Process while HELP pressed
     C                   READ      FTP716F2                               01
      *
      ** Clear messages from program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         FTPGMQ           10
     C                   PARM      '*SAME'       FTPGRL            5
     C                   Endif
      *
     C                   SELECT
      *
      * Exit
     C     *INKC         WHENEQ    *ON                                          F03
     C                   MOVEL     'F3'          @RTCD
      *
      * Previous
     C     *INKL         WHENEQ    *ON                                          F12
     C                   MOVEL     'F12'         @RTCD
      *
      * Switch (Location / Branch)
     C     *INKS         WHENEQ    *ON                                          F18
     C     *IN40         IFEQ      *OFF
     C                   MOVE      *ON           *IN40
     C                   ELSE
     C                   MOVE      *OFF          *IN40
     C                   ENDIF
      *
      * Valid
     C                   OTHER
     C                   EXSR      VALID
     C                   ENDSL
      *
     C                   ENDDO
      *
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALID    : Validate search criteria                          *
      *                                                               *
      *  CALLED BY: SMODE                                             *
      *             PMODE                                             *
      *             SFMODE                                            *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     VALID         BEGSR
      *
      * At least one search field must be entered
     C     SCRSEL        IFEQ      *BLANKS
     C     @2CRIV        ANDEQ     *BLANKS
     C                   MOVEL     'FTM2427'     ZAMSID
     C                   ENDIF
      *
      * Avoid conflict between the selection field
     C     SCRSEL        IFNE      *BLANKS
     C     @2CRIV        ANDNE     *BLANKS
     C                   MOVEL     'FTM2416'     ZAMSID
     C                   ENDIF
      *
      * Do not allow apostrophes and double quotes
     C     APOS(1)       SCAN      SCRSEL                                 50
     C     APOS(1)       SCAN      @2CRIV                                 51
     C     *IN50         IFEQ      *ON
     C     *IN51         OREQ      *ON
     C                   MOVEL     'FTM2420'     ZAMSID
     C                   ENDIF
     C     '"'           SCAN      SCRSEL                                 50
     C     *IN50         IFEQ      *ON
     C                   MOVEL     'FTM2423'     ZAMSID
     C                   ENDIF
      *
      * When not Batch mode then process screen function
     C                   Select
     C     @IMODE        WhenNe    'B'
      *
      * If error send message to program message queue
     C     ZAMSID        IFNE      *BLANKS
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      'Y'           WOK
     C                   SETON                                        23
     C                   WRITE     FTP716F1
     C                   SETOFF                                       23
     C                   Z-ADD     1             @SFR
     C                   ENDIF
      *
      * When Batch mode do not process screen function
     C                   Other
      *
      * If error then clear BIC Plus data & terminate program
     C     ZAMSID        IFNE      *BLANKS
     C                   Eval      @BICP = *Blanks
     C                   EXSR      EXIT
     C                   ELSE
     C                   MOVE      'Y'           WOK
     C                   ENDIF
     C                   Endsl
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  PMODE    : In-line prompt mode                               *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     PMODE         BEGSR
      *
      ** Construct the open query file
     C                   EXSR      VALID
     C     WOK           IFNE      'Y'
     C                   EXSR      SMODE
     C                   ENDIF
     C     @RTCD         IFEQ      *BLANKS
     C                   EXSR      BLDQRY
      *                                                                                       MK0504
      *  Override file MEBICPL0 to share(*NO)                                                 MK0504
      *                                                                                       MK0504
     C                   MOVEA     CMD@(1)       EDT                                          MK0504
     C                   MOVEL     'MEBICPL0'    U#FILE           10                          MK0504
     C                   MOVEA     U#FILE        EDT(17)                                      MK0504
     C                   MOVEA     EDT           OVRDBF           80                          MK0504
     C                   Z-ADD     80            CMDLEN           15 5                        MK0504
     C                   CALL      'QCMDEXC'                              90    90            MK0504
     C                   PARM                    OVRDBF                                       MK0504
     C                   PARM                    CMDLEN                                       MK0504
      *                                                                                       MK0504
     C     *IN90         IFEQ      '1'                                                        MK0504
     C                   Z-ADD     002           @DBASE                        ***************MK0504
     C                   MOVEL     'SDBANKPD'    @DBFIL                        *DB ERROR 002 *MK0504
     C                   MOVEL     '*FIRST'      @DBKEY                        ***************MK0504
     C                   OUT       LDA                                                        MK0504
     C                   EXSR      DBERR                                                      MK0504
     C                   END                                                                  MK0504
      *
      ** Execute the query
     C                   CALL      'QCMDEXC'
     C                   PARM                    COMMD
     C                   PARM                    PRMLEN           15 5
      *
      * Open BIC database plus file
     C                   OPEN      MEBICPL0
     C                   SETON                                            72
     C                   READ      MEBICPL0                               70
      *
     C     *IN70         IFEQ      *ON
      *
      * When not Batch mode then process screen function
     C                   Select
     C     @IMODE        WhenNe    'B'
      *
      * If no record found, provide the search enquiry function
     C                   EXSR      SFMODE
      *
      * When Batch mode then clear BIC Plus data & terminate program
     C                   Other
     C                   Eval      @BICP = *Blanks
     C                   EXSR      EXIT
     C                   Endsl
      *
     C                   ELSE
     C                   READ      MEBICPL0                               70
     C     *IN70         IFEQ      *OFF
      *
      * When not Batch mode then process screen function
     C                   Select
     C     @IMODE        WhenNe    'B'
      *
      * If more than one record, provide the search enquiry function
     C                   EXSR      SFMODE
      *
      * When Batch mode then clear BIC Plus data & terminate program
     C                   Other
     C                   Eval      @BICP = *Blanks
     C                   EXSR      EXIT
     C                   Endsl
      *
     C                   ELSE
      * Retrieve ZIP and clearing code information
     C     BICNTY        CHAIN     MEZIPPL0                           71
      *
     C     *IN71         IFNE      *OFF
      * Set 'place ZIP last indicator' and clearing prefix to defaults
     C                   MOVE      *BLANK        ZIZLST
     C                   MOVEL     '//'          ZICPFX
     C                   ENDIF
      *
     C     ZICPFX        IFEQ      *BLANKS
      * Set clearing prefix to defaults
     C                   MOVEL     '//'          ZICPFX
     C                   ENDIF
      *
     C     BICHIP        IFNE      *BLANKS
     C                   MOVE      BICHIP        @OCHIP
     C                   ENDIF
      *
     C     BIBIC         IFNE      *BLANKS
     C     BINATI        IFNE      *BLANKS
     C     ZICPFX        IFEQ      '//  '
     C     '//'          CAT       BINATI        WPXNAT           19
     C                   ELSE
     C     ZICPFX        CAT       BINATI        WPXNAT
     C                   ENDIF
     C                   MOVEL     WPXNAT        OADD1
      * Remove 'XXX' from position 9 to 11 of the BIC
     C     3             SUBST     BIBIC:9       WXXX              3
     C     WXXX          IFEQ      'XXX'
     C                   MOVE      '   '         BIBIC
     C                   ENDIF
     C                   MOVEL     BIBIC         OADD2
     C                   MOVE      'AC'          @OUTCD
     C                   ELSE
      * Remove 'XXX' from position 9 to 11 of the BIC
     C     3             SUBST     BIBIC:9       WXXX
     C     WXXX          IFEQ      'XXX'
     C                   MOVE      '   '         BIBIC
     C                   ENDIF
     C                   MOVEL     BIBIC         OADD1
     C                   MOVEL     'A'           @OUTCD
     C                   ENDIF
     C                   ELSE
      * If 'BIC' is blank, call the 'address reformatting routine'
     C                   CALL      'FT0910'
     C                   PARM                    BIINST                         I:Institution
     C                   PARM                    BIADDR                         I:Address
     C                   PARM                    BILOCN                         I:Location
     C                   PARM                    BIZIP                          I:ZIP
     C                   PARM                    ZIZLST                         I:Place ZIP last Ind
     C                   PARM                    WKADD                          O:4 address lines
     C                   PARM      *BLANKS       @RTCD             7            O:Return Code
      *
      * When not Batch mode then process screen function
     C                   Select
     C     @IMODE        WhenNe    'B'
      *
      * If data lost, call the  'manual repair routine'
     C     @RTCD         IFNE      *BLANKS                                      B004
      *
     C                   MOVE      WKADD         WK1ADD          140
     C                   MOVE      @RTCD         @WRN              7
      *
     C                   CALL      'FT0930'
     C                   PARM                    WK1ADD
     C                   PARM                    BIINST
     C                   PARM                    BIADDR
     C                   PARM                    BILOCN
     C                   PARM                    BIZIP
     C                   PARM                    @WRN
     C                   PARM      *BLANKS       WKADD
     C                   PARM      *BLANKS       @RTCD
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C     BINATI        IFNE      *BLANKS
     C     ZICPFX        IFEQ      '//  '
     C     '//'          CAT       BINATI        WPXNAT
     C                   ELSE
     C     ZICPFX        CAT       BINATI        WPXNAT
     C                   ENDIF
     C                   MOVEL     WPXNAT        OADD1
     C                   MOVE      WADD1         OADD2
     C                   MOVE      WADD2         OADD3
     C                   MOVE      WADD3         OADD4
     C                   MOVE      WADD4         OADD5
     C                   MOVE      'DC'          @OUTCD
     C                   ELSE
      * If National Id is Blank
     C                   MOVEL     WKADD         @OADD
     C                   MOVEL     'D'           @OUTCD
     C                   ENDIF
     C                   ENDIF
      *
      * When Batch mode do not process screen function
     C                   Other
      *
      * If data lost then clear BIC Plus data & terminate program
     C     @RTCD         IFNE      *BLANKS
     C                   Eval      @BICP = *Blanks
     C                   EXSR      EXIT
     C                   ENDIF
     C                   Endsl
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up BIC Plus return data from subfile record if search enquiry function
      ** accessed else directly from MEBICPPD record
     C                   If        @0INST <> *Blanks
     C                   Eval      @INST = @0INST
     C                   Eval      @BNCH = @0HBRC
     C                   Eval      @ADDR = @0HADD
     C                   Eval      @CITY = @0HCIT
     C                   Eval      @ZIP = @0HZIP
     C                   Eval      @CNTY = @0HCNT
     C                   Eval      @BIC  = @0BIC
     C                   Eval      @NATI = @0NATI
     C                   Eval      @CHIP = @0CHIP
     C                   Eval      @POBN = @0HPNB
     C                   Eval      @POBZ = @0HPZP
     C                   Eval      @POBL = @0HPLC
     C                   Else
     C                   Eval      @INST = BIINST
     C                   Eval      @BNCH = BIBNCH
     C                   Eval      @ADDR = BIADDR
     C                   Eval      @CITY = BICITY
     C                   Eval      @ZIP = BIZIP
     C                   Eval      @CNTY = BICNTY
     C                   Eval      @BIC  = BIBIC
     C                   Eval      @NATI = BINATI
     C                   Eval      @CHIP = BICHIP
     C                   Eval      @POBN = BIPOBN
     C                   Eval      @POBZ = BIPOBZ
     C                   Eval      @POBL = BIPOBL
     C                   Endif
      *
      * Retrieve 2-character country code
     C     @CNTY         Chain     @BICCPD
     C                   If        %Found
     C                   Eval      @CTRY = BCCNTC
     C                   Else
     C                   Eval      @CTRY = *Blanks
     C                   Endif
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SFMODE   : In-line search enquiry mode                       *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *             PMODE                                             *
      *                                                               *
      *  CALLS    : VALID                                             *
      *             BLDQRY                                            *
      *             BLDSFL                                            *
      *                                                               *
      *****************************************************************
     C     SFMODE        BEGSR
      *
      ** If in 'Stand-alone enquiry mode ' or  'in line search mode'
     C     @IMODE        IFNE      'P'                                          ---B00
     C     @IMODE        ANDNE     'B'
      *
      * Construct the open query file
     C                   EXSR      VALID
      *
     C                   EXSR      BLDQRY
      ** Execute the query
     C                   CALL      'QCMDEXC'
     C                   PARM                    COMMD
     C                   PARM                    PRMLEN           15 5
      *
      * Open BIC database plus file
     C                   SETON                                            72
     C                   OPEN      MEBICPL0
     C                   READ      MEBICPL0                               70
      *
     C                   ELSE                                                   ---X00
     C                   READP     MEBICPL0                               70
     C                   ENDIF                                                  ---E00
      ** Clear messages from program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         FTPGMQ           10
     C                   PARM      '*SAME'       FTPGRL            5
      *
     C                   MOVE      'N'           WOK
     C     *INKC         DOWEQ     *OFF                                         ---B00
     C     *INKL         ANDEQ     *OFF
     C     WOK           ANDEQ     'N'
     C     *IN70         IFEQ      *ON                                          ---B01
     C                   SETOFF                                       41
      * If no record found, write a message on the screen and wait for
      * a new selection
     C                   TIME                    ##TIME
     C                   WRITE     FTP716F2                                      Top Screen
     C                   WRITE     FTFOOTER
     C                   WRITE     #MSGCTL                                       messages
     C                   WRITE     FTNORECD                                      'No Record'
      *
     C                   READ      FTP716F2                               01     Top Screen
      *
      ** Clear messages from program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         FTPGMQ           10
     C                   PARM      '*SAME'       FTPGRL            5
      *
     C     *INKS         IFEQ      *ON                                          F18 --B02
     C     *IN40         IFEQ      *OFF                                             --B03
     C                   MOVE      *ON           *IN40
     C                   MOVE      CBRCA         @LOCBR
     C                   ELSE                                                   ---X03
     C                   MOVE      *OFF          *IN40
     C                   MOVE      CLOCA         @LOCBR
     C                   ENDIF                                                  ---E03
     C                   ELSE                                                   ---X02
      *
     C     *INKC         IFEQ      *OFF                                         ---B03
     C     *INKL         ANDEQ     *OFF
     C                   EXSR      VALID
     C     WOK           IFEQ      'Y'                                          ---B04
      * Close query and file
     C                   CALL      'QCMDEXC'
     C                   PARM                    QRY(6)
     C                   PARM      20            PRMLEN           15 5
     C                   CLOSE     MEBICPL0
     C                   EXSR      BLDQRY
     C                   CALL      'QCMDEXC'
     C                   PARM                    COMMD
     C                   PARM                    PRMLEN           15 5
      ** Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         FTPGMQ           10
     C                   PARM      '*SAME'       FTPGRL            5
      *
     C                   OPEN      MEBICPL0
     C                   SETON                                            72
     C                   READ      MEBICPL0                               70
      *
     C                   MOVE      'N'           WOK
     C                   ENDIF                                                  ---E04
     C                   ENDIF                                                  ---E03
     C                   ENDIF                                                  ---E02
      *
     C                   ELSE                                                   ---X01
      * Record found
     C                   SETON                                        41
      *
      * Build Subfil1
     C                   EXSR      BLDSFL
      *
     C                   MOVE      'N'           WOK1              1
     C     *INKC         DOWEQ     *OFF                                         ---B02
     C     *INKL         ANDEQ     *OFF
     C     WOK1          ANDEQ     'N'
     C     WOK           ANDEQ     'N'
     C                   TIME                    ##TIME
     C                   WRITE     FTP716F2                                      Top Screen
     C                   WRITE     FTP716F1                                      Subfile
     C                   WRITE     FTFOOTER                                       Cmd key
     C                   WRITE     #MSGCTL                                       messages
      *
     C                   READ      FTP716F1                               01     subfile
     C                   READ      FTP716F2                               01     Top Screen
      * Save Cursor Position
     C     @SFPOS        IFGT      *ZERO
     C                   Z-ADD     @SFPOS        @SFREC
     C                   ENDIF
      *
      ** Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         FTPGMQ           10
     C                   PARM      '*SAME'       FTPGRL            5
      *
     C                   SELECT                                                 ---B03
     C     *INKC         WHENEQ    *ON                                          F3
     C                   MOVEL     'F12'         @RTCD
     C     *INKL         WHENEQ    *ON                                          F12
     C                   MOVEL     'F3'          @RTCD
     C     *INKS         WHENEQ    *ON                                          F18
     C     *IN40         IFEQ      *OFF
     C                   MOVE      *ON           *IN40
     C                   MOVE      CBRCA         @LOCBR
     C                   ELSE
     C                   MOVE      *OFF          *IN40
     C                   MOVE      CLOCA         @LOCBR
     C                   ENDIF
     C                   EXSR      SWITCH
     C     *IN29         WHENEQ    *ON                                          Page Down
     C                   EXSR      BLDSFL
      *
      * Check subfile changes
     C                   OTHER                                                  ---X03
     C     @0SEL         DOUNE     *BLANKS
     C     *IN02         OREQ      *ON
     C                   READC     FTP716F0                               02     Subfile
     C                   ENDDO
     C     *IN02         IFEQ      *OFF                                         ---B04
     C                   MOVE      *BLANKS       ZICPFX
      * - ENQUIRY
     C     @0SEL         IFEQ      'E'                                          ---B05
     C                   EXSR      DETAIL
     C                   MOVE      *OFF          *INKL
     C                   ENDIF                                                  ---E05
      *
      * In Stand alone enquiry mode, only option 'E' is allowed
     C     *IN42         IFEQ      *ON
     C     @0SEL         ANDNE     *BLANKS
     C     @0SEL         ANDNE     'E'
     C                   MOVEL     'FTM2419'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      * - DEFAULT
     C     @0SEL         IFEQ      'X'                                          ---B05
     C     @0BIC         IFEQ      *BLANKS                                      ---B06
     C                   MOVEL     'D'           @0SEL
     C                   ELSE
     C                   MOVEL     'A'           @0SEL
     C                   ENDIF                                                  ---E06
     C                   ENDIF                                                  ---E05
      *
     C                   SELECT                                                 ---B05
      * - BIC
     C     @0SEL         WHENEQ    'A'
     C     @0BIC         IFEQ      *BLANKS                                      ---B06
     C                   MOVEL     'FTM2417'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      @0BIC         WXXX
     C     WXXX          IFEQ      'XXX'
     C                   MOVE      '   '         @0BIC
     C                   ENDIF
     C                   MOVEL     @0BIC         OADD1
     C                   MOVEL     @0CHIP        @OCHIP
     C                   MOVEL     'A'           @OUTCD
     C                   MOVE      'Y'           WOK
      * Return the clearing code if possible
     C     @0NATI        IFNE      *BLANKS                                      ---B07
      * Retrieve ZIP and clearing code information
     C     @0HCNT        CHAIN     MEZIPPL0                           71
     C     *IN71         IFEQ      *ON
     C                   MOVEL     '//'          ZICPFX
     C                   ENDIF
     C     ZICPFX        IFEQ      *BLANKS
      * Set clearing prefix to defaults
     C                   MOVEL     '//'          ZICPFX
     C                   ENDIF
      *
     C     ZICPFX        IFEQ      '//  '
     C     '//'          CAT       @0NATI        WPXNAT
     C                   ELSE
     C     ZICPFX        CAT       @0NATI        WPXNAT
     C                   ENDIF
     C                   MOVEL     WPXNAT        OADD1
     C                   MOVEL     @0BIC         OADD2
     C                   MOVEL     'AC'          @OUTCD
     C                   ENDIF                                                  ---E07
     C                   ENDIF                                                  ---E06
      * - BRANCH
     C     @0SEL         WHENEQ    'B'
     C     @0HBRC        IFNE      *BLANKS                                      ---B06
     C                   MOVEL     @0HBRC        OADD1
      * Check if loss of data
     C     35            SUBST     @0HBRC:36     WK35             35
     C     WK35          IFNE      *BLANKS                                      ---B07
      * Call 'Manual repair of reformatted branch'
     C                   CALL      'FT0920'
     C                   PARM      OADD1         PICBH            35
     C                   PARM      @0HINS        PIINS           105
     C                   PARM      @0HBRC        PIBCH            70
     C                   PARM      @0HCIT        PICIT            35
     C                   PARM      @0HLOC        PILOC            90
     C                   PARM                    POBCH            35
     C                   PARM                    @RTCD
     C     @RTCD         IFNE      *BLANKS                                      ---B08
     C     @RTCD         IFEQ      'F3'                                         ---B09
     C                   MOVE      *ON           *INKC
     C                   ELSE
     C                   MOVE      '*BLANKS'     @RTCD
     C                   ENDIF                                                  ---E09
     C                   ELSE                                                   ---X08
     C                   MOVEL     POBCH         OADD1
     C                   MOVE      'Y'           WOK
     C                   MOVEL     @0CHIP        @OCHIP
     C                   MOVEL     'B'           @OUTCD
     C                   ENDIF                                                  ---E08
      * no lost of data
     C                   ELSE                                                   ---X07
     C                   MOVE      'Y'           WOK
     C                   MOVEL     @0CHIP        @OCHIP
     C                   MOVEL     'B'           @OUTCD
     C                   ENDIF                                                  ---E07
      * if branch field is blank , use city
     C                   ELSE                                                   ---X06
     C                   MOVEL     @0HCIT        OADD1
     C                   MOVE      'Y'           WOK
     C                   MOVEL     @0CHIP        @OCHIP
     C                   MOVEL     'B'           @OUTCD
     C                   ENDIF                                                  ---E06
      * Return the clearing code if possible
     C     @0NATI        IFNE      *BLANKS                                      ---B06
     C     WOK           ANDEQ     'Y'
      * Retrieve ZIP and clearing code information
     C     @0HCNT        CHAIN     MEZIPPL0                           71
     C     *IN71         IFEQ      *ON
     C                   MOVEL     '//'          ZICPFX
     C                   ENDIF
     C     ZICPFX        IFEQ      *BLANKS
      * Set clearing prefix to defaults
     C                   MOVEL     '//'          ZICPFX
     C                   ENDIF
      *
     C     ZICPFX        IFEQ      '//  '
     C     '//'          CAT       @0NATI        WPXNAT
     C                   ELSE
     C     ZICPFX        CAT       @0NATI        WPXNAT
     C                   ENDIF
     C                   MOVE      OADD1         OADD2
     C                   MOVE      *BLANKS       OADD1
     C                   MOVEL     WPXNAT        OADD1
     C                   MOVEL     'BC'          @OUTCD
     C                   ENDIF                                                  ---E06
      * - CLEARING CODE
     C     @0SEL         WHENEQ    'C'
     C     @0NATI        IFEQ      *BLANKS                                      ---B06
     C                   MOVEL     'FTM2418'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   ---X06
      * Retrieve ZIP and clearing code information
     C     @0HCNT        CHAIN     MEZIPPL0                           71
     C     *IN71         IFEQ      *ON
     C                   MOVEL     '//'          ZICPFX
     C                   ENDIF
     C     ZICPFX        IFEQ      *BLANKS
      * Set clearing prefix to defaults
     C                   MOVEL     '//'          ZICPFX
     C                   ENDIF
      *
     C     ZICPFX        IFEQ      '//  '
     C     '//'          CAT       @0NATI        WPXNAT
     C                   ELSE
     C     ZICPFX        CAT       @0NATI        WPXNAT
     C                   ENDIF
     C                   MOVEL     WPXNAT        OADD1
     C                   MOVE      'Y'           WOK
     C                   MOVEL     @0CHIP        @OCHIP
     C                   MOVE      'C '          @OUTCD
     C                   ENDIF                                                  ---E06
      * - ADDRESS
     C     @0SEL         WHENEQ    'D'
      * Retrieve ZIP and clearing code information
     C     @0HCNT        CHAIN     MEZIPPL0                           71
     C     *IN71         IFEQ      *ON
     C                   MOVE      *BLANK        ZIZLST
     C                   MOVEL     '//'          ZICPFX
     C                   ENDIF
     C     ZICPFX        IFEQ      *BLANKS
      * Set clearing prefix to defaults
     C                   MOVEL     '//'          ZICPFX
     C                   ENDIF
      *
      *  call the 'address reformatting routine'
     C                   CALL      'FT0910'
     C                   PARM      @0HINS        PIINST          105            I:Institution
     C                   PARM      @0HADD        PIADDR          140            I:Address
     C                   PARM      @0HLOC        PILOCN           90            I:Location
     C                   PARM      @0HZIP        PIZIP            15            I:ZIP
     C                   PARM      ZIZLST        PIZLST            1            I:Place ZIP last Ind
     C                   PARM                    WKADD                          O:4 address lines
     C                   PARM      *BLANKS       PRTCD             7            O:Return Code
      * If data lost, call the  'manual repair routine'
     C     PRTCD         IFNE      *BLANKS                                      ---B06
      *
     C                   MOVE      WKADD         WK1ADD          140
     C                   MOVE      PRTCD         @WRN              7
      *
     C                   CALL      'FT0930'
     C                   PARM                    WK1ADD
     C                   PARM      @0HINS        PIINST
     C                   PARM      @0HADD        PIADDR
     C                   PARM      @0HLOC        PILOCN
     C                   PARM      @0HZIP        PIZIP
     C                   PARM                    @WRN
     C                   PARM      *BLANKS       WKADD
     C                   PARM      *BLANKS       PRTCD
     C     PRTCD         IFEQ      'F3'                                         ---B07
     C                   MOVEL     'F3'          @RTCD
     C                   MOVE      *ON           *INKC
     C                   ENDIF                                                  ---E07
     C                   ENDIF                                                  ---E06
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     WKADD         @OADD
     C                   MOVE      'Y'           WOK
     C                   MOVEL     @0CHIP        @OCHIP
     C                   MOVEL     'D'           @OUTCD
      * Return the clearing code if possible
     C     @0NATI        IFNE      *BLANKS                                      ---B06
     C     ZICPFX        IFEQ      '//  '
     C     '//'          CAT       @0NATI        WPXNAT
     C                   ELSE
     C     ZICPFX        CAT       @0NATI        WPXNAT
     C                   ENDIF
     C                   MOVE      WKADD         @OADD
     C                   MOVE      *BLANKS       OADD1
     C                   MOVEL     WPXNAT        OADD1
     C                   MOVEL     'DC'          @OUTCD
     C                   ENDIF                                                  ---E06
     C                   ENDIF
      *
     C                   ENDSL                                                  ---E05
     C                   ENDIF
      *
      * Process the other entries (only for enquiry)
     C     *IN02         DOWEQ     *OFF
     C                   MOVE      ' '           @0SEL
     C                   UPDATE    FTP716F0                                      Subfile
     C                   READC     FTP716F0                               02     Subfile
     C                   MOVE      *OFF          *INKL
     C     @0SEL         IFEQ      'E'                                          ---B05
     C                   EXSR      DETAIL
     C                   ENDIF                                                  ---E05
     C                   ENDDO
      *
      * If no change in the subfile, request a new enquiry
     C                   ELSE                                                   ---X04
     C                   EXSR      VALID
     C     WOK           IFEQ      'Y'                                          ---B05
     C                   CLOSE     MEBICPL0
     C                   CALL      'QCMDEXC'
     C                   PARM                    QRY(6)
     C                   PARM      20            PRMLEN           15 5
      *
     C                   EXSR      BLDQRY
      ** Execute the query
     C                   CALL      'QCMDEXC'
     C                   PARM                    COMMD
     C                   PARM                    PRMLEN           15 5
      ** Clear messages  (close & open query file)
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         FTPGMQ           10
     C                   PARM      '*SAME'       FTPGRL            5
      *
     C                   OPEN      MEBICPL0
     C                   SETON                                            72
     C                   READ      MEBICPL0                               70
      *
     C                   MOVE      'Y'           WOK1
     C                   MOVE      'N'           WOK
     C                   ENDIF                                                  ---E05
     C                   ENDIF                                                  ---E04
     C                   ENDSL                                                  ---E03
     C                   ENDDO                                                  ---E02
     C                   ENDIF                                                  ---E01
     C                   ENDDO                                                  ---E00
      *
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SWITCH   : Switch between Location and branch                *
      *                                                               *
      *  CALLED BY: SFMODE                                            *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     SWITCH        BEGSR
      *
     C                   Z-ADD     1             @SFK
     C     @SFK          DOWLT     @SFR
     C     @SFK          CHAIN     FTP716F0                           73
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     @0HLOC        @0LOCB
     C                   ELSE
     C                   MOVEL     @0HBRC        @0LOCB
     C                   ENDIF
     C                   UPDATE    FTP716F0
     C                   ADD       1             @SFK
     C                   ENDDO
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  BLDQRY   : Construct Open Query File Command for BIC+ query  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *             PMODE                                             *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     BLDQRY        BEGSR
      *
     C                   MOVE      *BLANKS       QSLT
     C                   MOVE      *BLANKS       COMMD
      * I)   USING SEARCH CRITERIA
     C     @2CRIV        IFNE      *BLANKS
     C                   MOVE      *BLANKS       WSG
     C                   MOVE      *BLANKS       WRD
     C                   Z-ADD     0             WLN
      *   A) Identify the first 5 words in the array SCH wich contains
      *      the search criteria
     C                   Z-ADD     1             P1                2 0          Word Beg
     C                   Z-ADD     1             P2                2 0          Word End
     C                   Z-ADD     1             P3                1 0          Word Number
      *                                                    up to 5
     C     P1            DOWLE     35
     C     P3            ANDLE     5
     C                   SELECT
      *
     C     SCH(P1)       WHENEQ    '+'
     C                   ADD       1             P1
     C     SCH(P1)       WHENEQ    '-'
     C                   MOVE      '-'           WSG(P3)
     C                   ADD       1             P1
      *
     C     SCH(P1)       WHENEQ    '"'
     C     P1            ANDNE     35
     C                   ADD       1             P1
     C     '"'           SCAN      @2CRIV:P1     P2
      * Avoid array error, if second '"' not found
     C     P2            IFEQ      0
     C     ' '           CHECKR    @2CRIV        P2
     C     P2            IFGT      P1
     C     P2            SUB       P1            WLN(P3)
     C                   ELSE
     C                   Z-ADD     1             WLN(P3)
     C                   ENDIF
     C                   ELSE
     C                   SUB       1             P2
     C     2             ADD       P2            PSAVE             2 0
     C                   ADD       1             P2
     C     P2            SUB       P1            LEN               2 0
     C     LEN           SUBST     @2CRIV:P1     WRD(P3)
     C                   Z-ADD     LEN           WLN(P3)
     C                   ADD       1             P3
     C                   Z-ADD     PSAVE         P1
     C                   ENDIF
     C*
     C     SCH(P1)       WHENNE    *BLANK
     C     ' '           SCAN      @2CRIV:P1     P2
     C     P2            IFEQ      0
     C                   Z-ADD     36            P2
     C                   ENDIF
     C     P2            SUB       P1            LEN
     C     LEN           SUBST     @2CRIV:P1     WRD(P3)
     C                   Z-ADD     LEN           WLN(P3)
     C                   ADD       1             P3
     C                   Z-ADD     P2            P1
     C*
     C                   OTHER
     C                   ADD       1             P1
     C                   ENDSL
     C                   ENDDO
     C*
     C*
      *   B) Build the query
      *      First identified search word
     C                   Z-ADD     1             P1
     C                   Z-ADD     1             P2
     C                   Z-ADD     1             P                 3 0
     C     WLN(1)        IFNE      *ZERO
     C                   MOVEL     WRD(1)        WCHAR             1
     C     WSG(1)        IFEQ      '-'
     C                   MOVE      '¬'           QSLT(P)
     C                   ADD       1             P
     C                   ENDIF
     C     P2            DOWLE     12
     C     1             SUBST     CINDX:P2      QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P2
     C                   ENDDO
     C                   MOVE      '"'           QSLT(P)
     C                   ADD       1             P
     C     P1            DOWLE     WLN(1)
     C     1             SUBST     WRD(1):P1     QSLT(P)
      * Remove unwanted '"'
     C     QSLT(P)       IFEQ      '"'
     C                   MOVE      ' '           QSLT(P)
     C                   ENDIF
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   MOVE      '"'           QSLT(P)
     C                   ADD       1             P
     C                   MOVE      ')'           QSLT(P)
     C                   ADD       2             P
      *
      *     Next identified search words
     C                   Z-ADD     2             P3
     C     P3            DOWLE     5
     C     WLN(P3)       ANDNE     *ZERO
     C                   Z-ADD     1             P1
     C                   Z-ADD     1             P2
     C                   MOVEL     WRD(P3)       WCHAR             1
     C     WSG(P3)       IFEQ      '-'
     C     P2            DOWLE     6
     C     1             SUBST     CANDN:P2      QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P2
     C                   ENDDO
     C                   ELSE
     C     P2            DOWLE     5
     C     1             SUBST     CAND:P2       QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P2
     C                   ENDDO
     C                   ENDIF
     C                   Z-ADD     1             P2
     C     P2            DOWLE     12
     C     1             SUBST     CINDX:P2      QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P2
     C                   ENDDO
     C                   MOVE      '"'           QSLT(P)
     C                   ADD       1             P
     C     P1            DOWLE     WLN(P3)
     C     1             SUBST     WRD(P3):P1    QSLT(P)
      * Remove unwanted '"'
     C     QSLT(P)       IFEQ      '"'
     C                   MOVE      ' '           QSLT(P)
     C                   ENDIF
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   MOVE      '"'           QSLT(P)
     C                   ADD       1             P
     C                   MOVE      ')'           QSLT(P)
     C                   ADD       2             P
     C*
     C                   ADD       1             P3
     C                   ENDDO
     C                   ENDIF
      *  Create the query command
     C                   MOVEL     QRY(1)        COM1
     C                   MOVEL     QRY(3)        COM2
     C                   MOVEL     QSLT2         COM3A
     C     P             ADD       123           P4                3 0
     C                   Z-ADD     1             P1
     C     P1            DOWLE     38
     C     1             SUBST     QRY(4):P1     CMD(P4)
     C                   ADD       1             P1
     C                   ADD       1             P4
     C                   ENDDO
     C                   Z-ADD     P4            PRMLEN
      **
      * II)  USING FIELD SELECTION
     C                   ELSE
     C                   Z-ADD     1             P1
     C                   Z-ADD     1             P2
     C                   Z-ADD     1             P                 3 0
     C                   MOVE      'N'           WAND              1
      * Institution
     C     @2INSV        IFNE      *BLANKS
     C     P1            DOWLE     12
     C     1             SUBST     CINST:P1      QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   MOVE      '"'           QSLT(P)
     C                   ADD       1             P
     C     ' '           CHECKR    @2INSV        P2
     C                   Z-ADD     1             P1
     C     P1            DOWLE     P2
     C     1             SUBST     @2INSV:P1     QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   MOVE      '"'           QSLT(P)
     C                   ADD       1             P
     C                   MOVE      ')'           QSLT(P)
     C                   ADD       2             P
     C                   MOVE      'Y'           WAND
     C                   ENDIF
      *
      * Branch or Location  ( If *IN40 =*ON , this is branch)
     C     @2LBRV        IFNE      *BLANKS
     C                   Z-ADD     1             P1
     C                   Z-ADD     1             P2
     C     WAND          IFEQ      'Y'
     C     P1            DOWLE     5
     C     1             SUBST     CAND:P1       QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   ADD       1             P
     C                   ENDIF
     C     *IN40         IFEQ      *ON
     C                   MOVE      CBNCH         WFIELD           12
     C                   ELSE
     C                   MOVE      CLOCN         WFIELD
     C                   ENDIF
     C                   Z-ADD     1             P1
     C     P1            DOWLE     12
     C     1             SUBST     WFIELD:P1     QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   MOVE      '"'           QSLT(P)
     C                   ADD       1             P
     C     ' '           CHECKR    @2LBRV        P2
     C                   Z-ADD     1             P1
     C     P1            DOWLE     P2
     C     1             SUBST     @2LBRV:P1     QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   MOVE      '"'           QSLT(P)
     C                   ADD       1             P
     C                   MOVE      ')'           QSLT(P)
     C                   ADD       2             P
     C                   MOVE      'Y'           WAND
     C                   ENDIF
      *
      * BIC
     C     @2BICV        IFNE      *BLANKS
     C                   Z-ADD     1             P1
     C                   Z-ADD     1             P2
     C     WAND          IFEQ      'Y'
     C     P1            DOWLE     5
     C     1             SUBST     CAND:P1       QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   ADD       1             P
     C                   ENDIF
     C                   Z-ADD     1             P1
     C     P1            DOWLE     12
     C     1             SUBST     CBIC:P1       QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   MOVE      '"'           QSLT(P)
     C                   ADD       1             P
     C     ' '           CHECKR    @2BICV        P2
     C                   Z-ADD     1             P1
     C     P1            DOWLE     P2
     C     1             SUBST     @2BICV:P1     QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   MOVE      '"'           QSLT(P)
     C                   ADD       1             P
     C                   MOVE      ')'           QSLT(P)
     C                   ADD       2             P
     C                   MOVE      'Y'           WAND
     C                   ENDIF
      *
      * National Id
     C     @2NATV        IFNE      *BLANKS
     C                   Z-ADD     1             P1
     C                   Z-ADD     1             P2
     C     WAND          IFEQ      'Y'
     C     P1            DOWLE     5
     C     1             SUBST     CAND:P1       QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   ADD       1             P
     C                   ENDIF
     C                   Z-ADD     1             P1
     C     P1            DOWLE     12
     C     1             SUBST     CNATI:P1      QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   MOVE      '"'           QSLT(P)
     C                   ADD       1             P
     C     ' '           CHECKR    @2NATV        P2
     C                   Z-ADD     1             P1
     C     P1            DOWLE     P2
     C     1             SUBST     @2NATV:P1     QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   MOVE      '"'           QSLT(P)
     C                   ADD       1             P
     C                   MOVE      ')'           QSLT(P)
     C                   ADD       2             P
     C                   MOVE      'Y'           WAND
     C                   ENDIF
      *
      * CHIPS
     C     @2CHPV        IFNE      *BLANKS
     C                   Z-ADD     1             P1
     C                   Z-ADD     1             P2
     C     WAND          IFEQ      'Y'
     C     P1            DOWLE     5
     C     1             SUBST     CAND:P1       QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   ADD       1             P
     C                   ENDIF
     C                   Z-ADD     1             P1
     C     P1            DOWLE     12
     C     1             SUBST     CCHIP:P1      QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   MOVE      '"'           QSLT(P)
     C                   ADD       1             P
     C     ' '           CHECKR    @2CHPV        P2
     C                   Z-ADD     1             P1
     C     P1            DOWLE     P2
     C     1             SUBST     @2CHPV:P1     QSLT(P)
     C                   ADD       1             P
     C                   ADD       1             P1
     C                   ENDDO
     C                   MOVE      '"'           QSLT(P)
     C                   ADD       1             P
     C                   MOVE      ')'           QSLT(P)
     C                   ADD       2             P
     C                   ENDIF
      *  Create the query command
     C                   MOVEL     QRY(2)        COM1
     C                   MOVEL     QSLT2         COM3B
     C     P             ADD       81            P4                3 0
     C                   Z-ADD     1             P1
     C     P1            DOWLE     20
     C     1             SUBST     QRY(5):P1     CMD(P4)
     C                   ADD       1             P1
     C                   ADD       1             P4
     C                   ENDDO
     C                   Z-ADD     P4            PRMLEN
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  DETAIL   : Display Detail of a record from BIC+              *
      *                                                               *
      *  CALLED BY: SFMODE                                            *
      *                                                               *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     DETAIL        BEGSR
      *
      * Write the details to the display file
      *  Institution
     C     70            SUBST     @0HINS:1      @3INS1
     C     35            SUBST     @0HINS:71     @3INS2
      *  Branch
     C                   MOVE      @0HBRC        @3BRCA
      *  Address
     C     35            SUBST     @0HADD:1      @3ADD1
     C     35            SUBST     @0HADD:36     @3ADD2
     C     35            SUBST     @0HADD:71     @3ADD3
     C     35            SUBST     @0HADD:106    @3ADD4
      * City
     C                   MOVEL     @0HCIT        @3CITY
      * ZIP Code
     C                   MOVEL     @0HZIP        @3ZIP1
      * Country
     C                   MOVE      @0HCNT        @3CNTY
      * BIC
     C                   MOVEL     @0BIC         @3BIC
      * National bank code
     C                   MOVEL     @0NATI        @3NATI
      * CHIPS code
     C                   MOVEL     @0CHIP        @3CHIP
      * PO Box information
     C                   MOVEL     @0HPNB        @3POBN
     C                   MOVEL     @0HPZP        @3PZIP
     C                   MOVEL     @0HPLC        @3PLOC
      *
     C     *INKC         DOWEQ     *OFF
     C     *INKL         ANDEQ     *OFF
     C                   TIME                    ##TIME
     C                   WRITE     FTFOOTER                                       Cmd key
     C                   WRITE     #MSGCTL                                       messages
     C                   WRITE     FTP716F3                                      Subfile
     C                   READ      FTP716F3                               01     Top Screen
     C                   ENDDO
      *
     C     *INKC         IFEQ      *ON
     C                   MOVEL     'F3'          @RTCD
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  BLDSFL   : Construct a subfile page                          *
      *                                                               *
      *  CALLED BY: SFMODE                                            *
      *                                                               *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     BLDSFL        BEGSR
      *
      *
     C                   SETOFF                                       26
     C                   SETON                                            25
     C                   SETON                                            23
     C                   SETOFF                                           30
      *
     C                   Z-ADD     @SFR          @SFK              7 0
     C                   Z-ADD     @SFK          @SFREC
      *
      *
      * Write a page of records
     C     *IN70         IFEQ      '0'
     C                   SETON                                        24
     C                   Z-ADD     1             Z                 2 0
     C*
     C** Do while less than 18 and not end of file
     C*
     C     Z             DOWLT     6
     C     *IN70         ANDEQ     '0'
     C*
      * Continue if Z is less than 18
     C     Z             IFLT      6                                            B002
      * Selection field
     C                   MOVE      *BLANK        @0SEL
      * Information fields
     C     *IN40         IFEQ      *OFF
     C                   MOVEL     BILOCN        @0LOCB
     C                   ELSE
     C                   MOVEL     BIBNCH        @0LOCB
     C                   ENDIF
     C                   MOVEL     BIINST        @0INST
     C                   MOVEL     BINATI        @0NATI
     C                   MOVEL     BIBIC         @0BIC
     C                   MOVEL     BICHIP        @0CHIP
      * Hidden fields
     C                   MOVEL     BIBNCH        @0HBRC
     C                   MOVEL     BILOCN        @0HLOC
     C                   MOVEL     BIINST        @0HINS
     C                   MOVEL     BICITY        @0HCIT
     C                   MOVEL     BICNTY        @0HCNT
     C                   MOVEL     BIADDR        @0HADD
     C                   MOVEL     BIZIP         @0HZIP
     C                   MOVEL     BIPOBN        @0HPNB
     C                   MOVEL     BIPOBZ        @0HPZP
     C                   MOVEL     BIPOBL        @0HPLC
     C*
     C** Write record to subfile and read next record
     C*
     C                   WRITE     FTP716F0
     C                   ADD       1             @SFK
     C                   READ      MEBICPL0                               70
     C                   ADD       1             Z
     C                   END
     C                   END                                                    E001
     C*
     C     *IN70         IFEQ      '0'
     C                   SETOFF                                       25
     C                   END
     C                   END                                                    E001
     C                   Z-ADD     @SFK          @SFR              7 0
     C                   SETOFF                                       23
     C                   SETON                                        30
      *
      *
     C                   ENDSR
      /EJECT
      *******************************************************************
      *  DBERR  - Error handling                                        *
      *******************************************************************
     C     DBERR         BEGSR
      *
      * Close MEBICPPD
     C     *IN72         IFEQ      *ON
     C                   CLOSE     MEBICPL0
     C                   CALL      'QCMDEXC'
     C                   PARM                    QRY(6)
     C                   PARM      20            PRMLEN           15 5
     C                   ENDIF
      *
     C                   DUMP
     C                   MOVEL     @DBALL        @DBSAV
     C     *LOCK         IN        LDA
     C                   MOVEL     @DBSAV        @DBALL
     C                   MOVEL     'FTP0716'     @DBPGM
     C                   OUT       LDA
      *
      *  Allocate dataarea to blanks
      *
     C                   EXSR      DALLOC
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR                                                  DBERR  ends
      *
      *****************************************************************
      * SUBROUTINE TO DEALLOCATE DATAAREA
      *****************************************************************
      *
     C     DALLOC        BEGSR                                                  *** DALLOC
      *
      * Call CL program to de-allocate
      *
     C                   MOVE      *BLANKS       @RTCDE            7
     C                   MOVE      'FT'          @MODLE            2
     C                   MOVE      *BLANKS       @TREF            15
     C                   MOVE      *BLANKS       @RTINF           80
     C                   CALL      'AOC8000'
     C                   PARM                    @RTCDE
     C                   PARM                    @MODLE
     C                   PARM                    @TREF
     C                   PARM                    @RTINF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS   : Send message to program's message queue           *
      *                                                               *
      *  CALLED BY:                                                   *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   ZASNMS        BEGSR
      *
     C                   CALL      'ZA0340'
     C                   PARM      'FTUSRMSG'    ZAMSGF           10
     C                   PARM                    ZAMSID           10
      *
     C                   CLEAR                   ZAMSID
     CSR                 ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  EXIT     : Exit the program                                  *
      *                                                               *
      *  CALLED BY: Main                                              *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   EXIT          BEGSR
      *
      *F12 ?
     C     *INKL         IFEQ      *ON
     C                   MOVEL     'F12'         @RTCD
     C                   ENDIF
      *
      *F3  ?
     C     *INKC         IFEQ      *ON
     C                   MOVEL     'F3 '         @RTCD
     C                   ENDIF
      *
      *Map BIC Plus data ?
     C     @IMODE        IFEQ      'B'
     C     @BICP         ANDEQ     *BLANKS
     C                   MOVEL     '*FALSE'      @RTCD
     C                   ENDIF
      *
      * Close the file and the query
     C     *IN72         IFEQ      *ON
     C                   CLOSE     MEBICPL0
     C                   CALL      'QCMDEXC'
     C                   PARM                    QRY(6)
     C                   PARM      20            PRMLEN           15 5
     C                   ENDIF
      *
     C                   SETON                                        LR
      *
     C                   RETURN
      *
     C                   ENDSR
      *******************************************************************
      *  INIT  Program initialisation                                   *
      *******************************************************************
     CSR   INIT          BEGSR
      *
      ** Access Standing Data Bank Details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG  '      @RTCD
     C                   PARM      '*FIRST'      @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Data base error in file SDBANKPD.
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     001           @DBASE                         ***************
     C                   MOVEL     'SDBANKPD'    @DBFIL                         *DB ERROR 001 *
     C                   MOVEL     '*FIRST'      @DBKEY                         ***************
     C                   OUT       LDA
     C                   ENDIF
      *
      * Obtain default message file
     C                   MOVEL     'FTUSRMSG'    ZADFMF           10
      ** retrieve messages
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'FTM2421'     #MSGID            7
     C                   PARM      'FTUSRMSG'    #MSGF            10
     C                   PARM                    #MSDTA          132
     C                   PARM      *BLANKS       #MSTX1          132
     C                   PARM      *BLANKS       #MSTX2          132
     C                   MOVEL     #MSTX1        CLOCA             8
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'FTM2422'     #MSGID            7
     C                   PARM      'FTUSRMSG'    #MSGF            10
     C                   PARM                    #MSDTA          132
     C                   PARM      *BLANKS       #MSTX1          132
     C                   PARM      *BLANKS       #MSTX2          132
     C                   MOVEL     #MSTX1        CBRCA             8
      *
      **  Access data area RUNDAT for Run Date
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C                   SETOFF                                       05
      *
      *  PLIST's, KLIST's, DEFN's etc....                             *
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LIKE         DEFINE    @DBALL        @DBSAV
      *
     C                   MOVE      QRY(1)        AA               80
     C*
     C** Entry Parameters
     C*
     C     *ENTRY        PLIST
     C                   PARM                    @IMODE            1
     C                   PARM                    @ICRIT           35
     C                   PARM                    @OADD           175
     C                   PARM                    @OCHIP            6
     C                   PARM                    @OUTCD            2
     C                   PARM                    @BICP
     C                   PARM                    @RTCD             7
      * The field (@OUTCD) is used to indicate what is returned
      * 'A'= BIC      'B'= Branch     'C'= Clearing Code
      * 'D'= Address
      * The possible values are : 'A','AC','B','BC','C','D','DC'
      *
      * Initialise fields
     C                   MOVE      CLOCA         @LOCBR
     C                   Z-ADD     1             @SFR
     C                   MOVE      SRUNA         ##MRDT            7            Midas Run date
      *
     C     @IMODE        Ifne      'B'
     C                   Open      FTP0716Df
     C                   Endif
      *
     CSR                 ENDSR                                                  INIT  ends
      *******************************************************************
      *
      /EJECT
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
**CTDATA APOS
'
**CTDATA QRY
OPNQRYF FILE((MEBICPL0 *FIRST @BICPPD) (MEBICIPD *FIRST @BICIPD)) OPTION(*INP)
OPNQRYF FILE((MEBICPL0 *FIRST @BICPPD)) OPTION(*INP) OPNID(MEBICPPD) QRYSLT('
OPNID(MEBICPPD) FORMAT(MEBICPL0) QRYSLT('
') JFLD((BIKEY BSKEY)) SEQONLY(*YES 1)
') SEQONLY(*YES 1)
CLOF OPNID(MEBICPPD)
**CTDATA CMD@                                                                                 MK0504
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO)                                                        MK0504
