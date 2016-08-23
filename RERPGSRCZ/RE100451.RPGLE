     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Hierarchy Details Enquiry')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100451 - Cash Management Hierarchy Details Enquiry         *
      *                                                               *
      *  Function: This module allows enquiry into Cash Management    *
      *            Hierarchy Details                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR685449           Date 08Dec10               *
      *  Prev Amend No. AR682707           Date 02Dec10               *
      *                 AR676213           Date 19Nov10               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BG8539             Date 15Sep05               *
      *                 BUG6979            Date 03May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 216375             Date 10Apr03               *
      *                 214360             Date 03Feb03               *
      *                 213910             Date 23Jan03               *
      *                 213261             Date 14Jan03               *
      *                 211210             Date 11Dec02               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR685449 - Apply fix 225096                                  *
      *  225096 - Wrong calculation of available funds(with overdraft)*
      *  AR682707 - Full account in hierarchy links is truncated      *
      *  AR676213 - Incorrect definition of CLGLAI field              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG8539 - Screen not dispaly properly in WebFacing            *
      *           Change the write/read order so that the last        *
      *           written format is not the footer before the READ    *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216375 - Show charge accounts as retail numbers if possible  *
      *  214360 - Cash Management Deferred Posting                    *
      *  213910 - Show blocked links                                  *
      *  213261 - Balance purge can't be done for internal top a/cs   *
      *  211210 - Various action code errors                          *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRE100451DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FRECMHLL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHLD0:RECMHLGL)
     FRECMHLL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHLD0:RECMHLRA)
     FREGAHLJ2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(R_)
     FREZSHLJ2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(R_)
     FRECMHDL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(R_)
     FRECMHLL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHLD0:RECMHLPA)
     F                                     PREFIX(P_)
     FREZSHLL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSHLD0:REZSHLCHK)
     F                                     PREFIX(Z_)
     FRELZSHXPD IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F_)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACCNTABF)
     FMEMOSL1   IF   E           K DISK    INFSR(*PSSR)
     FMEMOSM1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(ME_)
     FRECMBRL0  IF   E           K DISK    INFSR(*PSSR)                         213910
     F                                     RENAME(RECMBRD0:RECMBRF0)            213910
     F                                     PREFIX(BR_)                          213910
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
     D I_CACD          S             10  0                                                    CGL029
     D I_C1ACCID       S             24                                                       CGL029
     D I_C3ACCID       S             24                                                       CGL029
     D I_S_GLAI        S             24                                                       CGL029
     D DDC1ACC         S             28                                                       CGL029
     D DDC3ACC         S             28                                                       CGL029
     D ToP_GLAI        S            360                                                     AR676213
 
      * Cash Management Hierarchy Details
     D O_CMHD        E DS                  EXTNAME(RECMHDPD)
     D A_HIER                  1      9
      * Zero Balancing/Sweeping Hierarchy Details
     D O_ZSHD        E DS                  EXTNAME(REZSHDPD)
      * Group Account Hierarchy Details
     D O_GAHD        E DS                  EXTNAME(REGAHDPD)
 
 
      ** Chain Arrays
     D***X_GLAI*         S             18    DIM(99)                                          CGL029
     D X_GLAI          S             24    DIM(99)                                            CGL029
     D X_RAN           S             10    DIM(99)
 
 
      * Links Array
     D GLA_LINKS       S              9S 0 DIM(999)
     D RAN_LINKS       S              9S 0 DIM(999)
     D I_HIERLINKS     S              9S 0 DIM(999)
 
 
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
 
 
     D*GLDashes*       S              1    DIM(18)  CTDATA PERRCD(18)                       AR676213
     D GLDashes        S              1    DIM(24)  CTDATA PERRCD(24)                       AR676213
     D REDashes        S              1    DIM(10)  CTDATA PERRCD(10)
     D #_INF           S             79    DIM(6)  CTDATA PERRCD(1)
 
 
      * Accounts
     D                 DS
     D DDACCS                  1     75
     D AccsAR                  1     75    DIM(75)
     D                 DS
     D***WAccsAR                 1    150    DIM(150)                                       AR682707
     D WAccsAR                 1    360    DIM(360)                                         AR682707
 
 
      * Sequence/Display gen.led. a/c id or retail a/c number
     D                 DS
     D GLA_RAN                 1      3
     D GLA_RAN_Seq             1      1
     D GLA_RAN_Dsp             3      3
 
 
      * Screen Balance
     D                 DS
     D ZOUT21                  1     21
     D ZOUT21Sign             21     21
     D ZOUT21Edit              1     22
     D ZOUT21Digit             1     20
 
 
     D NumPerPag       C                   CONST(16)
      ** Array of Fields in error.
     D RIE             S              9S 0 DIM(NumPerPag)
 
 
     D ZMUSER          DS            17                                         211210
     D  UBRC                  11     13                                         211210
                                                                                211210
                                                                                211210
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer Details
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
 
      * Access Hierarchy Detail
 
     C                   EXSR      ACS_HIER
 
      * Convert Cash Management Header
 
     C                   EXSR      CNV_CMHEADER
 
      * If a zero-balancing/sweeping hierarchy
      * ---------------------------------------
      * Access profile details
      * Convert Zero Balancing/Sweeping Header
 
      * If a group account hierarchy
      * ----------------------------
      * Convert Group A/c Header
 
     C     CDHTYP        IFEQ      'ZS'
     C                   EXSR      CNV_ZSHEADER
     C                   ELSE
     C                   EXSR      CNV_GAHEADER
     C                   ENDIF
 
      * Display screen until F3 or F12 taken
 
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
 
      * Initialize pointers
 
     C**********         MOVEL     *BLANK        CLGLAI                                     AR676213
     C                   MOVEL     *BLANK        CLGLAC                                     AR676213
     C                   MOVEL     *BLANK        CLRAN
 
      * Write and read details
 
     C                   TIME                    DDTIME
     C     CDHTYP        IFEQ      'ZS'
     C     ZDDEST        IFNE      *BLANK
     C                   MOVE      *ON           *IN30
     C                   ELSE
     C                   MOVE      *OFF          *IN30
     C                   ENDIF
     C                   EXFMT     ZEROBLSW
     C                   ELSE
     C                   EXFMT     GROUPACH
     C                   ENDIF
 
      * Display subfile screen until F3 or F12 taken
 
     C     *INKC         IFEQ      '0'
     C     *INKL         ANDEQ     '0'
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END
     C                   MOVE      *OFF          *INKL
     C                   END
     C                   END
 
      * Pass back function keys taken
 
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
 
      * End of program
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Display subfile screen
      *****************************************************************
     C     DSPLAY_SCN    BEGSR
 
      * Fill current subfile page
     C     *IN05         IFEQ      '1'
     C     *IN06         OREQ      '1'
     C     SUBF_RRN      OREQ      *ZERO
     C                   EXSR      FILL_SUBF
     C                   ENDIF
 
      * Write subfile control and foooter
 
     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCT
     C**********         WRITE     SUBFLCTL                                                   BG8539
     C                   WRITE     FOOTER
     C                   WRITE     SUBFLCTL                                                   BG8539
 
      * Read subfile control
 
     C                   READ      SUBFLCTL                               99    *
 
      ** Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
      ** If F3 and F12 were not taken
 
     C     *INKC         IFEQ      '0'
     C     *INKL         ANDEQ     '0'
 
      * Rolldown requested
 
     C     *IN05         CASEQ     '1'           ROLLDOWN
 
      * Rollup requested
 
     C     *IN06         CASEQ     '1'           CONTINUE
 
      * Toggle A/C ID
 
     C     *INKQ         CASEQ     '1'           TOG_ACID
 
      * Toggle Details
 
     C     *INKS         CASEQ     '1'           TOG_DETL
 
      * Toggle Name
 
     C     *INKU         CASEQ     '1'           TOG_NAME
 
      * Check for a record selected from the subfile
 
     C     *IN04         CASEQ     '0'           CHK_SUBF
     C                   END
 
     C                   ENDIF
 
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
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Continue
      *****************************************************************
     C     CONTINUE      BEGSR
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
 
      * Return to top of subfile page
 
     C**********         MOVEL     Top_GLAI      CLGLAI                                     AR676213
     C                   MOVEL     Top_GLAI      CLGLAC                                     AR676213
     C                   MOVEL     Top_RAN       CLRAN
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Toggle A/C ID
      *****************************************************************
     C     TOG_ACID      BEGSR
 
      * R_R = Show in retail a/c number sequence, display retail a/c number
      * R_G = Show in retail a/c number sequence, display gen.led. a/c id
      * G_G = Show in gen.led. a/c id sequence, display gen.led. a/c id
      * G_R = Show in gen.led. a/c id sequence, display retail a/c number
 
     C                   SELECT
     C     GLA_RAN       WHENEQ    'R_R'
     C                   MOVEL     'R_G'         GLA_RAN
     C     GLA_RAN       WHENEQ    'R_G'
     C                   MOVEL     'R_R'         GLA_RAN
     C                   ENDSL
 
      * Return to top of subfile page
 
     C**********         MOVEL     Top_GLAI      CLGLAI                                     AR676213
     C                   MOVEL     Top_GLAI      CLGLAC                                     AR676213
     C                   MOVEL     Top_RAN       CLRAN
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Toggle Details
      *****************************************************************
     C     TOG_DETL      BEGSR
 
     C                   SELECT
     C     SHOW_DETL     WHENEQ    '  '
     C                   MOVEL     'OC'          SHOW_DETL
     C                   MOVEL     #_INF(1)      DDNARR
     C     SHOW_DETL     WHENEQ    'OC'
     C                   MOVEL     'CC'          SHOW_DETL
     C                   MOVEL     #_INF(2)      DDNARR
     C     SHOW_DETL     WHENEQ    'CC'
     C                   MOVEL     'OL'          SHOW_DETL
     C                   MOVEL     #_INF(3)      DDNARR
     C     SHOW_DETL     WHENEQ    'OL'
     C                   MOVEL     'CL'          SHOW_DETL
     C                   MOVEL     #_INF(4)      DDNARR
     C     SHOW_DETL     WHENEQ    'CL'
     C     CDHTYP        ANDEQ     'GA'
     C                   MOVEL     'DI'          SHOW_DETL
     C                   MOVEL     #_INF(5)      DDNARR
     C                   OTHER
     C                   MOVEL     '  '          SHOW_DETL
     C                   MOVEL     #_INF(6)      DDNARR
     C                   ENDSL
 
      * Return to top of subfile page
 
     C**********         MOVEL     Top_GLAI      CLGLAI                                     AR676213
     C                   MOVEL     Top_GLAI      CLGLAC                                     AR676213
     C                   MOVEL     Top_RAN       CLRAN
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Toggle Name
      *****************************************************************
     C     TOG_NAME      BEGSR
 
     C     ANAM_CRNM     IFEQ      'A'
     C                   MOVEL     'C'           ANAM_CRNM
     C                   ELSE
     C                   MOVEL     'A'           ANAM_CRNM
     C                   ENDIF
 
      * Return to top of subfile page
 
     C**********         MOVEL     Top_GLAI      CLGLAI                                     AR676213
     C                   MOVEL     Top_GLAI      CLGLAC                                     AR676213
     C                   MOVEL     Top_RAN       CLRAN
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill subfile
      *****************************************************************
     C     FILL_SUBF     BEGSR
 
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   Z-ADD     *ZERO         SUBF_RRN
 
      * Write subfile control
 
     C                   WRITE     SUBFLCTL                                     *
 
      * Get first record
 
     C     GLA_RAN_Seq   IFEQ      'G'
     C     RECMHLK_GL    SETLL     RECMHLGL
     C     I_HIER        READE     RECMHLGL                               99    *
     C                   ELSE
     C     RECMHLK_RA    SETLL     RECMHLRA
     C     I_HIER        READE     RECMHLRA                               99    *
     C                   ENDIF
 
      * If not end of file
 
     C     *IN99         IFEQ      '0'
     C**********         MOVEL     CLGLAI        ToP_GLAI        270                        AR676213
     C                   MOVEL     CLGLAC        ToP_GLAI                                   AR676213
     C                   MOVEL     CLRAN         ToP_RAN         150
     C                   ELSE
     C                   MOVEL     *BLANK        ToP_GLAI
     C                   MOVEL     *BLANK        ToP_RAN
     C**********         MOVEL     *BLANK        CLGLAI                                     AR676213
     C                   MOVEL     *BLANK        CLGLAC                                     AR676213
     C                   MOVEL     *BLANK        CLRAN
 
      * Else, if end of file
      * Issue message
 
     C                   MOVEL     'RE75900'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      * Do while not end of file
 
     C     *IN99         DOWEQ     '0'
 
     C                   ADD       1             SUBF_RRN          4 0    04    *
 
      * Format data for output
 
     C                   EXSR      FMT_DATA
 
      * In error?
 
     C     CLLINK        LOOKUP    RIE                                    65
 
      * Write a record to the subfile
 
     C                   WRITE     SUBFLREC
     C     SUBF_RRN      IFEQ      NumPerPag
     C     GLA_RAN_Seq   IFEQ      'G'
     C     I_HIER        READE     RECMHLGL                               99    *
     C                   ELSE
     C     I_HIER        READE     RECMHLRA                               99    *
     C                   ENDIF
     C     *IN99         IFEQ      '1'
     C**********         MOVEL     *BLANK        CLGLAI                                     AR676213
     C                   MOVEL     *BLANK        CLGLAC                                     AR676213
     C                   MOVEL     *BLANK        CLRAN
     C                   MOVEL     'RE75900'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C     GLA_RAN_Seq   IFEQ      'G'
     C     I_HIER        READE     RECMHLGL                               99    *
     C                   ELSE
     C     I_HIER        READE     RECMHLRA                               99    *
     C                   ENDIF
     C     *IN99         IFEQ      '1'
     C**********         MOVEL     *BLANK        CLGLAI                                     AR676213
     C                   MOVEL     *BLANK        CLGLAC                                     AR676213
     C                   MOVEL     *BLANK        CLRAN
     C                   MOVEL     'RE75900'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
     C                   END
 
     C                   ENDDO
 
      * Set on subfile control indicators
 
     C     *IN(4)        IFEQ      '1'
     C                   MOVEA     '010'         *IN(1)
     C                   ELSE
     C                   MOVEA     '111'         *IN(1)
     C                   END
 
     C                   Z-ADD     *ZERO         RIE
 
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
     C     ZLSTYP        ANDEQ     'Z'
     C                   EXSR      HIER_PUR_REQ
     C                   ELSE
 
      * Call the cash management block request
 
     C     DDACTN        IFEQ      'B'
     C     CDHTYP        ANDEQ     'ZS'
     C                   EXSR      HIER_BLK_REQ
     C                   ELSE
 
      * Call the Cash Management Hierarchy Links Enquiry
 
     C                   EXSR      HIER_LNK_ENQ
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Return to top of subfile page
 
     C**********         MOVEL     Top_GLAI      CLGLAI                                     AR676213
     C                   MOVEL     Top_GLAI      CLGLAC                                     AR676213
     C                   MOVEL     Top_RAN       CLRAN
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Format data for output
      ********************************************************************
     C     FMT_DATA      BEGSR
 
     C                   MOVEL     *BLANK        DDACCS
 
      * A/cs - General Ledger ID
      * ------------------------
 
     C     GLA_RAN_Dsp   IFEQ      'G'
 
     C**********         MOVEA     CLGLAI        X_GLAI                                     AR676213
     C                   MOVEA     CLGLAC        X_GLAI                                     AR676213
     C                   Z-ADD     1             X                 3 0
     C                   Z-ADD     2             Y                 3 0
     C     X_GLAI(Y)     DOWNE     *BLANK
     C                   MOVEA     GLDashes      X_GLAI(X)
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   ENDDO
 
     C                   MOVEA     X_GLAI        WAccsAR
 
      * A/cs - Retail A/c Number
      * ------------------------
 
     C                   ELSE
 
     C                   MOVEA     CLRAN         X_RAN
     C                   Z-ADD     1             X                 3 0
     C                   Z-ADD     2             Y                 3 0
     C     X_RAN(Y)      DOWNE     *BLANK
     C                   MOVEA     REDashes      X_RAN(X)
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   ENDDO
 
     C                   MOVEA     X_RAN         WAccsAR
 
     C                   ENDIF
 
      * Remove fillers
 
     C                   Z-ADD     1             X
     C                   Z-ADD     1             Y
     C*****X****         DOUGT     150                                                      AR682707
     C     X             DOUGT     360                                                      AR682707
     C     Y             ORGT      75
     C     SHOW_DETL     IFEQ      'CC'
     C     WAccsAR(X)    ANDNE     '!'
     C     WAccsAR(X)    ANDNE     '_'
     C     SHOW_DETL     OREQ      'CL'
     C     WAccsAR(X)    ANDNE     '!'
     C     WAccsAR(X)    ANDNE     '_'
     C     SHOW_DETL     ORNE      'CC'
     C     SHOW_DETL     ANDNE     'CL'
     C     WAccsAR(X)    ANDNE     '!'
     C                   MOVEL     WAccsAR(X)    AccsAR(Y)
     C                   ADD       1             Y
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
 
      * Child a/c
 
     C                   MOVEL     CLCBRC        BRC
     C                   MOVEL     CLCCUS        CUS
     C                   MOVEL     CLCCCY        CCY
     C                   MOVEL     CLCACD        ACD
     C                   MOVEL     CLCASN        ASN
 
      * Access a/c details for the child a/c
 
     C                   EXSR      ACS_ACCNT
 
     C                   MOVEL     RECI          C_RECI            1
     C                   MOVEL     ACNO          C_ACNO
     C                   MOVEL     ANAM          C_ANAM
 
      * Highlight selection
 
     C                   MOVE      *OFF          *IN50
     C                   SELECT
     C     I_S_LINK      WHENNE    *ZERO
     C     I_S_LINK      COMP      CLLINK                                 50
     C     I_S_RAN       WHENNE    *ZERO
     C     I_S_RAN       COMP      ACNO                                   50
     C     I_S_GLAI      WHENNE    *BLANK
     C     I_S_GLAI      COMP      ACCID                                  50
     C*****I_S_CUS       WHENNE    *ZERO                                                      CSD027
     C     I_S_CUS       WHENNE    *BLANKS                                                    CSD027
     C     I_S_CUS       COMP      CUS                                    50
     C                   ENDSL
 
 
      * Access Customer
 
     C                   MOVE      CUS           WrkCUS            6
     C                   EXSR      ACS_CUST
 
      * Access currency details
 
     C                   EXSR      ACS_CURR
 
      * Access MEMOS record(s)
 
     C                   EXSR      ACS_MEMOS
 
      * Edit CLOSING cleared/ledger balance, Overdraft and Available Funds
 
     C     SHOW_DETL     IFEQ      'CC'
     C     SHOW_DETL     OREQ      'CL'
 
      * Closing Cleared/Ledger Balance
 
     C                   MOVE      *BLANKS       ZFLD15
     C     SHOW_DETL     IFEQ      'CC'
     C                   MOVE      CLBLN         ZFLD15
     C                   ELSE
     C                   MOVE      LDBLN         ZFLD15
     C                   ENDIF
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    ScnBal           18
     C     C_RECI        IFNE      'D'
     C                   MOVEL     ' * CLOSED *' ScnBal
     C                   ENDIF
     C                   MOVEA     ScnBal        AccsAR(25)
 
      * Overdraft
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      ODLN          ZFLD15
     C                   Z-ADD     *ZERO         ZDECS
     C                   MOVE      *BLANKS       ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Digit   WOdln            11
     C                   MOVEA     WOdln         AccsAR(45)
 
      * Available Funds.  Set amount with decimal places of
      * currency.
 
     C                   SELECT
     C     A6NBDP        WHENEQ    0
     C     1             MULT      ODLN          WOdlnNum         15 0
     C     A6NBDP        WHENEQ    1
     C     10            MULT      ODLN          WOdlnNum
     C     A6NBDP        WHENEQ    2
     C     100           MULT      ODLN          WOdlnNum
     C     A6NBDP        WHENEQ    3
     C     1000          MULT      ODLN          WOdlnNum
     C                   ENDSL
 
     C     SHOW_DETL     IFEQ      'CC'
     C*****CLBLN         ADD       WOdlnNum      WAvailFund       15 0                        225096
     C     CLBLN         SUB       WOdlnNum      WAvailFund       15 0                        225096
     C                   ELSE
     C*****LDBLN         ADD       WOdlnNum      WAvailFund                                   225096
     C     LDBLN         SUB       WOdlnNum      WAvailFund                                   225096
     C                   ENDIF
     C*
     C* If Blocked on debits, available balance must be zero.
     C*
     C                   TESTB     '2'           RETB                     99
     C   99              Z-ADD     0             WAvailFund
     C*
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WAvailFund    ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    ScnBal
     C                   MOVEA     ScnBal        AccsAR(58)
     C                   ENDIF
 
      * Edit OPENING cleared balance
 
     C     SHOW_DETL     IFEQ      'OC'
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      CLBL          ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    ScnBal
     C     C_RECI        IFNE      'D'
     C                   MOVEL     ' * CLOSED *' ScnBal
     C                   ENDIF
     C                   MOVE      ScnBal        DDACCS
     C                   ENDIF
 
      * Edit OPENING ledger balance
 
     C     SHOW_DETL     IFEQ      'OL'
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      LDBL          ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    ScnBal
     C     C_RECI        IFNE      'D'
     C                   MOVEL     ' * CLOSED *' ScnBal
     C                   ENDIF
     C                   MOVE      ScnBal        DDACCS
     C                   ENDIF
 
      * Determine a/c relationships
      * Link ID
 
     C     SHOW_DETL     IFEQ      '  '
     C                   EXSR      DET_AC_REL
     C                   MOVE      CLLINK        DDACCS
     C                   ELSE
     C     SHOW_DETL     IFNE      'DI'
     C     SHOW_DETL     ANDNE     'CC'
     C     SHOW_DETL     ANDNE     'CL'
     C     ANAM_CRNM     IFEQ      'A'
     C                   MOVEA     ANAM          AccsAR(38)
     C                   ELSE
     C                   MOVEA     BBCRNM        AccsAR(28)
     C                   MOVEA     BBCRTN        AccsAR(48)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * If GROUP A/C Hierarchy and NOT a sub a/c
      * Validate sub-totals
 
     C                   MOVE      *OFF          *IN51
     C     CDHTYP        IFEQ      'GA'
     C     CLCCAT        ANDNE     'S'
     C                   EXSR      VAL_SUBTOTS
     C     LDBL_DIFF     IFNE      0
     C     CLBL_DIFF     ORNE      0
     C                   MOVE      *ON           *IN51
     C                   ENDIF
     C                   ENDIF
 
      * Edit DIFFERENCES in cleared balance and ledger balance
 
     C     SHOW_DETL     IFEQ      'DI'
     C     *IN51         ANDEQ     '1'
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      LDBL_DIFF     ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    ScnBal
     C                   MOVEA     ScnBal        AccsAR(40)
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      CLBL_DIFF     ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    ScnBal
     C                   MOVEA     ScnBal        AccsAR(58)
     C                   ENDIF
 
      * Check if zero balancing/sweeping link
 
     C     REZSHLK_CHK   CHAIN     REZSHLCHK                          99
     C  N99              MOVEL     Z_ZLSTYP      ZLSTYP
     C   99              MOVEL     *BLANK        ZLSTYP
                                                                                213910
      * Check if link is blocked                                                213910
                                                                                213910
     C     RECMBRK       CHAIN     RECMBRF0                           99        213910
     C  N99              MOVEA     'BLK'         AccsAR(34)                     213910
     C  N99              MOVEL     'Y'           DDBLOCK                        213910
     C   99              MOVEL     'N'           DDBLOCK                        213910
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Determine a/c relationships
      ********************************************************************
     C     DET_AC_REL    BEGSR
 
      * If zero balancing/sweeping hierarchy
 
     C     CDHTYP        IFEQ      'ZS'
 
      * Determine if a/c is an a/c in a group a/c hierarchy
      * If it is, identify the hierarchy
 
     C     ACCNTK        CHAIN     REGAHLJ2                           99
     C     *IN99         IFEQ      '0'
     C     R_CLHIER      CHAIN     RECMHDD0                           99
     C     AccsAR(56)    IFEQ      *BLANK
     C                   MOVEA     R_CDHISN      AccsAR(56)
     C                   ENDIF
     C                   ENDIF
 
      * Determine if a/c exists in another zero balancing/sweeping hierarchy
      * If it does, identify the hierarchy
 
     C     ACCNTK        SETLL     REZSHLJ2
     C     ACCNTK        READE     REZSHLJ2                               99
     C     *IN99         DOWEQ     '0'
     C     R_CLHIER      IFNE      I_HIER
     C     R_CLHIER      CHAIN     RECMHDD0                           99
     C     AccsAR(56)    IFEQ      *BLANK
     C                   MOVEA     R_CDHISN      AccsAR(56)
     C                   ENDIF
     C                   ENDIF
     C     ACCNTK        READE     REZSHLJ2                               99
     C                   ENDDO
 
     C                   ELSE
 
      * Determine if a/c is an a/c in a zero balancing/sweeping hierarchy
      * If it is, identify the hierarchy
 
     C     ACCNTK        CHAIN     REZSHLJ2                           99
     C     *IN99         IFEQ      '0'
     C     R_CLHIER      CHAIN     RECMHDD0                           99
     C     AccsAR(56)    IFEQ      *BLANK
     C                   MOVEA     R_CDHISN      AccsAR(56)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate sub-totals
      ********************************************************************
     C     VAL_SUBTOTS   BEGSR
 
      * Start with this a/c's ledger and cleared balance
 
     C                   Z-ADD     LDBL          LDBL_DIFF        15 0
     C                   Z-ADD     CLBL          CLBL_DIFF        15 0
 
      * Read all a/cs who have a parent equal to this a/c
 
     C     RECMHLK_PA    SETLL     RECMHLPA
     C     RECMHLK_PA    READE     RECMHLPA                               99    *
 
     C     *IN99         DOWEQ     '0'
 
      * Access child a/c
     C     ACCNTK_CH     CHAIN     ACCNTABF                           60        *
 
     C                   SUB       LDBL          LDBL_DIFF
     C                   SUB       CLBL          CLBL_DIFF
 
     C     RECMHLK_PA    READE     RECMHLPA                               99    *
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Rolldown
      ********************************************************************
     C     ROLLDOWN      BEGSR
 
     C                   Z-ADD     *ZERO         SUBF_RRN
     C**********         MOVEL     Top_GLAI      CLGLAI                                     AR676213
     C                   MOVEL     Top_GLAI      CLGLAC                                     AR676213
     C                   MOVEL     Top_RAN       CLRAN
 
     C     GLA_RAN_Seq   IFEQ      'G'
     C     RECMHLK_GL    SETGT     RECMHLGL
     C     I_HIER        READPE    RECMHLGL                               99    *
     C                   ELSE
     C     RECMHLK_RA    SETGT     RECMHLRA
     C     I_HIER        READPE    RECMHLRA                               99    *
     C                   ENDIF
 
      * Read previous
      * until count matches count of records previous read
 
     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C     GLA_RAN_Seq   IFEQ      'G'
     C     I_HIER        READPE    RECMHLGL                               99    *
     C                   ELSE
     C     I_HIER        READPE    RECMHLRA                               99    *
     C                   ENDIF
     C                   ADD       1             SUBF_RRN
     C                   ENDDO
 
      * Issue start of file message
 
     C     *IN99         IFEQ      '1'
     C**********         MOVEL     *BLANK        CLGLAI                                     AR676213
     C                   MOVEL     *BLANK        CLGLAC                                     AR676213
     C                   MOVEL     *BLANK        CLRAN
     C                   MOVEL     'RE75901'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
 
     C                   ENDSR
      *****************************************************************
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
     C                   PARM      'L'           I_REQTYP          1
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Type
      * Hierarchy Description
      * Link ID
     C                   PARM                    I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
     C                   PARM      CDHTYP        I_HTYP            2
     C                   PARM      CDDESC        I_DESC           50
     C                   PARM      CLLINK        I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      CLCBRC        I_CBRC            3
     C**********         PARM      CLCCUS        I_CCUS            6 0                        CSD027
     C                   PARM      CLCCUS        I_CCUS            6                          CSD027
     C                   PARM      CLCCCY        I_CCCY            3
     C**********         PARM      CLCACD        I_CACD            4 0                        CGL029
     C                   PARM      CLCACD        I_CACD                                       CGL029
     C                   PARM      CLCASN        I_CASN            2 0
      * Retail A/c Number
      * Account Name
     C                   PARM      C_ACNO        I_RAN            10
     C                   PARM      C_ANAM        I_ANAM           20
 
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
     C                   PARM      'L'           I_REQTYP          1
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Type
      * Hierarchy Description
      * Link ID
     C                   PARM                    I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
     C                   PARM      CDHTYP        I_HTYP            2
     C                   PARM      CDDESC        I_DESC           50
     C                   PARM      CLLINK        I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      CLCBRC        I_CBRC            3
     C**********         PARM      CLCCUS        I_CCUS            6 0                        CSD027
     C                   PARM      CLCCUS        I_CCUS            6                          CSD027
     C                   PARM      CLCCCY        I_CCCY            3
     C**********         PARM      CLCACD        I_CACD            4 0                        CGL029
     C                   PARM      CLCACD        I_CACD                                       CGL029
     C                   PARM      CLCASN        I_CASN            2 0
      * Retail A/c Number
      * Account Name
     C                   PARM      C_ACNO        I_RAN            10
     C                   PARM      C_ANAM        I_ANAM           20
 
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
     C                   PARM      'L'           I_REQTYP          1
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Type
      * Hierarchy Description
      * Link ID
     C                   PARM                    I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
     C                   PARM      CDHTYP        I_HTYP            2
     C                   PARM      CDDESC        I_DESC           50
     C                   PARM      CLLINK        I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      CLCBRC        I_CBRC            3
     C**********         PARM      CLCCUS        I_CCUS            6 0                        CSD027
     C                   PARM      CLCCUS        I_CCUS            6                          CSD027
     C                   PARM      CLCCCY        I_CCCY            3
     C**********         PARM      CLCACD        I_CACD            4 0                        CGL029
     C                   PARM      CLCACD        I_CACD                                       CGL029
     C                   PARM      CLCASN        I_CASN            2 0
      * Retail A/c Number
      * Account Name
     C                   PARM      C_ACNO        I_RAN            10
     C                   PARM      C_ANAM        I_ANAM           20
 
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
      * Call the Cash Management Hierarchy Links Enquiry
      *****************************************************************
     C     HIER_LNK_ENQ  BEGSR
 
     C     GLA_RAN_Seq   IFEQ      'G'
     C                   MOVE      GLA_LINKS     I_HIERLINKS
     C                   ELSE
     C                   MOVE      RAN_LINKS     I_HIERLINKS
     C                   ENDIF
 
     C                   CALL      'RE100452'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Type
      * Hierarchy Description
     C                   PARM                    I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
     C                   PARM      CDHTYP        I_HTYP            2
     C                   PARM      CDDESC        I_DESC           50
      * Link ID
     C                   PARM      CLLINK        I_LINK            9 0
      * Hierarchy Links
     C                   PARM                    I_HIERLINKS
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
     C     DDACTN        OREQ      'P'
     C     ZLSTYP        ANDNE     'Z'
     C     DDACTN        OREQ      'P'                                          213261
     C     CLCCAT        ANDEQ     'T'                                          213261
     C     ZDEXTL        ANDNE     'Y'                                          213261
     C     DDACTN        OREQ      'B'
     C     CDHTYP        ANDNE     'ZS'
 
     C                   MOVEL     'N'           ActnOK
     C                   MOVEL     'RE75904'     ZAMSID
     C                   EXSR      ZASNMS
 
     C                   ELSE
                                                                                213910
      * Check if account blocked: if so, sweeps and purges not allowed          213910
                                                                                213910
     C     DDACTN        IFEQ      'S'                                          213910
     C     DDBLOCK       ANDEQ     'Y'                                          213910
     C     DDACTN        OREQ      'P'                                          213910
     C     DDBLOCK       ANDEQ     'Y'                                          213910
     C                   MOVEL     'N'           ActnOK                         213910
     C                   MOVEL     'RE75906'     ZAMSID                         213910
     C                   EXSR      ZASNMS                                       213910
     C                   ELSE                                                   213910
 
      * Check for user authority to action code
 
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        @ZACTN            1
     C                   PARM      CLCBRC        @ZBR              3
     C                   PARM      *ZERO         @ERR              1 0
     C     @ERR          IFEQ      2
     C                   MOVEL     'N'           ActnOK
     C                   MOVEL     'RE75902'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF                                                  213910
     C                   ENDIF
 
      * If action code not OK, log record in error
 
     C     ActnOK        IFNE      'Y'
     C                   MOVE      '0'           @INKC
     C                   Z-ADD     1             @RIE              2 0
     C     *ZERO         LOOKUP    RIE(@RIE)                              99
     C                   Z-ADD     CLLINK        RIE(@RIE)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
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
      /SPACE 5
      ********************************************************************
      * Access Hierarchy Detail
      ********************************************************************
     C     ACS_HIER      BEGSR
 
     C                   CALLB     'RE100601'
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Option
     C                   PARM      '*ALL   '     X_OPTN            7
      * Hierarchy ID
     C                   PARM                    I_HIER            9 0
      * Hierarchy Type
     C                   PARM      *BLANK        I_HTYP            2
 
     C                   PARM                    O_CMHD
     C                   PARM                    O_ZSHD
     C                   PARM                    O_GAHD
 
      * End if error occurred in module
      * or if no record found
 
     C     X_RTCD        IFEQ      '*ERROR'
     C     X_RTCD        OREQ      '*NOREC'
     C                   EVAL      X_ERMS = 'BAD HIERARCHY DETAIL:' + A_HIER
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Cash Management Header
      ********************************************************************
     C     CNV_CMHEADER  BEGSR
 
     C                   CALLB     'RE100311'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
 
      * INPUTS
 
      * Date format
     C                   PARM      'A'           I_DATFMT          1
      * Date Effective From
      * Review Date
      * Last Change Date
     C                   PARM      CDDEFR        I_DEFR            5 0
     C                   PARM      CDRVDT        I_RVDT            5 0
     C                   PARM      CDLCDT        I_LCDT            5 0
 
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * Date Effective From
      * Review Date
      * Last Change Date
     C                   PARM                    DDDEFR            7
     C                   PARM                    DDRVDT            7
     C                   PARM                    DDLCDT            7
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN CASH MANAGEMENT HEADER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Zero Balancing/Sweeping Header
      ********************************************************************
     C     CNV_ZSHEADER  BEGSR
 
      * Get currency of top a/c
 
     C     I_HIER        SETLL     RECMHLGL
     C     I_HIER        READE     RECMHLGL                               60
 
     C                   CALLB     'RE100312'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
      * INPUTS
      * Child Currency
     C                   PARM      CLCCCY        I_CCCY            3
      * Edit code
     C                   PARM      'J'           I_ECODE           1
 
      * Input Cycle Sweeping Frequency
      * Input Cycle Sweeping Indicators
     C                   PARM      ZDICSF        I_ICSF           48
     C                   PARM      ZDICSI        I_ICSI           12
 
      * Sweeping Holiday Convention
     C                   PARM      ZDSHOC        I_SHOC            1
 
      * Check For Cover on Top A/c
     C                   PARM      ZDCHKC        I_CHKC            1
 
      * External
      * Master Account
      * External Fwd Value Sweeping
      * External Account 1                                                      214360
     C                   PARM      ZDEXTL        I_EXTL            1
     C                   PARM      ZDMAST        I_MAST            1
     C                   PARM      ZDEFVS        I_EFVS            1
     C                   PARM      ZDEXA1        I_EXA1           35            214360
 
      * MT202 Cover Message Required
     C                   PARM      ZDMCMR        I_MCMR            1
 
      * MT101 Charges Account
      * MT101 Charges Amount
     C*******************PARM                    I_C1ACCID        18            216375
     C**********         PARM      ZDCAC1        I_C1ACCID        18                   216375 CGL029
     C                   PARM      ZDCAC1        I_C1ACCID                                    CGL029
     C                   PARM      ZDCAM1        I_CAM1           15 0
 
      * MT103 Charges Account
      * MT103 Charges Amount
     C*******************PARM                    I_C3ACCID        18            216375
     C**********         PARM      ZDCAC3        I_C3ACCID        18                   216375 CGL029
     C                   PARM      ZDCAC3        I_C3ACCID                                    CGL029
     C                   PARM      ZDCAM3        I_CAM3           15 0
      * Deferred Posting                                                        214360
      * Deferred Posting Zero Narrative                                         214360
     C                   PARM      ZDDEFP        I_DEFP            1            214360
     C                   PARM      ZDDEFZ        I_DEFZ            1            214360
 
      * OUTPUTS
 
      * Input Cycle Sweeping Frequency
      * Input Cycle Sweeping Indicators
     C                   PARM                    DDICSF           59
     C                   PARM                    DDICSI           48
 
      * Sweeping Holiday Convention
     C                   PARM                    DDSHOC            7
 
      * Check For Cover on Top A/c
     C                   PARM                    DDCHKC            3
 
      * External
      * Master Account
      * External Fwd Value Sweeping
      * External Account 1                                                      214360
     C                   PARM                    DDEXTL            3
     C                   PARM                    DDMAST            3
     C                   PARM                    DDEFVS            3
     C                   PARM                    DDEXA11          25            214360
     C                   PARM                    DDEXA12          10            214360
 
      * MT202 Cover Message Required
     C                   PARM                    DDMCMR            3
 
      * MT101 Charges Account
      * MT101 Charges Amount
     C**********         PARM                    DDC1ACC          22                          CGL029
     C                   PARM                    DDC1ACC                                      CGL029
     C                   PARM                    DDCAM1           17
 
      * MT103 Charges Account
      * MT103 Charges Amount
     C**********         PARM                    DDC3ACC          22                          CGL029
     C                   PARM                    DDC3ACC                                      CGL029
     C                   PARM                    DDCAM3           17
      * Deferred Posting                                                        214360
      * Deferred Posting Zero Narrative                                         214360
     C                   PARM                    DDDEFP            3            214360
     C                   PARM                    DDDEFZ            3            214360
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN ZERO BAL/SWEEPING HEADER'
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                216375
      *Charge a/cs                                                              216375
     C                   MOVEL     DDC1ACC       DDCAC1                         216375
     C                   MOVEL     DDC3ACC       DDCAC3                         216375
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Group A/c Header
      ********************************************************************
     C     CNV_GAHEADER  BEGSR
 
     C                   CALLB     'RE100313'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
      * INPUTS
 
      * Top on Balance Sheet
      * Link Effective At Last Capitalization Date
      * Unlink Effective At Last Capitalization Date
     C                   PARM      GDTOPB        I_TOPB            1
     C                   PARM      GDLELC        I_LELC            1
     C                   PARM      GDUELC        I_UELC            1
 
      * OUTPUTS
 
      * Top on Balance Sheet
      * Link Effective At Last Capitalization Date
      * Unlink Effective At Last Capitalization Date
     C                   PARM                    DDTOPB            3
     C                   PARM                    DDLELC            3
     C                   PARM                    DDUELC            3
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN GROUP A/C HEADER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Access a/c details
      ********************************************************************
     C     ACS_ACCNT     BEGSR
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access a customer
      ********************************************************************
     C     ACS_CUST      BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WrkCUS        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Access a currency
      ********************************************************************
     C     ACS_CURR      BEGSR
 
     C                   CALLB     'ZAACSCURR'
     C                   PARM                    CCY
     C                   PARM                    SDCURR
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Access MEMOS record
      ********************************************************************
     C     ACS_MEMOS     BEGSR
 
     C     ACCNTK        CHAIN     MEMOSMDF                           60        *
     C   60              Z-ADD     0             LDBLN
     C   60              Z-ADD     0             CLBLN
 
     C     ACCNTK_ME     SETLL     MEMOSMEF                           60        *
     C     ACCNTK_ME     READE     MEMOSMEF                               60    *
     C     *IN60         DOWEQ     '0'
     C                   ADD       ME_LDBL       LDBLN
     C                   ADD       ME_CLBL       CLBLN
     C     ACCNTK_ME     READE     MEMOSMEF                               60    *
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /EJECT
      *****************************************************************
      * Edit a signed field
      *****************************************************************
     C     ZSEDIT        BEGSR
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT21           21
     C     ZOUT21Sign    IFEQ      '-'
     C                   MOVE      'CR'          ZOUT21Edit
     C                   ELSE
     C                   MOVE      '  '          ZOUT21Edit
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Determine hierarchy links
      ********************************************************************
     C     DET_LINKS     BEGSR
 
     C                   Z-ADD     0             LKN               3 0
 
     C     GLA_RAN_Seq   IFEQ      'G'
     C     I_HIER        SETLL     RECMHLGL
     C     I_HIER        READE     RECMHLGL                               99    *
     C                   ELSE
     C     I_HIER        SETLL     RECMHLRA
     C     I_HIER        READE     RECMHLRA                               99    *
     C                   ENDIF
 
      * Do while not end of file
 
     C     *IN99         DOWEQ     '0'
     C                   ADD       1             LKN                            *
     C     GLA_RAN_Seq   IFEQ      'G'
     C                   Z-ADD     CLLINK        GLA_LINKS(LKN)
     C     I_HIER        READE     RECMHLGL                               99    *
     C                   ELSE
     C                   Z-ADD     CLLINK        RAN_LINKS(LKN)
     C     I_HIER        READE     RECMHLRA                               99    *
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
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
      * Hierarchy ID
     C                   PARM                    I_HIER            9 0
      * Selected Link Id
      * Selected Retail Account Number
      * Selected GL Account Number
      * Selected Customer
     C                   PARM                    I_S_LINK          9 0
     C                   PARM                    I_S_RAN          10 0
     C**********         PARM                    I_S_GLAI         18                          CGL029
     C                   PARM                    I_S_GLAI                                     CGL029
     C**********         PARM                    I_S_CUS           6 0                        CSD027
     C                   PARM                    I_S_CUS           6                          CSD027
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
 
     C                   MOVEL     'RE100451'    DDPGM
 
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
 
      * Determine hierarchy links
 
     C                   MOVEL     'R'           GLA_RAN_Seq
     C                   EXSR      DET_LINKS
     C                   MOVEL     'G'           GLA_RAN_Seq
     C                   EXSR      DET_LINKS
 
      * Initialize toggles
 
     C                   MOVEL     'R_R'         GLA_RAN
     C                   MOVEL     'OC'          SHOW_DETL         2
     C                   MOVEL     'A'           ANAM_CRNM         1
     C                   MOVEL     #_INF(1)      DDNARR
 
      * Key lists
 
     C     RECMHLK_GL    KLIST
     C                   KFLD                    I_HIER
     C**********         KFLD                    CLGLAI                                     AR676213
     C                   KFLD                    CLGLAC                                     AR676213
     C     RECMHLK_RA    KLIST
     C                   KFLD                    I_HIER
     C                   KFLD                    CLRAN
     C     RECMHLK_PA    KLIST
     C                   KFLD                    I_HIER
     C                   KFLD                    BRC
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C     ACCNTK_CH     KLIST
     C                   KFLD                    P_CLCCUS
     C                   KFLD                    P_CLCCCY
     C                   KFLD                    P_CLCACD
     C                   KFLD                    P_CLCASN
     C                   KFLD                    P_CLCBRC
     C     REZSHLK_CHK   KLIST
     C                   KFLD                    I_HIER
     C                   KFLD                    CLLINK
     C     ACCNTK_ME     KLIST
     C                   KFLD                    BRC
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
     C     RECMBRK       KLIST                                                  213910
     C                   KFLD                    I_HIER                         213910
     C                   KFLD                    CLLINK                         213910
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
** GLdashes
!!!!!!!!!!!!!!!!!!!!!___                                                                    AR676213
** REdashes
!!!!!!!___
** #_INF
    Accounts                                            OPENING Cleared Balance
    Accounts           CLOSING Cleared Balance    Overdraft     Available Funds
    Accounts                                             OPENING Ledger Balance
    Accounts            CLOSING Ledger Balance    Overdraft     Available Funds
    Accounts                DIFFERENCE:      Ledger Balance     Cleared Balance
    Accounts                                       Related Hierarchy  Link ID
