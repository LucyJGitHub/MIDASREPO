     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Select Override Profile')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP000025S - Select Override Profile                          *
      *                                                               *
      *  Function:  This program displays the records from the        *
      *             Override Profiles file                            *
      *                                                               *
      *  Called By: GPAOOVPRR0 - Midas AO Override Profiles           *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG27504           Date 21Apr10               *
      *                 CSD086  *CREATE    Date 17Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27504 - Prevent GP000025S from locking LDA. Also pass     *
      *             the zone as parameters for GP000025S              *
      *  CSD086 - Overridable Errors                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *    80         No Data to Display                              *
      *    31         Clear Subfile(SFLCLR)                           *
      *    32         Message Subfile End (SFLEND)                    *
      *    30         SFLDSP                                          *
      *    33         SFLEND                                          *
      *    34         SFLNXTCHG                                       *
      *    35         Reverse Image                                   *
      *    27         RollUp                                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRProcess - Process the Subfile                               *
      * SRBldSfl  - Build the Subfile                                 *
      * SRLoadSfl - Load the Subfile                                  *
      * SRDspSfl  - Display the Subfile                               *
      * SRPrSfl   - Process the Subfile Functions                     *
      * SRClrSfl  - Clear the Subfile                                 *
      * SRErrDta  - Output Error Message With Data                    *
      * SRSnms    - Error Meesage for No selection                    *
      * *PSSR     - Error processing                                  *
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
      *
      ** Override Profiles
     FGPOVPRL0  IF   E           K DISK    INFSR(*PSSR)
     F
      *
      ** Select Override Profiles
     FGP000025S#CF   E             WORKSTN
     F                                     SFILE(GP000025S0:RRN0)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** Layout and the Following Named Constants:
      ** True       Logical = *ON (For Indcator Processing)
      ** False      Logical = *OFF (For Indcator Processing)
      ** DBErrCtl   10A     = 'DBERRCTL' (The Name Of The Database
      **                       Error Handler)
      ** and the Following Variables:
      ** RunBefore  1A (For The PSSR)
      *
     D/COPY GPCPYSRCG,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY GPCPYSRCG,PSDS
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D SflPag          C                   CONST(14)
     D Select          C                   CONST('1')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D GZSDBANK      E DS                  EXTNAME(GZSDBANKPD)
 
      ** Indicator Data Structure
     D Indicators      DS                  BASED(IndPointer)
     D  Exit                  03     03
     D  RollUp                27     27
     D  SflDsp                30     30
     D  SflClr                31     31
     D  SflEnd                33     33
     D  NoData                80     80
     D  ActnErr               35     35
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D IndPointer      S               *   INZ(%ADDR(*IN))
     D RRN0            S              4S 0
     D WLstRrn         S              4S 0
     D WError          S              1A   INZ('N')
     D WCtr            S              2S 0
     D WRun            S              1A
     D WIdx            S              3P 0
     D WCCod           S                   LIKE(DOVPRS)
 
      ** Entry Parameters
     D PRetCode        S              7A
     D PKeyfld         S             10A
 
      ** Parameter for 'AOBANKR0'
     D PRtCd           S              7A
     D POptn           S              7A
     D PZone           S             10A
     D PErms           S             50A
     D PCache          S              1A
     D PRecImage       S          32000A
 
      ** Parameter for ZA0350
     D PZMsgFile       S             10A
     D PZMsgId         S             10A
     D PZMsgData       S             45A
      *
      ** Parameters for Y2SNMGC
     D PZAPgm          S             10A
     D PZAPgrl         S              5A
     D PZAMsid         S              7A
     D PZAMsgf         S             10A
     D PZAMsda         S            132A
     D PZAMstp         S              7A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *********************************************************************
      ** MAIN PROCEDURE                                                   *
      *********************************************************************
 
      ** Build the subfile
     C                   EXSR      SRBldSfl
 
      ** Display the screen until F3 is pressed
     C                   DOW       (EXIT = *OFF)
 
      ** Display And Process the Subfile
     C                   EXSR      SRDspSfl
 
      ** Process the Subfile
     C                   EXSR      SRProcess
 
     C                   ENDDO
 
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
      *
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRetCode
     C                   PARM                    PKeyfld
     C                   PARM                    PZone                                      BUG27504
 
     C                   CALL      'GPACSZBNK'
 
      ** Input
 
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      *BLANKS       PErms
     C                   PARM                    PZone
     C                   PARM      'N'           PCache
 
      ** Output
 
     C     GZSDBANK      PARM                    PRecImage
 
     C                   IF        PRtCd <> *BLANKS
     C******LOCK         IN        LDA                                                      BUG27504
     C                   EVAL      DBPGM = 'GPACSZBNK'
     C                   EVAL      DBFILE = 'GZSDBANKPD'
     C                   EVAL      DBKEY = PRtcd
     C                   EVAL      DBASE = 1
     C**********         OUT       LDA                                                      BUG27504
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
      ** Populate WorkStation ID
     C                   EVAL      DWSID = PSJobName
 
      ** Populate User
     C                   EVAL      DUSER = PSUser
 
      ** Populate Midas Run Date
     C                   EVAL      DMRDT = BJMRDT
 
      ** Initialise Subfile Program Queue and Message File
     C                   EVAL      D1PGMQ = '*'
     C                   EVAL      PZMsgFile = 'GBSDUSRMSG'
 
      ** Message Subfile Indicator
     C                   EVAL      *IN32 = *ON
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Build the Subfile                                 *
      *                                                               *
      *  Called by: MAIN Processing, SRProcess                        *
      *                                                               *
      *  Calls: SRClrSfl, SRLoadSfl                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRBldSfl      BEGSR
 
      ** Clear the Subfile
     C                   EXSR      SRClrSfl
 
      ** Load the Subfile
     C                   EXSR      SRLoadSfl
 
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
 
     C                   TIME                    DTIME
 
      ** Write the Footer (Command Keys)
     C                   WRITE     GP000025F0
 
      ** Write the Message Subfile Control Format
     C                   WRITE     GP000025C1
 
      ** Display the Subfile
     C                   EXFMT     GP000025C0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRBldSfl, SRLoadSfl, SRPrSfl, SRsnms                  *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Reset the Program Message Queue
     C                   CALL      'ZA0250'
 
     C                   EVAL      WIdx = 0
 
     C                   IF        DOVPRS = *BLANKS
     C                   EVAL      WCCod = *BLANKS
     C                   ENDIF
 
     C                   SELECT
 
      ** When F3 Is Pressed
     C                   WHEN      Exit = *ON
 
     C                   EXSR      SRSnms
     C                   MOVEL     'Y2U0016'     PRetcode
 
     C                   LEAVESR
 
      ** When Page Down Is Pressed
     C                   WHEN      RollUp = *ON
 
      ** Load the Next Page
     C                   EXSR      SRLoadSfl
 
      ** When an Override Profile is entered
     C                   WHEN      (DOVPRS <> *BLANKS)
 
     C                   EXSR      SRPrSfl
 
     C                   IF        WError = 'N'
     C                   EVAL      WCCod = DOVPRS
 
      ** Build the Subfile With the Selection Criteria
     C                   EXSR      SRBldSfl
     C                   ENDIF
 
     C                   OTHER
 
     C                   EXSR      SRPrSfl
 
     C                   ENDSL
 
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
 
      ** Set Pointer to First Record of Database
     C     *LOVAL        SETLL     GPOVPRL0
 
      ** Intialise Fields
     C                   EVAL      WError = 'N'
     C                   EVAL      RRN0 = *ZEROS
     C                   EVAL      DSFRC = RRN0
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      DOPTN = *BLANKS
     C                   EVAL      NoData = *OFF
     C                   EVAL      ActnErr = *OFF
     C                   EVAL      SflClr = *ON
     C                   EVAL      SflEnd = *OFF
 
     C                   WRITE     GP000025C0
 
     C                   EVAL      SflClr = *OFF
 
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
      ** If Relative Record Number of the last record loaded in the
      ** subfile is greater than zero
      *
     C                   IF        WLstRrn > *ZEROS
 
     C                   EVAL      RRN0 = WLstRrn
     C                   EVAL      WLstRrn = DSFRC
 
     C                   ENDIF
 
      ** If position field - Override Profile is not blank,
      ** set the pointer to the entered Override Profile
 
     C                   IF        (DOVPRS <> *BLANKS) AND
     C                             RollUp = *OFF AND
     C                             NOT %EOF(GPOVPRL0)
 
     C     DOVPRS        SETLL     GPOVPRL0
 
     C                   ENDIF
 
      ** Reset counter
     C                   EVAL      WCtr = 0
 
      ** Load records to Subfile
     C                   DOW       WCtr < SflPag AND
     C                             NOT %EOF(GPOVPRL0)
 
     C                   READ      GPOVPRL0
 
     C                   IF        NOT %EOF(GPOVPRL0)
 
     C                   EVAL      DOVPR = A1OVPR
     C                   EVAL      DDESC = A1DESC
     C                   EVAL      DFRPT = A1FORC
 
     C                   EVAL      RRN0 = RRN0 + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      DSFRC = RRN0
     C                   EVAL      DOPTN = *BLANKS
     C                   EVAL      *IN35 = *OFF
     C                   WRITE     GP000025S0
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      WLstRrn = DSFRC
 
      ** IF Last Record, turn on the 'SFLEND' indicator
     C                   READ      GPOVPRL0
     C                   IF        %EOF(GPOVPRL0)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   READP     GPOVPRL0
     C                   EVAL      SflEnd = *OFF
     C                   ENDIF
 
      ** Check if records were written into the subfile
     C                   IF        WLstRrn <> *ZEROS
     C                   EVAL      SflDsp = *ON
     C                   ELSE
 
      ** If No Records exist, show 'No Data to Display' message
     C                   EVAL      SflDsp = *OFF
     C                   EVAL      NoData = *ON
     C                   EVAL      PZMsgId = 'ASM0001'
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrSfl - Process the Subfile                                *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRPrSfl       BEGSR
      *
     C                   IF        WLstRrn > *ZEROS
 
      ** Reset Error Flag
     C                   READC     GP000025S0
     C                   DOW       NOT %EOF
 
     C                   EVAL      WIdx = *ZEROS
 
      ** Validation for Invalid Action Code
     C                   IF        (DOPTN <> Select) AND
     C                             (DOPTN <> *BLANKS)
 
     C                   EVAL      PZMsgId = 'USR9173'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   EVAL      ActnErr = *ON
 
     C                   EVAL      *IN34 = *ON
     C                   UPDATE    GP000025S0
 
     C                   ELSEIF    (DOPTN = Select)
 
     C                   EVAL      ActnErr = *ON
     C                   EVAL      PKeyfld = DOVPR
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDIF
 
     C                   READC     GP000025S0
 
     C                   ENDDO
 
     C                   EVAL      *IN34 = *OFF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrDta - Output Error Message With Data                    *
      *                                                               *
      *  Called by: SRChkAut, SRPrSfl, SRloadSfl                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRErrDta      BEGSR
 
     C                   CALL      'ZA0350'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgId
     C                   PARM      *BLANKS       PZMsgData
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSnms - Send error message to program message Queue         *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSnms        BEGSR
 
      ** Send message '*No value selected'
     C                   MOVEL     'Y2U0016'     PZAMsid
     C                   MOVEL     'Y2USRMSG'    PZAMsgf
     C                   MOVEL     '*PRV '       PZAPgrl
 
     C                   CALL      'Y2SNMGC'
     C                   PARM      'GP000025S'   PZAPgm
     C                   PARM                    PZAPgrl
     C                   PARM                    PZAMsid
     C                   PARM                    PZAMsgf
     C                   PARM                    PZAMsda
     C                   PARM                    PZAMstp
 
      ** Clear all fields for default mechanism next time.
     C                   EVAL      PZAPgm = *BLANKS
     C                   EVAL      PZAPgrl = *BLANKS
     C                   EVAL      PZAMsid = *BLANKS
     C                   EVAL      PZAMsgf = *BLANKS
 
     C                   ENDSR
 
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
      *
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
 
     C                   EVAL      WRun = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
