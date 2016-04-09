     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Securities Prices Price')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEVSEPR01 - Validate Securities Prices Price field           *
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
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSD010             Date 03May02               *
      *  Prev Amend No. 196570             Date 23Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060  *CREATE    Date 07Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD010 - Collateralised Lending (Securities and FX Pricing)  *
      *  196570 - Patch for Market Data Feed                          *
      *  CAP060 - Midas APIs, Security Prices Full API                *
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
 
      ** Work field to check if price has changed for anmends with data req feed ID
     D JPPRC2          S                   LIKE(JPPRC)
 
     D PrevPrice       S             15  8 DIM(1)
     D PrevWarn        S              1    DIM(1)
 
     D CSD010          S              1A                                                      CSD010
                                                                                              CSD010
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
     C                   MOVE      *BLANK        WMSGIDXAR
     C                   MOVE      *BLANK        WFLDNMXAR
     C                   Z-ADD     0             WIDX
      *
      * Initialise output fields
     C                   MOVEL     *BLANK        PRTLEX
      *
      ** Validation carried out if price type is V and extel indicator is on
      *
     C                   IF        DDDTFR = *BLANKS
      *
      ** Validation of price as previously carried out in SE0080
      *
     C                   EXSR      PRICE
     C                   ELSE
      *
      ** If Data feed request ID is entered, it must be a valid numeric with at most 8
      ** decimal places.
 
      ** Set a flag if the value is not within the MDF ICD prices tolerance of current price.
      ** If tolerance is 999.99, no checking is performed.
      *
     C                   EXSR      PRICE2
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDPRCOK = 'N' OR
     C                             DDNPXROK = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * PRICE - Validate Price if Data Feed Request is blank          *
      *****************************************************************
     C     PRICE         BEGSR
     C*
     C** Price field is a mandatory entry as valid number
     C*
      * If portfolio is blank and price is blank, error
                                                                                              CSD010
      ** However, if CSD010 is installed, price is optional                                   CSD010
                                                                                              CSD010
     C     DDPTFR        IFEQ      *BLANKS
     C     DDPPRC        ANDEQ     *BLANKS
     C     CSD010        ANDEQ     'N'                                                        CSD010
     C                   MOVE      'N'           DDPRCOK
     C                   ADD       1             Idx
      * 200 The price has not been entered or is invalid
     C                   EVAL      MsgIdXar(Idx) = 'MMA1140'
     C                   EVAL      FldNamXAr (Idx) = 'DDPPRC'
     C                   ENDIF
 
     C     DDPPRC        IFEQ      *BLANKS
     C     DDNPXR        IFEQ      *BLANKS
 
      * If portfolio isn't blank and price is blank and FX rate are blank, error
     C     DDPTFR        IFNE      *BLANKS
     C                   MOVE      'N'           DDPRCOK
     C                   MOVE      'N'           DDNPXROK
     C                   ADD       1             Idx
      * 213: Enter either a price or an FX rate.
     C                   EVAL      MsgIdXar(Idx) = 'MMA1146'
     C                   EVAL      FldNamXAr (Idx) = 'DDPPRC'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C*
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDPPRC        ZFIELD
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
      * Check that PPRC is numeric
      *
     C     ZRTN          IFEQ      'N'
     C                   MOVE      'N'           DDPRCOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXar(Idx) = 'MMA1140'
     C                   EVAL      FldNamXAr (Idx) = 'DDPPRC'
     C                   ELSE
     C                   MOVE      ZFIELD        JPPRC            15 8
 
     C*
     C* If this has been run before and the price is the same as
     C* before WARNING ERROR ONLY - ACCEPT IF UNCHANGED **
     C*
     C                   If        PrevPrice(1) = JPPRC
 
     C                   EVAL      PPWN = PrevWarn   (1)
     C                   EVAL      PrevWarn   (1) = ' '
     C                   EVAL      PrevPrice(1) = *ZEROS
 
     C                   EndIf
 
     C*
     C* Fetch 10% + or - of Current price for comparison
     C*    ** WARNING ERROR ONLY - ACCEPT IF UNCHANGED **
     C*
     C     JPPRC         IFNE      HPPRC
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDCURP        ZFIELD
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   MOVE      ZFIELD        CURPRC           15 8
      *
      ** If price type is 'V ', (current price), use value entered
      ** (ie. do not use if blanks)
      **   as percentage allowable otherwise use 10%.
      *
     C     DDPPRT        IFEQ      'V '
     C     JPMOV         ANDNE     0
     C     JPMOV         DIV(H)    100           WK158            15 8
     C     CURPRC        MULT      WK158         WK158
     C                   ELSE
     C     CURPRC        DIV(H)    10            WK158            15 8
     C                   ENDIF
     C     CURPRC        ADD       WK158         CURPRP           15 8
     C     CURPRC        SUB       WK158         CURPRL           15 8
     C     JPPRC         IFGT      CURPRP
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIdXar(WIdx) = 'MMA0813'
     C                   EVAL      WFLDNMXAR (WIdx) = 'JPPRC'
     C                   EVAL      DDPRCOK = 'W'
     C                   MOVE      'Y'           PPWN              1
     C                   EVAL      PrevPrice (1) = JPPRC
     C                   EVAL      PrevWarn  (1) = PPWN
     C                   ELSE
     C     JPPRC         IFLT      CURPRL
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIdXar(WIdx) = 'MMA0813'
     C                   EVAL      WFLDNMXAR (WIdx) = 'JPPRC'
     C                   EVAL      DDPRCOK = 'W'
     C                   MOVE      'Y'           PPWN
     C                   EVAL      PrevPrice (1) = JPPRC
     C                   EVAL      PrevWarn  (1) = PPWN
     C                   ELSE
     C                   MOVE      'N'           PPWN
     C                   EVAL      PrevPrice (1) = JPPRC
     C                   EVAL      PrevWarn  (1) = PPWN
     C                   EVAL      DDPRCOK = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   EVAL      HPPRC = JPPRC
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      * PRICE2- Validate Price if Data Feed Request is not blank      *
      *****************************************************************
     C     PRICE2        BEGSR
     C*
     C** Price field is a mandatory entry as valid number
     C*
      * If portfolio is blank and price is blank, error
                                                                                              CSD010
      ** However, if CSD010 is installed, price is optional                                   CSD010
                                                                                              CSD010
     C     DDPTFR        IFEQ      *BLANKS
     C     DDPPRC        ANDEQ     *BLANKS
     C     CSD010        ANDEQ     'N'                                                        CSD010
     C                   MOVE      'N'           DDPRCOK
     C                   ADD       1             Idx
      * 200 The price has not been entered or is invalid
     C                   EVAL      MsgIdXar(Idx) = 'MMA1140'
     C                   EVAL      FldNamXAr (Idx) = 'DDPPRC'
     C                   ENDIF
 
     C     DDPPRC        IFEQ      *BLANKS
     C     DDNPXR        IFEQ      *BLANKS
 
      * If portfolio isn't blank and price is blank and FX rate are blank, error
     C     DDPTFR        IFNE      *BLANKS
     C                   MOVE      'N'           DDPRCOK
     C                   MOVE      'N'           DDNPXROK
     C                   ADD       1             Idx
      * 213: Enter either a price or an FX rate.
     C                   EVAL      MsgIdXar(Idx) = 'MMA1146'
     C                   EVAL      FldNamXAr (Idx) = 'DDPPRC'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
 
     C* Either an FX rate or price has been entered; convert price to numeric
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDPPRC        ZFIELD
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
      * Check that DDPPRC is numeric
      *
     C     ZRTN          IFEQ      'N'
     C                   MOVE      'N'           DDPRCOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIdXar(Idx) = 'MMA1140'
     C                   EVAL      FldNamXAr (Idx) = 'DDPPRC'
     C                   ELSE
      * Put the new price into a work field; then check if it has been amended
     C                   MOVE      ZFIELD        JPPRC2
 
     C                   IF        DDACTN = 'A' AND
     C                             JPPRC2 <> JPPRC AND
     C                             JPPRC  <> 0
     C
 
      * do not check MDF ICD securities prices tolerance of current price if the tol -
      * erance is set at 999.99, or if price has not been entered, as this is optional when
      * portfolio management is on
 
     C                   IF        MDSPTL <>  999.99  OR
     C                             DDPPRC <> *BLANKS
      * clear work fields
     C                   MOVE      *ZEROS        WK15             15 8
     C*******************MOVE      *ZEROS        DIFPRC           15 8                        196570
     C                   MOVE      *ZEROS        DIFPRC           29 8                        196570
 
      * for amended price: new price - previous price
     C                   EVAL      WK15  = JPPRC2 - JPPRC
 
      * if WK15 is negative, Z-SUB the field
     C                   IF        WK15 < 0
     C                   Z-SUB     WK15          WK15
     C                   ENDIF
 
      * divide WK15 by previous price
     C                   EVAL      DIFPRC = (WK15/JPPRC) * 100
 
      * DIFPRC is compared to MDF ICD Sec Price tolerance
      * If DIFFRT is greater then flag is to set to 'Y', else 'N'
 
     C                   IF        DIFPRC > MDSPTL
     C                   EVAL      PRTLEX = 'Y'
     C                   ELSE
     C                   EVAL      PRTLEX = 'N'
     C                   ENDIF
 
     C                   ENDIF
     C                   EVAL      JPPRC = JPPRC2
     C                   ELSE
     C                   EVAL      JPPRC = JPPRC2
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     EPRIC         ENDSR
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
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Price
     C                   PARM                    DDPPRC           16
      ** Price Type
     C                   PARM                    DDPPRT            2
      ** FX Rate
     C                   PARM                    DDNPXR           14
      ** Current price
     C                   PARM                    DDCURP           16
      ** Portfolio Reference
     C                   PARM                    DDPTFR            4
      ** Data Request feed identifier
     C                   PARM                    DDDTFR           32
      * Price (passed from CVT if in AMEND mode, in numeric format)
     C                   PARM                    HPPRC            15 8
     C                   PARM                    JPMOV             9 6
 
      * Securites Prices tolerance
     C                   PARM                    MDSPTL            5 2
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXar
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXar
     C                   PARM                    WMsgDtXAR
      *
      ** Price OK flag
     C                   PARM                    DDPRCOK           1
      ** FX Rate OK flag
     C                   PARM                    DDNPXROK          1
      *  EXTEL Price percentage allowable movement warning
     C                   PARM                    PPWN              1
      *  Rates Tolerance exceeded
     C                   PARM                    PRTLEX            1
      *  Price in file format
     C                   PARM                    JPPRC            15 8
                                                                                              CSD010
      ** CSD010 Switchable Feature                                                            CSD010
                                                                                              CSD010
     C                   PARM                    CSD010                                       CSD010
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
