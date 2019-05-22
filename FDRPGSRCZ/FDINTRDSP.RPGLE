     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD MM Interest Rates Details Display Module')
      *****************************************************************
      *                                                               *
      *  Midas - FD ILE Module                                        *
      *                                                               *
      *  FDINTRDSP - Interest Rates Details Display                   *
      *                                                               *
      *  Function:  This module displays Interest Rates Details       *
      *             Maintenance screen                                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 213558             Date 09Jun03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 13Jul00               *
      *                 CAP058  *CREATE    Date 13Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  213558 - Change data feed req id and timestamp to output only*
      *           (recompile)                                         *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP058 - Money Market Interest Rates API                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFDINTRDDF CF   E             WORKSTN SFILE(FDINTRS0:@@RRN)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *      FUNCTION OF INDICATORS                                   *
      *                                                               *
      *       20  Error on Action Code                                *
      *       21  Error on Currency                                   *
      *       22  Warning on Data Request Id                          *
      *       23  Error on Timestamp                                  *
      *       25  Error on Borrowing Rate                             *
      *       26  Error on Lending Rate                               *
      *       69  Enable Key fields (Action code and Currency)        *
      *       70  Display only                                        *
      *       71  Enable Function Key - F10                           *
      *       72  Enable Function Key - F7 and F8                     *
      *       73  Position cursor on first field                      *
      *       74  Enable Function Key - F15                           *
      *       75  When off, positions cursor to first subfile detail  *
      *           field in error                                      *
      *     80-89 Reference and Part./Non-Part. fields display        *
      *       90  CSD006 Market Data Feeds                            *
      *       96  Subfile End                                         *
      *       97  Subfile Clear                                       *
      *       98  Rollup                                              *
      *       99  Read error                                          *
      *       LR  End of Program                                      *
      *                                                               *
      *       KC  Function Key - F3  (Program Exit)                   *
      *       KG  Function Key - F7  (Display Previous Record)        *
      *       KH  Function Key - F8  (Display Next Record)            *
      *       KJ  Function Key - F10 (Delete Record)                  *
      *       KL  Function Key - F12 (Cancel)                         *
      *       KP  Function Key - F15 (Browse Records)                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      SUBROUTINE DESCRIPTIONS                                  *
      *                                                               *
      *      *INZSR        - Program Initialisation                   *
      *      SrMAIN        - Main Processing                          *
      *      SrUPDERRS     - Update Error Indicators                  *
      *      SrRATERRS     - Update Error Indicators for Rates        *
      *      SrBLDSFL      - Build Sub-File for Interest Rate Details *
      *      SrSAVARR      - Saves Interest Details in an array       *
      *      SrMOVDET      - Move Interest Details to Subfile fields  *
      *      SrSETFLD      - Move Subfile Fields to Screen Data Struc *
      *                      ture                                     *
      *      SrGETDTA      - Get Data from Subfile                    *
      *      *PSSR         - Standard Error Subroutine                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      PROCEDURES AND PROGRAMS CALLED                           *
      *                                                               *
      *      AOBANKR0      - Access Object for Bank Details           *
      *      AOSARDR0      - Access Object for switchable features    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **---------------------------------------------------------------
 
 
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
 
     D @EI             S              1    DIM(70)
     D @BORROW         S             12    DIM(21)
     D @LEND           S             12    DIM(21)
     D @EXTRA          S             12    DIM(21)
     D @Z10            S              1    DIM(10) CTDATA PERRCD(10)
     D @PERD           S             15    DIM(21) CTDATA PERRCD(4)
 
      ** Table for Error field sequence number and corresponding
      ** relative record number from subfile
     D TabErrNum       S              2  0 DIM(42) PERRCD(7)
     D                                     CTDATA
     D TabSRecNum      S              2  0 DIM(42) ALT(TabErrNum)
 
      ** Interest Rates Details in screen format
     D NwIRScnFmt    E DS                  EXTNAME(FDINTRPD)
 
      ** Error indicators
     D OKIRScnFld    E DS                  EXTNAME(FDEINTRPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for switchable features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Timestamp
     D TimeStampDS     DS
     D  DDCENT                 1      2
     D  DDDFT1                 3      8
     D  DDDFT2                 9     14
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input Parameter (Enable F7, F8, F10, F15 in Command Narrative and Key Fields)
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKP          S              1A
     D PEKYFD          S              1A
 
      ** Output Parameter (Function Keys - 3,7,8,10,12 and 15)
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
 
      ** General purpose index
     D @X              S              3  0
     D @Y              S              3  0
     D @Z              S              3  0
 
      ** Exit loop indicator
     D WEXIT           S              1A
 
      ** Borrow, Lending and Extra data details
     D WRATEDET        S            588
     D WBORROW         S             12
     D WLEND           S             12
     D WEXTRA          S              4
 
      ** Current subfile record number
     D WCRECNUM        S              2  0
 
      ** Previous subfile record number
     D WPRECNUM        S              2  0
 
      ** Previous borrow error indicator
     D WPRV25          S              1
 
      ** Previous lending error indicator
     D WPRV26          S              1
 
      ** First Page/Second Page subfile
     D WFRSTP          C                   CONST(1)
     D WSCNDP          C                   CONST(12)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the             ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Main processing
 
     C                   EXSR      SrMAIN
 
      ** F3, Terminate program
 
     C                   IF        *INKC = TRUE
     C                   EVAL      *INLR = TRUE
     C                   ENDIF
 
      ** Return to calling program
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMAIN - Main Processing                                      *
      *                                                               *
      *****************************************************************
     C     SrMAIN        BEGSR
 
      ** Set up the transaction reference to be used by the message handler
 
     C                   EVAL      TranRef = DDCCY
     C                   EVAL      ActionCode = DDACTN
 
      **---------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **---------------------------------------------------------------
 
      ** Set cursor to action code field
 
     C     DDACTN        IFEQ      *BLANK
     C                   EVAL      *IN73 = TRUE
     C                   ENDIF
 
      ** Enable Action Code and Currency Code
 
     C     PEKYFD        IFEQ      'Y'
     C                   EVAL      *IN69 = TRUE
     C                   ELSE
     C                   EVAL      *IN69 = FALSE
     C                   ENDIF
 
      ** WriteOnly is set to 'Y', protect detail fields
 
     C     WriteOnly     IFEQ      'Y'
     C                   EVAL      *IN70 = TRUE
     C                   ELSE
     C                   EVAL      *IN70 = FALSE
     C                   ENDIF
 
      ** Enable Function Key - F10 Delete
 
     C     PEINKJ        IFEQ      'Y'
     C                   EVAL      *IN71 = TRUE
     C                   ELSE
     C                   EVAL      *IN71 = FALSE
     C                   ENDIF
 
      ** Enable Function Key - F7 or F8 for prev/next record
 
     C     PEINKG        IFEQ      'Y'
     C     PEINKH        OREQ      'Y'
     C                   EVAL      *IN72 = TRUE
     C                   ELSE
     C                   EVAL      *IN72 = FALSE
     C                   ENDIF
 
      ** Enable Function Key - F15 for Browse
 
     C     PEINKP        IFEQ      'Y'
     C                   EVAL      *IN74 = TRUE
     C                   ELSE
     C                   EVAL      *IN74 = FALSE
     C                   ENDIF
 
      ** Save interest rates details from screen format to array.
 
     C                   EXSR      SrSAVARR
 
      ** Build Subfile
 
     C                   EXSR      SrBLDSFL
 
     C                   ENDSR
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUPDERRS - Update Error Indicators                           *
      *                                                               *
      *****************************************************************
     C     SrUPDERRS     BEGSR
 
      ** Move 'OK' flags into array (for checking)
 
     C                   MOVEA     OkIRScnFld    @EI
 
      ** Reset error indicators
 
     C                   MOVEA     @Z10          *IN(20)
 
     C                   EVAL      WCRECNUM = *ZERO
 
      ** Set screen error indicators according to status of 'OK' flags
 
     C                   Z-ADD     1             C                 2 0
 
     C     C             DOWLE     70
     C     @EI(C)        ANDNE     *BLANK
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
 
      ** Action Code
 
     C     C             IFEQ      1
     C                   EVAL      *IN20 = TRUE
     C                   ENDIF
 
      ** Currency Code
 
     C     C             IFEQ      2
     C                   EVAL      *IN21 = TRUE
     C                   ENDIF
 
      ** Borrow and Lending Rate
 
     C                   IF        (C > 2) OR (C < 66)
 
 
      ** Save Previous Subfile Record Number
 
     C                   Eval      WPRECNUM = WCRECNUM
     C     C             LOOKUP    TabErrNum     TabSRecNum               80
     C                   EXSR      SrRATERRS
     C                   ENDIF
 
      ** Data Request Id
 
     C     C             IFEQ      66
     C                   EVAL      *IN22 = TRUE
     C                   ENDIF
 
      ** Time Stamp
 
     C     C             IFEQ      67
     C                   EVAL      *IN23 = TRUE
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      C = C + 1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRATERRS - Update Error Indicators for Rates                 *
      *                                                               *
      *****************************************************************
     C     SrRATERRS     BEGSR
 
     C     *IN80         IFEQ      TRUE
     C                   EVAL      WCRECNUM = TabSRecNum
 
      ** Setup subfile page against the first subfile record with error
 
     C     WPRECNUM      IFEQ      *ZERO
     C     TabSRecNum    IFLT      12
     C                   Z-ADD     WFRSTP        WSFLPAG
     C                   ELSE
     C                   Z-ADD     WSCNDP        WSFLPAG
     C                   ENDIF
     C                   ENDIF
     C
     C     TabSRecNum    CHAIN     FDINTRS0                           99
     C     *IN99         IFEQ      FALSE
 
     C                   EVAL      WREM = *ZERO
     C     C             DIV       3             WINT              2 0
     C                   MVR                     WREM              1 0
 
      ** When WREM is equal to zero, error on Borrowing Rate, otherwise
      ** error on Lending Rate
 
     C     WREM          IFEQ      *ZERO
     C                   EVAL      *IN25 = TRUE
     C                   EVAL      WPRV25 = *IN25
 
      ** If current subfile record number is equal to previous,
      ** both borrow and lending rates contain errors, set the
      ** lending error indicator to previous to highlight both
      ** fields in error
 
     C     TabSRecNum    IFEQ      WPRECNUM
     C                   EVAL      *IN26 = WPRV26
     C                   EVAL      WPRV26 = *BLANK
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN26 = TRUE
     C                   EVAL      WPRV26 = *IN26
 
      ** If current subfile record number is equal to previous,
      ** both borrow and lending rates contain errors, set the
      ** borrow error indicator to previous value to highlight
      ** both fields in error
 
     C     TabSRecNum    IFEQ      WPRECNUM
     C                   EVAL      *IN25 = WPRV25
     C                   EVAL      WPRV25 = *BLANK
     C                   ENDIF
     C                   ENDIF
 
      ** Update subfile record
     C
     C                   UPDATE    FDINTRS0
 
      ** Reset subfile field error indicators
 
     C                   EVAL      *IN25 = FALSE
     C                   EVAL      *IN26 = FALSE
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBLDSFL  - Build Sub-File for Interest Rate Details          *
      *                                                               *
      *****************************************************************
     C     SrBLDSFL      BEGSR
 
      ** Initialise subfile relative record number.
 
     C                   Z-ADD     0             @@RRN             5 0
     C                   Z-ADD     0             @@CNT             2 0
 
      ** Initialise subfile page
 
     C                   Z-ADD     WFRSTP        WSFLPAG           2 0
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
 
     C                   MOVE      '1'           *IN97
     C                   WRITE     FDINTRC0
     C                   MOVE      '0'           *IN97
 
      ** Write header and footer to the screen
 
     C                   WRITE     FDINTRH0
     C                   WRITE     FDINTRF0
     C                   WRITE     FDINTRC1
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   MOVE      '1'           *IN98
 
      ** Write records into the subfile until all pages have
      ** been filled.
 
     C     *IN98         DOWEQ     TRUE
 
      ** Write to subfile until the subfile ends
 
     C     @@CNT         DOWLT     21
 
      ** Increment the subfile record no. and record counter
 
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
 
      ** Move details from the interest details screen format to subfile.
 
     C                   EXSR      SrMOVDET
 
      ** Write the interest rate details to the subfile.
 
     C                   Z-ADD     @@RRN         DDRLRN
     C                   WRITE     FDINTRS0
 
      ** Enable subfile end
 
     C     @@RRN         IFEQ      21
     C                   EVAL      *IN96 = TRUE
     C                   ELSE
     C                   EVAL      *IN96 = FALSE
     C                   ENDIF
 
     C                   ENDDO
 
      ** If there is any error, update error indicator
 
     C                   EXSR      SrUPDERRS
 
      ** Set subfile relative record number to subfile page workfield
 
     C                   Z-ADD     WSFLPAG       DDRLRN
 
      ** Write the subfile control record to the screen to display
      ** the subfile.
 
     C                   WRITE     FDINTRC0
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
 
     C                   READ      FDINTRC0                               99
 
     C                   SELECT
 
      ** If F3, bypass further processing.
 
     C     *INKC         WHENEQ    TRUE
     C                   EVAL      PINKC = TRUE
 
      ** If F12, bypass further processing.
 
     C     *INKL         WHENEQ    TRUE
     C                   EVAL      PINKL = TRUE
 
      ** If F8, Next record
 
     C     *INKH         WHENEQ    TRUE
     C                   EVAL      PINKH = TRUE
 
      ** If F7, Prev record
 
     C     *INKG         WHENEQ    TRUE
     C                   EVAL      PINKG = TRUE
 
      ** If F15, Select record
 
     C     *INKP         WHENEQ    TRUE
     C                   EVAL      PINKP = TRUE
 
      ** If F10, Delete Record
 
     C     *INKJ         WHENEQ    TRUE
     C     PEINKJ        ANDEQ     'Y'
     C                   EVAL      PINKJ = TRUE
 
      ** Otherwise Rollup or Enter
 
     C                   OTHER
 
     C     *IN98         IFEQ      TRUE
 
      ** Set subfile to next page
 
     C                   Z-ADD     WSCNDP        WSFLPAG
     C                   ELSE
 
      ** Set move subfile fields to screen data structure, then return
 
     C                   EXSR      SrSETFLD
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDDO
 
      ** Move timestamp from screen field to screen field data structure
 
     C                   MOVEL     TimeStampDS   DDDFTS
 
      ** Reset screen indicators
 
     C                   MOVEA     @Z10          *IN(70)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSAVARR  - Saves Interest Details in an array                *
      *                                                               *
      *****************************************************************
     C     SrSAVARR      BEGSR
 
      ** Reset counter
 
     C                   EVAL      @X = *ZERO
     C                   EVAL      @Y = *ZERO
     C                   EVAL      @Z = *ZERO
 
      ** Get Borrow rates and Lending rates details
 
     C                   EVAL      WRATEDET = (%SUBST(NwIRScnFmt:37:588))
 
      ** From detail screen format and extra data data structure, save to array
 
     C     @X            DOWLT     21
     C                   EVAL      @X = @X + 1
     C                   EVAL      @Y = @Z + 1
     C                   EVAL      @Z = @Z + 12
     C                   EVAL      @BORROW(@X) = (%SUBST(WRATEDET:@Y:12))
     C                   EVAL      @Y = @Z + 1
     C                   EVAL      @Z = @Z + 12
     C                   EVAL      @LEND(@X) = (%SUBST(WRATEDET:@Y:12))
     C                   EVAL      @Y = @Z + 1
     C                   EVAL      @Z = @Z + 4
     C                   EVAL      @EXTRA(@X) = (%SUBST(WRATEDET:@Y:4))
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMOVDET  - Move Interest Details to Subfile fields           *
      *                                                               *
      *****************************************************************
     C     SrMOVDET      BEGSR
 
     C                   EVAL      @X = @@RRN
 
     C                   EVAL      DDPDSC = @PERD(@X)
     C                   EVAL      DDBRWR = @BORROW(@X)
     C                   EVAL      DDLNDR = @LEND(@X)
     C                   EVAL      DDEXTD = @EXTRA(@X)
     C                   MOVE      DDDFTS        TimeStampDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSETFLD  - Move Subfile Fields to Screen Data Structure      *
      *                                                               *
      *****************************************************************
     C     SrSETFLD      BEGSR
 
     C     1             DO        21            @X
     C     @X            CHAIN     FDINTRS0                           99
     C                   EVAL      WBORROW = DDBRWR
     C                   EVAL      WLEND = DDLNDR
     C                   EVAL      WEXTRA = DDEXTD
     C                   EXSR      SrGETDTA
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGETDTA  - Get Data from Subfile                             *
      *                                                               *
      *****************************************************************
     C     SrGETDTA      BEGSR
 
     C                   SELECT
 
     C     @X            WHENEQ    1
     C                   EVAL      DDBR01 = WBORROW
     C                   EVAL      DDLR01 = WLEND
     C                   EVAL      DDEX01 = WEXTRA
 
     C     @X            WHENEQ    2
     C                   EVAL      DDBR02 = WBORROW
     C                   EVAL      DDLR02 = WLEND
     C                   EVAL      DDEX02 = WEXTRA
 
     C     @X            WHENEQ    3
     C                   EVAL      DDBR03 = WBORROW
     C                   EVAL      DDLR03 = WLEND
     C                   EVAL      DDEX03 = WEXTRA
 
     C     @X            WHENEQ    4
     C                   EVAL      DDBR04 = WBORROW
     C                   EVAL      DDLR04 = WLEND
     C                   EVAL      DDEX04 = WEXTRA
 
     C     @X            WHENEQ    5
     C                   EVAL      DDBR05 = WBORROW
     C                   EVAL      DDLR05 = WLEND
     C                   EVAL      DDEX05 = WEXTRA
 
     C     @X            WHENEQ    6
     C                   EVAL      DDBR06 = WBORROW
     C                   EVAL      DDLR06 = WLEND
     C                   EVAL      DDEX06 = WEXTRA
 
     C     @X            WHENEQ    7
     C                   EVAL      DDBR07 = WBORROW
     C                   EVAL      DDLR07 = WLEND
     C                   EVAL      DDEX07 = WEXTRA
 
     C     @X            WHENEQ    8
     C                   EVAL      DDBR08 = WBORROW
     C                   EVAL      DDLR08 = WLEND
     C                   EVAL      DDEX08 = WEXTRA
 
     C     @X            WHENEQ    9
     C                   EVAL      DDBR09 = WBORROW
     C                   EVAL      DDLR09 = WLEND
     C                   EVAL      DDEX09 = WEXTRA
 
     C     @X            WHENEQ    10
     C                   EVAL      DDBR10 = WBORROW
     C                   EVAL      DDLR10 = WLEND
     C                   EVAL      DDEX10 = WEXTRA
 
     C     @X            WHENEQ    11
     C                   EVAL      DDBR11 = WBORROW
     C                   EVAL      DDLR11 = WLEND
     C                   EVAL      DDEX11 = WEXTRA
 
     C     @X            WHENEQ    12
     C                   EVAL      DDBR12 = WBORROW
     C                   EVAL      DDLR12 = WLEND
     C                   EVAL      DDEX12 = WEXTRA
 
     C     @X            WHENEQ    13
     C                   EVAL      DDBR13 = WBORROW
     C                   EVAL      DDLR13 = WLEND
     C                   EVAL      DDEX13 = WEXTRA
 
     C     @X            WHENEQ    14
     C                   EVAL      DDBR14 = WBORROW
     C                   EVAL      DDLR14 = WLEND
     C                   EVAL      DDEX14 = WEXTRA
 
     C     @X            WHENEQ    15
     C                   EVAL      DDBR15 = WBORROW
     C                   EVAL      DDLR15 = WLEND
     C                   EVAL      DDEX15 = WEXTRA
 
     C     @X            WHENEQ    16
     C                   EVAL      DDBR16 = WBORROW
     C                   EVAL      DDLR16 = WLEND
     C                   EVAL      DDEX16 = WEXTRA
 
     C     @X            WHENEQ    17
     C                   EVAL      DDBR17 = WBORROW
     C                   EVAL      DDLR17 = WLEND
     C                   EVAL      DDEX17 = WEXTRA
 
     C     @X            WHENEQ    18
     C                   EVAL      DDBR18 = WBORROW
     C                   EVAL      DDLR18 = WLEND
     C                   EVAL      DDEX18 = WEXTRA
 
     C     @X            WHENEQ    19
     C                   EVAL      DDBR19 = WBORROW
     C                   EVAL      DDLR19 = WLEND
     C                   EVAL      DDEX19 = WEXTRA
 
     C     @X            WHENEQ    20
     C                   EVAL      DDBR20 = WBORROW
     C                   EVAL      DDLR20 = WLEND
     C                   EVAL      DDEX20 = WEXTRA
 
     C     @X            WHENEQ    21
     C                   EVAL      DDBR21 = WBORROW
     C                   EVAL      DDLR21 = WLEND
     C                   EVAL      DDEX21 = WEXTRA
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    NwIRScnFmt
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    OkIRScnFld
     C                   PARM                    PEKYFD
     C                   PARM                    Writeonly
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
     C                   PARM                    PINKC
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
 
      ** Initialise program name
 
     C                   MOVEL     'FDINTRDSP'   DBPGM
 
      ** Move user and workstation ID to screen fields.
 
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWSID
 
     C                   MOVEL     '*'           DDPGMQ
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access switchable features file - Market data feed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD006'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Set screen conditioning indicator
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      *IN90 = '0'
     C                   ELSE
     C                   EVAL      *IN90 = '1'
     C                   ENDIF
 
      **---------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **---------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** @Z10
0000000000
** @PERD - array for period descriptions
Overnight      Tomorrow/Next  Spot/Next      1 Week
2 Weeks        3 Weeks        1 Month        2 Months
3 Months       6 Months       9 Months        1 Year
 2 Years        3 Years        4 Years        5 Years
 6 Years        7 Years        8 Years        9 Years
10 Years
** TabErrNum/TabSRecNum - Table for Error Field Sequence/Subfile Record Number
0301040106020702090310031204
1304150516051806190621072207
2408250827092809301031103311
3411361237123913401342144314
4515461548164916511752175418
5518571958196020612063216421
