     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Upgrade DTAARA LERSTS (to update LLSTRN)')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00087 - Upgrade for dataarea LERSTS                       *
      *                                                               *
      *  Function:  This program updates field LLSTRN of dataarea     *
      *             LERSTS                                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 142402 *C *CREATE  Date 10Nov98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S15817707.                         *
      *  142402  - Upgrade program to update dataarea LERSTS          *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D LERSTS        E DS                  EXTNAME(LERSTS)
     D  WHISST       E                     EXTFLD(FACHISD)
     D  LERC20       E                     EXTFLD(LERC2030)
     D  LERC13       E                     EXTFLD(LERC135)
     D  LERC35       E                     EXTFLD(LERC315)
     D  LERC42       E                     EXTFLD(LERC425)
     D  EOYFLG       E                     EXTFLD(EOYFLAG)
     C/EJECT
      *****************************************************************
      *                                                               *
      *  Main Processing.                                             *
      *                                                               *
      *****************************************************************
      *
      ** Output the LASTRN value of dataarea LERSTS to LLSTRN
      *
     C     *DTAARA       DEFINE                  LERSTS
     C     *LOCK         IN        LERSTS
     C                   Z-ADD     LASTRN        LLSTRN            5 0
     C                   OUT       LERSTS
      *
     C                   MOVE      '1'           *INLR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      * Check to see that *PSSR has not already been called.
     C     *INLR         IFNE      *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
