      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Validation List Entries Maintenance')         *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000031 - Midas UT Validation List Entries Maintenance      *
      *                                                               *
      *  Function:  This program display the entries contained        *
      *             within a given validation list                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. BUG28082           Date 31Aug10               *
      *  Prev Amend No. BUG27989*CREATE    Date 08Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG28082 - Unable to display the correct information in the  *
      *             screen. (Recompile)                               *
      *  BUG27989 - HATS should run with/without LDAP                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRBldSfl - Build the Subfile                                 *
      *  SrClrOutFile - Clear Output File                             *
      *  SRClrSfl - Clear the Subfile                                 *
      *  SrDelete - Delete a Validation List Entry                    *
      *  SRDspSfl - Display the Subfile                               *
      *  SRErrDta - Output Error Message With Data                    *
      *  SrInsert - Insert a Validation List Entry                    *
      *  SRloadSfl - Load the Subfile                                 *
      *  SrModify - Modify Validation List Entry                      *
      *  SRProcess - Process the Subfile                              *
      *  SRPrSfl - Process the Subfile Functions                      *
      *  SRRefresh - Refresh Entries                                  *
      *  SRReset - Reset the Fields                                   *
      *  SRResetInd  - Reset Indicators                               *
      *  SrCommand - Execute CL Command                               *
      *  SrView - View a Validation List Entry                        *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Validation List Entries Maintenance Display File
     FUT000031DFCF   E             WORKSTN SFILE(UT000031S0:RRN0)
 
      ** Validation List Entries Retrieval File
     FUTVLLEL0  UF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     DPSDS            SDS
     D PSExcpType             40     42
      **  Exception number
     D PSExcpNo               43     46
      **  Program library
      ** Job name
     D PSJobName             244    253
      ** User name
     D PSUser                254    263
 
     D IndPointer      S               *   Inz(%ADDR(*IN))
 
      ** Indicator Data Structure
     D Indicators      DS                  BASED(IndPointer)
     D  Exit                  03     03
     D  Refresh               05     05
     D  AddRecord             09     09
     D  Confirm               10     10
     D  Previous              12     12
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Action Codes
     D Insert          C                   CONST('A')
     D Modify          C                   CONST('M')
     D Reset           C                   CONST('R')
     D Delete          C                   CONST('D')
     D Find            C                   CONST('F')
 
     D ACT_Modify      C                   CONST('A')
     D ACT_View        C                   CONST('E')
     D ACT_Delete      C                   CONST('D')
 
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Logical conditions
     D True            C                   *ON
     D False           C                   *OFF
 
     D VLDL            DS                  ALIGN
     D   ValidList                   10A
     D   Library                     10A
      *
      ** Parameter For AOBANKR0
     D PRtcd           S              7A
     D POptn           S              7A
 
     D SflChanged      S              1N
     D ErrorExist      S              1N
     D UpdateOptn      S              1N
 
     D ReturnVal       S             10I 0
     D WRun            S              1A
 
      ** Entry Parameters
     D PValidList      S             10A
     D PLibrary        S             10A
      *
      ** Parameter for ZA0350
     D PZMsgFile       S             10A   INZ('UTMSGF')
     D PZMsgId         S             10A
     D PZMsgData       S             45A
 
     D RRN0            S              4  0
     D SflPag          C                   CONST(14)
     D WCtr            S              2  0
     D WLstRrn         S              4  0
     D EndPGMFlag      S              1A
     D WSelDESC        S              1A
 
      ** UT00032 parameters
     D PReturnCode     S              7A
     D PAction         S              1A
     D PuserName       S            256A
     D PPass1          S            256A
     D PPass2          S            256A
     D PDescr          S             50A
      *
     D   MessageID     S              7A   INZ(*BLANKS)
     D   CommandStr    S            200A   INZ(*BLANKS)
      *
     D UserErrMsg      S             10A
     D Pas1ErrMsg      S             10A
     D Pas2ErrMsg      S             10A
     D Pas3ErrMsg      S             10A
      *
     D CommandLen      S             15  5
     D TmStamp         S             14  0
      *****************************************************************
      /EJECT
      *****************************************************************
      ** MAIN - Processing
      *****************************************************************
      *
     C                   EXSR      SrCheckOBJ
     C                   IF        MessageID <> *BLANKS
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** Build The Subfile
      *
     C                   EXSR      SRBldSfl
      *
      ** Display the Screen Until F12 or F3 Is Pressed
      *
     C                   DOW       (Exit = False) AND
     C                             (EndPGMFlag = False)
      *
     C                   EVAL      ##OPTN = *BLANKS
     C                   EVAL      SflChanged = False
     C                   EXSR      SRResetInd
      *
      ** Display And Process the Subfile
      *
     C                   EXSR      SRDspSfl
      *
      ** Process the Subfile
      *
     C                   EXSR      SRProcess
      *
      ** Rebuild subfile
      *
     C                   IF        (SflChanged)
     C                   EXSR      SRRefresh
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
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
     C                   CLOSE     UTVLLEL0
      *
     C                   CALL      'UT000032'
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   OPEN      UTVLLEL0
      *
      ** Clear the Subfile
      *
     C                   EXSR      SRClrSfl
      *
      ** Load the Subfile
      *
     C                   EXSR      SRLoadSfl
      *
     C                   ENDSR
      *****************************************************************
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
      ** Delete all entries on this outfile
      *
     C     *LOVAL        SETLL     UTVLLED0
     C                   READ      UTVLLEL0
     C                   DOW       NOT(%EOF(UTVLLEL0))
     C                   DELETE    UTVLLEL0
     C                   READ      UTVLLEL0
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
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
     C     *LOVAL        SETLL     UTVLLEL0
      *
      ** Intialise Fields
      *
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
     C                   ENDSR
      *****************************************************************
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
      ** Check if username exist
      *
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PReturnCode
     C                   PARM      Find          PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      #HUSER        PUserName
     C                   PARM      *BLANKS       PPass1
     C                   PARM      *BLANKS       PPass2
     C                   PARM      *BLANKS       PDescr
      *
     C                   IF        PReturnCode <> *BLANKS
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      #4USER = PUserName
     C                   EVAL      #4DESC = PDescr
     C                   EVAL      #4ACTI = '         DELETE'
     C                   EVAL      #4LABL = 'Current user will be deleted -
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
     C                   PARM      #HUSER        PUserName
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
     C                   ENDSR
      *****************************************************************
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
      ** Write the Message Subfile Control Format
      *
     C                   WRITE     UT000031C1
     C                   WRITE     UT000031F0
     C                   EXFMT     UT000031C0
      *
     C                   ENDSR
      *****************************************************************
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
     C                   ENDSR
      *****************************************************************
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
     C                   EVAL      ErrUser = False
     C                   EVAL      ErrPas1 = False
     C                   EVAL      ErrPas2 = False
     C                   EVAL      Previous   = False
     C                   EVAL      ErrorExist = False
     C                   EVAL      #2USER = *BLANKS
     C                   EVAL      #2PAS1 = *BLANKS
     C                   EVAL      #2PAS2 = *BLANKS
     C                   EVAL      #2DESC = *BLANKS
 
     C                   EVAL      #2ACTI = '         INSERT'
     C                   DOW       (Previous = False)
     C                   EVAL      ErrorExist = False
     C                   WRITE     UT000031C1
     C                   WRITE     UT000031R0
     C                   EXFMT     UT000031R0
      *
      ** Go back to previous screen when F12 is pressed
      *
     C                   IF        (Previous = True)
     C                   EXSR      SrReset
     C                   LEAVESR
     C                   ENDIF
      *
      ** User name must be entered
      *
     C                   IF        (#2USER = *BLANKS)
     C                   EVAL      UserErrMsg = 'USR9001'
     C                   EVAL      ErrorExist = True
     C                   EVAL      ErrUser    = True
     C                   ELSE
     C                   EVAL      ErrUser    = False
      *
      ** Check if username exist
      *
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PReturnCode
     C                   PARM      Find          PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      #2USER        PUserName
     C                   PARM      *BLANKS       PPass1
     C                   PARM      *BLANKS       PPass2
     C                   PARM      *BLANKS       PDescr
      *
     C                   IF        PReturnCode = *BLANKS
     C                   EVAL      UserErrMsg = 'USR9014'
     C                   EVAL      ErrorExist = True
     C                   EVAL      ErrUser    = True
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Password should not be blanks
      *
     C                   IF        (#2PAS1 = *BLANKS)
     C                   EVAL      Pas1ErrMsg = 'USR9002'
     C                   EVAL      ErrorExist = True
     C                   EVAL      ErrPas1    = True
     C                   ELSE
     C                   EVAL      ErrPas1    = False
     C                   ENDIF
      *
      ** Confirm password should not be blanks
      *
     C                   IF        (#2PAS2 = *BLANKS)
     C                   EVAL      Pas2ErrMsg = 'USR9005'
     C                   EVAL      ErrorExist = True
     C                   EVAL      ErrPas2    = True
     C                   ELSE
     C                   EVAL      ErrPas2    = False
     C                   ENDIF
      *
      ** Confirm password should not be blanks
      *
     C                   IF        (#2PAS1 <> *BLANKS) AND
     C                             (#2PAS2 <> *BLANKS)
     C                   IF        (#2PAS1  <> #2PAS2)
     C                   EVAL      Pas1ErrMsg = 'USR9006'
     C                   EVAL      Pas2ErrMsg = *BLANKS
     C                   EVAL      ErrorExist = True
     C                   EVAL      ErrPas1    = True
     C                   EVAL      ErrPas2    = True
     C                   ELSE
     C                   EVAL      ErrPas2    = False
     C                   EVAL      ErrPas2    = False
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        NOT(ErrorExist) AND
     C                             (#2USER <> *BLANKS) AND
     C                             (#2PAS1 <> *BLANKS) AND
     C                             (#2PAS2 <> *BLANKS)
      *
      ** No Error (User successfully insert must be displayed)
      *
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PReturnCode
     C                   PARM      Insert        PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      #2USER        PUserName
     C                   PARM      #2PAS1        PPass1
     C                   PARM      #2PAS2        PPass2
     C                   PARM      #2DESC        PDescr
      *
     C                   IF        (PReturnCode = *BLANKS)
     C                   EXSR      SrReset
     C                   EVAL      PZMsgId= 'USR9009'
     C                   EXSR      SRErrDta
     C                   EVAL      SflChanged = True
     C                   EVAL      #2USER = *BLANKS
     C                   EVAL      #2PAS1 = *BLANKS
     C                   EVAL      #2PAS2 = *BLANKS
     C                   EVAL      #2DESC = *BLANKS
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Errors found then display the error messages
     C                   EXSR      SrReset
      *
      ** Error in username
     C                   IF        ErrUser = True
     C                   EVAL      PZMsgID = UserErrMsg
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Error in Password
     C                   IF        ErrPas1 = True
     C                   EVAL      PZMsgID = Pas1ErrMsg
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Error in confirm new password
     C                   IF        ErrPas2 = True AND Pas2ErrMsg <> *BLANKS
     C                   EVAL      PZMsgID = Pas2ErrMsg
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
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
      ** If Relative Record Number of the Last Record Loaded in the
      ** Subfile is Greater than Zero
      *
     C                   IF        WLstRrn > *ZEROS
      *
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
      *
     C                   ENDIF
      *
      ** Intialise Filter Flags - No Search Criteria
      *
     C                   EVAL      WSelDESC = 'Y'
      *
      ** If Position field - User Name is not blank,
      ** Set the Pointer To the entered User Name
      *
     C                   IF        (#SUSER  <> *BLANKS) AND
     C                             RollUp = *OFF AND
     C                             NOT %EOF(UTVLLEL0) OR
     C                             (#SUSER  =  *BLANKS) AND
     C                             RollUp = *OFF AND
     C                             NOT %EOF(UTVLLEL0)
      *
     C                   EVAL      #SHUSER = #SUSER
     C                   IF        #SUSER <> *BLANKS
     C                   MOVEL     #SUSER        #KUSER          256
     C                   ELSE
     C                   MOVEL     *LOVAL        #KUSER
     C                   ENDIF
      *
     C     #KUSER        SETLL     UTVLLEL0
      *
     C                   ENDIF
      *
      ** Reset Counter
      *
     C                   EVAL      WCtr = 0
      *
      ** Loading Records to Subfile
      *
     C                   DOW       WCtr < SflPag AND
     C                             NOT %EOF(UTVLLEL0)
      *
      ** Read the Database File
      *
     C                   READ      UTVLLEL0
      *
     C                   IF        %EOF(UTVLLEL0)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(UTVLLEL0)
      *
     C                   EVAL      ##USER = VLUSER
     C                   EVAL      ##DESC = VLDESC
     C                   EVAL      #HUSER = VLUSER
      *
      ** Search - Description
      *
     C                   IF        (WSelDESC = 'Y')
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      ##OPTN = *BLANKS
     C                   EVAL      *IN35 = *OFF
      *
     C                   WRITE     UT000031S0
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
      ** If Last Record, Turn on the 'SFLEND' indicator
      *
     C                   READ      UTVLLEL0
     C                   IF        %EOF(UTVLLEL0)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   IF        %EOF(UTVLLEL0)
     C                   READP     UTVLLEL0
     C                   ENDIF
     C                   EVAL      SflEnd = *OFF
     C                   ENDIF
     C                   EVAL      WLstRrn = D0SFRN
      *
      ** Check If Records Were Written into the Subfile
      *
     C                   IF        WLstRrn <> *ZEROS
     C                   EVAL      SflDsp = *ON
     C                   ELSE
      *
      ** If No Records Exists, then show 'No Data to Display' Message
      *
     C                   EVAL      SflDsp = *OFF
     C                   EVAL      *IN20  = *ON
     C                   EVAL      PZMsgId = 'USR9013'
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrModify - Modify Validation List Entry
      *                                                               *
      *  Called by: SRPrSfl                                           *
      *                                                               *
      *  Calls: EXTERNAL/UT000033                                     *
      *                                                               *
      *****************************************************************
     C     SRModify      BEGSR
      *
     C                   EXSR      SrReset
     C                   EVAL      #3PAS1 = *BLANKS
     C                   EVAL      #3PAS2 = *BLANKS
     C                   EVAL      #3PAS3 = *BLANKS
      *
      ** Check if username exist
      *
     C                   EVAL      Previous = False
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PReturnCode
     C                   PARM      Find          PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      #HUSER        PUserName
     C                   PARM      *BLANKS       PPass1
     C                   PARM      *BLANKS       PPass2
     C                   PARM      *BLANKS       PDescr
      *
     C                   IF        PReturnCode <> *BLANKS
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      #3USER = PUserName
     C                   EVAL      #3DESC = PDescr
     C                   EVAL      #3HDESC = PDescr
     C                   EVAL      #3HPAS1 = PPass1
     C                   EVAL      #3PAS2 = *BLANKS
     C                   EVAL      #3PAS3 = *BLANKS
      *
     C                   EVAL      #3ACTI = '          AMEND'
     C                   DOW       (Previous = False)
      *
     C                   EVAL      ErrorExist = False
     C                   WRITE     UT000031C1
     C                   EXFMT     UT000031R1
      *
      ** Go back to previous screen when F12 is pressed
      *
     C                   IF        (Previous = True)
     C                   EXSR      SrReset
     C                   LEAVESR
     C                   ENDIF
      *
      ** Check if current password is blanks
      *
     C                   IF        (#3PAS1 = *BLANKS)
     C                   EVAL      ErrPas1 = True
     C                   EVAL      ErrorExist = True
     C                   EVAL      Pas1ErrMsg = 'USR9002'
     C                   ELSE
     C                   EVAL      ErrPas1 = False
     C                   ENDIF
      *
      ** Check if current password is equal to saved password
      *
     C                   IF        (#3PAS1 <> *BLANKS) AND
     C                             (#3PAS1 <> PPass1)
     C                   EVAL      ErrPas1 = True
     C                   EVAL      Pas1ErrMsg = 'USR9003'
     C                   EVAL      ErrorExist = True
     C                   ELSE
     C                   EVAL      ErrPas1 = False
     C                   ENDIF
      *
      ** Check if new password is blanks
      *
     C                   IF        (#3PAS2 = *BLANKS)
     C                   EVAL      ErrPas2 = True
     C                   EVAL      ErrorExist = True
     C                   EVAL      Pas2ErrMsg = 'USR9004'
     C                   ELSE
     C                   EVAL      ErrPas2 = False
     C                   ENDIF
      *
      ** Check if confirm new password is blanks
      *
     C                   IF        (#3PAS3 = *BLANKS)
     C                   EVAL      ErrPas3 = True
     C                   EVAL      ErrorExist = True
     C                   EVAL      Pas3ErrMsg = 'USR9005'
     C                   ELSE
     C                   EVAL      ErrPas3 = False
     C                   ENDIF
      *
      ** Check if new password is equal to  confirm new password
      *
     C                   IF        (#3PAS2 <> *BLANKS) AND
     C                             (#3PAS3 <> *BLANKS)
     C                   IF        (#3PAS2 <> #3PAS3)
     C                   EVAL      ErrPas2 = True
     C                   EVAL      ErrPas3 = True
     C                   EVAL      ErrorExist = True
     C                   EVAL      Pas2ErrMsg = 'USR9006'
     C                   EVAL      Pas3ErrMsg = *BLANKS
     C                   ELSE
      *
      ** Check if new password is equal to  current new password
      *
     C                   IF        (#3HPAS1= #3PAS2)
     C                   EVAL      ErrPas1 = True
     C                   EVAL      ErrPas2 = True
     C                   EVAL      ErrPas3 = True
     C                   EVAL      ErrorExist = True
     C                   EVAL      Pas1ErrMsg = 'USR9008'
     C                   EVAL      Pas2ErrMsg = *BLANKS
     C                   EVAL      Pas3ErrMsg = *BLANKS
     C                   ELSE
     C                   EVAL      ErrPas1 = False
     C                   EVAL      ErrPas2 = False
     C                   EVAL      ErrPas3 = False
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        (#3PAS1 = *BLANKS) AND
     C                             (#3PAS2 = *BLANKS) AND
     C                             (#3PAS2 = *BLANKS)
     C                   EVAL      ErrPas1 = False
     C                   EVAL      ErrPas2 = False
     C                   EVAL      ErrPas3 = False
     C                   EVAL      ErrorExist = False
     C                   EXSR      SrReset
     C                   IF        (#3HDESC = #3DESC)
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        NOT(ErrorExist)
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PReturnCode
     C                   PARM      Modify        PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      #HUSER        PUserName
     C                   PARM      #3HPAS1       PPass1
     C                   PARM      #3PAS2        PPass2
     C                   PARM      #3DESC        PDescr
      *
     C                   IF        (PReturnCode = *BLANKS)
     C                   EXSR      SrReset
     C                   EVAL      PZMsgId= 'USR9007'
     C                   EXSR      SRErrDta
     C                   EVAL      SflChanged = True
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Errors found then display the error messages
      *
     C                   EXSR      SrReset
      *
      ** Error in Current Password
      *
     C                   IF        ErrPas1 = True and Pas1ErrMsg <> *BLANKS
     C                   EVAL      PZMsgID = Pas1ErrMsg
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Error in New Password
      *
     C                   IF        ErrPas2 = True AND Pas2ErrMsg <> *BLANKS
     C                   EVAL      PZMsgID = Pas2ErrMsg
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Error in Confirm New Password
      *
     C                   IF        ErrPas3 = True AND Pas3ErrMsg <> *BLANKS
     C                   EVAL      PZMsgID = Pas3ErrMsg
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: Various subroutines                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
      *
      ** Reset the Fields and the Program Message Queue
      *
     C                   EXSR      SRReset
      *
     C                   SELECT
      *
      ** When F12 is Previous
      *
     C                   WHEN      Previous = True
     C                   EVAL      EndPGMFlag = True
      *
     C                   LEAVESR
      *
      ** When F5 Is Pressed (Refresh)
      *
     C                   WHEN      Refresh = True
      ** Reset and Build
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
      *
      ** When F9 Is Pressed (Insert)
      *
     C                   WHEN      AddRecord = True
     C                   EXSR      SRInsert
      *
      ** When Page Down Is Pressed
      *
     C                   WHEN      Rollup = True
      *
      ** Load the Next Page
      *
     C                   EXSR      SRLoadSfl
      *
     C                   WHEN      #SUSER <> *BLANKS  OR
     C                             #SUSER <> #SHUSER
      *
     C                   EXSR      SrprSfl
     C                   EXSR      SrBldsfl
 
     C                   OTHER
      *
      ** Process the Subfile
      *
     C                   EXSR      SRPrSfl
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
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
      ** Check For Last Relative Record Number
      *
     C                   IF        WLstRrn > *ZEROS
      *
      ** Reset Error Flag
      *
     C                   READC     UT000031S0
     C                   Dow       Not %Eof
      *
     C                   SELECT
     C                   WHEN      ##OPTN = ACT_Modify
     C                   EXSR      SrModify
     C                   EVAL      UpdateOptn = True
     C                   WHEN      ##OPTN = ACT_View
     C                   EVAL      UpdateOptn = True
     C                   EXSR      SrView
     C                   WHEN      ##OPTN = ACT_Delete
     C                   EVAL      UpdateOptn = True
     C                   EXSR      SrDelete
     C                   OTHER
     C                   IF        ##OPTN <> *BLANKS
     C                   EVAL      UpdateOptn = False
     C                   ELSE
     C                   EVAL      UpdateOptn = True
     C                   ENDIF
     C                   ENDSL
      *
     C                   IF        (UpdateOptn = True)
     C                   EVAL      ErrOptn = False
     C                   EVAL      ##OPTN = *BLANKS
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
     C                   ENDSR
      *****************************************************************
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
     C                   EVAL      ##OPTN = *BLANKS
     C                   EXSR      SRBldSfl
      *
     C                   ENDSR
      *****************************************************************
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
      ** Clear Program Queue And Message File
      *
     C                   CALL      'ZA0250'
      *
     C                   EVAL      PZMsgId = *BLANKS
     C                   EVAL      PZMsgData = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
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
     C                   ENDSR
      *****************************************************************
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
      ** Check if User Name exist
      *
     C                   EXSR      SrReset
     C                   EVAL      Previous = False
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PReturnCode
     C                   PARM      Find          PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      #HUSER        PUserName
     C                   PARM      *BLANKS       PPass1
     C                   PARM      *BLANKS       PPass2
     C                   PARM      *BLANKS       PDescr
      *
     C                   IF        PReturnCode <> *BLANKS
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      #4USER = PUserName
     C                   EVAL      #4DESC = PDescr
     C                   EVAL      #4ACTI = '        ENQUIRE'
     C                   EVAL      #4LABL = 'Current validation list user-
     C                              information ...'
      *
     C                   EXSR      SrResetInd
     C                   DOW       (Previous = False)
     C                   WRITE     UT000031C1
     C                   EXFMT     UT000031R2
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
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
     C                   EVAL      MessageID = *BLANKS
     C                   EVAL      CommandLen = 200
     C                   CALL  (E) 'QCMDEXC'
     C                   PARM                    CommandStr
     C                   PARM                    CommandLen
     C                   IF        %ERROR
     C                   EVAL      MessageID = PSExcpType+
     C                             PSExcpNo
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
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
     C                   EVAL      CommandStr = 'CHKOBJ OBJ('+
     C                             %TRIM(PLibrary) +'/'+ %TRIM(PValidList) +')'+
     C                             ' OBJTYPE(*VLDL)'
     C                   EXSR      SrCommand
     C                   ENDSR
      *****************************************************************
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
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
      *
     C                   EVAL      ValidList = PValidList
     C                   EVAL      Library   = PLibrary
     C                   EVAL      EndPGMFlag = False
      *
      ** Populate WorkStation ID
      *
     C                   EVAL      D0WID = PsJobName
      *
      ** Populate User
      *
     C                   EVAL      D0USER = PsUser
 
     C                   TIME                    TmStamp
     C                   MOVE      TmStamp       D0MRDT
      *
      ** Initialise Subfile Program Queue and Message File
      *
     C                   EVAL      D1PGMQ = '*'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      #1VLDL = PValidList
 
     C                   ENDSR
      *****************************************************************
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
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2010
