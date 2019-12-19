     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD054605
/*STD *  RPGSQLBND                                                    *                     MD054605
/*EXI *  TEXT('Midas SM Update core source library on SDSVALPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1200 - Update core source library on SDSVALPD              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 23Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CUP016 *C *CREATE  Date 01Apr03               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
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
     F*SDSVALL0* UF   E           K DISK    INFSR(*PSSR)                                    MD054605
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
     C*****SVAL_Key      CHAIN     SDSVALL0                           2121                  MD054605
      * If not found then perform error subroutine and exit program ...                     MD054605
     C**********         IF        *IN21 = *ON                                              MD054605
     C**********         EXSR      *PSSR                                                    MD054605
      * ...else update status.                                                              MD054605
     C**********         ELSE                                                               MD054605
     C**********         EVAL      GIVAL = SRCL                                             MD054605
     C**********         UPDATE    @SVALL0                                                  MD054605
     C**********         ENDIF                                                              MD054605
     C/EXEC SQL                                                                             MD054605
     C+ update SDSVLXTD                                                                     MD054605
     C+  SET GIVAL = :SRCL                                                                  MD054605
     C+ where GISVAL = :SVAL_Key                                                            MD054605
     C/END-EXEC                                                                             MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   EXSR      *PSSR                                                    MD054605
     C                   ENDIF                                                              MD054605
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
