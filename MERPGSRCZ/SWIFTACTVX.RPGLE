     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME Check if SWIFT Feature is active')            *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  SWIFTACTVX - Check if SWIFT Feature is active                *
      *                                                               *
      *  Function:  This program will ascertain whether SWIFT         *
      *             enhancement is on.  It is active if switchable    *
      *             feature CSWxxx is installed or the run date       *
      *             is greater than or equal to the corresponding     *
      *             activation date or rundate is equal to the        *
      *             working day prior activation date and MPHAS is    *
      *             not 'A' and not 'F' and not 'G'.                  *
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

      ** Phase of day
     D MPHASA        E DS                  EXTNAME(MPHAS)

      ** SAR Descriptions
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

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
     D WRunCOB         S              1
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

     c                   EVAL      WRtCd = *BLANKS
     C                   EVAL      WActDte = 0

      ** Get activation Date

     C     PSwift        SETLL     MESWACL0                           51
     C     PSwift        CHAIN     MESWACL0                           51
     C                   IF        *IN51 = '0'
     C                   EVAL      WActDte = SWACDT
     C                   ENDIF

      ** Access Bank details via access program

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   EVAL      WRunCOB = 'N'
     C                   EVAL      WRunDNo = BJRDNB
     C**********         IF        BJDNWD >= WActDte                                        MD055736
     C                   IF        BJDNWD >= WActDte AND *IN51 = '0'                        MD055736
     C                   EVAL      WRunCOB = 'Y'
     C                   ENDIF

      ** Call activation processing

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

      ** Get data from data area MPHAS.

     C     *DTAARA       DEFINE    MPHAS         MPHASA
     C                   IN        MPHASA

      ** Access AOSARDR0 to check if SWIFT Feature is on

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      PSwift        PSard
     C     SCSARD        PARM      *BLANKS       DSFDY

      ** If return code is blanks or the run date is greater than or
      ** equal to activation date, set work return code to 'CSWACTV'
      ** or rundate is equal to the first working day prior
      ** activation date and MPHAS is not 'A', 'G' and not 'F',
      ** set work return code to 'CSWACTV'

     C                   IF        PRtCd = *BLANKS
     C**********                   OR WRunDNo >= WActDte                                    MD055736
     C                             OR (WRunDNo >= WActDte AND *IN51 = '0')                  MD055736
     C                             OR ((WRunCOB = 'Y') AND ((MPHAS <> 'A')
     C                             AND (MPHAS <> 'F') AND (MPHAS <> 'G')))
     C
     C                   EVAL      WRtCd = 'CSWACTV'
     C                   ELSE
     C                   EVAL      WRtCd = *BLANKS
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
