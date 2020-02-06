     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*S*D****RPGBASEMOD****************************************************                      CSW206H
/*STD *  RPGBASEBND                                                   *                      CSW206H
/*EXI *  TEXT('Midas ME Check if SWIFT 2006 is active')               *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  SWIF2006X - SWIFT 2006 Active?                               *
      *                                                               *
      *  Function:  This program will ascertain whether SWIFT 2006    *
      *             enhancement is on.  It is active if switchable    *
      *             feature CSW206 is installed or the run date       *
      *             is greater than or equal to 18th November 2006.   *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206H            Date 11Aug06               *
      *                 CSW206G *Create    Date 11Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CSW206H - SWIFT 2006 Standard Changes                        *
      *  CSW206G - SWIFT 2006 Standard Changes                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRINIT - Initialisation Subroutine                           *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      *
      ** Data Area giving Installation Control Details
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      ***Data*Area*of*the*Phase*of*the*Day*****************************                       CCB020
      *
     D*MPHASA********E DS                  EXTNAME(MPHAS)                                     CCB020
      *
      ** SAR Descriptions
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Data Structures used by Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D WRTCD           S              7
     D WFrstFlg        S              1
     D WRunDNo         S              5  0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
      *
      ** If first time flag not equal to 'N', execute subroutine SRINIT.
      *
     C                   IF        WFrstFlg <> 'N'
     C                             OR WRunDNo = 12740
     C                   EXSR      SRINIT
     C                   ENDIF
      *
     C                   EVAL      PRTCD = WRTCD
      *
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation Subroutine                           *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Set first time to 'N'
      *
     C                   EVAL      WFRSTFLG = 'N'
      *
      ** Get date from data area RUNDAT.
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   EVAL      WRunDNo = AGRDNB
      *
      ***Get*MPHAS*information.****************************************                       CCB020
      *
     C******DTAARA       DEFINE    MPHAS         MPHASA                                       CCB020
     C**********         IN        MPHASA                                                     CCB020
      *
      ** Access AOSARDR0 to check if CSW206 is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSW206'      PSARD
     C     SCSARD        PARM      *BLANKS       DSFDY
      *
      ** If return code is blanks or
      ***the*run*date*is*greater*than*or*equal*to*18th*November*2006*or                       CCB020
      ***the*run*date*is*equal*to*17th*November*2006*and*during*CoB,***                       CCB020
      ** the run date is greater then or equal to 17th November 2006,                         CCB020
      ** set work return code to 'CSW2006'.
      *
     C                   IF        PRTCD = *BLANKS
     C**********                   OR WRunDNo >= 12741                                        CCB020
     C**********                   OR WRunDNo = 12740 AND MPHAS <> 'A'                        CCB020
     C                             OR WRunDNo >= 12740                                        CCB020
     C                   EVAL      WRTCD = 'CSW2006'
     C                   ELSE
     C                   EVAL      WRTCD = *BLANKS
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
