     H DEBUG ALWNULL(*USRCTL)
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Initialise PRAPID in T_GPPDCRSV')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SMU0019984 - Midas UT Initialise PRAPID in T_GPPDCRSV        *
      *                                                               *
      *  Function:  This program will initialise PRAPID field with    *
      *             0 value and set it to PRPDID                      *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD020087 *CREATE   Date 30Sep13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD020087 - ABC Issue on Amendments on Several Write on       *
      *             Authorise APIs                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *****************************************************************
 
     FGPPDCRL0  UF   E             DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   READ      GPPDCRL0
 
     C                   DOW       NOT %EOF(GPPDCRL0)
 
     C                   IF        PRAPID = 0
     C                   EVAL      PRAPID = PRPDID
     C                   UPDATE    T_GPPDCRSV
     C                   ENDIF
 
     C                   READ      GPPDCRL0
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
