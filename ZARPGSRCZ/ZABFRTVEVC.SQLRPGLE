     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas ZA Retrieve BankFusion Event Code')
      *****************************************************************
      *                                                               *
      *  Midas - Common Routines                                      *
      *                                                               *
      *  ZABFRTVEVC - Retrieve BankFusion Event Codes                 *
      *                                                               *
      *  Function:  This module takes error and warning messages      *
      *             issued by the APIs and returns BF Event Codes     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR996838           Date 10Jul12               *
      *  Prev Amend No. CBF011  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR996838 - Incorrect BF event code and description when      *
      *             trying to reverse a facility attached to a live   *
      *             account                                           *
      *           - BF event code 45099999 always displays for all    *
      *             new MsgId under BF2.0                             *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    10 - Message Id found in Data Array                        *
      *    11 - Check for numeric data                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * GetErrEvCdR - Get BF Event Codes for Error Messages           *
      * GetWrnEvCdR - Get BF Event Codes for Warnings                 *
      * SrchDtaArr - Search Data Array fo previous records            *
      * PrepStmt - Prepare SQL variables                              *
      * CrtEvCd - Create BF event code                                *
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
 
      ** The maximum size of the error arrays
     D ArrayMax        C                   CONST(75)
 
      ** Message Id
     D #ErrMsgId       S             50A
 
      ** Field Name
     D #FldNam         S             20A
 
      ** API Name
     D #ApiSize        S             20A
 
      ** Message File
     D #MsgFile        S             10A
 
      ** BF Event Code
     D #BFEvntCode     S              8A
 
      ** Array of error message IDs
     D ErrMsgIdArr     S                   DIM(ArrayMax)
     D                                     LIKE(#ErrMsgId)
 
      ** Array of warning message IDs
     D WErMsgIdArr     S                   DIM(ArrayMax)
     D                                     LIKE(#ErrMsgId)
 
      ** Array of Field Names with Errors
     D FldNameArr      S                   DIM(ArrayMax)
     D                                     LIKE(#FldNam)
 
      ** Array of Field Names with Warnings
     D WFldNameArr     S                   DIM(ArrayMax)
     D                                     LIKE(#FldNam)
 
      ** Array of message files
     D BFEvCdArr       S                   DIM(ArrayMax)
     D                                     LIKE(#BFEvntCode)
 
      ** Array of warning BF Event Codes
     D WBFEvCdArr      S                   DIM(ArrayMax)
     D                                     LIKE(#BFEvntCode)
 
      ** Data Array - message file, message id
     D                 DS
     D DatArr                       108    DIM(9999)
     D  DatAPI                             LIKE(#APISize) OVERLAY(DatArr)
     D  DatFld                             LIKE(#FldNam) OVERLAY(DatArr:*next)
     D  DatErr                             LIKE(#ErrMsgID) OVERLAY(DatArr:*next)
     D  DatMsF                             LIKE(#MsgFile) OVERLAY(DatArr:*next)
     D  DatEvc                             LIKE(#BFEvntCode)
     D                                     OVERLAY(DatArr:*next)
 
      ** Temporary Array for holding query result
     D TmpArr          DS
     D  TAPI                   1     20
     D  TFld                  21     40
     D  TErr                  41     90
     D  TMsF                  91    100
     D  TEvc                 101    108
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRun            S              1A
     D STMT            S            200A   INZ(*BLANKS)
     D APIName         S             20A
     D RecCount        S              5  0
     D RetCode         S              7A
     D I               S              5  0
     D X               S              5  0
     D ConApos         C                   CONST('''')
     D VarApos         S              1A
     D VarID           S             50A
     D FinID           S             52A
     D FinAPI          S             22A
     D VarFld          S             20A
     D FinFld          S             22A
     D ErrTyp          S              1A
     D Found           S              1A
     D SrchErr         S             50A
     D SrchStr         S             80A
     D NumCheck        C                   CONST('0123456789')                              AR996838
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Check if mapping table is empty
      *
     C                   EVAL      RecCount = *Zero
      *
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :RecCount FROM MIVW_BFEVC
     C/END-EXEC
      *
     C                   IF        RecCount = 0
     C                   EVAL      RetCode = '*NODATA'
     C                   ELSE
      *
      ** Prepare API Name for query
      *
     C                   EVAL      FinAPI = *BLANKS
     C                   MOVEL     ConApos       VarApos
     C                   MOVEL     VarApos       FinAPI
     C     FinAPI        CAT       APIName:0     FinAPI
     C                   EVAL      FinAPI = %TRIM(FinAPI) + VarApos
      *
      ** Retrieve Error and Warning Event Codes for Midas
      *
     C                   EXSR      GetErrEvCd
     C                   EXSR      GetWrnEvCd
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetErrEvCd - Retrieve corresponding BF event code from mapping*
      *              file for all errors                              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      *****************************************************************
     C     GetErrEvCd    BEGSR
 
     C                   EVAL      I = 1
 
     C                   DOW       I <= ArrayMax AND
     C                             ErrMsgIdArr(I) <> *BLANKS
 
     C                   EVAL      Found = 'N'
 
     C                   EVAL      SrchErr = ErrMsgIdArr(I)
     C                   EVAL      SrchStr = *BLANKS
     C                   EVAL      SrchStr = APIName + FldNameArr(I) +
     C                                       SrchErr
      *
      ** Search Event Codes in Data Array
      *
     C                   EXSR      SrchDtaArr
 
      *
      ** Retrieve BF Event Code from Data Array
      *
     C                   IF        *IN10 = *ON
     C                   EVAL      BFEvCdArr(I) = DatEvc(X)
      *
      ** Setup work variables for accessing mapping table
      *
     C                   ELSE
      *
      ** Prepare variables for query
      *
     C                   EVAL      VarId = ErrMsgIdArr(I)
     C                   EVAL      VarFld = FldNameArr(I)
 
      *
      ** Prepare variables for query
      *
     C                   EXSR      PrepStmt
      *
      ** Retrieve Event Code from mapping table
      *
     C                   EXSR      GenStmt
 
     C                   IF        SQLCODE = *ZERO
     C
     C                   EVAL      BFEvCdArr(I) = TEvc
     C                   MOVEA     TmpArr        DatArr(X)
     C                   ELSE
     C                   EVAL      ErrTyp = 'E'
     C                   EXSR      CrtEvCd
     C                   ENDIF
 
     C/EXEC SQL
     C+ CLOSE C1
     C/END-EXEC
 
     C                   ENDIF
     C                   EVAL      I = I + 1
 
     C                   ENDDO
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetWrnEvCd - Retrieve corresponding BF event code from mapping*
      *              file for all warnings                            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      *****************************************************************
     C     GetWrnEvCd    BEGSR
 
     C                   EVAL      I = 1
 
     C                   DOW       I <= ArrayMax AND
     C                             WErMsgIdArr(I) <> *BLANKS
 
     C                   EVAL      Found = 'N'
 
     C                   EVAL      SrchErr = WErMsgIdArr(I)
     C                   EVAL      SrchStr = *BLANKS
     C                   EVAL      SrchStr = APIName + WFldNameArr(I) +
     C                                       SrchErr
      *
      ** Search Event Codes in Data Array
      *
     C                   EXSR      SrchDtaArr
 
      *
      ** Retrieve BF Event Code from Data Array
      *
     C                   IF        *IN10 = *ON
     C                   EVAL      WBFEvCdArr(I) = DatEvc(X)
      *
      ** Setup work variables for accessing mapping table
      *
     C                   ELSE
      *
      ** Prepare variables for query
      *
     C                   EVAL      VarId = WErMsgIdArr(I)
     C                   EVAL      VarFld = WFldNameArr(I)
 
      *
      ** Prepare variables for query
      *
     C                   EXSR      PrepStmt
      *
      ** Retrieve Event Code from mapping table
      *
     C                   EXSR      GenStmt
 
     C                   IF        SQLCODE = *ZERO
 
     C                   EVAL      WBFEvCdArr(I) = TEvc
     C                   MOVEA     TmpArr        DatArr(X)
     C                   ELSE
     C                   EVAL      ErrTyp = 'W'
     C                   EXSR      CrtEvCd
     C                   ENDIF
 
     C/EXEC SQL
     C+ CLOSE C1
     C/END-EXEC
 
     C                   ENDIF
     C                   EVAL      I = I + 1
 
     C                   ENDDO
     C                   ENDSR
      *
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrchDtaArr - Search any stored data from previous records     *
      *              accessed from MITB_BFEVC.                        *
      *                                                               *
      * Called by: GetErrEvCd                                         *
      *            GetWrnEvCd                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrchDtaArr    BEGSR
      *
     C                   EVAL      X = 1
     C                   DOW       DatArr(X) <> *BLANK AND
     C                             X <= 9999 AND
     C                             Found = 'N'
      *
     C     SrchStr:80    SCAN      DatArr(X):1                            10
      *
     C                   IF        *IN10 = *OFF
     C                   EVAL      X = X + 1
     C                   ELSE
     C                   EVAL      Found = 'Y'
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GenStmt - Generate SQL statement                              *
      *                                                               *
      * Called by: GetErrEvCd                                         *
      *            GetWrnEvCd                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     GenStmt       BEGSR
 
     C                   EVAL      STMT = *BLANKS
     C                   EVAL      STMT = 'SELECT * FROM MIVW_BFEVC +
     C                                    WHERE EVAPIN = ' + FinAPI +
     C                                    ' AND EVFLDN = ' + FinFld +
     C                                    ' AND EVERCD = ' + FinId
 
     C                   EXSR      ExecStmt
 
     C                   IF        SQLCODE = 100
 
     C/EXEC SQL
     C+ CLOSE C1
     C/END-EXEC
 
     C                   EVAL      STMT = *BLANKS
     C                   EVAL      STMT = 'SELECT * FROM MIVW_BFEVC +
     C                                    WHERE EVAPIN = ' + FinAPI +
     C                                    ' AND EVERCD = ' + FinId
     C                   EXSR      ExecStmt
 
     C                   ENDIF
 
     C                   IF        SQLCODE = 100
 
     C/EXEC SQL
     C+ CLOSE C1
     C/END-EXEC
 
     C                   EVAL      STMT = *BLANKS
     C                   EVAL      STMT = 'SELECT * FROM MIVW_BFEVC +
     C                                    WHERE EVFLDN = ' + FinFld +
     C                                    ' AND EVERCD = ' + FinId
     C                   EXSR      ExecStmt
 
     C                   ENDIF
 
     C                   IF        SQLCODE = 100
 
     C/EXEC SQL
     C+ CLOSE C1
     C/END-EXEC
 
     C                   EVAL      STMT = *BLANKS
     C                   EVAL      STMT = 'SELECT * FROM MIVW_BFEVC +
     C                                    WHERE EVERCD = ' + FinId
     C                   EXSR      ExecStmt
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ExecStmt - Execute SQL statement                              *
      *                                                               *
      * Called by: GetErrEvCd                                         *
      *            GetWrnEvCd                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ExecStmt      BEGSR
 
     C/EXEC SQL
     C+ PREPARE S1 FROM :STMT
     C/END-EXEC
 
     C/EXEC SQL
     C+ DECLARE C1 CURSOR FOR S1
     C/END-EXEC
 
     C/EXEC SQL
     C+ OPEN C1
     C/END-EXEC
 
     C/EXEC SQL
     C+ FETCH NEXT FROM C1 INTO :TmpArr
     C/END-EXEC
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PrepStmt - Prepare SQL statement variables for query          *
      *                                                               *
      * Called by: GetErrEvCd                                         *
      *            GetWrnEvCd                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     PrepStmt      BEGSR
      *
      ** Format query variables with apostrophes
      *
     C                   EVAL      FinId = *BLANKS
     C                   MOVEL     VarApos       FinId
     C     FinId         CAT       VarId:0       FinId
     C                   EVAL      FinId = %TRIM(FinId) + VarApos
      *
     C                   EVAL      FinFld = *BLANKS
     C                   MOVEL     VarApos       FinFld
     C     FinFld        CAT       VarFld:0      FinFld
     C                   EVAL      FinFld = %TRIM(FinFld) + VarApos
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CrtEvCd - Create BF Event Code for messages not found in      *
      *           MITB_BFEVC and move to output array.                *
      *                                                               *
      * Called by: GetWrnEvCd                                         *
      *            GetErrEvCd                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     CrtEvCd       BEGSR
      *
      ** Process error messages
      *
     C                   IF        ErrTyp = 'E'
     C**********         TESTN                   ErrMsgIdArr(I)         11                  AR996838
     C                   IF        %CHECK(NumCheck:%TRIM(ErrMsgIdArr(I))) = 0               AR996838
      *
      ** Prefix with 4 if Error Message Id is numeric
      *
     C**********         IF        *IN11 = *OFF                                             AR996838
     C                   EVAL      BFEvCdArr(I) = '4' + ErrMsgIdArr(I)
      *
      ** Else return 'bf event code not found'
      *
     C                   ELSE
     C                   EVAL      BFEvCdArr(I) = '45099999'
     C                   ENDIF
      *
      ** Process warnings
      *
     C                   ELSE
     C**********         TESTN                   WErMsgIdArr(I)         11                  AR996838
     C                   IF        %CHECK(NumCheck:%TRIM(WErMsgIdArr(I))) = 0               AR996838
      *
      ** Prefix with 4 if Error Message Id is numeric
      *
     C**********         IF        *IN11 = *ON                                              AR996838
     C                   EVAL      WBFEvCdArr(I) = '4' + WErMsgIdArr(I)
      *
      ** Else return 'bf event code not found'
      *
     C                   ELSE
     C                   EVAL      WBFEvCdArr(I) = '45099999'
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCode
     C                   PARM                    APIName
     C                   PARM                    FldNameArr
     C                   PARM                    WFldNameArr
     C                   PARM                    ErrMsgIdArr
     C                   PARM                    WErMsgIdArr
     C                   PARM                    BFEvCdArr
     C                   PARM                    WBFEvCdArr
      *
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
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
