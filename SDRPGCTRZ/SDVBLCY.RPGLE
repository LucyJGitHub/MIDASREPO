     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Base Limit Currency')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Market Data Feed Details Val. *
      *                                                               *
      *  SDVBLCY - Validate base Limit currency                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CAP038             Date 15May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP038 - Conversion of BASE Rates into Modular APIs          *
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
      **--------------------------------------------------------------------------------------------
      ** EXTERNAL DS FOR CURRENCY DETAILS
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
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
     D WIdx            S              3P 0
 
     D CurrSprt        S                   LIKE(A6SPRT)
     D PrevSprt        S                   LIKE(A6SPRT)
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
     C                   Z-ADD     0             WIdx
     C                   Z-ADD     AVSPRT        PrevSprt
     C                   MOVE      'N'           WUBCLC
 
      *
      ** VALIDATION
 
      ** Mandatory
     C                   IF        DDSPRT = *BLANK
     C                   EVAL      DDSPRTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSPRT    '
     C                   EVAL      MsgIdXAr(Idx) = 'SDM0090'
     C                   GOTO      EMAIN
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
     C                   EVAL      MsgIdXAr(Idx) = 'SDM0091'
     C                   GOTO      EMAIN
     C                   ENDIF
     C                   MOVE      ZFIELD        CurrSprt
 
      ** SPECIAL VALIDATION IF CURRENCY AMENDED IS BASE CURRENCY LIMIT
      ** Set to Y flag for update module so that all currencies are
      ** updated
     C                   IF        CcyLim =  DDCYCD
      ** One of base currency details has changed ?
     C                   IF        CurrSprt <> PrevSprt
     C                             OR DDMDIN <> AVMDIN
     C                   EVAL      WUBCLC = 'Y'
     C                   EVAL      DDSPRTOK = 'W'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WFldNmXAr(WIdx) = 'DDSPRT    '
     C                   EVAL      WMsgIdXAr(WIdx) = 'SDM0088'
     C                   ELSE
      ** No changes in base currency details
     C                   EVAL      WUBCLC = 'N'
     C                   ENDIF
     C                   ENDIF
 
      *
      * RETURN
      *
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
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
      ** Currency code
     C                   PARM                    DDCYCD
      ** Currency limit
     C                   PARM                    CcyLim
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
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      ** Spot Rate OK
     C                   PARM                    DDSPRTOK          1
      ** Base currency limits changed
     C                   PARM                    WUBCLC            1
      *
     C     *LIKE         DEFINE    A6MDIN        DDMDIN
     C     *LIKE         DEFINE    A6MDIN        AVMDIN
     C     *LIKE         DEFINE    A6SPRT        AVSPRT
     C     *LIKE         DEFINE    A6CYCD        DDCYCD
     C     *LIKE         DEFINE    A6CYCD        CcyLim
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
