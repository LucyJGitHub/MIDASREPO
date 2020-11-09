     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management A/c Movements Enquiry')       *
     x*****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100453 - Cash Management Account Movements Enquiry         *
      *                                                               *
      *  Function: This module allows enquiry into account movements. *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BG8539             Date 15Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 215678             Date 10Mar03               *
      *                 213738             Date 22Jan03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG8539 - Screen not dispaly properly in WebFacing            *
      *           Change the write/read order so that the last        *
      *           written format is not the footer before the READ    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  215678 - Wrong posting date displayed                        *
      *  213738 - Show pooling narrative on F16                       *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************

     FRE100453DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:RRN)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACCNTABF)
     FAPOSTL1   IF   E           K DISK    INFSR(*PSSR)
     FPMHPOSL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:APOSTPDX)
     F                                     RENAME(GLACPHPF:GLACPHPX)
     FRSACMTL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:CLEARPDF)
     F                                     PREFIX(E_)
     FGLAPSGAL0 IF   E           K DISK    INFSR(*PSSR)
     FGLAPSZSL0 IF   E           K DISK    INFSR(*PSSR)
     FGLPSTZSL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLAPZSD0: GLPSTZSD0)
     FGLPSTGAL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLAPGAD0: GLPSTGAD0)
     F/COPY WNCPYSRC,RE100453F1                                                 213738

      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************


      * Account ID
     D                 DS
     D***ACCID**                 1     18                                                     CGL029
     D ACCID                   1     24                                                       CGL029
     D BRC                     1      3
     D*CUS******               4      9S 0                                                    CSD027
     D CUS                     4      9                                                       CSD027
     D CCY                    10     12
     D***ACD****                13     16S 0                                                  CGL029
     D***ASN****                17     18S 0                                                  CGL029
     D ACD                    13     22S 0                                                    CGL029
     D ASN                    23     24S 0                                                    CGL029


      * Posting
     D                 DS
     D POSTING                 1    100
     D DDACTN                  1      1
     D EPSTD                   2      8
     D EVALD                   9     15
     D EPNAR                  16     45
     D EPSTA                  46     63
     D EDRCR                  64     64
     D ESPOS                  65     69
     D EXRFI                  70     72


      * Selection
     D                 DS
     D SELECT                  1    100
     D DDPSTD                  1      6
     D DDVALD                  7     12
     D DDPNAR                 13     42
     D DDPSTA                 43     60
     D DDDRCR                 61     61
     D DDSPOS                 62     66
     D DDXRFI                 67     69

      * Previous Selection
     D                 DS
     D P_SELECT                1    100


     D                 DS
     D ZOUT21                  1     21
     D ZOUT21Sign             21     21
     D ZOUT21Edit              1     22


      *  Layout for data area JNSTAT
     D JNSTAT        E DS                  EXTNAME(JNSTAT)


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs


     IRSACMTPO      01
     I              PTDT                        PSTD
     I              VUDT                        VALD
     I              NRTD                        PNAR
     I              MVAM                        PSTA
     I              DORC                        DRCR
     I              XRFI                        XRFI
     I              XRFN                        XRFN
     IFFACMVDF      02
     I              PTDT                        PSTD
     I              VUDT                        VALD
     I              NRTD                        PNAR
     I              MVAM                        PSTA
     I              DORC                        DRCR
     I              XRFI                        XRFI
     I              XRFN                        XRFN
     I              NRTC                        ZZNRTC
     ICLEARPDF      03
     I              PSTD                        PSTD
     I              VALD                        VALD
     I              PNAR                        PNAR
     I              PSTA                        PSTA
     I              DRCR                        DRCR
     I              SPOS                        SPOS
     I              XRFI                        XRFI
     I              XRFN                        XRFN


      /SPACE 5

      * Requested Account ID

     C                   MOVEL     I_RACCID      ACCID
     C                   MOVE      CUS           WrkCUS            6
     C**********         MOVE      ACD           WrkACD            4                          CGL029
     C                   MOVE      ACD           WrkACD           10                          CGL029
     C                   MOVE      ASN           WrkASN            2
     C                   EVAL      DDACC  = BRC  +  '-'  +  WrkCUS   +  '-'
     C                                      +  CCY  +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN

      * Access Account

     C                   EXSR      ACS_ACCNT

      * Access Customer

     C                   EXSR      ACS_CUST

      * Access Currency

     C                   EXSR      ACS_CURR

      * Convert previous run date to DD/MM/YY format
      * and set the screen value date or posting date equal to this

     C                   Z-ADD     PRUN          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATEN        PrevRunDate       6
     C     PSTD_VALD     IFEQ      'P'
     C                   MOVE      PrevRunDate   DDPSTD
     C                   ELSE
     C                   MOVE      PrevRunDate   DDVALD
     C                   ENDIF

      * Fill the subfile with movements

     C                   Z-ADD     PRUN          ReadFromDate
     C     PSTD_VALD     IFEQ      'P'
     C                   EXSR      DET_BF_LDBL
     C                   EXSR      FILL_SUBPD
     C                   ELSE
     C                   EXSR      DET_BF_CLBL
     C                   EXSR      FILL_SUBVD
     C                   ENDIF

      * Display screen until F3, or F12 taken

     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END

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

     C     PSTD_VALD     IFEQ      'P'
     C                   EVAL      DDPV = 'BY POSTING DATE'
     C                   MOVE      *ON           *IN50
     C                   ELSE
     C                   EVAL      DDPV = 'BY VALUE DATE  '
     C                   MOVE      *OFF          *IN50
     C                   ENDIF

     C                   MOVEL     SELECT        P_SELECT
     C                   MOVEL     EXTD_NARR     P_EXTD_NARR       1

      * Write and read screen

     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCT
     C**********         WRITE     SUBFLCTL                                                   BG8539
     C                   WRITE     FOOTER
     C                   WRITE     SUBFLCTL                                                   BG8539

      * Read subfile control

     C                   READ      SUBFLCTL                               99    *

      ** Clear the message queue & init error indicators

     C                   EXSR      CLR_MSGQ

      ** Toggle Extended Narrative

     C     *INKQ         IFEQ      '1'
     C     EXTD_NARR     IFEQ      'Y'
     C                   MOVE      'N'           EXTD_NARR
     C                   ELSE
     C                   MOVE      'Y'           EXTD_NARR
     C                   ENDIF
     C                   ENDIF

      ** Toggle Entry Sequence

     C     *INKS         IFEQ      '1'
     C     PSTD_VALD     IFEQ      'P'
     C                   MOVE      'V'           PSTD_VALD
     C                   MOVE      DDPSTD        DDVALD
     C                   MOVE      *BLANK        DDPSTD
     C                   ELSE
     C                   MOVE      'P'           PSTD_VALD
     C                   MOVE      DDVALD        DDPSTD
     C                   MOVE      *BLANK        DDVALD
     C                   ENDIF
     C                   ENDIF

      ** Interest Statement Enquiry

     C     *INKU         IFEQ      '1'
     C                   EXSR      INT_STAT_ENQ
     C                   MOVE      @INKC         *INKC
     C                   ELSE

      ** Outgoing Messages Enquiry

     C     *INKW         IFEQ      '1'
     C                   EXSR      OUT_MSGS_ENQ
     C                   MOVE      @INKC         *INKC
     C                   ELSE

      ** If selection has changed and it's valid
      ** or if extended narrative display has changed
      ** Re-Determine B/F Ledger or Cleared Balance
      ** Re-fill the subfile with the movements

     C     *INKC         IFNE      '1'
     C     *INKL         ANDNE     '1'
     C                   EXSR      VALID_SELECT
     C     SELECT        IFNE      P_SELECT
     C     Valid         ANDEQ     'Y'
     C     EXTD_NARR     ORNE      P_EXTD_NARR
     C     Valid         ANDEQ     'Y'
     C     PSTD_VALD     IFEQ      'P'
     C                   EXSR      DET_BF_LDBL
     C                   EXSR      FILL_SUBPD
     C                   ELSE
     C                   EXSR      DET_BF_CLBL
     C                   EXSR      FILL_SUBVD
     C                   ENDIF
     C                   ENDIF

      * Check for a record selected from the subfile

     C     *IN(04)       CASEQ     '0'           CHK_SUBF
     C                   END

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Determine B/F Ledger Balance
      *****************************************************************
     C     DET_BF_LDBL   BEGSR

     C                   Z-ADD     LDBL          BFBal            15 0

      * Read all postings for a/c from Read From Date

     C     APOSTKF       SETLL     APOSTL1
     C     APOSTK        READE     APOSTL1                                99    *

      * Do while postings found

     C     *IN99         DOWEQ     '0'
     C     DRCR          IFEQ      0
     C                   SUB       PSTA          BFBal
     C                   ELSE
     C                   ADD       PSTA          BFBal
     C                   ENDIF
     C     APOSTK        READE     APOSTL1                                99    *
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Determine B/F Cleared Balance
      *****************************************************************
     C     DET_BF_CLBL   BEGSR

     C                   Z-ADD     LDBL          BFBal            15 0

      * Read all postings for a/c from Read From Date

     C     APOSTKF       SETLL     PMHPOSL1
     C     APOSTK        READE     PMHPOSL1                               99    *

      * Do while postings found

     C     *IN99         DOWEQ     '0'
     C     DRCR          IFEQ      0
     C                   SUB       PSTA          BFBal
     C                   ELSE
     C                   ADD       PSTA          BFBal
     C                   ENDIF
     C     APOSTK        READE     PMHPOSL1                               99    *
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Fill the subfile with posting date movements
      *****************************************************************
     C     FILL_SUBPD    BEGSR

     C                   Z-ADD     BFBal         CFBal            15 0

      * Clear subfile
     C                   MOVEA     '000'         *IN(11)
     C                   Z-ADD     *ZERO         RRN
     C                   WRITE     SUBFLCTL                                     *

      * Format B/F Ledger Balance
      * Output B/F Ledger Balance

     C                   EXSR      FMT_BF_LDBL
     C                   ADD       1             RRN               4 0          *
     C                   WRITE     SUBFLREC

      * Read all postings for a/c

     C     APOSTKF       SETLL     APOSTL1
     C     APOSTK        READE     APOSTL1                                99    *
     C  N99              Z-ADD     PSTD          PrevBalDate       5 0

      * Do while postings found

     C     *IN99         DOWEQ     '0'

      * Format Extended Narrative

     C     EXTD_NARR     IFEQ      'Y'
     C                   EXSR      FMT_EXTD_NARR
     C                   ENDIF

      * Check if record to be selected

     C                   EXSR      CHK_SELECT

     C     RecdSelect    IFEQ      'Y'

      * Format C/F Ledger Balance
      * Output C/F Ledger Balance

     C     PSTD          IFGT      PrevBalDate
     C                   MOVEL     'INTERIMCLOS' OPEN_CLOS
     C                   EXSR      FMT_CF_LDBL
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC
     C                   ENDIF

     C                   EXSR      FMT_POSTING
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC
     C                   SETOFF                                       24
     C                   ENDIF

     C     DRCR          IFEQ      0
     C                   ADD       PSTA          CFBal
     C                   ELSE
     C                   SUB       PSTA          CFBal
     C                   ENDIF

     C                   Z-ADD     PSTD          PrevBalDate

     C     APOSTK        READE     APOSTL1                                99    *
     C                   ENDDO

      * Format TODAY'S C/F OPENING Ledger Balance
      * Output C/F OPENING Ledger Balance

     C                   MOVEL     'TODAYSOPEN ' OPEN_CLOS        11
     C                   EXSR      FMT_CF_LDBL
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC

      * Read a/c movements for a/c

     C     APOSTK        SETLL     RSACMTL6
     C                   SETOFF                                       010203
     C     APOSTK        READE     RSACMTL6                               99    *

      * Do while a/c movements found

     C     *IN99         DOWEQ     '0'

     C     *in01         IFEQ      '1'
     C     *in02         OREQ      '1'

     C                   Z-ADD     BJRDNB        PSTD
     C                   MOVEL     *BLANK        SPOS
     C     PNAR          IFEQ      *BLANK
     C                   EVAL      PNAR = E_TRYP + ' ' + E_TNMR
     C                   ENDIF

     C     DRCR          IFEQ      0
     C                   ADD       PSTA          CFBal
     C                   ELSE
     C                   SUB       PSTA          CFBal
     C                   ENDIF

      * Format Extended Narrative

     C     EXTD_NARR     IFEQ      'Y'
     C                   EXSR      FMT_EXTD_NARR
     C                   ENDIF

      * Check if record to be selected

     C                   EXSR      CHK_SELECT

     C     RecdSelect    IFEQ      'Y'
     C                   EXSR      FMT_POSTING
     C                   ADD       1             RRN                  25        *
     C                   MOVEL     'RSACMTPD'    SRCFIL
     C                   WRITE     SUBFLREC
     C                   MOVEL     *BLANK        SRCFIL
     C                   SETOFF                                       2425
     C                   ENDIF
     C                   ENDIF

     C                   SETOFF                                       010203
     C     APOSTK        READE     RSACMTL6                               99    *
     C                   ENDDO

      * Format TODAY'S C/F CLOSING Ledger Balance
      * Output C/F CLOSING Ledger Balance

     C                   MOVEL     'TODAYSCLOS ' OPEN_CLOS
     C                   EXSR      FMT_CF_LDBL
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC

      * Reset subfile

     C                   MOVEA     '111'         *IN(11)

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Fill the subfile with value date movements
      *****************************************************************
     C     FILL_SUBVD    BEGSR

     C                   Z-ADD     BFBal         CFBal

      * Clear subfile
     C                   MOVEA     '000'         *IN(11)
     C                   Z-ADD     *ZERO         RRN
     C                   WRITE     SUBFLCTL                                     *

      * Format B/F Cleared Balance
      * Output B/F Cleared Balance

     C                   EXSR      FMT_BF_CLBL
     C                   ADD       1             RRN               4 0          *
     C                   WRITE     SUBFLREC

      * Read all postings for a/c

     C     APOSTKF       SETLL     PMHPOSL1
     C     APOSTK        READE     PMHPOSL1                               99    *
     C  N99              Z-ADD     VALD          PrevBalDate       5 0

      * Do while postings found

     C     *IN99         DOWEQ     '0'

      * Only include postings with a value date prior to today

     C     VALD          IFLT      BJRDNB

      * Format Extended Narrative

     C     EXTD_NARR     IFEQ      'Y'
     C                   EXSR      FMT_EXTD_NARR
     C                   ENDIF

      * Check if record to be selected

     C                   EXSR      CHK_SELECT

     C     RecdSelect    IFEQ      'Y'

      * Format C/F Cleared Balance
      * Output C/F Cleared Balance

     C     VALD          IFGT      PrevBalDate
     C                   MOVEL     'INTERIMCLOS' OPEN_CLOS
     C                   EXSR      FMT_CF_CLBL
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC
     C                   ENDIF

     C                   EXSR      FMT_POSTING
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC
     C                   SETOFF                                       24
     C                   ENDIF

     C     DRCR          IFEQ      0
     C                   ADD       PSTA          CFBal
     C                   ELSE
     C                   SUB       PSTA          CFBal
     C                   ENDIF

     C                   ENDIF

     C                   Z-ADD     VALD          PrevBalDate

     C     APOSTK        READE     PMHPOSL1                               99    *
     C                   ENDDO

      * Format TODAY'S C/F OPENING Cleared Balance
      * Output C/F OPENING Cleared Balance

     C                   MOVEL     'TODAYSOPEN ' OPEN_CLOS
     C                   EXSR      FMT_CF_CLBL
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC

     C                   MOVE      'N'           CLOS_Output       1

      * Read a/c movements for a/c

     C     APOSTK        SETLL     RSACMTL6
     C                   SETOFF                                       010203
     C     APOSTK        READE     RSACMTL6                               99    *

      * Do while a/c movements found

     C     *IN99         DOWEQ     '0'

      * Once a posting has been read beyond the current run date

     C     VALD          IFGE      BJDNWD
     C     CLOS_Output   ANDNE     'Y'

      * Format TODAY'S C/F CLOSING Cleared Balance
      * Output C/F CLOSING Cleared Balance

     C                   MOVEL     'TODAYSCLOS ' OPEN_CLOS
     C                   EXSR      FMT_CF_CLBL
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC

     C                   MOVE      'Y'           CLOS_Output
     C                   ENDIF

     C  N03              Z-ADD     BJRDNB        PSTD
     C  N03              MOVEL     *BLANK        SPOS
     C  N03PNAR          IFEQ      *BLANK
     C                   EVAL      PNAR = E_TRYP + ' ' + E_TNMR
     C                   ENDIF

     C     DRCR          IFEQ      0
     C                   ADD       PSTA          CFBal
     C                   ELSE
     C                   SUB       PSTA          CFBal
     C                   ENDIF

      * Format Extended Narrative

     C     EXTD_NARR     IFEQ      'Y'
     C                   EXSR      FMT_EXTD_NARR
     C                   ENDIF

      * Check if record to be selected

     C                   EXSR      CHK_SELECT

     C     RecdSelect    IFEQ      'Y'
     C                   EXSR      FMT_POSTING
     C                   ADD       1             RRN                  25        *
     C                   MOVEL     'RSACMTPD'    SRCFIL
     C                   WRITE     SUBFLREC
     C                   MOVEL     *BLANK        SRCFIL
     C                   SETOFF                                       2425
     C                   ENDIF

     C                   SETOFF                                       010203
     C     APOSTK        READE     RSACMTL6                               99    *
     C                   ENDDO

      * If no posting was read beyond the current run date

     C     CLOS_Output   IFNE      'Y'

      * Format TODAY'S C/F CLOSING Cleared Balance
      * Output C/F CLOSING Cleared Balance

     C                   MOVEL     'TODAYSCLOS ' OPEN_CLOS
     C                   EXSR      FMT_CF_CLBL
     C                   ADD       1             RRN                            *
     C                   WRITE     SUBFLREC

     C                   ENDIF

      * Reset subfile

     C                   MOVEA     '111'         *IN(11)

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Format B/F Ledger Balance
      *****************************************************************
     C     FMT_BF_LDBL   BEGSR

     C                   MOVEL     *BLANK        POSTING

      * Posting date = Read From Date

     C                   Z-ADD     ReadFromDate  ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        EPSTD

      * Value date
     C                   MOVE      '------>'     EVALD

      * Posting narrative

     C                   EVAL      EPNAR = 'OPENING LEDGER BALANCE ------>'

      * Posting amount

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      BFBal         ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    EPSTA

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Format B/F Cleared Balance
      *****************************************************************
     C     FMT_BF_CLBL   BEGSR

     C                   MOVEL     *BLANK        POSTING

      * Posting date
     C                   MOVE      '------>'     EPSTD

      * Value date = Read From Date

     C                   Z-ADD     ReadFromDate  ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        EVALD

      * Posting narrative

     C                   EVAL      EPNAR = 'OPENING CLEARED BALANCE ----->'

      * Posting amount

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      BFBal         ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    EPSTA

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Format Posting
      *****************************************************************
     C     FMT_POSTING   BEGSR

     C                   MOVEL     *BLANK        POSTING

      * Posting date

     C                   Z-ADD     PSTD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        EPSTD

      * Value date

     C                   Z-ADD     VALD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        EVALD

      * Blank out one date if they are equal

     C     DDPSTD        IFEQ      DDVALD
     C     PSTD_VALD     IFEQ      'P'
     C                   MOVEL     *BLANK        DDVALD
     C                   ELSE
     C                   MOVEL     *BLANK        DDPSTD
     C                   ENDIF
     C                   ENDIF

      * Posting narrative

     C                   MOVE      PNAR          EPNAR

      * Posting amount

     C     DRCR          IFEQ      1
     C                   Z-SUB     PSTA          W_AMT            13 0
     C                   ELSE
     C                   Z-ADD     PSTA          W_AMT
     C                   ENDIF
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      W_AMT         ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    EPSTA

      * Source of posting

     C                   MOVE      SPOS          ESPOS

      * Extension file reference ID

     C                   MOVE      XRFI          EXRFI
     C     EXRFI         COMP      'GA '                                  24
     C  N24EXRFI         COMP      'ZS '                                  24

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Format Extended Narrative
      *****************************************************************
     C     FMT_EXTD_NARR BEGSR

     C                   SETON                                        99
     C     XRFI          IFEQ      'ZS'
     C     EXTSNK        CHAIN     GLAPZSD0                           99        *
     C   99EXTSNK        CHAIN     GLPSTZSD0                          99        *
     C                   ELSE
     C     XRFI          IFEQ      'GA'
     C     EXTSNK        CHAIN     GLAPGAD0                           99        *
     C   99EXTSNK        CHAIN     GLPSTGAD0                          99        *
     C/COPY WNCPYSRC,RE100453C1                                                 213738
     C                   ENDIF
     C                   ENDIF

     C     *IN99         CABEQ     '1'           EFMT_EXTD_NARR

     C     XRFI          IFEQ      'ZS'
     C                   EXSR      EDIT_ZS
     C                   ELSE
     C/COPY WNCPYSRC,RE100453C2                                                 213738
     C                   EXSR      EDIT_GA
     C                   ENDIF
     C/COPY WNCPYSRC,RE100453C3                                                 213738

     C     EFMT_EXTD_NARRENDSR
      ********************************************************************
     C/COPY WNCPYSRC,RE100453C4                                                 213738
      /SPACE 5
      ********************************************************************
      * Edit Zero Balancing/Sweeping Fields
      ********************************************************************
     C     EDIT_ZS       BEGSR

      * Account

     C                   MOVEL     *BLANK        W_ACC            22
     C                   MOVE      AZACUS        WrkCUS            6
     C**********         MOVE      AZAACD        WrkACD            4                          CGL029
     C                   MOVE      AZAACD        WrkACD                                       CGL029
     C                   MOVE      AZAASN        WrkASN            2
     C                   EVAL      W_ACC = AZABRC + '-' + WrkCUS
     C                                     + '-' + AZACCY + '-' + WrkACD
     C                                     + '-' + WrkASN

      * Account retail number

     C                   MOVEL     AZARNO        W_RAN            10

      * External account number

     C                   Z-ADD     0             S1                3 0
     C                   Z-ADD     0             S2                3 0
     C                   Z-ADD     0             X                 3 0
     C                   MOVEL     *BLANK        W_EXTA           25
     C                   EVAL      S1 = %scan('/' : AZF861 : 1)
     C                   IF        S1 > 0
     C                   EVAL      S2 = %scan('/' : AZF861 : S1 + 2)
     C                   IF        S2 > 0
     C                   EVAL      W_EXTA = %subst(AZF861: S1 + 1 : S2-S1-1)
     C                   ELSE
     C                   EVAL      W_EXTA = %subst(AZF861: S1 + 1 : 25)
     C                   ENDIF
     C                   ENDIF

      * Text

     C                   SELECT
     C     AZASDA        WHENEQ    'S'
     C     AZTPSW        ANDEQ     'T'
     C     W_EXTA        IFNE      *BLANK
     C                   EVAL      PNAR  = 'TOP TO ' + W_EXTA
     C                   ELSE
     C     AZARNO        IFEQ      *ZERO
     C                   EVAL      PNAR  = 'TOP TO ' + W_ACC
     C                   ELSE
     C                   EVAL      PNAR  = 'TOP TO ' + W_RAN
     C                   ENDIF
     C                   ENDIF
     C     AZASDA        WHENEQ    'S'
     C     AZTPSW        ANDEQ     'S'
     C     W_EXTA        IFNE      *BLANK
     C                   EVAL      PNAR  = 'SWEEP FROM ' + W_EXTA
     C                   ELSE
     C     AZARNO        IFEQ      *ZERO
     C                   EVAL      PNAR  = 'SWP FRM ' + W_ACC
     C                   ELSE
     C                   EVAL      PNAR  = 'SWEEP FROM ' + W_RAN
     C                   ENDIF
     C                   ENDIF
     C     AZASDA        WHENEQ    'D'
     C     AZTPSW        ANDEQ     'T'
     C     W_EXTA        IFNE      *BLANK
     C                   EVAL      PNAR  = 'TOP FROM ' + W_EXTA
     C                   ELSE
     C     AZARNO        IFEQ      *ZERO
     C                   EVAL      PNAR  = 'TOP FRM ' + W_ACC
     C                   ELSE
     C                   EVAL      PNAR  = 'TOP FROM ' + W_RAN
     C                   ENDIF
     C                   ENDIF
     C     AZASDA        WHENEQ    'D'
     C     AZTPSW        ANDEQ     'S'
     C     W_EXTA        IFNE      *BLANK
     C                   EVAL      PNAR  = 'SWEEP TO ' + W_EXTA
     C                   ELSE
     C     AZARNO        IFEQ      *ZERO
     C                   EVAL      PNAR  = 'SWP TO ' + W_ACC
     C                   ELSE
     C                   EVAL      PNAR  = 'SWEEP TO ' + W_RAN
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL

     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Edit Group A/c Hierarchy Fields
      ********************************************************************
     C     EDIT_GA       BEGSR

      * Source account

     C                   MOVEL     *BLANK        SrcACC           23
     C                   MOVE      AGSCUS        WrkCUS            6
     C**********         MOVE      AGSACD        WrkACD            4                          CGL029
     C                   MOVE      AGSACD        WrkACD                                       CGL029
     C                   MOVE      AGSASN        WrkASN            2
     C                   EVAL      SrcACC = '<'   + AGSBRC + '-' + WrkCUS
     C                                      + '-' + AGSCCY + '-' + WrkACD
     C                                      + '-' + WrkASN

      * Source account retail number

     C                   MOVEL     '<'           SrcRAN           11
     C                   MOVE      AGSRNO        SrcRAN

     C     AGSRNO        IFNE      *ZERO
     C                   MOVE      SrcRAN        PNAR
     C                   ELSE
     C                   MOVE      SrcACC        PNAR
     C                   ENDIF

     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *****************************************************************
      * Format C/F Ledger Balance
      *****************************************************************
     C     FMT_CF_LDBL   BEGSR

     C                   MOVEL     *BLANK        POSTING

      * Posting date = Todays's Date

     C                   SELECT
     C     OPEN_CLOS     WHENEQ    'TODAYSOPEN '
     C                   Z-ADD     BJRDNB        ZDAYNO
     C     OPEN_CLOS     WHENEQ    'TODAYSCLOS '
     C                   Z-ADD     BJRDNB        ZDAYNO
     C     OPEN_CLOS     WHENEQ    'INTERIMCLOS'
     C                   Z-ADD     PrevBalDate   ZDAYNO
     C                   ENDSL
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        EPSTD

      * Value date
     C                   MOVE      '------>'     EVALD

      * Posting narrative

     C                   SELECT
     C     OPEN_CLOS     WHENEQ    'TODAYSOPEN '
     C                   EVAL      EPNAR = 'TODAY''S OPENING LEDGER BALANCE'
     C     OPEN_CLOS     WHENEQ    'TODAYSCLOS '
     C                   EVAL      EPNAR = 'TODAY''S CLOSING LEDGER BALANCE'
     C     OPEN_CLOS     WHENEQ    'INTERIMCLOS'
     C                   EVAL      EPNAR = 'CLOSING LEDGER BALANCE ------>'
     C                   ENDSL

      * Posting amount

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      CFBal         ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    EPSTA

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Format C/F Cleared Balance
      *****************************************************************
     C     FMT_CF_CLBL   BEGSR

     C                   MOVEL     *BLANK        POSTING

      * Posting date
     C                   MOVE      '------>'     EPSTD

      * Value date

     C                   SELECT
     C     OPEN_CLOS     WHENEQ    'TODAYSOPEN '
     C                   Z-ADD     BJRDNB        ZDAYNO
     C     OPEN_CLOS     WHENEQ    'TODAYSCLOS '
     C     BJDNWD        SUB       1             ZDAYNO
     C     OPEN_CLOS     WHENEQ    'INTERIMCLOS'
     C                   Z-ADD     PrevBalDate   ZDAYNO
     C                   ENDSL
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        EVALD

      * Posting narrative

     C                   SELECT
     C     OPEN_CLOS     WHENEQ    'TODAYSOPEN '
     C                   EVAL      EPNAR = 'TODAYS OPENING CLEARED BALANCE'
     C     OPEN_CLOS     WHENEQ    'TODAYSCLOS '
     C                   EVAL      EPNAR = 'TODAYS CLOSING CLEARED BALANCE'
     C     OPEN_CLOS     WHENEQ    'INTERIMCLOS'
     C                   EVAL      EPNAR = 'CLOSING CLEARED BALANCE ----->'
     C                   ENDSL

      * Posting amount

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      CFBal         ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    EPSTA

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Check if record to be selected
      *****************************************************************
     C     CHK_SELECT    BEGSR

     C                   MOVEL     'Y'           RecdSelect        1

      * Posting narrative

     C     DDPNAR        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    PNAR
      * Length
     C                   PARM      30            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    DDPNAR
      * Length
     C                   PARM      30            WQC3N             3 0
      * Translate
     C                   PARM      '1'           WQD1              1
      * Trim
     C                   PARM      '1'           WQE1              1
      * Wild
     C                   PARM      '?'           WQF1              1
      * Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         IFLT      1
     C                   MOVEL     'N'           RecdSelect
     C                   ENDIF
     C                   ENDIF

      * Posting Amount

     C     SelectPSTA    IFNE      *ZERO
     C     PSTA          IFNE      SelectPSTA
     C                   MOVEL     'N'           RecdSelect
     C                   ENDIF
     C                   ENDIF

      * Debit/credit indicator

     C     SelectDRCR    IFNE      9
     C     DRCR          IFNE      SelectDRCR
     C                   MOVEL     'N'           RecdSelect
     C                   ENDIF
     C                   ENDIF

      * Source of posting

     C     DDSPOS        IFNE      *BLANK
     C                   MOVE      SPOS          W_SPOS            5
     C     W_SPOS        IFNE      DDSPOS
     C                   MOVEL     'N'           RecdSelect
     C                   ENDIF
     C                   ENDIF

      * Reference ID

     C     DDXRFI        IFNE      *BLANK
     C     DDXRFI        IFNE      '*  '
     C     DDXRFI        ANDNE     XRFI
     C     DDXRFI        OREQ      '*  '
     C     'ZS '         ANDEQ     XRFI
     C     DDXRFI        OREQ      '*  '
     C     'GA '         ANDEQ     XRFI
     C                   MOVEL     'N'           RecdSelect
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Validate selection
      *****************************************************************
     C     VALID_SELECT  BEGSR

     C                   MOVE      'Y'           Valid             1

      * Posting date must be a valid date
      * ---------------------------------
      * (default it to the previous run date if it is not defined)

     C     PSTD_VALD     IFEQ      'P'

     C     DDPSTD        IFEQ      *BLANK
     C                   MOVE      PrevRunDate   DDPSTD
     C                   ENDIF

     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDPSTD        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0

     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   EXSR      ZDATE1
     C                   END

      * If either ZALIGN and ZDATE1 errors
      * 'Invalid Posting Date'

     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'RE75950 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE

      * If after the run date
      * 'Posting Date can't be after the run date'

     C                   Z-ADD     ZDAYNO        ReadFromDate
     C     ReadFromDate  IFGT      BJRDNB
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'RE75951 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C                   END

      * Value date must be a valid date
      * -------------------------------
      * (default it to the previous run date if it is not defined)

     C     PSTD_VALD     IFEQ      'V'

     C     DDVALD        IFEQ      *BLANK
     C                   MOVE      PrevRunDate   DDVALD
     C                   ENDIF

     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDVALD        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0

     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   EXSR      ZDATE1
     C                   END

      * If either ZALIGN and ZDATE1 errors
      * 'Invalid Value Date'

     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN52
     C                   MOVEL     'RE75952 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE

      * If after the run date
      * 'Value Date can't be after the run date'

     C                   Z-ADD     ZDAYNO        ReadFromDate
     C     ReadFromDate  IFGT      BJRDNB
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN52
     C                   MOVEL     'RE75953 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C                   END

      * If entered, posting amount must be valid

     C     DDPSTA        IFNE      *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDPSTA        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM      13            ZADIG             2 0

     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        SelectPSTA       13 0
     C                   ELSE
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN53
     C                   MOVEL     'RE75954 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   END

     C                   ELSE
     C                   Z-ADD     *ZERO         SelectPSTA
     C                   END

      * If entered, debit/credit indicator must be valid

     C     DDDRCR        IFNE      *BLANK
     C     DDDRCR        ANDNE     'D'
     C     DDDRCR        ANDNE     'C'
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN54
     C                   MOVEL     'RE75955 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     9             SelectDRCR        1 0
     C     DDDRCR        IFEQ      'D'
     C                   Z-ADD     0             SelectDRCR
     C                   ELSE
     C     DDDRCR        IFEQ      'C'
     C                   Z-ADD     1             SelectDRCR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      ** Interest Statement Enquiry
      *****************************************************************
     C     INT_STAT_ENQ  BEGSR

      * Call the Cash Management Interest Statement Enquiry

     C                   CALL      'RE100454'

      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS

      * Requested Account ID
     C**********         PARM                    I_RACCID         18                          CGL029
     C                   PARM                    I_RACCID         24                          CGL029
      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1

      * Error
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ENQUIRY FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      ** Outgoing Message Enquiry
      *****************************************************************
     C     OUT_MSGS_ENQ  BEGSR

      * Call the Cash Management Outgoing Messages Enquiry

     C                   CALL      'RE100456'

      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Link ID
     C                   PARM                    I_LINK            9 0
      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1

      * Error
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ENQUIRY FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF

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
     C                   EXSR      ENQ_SflREC
     C     RRN           CHAIN     SUBFLREC                           99
     C                   MOVEL     *BLANK        DDACTN
     C                   SETON                                        2324
     C     SRCFIL        COMP      'RSACMTPD'                             25
     C                   UPDATE    SUBFLREC
     C                   SETOFF                                       232425
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

     C                   MOVEL     *BLANK        SRCFIL

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Enquire on the record in the subfile
      ********************************************************************
     C     ENQ_SflREC    BEGSR

      * Call the Cash Management Posting Details Enquiry

     C                   CALL      'RE100455'

      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Account
      * Retail A/c Number
      * Account Name
     C**********         PARM      DDACC         I_ACC            22                          CGL029
     C                   PARM      DDACC         I_ACC            28                          CGL029
     C                   PARM      DDRAN         I_RAN            10
     C                   PARM      DDANAM        I_ANAM           20
      * Customer Report Name
      * Customer Report Town
     C                   PARM      BBCRNM        I_CRNM           20
     C                   PARM      BBCRTN        I_CRTN           10
      * Posting Date
      * Value Date
      * Posting Narrative
      * Posting amount
     C                   PARM      EPSTD         I_PSTD            7
     C                   PARM      EVALD         I_VALD            7
     C                   PARM      EPNAR         I_PNAR           30
     C                   PARM      EPSTA         I_PSTA           18
      * Reference ID
      * Reference Number
     C                   PARM      EXRFI         I_XRFI            3
     C                   PARM      XRFN          I_XRFN           10 0

      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1

      * Error
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ENQUIRY FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      ** Clear the message queue & init error indicators
      *****************************************************************
     C     CLR_MSGQ      BEGSR

     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5

     C                   MOVEA     '000000'      *IN(51)

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Access a/c details
      ********************************************************************
     C     ACS_ACCNT     BEGSR

     C     ACCNTK        CHAIN     ACCNTABF                           60        *
     C  N60              MOVEL     ACNO          DDRAN
     C  N60              MOVEL     ANAM          DDANAM
     C   60              MOVEL     *BLANK        DDRAN
     C   60              MOVEL     *BLANK        DDANAM

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
      * Convert a date into a day number
      ********************************************************************
     C     ZDATE1        BEGSR
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      'N'           ErrorFlag         1
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert a day number into a date
      ********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * Edit a signed field
      *****************************************************************
     C     ZSEDIT        BEGSR
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM                    ZOUT21           21
     C     ZOUT21Sign    IFEQ      '-'
     C                   MOVE      'CR'          ZOUT21Edit
     C                   ELSE
     C                   MOVE      '  '          ZOUT21Edit
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
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      * Return code
      * Error Message
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * Link ID
     C                   PARM                    I_LINK            9 0

      * Requested Account ID
     C**********         PARM                    I_RACCID         18                          CGL029
     C                   PARM                    I_RACCID                                     CGL029
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1

      * Initialize program name

     C                   MOVEL     'RE100453 '   DDPGM

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

     C     *DTAARA       DEFINE                  JNSTAT
     C     *LOCK         IN        JNSTAT
     C                   OUT       JNSTAT

      * Initialize toggles

     C                   MOVEL     'N'           EXTD_NARR         1
     C                   MOVEL     'V'           PSTD_VALD         1

      * Initialize selections

     C                   Z-ADD     *ZERO         SelectPSTA
     C                   Z-ADD     9             SelectDRCR

      * key lists

     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
     C     APOSTK        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C     APOSTKF       KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    ReadFromDate      5 0
     C     EXTSNK        KLIST
     C                   KFLD                    XRFI
     C                   KFLD                    XRFN

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
