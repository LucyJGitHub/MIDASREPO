     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO IBAN format')                                 *
      *****************************************************************
      *                                                               *
      *  Midas - Access Object                                        *
      *                                                               *
      *  AOIBANR3 - IBAN Format                                       *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE083BA           Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004  *CREATE    Date 15Jul99               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE083BA -  COB Restructure - RE COB Optimisation Phase 1    *
      *  CFT004 - International Bank Account Number                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  30    - LOKUP                                                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *                                                               *
      *****************************************************************
      /EJECT
      ** Array containing Copyright statement
      *
     D PIBAN           S              1    DIM(47)                              I:IBAN Number
     D PIWITH          S              1    DIM(47)                              O:With Blanks
     D PINOBL          S              1    DIM(34)                              O:No   Blanks
      ** Arrays containing Input and Output Parameters
     D WIBAN           S              1    DIM(47)                              Work IBAN
      ** Work Array
      *
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      /SPACE 3
      *
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C                   PARM                    P@RTCD            7            B:Return code
     C                   PARM                    PIBAN                          I:Option
     C                   PARM                    PIWITH                         O:With blanks
     C                   PARM                    PINOBL                         O:No Blanks
      *****************************************************
      *MAIN
      *
     C                   MOVEA     *BLANKS       PIWITH
     C                   MOVEA     *BLANKS       PINOBL
     C                   MOVEA     *BLANKS       WIBAN
      * Remove blanks
     C                   Z-ADD     0             WCOUNT            2 0          Counter
     C                   Z-ADD     0             WLENGTH           2 0          Length
     C     WCOUNT        DOWLT     47
     C                   ADD       1             WCOUNT
     C     PIBAN(WCOUNT) IFNE      *BLANK
     C                   ADD       1             WLENGTH
     C                   MOVE      PIBAN(WCOUNT) WIBAN(WLENGTH)
     C                   ENDIF
     C                   ENDDO
      *
      * Remove 'IBAN'tag if present
     C                   MOVEA     PIBAN         WTAG              4
     C     WTAG          IFEQ      'IBAN'
     C                   Z-ADD     4             WCOUNT
     C                   Z-ADD     0             WCOUN1            2 0
     C     WCOUNT        DOWLT     WLENGTH
     C                   ADD       1             WCOUN1
     C                   ADD       1             WCOUNT
     C                   MOVE      WIBAN(WCOUNT) PINOBL(WCOUN1)
     C                   ENDDO
     C                   SUB       4             WLENGTH
     C                   ELSE
     C                   MOVEA     WIBAN         PINOBL
     C                   ENDIF
      * Check if there are too many Characters in IBAN
     C     WLENGTH       IFGT      34
     C                   MOVE      '1'           P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      * Format with 'IBAN' text
     C                   MOVE      'I'           PIWITH(1)
     C                   MOVE      'B'           PIWITH(2)
     C                   MOVE      'A'           PIWITH(3)
     C                   MOVE      'N'           PIWITH(4)
      *
      * Format with blanks
     C                   Z-ADD     5             WWB               2 0          With Blanks
     C                   Z-ADD     0             WNB               2 0          No Blanks
     C     WNB           DOWLT     WLENGTH
     C                   ADD       1             WWB
     C                   ADD       1             WNB
     C                   MOVE      PINOBL(WNB)   PIWITH(WWB)
      *
     C     WNB           IFEQ      4
     C     WNB           OREQ      8
     C     WNB           OREQ      12
     C     WNB           OREQ      16
     C     WNB           OREQ      20
     C     WNB           OREQ      24
     C     WNB           OREQ      28
     C     WNB           OREQ      32
     C                   ADD       1             WWB
     C                   MOVE      *BLANK        PIWITH(WWB)
     C                   ENDIF
     C                   ENDDO
      *
     C**********         SETON                                        LR                    CRE083BA
     C                   RETURN
      /EJECT
      ********************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2001
