      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Remove redundant menu items from MACBRDD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM001072 - Select and copy Midas user data to the new system *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CUP034  *CREATE    Date 18Dec06               *
      *  Last Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP034 - MidasPlus user data migration.                      *
      *                                                               *
      *****************************************************************
      *
     FMACBR     UF   E           K DISK    INFSR(*PSSR)
      *
     FGPMTXTL0  IF   E           K DISK    INFSR(*PSSR)
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  SWSID                244    253
     D  SUSER                254    263
      *
     D                 DS
     D PrtLine                 1    100
     D  PrtPrf                 1     10
     D  PrtIndex              13     22
     D  PrtBranch             25     27
     D  PrtDesc               30     74
     D  PrtReason             77     86
      *
     D KeyIndex        S             10
     D Write           S              7    INZ('*WRITE')
     D Report          S              7    INZ('*REPORT')
     D Program         S             10    INZ('SM001073')
 
     C     *LOVAL        SETLL     MACBR
     C                   READ      MACBR
      *
     C                   DOW       NOT(%EOF)
      *
     C                   EVAL      KeyIndex = INDX
     C     KeyIndex      CHAIN     GPMTXTL0
     C                   IF        NOT(%FOUND) or
     C                             MIDEL = 'Y'
     C                   EVAL      PrtPrf    = USRP
     C                   EVAL      PrtIndex  = INDX
     C                   EVAL      PrtBranch = BRCB
     C                   IF        NOT(%FOUND)
     C                   EVAL      PrtReason = 'Not Found'
     C                   EVAL      PrtDesc = *blanks
     C                   ENDIF
     C                   IF        MIDEL = 'Y'
     C                   EVAL      PrtReason = 'Deleted'
     C                   EVAL      PrtDesc = MIINAR
     C                   ENDIF
      * Write menu item to standard report and delete record.
     C                   CALL      'UP008010'
     C                   PARM                    Write
     C                   PARM                    Program
     C                   PARM                    PrtLine
      *
     C                   DELETE    MACBR
     C                   CLEAR                   PrtLine
      *
     C                   ENDIF
      *
     C                   READ      MACBR
      *
     C                   ENDDO
      *
      * Write final report.
     C                   CALL      'UP008010'
     C                   PARM                    Report
     C                   PARM                    Program
     C                   PARM                    PrtLine
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      ********************************************************************
      *  *PSSR Subroutine - Error handling                               *
      ********************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
