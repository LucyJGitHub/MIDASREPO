     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Securities Prices Price')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEVSEPR02 - Validate Securities Prices - Mid Price,          *
      *              Bid Price, Offer Price and Closing Price fields  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSD010  *CREATE    Date 03May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD010 - Collateralised Lending (Securities and FX Pricing)  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIDX            S              3P 0
 
     D JPPRC           S             15  8
     D JBDPR           S             15  8
     D JOFPR           S             15  8
     D JCLPR           S             15  8
     D CURPRC          S             15  8
     D CURPRP          S             15  8
     D CURPRL          S             15  8
     D WK158           S             15  8
     D WK15            S             15  8
     D DIFPRC          S             15  8
 
      ** Work field to check if price has changed for amends with data req feed ID
     D JPPRC2          S                   LIKE(JPPRC)
     D JBDPR2          S                   LIKE(JBDPR)
     D JOFPR2          S                   LIKE(JOFPR)
     D JCLPR2          S                   LIKE(JCLPR)
 
     D PrevPrice       S             15  8 DIM(1)
     D PrevWarn        S              1    DIM(1)
 
      ** Parameters used for call of ZALIGN
     D PReturn         S              1A
     D PField          S             16A
     D PDecimals       S              1  0
     D PDigits         S              2  0
 
      ** Entry Parameters
     D DDACTN          S              1
     D DDPPRC          S             16
     D DDBDPR          S             16
     D DDOFPR          S             16
     D DDCLPR          S             16
     D DDPPRT          S              2
     D DDNPXR          S             14
     D DDCURP          S             16
     D DDPTFR          S              4
     D DDDTFR          S             32
     D HPPRC           S             15  8
     D HBDPR           S             15  8
     D HOFPR           S             15  8
     D HCLPR           S             15  8
     D JPMOV           S              9  6
     D MDSPTL          S              5  2
     D DDPRCOK         S              1
     D DDBDPROK        S              1
     D DDOFPROK        S              1
     D DDCLPROK        S              1
     D DDNPXROK        S              1
     D PPWN            S              1
     D PRTLEX          S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIdXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   Z-ADD     0             Idx
     C                   EVAL      WMSGIDXAR = *BLANKS
     C                   EVAL      WFLDNMXAR = *BLANKS
     C                   Z-ADD     0             WIDX
 
      ** Initialise output fields
 
     C                   EVAL      PRTLEX = *BLANKS
 
      ** Validation carried out if price type is V and extel indicator is on
 
     C                   IF        DDDTFR = *BLANKS
 
      ** Validation of price similar to SEVSEPR01
 
     C                   EXSR      SRMID
     C                   EXSR      SRBID
     C                   EXSR      SROFFER
 
      ** If both Bid and Offer Prices are entered and Mid Price is blank,
      ** Mid Price is calculated as the average of Bid and Offer Prices
 
     C                   IF        DDPPRC = *BLANKS
     C                   IF        DDBDPR <> *BLANKS AND DDOFPR <> *BLANKS
     C                             AND DDBDPROK <> 'N' AND DDOFPROK <> 'N'
     C                   EVAL      JPPRC = (JBDPR + JOFPR)/2
 
     C                   EVAL      PField = *BLANKS
     C                   MOVE      JPPRC         PFIELD
     C                   Z-ADD     8             PDecimals
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    PField
     C                   PARM                    PDecimals
     C                   MOVE      PField        DDPPRC
     C
     C                   EVAL      HPPRC = JPPRC
     C
     C                   ENDIF
     C
     C                   ENDIF
 
     C                   EXSR      SRCLOSING
 
     C                   ELSE
 
      ** If Data feed request ID is entered, it must be a valid numeric
      ** with at most 8 decimal places.
 
      ** Set a flag if the value is not within the MDF ICD prices tolerance of current price.
      ** If tolerance is 999.99, no checking is performed.
 
     C                   EXSR      SRMID
     C                   EXSR      SRBID2
     C                   EXSR      SROFFER2
 
      ** If both Bid and Offer Prices are entered and Mid Price is blank,
      ** Mid Price is calculated as the average of Bid and Offer Prices
 
     C                   IF        DDPPRC = *BLANKS
     C                   IF        DDBDPR <> *BLANKS AND DDOFPR <> *BLANKS
     C                             AND DDBDPROK <> 'N' AND DDOFPROK <> 'N'
     C                   EVAL      JPPRC = (JBDPR + JOFPR)/2
 
     C                   EVAL      PField = *BLANKS
     C                   MOVE      JPPRC         PFIELD
     C                   Z-ADD     8             PDecimals
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    PField
     C                   PARM                    PDecimals
     C                   MOVE      PField        DDPPRC
     C
     C                   EVAL      HPPRC = JPPRC
     C
     C                   ENDIF
     C
     C                   ENDIF
 
     C                   EXSR      SRCLOSING2
 
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDPRCOK = 'N' OR DDNPXROK = 'N' OR
     C                             DDBDPROK = 'N' OR DDOFPROK = 'N' OR
     C                             DDCLPROK = 'N'
 
     C                   EVAL      RetCodeIn = 'Error'
 
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * SRBID - Validate Price if Data Feed Request is blank          *
      *                                                               *
      *****************************************************************
 
     C     SRBID         BEGSR
 
      ** Error if portfolio is not blank and price is blank and
      ** FX rate is blank
 
     C                   IF        DDBDPR = *BLANKS
 
     C                   IF        DDNPXR = *BLANKS AND
     C                             DDPTFR <> *BLANKS
     C                   EVAL      DDBDPROK = 'N'
     C                   EVAL      DDNPXROK = 'N'
     C                   ADD       1             Idx
 
      ** 213: Enter either a price or an FX rate.
 
     C                   EVAL      MsgIdXar(Idx) = 'MMA1146'
     C                   EVAL      FldNamXAr (Idx) = 'DDBDPR'
     C                   ENDIF
 
     C                   ELSE
 
     ** Must be a valid price with maximum 7 integers, 8 decimals
     ** and one decimal point.
 
     C                   EVAL      PField = *BLANKS
     C                   MOVE      DDBDPR        PField
     C                   Z-ADD     7             PDigits
     C                   Z-ADD     8             PDecimals
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PReturn
     C                   PARM                    PField
     C                   PARM                    PDecimals
     C                   PARM                    PDigits
 
      ** Must be numberic
 
     C                   IF        PReturn = 'N'
     C                   EVAL      DDBDPROK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXar(Idx) = 'MMA1140'
     C                   EVAL      FldNamXAr (Idx) = 'DDBDPR'
     C                   ELSE
     C                   MOVE      PField        JBDPR
 
      ** If this has been run before and the price is the same as
      ** before, Warning Error Only - Accept if Unchanged
 
     C                   IF        PrevPrice(1) = JBDPR
     C                   EVAL      PPWN = PrevWarn   (1)
     C                   EVAL      PrevWarn   (1) = ' '
     C                   EVAL      PrevPrice(1) = *ZEROS
     C                   ENDIF
 
      ** Fetch 10% + or - of Current price for comparison
      ** Warning Error Only - Accept if Unchanged
 
     C                   IF        JBDPR <> HBDPR
     C                   EVAL      PField = *BLANKS
     C                   MOVE      DDCURP        PField
     C                   Z-ADD     7             PDigits
     C                   Z-ADD     8             PDecimals
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PReturn
     C                   PARM                    PField
     C                   PARM                    PDecimals
     C                   PARM                    PDigits
     C                   MOVE      PField        CURPRC
 
      ** If price type is 'V ', (current price), use value entered
      ** (ie. do not use if blanks)
      ** as percentage allowable otherwise use 10%.
 
     C                   IF        DDPPRT = 'V ' AND JPMOV <> 0
     C     JPMOV         DIV(H)    100           WK158
     C     CURPRC        MULT      WK158         WK158
     C                   ELSE
     C     CURPRC        DIV(H)    10            WK158
     C                   ENDIF
 
     C     CURPRC        ADD       WK158         CURPRP
     C     CURPRC        SUB       WK158         CURPRL
 
     C                   IF        JBDPR > CURPRP
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIdXar(WIdx) = 'MMA0813'
     C                   EVAL      WFLDNMXAR (WIdx) = 'JBDPR'
     C                   EVAL      DDBDPROK = 'W'
     C                   EVAL      PPWN = 'Y'
     C                   EVAL      PrevPrice (1) = JBDPR
     C                   EVAL      PrevWarn  (1) = PPWN
     C                   ELSE
 
     C                   IF        JBDPR < CURPRL
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIdXar(WIdx) = 'MMA0813'
     C                   EVAL      WFLDNMXAR (WIdx) = 'JBDPR'
     C                   EVAL      DDBDPROK = 'W'
     C                   EVAL      PPWN = 'Y'
     C                   EVAL      PrevPrice (1) = JBDPR
     C                   EVAL      PrevWarn  (1) = PPWN
     C                   ELSE
 
     C                   EVAL      PPWN = 'N'
     C                   EVAL      PrevPrice (1) = JBDPR
     C                   EVAL      PrevWarn  (1) = PPWN
     C                   EVAL      DDBDPROK = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      HBDPR = JBDPR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SROFFER - Validate Offer Price if Data Request is blank       *
      *                                                               *
      *****************************************************************
 
     C     SROFFER       BEGSR
 
      ** Error if portfolio is not blank and price is blank and
      ** FX rate is blank
 
     C                   IF        DDOFPR = *BLANKS
 
     C                   IF        DDNPXR = *BLANKS AND
     C                             DDPTFR <> *BLANKS
     C                   EVAL      DDOFPROK = 'N'
     C                   EVAL      DDNPXROK = 'N'
     C                   ADD       1             Idx
 
      ** 213: Enter either a price or an FX rate.
 
     C                   EVAL      MsgIdXar(Idx) = 'MMA1146'
     C                   EVAL      FldNamXAr (Idx) = 'DDOFPR'
     C                   ENDIF
 
     C                   ELSE
 
     ** Must be a valid price with maximum 7 integers, 8 decimals
     ** and one decimal point.
 
     C                   EVAL      PField = *BLANKS
     C                   MOVE      DDOFPR        PField
     C                   Z-ADD     7             PDigits
     C                   Z-ADD     8             PDecimals
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PReturn
     C                   PARM                    PField
     C                   PARM                    PDecimals
     C                   PARM                    PDigits
 
      ** Must be numberic
 
     C                   IF        PReturn = 'N'
     C                   EVAL      DDOFPROK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXar(Idx) = 'MMA1140'
     C                   EVAL      FldNamXAr (Idx) = 'DDOFPR'
     C                   ELSE
     C                   MOVE      PField        JOFPR
 
      ** If this has been run before and the price is the same as
      ** before, Warning Error Only - Accept if Unchanged
 
     C                   IF        PrevPrice(1) = JOFPR
     C                   EVAL      PPWN = PrevWarn   (1)
     C                   EVAL      PrevWarn   (1) = ' '
     C                   EVAL      PrevPrice(1) = *ZEROS
     C                   ENDIF
 
      ** Fetch 10% + or - of Current price for comparison
      ** Warning Error Only - Accept if Unchanged
 
     C                   IF        JOFPR <> HOFPR
     C                   EVAL      PField = *BLANKS
     C                   MOVE      DDCURP        PField
     C                   Z-ADD     7             PDigits
     C                   Z-ADD     8             PDecimals
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PReturn
     C                   PARM                    PField
     C                   PARM                    PDecimals
     C                   PARM                    PDigits
     C                   MOVE      PField        CURPRC
 
      ** If price type is 'V ', (current price), use value entered
      ** (ie. do not use if blanks)
      ** as percentage allowable otherwise use 10%.
 
     C                   IF        DDPPRT = 'V ' AND JPMOV <> 0
     C     JPMOV         DIV(H)    100           WK158
     C     CURPRC        MULT      WK158         WK158
     C                   ELSE
     C     CURPRC        DIV(H)    10            WK158
     C                   ENDIF
 
     C     CURPRC        ADD       WK158         CURPRP
     C     CURPRC        SUB       WK158         CURPRL
 
     C                   IF        JOFPR > CURPRP
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIdXar(WIdx) = 'MMA0813'
     C                   EVAL      WFLDNMXAR (WIdx) = 'JOFPR'
     C                   EVAL      DDOFPROK = 'W'
     C                   EVAL      PPWN = 'Y'
     C                   EVAL      PrevPrice (1) = JOFPR
     C                   EVAL      PrevWarn  (1) = PPWN
     C                   ELSE
 
     C                   IF        JOFPR < CURPRL
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIdXar(WIdx) = 'MMA0813'
     C                   EVAL      WFLDNMXAR (WIdx) = 'JOFPR'
     C                   EVAL      DDOFPROK = 'W'
     C                   EVAL      PPWN = 'Y'
     C                   EVAL      PrevPrice (1) = JOFPR
     C                   EVAL      PrevWarn  (1) = PPWN
     C                   ELSE
 
     C                   EVAL      PPWN = 'N'
     C                   EVAL      PrevPrice (1) = JOFPR
     C                   EVAL      PrevWarn  (1) = PPWN
     C                   EVAL      DDOFPROK = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      HOFPR = JOFPR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SRMID - Validate Mid Price if Data Feed Request is blank      *
      *                                                               *
      *****************************************************************
 
     C     SRMID         BEGSR
 
     C                   IF        DDPPRC = *BLANKS
 
      ** Mid Price will be mandatory unless the Bid and Offer Prices are
      ** entered
 
     C                   IF        DDBDPR = *BLANKS OR DDOFPR = *BLANKS
     C                   EVAL      DDPRCOK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXar(Idx) = 'MMA1244'
     C                   EVAL      FldNamXAr (Idx) = 'DDPPRC'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLOSING - Validate Closing Price if Data Request is blank   *
      *                                                               *
      *****************************************************************
 
     C     SRCLOSING     BEGSR
 
      ** If Closing Price is not entered, default to Mid Price
 
     C                   IF        DDCLPR = *BLANKS
     C                   EVAL      DDCLPR = DDPPRC
     C                   ENDIF
 
      ** Error if portfolio is not blank and price is blank and
      ** FX rate is blank
 
     C                   IF        DDCLPR = *BLANKS
 
     C                   IF        DDNPXR = *BLANKS AND
     C                             DDPTFR <> *BLANKS
     C                   EVAL      DDCLPROK = 'N'
     C                   EVAL      DDNPXROK = 'N'
     C                   ADD       1             Idx
 
      ** 213: Enter either a price or an FX rate.
 
     C                   EVAL      MsgIdXar(Idx) = 'MMA1146'
     C                   EVAL      FldNamXAr (Idx) = 'DDCLPR'
     C                   ENDIF
 
     C                   ELSE
 
     ** Must be a valid price with maximum 7 integers, 8 decimals
     ** and one decimal point.
 
     C                   EVAL      PField = *BLANKS
     C                   MOVE      DDCLPR        PField
     C                   Z-ADD     7             PDigits
     C                   Z-ADD     8             PDecimals
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PReturn
     C                   PARM                    PField
     C                   PARM                    PDecimals
     C                   PARM                    PDigits
 
      ** Must be numberic
 
     C                   IF        PReturn = 'N'
     C                   EVAL      DDCLPROK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXar(Idx) = 'MMA1140'
     C                   EVAL      FldNamXAr (Idx) = 'DDCLPR'
     C                   ELSE
     C                   MOVE      PField        JCLPR
 
      ** If this has been run before and the price is the same as
      ** before, Warning Error Only - Accept if Unchanged
 
     C                   IF        PrevPrice(1) = JCLPR
     C                   EVAL      PPWN = PrevWarn   (1)
     C                   EVAL      PrevWarn   (1) = ' '
     C                   EVAL      PrevPrice(1) = *ZEROS
     C                   ENDIF
 
      ** Fetch 10% + or - of Current price for comparison
      ** Warning Error Only - Accept if Unchanged
 
     C                   IF        JCLPR <> HCLPR
     C                   EVAL      PField = *BLANKS
     C                   MOVE      DDCURP        PField
     C                   Z-ADD     7             PDigits
     C                   Z-ADD     8             PDecimals
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PReturn
     C                   PARM                    PField
     C                   PARM                    PDecimals
     C                   PARM                    PDigits
     C                   MOVE      PField        CURPRC
 
      ** If price type is 'V ', (current price), use value entered
      ** (ie. do not use if blanks)
      ** as percentage allowable otherwise use 10%.
 
     C                   IF        DDPPRT = 'V ' AND JPMOV <> 0
     C     JPMOV         DIV(H)    100           WK158
     C     CURPRC        MULT      WK158         WK158
     C                   ELSE
     C     CURPRC        DIV(H)    10            WK158
     C                   ENDIF
 
     C     CURPRC        ADD       WK158         CURPRP
     C     CURPRC        SUB       WK158         CURPRL
 
     C                   IF        JCLPR > CURPRP
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIdXar(WIdx) = 'MMA0813'
     C                   EVAL      WFLDNMXAR (WIdx) = 'JCLPR'
     C                   EVAL      DDCLPROK = 'W'
     C                   EVAL      PPWN = 'Y'
     C                   EVAL      PrevPrice (1) = JCLPR
     C                   EVAL      PrevWarn  (1) = PPWN
     C                   ELSE
 
     C                   IF        JCLPR < CURPRL
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIdXar(WIdx) = 'MMA0813'
     C                   EVAL      WFLDNMXAR (WIdx) = 'JCLPR'
     C                   EVAL      DDCLPROK = 'W'
     C                   EVAL      PPWN = 'Y'
     C                   EVAL      PrevPrice (1) = JCLPR
     C                   EVAL      PrevWarn  (1) = PPWN
     C                   ELSE
 
     C                   EVAL      PPWN = 'N'
     C                   EVAL      PrevPrice (1) = JCLPR
     C                   EVAL      PrevWarn  (1) = PPWN
     C                   EVAL      DDCLPROK = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCLPR = DDPPRC AND DDCLPROK ='W'
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIdXar(WIdx) = 'MMA0813'
     C                   EVAL      WFLDNMXAR (WIdx) = 'JPPRC'
     C                   EVAL      DDPRCOK = 'W'
     C                   ENDIF
 
     C                   EVAL      HCLPR = JCLPR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SRBID2 - Validate Bid Price if Data Feed Request is not blank *
      *                                                               *
      *****************************************************************
 
     C     SRBID2        BEGSR
 
      ** Error if portfolio is not blank and price is blank and
      ** FX rate is blank
 
     C                   IF        DDBDPR = *BLANKS
 
     C                   IF        DDNPXR = *BLANKS AND
     C                             DDPTFR <> *BLANKS
     C                   EVAL      DDBDPROK = 'N'
     C                   EVAL      DDNPXROK = 'N'
     C                   ADD       1             Idx
 
      ** 213: Enter either a price or an FX rate.
 
     C                   EVAL      MsgIdXar(Idx) = 'MMA1146'
     C                   EVAL      FldNamXAr (Idx) = 'DDBDPR'
     C                   ENDIF
 
     C                   ELSE
 
     ** Must be a valid price with maximum 7 integers, 8 decimals
     ** and one decimal point.
 
     C                   EVAL      PField = *BLANKS
     C                   MOVE      DDBDPR        PField
     C                   Z-ADD     7             PDigits
     C                   Z-ADD     8             PDecimals
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PReturn
     C                   PARM                    PField
     C                   PARM                    PDecimals
     C                   PARM                    PDigits
 
      ** Must be numeric
 
     C                   IF        PReturn = 'N'
     C                   EVAL      DDBDPROK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXar(Idx) = 'MMA1140'
     C                   EVAL      FldNamXAr (Idx) = 'DDBDPR'
     C                   ELSE
     C                   MOVE      PField        JBDPR2
 
     C                   IF        DDACTN = 'A' AND
     C                             JBDPR2 <> JBDPR AND
     C                             JBDPR  <> 0
     C
 
      ** Do not check MDF ICD securities prices tolerance of current
      ** price if the tolerance is set at 999.99, or if price has not
      ** been entered, as this is optional when portfolio management
      ** is installed
 
     C                   IF        MDSPTL <>  999.99  OR
     C                             DDBDPR <> *BLANKS
     C                   EVAL      WK15 = *ZEROS
     C                   EVAL      DIFPRC = *ZEROS
 
      ** For amended price: new price - previous price
 
     C                   EVAL      WK15  = JBDPR2 - JBDPR
 
      ** If WK15 is negative, Z-SUB the field
 
     C                   IF        WK15 < 0
     C                   Z-SUB     WK15          WK15
     C                   ENDIF
 
      ** Divide WK15 by previous price
 
     C                   EVAL      DIFPRC = (WK15/JBDPR) * 100
 
      ** DIFPRC is compared to MDF ICD Sec Price tolerance
      ** If DIFFRT is greater then flag is to set to 'Y', else 'N'
 
     C                   IF        DIFPRC > MDSPTL
     C                   EVAL      PRTLEX = 'Y'
     C                   ELSE
     C                   EVAL      PRTLEX = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      JBDPR = JBDPR2
     C                   ELSE
     C                   EVAL      JBDPR = JBDPR2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SROFFER2 - Validate Offer Price if Data Feed Request is not   *
      *            blank                                              *
      *                                                               *
      *****************************************************************
 
     C     SROFFER2      BEGSR
 
      ** Error if portfolio is not blank and price is blank and
      ** FX rate is blank
 
     C                   IF        DDOFPR = *BLANKS
 
     C                   IF        DDNPXR = *BLANKS AND
     C                             DDPTFR <> *BLANKS
     C                   EVAL      DDOFPROK = 'N'
     C                   EVAL      DDNPXROK = 'N'
     C                   ADD       1             Idx
 
      ** 213: Enter either a price or an FX rate.
 
     C                   EVAL      MsgIdXar(Idx) = 'MMA1146'
     C                   EVAL      FldNamXAr (Idx) = 'DDOFPR'
     C                   ENDIF
 
     C                   ELSE
 
     ** Must be a valid price with maximum 7 integers, 8 decimals
     ** and one decimal point.
 
     C                   EVAL      PField = *BLANKS
     C                   MOVE      DDOFPR        PField
     C                   Z-ADD     7             PDigits
     C                   Z-ADD     8             PDecimals
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PReturn
     C                   PARM                    PField
     C                   PARM                    PDecimals
     C                   PARM                    PDigits
 
      ** Must be numeric
 
     C                   IF        PReturn = 'N'
     C                   EVAL      DDOFPROK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXar(Idx) = 'MMA1140'
     C                   EVAL      FldNamXAr (Idx) = 'DDOFPR'
     C                   ELSE
     C                   MOVE      PField        JOFPR2
 
     C                   IF        DDACTN = 'A' AND
     C                             JOFPR2 <> JOFPR AND
     C                             JOFPR  <> 0
     C
 
      ** Do not check MDF ICD securities prices tolerance of current
      ** price if the tolerance is set at 999.99, or if price has not
      ** been entered, as this is optional when portfolio management
      ** is installed
 
     C                   IF        MDSPTL <>  999.99  OR
     C                             DDOFPR <> *BLANKS
     C                   EVAL      WK15 = *ZEROS
     C                   EVAL      DIFPRC = *ZEROS
 
      ** For amended price: new price - previous price
 
     C                   EVAL      WK15  = JOFPR2 - JOFPR
 
      ** If WK15 is negative, Z-SUB the field
 
     C                   IF        WK15 < 0
     C                   Z-SUB     WK15          WK15
     C                   ENDIF
 
      ** Divide WK15 by previous price
 
     C                   EVAL      DIFPRC = (WK15/JOFPR) * 100
 
      ** DIFPRC is compared to MDF ICD Sec Price tolerance
      ** If DIFFRT is greater then flag is to set to 'Y', else 'N'
 
     C                   IF        DIFPRC > MDSPTL
     C                   EVAL      PRTLEX = 'Y'
     C                   ELSE
     C                   EVAL      PRTLEX = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      JOFPR = JOFPR2
     C                   ELSE
     C                   EVAL      JOFPR = JOFPR2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SRCLOSING2 - Validate Offer Price if Data Feed Request is not *
      *              blank                                            *
      *                                                               *
      *****************************************************************
 
     C     SRCLOSING2    BEGSR
 
      ** If Closing Price is not entered, default to Mid Price
 
     C                   IF        DDCLPR = *BLANKS
     C                   EVAL      DDCLPR = DDPPRC
     C                   ENDIF
 
      ** Error if portfolio is not blank and price is blank and
      ** FX rate is blank
 
     C                   IF        DDCLPR = *BLANKS
 
     C                   IF        DDNPXR = *BLANKS AND
     C                             DDPTFR <> *BLANKS
     C                   EVAL      DDCLPROK = 'N'
     C                   EVAL      DDNPXROK = 'N'
     C                   ADD       1             Idx
 
      ** 213: Enter either a price or an FX rate.
 
     C                   EVAL      MsgIdXar(Idx) = 'MMA1146'
     C                   EVAL      FldNamXAr (Idx) = 'DDCLPR'
     C                   ENDIF
 
     C                   ELSE
 
     ** Must be a valid price with maximum 7 integers, 8 decimals
     ** and one decimal point.
 
     C                   EVAL      PField = *BLANKS
     C                   MOVE      DDCLPR        PField
     C                   Z-ADD     7             PDigits
     C                   Z-ADD     8             PDecimals
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PReturn
     C                   PARM                    PField
     C                   PARM                    PDecimals
     C                   PARM                    PDigits
 
      ** Must be numeric
 
     C                   IF        PReturn = 'N'
     C                   EVAL      DDCLPROK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXar(Idx) = 'MMA1140'
     C                   EVAL      FldNamXAr (Idx) = 'DDCLPR'
     C                   ELSE
     C                   MOVE      PField        JCLPR2
 
     C                   IF        DDACTN = 'A' AND
     C                             JCLPR2 <> JCLPR AND
     C                             JCLPR  <> 0
     C
 
      ** Do not check MDF ICD securities prices tolerance of current
      ** price if the tolerance is set at 999.99, or if price has not
      ** been entered, as this is optional when portfolio management
      ** is installed
 
     C                   IF        MDSPTL <>  999.99  OR
     C                             DDCLPR <> *BLANKS
     C                   EVAL      WK15 = *ZEROS
     C                   EVAL      DIFPRC = *ZEROS
 
      ** For amended price: new price - previous price
 
     C                   EVAL      WK15  = JCLPR2 - JCLPR
 
      ** If WK15 is negative, Z-SUB the field
 
     C                   IF        WK15 < 0
     C                   Z-SUB     WK15          WK15
     C                   ENDIF
 
      ** Divide WK15 by previous price
 
     C                   EVAL      DIFPRC = (WK15/JCLPR) * 100
 
      ** DIFPRC is compared to MDF ICD Sec Price tolerance
      ** If DIFFRT is greater then flag is to set to 'Y', else 'N'
 
     C                   IF        DIFPRC > MDSPTL
     C                   EVAL      PRTLEX = 'Y'
     C                   ELSE
     C                   EVAL      PRTLEX = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      JCLPR = JCLPR2
     C                   ELSE
     C                   EVAL      JCLPR = JCLPR2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Mid Price
 
     C                   PARM                    DDPPRC
 
      ** Bid Price
 
     C                   PARM                    DDBDPR
 
      ** Offer Price
 
     C                   PARM                    DDOFPR
 
      ** Closing Price
 
     C                   PARM                    DDCLPR
 
      ** Price Type
 
     C                   PARM                    DDPPRT
 
      ** FX Rate
 
     C                   PARM                    DDNPXR
 
      ** Current price
 
     C                   PARM                    DDCURP
 
      ** Portfolio Reference
 
     C                   PARM                    DDPTFR
 
      ** Data Request feed identifier
 
     C                   PARM                    DDDTFR
 
      ** Price (passed from CVT if in AMEND mode, in numeric format)
 
     C                   PARM                    HPPRC
     C                   PARM                    HBDPR
     C                   PARM                    HOFPR
     C                   PARM                    HCLPR
     C                   PARM                    JPMOV
 
      ** Securites Prices tolerance
 
     C                   PARM                    MDSPTL
 
      ** Outputs
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXar
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXar
     C                   PARM                    WMsgDtXAR
 
      ** Mid Price OK flag
 
     C                   PARM                    DDPRCOK
 
      ** Bid Price OK Flag
 
     C                   PARM                    DDBDPROK
 
      ** Offer Price OK flag
 
     C                   PARM                    DDOFPROK
 
      ** Closing Price OK flag
 
     C                   PARM                    DDCLPROK
 
      ** FX Rate OK flag
 
     C                   PARM                    DDNPXROK
 
      ** EXTEL Price percentage allowable movement warning
 
     C                   PARM                    PPWN
 
      ** Rates Tolerance exceeded
 
     C                   PARM                    PRTLEX
 
      ** Price in file format
 
     C                   PARM                    JPPRC
 
      ** Bid Price in file format
 
     C                   PARM                    JBDPR
 
      ** Offer Price in file format
 
     C                   PARM                    JOFPR
 
      ** Closing Price in file format
 
     C                   PARM                    JCLPR
 
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
