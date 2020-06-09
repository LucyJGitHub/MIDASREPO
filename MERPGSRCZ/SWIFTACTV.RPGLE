     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME Check if SWIFT Feature is active')            *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  SWIFTACTV - Check if SWIFT Feature is active                 *
      *                                                               *
      *  Function:  This program will ascertain whether SWIFT Feature *
      *             enhancement is on. It is active if switchable     *
      *             feature CSWxxx is installed or the run date is    *
      *             greater than or equal to the activation date      *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD055736           Date 30Apr20               *
      *  Prev Amend No. CSW219  *CREATE    Date 04Mar19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055736 - CSW220 changes are still enabled even when the    *
      *             feature was manually switched OFF                 *
      *  CSW219 - SWIFT Changes 2019                                  *
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
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMESWACL0  IF   E           K DISK
      ** Midas ME SWIFT Activation File

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

     D PRtCd           S              7
     D PSwift          S              6
     D POptn           S              7
     D PSard           S              6
     D WRtCd           S              7
     D WRunDNo         S              5  0
     D WActDte         S              5  0

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
     C                   PARM                    PSwift
     C                   PARM                    PRtCd

      ** Initialise work variables, then call activation checking

     C                   EVAL      WActDte = 0
     C                   EVAL      WRtCd = *BLANKS
     C                   EXSR      SRINIT

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

      ** Get date from data area RUNDAT.

     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   EVAL      WRunDNo = AGRDNB

      ** Get activation Date

     C     PSwift        SETLL     MESWACL0                           51
     C     PSwift        CHAIN     MESWACL0                           51
     C                   IF        *IN51 = '0'
     C                   EVAL      WActDte = SWACDT
     C                   ENDIF

      ** Access AOSARDR0 to check if SWIFT Feature is on

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      PSWift        PSard
     C     SCSARD        PARM      *BLANKS       DSFDY

      ** If return code is blanks or the run date is greater than or
      ** equal to activation date, set work return code to 'CSWACTV'

     C                   IF        PRtCd = *BLANKS
     C**********                   OR WRunDNo >= WActDte                                    MD055736
     C                             OR (WRunDNo >= WActDte AND *IN51 = '0')                  MD055736
     C                   EVAL      WRtCd = 'CSWACTV'
     C                   ELSE
     C                   EVAL      WRtCd = *BLANKS
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
