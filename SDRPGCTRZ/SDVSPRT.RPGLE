     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Spot Rate')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Market Data Feed Details Val. *
      *                                                               *
      *  SDVSPRT - Validate Spot Rate                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 212370             Date 18Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 196570             Date 23Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 03Nov00               *
      *                 CAP057  *CREATE    Date 03Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  212370 - System accepts new spot rate of more than +/-10%    *
      *           difference from the old rate. Should not allow this.*
      *  196570 - Patch for Market Data Feed                          *
      *  CSD006 - Market Data Feed                                    *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs          *
      *                                                               *
      *****************************************************************


      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** EXTERNAL DS FOR CURRENCY DETAILS
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Market data feed installation control data                             CSD006
     D SDMDFC        E DS                  EXTNAME(SDMDFCPD)                    CSD006
      *
      * Data Structures used by Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Bank details Structure
      *
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

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

     D CSD006F         S              1A

      ** field to calculate difference between rates                                          196570
     D WACTRDIF        S             29P 8                                                    196570
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Initialization

     C                   MOVE      *BLANK        RetCodeIn

     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   EVAL      AVTLEX = 'N'
     C                   Z-ADD     AVSPRT        PrevSprt

      *
      ** VALIDATION
      *
      ** Common validation
     C                   EXSR      COMSPRT
     C                   IF        DDSPRTOK = 'Y' AND CSD006F='Y'               CSD006
     C                   IF        DDDTFR <> *BLANK                             CSD006
      ** MDF validation                                                         CSD006
     C                   EXSR      MDFSPRT                                      CSD006
     C                   ENDIF                                                                212370
     C                   ELSE                                                   CSD006
      ** Existing validation
     C                   EXSR      EXSSPRT
     C**********         ENDIF                                                         CSD006 212370
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************         CSD006
      ** VALIDATION RELATED TO MARKET DATA FEED                                 CSD006
      *****************************************************************         CSD006
     C     MDFSPRT       BEGSR                                                  CSD006

      ** Value of ICD tolerance allows tolerance checking ?                     CSD006
     C                   IF        WSETMAX = 'N'                                CSD006
     C                   CALLB     'SDVMDIN'                                    CSD006
     C                   PARM                    RetCodeIn                      CSD006
     C                   PARM                    DDMDIN                         CSD006
     C                   PARM                    AVMDIN                         CSD006
     C                   PARM                    DDCYCD                         CSD006
     C                   PARM      *BLANKS       FldNameArr                     CSD006
     C                   PARM      *BLANKS       MsgIdArr                       CSD006
     C                   PARM      *BLANKS       MsgDtaArr                      CSD006
     C                   PARM      'Y'           DDMDINOK          1

      ** Impossible to check the spot rate against the tolerance                CSD006
     C                   IF        DDMDINOK <> 'Y'                              CSD006
     C                   EVAL      DDSPRTOK = 'N'                               CSD006
     C                   EVAL      Idx = Idx + 1                                CSD006
     C                   EVAL      FldNamXAr(Idx) = 'DDSPRT    '                CSD006
     C                   EVAL      MsgIdXAr(Idx) = 'SDM0086'                    CSD006
     C                   GOTO      EDFRSPR                                      CSD006
     C                   ENDIF                                                  CSD006


     C                   EXSR      SrTOLERNCE                                   CSD006
     C                   ENDIF                                                  CSD006

     C     EDFRSPR       ENDSR                                                  CSD006
      *****************************************************************
      /EJECT
      *****************************************************************
      ** EXISTING VALIDATION
      *****************************************************************
     C     EXSSPRT       BEGSR

      ** Does the amended spot rate exceed the allowed margin ?
     C                   IF        CEU002 = 'Y'
     C                   EVAL      ForceCheck = 'N'
     C                   ELSE
     C                   EVAL      ForceCheck = 'Y'
     C                   ENDIF

     C                   CALLB     'SDSPTRAMG'                          90
     C                   PARM                    ReturnCode
     C                   PARM                    ForceCheck        1
     C                   PARM      A6INCY        PIINCY
     C                   PARM      CurrSprt      PINSRT
     C                   PARM      PrevSprt      PIOSRT
     C                   PARM      1.1           PIUPLM
     C                   PARM      0.9           PILWLM
     C                   PARM                    Figure           10

     C     *LIKE         DEFINE    A6INCY        PIINCY
     C     *LIKE         DEFINE    A6SPRT        PINSRT
     C     *LIKE         DEFINE    A6SPRT        PIOSRT
     C     *LIKE         DEFINE    A6SPRT        PIUPLM
     C     *LIKE         DEFINE    A6SPRT        PILWLM

     C                   IF        RetCodeIn <> *BLANK  OR *IN90
     C                   MOVEL     'SDSPTRAMG'   DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     '*CALL'       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        Figure = '*LOWER' OR Figure = '*UPPER'
     C                   EVAL      DDSPRTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSPRT    '
     C                   EVAL      MsgIdXAr(Idx) = 'USR0363'
     C                   GOTO      EEXSPRT
     C                   ENDIF
      *
     C     EEXSPRT       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** COMMON VALIDATION
      *****************************************************************
     C     COMSPRT       BEGSR

      ** Mandatory
     C                   IF        DDSPRT = *BLANK
     C                   EVAL      DDSPRTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSPRT    '
     C                   EVAL      MsgIdXAr(Idx) = 'USR1144'
     C                   GOTO      ECOMSPR
     C                   ENDIF

      ** Must be numeric
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM      DDSPRT        ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   PARM      5             ZADIG             2 0
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      DDSPRTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSPRT    '
     C                   EVAL      MsgIdXAr(Idx) = 'USR1882'
     C                   GOTO      ECOMSPR
     C                   ENDIF
     C                   MOVE      ZFIELD        CurrSprt

      ** Ensure CurrSprt is non-zero                                                          196570
      **                                                                                      196570
     C                   IF        CurrSprt = 0                                               196570
     C                   EVAL      DDSPRTOK = 'N'                                             196570
     C                   EVAL      Idx = Idx + 1                                              196570
     C                   EVAL      FldNamXAr(Idx) = 'DDSPRT    '                              196570
     C                   EVAL      MsgIdXAr(Idx) = 'USR5588'                                  196570
     C                   GOTO      ECOMSPR                                                    196570
     C                   ENDIF                                                                196570

      ** To determine whether the spot rate is amendable we need to
      ** retrieve the details of the currency
     C                   IF        DDCYCD = *BLANK
     C                   EVAL      DDSPRTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSPRT    '
     C                   EVAL      MsgIdXAr(Idx) = 'SDM0087'
     C                   GOTO      ECOMSPR
     C                   ENDIF

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCYCD        @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DDSPRTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSPRT    '
     C                   EVAL      MsgIdXAr(Idx) = 'USR0071'
     C                   GOTO      ECOMSPR
     C                   ENDIF

      ** Is spot rate amendable ?
     C                   CALLB     'SDSPTRAEU'                          90
     C
     C                   PARM                    RetCodeIn
     C                   PARM                    DDCYCD
     C                   PARM                    A6INCY
     C                   PARM                    A6TPSD
     C                   PARM                    SprtAmd           1

     C                   IF        RetCodeIn <> *BLANK  OR *IN90
     C                   MOVEL     'SDSPTRAEU'   DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     DDCYCD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Field not amendable, for EMU Currencies passed their
      ** transition start date
     C                   IF        CEU002 = 'Y' AND SprtAmd = 'N'
     C                   IF        CurrSprt <> PrevSprt
     C                   EVAL      DDSPRTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSPRT    '
     C                   EVAL      MsgIdXAr(Idx) = 'USR3566'
     C                   GOTO      ECOMSPR
     C                   ENDIF
     C                   ENDIF


     C     ECOMSPR       ENDSR
      *****************************************************************
      /EJECT                                                                    CSD006
      *****************************************************************         CSD006
      *                                                               *         CSD006
      * SrTOLERNCE - Validate against the given Tolerance             *         CSD006
      *                                                               *         CSD006
      *****************************************************************         CSD006
     C     SrTOLERNCE    BEGSR                                                  CSD006
     C     *LIKE         DEFINE    AVSPRT        CurrSprt                       CSD006
     C     *LIKE         DEFINE    AVSPRT        PrevSprt                       CSD006
     C     *LIKE         DEFINE    AVSPRT        WDIFF                          CSD006
     C******LIKE         DEFINE    AVSPRT        WACTRDIF                       CSD006        196570
     C     *LIKE         DEFINE    PrevSprt      BefoSprt                       CSD006
                                                                                CSD006
      ** Save original value in case it is used somewhere else                  CSD006
     C                   EVAL      BefoSprt = PrevSprt                          CSD006
     C                   IF        DDMDIN <> AVMDIN                             CSD006
     C                   EVAL      PrevSprt = 1 / PrevSprt                      CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
      ** If a new rate was entered, get difference from the previous value      CSD006
                                                                                CSD006
     C                   IF        (CurrSprt <> PrevSprt)                       CSD006
     C                   EVAL      WDIFF = CurrSprt -  PrevSprt                 CSD006
                                                                                CSD006
                                                                                CSD006
      ** If negative, make it positive                                          CSD006
     C                   IF        WDIFF < 0                                    CSD006
     C                   Z-SUB     WDIFF         WDIFF                          CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
      ** Get the actual rate difference of the new rate by dividing             CSD006
      ** the difference to that of the previous rate                            CSD006
     C                   EVAL      WACTRDIF = (WDIFF/PrevSprt) * 100            CSD006
                                                                                CSD006
      ** Check against the tolerance                                            CSD006
     C                   IF        WACTRDIF > MDSRTL                            CSD006
     C                   EVAL      AVTLEX = 'Y'                                 CSD006
     C                   ELSE                                                   CSD006
     C                   EVAL      AVTLEX = 'N'                                 CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
      ** Restaure original value in case it is used somewhere else              CSD006
     C                   EVAL      PrevSprt = BefoSprt                          CSD006
                                                                                CSD006
     C                   ENDSR                                                  CSD006
      *****************************************************************         CSD006
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Request Id
     C                   PARM                    DDDTFR
      ** Currency code
     C                   PARM                    DDCYCD
      ** Current Spot Rate
     C                   PARM                    DDSPRT           14
      ** Previous Spot Rate
     C                   PARM                    AVSPRT
      ** Current Multiply Divide Indicator
     C                   PARM                    DDMDIN
      ** Previous Multiply Divide Indicator
     C                   PARM                    AVMDIN
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Spot Rate OK
     C                   PARM                    DDSPRTOK          1
      ** Tolerence exceeded flag
     C                   PARM                    AVTLEX
      ** New Spot Rate
     C                   PARM                    CurrSprt
      *
     C     *LIKE         DEFINE    A6DTFR        DDDTFR
     C     *LIKE         DEFINE    A6CYCD        DDCYCD
     C     *LIKE         DEFINE    A6SPRT        AVSPRT
     C     *LIKE         DEFINE    A6SPRT        NewSPRT
     C     *LIKE         DEFINE    A6MDIN        DDMDIN
     C     *LIKE         DEFINE    A6MDIN        AVMDIN
     C     *LIKE         DEFINE    A6TLEX        AVTLEX
      *
      ** Check if switchable feature CEU002 is switched on.
      ** Euro rates
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU002'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU002'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU002            1
     C                   ELSE
     C                   MOVE      'N'           CEU002
     C                   ENDIF

     C                   CALL      'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
      *                                                                                       CSD006
     C     @RTCD         IFEQ      *BLANKS                                                    CSD006
     C                   MOVE      'Y'           CSD006F                                      CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVE      'N'           CSD006F                                      CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   IF            CSD006F = 'Y'                                          CSD006
      ** Retrieve tolerance amount for Spot Rate                                              CSD006
     C                   CALLB     'AOMDFCR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*FIRST '     @OPTN                                        CSD006
     C     SDMDFC        PARM      SDMDFC        DSSDY                                        CSD006
                                                                                              CSD006
     C                   IF        @RTCD <> *Blanks                                           CSD006
     C                   MOVEL     'SDMDFCPD'    DBFILE                                       CSD006
     C                   Z-ADD     3             DBASE                                        CSD006
     C                   MOVEL     @OPTN         DBKEY                                        CSD006
     C                   EXSR      *PSSR                                                      CSD006
     C                   ENDIF                                                                CSD006

      ** Check if the Interest Rate Tolerance is set to maximum (999.99)

     C     MDSRTL        IFEQ      999.99
     C                   MOVE      'Y'           WSETMAX           1
     C                   ELSE
     C                   MOVE      'N'           WSETMAX
     C                   ENDIF
     C                   ENDIF                                                                CSD006

      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
