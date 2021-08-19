     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Find nth working day from given midas day number')     *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM043*-*Find*nth*working*day*from*given*midas*day*number*****                       LUC109
      *  XX000043 - Find nth working day from given midas day number  *                       LUC109
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
      *  Prev Amend No. MMI043  *CREATE    Date 16Drc98               *
      *                 nnnnnn             Date ddMmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MMI043 - Head Office Reporting                               *
      *                                                               *
      *****************************************************************
      *SD STANDARD SUB-ROUTINE - ZFWDT
      *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      *Purpose:
      *~~~~~~~~
      *To calculate the nth working day forward from a given
      *start date for any particular currency and (optional) location.
      *
      *
      *Requirements:
      *~~~~~~~~~~~~
      *Input:
      *~~~~~
      * ZDAYNO
      *   - A five digit numeric field containing the day number, as a
      *     number of days from 31DEC71, that we wish to calculate the
      *     number of days forward from.
      *
      * ZCCY
      *   - A three-character alphabetic field containing the name of
      *     the required currency.
      *
      * ZLOC
      *   - A three-character alphabetic field containing the name of
      *     the required location. This field is optional and should be
      *     blank if no location is to be specified.
      *
      * ZNRDYS
      *   - A two digit numeric field containing the number of days
      *     forward that is to be calculated. Note that zero is a valid
      *     value.
      *
      *
      *Output:
      *~~~~~~
      * ZDYNBR
      *   - A five digit numeric field that contains the value of the
      *     nth working day forward from the input date, expressed as a
      *     number of days from 31DEC71.
      *
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
      ***/C*PY*ZSRSRC,ZHOLE                                                                   LUC109
      ***/C*PY*ZSRSRC,ZHOLI                                                                   LUC109
      ***/C*PY*ZSRSRC,ZHOLDS                                                                  LUC109
      /COPY ZSRSRC,ZHOLELE                                                                    LUC109
      /COPY ZSRSRC,ZHOLILE                                                                    LUC109
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     LUC109
      * Second DS for access programs, long data structure                                    LUC109
      *
      *
      *****************************************************************
      *
     C                   EXSR      #INIT                                        Housekeeping
      *
     C                   EXSR      ZFWDT                                        Main process
      *
     C                   EXSR      #TERM                                        Return
      *
     C**
      ***/C*PY*ZSRSRC,ZACCH                                                                   LUC109
      ***/C*PY*ZSRSRC,ZFWDT                                                                   LUC109
     C/COPY ZSRSRC,ZACCHLE                                                                    LUC109
     C/COPY ZSRSRC,ZFWDT_ILE                                                                  LUC109
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
     C                   PARM                    @DAYNO            5 0          Input Day #
     C                   PARM                    @NRDYS            2 0          # Wk Dys Fwd
     C                   PARM                    @CCY              3            Currency
     C                   PARM                    @LOC              3            Locn-optionl
     C                   PARM                    @DYNBR            5 0          Output Day #
      *
     C                   Z-ADD     @DAYNO        ZDAYNO
     C                   Z-ADD     @NRDYS        ZNRDYS
     C                   MOVE      @CCY          ZCCY
     C                   MOVE      @LOC          ZLOC
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
     C                   MOVE      ZDYNBR        @DYNBR
     C                   RETURN                                                 Return control
      *
     C                   ENDSR
      *
