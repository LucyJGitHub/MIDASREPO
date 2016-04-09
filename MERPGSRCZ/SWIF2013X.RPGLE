     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME Check if SWIFT 2013 is active')               *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  SWIF2013X - SWIFT 2013 Active?                               *
      *                                                               *
      *  Function:  This program will ascertain whether SWIFT 2013    *
      *             enhancement is on.  It is active if switchable    *
      *             feature CSW213 is installed or the run date       *
      *             is greater than or equal to 17th November 2013    *
      *             or Rundate is equal to 16th November and          *
      *             MPHAS is not 'A' and not 'F'.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW213 - SWIFT Changes 2013                                  *
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
 
      ** Data Area giving Installation Control Details
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
 
     D MPHASA        E DS                  EXTNAME(MPHAS)
 
      ** SAR Descriptions
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Data Structures used by Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D WRTCD           S              7
     D WFrstFlg        S              1
     D WRunDNo         S              5  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
      *
      ** If first time flag not equal to 'N', execute subroutine SRINIT
      *
     C                   IF        (WFrstFlg <> 'N') or (WRunDNo = 15296)
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
     C                   EVAL      WFrstFlg = 'N'
      *
      ** Get date from data area RUNDAT.
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
      *
      ** Get data from data area MPHAS.
      *
     C     *DTAARA       DEFINE    MPHAS         MPHASA
     C                   IN        MPHASA
      *
     C                   EVAL      WRunDNo = AGRDNB
      *
      ** Access AOSARDR0 to check if CSW213 is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSW213'      PSARD
     C     SCSARD        PARM      *BLANKS       DSFDY
      *
      ** If return code is blanks or the run date is greater than or
      ** equal to 17th November 2013, set work return code to 'CSW2013' or
      ** equal to 16th November 2013 and MPHAS is not 'A' and not 'F',
      ** set work return code to 'CSW2013'
      *
     C                   IF        PRTCD = *BLANKS
     C                             OR WRunDNo >= 15297
     C                             OR (WRunDNo = 15296) AND (MPHAS <> 'A')
     C                             AND (MPHAS <> 'F')
     C                   EVAL      WRTCD = 'CSW2013'
     C                   ELSE
     C                   EVAL      WRTCD = *BLANKS
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
