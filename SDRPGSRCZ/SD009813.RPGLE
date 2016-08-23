     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD External Transation syatem ID Maintenance')
      *****************************************************************
      *                                                               *
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009813 - This Module Is For External Transaction System    *
      *             ID Maintenance                                    *
      *                                                               *
      *  Function:  This program is used for the maintenance of       *
      *             External Transaction System ID file               *
      *                                                               *
      *  Called By: SD009812 - MIDAS SD External Transaction System   *
      *                        ID subfile                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use Of Indicators.                                           *
      *                                                               *
      *    03 - Exit                                                  *
      *    10 - Delete Record                                         *
      *    12 - Cancel                                                *
      *    22 - Protect External System ID                            *
      *    22 - Under line External System ID                         *
      *    24 - Footer                                                *
      *    29 - Protect Description                                   *
      *    29 - Under line Description                                *
      *    32 - SflMsgEnd                                             *
      *    81 - Reverse Image                                         *
      *    83 - Reverse Image                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRFldVal - Validate The Data Of The Fields                   *
      *  SRAmend  - Amend the Record Subroutine                       *
      *  SRDelete - Delete The select record                          *
      *  SRInsert - Insert A New Record In The File                   *
      *  SRErrDta - Output error Message With Data                    *
      *  *INZSR   - Initialise                                        *
      *  *PSSR    - Error processing                                  *
      *                                                               *
      *    The *INZSR Subroutine Will Only Get Called Automatically   *
      *    On Entry To The Module The First Time It Is Run            *
      *    (Unless You End The Program With LR On).  Similarly        *
      *    D-spec initialisation only happens The First Time.  Use    *
      *    RESET For Subsequent Passes.                               *
      *                                                               *
      *****************************************************************
      *---------------------------------------------------------------*
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** External Transaction System ID  File
     FSDEXTSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** External Transaction System ID Subfile
     FSD009813DFCF   E             WORKSTN
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically Included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The Following /COPY Line Includes The LDA Layout,
      ** The Copyright Array Definition,
      ** And The Following Named Constants:
      **    True       Logical = *ON (For Indcator Processing)
      **    False      Logical = *OFF (For Indcator Processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (The Name Of The Database
      **                         Error Handler)
      ** And The Following Variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      *
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End Of Automatically Included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Arrays And Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS SDBANK Based On SDBANKPD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D Indicators      DS                  BASED(IndPointer)
     D  Exit                   3      3
     D  DltRecord             10     10
     D  Cancel                12     12
     D  SflMsgEnd             32     32
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D IndPointer      S               *   Inz(%Addr(*IN))
     D Error           S              1A
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D Amend           C                   CONST('A')
     D Enquire         C                   CONST('E')
     D Delete          C                   CONST('D')
     D Insert          C                   CONST('I')
      *
      ** Paramaters For AOBANKR0
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Paramaters For ZA0350
     D PZMsgFile       S             10A
     D PZMsgId         S             10A
     D PZMsgData       S             45A
      *
      ** Work Variable
     D WMsgId          S              7A
     D WMsgDta         S             45A
     D WRun            S              1A
     D WIdx            S              3P 0
      *
      ** Entry Parameters
     D POpt            S              1A
     D PExid           S              2A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial Processing Is Performed Automatically: The *INZSR  ¦
      ** ¦ Is Executed At Program Activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************
      *
      ** Turn Off All Reverse Image Indicators
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN83 = *OFF
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN85 = *OFF
     C                   EVAL      Cancel = *OFF
     C                   EVAL      Exit = *OFF
      *
      ** Populate The Screen Field
     C                   IF        (POpt = Amend) OR
     C                             (POpt = Enquire) OR
     C                             POpt = Delete
      *
      ** If found, Then Populate the Screen Fields
     C     PExid         CHAIN     SDEXTSL0
     C                   IF        %FOUND(SDEXTSL0)
      *
     C                   EVAL      D0EXID = E9EXID
     C                   EVAL      D0DESC = E9DESC
     C                   EVAL      D0AMEN = E9AMEN
     C                   EVAL      D0TIMF = E9TIMF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Not found, Then Set The Blank Value.
     C                   EVAL      D0EXID = *BLANKS
     C                   EVAL      D0DESC = *BLANKS
     C                   EVAL      D0AMEN = 'N'
     C                   EVAL      D0TIMF = *BLANKS
      *
     C                   ENDIF
      *
     C                   DOW       (Exit = *OFF) AND
     C                             (Cancel = *OFF)
      *
      ** If Amendment, Set Required Indicators
     C                   IF        POpt = Amend
      *
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN29 = *OFF
      *
      ** If Enquire, Set Required Indicators
     C                   ELSEIF    POpt = Enquire
      *
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN29 = *ON
      *
      ** If Delete, Set Required Indicators
     C                   ELSEIF    POpt = Delete
      *
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN24 = *ON
     C                   EVAL      *IN29 = *ON
      *
      ** If Insert, Set Required Indicators
     C                   ELSEIF    POpt = Insert
      *
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN29 = *OFF
      *
     C                   ENDIF
      *
      ** Populate The Time Field
     C                   TIME                    D0TIME
      *
      ** Footer Of The Screen With Function Keys
     C                   WRITE     SD009813F1
      *
      ** Message Subfile Control Format
     C                   WRITE     SD009813C0
      *
      ** Screen Format
     C                   EXFMT     SD009813F0
      *
     C                   SELECT
      *
     C                   WHEN      Exit = *ON
     C                   EVAL      PRtcd = 'F3'
     C                   RETURN
      *
     C                   WHEN      Cancel = *ON
     C                   EVAL      PRtcd = 'F12'
     C                   RETURN
      *
      ** Amend The Record
     C                   WHEN      POpt = Amend
     C                   EXSR      SRAmend
      *
      ** Delete The Record
     C                   WHEN      POpt = Delete
     C                   EXSR      SRDelete
      *
      ** Insert The Record
     C                   WHEN      POpt = Insert
     C                   EXSR      SRInsert
      *
     C                   WHEN      POpt = Enquire
     C                   EVAL      Cancel = *ON
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      *IN22 = *OFF
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   COMMIT
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly On Program Activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    POpt
     C                   PARM                    PExid
     C                   PARM                    PRtcd
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check the Return Parameter
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
      *
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   EVAL      D0WOID = PsJobName
     C                   EVAL      D0USRP = PsUser
     C                   EVAL      D0MRDT = BJMRDT
      *
      ** Initialise Subfile Program Queue And Message File
     C                   EVAL      D0PGMQ = '*'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
      *
      ** Clear Program Message Queue
     C                   CALL      'ZA0250'
      *
     C                   EVAL      SflMsgEnd = *ON
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFldVal - Validate The Data Of The Fields                   *
      *                                                               *
      *  Called by: MAIN Processing, SRAmend, SRInsert                *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
     C     SRFldVal      BEGSR
     C                   IF        (POpt = Insert) AND
     C                             (D0EXID = *BLANKS)
      *
      ** External System Id Can Not Be Blank
     C                   EVAL      WMsgId = 'USR8102'
     C                   EVAL      *IN81 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ELSEIF    (POpt = Insert) AND
     C                             (D0EXID <> *BLANKS)
      *
      ** External Sys Id Should Be Equal To Two Character
     C                   IF        %LEN(%TRIM(D0EXID)) < 2
     C                   EVAL      WMsgId = 'USR4078'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Perform Chain Operation With EXT ID In The File SDEXTSL0
      ** EXT ID Should be Unique In The File
      *
     C     D0EXID        CHAIN     SDEXTSL0
     C                   IF        %FOUND(SDEXTSL0)
     C                   EVAL      WMsgId = 'USR8103'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      *IN81 = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validation of Description
      ** Description Can Not Be Blank
      *
     C                   IF        D0DESC = *BLANKS
     C                   EVAL      WMsgId = 'USR8104'
     C                   EVAL      *IN83 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Validation for 'Amendable' field
     C                   IF        D0EXID =  'TO'
      *
     C                   IF        D0AMEN = 'N'
     C                   EVAL      *IN84 = *ON
     C                   EVAL      WMsgId = 'USR8209'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** For ToF, Time Format must be 'U'
     C                   IF        D0TIMF <> 'U'
     C                   EVAL      *IN85 = *ON
     C                   EVAL      WMsgId = 'USR8110'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ELSE
      *
      *
     C                   IF        D0AMEN <> 'Y' AND
     C                             D0AMEN <> 'N'
      *
     C                   EVAL      *IN84 = *ON
     C                   EVAL      WMsgId = 'USR8208'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ENDIF
      *
      ** Time Format must be 'U' or 'L'
     C                   IF        D0TIMF <> 'U' AND
     C                             D0TIMF <> 'L' AND
     C                             D0TIMF <> 'M'
      *
     C                   EVAL      *IN85 = *ON
     C                   EVAL      WMsgId = 'USR8107'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmend - Amend The Record Subroutine                        *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRFldVal                                              *
      *                                                               *
      *****************************************************************
     C     SRAmend       BEGSR
      *
      ** Reset Error Flag
     C                   EXSR      SRReset
      *
     C                   EXSR      SRFldVal
      *
     C                   IF        WIdx = 0
      *
      ** If Valid, Update Database
     C                   EVAL      E9EXID = D0EXID
     C                   EVAL      E9DESC = D0DESC
     C                   EVAL      E9AMEN = D0AMEN
     C                   EVAL      E9LCD  = BJRDNB
     C                   EVAL      E9TIMF = D0TIMF
     C                   EVAL      E9TYLC = Amend
     C                   UPDATE    SDEXTSD0
      *
     C                   EVAL      Cancel = *ON
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelete - Delete The Select Record                          *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRDelete      BEGSR
      *
     C                   IF        *IN10 = *ON
     C                   DELETE    SDEXTSD0
     C                   EVAL      Cancel = *ON
      *
     C                   ELSE
     C                   EVAL      WIdx = *ZEROS
      *
      ** Clear Program Message Queue
     C                   CALL      'ZA0250'
      *
     C                   EVAL      WMsgId = 'ASM0028'
     C                   EVAL      WIdx = WIdx
     C                   EXSR      SRErrDta
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsert - Insert A New Record In The File                   *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRFldVal,SRErrDta                                     *
      *                                                               *
      *****************************************************************
      *
     C     SRInsert      BEGSR
      *
      ** Reset Error Flag
     C                   EXSR      SRReset
      *
     C                   EXSR      SRFldVal
      *
     C                   IF        WIdx = 0
      *
      ** If valid, Write To Database
     C                   EVAL      E9EXID = D0EXID
     C                   EVAL      E9DESC = D0DESC
     C                   EVAL      E9LCD  = BJRDNB
     C                   EVAL      E9TYLC = Insert
     C                   EVAL      E9AMEN = D0AMEN
     C                   EVAL      E9TIMF = D0TIMF
      *
     C                   WRITE     SDEXTSD0
      *
     C                   EVAL      Cancel = *ON
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrDta - Output Error Message With Data                    *
      *                                                               *
      *  Called by: MAIN Processing, SRFldVal, SRDelete, SRInsert     *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRErrDta      BEGSR
     C                   EVAL      PZMsgId = *BLANKS
     C                   EVAL      PZMsgId = WMsgId
      *
      ** Send Error Message To Message Subfile
     C                   CALL      'ZA0350'
      *
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgId
     C                   PARM      WMsgDta       PZMsgData
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      *  SRReset - Reset Error Flag                                   *
      *                                                               *
      *  Called by: SRAmend, SRInsert                                 *
      *                                                               *
      *  Calls: SRFldVal, SRErrDta                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRReset       BEGSR
      *
     C                   CALL      'ZA0250'
      *
      ** Reset Error Indicator
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN83 = *OFF
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN85 = *OFF
      *
      ** Clear Error Fields
     C                   EVAL      PZMsgId = *BLANKS
     C                   EVAL      PZMsgData = *BLANKS
     C                   EVAL      WIdx = *ZEROS
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically if a program error occurs,          *
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
      *****************************************************************
      /EJECT
      *****************************************************************
