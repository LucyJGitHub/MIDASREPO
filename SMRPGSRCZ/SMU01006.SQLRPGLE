     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Update CRS Reports Management File  ')        *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU01006 - Midas SM Update CRS Reports Management File       *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD054905 *CREATE     Date 04Dec19             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD054905 - CRS issue: Message Header  MessageRefID          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************

     FGLCRMGPD  IF   E           K DISK    INFSR(*PSSR)
     FGLCRMDPD  IF   E           K DISK    INFSR(*PSSR)
     FGLCRMIPD  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

      ** Variables

     D PYEAR           S              4A
     D PCTRY           S              2A
     D PCUST           S             10A
     D PRtcd           S              7A

     D RUNBFOR         S              1A

     C     *ENTRY        PLIST
     C                   PARM                    PRtcd

      ** ACCESS BANK DETAILS

     C/exec SQL
     C+ select GGRYER into :PYEAR
     C+ from GLCRMGPD
     C+ where GGRYER <> ' '
     C/end-exec

     C                   IF        PYEAR <> *BLANKS
      *
      ** Change format of the CRS Report Management File
     C                   EXSR      SRCRMG
      *
      ** Change format of the CRS Report Management Details File
     C                   EXSR      SRCRMD
      *
      ** Change format of the CRS Report Management Exception Management File
     C                   EXSR      SRCRMI
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      *  SRCRMG - This subroutine will migrate all corresponding      *
      *           reports from GLCRMGPD                               *
      *****************************************************************
     C     SRCRMG        BEGSR

     C/EXEC SQL
     C+ update GLCRMGPD set GGMSID = CONCAT(SUBSTR(GGMSID,8,2),
     C+ CONCAT(CONCAT(GGRYER,SUBSTR(GGMSID,8,2)),GGMSID))
     C+ where GGMSID <> ' '
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   MOVEL     SQLCODE       PRTCD
     C                   EXSR      *PSSR
     C                   ENDIF

     C/EXEC SQL
     C+ update GLCRMGPD set GGAMID = CONCAT(SUBSTR(GGAMID,8,2),
     C+ CONCAT(CONCAT(GGRYER,SUBSTR(GGAMID,8,2)),GGAMID))
     C+ where GGAMID <> ' '
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   MOVEL     SQLCODE       PRTCD
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      *  SRCRMD - This subroutine will migrate all corresponding      *
      *           reports from GLCRMDPD                               *
      *****************************************************************
     C     SRCRMD        BEGSR

     C/EXEC SQL
     C+ update GLCRMDPD set MGDATA = CONCAT(SUBSTR(MGMSID,8,2), MGDATA)
     C+ where MGELMT = 'DocRefId' and MGDATA <> ' '
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   MOVEL     SQLCODE       PRTCD
     C                   EXSR      *PSSR
     C                   ENDIF

     C/EXEC SQL
     C+ update GLCRMDPD set MGDATA =  CONCAT(SUBSTR(MGMSID,8,2), MGDATA)
     C+ where MGELMT = 'CorrDocRefId' and MGDATA <> ' '
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   MOVEL     SQLCODE       PRTCD
     C                   EXSR      *PSSR
     C                   ENDIF

     C/EXEC SQL
     C+ update GLCRMDPD set MGMSID = CONCAT(SUBSTR(MGMSID,8,2),
     C+ CONCAT(CONCAT(:PYEAR,SUBSTR(MGMSID,8,2)), MGMSID))
     C+ where MGMSID <> ' '
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   MOVEL     SQLCODE       PRTCD
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      *  SRCRMI - This subroutine will migrate all corresponding      *
      *           reports from GLCRMIPD                               *
      *****************************************************************
     C     SRCRMI        BEGSR

     C/EXEC SQL
     C+ update GLCRMIPD set IEMSID = CONCAT(SUBSTR(IEMSID,8,2),
     C+ CONCAT(CONCAT(:PYEAR,SUBSTR(IEMSID,8,2)), IEMSID))
     C+ where IEMSID <> ' '
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   MOVEL     SQLCODE       PRTCD
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *
      *****************************************************************
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        RUNBFOR = *BLANK
     C                   MOVE      'Y'           RUNBFOR
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
