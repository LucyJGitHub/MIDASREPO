     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Reporting/update utility for MD-54125')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  UTGL0842A - Reporting/Correcting program for APOSTPD and     *
      *              GLACPHPD with Associated Customer (ASOC) equal   *
      *              to '000000'                                      *
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
      *             if value of ASOC = '000000'                       *
      *                                                               *
      *****************************************************************
     FAPOST     UF   E           K DISK    IGNORE(APOSTRAF)
     FGLACPHL1  UF   E           K DISK    RENAME(APOSTPDF:GLACHPDF)
     FSDBANKPD  IF   E             DISK
     FUTGL842AP1O    E             PRINTER OFLIND(*IN66)
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
     D ModeParm        S              1A
     D Mode            S              6A
      ** Line Counters
     D X1Counter       S              6  0
      *
      **  MAIN ROUTINE
      *
     C                   Eval      X1Counter = 0
     C                   Exsr      APOSPRC
     C                   Eval      X1Counter = 0
     C                   Exsr      GLACPRC
     C
      *
      ** End Program
      *
     C                   Seton                                        LR
     C                   Return

      *****************************************************************
      *
      *   APOSPRC - Process APOSTPD File
      *
      *****************************************************************
     C     APOSPRC       BEGSR
      *
      ** Read first record from accounts file
      *
     C                   Eval      *IN40 = *ON
     C                   READ      APOST                                  10
      *
     C     *IN10         DOWEQ     '0'
      *
     C     ASOC          IFEQ      '000000'
      *
      ** If update mode (*IN30=*ON) delete from file now.
      *
     C     *IN30         IFEQ      *ON
     C                   MOVE      *Blank        ASOC
     C                   Exsr      PrintX1
     C                   UPDATE    APOSTPDF
     C                   Else
     C                   Exsr      PrintX1
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      APOST                                  10
      *
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
     C                   CLOSE     UTGL842AP1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *   GLACPRC - Process GLACPHPD File
      *
      *****************************************************************
     C     GLACPRC       BEGSR
      *
      ** Read first record from accounts file
      *
     C                   OPEN      UTGL842AP1
     C                   Eval      *IN40 = *Off
     C                   Eval      *IN66 = *On
     C                   READ      GLACPHL1                               20
      *
     C     *IN20         DOWEQ     '0'
      *
     C     ASOC          IFEQ      '000000'
      *
      ** If update mode (*IN30=*ON) delete from file now.
      *
     C     *IN30         IFEQ      *ON
     C                   MOVE      *Blank        ASOC
     C                   Eval      *IN31 = *On
     C                   Eval      UTCLRD = 'Y'
     C                   Exsr      PrintX1
     C                   UPDATE    GLACHPDF
     C                   Else
     C                   Eval      *IN31 = *Off
     C                   Eval      UTCLRD = ' '
     C                   Exsr      PrintX1
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      GLACPHL1                               20
      *
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
     C                   CLOSE     UTGL842AP1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
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
     C                   Eval      UTBRCA = BRCA
     C                   Eval      UTCNUM = CNUM
     C                   Eval      UTCCY  = CCY
     C                   Eval      UTACOD = ACOD
     C                   Eval      UTACSQ = ACSQ
     C                   Eval      UTDRCR = DRCR
     C                   Eval      UTASOC = ASOC
     C                   Movel     PSTA          UTPSTA
      *
      ** Format Posting Date
      *
     C                   Eval      ZDAYNO = PSTD
     C                   EXSR      ZDATE2
     C                   Eval      UTPSTD = ZADATE
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
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *    ZDATE2 SR. TO CONVERT A DAY NUMBER TO DATE FORMATS.        *
      *    THE YEAR 2000, BEING DIVISIBLE BY 400, IS A LEAP YEAR.     *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR                                                  *** ZDATE2 ***
      *
      ** Clear Leap Year Work Field.
      *
     C                   MOVE      'N'           ZLEAP             1
      *
      ** Clear Date Fields.
      *
     C                   Z-ADD     0             ZDATE             6 0
     C                   MOVEL     '       '     ZADATE            7
      *
      ** Calculation to Define Input Day Number.
      *
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
      *
      ** Determine Year Number.
      ** Adjust Day Number in Case Last Day of Year.
      *
     C     ZDAYNO        SUB       1             ZDAYN1            5 0
     C     ZDAYN1        IFLT      0
     C                   GOTO      ZDEND2
     C                   END
      *
      ** Calculate Number of 4 Year Spans Since 31/12/1971.
      *
     C     ZDAYN1        DIV       1461          ZLYR              2 0
     C                   MVR                     ZDAYN1                         SAVE REMAINING DAYS
      *
      ** Calculate Number of Remaining Years.
      *
     C                   Z-ADD     1             ZWRK2             2 0
     C     ZDTAG1        TAG                                                    ** ZDTAG1 TAG *
     C     ZDAYN1        IFGE      ZYDY(ZWRK2)
     C     ZWRK2         ADD       1             ZWRK2
     C                   GOTO      ZDTAG1
     C                   END
      *
     C     ZWRK2         SUB       1             ZWRK2
      *
      ** Decrement Day No. By Days in Remaining Years.
      *
     C     ZWRK2         IFNE      0
     C     ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
     C                   END
      *
      ** Calculate Actual Year Number.
      *
     C     ZLYR          MULT      4             ZWRK3             3 0
     C     ZWRK3         ADD       72            ZWRK3                          BASE IS 1972
     C                   Z-ADD     ZWRK3         ZYEAR             2 0
     C     ZYEAR         ADD       ZWRK2         ZYEAR                          YEAR
      *
      ** Detemine Month Number.
      ** Adjust Day No. in Case Last Day of Leap Year February.
      *
     C     ZWRK2         IFEQ      0
     C     ZDAYN1        IFEQ      59
     C                   MOVE      'Y'           ZLEAP
     C                   END
     C     ZDAYN1        IFGE      59
     C     ZDAYN1        SUB       1             ZDAYN1
     C                   END
     C                   END
      *
      ** Calculate Month Number.
      *
     C                   Z-ADD     2             ZWRK2
     C     ZDTAG2        TAG                                                    ** ZDTAG2 TAG *
     C     ZDAYN1        IFGE      ZMDY(ZWRK2)
     C     ZWRK2         ADD       1             ZWRK2
     C                   GOTO      ZDTAG2
     C                   END
      *
     C     ZWRK2         SUB       1             ZWRK2
      *
     C                   Z-ADD     ZWRK2         ZMTH              2 0          MONTH
      *
      ** Determine Day of Month.
      ** Add Back Last Day of Year Adjustment.
      *
     C     ZDAYN1        ADD       1             ZDAYN1
      *
      ** Calculate Day of Month.
      *
     C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0          DAY
      *
      ** Add Back Leap Year 29th February Adjustment, If Required.
      *
     C     ZLEAP         IFEQ      'Y'
     C     ZDAY          ADD       1             ZDAY
     C                   END
      *
      ** Format Date, DDMMYY OR MMDDYY.
      *
     C  N98              MOVEL     ZDAY          ZWRK4             4 0
     C   98              MOVE      ZDAY          ZWRK4
     C  N98              MOVE      ZMTH          ZWRK4
     C   98              MOVEL     ZMTH          ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE
      *
      ** Format Alpha Date, DDMMMYY.
      *
     C                   MOVEL     ZDAY          ZWRK5             5
     C     ZDAY          IFLT      10
     C                   MOVEL     ' '           ZWRK5
     C                   END
     C                   MOVE      ZMNM(ZMTH)    ZWRK5
     C                   MOVEL     ZWRK5         ZADATE
     C                   MOVE      ZYEAR         ZADATE
      *
     C     ZDEND2        ENDSR                                                  * ZDEND2 ENDSR*
      *
      /COPY ZACPYSRC,PSSR_ILE
**  ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**  ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**  ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**  CPY@
(c) Finastra International Limited 2019
