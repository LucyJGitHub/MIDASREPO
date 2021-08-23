     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('GL Daily Movements Extract Report')                    *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM035A  GL Daily Movements Extract Report                   *                       LUC109
      *  XX00035A  GL Daily Movements Extract Report                  *                       LUC109
      *                                                               *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  CALLED BY  XXXXXXXX- XXXXXXXXXXXXXXXXXXXXXXXX                *
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1993,*1994**************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. 228619             Date 09Aug04               *
      *                 159964             Date 22Aug99               *
      *                 MMI043             Date 18Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  228619 - Avoid overflow on footer.                           *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043  Daily Movements Extract                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *****************************************************************
      *
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
     FACCNTPO   IF   E           K DISK    INFSR(*PSSR)
     FACCNTBL   IF   E           K DISK    INFSR(*PSSR)
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
     F***GLM035AU  O    E             PRINTER INFSR(*PSSR)                                    LUC109
     F***GLM035P1  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000035AUO    E             PRINTER INFSR(*PSSR)                                       LUC109
     FXX000035P1O    E             PRINTER INFDS(SPOOL)                                       LUC109
     F                                     INFSR(*PSSR)                                       LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   40 - PF/ACCNTPO    File I/O                                 *
      *   41 - PF/ACCNTBL    File I/O                                 *
      *   50 - General I/O                                            *
      *                                                               *
      *   88      Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  S100 - Initial Processing                                    *
      *  S200 - Main Processing                                       *
      *  S300 - Program termination                                   *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE1/2 SR.ARRAY
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE1/2 SR.ARRAY
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
     D ZS2             S              1    DIM(22)
      *
      ***File*information*for*printer*file*GLM035AU********************                       LUC109
      ** File information for printer file XX000035AU                                         LUC109
      *
     D SPOOL           DS
     D  @@OFLO               188    189B 0
     D  @@PRTL               367    368B 0
      *
      ** Data structure for data-base error processing
      *
     D DBERR           DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
     D                 DS
     D  DMY                    1      6  0
     D  @@D                    1      2  0
     D  @@M                    3      4  0
     D  @@Y                    5      6  0
      *
     D                 DS
     D  @@DMYY                 1     10
     D  @DD                    1      2  0
     D  @S1                    3      3
     D  @MM                    4      5  0
     D  @S2                    6      6
     D  @CC                    7      8  0
     D  @YY                    9     10  0
      *
     D                 DS
     D  ZWRK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)
     D                 DS
     D  ZOUT25                 1     25
     D  ZOUT0                  1     21
     D  ZOUT1                  2     23
     D  ZOUT2                  3     24
     D  ZOUT3                  5     25
      *
     D P1ACNO          DS
     D  @@BRCH                 1      3
     D  @@CUST                 4      9  0
     D  @@CCYC                10     12
     D  @@ACOD                13     16  0
     D  @@ACSQ                17     18  0
      *
      *****************************************************************
      *
     C                   EXSR      S100                                         Housekeeping
      *
     C                   EXSR      S200                                         Main process
      *
     C                   EXSR      S300                                         Termination
      *
      *****************************************************************
      *                                                               *
      *  S100  -  Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     S100          BEGSR                                                  Initialisation
      *
      ** Data definition
      *
     C     *DTAARA       DEFINE    LDA           WLDA            256            Data area
      *
     C     @@KPOS        KLIST                                                  ACCNTPO
     C                   KFLD                    POBRCA                         Branch code
     C                   KFLD                    POCYCD                         Currency code
     C                   KFLD                    POCNUM                         Customer
     C                   KFLD                    POACOD                         Account code
     C                   KFLD                    POACSQ                         Account seq
      *
     C     @@KBAL        KLIST                                                  ACCNTPO
     C                   KFLD                    POCNUM                         Customer
     C                   KFLD                    POCYCD                         Currency code
     C                   KFLD                    POACOD                         Account code
     C                   KFLD                    POACSQ                         Account seq
     C                   KFLD                    POBRCA                         Branch code
      *
      ** Initial housekeeping
      *
     C                   MOVE      'N'           @@PSSR            1            *PSSR Control
     C                   MOVE      '/'           @S1                            Slash 1
     C                   MOVE      '/'           @S2                            Slash 2
     C                   MOVE      *ALL'-'       P1UL01                         Underline 1
     C                   MOVE      *ALL'-'       P1UL02                         Underline 2
     C                   MOVE      *ALL'-'       P1UL03                         Underline 3
     C                   MOVE      *ALL'-'       P1UL04                         Underline 4
     C                   MOVEA     CPY@          ACT@             80            Copyright
      *
     C                   READ      SDBANKPD                               50    Bank details
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '001'         DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DB ERR  001 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN98                          DDMMYY
     C                   Z-ADD     BJRDNB        ZDAYNO                         Parameter
     C                   EXSR      ZDATE2                                       Convert date
     C                   Z-ADD     ZDATE         DMY                            Converted date
     C                   Z-ADD     @@D           @DD                            Day
     C                   Z-ADD     @@M           @MM                            Month
     C                   Z-ADD     @@Y           @YY                            Year
      *
     C     @@Y           IFGT      50                                           Year 2000
     C                   MOVE      '19'          @CC
     C                   ELSE
     C                   MOVE      '20'          @CC
     C                   ENDIF
      *
     C                   MOVE      @@DMYY        P1RUND                         Start date
      *
     C                   READ      ACCNTPO                                40    Primary read
      *
     C     *IN40         IFEQ      *OFF                                         Found
      *
     C                   MOVE      *OFF          *IN98                          DDMMYY
     C                   Z-ADD     POPSTD        ZDAYNO                         Parameter
     C                   EXSR      ZDATE2                                       Convert date
     C                   Z-ADD     ZDATE         DMY                            Converted date
     C                   Z-ADD     @@D           @DD                            Day
     C                   Z-ADD     @@M           @MM                            Month
     C                   Z-ADD     @@Y           @YY                            Year
      *
     C     @@Y           IFGT      50                                           Year 2000
     C                   MOVE      '19'          @CC
     C                   ELSE
     C                   MOVE      '20'          @CC
     C                   ENDIF
      *
     C                   MOVE      @@DMYY        P1RPTD                         Start date
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S200   -  Main process                                       *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls: S210                                                  *
      *                                                               *
      *****************************************************************
      *
     C     S200          BEGSR
      *
      ** Loop & process all branches
      *
     C     *IN40         DOWEQ     *OFF                                         Until eof
      *
     C     POBRCA        IFNE      A8BRCD                                       New branch
     C                   EXSR      COM901                                       Header
     C                   ENDIF
      *
     C     POCNUM        IFEQ      *LOVAL                                       Balance rec
     C                   EXSR      COM902                                       Column
     C                   ENDIF
      *
     C                   EXSR      COM903                                       Detail
      *
     C                   READ      ACCNTPO                                40    Get first
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *    S300      - Program termination                            *
      *                                                               *
      *    CALLED BY - S200 , *PSSR                                   *
      *    CALLS     - NONE                                           *
      *                                                               *
      *****************************************************************
      *
     C     S300          BEGSR
      *
     C     *IN88         IFEQ      *ON                                          Database error
     C                   WRITE     HEADAU                                       Report header
     C                   WRITE     DBERROR                                      Report error
     C                   ENDIF
      *                                                                   228619
     C     @@PRTL        IFGE      55                                           Print overflow 22861
     C                   WRITE     P1HEAD                                       Header         22861
     C                   ENDIF                                                                 22861
      *
     C                   WRITE     P1FOOT                                       Footer
      *
     C                   MOVE      *ON           *INLR                          Last record
     C                   RETURN                                                 Return control
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  COM901 - Common routine to perform branch initialisation     *
      *                                                               *
      *  Called By: S200                                              *
      *                                                               *
      *****************************************************************
      *
     C     COM901        BEGSR
      *
     C     POBRCA        CHAIN     SDBRCHL1                           50        Retrieve branch
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '002'         DBASE                          ***************
     C                   MOVEL     'SDBRCHL1'    DBFILE                         * DB ERR  002 *
     C                   MOVEL     POBRCA        DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      A8BRNM        P1BRNM                         Branch name
     C                   WRITE     P1HEAD                                       Header
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  COM902 - Common routine to perform currency initialisation   *
      *                                                               *
      *  Called By: S200                                              *
      *                                                               *
      *****************************************************************
      *
     C     COM902        BEGSR
      *
     C     POCYCD        IFNE      P1CYCD                                       New currency
      *
     C     POCYCD        CHAIN     SDCURRL0                           50
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '003'         DBASE                          ***************
     C                   MOVEL     'SDCURRL0'    DBFILE                         * DB ERR  003 *
     C                   MOVEL     POCYCD        DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      POCYCD        P1CYCD                         Currency
      *
     C                   ENDIF
      *
     C*          @@PRTL    IFGE 54                         Print overflow
     C     @@PRTL        IFGE      50                                           Print overflow
     C                   WRITE     P1HEAD                                       Header
     C                   ENDIF
      *
     C                   WRITE     P1SUB1                                       Sub-header
      *
      ** Set up total postings for the currency
      *
     C                   Z-SUB     PODBIT        ZFLD15                         Raw value
     C                   Z-ADD     A6NBDP        ZDECS                          Decimal places
     C                   MOVE      'J'           ZECODE                         Edit code
     C                   EXSR      ZFRPED                                       Format amount
     C                   MOVE(P)   ZOUT22        P1DBIT                         DR Postings
      *
     C                   Z-ADD     POCRDT        ZFLD15                         Raw value
     C                   EXSR      ZFRPED                                       Format amount
     C                   MOVE(P)   ZOUT22        P1CRDT                         CR Postings
      *
     C     POCRDT        SUB       PODBIT        ZFLD15                         Raw value
     C                   EXSR      ZFRPED                                       Format amount
     C                   MOVE(P)   ZOUT22        P1NETT                         Difference
      *
     C                   WRITE     P1SUB2                                       Sub-header
     C                   WRITE     P1COLM                                       Column hdr
      *
     C     @@KPOS        SETGT     ACCNTPO                                      Set pointer
     C                   READ      ACCNTPO                                40    Get first
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  COM903 - Common routine to print detail line                 *
      *                                                               *
      *  Called By: S200                                              *
      *                                                               *
      *****************************************************************
      *
     C     COM903        BEGSR
      *
     C                   MOVE      POBRCA        @@BRCH                         Branch code
     C                   Z-ADD     POCNUM        @@CUST                         Customer
     C                   MOVE      POCYCD        @@CCYC                         Currency code
     C                   Z-ADD     POACOD        @@ACOD                         A/c code
     C                   Z-ADD     POACSQ        @@ACSQ                         A/c seq
      *
      ** Loop & process all records for the account
      *
     C     *IN40         DOWEQ     *OFF                                         Until eof
      *
     C     @@PRTL        IFGE      58                                           Print overflow
     C                   EXSR      COM904                                       Header
     C                   ENDIF
      *
     C     PODRCR        IFEQ      *ZERO                                        Debit
     C                   Z-SUB     POPSTA        ZFLD15                         Raw value
     C                   ELSE
     C                   Z-ADD     POPSTA        ZFLD15                         Raw value
     C                   ENDIF
      *
     C                   EXSR      ZFRPED                                       Format amount
     C                   MOVE(P)   ZOUT22        P1PSTA                         Postings
      *
     C     P1ACNO        IFEQ      *BLANKS                                      Second line
     C                   WRITE     P1DTL2                                       Detail line
     C                   ELSE
     C                   WRITE     P1DTL1                                       Detail line
     C                   MOVE      *BLANKS       P1ACNO                         A/c number
     C                   ENDIF
      *
     C     @@KPOS        READE     ACCNTPO                                40    Get next
      *
     C                   ENDDO
      *
     C     P1ACNO        IFEQ      *BLANKS                                      Detail printed
      *
     C     @@PRTL        IFGE      57                                           Print overflow
     C                   EXSR      COM904                                       Header
     C                   ENDIF
      *
     C                   WRITE     P1DTL3                                       Detail line
     C                   CLEAR                   P1DTL4                         Clear format
     C     @@KBAL        CHAIN     ACCNTBL                            41        Get balance
      *
     C     *IN41         IFEQ      *OFF                                         Balance found
      *
     C                   Z-ADD     BLPSTA        ZFLD15                         Raw value
     C                   EXSR      ZFRPED                                       Format amount
     C                   MOVE(P)   ZOUT22        P1TOTP                         Postings
      *
     C                   Z-ADD     BLOPEN        ZFLD15                         Raw value
     C                   EXSR      ZFRPED                                       Format amount
     C                   MOVE(P)   ZOUT22        P1OPEN                         Opening bal
      *
     C                   Z-ADD     BLCLOS        ZFLD15                         Raw value
     C                   EXSR      ZFRPED                                       Format amount
     C                   MOVE(P)   ZOUT22        P1CLOS                         Closing bal
      *
     C                   Z-ADD     BLDIFF        ZFLD15                         Raw value
     C                   EXSR      ZFRPED                                       Format amount
     C                   MOVE(P)   ZOUT22        P1DIFF                         Difference
      *
     C                   WRITE     P1DTL4                                       Detail line
      *
     C                   ENDIF
      *
     C     @@KPOS        SETGT     ACCNTPO                                      Set pointer
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  COM904 - Common routine to perform page break                *
      *                                                               *
      *  Called By: S200                                              *
      *                                                               *
      *****************************************************************
      *
     C     COM904        BEGSR
      *
     C                   WRITE     P1HEAD                                       Header
     C                   WRITE     P1COLM                                       Column
      *
     C                   ENDSR
      *
     C********************************************************************
     C**
     C**   ZDATE2 SR. TO CONVERT A DAY NUMBER TO DATE FORMATS.
     C**
     C**   THE YEAR 2000, BEING DIVISIBLE BY 400, IS A LEAP YEAR.
     C**
     C     ZDATE2        BEGSR                                                  *** ZDATE2 ***
     C**
     C**   CLEAR LEAP YEAR WORK FIELD.
     C                   MOVE      'N'           ZLEAP             1
     C**
     C**   CLEAR DATE FIELDS.
     C                   Z-ADD     0             ZDATE             6 0
     C                   MOVEL     '       '     ZADATE            7
     C**
     C**   CALCULATION TO DEFINE INPUT DAY NUMBER.
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C**
     C**   DETERMINE YEAR NUMBER.
     C**
     C**   ADJUST DAY NUMBER IN CASE LAST DAY OF YEAR.
     C     ZDAYNO        SUB       1             ZDAYN1            5 0
     C     ZDAYN1        IFLT      0
     C                   GOTO      ZDEND2
     C                   END
     C**
     C**   CALCULATE NUMBER OF 4 YEAR SPANS SINCE 31/12/1971.
     C     ZDAYN1        DIV       1461          ZLYR              2 0
     C                   MVR                     ZDAYN1                         SAVE REMAINING
     C**                                                   DAYS
     C**   CALCULATE NUMBER OF REMAINING YEARS.
     C                   Z-ADD     1             ZWRK2             2 0
     C     ZDTAG1        TAG                                                    ** ZDTAG1 TAG *
     C     ZDAYN1        IFGE      ZYDY(ZWRK2)
     C     ZWRK2         ADD       1             ZWRK2
     C                   GOTO      ZDTAG1
     C                   END
     C*
     C     ZWRK2         SUB       1             ZWRK2
     C**
     C**   DECREMENT DAY NO. BY DAYS IN REMAINING YEARS.
     C     ZWRK2         IFNE      0
     C     ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
     C                   END
     C**
     C**   CALCULATE ACTUAL YEAR NUMBER.
     C     ZLYR          MULT      4             ZWRK3             3 0
     C     ZWRK3         ADD       72            ZWRK3                          BASE IS 1972
     C                   Z-ADD     ZWRK3         ZYEAR             2 0
     C     ZYEAR         ADD       ZWRK2         ZYEAR                          YEAR
     C**
     C**   DETERMINE MONTH NUMBER.
     C**
     C**   ADJUST DAY NO. IN CASE LAST DAY OF LEAP YEAR FEBRUARY.
     C     ZWRK2         IFEQ      0
     C     ZDAYN1        IFEQ      59
     C                   MOVE      'Y'           ZLEAP
     C                   END
     C     ZDAYN1        IFGE      59
     C     ZDAYN1        SUB       1             ZDAYN1
     C                   END
     C                   END
     C**
     C**   CALCULATE MONTH NUMBER.
     C                   Z-ADD     2             ZWRK2
     C     ZDTAG2        TAG                                                    ** ZDTAG2 TAG *
     C     ZDAYN1        IFGE      ZMDY(ZWRK2)
     C     ZWRK2         ADD       1             ZWRK2
     C                   GOTO      ZDTAG2
     C                   END
     C*
     C     ZWRK2         SUB       1             ZWRK2
     C**
     C                   Z-ADD     ZWRK2         ZMTH              2 0          MONTH
     C**
     C**   DETERMINE DAY OF MONTH.
     C**
     C**   ADD BACK LAST DAY OF YEAR ADJUSTMENT.
     C     ZDAYN1        ADD       1             ZDAYN1
     C**
     C**   CALCULATE DAY OF MONTH.
     C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0          DAY
     C**
     C**   ADD BACK LEAP YEAR 29TH FEBUARY ADJUSTMENT, IF REQUIRED.
     C     ZLEAP         IFEQ      'Y'
     C     ZDAY          ADD       1             ZDAY
     C                   END
     C**
     C**   FORMAT DATE, DDMMYY OR MMDDYY.
     C  N98              MOVEL     ZDAY          ZWRK4             4 0
     C   98              MOVE      ZDAY          ZWRK4
     C  N98              MOVE      ZMTH          ZWRK4
     C   98              MOVEL     ZMTH          ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE
     C**
     C**   FORMAT ALPHA DATE, DDMMMYY.
     C                   MOVEL     ZDAY          ZWRK5             5
     C     ZDAY          IFLT      10
     C                   MOVEL     ' '           ZWRK5
     C                   END
     C                   MOVE      ZMNM(ZMTH)    ZWRK5
     C                   MOVEL     ZWRK5         ZADATE
     C                   MOVE      ZYEAR         ZADATE
     C**
     C     ZDEND2        ENDSR                                                  * ZDEND2 ENDSR*
      *
      *****************************************************************
     C**                                                                 *
     C** ZFRPED subroutine to insert a decimal point and sign into a     *
     C** numeric field and to blank out leading zeros (optionaly         *
     C** inserting commas).                                              *
     C**     Input fields:   ZFLD15 15/0                                 *
     C**                     ZDECS  1/0                                  *
     C**                     ZECODE 1/  ('A','C','J','L' or blank)       *
     C**                                ( Default is 'J')                *
     C**     Arrays:         ZS1    15/1/0                               *
     C**                     ZS2    22/1/                                *
     C**                                                                 *
     C**     Output fields:  ZOUT22 22                                   *
     C**     Output fields:  ZOUT25 25  (ALIGNED BY DECIMAL POINT)       *
     C**          (The last 2 characters will be '  ','CR',or '- ')      *
     C**
     C     ZFRPED        BEGSR                                                  **  ZFRPED   *
     C*
     C* Define/Clear fields
     C*
     C                   Z-ADD     ZFLD15        ZFLD15           15 0
     C                   Z-ADD     ZDECS         ZDECS             1 0
     C                   MOVE      ZECODE        ZECODE            1
     C                   MOVE      *BLANKS       ZOUT22           22
     C                   MOVE      *BLANKS       ZOUT25           25
     C     ZECODE        IFEQ      *BLANKS
     C                   MOVE      'J'           ZECODE
     C                   END
     C*
     C*       SET UP WORK FIELDS
     C*
     C                   Z-ADD     0             ZS1
     C                   MOVE      ' '           ZS2
     C*
     C                   Z-ADD     15            Z1                2 0
     C                   Z-ADD     20            Z2                2 0
     C*
     C     15            SUB       ZDECS         ZINTS             2 0
     C*
     C* Check if numeric field is negative
     C*
     C     ZFLD15        IFLT      *ZEROS
     C     ZECODE        IFEQ      'A'
     C     ZECODE        OREQ      'C'
     C                   MOVEA     'CR'          ZS2(21)
     C                   ELSE
     C                   MOVE      '-'           ZS2(21)
     C                   END
     C                   Z-SUB     ZFLD15        ZFLD15
     C                   END
     C*
     C                   Z-ADD     ZFLD15        ZWRK15
     C*
     C*       CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES
     C*
     C     ZDECS         CABEQ     0             ZS10
     C*
     C*       SET UP DECIMALS
     C*
     C                   Z-ADD     *ZEROS        ZCNT              1 0
     C     ZCNT          DOUEQ     ZDECS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z2
     C                   ADD       1             ZCNT
     C                   SUB       1             Z1
     C                   END
     C*
     C*       PUT IN DECIMAL PLACE
     C*
     C                   MOVE      '.'           ZS2(Z2)
     C                   SUB       1             Z2
     C*
     C     ZS10          TAG                                                    ** ZS10 TAG **
     C*
     C*       SET UP INTEGERS
     C*
     C                   Z-ADD     *ZEROS        CNT3              1 0
     C     Z1            DOUEQ     *ZEROS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z1
     C                   SUB       1             Z2
     C*
     C* If edit code is 'J', insert a ',' before each group of three
     C* digits - not if beginning of array reached.
     C*
     C     Z2            IFGT      *ZEROS
     C     ZECODE        ANDEQ     'J'
     C     Z2            ORGT      *ZEROS
     C     ZECODE        ANDEQ     'A'
     C                   ADD       1             CNT3
     C     CNT3          IFEQ      3
     C                   MOVE      ','           ZS2(Z2)
     C                   SUB       1             Z2
     C                   Z-ADD     *ZEROS        CNT3
     C                   END
     C                   END
     C*
     C                   END
     C*
     C*       PUT IN LEADING BLANKS
     C*
     C                   Z-ADD     1             Z2
     C     ZS2(Z2)       DOWEQ     '0'
     C     ZS2(Z2)       OREQ      ' '
     C     ZS2(Z2)       OREQ      ','
     C                   MOVE      ' '           ZS2(Z2)
     C                   ADD       1             Z2
     C     Z2            CABEQ     23            ZS20
     C                   END
     C*
     C*       IF NO INTEGERS PUT IN LEADING ZERO
     C*
     C     ZS20          TAG                                                    ** ZS20 TAG **
     C*
     C     Z2            IFEQ      23
     C                   SUB       2             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   ELSE
     C*
     C     ZS2(Z2)       IFEQ      '.'
     C                   SUB       1             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   END
     C                   END
     C*
     C*       SET UP OUTPUT FIELD
     C*
     C                   MOVEA     ZS2           ZOUT22
     C*
     C     ZDECS         IFEQ      0
     C                   MOVE      ZOUT22        ZOUT0
     C                   ELSE
     C**
     C     ZDECS         IFEQ      1
     C                   MOVE      ZOUT22        ZOUT1
     C                   ELSE
     C**
     C     ZDECS         IFEQ      2
     C                   MOVE      ZOUT22        ZOUT2
     C                   ELSE
     C**
     C                   MOVE      ZOUT22        ZOUT3
     C                   END
     C**
     C                   END
     C**
     C                   END
     C**
     C                   ENDSR
     C*
     C********************************************************************
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *  #AUDIT - Produce #AUDIT Report and End Program               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  *** *PSSR  ***
      *
      ** Prevent recursive call
      *
     C     @@PSSR        IFEQ      'N'                                          Recursive call
      *
     C                   MOVE      'Y'           @@PSSR                         *PSSR Executed
      *
      ** Update local data area
      *
     C     DBPGM         IFEQ      *BLANKS
     C**********         MOVEL     'GLM035A'     DBPGM                          Set program idLUC109
     C                   MOVEL     'XX00035A'    DBPGM                          Set program idLUC109
     C                   ENDIF
      *
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
     C                   MOVE      *ON           *IN88                          Database error
     C                   MOVE      *ON           *INU7                                         15996
     C                   MOVE      *ON           *INU8                                         15996
     C                   DUMP                                                   Dump system var
      *
     C                   EXSR      S300                                         Stop run
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ***
**  CPY@
(c) Finastra International Limited 2016
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
