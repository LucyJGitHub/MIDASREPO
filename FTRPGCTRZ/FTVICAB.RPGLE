     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Account with Institution (Cover)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVICAB  - Validate Account with Institution (Cover)         *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 07May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
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
 
      ** Valid Incoming Payments Extension File (default)
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)
 
      ** Flags to indicate whether transaction fields are valid
     D FTEIPY7       E DS                  EXTNAME(FTEIPY7PD)
 
      ** Externally described DS for BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
 
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Externally described DS for Counterparty Nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
 
      ** Account with Institution data structure
     D ACCINS          DS           175
     D  WCAB1                  1     35
     D  WCAB2                 36     70
     D  WCAB3                 71    105
     D  WCAB4                106    140
     D  WCAB5                141    175
 
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
 
      ** Work fields
     D CLSWTK          S             12A
 
      ** Fields used for SWIFT validation
     D ADLINE          S              1A
     D ADSLON          S              1A
     D ##CSID          S              1A
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
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
     C                   EXSR      VICAB
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKCAB1 = 'N'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ELSE
     C                   EVAL      I2CAB1 = DDCAB1
     C                   EVAL      I2CAB2 = DDCAB2
     C                   EVAL      I2CAB3 = DDCAB3
     C                   EVAL      I2CAB4 = DDCAB4
     C                   EVAL      I2CAB5 = DDCAB5
     C                   ENDIF
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VICAB - Validate Account with Institution (Cover)
      *****************************************************************
      *
     C     VICAB         BEGSR
      *
     C                   EVAL      I2CABT = *BLANKS
      *
     C                   MOVEL     DDCAB1        WCAB1
     C                   MOVEL     DDCAB2        WCAB2
     C                   MOVEL     DDCAB3        WCAB3
     C                   MOVEL     DDCAB4        WCAB4
     C                   MOVEL     DDCAB5        WCAB5
      *
     C                   IF        DDNWRK = 'SWIFT' AND
     C                             DDVALF = 'COV'   AND
     C                             (DDMTPY = '202' OR DDMTPY = '205')
      *
      ** Account with Institution (Cover) can only be entered for
      ** SWIFT 202 COV or SWIFT 205 COV
      *
     C                   ELSEIF    ACCINS <> *BLANKS
     C                   EVAL      OKCAB1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCAB1'      FldNamXAr(Idx)
     C**********         MOVEL     DDCAB1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCAB1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCAB1)                   MD000091
     C                   MOVEL     'ME00195'     MsgIDXAr(Idx)
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        ACCINS <> *BLANKS
      *
     C                   MOVEL     ACCINS        ADDRSS
      *
      ** Validate SWIFT Address
      *
     C                   IF        (ADCH26 = *BLANKS AND
     C                             ADEXSW  = *BLANKS AND
     C                             ADSLSH  <> '/')
     C                             OR
     C                             (ADCH36 = *BLANKS AND
     C                             ADEXS2  = *BLANKS AND
     C                             ADSLSH  = '/'     AND
     C                             ADCHK2 <> *BLANKS AND
     C                             ADSLS2 <> '/')
      *
     C                   EXSR      VSWFT
      *
      ** Exit if error found
      *
     C                   IF        OKCAB1 = 'N'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
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
      * VSWFT - Validate SWIFT Address
      *****************************************************************
      *
     C     VSWFT         BEGSR
      *
      ** First 11 characters should be key for CLSWT.
      *
     C                   MOVEL     DDCAB1        CLSWTK
      *
     C                   IF        DDCAB2 <> *BLANKS
     C                   MOVEL     DDCAB2        CLSWTK
     C                   ENDIF
      *
     C                   EXSR      SWIFT
      *
     C                   IF        ##CSID = 'Y'
      *
      ** Invalid SWIFT characters found
      *
     C                   IF        *IN31 = *ON
     C                   EVAL      OKCAB1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCAB1'      FldNamXAr(Idx)
     C**********         MOVEL     DDCAB1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCAB1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCAB1)                   MD000091
     C                   MOVEL     'ME00196'     MsgIDXAr(Idx)
     C                   LEAVESR
     C                   ENDIF
      *
      ** BIC directory is not loaded
      *
     C                   IF        *IN32 = *ON  AND
     C                             *IN31 = *OFF
     C                   EVAL      OKCAB1 = 'W'
     C                   ADD       1             WIX
     C                   MOVEL     'DDCAB1'      WFldNmXAr(WIX)
     C**********         EVAL      WMsgDtaXAr(WIX) = DDCAB1                                 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCAB1))                               MD000091
     C                   EVAL      WMsgDtaXAr(WIX) = LenStr +%TRIM(DDCAB1)                  MD000091
     C                   MOVEL     'ME00197'     WMsgIDXAr(WIX)
     C                   ENDIF
      *
     C                   EVAL      I2CAB1 = DDCAB1
     C                   EVAL      I2CAB2 = DDCAB2
     C                   EVAL      I2CAB3 = DDCAB3
     C                   EVAL      I2CAB4 = DDCAB4
     C                   EVAL      I2CAB5 = DDCAB5
     C                   EVAL      I2CABT = 'S'
      *
      ** Exit if Account with Institution (Cover) is a SWIFT Address
      *
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
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
      ** Send error if Address line starts with "/" but no second line entered
      *
     C                   IF        *IN91 = *ON AND
     C                             DDCAB2 = *BLANKS
     C                   EVAL      OKCAB1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCAB1'      FldNamXAr(Idx)
     C**********         MOVEL     DDCAB1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCAB1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCAB1)                   MD000091
     C                   MOVEL     'ME00198'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** Send error if 5th line entered but 1st line not starting with "/"
      *
     C                   IF        *IN91 = *ON AND
     C                             DDCAB5 <> *BLANKS
     C                   EVAL      OKCAB1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCAB1'      FldNamXAr(Idx)
     C**********         MOVEL     DDCAB1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCAB1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCAB1)                   MD000091
     C                   MOVEL     'ME00182'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** Send error if Embedded blank lines exist
      *
     C                   IF        *IN92 = *ON
     C                   EVAL      OKCAB1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCAB1'      FldNamXAr(Idx)
     C**********         MOVEL     DDCAB1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCAB1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCAB1)                   MD000091
     C                   MOVEL     'ME00199'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** Send error if Invalid SWIFT character found
      *
     C                   IF        AD#1 = 'Y' OR
     C                             AD#2 = 'Y' OR
     C                             AD#3 = 'Y' OR
     C                             AD#4 = 'Y' OR
     C                             AD#5 = 'Y'
     C                   EVAL      OKCAB1 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCAB1'      FldNamXAr(Idx)
     C**********         MOVEL     DDCAB1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCAB1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCAB1)                   MD000091
     C                   MOVEL     'ME00222'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   EVAL      I2CABT = 'A'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTADDRSC1
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTSWFTCLE
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
 
      * OUTPUTS
      ** Incoming Payments (additional details) for file update
     C                   PARM                    NwIP2FilFmt
      *
      ** Incoming Payments Lvl 2 Scrn 7 error indicators
     C                   Parm                    FTEIPY7
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
(c) Finastra International Limited 2009
