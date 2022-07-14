      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM to update severity of BFTEVTCODE')            *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU91001 - Midas SM to update severity of BFTEVTCODE         *
      *                                                               *
      *  Function:  This program will update the severity field       *
      *             of BFTEVTCODE from client previous DB to migrated *
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
      *           - Update severity field of BFTEVTCODE from client   *
      *             previous DB to migrated DB.                       *
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
       condStatement = 'UPDATE <gg>BFLIB.BFTB_EVENTCODE A SET A.BFSEVERITY' 1
           + '= CASE WHEN A.BFSEVERITY <> (SELECT B.BFSEVERITY FROM'        2
           + '<Temp BFLIB>.BFTB_EVENTCODE B WHERE A.BFEVENTCODEIDPK ='      3
           + ' B.BFEVENTCODEIDPK) THEN (SELECT B.BFSEVERITY'                4
           + ' FROM <Temp BFLIB>.BFTB_EVENTCODE B WHERE A.BFEVENTCODEIDPK'  5
           + ' = B.BFEVENTCODEIDPK) ELSE A.BFSEVERITY END'                  6
           + ' WHERE A.BFEVENTCODEIDPK = (SELECT B.BFEVENTCODEIDPK'         7
           + ' FROM <Temp BFLIB>.BFTB_EVENTCODE B WHERE A.BFEVENTCODEIDPK'  8
           + ' = B.BFEVENTCODEIDPK)';

       condStatement = 'UPDATE ?.BFTB_EVENTCODE A SET A.BFSEVERITY'
           + ' = CASE WHEN A.BFSEVERITY <> (SELECT B.BFSEVERITY FROM'
           + ' #.BFTB_EVENTCODE B WHERE A.BFEVENTCODEIDPK ='
           + ' B.BFEVENTCODEIDPK) THEN (SELECT B.BFSEVERITY'
           + ' FROM #.BFTB_EVENTCODE B WHERE A.BFEVENTCODEIDPK'
           + ' = B.BFEVENTCODEIDPK) ELSE A.BFSEVERITY END'
           + ' WHERE A.BFEVENTCODEIDPK = (SELECT B.BFEVENTCODEIDPK'
           + ' FROM #.BFTB_EVENTCODE B WHERE A.BFEVENTCODEIDPK'
           + ' = B.BFEVENTCODEIDPK)';
                ;

       USZONESTM = 'Update '+ ZOMSYS +'DTALIB/MUSERDD set USZONE = ''' +
                       ZOZONE + ''' where USRP in (select BFNAMEPK ' +
                       'from BFTB_USER)';                                                //AR1085933
           Exec SQL
                Prepare MUSZONE from :USZONESTM;

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
