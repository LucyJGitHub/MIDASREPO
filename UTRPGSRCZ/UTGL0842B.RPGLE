     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Reporting/update utility for MD-54125')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  UTGL0842B - Reporting/Correcting program for GLHIBLPD        *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD054125 *CREATE   Date 27Jul20               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD054125 - Datapatch to blank out Associated Customer (ASOC) *
      *             and merge the balances                            *
      *                                                               *
      *****************************************************************
     FGLHIBLL0  UF   E           K DISK    PREFIX(A_)
     FGLHIBLL1  UF   E           K DISK
     FGLAVBLL0  IF   E           K DISK    PREFIX(A_)
     FGLAVBLL1  UF   E           K DISK
     FGLHBCGL0  UF   E           K DISK
     FSDBANKPD  IF   E             DISK
     FUTGL842BP1O    E             PRINTER OFLIND(*IN66)
      **--------------------------------------------------------------------------------------------
     D WCGCD           S              2
     D WBRCA           S              3
     D WCNUM           S              6
     D WCCY            S              3
     D WACOD           S             10
     D WACSQ           S              2
     D WPCCD           S              4
     D WACNB           S              6
     D WPDCT           S              2
     D WPDYR           S              2
     D WPDNY           S              2
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
     D ModeParm        S              1A
     D Mode            S              6A
      ** Line Counters
     D X1Counter       S              6  0
     C     AKEY          KLIST
     C                   KFLD                    A_HBCGCD
     C                   KFLD                    A_HBBRCD
     C                   KFLD                    A_HBCYCD
     C                   KFLD                    A_HBACCD
     C                   KFLD                    A_HBCUST
     C                   KFLD                    A_HBACSN
     C                   KFLD                    A_HBPCCD
     C                   KFLD                    A_HBBKCD
     C                   KFLD                    A_HBOTTP
     C                   KFLD                    A_HBTSTY
     C                   KFLD                    A_HBACNB
     C                   KFLD                    A_HBPDCT
     C                   KFLD                    A_HBPDYR
     C                   KFLD                    A_HBPDNY
      *
     C     ABKEY         KLIST
     C                   KFLD                    A_ABCGCD
     C                   KFLD                    A_ABBRCD
     C                   KFLD                    A_ABCYCD
     C                   KFLD                    A_ABACCD
     C                   KFLD                    A_ABCUST
     C                   KFLD                    A_ABACSN
     C                   KFLD                    A_ABPCCD
     C                   KFLD                    A_ABBKCD
     C                   KFLD                    A_ABOTTP
     C                   KFLD                    A_ABTSTY
     C                   KFLD                    A_ABACNB
     C                   KFLD                    A_ABPDCT
     C                   KFLD                    A_ABPDYR
     C                   KFLD                    A_ABPDNY
      *
      **  MAIN ROUTINE
      *
     C                   Eval      X1Counter = 0
      *
      ** Read first record from accounts file
      *
     C                   READ      GLHIBLL0                               10
     C                   Move      A_HBCGCD      WCGCD
     C                   Move      A_HBCGCD      UTCGCD
      *
     C     *IN10         DOWEQ     '0'
      *
     C                   If        A_HBACNB = '000000'
      *
      ** If update mode (*IN30=*ON) merge and delete from file now.
      *
     C                   Move      A_HBACNB      W_HBACNB          6
     C                   Move      *Blank        A_HBACNB
     C                   If        *IN30 = *On
      *
     C     AKEY          CHAIN     GLHIBLL1                           20
     C                   If        *IN20 = *Off and HBACNB = *Blank
     C                   Eval      HBPDOB = HBPDOB + A_HBPDOB
     C                   Eval      HBPDCB = HBPDCB + A_HBPDCB
     C                   Eval      HBWPBL = HBWPBL + A_HBWPBL
     C                   Eval      HBWT1B = HBWT1B + A_HBWT1B
     C                   Eval      HBWT2B = HBWT2B + A_HBWT2B
     C                   Eval      HBWYBL = HBWYBL + A_HBWYBL
     C                   Eval      UTBRCA = HBBRCD
     C                   Eval      UTCNUM = HBCUST
     C                   Eval      UTCCY  = HBCYCD
     C                   Eval      UTACOD = HBACCD
     C                   Eval      UTACSQ = HBACSN
     C                   Eval      UTPCCD = HBPCCD
     C                   Eval      UTACNB = HBACNB
     C                   Eval      UTPDCT = HBPDCT
     C                   Eval      UTPDYR = HBPDYR
     C                   Eval      UTPDNY = HBPDNY
     C                   Eval      UTACTN = 'U'
     C                   Exsr      PrintX1
     C                   UPDATE    @BORED7
     C                   Eval      UTBRCA = A_HBBRCD
     C                   Eval      UTCNUM = A_HBCUST
     C                   Eval      UTCCY  = A_HBCYCD
     C                   Eval      UTACOD = A_HBACCD
     C                   Eval      UTACSQ = A_HBACSN
     C                   Eval      UTPCCD = A_HBPCCD
     C                   Eval      UTACNB = W_HBACNB
     C                   Eval      UTPDCT = A_HBPDCT
     C                   Eval      UTPDYR = A_HBPDYR
     C                   Eval      UTPDNY = A_HBPDNY
     C                   Eval      UTACTN = 'D'
     C                   Exsr      PrintX1
     C                   DELETE    @BORED6
      *
     C     AKEY          CHAIN     GLAVBLL0                           50
     C                   If        *IN50 = *Off and A_ABACNB = *Blank
     C                   Move      '000000'      A_ABACNB
     C     ABKEY         CHAIN     GLAVBLL1                           51
     C                   If        *IN51 = *Off
     C                   DELETE    @BPRED4
     C                   Endif
     C                   Endif
      *
     C                   Else
      *
     C                   Eval      UTBRCA = A_HBBRCD
     C                   Eval      UTCNUM = A_HBCUST
     C                   Eval      UTCCY  = A_HBCYCD
     C                   Eval      UTACOD = A_HBACCD
     C                   Eval      UTACSQ = A_HBACSN
     C                   Eval      UTPCCD = A_HBPCCD
     C                   Eval      UTACNB = A_HBACNB
     C                   Eval      UTPDCT = A_HBPDCT
     C                   Eval      UTPDYR = A_HBPDYR
     C                   Eval      UTPDNY = A_HBPDNY
     C                   Eval      UTACTN = 'U'
     C                   Exsr      PrintX1
     C                   Move      *Blank        HBACNB
     C                   UPDATE    @BORED6
      *
     C     AKEY          CHAIN     GLAVBLL0                           50
     C                   If        *IN50 = *On
     C                   Move      '000000'      A_HBACNB
     C     AKEY          CHAIN     GLAVBLL1                           51
     C                   If        *IN51 = *Off
     C                   Move      *Blank        ABACNB
     C                   UPDATE    @BPRED4
     C                   Endif
     C                   Endif
      *
     C                   Endif
      *
     C                   Else
      *
      ** If audit mode (*IN30=*OFF), just get the details for the report
      *
     C     AKEY          CHAIN     GLHIBLL1                           20
     C                   If        *IN20 = *Off and HBACNB = *Blank
     C                   Eval      UTBRCA = HBBRCD
     C                   Eval      UTCNUM = HBCUST
     C                   Eval      UTCCY  = HBCYCD
     C                   Eval      UTACOD = HBACCD
     C                   Eval      UTACSQ = HBACSN
     C                   Eval      UTPCCD = HBPCCD
     C                   Eval      UTACNB = HBACNB
     C                   Eval      UTPDCT = HBPDCT
     C                   Eval      UTPDYR = HBPDYR
     C                   Eval      UTPDNY = HBPDNY
     C                   Eval      UTACTN = 'U'
     C                   Exsr      PrintX1
     C                   Eval      UTBRCA = A_HBBRCD
     C                   Eval      UTCNUM = A_HBCUST
     C                   Eval      UTCCY  = A_HBCYCD
     C                   Eval      UTACOD = A_HBACCD
     C                   Eval      UTACSQ = A_HBACSN
     C                   Eval      UTPCCD = A_HBPCCD
     C                   Eval      UTACNB = W_HBACNB
     C                   Eval      UTPDCT = A_HBPDCT
     C                   Eval      UTPDYR = A_HBPDYR
     C                   Eval      UTPDNY = A_HBPDNY
     C                   Eval      UTACTN = 'D'
     C                   Exsr      PrintX1
     C                   Else
     C                   Eval      UTBRCA = A_HBBRCD
     C                   Eval      UTCNUM = A_HBCUST
     C                   Eval      UTCCY  = A_HBCYCD
     C                   Eval      UTACOD = A_HBACCD
     C                   Eval      UTACSQ = A_HBACSN
     C                   Eval      UTPCCD = A_HBPCCD
     C                   Eval      UTACNB = W_HBACNB
     C                   Eval      UTPDCT = A_HBPDCT
     C                   Eval      UTPDYR = A_HBPDYR
     C                   Eval      UTPDNY = A_HBPDNY
     C                   Eval      UTACTN = 'U'
     C                   Exsr      PrintX1
     C                   Endif
      *
     C                   Endif
     C                   Endif
      *
     C                   READ      GLHIBLL0                               10
      *
     C                   Enddo
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
      *
      ** Update GLHBCGPD and change Last Posting Date to 31DEC2018
      *
     C                   If        *IN30 = *On
      *
     C     WCGCD         CHAIN     GLHBCGL0                           40
     C                   If        *IN40 = *Off
     C                   Eval      HCCPNB = 201812
     C                   Eval      HCLPDT = 17167235959
     C                   UPDATE    @BNREDZ
     C                   Endif
      *
     C                   Endif
      *
      ** End Program
      *
     C                   Seton                                        LR
     C                   Return

      *****************************************************************
      *
      *   PRINTX1 - Report Generation Routine for UTGL0833P1
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
     C                   Eval      UTCGCD = A_HBCGCD
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
     C
     C     *ENTRY        PLIST
     C                   PARM                    ModeParm
      *
     C                   If        ModeParm = 'U' or ModeParm = 'u'
     C                   Eval      Mode = 'UPDATE'
     C                   Eval      *IN30 = *On
     C                   ELSE
     C                   If        ModeParm = 'A' or ModeParm = 'a'
     C                   Eval      Mode = 'AUDIT'
     C                   Eval      *IN30 = *Off
     C                   Endif
     C                   Endif
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
     C                   Eval      *IN10 = *Off
     C                   Eval      *IN20 = *Off
     C                   Eval      *IN40 = *Off
      *
     C                   ENDSR
      *
      /COPY ZACPYSRC,PSSR_ILE
**  CPY@
(c) Finastra International Limited 2019
