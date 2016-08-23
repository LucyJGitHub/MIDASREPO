     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Remittance Information (Cover)')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVICDP  - Validate Remittance Information (Cover)           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *                                                               *
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Warning in error.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of Warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of Warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Incoming Transaction
     D NwIP7ScnFmt   E DS                  EXTNAME(FTIPY7PD)
     D NwIP8ScnFmt   E DS                  EXTNAME(FTIPY8PD)
 
      ** Valid Incoming Payments Extension File (default)
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)
 
      * Flags to indicate whether transaction fields are valid
     D FTEIPY8       E DS                  EXTNAME(FTEIPY8PD)
 
      ** Sender to Receiver data structure
     D RMTINF          DS           140
     D  WCDP1                  1     35
     D  WCDP2                 36     70
     D  WCDP3                 71    105
     D  WCDP4                106    140
 
      *
      /COPY FTCPYSRC,SFTVALCSLE
      *
      /COPY FTCPYSRC,SFTADDRILE
      *
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIX             S              3P 0
 
      ** Fields used for SWIFT validation
     D ADLINE          S              1A
     D ADSLON          S              1A
 
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
 
      *
      ** Initialization
      *
     C                   EVAL      RetCodeIn  = *BLANKS
     C                   EVAL      FldNamXAr  = *BLANKS
     C                   EVAL      MsgIDXAr   = *BLANKS
     C                   EVAL      MsgDtaXAr  = *BLANKS
     C                   EVAL      WFldNmXAr  = *BLANKS
     C                   EVAL      WMsgIDXAr  = *BLANKS
     C                   EVAL      WMsgDtaXAr = *BLANKS
     C                   EVAL      WIX = 0
     C                   EVAL      Idx = 0
 
      ** Validate
     C                   EXSR      VICDP
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKCDP1 = 'N'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ELSE
     C                   EVAL      I2CDP1 = DDCDP1
     C                   EVAL      I2CDP2 = DDCDP2
     C                   EVAL      I2CDP3 = DDCDP3
     C                   EVAL      I2CDP4 = DDCDP4
     C                   ENDIF
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VICDP - Validate Remittance Information (Cover)
      *****************************************************************
      *
     C     VICDP         BEGSR
      *
     C                   MOVEL     DDCDP1        WCDP1
     C                   MOVEL     DDCDP2        WCDP2
     C                   MOVEL     DDCDP3        WCDP3
     C                   MOVEL     DDCDP4        WCDP4
      *
     C                   IF        DDNWRK = 'SWIFT' AND
     C                             DDVALF = 'COV'   AND
     C                             (DDMTPY = '202' OR DDMTPY = '205')
      *
      ** Remittance Information (Cover) can only be entered for
      ** SWIFT 202 COV or SWIFT 205 COV
      *
     C                   ELSEIF    RMTINF <> *BLANKS
     C                   EVAL      OKCDP1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDP1'      FldNamXAr(Idx)
     C                   MOVEL     DDCDP1        MsgDtaXAr(IDX)
     C                   MOVEL     'ME00214'     MsgIDXAr(Idx)
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        RMTINF <> *BLANKS
      *
     C                   MOVEL     RMTINF        ADDRSS
      *
      ** Validate Address
      *
     C                   EXSR      VADDR
      *
     C                   ENDIF
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      * VADDR - Validate Address
      *****************************************************************
      *
     C     VADDR         BEGSR
      *
     C                   EVAL      ADLINE = 'Y'
     C                   EXSR      ADCHK
      *
      ** Send error if Embedded blank lines exist
      *
     C                   IF        *IN92 = *ON
     C                   EVAL      OKCDP1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDP1'      FldNamXAr(Idx)
     C                   MOVEL     DDCDP1        MsgDtaXAr(Idx)
     C                   MOVEL     'ME00215'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTADDRSC1
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTADDRCLE
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
     C*
     C     *ENTRY        PLIST
 
      * INPUTS
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Incoming Payments details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP7ScnFmt
     C                   PARM                    NwIP8ScnFmt
 
      * OUTPUTS
      ** Incoming Payments (additional details) for file update
     C                   PARM                    NwIP2FilFmt
      *
      ** Incoming Payments Lvl 2 Scrn 7 error indicators
     C                   Parm                    FTEIPY8
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtaXAr
      *
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
