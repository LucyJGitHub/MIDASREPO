     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ZA Investment Proportion Utility')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZAINVPUT - Midas ZA Investment Proportion Utility            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 235709  *CREATE    Date 26Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  235709 - Wrong tax amount on Joint Account.                  *
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
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Copyright Statement Array
     D CPY@            S             80    DIM(1) CTDATA
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D POption         S              7A
     D PParam1         S             10A
     D PParam2         S             10A
     D PParam3         S             10A
     D PRatio          S             13P 8
 
      ** Standard Utility Parameters
     D PZField         S             16A
     D PZDecs          S              1P 0
 
      ** Working Variables
     D WInvP           S             10A
     D WPos            S              2P 0
     D WLen            S              2P 0
     D WSta            S              2P 0
     D WNumer          S             10A
     D WDenom          S             10A
     D WX              S              4P 0
     D WY              S              5P 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Option: *PARSE
 
      ** Input:
      ** Parm1 - Investment Proportion (N/D)
      ** Output:
      ** Parm2 - N (Right-aligned)
      ** Parm3 - D (Right-aligned)
      ** Ratio - N/D (Numeric)
 
      ** Option: *BUILD
 
      ** Input:
      ** Parm1 - N
      ** Parm2 - D
      ** Output:
      ** Parm3 - Investment Proportion (N/D)
      ** Ratio - N/D (Numeric)
 
     C                   SELECT
 
     C                   WHEN      POption = '*PARSE '
     C                   EXSR      SRPInvP
 
     C                   WHEN      POption = '*BUILD '
     C                   EXSR      SRBInvP
 
     C                   ENDSL
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPInvP - Parses Investment Proportions.                     *
      *                                                               *
      *****************************************************************
     C     SRPInvP       BEGSR
 
     C                   EVAL      WInvP = PParam1
 
     C                   EVAL      WPos = %SCAN('/':WInvP)
 
      ** Parse Investment Proportion to get input numerator & denominator.
 
     C                   EVAL      WLen = WPos - 1
     C                   EVAL      WSta = WPos + 1
     C                   EVAL      WNumer = %SUBST(WInvP:1:WLen)
     C                   EVAL      WDenom = %SUBST(WInvP:WSta)
 
      ** Right-align parsed input.
 
     C                   EVALR     WNumer = %TRIM(WNumer)
     C                   EVALR     WDenom = %TRIM(WDenom)
 
     C                   MOVE      WNumer        WX
     C                   MOVE      WDenom        WY
 
     C                   MOVE      WNumer        PParam2
     C                   MOVE      WDenom        PParam3
 
     C                   IF        WY <> *ZERO
     C                   EVAL(H)   PRatio = WX/WY
     C                   ELSE
     C                   EVAL      PRatio = *ZERO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBInvP - Builds Investment Proportions.                     *
      *                                                               *
      *****************************************************************
     C     SRBInvP       BEGSR
 
      ** Format the numerator.
 
     C                   EVALR     PZField = %TRIM(PParam1)
 
     C                   CALL      'ZEDIT'
     C                   PARM                    PZField
     C                   PARM      *ZERO         PZDecs
 
     C                   MOVE      PZField       WNumer
 
      ** Format the denominator.
 
     C                   EVALR     PZField = %TRIM(PParam2)
 
     C                   CALL      'ZEDIT'
     C                   PARM                    PZField
     C                   PARM      *ZERO         PZDecs
 
     C                   MOVE      PZField       WDenom
 
     C                   EVAL      WInvP = %TRIM(WNumer) + '/' +
     C                                     %TRIM(WDenom)
 
     C                   MOVE      WNumer        WX
     C                   MOVE      WDenom        WY
 
     C                   MOVE      WInvP         PParam3
 
     C                   IF        WY <> *ZERO
     C                   EVAL(H)   PRatio = WX/WY
     C                   ELSE
     C                   EVAL      PRatio = *ZERO
     C                   ENDIF
 
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
 
      ** Option
     C                   PARM                    POption
 
      ** Input/Output Parameters
     C                   PARM                    PParam1
     C                   PARM                    PParam2
     C                   PARM                    PParam3
 
      ** Ratio
     C                   PARM                    PRatio
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2005
