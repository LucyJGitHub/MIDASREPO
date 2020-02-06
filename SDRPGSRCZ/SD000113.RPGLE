     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD IGA Country Update Tool')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000113 - Midas SD IGA Country Update Tool                  *
      *                                                               *
      *  Function:  This program will display the 2nd screen where    *
      *             the user may define the FFI sub types and the new *
      *             FATCA classification codes to be used by tool     *
      *                                                               *
      *  Called By: SD000136 - Midas SD IGA Country Update Subfile    *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD029846           Date 24Sep14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD029846 -  Clarifications on FATCA menu action codes        *
      *              Apply Fix MD030170A                              *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use Of Indicators.                                           *
      *                                                               *
      *    03 - Exit                                                  *
      *    11 - Run Tool in Information Mode                          *
      *    13 - Run Tool in Update Mode                               *
      *    12 - Cancel                                                *
      *    24 - Footer                                                *
      *    32 - SflMsgEnd                                             *
      *    81 - Error IGA Model 1 FFI Sub Type                        *
      *    82 - Error IGA Model 1 FATCA Classification Code           *
      *    83 - Error IGA Model 2 FFI Sub Type                        *
      *    84 - Error IGA Model 2 FATCA Classification Code           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRFldVal - Validate The Data Of The Fields                   *
      *  SRErrDta - Output error Message With Data                    *
      *  SRReset  - Reset the Fields                                  *
      *  SRChkAut - Validate Authorization Of User                    *
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
      ** IGA Country Update Tool
     FSD000113DFCF   E             WORKSTN
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
      ** External DS Based On SDFATCPD
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
      *
     D Indicators      DS                  BASED(IndPointer)
     D  Exit                   3      3
     D  RunToolInf            11     11
     D  Cancel                12     12
     D  RunToolUpd            13     13
     D  SflMsgEnd             32     32
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D IndPointer      S               *   Inz(%Addr(*IN))
     D Error           S              1A
     D PClas           S              5A
     D PMode           S              1A
     D POpt            S              1A
     D PCArr           S           1000A
     D PM1ST           S              2A
     D PM1CC           S              5A
     D PM2ST           S              2A
     D PM2CC           S              5A
     D IsFileLocked    S              1A   INZ('N')
     D LckRlsFlag      S              5A
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
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
      ** Define A Data Structure To Access Default Branch
     D ZMUser          DS            17
     D  PBrc                  11     13A
      *
      ** Parameters For ZVACTBU/ZVACTU
     D PZbr            S              3A
     D PErr            S              1P 0
      *
      ** Work Variable
     D WMsgId          S              7A
     D WMsgDta         S             45A
     D WRun            S              1A
     D WIdx            S              3P 0
     D WarnTool        S              1A   INZ('N')
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
      ** Turn Off All Error Indicators
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN83 = *OFF
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      Cancel = *OFF
     C                   EVAL      Exit = *OFF
      *
     C                   DOW       (Exit = *OFF) AND
     C                             (Cancel = *OFF)
      *
      ** Populate The Time Field
     C                   TIME                    D0TIME
      *
      ** Footer Of The Screen With Function Keys
     C                   WRITE     SD000113F1
      *
      ** Message Subfile Control Format
     C                   WRITE     SD000113C0
      *
      ** Screen Format
     C                   EXFMT     SD000113F0
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
      ** Information Mode
     C                   WHEN      RunToolInf = *ON OR
     C                             RunToolUpd = *ON
     C                   EXSR      SRFldVal
      *
     C                   IF        WIdx = 0
      *
      ** Information Mode
     C                   IF        RunToolInf = *ON
     C                   EVAL      PMode = 'F'
     C                   EVAL      POpt = 'R'
     C                   ENDIF
      *
      ** Update Mode
     C                   IF        RunToolUpd = *ON
     C                   EVAL      PMode = 'U'
     C                   EVAL      POpt = 'U'
      ** If Update Mode, Check Files Allocations
     C
     C                   IF        LckRlsFlag <> '*LOCK'
     C                   EVAL      LckRlsFlag = '*LOCK'
     C                   EXSR      ChkFileLck
     C                   IF        IsFileLocked = 'Y'
     C                   EVAL      WMsgId = 'USS0320'
     C                   EXSR      SRErrDta
     C
     C                   EVAL      WIdx += 1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      ***Check*the*Authority****************************************                       MD030170A
     C**********         EXSR      SRChkAut                                                MD030170A
      ** Call the Tool
     C                   IF        WIdx = 0
      *
      ** Output Warning Before Tool is Executed in Update Mode
     C                   IF        WarnTool = 'N' AND RunToolUpd = *ON
     C                             and WIdx < 1
     C                   EVAL      WarnTool = 'Y'
     C                   EVAL      WMsgId = 'USS0285'
     C                   EXSR      SRErrDta
     C                   ELSE
     C                   CALL      'SDC000160'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PMode
     C                   PARM                    PCArr
     C                   PARM      D0M1ST        PM1ST
     C                   PARM      D0M1CC        PM1CC
     C                   PARM      D0M2ST        PM2ST
     C                   PARM      D0M2CC        PM2CC
      *
     C                   IF        PMode = 'U'
     C                   EVAL      LckRlsFlag = '*RLS '
     C                   EXSR      ChkFileLck
     C                   ENDIF
      *
     C                   CALL      'SD000108'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PMode
     C                   PARM                    PCArr
     C                   PARM      D0M1ST        PM1ST
     C                   PARM      D0M1CC        PM1CC
     C                   PARM      D0M2ST        PM2ST
     C                   PARM      D0M2CC        PM2CC
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   OTHER
     C                   EVAL      WarnTool = 'N'
     C                   EXSR      SRFldVal
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   IF        LckRlsFlag = '*LOCK'
     C                   EVAL      LckRlsFlag = '*RLS '
     C                   EXSR      ChkFileLck
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * ChkFileLck - Check Files Allocation                             *
      *                                                                 *
      *******************************************************************
      *
     C     ChkFileLck    BEGSR
     C                   EVAL      IsFileLocked = 'N'
     C                   CALL      'SDC000558'
     C                   PARM      *BLANKS       PRtcd             7
     C                   PARM      'SD000136'    PCallerPGM       10
     C                   PARM      LckRlsFlag    PModeLck          7
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      IsFileLocked = 'Y'
     C                   EVAL      LckRlsFlag = *BLANKS
     C                   ENDIF
     C     ChkFileLckE   ENDSR
      *******************************************************************
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
     C                   PARM                    PRtcd
     C                   PARM                    PCArr
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
      ** GET ZMUser To Access Default Branch
     C     *DTAARA       DEFINE                  ZMUser
     C                   IN        ZMUser
     C                   UNLOCK    ZMUser
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
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
     C     SRFldVal      BEGSR
      *
      ** Reset Error Flag
     C                   EXSR      SRReset
      *
      ** Validation of IGA Model 1 FFI Sub Type
      ** The FATCA Customer Sub-Type must be either PO, PW, PS, NP,
      ** UN or OW
     C                   IF        D0M1ST <> 'PO' AND D0M1ST <> 'PW'
     C                             AND D0M1ST <> 'PS' AND
     C                             D0M1ST <> 'NP' AND D0M1ST <> 'UN'
     C                             AND D0M1ST <> 'OW'
     C                   EVAL      WMsgId = 'USS0262'
     C                   EVAL      *IN81 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Validation for IGA Model 1 FATCA Classification Code
      ** If Entered, FATCA Classification Code Must Be A Valid Code
     C                   IF        D0M1CC <> *BLANKS
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      D0M1CC        PClas
     C     SDFATC        PARM      SDFATC        DSFDY
      *
     C                   IF        PRtcd = '*NRF'
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WMsgId = 'USS0280'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      D0M1CD = FCDESC
     C                   EVAL      D0M1CC = FCCODE
     C                   ENDIF
     C                   ELSE
     C                   EVAL      D0M1CD = *BLANKS
     C                   ENDIF
      *
      ** Validation of IGA Model 2 FFI Sub Type
      ** The FATCA Customer Sub-Type must be either PO, PW, PS, NP,
      ** UN or OW
     C                   IF        D0M2ST <> 'PO' AND D0M2ST <> 'PW'
     C                             AND D0M2ST <> 'PS' AND
     C                             D0M2ST <> 'NP' AND D0M2ST <> 'UN'
     C                             AND D0M2ST <> 'OW'
     C                   EVAL      WMsgId = 'USS0262'
     C                   EVAL      *IN83 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Validation for IGA Model 2 FATCA Classification Code
      ** If Entered, FATCA Classification Code Must Be A Valid Code
     C                   IF        D0M2CC <> *BLANKS
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      D0M2CC        PClas
     C     SDFATC        PARM      SDFATC        DSFDY
      *
     C                   IF        PRtcd = '*NRF'
     C                   EVAL      *IN84 = *ON
     C                   EVAL      WMsgId = 'USS0280'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      D0M2CD = FCDESC
     C                   EVAL      D0M2CC = FCCODE
     C                   ENDIF
     C                   ELSE
     C                   EVAL      D0M2CD = *BLANKS
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
      *  Called by: SRFldVal                                          *
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
      *  Called by: SRFldVal                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRReset       BEGSR
      *
     C                   CALL      'ZA0250'
      *
      ** Reset Error Indicator
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN83 = *OFF
     C                   EVAL      *IN84 = *OFF
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
      *  SRChkAut - Validate Authorization Of User                    *
      *                                                               *
      *  Called by:  MAIN Processing                                  *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
     C     SRChkAut      BEGSR
      *
      ** Check Whether The User Is Authorized For The Selected
      ** Operation
      *
     C                   IF        BJSBRC <> *BLANKS
      *
      ** Single Branching
     C                   CALL      'ZVACTU'
     C                   PARM                    POpt
     C                   PARM      *ZEROS        PErr
      *
     C                   IF        PErr = 1
     C                   EVAL      WMsgId = 'USR4436'
     C                   EVAL      WIdx = WIdx +1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Multi Branching
     C                   CALL      'ZVACTBU'
     C                   PARM                    POpt
     C                   PARM      PBrc          PZbr
     C                   PARM      *ZEROS        PErr
      *
     C                   IF        PErr = 1
     C                   EVAL      WMsgId = 'CSF9008'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ELSEIF    PErr = 2
     C                   EVAL      WMsgId = 'USR4436'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
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
