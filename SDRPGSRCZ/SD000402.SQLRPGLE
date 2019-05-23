      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Interface-User Passwords Maintenance')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000402 - Midas SD Interface-User Passwords Maintenance     *
      *                                                               *
      *  Function:  This program displays the Interface-User used by  *
      *             Midas                                             *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD053314           Date 30Apr19               *
      *  Prev Amend No. MD053140           Date 03Apr19               *
      *                 MD053114           Date 28Mar19               *
      *                 CSD101 *CREATE     Date 07Dec18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053314 - Ensure user cannot be deleted when attached to    *
      *             an Interface.                                     *
      *  MD053140 - F3 Exit and F12 Previous have the same function   *
      *             which makes it duplicate                          *
      *  MD053114 - No User is displayed in Interface Password        *
      *             maintenance                                       *
      *  CSD101 - Password Encryption                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      *  SrBldSfl - Build the Subfile                                 *
      *  SrClrSfl - Clear the Subfile                                 *
      *  SrDspSfl - Display the Subfile                               *
      *  SrErrDta - Output Error Message With Data                    *
      *  SrLoadSfl - Load the Subfile                                 *
      *  SrProcess - Process the Subfile                              *
      *  SrPrSfl - Process the Subfile Functions                      *
      *  SrRefresh - Refresh Entries                                  *
      *  SrReset - Reset the Fields                                   *
      *  SrDelPop - Populate Delete Records                           *
      *  SrDelete - Delete Validation List Entry                      *
      *  SrDeleteDesc - Update Description of Delete Record           *
      *  SrAmend - Amend Validation List Entry                        *
      *  SrAmendDesc - Amend Description in the Subfile               *
      *  SrPrcInsert - Process Insert a Record Entry                  *
      *  SrInsertVal - Insert Validation Entry                        *
      *  SrInsert - Process Insert Record Entry                       *
      *  SrCmdStr - Set Up Command String                             *
      *  SrCommand - Execute CL Command                               *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Validation list entries maintenance display file.
     FSD000402DFCF   E             WORKSTN SFILE(SD000402S0:RRN0)
     FSDINPVL0  IF   E           K DISK    INFSR(*pssr)                                     MD053314
      *
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     DPSDS            SDS
     D PSExcpType             40     42
      **  Exception number.
     D PSExcpNo               43     46
      ** Job name.
     D PSJobName             244    253
      ** User name.
     D PSUser                254    263
      *
     D IndPointer      S               *   Inz(%ADDR(*IN))

      ** Indicator data structure.
     D Indicators      DS                  BASED(IndPointer)
     D  Exit                  03     03
     D  Refresh               05     05
     D  Insert                09     09
     D  Previous              12     12
     D  RollUp                27     27
     D  SflDsp                30     30
     D  SflClr                31     31
     D  SflEnd                33     33
     D  SflNxtChg             34     34
     D  ErrOptn               48     48
     D  ErrIns                49     49
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Action codes.
     D ACT_Amend       C                   CONST('A')
     D ACT_Delete      C                   CONST('D')
     D ACT_Insert      C                   CONST('I')
     D ACT_Empty       C                   CONST(' ')
     D quote           C                   CONST(x'7D')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D Arr_User        S             50A   DIM(100)
     D Arr_Unique      S             75A   DIM(100)
     D Arr_RRN         S              5S 0 DIM(100)
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Logical conditions.
     D True            C                   *ON
     D False           C                   *OFF
      *
     D FileFormat    E DS                  EXTNAME(SDFACXTD)
      *
     D SflChanged      S              1N
     D UpdateOptn      S              1N
      *
     D WRun            S              1A
     D KID             S             20A
      *
      ** Parameter for ZA0350.
     D PZMsgFile       S             10A   INZ('SDUSRMSG')
     D PZMsgId         S             10A
     D PZMsgData       S             45A
      *
      ** SD000402 parameters.
     D PReturnCode     S              7A
     D PID             S             20A
     D PIDDesc         S             50A
     D PExit           S              1A                                                    MD053140
      *
      ** SD000403 parameters.
     D PUniq           S             75A
     D PInterface      S             20A
     D PUser           S             50A
     D PUserDesc       S             50A
     D PStat           S              1A
     D PRecord         S              1A
     D PReturnVal      S              7A
     D PAUser          S             50A   DIM(100)
     D PAUniq          S             75A   DIM(100)
      *
     D RRN0            S              4  0
     D SflPag          C                   CONST(7)
     D WCtr            S              2  0
     D WLstRrn         S              4  0
     D FstRrn          S              4  0
     D ReadCFlag       S              1A
     D MIMessageF      S             10A
     D LanguageId      S              2A
     D Count           S              5S 0
     D WSearch         S                   LIKE(D0SIDE)
     D NoSearch        S              1A   INZ(*BLANKS)
     D ExitFlag        S              1A
     D DeleteFlag      S              1A
     D MarkAmend       S              1A
     D MarkError       S              1A
     D UpdateDelDesc   S              1A
     D CtrA            S              4S 0
     D Ax              S              4S 0
     D InsFlag         S              1A
     D WithError       S              1A
     D InsUniq         S             75A
     D CountI          S              5S 0
     D CountD          S              5S 0
     D RRNKy1          S              4  0
      *
     D MessageID       S              7A   INZ(*BLANKS)
     D CommandStr      S            200A   INZ(*BLANKS)
     D CommandLen      S             15  5
      *
     D TmStamp         S             14  0
     D wSqlStr         S            200A
     D wSqlStr1        S            200A
      *
      *
      /EJECT
      *****************************************************************
      * MAIN - Processing
      *****************************************************************
      *
      ** Build the subfile.
      *
      ** MD053114 fix, add dynusrprf set to *owner
     C/EXEC SQL
     C+ SET OPTION Commit=*NONE, Naming=*SYS, DynUsrPrf=*Owner,
     C+            CloSqlCsr = *EndMod
     C/END-EXEC
     C                   EXSR      SrBldSfl
      *
      ** Display the screen until F3 is pressed.
     C                   DOW       (Exit = False)
      *
     C                   EVAL      D0OPTN = *BLANKS
      *
      ** Display and process the subfile.
     C                   EXSR      SrDspSfl
      *
      ** Process the subfile.
     C                   EXSR      SrProcess
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBldSfl - Build the Subfile                                 *
      *                                                               *
      *****************************************************************
     C     SrBldSfl      BEGSR
      *
      ** Clear the subfile.
     C                   EXSR      SrClrSfl
      *
      ** Load the subfile.
     C                   EXSR      SrLoadSfl
      *
     C     SrBldSflE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrClrSfl - Clear the Subfile                                 *
      *                                                               *
      *****************************************************************
     C     SrClrSfl      BEGSR
      *
     C/exec SQL
     C+ close FaceCursor
     C/end-exec
      *
      ** Intialise fields.
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      SflClr = *ON
     C                   EVAL      SflEnd = *OFF
     C                   EVAL      ErrOptn = *OFF
     C                   EVAL      NoSearch = ' '
     C                   EVAL      PReturnVal = *BLANKS
      *
     C                   WRITE     SD000402C0
      *
     C                   EVAL      SflClr = *OFF
      *
     C     SrClrSflE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDspSfl - Display the Subfile                               *
      *                                                               *
      *****************************************************************
     C     SrDspSfl      BEGSR
      *
     C                   TIME                    D0TIME
     C                   IF        NoSearch = ' '
      *
      ** Write the message subfile control format.
     C                   WRITE     SD000402C1
     C                   WRITE     SD000402F0
     C                   EXFMT     SD000402C0
     C                   ENDIF
      *
     C     SrDspSflE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrErrDta - Output Error Message With Data                    *
      *                                                               *
      *****************************************************************
     C     SrErrDta      BEGSR
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgId
     C                   PARM      *BLANKS       PZMsgData
      *
     C     SrErrDtaE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrLoadSfl - Load the Subfile                                 *
      *                                                               *
      *****************************************************************
     C     SrLoadSfl     BEGSR
      *
      ** If RRN of the last record loaded in the subfile is greater than zero.
     C                   IF        WLstRrn > *ZEROS
      *
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      D0SFRN  = WLstRrn
      *
     C                   ENDIF
      *
      ** If Position field - ID is not blank, set the pointer to the entered ID data.
     C                   IF        RollUp = *OFF
      *
     C                   EVAL      D0HSID = D0SIDE
     C                   IF        D0SIDE <> *BLANKS
     C                   EVAL      wSqlStr1 = ' and INUSER>=' +
     C                               quote + %trim(D0SIDE) + quote
     C                   ELSE
     C                   EVAL      wSqlStr1 = *BLANKS
     C                   ENDIF
     C
     C                   EVAL      wSqlStr = 'select * from SDFACXTD ' +
     C                                'where ININTF =' + quote + %trim(PID) +
     C                               quote + %trim(wSqlStr1) +
     C                                ' order by ININTF, INUSER'
     C/exec SQL
     C+ prepare FaceCursor from :wSqlStr
     C/end-exec
      *
     C/exec SQL
     C+ declare FaceCursor cursor for FaceCursor
     C/end-exec
      *
     C/exec SQL
     C+ open FaceCursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from FaceCursor into :FileFormat
     C/end-exec
      *
     C                   ENDIF
      *
      ** Reset counter.
     C                   EVAL      WCtr = 0
      *
      ** Load records to subfile.
     C                   DOW       WCtr < SflPag AND
     C                             SQLCODE <> 100
      *
      ** Username
     C                   EVAL      D0USID = INUSER
      *
      ** User Description
     C                   EVAL      D0DESC = INUSRD
      *
      ** User Description Hidden
     C                   EVAL      D0HDES = INUSRD
      *
      ** Unique Key
     C                   EVAL      D0UNIQ = INUNIQ
      *
      ** Increment the subfile
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      D0OPTN = *BLANKS
     C                   EVAL      SflNxtChg = False
      *
     C                   WRITE     SD000402S0
      *
      ** Get the next record
     C/exec SQL
     C+ fetch next from FaceCursor into :FileFormat
     C/end-exec
     C                   ENDDO
      *
      ** If last record, turn on the 'SFLEND' indicator.
     C                   IF        SQLCODE = 100
     C                   EVAL      SflEnd = True
     C                   ENDIF
     C                   EVAL      WLstRrn = D0SFRN
      *
      ** Check if records were written into the subfile.
     C                   IF        WLstRrn <> *ZEROS
     C                   EVAL      SflDsp = *ON
      *
      ** If search has no record to display but there is a record on file.
      ** Message - No records found.
     C                   ELSE
     C                   EVAL      WSearch = D0SIDE
     C                   EVAL      ExitFlag = ' '
      *
     C                   DOW       ExitFlag = ' '
     C                   EVAL      PZMsgId = 'PWD0004'
     C                   EXSR      SrErrDta
     C                   TIME                    D0TIME
     C                   WRITE     SD000402C1
     C                   EXFMT     SD000402R0
     C                   EXSR      SrReset
      *
     C                   SELECT
      *
      ** When F3 is pressed.
     C                   WHEN      Exit = True
     C                   EVAL      ExitFlag = 'Y'
      *
      ** When F5 is pressed.
     C                   WHEN      Refresh = True
     C                   EVAL      ExitFlag = 'Y'
     C                   EVAL      NoSearch = 'Y'
     C                   EVAL      D0SIDE = *BLANKS
      *
     C                   IF        Count > 0
     C                   EVAL      Refresh = False
     C                   ENDIF
      *
      ** When F12 is pressed.
     C                   WHEN      Previous = True
     C                   EVAL      ExitFlag = 'Y'
     C                   EVAL      NoSearch = 'Y'
      *
      ** When F9 is pressed.
     C                   WHEN      Insert = True
     C                   EXSR      SrPrcInsert
     C                   EVAL      Insert = False
      *
      ** When Poistion to is blank.
     C                   WHEN      (D0SIDE = *BLANKS AND
     C                             Count > 0) OR
     C                             (D0SIDE <> WSearch)
     C                   EVAL      ExitFlag = 'Y'
     C                   EVAL      NoSearch = 'Y'
      *
     C                   ENDSL
     C                   ENDDO
     C                   ENDIF
      *
     C     SrLoadSflE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcess - Process the Subfile                              *
      *                                                               *
      *****************************************************************
     C     SrProcess     BEGSR
      *
      ** Reset the fields and the program message queue.
     C                   IF        NoSearch = ' '
     C                   EXSR      SrReset
     C                   ENDIF
      *
     C                   SELECT
      *
      ** When F3 is pressed (Exit).
     C                   WHEN      Exit = True
     C                   EVAL      PExit = 'Y'                                              MD053140
      *
      ** When F5 is pressed (Refresh).
     C                   WHEN      Refresh = True
      *
      ** Reset and build.
     C                   EXSR      SrReset
     C                   EXSR      SrRefresh
     C                   EVAL      PExit = *BLANKS                                          MD053140
      *
      ** When F9 is pressed (Insert).
     C                   WHEN      Insert = True
     C                   EXSR      SrPrcInsert
     C                   EVAL      Insert = False
     C                   EVAL      PExit = *BLANKS                                          MD053140
      *
      ** When F12 is pressed (Previous).
     C                   WHEN      Previous = True
     C                   EVAL      Exit = True
     C                   EVAL      PExit = *BLANKS                                          MD053140
      *
      ** When Page Down is pressed.
     C                   WHEN      Rollup = True
      *
      ** Load the next page.
     C                   EXSR      SrLoadSfl
     C                   EVAL      PExit = *BLANKS                                          MD053140
      *
     C                   WHEN      (D0SIDE <> *BLANKS) OR
     C                             (D0SIDE <> D0HSID)
      *
     C                   EXSR      SrPrSfl
     C                   IF        (ErrOptn = False AND
     C                             MarkError = ' ') OR
     C                             (D0HSID = 'Dummy Delete')
     C                   EXSR      SrBldSfl
     C                   ENDIF
     C                   EVAL      PExit = *BLANKS                                          MD053140
      *
     C                   OTHER
      *
      ** Process the subfile.
     C                   EXSR      SrPrSfl
     C                   EVAL      PExit = *BLANKS                                          MD053140
      *
     C                   ENDSL
      *
     C     SrProcessE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPrSfl - Process the Subfile Functions                      *
      *                                                               *
      *****************************************************************
     C     SrPrSfl       BEGSR
      *
      ** Check for last RRN.
     C                   IF        WLstRrn > *ZEROS
      *
      ** Reset error flag.
     C                   EVAL      ReadCFlag = ' '
     C                   EVAL      DeleteFlag = ' '
     C                   EVAL      MarkAmend = ' '
     C                   EVAL      UpdateDelDesc = ' '
      *
     C                   EVAL      FstRrn = 0
     C                   EVAL      CtrA = 0
     C                   EVAL      Ax = 0
     C                   CLEAR                   Arr_User
     C                   CLEAR                   Arr_Unique
     C                   CLEAR                   Arr_RRN
      *
     C                   READC     SD000402S0
     C                   DOW       NOT %EOF
      *
     C                   SELECT
      *
      ** Option A is selected.
     C                   WHEN      D0OPTN = ACT_Amend
     C                   EVAL      UpdateOptn = True
     C                   IF        DeleteFlag = ' '
     C                   EXSR      SrAmend
      *
     C                   IF        D0HDES <> D0DESC
     C                   EXSR      SrAmendDesc
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      CtrA = CtrA + 1
     C                   EVAL      MarkAmend = 'Y'
     C                   ENDIF
      *
      ** Option D is selected.
     C                   WHEN      D0OPTN = ACT_Delete
      *                                                                                     MD053314
      ** Access validation program for the user's interface.                                MD053314
     C     PID           CHAIN     SDINPVL0                           50                    MD053314
     C                   IF        *IN50 = *off                                             MD053314
     C                   CALL      IPPGMV                                                   MD053314
     C                   PARM                    PID                                        MD053314
     C                   PARM                    D0USID                                     MD053314
     C                   PARM      *BLANKS       RTNCOD            7                        MD053314
     C                   ENDIF                                                              MD053314
      *                                                                                     MD053314
      ** Issue error message when user is attached to a Live Interface                      MD053314
     C                   IF        RTNCOD <> *BLANKS                                        MD053314
      *                                                                                     MD053314
     C                   EVAL      UpdateOptn = False                                       MD053314
      *                                                                                     MD053314
     C                   IF        FstRrn = 0                                               MD053314
     C                   EVAL      FstRrn = RRN0                                            MD053314
     C                   ENDIF                                                              MD053314
      *                                                                                     MD053314
     C                   EVAL      D0SFRN = FstRrn                                          MD053314
     C                   EVAL      SflNxtChg = True                                         MD053314
     C                   EVAL      ErrOptn = True                                           MD053314
     C                   EVAL      MarkError = 'Y'                                          MD053314
     C                   EVAL      PZMsgId = 'PWD0022'                                      MD053314
     C                   EXSR      SrErrDta                                                 MD053314
     C                   EVAL      ReadCFlag = 'Y'                                          MD053314
     C                   WRITE     SD000402C1                                               MD053314
      *                                                                                     MD053314
      ** Otherwise, proceed deletion                                                        MD053314
     C                   ELSE                                                               MD053314
     C                   EVAL      UpdateOptn = True
     C                   EVAL      DeleteFlag = 'Y'
     C                   EXSR      SrDelPop
     C                   ENDIF                                                              MD053314
      *
      ** No Option is selected but the user description has been amended.
     C                   WHEN      D0OPTN = ACT_Empty AND
     C                             D0HDES <> D0DESC
     C                   EVAL      UpdateOptn = True
     C                   EXSR      SrAmendDesc
      *
      ** Option entry is invalid.
     C                   OTHER
      *
     C                   IF        D0OPTN <> *BLANKS
     C                   EVAL      UpdateOptn = False
     C                   ELSE
     C                   EVAL      UpdateOptn = True
     C                   ENDIF
     C                   ENDSL
      *
      ** When Option is Blank or UpdateOptn is set to true
     C                   IF        UpdateOptn = True
      *
      ** When Option A is in between Option D, it will be marked
      ** so that it will be processed in the next ReadC.
     C                   IF        MarkAmend = 'Y'
     C                   EVAL      SflNxtChg = True
     C                   EVAL      MarkAmend = ' '
     C                   ELSE
     C                   EVAL      SflNxtChg = False
     C                   EVAL      D0OPTN = *BLANKS
     C                   ENDIF
      *
     C                   EVAL      ErrOptn = False
     C                   ELSE
      *
      ** When Option is invalid.
     C                   IF        FstRrn = 0
     C                   EVAL      FstRrn = RRN0
     C                   ENDIF
      *
     C                   EVAL      D0SFRN = FstRrn
     C                   EVAL      SflNxtChg = True
     C                   EVAL      ErrOptn = True
     C                   EVAL      MarkError = 'Y'
     C                   IF        D0OPTN <> ACT_Delete                                         xxx
     C                   EVAL      PZMsgId= 'PWD0005'
     C                   EXSR      SrErrDta
     C                   ENDIF                                                                  xxx
     C                   EVAL      ReadCFlag = 'Y'
     C                   WRITE     SD000402C1
     C                   ENDIF
      *
     C                   UPDATE    SD000402S0
      *
     C                   READC     SD000402S0
      *
     C                   ENDDO
      *
      ** If option D has one or more entry, process Deletion.
     C                   IF        Ax > 0
     C                   EXSR      SrDelete
     C                   ENDIF
      *
      ** If option A has one or more entry in between D, process ReadC again.
     C                   IF        CtrA > 0
     C                   READC     SD000402S0
     C                   DOW       NOT %EOF
      *
     C                   SELECT
     C                   WHEN      D0OPTN = ACT_Amend
     C                   EVAL      UpdateOptn = True
     C                   EXSR      SrAmend
     C                   IF        D0HDES <> D0DESC
     C                   EXSR      SrAmendDesc
     C                   ENDIF
      *
     C                   EVAL      SflNxtChg = False
     C                   EVAL      ErrOptn = False
     C                   EVAL      D0OPTN = *BLANKS
      *
     C                   UPDATE    SD000402S0
     C                   ENDSL
      *
     C                   READC     SD000402S0
     C                   ENDDO
     C                   ENDIF
      *
     C                   IF        (D0HSID = 'Dummy Delete') AND
     C                             (PReturnVal = *BLANKS)
     C                   EXSR      SrReset
     C                   ENDIF
      *
      ** Update the description of the selected delete record
      ** if deletion has been cancelled.
     C                   IF        UpdateDelDesc = 'Y'
     C                   EXSR      SrDeleteDesc
     C                   ENDIF
      *
      ** If position to is blank and Rollup is not pressed then set the subfile
      ** to 1st RRN
     C                   IF        Rollup = False AND
     C                             ReadCFlag = *BLANKS AND D0SIDE = *BLANKS
     C                   EVAL      D0SFRN = 1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     SrPrSflE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRefresh - Refresh Subfile                                  *
      *                                                               *
      *****************************************************************
     C     SrRefresh     BEGSR
      *
     C                   EVAL      D0OPTN = *BLANKS
     C                   EVAL      D0SIDE = *BLANKS
     C                   EXSR      SrBldSfl
      *
     C     SrRefreshE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReset - Reset the Fields                                   *
      *                                                               *
      *****************************************************************
     C     SrReset       BEGSR
      *
      ** Clear program queue and message file.
     C                   CALL      'ZA0250'
      *
     C                   EVAL      PZMsgId = *BLANKS
     C                   EVAL      PZMsgData = *BLANKS
      *
     C                   EVAL      ErrOptn = False
     C                   EVAL      MarkError = ' '
      *
     C     SrResetE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDelPop -  Populate Delete Records                          *
      *                                                               *
      *****************************************************************
     C     SrDelPop      BEGSR
      *
      ** Save all records in array for deletion.
     C                   EVAL      Ax = Ax + 1
     C                   CLEAR                   Arr_User(Ax)
     C                   CLEAR                   Arr_Unique(Ax)
     C                   CLEAR                   Arr_RRN(Ax)
     C                   EVAL      Arr_User(Ax) = D0USID
     C                   EVAL      Arr_Unique(Ax) = D0UNIQ
     C                   EVAL      Arr_RRN(Ax) = RRN0
      *
     C     SrDelPopE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDelete -  Delete Validation List Entry                     *
      *                                                               *
      *****************************************************************
     C     SrDelete      BEGSR
      *
     C                   MOVEA     Arr_User      PAUser
     C                   MOVEA     Arr_Unique    PAUniq
      *
     C                   CALL(E)   'SD000403'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      *BLANKS       PUniq
     C                   PARM      *BLANKS       PIDDesc
     C                   PARM      *BLANKS       PInterface
     C                   PARM      *BLANKS       PUser
     C                   PARM      *BLANKS       PUserDesc
     C                   PARM      'D'           PStat
     C                   PARM      'S'           PRecord
     C                   PARM      *BLANKS       PReturnVal
     C                   PARM                    PAUser
     C                   PARM                    PAUniq
      *
     C                   IF        %ERROR
     C                   LEAVESR
     C                   ENDIF
      *
     C                   SELECT
      ** Error occurred in calling SD000404 during delete.
     C                   WHEN      PReturnVal = 'ErrDel'
     C                   EVAL      PZMsgId = 'PWD0008'
     C                   EXSR      SrErrDta
      *
      ** Validation list entry does not exist.
     C                   WHEN      PReturnVal = 'CPF226B'
     C                   EVAL      PZMsgId = 'PWD0009'
     C                   EXSR      SrErrDta
     C                   ENDSL
      *
     C                   IF        PReturnCode = *BLANKS
     C                   EVAL      NoSearch = 'Y'
     C                   EVAL      ExitFlag = 'Y'
     C                   EVAL      D0HSID = 'Dummy Delete'
     C                   ELSE
     C                   EVAL      UpdateDelDesc = 'Y'
     C                   ENDIF
      *
      ** Get record count of SDFACXTD
     C/exec SQL
     C+ select count(*) into :Count
     C+ from SDFACXTD
     C+ where
     C+   ININTF = :PID
     C/end-exec
      *
      ** Get the cursor location for RRN.
     C                   IF        D0HCUR <> 0
     C                   EVAL      D0SFRN = D0HCUR
     C                   ENDIF
      *
     C     SrDeleteE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDeleteDesc - Update Description of Delete Record if        *
      *                 deletion has been cancelled.                  *
      *                                                               *
      *****************************************************************
     C     SrDeleteDesc  BEGSR
      *
     C                   EVAL      Ax = 1
     C                   DOW       Arr_User(Ax) <> *BLANKS
     C                   EVAL      D0UNIQ = Arr_Unique(Ax)
     C                   EVAL      RRNKy1 = Arr_RRN(Ax)
      *
      ** Check if record is deleted. If not deleted, check
      ** description if changed. If so, then update its description.
     C/exec SQL
     C+ select count(*) into :CountD
     C+ from SDFACXTD
     C+ where
     C+   INUNIQ = :D0UNIQ
     C/end-exec
     C                   IF        CountD > 0
     C     RRNKy1        CHAIN     SD000402S0
     C                   IF        %FOUND AND
     C                             D0HDES <> D0DESC
      *
      ** Update description if user cancel the deletion.
     C/exec SQL
     C+ update SDFACXTD set
     C+   INUSRD = :D0DESC
     C+ where
     C+   INUNIQ = :D0UNIQ
     C/end-exec
      *
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      Ax = Ax + 1
     C                   ENDDO
      *
     C     SrDeleteDescE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAmend -  Amend Validation List Entry                       *
      *                                                               *
      *****************************************************************
     C     SrAmend       BEGSR
      *
     C                   CLEAR                   PAUser
     C                   CLEAR                   PAUniq
      *
     C                   CALL(E)   'SD000403'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      D0UNIQ        PUniq
     C                   PARM      *BLANKS       PIDDesc
     C                   PARM      *BLANKS       PInterface
     C                   PARM      D0USID        PUser
     C                   PARM      *BLANKS       PUserDesc
     C                   PARM      'A'           PStat
     C                   PARM      'S'           PRecord
     C                   PARM      *BLANKS       PReturnVal
     C                   PARM                    PAUser
     C                   PARM                    PAUniq
      *
     C                   IF        %ERROR
     C                   LEAVESR
     C                   ENDIF
      *
     C                   SELECT
      ** Error occurred in calling SD000404 during amend.
     C                   WHEN      PReturnVal = 'ErrAmd'
     C                   EVAL      PZMsgId = 'PWD0007'
     C                   EXSR      SrErrDta
      *
      ** Validation list entry does not exist.
     C                   WHEN      PReturnVal = 'CPF226B'
     C                   EVAL      PZMsgId = 'PWD0009'
     C                   EXSR      SrErrDta
     C                   ENDSL
      *
     C                   IF        PReturnCode <> *BLANKS
     C                   LEAVESR
     C                   ENDIF
      *
      ** Get the cursor location for RRN.
     C                   IF        D0HCUR <> 0
     C                   EVAL      D0SFRN = D0HCUR
     C                   ENDIF
      *
     C     SrAmendE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAmendDesc - Amend Description in the Subfile               *
      *                                                               *
      *****************************************************************
     C     SrAmendDesc   BEGSR
      *
     C/exec SQL
     C+ update SDFACXTD set
     C+   INUSRD = :D0DESC
     C+ where
     C+   INUNIQ = :D0UNIQ
     C/end-exec
      *
      ** Get the cursor location for RRN.
     C                   IF        D0HCUR <> 0
     C                   EVAL      D0SFRN = D0HCUR
     C                   ENDIF
      *
     C     SrAmendDescE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPrcInsert - Process Insert a Record Entry                  *
      *                                                               *
      *****************************************************************
     C     SrPrcInsert   BEGSR
      *
      ** Reset Indicators and flags.
     C                   EVAL      InsFlag = ' '
     C                   EVAL      WithError = ' '
     C                   EVAL      InsUniq = *BLANKS
     C                   EVAL      PIDDesc = *BLANKS
     C                   EVAL      ErrIns = False
     C                   EVAL      D0STAT = 'Insert'
     C                   EVAL      D1USID = *BLANKS
     C                   EVAL      D1DESC = *BLANKS
      *
     C                   DOW       InsFlag = ' '
     C                   TIME                    D0TIME
      *
      ** Write the message subfile control format.
     C                   WRITE     SD000402C1
     C                   EXFMT     SD000402R1
     C                   EVAL      ErrIns = False
     C                   EVAL      WithError = ' '
     C                   EXSR      SrReset
      *
     C                   SELECT
      ** When F5 is press (Refresh).
     C                   WHEN      Refresh = True
     C                   CLEAR                   D1USID
     C                   CLEAR                   D1DESC
      *
      ** When F12 is press (Cancel).
     C                   WHEN      Previous = True
     C                   EVAL      InsFlag = 'Y'
      *
      ** When enter is press.
     C                   OTHER
     C                   EXSR      SrInsertVal
      *
     C                   IF        WithError = ' '
     C                   EXSR      SrInsert
     C                   ENDIF
      *
     C                   ENDSL
     C                   ENDDO
      *
     C     SrPrcInsetE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInsertVal - Insert Validation Entry                        *
      *                                                               *
      *****************************************************************
     C     SrInsertVal   BEGSR
      *
      ** User cannot be blank.
     C                   IF        D1USID = *BLANKS
     C                   EVAL      PZMsgId = 'PWD0010'
     C                   EXSR      SrErrDta
     C                   EVAL      ErrIns = True
     C                   EVAL      WithError = 'Y'
     C                   ENDIF
      *
      *
      ** Check user if existing.
     C/exec SQL
     C+ select count(*) into :CountI
     C+ from SDFACXTD
     C+ where
     C+   INUSER = :D1USID and ININTF = :PID
     C/end-exec
      *
      ** User should not exist.
     C                   IF        CountI > 0
     C                   EVAL      PZMsgId = 'PWD0003'
     C                   EXSR      SrErrDta
     C                   EVAL      ErrIns = True
     C                   EVAL      WithError = 'Y'
     C                   ENDIF
      *
     C                   IF        WithError = ' '
     C                   EVAL      InsUniq = %TRIM(PID) + '_' +
     C                               %TRIM(D1USID)
     C                   EVAL      PIDDesc = D1DESC
     C                   EVAL      PInterface = D0INTF
     C                   ENDIF
      *
     C     SrInsertValE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInsert - Process Insert Record Entry                       *
      *                                                               *
      *****************************************************************
     C     SrInsert      BEGSR
      *
     C                   CLEAR                   PAUser
     C                   CLEAR                   PAUniq
      *
     C                   CALL(E)   'SD000403'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      InsUniq       PUniq
     C                   PARM      D0INTF        PIDDesc
     C                   PARM      PID           PInterface
     C                   PARM      D1USID        PUser
     C                   PARM      D1DESC        PUserDesc
     C                   PARM      'I'           PStat
     C                   PARM      'S'           PRecord
     C                   PARM      *BLANKS       PReturnVal
     C                   PARM                    PAUser
     C                   PARM                    PAUniq
      *
     C                   IF        %ERROR
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        PReturnCode = *BLANKS
     C                   EVAL      InsFlag = 'Y'
     C                   EVAL      NoSearch = 'Y'
     C                   EVAL      ExitFlag = 'Y'
     C                   EVAL      D0HSID = 'Dummy Insert'
     C                   ENDIF
      *
     C                   SELECT
      ** Error occurred in calling SD000404 during insert.
     C                   WHEN      PReturnVal = 'ErrIns'
     C                   EVAL      PZMsgId = 'PWD0006'
     C                   EXSR      SrErrDta
      *
      ** Validation list entry does not exist.
     C                   WHEN      PReturnVal = 'CPF226B'
     C                   EVAL      PZMsgId = 'PWD0009'
     C                   EXSR      SrErrDta
      *
      ** Validation list entry already exists.
     C                   WHEN      PReturnVal = 'CPF226A'
     C                   EVAL      PZMsgId = 'PWD0011'
     C                   EXSR      SrErrDta
     C                   ENDSL
      *
     C                   IF        PReturnCode <> *BLANKS AND
     C                             PReturnCode <> 'F12'
     C                   LEAVESR
     C                   ENDIF
      *
      ** Get the cursor location for RRN.
     C                   IF        D0HCUR <> 0
     C                   EVAL      D0SFRN = D0HCUR
     C                   ENDIF
      *
     C     SrInsertE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PReturnCode
     C                   PARM                    PID
     C                   PARM                    PIDDesc
     C                   PARM                    PExit
      *
      ** Populate Interface ID
     C                   EVAL      D0INTF = %TRIM(PID) + ' - ' + %TRIM(PIDDesc)
      *
      ** Populate workstation ID.
     C                   EVAL      D0WID = PsJobName
      *
      ** Populate user.
     C                   EVAL      D0USER = PsUser
      *
     C                   TIME                    TmStamp
     C                   MOVE      TmStamp       D0MRDT
      *
      ** Initialise subfile program queue and message file.
     C                   EVAL      D1PGMQ = '*'
     C                   EVAL      *IN32 = *ON
      *
      ** Get the Multi-Language of the User
     C/exec SQL
     C+ select
     C+   MULT
     C+ into
     C+   :LanguageId
     C+ from MUSERDD
     C+ where
     C+     USRP = 'MIDAS'
     C/end-exec
      *
     C                   IF        SQLCODE = 0
     C                   IF        LanguageId = ' '
     C                   EVAL      MIMessageF = 'GBSDUSRMSG'
     C                   ELSE
     C                   EVAL      MIMessageF = LanguageId + 'SDUSRMSG'
     C                   ENDIF
      *
     C                   EXSR      SrCmdStr
     C                   ENDIF
      *
     C     INZSRE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCmdStr - Set Up Command String                             *
      *                                                               *
      *****************************************************************
     C     SrCmdStr      BEGSR
      *
     C                   EVAL      CommandStr = 'OVRMSGF MSGF(SDUSRMSG) ' +
     C                             'TOMSGF(' + MIMessageF +')'
     C                   EVAL      CommandLen = 41
     C                   EXSR      SrCommand
      *
     C     SrCmdStrE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCommand - Execute CL Command                               *
      *                                                               *
      *****************************************************************
     C     SrCommand     BEGSR
      *
     C                   EVAL      MessageID = *BLANKS
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    CommandStr
     C                   PARM                    CommandLen
     C                   IF        %ERROR
     C                   EVAL      MessageID = PSExcpType+
     C                             PSExcpNo
     C                   ENDIF
      *
     C     SrCommandE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically If a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
