     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA European W/Tax Calculation for Joint Acc.')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZAMRATIO - European Withholding Tax Memeber Ratio            *
      *             Calculation                                       *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 233710  *CREATE    Date 13Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  233710 - Generation of position settlement cust income and   *
      *           account key                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInvtRatio - Determine ratio of investment proportion       *
      *  *INZSR - Program Initialisation routine                      *
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
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
 
      ** Input Parameter
 
     D PINVP           S             10A
     D PTXNM           S             13  0
 
      ** Output Parameter
 
     D PTAXA           S             15  0
 
      ** Work Fields
     D WPosition       S              5  0
     D WMulValue       S              5  0
     D WDivValue       S              5  0
     D WStart          S              5  0
     D WEnd            S              5  0
     D WNumerator      S              5A
     D WDenominator    S              5A
 
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
 
      ** Initialise output fields
 
     C                   EVAL      PTAXA  = *ZEROS
 
     C                   EXSR      SRInvtRatio
 
     C                   EVAL(H)   PTAXA = PTXNM * WMulValue / WDivValue
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRInvtRatio - Determine ratio of investment proportion
      *****************************************************************
     C     SRInvtRatio   BEGSR
 
     C                   EVAL      WMulValue = *Zeros
     C                   EVAL      WDivValue = *Zeros
 
      ** Search '/' from the PINVP startting at position 2
 
     C                   EVAL      WPosition = %SCAN('/':PINVP:2)
 
      ** If '/' not found, or if '/' is on position 1, set ratio to 1
 
     C                   IF        WPosition = 0
     C                   EVAL      WMulValue = 1
     C                   EVAL      WDivValue = 1
     C                   ELSE
 
      ** Get the value on the left hand of '/' and set as multiplied value
      ** Get the value on the right hand of '/' and set as divide value
 
     C                   EVAL      WStart = WPosition - 1
     C                   EVAL      WEnd = WPosition + 1
     C                   EVAL      WNumerator = %SUBST(PINVP:1:WStart)
     C                   EVAL      WDenominator = %SUBST(PINVP:WEnd)
 
     C                   EVALR     WNumerator = %TRIM(WNumerator)                             233795
     C                   EVALR     WDenominator = %TRIM(WDenominator)                         233795
                                                                                              233795
     C                   MOVEL     WNumerator    WMulValue
     C                   MOVEL     WDenominator  WDivValue
     C                   ENDIF
 
      ** Trap possible blanks or zero value
 
     C                   IF        WMulValue = *Zeros  OR
     C                             WDivValue = *Zeros
     C                   EVAL      WMulValue = 1
     C                   EVAL      WDivValue = 1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
 
     C                   PARM                    PINVP
     C                   PARM                    PTXNM
 
      ** OUTPUTS
     C                   PARM                    PTAXA
 
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2005
