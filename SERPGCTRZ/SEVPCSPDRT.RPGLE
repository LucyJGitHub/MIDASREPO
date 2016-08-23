     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Sec Price/Coupon Spread Rate')       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVPCSPDRT - Validate Securities Price/Coupon Spread Rate    *
      *                                                               *
      *  Component of: SESECS2VL                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically Included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition.
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually Included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
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
 
      ** Program Parameters
     D PFldName        S             10A
     D PSpdRate        S             17A
     D PValSpdRate     S             15P 8
     D PSpdRateOK      S              1A
 
      ** Working Variables
     D WPos            S              2P 0
     D WChr            S              1A
     D WNegFlg         S              1A
     D WSpdRate        S                   LIKE(PSpdRate)
 
      ** +--------------------------------------+
      ** ¦ Prototype Declarations               ¦
      ** ¦ ======================               ¦
      ** +--------------------------------------+
 
      ** Midas Standard Number Formatting/Validation Program
     D ZALIGN          PR                  EXTPGM('ZALIGN')
     D  PZRtCd                        7A
     D  PZFld                        16A   CONST OPTIONS(*VARSIZE)
     D  PZADec                        1P 0 CONST
     D  PZADig                        2P 0 CONST
     D  PZAFld                       16A   CONST OPTIONS(*VARSIZE)
 
      ** ZALIGN Wrapper
     D SPSpdRtChk      PR             1A
     D  PSpdRt                       17A   VALUE
 
      ** Number Validation Routine
     D SPIsNumeric     PR             1A
     D  PStr                         17A   VALUE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Initialise all relevant variables.
 
     C                   EXSR      SRInit
 
      ** Validate the Securities Price/Coupon Spread Rate.
 
     C                   EVAL      PSpdRateOK = SPSpdRtChk(WSpdRate)
 
      ** Do we have a valid Spread Rate?
 
     C                   IF        PSpdRateOK <> 'N'
 
      ** Negate the Spread Rate if necessary.
 
     C                   IF        WNegFlg = 'Y'
     C                   EVAL      PValSpdRate = -1 * PValSpdRate
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Performs the initial variable setup.                *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Clear all output parameters.
 
     C                   EVAL      RetCodeIn = *BLANKS
     C                   CLEAR                   FldNamXAr
     C                   CLEAR                   MsgIDXAr
     C                   CLEAR                   MsgDtaXAr
     C                   EVAL      PValSpdRate = *ZERO
     C                   EVAL      PSpdRateOK = *BLANK
 
      ** If the Spread Rate is blank, then there's no point in further
      ** processing.
 
     C                   IF        PSpdRate = *BLANKS
     C                   EVAL      PSpdRateOK = 'Y'
     C                   RETURN
     C                   ENDIF
 
     C                   EVAL      WSpdRate = PSpdRate
 
      ** Get the last non-blank character from the Spread Rate.
 
     C                   EVAL      WPos = %CHECKR(' ' : WSpdRate)
     C                   EVAL      WChr = %SUBST(WSpdRate : WPos : 1)
 
      ** If the Spread Rate is suffixed by a negative sign, remove it
      ** and set the Negative Flag to 'Y'.
 
     C                   EVAL      WNegFlg = 'N'
 
     C                   IF        WChr = '-'
     C                   EVAL      %SUBST(WSpdRate : WPos : 1) = ' '
     C                   EVALR     WSpdRate = %TRIM(WSpdRate)
     C                   EVAL      WNegFlg = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Begin Parameter List
      ** ====================
 
     C     *ENTRY        PLIST
 
      ** Input Parameters:
 
      ** Return Code
      ** Field Name
      ** Spread Rate
 
     C                   PARM                    RetCodeIn
     C                   PARM                    PFldName
     C                   PARM                    PSpdRate
 
      ** Output Parameters:
 
      ** Error Fields/Message IDs/Message Data (Arrays) From/To Caller
      ** Validated Spread Rate
      ** Spread Rate OK Indicator
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    PValSpdRate
     C                   PARM                    PSpdRateOK
 
      ** End Parameter List
      ** ==================
 
      **---------------------------------------------------------------
      ** The following /COPY line sets the program, module, and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Error-Handling Routines              ¦
      ** ¦ =======================              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the *PSSR subroutine.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Subprocedure Definitions             ¦
      ** ¦ ========================             ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SPSpdRtChk - Checks whether a given Spread Rate is valid     *
      *               or not.                                         *
      *                                                               *
      *****************************************************************
     P SPSpdRtChk      B
     D SPSpdRtChk      PI             1A
     D  PSpdRt                       17A   VALUE
 
      ** Working Variables
     D WRetCde         S              1A   INZ('N')
     D Idx             S              3P 0
 
      ** ZALIGN Parameters
     D PZRtCd          S              7A
     D PZFld           S             16A
     D PZADec          S              1P 0 INZ(8)
     D PZADig          S              2P 0 INZ(7)
     D PZAFld          S             16A
 
     C                   EVAL      PZFld = %TRIM(PSpdRt)
 
     C                   CALLP     ZALIGN(PZRtCd : PZFld :
     C                             PZADec : PZADig : PZAFld)
 
      ** Set the Validated Spread Rate if we have a valid Spread Rate.
      ** Set the error arrays otherwise.
 
     C                   IF        PZRtCd = *BLANKS
     C                   MOVE      PZAFld        PValSpdRate
     C                   EVAL      WRetCde = 'Y'
     C                   ELSE
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = PFldName
 
      ** If the Spread Rate is a valid numerical value, then we have
      ** an invalid rate format. Otherwise, the Spread Rate is a
      ** totally invalid entry.
 
     C                   IF        SPIsNumeric(PSpdRt) = 'Y'
     C                   EVAL      MsgIdXAr(Idx) = 'SEA0145'
     C                   ELSE
     C                   EVAL      MsgIdXAr(Idx) = 'SEA0524'
     C                   ENDIF
 
     C                   EVAL      MsgDtaXAr(Idx) = PSpdRate
     C                   ENDIF
 
     C                   RETURN    WRetCde
 
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SPIsNumeric - Checks whether a given string value is         *
      *                numeric or not.                                *
      *                                                               *
      *****************************************************************
     P SPIsNumeric     B
     D SPIsNumeric     PI             1A
     D  PStr                         17A   VALUE
 
      ** Working Variables
     D WRetCde         S              1A   INZ('N')
     D WPos            S              2P 0
     D WStr            S             17A
     D WChr            S              1A
 
      ** Get the last non-blank character from the given string.
 
     C                   EVAL      WStr = PStr
     C                   EVAL      WPos = %CHECKR(' ' : WStr)
     C                   EVAL      WChr = %SUBST(WStr : WPos : 1)
 
      ** If the extracted character from above is equal to 'T' or 'M',
      ** remove it since they are symbolically numerical anyway.
 
     C                   IF        WChr = 'T' OR
     C                             WChr = 'M'
     C                   EVAL      %SUBST(WStr : Wpos : 1) = ' '
     C                   ENDIF
 
     C                   EVAL      WPos = %CHECK('0123456789.' :
     C                             %TRIM(WStr))
 
     C                   IF        WPos = *ZERO
     C                   EVAL      WRetCde = 'Y'
     C                   ENDIF
 
     C                   RETURN    WRetCde
 
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2003
