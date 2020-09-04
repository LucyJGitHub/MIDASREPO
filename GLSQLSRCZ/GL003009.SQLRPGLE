     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL003009 - Midas GL Account Transfer GLRATMSEQ Reset         *
      *                                                               *
      *  Function:  This program will reset the sequence number in    *
      *             *DTAARA GLRATMSEQ                                 *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27832*CREATE    Date 22Jun10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27832 - Chicago performance issues: File Locking on       *
      *             T_SEQUENCE. Reset GLRATMSEQ to 1.                 *
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
      * SrReset - Reset value of GLRATMSEQ data area to 1             *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Data Area giving Installation Control Details

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Program Status Data Structure
     D LDA             DS           256
      ** Local data area for database error details

     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WRun            S              1A
     D WSQLStat        S            100A   INZ(*BLANKS)

      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Define LDA

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GL003009'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBASE = 0
     C                   EVAL      DBTXT = *BLANKS
     C                   OUT       LDA

     C                   EXSR      SrReset

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrReset - Reset value of GLRATMSEQ data area to 1             *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrReset       BEGSR

      ** Prepare SQL statement

     C                   Eval      WSQLStat = 'ALTER SEQUENCE GLRATMSEQ +
     C                                     RESTART WITH 1'

      ** Reset GLRATMSEQ value to 1

     C/EXEC SQL WHENEVER SQLERROR GOTO UPDERR
     C/END-EXEC

     C/EXEC SQL
     C+ PREPARE S1 FROM :WSQLStat
     C/END-EXEC

      ** Execute SQL statement

     C/EXEC SQL
     C+ EXECUTE S1
     C/END-EXEC

     C                   GOTO      ENDSEQ

      ** Database error if record is not found


     C     UPDERR        TAG
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLRATMSEQ'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR


     C     ENDSEQ        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP

     C                   CALL      'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

 ;                                                                              :
  label on table     **********/**********                                      :
   is 'Midas GL Account Transfer Reference Seq Reset     ';                     :
                                                                                :
