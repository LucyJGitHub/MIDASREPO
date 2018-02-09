     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Hierarchy Details Browse')    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100450 - Cash Management Hierarchy Details Browse          *
      *                                                               *
      *  Function: This module allows browsing of Cash Management     *
      *            Hierarchy Details                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR676213           Date 19Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BG8539             Date 15Sep05               *
      *                 BUG6979            Date 03May05               *
      *                 214360             Date 03Feb03               *
      *                 213195             Date 10Jan03               *
      *                 212840             Date 10Jan03               *
      *                 211210             Date 11Dec02               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR676213 - Incorrect definition of CLGLAI field              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG8539 - Screen not dispaly properly in WebFacing            *
      *           Change the write/read order so that the last        *
      *           written format is not the footer before the READ    *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  214360 - Cash Management Deferred Posting                    *
      *  213195 - Wrong hierarchy description on purge & sweep screens*
      *  212840 - Missing info on link id                             *
      *  211210 - Various action code errors                          *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRE100450DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FRECMHDL2  IF   E           K DISK    INFSR(*PSSR)
     FREZSHDL0  IF   E           K DISK    INFSR(*PSSR)
     FRECMHLL5  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D NumPerPag       C                   CONST(14)
     D I_S_GLAI        S             24A                                                    AR676213
      ** Array of Fields in error.
     D RIE             S              9S 0 DIM(NumPerPag)
 
 
     D ZMUSER          DS            17                                         211210
     D  UBRC                  11     13                                         211210
                                                                                211210
                                                                                211210
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      /SPACE 5
 
      *                                                                                    BUG6979
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
 
      * Display subfile screen until F3 taken
 
     C     *INKC         DOWEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END
 
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
     C     CDHISN        ORNE      P_CDHISN
     C                   EXSR      FILL_SUBF
     C                   ENDIF
 
     C                   MOVEL     CDHISN        P_CDHISN         10
 
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
 
      ** If F3 was not taken
 
     C     *INKC         IFEQ      '0'
 
      * Rolldown requested
 
     C     *IN05         CASEQ     '1'           ROLLDOWN
 
      * Rollup requested
 
     C     *IN06         CASEQ     '1'           CONTINUE
 
      * Hierarchy selection prompt requested
 
     C     *INKJ         CASEQ     '1'           HIER_SEL_PRM
 
      * Reselection
 
     C     CDHISN        CASNE     P_CDHISN      CONTINUE
 
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
 
     C                   MOVEL     ToP_HISN      CDHISN
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
 
     C     RECMHDK       SETLL     RECMHDD0
     C                   READ      RECMHDD0                               99    *
 
      * If not end of file
 
     C     *IN99         IFEQ      '0'
     C                   MOVEL     CDHISN        ToP_HISN         10
     C                   ELSE
     C                   MOVEL     *BLANK        ToP_HISN
     C                   MOVEL     *BLANK        CDHISN
 
      * Else, if end of file
      * Issue message
 
     C                   MOVEL     'RE75900'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      * Do while not end of file
 
     C     *IN99         DOWEQ     '0'
 
     C                   ADD       1             SUBF_RRN          4 0    04    *
 
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
 
      * Get top a/c
 
     C     CDHIER        SETLL     RECMHLL5
     C     CDHIER        READE     RECMHLL5                               99
     C   99              Z-ADD     0             CLLINK
 
      * In error?
 
     C     CDHIER        LOOKUP    RIE                                    65
 
      * Write a record to the subfile
 
     C                   WRITE     SUBFLREC
     C     SUBF_RRN      IFEQ      NumPerPag
     C                   READ      RECMHDD0                               99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        CDHISN
     C                   MOVEL     'RE75900'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C                   READ      RECMHDD0                               99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        CDHISN
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
     C                   EXSR      HIER_PUR_REQ
     C                   ELSE
 
      * Call the cash management block request
 
     C     DDACTN        IFEQ      'B'
     C     CDHTYP        ANDEQ     'ZS'
     C                   EXSR      HIER_BLK_REQ
     C                   ELSE
 
      * Call the Cash Management Hierarchy Details Enquiry
 
     C                   EXSR      HIER_DTL_ENQ
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Return to top of subfile page
 
     C                   MOVEL     ToP_HISN      CDHISN
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Rolldown
      ********************************************************************
     C     ROLLDOWN      BEGSR
 
     C                   Z-ADD     *ZERO         SUBF_RRN
     C                   MOVEL     ToP_HISN      CDHISN
 
     C     RECMHDK       SETGT     RECMHDD0
     C                   READP     RECMHDD0                               99    *
 
      * Read previous
      * until count matches count of records previous read
 
     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C                   READP     RECMHDD0                               99    *
     C                   ADD       1             SUBF_RRN
     C                   ENDDO
 
      * Issue start of file message
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        CDHISN
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
     C                   PARM      *ZERO         I_CACD            4 0
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
     C                   PARM      *ZERO         I_CACD            4 0
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
     C                   PARM      *ZERO         I_CACD            4 0
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
     C                   PARM      *ZERO         I_S_LINK          9 0
     C                   PARM      *ZERO         I_S_RAN          10 0
     C**********         PARM      *BLANK        I_S_GLAI         18                        AR676213
     C                   PARM      *BLANK        I_S_GLAI                                   AR676213
     C                   PARM      *ZERO         I_S_CUS           6 0
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
      * Call the Cash Management Hierarchy Selection Prompt
      *****************************************************************
     C     HIER_SEL_PRM  BEGSR
 
     C                   CALL      'RE100460'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Error
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'SELECTION PROMPT FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      @INKC         *INKC
 
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
 
     C                   MOVEL     'RE100450 '   DDPGM
 
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
 
      * Key list
 
     C     RECMHDK       KLIST
     C                   KFLD                    CDHISN
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
