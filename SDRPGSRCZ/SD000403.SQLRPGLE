      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Passwords Maintenance')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000403 - Midas SD Passwords Maintenance                    *
      *                                                               *
      *  Function:  This program displays the Password used by Midas  *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD053487           Date 28May19               *
      *  Prev Amend No. MD053289           Date 15Apr19               *
      *                 CSD101 *CREATE     Date 07Dec18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053487 - Audit Report should be available for Interface    *
      *             Password Maintenance                              *
      *  MD053289 - Password double capture process is missing in the *
      *             Password Maintenance.                             *
      *  CSD101 - Password Encryption                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      *  SrDspSfl - Display the Subfile                               *
      *  SrBldSfl - Build the Subfile                                 *
      *  SrClrSfl - Clear the Subfile                                 *
      *  SrLoadSfl - Load the Subfile                                 *
      *  SrDelProc - Process Deletion                                 *
      *  SrErrDta - Output Error Message With Data                    *
      *  SrProcess - Process the Subfile                              *
      *  SrValidation - Validation Password Entry                     *
      *  SrPrRec - Process the Record                                 *
      *  SrRefresh - Refresh Entries                                  *
      *  SrReset - Reset the Fields                                   *
      *  SrVLDL - Retrieve Password from Validation List Object       *
      *  SrDelete - Delete a Validation List Entry                    *
      *  SrAmend - Amend a Validation List Entry                      *
      *  SrInsert - Insert a Validation List Entry                    *
      *  SrGetTmSt1 - Retrieve Timestamp 1                            *
      *  SrGetTmSt2 - Retrieve Timestamp 2                            *
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
     FSD000403DFCF   E             WORKSTN SFILE(SD000403S0:RRN0)
      *
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     DPSDS            SDS
     D PSExcpType             40     42
      ** Exception number.
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
     D  Cancel                12     12
     D  Rollup                27     27
     D  SflDsp                30     30
     D  SflClr                31     31
     D  SflEnd                33     33
     D  SflNxtChg             34     34
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Action codes.
     D Act_Amend       C                   CONST('A')
     D Act_Delete      C                   CONST('D')
     D Act_Insert      C                   CONST('I')

      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
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
     D VLDL            DS                  ALIGN
     D   ValidList                   10A   INZ('SDINTFVL')
     D   Library                     10A   INZ('xxDMLIB')
      *
     D FileFormat    E DS                  EXTNAME(SDFACXTD)
      *
     D WRun            S              1A
     D KID             S             20A
      *
      ** Parameter for ZA0350.
     D PZMsgFile       S             10A   INZ('SDUSRMSG')
     D PZMsgId         S             10A
     D PZMsgData       S             45A
      *
      ** SD000404 parameters.
     D PReturnVal      S              7A
     D PAction         S              1A
     D PValidList      S             10A
     D PLibrary        S             10A
     D PIDName         S            100A
     D P1Pass          S                   LIKE(D0PASS)
     D P1Descr         S           1000A
      *
      ** ZAGENTS parameters.
     D PTimeStamp      S               Z
      *
      ** Entry parameters.
     D PReturnCode     S              7A
     D PUniq           S             75A
     D PIDDesc         S             50A
     D PInterface      S             20A
     D PUser           S             50A
     D PUserDesc       S             50A
     D PStat           S              1A
     D PRecord         S              1A
     D PAUser          S             50A   DIM(100)
     D PAUniq          S             75A   DIM(100)
      *
     D RRN0            S              4  0
     D WCtr            S              2  0
     D MIMessageF      S             10A
     D LanguageId      S              2A
     D Count           S              5S 0
     D ExitFlag        S              1A
     D ExitDel         S              1A
     D WLstRrn         S              4S 0
     D Ax              S              4S 0
     D WithError       S              1A
     D WTmSt1          S               Z
     D WTmSt2          S               Z
      *
     D MessageID       S              7A   INZ(*BLANKS)
     D CommandStr      S            200A   INZ(*BLANKS)
     D CommandLen      S             15  5
     D TmStamp         S             14  0
     D wSqlStr         S            200A
     D wSqlStr1        S            200A
     D PChangeType     S              1A                                                    MD053487
     D PLUser          S             10A                                                    MD053487
      *
      /EJECT
      *****************************************************************
      * MAIN - Processing
      *****************************************************************
      *
      ** Display the screen until Valid Entry is pressed.
     C                   DOW       Exitflag = ' '
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
     C     SrDspSfl      BEGSR
      *
     C                   TIME                    D0TIME
      *
      ** Display record format if not delete.
     C                   IF        PStat <> Act_Delete
      *
      ** Write the message subfile control format.
     C                   WRITE     SD000403C1
     C                   WRITE     SD000403F0
     C                   EXFMT     SD000403R0
      *
      ** Display subfile format to list records for deletion
      ** and single record.
     C                   ELSEIF    (PStat = Act_Delete) AND
     C                             (PRecord = 'S')
      *
     C                   EXSR      SrBldSfl
     C                   EXSR      SrDelProc
      *
      ** No diplay needed, immediate delete of password in VLDL
      ** for multiple record.
     C                   ELSEIF    (PStat = Act_Delete) AND
     C                             (PRecord = 'M')
     C                   EXSR      SrDelete
     C                   ENDIF
      *
     C     SrDspSflE     ENDSR
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
      ** Intialise fields.
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      SflClr = *ON
     C                   EVAL      SflEnd = *OFF
      *
     C                   WRITE     SD000403C0
      *
     C                   EVAL      SflClr = *OFF
      *
     C     SrClrSflE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrLoadSfl - Load the Subfile                                 *
      *                                                               *
      *****************************************************************
     C     SrLoadSfl     BEGSR
      *
     C                   EVAL      Ax = 1
     C                   DOW       PAUser(Ax) <> *BLANKS
     C                   EVAL      D0USD1 = PAUser(Ax)
     C                   EVAL      D0UNQ1 = PAUniq(Ax)
     C                   EVAL      Ax = Ax + 1
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      D0SFRN = RRN0
      *
     C                   WRITE     SD000403S0
     C                   ENDDO
      *
     C                   EVAL      WLstRrn = D0SFRN
      *
      ** Check if records were written into the subfile.
     C                   IF        WLstRrn <> *ZEROS
     C                   EVAL      SflDsp = *ON
     C                   EVAL      D0SFRN = 1
     C                   ENDIF
      *
     C                   IF        PAUser(Ax)= *BLANKS
     C                   EVAL      SflEnd = True
     C                   ENDIF
      *
     C     SrLoadSfE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDelProc - Process Deletion                                 *
      *                                                               *
      *****************************************************************
     C     SrDelProc     BEGSR
      *
     C                   EVAL      ExitDel = ' '
     C                   DOW       ExitDel = ' '
     C                   WRITE     SD000403C1
     C                   WRITE     SD000403F1
     C                   EXFMT     SD000403C0
     C                   EXSR      SrReset
      *
     C                   SELECT
      ** When F12 is press (Cancel).
     C                   WHEN      Cancel = True
     C                   EVAL      ExitDel = 'Y'
      *
      ** When Rollup is press.
     C                   WHEN      Rollup = True
      *
      ** When Enter is press.
     C                   OTHER
     C                   EXSR      SrDelete
     C                   EVAL      ExitDel = 'Y'
      *
     C                   ENDSL
     C                   ENDDO
      *
     C     SrDelProcE    ENDSR
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
      *  SrProcess - Process the Subfile                              *
      *                                                               *
      *****************************************************************
     C     SrProcess     BEGSR
      *
      ** Reset the fields and the program message queue.
     C                   EXSR      SrReset
      *
     C                   SELECT
      *
      ** When F5 is pressed (Refresh).
     C                   WHEN      Refresh = True
     C                   EXSR      SrRefresh
      *
      ** When F12 is pressed (Cancel).
     C                   WHEN      Cancel = True
     C                   EVAL      ExitFlag = 'Y'
     C                   EVAL      PReturnCode = 'F12'
      *
     C                   OTHER
      *
      ** Validation.
     C                   EXSR      SrValidation
      *
      ** Process the record.
     C                   EXSR      SrPrRec
      *
     C                   ENDSL
      *
     C     SrProcessE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidation - Validate Password Entry                       *
      *                                                               *
      *****************************************************************
     C     SrValidation  BEGSR
      *
      ** No validation for Delete
     C                   IF        PStat <> Act_Delete
      *
      ** Password cannot be blank.
      ** Insert and Amend.
     C                   SELECT
     C                   WHEN      D0PASS = *BLANKS
     C                   EVAL      PZMsgId = 'PWD0001'
     C                   EXSR      SrErrDta
     C                   EVAL      WithError = 'Y'
      *                                                                                     MD053289
      ** Re-enter Password.                                                                 MD053289
     C                   WHEN      D0PASS <> D0RPAS                                         MD053289
     C                   EVAL      PZMsgId = 'PWD0020'                                      MD053289
     C                   EXSR      SrErrDta                                                 MD053289
     C                   EVAL      WithError = 'Y'                                          MD053289
      *
      ** Amend.
     C                   WHEN      PStat = Act_Amend
      *
      ** Retrieve Password from Validation List Object
     C                   EXSR      SRVLDL
      *
      ** Password cannot be the same as old password.
     C                   IF        D0PASS = P1Pass
     C                   EVAL      PZMsgId = 'PWD0002'
     C                   EXSR      SrErrDta
     C                   EVAL      WithError = 'Y'
     C                   ELSE
      *
      ** Get the Timestamp if still the same.
     C                   EXSR      SrGetTmst2
      *
      ** Record has been updated by another workstation.
     C                   IF        WTmSt1 <> WTmSt2
     C                   EVAL      PZMsgId = 'PWD0017'
     C                   EXSR      SrErrDta
     C                   EVAL      WithError = 'Y'
     C                   ELSE
     C                   EVAL      WithError = ' '
     C                   ENDIF
     C                   ENDIF
      *
      ** No Error.
      ** Insert.
     C                   OTHER
     C                   EVAL      WithError = ' '
      *
     C                   ENDSL
     C                   ENDIF
      *
     C     SrValidationE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrRec - Process the record                                 *
      *                                                               *
      *****************************************************************
     C     SrPrRec       BEGSR
      *
      ** If no error proceed processing
     C                   IF        WithError = ' '
      *
     C                   SELECT
      *
     C                   WHEN      PStat = Act_Amend
     C                   EXSR      SrAmend
      *
     C                   WHEN      PStat = Act_Insert
     C                   EXSR      SrInsert
      *
     C                   ENDSL
      *
     C                   EVAL      ExitFlag = 'Y'
      *
     C                   ENDIF
      *
     C     SrPrRecE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRefresh - Refresh Record                                   *
      *                                                               *
      *****************************************************************
     C     SrRefresh     BEGSR
      *
     C                   EXSR      SrReset
     C                   EVAL      D0PASS = *BLANKS
     C                   EVAL      D0RPAS = *BLANKS                                         MD053289
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
     C                   EVAL      WithError = ' '
      *
     C     SrResetE      ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVLDL - Retrieve Password from Validation List Object       *
      *                                                               *
      *****************************************************************
     C     SrVLDL        BEGSR
      *
     C                   EVAL      PIDName = PUniq
      *
     C                   CALL(E)   'SD000404'
     C                   PARM      *BLANKS       PReturnVal
     C                   PARM      'F'           PAction
     C                   PARM      ValidList     PValidList
     C                   PARM      Library       PLibrary
     C                   PARM                    PIDName
     C                   PARM      *BLANKS       P1Pass
     C                   PARM      *BLANKS       P1Descr
      *
     C     SrVLDLE       ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDelete -  Delete Validation List Entry                     *
      *                                                               *
      *****************************************************************
     C     SrDelete      BEGSR
      *
      ** If Single Record, delete from file and VLDL object
     C                   IF        PRecord = 'S'
      *
     C                   EVAL      Ax = 1
     C                   DOW       PAUser(Ax) <> *BLANKS
     C                   EVAL      D0UNQ1 = PAUniq(Ax)
     C                   EVAL      Ax = Ax + 1
     C/exec SQL
     C+ delete from SDFACXTD
     C+ where
     C+   INUNIQ = :D0UNQ1
     C/end-exec
      *
     C                   EVAL      PIDName = D0UNQ1
     C                   CALL(E)   'SD000404'
     C                   PARM      *BLANKS       PReturnVal
     C                   PARM      'D'           PAction
     C                   PARM      ValidList     PValidList
     C                   PARM      Library       PLibrary
     C                   PARM                    PIDName
     C                   PARM      *BLANKS       P1Pass
     C                   PARM      *BLANKS       P1Descr
     C                   ENDDO
     C                   ENDIF
      *
      ** If Multiple Record, delete from VLDL object
     C                   IF        PRecord = 'M'
     C                   EVAL      D0UNQ1 = PAUniq(1)
     C                   EVAL      PIDName = D0UNQ1
     C                   CALL(E)   'SD000404'
     C                   PARM      *BLANKS       PReturnVal
     C                   PARM      'D'           PAction
     C                   PARM      ValidList     PValidList
     C                   PARM      Library       PLibrary
     C                   PARM                    PIDName
     C                   PARM      *BLANKS       P1Pass
     C                   PARM      *BLANKS       P1Descr
     C                   ENDIF
      *
     C                   IF        %ERROR
     C                   EVAL      PReturnVal = 'ErrDel'
     C                   LEAVESR
     C                   ENDIF
      *
     C     SrDeleteE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAmend -  Amend Validation List Entry                       *
      *                                                               *
      *****************************************************************
     C     SrAmend       BEGSR
      *
      ** Generate TimeStamp
     C                   CALL      'ZAGENTS'
     C                   PARM                    PTimeStamp
     C                   EVAL      PChangeType = 'A'                                        MD053487
      ** Get User Name                                                                      MD053487
     C                   CALL      'SFC000026'                                              MD053487
     C                   PARM      *BLANKS       PLUSER                                     MD053487
      *
     C/exec SQL
     C+ update SDFACXTD set
     C+   INTMST = :PTimeStamp,                                                             MD053487
     C+   INTYLC = :PChangeType,                                                            MD053487
     C+   INLCUS = :PLUSER                                                                  MD053487
     C+ where
     C+   INUNIQ = :PUniq
     C/end-exec
      *
     C                   EVAL      PIDName = PUniq
     C                   EVAL      P1Pass  = D0PASS
      *
     C                   CALL(E)   'SD000404'
     C                   PARM      *BLANKS       PReturnVal
     C                   PARM      'M'           PAction
     C                   PARM      ValidList     PValidList
     C                   PARM      Library       PLibrary
     C                   PARM                    PIDName
     C                   PARM                    P1Pass
     C                   PARM                    P1Descr
      *
     C                   IF        %ERROR
     C                   EVAL      PReturnVal = 'ErrAmd'
     C                   LEAVESR
     C                   ENDIF
      *
     C     SrAmendE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInsert - Insert Validation List Entry                      *
      *                                                               *
      *****************************************************************
     C     SrInsert      BEGSR
      *
     C                   EVAL      PIDName = PUniq
     C                   EVAL      P1Pass  = D0PASS
      *
      ** If Single Record, insert to file and VLDL object
     C                   IF        PRecord = 'S'
      *
      ** Generate TimeStamp
     C                   CALL      'ZAGENTS'
     C                   PARM                    PTimeStamp
      *                                                                                     MD053487
     C                   EVAL      PChangeType = 'I'                                        MD053487
      ** Get User Name                                                                      MD053487
     C                   CALL      'SFC000026'                                              MD053487
     C                   PARM      *BLANKS       PLUSER                                     MD053487
      *
     C/exec SQL
     C+ insert into SDFACXTD
     C+ (
     C+   ININTF
     C+  ,INUSER
     C+  ,INUNIQ
     C+  ,INUSRD
     C+  ,INTMST
     C+  ,INTYLC                                                                            MD053487
     C+  ,INLCUS                                                                            MD053487
     C+ )
     C+ values
     C+ (
     C+   :PInterface
     C+  ,:PUser
     C+  ,:PUniq
     C+  ,:PUserDesc
     C+  ,:PTimeStamp
     C+  ,:PChangeType                                                                      MD053487
     C+  ,:PLUser                                                                           MD053487
     C+ )
     C/end-exec
      *
     C                   CALL(E)   'SD000404'
     C                   PARM      *BLANKS       PReturnVal
     C                   PARM      'A'           PAction
     C                   PARM      ValidList     PValidList
     C                   PARM      Library       PLibrary
     C                   PARM                    PIDName
     C                   PARM                    P1Pass
     C                   PARM                    P1Descr
     C                   ENDIF
      *
      ** If Multiple Record, insert to VLDL object
     C                   IF        PRecord = 'M'
     C                   CALL(E)   'SD000404'
     C                   PARM      *BLANKS       PReturnVal
     C                   PARM      'A'           PAction
     C                   PARM      ValidList     PValidList
     C                   PARM      Library       PLibrary
     C                   PARM                    PIDName
     C                   PARM                    P1Pass
     C                   PARM                    P1Descr
     C                   ENDIF
      *
     C                   IF        %ERROR
     C                   EVAL      PReturnVal = 'ErrIns'
     C                   LEAVESR
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
     C                   PARM                    PUniq
     C                   PARM                    PIDDesc
     C                   PARM                    PInterface
     C                   PARM                    PUser
     C                   PARM                    PUserDesc
     C                   PARM                    PStat
     C                   PARM                    PRecord
     C                   PARM                    PReturnVal
     C                   PARM                    PAUser
     C                   PARM                    PAUniq
      *
      ** Populate Unique Key
     c                   EVAL      D0UNIQ = PUniq
      *
      ** Populate Status
     C                   SELECT
     C                   WHEN      PStat = Act_Amend
     C                   EVAL      D0STAT = 'AMEND'
     C                   EVAL      *IN35 = *ON                                              MD053289
     C                   EXSR      SrGetTmSt1
     C                   WHEN      PStat = Act_Delete
     C                   EVAL      D0STAT = 'DELETE'
     C                   WHEN      PStat = Act_Insert
     C                   EVAL      D0STAT = 'INSERT'
     C                   EVAL      *IN35 = *OFF                                             MD053289
     C                   ENDSL
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
     C                   EXSR      SRCmdStr
     C                   ENDIF
      *
     C                   IN        SDSTAT
     C                   EVAL      Library = %REPLACE(LIBR:Library:1:2)
      *
     C     INZSRE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetTmSt1 - Retrieve Timestamp 1                            *
      *                                                               *
      *****************************************************************
     C     SrGetTmSt1    BEGSR
      *
     C/exec SQL
     C+ select INTMST into :WTmSt1
     C+ from SDFACXTD
     C+ where
     C+   INUNIQ = :PUniq
     C/end-exec
      *
     C     SrGetTmSt1E   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetTmSt2 - Retrieve Timestamp 2                            *
      *                                                               *
      *****************************************************************
     C     SrGetTmSt2    BEGSR
      *
     C/exec SQL
     C+ select INTMST into :WTmSt2
     C+ from SDFACXTD
     C+ where
     C+   INUNIQ = :PUniq
     C/end-exec
      *
     C     SrGetTmSt2E   ENDSR
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
