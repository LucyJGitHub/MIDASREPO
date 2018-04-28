     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Collateral Currency')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Validate Collateral Currency  *
      *                                                               *
      *  SDVCYCD - Validate Collateral Currency                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    /COPY, Customer Future and Options Details amendments must *
      *    not be applied to this source.                             *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
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
      ** ¦ =====================================¦
      * +-------------------------------------- +
      **External DS for Access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **External DS for Currency Codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Index for arrays of error message ids etc
     D DDCYCD          S              3A
     D DDCODE          S             20A
     D DDCOAM          S             13A
     D DDCYCDOK        S              1A
     D DDCODEOK        S              1A
 
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
 
      ** Validation
      ** Validate Collateral currency & Collateral details
      ** Collateral Currency & Collateral Description
      ** Currency Code is not blank
     C                   IF        DDCYCD <> *BLANK
      ** Collateral Description is Blank
      ** Access the currency file, for currency code Validation,
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    DDCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        @RTCD <> *Blanks
 
     C                   EVAL      DDCYCDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCYCD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0071'
 
     C                   ENDIF
 
     C                   IF        DDCODE = *BLANK
      ** Send message 'Collateral Desc Required'
     C                   EVAL      DDCODEOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCODE    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1191'
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Collateral Amount Screen field is Not Blank
     C                   IF        DDCOAM <> *BLANK
      ** Send message 'Collateral Currency Req'
     C                   EVAL      DDCYCDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCYCD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1204'
      ** Collateral Description is Blank
     C                   IF        DDCODE  = *BLANK
      ** Send message 'Collateral Desc Required'
     C                   EVAL      DDCODEOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCODE    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1191'
 
     C                   ENDIF
     C                   ELSE
      ** Collateral Description is Not blank
     C                   IF        DDCODE <> *BLANK
      ** Send message 'Collateral Currency Req'
     C                   EVAL      DDCYCDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCYCD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1204'
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Return
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Currency Code
     C                   PARM                    DDCYCD
      ** Collateral Description
     C                   PARM                    DDCODE
      ** Collateral Amount
     C                   PARM                    DDCOAM
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Collateral Currency - OK
     C                   PARM                    DDCYCDOK
      ** Collateral Description - OK
     C                   PARM                    DDCODEOK
 
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
(c) Misys International Banking Systems Ltd. 2006
