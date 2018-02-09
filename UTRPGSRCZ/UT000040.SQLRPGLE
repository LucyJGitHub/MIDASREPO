     H DEBUG
     H COPYRIGHT('(c)inastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT Error Codes Collector Utility')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000040 - Error Codes Collector Utility                     *
      *                                                               *
      *  Function:  This module inserts data to the work files of the *
      *             Midas UT Error Codes Collector                    *
      *                                                               *
      *  (c)Finastra International Limited 2011                       *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. CBF011  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
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
     D Option          S              1
     D List            S           1050
     D RetCode         S              7
     D WorkVar         S            210
     D X               S              3  0

     D TopPgm          S             10
     D ErrFld          S             20
     D WErrFld         S             20
     D FldErr          S             20
     D WFldErr         S             20
     D MsgFFld         S             50
     D MsgFNam         S             50
     D ApiFld          S             10
     D ApiNam          S             10

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    Option
     C                   PARM                    List
     C                   PARM                    RetCode

     C                   SELECT
     C     Option        WHENEQ    'L'

      ** Process Library list to UTLIBLPD

     C/EXEC SQL
     C+ INSERT INTO UTLIBLPD
     C+ VALUES (:List) WITH NC
     C/END-EXEC

     C                   IF        SQLCODE <> 0
     C                   EVAL      RetCode = '*ERROR'
     C                   ENDIF

      ** Process Top-Level Programs to UTPGMLPD

     C     Option        WHENEQ    'P'

     C                   EVAL      X = 1
     C                   EVAL      WorkVar = %Subst(List:X:210)

     C                   DOW       WorkVar <> *BLANKS

     C                   EVAL      TopPgm = %Subst(WorkVar:1:10)
     C                   EVAL      ErrFld = %Subst(WorkVar:11:20)
     C                   EVAL      WErrFld = %Subst(WorkVar:31:20)
     C                   EVAL      FldErr = %Subst(WorkVar:51:20)
     C                   EVAL      WFldErr = %Subst(WorkVar:71:20)
     C                   EVAL      MsgFFld = %Subst(WorkVar:91:50)
     C                   EVAL      MsgFNam = %Subst(WorkVar:141:50)
     C                   EVAL      ApiFld = %Subst(WorkVar:191:10)
     C                   EVAL      ApiNam = %Subst(WorkVar:201:10)

     C/EXEC SQL
     C+ INSERT INTO UTPGMLPD
     C+ (PCGPGM, PCERRN, PCWERR, PCERRF, PCWERF, PCMSGF, PCMSGN, PCAPIF, PCAPIN)
     C+ VALUES (:TopPgm, :ErrFld, :WErrFld, :FldErr, :WFldErr,
     C+ :MsgFFld, :MsgFNam, :ApiFld, :ApiNam) WITH NC
     C/END-EXEC

     C                   IF        SQLCODE <> 0
     C                   EVAL      RetCode = '*ERROR'
     C                   ENDIF

     C                   EVAL      X = X + 210
     C                   EVAL      WorkVar = %Subst(List:X:210)
     C                   ENDDO

     C                   ENDSL

     C                   EVAL      *INLR = *ON
     C                   RETURN

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
