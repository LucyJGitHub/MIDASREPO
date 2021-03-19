     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Instructed Currency/Amount (Cov)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVICIC  - Validate Instructed Currency and Amount (Cover)   *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 07May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24510           Date 24Jun09               *
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  BUG24510 - Instructed Amount Cover must be entered if        *
      *             Instructed Currency is not blank                  *
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
 
      ** Flags to indicate whether transaction fields are valid
     D FTEIPY8       E DS                  EXTNAME(FTEIPY8PD)
 
      ** External data structure for Currency standing data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
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
     D PMode           S              6A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PCCY            S              3A
     D ZALIGNok        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
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
     C                   EXSR      VICIC
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKCICY = 'N' OR
     C                             OKCIAM = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VICIC - Validate Instructed Currency and Amount (Cover)
      *****************************************************************
      *
     C     VICIC         BEGSR
      *
     C                   IF        DDNWRK = 'SWIFT' AND
     C                             DDVALF = 'COV'   AND
     C                             (DDMTPY = '202' OR DDMTPY = '205')
      *
      ** Instructed Currency and Amount (Cover) can only be entered for
      ** SWIFT 202 COV or SWIFT 205 COV
      *
     C                   ELSE
      *
     C                   IF        DDCICY <> *BLANKS
     C                   EVAL      OKCICY = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCICY'      FldNamXAr(Idx)
     C**********         MOVEL     DDCICY        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCICY))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCICY)                   MD000091
     C                   MOVEL     'ME00216'     MsgIDXAr(Idx)
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        DDCIAM <> *BLANKS
     C                   EVAL      OKCIAM = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCIAM'      FldNamXAr(Idx)
     C**********         MOVEL     DDCIAM        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCIAM))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCIAM)                   MD000091
     C                   MOVEL     'ME00217'     MsgIDXAr(Idx)
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Instructed Currency (Cover)
      *
     C                   IF        DDCICY <> *BLANKS
     C                   IF        PMode = '*FRONT'
      ** Check if '?' is entered
     C     '?'           SCAN      DDCICY                                 01
      *
     C                   IF        *IN01 = '*ON'
     C                   EVAL      OKCICY = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCICY'      FldNamXAr(Idx)
     C**********         MOVEL     DDCICY        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCICY))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCICY)                   MD000091
     C                   MOVEL     'ME00218'     MsgIDXAr(Idx)
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C     DDCICY        PARM      DDCICY        PCCY
     C     SDCURR        PARM      SDCURR        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      OKCICY = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCICY'      FldNamXAr(Idx)
     C**********         MOVEL     DDCICY        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCICY))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCICY)                   MD000091
     C                   MOVEL     'ME00218'     MsgIDXAr(Idx)
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      I2CICY = DDCICY
     C                   ENDIF
      *
      ** Validate Instructed Amount (Cover)
      *
     C                   IF        DDCIAM <> *BLANKS
      ** Currency is mandatory if Instructed amount is entered
     C                   IF        DDCICY =  *BLANKS
     C                   EVAL      OKCIAM = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCIAM'      FldNamXAr(Idx)
     C**********         MOVEL     DDCIAM        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCIAM))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCIAM)                   MD000091
     C                   MOVEL     'ME00220'     MsgIDXAr(Idx)
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      ZFIELD = *BLANKS
     C                   EVAL      ZALIGNok = 'Y'
     C                   MOVE (P)  DDCIAM        ZFIELD
      *
      ** Ensure Instructed amount is in a valid format
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
     C                   PARM      13            ZADIG
      *
     C                   IF        ZALIGNok <> 'Y'
     C                   EVAL      OKCIAM = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCIAM'      FldNamXAr(Idx)
     C**********         MOVEL     DDCIAM        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCIAM))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCIAM)                   MD000091
     C                   MOVEL     'ME00221'     MsgIDXAr(Idx)
     C                   LEAVESR
     C                   ENDIF
      *
     C                   MOVE      ZFIELD        I2CIAM
      *                                                                                     BUG24510
     C                   ELSE                                                               BUG24510
      *                                                                                     BUG24510
      ** Instructed amount is optional but is mandatory if the currency is entered.         BUG24510
      *                                                                                     BUG24510
     C                   IF        DDCICY <> *BLANKS                                        BUG24510
     C                   EVAL      OKCIAM = 'N'                                             BUG24510
     C                   ADD       1             Idx                                        BUG24510
     C                   MOVEL     'DDCIAM'      FldNamXAr(Idx)                             BUG24510
     C**********         MOVEL     DDCIAM        MsgDtaXAr(IDX)                    BUG24510 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCIAM))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDCIAM)                   MD000091
     C                   MOVEL     'ME00268'     MsgIDXAr(Idx)                              BUG24510
     C                   LEAVESR                                                            BUG24510
     C                   ENDIF                                                              BUG24510
     C                                                                                      BUG24510
     C                   ENDIF
      *
     C                   ENDSR
     C*****************************************************************
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
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
 
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
(c) Finastra International Limited 2009
