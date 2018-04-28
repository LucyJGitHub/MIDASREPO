     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Hierarchy Selection Prmpt')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100460 - Cash Management Hierarchy Selection Prompt        *
      *                                                               *
      *  Function: This module allows selection of hierarchies to be  *
      *            made based on a link id or account present         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BG8539             Date 15Sep05               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG6979            Date 03May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 214360             Date 03Feb03               *
      *                 213195             Date 10Jan03               *
      *                 212840             Date 10Jan03               *
      *                 211210             Date 11Dec02               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BG8539 - Screen not dispaly properly in WebFacing            *
      *           Change the write/read order so that the last        *
      *           written format is not the footer before the READ    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  214360 - Cash Management Deferred Posting                    *
      *  213195 - Wrong hierarchy description on purge & sweep screens*
      *  212840 - Missing info on link id                             *
      *  211210 - Various action code errors                          *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRE100460DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:RRN)
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMABF)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACCNTABF)
     FRECMHLL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHLD0:RECMHLLK)
     FRECMHLL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHLD0:RECMHLAC)
     FRECMHDL0  IF   E           K DISK    INFSR(*PSSR)
     FREZSHDL0  IF   E           K DISK    INFSR(*PSSR)
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D NumPerPag       C                   CONST(99)
      ** Array of Fields in error.
     D RIE             S              9S 0 DIM(NumPerPag)
 
 
      * Hierarchies Array
     D ARR_HIERS       S              9S 0 DIM(999) ASCEND
      * Links Array
     D ARR_LINKS       S              9S 0 DIM(999) ASCEND
      * Branches Array
     D ARR_BRCHS       S              3A   DIM(999) ASCEND
 
 
      * Account ID
     D                 DS
     D***SCREENSELECT            1     47                                                     CGL029
     D SCREENSELECT            1     53                                                       CGL029
     D DDLINK                  1      9
     D DDACNO                 10     19
     D***DDACID*                20     37                                                     CGL029
     D DDACID                 20     43                                                       CGL029
     D DDBRCA                 20     22
     D DDCNUM                 23     28
     D DDCCY                  29     31
     D***DDACOD*                32     35                                                     CGL029
     D***DDACSQ*                36     37                                                     CGL029
     D***DDCUST*                38     47                                                     CGL029
     D DDACOD                 32     41                                                       CGL029
     D DDACSQ                 42     43                                                       CGL029
     D DDCUST                 44     53                                                       CGL029
 
      * Account ID
     D                 DS
     D***ACCID**                 1     18                                                     CGL029
     D ACCID                   1     24                                                       CGL029
     D BRC                     1      3
     D*CUS******               4      9S 0                                                    CSD027
     D CUS                     4      9A                                                      CSD027
     D CCY                    10     12
     D***ACD****                13     16S 0                                                  CGL029
     D***ASN****                17     18S 0                                                  CGL029
     D ACD                    13     22S 0                                                    CGL029
     D ASN                    23     24S 0                                                    CGL029
 
 
     D ZMUSER          DS            17                                         211210
     D  UBRC                  11     13                                         211210
                                                                                211210
                                                                                211210
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer Details
     D QQDFC1        E                     EXTFLD(QQDFAC)                                     CGL029
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** Account Code Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs
 
 
      /SPACE 5
 
      **  GET ZMUSER to access default branch.                                             BUG6979
      *                                                                                    BUG6979
     C     *DTAARA       DEFINE                  ZMUSER                                    BUG6979
     C                   IN        ZMUSER                                                  BUG6979
     C                   UNLOCK    ZMUSER                                                  BUG6979
      *                                                                                    BUG6979
      **  Determine option codes available                                                 BUG6979
      *                                                                                    BUG6979
     C                   EXSR      DET_OPTS                                                BUG6979
                                                                                           BUG6979
      * Set up standard screen fields.                                                     BUG6979
                                                                                           BUG6979
     C                   MOVEL     PsJobName     DDJOB                                     BUG6979
     C                   MOVEL     PsUser        DDUSR                                     BUG6979
      *                                                                                    BUG6979
      * Write subfile control and foooter
 
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
 
     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCT
     C**********         WRITE     PROMPT                                                     BG8539
     C                   WRITE     FOOTER1
     C                   WRITE     PROMPT                                                     BG8539
     C                   READ      PROMPT
 
      ** Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
      ** If F3 and F12 were not taken
 
     C     *INKC         IFEQ      '0'
     C     *INKL         ANDEQ     '0'
 
      * Validate Selection
 
     C                   EXSR      VAL_SELECT
     C     Valid         IFEQ      'Y'
     C                   EXSR      DET_HIERS
     C     *ZERO         LOOKUP    ARR_HIERS                          99
     C     *IN99         IFEQ      '1'
 
      * Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
      * Display screen until F3, or F12 taken
 
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   ENDDO
 
     C                   ELSE
     C                   MOVE      'N'           Valid
     C     DDLINK        COMP      *BLANK                             5151
     C     DDACNO        COMP      *BLANK                             5252
     C     DDACID        IFNE      *BLANK
     C                   MOVEA     '11111'       *IN(53)
     C                   ENDIF
     C     DDCUST        COMP      *BLANK                             5858
     C                   MOVEL     'RE75390 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
      * Pass back function keys taken
 
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
 
      * End of program
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Display screen
      *****************************************************************
     C     DSPLAY_SCN    BEGSR
 
      * 'This is a subsetted list'
 
     C                   MOVEL     'RE75905'     ZAMSID
     C                   EXSR      ZASNMS
 
      * Fill the subfile
 
     C                   EXSR      FILL_SUB
 
      * Write and read screen
 
     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCT
     C**********         WRITE     SUBFLCTL                                                   BG8539
     C                   WRITE     FOOTER2
     C                   WRITE     SUBFLCTL                                                   BG8539
 
      * Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
      * Read subfile control
 
     C                   READ      SUBFLCTL                               99    *
 
      * Check for a record selected from the subfile
 
     C                   EXSR      CHK_SUBF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Check for a record selected from the subfile
      *****************************************************************
     C     CHK_SUBF      BEGSR
 
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
 
      * Do until all records processed
 
     C     *IN99         DOWEQ     '0'
 
      * If an action code is specified
      *   Enquire on the record in the subfile
 
     C     DDACTN        IFNE      *BLANK
     C                   EXSR      ACTN_CHK
     C     ActnOK        IFEQ      'Y'
     C                   EXSR      ENQ_SflREC
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '0'           @INKC
     C                   ENDIF
 
      * Read next if F3 not requested
 
     C     @INKC         IFEQ      '0'
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
     C                   ELSE
     C                   MOVE      '1'           *IN99
     C                   MOVE      @INKC         *INKC
     C                   END
 
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Enquire on the record in the subfile
      ********************************************************************
     C     ENQ_SflREC    BEGSR
 
      * Call the cash management sweep request
 
     C     DDACTN        IFEQ      'S'
     C     CDHTYP        ANDEQ     'ZS'
     C                   EXSR      HIER_SWP_REQ
     C                   ELSE
 
      * Call the cash management purge request
 
     C     DDACTN        IFEQ      'P'
     C     CDHTYP        ANDEQ     'ZS'
     C                   EXSR      HIER_PUR_REQ
     C                   ELSE
 
      * Call the cash management block request
 
     C     DDACTN        IFEQ      'B'
     C     CDHTYP        ANDEQ     'ZS'
     C                   EXSR      HIER_BLK_REQ
     C                   ELSE
 
      * Call the Cash Management Hierarchy Details Enquiry
 
     C                   Z-ADD     *ZERO         I_S_LINK
     C                   Z-ADD     *ZERO         I_S_RAN
     C                   MOVE      *BLANK        I_S_GLAI
     C**********         Z-ADD     *ZERO         I_S_CUS                                      CSD027
     C                   EVAL      I_S_CUS =     *BLANKS                                      CSD027
 
     C                   SELECT
     C     DDLINK        WHENNE    *BLANK
     C                   MOVE      DDLINK        I_S_LINK
     C     DDACNO        WHENNE    *BLANK
     C                   MOVE      DDACNO        I_S_RAN
     C     DDACID        WHENNE    *BLANK
     C                   MOVE      DDACID        I_S_GLAI
     C     DDCUST        WHENNE    *BLANK
     C                   MOVE      DDCUST        I_S_CUS
     C                   ENDSL
 
     C                   EXSR      HIER_DTL_ENQ
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Call the cash management sweep request
      *****************************************************************
     C     HIER_SWP_REQ  BEGSR
 
     C                   CALL      'RE100461'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Request Type
     C                   PARM      'H'           I_REQTYP          1
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Type
      * Hierarchy Description
      * Link ID
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
     C                   PARM      CDHTYP        I_HTYP            2
     C                   PARM      CDDESC        I_DESC           50
     C                   PARM      *ZERO         I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      *BLANK        I_CBRC            3
     C                   PARM      *ZERO         I_CCUS            6 0
     C                   PARM      *BLANK        I_CCCY            3
     C**********         PARM      *ZERO         I_CACD            4 0                        CGL029
     C                   PARM      *ZERO         I_CACD           10 0                        CGL029
     C                   PARM      *ZERO         I_CASN            2 0
      * Retail A/c Number
      * Account Name
     C                   PARM      *BLANK        I_RAN            10
     C                   PARM      *BLANK        I_ANAM           20
 
      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      * Error
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'SWEEP REQUEST FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Call the cash management purge request
      *****************************************************************
     C     HIER_PUR_REQ  BEGSR
 
     C                   CALL      'RE100462'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Request Type
     C                   PARM      'H'           I_REQTYP          1
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Type
      * Hierarchy Description
      * Link ID
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
     C                   PARM      CDHTYP        I_HTYP            2
     C                   PARM      CDDESC        I_DESC           50
     C                   PARM      *ZERO         I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      *BLANK        I_CBRC            3
     C                   PARM      *ZERO         I_CCUS            6 0
     C                   PARM      *BLANK        I_CCCY            3
     C**********         PARM      *ZERO         I_CACD            4 0                        CGL029
     C                   PARM      *ZERO         I_CACD                                       CGL029
     C                   PARM      *ZERO         I_CASN            2 0
      * Retail A/c Number
      * Account Name
     C                   PARM      *BLANK        I_RAN            10
     C                   PARM      *BLANK        I_ANAM           20
 
      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      * Error
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'PURGE REQUEST FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Call the cash management block request
      *****************************************************************
     C     HIER_BLK_REQ  BEGSR
 
     C                   CALL      'RE100463'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Request Type
     C                   PARM      'H'           I_REQTYP          1
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Type
      * Hierarchy Description
      * Link ID
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
     C                   PARM      CDHTYP        I_HTYP            2
     C                   PARM      CDDESC        I_DESC           50
     C                   PARM      *ZERO         I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      *BLANK        I_CBRC            3
     C                   PARM      *ZERO         I_CCUS            6 0
     C                   PARM      *BLANK        I_CCCY            3
     C**********         PARM      *ZERO         I_CACD            4 0                        CGL029
     C                   PARM      *ZERO         I_CACD                                       CGL029
     C                   PARM      *ZERO         I_CASN            2 0
      * Retail A/c Number
      * Account Name
     C                   PARM      *BLANK        I_RAN            10
     C                   PARM      *BLANK        I_ANAM           20
 
      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      * Error
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'BLOCK REQUEST FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Call the Cash Management Hierarchy Details Enquiry
      *****************************************************************
     C     HIER_DTL_ENQ  BEGSR
 
     C                   CALL      'RE100451'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Hierarchy ID
     C                   PARM      CDHIER        I_HIER            9 0
      * Selected Link Id
      * Selected Retail Account Number
      * Selected GL Account Number
      * Selected Customer
     C                   PARM                    I_S_LINK          9 0
     C                   PARM                    I_S_RAN          10 0
     C**********         PARM                    I_S_GLAI         18                          CGL029
     C                   PARM                    I_S_GLAI         24                          CGL029
     C**********         PARM                    I_S_CUS           6 0                        CSD027
     C                   PARM                    I_S_CUS           6                          CSD027
      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      * Error
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ENQUIRY FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Fill the subfile
      *****************************************************************
     C     FILL_SUB      BEGSR
 
      * Clear subfile
     C                   MOVEA     '000'         *IN(11)
     C                   Z-ADD     *ZERO         RRN               4 0
     C                   WRITE     SUBFLCTL                                     *
 
      * Read all hierarchies
 
     C                   Z-ADD     1             HI
     C     ARR_HIERS(HI) CHAIN     RECMHDD0                           60        *
 
      * Do while hierarchies found
 
     C     *IN60         DOWEQ     '0'
 
      * Action code
     C                   MOVEL     *BLANK        DDACTN
 
      * Description
     C                   MOVEL     CDDESC        DDDESC
 
      * External
      * Master account
     C     CDHTYP        IFEQ      'ZS'
     C     CDHIER        CHAIN     REZSHDL0                           99
     C                   MOVE      ZDEXTL        DDEXTL
     C                   MOVE      ZDMAST        DDMAST
     C                   ELSE
     C                   MOVE      ' '           DDEXTL
     C                   MOVE      ' '           DDMAST
     C                   ENDIF
 
      * Link
     C                   MOVEL     ARR_LINKS(HI) CLLINK
 
      * In error?
 
     C     CDHIER        LOOKUP    RIE                                    65
 
      * Write a hierarchy
 
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC
 
     C                   ADD       1             HI
     C     ARR_HIERS(HI) CHAIN     RECMHDD0                           60        *
 
     C                   ENDDO
 
      * Reset subfile
 
     C                   MOVEA     '111'         *IN(11)
 
     C                   Z-ADD     *ZERO         RIE
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Action code check
      *****************************************************************
     C     ACTN_CHK      BEGSR
 
     C                   MOVEL     'Y'           ActnOK            1
 
      * Check for valid action code
 
     C     DDACTN        IFNE      'E'
     C     DDACTN        ANDNE     'S'
     C     DDACTN        ANDNE     'P'
     C     DDACTN        ANDNE     'B'
     C     DDACTN        OREQ      'S'
     C     CDHTYP        ANDNE     'ZS'
     C     DDACTN        OREQ      'P'
     C     CDHTYP        ANDNE     'ZS'
     C     DDACTN        OREQ      'B'
     C     CDHTYP        ANDNE     'ZS'
 
     C                   MOVEL     'N'           ActnOK
     C                   MOVEL     'RE75903'     ZAMSID
     C                   EXSR      ZASNMS
 
     C                   ELSE
 
      * Check for user authority to action code
 
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        @ZACTN            1
     C                   PARM      CDBRCA        @ZBR              3
     C                   PARM      *ZERO         @ERR              1 0
     C     @ERR          IFEQ      2
     C                   MOVEL     'N'           ActnOK
     C                   MOVEL     'RE75902'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
 
      * If action code not OK, log record in error
 
     C     ActnOK        IFNE      'Y'
     C                   MOVE      '0'           @INKC
     C                   Z-ADD     1             @RIE              2 0
     C     *ZERO         LOOKUP    RIE(@RIE)                              99
     C                   Z-ADD     CDHIER        RIE(@RIE)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Selection
      ********************************************************************
     C     VAL_SELECT    BEGSR
 
     C                   MOVE      'Y'           Valid             1
 
     C                   SELECT
 
      * 'Select EITHER link id, retail account number, account id or customer'
 
     C     SCREENSELECT  WHENEQ    *BLANK
     C     DDLINK        ORNE      *BLANK
     C     DDACNO        ANDNE     *BLANK
     C     DDLINK        ORNE      *BLANK
     C     DDACID        ANDNE     *BLANK
     C     DDLINK        ORNE      *BLANK
     C     DDCUST        ANDNE     *BLANK
     C     DDACNO        ORNE      *BLANK
     C     DDACID        ANDNE     *BLANK
     C     DDACNO        ORNE      *BLANK
     C     DDCUST        ANDNE     *BLANK
     C     DDACID        ORNE      *BLANK
     C     DDCUST        ANDNE     *BLANK
 
     C                   MOVE      'N'           Valid
     C                   MOVEA     '11111111'    *IN(51)
     C                   MOVEL     'RE75380 '    ZAMSID
     C                   EXSR      ZASNMS
 
      * Validate LINK ID
 
     C     DDLINK        WHENNE    *BLANK
     C                   EXSR      VAL_LINK
 
      * Validate RETAIL ACCOUNT NUMBER
 
     C     DDACNO        WHENNE    *BLANK
     C                   EXSR      VAL_ACNO
 
      * Validate ACCOUNT ID
 
     C     DDACID        WHENNE    *BLANK
 
      * Validate BRANCH
 
     C                   EXSR      VAL_BRCA
 
      * Validate CUSTOMER
 
     C                   EXSR      VAL_CNUM
 
      * Validate CURRENCY
 
     C                   EXSR      VAL_CCY
 
      * Validate ACCOUNT CODE
 
     C                   EXSR      VAL_ACOD
 
      * Validate ACCOUNT SEQUENCE
 
     C                   EXSR      VAL_ACSQ
 
     C     Valid         IFEQ      'Y'
     C                   EXSR      VAL_ACCID
     C                   ENDIF
 
      * Validate CUSTOMER
 
     C     DDCUST        WHENNE    *BLANK
     C                   EXSR      VAL_CUST
 
     C                   ENDSL
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Link ID
      ********************************************************************
     C     VAL_LINK      BEGSR
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDLINK        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      9             ZADIG             2 0
 
      * If ZALIGN error
      * 'Invalid Link ID'
 
     C     ZALIGNok      IFEQ      'N'
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'RE75381 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      ZFIELD        DDLINK
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate RETAIL ACCOUNT NUMBER
      ********************************************************************
     C     VAL_ACNO      BEGSR
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDACNO        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      10            ZADIG             2 0
 
     C     ZALIGNok      IFNE      'N'
     C                   MOVE      ZFIELD        ACNO
     C     ACNO          CHAIN     ACNUMABF                           60        *
     C                   MOVE      ACNO          DDACNO
     C                   ENDIF
 
      * 'Invalid Retail Account Number'
 
     C     ZALIGNok      IFEQ      'N'
     C     ZALIGNok      ORNE      'N'
     C     *IN60         ANDEQ     '1'
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN52
     C                   MOVEL     'RE75382 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate BRANCH
      ********************************************************************
     C     VAL_BRCA      BEGSR
 
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBRCA        @BRCA             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
      * 'Invalid Branch'
 
     C     DDBRCA        IFEQ      *BLANK
     C     @RTCD         ORNE      *BLANKS
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN53
     C                   MOVEL     'RE75383 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      A8BRCD        DDBRCA
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate CUSTOMER
      ********************************************************************
     C     VAL_CNUM      BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCNUM        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
      * 'Invalid Customer'
 
     C     DDCNUM        IFEQ      *BLANK
     C     @RTCD         ORNE      *BLANKS
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN54
     C                   MOVEL     'RE75384 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVEL     *BLANK        DDCNUM
     C                   MOVE      BBCUST        DDCNUM
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate CURRENCY
      ********************************************************************
     C     VAL_CCY       BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*BLANK '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCCY         @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
      * 'Invalid Currency'
 
     C     DDCCY         IFEQ      *BLANK
     C     @RTCD         ORNE      *BLANKS
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN55
     C                   MOVEL     'RE75385 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      A6CYCD        DDCCY
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate ACCOUNT CODE
      ********************************************************************
     C     VAL_ACOD      BEGSR
 
     C                   CALL      'AOACODR0'
     C                   PARM      '*BLANK '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C**********         PARM      DDACOD        @ACOD             4                          CGL029
     C                   PARM      DDACOD        @ACOD            10                          CGL029
     C     SDACOD        PARM      SDACOD        DSFDY
 
      * 'Invalid Account Code'
 
     C     DDACOD        IFEQ      *BLANK
     C     @RTCD         ORNE      *BLANKS
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN56
     C                   MOVEL     'RE75386 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      A5ACCD        DDACOD
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate ACCOUNT SEQUENCE
      ********************************************************************
     C     VAL_ACSQ      BEGSR
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDACSQ        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      2             ZADIG             2 0
 
      * If ZALIGN error
      * 'Invalid Account Sequence'
 
     C     DDACSQ        IFEQ      *BLANK
     C     ZALIGNok      OREQ      'N'
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN57
     C                   MOVEL     'RE75387 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      ZFIELD        DDACSQ
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate ACCOUNT ID
      ********************************************************************
     C     VAL_ACCID     BEGSR
 
     C                   MOVEL     DDACID        ACCID
 
      * 'Invalid account'
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
     C     *IN60         IFEQ      '1'
     C                   MOVE      'N'           Valid
     C                   MOVEA     '11111'       *IN(53)
     C                   MOVEL     'RE75388 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate CUSTOMER
      ********************************************************************
     C     VAL_CUST      BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCUST        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
      * 'Invalid Customer'
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN58
     C                   MOVEL     'RE75384 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVEL     *BLANK        DDCUST
     C                   MOVE      BBCUST        DDCUST
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Determine Hierarchies
      ********************************************************************
     C     DET_HIERS     BEGSR
 
     C                   Z-ADD     1             HI                3 0
     C                   Z-ADD     *ZERO         ARR_HIERS
     C                   Z-ADD     *ZERO         ARR_LINKS
 
     C                   SELECT
     C     DDLINK        WHENNE    *BLANK
     C                   MOVEL     DDLINK        CLLINK
     C     CLLINK        CHAIN     RECMHLLK                           60        *
     C  N60              MOVEL     CLHIER        ARR_HIERS(1)
     C  N60              MOVEL     CLLINK        ARR_LINKS(1)
 
     C     DDCUST        WHENNE    *BLANK
     C                   MOVEL     *BLANK        ACCID
     C                   MOVE      DDCUST        CUS
     C                   Z-ADD     1             BR
     C     ARR_BRCHS(BR) DOWNE     *BLANK
     C                   MOVEL     ARR_BRCHS(BR) BRC
     C     BRCCUSK       SETLL     RECMHLAC                                     *
     C     BRCCUSK       READE     RECMHLAC                               60    *
     C     *IN60         DOWEQ     '0'
     C     CLHIER        LOOKUP    ARR_HIERS                              99
     C  N99              MOVEL     CLHIER        ARR_HIERS(HI)
     C  N99              MOVEL     CLLINK        ARR_LINKS(HI)
     C  N99              ADD       1             HI
     C     BRCCUSK       READE     RECMHLAC                               60    *
     C                   ENDDO
     C                   ADD       1             BR
     C                   ENDDO
 
     C                   OTHER
     C     CHILDK        SETLL     RECMHLAC                                     *
     C     CHILDK        READE     RECMHLAC                               60    *
     C     *IN60         DOWEQ     '0'
     C                   MOVEL     CLHIER        ARR_HIERS(HI)
     C                   MOVEL     CLLINK        ARR_LINKS(HI)
     C                   ADD       1             HI
     C     CHILDK        READE     RECMHLAC                               60    *
     C                   ENDDO
     C                   ENDSL
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      ** Clear the message queue
      *****************************************************************
     C     CLR_MSGQ      BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
     C                   MOVEA     '00000000'    *IN(51)
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * ZASNMS - SEND A MESSAGE
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C                   CALL      'Y2SNMGC'                            0909    *
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM      'REUSRMSG'    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                  211210
      *****************************************************************         211210
      * DETERMINE OPTION CODES AVAILABLE                                        211210
      *****************************************************************         211210
     C     DET_OPTS      BEGSR                                                  211210
                                                                                211210
     C                   CALL      'ZVACTBU'                                    211210
     C                   PARM      'B'           @ZACTN            1            211210
     C                   PARM      UBRC          @ZBR              3            211210
     C                   PARM      *ZERO         @ERR              1 0          211210
                                                                                211210
     C                   IF        @ERR = 0                                     211210
     C     'B=Block'     CAT(P)    DDOPTS:1      DDOPTS                         211210
     C                   ENDIF                                                  211210
                                                                                211210
     C                   CALL      'ZVACTBU'                                    211210
     C                   PARM      'P'           @ZACTN            1            211210
     C                   PARM      UBRC          @ZBR              3            211210
     C                   PARM      *ZERO         @ERR              1 0          211210
                                                                                211210
     C                   IF        @ERR = 0                                     211210
     C     'P=Purge'     CAT(P)    DDOPTS:1      DDOPTS                         211210
     C                   ENDIF                                                  211210
                                                                                211210
     C                   CALL      'ZVACTBU'                                    211210
     C                   PARM      'S'           @ZACTN            1            211210
     C                   PARM      UBRC          @ZBR              3            211210
     C                   PARM      *ZERO         @ERR              1 0          211210
                                                                                211210
     C                   IF        @ERR = 0                                     211210
     C     'S=Sweep'     CAT(P)    DDOPTS:1      DDOPTS                         211210
     C                   ENDIF                                                  211210
                                                                                211210
     C                   CALL      'ZVACTBU'                                    211210
     C                   PARM      'E'           @ZACTN            1            211210
     C                   PARM      UBRC          @ZBR              3            211210
     C                   PARM      *ZERO         @ERR              1 0          211210
                                                                                211210
     C                   IF        @ERR = 0                                     211210
     C     'E=Enquiry'   CAT(P)    DDOPTS:1      DDOPTS                         211210
     C                   ENDIF                                                  211210
                                                                                211210
     C                   ENDSR                                                  211210
      *****************************************************************         211210
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      **********                                                                    211210 BUG6979
      ****GET*ZMUSER*to*access*default*branch.                                      211210 BUG6979
      **********                                                                    211210 BUG6979
     C******DTAARA       DEFINE                  ZMUSER                             211210 BUG6979
     C**********         IN        ZMUSER                                           211210 BUG6979
     C**********         UNLOCK    ZMUSER                                           211210 BUG6979
      **********                                                                    211210 BUG6979
      ****Determine*option*codes*available                                          211210 BUG6979
      **********                                                                    211210 BUG6979
     C**********         EXSR      DET_OPTS                                         211210 BUG6979
 
      * Initialize program name
 
     C                   MOVEL     'RE100460'    DDPGM
 
      * Set up subfile message queue information
 
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
      **********                                                                           BUG6979
      **Set*up*standard*screen*fields.                                                     BUG6979
      **********                                                                           BUG6979
     C**********         MOVEL     PsJobName     DDJOB                                     BUG6979
     C**********         MOVEL     PsUser        DDUSR                                     BUG6979
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Load branches
 
     C                   Z-ADD     1             BR                3 0
     C     *LOVAL        SETLL     SDBRCHL1
     C                   READ      SDBRCHL1                               99
     C     *IN99         DOWEQ     '0'
     C                   MOVEL     A8BRCD        ARR_BRCHS(BR)
     C                   ADD       1             BR
     C                   READ      SDBRCHL1                               99
     C                   ENDDO
 
      * Key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
     C     CHILDK        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C     BRCCUSK       KLIST
     C                   KFLD                    BRC
     C                   KFLD                    CUS
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
