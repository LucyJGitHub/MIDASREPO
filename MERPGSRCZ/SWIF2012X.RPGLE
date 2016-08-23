     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME Check if SWIFT 2012 is active')               *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  SWIF2012X - SWIFT 2012 Active?                               *
      *                                                               *
      *  Function:  This program will ascertain whether SWIFT 2012    *
      *             enhancement is on.  It is active if switchable    *
      *             feature CSW212 is installed or the run date       *
      *             is greater than or equal to 17th November 2012    *
      *             or Rundate is equal to 16th November and          *
      *             MPHAS is not 'A' and not 'F'                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CSW212  *CREATE    Date 03May12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW212 - SWIFT 2012 Changes                                  *
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
     C                   IF        (WFrstFlg <> 'N') or (WRunDNo = 14931)
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
      ** Access AOSARDR0 to check if CSW212 is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSW212'      PSARD
     C     SCSARD        PARM      *BLANKS       DSFDY
      *
      ** If return code is blanks or the run date is greater than or
      ** equal to 17th November 2012, set work return code to 'CSW2012' or
      ** equal to 16th November 2012 and MPHAS is not 'A' and not 'F',
      ** set work return code to 'CSW2012'
      *
     C                   IF        PRTCD = *BLANKS
     C                             OR WRunDNo >= 14932
     C                             OR (WRunDNo = 14931) AND (MPHAS <> 'A')
     C                             AND (MPHAS <> 'F')
     C                   EVAL      WRTCD = 'CSW2012'
     C                   ELSE
     C                   EVAL      WRTCD = *BLANKS
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
