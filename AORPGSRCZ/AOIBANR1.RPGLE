     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO IBAN convert alpha code to numeric')
      *****************************************************************
      *                                                               *
      *  Midas - Access Object                                        *
      *                                                               *
      *  AOIBANR1 - IBAN Convert Alpha Code to Numeric                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *   Prev Amend No. CFT004 *Create     DATE 14Jul99              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *   MD046248 - Finastra Rebranding                              *
      *   CFT004 - International Bank Account Number                  *
      *                                                               *
      *****************************************************************
      *
      * ID F  C  H  L     FUNCTION OF INDICATORS
      *
      *       30      LOKUP Indicator
      *
      ********************************************************************
      /EJECT
     D*ESTART
      ****************************************************************
     D ALPH            S              1    DIM(26) CTDATA PERRCD(26)
     D DIGT            S              2    DIM(26) CTDATA PERRCD(26)
      *
      * Description     : Copyright notice for inclusion in all programs
      ********************************************************************
      /EJECT
      *ISTART
      ************************************************************
      * Description     : Copyright notice for inclusion in all programs
      *
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C                   PARM                    P@RTCD            7            O:Return code
     C                   PARM                    P@ALPH            1            I:Alpha Code
     C                   PARM                    P@DIGT            2            O:Digit Code
      *****************************************************
      *MAIN
      *
     C                   MOVE      *BLANKS       P@RTCD
     C                   MOVE      *BLANKS       P@DIGT
      * Check if Apha Code input exists in the Alpha Code array :
      *
     C                   Z-ADD     1             NB                2 0
     C     P@ALPH        LOOKUP    ALPH(NB)                               30
     C     *IN30         IFEQ      *OFF
      * Alpha Code not found or not upper case
     C                   MOVE      '*CHAR  '     P@RTCD
     C                   ELSE
     C                   MOVE      *BLANKS       P@RTCD
     C                   MOVE      DIGT(NB)      P@DIGT
     C                   END
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA ALPH
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**CTDATA DIGT
1011121314151617181920212223242526272829303132333435
**CTDATA CPY@
(c) Finastra International Limited 2001
