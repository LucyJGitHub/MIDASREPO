      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM to insert new record in BFTEVTCODE')          *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU91001 - Midas SM to insert new record in BFTEVTCODE       *
      *                                                               *
      *  Function:  This program will insert new record in SMBFMGTD   *
      *             to update the severity of client DB to migrated   *
      *             DB.                                               *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD060155 *CREATE     Date 13Jul22             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060155 - In FBM 2021.C Facility-Edit, there is message     *
      *             "45028960" that cannot be overridden.             *
      *           - Insert update record for BFTEVTCODE to amend      *
      *             severity from client DB to migrated DB.           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
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

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D condStatement   S          12000

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      /free
       condStatement = 'UPDATE ?.BFTB_EVENTCODE A SET A.BFSEVERITY'
           + ' = CASE WHEN A.BFSEVERITY <> (SELECT B.BFSEVERITY FROM'
           + ' #.BFTB_EVENTCODE B WHERE A.BFEVENTCODEIDPK ='
           + ' B.BFEVENTCODEIDPK) THEN (SELECT B.BFSEVERITY'
           + ' FROM #.BFTB_EVENTCODE B WHERE A.BFEVENTCODEIDPK'
           + ' = B.BFEVENTCODEIDPK) ELSE A.BFSEVERITY END'
           + ' WHERE A.BFEVENTCODEIDPK = (SELECT B.BFEVENTCODEIDPK'
           + ' FROM #.BFTB_EVENTCODE B WHERE A.BFEVENTCODEIDPK'
           + ' = B.BFEVENTCODEIDPK)';

       Exec SQL
        INSERT INTO SMBFMGTD(BFTABL,BFSTAT,BFLAYR,BFPRTY,BFRTYP,BFUFLD,BFTFLD)
        VALUES('BFTB_EVENTCODE',' ','*GLOBAL','3','UPD','', :condStatement);

       Return;
       /end-free

      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************

     C     *INZSR        BEGSR

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
