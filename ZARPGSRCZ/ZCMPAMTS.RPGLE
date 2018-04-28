     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Compare Screen Format Amounts')
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subroutines                                 *
      *                                                               *
      *  ZCMPAMTS - Compare Screen Format Amounts                     *
      *                                                               *
      *  Function:   This module compares two screen format amounts   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAP074   *Create   Date 27Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      ****************************************************************
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
 
      **
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D Digits          C                   '0123456789.'
     D I_AA            S              1A   DIM(25)
     D O_AA            S              1A   DIM(25)
 
      * Move the amounts into a common format
 
     C                   MOVEA     ZCMPAMT1      I_AA
     C                   EXSR      MovAmnt
     C                   MOVEA     O_AA          ZCMP1            25
 
     C                   MOVEA     ZCMPAMT2      I_AA
     C                   EXSR      MovAmnt
     C                   MOVEA     O_AA          ZCMP2            25
 
      * Compare amounts
 
     C     ZCMP1         IFNE      ZCMP2
     C                   MOVEL     'Y'           ZCMPAMTDif
     C                   ELSE
     C                   MOVEL     'N'           ZCMPAMTDif
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * Move amount into a common format
      *****************************************************************
     C     MovAmnt       BEGSR
 
     C                   MOVE      *BLANK        O_AA
 
      * Identify if negatively signed
 
     C     '-'           LOOKUP    I_AA                                   99
     C   99              MOVEL     '-'           O_AA(1)
 
      * Move digits
 
     C                   Z-ADD     1             @ZX               2 0
     C                   Z-ADD     2             @ZY               2 0
 
      * Start trailing zeroes
      * Decimal point present
 
     C                   MOVEL     'N'           StrTrl            1
     C                   MOVEL     'N'           DecPnt            1
 
     C     @ZY           DOUGT     25
 
     C     @ZX           IFLE      25
     C     Digits        CHECK     I_AA(@ZX)
     C                   ENDIF
 
     C                   IF        %FOUND = '0' AND @ZX <= 25
     C                   MOVEL     'Y'           StrTrl
     C                   MOVEL     I_AA(@ZX)     O_AA(@ZY)
     C                   ADD       1             @ZY
     C                   IF        I_AA(@ZX) = '.'
     C                   MOVEL     'Y'           DecPnt
     C                   ENDIF
     C                   ELSE
     C     StrTrl        IFEQ      'Y'
     C     @ZX           ANDLE     25
     C     I_AA(@ZX)     ANDEQ     ' '
     C     @ZX           ORGT      25
     C                   IF        DecPnt = 'N'
     C                   MOVEL     'Y'           DecPnt
     C                   MOVEL     '.'           O_AA(@ZY)
     C                   ADD       1             @ZY
     C                   ENDIF
     C                   MOVEL     '0'           O_AA(@ZY)
     C                   ADD       1             @ZY
     C                   ENDIF
     C                   ENDIF
 
     C                   ADD       1             @ZX
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
     C                   PARM                    ZCMPAMT1         25
     C                   PARM                    ZCMPAMT2         25
      *
      * OUTPUTS
     C                   PARM                    ZCMPAMTDif        1
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2002
