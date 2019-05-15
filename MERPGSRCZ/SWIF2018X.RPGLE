     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME Check if SWIFT 2018 is active')               *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  SWIF2018X - SWIFT 2018 Active?                               *
      *                                                               *
      *  Function:  This program will ascertain whether SWIFT 2018    *
      *             enhancement is on.  It is active if switchable    *
      *             feature CSW218 is installed or the run date       *
      *             is greater than or equal to 18th November 2018    *
      *             or Rundate is equal to 16th November and          *
      *             MPHAS is not 'A' and not 'F' and not 'G'.         *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. CSW218  *CREATE    Date 19Mar18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW218 - SWIFT Changes 2018                                  *
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

     D PRtCd           S              7
     D POptn           S              7
     D PSard           S              6
     D WRtCd           S              7
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

     C     *ENTRY        PLIST
     C                   PARM                    PRtCd

      ** If first time flag not equal to 'N', execute subroutine SRINIT

     C                   IF        (WFrstFlg <> 'N') or (WRunDNo = 17122)
     C                   EXSR      SRINIT
     C                   ENDIF

     C     PRTCD         DSPLY
     C     WRTCD         DSPLY
     C     WRUndNo       DSPLY
     C     MPHAS         DSPLY
     C                   EVAL      PRtCd = WRtCd

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

      ** Set first time to 'N'

     C                   EVAL      WFrstFlg = 'N'

      ** Get date from data area RUNDAT.

     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA

      ** Get data from data area MPHAS.

     C     *DTAARA       DEFINE    MPHAS         MPHASA
     C                   IN        MPHASA

     C                   EVAL      WRunDNo = AGRDNB

      ** Access AOSARDR0 to check if CSW218 is switched on

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSW218'      PSard
     C     SCSARD        PARM      *BLANKS       DSFDY

      ** If return code is blanks or the run date is greater than or
      ** equal to 18th November 2018, set work return code to 'CSW2018' or
      ** equal to 16th November 2018 and MPHAS is not 'A' and not 'F',
      ** set work return code to 'CSW2018'

     C                   IF        PRtCd = *BLANKS
     C                             OR WRunDNo >= 17124
     C                             OR ((WRunDNo = 17122) AND ((MPHAS <> 'A')
     C                             AND (MPHAS <> 'F') AND (MPHAS <> 'G')))
     C
     C                   EVAL      WRtCd = 'CSW2018'
     C                   ELSE
     C                   EVAL      WRtCd = *BLANKS
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
