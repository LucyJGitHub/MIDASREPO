     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Investment Proportion Group Check')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVINVG01 - Midas SD Investment Proportion Group Check       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 CGL132             Date 01May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233204             Date 25Apr05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CGL132 - Investment Proportion of Customers with "FATCA      *
      *           Customer Type = J" should not be validated to       *
      *           100% if Joint Account Type is not set to Y          *
      *         - Applied MD025267                                    *
      *  233204 - Errors on Joint Account Members Maintenance         *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Joint A/c Member Details - Retrieve Index
     FSDJACCL1  IF   E           K DISK    INFSR(*PSSR)
 
 
      ** Midas SD Additional Customer Details by Customer Number                              CGL132
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)                                       CGL132
                                                                                              CGL132
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** API Validation X Error Array Declarations
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Customer Number Array
     D PACUST          S              6A   DIM(100)
 
      ** Non-a/c Holder Array
     D PANAHO          S             10A   DIM(100)
 
      ** Investment Proportion Array
     D PAINVP          S             10A   DIM(100)
 
      ** External DS for SAR details                                                          CGL132
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL132
                                                                                              CGL132
      ** Short Access Object Data Structure                                                   CGL132
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CGL132
                                                                                              CGL132
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRetCode        S             10A
     D PDJANO          S              6A
     D OKINVP          S              1A
                                                                                              CGL132
      ** Access Object Parameters                                                             CGL132
     D PRtCd           S              7A                                                      CGL132
     D POptn           S              7A                                                      CGL132
 
      ** Key Fields
     D KJANo           S                   LIKE(JCJANO)
     D KAcus           S                   LIKE(JCCUST)                                       CGL132
     D PSARD           S              6A                                                      CGL132
     D CGL132          S              1A                                                      CGL132
 
      ** Working Variables
     D Ix              S              3P 0
     D WInvPIx         S              3P 0
     D WInvP           S             10A
     D WPos            S              2P 0
     D WLen            S              2P 0
     D WSta            S              2P 0
     D WNumer          S             10A
     D WDenom          S             10A
     D WN              S             10P 0
     D WD              S             10P 0
     D WNt             S             10P 0
     D WCurDen         S             10A
     D WPrvDen         S             10A
     D WDBDen          S             10A                                                      233204
     D WOKInvP         S              1A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Initialise relevant variables.
 
     C                   EVAL      PRetCode  = *BLANKS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Ix = *ZERO
 
      ** Validate Investment Proportion.
 
     C                   EXSR      SRVInvP
 
     C                   IF        OKINVP <> 'Y'
     C                   EVAL      PAINVP(1) = '*ERROR'
     C                   EVAL      PRetCode  = '*ERROR'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVInvP - Validates the Investment Proportion.               *
      *                                                               *
      *****************************************************************
     C     SRVInvP       BEGSR
 
      ** Validation is only for Joint Account Customers when CGL132 is ON.                    CGL132
                                                                                              CGL132
     C                   EVAL      KAcus = PDJANO                                             CGL132
     C     KAcus         CHAIN     SDACUSL1                                                   CGL132
     C                   IF        %FOUND AND E5JATP <> 'Y'                                   CGL132
     C                             AND CGL132 = 'Y'                                           CGL132
     C                             OR NOT %FOUND                                              CGL132
     C                             AND CGL132 = 'Y'                                           CGL132
     C                   LEAVESR                                                              CGL132
                                                                                              CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Initialise relevant variables.
 
     C                   EVAL      WOKInvP = 'Y'
     C                   EVAL      WInvPIx = 1
     C                   EVAL      WN = *ZERO
     C                   EVAL      WD = *ZERO
     C                   EVAL      WNt = *ZERO
     C                   EVAL      WCurDen = *BLANKS
     C                   EVAL      WPrvDen = *BLANKS
 
     C                   DOW       PAINVP(WInvPIx) <> *BLANKS
 
      ** Parse input Investment Proportion.
 
     C                   EVAL      WInvP = PAINVP(WInvPIx)
     C                   EXSR      SRPInvP
 
      ** Get the sum of all numerators.
 
     C                   MOVE      WNumer        WN
     C                   EVAL      WNt = WNt + WN
 
      ** Check if all denominators are the same.
 
     C                   EVAL      WPrvDen = WCurDen
     C                   EVAL      WCurDen = WDenom
 
     C                   IF        WPrvDen <> *BLANKS AND
     C                             WPrvDen <> WCurDen
     C                   EVAL      WOKInvP = 'N'
     C                   ENDIF
 
     C                   EVAL      WInvPIx = WInvPIx + 1
     C                   ENDDO
 
     C                   IF        WOKInvP = 'N'
 
      ** All denominators must be the same.
 
     C                   EVAL      OKINVP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDINVP'
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0128'
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        PAINVP(1) <> *BLANKS
 
      ** Get the database numerators to complete the total for this group.
 
     C                   EVAL      WNumer = *BLANKS                                           233204
     C                   EVAL      WDenom = *BLANKS                                           233204
     C                   EXSR      SRGetDBNmr
                                                                                              233204
      ** Save a database denominator as reference for the group.                              233204
                                                                                              233204
     C                   EVAL      WDBDen = WDenom                                            233204
 
      ** Get the first denominator as reference for the group.
 
     C                   EVAL      WInvP = PAINVP(1)
     C                   EXSR      SRPInvP
                                                                                              233204
      ** Check first if the database denominator is equal to the input denominator.           233204
                                                                                              233204
     C                   IF        WDBDen <> *BLANKS AND                                      233204
     C                             WDenom <> *BLANKS AND                                      233204
     C                             WDBDen <> WDenom                                           233204
                                                                                              233204
      ** All denominators must be the same.                                                   233204
                                                                                              233204
     C                   EVAL      OKINVP = 'N'                                               233204
     C                   EVAL      Ix = Ix + 1                                                233204
     C                   EVAL      FldNamXAr(Ix) = 'DDINVP'                                   233204
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0128'                                   233204
     C                   LEAVESR                                                              233204
     C                   ENDIF                                                                233204
                                                                                              233204
     C                   MOVE      WDenom        WD
 
     C                   IF        WNt <> WD
 
      ** The sum of all numerators must be equal to the given denominator.
 
     C                   EVAL      OKINVP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDINVP'
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0129'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPInvP - Parses Investment Proportions.                     *
      *                                                               *
      *****************************************************************
     C     SRPInvP       BEGSR
 
     C                   EVAL      WPos = %SCAN('/':WInvP)
 
      ** Parse Investment Proportion to get input numerator & denominator.
 
     C                   EVAL      WLen = WPos - 1
     C                   EVAL      WSta = WPos + 1
     C                   EVAL      WNumer = %SUBST(WInvP:1:WLen)
     C                   EVAL      WDenom = %SUBST(WInvP:WSta)
 
      ** Right-align parsed input.
 
     C                   EVALR     WNumer = %TRIM(WNumer)
     C                   EVALR     WDenom = %TRIM(WDenom)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetDBNmr - Gets the database numerators.                   *
      *                                                               *
      *****************************************************************
     C     SRGetDBNmr    BEGSR
 
     C                   EVAL      KJANo = PDJANO
     C     KJANo         SETLL     SDJACCL1
     C     KJANo         READE     SDJACCL1
 
     C                   DOW       NOT %EOF
 
      ** If the Joint A/c Member read does not exist in those that were marked
      ** as changed, add its numerator to the running total. This will properly
      ** set the total to its new value.
 
     C                   IF        (JCCUST <> *BLANKS AND
     C                             %LOOKUP(JCCUST:PACUST:1) = *ZERO) OR
     C                             (JCNAHO <> *BLANKS AND
     C                             %LOOKUP(JCNAHO:PANAHO:1) = *ZERO)
     C                   EVAL      WInvP = JCINVP
     C                   EXSR      SRPInvP
     C                   MOVE      WNumer        WN
     C                   EVAL      WNt = WNt + WN
     C                   ENDIF
 
     C     KJANo         READE     SDJACCL1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters **
      ** Return Code
     C                   PARM                    PRetCode
 
      ** Joint A/c Number
     C                   PARM                    PDJANO
 
      ** Customer Number Array
     C                   PARM                    PACUST
 
      ** Non-a/c Holder Array
     C                   PARM                    PANAHO
 
      ** Investment Proportion Array
     C                   PARM                    PAINVP
 
      ** Output Parameters **
      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** OK - Investment Proportion
     C                   PARM                    OKINVP
 
      ** Check if CGL132 is ON                                                                CGL132
     C                   CALL      'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       PRTCD                                        CGL132
     C                   PARM      '*VERIFY'     POPTN                                        CGL132
     C                   PARM      'CGL132'      PSARD                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C                   IF        PRTCD <> *BLANKS                                           CGL132
     C                   EVAL      CGL132 = 'N'                                               CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      CGL132 = 'Y'                                               CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      **---------------------------------------------------------------
      ** Program, module, and procedure names for DB error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   CALLB     'DBERRCTL'
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
