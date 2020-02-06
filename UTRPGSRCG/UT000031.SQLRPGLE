      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT Validation List entries maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000031 - Midas UT Validation List Entries Maintenance      *
      *                                                               *
      *  Function:  This program display the entries contained        *
      *             within a given validation list                    *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. CUT007 *REWRITE    Date 02Dec10               *
      *                 BUG28082           Date 31Aug10               *
      *                 BUG27989*CREATE    Date 08Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUT007 - Make utility file-driven.                           *
      *  BUG28082 - Unable to display the correct information in the  *
      *             screen. (Recompile)                               *
      *  BUG27989 - HATS should run with/without LDAP                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      *  SRBldSfl - Build the Subfile                                 *
      *  SrClrOutFile - Clear Output File                             *
      *  SRClrSfl - Clear the Subfile                                 *
      *  SrDelete - Delete a Validation List Entry                    *
      *  SRDspSfl - Display the Subfile                               *
      *  SRErrDta - Output Error Message With Data                    *
      *  SrIn
      *  SRloadSfl - Load the Subfile                                 *
      *  SrModify - Modify Validation List Entry                      *
      *  SRProcess - Process the Subfile                              *
      *  SRPrSfl - Process the Subfile Functions                      *
      *  SRRefresh - Refresh Entries                                  *
      *  SRReset - Reset the Fields                                   *
      *  SRResetInd  - Reset Indicators                               *
      *  SrCommand - Execute CL Command                               *
      *  SrView - View a Validation List Entry                        *
      *  IntEntField - Initialization of fields                       *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      * Validation list entries maintenance display file.
     FUT000031DFCF   E             WORKSTN SFILE(UT000031S0:RRN0)
     F                                     INFDS(SCRDS)
      *
      * Validation list entries retrieval file.
     FUTVLLEPD  UF   E           K DISK    INFSR(*PSSR)
      *
      *
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     DPSDS            SDS
     D PSExcpType             40     42
      *  Exception number.
     D PSExcpNo               43     46
      * Job name.
     D PSJobName             244    253
      * User name.
     D PSUser                254    263
      *
     D IndPointer      S               *   Inz(%ADDR(*IN))

      * Indicator data structure.
     D Indicators      DS                  BASED(IndPointer)
     D  Exit                  03     03
     D  Refresh               05     05
     D  AddRecord             09     09
     D  Confirm               10     10
     D  Previous              12     12
     D  DspEntFld             22     22
     D  NoData                20     20
     D  RollUp                27     27
     D  SflDsp                30     30
     D  SflClr                31     31
     D  SflEnd                33     33
     D  ActnErr               35     35
     D  ErrOptn               48     48
     D  ErrUser               49     49
     D  ErrPas1               50     50
     D  ErrPas2               51     51
     D  ErrPas3               52     52
     D  SetCursor             55     55

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      * Action codes.
     D Insert          C                   CONST('A')
     D Modify          C                   CONST('M')
     D Reset           C                   CONST('R')
     D Delete          C                   CONST('D')
     D Find            C                   CONST('F')
      *
     D ACT_Modify      C                   CONST('A')
     D ACT_View        C                   CONST('E')
     D ACT_Delete      C                   CONST('D')

      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      * Logical conditions.
     D True            C                   *ON
     D False           C                   *OFF
      *
      * Default ID / password / description length.
     D ID_LEN          C                   100
     D PWD_LEN         C                   100
     D DSC_LEN         C                    50
      * Default column text.
     D ID_TX           C                   'Validation List ID. . . . . .:'
      *
     D VLDL            DS                  ALIGN
     D   ValidList                   10A
     D   Library                     10A
      *
     D VLDLDS        E DS                  EXTNAME(UTVLDJW0)
      *
     D SCRDS           DS
     D  CURSOR               370    371B 0
      *
     D SflChanged      S              1N
     D ErrorExist      S              1N
     D UpdateOptn      S              1N
      *
     D ReturnVal       S             10I 0
     D WRun            S              1A
     D KID             S            100A
      *
      * Entry parameters.
     D PValidList      S             10A
     D PLibrary        S             10A
      *
      * Parameter for ZA0350.
     D PZMsgFile       S             10A   INZ('UTMSGF')
     D PZMsgId         S             10A
     D PZMsgData       S             45A
      *
     D RRN0            S              4  0
     D SflPag          C                   CONST(14)
     D WCtr            S              2  0
     D WLstRrn         S              4  0
     D EndPGMFlag      S              1A
     D WSelDESC        S              1A
     D DisplayLen      S              3  0
      *
      * UT00032 parameters.
     D PReturnCode     S              7A
     D PAction         S              1A
     D PID             S            100A
     D PPass1          S            600A
     D PPass2          S            600A
     D PDescr          S           1000A
      *
     D MessageID       S              7A   INZ(*BLANKS)
     D CommandStr      S            200A   INZ(*BLANKS)
      *
     D UserErrMsg      S             10A
     D Pas1ErrMsg      S             10A
     D Pas2ErrMsg      S             10A
     D Pas3ErrMsg      S             10A
      *
     D CommandLen      S             15  5
     D TmStamp         S             14  0
      *
     D IDLen           S             10I 0
     D PwdLen          S             10I 0
     D DscLen          S             10I 0
     D ID              S            100A
     D Pwd1            S            600A
     D Desc            S           1000A
     D ProcFlg         S              1N
      *
     D IDEntFldID      S            100A   dim(9999)
     D IDEntFldDs      S           1000A   dim(9999)
     D IDTxDot         S             30A   inz('. . . . . . . . . . . . . . .:')
      *
      /EJECT
      *****************************************************************
      * MAIN - Processing
      *****************************************************************
      *
     C                   EXSR      SrCheckOBJ
     C                   IF        MessageID <> *BLANKS
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      * Build the subfile.
      *
     C                   EXSR      SRBldSfl
      *
      * Display the screen until F12 or F3 is pressed.
     C                   DOW       (Exit = False) AND
     C                             (EndPGMFlag = False)
      *
     C                   EVAL      D0OPTN = *BLANKS
     C                   EVAL      SflChanged = False
     C                   EXSR      SRResetInd
      *
      * Get the ID Data column header.
     C/exec SQL
     C+ select
     C+   *
     C+ into
     C+   :VLDLDS
     C+ from UTVLDJW0
     C+ where
     C+     VLVLDL =  :PValidList
     C+ and VLDEL  <> 'Y'
     C/end-exec
     C                   IF        SQLCODE = 0
      * Get the ID Data column heading.
     C                   EVAL      D0IDTX = VLIDTX
     C*                  EVAL      D3IDTX = VLIDTX
     C                   Eval      D3IDTX = %Subst(VLIDTX:1:%Len(%Trim(VLIDTX)))
     C                                      + %Subst(IDTxDot:%Len(%Trim(VLIDTX))
     C                                      + 1 :(30 - %Len(%Trim(VLIDTX))))
     C                   ELSE
      * Default ID Data column heading.
     C                   EVAL      D0IDTX = ID_TX
     C                   EVAL      D3IDTX = ID_TX
     C                   ENDIF
      *
      * Display and process the subfile.
     C                   EXSR      SRDspSfl
      *
      * Process the subfile.
     C                   EXSR      SRProcess
      *
      * Rebuild subfile.
     C                   IF        (SflChanged)
     C                   EXSR      SRRefresh
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Build the Subfile                                 *
      *                                                               *
      *  Called by: MAIN Processing, SRProcess                        *
      *                                                               *
      *  Calls: SRClrSfl, SRLoadSfl, EXTERNAL/UT000032                *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
      *
     C                   EXSR      SrClrOutFile
     C                   CLOSE     UTVLLEPD
      *
     C                   CALL      'UT000032'
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   OPEN      UTVLLEPD
      *
      * Clear the subfile.
     C                   EXSR      SRClrSfl
      *
      * Load the subfile.
     C                   EXSR      SRLoadSfl
      *
     C     SRBldSflE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrClrOutFile - Clear Output File                             *
      *                                                               *
      *  Called by: SrLoadSfl                                         *
      *                                                               *
      *  Calls: *None                                                 *
      *                                                               *
      *****************************************************************
     C     SrClrOutFile  BEGSR
      *
      * Delete all entries on the temporary file.
     C     *LOVAL        SETLL     UTVLLED0
     C                   READ      UTVLLEPD
     C                   DOW       NOT(%EOF(UTVLLEPD))
     C                   DELETE    UTVLLEPD
     C                   READ      UTVLLEPD
     C                   ENDDO
      *
     C     SrClrOutFileE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrSfl - Clear the Subfile                                 *
      *                                                               *
      *  Called by: SRBldSfl                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRClrSfl      BEGSR
      *
     C     *LOVAL        SETLL     UTVLLEPD
      *
      * Intialise fields.
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      *IN20  = *OFF
     C                   EVAL      ActnErr = *OFF
     C                   EVAL      SflClr = *ON
     C                   EVAL      SflEnd = *OFF
      *
     C                   WRITE     UT000031C0
      *
     C                   EVAL      SflClr = *OFF
      *
     C     SRClrSflE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDelete - Delete a Validation List Entry                    *
      *                                                               *
      *  Called by: SRPrSfl                                           *
      *                                                               *
      *  Calls: EXTERNAL/UT000033                                     *
      *                                                               *
      *****************************************************************
     C     SRDelete      BEGSR
      *
     C                   EXSR      SrReset
     C                   EVAL      Previous = False
      *
      * Check if ID exists.
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PReturnCode
     C                   PARM      Find          PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      D0HEID        PID
     C                   PARM      *BLANKS       PPass1
     C                   PARM      *BLANKS       PPass2
     C                   PARM      *BLANKS       PDescr
      *
     C                   IF        PReturnCode <> *BLANKS
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      D3IDTA = PID
     C                   EVAL      D3DDTA = PDescr
     C                   EVAL      D3ACTI = '         DELETE'
     C                   EVAL      D3LABL = 'Current data will be deleted -
     C                             press F10 to confirm ...'
      *
     C                   EXSR      SrResetInd
     C                   DOW       (Previous = False)
     C                   WRITE     UT000031C1
     C                   EXFMT     UT000031R2
      *
     C                   IF        (Confirm = True)
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PReturnCode
     C                   PARM      Delete        PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      D0HEID        PID
     C                   PARM      *BLANKS       PPass1
     C                   PARM      *BLANKS       PPass2
     C                   PARM      *BLANKS       PDescr
      *
     C                   IF        (PReturnCode = *BLANKS)
     C                   EXSR      SrReset
     C                   EVAL      PZMsgId= 'USR9010'
     C                   EXSR      SRErrDta
     C                   EVAL      SflChanged = True
     C                   LEAVESR
     C                   ENDIF
      *
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     SRDeleteE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspSfl - Display the Subfile                               *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRDspSfl      BEGSR
      *
     C                   TIME                    D0TIME
      *
      * Write the message subfile control format.
     C                   WRITE     UT000031C1
     C                   WRITE     UT000031F0
     C                   EXFMT     UT000031C0
      *
     C     SRDspSflE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrDta - Output Error Message With Data                    *
      *                                                               *
      *  Called by: Various subroutines                               *
      *                                                               *
      *  Calls: EXTERNAL/ZA0350                                       *
      *                                                               *
      *****************************************************************
     C     SRErrDta      BEGSR
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgId
     C                   PARM      *BLANKS       PZMsgData
      *
     C     SRErrDtaE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInsert - Insert a Validation List Entry                    *
      *                                                               *
      *  Called by: SRPrSfl                                           *
      *                                                               *
      *  Calls: EXTERNAL/UT000033                                     *
      *                                                               *
      *****************************************************************
     C     SRInsert      BEGSR
      *
     C                   EXSR      SrReset
      *
      * Check validation list exists in UTVLD* and get ID / password / desc length.
     C/exec SQL
     C+ select
     C+   *
     C+ into
     C+   :VLDLDS
     C+ from UTVLDJW0
     C+ where
     C+     VLVLDL =  :PValidList
     C+ and VLDEL  <> 'Y'
     C/end-exec
     C                   IF        SQLCODE = 0
      * Get the ID / password / description length.
     C                   EVAL      IDLen  = VLIDLE
     C                   EVAL      PwdLen = VLENLE
     C                   EVAL      DscLen = VLDTLE
     C                   ELSE
      * Default ID / password / description length.
     C                   EVAL      IDLen  = ID_LEN
     C                   EVAL      PwdLen = PWD_LEN
     C                   EVAL      DscLen = DSC_LEN
     C                   ENDIF
      *
      * Validation list entries maintenance screen (Insert).
     C                   CALL      'UT000034'
     C                   PARM      'I'           PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM                    IDLen
     C                   PARM                    PwdLen
     C                   PARM                    DscLen
     C                   PARM                    D0IDTX
     C                   PARM      *Blanks       ID
     C                   PARM      *Blanks       Pwd1
     C                   PARM      *Blanks       Desc
     C                   PARM      *Off          ProcFlg
      *
     C                   IF        ProcFlg = *On
      *
      * No error (ID successfully insert must be displayed).
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PReturnCode
     C                   PARM      Insert        PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      ID            PID
     C                   PARM      Pwd1          PPass1
     C                   PARM      Pwd1          PPass2
     C                   PARM      Desc          PDescr
      *
     C                   IF        (PReturnCode = *BLANKS)
     C                   EXSR      SrReset
     C                   EVAL      PZMsgId= 'USR9009'
     C                   EXSR      SRErrDta
     C                   EVAL      SflChanged = True
     C                   EVAL      D1IDTA = *BLANKS
     C                   EVAL      D1EDTA = *BLANKS
     C                   EVAL      D1EDTC = *BLANKS
     C                   EVAL      D1DDTA = *BLANKS
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     SRInsertE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRloadSfl - Load the Subfile                                 *
      *                                                               *
      *  Called by: SRBldSfl, SRProcess                               *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
     C     SRloadSfl     BEGSR
      *
      * If RRN of the last record loaded in the subfile is greater than zero.
     C                   IF        WLstRrn > *ZEROS
      *
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      D0SFRN  = WLstRrn
      *
     C                   ENDIF
      *
      * Intialise filter flags - no search criteria.
     C                   EVAL      WSelDESC = 'Y'
      *
      * If Position field - ID is not blank, set the pointer to the entered ID data.
     C                   IF        (D0SIDE  <> *BLANKS) AND
     C                             RollUp = *OFF AND
     C                             NOT %EOF(UTVLLEPD) OR
     C                             (D0SIDE  =  *BLANKS) AND
     C                             RollUp = *OFF AND
     C                             NOT %EOF(UTVLLEPD)
      *
     C                   EVAL      D0HSID = D0SIDE
     C                   IF        D0SIDE <> *BLANKS
     C                   MOVEL     D0SIDE        KID
     C                   ELSE
     C                   MOVEL     *LOVAL        KID
     C                   ENDIF
      *
     C     KID           SETLL     UTVLLEPD
      *
     C                   ENDIF
      *
      * Reset counter.
     C                   EVAL      WCtr = 0
      *
      * Load records to subfile.
     C                   DOW       WCtr < SflPag AND
     C                             NOT %EOF(UTVLLEPD)
      *
      * Read the database file.
     C                   READ      UTVLLEPD
      *
     C                   IF        %EOF(UTVLLEPD)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(UTVLLEPD)
      *
      * Work out if the full ID entry can be displayed.
     C                   EVAL      D0ENID = LEENTI
     C                   EVAL      DisplayLen = %LEN(%TRIM(LEENTI))
     C                   IF        DisplayLen > 30
     C                   EVAL      %SUBST(D0ENID:29:2) = ' >'
     C                   ENDIF
      *
      * Work out if the full description entry can be displayed.
     C                   EVAL      D0DESC = LEENTD
     C                   EVAL      DisplayLen = %LEN(%TRIM(LEENTD))
     C                   IF        DisplayLen > 44
     C                   EVAL      %SUBST(D0DESC:43:2) = ' >'
     C                   ENDIF
      *
     C                   EVAL      D0HEID = LEENTI
      *
      * Search - description.
     C                   IF        (WSelDESC = 'Y')
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      D0OPTN = *BLANKS
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      IDEntFldID(RRN0) = LEENTI
     C                   EVAL      IDEntFldDs(RRN0) = LEENTD
      *
     C                   WRITE     UT000031S0
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
      * If last record, turn on the 'SFLEND' indicator.
     C                   EVAL      SflEnd = %EOF
     C                   EVAL      WLstRrn = D0SFRN
      *
      * Check if records were written into the subfile.
     C                   IF        WLstRrn <> *ZEROS
     C                   EVAL      SflDsp = *ON
     C                   ELSE
      *
      * If no records exists, then show 'No Data to Display' message.
     C                   EVAL      SflDsp = *OFF
     C                   EVAL      *IN20  = *ON
     C                   EVAL      PZMsgId = 'USR9013'
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C     SRloadSflE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrModify - Modify Validation List Entry                      *
      *                                                               *
      *  Called by: SRPrSfl                                           *
      *                                                               *
      *  Calls: EXTERNAL/UT000033                                     *
      *                                                               *
      *****************************************************************
     C     SRModify      BEGSR
      *
     C                   EXSR      SrReset
      *
      * Check if ID exists.
     C                   EVAL      Previous = False
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PReturnCode
     C                   PARM      Find          PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      D0HEID        PID
     C                   PARM      *BLANKS       PPass1
     C                   PARM      *BLANKS       PPass2
     C                   PARM      *BLANKS       PDescr
      *
     C                   IF        PReturnCode <> *BLANKS
     C                   LEAVESR
     C                   ENDIF
      *
      * Check validation list exists in UTVLD* and get ID / password / desc length.
     C/exec SQL
     C+ select
     C+   *
     C+ into
     C+   :VLDLDS
     C+ from UTVLDJW0
     C+ where
     C+     VLVLDL =  : PValidList
     C+ and VLDEL  <> 'Y'
     C/end-exec
     C                   IF        SQLCODE = 0
      * Get the ID / password / description length.
     C                   EVAL      IDLen  = VLIDLE
     C                   EVAL      PwdLen = VLENLE
     C                   EVAL      DscLen = VLDTLE
     C                   ELSE
      * Default ID / password / description length.
     C                   EVAL      IDLen  = ID_LEN
     C                   EVAL      PwdLen = PWD_LEN
     C                   EVAL      DscLen = DSC_LEN
     C                   ENDIF
      *
      * Validation list entries maintenance screen (Amend).
     C                   CALL      'UT000034'
     C                   PARM      'A'           PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM                    IDLen
     C                   PARM                    PwdLen
     C                   PARM                    DscLen
     C                   PARM                    D0IDTX
     C                   PARM      PID           ID
     C                   PARM      PPass1        Pwd1
     C                   PARM      PDescr        Desc
     C                   PARM      *Off          ProcFlg
      *
     C                   IF        ProcFlg = *ON
      *
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PReturnCode
     C                   PARM      Modify        PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM                    PID
     C                   PARM      Pwd1          PPass1
     C                   PARM      Pwd1          PPass2
     C                   PARM      Desc          PDescr
      *
     C                   IF        (PReturnCode = *BLANKS)
     C                   EXSR      SrReset
     C                   EVAL      PZMsgId= 'USR9007'
     C                   EXSR      SRErrDta
     C                   EVAL      SflChanged = True
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Get the cursor location for RRN.
     C                   IF        D0HCUR <> 0
     C                   EVAL      D0SFRN = D0HCUR
     C                   ENDIF
      *
     C     SRModifyE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: Various subroutines                                   *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
      *
      * Reset the fields and the program message queue.
     C                   EXSR      SRReset
      *
     C                   SELECT
      *
      * When F12 is previous.
     C                   WHEN      Previous = True
     C                   EVAL      EndPGMFlag = True
      *
     C                   LEAVESR
      *
      * When F5 Is pressed (Refresh).
     C                   WHEN      Refresh = True
      * Reset and build.
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
      *
      * When F9 is pressed (Insert).
     C                   WHEN      AddRecord = True
     C                   EXSR      SRInsert
      *
      * When F22 is pressed (Display entire field).
     C                   WHEN      DspEntFld = True
     C                   EXSR      SRDspEntFld
      *
      * When Page Down is pressed.
     C                   WHEN      Rollup = True
      *
      * Load the next page.
     C                   EXSR      SRLoadSfl
      *
     C                   WHEN      D0SIDE <> *BLANKS  OR
     C                             D0SIDE <> D0HSID
      *
     C                   EXSR      SrprSfl
     C                   EXSR      SrBldsfl

     C                   OTHER
      *
      * Process the subfile.
     C                   EXSR      SRPrSfl
      *
     C                   ENDSL
      *
     C     SRProcessE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrSfl - Process the Subfile Functions                      *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SrModify, SrView, SrDelete, SrErrData                 *
      *                                                               *
      *****************************************************************
     C     SRPrSfl       BEGSR
      *
      * Check for last RRN.
     C                   IF        WLstRrn > *ZEROS
      *
      * Reset error flag.
     C                   READC     UT000031S0
     C                   DOW       NOT %EOF
      *
     C                   SELECT
     C                   WHEN      D0OPTN = ACT_Modify
     C                   EXSR      SrModify
     C                   EVAL      UpdateOptn = True
     C                   WHEN      D0OPTN = ACT_View
     C                   EVAL      UpdateOptn = True
     C                   EXSR      SrView
     C                   WHEN      D0OPTN = ACT_Delete
     C                   EVAL      UpdateOptn = True
     C                   EXSR      SrDelete
     C                   OTHER
     C                   IF        D0OPTN <> *BLANKS
     C                   EVAL      UpdateOptn = False
     C                   ELSE
     C                   EVAL      UpdateOptn = True
     C                   ENDIF
     C                   ENDSL
      *
     C                   IF        (UpdateOptn = True)
     C                   EVAL      ErrOptn = False
     C                   EVAL      D0OPTN = *BLANKS
     C                   UPDATE    UT000031S0
     C                   ELSE
     C                   EVAL      ErrOptn = True
     C                   EVAL      PZMsgId= 'USR9011'
     C                   EXSR      SRErrDta
     C                   WRITE     UT000031C1
     C                   UPDATE    UT000031S0
     C                   ENDIF
      *
     C                   READC     UT000031S0
      *
     C                   ENDDO
     C                   ENDIF
      *
     C     SRPrSflE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRefresh - Refresh Subfile                                  *
      *                                                               *
      *  Called by: SrPrSfl                                           *
      *                                                               *
      *  Calls: SrReset, SrBldSfl                                     *
      *                                                               *
      *****************************************************************
     C     SRRefresh     BEGSR
      *
     C                   EVAL      D0OPTN = *BLANKS
     C                   EXSR      SRBldSfl
      *
     C     SRRefreshE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReset - Reset the Fields                                   *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: EXTERNAL/ZA0250                                       *
      *                                                               *
      *****************************************************************
     C     SRReset       BEGSR
      *
      * Clear program queue and message file.
     C                   CALL      'ZA0250'
      *
     C                   EVAL      PZMsgId = *BLANKS
     C                   EVAL      PZMsgData = *BLANKS
      *
     C                   EVAL      ErrOptn = False
     C                   EVAL      SetCursor = False
      *
     C     SRResetE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrResetInd - Reset Indicators                                *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRResetInd    BEGSR
      *
     C                   EVAL      ErrPas1 = False
     C                   EVAL      ErrPas2 = False
     C                   EVAL      ErrPas3 = False
      *
     C     SRResetIndE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrView - View a Validation List Entry                        *
      *                                                               *
      *  Called by: SrPrSfl                                           *
      *                                                               *
      *  Calls: EXTERNAL/UT000033                                     *
      *                                                               *
      *****************************************************************
     C     SRView        BEGSR
      *
     C                   EXSR      SrReset
      *
      * Check if ID name exists.
     C                   EXSR      SrReset
     C                   EVAL      Previous = False
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PReturnCode
     C                   PARM      Find          PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      D0HEID        PID
     C                   PARM      *BLANKS       PPass1
     C                   PARM      *BLANKS       PPass2
     C                   PARM      *BLANKS       PDescr
      *
     C                   IF        PReturnCode <> *BLANKS
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      D3IDTA = PID
     C                   EVAL      D3DDTA = PDescr
     C                   EVAL      D3ACTI = '        ENQUIRE'
     C                   EVAL      D3LABL = 'Current validation list user-
     C                              information ...'
      *
     C                   EXSR      SrResetInd
     C                   DOW       (Previous = False)
     C                   WRITE     UT000031C1
     C                   EXFMT     UT000031R2
      *
     C                   ENDDO
      * Get the cursor location for RRN.
     C                   IF        D0HCUR <> 0
     C                   EVAL      D0SFRN = D0HCUR
     C                   ENDIF
      *
     C     SRViewE       ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCommand - Execute CL Command                               *
      *                                                               *
      *  Called by: SrCheckLib, SrPopulate                            *
      *                                                               *
      *  Calls: QCMDEXC                                               *
      *                                                               *
      *****************************************************************
     C     SrCommand     BEGSR
      *
     C                   EVAL      MessageID = *BLANKS
     C                   EVAL      CommandLen = 200
     C                   CALL  (E) 'QCMDEXC'
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
      *  SRCheckObj - Verify if a validation list object exist        *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: QCMD/CHKOBJ                                           *
      *                                                               *
      *****************************************************************
     C     SRCheckObj    BEGSR
      *
     C                   EVAL      CommandStr = 'CHKOBJ OBJ('+
     C                             %TRIM(PLibrary) +'/'+ %TRIM(PValidList) +')'+
     C                             ' OBJTYPE(*VLDL)'
     C                   EXSR      SrCommand
      *
     C     SRCheckObjE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspEntFld - Display entire field for validation list entry *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRDspEntFld   BEGSR
      * Initialize fields.
     C                   Exsr      IntEntField
      *
      * Position cursor where the F22 pressed.
     C     CURSOR        DIV       256           D0HROW
     C                   MVR                     D0HCOL
     C                   EVAL      D0HCOL = 3
     C                   EVAL      SetCursor = True
      * ID
     C                   IF        D0HFLD = 'D0ENID' or D0HFLD = 'D0OPTN'
      * Get the cursor location for RRN.
     C                   EVAL      D0SFRN = D0HCUR
      *
     C                   Eval      D4IDSC = D0IDTX
     C                   EVAL      D4IDT1 = %SUBST(IDEntFldID(D0HCUR):001:74)
     C                   EVAL      D4IDT2 = %SUBST(IDEntFldID(D0HCUR):075:26)
     C                   DOW       Previous = False
     C                   EXFMT     UT000031W1
     C                   ENDDO
     C                   ENDIF
      * Description
     C                   IF        D0HFLD = 'D0DESC'
      * Get the cursor location for RRN.
     C                   EVAL      D0SFRN = D0HCUR
      *
     C                   Eval      D4IDSC = 'Description'
     C                   EVAL      D4IDT1 = %SUBST(IDEntFldDs(D0HCUR):001:74)
     C                   EVAL      D4IDT2 = %SUBST(IDEntFldDs(D0HCUR):075:74)
     C                   EVAL      D4IDT3 = %SUBST(IDEntFldDs(D0HCUR):149:74)
     C                   EVAL      D4IDT4 = %SUBST(IDEntFldDs(D0HCUR):223:74)
     C                   EVAL      D4IDT5 = %SUBST(IDEntFldDs(D0HCUR):297:74)
     C                   EVAL      D4IDT6 = %SUBST(IDEntFldDs(D0HCUR):371:74)
     C                   EVAL      D4IDT7 = %SUBST(IDEntFldDs(D0HCUR):445:74)
     C                   EVAL      D4IDT8 = %SUBST(IDEntFldDs(D0HCUR):519:74)
     C                   EVAL      D4IDT9 = %SUBST(IDEntFldDs(D0HCUR):593:74)
     C                   EVAL      D4IDT10 = %SUBST(IDEntFldDs(D0HCUR):667:74)
     C                   EVAL      D4IDT11 = %SUBST(IDEntFldDs(D0HCUR):741:74)
     C                   EVAL      D4IDT12 = %SUBST(IDEntFldDs(D0HCUR):815:74)
     C                   EVAL      D4IDT13 = %SUBST(IDEntFldDs(D0HCUR):889:74)
     C                   EVAL      D4IDT14 = %SUBST(IDEntFldDs(D0HCUR):963:37)
     C                   DOW       Previous = False
     C                   EXFMT     UT000031W1
     C                   ENDDO
     C                   ENDIF
      *
     C     SRDspEntFldE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  IntEntField - Initialization of fields                       *
      *                                                               *
      *  Called by: SRDspEntFld                                       *
      *                                                               *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
     C     IntEntField   BEGSR
     C                   EVAL      D4IDT1 = *Blanks
     C                   EVAL      D4IDT2 = *Blanks
     C                   EVAL      D4IDT3 = *Blanks
     C                   EVAL      D4IDT4 = *Blanks
     C                   EVAL      D4IDT5 = *Blanks
     C                   EVAL      D4IDT6 = *Blanks
     C                   EVAL      D4IDT7 = *Blanks
     C                   EVAL      D4IDT8 = *Blanks
     C                   EVAL      D4IDT9 = *Blanks
     C                   EVAL      D4IDT10 = *Blanks
     C                   EVAL      D4IDT11 = *Blanks
     C                   EVAL      D4IDT12 = *Blanks
     C                   EVAL      D4IDT13 = *Blanks
     C                   EVAL      D4IDT14 = *Blanks
      *
     C     IntEntFieldE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on Program Activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters.
     C     *ENTRY        PLIST
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
      *
     C                   EVAL      ValidList = PValidList
     C                   EVAL      Library   = PLibrary
     C                   EVAL      EndPGMFlag = False
      *
      * Populate workstation ID.
     C                   EVAL      D0WID = PsJobName
      *
      * Populate user.
     C                   EVAL      D0USER = PsUser
      *
     C                   TIME                    TmStamp
     C                   MOVE      TmStamp       D0MRDT
      *
      * Initialise subfile program queue and message file.
     C                   EVAL      D1PGMQ = '*'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      D0VLDL = %TRIMR(PLibrary) +'/'+
     C                             PValidList
      *
     C     INZSRE        ENDSR
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
      *  Calls: None                                                  *
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
