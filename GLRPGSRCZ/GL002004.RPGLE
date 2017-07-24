     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account Enquiry - By Retail A/c Number')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL002004 - Account Enquiry - By Retail A/c Number            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD046682           Date 14Jul17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG13285           Date 11Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 BG1769             Date 23May03               *
      *                 CGL029             Date 23May03               *
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046682 - Credit amount should not be displayed with '-'.   *
      *  BUG13285 - Amount defaulted are in one decimal place only    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BG1769 - Complete 10 digit account code changes.             *
      *  CGL029 - 10 digit account code changes.                      *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************

     FGL002004DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FACNUMA    IF   E           K DISK    INFSR(*PSSR)
     FMEMOSL1   IF   E           K DISK    INFSR(*PSSR)
     FMEMOSM1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(ME_)

      *****************************************************************
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************


     D #_INF           S             42    DIM(5)  CTDATA PERRCD(1)


     D NumPerPag       C                   CONST(16)


      ** Array of Fields in error.
     D RIE             S             24    DIM(NumPerPag)


     D                 DS
     D  AccountID              1     24
     D  BRCA                   1      3
     D**CNUM****               4      9  0                                                    CSD027
     D  CNUM                   4      9                                                       CSD027
     D  CCY                   10     12
     D**ACOD***               13     16  0                                                    CGL029
     D  ACOD                  13     22  0                                                    CGL029
     D  ACSQ                  23     24  0


      * Screen Balance
     D                 DS
     D ZOUT21                  1     21
     D ZOUT21Sign             21     21
     D ZOUT2122CR             21     22                                                     MD046682
      *                                                                                     BUG13285
      ** Position 21-22 was overriden by CR/Blanks, adjust length of                        BUG13285
      ** ZOUT21Edit from 21 to 23 to accomodate moving of CR/Blanks.                        BUG13285
      *                                                                                     BUG13285
     D*ZOUT21Edit              1     22                                                     BUG13285
     D ZOUT21Edit              1     23                                                     BUG13285
     D ZOUT21Digit             1     20


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)


     IMEMOSMDF
     I              RECI                        ME_RECI
      /SPACE 5


      * Display subfile screen until F3 or F12 taken

     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END

      * End

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
     C     DDACNO        ORNE      *BLANK
     C                   EXSR      FILL_SUBF
     C                   ENDIF

     C                   MOVEL     *BLANK        DDACNO

      * Write subfile control and foooter

     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCT
     C                   WRITE     FOOTER
     C                   WRITE     SUBFLCTL

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

      * Toggle A/C information

     C     *INKQ         CASEQ     '1'           TOG_ACIN

      * Reselection

     C     DDACNO        CASNE     *BLANK        CONTINUE

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
      * Toggle account information
      *****************************************************************
     C     TOG_ACIN      BEGSR

     C                   SELECT
     C     SHOW_DETL     WHENEQ    '  '
     C                   MOVEL     'CL'          SHOW_DETL
     C                   MOVEL     #_INF(2)      DDNARR
     C     SHOW_DETL     WHENEQ    'CL'
     C                   MOVEL     'CC'          SHOW_DETL
     C                   MOVEL     #_INF(3)      DDNARR
     C     SHOW_DETL     WHENEQ    'CC'
     C                   MOVEL     'OL'          SHOW_DETL
     C                   MOVEL     #_INF(4)      DDNARR
     C     SHOW_DETL     WHENEQ    'OL'
     C                   MOVEL     'OC'          SHOW_DETL
     C                   MOVEL     #_INF(5)      DDNARR
     C                   OTHER
     C                   MOVEL     '  '          SHOW_DETL
     C                   MOVEL     #_INF(1)      DDNARR
     C                   ENDSL

      * Return to top of subfile page

     C                   Z-ADD     ToP_ACNO      ACNO
     C                   Z-ADD     *ZERO         SUBF_RRN

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

     C                   Z-ADD     ToP_ACNO      ACNO
     C                   Z-ADD     *ZERO         SUBF_RRN

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill subfile
      *****************************************************************
     C     FILL_SUBF     BEGSR

     C     DDACNO        IFNE      *BLANK
     C                   MOVEL     DDACNO        ACNO
     C                   ENDIF

     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   Z-ADD     *ZERO         SUBF_RRN

      * Write subfile control

     C                   WRITE     SUBFLCTL                                     *

      * Get first record

     C     ACCNTK        SETLL     ACCNTABF
     C                   READ      ACCNTABF                               99    *
     C                   EXSR      READ4SELECT

      * If not end of file

     C     *IN99         IFEQ      '0'
     C                   Z-ADD     ACNO          ToP_ACNO         10 0
     C                   ELSE
     C                   Z-ADD     *ZERO         ToP_ACNO
     C                   Z-ADD     *ZERO         ACNO

      * Else, if end of file
      * Issue message

     C                   MOVEL     'GLE0001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF

      * Do while not end of file

     C     *IN99         DOWEQ     '0'

     C                   ADD       1             SUBF_RRN          4 0    04    *

      * In error?

     C     AccountID     LOOKUP    RIE                                    65

      * Access Customer

     C                   MOVE      CNUM          WrkCNUM           6
     C                   EXSR      ACS_CUST

      * Access currency details

     C                   EXSR      ACS_CURR

      * Access a/c code details

     C*******************MOVE      ACOD          WrkACOD           4                          BG1769
     C                   MOVE      ACOD          WrkACOD          10                          BG1769
     C                   EXSR      ACS_ACOD

      * Access MEMOS record(s)

     C                   EXSR      ACS_MEMOS

      * Format account details for display

     C                   EXSR      FMT_AC_DTLS

      * Write a record to the subfile

     C                   WRITE     SUBFLREC
     C     SUBF_RRN      IFEQ      NumPerPag
     C                   READ      ACCNTABF                               99    *
     C                   EXSR      READ4SELECT
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         ACNO
     C                   MOVEL     'GLE0001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C                   READ      ACCNTABF                               99    *
     C                   EXSR      READ4SELECT
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         ACNO
     C                   MOVEL     'GLE0001'     ZAMSID
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

     C                   MOVEL     *BLANK        RIE

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Format account details for display
      ********************************************************************
     C     FMT_AC_DTLS   BEGSR

      * Ledger balance

     C                   MOVE      *BLANKS       ZFLD15
     C     SHOW_DETL     IFEQ      'OL'
     C                   MOVE      LDBL          ZFLD15
     C                   ELSE
     C                   MOVE      LDBLN         ZFLD15
     C                   ENDIF
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    DDLDBL           20
     C     RECI          IFNE      'D'
     C                   MOVEL     '* CLOSED *'  DDLDBL
     C                   ENDIF

      * Cleared balance

     C                   MOVE      *BLANKS       ZFLD15
     C     SHOW_DETL     IFEQ      'OC'
     C                   MOVE      CLBL          ZFLD15
     C                   ELSE
     C                   MOVE      CLBLN         ZFLD15
     C                   ENDIF
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    DDCLBL           20
     C     RECI          IFNE      'D'
     C                   MOVEL     '* CLOSED *'  DDCLBL
     C                   ENDIF

      * A/c information

     C                   MOVE      *BLANK        DDACIN
     C     SHOW_DETL     IFEQ      '  '
     C                   EVAL      %subst(DDACIN:1:20) = BBCRNM
     C                   EVAL      %subst(DDACIN:21:17) = A5ACCN
     C                   ELSE
     C                   EVAL      %subst(DDACIN:1:10) = BBCSSN
     C     SHOW_DETL     IFEQ      'CL'
     C     SHOW_DETL     OREQ      'OL'
     C                   EVAL      %subst(DDACIN:14:20) = DDLDBL
     C                   ENDIF
     C     SHOW_DETL     IFEQ      'CC'
     C     SHOW_DETL     OREQ      'OC'
     C                   EVAL      %subst(DDACIN:14:20) = DDCLBL
     C                   ENDIF
     C                   ENDIF

      *Change

     C                   SELECT
     C     SHOW_DETL     WHENEQ    'OL'
     C     LDBL          ANDNE     LDBLN
     C     SHOW_DETL     OREQ      'CL'
     C     LDBL          ANDNE     LDBLN
     C                   EVAL      %subst(DDACIN:39:1) = 'Y'
     C     SHOW_DETL     WHENEQ    'OC'
     C     CLBL          ANDNE     CLBLN
     C     SHOW_DETL     OREQ      'CC'
     C     CLBL          ANDNE     CLBLN
     C                   EVAL      %subst(DDACIN:39:1) = 'Y'
     C                   ENDSL

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Enquire on the record in the subfile
      ********************************************************************
     C     ENQ_SflREC    BEGSR

      * Display the account movements enquiry

     C                   EVAL      I_RACCID = AccountID
     C                   EXSR      AC_MOVMENTS

      * Return to top of subfile page

     C                   Z-ADD     ToP_ACNO      ACNO
     C                   Z-ADD     *ZERO         SUBF_RRN

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Rolldown
      ********************************************************************
     C     ROLLDOWN      BEGSR

     C                   Z-ADD     *ZERO         SUBF_RRN
     C                   Z-ADD     ToP_ACNO      ACNO

     C     ACCNTK        SETGT     ACCNTABF
     C                   READP     ACCNTABF                               99    *
     C                   EXSR      READP4SELECT

      * Read previous
      * until count matches count of records previous read

     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C                   READP     ACCNTABF                               99    *
     C                   EXSR      READP4SELECT
     C                   ADD       1             SUBF_RRN
     C                   ENDDO

      * Issue start of file message

     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         ACNO
     C                   MOVEL     'GLE0002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Read for selection
      *****************************************************************
     C     READ4SELECT   BEGSR
     C     *IN99         DOWEQ     '0'
     C     BRCA          ANDNE     I#BRCA
     C     *IN99         OREQ      '0'
     C     RECI          ANDNE     ClosRecordID
     C     RECI          ANDNE     LiveRecordID
     C     *IN99         OREQ      '0'
     C     LDBL          ANDEQ     0
     C     CLBL          ANDEQ     0
     C     LMVD          ANDLT     InactiveDate
     C                   READ      ACCNTABF                               99    *
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Read previous for branch
      *****************************************************************
     C     READP4SELECT  BEGSR
     C     *IN99         DOWEQ     '0'
     C     BRCA          ANDNE     I#BRCA
     C     *IN99         OREQ      '0'
     C     RECI          ANDNE     ClosRecordID
     C     RECI          ANDNE     LiveRecordID
     C     *IN99         OREQ      '0'
     C     LDBL          ANDEQ     0
     C     CLBL          ANDEQ     0
     C     LMVD          ANDLT     InactiveDate
     C                   READP     ACCNTABF                               99    *
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Display the account movements enquiry
      *****************************************************************
     C     AC_MOVMENTS   BEGSR

     C                   CALL      'GL002010'
     C                   PARM      *BLANK        X_RTCD            7
     C                   PARM      *BLANK        X_ERMS           50
      * INPUT
      * Requested Account ID
      * Account Type
     C                   PARM                    I_RACCID         24
     C                   PARM      A5ACTY        I_ATYP            1

      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1

      * Error
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'A/C MOVEMENTS ENQUIRY FAILED'
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

     C                   MOVEL     'N'           ActnOK
     C                   MOVEL     'GLE0010'     ZAMSID
     C                   EXSR      ZASNMS

     C                   ENDIF

      * If action code not OK, log record in error

     C     ActnOK        IFNE      'Y'
     C                   Z-ADD     1             @RIE              2 0
     C     *BLANK        LOOKUP    RIE(@RIE)                              99
     C                   MOVEL     AccountID     RIE(@RIE)
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
     C                   PARM      'GLUSRMSG'    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Access a customer
      ********************************************************************
     C     ACS_CUST      BEGSR

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WrkCNUM       @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Access a currency
      ********************************************************************
     C     ACS_CURR      BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      '*BLANK '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CCY           @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Access an a/c code
      ********************************************************************
     C     ACS_ACOD      BEGSR

     C                   CALL      'AOACODR0'
     C                   PARM      '*BLANK '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WrkACOD       @ACOD            10                          BG1769
     C     SDACOD        PARM      SDACOD        DSSDY                                        BG1769
     C*******************PARM      WrkACOD       @ACOD             4                          BG1769
     C*****SDACOD********PARM      SDACOD        DSFDY                                        BG1769

     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Access MEMOS record
      ********************************************************************
     C     ACS_MEMOS     BEGSR

     C     ACCNTK_BR     CHAIN     MEMOSMDF                           60        *
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
     C**********         MOVE      'CR'          ZOUT21Edit                                 MD046682
     C                   MOVE      'CR'          ZOUT2122CR                                 MD046682
     C                   ELSE
     C                   MOVE      '  '          ZOUT21Edit
     C                   MOVE      '  '          ZOUT2122CR                                 MD046682
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Return code
      * Error Message
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * Branch
     C                   PARM                    I#BRCA            3
      * Omit closed a/cs
      * Activity months
     C                   PARM                    I#OMCL            1
     C                   PARM                    I#ACMN            2
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1

     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL

      * Initialize program name

     C                   MOVEL     'GL002004 '   DDPGM

      * Set up subfile message queue information

     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40

      * Set up standard screen fields.

     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR

      *  Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   MOVEL     '  '          SHOW_DETL         2
     C                   EXSR      TOG_ACIN

     C                   MOVEL     'C'           ClosRecordID      1
     C                   MOVEL     'D'           LiveRecordID      1
     C     I#OMCL        IFEQ      'Y'
     C                   MOVEL     ' '           ClosRecordID
     C                   ENDIF

     C     I#ACMN        IFNE      *BLANK
     C                   MOVE      I#ACMN        ActivityDays      5 0
     C                   MULT      31            ActivityDays
     C     BJRDNB        SUB       ActivityDays  InactiveDate      5 0
     C                   ELSE
     C                   Z-ADD     *ZERO         InactiveDate
     C                   ENDIF

      * Key list

     C     ACCNTK        KLIST
     C                   KFLD                    ACNO
     C     ACCNTK_ME     KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C     ACCNTK_BR     KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
** #_INF
Customer            Account Code
Customer   CLOSING Ledger Balance  Change
Customer   CLOSING Cleared Balance Change
Customer   OPENING Ledger Balance  Change
Customer   OPENING Cleared Balance Change
