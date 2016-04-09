     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME Check if SWIFT 2014 is active')               *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  SWIF2014 - SWIFT 2014 Active?                                *
      *                                                               *
      *  Function:  This program will ascertain whether SWIFT 2014    *
      *             enhancement is on.  It is active if switchable    *
      *             feature CSW214 is installed or the run date       *
      *             is greater than or equal to 16th November 2014.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CSW214  *CREATE    Date 25Nov14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW214 - SWIFT Changes 2014                                  *
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
     C                   IF        WFrstFlg <> 'N'
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
     C                   EVAL      WRunDNo = AGRDNB
      *
      ** Access AOSARDR0 to check if CSW214 is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSW214'      PSARD
     C     SCSARD        PARM      *BLANKS       DSFDY
      *
      ** If return code is blanks or the run date is greater than or
      ** equal to 16th November 2014, set work return code to 'CSW2014'
      *
     C                   IF        PRTCD = *BLANKS
     C                             OR WRunDNo >= 15661
     C                   EVAL      WRTCD = 'CSW2014'
     C                   ELSE
     C                   EVAL      WRTCD = *BLANKS
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
