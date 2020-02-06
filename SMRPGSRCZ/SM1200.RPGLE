     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update core source library on SDSVALPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1200 - Update core source library on SDSVALPD              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CAP205             Date 23Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CUP016 *C *CREATE  Date 01Apr03               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CUP016 - Add implementation software to core.                *
      *                                                               *
      *****************************************************************
      *                                                               *
      * Indicator Function Summary                                    *
      *                                                               *
      *  21    SDSVALPD chain failed                                  *
      *                                                               *
      *****************************************************************
      *
     FSDSVALL0  UF   E           K DISK    INFSR(*PSSR)
      *
     D SVAL_Key        S             20
      *
      /EJECT
      *
     C     *ENTRY        PLIST
     C                   PARM                    SRCL             10
      *
     C                   EVAL      SVAL_Key = 'BrgDeliveredSrcLib'
      *
      * Chain to systems value file
     C     SVAL_Key      CHAIN     SDSVALL0                           2121
      * If not found then perform error subroutine and exit program ...
     C                   IF        *IN21 = *ON
     C                   EXSR      *PSSR
      * ...else update status.
     C                   ELSE
     C                   EVAL      GIVAL = SRCL
     C                   UPDATE    @SVALL0
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  Subroutine: *PSSR - Error handling                           *
      *                                                               *
      *  Called by : *Auto                                            *
      *  Calls     : *None                                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
