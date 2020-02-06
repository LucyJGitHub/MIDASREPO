     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Check if SWIFT 2003 is active')
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  SWIF2003 - SWIFT 2003 Active?                                *
      *                                                               *
      *  Function:  This program will ascertain whether SWIFT 2003    *
      *             enhancement is on.  It is active if switchable    *
      *             feature CSW203 is installed or the run date       *
      *             is greater than or equal to 15th November 2003.   *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSW203  *CREATE    Date 26May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW203 - SWIFT 2003 Standards Update                         *
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
 
      ** If first time flag not equal to 'N', execute subroutine SRINIT.
 
     C                   IF        WFrstFlg <> 'N'
     C                   EXSR      SRINIT
     C                   ENDIF
 
     C                   EVAL      PRTCD = WRTCD
 
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
 
     C                   EVAL      WFRSTFLG = 'N'
 
      ** Get date from data area RUNDAT.
 
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   EVAL      WRunDNo = AGRDNB
 
      ** Access AOSARDR0 to check if CSW203 is switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSW203'      PSARD
     C     SCSARD        PARM      *BLANKS       DSFDY
 
      ** If return code is blanks or the run date is greater than or
      ** equal to 15th November 2003, set work return code to 'CSW2003'.
 
     C                   IF        PRTCD = *BLANKS
     C                             OR WRunDNo >= 11642
     C                   EVAL      WRTCD = 'CSW2003'
     C                   ELSE
     C                   EVAL      WRTCD = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
