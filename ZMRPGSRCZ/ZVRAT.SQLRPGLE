     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas ZM Retrn avail act code for usr/optn')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data (SPF) / Message Management             *
      *                                                               *
      *   ZVRAT - Access available action codes for User/Pgm          *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. AR939494           Date 12Apr12               *
      *                 CBF005  *REWRITE   Date 04Jul11               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSF002             Date 11Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 086621             Date 02Apr96               *
      *                 S01449             Date 19Jan94               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR939494 - No SWIFT messages generated for Fund Transfer     *
      *             Updated query to MIVW_PERMM                       *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile (REWRITE)                                   *
      *  CSF002 - Global layer.                                       *
      *           - Replace previous ZMITEM layout with the new       *
      *             unique code.                                      *
      *  086621 - Program loops on second access as X variable is     *
      *           not reset.                                          *
      *  S01449 - Automatic Reconciliations II                        *
      *           - Ensure exit from loop if branch not in multiple   *
      *             occurrence DS                                     *
      *                                                               *
      *****************************************************************
      *
      *       Input to this program
      *       ~~~~~~~~~~~~~~~~~~~~~
      *
      *       Branch code 3A      (from callling program)
      *       Menu item requested (from DTAARA/ZMITEM)
      *       USRID               (from PSDS)
      *
      *****************************************************************
      *
      *       Output from this program
      *       ~~~~~~~~~~~~~~~~~~~~~~~~
      *
      * ACODES     : Available action codes for User/Branch
      * Error code : 0 = NO ERROR
      *              1 = NO RECORD FOUND FOR USER/MENU ITEM/BRANCH
      *
      *****************************************************************
      *
      ** Program Status Data Structure
      *
     D PSDS           SDS
     D  USRID                254    263

     C** Data structure to store BRANCH/AUTHORITY details

     D AtCode          DS
     D  ACT                           1A   DIM(6)

     D Action          S              1
     D EntType         S             10A
     D FetchErr        S              1A
     D Idx             S              2  0
     D OpenErr         S              1A
     D Stmt            S            500A

     C     *DTAARA       DEFINE                  ZMITEM           10
     C                   IN        ZMITEM
     C                   UNLOCK    ZMITEM
      *
      ** Initialise program variables
      *
     C                   Z-ADD     0             ERR
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANKS       ACODES

     C                   EXSR      Prep_SQLStm

     C                   IF        OpenErr = 'N'
     C                   EXSR      Fetch_SQLRec
     C                   END

     C                   IF        Idx > 0
     C                   MOVE      AtCode        ACODES
     C                   ELSE
     C                   Z-ADD     1             ERR
     C                   END

     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
     C     Prep_SQLStm   BEGSR

     C                   EVAL      OpenErr = 'Y'
     C                   EVAL      EntType = 'Branch'
                                                                                            AR939494
     C/EXEC SQL                                                                             AR939494
     C+ DECLARE C1 CURSOR FOR                                                               AR939494
     C+ SELECT ACA from MIVW_PERMM                                                          AR939494
     C+  WHERE INDX = :ZMITEM AND BRCB = :ZBR                                               AR939494
     C+    AND USRP = :USRID                                                                AR939494
     C/END-EXEC                                                                             AR939494
      *                                                                                     AR939494
     C/EXEC SQL                                                                             AR939494
     C+ OPEN C1                                                                             AR939494
     C/END-EXEC                                                                             AR939494
      *                                                                                     AR939494
      ***/free**                                                                            AR939494
      ***STMT*=*'SELECT PMACTC from MIVW_PERMM ' +                                          AR939494
      **********   'Where PMINDX = ? AND ENENTV = ? AND ' +                                 AR939494
      **********         'ENUSER = ? AND ENENTT = ?' ;                                      AR939494
      ***/End-free                                                                          AR939494
     C***/EXEC*SQL WHENEVER SQLERROR GOTO ERRP1                                             AR939494
     C***/END-EXEC                                                                          AR939494

     C***/EXEC*SQL                                                                          AR939494
     C***+*PREPARE S1 FROM :STMT                                                            AR939494
     C***/END-EXEC                                                                          AR939494

     C***/EXEC*SQL                                                                          AR939494
     C***+*DECLARE C1 CURSOR FOR S1                                                         AR939494
     C***/END-EXEC                                                                          AR939494

     C***/EXEC*SQL                                                                          AR939494
     C***+*OPEN C1 using :ZMITEM,:ZBR,:USRID,:EntType                                       AR939494
     C***/END-EXEC                                                                          AR939494
     C                   EVAL      OpenErr = 'N'
     C                   EVAL      SQLSTT = '00000'

     C     ERRP1         TAG
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     Fetch_SQLRec  BEGSR

     C                   EVAL      FetchErr = 'Y'

     C/EXEC SQL WHENEVER SQLERROR GOTO ERROP
     C/END-EXEC
     C                   DOW       SQLSTT = '00000' and Idx < 7
     C/EXEC SQL
     C+  FETCH C1 INTO :Action
     C/END-EXEC
     C                   IF        SQLSTT <> '02000'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ACT(Idx) = Action
     C                   ENDIF
     C                   ENDDO
     C                   EVAL      FetchErr = 'N'
     C     ERROP         TAG
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    ZBR               3
     C                   PARM                    ACODES            6
     C                   PARM                    ERR               1 0

     C                   ENDSR
      *****************************************************************
