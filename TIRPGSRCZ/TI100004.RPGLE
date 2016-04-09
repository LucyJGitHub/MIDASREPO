     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Bulk Export Control Screen')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Module                              *
      *                                                               *
      *  TI100004 - Bulk Export Control Screen                        *
      *                                                               *
      *  Function:  This program is called as a control confirmation  *
      *             screen for starting bulk export program.          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD031150           Date 29Oct14               *
      *  Prev Amend No. CTI006  *CREATE    Date 31Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031150 - Changes to Export of Base Rates                   *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface                *
      *                                                               *
      *****************************************************************
 
      ** Midas TI Bulk Export Control File
 
     FTI100004DFCF   E             WORKSTN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Text constants
 
     D CTEXT1          C                   CONST('Start Bulk Export of-
     D                                      Account Branch Change')
 
     D CTEXT2          C                   CONST('Start Bulk Export of-
     D                                      Account Officer')
 
     D CTEXT3          C                   CONST('Start Bulk Export of-
     D                                      Account Type')
 
     D CTEXT4          C                   CONST('Start Bulk Export of-
     D                                      Analysis Code')
 
     D CTEXT5          C                   CONST('Start Bulk Export of-
     D                                      Base Rate')
 
     D CTEXT6          C                   CONST('Start Bulk Export of-
     D                                      Base Rate Code')
 
     D CTEXT7          C                   CONST('Start Bulk Export of-
     D                                      Branch')
 
     D CTEXT8          C                   CONST('Start Bulk Export of-
     D                                      Branch Calendar')
 
     D CTEXT9          C                   CONST('Start Bulk Export of-
     D                                      Country')
 
     D CTEXT10         C                   CONST('Start Bulk Export of-
     D                                      Country Calendar')
 
     D CTEXT11         C                   CONST('Start Bulk Export of-
     D                                      Currency')
 
     D CTEXT12         C                   CONST('Start Bulk Export of-
     D                                      Currency Calendar')
 
     D CTEXT13         C                   CONST('Start Bulk Export of-
     D                                      Currency Spot Rate')
 
     D CTEXT14         C                   CONST('Start Bulk Export of-
     D                                      Customer Type')
 
     D CTEXT15         C                   CONST('Start Bulk Export of-
     D                                      Default Nostro')
 
     D CTEXT16         C                   CONST('Start Bulk Export of-
     D                                      FX Rate')
 
     D CTEXT17         C                   CONST('Start Bulk Export of-
     D                                      Group')
 
     D CTEXT18         C                   CONST('Start Bulk Export of-
     D                                      Nostro')
 
     D CTEXT19         C                   CONST('Start Complete Bulk -
     D                                     Extract')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Midas SD Rundate Data Area
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WPos            S              2P 0
     D WTxt            S             78A
     D PEntry          S              2A
     D PFormat         S             10A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ****************************************************************
      *                                                              *
      *  Main processing                                             *
      *                                                              *
      ****************************************************************
 
      ** Get job details
     C                   IN        RUNDAT
     C                   EVAL      USER     = PSUser
     C                   EVAL      WSID     = PSJobName
     C                   EVAL      RUNA     = AGMRDT
     C                   EVAL      WTxt     = *BLANKS
     C                   EVAL      PFormat  = *BLANKS
 
     C                   SELECT
      ** AccountBranchChange
     C                   WHEN      PEntry   = '1'
     C                   EVAL      WTxt     = CTEXT1
     C                   EVAL      PFormat  = 'TIACCTBC'
     C                   EXSR      SRAlign
      ** AccountOfficer
     C                   WHEN      PEntry   = '2'
     C                   EVAL      WTxt     = CTEXT2
     C                   EVAL      PFormat  = 'TISDACOF'
     C                   EXSR      SRAlign
      ** AccountType
     C                   WHEN      PEntry   = '3'
     C                   EVAL      WTxt     = CTEXT3
     C                   EVAL      PFormat  = 'TISDACOD'
     C                   EXSR      SRAlign
      ** AnalysisCode
     C                   WHEN      PEntry   = '4'
     C                   EVAL      WTxt     = CTEXT4
     C                   EVAL      PFormat  = 'TISDTICS'
     C                   EXSR      SRAlign
      ** BaseRate
     C                   WHEN      PEntry   = '5'
     C                   EVAL      WTxt     = CTEXT5
     C**********         EVAL      PFormat  = 'TISDBSRT'                                    MD031150
     C                   EVAL      PFormat  = 'TISDBSHS'                                    MD031150
     C                   EXSR      SRAlign
      ** BaseRateCode
     C                   WHEN      PEntry   = '6'
     C                   EVAL      WTxt     = CTEXT6
     C                   EVAL      PFormat  = 'TISDBSCD'
     C                   EXSR      SRAlign
      ** Branch
     C                   WHEN      PEntry   = '7'
     C                   EVAL      WTxt     = CTEXT7
     C                   EVAL      PFormat  = 'TIBRCH'
     C                   EXSR      SRAlign
      ** BranchCalendar
     C                   WHEN      PEntry   = '8'
     C                   EVAL      WTxt     = CTEXT8
     C                   EVAL      PFormat  = 'TIBRCCAL'
     C                   EXSR      SRAlign
      ** Country
     C                   WHEN      PEntry   = '9'
     C                   EVAL      WTxt     = CTEXT9
     C                   EVAL      PFormat  = 'TISDCTRY'
     C                   EXSR      SRAlign
      ** CountryCalendar
     C                   WHEN      PEntry   = '10'
     C                   EVAL      WTxt     = CTEXT10
     C                   EVAL      PFormat  = 'TICOCTRY'
     C                   EXSR      SRAlign
      ** Currency
     C                   WHEN      PEntry   = '11'
     C                   EVAL      WTxt     = CTEXT11
     C                   EVAL      PFormat  = 'TISDCURR'
     C                   EXSR      SRAlign
      ** CurrencyCalendar
     C                   WHEN      PEntry   = '12'
     C                   EVAL      WTxt     = CTEXT12
     C                   EVAL      PFormat  = 'TICURHOL'
     C                   EXSR      SRAlign
      ** CurrencySpotRate
     C                   WHEN      PEntry   = '13'
     C                   EVAL      WTxt     = CTEXT13
     C                   EVAL      PFormat  = 'TISDSPOT'
     C                   EXSR      SRAlign
      ** CustomerType
     C                   WHEN      PEntry   = '14'
     C                   EVAL      WTxt     = CTEXT14
     C                   EVAL      PFormat  = 'TISDINST'
     C                   EXSR      SRAlign
      ** DefaultNostro
     C                   WHEN      PEntry   = '15'
     C                   EVAL      WTxt     = CTEXT15
     C                   EVAL      PFormat  = 'TISDDFNO'
     C                   EXSR      SRAlign
      ** FXRate
     C                   WHEN      PEntry   = '16'
     C                   EVAL      WTxt     = CTEXT16
     C                   EVAL      PFormat  = 'TISDFXRT'
     C                   EXSR      SRAlign
      ** Group
     C                   WHEN      PEntry   = '17'
     C                   EVAL      WTxt     = CTEXT17
     C                   EVAL      PFormat  = 'TIGROUP'
     C                   EXSR      SRAlign
      ** Nostro
     C                   WHEN      PEntry   = '18'
     C                   EVAL      WTxt     = CTEXT18
     C                   EVAL      PFormat  = 'TISDNOST'
     C                   EXSR      SRAlign
      ** Complete Bulk Extract
     C                   WHEN      PEntry   = '19'
     C                   EVAL      WTxt     = CTEXT19
     C                   EVAL      PFormat  = *BLANKS
     C                   EXSR      SRAlign
 
     C                   ENDSL
 
      ** Loop until F3 or ENTER is pressed
 
     C                   DOU       *IN03  = *ON
     C                             OR *IN10 = *OFF
 
     C                   EXFMT     TI100004F0
 
     C                   IF        *IN03  = *OFF
     C                             AND *IN10   = *OFF
      ** Bulk program
     C                   CALL(E)   'TIC100000'
     C                   PARM      PFormat       PFormatX         10
 
     C                   IF        %ERROR()
     C                   EVAL      *IN10  = *ON
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PEntry
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAlign - Align text to screen.                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRAlign       BEGSR
     C                   EVAL      WPos = (78-%LEN(%TRIMR(WTxt)))/2+1
     C                   EVAL      RTXT = *BLANKS
     C                   EVAL      %SUBST(RTXT:WPos) = WTxt
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   IF        RunBefore <> 'Y'
     C
     C                   EVAL      RunBefore = 'Y'
     C
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   RETURN
     C                   ENDSR
