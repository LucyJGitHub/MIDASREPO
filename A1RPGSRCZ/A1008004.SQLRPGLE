     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas FN Update UDF T_GZTRADEX/UDFTRAD13')             *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  A1008004  - Midas FN Update UDF T_GZTRADEX/UDFTRAD13         *
      *                                                               *
      *  Function:  This program updates  UDFTRAD08 from Trade        *
      *  Called By: A1008002                                          *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD059806           Date 24Apr22               *
      *  Prev Amend No. BA1008   *CREATE   Date 03Jun21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059806 - Trade UDF fields not replicating onto T_GZTRADEX. *
      *             Change DDTRDF to DDTDRF field.                    *
      *  BA1008 - Replication of Trades to consolidated Branches      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *    99         Found Action Code Record                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
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
      *
      ** Dynamic SQL statement work field
      *
     D WSTRSQL         S           1000A   INZ(*BLANKS)
      *
     D SysValue        S            200                                                     AR989143
     D ZoneName        S             10
     D Traderef        S              6
     D FRNTref         S              6
     D UniqueID        S             10
     D RTNCALL         S              1
     D ReturnCode      S              7
     D Option          S              7
     D Parms           S             80
     D Quote           S              1
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +------------------------------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     DDSSDY          E DS


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      ** MAIN PROCEDURE                                               *
      *****************************************************************
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA

      *                                                                                     AR989143
      ** Retrieve zone name from System Value file                                          AR989143
      *                                                                                     AR989143
     C/EXEC SQL                                                                             AR989143
     C**select*GIVAL into :SysValue from SDSVALPD                                    AR989143 BA1008
     C+ Declare Cursor1 Insensitive scroll cursor for                                         BA1008
     C+ select GIVAL from SDSVLJW0                                                            BA1008
     C+ where GISVAL = 'ZoneSystemName'                                                     AR989143
     C/END-EXEC                                                                             AR989143
                                                                                              BA1008
     C/EXEC SQL                                                                               BA1008
     C+ Open Cursor1                                                                          BA1008
     C/END-EXEC                                                                               BA1008
                                                                                              BA1008
     C/EXEC SQL                                                                               BA1008
     C+ FETCH NEXT FROM Cursor1 INTO :SysValue                                                BA1008
     C/END-EXEC                                                                               BA1008
      *                                                                                       BA1008
     C/EXEC SQL                                                                               BA1008
     C+ Close Cursor1                                                                         BA1008
     C/END-EXEC                                                                               BA1008
      *                                                                                     AR989143
     C                   IF        SysValue = *BLANKS                                       AR989143
     C     *LOCK         IN        LDA                                                      AR989143
     C                   EVAL      *INU7 = *ON                                              AR989143
     C                   EVAL      *INU8 = *ON                                              AR989143
     C                   EVAL      DBFILE =  'SDSVALPD'                                     AR989143
     C                   EVAL      DBKEY  =  'ZoneSystemName'                               AR989143
     C                   EVAL      DBPGM  =  PSProcPgm                                      AR989143
     C                   EVAL      DBASE  =  002                                            AR989143
     C                   EVAL      DBMOD  =  PSProcMod                                      AR989143
     C                   EVAL      DBPROC =  'Main'                                         AR989143
     C                   OUT       LDA                                                      AR989143
     C                   EXSR      *PSSR                                                    AR989143
     C                   ELSE                                                               AR989143
     C                   EVAL      ZoneName = %TRIM(SysValue)                               AR989143
     C                   ENDIF                                                              AR989143
      *                                                                                     AR989143
     C                   Eval      WSTRSQL = 'update T_GZTRADEX set ' +
     C                                        ' UDFTRAD13  = ' + '''' +
     C                                        %trim(FRNTref) + '''' +
     C**********                              ' where DDTRDF = ' + '''' +                   MD059806
     C                                        ' where DDTDRF = ' + '''' +                   MD059806
     C                                        %trim(Traderef) + '''' +
     C                                        ' and ZONE = ' +  '''' +
     C                                        %trim(ZoneName) + ''''
      *
      ** Prepare SQL statement
      *
     C/EXEC SQL
     C+ PREPARE S1 FROM :WSTRSQL
     C/END-EXEC
      *
      ** Execute SQL statement
      *
     C/EXEC SQL
     C+ EXECUTE S1
     C/END-EXEC
     C                   IF        SQLCOD = 100
     C                   MOVEL     'NRF'         ReturnCode
     C                   Endif
     C                   IF        SQLCOD <> 0  And SQLCOD <> 100
     C                   MOVEL     'A1008004'    DBPGM
     C                   MOVEL     'T_GZTRADEX'  DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     TRADEREF      DBKEY
     C                   MOVEL     'ERR'         ReturnCode
      *
     C                   ENDIF
     C                   COMMIT
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST
     C                   PARM                    Traderef
     C                   PARM                    FRNTRef

     C                   ENDSR
      *
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
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN
      *
     C                   ENDSR
      *
