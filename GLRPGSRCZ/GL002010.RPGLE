     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account Movements Enquiry')                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL002010 - Account Movements Enquiry                         *
      *                                                               *
      *  Function: This module allows enquiry into account movements. *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD039988           Date 08Aug16               *
      *  Prev Amend No. MD039702           Date 14Jul16               *
      *                 MD029074           Date 21Nov14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR792734A          Date 14Sep11               *
      *                 AR586146           Date 17Apr12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 27Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13387           Date 23Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG13352           Date 11Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12888           Date 15Dec06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 BG1769             Date 23May03               *
      *                 CGL029             Date 23May03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039988 - Discrepancy of Balances between enquiry screens.  *
      *             Amend to reconcile all screens.                   *
      *  MD039702 - Batch number can hold alpha characters. Test      *
      *             should be done on characters 4 to 6 when          *
      *             displaying 'MANPO'.                               *
      *  MD029074 - Incorrect CR is displayed on debit balance        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR792734A - Applied core fix 249420. (Child: AR792735A)      *
      *  249420 - Do not show real time postings from RSACMTPD when   *
      *           it is already in APOSTPD. Apply fix 235898.         *
      *  AR586146 - Posting date for shadow posting is incorrect.     *
      *             Display actual posting date from RSACMTPD instead *
      *             of rundate. Apply fix 254135. Also, show correct  *
      *             today's closing ledger balance by posting date.   *
      *           - Applied for AR954327 (Child:AR954330)             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CAP204 - Retail Account Transfer                             *
      *  BUG13387 - Negative or reversal sign not reflected on the GL *
      *             Account Movements Enquiry                         *
      *  BUG13352 - Amount defaulted are in one decimal place only    *
      *  BUG12888 - Account Movements Enquiry missing source          *
      *             of Posting                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BG1769 - Complete 10 digit account code changes.             *
      *  CGL029 - 10 digit account code changes.                      *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************

     FGL002010DFCF   E             WORKSTN INFSR(*PSSR)
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
     FFDDTSTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(DT)
     FSDLOANL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(LT)

      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************


     D                 DS
     D #_RefField              1     15    DIM(15)
     D  RefField               1     15


      * Account ID
     D                 DS
     D ACCID                   1     24
     D BRC                     1      3
     D*CUS******               4      9S 0                                                    CSD027
     D CUS                     4      9                                                       CSD027
     D CCY                    10     12
     D*ACD******              13     16S 0                                                    CGL029
     D ACD                    13     22S 0                                                    CGL029
     D ASN                    23     24S 0


      * Posting
     D                 DS
     D POSTING                 1    100
     D EPSTD                   2      8
     D EVALD                   9     15
     D EPNAR                  16     45
     D EPSTA                  46     67
     D EDRCR                  68     68
     D ESPOS                  69     73
     D EBTID                  74     79                                                       249420
     D EPSTP                  80     84S 0                                                    249420
     D EVALP                  85     89S 0                                                    249420
     D/COPY WNCPYSRC,GLH00506


      * Selection
     D                 DS
     D SELECT                  1    100
     D DDPSTD                  1      6
     D DDVALD                  7     12
     D DDPNAR                 13     42
     D DDPSTA                 43     64
     D DDDRCR                 65     65
     D DDSPOS                 66     70

      * Previous Selection
     D                 DS
     D P_SELECT                1    100


     D                 DS
     D ZOUT21                  1     21
     D ZOUT21Sign             21     21
      *                                                                                     BUG13352
      ** Position 21-22 was overriden by CR/Blanks, adjust length of                        BUG13352
      ** ZOUT21Edit from 21 to 23 to accomodate moving of CR/Blanks.                        BUG13352
      *                                                                                     BUG13352
     D*ZOUT21Edit*********     1     22                                                     BUG13352
     D ZOUT21Edit              1     23                                                     BUG13352

     D                 DS                                                                   MD039702
     D WRK7                    1      7                                                     MD039702
     D WRK3                    4      6                                                     MD039702
                                                                                            MD039702

      *  Layout for data area JNSTAT
     D JNSTAT        E DS                  EXTNAME(JNSTAT)


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D/COPY WNCPYSRC,GLH00462
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAP204
      ** Switcable Features file                                                              CAP204
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs
     D/COPY ZSRSRC,ZHOLILE                                                                  MD039988
     D/COPY ZSRSRC,ZHOLELE                                                                  MD039988
                                                                                            BUG12888
     D/COPY WNCPYSRC,GLH00463
      ** narrative dscription constants for CLS transaction  type                           BUG12888
     DSTDCLS_PAY       S             30A   inz('CLS PAY')                                   BUG12888
     DSTDCLS_RCV       S             30A   inz('CLS RCV')                                   BUG12888

      ** AOSARDR0 SAR parameter                                                               CAP204
     D@SARD            S              6A                                                      CAP204
     DCAP204           S              1A                                                      CAP204
                                                                                              CAP204
     DW#REAL           S              1A                                                      249420
     DW#SFR            S              4P 0                                                    249420
     DW#RRN            S              4P 0                                                    249420
     IRSACMTPO      01
     I              PTDT                        PSTD
     I              VUDT                        VALD
     I              NRTD                        PNAR
     I              MVAM                        PSTA
     I              DORC                        DRCR
     IFFACMVDF      02
     I              PTDT                        PSTD
     I              VUDT                        VALD
     I              NRTD                        PNAR
     I              MVAM                        PSTA
     I              DORC                        DRCR
     I              NRTC                        ZZNRTC
     ICLEARPDF      03
     I              PSTD                        PSTD
     I              VALD                        VALD
     I              PNAR                        PNAR
     I              PSTA                        PSTA
     I              DRCR                        DRCR
     I              SPOS                        SPOS


      /SPACE 5

      * Requested Account ID

     C                   MOVEL     I_RACCID      ACCID
     C                   MOVE      CUS           WrkCUS            6
     C                   MOVE      ACD           WrkACD           10
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
     C                   WRITE     FOOTER                                                     BG1769
     C                   WRITE     SUBFLCTL
     C*******************WRITE     FOOTER                                                     BG1769

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
     C     *IN70         IFEQ      '0'
     C                   EXSR      INT_STAT_ENQ
     C                   MOVE      @INKC         *INKC
     C                   ENDIF
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

      * Write B/F Ledger Balance

     C                   EXSR      WRT_BF_LDBL

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

      * Write C/F Ledger Balance

     C     PSTD          IFGT      PrevBalDate
     C                   MOVEL     'INTERIMCLOS' OPEN_CLOS
     C                   EXSR      WRT_CF_LDBL
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

     C     RRN           CABGT     9990          PDSUBF_FULL
     C     APOSTK        READE     APOSTL1                                99    *
     C                   ENDDO

      * Write TODAY'S C/F OPENING Ledger Balance

     C                   MOVEL     'TODAYSOPEN ' OPEN_CLOS        11
     C                   EXSR      WRT_CF_LDBL
                                                                                            AR586146
     C                   MOVE      'N'           CLOS_Output                                AR586146

      * Read a/c movements for a/c

     C     APOSTK        SETLL     RSACMTL6
     C                   SETOFF                                       010203
     C     APOSTK        READE     RSACMTL6                               99    *

      * Do while a/c movements found

     C     *IN99         DOWEQ     '0'
     C                   MOVE      'N'           W#REAL                                       249420
     C                   EXSR      CHK_REALT                                                  249420
                                                                                              249420

     C     *in01         IFEQ      '1'
     C     W#REAL        ANDEQ     'N'                                                        249420
     C     *in02         OREQ      '1'
                                                                                            AR586146
      ** Once a posting has been read beyond the current run date,                          AR586146
                                                                                            AR586146
     C     PSTD          IFGT      BJRDNB                                                   AR586146
     C     CLOS_Output   ANDNE     'Y'                                                      AR586146
                                                                                            AR586146
      ** write TODAY'S C/F CLOSING Ledger Balance.                                          AR586146
                                                                                            AR586146
     C                   MOVEL     'TODAYSCLOS ' OPEN_CLOS                                  AR586146
     C                   EXSR      WRT_CF_LDBL                                              AR586146
     C                   MOVE      'Y'           CLOS_Output                                AR586146
     C                   ENDIF                                                              AR586146

      * RSACMTPD narratives
      * FFACMVD  narratives

     C   01              EXSR      RSACMTPD_NARRS
     C   02              EXSR      FFACMVD_NARRS

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

     C     RRN           CABGT     9990          PDSUBF_FULL
     C                   SETOFF                                       010203
     C     APOSTK        READE     RSACMTL6                               99    *
     C                   ENDDO
                                                                                            AR586146
      ** If no posting was read beyond the current run date,                                AR586146
                                                                                            AR586146
     C     CLOS_Output   IFNE      'Y'                                                      AR586146

      * Write TODAY'S C/F CLOSING Ledger Balance

     C                   MOVEL     'TODAYSCLOS ' OPEN_CLOS
     C                   EXSR      WRT_CF_LDBL
     C                   ENDIF                                                              AR586146
     C                   GOTO      PDSUBF_OK

      * Subfile full

     C     PDSUBF_FULL   TAG
     C                   MOVEL     'GLE0005 '    ZAMSID
     C                   EXSR      ZASNMS
     C     PDSUBF_OK     TAG

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

      * Write B/F Cleared Balance

     C                   EXSR      WRT_BF_CLBL

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

      * Write C/F Cleared Balance

     C     VALD          IFGT      PrevBalDate
     C                   MOVEL     'INTERIMCLOS' OPEN_CLOS
     C                   EXSR      WRT_CF_CLBL
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

     C     RRN           CABGT     9990          VDSUBF_FULL
     C     APOSTK        READE     PMHPOSL1                               99    *
     C                   ENDDO

      * Write TODAY'S C/F OPENING Cleared Balance

     C                   MOVEL     'TODAYSOPEN ' OPEN_CLOS
     C                   EXSR      WRT_CF_CLBL

     C                   MOVE      'N'           CLOS_Output       1

      * Read a/c movements for a/c

     C     APOSTK        SETLL     RSACMTL6
     C                   SETOFF                                       010203
     C     APOSTK        READE     RSACMTL6                               99    *

      * Do while a/c movements found

     C     *IN99         DOWEQ     '0'
     C                   MOVE      'N'           W#REAL                                    AR792734A
     C                   EXSR      CHK_REALT                                               AR792734A
                                                                                           AR792734A

      * Once a posting has been read beyond the current run date

     C     VALD          IFGE      BJDNWD
     C     CLOS_Output   ANDNE     'Y'

      * Write TODAY'S C/F CLOSING Cleared Balance

     C                   MOVEL     'TODAYSCLOS ' OPEN_CLOS
     C                   EXSR      WRT_CF_CLBL

     C                   MOVE      'Y'           CLOS_Output
     C                   ENDIF

     C     *IN01         IFEQ      '1'                                                     AR792734A
     C     W#REAL        ANDEQ     'N'                                                     AR792734A
     C     *IN02         OREQ      '1'                                                     AR792734A
     C     *IN03         OREQ      '1'                                                     AR792734A
      * RSACMTPD narratives
      * FFACMVD  narratives

     C   01              EXSR      RSACMTPD_NARRS
     C   02              EXSR      FFACMVD_NARRS

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
     C                   ENDIF                                                             AR792734A

     C     RRN           CABGT     9990          VDSUBF_FULL
     C                   SETOFF                                       010203
     C     APOSTK        READE     RSACMTL6                               99    *
     C                   ENDDO

      * If no posting was read beyond the current run date

     C     CLOS_Output   IFNE      'Y'

      * Write TODAY'S C/F CLOSING Cleared Balance

     C                   MOVEL     'TODAYSCLOS ' OPEN_CLOS
     C                   EXSR      WRT_CF_CLBL

     C                   ENDIF
     C                   GOTO      VDSUBF_OK

      * Subfile full

     C     VDSUBF_FULL   TAG
     C                   MOVEL     'GLE0005 '    ZAMSID
     C                   EXSR      ZASNMS
     C     VDSUBF_OK     TAG

      * Reset subfile

     C                   MOVEA     '111'         *IN(11)

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************                       249420
      * Check if the RSCAMTPD record is already in APOSTPD                                    249420
      *****************************************************************                       249420
     C     CHK_REALT     BEGSR                                                                249420
                                                                                              249420
      ** Do not include records if already in APOSTPD (realtime postings)                     249420
                                                                                              249420
     C     E_TRYP        IFEQ      'ME'                                                       249420
     C     *IN01         ANDEQ     '1'                                                        249420
     C                   Z-ADD     1             W#SFR                                        249420
     C                   Z-ADD     RRN           W#RRN                                        249420
                                                                                              249420
     C     W#SFR         DOWLE     W#RRN                                                      249420
     C     W#SFR         CHAIN(E)  SUBFLREC                                                   249420
                                                                                              249420
     C     E_TNMR        IFEQ      EBTID                                                      249420
     C     E_TNMR        ANDNE     *BLANKS                                                    249420
     C     PSTD          ANDEQ     EPSTP                                                      249420
     C     VALD          ANDEQ     EVALP                                                      249420
     C                   MOVE      'Y'           W#REAL                                       249420
     C     W#RRN         CHAIN(E)  SUBFLREC                                                   249420
     C     W#RRN         ADD       1             W#SFR                                        249420
     C                   ENDIF                                                                249420
                                                                                              249420
     C                   ADD       1             W#SFR                                        249420
     C                   ENDDO                                                                249420
                                                                                              249420
     C                   ENDIF                                                                249420
                                                                                              249420
     C                   ENDSR                                                                249420
      *****************************************************************                       249420
      /SPACE 5                                                                                249420
      *****************************************************************
      * Write B/F Ledger Balance
      *****************************************************************
     C     WRT_BF_LDBL   BEGSR

      * No write if selection on narrative, posting amount, dr/cr or source of posting

     C     DDPNAR        CABNE     *BLANK        E_WRT_BF_LDBL
     C     DDPSTA        CABNE     *BLANK        E_WRT_BF_LDBL
     C     DDDRCR        CABNE     *BLANK        E_WRT_BF_LDBL
     C     DDSPOS        CABNE     *BLANK        E_WRT_BF_LDBL

     C                   MOVEL     *BLANK        POSTING

      * Posting date = Read From Date

     C                   IF        ReadFromDate <> BJRDNB                                   MD039988
     C                   Z-ADD     ReadFromDate  ZDAYNO                                     MD039988
     C                   ELSE                                                               MD039988
     C                   Z-ADD     ReadFromDate  ZDAYNO
     C                   MOVE      CCY           ZCCY                                       MD039988
     C                   MOVE      BJSLCD        ZLOC                                       MD039988
     C                   Z-ADD     1             ZNRDYS                                     MD039988
     C                   EXSR      ZBKDT                                                    MD039988
     C                   Z-ADD     ZDYNBR        ZDAYNO                                     MD039988
     C                   ENDIF                                                              MD039988
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        EPSTD

      * Value date
     C                   MOVE      '------>'     EVALD

      * Posting narrative

     C                   IF        ReadFromDate <> BJRDNB                                   MD039988
     C                   EVAL      EPNAR = 'OPENING LEDGER BALANCE ------>'
     C                   ELSE                                                               MD039988
     C                   EVAL      EPNAR = 'CLOSING LEDGER BALANCE ------>'                 MD039988
     C                   ENDIF                                                              MD039988

      * Posting amount

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      BFBal         ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   IF        BFBAL < 0                                                MD029074
     C                   MOVE      'CR'          ZOUT21Edit                                 MD029074
     C                   ELSE                                                               MD029074
     C                   MOVE      '  '          ZOUT21Edit                                 MD029074
     C                   ENDIF                                                              MD029074
     C                   MOVE      ZOUT21Edit    EPSTA

     C                   ADD       1             RRN               4 0          *
     C                   WRITE     SUBFLREC

     C     E_WRT_BF_LDBL ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Write B/F Cleared Balance
      *****************************************************************
     C     WRT_BF_CLBL   BEGSR

      * No write if selection on narrative, posting amount, dr/cr or source of posting

     C     DDPNAR        CABNE     *BLANK        E_WRT_BF_CLBL
     C     DDPSTA        CABNE     *BLANK        E_WRT_BF_CLBL
     C     DDDRCR        CABNE     *BLANK        E_WRT_BF_CLBL
     C     DDSPOS        CABNE     *BLANK        E_WRT_BF_CLBL

     C                   MOVEL     *BLANK        POSTING

      * Posting date
     C                   MOVE      '------>'     EPSTD

      * Value date = Read From Date

     C                   IF        ReadFromDate <> BJRDNB                                   MD039988
     C                   Z-ADD     ReadFromDate  ZDAYNO
     C                   ELSE                                                               MD039988
     C                   MOVE      CCY           ZCCY                                       MD039988
     C                   MOVE      BJSLCD        ZLOC                                       MD039988
     C                   Z-ADD     1             ZNRDYS                                     MD039988
     C                   EXSR      ZBKDT                                                    MD039988
     C                   Z-ADD     ZDYNBR        ZDAYNO                                     MD039988
     C                   ENDIF                                                              MD039988
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        EVALD

      * Posting narrative

     C                   IF        ReadFromDate <> BJRDNB                                   MD039988
     C                   EVAL      EPNAR = 'OPENING CLEARED BALANCE ----->'
     C                   ELSE                                                               MD039988
     C                   EVAL      EPNAR = 'CLOSING CLEARED BALANCE ----->'                 MD039988
     C                   ENDIF                                                              MD039988

      * Posting amount

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      BFBal         ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   IF        BFBAL < 0                                                MD029074
     C                   MOVE      'CR'          ZOUT21Edit                                 MD029074
     C                   ELSE                                                               MD029074
     C                   MOVE      '  '          ZOUT21Edit                                 MD029074
     C                   ENDIF                                                              MD029074
     C                   MOVE      ZOUT21Edit    EPSTA

     C                   ADD       1             RRN               4 0          *
     C                   WRITE     SUBFLREC

     C     E_WRT_BF_CLBL ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Format Posting
      *****************************************************************
     C     FMT_POSTING   BEGSR

     C                   MOVEL     *BLANK        POSTING

      * Posting date

     C                   Z-ADD     PSTD          EPSTP                                        249420
     C                   Z-ADD     PSTD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        EPSTD

      * Value date

     C                   Z-ADD     VALD          EVALP                                        249420
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
     C                   MOVE      'CR'          ZOUT21Edit                                 BUG13387
     C                   ELSE
     C                   Z-ADD     PSTA          W_AMT
     C                   MOVE      '  '          ZOUT21Edit                                 BUG13387
     C                   ENDIF
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      W_AMT         ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    EPSTA

      * Source of posting

     C/COPY WNCPYSRC,GLH00464
     C**********         MOVEL     SPOS          WRK3              3                        MD039702
     C                   MOVEL     SPOS          WRK7                                       MD039702
     C                   TESTN                   WRK3                 99
     C/COPY WNCPYSRC,GLH00465
     C  N99              MOVE      SPOS          ESPOS
     C   99              MOVEL     'MANPO'       ESPOS
     C     *IN99         IFEQ      '1'                                                        249420
     C                   MOVEL     SPOS          EBTID                                        249420
     C                   ENDIF                                                                249420
     C/COPY WNCPYSRC,GLH00466

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * RSACMTPD narratives
      *****************************************************************
     C     RSACMTPD_NARRSBEGSR

     C**********         Z-ADD     BJRDNB        PSTD                                       AR586146

     C                   MOVEL     *BLANK        SPOS
     C                   EVAL      OTRF = *BLANK
     C                   EVAL      OTST = *BLANK
     C                   EVAL      OTTP = *BLANK
     C                   SELECT
     C     E_TRYP        WHENEQ    'CE'
     C                   MOVE      'GE-CE'       SPOS
     C                   EVAL      OTRF = E_TNMR
     C     E_FUND        WHENEQ    PNAR
     C     E_FUND        ANDNE     *BLANK
     C                   MOVE      'GE-FT'       SPOS
     C                   EVAL      OTRF = E_FUND
     C                   EVAL      OTST = E_TRYP
     C     E_TRYP        WHENEQ    'TP'
     C     E_TRYP        OREQ      'TS'
     C                   MOVE      'GE-ST'       SPOS
     C                   EVAL      OTRF = E_TNMR
     C                   EVAL      OTST = E_TRYP
     C     PNAR          IFEQ      *BLANK
     C                   EVAL      PNAR = E_TNMR + '-' + E_TRYP
     C                   ENDIF
     C     E_TRYP        WHENEQ    'ME'
     C                   MOVE      'MANPO'       SPOS
     C                   EVAL      OTRF = %subst(E_TNMR:1:3)
     C                   EVAL      OTST = %subst(E_TNMR:4:3)
     C     E_TRYP        WHENEQ    'F1'
     C                   MOVE      'GE-LE'       SPOS
     C                   EVAL      OTRF = E_TNMR
     C     E_TRYP        WHENEQ    'F2'
     C                   MOVE      'GE-LE'       SPOS
     C                   EVAL      OTRF = %subst(E_TNMR:2:3)
     C                   EVAL      OTST = %subst(E_TNMR:5:2)
     C     E_TRYP        WHENEQ    'MR'
     C                   MOVE      'GE-LE'       SPOS
     C                   EVAL      OTRF = E_TNMR
     C     E_TRYP        WHENEQ    'SO'
     C                   MOVE      'GE-SO'       SPOS
     C                   EVAL      OTRF = E_TNMR
                                                                                            BUG12888
     C     E_TRYP        WHENEQ    'CP'                                                     BUG12888
     C                   MOVE      'GE-DL'       SPOS                                       BUG12888
     C                   EVAL      OTRF = E_TNMR                                            BUG12888
                                                                                            BUG12888
     C     E_TRYP        WHENEQ    'DL'                                                     BUG12888
     C     PNAR          IFEQ      STDCLS_PAY                                               BUG12888
     C     PNAR          OREQ      STDCLS_RCV                                               BUG12888
     C                   MOVE      'GE-DL'       SPOS                                       BUG12888
     C                   EVAL      OTRF = E_TNMR                                            BUG12888
     C                   ENDIF                                                              BUG12888
                                                                                            BUG12888
     C     E_TRYP        WHENEQ    'CL'                                                     BUG12888
     C     PNAR          IFEQ      STDCLS_PAY                                               BUG12888
     C     PNAR          OREQ      STDCLS_RCV                                               BUG12888
     C                   MOVE      'GE-LE'       SPOS                                       BUG12888
     C                   EVAL      OTRF = E_TNMR                                            BUG12888
     C                   ENDIF                                                              BUG12888
                                                                                            BUG12888
     C     E_TRYP        WHENEQ    'ZT'                                                       CAP204
     C     CAP204        IFEQ      'Y'                                                        CAP204
     C                   MOVE      'GE-TX'       SPOS                                         CAP204
     C                   EVAL      OTRF = E_OTR1                                              CAP204
     C                   ENDIF                                                                CAP204
                                                                                              CAP204
     C                   OTHER

     C     E_TRYP        CHAIN     FDDTSTPD                           99
     C     *IN99         IFEQ      *OFF
     C                   MOVE      'GE-DL'       SPOS
     C                   ELSE
     C     E_TRYP        CHAIN     @AYRECK                            99
     C     *IN99         IFEQ      *OFF
     C                   MOVE      'GE-LE'       SPOS
     C                   ENDIF
     C                   ENDIF

     C     E_TNMR        IFNE      *BLANK
     C                   EVAL      OTRF = E_TNMR
     C                   ELSE
     C                   EVAL      OTRF = PNAR
     C                   ENDIF
     C                   EVAL      OTST = E_TRYP
     C     PNAR          IFEQ      *BLANK
     C                   EVAL      PNAR = E_TNMR + '-' + E_TRYP
     C                   ENDIF
     C                   ENDSL

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * FFACMVD narratives
      *****************************************************************
     C     FFACMVD_NARRS BEGSR
     C**********         Z-ADD     BJRDNB        PSTD                                       AR586146
     C                   MOVEL     '  GE-FF'     SPOS
     C     E_TNMR        IFNE      *BLANK
     C                   EVAL      OTRF = E_TNMR
     C                   ELSE
     C                   EVAL      OTRF = PNAR
     C                   ENDIF
     C                   EVAL      OTST = E_TRYP
     C                   EVAL      OTTP = *BLANK
     C     PNAR          IFEQ      *BLANK
     C                   EVAL      PNAR = E_TNMR + '-' + E_TRYP
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Format Extended Narrative
      *****************************************************************
     C     FMT_EXTD_NARR BEGSR

      * Clear narrative fields
     C     SPOS          IFEQ      '  GE-SF'
     C     SPOS          OREQ      '  GE-FA'
     C                   MOVE      *BLANK        OTRF
     C                   MOVE      *BLANK        OTST
     C                   MOVE      *BLANK        OTTP
     C                   ENDIF
      * Manual postings
     C/COPY WNCPYSRC,GLH00467
     C                   MOVEL     SPOS          WRK3
     C                   TESTN                   WRK3                 99
     C     *IN99         IFEQ      '1'
     C                   EVAL      OTRF = %subst(SPOS: 1: 3)
     C                   EVAL      OTST = %subst(SPOS: 4: 4)
     C                   MOVE      *BLANK        OTTP
     C                   ENDIF
     C/COPY WNCPYSRC,GLH00468

      * String narrative fields together

     C                   Z-ADD     1             #RF               2 0
     C                   MOVE      *BLANK        PNAR

     C                   MOVE      *BLANK        #_RefField
     C                   MOVEA     OTRF          #_RefField
     C     RefField      IFNE      *BLANK
     C                   EXSR      ADD_REFF_NAR
     C                   ENDIF

     C                   MOVE      *BLANK        #_RefField
     C                   MOVEA     OTST          #_RefField
     C     RefField      IFNE      *BLANK
     C                   EXSR      ADD_REFF_NAR
     C                   ENDIF

     C                   MOVE      *BLANK        #_RefField
     C                   MOVEA     OTTP          #_RefField
     C     RefField      IFNE      *BLANK
     C                   EXSR      ADD_REFF_NAR
     C                   ENDIF

     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *****************************************************************
      * Add Reference Field To Narrative
      *****************************************************************
     C     ADD_REFF_NAR  BEGSR

     C     #RF           IFGT      1
     C                   EVAL      %subst(PNAR:#RF:1) = '-'
     C                   ADD       1             #RF
     C                   ENDIF

     C                   Z-ADD     1             #D                2 0
     C     #D            DOUGT     15
     C     #_RefField(#D)OREQ      *BLANK
     C                   ADD       1             #D
     C                   ENDDO
     C                   SUB       1             #D
     C                   EVAL      %subst(PNAR:#RF:#D) =
     C                               %subst(RefField:1:#D)
     C                   ADD       #D            #RF
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *****************************************************************
      * Write C/F Ledger Balance
      *****************************************************************
     C     WRT_CF_LDBL   BEGSR

      * No write if selection on narrative, posting amount, dr/cr or source of posting

     C     DDPNAR        CABNE     *BLANK        E_WRT_CF_LDBL
     C     DDPSTA        CABNE     *BLANK        E_WRT_CF_LDBL
     C     DDDRCR        CABNE     *BLANK        E_WRT_CF_LDBL
     C     DDSPOS        CABNE     *BLANK        E_WRT_CF_LDBL

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
     C                   IF        CFBAL < 0                                                MD029074
     C                   MOVE      'CR'          ZOUT21Edit                                 MD029074
     C                   ELSE                                                               MD029074
     C                   MOVE      '  '          ZOUT21Edit                                 MD029074
     C                   ENDIF                                                              MD029074
     C                   MOVE      ZOUT21Edit    EPSTA

     C                   ADD       1             RRN
     C                   WRITE     SUBFLREC

     C     E_WRT_CF_LDBL ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Write C/F Cleared Balance
      *****************************************************************
     C     WRT_CF_CLBL   BEGSR

      * No write if selection on narrative, posting amount, dr/cr or source of posting

     C     DDPNAR        CABNE     *BLANK        E_WRT_CF_CLBL
     C     DDPSTA        CABNE     *BLANK        E_WRT_CF_CLBL
     C     DDDRCR        CABNE     *BLANK        E_WRT_CF_CLBL
     C     DDSPOS        CABNE     *BLANK        E_WRT_CF_CLBL

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
     C                   IF        CFBAL < 0                                                MD029074
     C                   MOVE      'CR'          ZOUT21Edit                                 MD029074
     C                   ELSE                                                               MD029074
     C                   MOVE      '  '          ZOUT21Edit                                 MD029074
     C                   ENDIF                                                              MD029074
     C                   MOVE      ZOUT21Edit    EPSTA

     C                   ADD       1             RRN
     C                   WRITE     SUBFLREC

     C     E_WRT_CF_CLBL ENDSR
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

     C/COPY WNCPYSRC,GLH00469
     C     DDSPOS        IFNE      *BLANK
     C/COPY WNCPYSRC,GLH00470
     C**********         MOVEL     SPOS          WRK3              3                        MD039702
     C                   MOVEL     SPOS          WRK7                                       MD039702
     C                   TESTN                   WRK3                 99
     C  N99              MOVE      SPOS          W_SPOS            5
     C   99              MOVEL     'MANPO'       W_SPOS
     C/COPY WNCPYSRC,GLH00471
     C     W_SPOS        IFNE      DDSPOS
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
     C                   MOVEL     'GLE0100 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE

      * If after the run date
      * 'Posting Date can't be after the run date'

     C                   Z-ADD     ZDAYNO        ReadFromDate
     C     ReadFromDate  IFGT      BJRDNB
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'GLE0101 '    ZAMSID
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
     C                   MOVEL     'GLE0102 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE

      * If after the run date
      * 'Value Date can't be after the run date'

     C                   Z-ADD     ZDAYNO        ReadFromDate
     C     ReadFromDate  IFGT      BJRDNB
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN52
     C                   MOVEL     'GLE0103 '    ZAMSID
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
     C                   MOVEL     'GLE0104 '    ZAMSID
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
     C                   MOVEL     'GLE0105 '    ZAMSID
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
     C                   PARM                    I_RACCID         24
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
     C*****ZOUT21Sign    IFEQ      '-'                                                      BUG13387
     C**********         MOVE      'CR'          ZOUT21Edit                                 BUG13387
     C**********         ELSE                                                               BUG13387
     C**********         MOVE      '  '          ZOUT21Edit                                 BUG13387
     C**********         ENDIF                                                              BUG13387
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
      *****************************************************************                     MD039988
      *                                                               *                     MD039988
      *  ZBKDT - CALCULATE THE NTH WORKING DAY BACKWARD FROM A GIVEN  *                     MD039988
      *          START DATE FOR ANY PARTICULAR CURRENCY               *                     MD039988
      *          AND (OPTIONAL) LOCATION.                             *                     MD039988
      *                                                               *                     MD039988
      *****************************************************************                     MD039988
      *****************************************************************                     MD039988
     C/COPY ZSRSRC,ZBKDT_ILE                                                                MD039988
      /SPACE 5                                                                              MD039988
      *****************************************************************                     MD039988
      *                                                               *                     MD039988
      *  ZACCH - ACCESS A HOLIDAY RECORD FOR A PARTICULAR CURRENCY    *                     MD039988
      *          AND (OPTIONAL) LOCATION.                             *                     MD039988
      *                                                               *                     MD039988
      *****************************************************************                     MD039988
     C/COPY ZSRSRC,ZACCHLE                                                                  MD039988
      /SPACE 5                                                                              MD039988
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Return code
      * Error Message
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * Requested Account ID
      * Account Type
     C                   PARM                    I_RACCID         24
     C                   PARM                    I_ATYP            1
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1

     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
                                                                                              CAP204
      ** Initialise LDA field                                                                 CAP204
                                                                                              CAP204
     C     *LOCK         IN        LDA                                                        CAP204
     C                   EVAL      DBASE = *ZEROS                                             CAP204
     C                   EVAL      DBFILE = *BLANKS                                           CAP204
     C                   EVAL      DBKEY = *BLANKS                                            CAP204
     C                   EVAL      DBMOD = 'GL002010'                                         CAP204
     C                   EVAL      DBPGM = 'GL002010'                                         CAP204
     C                   OUT       LDA                                                        CAP204

      * Initialize program name

     C                   MOVEL     'GL002010 '   DDPGM

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

      ** Access SAR details file to determine if Retail Account                               CAP204
      ** Transfer is switched on                                                              CAP204
                                                                                              CAP204
     C                   CALL      'AOSARDR0'                                                 CAP204
     C                   PARM      *BLANKS       @RTCD                                        CAP204
     C                   PARM      '*VERIFY'     @OPTN                                        CAP204
     C                   PARM      'CAP204'      @SARD                                        CAP204
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP204
                                                                                              CAP204
     C                   MOVEL     'N'           CAP204                                       CAP204
     C     @RTCD         IFEQ      *BLANKS                                                    CAP204
     C                   MOVEL     'Y'           CAP204                                       CAP204
     C                   ELSE                                                                 CAP204
     C     @RTCD         IFNE      '*NRF   '                                                  CAP204
     C     *LOCK         IN        LDA                                                        CAP204
     C                   EVAL      DBASE = 1                                                  CAP204
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP204
     C                   EVAL      DBKEY = 'CAP204'                                           CAP204
     C                   OUT       LDA                                                        CAP204
     C                   EXSR      *PSSR                                                      CAP204
     C                   ENDIF                                                                CAP204
     C                   ENDIF                                                                CAP204
                                                                                              CAP204
      * Initialize toggles

     C                   MOVEL     'N'           EXTD_NARR         1
     C     I_ATYP        IFEQ      'R'
     C                   MOVEL     'P'           PSTD_VALD         1
     C                   ELSE
     C                   MOVEL     'P'           PSTD_VALD
     C                   ENDIF

     C     I_ATYP        IFEQ      'R'
     C                   SETOFF                                       70
     C                   ELSE
     C                   SETON                                        70
     C                   ENDIF

      * Initialize selections

     C                   Z-ADD     *ZERO         SelectPSTA
     C                   Z-ADD     9             SelectDRCR

     C/COPY WNCPYSRC,GLH00472
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

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
