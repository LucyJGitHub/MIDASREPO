     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL CRS Reports Management - Exception')          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000765 - Midas GL CRS Reports Management - Exception       *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD041618           Date 22Sep16               *
      *  Prev Amend No. MD040841           Date 26Aug16               *
      *                 CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041618 - Remark field is not updated when selecting the    *
      *             same customer to include                          *
      *  MD040841 - CRS Reports Screenflow for Actions Exclude, Cor-  *
      *             rect and Include should be adjusted               *
      *  CGL177 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03 - Exit                                                  *
      *    05 - Refresh                                               *
      *    12 - Previous                                              *
      *    30 - Subfile display                                       *
      *    31 - Subfile clear                                         *
      *    32 - Subfile message end                                   *
      *    33 - Error indicator                                       *
      *    34 - End of file or read not equal                         *
      *    36 - Subfile end                                           *
      *    50 - Subfile display                                       *
      *    55 - Subfile message end                                   *
      *    56 - Subfile end                                           *
      *    68 - Rollup indicator for exception detail list            *
      *    77 - List of exception or remarks                          *
      *    78 - Footer indicator for Enquire mode or Insert mode      *
      *    98 - Rollup indicator                                      *
      *    99 - End of file reports management                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR       - Initialise                                    *
      *  *PSSR        - Error processing                              *
      *  SrIntVar     - Initialize variables                          *
      *  SrLstExcp    - Main processing for list of Cust/Naho under   *
      *                 exception management                          *
      *  SrLoadSflX   - Load subfile from GLRMDTPD file               *
      *  SrProcessX   - Process the subfile                           *
      *  SrBldSflX    - Build the subfile                             *
      *  SrDspSflX    - Display the subfile                           *
      *  SrEmpSflX    - Display empty subfile                         *
      *  SrResetX     - Reset the fields                              *
      *  SrClrSflX    - Clear the subfile                             *
      *  SrPrSflX     - Process the subfile functions                 *
      *  SrErrDtaX    - Output error message with data                *
      *  SrInitSfl    - Initialise exception detail list              *
      *  SrCSprocX    - Customer processing                           *
      *  SrNHprocX    - Non-account holder processing                 *
      *  SrWrtDrvX    - Write a record into the table                 *
      *  SrDetProX    - Display exception detail list                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas GL List of Cust/Naho Under Exception Management Subfile
     FGL000765DFCF   E             WORKSTN SFILE(GL000765S0:Rrn0)
     F                                     SFILE(GL000765S1:Rrn1)
     F                                     INFDS(ScnDS)

      ** Customer Details File
     FSDCRSHL0  IF   E           K DISK    INFSR(*PSSR)

      ** Non-Account Holders File
     FSDCRNHL0  IF   E           K DISK    INFSR(*PSSR)

      ** SD Exception Management Detail
     FSDEXMAL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL Excluded Account Records File
     FGLCRMIL0  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The Following /COPY Line Includes The LDA Layout,
      ** And The Following Named Constants:
      **    True       Logical = *ON (For Indcator Processing)
      **    False      Logical = *OFF (For Indcator Processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (The Name Of The Database
      **                         Error Handler)
      ** And The Following Variables:
      **    RunBefore  1A (For The PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The Following /COPY Line Includes All The Defined Fields In
      ** the PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Data Structures used by Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS Based On SDCUSTPD
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS Based On SDNAHOPD
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)

      ** DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Customer/Non-Account Holder Inclusion Array
     D ArIncCsNh                    278A   DIM(50)
     D  ArCsNhFl                      1A   OVERLAY(ArIncCsNh:1)
     D  ArCusNah                     10A   OVERLAY(ArIncCsNh:2)
     D  ArCsNhMi                    256A   OVERLAY(ArIncCsNh:12)
     D  ArInclude                    11A   OVERLAY(ArIncCsNh:1)

     D ArIncCsNhO      S            278A   DIM(50)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D ExcpLst         C                   CONST('ABCDEFGHIJKLMNOPQRS+
     D                                            TUVWXYZ')
     D SflPag          C                   CONST(13)
     D EnterKey        C                   CONST(X'F1')

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

     D Exit            S              1A   INZ(*OFF)
     D NoData          S              1A   INZ(*OFF)
     D Result          S             80A   VARYING
     D PKeyST          S              7A
     D DDCTRY          S             60A

      ** Parameter  entry
     D PActMode        S              1A
     D PMsgRId         S             21A
     D PDDocTp         S              7A
     D PDRtyp          S             18A
     D PDRyer          S              4A
     D PFuncKey        S              3A

      ** Parameters AOBANKR0
     D POptn           S              7A
     D PRtcd           S              7A

      ** Parameter For ZA0350
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgId          S             10A
     D PMsgData        S             45A

      ** Working variables
     D WExidC          S              1A
     D KExma           S              1A
     D WExma2          S              1A
     D WfdCsnh         S             10A
     D WfdRpnm         S             20A
     D WfdRptn         S             10A
     D WfdExlt         S             60A
     D WfdExid         S             30A
     D WfdFile         S              1A
     D WfdRmrk         S            256A
     D WfdInEx         S              1A
     D WfdUser         S             10A
     D WfdTmst         S             26A
     D WSelectCS       S              1A
     D WSelectCR       S              1A
     D WSelectCT       S              1A
     D WSelectEX       S              1A
     D WError          S              1A   INZ('N')
     D DxExid          S             30A
     D WStart          S              5  0
     D CtrExm          S              5  0
     D CtrLen          S              5  0 INZ(2)
     D WsFound         S              1A
     D WsCTRY          S              2A

     D WLstRrn         S              4S 0
     D XstrPos         S              3S 0
     D XPosition       S              3S 0
     D XLength         S              3S 0
     D Rrn0            S              4S 0
     D Rrn1            S              4S 0
     D EndPtr          S              4S 0
     D CurPtr          S              4S 0
     D Indx            S              4S 0
     D Indy            S              4S 0                                                  MD041618
     D AIx             S              4S 0 INZ(0)
     D WCtr            S              2S 0
     D WCnt            S              3S 0
     D XPos            S              2S 0
     D PResult         S              3P 0
     D WIdx            S              3P 0
     D WExidN          S              2P 0
     D WStr            S              3P 0 INZ(1)                                           MD040841

      ** Parameter For QCLSCAN
     D PStart          S              3P 0 INZ(1)
     D PLenCsnh        S              3P 0
     D PLenCsrn        S              3P 0
     D PLenCsrt        S              3P 0
     D PLenExlt        S              3P 0
     D PLenDdCsnh      S              3P 0
     D PLenDdRpnm      S              3P 0
     D PLenDdRptn      S              3P 0
     D PLenDdExlt      S              3P 0
     D PTranslate      S              1A   INZ('1')
     D PTrim           S              1A   INZ('1')
     D PWild           S              1A   INZ('?')

     D WFcs            S                   LIKE(DDCSNH)
     D WFrp            S                   LIKE(DDRPNM)
     D WFrt            S                   LIKE(DDRPTN)
     D WFex            S                   LIKE(DDEXLT)

     D ScnDS           DS
     D  PressKey             369    369

      ** Exception Description array
     D WExDesc         S             64A   DIM(3)

      ** Excldue Remark array
     D WExRmrk         S             64A   DIM(4)

      ** List of Customer/Non-Account Holder under Exception Management
     D LstCsnh         DS                  QUALIFIED DIM(9999) INZ
     D  ExCsnh                       10A
     D  ExRpnm                       20A
     D  ExRptn                       10A
     D  ExExlt                       60A
     D  ExExid                       30A
     D  ExFile                        1A
     D  ExInEx                        1A
     D  ExUser                       10A
     D  ExTmst                       26A
     D  ExRmrk                      256A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      *                                                               *
      * MAIN PROCEDURE                                                *
      *                                                               *
      *****************************************************************

      ** Customers/Non-Account Holders list under Exception Management

     C                   EXSR      SrLstExcp

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLstExcp - Main processing for List of CUST/NAHO Under       *
      *             Exception Management                              *
      *                                                               *
      * Called by:  Main processing                                   *
      *                                                               *
      * Calls:      SrLoadDrvX, SrBldSflX,SrDspSflX,SrProcessX        *
      *                                                               *
      *****************************************************************
     C     SrLstExcp     BEGSR

      ** Load data read in Report Management file

     C                   EXSR      SrLoadDrvX

     C                   IF        *IN99 = *OFF
     C                   EXSR      SrEmpSflX
     C                   ELSE

      ** Buid the Subfile

     C                   EXSR      SrBldSflX
     C                   ENDIF

      ** Display the screen until F3 or F12 is pressed

     C                   DOW       (Exit = *OFF)

      ** Display and process the subfile

     C                   EXSR      SrDspSflX

      ** Process the subfile

     C                   EXSR      SrProcessX

      ** When F16 is pressed

     C                   IF        *IN16 = *ON
     C                   EVAL      PFuncKey = 'F12'
     C                   EVAL      EXIT = *ON
     C                   ENDIF

      ** When F20 is pressed, Account Report screen

     C                   IF        *IN20 = *ON
     C                   EVAL      PFuncKey = 'F20'
     C                   EVAL      EXIT = *ON
     C                   ENDIF

     C                   ENDDO

     C                   IF        *IN03 = *ON
     C                   EVAL      PFuncKey = 'F3 '
     C                   ENDIF

     C                   EVAL      ArIncCsNhO = ArIncCsNh

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoadDrvX   - Load CUST/NAHO under Exception Mngmt file      *
      *                                                               *
      * Called by:   SrLstExcp                                        *
      *                                                               *
      * Calls:       SrCSprocX, SrNHprocX                             *
      *                                                               *
      *****************************************************************
     C     SrLoadDrvX    BEGSR

     C                   MOVEA     ArIncCsNhO    ArIncCsNh                                  MD041618
                                                                                            MD041618
      ** Perform read to check for empty file

     C     PMsgrID       SETLL     GLCRMIL0                               99

      ** Continue processing records if file is not empty

     C                   IF        *IN99 = *ON

     C                   EVAL      EndPtr = 1

     C     PMsgrID       READE     GLCRMIL0
     C                   DOW       NOT %EOF(GLCRMIL0)

     C                   SELECT

     C                   WHEN      IECNFL = 'C'
     C                   IF        IEINEX <> 'I'
     C                   EXSR      SrCSprocX
     C                   ENDIF

     C                   WHEN      IECNFL = 'N'
     C                   IF        IEINEX <> 'I'
     C                   EXSR      SrNHprocX
     C                   ENDIF

     C                   ENDSL

     C     PMsgrID       READE     GLCRMIL0
     C                   ENDDO

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCSprocX    - Load customer records                          *
      *                                                               *
      * Called by:   SrLoadDrvX                                       *
      *                                                               *
      * Calls:       SrWrtDrvX                                        *
      *                                                               *
      *****************************************************************
     C     SrCSprocX     BEGSR

     C                   EVAL      WfdCsnh = IECREF

     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WfdCsnh
     C                   PARM      *BLANKS       PKeyST
     C     SDCUST        PARM      SDCUST        DSSDY

      ** Database error processing

     C                   IF        Prtcd <> *BLANKS
     C                             AND Prtcd <> '*CUSDEL'
     C                             AND Prtcd <> '*CUSCLS'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = WfdCsnh
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   OUT       LDA

     C                   ELSE

     C                   IF        Prtcd = '*CUSDEL'
     C                             OR Prtcd = '*CUSCLS'
     C                   ELSE
     C                   EVAL      WfdRpnm = BBCRNM
     C                   EVAL      WfdRptn = BBCRTN

     C     BBCUST        CHAIN     SDCRSHL0

     C                   IF        %FOUND(SDCRSHL0)
     C                   EVAL      Result = *BLANKS

      ** Check if exception ID is present

     C                   IF        CREXMI <> *BLANKS
     C                             AND IEINEX <> 'O'
     C                   EVAL      WExidC = *BLANKS
     C                   EVAL      XstrPos = 1
     C                   EVAL      XLength = 1

      ** Read through exception ID string

     C                   DOW       XstrPos <= 30

     C                   EVAL      WExidC=%TRIM(%SUBST(CREXMI:XstrPos:XLength))
     C                   EVAL      WExidN=%SCAN(WExidC:ExcpLst)

     C                   IF        WExidN = 0
     C                   LEAVE
     C                   ENDIF

      ** Convert character exception ID to numeric counterpart

     C                   IF        XstrPos = 1
     C                   EVAL      Result=%CHAR(WExidN)
     C                   ELSE
     C                   EVAL      Result=%REPLACE(', '+
     C                             %CHAR(WExidN): Result: %LEN(Result)+1:0)
     C                   ENDIF

      ** Increment pointer position of string

     C                   EVAL      XstrPos = XstrPos + 1
     C                   ENDDO

     C                   EVAL      WfdExlt = Result
     C                   EVAL      WfdExid = CREXMI
     C                   EVAL      WfdInEx = IEINEX
     C                   EVAL      WfdRmrk = *BLANKS
     C                   EVAL      WfdUser = *BLANKS
     C                   EVAL      WfdTmst = *BLANKS
     C                   ENDIF

     C                   IF        IEINEX = 'O'
     C                   EVAL      WfdExlt = 'Manually excluded from '
     C                                       + 'report'
     C                   EVAL      WfdExid = *BLANKS
     C                   EVAL      WfdInEx = 'O'
     C                   EVAL      WfdRmrk = IERMRK
     C                   EVAL      WfdUser = IEUSER
     C                   EVAL      WfdTmst = IETMST
     C                   ENDIF

     C                   IF        CREXMI = *BLANKS
     C                             AND IEINEX <> 'O'
     C                   EVAL      WfdExlt = *BLANKS
     C                   EVAL      WfdExid = CREXMI
     C                   EVAL      WfdInEx = IEINEX
     C                   EVAL      WfdRmrk = *BLANKS
     C                   EVAL      WfdUser = *BLANKS
     C                   EVAL      WfdTmst = *BLANKS
     C                   ENDIF

     C                   EVAL      WfdFile = IECNFL
     C                   ENDIF

      ** Write to lookup table

     C                   EXSR      SrWrtDrvX
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrNHprocX    - Load non-account holder records                *
      *                                                               *
      * Called by:     SrLoadDrvX                                     *
      *                                                               *
      * Calls:         SrWrtDrvX                                      *
      *                                                               *
      *****************************************************************
     C     SrNHprocX     BEGSR

     C                   EVAL      WfdCsnh = IECREF

     C                   CALLB     'AONAHOR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WfdCsnh
     C     SDNAHO        PARM      SDNAHO        DSSDY

      ** Database error processing

     C                   IF        Prtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBKEY = WfdCsnh
     C                   EVAL      DBASE = 003
     C                   EXSR      *PSSR
     C                   OUT       LDA

     C                   ELSE
     C                   EVAL      WfdRpnm = NHNARN
     C                   EVAL      WfdRptn = NHNATW

      ** Insert exception list processing before write to table

     C     NHNAHO        CHAIN     SDCRNHL0

     C                   IF        %FOUND(SDCRNHL0)
     C                   EVAL      Result = *BLANKS

      ** Check if exception ID is present

     C                   IF        NREXMI <> *BLANKS
     C                             AND IEINEX <> 'O'
     C                   EVAL      WExidC = *BLANKS
     C                   EVAL      XstrPos = 1
     C                   EVAL      XLength = 1

      ** Read through exception ID string

     C                   DOW       XstrPos <= 30

     C                   EVAL      WExidC=%TRIM(%SUBST(NREXMI:XstrPos:XLength))
     C                   EVAL      WExidN=%SCAN(WExidC:ExcpLst)

     C                   IF        WExidN = 0
     C                   LEAVE
     C                   ENDIF

      ** Convert character exception ID to numeric counterpart

     C                   IF        XstrPos = 1
     C                   EVAL      Result=%CHAR(WExidN)
     C                   ELSE
     C                   EVAL      Result=%REPLACE(', '+
     C                             %CHAR(WExidN): Result: %LEN(Result)+1:0)
     C                   ENDIF

      ** Increment pointer position of string

     C                   EVAL      XstrPos = XstrPos + 1
     C                   ENDDO

     C                   EVAL      WfdExlt = Result
     C                   EVAL      WfdExid = NREXMI
     C                   EVAL      WfdInEx = IEINEX
     C                   EVAL      WfdRmrk = *BLANKS
     C                   EVAL      WfdUser = *BLANKS
     C                   EVAL      WfdTmst = *BLANKS
     C                   ENDIF

     C                   IF        IEINEX = 'O'
     C                   EVAL      WfdExlt = 'Manually excluded from '
     C                                       + 'report'
     C                   EVAL      WfdExid = *BLANKS
     C                   EVAL      WfdInEx = 'O'
     C                   EVAL      WfdRmrk = IERMRK
     C                   EVAL      WfdUser = IEUSER
     C                   EVAL      WfdTmst = IETMST
     C                   ENDIF

     C                   IF        NREXMI <> *BLANKS
     C                             AND IEINEX <> 'O'
     C                   EVAL      WfdExlt = *BLANKS
     C                   EVAL      WfdExid = NREXMI
     C                   EVAL      WfdInEx = IEINEX
     C                   EVAL      WfdRmrk = *BLANKS
     C                   EVAL      WfdUser = *BLANKS
     C                   EVAL      WfdTmst = *BLANKS
     C                   ENDIF

     C                   EVAL      WfdFile = IECNFL
     C                   ENDIF

     C                   EXSR      SrWrtDrvX
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcessX     - Main processing of subfile                   *
      *                                                               *
      * Called by:       SrLstExcp                                    *
      *                                                               *
      * Calls:           SrResetX, SrBldSflX, SrLoadSflX, SrPrSflX    *
      *                                                               *
      *****************************************************************
     C     SrProcessX    BEGSR

      ** Reset the fields and the program message queue

     C                   EXSR      SrResetX

     C                   IF        DDCSNS = *BLANKS
     C                   EVAL      WFcs = *BLANKS
     C                   ENDIF

     C                   IF        DDRPNS = *BLANKS
     C                   EVAL      WFrp = *BLANKS
     C                   ENDIF

     C                   IF        DDRPTS = *BLANKS
     C                   EVAL      WFrt = *BLANKS
     C                   ENDIF

     C                   IF        DDEXLS = *BLANKS
     C                   EVAL      WFex = *BLANKS
     C                   ENDIF

     C                   SELECT

      ** When F3 is pressed

     C                   WHEN      *IN03 = *ON
     C                   EVAL      PFuncKey = 'F3'
     C                   EVAL      EXIT = *ON
     C                   LEAVESR

      ** When F5 is pressed

     C                   WHEN      *IN05 = *ON
     C                   EXSR      SrResetX
     C                   EXSR      SrBldSflX

      ** When page down is pressed

     C                   WHEN      *IN98 = *ON
     C                   EXSR      SrLoadSflX

      ** When selection filters are not changed and valid options
      ** are entered on the screen, process the subfile

     C                   WHEN      (DDCSNS = WFcs)
     C                             AND (DDRPNS = WFrp)
     C                             AND (DDRPTS = WFrt)
     C                             AND (DDEXLS = WFex)

     C                   EXSR      SrPrSflX

     C                   IF        WError <> 'Y'

      ** Clear the programn message queue and the fields

     C                   EXSR      SrResetX


      ** Check if enter key is pressed and no data to display

     C                   IF        PressKey = EnterKey
     C                             AND NoData = *ON
     C                   EVAL      EXIT = *ON
     C                   LEAVESR
     C                   ELSE

      ** Build the subfile

     C                   EXSR      SrBldSflX
     C                   ENDIF

     C                   ENDIF

      ** When selection filters are entered

     C                   WHEN      (DDCSNS <> *BLANKS)
     C                             OR (DDRPNS <> *BLANKS)
     C                             OR (DDRPTS <> *BLANKS)
     C                             OR (DDEXLS <> *BLANKS)

     C                   EXSR      SrPrSflX

     C                   IF        WError = 'N'
     C                   EVAL      WFcs = DDCSNS
     C                   EVAL      WFrp = DDRPNS
     C                   EVAL      WFrp = DDRPTS
     C                   EVAL      WFex = DDEXLS

      ** Build the subfile with the selection criteria (filters)

     C                   EXSR      SrBldSflX

     C                   ENDIF

     C                   OTHER

      ** Process the subfile

     C                   EXSR      SrPrSflX

     C                   IF        WError <> 'Y'
     C                   EXSR      SrResetX
     C                   EXSR      SrBldSflX
     C                   ENDIF

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWrtDrvX  - Write a record into the lookup table             *
      *                                                               *
      * Called by:   SrCSprocX, SrNHprocX                             *
      *                                                               *
      * Calls:       None                                             *
      *                                                               *
      *****************************************************************
     C     SrWrtDrvX     BEGSR

     C                   EVAL      LstCsnh(EndPtr).ExCsnh = WfdCsnh
     C                   EVAL      LstCsnh(EndPtr).ExRpnm = WfdRpnm
     C                   EVAL      LstCsnh(EndPtr).ExRptn = WfdRptn
     C                   EVAL      LstCsnh(EndPtr).ExExlt = WfdExlt
     C                   EVAL      LstCsnh(EndPtr).ExExid = WfdExid
     C                   EVAL      LstCsnh(EndPtr).ExFile = WfdFile
     C                   EVAL      LstCsnh(EndPtr).ExRmrk = WfdRmrk
     C                   EVAL      LstCsnh(EndPtr).ExInEx = WfdInEx
     C                   EVAL      LstCsnh(EndPtr).ExUser = WfdUser
     C                   EVAL      LstCsnh(EndPtr).ExTmst = WfdTmst
     C                   EVAL      EndPtr = EndPtr + 1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBldSflX    - Build the subfile                              *
      *                                                               *
      * Called by:     SrProcessX                                     *
      *                                                               *
      * Calls:         SrClrSflX, SrLoadSflX                          *
      *                                                               *
      *****************************************************************
     C     SrBldSflX     BEGSR

      ** Clear the subfile

     C                   EXSR      SrClrSflX

      ** Load the subfile

     C                   EXSR      SrLoadSflX

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoadSflX   - Load the subfile                               *
      *                                                               *
      * Called by:     SrBldSflX                                      *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SrLoadSflX    BEGSR

     C                   EVAL      WSelectCS = 'Y'
     C                   EVAL      WSelectCR = 'Y'
     C                   EVAL      WSelectCT = 'Y'
     C                   EVAL      WSelectEX = 'Y'

      ** If relative record number of the last record loaded in the
      ** subfile is greater than zero

     C                   IF        WLstRrn > *ZEROS
     C                   EVAL      Rrn0 = WLstRrn
     C                   EVAL      WLstRrn = DDSFRN
     C                   EVAL      CurPtr = CurPtr + 1
     C                   ENDIF

      ** Reset counter

     C                   EVAL      WCtr = 1

      ** Display the no of records that is specified in the SFLPAG

     C                   DOW       WCtr <= SflPag
     C                             AND CurPtr < EndPtr

     C                   IF        CurPtr = EndPtr + 1
     C                   LEAVE
     C                   ENDIF

     C                   IF        CurPtr < EndPtr
      *
     C                   IF        LstCsnh(CurPtr).ExInEx = 'I'
     C                   EVAL      CurPtr = CurPtr + 1
     C                   ENDIF

     C                   EVAL      DDCSNH = LstCsnh(CurPtr).ExCsnh
     C                   EVAL      DDRPNM = LstCsnh(CurPtr).ExRpnm
     C                   EVAL      DDRPTN = LstCsnh(CurPtr).ExRptn
     C                   EVAL      DDEXLT = LstCsnh(CurPtr).ExExlt

      ** Customer/Non-Account Holder not blanks

     C                   IF        DDCSNS <> *BLANKS

      ** Scan database field with the search argument

     C                   CALL      'QCLSCAN'
     C                   PARM                    DDCSNH
     C                   PARM      10            PLenCsnh
     C                   PARM                    PStart
     C                   PARM                    DDCSNS
     C                   PARM      10            PLenDDCSNH
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult

      ** If not present, blank out screen field

     C                   IF        PResult < 1
     C                   EVAL      WSelectCS = 'N'
     C                   ELSE
     C                   EVAL      WSelectCS = 'Y'
     C                   ENDIF

     C                   ENDIF

      ** Customer/Non-account holder report name is not blanks

     C                   IF        DDRPNS <> *BLANKS

      ** Scan database field with the search argument

     C                   CALL      'QCLSCAN'
     C                   PARM                    DDRPNM
     C                   PARM      20            PLenCsrn
     C                   PARM                    PStart
     C                   PARM                    DDRPNS
     C                   PARM      20            PLenDDRPNM
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult

      ** If not present, blank out screen field

     C                   IF        PResult < 1
     C                   EVAL      WSelectCR = 'N'
     C                   ELSE
     C                   EVAL      WSelectCR = 'Y'
     C                   ENDIF

     C                   ENDIF

      ** Customer/Non-account holder report town is not blanks

     C                   IF        DDRPTS <> *BLANKS

      ** Scan database field with the search argument

     C                   CALL      'QCLSCAN'
     C                   PARM                    DDRPTN
     C                   PARM      10            PLenCsrt
     C                   PARM                    PStart
     C                   PARM                    DDRPTS
     C                   PARM      10            PLenDDRPTN
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult

      ** If not present, blank out screen field

     C                   IF        PResult < 1
     C                   EVAL      WSelectCT = 'N'
     C                   ELSE
     C                   EVAL      WSelectCT = 'Y'
     C                   ENDIF

     C                   ENDIF

      ** Excemption list is not blanks

     C                   IF        DDEXLS <> *BLANKS

      ** Scan database field with the search argument

     C                   CALL      'QCLSCAN'
     C                   PARM                    DDEXLT
     C                   PARM      64            PLenExlt
     C                   PARM                    PStart
     C                   PARM                    DDEXLS
     C                   PARM      64            PLenDDEXLT
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult

      ** If not present, blank out screen field

     C                   IF        PResult < 1
     C                   EVAL      WSelectEX = 'N'
     C                   ELSE
     C                   EVAL      WSelectEX = 'Y'
     C                   ENDIF

     C                   ENDIF

      ** Write the selected records

     C                   IF        WSelectCS = 'Y'
     C                             AND WSelectCR = 'Y'
     C                             AND WSelectCT = 'Y'
     C                             AND WSelectEX = 'Y'

     C                   EVAL      Rrn0  = Rrn0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      DDSFRN = Rrn0
     C                   EVAL      DDACTN = *BLANKS
     C                   EVAL      *IN33 = *OFF
     C                   WRITE     GL000765S0
     C                   ENDIF

     C                   ENDIF

      ** Increment current pointer until end of file reached

     C                   EVAL      CurPtr = CurPtr + 1
     C                   ENDDO

     C                   EVAL      WLstRrn = DDSFRN

      ** Check for last record for switching on the SFLEND indicator

     C                   IF        CurPtr = EndPtr
     C                   EVAL      *IN36 = *ON
     C                   ELSE
     C                   EVAL      CurPtr = CurPtr - 1
     C                   EVAL      *IN36 = *OFF
     C                   ENDIF

      ** Check if records are written into subfile

     C                   IF        WLstRrn <> 0
     C                   EVAL      *IN30 = *ON
     C                   ELSE
     C                   EVAL      *IN30 = *OFF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDspSflX    - Display the subfile                            *
      *                                                               *
      * Called by:     SrLstExcp                                      *
      *                                                               *
      * Calls:         None                                           *
      *                                                               *
      *****************************************************************
     C     SrDspSflX     BEGSR

      ** Write the footer

     C                   WRITE     GL000765F0

      ** Display the subfile

     C                   EXFMT     GL000765C0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEmpSflX    - Display empty subfile if no data read          *
      *                                                               *
      * Called by:     SrLstExcp                                      *
      *                                                               *
      * Calls:         None                                           *
      *                                                               *
      *****************************************************************
     C     SrEmpSflX     BEGSR

     C                   EVAL      PMsgId = 'USR7530'
     C                   EXSR      SRErrDtaX
     C                   EVAL      *IN31 = *ON
     C                   WRITE     GL000765C0
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      Rrn0 = 1
     C                   EVAL      DDSFRN = 1
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      *IN40 = *ON
     C                   WRITE     GL000765M0
     C                   EVAL      NoData = *ON

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrResetX     - Reset the fields                               *
      *                                                               *
      * Called by:     SrProcessX                                     *
      *                                                               *
      * Calls:         None                                           *
      *                                                               *
      *****************************************************************
     C     SrResetX      BEGSR

      ** Clear program queue and message file

     C                   CALL      'ZA0250'
     C                   EVAL      WIdx = 0

     C                   IF        *IN05 = *ON

     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   WRITE     GL000765M0
     C                   EVAL      *IN41 = *OFF

     C                   EVAL      DDCSNS = *BLANKS
     C                   EVAL      DDRPNS = *BLANKS
     C                   EVAL      DDRPTS = *BLANKS
     C                   EVAL      DDEXLS = *BLANKS
     C                   EVAL      WFcs = *BLANKS
     C                   EVAL      WFrp = *BLANKS
     C                   EVAL      WFrt = *BLANKS
     C                   EVAL      WFex = *BLANKS
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrClrSflX    - Clear the subfile                              *
      *                                                               *
      * Called by:     SrBldSflX                                      *
      *                                                               *
      * Calls:         None                                           *
      *                                                               *
      *****************************************************************
     C     SrClrSflX     BEGSR

      ** Set pointer to first record of database

     C                   EVAL      CurPtr = 1
     C                   EVAL      WError = 'N'
     C                   EVAL      Rrn0  = *ZEROS
     C                   EVAL      DDSFRN = Rrn0
     C                   EVAL      WLstRrn = *ZEROS

     C                   EVAL      *IN41 = *ON
     C                   WRITE     GL000765M0
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN46 = *ON

     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN31 = *ON
     C                   WRITE     GL000765C0
     C                   EVAL      *IN31 = *OFF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPrSflX - Process the subfile functions                     *
      *                                                               *
      *  Called by: SrProcessX                                        *
      *                                                               *
      *  Calls:     SrErrDtaX, SrDetProX                              *
      *                                                               *
      *****************************************************************
     C     SrPrSflX      BEGSR

      ** Check for last relative record number

     C                   IF        WLstRrn > *ZEROS

      ** Reset error flag

     C                   EVAL      WError = 'N'

      ** Read input if there are changes in screen display

     C                   READC     GL000765S0

      ** Read input until end of file reached

     C                   DOW       NOT %EOF

     C                   EVAL      WIdx = *ZEROS

      ** Invalid action code

     C                   IF        (DDACTN <> '1')
     C                             AND (DDACTN <> *BLANKS)
     C                   EVAL      PMsgId = 'USR9358'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SrErrDtaX
     C                   ENDIF

      ** Invalid action code error message
     C                   IF        (DDACTN = '1')
     C                             AND (DDEXLT <> *BLANKS)
     C                             AND (DDEXLT <>
     C                                 'Manually excluded from report')
     C                             AND PActMode <> 'E'
     C                             AND PActMode <> 'I'
     C                             AND PActMode <> 'O'
     C                   EVAL      PMsgId = 'USS0516'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SrErrDtaX
     C                   ENDIF

     C                   IF        WIdx > *ZEROS
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      DDSFRN = Rrn0
     C                   EVAL      *IN40 = *ON
     C                   WRITE     GL000765M0

     C                   ELSE
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN41 = *ON
     C                   WRITE     GL000765M0
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN40 = *OFF
     C                   ENDIF

     C                   EVAL      *IN34 = *ON
     C                   UPDATE    GL000765S0
     C                   READC     GL000765S0

     C                   ENDDO

     C                   EVAL      *IN34 = *OFF

      ** If Error, stop processing further

     C                   IF        (WError = 'Y')
     C                   LEAVESR
     C                   ENDIF

     C                   READC     GL000765S0
     C                   DOW       NOT %EOF

     C                   IF        DDACTN = '1'
     C                   EXSR      SrDetProX

     C                   IF        *IN12 = *ON
     C                   EVAL      *IN12 = *OFF
     C                   ENDIF

     C                   EVAL      DDACTN = *BLANKS
     C                   UPDATE    GL000765S0
     C                   ENDIF

     C                   READC     GL000765S0
     C                   ENDDO

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDetProX  - Display details for Customer/Non-Account Holder *
      *               under Exception Management                      *
      *                                                               *
      *  Called by:   SrPrSflX                                        *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SrDetProX     BEGSR

     C                   EXSR      SrInitSfl
     C                   EVAL      DXCSNH = DDCSNH
     C                   EVAL      DXRPNM = DDRPNM
     C                   EVAL      DXRPTN = DDRPTN

      ** Search corresponding exception message ID in table

     C                   EVAL      Indx = 1

     C                   DOW       Indx <= EndPtr
     C                             AND DXCSNH <> LstCsnh(Indx).ExCsNh
     C                   EVAL      Indx = Indx + 1
     C                   ENDDO

      ** If Customer/Non-Account holder is found in table
      ** save exception message IDs

     C                   IF        DXCSNH = LstCsNh(Indx).ExCsNh
     C                   EVAL      DXUSER = LstCsNh(Indx).ExUser
     C                   EVAL      DXTMST = LstCsNh(Indx).ExTmst

     C                   IF        LstCsNh(Indx).ExInEx <> 'O'
     C                   EVAL      DXEXID = LstCsNh(Indx).ExExId
     C                   EVAL      *IN77 = *OFF
     C                   ELSE
     C                   EVAL      WfdRmrk = LstCsNh(Indx).ExRmrk
     C                   EVAL      *IN77 = *ON
     C                   ENDIF

     C                   ENDIF

     C                   DOW       XPos < 31
     C                             AND *IN68 = *ON

     C                   IF        LstCsNh(Indx).ExInEx <> 'O'
     C                   EVAL      Kexma = %SUBST(DxExid:XPos:1)
     C                   Z-ADD     1             DXSFRN

      ** If exception message ID is not blank

     C                   IF        Kexma <> ' '

      ** Search for matching exception message ID

     C     Kexma         CHAIN     SDEXMAL0

     C                   IF        %FOUND(SDEXMAL0)
     C                   EVAL      WCnt = WCnt + 1
     C                   EVAL      Rrn1 = Rrn1 + 1
     C                   MOVEA     *BLANKS       WExDesc
     C                   MOVEA     FEEXDE        WExDesc
     C                   MOVE      WExDesc(1)    DXEXMA
     C                   EVAL      *IN50 = *ON
     C                   WRITE     GL000765S1
     C                   EVAL      *IN50 = *OFF

      ** If message line 2 is not blank

     C                   IF        WExDesc(2) <> *BLANKS
     C                   MOVE      WExDesc(2)    DXEXMA
     C                   EVAL      WCnt = WCnt + 1
     C                   EVAL      Rrn1 = Rrn1 + 1
     C                   EVAL      *IN50 = *ON
     C                   WRITE     GL000765S1
     C                   EVAL      *IN50 = *OFF
     C                   ENDIF

      ** If message line 3 is not blank

     C                   IF        WExDesc(3) <> *BLANKS
     C                   MOVE      WExDesc(3)    DXEXMA
     C                   EVAL      WCnt = WCnt + 1
     C                   EVAL      Rrn1 = Rrn1 + 1
     C                   EVAL      *IN50 = *ON
     C                   WRITE     GL000765S1
     C                   EVAL      *IN50 = *OFF
     C                   ENDIF

      ** Check next ID if blanks, turn off pagedown

     C                   EVAL      Wexma2 = %SUBST(DxExid:XPos+1:1)

     C                   IF        Kexma <> Wexma2
     C                             AND Wexma2 <> ' '
     C                   EVAL      DXEXMA = ' '
     C                   EVAL      WCnt = WCnt + 1
     C                   EVAL      Rrn1 = Rrn1 + 1
     C                   EVAL      *IN50 = *ON
     C                   WRITE     GL000765S1
     C                   EVAL      *IN50 = *OFF
     C                   ENDIF

     C                   IF        Wexma2 = ' '
     C                   EVAL      DXEXMA = ' '
     C                   EVAL      WCnt = WCnt + 1
     C                   EVAL      Rrn1 = Rrn1 + 1
     C                   EVAL      *IN50 = *ON
     C                   WRITE     GL000765S1
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      *IN56 = *ON
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   IF        Kexma = ' '
     C                             OR Kexma <> ' '
     C                             AND PActMode = 'I'

      ** Set up footer toggle text and write the footer
      ** If there is no data to display, set on SFLCLR condition and
      ** write the subfile control record

     C                   IF        WCnt = 0 AND
     C                             Rrn1 = 0
     C                   EVAL      DXEXMA = ' '
     C                   Z-ADD     1             Rrn1
     C                   Z-ADD     1             DXSFRN
     C                   EVAL      *IN50 = *ON
     C                   WRITE     GL000765S1
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      *IN56 = *ON
     C                   ENDIF

      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required

      ** Manual Inclusion Remarks Input screen

     C                   IF        PActMode = 'I'
     C                   EVAL      *IN78 = *OFF
     C**********         EVAL      D2MIR1 = *BLANKS                                         MD040841
     C**********         EVAL      D2MIR2 = *BLANKS                                         MD040841
     C**********         EVAL      D2MIR3 = *BLANKS                                         MD040841
     C**********         EVAL      D2MIR4 = *BLANKS                                         MD040841
     C                   EVAL      WStr = %LOOKUP(DXCSNH:ARCUSNAH)                          MD040841
     C                   IF        WStr <> 0                                                MD040841
     C                   EVAL      D2MIR1 = %SUBST(ARCSNHMI(WStr):1:64)                     MD040841
     C                   EVAL      D2MIR2 = %SUBST(ARCSNHMI(WStr):65:64)                    MD040841
     C                   EVAL      D2MIR3 = %SUBST(ARCSNHMI(WStr):129:64)                   MD040841
     C                   EVAL      D2MIR4 = %SUBST(ARCSNHMI(WStr):193:64)                   MD040841
                                                                                            MD040841
     C                   EVAL      PMsgId = 'USS0691'                                       MD040841
     C                   EXSR      SrErrDtaX                                                MD040841
     C                   WRITE     GL000765C2                                               MD040841
     C                   EVAL      *IN40 = *ON                                              MD040841
     C                   WRITE     GL000765M0                                               MD040841
     C                   EVAL      *IN40 = *OFF                                             MD040841
                                                                                            MD040841
     C                   ELSE                                                               MD040841
     C                   EVAL      D2MIR1 = *BLANKS                                         MD040841
     C                   EVAL      D2MIR2 = *BLANKS                                         MD040841
     C                   EVAL      D2MIR3 = *BLANKS                                         MD040841
     C                   EVAL      D2MIR4 = *BLANKS                                         MD040841
     C                   ENDIF                                                              MD040841

     C     ReMIDspA      TAG
     C                   CALL      'ZA0250'
     C                   WRITE     GL000765F1
     C                   EXFMT     GL000765C2
     C                   EVAL      *IN42 = *OFF

      ** Return F3 function key variable if exit

     C                   IF        *IN03 = *ON
     C                   EVAL      PFuncKey = 'F3'
     C                   EVAL      EXIT = *ON
     C                   LEAVE
     C                   ENDIF

     C                   IF        *IN12 = *ON
     C                   CALL      'ZA0250'
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   WRITE     GL000765M0
     C                   EVAL      *IN41 = *OFF
     C                   LEAVE
     C                   ENDIF

     C                   IF        D2MIR1 = *BLANKS
     C                             AND D2MIR2 = *BLANKS
     C                             AND D2MIR3 = *BLANKS
     C                             AND D2MIR4 = *BLANKS
     C                   EVAL      PMsgId = 'USS0565'
     C                   EXSR      SrErrDtaX
     C                   EVAL      *IN42 = *ON
     C                   WRITE     GL000765C2
     C                   EVAL      *IN40 = *ON
     C                   WRITE     GL000765M0
     C                   EVAL      *IN40 = *OFF
     C                   GOTO      ReMIDspA
     C                   ENDIF

      ** Insert passing of remark inputs into the additional array
     C                   CALL      'ZA0250'
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   WRITE     GL000765M0
     C                   EVAL      *IN41 = *OFF

     C                   EVAL      *IN78 = *ON
     C                   ENDIF

     C                   WRITE     GL000765F1
     C                   EXFMT     GL000765C1

     C                   IF        *IN12 = *ON                                              MD040841
     C                             AND PActMode = 'I'                                       MD040841
     C                   GOTO      ReMIDspA                                                 MD040841
     C                   ENDIF                                                              MD040841

     C                   EVAL      DXEXMA = *BLANKS
      *                                                                                     MD040841
     C                   EVAL      *IN51 =*OFF                                              MD040841
     C                   EVAL      *IN52 =*OFF                                              MD040841
     C                   EVAL      *IN53 =*OFF                                              MD040841
     C                   IF        *IN03 <> *ON AND                                         MD040841
     C                             *IN12 <> *ON                                             MD040841
     C                   EVAL      *IN36 = *ON                                              MD040841
     C                   IF        PActMode = 'I' OR                                        MD040841
     C                             PActMode = 'C'                                           MD040841
     C                   IF        PActMode = 'O'                                           MD040841
     C                   EVAL      *IN51 =*ON                                               MD040841
     C                   ENDIF                                                              MD040841
     C                   IF        PActMode = 'I'                                           MD040841
     C                   EVAL      *IN52 =*ON                                               MD040841
     C                   ENDIF                                                              MD040841
     C                   IF        PActMode = 'C'                                           MD040841
     C                   EVAL      *IN53 =*ON                                               MD040841
     C                   ENDIF                                                              MD040841
     C                   WRITE     GL000765F2                                               MD040841
     C                   EVAL      *IN78 = *ON                                              MD040841
     C                   EXFMT     GL000765C1                                               MD040841
     C                   ENDIF                                                              MD040841
                                                                                            MD040841
     C                   IF        *IN12 = *ON                                              MD040841
     C                   LEAVE                                                              MD040841
     C                   ENDIF                                                              MD040841
     C                   ENDIF                                                              MD040841
     C                   ENDIF

     C                   ELSE
      ** Write remarks
     C                   Z-ADD     1             Rrn1
     C                   Z-ADD     1             DXSFRN

     C                   EVAL      DXEXMA = %SUBST(WfdRmrk:1:64)
     C                   EVAL      *IN50 = *ON
     C                   WRITE     GL000765S1
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      Rrn1 = Rrn1 + 1

     C                   EVAL      DXEXMA = %SUBST(WfdRmrk:65:64)
     C                   EVAL      *IN50 = *ON
     C                   WRITE     GL000765S1
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      Rrn1 = Rrn1 + 1

     C                   EVAL      DXEXMA = %SUBST(WfdRmrk:129:64)
     C                   EVAL      *IN50 = *ON
     C                   WRITE     GL000765S1
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      Rrn1 = Rrn1 + 1

     C                   EVAL      DXEXMA = %SUBST(WfdRmrk:193:64)
     C                   EVAL      *IN50 = *ON
     C                   WRITE     GL000765S1
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      Rrn1 = Rrn1 + 1

      ** Manual Inclusion Remarks Input screen

     C                   IF        PActMode = 'I'
     C                   EVAL      *IN78 = *OFF
     C**********         EVAL      D2MIR1 = *BLANKS                                         MD040841
     C**********         EVAL      D2MIR2 = *BLANKS                                         MD040841
     C**********         EVAL      D2MIR3 = *BLANKS                                         MD040841
     C**********         EVAL      D2MIR4 = *BLANKS                                         MD040841
     C                   EVAL      WStr = %LOOKUP(DXCSNH:ARCUSNAH)                          MD040841
     C                   IF        WStr <> 0                                                MD040841
     C                   EVAL      D2MIR1 = %SUBST(ARCSNHMI(WStr):1:64)                     MD040841
     C                   EVAL      D2MIR2 = %SUBST(ARCSNHMI(WStr):65:64)                    MD040841
     C                   EVAL      D2MIR3 = %SUBST(ARCSNHMI(WStr):129:64)                   MD040841
     C                   EVAL      D2MIR4 = %SUBST(ARCSNHMI(WStr):193:64)                   MD040841
                                                                                            MD040841
     C                   EVAL      PMsgId = 'USS0691'                                       MD040841
     C                   EXSR      SrErrDtaX                                                MD040841
     C                   WRITE     GL000765C2                                               MD040841
     C                   EVAL      *IN40 = *ON                                              MD040841
     C                   WRITE     GL000765M0                                               MD040841
     C                   EVAL      *IN40 = *OFF                                             MD040841
                                                                                            MD040841
     C                   ELSE                                                               MD040841
     C                   EVAL      D2MIR1 = *BLANKS                                         MD040841
     C                   EVAL      D2MIR2 = *BLANKS                                         MD040841
     C                   EVAL      D2MIR3 = *BLANKS                                         MD040841
     C                   EVAL      D2MIR4 = *BLANKS                                         MD040841
     C                   ENDIF                                                              MD040841

     C     ReMIDspB      TAG
     C                   CALL      'ZA0250'
     C                   WRITE     GL000765F1
     C                   EXFMT     GL000765C2
     C                   EVAL      *IN42 = *OFF

      ** Return F3 function key variable if exit

     C                   IF        *IN03 = *ON
     C                   EVAL      PFuncKey = 'F3'
     C                   EVAL      EXIT = *ON
     C                   LEAVE
     C                   ENDIF

     C                   IF        *IN12 = *ON
     C                   CALL      'ZA0250'
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   WRITE     GL000765M0
     C                   EVAL      *IN41 = *OFF
     C                   LEAVE
     C                   ENDIF

     C                   IF        D2MIR1 = *BLANKS
     C                             AND D2MIR2 = *BLANKS
     C                             AND D2MIR3 = *BLANKS
     C                             AND D2MIR4 = *BLANKS
     C                   EVAL      PMsgId = 'USS0565'
     C                   EXSR      SrErrDtaX
     C                   EVAL      *IN42 = *ON
     C                   WRITE     GL000765C2
     C                   EVAL      *IN40 = *ON
     C                   WRITE     GL000765M0
     C                   EVAL      *IN40 = *OFF
     C                   GOTO      ReMIDspB
     C                   ENDIF

      ** Insert passing of remark inputs into the additional array
     C                   CALL      'ZA0250'
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   WRITE     GL000765M0
     C                   EVAL      *IN41 = *OFF

     C                   EVAL      *IN78 = *ON
     C                   ENDIF

     C                   EVAL      *IN56 = *ON
     C                   WRITE     GL000765F1
     C                   EXFMT     GL000765C1
                                                                                            MD040841
     C                   IF        *IN12 = *ON                                              MD040841
     C                             AND PActMode = 'I'                                       MD040841
     C                   GOTO      ReMIDspB                                                 MD040841
     C                   ENDIF                                                              MD040841
                                                                                            MD040841
     C                   EVAL      DXEXMA = *BLANKS
      *                                                                                     MD040841
     C                   EVAL      *IN51 =*OFF                                              MD040841
     C                   EVAL      *IN52 =*OFF                                              MD040841
     C                   EVAL      *IN53 =*OFF                                              MD040841
     C                   IF        *IN03 <> *ON AND                                         MD040841
     C                             *IN12 <> *ON                                             MD040841
     C                   EVAL      *IN36 = *ON                                              MD040841
     C                   IF        PActMode = 'I' OR                                        MD040841
     C                             PActMode = 'C'                                           MD040841
     C                   IF        PActMode = 'O'                                           MD040841
     C                   EVAL      *IN51 =*ON                                               MD040841
     C                   ENDIF                                                              MD040841
     C                   IF        PActMode = 'I'                                           MD040841
     C                   EVAL      *IN52 =*ON                                               MD040841
     C                   ENDIF                                                              MD040841
     C                   IF        PActMode = 'C'                                           MD040841
     C                   EVAL      *IN53 =*ON                                               MD040841
     C                   ENDIF                                                              MD040841
     C                   WRITE     GL000765F2                                               MD040841
     C                   EVAL      *IN78 = *ON                                              MD040841
     C                   EXFMT     GL000765C1                                               MD040841
     C                   ENDIF                                                              MD040841
                                                                                            MD040841
     C                   IF        *IN12 = *ON                                              MD040841
     C                   LEAVE                                                              MD040841
     C                   ENDIF                                                              MD040841
     C                   ENDIF                                                              MD040841
     C                   ENDIF

      ** Return F3 function key variable if exit

     C                   IF        *IN03 = *ON
     C                   EVAL      PFuncKey = 'F3'
     C                   EVAL      EXIT = *ON
     C                   LEAVE
     C                   ENDIF

     C                   IF        *IN12 = *ON
     C                   LEAVE
     C                   ENDIF

     C                   IF        PressKey = EnterKey
     C                             AND PActMode <> 'E'
     C**********                   AND %LOOKUP(LstCsnh(Indx).ExCsNh:ArCusNah)=0             MD041618
                                                                                            MD041618
     C                   EVAL      Indy = %LOOKUP(LstCsnh(Indx).ExCsNh:ArCusNah)            MD041618
     C                   IF        Indy <> 0                                                MD041618
     C                   EVAL      ArCsNhMi(Indy) = D2MIR1 + D2MIR2 +                       MD041618
     C                             D2MIR3 + D2MIR4                                          MD041618
     C                   ELSE                                                               MD041618

      ** Save to Inclusion Array
     C                   EVAL      AIx = AIx + 1
     C                   EVAL      ArCusNah(AIx) = LstCsnh(Indx).ExCsNh
     C                   EVAL      ArCsNhFl(AIx) = LstCsnh(Indx).ExFile
     C                   EVAL      ArCsNhMi(AIx) = D2MIR1 + D2MIR2 +
     C                             D2MIR3 + D2MIR4
     C                   ENDIF                                                              MD041618
     C                   ENDIF

     C                   EVAL      XPos = XPos + 1
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrErrDtaX - Output error message with data                   *
      *                                                               *
      *  Called by:  SRPrSfl                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrErrDtaX     BEGSR

     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM                    PMsgData

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInitSfl - Initialise exception detail list                  *
      *                                                               *
      * Called by:  SrDetProX                                         *
      *                                                               *
      * Calls:      None                                              *
      *                                                               *
      *****************************************************************
     C     SrInitSfl     BEGSR

     C                   EVAL      *IN56 = *OFF

      ** Initialise subfile relative record number

     C                   Z-ADD     0             Rrn1

      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.

     C                   EVAL      *IN50 = *ON
     C                   WRITE     GL000765C1
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      WCnt = 0
     C                   EVAL      XPos = 1
     C                   EVAL      *IN68 = *ON

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Access Bank file to set system date, time, job       *
      *          and user in the screen header                        *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PActMode
     C                   PARM                    PMsgRId
     C                   PARM                    PDDocTp
     C                   PARM                    PDRtyp
     C                   PARM                    PDRyer
     C                   PARM                    PFuncKey
     C                   PARM                    ArIncCsNhO

     C                   EVAL      DDPGMQ = '*'
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWID = PSJobName
     C                   EVAL      DDOCTP = PDDocTp
     C                   EVAL      DDACTC = PActMode
     C                   EVAL      DDRTYP = PDRtyp
     C                   EVAL      DDRYER = PDRyer

      ** Mode select
     C                   IF        PActMode  = 'E'
     C                   EVAL      *IN78 = *OFF
     C                   ELSE
     C                   EVAL      *IN78 = *ON
     C                   ENDIF

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
