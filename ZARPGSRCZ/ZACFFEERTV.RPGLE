     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Deal Retrieve CFFEED TRAM status fields')
      *****************************************************************
      *                                                               *
      *  Midas - Foriegn Exchange Dealing Module                      *
      *                                                               *
      *  ZACFFEERTV - DEAL RETRIEVE CFFEED TRAM STATUS FIELDS         *
      *                                                               *
      *  Function:  This module retrieves the TRAM status from        *
      *             the database for a given deal                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 238709             Date 06Jul06               *
      *  Prev Amend No. BUG7287            Date 23May05               *
      *                 BUG6512  *CREATE   Date 21Apr05               *
      *---------------------------------------------------------------*
      *                                                               *
      *  238709 - Allow Counterparty and Broker Status to be picked   *
      *           up for 'FI' deals on CFFEEDPD.                      *
      *  BUG7287- Allow Action code 'R'                               *
      *  BUG6512- TRAM fields retreived in DSP module in Midas. So    *
      *           this new module created for Midasplus               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FCFFEEDL0  IF   E           K DISK
 
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
 
      ** SD data area                                                                         CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D/COPY WNCPYSRC,FXFXDLID01
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** Variables
     D Dsp_CP          S              1
     D Dsp_BK          S              1
 
     D WI              S              3P 0
 
     D WFuncType       S              8
     D WIdntifier      S             40
     D WBranch         S              3
     D PRetCode        S              7A
     D POption         S              7A
     D PFunc           S              8A
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      * Get TRAM details
      *
     C                   EXSR      TramDtl
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * TramDtl - Retrieve Details from CFFEED file
      *****************************************************************
     C     TramDtl       BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I', 'A, 'D', 'E' or 'X'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'X'
     C     DDACTN        ANDNE     'R'                                                       BUG7287
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0100'     MsgIdArr(Ix)
     C                   GOTO      ETramDtl
     C                   END
      *
      *
      ** Confirmation matching status - if not turned on, do not
      ** display the fields
      *
     C                   IF        BGCFMT = 'Y'
 
     C                   EVAL      Dsp_CP = 'Y'
     C                   EVAL      Dsp_BK = 'Y'
 
     C                   ELSE
 
     C                   EVAL      Dsp_CP = 'N'
     C                   EVAL      Dsp_BK = 'N'
 
     C                   ENDIF
 
      ** Do not display both confirmation matching status lines if..
      ** ... mode is insert
      *
     C                   If        DDACTN = 'I'
 
     C                   Eval      Dsp_CP = 'N'
     C                   Eval      Dsp_BK = 'N'
 
     C                   EndIf
      *
     C                   EXSR      Conf_Match
 
     C     ETramDtl      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Conf_Match - Set up confirmation matching screen info         *
      *                                                               *
      *****************************************************************
     C     Conf_Match    BegSr
      *
      *
      ** ... do not display the broker status if the broker is 'PHON'
      ** 'TELX', 'MAIL' or 'SWAP'.
      *
     C                   If        DDBRKR = 'PHON' or DDBRKR = 'TELX' or
     C                             DDBRKR = 'MAIL' or DDBRKR = 'SWAP'
     C                   Eval      Dsp_BK = 'N'
     C                   EndIf
      *
      ** Clear previous information.
      *
     C                   Eval      @CPST = *Blanks
     C                   Eval      @BKST = *Blanks
      *
      ** If the confirmation matching details are going to be displayed,
      ** get the status from file.
      *
     C                   If        Dsp_CP = 'Y' or Dsp_BK = 'Y'
      *
      ** Set up key to chain to file
      *
     C                   Move      *Blanks       CFFeed_Key       16
     C                   Move      *Blanks       Work_8            8
     C                   Move      *Blanks       Work_11          11
 
     C                   MoveL     'DL'          Work_8
     C                   Move      DDDLNO        Work_8
     C                   MoveL     Work_8        Work_11
     C                   Move      '999'         Work_11
     C                   MoveL     Work_11       CFFeed_Key
      *
      ** Check file for latest status of deal
      *
     C                   Move      *Off          *IN91                                        238709
     C     CFFeed_Key    SetGT     CFFEEDL0
     C                   ReadP     CFFEEDL0                               99
 
     C                   If        *IN99 = *Off
     C                   MoveL     IMRF          Work8_2           8
     C     Work_8        Comp      Work8_2                            9999
     C                   EndIf
      *                                                                                       238709
      ** Retry with type 'FI' if 'DL' key not found.                                          238709
      *                                                                                       238709
     C                   If        *IN99 = *On                                                238709
     C                   MoveL     'FI'          Work_8                                       238709
     C                   MoveL     'FI'          CFFeed_Key                                   238709
      *                                                                                       238709
     C     CFFeed_Key    SetGT     CFFEEDL0                                                   238709
     C                   ReadP     CFFEEDL0                               91                  238709
                                                                                              238709
     C                   If        *IN91 = *Off                                               238709
     C                   MoveL     IMRF          Work8_2           8                          238709
     C     Work_8        Comp      Work8_2                            9191                    238709
     C                   EndIf                                                                238709
     C                   EndIf                                                                238709
      *
      ** If no record with deal key set status to 00 - No feedback yet,
      ** otherwise set up the status as found on file
      *
     C**********         If        *IN99 = *On                                                238709
     C                   If        *IN99 = *On and *IN91 = *On                                238709
     C                   Move      '00'          @CPST             2
     C                   Move      '00'          @BKST             2
     C                   Else
     C                   Move      CPSX          @CPST
     C                   Move      BKSX          @BKST
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndSr
      ********************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      /EJECT
     C*****************************************************************
     C* INIT - INITIALIZATION
     C*****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   MOVEL     'Y'           OKACTN
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO            6
      *
      * Broker
     C                   PARM                    DDBRKR            4
      *
      * OUTPUTS
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * Counterparty Status
     C                   PARM                    @CPST             2
     C                   PARM                    Dsp_CP            1
      *
      * Broker Status
     C                   PARM                    @BKST             2
     C                   PARM                    Dsp_BK            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
 
      ** Warning error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Warning array index (3P0) from/to caller
 
     C                   PARM                    WI
 
     C/COPY WNCPYSRC,FXFXDLIC04
      *
      ** Initialize program name
      *
     C                   MOVEL     'FXFXDLRTT'   DBPGM
      *
      * Key Lists
      *
      *
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
