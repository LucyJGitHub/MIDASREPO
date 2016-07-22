     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Investment Proportion')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVINVP01 - Midas SD Validate Investment Proportion          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. CGL132             Date 01May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233204             Date 25Apr05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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

      ** Midas SD Joint A/c Member Details by Joint A/c No./Customer No.
     FSDJACCL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDJACCD0:SDJACCD1)

      ** Midas SD Joint A/c Member Details by Joint A/c No./Non-a/c Holder
     FSDJACCL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDJACCD0:SDJACCD3)

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

      ** Valid Investment Proportion Characters
     D VIPC            C                   '0123456789/'

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

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
     D PDCUST          S              6A
     D PDNAHO          S             10A
     D PDINVP          S             10A
     D OKINVP          S              1A
     D PSARD           S              6A                                                      CGL132
     D CGL132          S              1A                                                      CGL132

      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PNAHo           S             10A

      ** Key Fields
     D KJANo           S                   LIKE(JCJANO)
     D KCust           S                   LIKE(JCCUST)
     D KAcus           S                   LIKE(JCCUST)                                       CGL132
     D KNAHo           S                   LIKE(JCNAHO)

      ** Working Variables
     D Ix              S              3P 0
     D WOKInvP         S              1A
     D WInvP           S                   LIKE(JCINVP)
     D WOvrIdx         S              2P 0
     D WPos            S              2P 0
     D WLen            S              2P 0
     D WSta            S              2P 0
     D WNumer          S             10A
     D WDenom          S             10A
     D WInNum          S             10A
     D WInDen          S             10A
     D WX              S              4P 0
     D WY              S              5P 0
     D WSKIPV          S              1A                                                      CGL132

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
     C                             AND PDINVP = *BLANKS                                       CGL132
     C                             OR NOT %FOUND                                              CGL132
     C                             AND CGL132 = 'Y'                                           CGL132
     C                             AND PDINVP = *BLANKS                                       CGL132
     C                   LEAVESR                                                              CGL132
                                                                                              CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        PDINVP = *BLANKS

      ** Investment Proportion is mandatory.

     C                   EVAL      OKINVP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDINVP'
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0120'
     C                   LEAVESR
     C                   ENDIF

     C                   EVAL      WOKInvP = 'Y'

      ** Check for invalid characters.

     C                   IF        %CHECK(VIPC:%TRIM(PDINVP)) <> *ZERO
     C                   EVAL      WOKInvP = 'N'
     C                   ENDIF

     C                   IF        WOKInvP = 'Y'

      ** Search for the "over" (/) sign and check its validity.

     C                   EVAL      WOvrIdx = %SCAN('/':PDINVP)

     C                   IF        WOvrIdx = *ZERO OR
     C                             WOvrIdx = 1 OR
     C                             WOvrIdx = 10
     C                   EVAL      WOKInvP = 'N'
     C                   ENDIF

     C                   ENDIF

     C                   IF        WOKInvP = 'Y'

      ** Parse input Investment Proportion.

     C                   EVAL      WInvP = PDINVP
     C                   EXSR      SRPInvP

     C                   EVAL      WInNum = WNumer
     C                   EVAL      WInDen = WDenom

      ** Numerator & denominator formats must be nnnn & nnnnn respectively.

     C                   IF        %LEN(%TRIM(WInNum)) > 4 OR
     C                             %LEN(%TRIM(WInDen)) > 5
     C                   EVAL      WOKInvP = 'N'
     C                   ENDIF

     C                   ENDIF

     C                   IF        WOKInvP = 'N'

      ** Invalid Investment Proportion. It must be entered as a fraction in
      ** nnnn/nnnnn format.

     C                   EVAL      OKINVP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDINVP'
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0121'
     C                   LEAVESR
     C                   ENDIF

      ** Convert parsed input to numeric.

     C                   MOVE      WInNum        WX
     C                   MOVE      WInDen        WY

     C                   IF        WY = *ZERO

      ** Denominator must not be zero.

     C                   EVAL      OKINVP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDINVP'
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0122'
     C                   LEAVESR
     C                   ENDIF

     C                   IF        WX/WY < *ZERO OR
     C                             WX/WY > 1

      ** Investment Proportion must be >= 0 & <= 1.

     C                   EVAL      OKINVP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDINVP'
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0123'
     C                   LEAVESR
     C                   ENDIF

      ***Search*for*a*reference*denominator.***************************                       233204

     C**********         EVAL      KJANo = PDJANO                                             233204
     C*****KJANo         CHAIN     SDJACCL1                                                   233204

     C**********         IF        %FOUND                                                     233204

      ***Parse*database*Investment*Proportion.*************************                       233204

     C**********         EVAL      WInvP = JCINVP                                             233204
     C**********         EXSR      SRPInvP                                                    233204

     C**********         IF        WInDen <> WDenom                                           233204

      ***Denominators*can't*be*redefined.******************************                       233204

     C**********         EVAL      OKINVP = 'N'                                               233204
     C**********         EVAL      Ix = Ix + 1                                                233204
     C**********         EVAL      FldNamXAr(Ix) = 'DDINVP'                                   233204
     C**********         EVAL      MsgIDXAr(Ix) = 'SDM0124'                                   233204
     C**********         LEAVESR                                                              233204
     C**********         ENDIF                                                                233204

     C**********         ENDIF                                                                233204

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
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Input Parameters **
      ** Return Code
     C                   PARM                    PRetCode

      ** Joint Account Number
     C                   PARM                    PDJANO

      ** Customer Number
     C                   PARM                    PDCUST

      ** Non-account Holder
     C                   PARM                    PDNAHO

      ** Investment Proportion
     C                   PARM                    PDINVP

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

      ** Key Lists

     C     KJAC1         KLIST
     C                   KFLD                    KJANo
     C                   KFLD                    KCust

     C     KJAC3         KLIST
     C                   KFLD                    KJANo
     C                   KFLD                    KNAHo

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
(c) Misys International Banking Systems Ltd. 2004
