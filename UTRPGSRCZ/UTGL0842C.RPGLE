     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Reporting/update utility for MD-54125')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  UTGL0842C - Reporting/Correcting program for APOSTPD and     *
      *              GLACPHPD with Associated Customer (ASOC) equal   *
      *              to '000000'                                      *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD054125 *Create   Date 17Aug20               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD054125A - Reports account with balance discrepancy between *
      *              GLHIBLPD (Period Closing Balance) and            *
      *              ACCNTAB (Cleared Balance/Ledger Balance).        *
      *                                                               *
      *****************************************************************
     FUTHIBLL0  IF   E           K DISK
     FGLHIBLL3  IF   E           K DISK     PREFIX(A_)
     FACCNTL0   IF   E           K DISK
     FUTGL842CPDUF A E           K DISK
     FSDBANKPD  IF   E             DISK
     FUTGL842CP1O    E             PRINTER OFLIND(*IN66)
      **--------------------------------------------------------------------------------------------
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Mode Parameter
     D TOTPCB          S             19  0 INZ(*ZERO)
     D WBRCD           S              3A   INZ(*BLANK)
     D WCUST           S              6A   INZ(*BLANK)
     D WCYCD           S              3A   INZ(*BLANK)
     D WACCD           S             10A   INZ(*BLANK)
     D WACSN           S              2A   INZ(*BLANK)
     D WPDCT           S              2A   INZ(*BLANK)
     D WPDYR           S              2A   INZ(*BLANK)
     D WPDNY           S              2A   INZ(*BLANK)
     D NMACCD          S             10  0
     D NMACSN          S              2  0
     D PSTB            S              1A
      ** Line Counters
     D X1Counter       S              6  0
     C     UTKEY1        KLIST
     C                   KFLD                    UTPDCT
     C                   KFLD                    UTPDYR
     C                   KFLD                    UTPDNY
     C                   KFLD                    UTBRCD
     C                   KFLD                    UTCYCD
     C                   KFLD                    UTACCD
     C                   KFLD                    UTCUST
     C                   KFLD                    UTACSN
      *
     C     AKEY          KLIST
     C                   KFLD                    UTCUST
     C                   KFLD                    UTCYCD
     C                   KFLD                    NMACCD
     C                   KFLD                    NMACSN
     C                   KFLD                    UTBRCD
      *
      **  MAIN ROUTINE
      *
     C                   Eval      X1Counter = 0
     C                   Exsr      DRIVEF
     C                   Exsr      MAIN
     C
      *
      ** End Program
      *
     C                   Seton                                        LR
     C                   Return

      *****************************************************************
      *
      *   DRIVEF - Create driving file UTGL842CPD
      *
      *****************************************************************
     C     DRIVEF        BEGSR
      *
      ** Read first record from GLHIBLPD file
      *
     C                   READ      UTHIBLL0                               10
     C                   MOVE      HBBRCD        WBRCD
     C                   MOVE      HBCUST        WCUST
     C                   MOVE      HBCYCD        WCYCD
     C                   MOVE      HBACCD        WACCD
     C                   MOVE      HBACSN        WACSN
      *
     C     *IN10         DOWEQ     '0'
      *
     C     HBBRCD        IFNE      WBRCD
     C     HBCUST        ORNE      WCUST
     C     HBCYCD        ORNE      WCYCD
     C     HBACCD        ORNE      WACCD
     C     HBACSN        ORNE      WACSN
     C                   MOVE      WPDCT         UTPDCT
     C                   MOVE      WPDYR         UTPDYR
     C                   MOVE      WPDNY         UTPDNY
     C                   MOVE      WBRCD         UTBRCD
     C                   MOVE      WCYCD         UTCYCD
     C                   MOVE      WACCD         UTACCD
     C                   MOVE      WCUST         UTCUST
     C                   MOVE      WACSN         UTACSN
      *
     C                   MOVE      UTACCD        NMACCD
     C                   MOVE      UTACSN        NMACSN
     C     AKEY          CHAIN     ACCNTL0                            99
     C     *IN99         IFEQ      '0'
     C                   Write     UTHIBLD0
     C                   Endif
     C                   MOVE      HBBRCD        WBRCD
     C                   MOVE      HBCUST        WCUST
     C                   MOVE      HBCYCD        WCYCD
     C                   MOVE      HBACCD        WACCD
     C                   MOVE      HBACSN        WACSN
     C                   MOVE      HBPDCT        WPDCT
     C                   MOVE      HBPDYR        WPDYR
     C                   MOVE      HBPDNY        WPDNY
     C                   ELSE
     C                   MOVE      HBBRCD        WBRCD
     C                   MOVE      HBCUST        WCUST
     C                   MOVE      HBCYCD        WCYCD
     C                   MOVE      HBACCD        WACCD
     C                   MOVE      HBACSN        WACSN
     C                   MOVE      HBPDCT        WPDCT
     C                   MOVE      HBPDYR        WPDYR
     C                   MOVE      HBPDNY        WPDNY
     C                   ENDIF
      *
     C                   READ      UTHIBLL0                               10
     C                   ENDDO
      *
      ** Write the last record from GLHIBLPD
      *
     C     *IN10         IFEQ      '1'
     C                   MOVE      WPDCT         UTPDCT
     C                   MOVE      WPDYR         UTPDYR
     C                   MOVE      WPDNY         UTPDNY
     C                   MOVE      WBRCD         UTBRCD
     C                   MOVE      WCYCD         UTCYCD
     C                   MOVE      WACCD         UTACCD
     C                   MOVE      WCUST         UTCUST
     C                   MOVE      WACSN         UTACSN
     C                   Write     UTHIBLD0
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *   MAIN - Main Processing
      *
      *****************************************************************
     C     MAIN          BEGSR
      *
     C     PSTB          IFEQ      'V'
     C                   Eval      *IN50=*Off
     C                   ELSE
     C     PSTB          IFEQ      'P'
     C                   Eval      *IN50=*On
     C                   ENDIF
     C                   ENDIF
     C                   Eval      *IN66 = *On
     C                   Z-ADD     0             TOTPCB
     C                   READ      UTHIBLD0                               20
      *
     C     *IN20         DOWEQ     '0'
      *
     C     UTKEY1        CHAIN     GLHIBLL3                           30
     C     *IN30         DOWEQ     '0'
     C                   ADD       A_HBPDCB      TOTPCB
     C     UTKEY1        READE     GLHIBLL3                               30
     C                   ENDDO
      *
      ** Report if Cleared Balance and Period Closing Balance is not equal
      *
     C     *IN30         IFEQ      '1'
     C                   MOVE      UTACCD        NMACCD
     C                   MOVE      UTACSN        NMACSN
     C                   MOVE      A_HBCGCD      UTCGCD
     C     AKEY          CHAIN     ACCNTL0                            99
     C     *IN99         IFEQ      '0'
     C     PSTB          IFEQ      'V'
     C     CLBL          ANDNE     TOTPCB
     C     PSTB          OREQ      'P'
     C     LDBL          ANDNE     TOTPCB
     C                   Exsr      PrintX1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     0             TOTPCB
     C                   READ      UTHIBLD0                               20
     C                   ENDDO
      *
      ** Print Totals if details are printed
      *
     C                   If        X1Counter > 0
     C                   Eval      UTCOUNT = X1Counter
     C                   Else
     C                   Eval      *IN67 = *On
     C                   Write     UTPAGHDR
     C                   Write     UTTITLE
     C                   Endif
     C                   Write     UTFINTTL
     C                   Write     UTENDRPT
     C*                  CLOSE     UTGL842CP1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *   PRINTX1 - Report Generation Routine for UTGL842CP1
      *
      *****************************************************************
     C     PRINTX1       BEGSR
      *
      ** Print header on every start of page
      *
     C                   If        *IN66 = *On and X1Counter = 0
     C                   Write     UTPAGHDR
     C                   Eval      *IN66 = *Off
     C                   Endif
      *
      ** Print Title Lines
      *
     C                   If        X1Counter = 0
     C                   Write     UTTITLE
     C                   Endif
      *
      ** If next page, write header and title line again
      *
     C                   If        X1Counter > 0 and *IN66 = *On
     C                   Write     UTPAGHDR
     C                   Write     UTTITLE
     C                   Eval      *IN66 = *Off
     C                   Endif
      *
      ** Print account details
      *
     C                   Eval      UTBRCA = UTBRCD
     C                   Eval      UTCNUM = UTCUST
     C                   Eval      UTCCY  = UTCYCD
     C                   Eval      UTACOD = UTACCD
     C                   Eval      UTACSQ = UTACSN
     C     PSTB          IFEQ      'V'
     C                   Eval      UTACBL = CLBL
     C                   ENDIF
     C     PSTB          IFEQ      'P'
     C                   Eval      UTACBL = LDBL
     C                   ENDIF
     C                   Eval      UTPDCB = TOTPCB
      *
     C                   Write     UTDTLRCD
     C                   Eval      X1Counter = X1Counter + 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *   INIT SUBROUTINE
      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSTB
      *
      *  Seton overflow indicator to write the header on first print
      *
     C                   Eval      *IN66 = *On
     C                   Eval      *IN67 = *Off
      *
      *  Print Midas Run Date on report
      *
     C                   Read      SDBANKD0
     C                   If        Not %Eof
     C                   Eval      UTMRDT = BJMRDT
     C                   Endif
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      **                           MMDDYY (*IN98 on)
      *
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
**  ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**  ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**  ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**  CPY@
(c) Finastra International Limited 2019
