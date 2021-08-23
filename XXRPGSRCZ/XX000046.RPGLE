     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Calculate next payment/statement date')                *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM046*-*Calculate*next*payment/statement*date****************                       LUC109
      *  XX000046 - Calculate next payment/statement date             *                       LUC109
      *                                                               *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1998********************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. MMI043  *CREATE    Date 16Dec98               *
      *                 nnnnnn             Date ddMmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MMI043 - Head Office Reporting                               *
      *                                                               *
      *****************************************************************
      *STANDARD SUBROUTINE - ZFREQB
      *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      *
      *Purpose:
      *~~~~~~~~
      *To calculate the day number of the next payment/statement date
      *from current date/day in month and frequency code.
      *
      *
      *Input:
      *~~~~~
      *
      *ZFREQ -  A one character field containing the frequency
      *           code.
      *
      *ZDAYNO -   A five digit field containing the base date
      *           (day number of current payment date).
      *
      *ZMDAY -   A two digit field containing the day of the month
      *          (required only for certain frequencies:
      *          M R T Q X Y L B) on which payment should fall
      *
      *ZCCY  -   A three character field containing the currency
      *           code. For processing to check a working day has
      *          been found, this currency code is used.
      *
      *ZLOC  -   A three character field containing the location
      *           code. This may be left blank if no location is
      *           required.
      *
      *
      *Output:
      *~~~~~~
      * ZDAYNO:
      *   - a five digit field containing the day no. for the next
      *     payment date calculated
      *
      * ZZERR@:
      *   - a 7 alpha field set to blank if the subroutine runs
      *   - successfully and '*ERROR ' if an error occurs.
      *****************************************************************
      *
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  #INIT  - Initial Processing                                  *
      *  #TERM  - Program termination                                 *
      *                                                               *
      *****************************************************************
      *
      * E Specs
      ***/C*PY*ZSRSRC,ZHOLE                                                                   LUC109
      ***/C*PY*ZSRSRC,ZFREQBZ1                                                                LUC109
      ***/C*PY*ZSRSRC,ZDATE2Z1                                                                LUC109
     D/COPY ZSRSRC,ZHOLELE                                                                    LUC109
     D ZFMD            S              2    DIM(12) CTDATA PERRCD(12)                          LUC109
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 LUC109
      * I Specs
      ***/C*PY*ZSRSRC,ZHOLDS                                                                  LUC109
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     LUC109
      ***/C*PY*ZSRSRC,ZHOLI                                                                   LUC109
     D/COPY ZSRSRC,ZHOLILE                                                                    LUC109
      ***/C*PY*ZSRSRC,ZAOZ1                                                                   LUC109
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     LUC109
      ***/C*PY*ZSRSRC,ZAOZ2                                                                   LUC109
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  LUC109
      *
     D RUNDT           DS
     D*
     D* External DTAARA for run-date
     D*
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      *
      *****************************************************************
      *
     C                   EXSR      #INIT                                        Housekeeping
      *
     C                   EXSR      ZFREQB                                       Main process
      *
     C                   EXSR      #TERM                                        Return
      *
     C* Subroutines
      ***/C*PY*ZSRSRC,ZFREQBZ2                                                                LUC109
      /COPY ZSRSRC,ZFREQBZ2LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDATE1Z2                                                                LUC109
      /COPY ZSRSRC,ZDATE1Z2LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDATE2Z2                                                                LUC109
      /COPY ZSRSRC,ZDATE2Z2LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZCHKH                                                                   LUC109
      /COPY ZSRSRC,ZCHKHLE                                                                    LUC109
      ***/C*PY*ZSRSRC,ZACCH                                                                   LUC109
      /COPY ZSRSRC,ZACCHLE                                                                    LUC109
     C**
      *****************************************************************
      *                                                               *
      *  INIT - Program initialisation.                               *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #INIT         BEGSR                                                  Initialisation
      *
      ** Entry parameters
      *
     C     *ENTRY        PLIST                                                  Parameters
     C                   PARM                    @FREQ             1            Freq Ind
     C                   PARM                    @DAYNO            5 0          Base Date
     C                   PARM                    @MDAY             2 0          Day of Mth
     C                   PARM                    @CCY              3            Currency
     C                   PARM                    @LOC              3            Locn-optionl
     C                   PARM                    @RETRN            7            Return Code
     C                   PARM                    @RETDT            5 0          Return Date
      *
     C                   MOVE      @FREQ         ZFREQ
     C                   Z-ADD     @DAYNO        ZDAYNO
     C                   Z-ADD     @MDAY         ZMDAY
     C                   MOVE      @CCY          ZCCY
     C                   MOVE      @LOC          ZLOC
      * Define data area
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C                   IN        RUNDT
      * Check system date format, DDMMYY OR MMDDYY.
     C     DATF          COMP      'M'                                    98    MMDDYY, 98 ON
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *    #TERM     - Program termination                            *
      *                                                               *
      *    CALLED BY - #PROC, *PSSR                                   *
      *    CALLS     - NONE                                           *
      *                                                               *
      *****************************************************************
      *
     C     #TERM         BEGSR
      *
     C                   Z-ADD     ZDAYNO        @RETDT
     C                   MOVE      ZZERR@        @RETRN
     C                   RETURN                                                 Return control
      *
     C                   ENDSR
      ****************************************************************
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
