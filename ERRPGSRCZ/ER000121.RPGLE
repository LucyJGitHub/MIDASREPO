     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas @24 KWG display transmission details')           *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000121 - Midas @24 KWG display transmission details        *
      *                                                               *
      *  Function : This program displays the transmission file       *
      *             history details. All accounts reported with       *
      *             the transmissin file selected are dispalyed.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER068             Date 25Feb14               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG24101           Date 27May09               *
      *                 BUG23947           Date 20May09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER068 - Upgrade CER047 to be compatible with BaFin 3.2.2    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24101 - KWG Extract does not capture non-account holders  *
      *             (Recompile)                                       *
      *  BUG23947 - Menu Item should show correct symbol "§"          *
      *             ReCompile Due to DSPF Modification                *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRChkInp - Check Inputs From SUBFILE 1                       *
      *  SRNewRec - Write New Records                                 *
      *  SRLodSf1 - Fill SUBFILE 1                                    *
      *  SRLmoSf1 - Fill MORE SUBFILE 1                               *
      *  SRLpvSf1 - Fill SUBFILE 1 With Previous Records              *
      *  SRSetVal - Set SUBFILE Values                                *
      *  SRClrSf1 - Clesr SUBFILE 1                                   *
      *  SRSndMg - Send a Message to the Program                      *
      *  SRClrMg - Clear Msg                                          *
      *  *INZSR -  Program initialization                             *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas @24 KWG display transmission details
      *
     FER000121DFCF   E             WORKSTN SFILE(ER000121S0:RRN1)
      *
      ** Midas @24 KWG account record by account number
      *
     FERACEXL2  IF   E           K DISK
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the DB error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D  WYes           C                   CONST('Y')
     D  WNo            C                   CONST('N')
     D  WAllOf         C                   CONST('000000000')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Data structure for data area RUNDAT
      *
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *
      **  Data structure to format separate dates into a 8N number
      *
     D DSFmt           DS
     D  WYear                  1      4  0
     D  WMnth                  5      6  0
     D  WDay                   7      8  0
     D  WDate                  1      8  0
     D  WDay2                  9     10  0
     D  WMnth2                11     12  0
     D  WYear2                13     16  0
     D  WDate2                 9     16  0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D  Size           S              3P 0 INZ(14)
     D  RRN1           S              4P 0
     D  SAVRRN1        S              4P 0
     D  COUNT          S              4P 0
     D  WErr           S              1A   INZ(WNo)
     D**WAcc****       S             20A                                                      CER068
     D  WAcc           S             50A                                                      CER068
      *
     D  D2ACC1         S                   LIKE(D2ACC)
      *
     D  PFnr           S              8P 0
     D  PIn03          S              1A
     D**PAcCount       S             20A                                                      CER068
     D  PAcCount       S             50A                                                      CER068
     D  PReference     S             12A
     D  PVdt           S              8P 0
     D  PVtm           S              6P 0
     D  PZapGmq        S             10A
     D  PZapGrl        S              5A
     D  PZamSid        S              7A
     D  PZamSgf        S             10A
     D  PZamSda        S            132A
     D  PZamStp        S              7A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing ------------------------------+
      ** ¦                                                           ¦
      ** ¦ Initial processing is performed automatically: the *INZ   ¦
      ** ¦ executed at program activation.                           ¦
      ** ¦                                                           ¦
      ** +-----------------------------------------------------------+
      *
      *****************************************************************
      ** MAIN PROCEDURE
      *****************************************************************
      *
      ** Main Loop
      *
     C                   DOW       NOT(*IN03) AND NOT(*IN12)
     C                   WRITE     ER000121F0
     C                   WRITE     ER000121C1
     C  N61              WRITE     ER000121F1
     C                   EXFMT     ER000121C0
     C                   EXSR      SRClrMg
      *
      ** Select function key
      *
     C                   SELECT
      *
      ** Page Forwards
      *
     C                   WHEN      *IN25
     C                   EXSR      SRLmoSf1
      *
      ** Page Backwards
      *
     C                   WHEN      *IN26
     C                   EXSR      SRLpvSf1
      *
      ** Change in Sub File Header
      *
     C                   WHEN      D2ACC <> D2ACC1
     C                   EXSR      SRNewRec
      *
      ** Check input fields
      *
     C                   OTHER
     C                   IF        NOT(*IN03) AND NOT(*IN12) AND *IN61
     C                   EXSR      SRChkInp
     C                   ELSE
     C                   SETON                                        12
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   SETON                                        LR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkInp - Check Inputs From SUBFILE 1                       *
      *                                                               *
      *  Called by : MAIN Processing                                  *
      *                                                               *
      *  Calls : SRSndMg                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRChkInp      BEGSR
      *
     C                   IF        DDSCR1 <> 0
     C                   EVAL      DDSFR1 = DDSCR1
     C                   ENDIF
      *
      ** Read changed subfile record
      *
     C                   EVAL      SAVRRN1 = RRN1
     C                   READC     ER000121S0                             41
      *
      ** No changed records, leave the program
      *
     C                   IF        *IN41
     C                   SETON                                        12
     C                   ENDIF
      *
      ** Read all changed subfile records
      *
     C                   DOW       NOT(*IN41)
      *
     C                   SELECT
      *
      ** Enquire authority holders
      *
     C                   WHEN      D1SEL = 'E'
     C                   CALLB     'ER000122'
     C                   PARM      D1ACC         PAcCount
     C                   PARM      D1REF         PReference
     C                   PARM      D1VDT         PVdt
     C                   PARM      D1VTM         PVtm
     C     *IN03         PARM                    PIn03
      *
      ** Invalid Option
      *
     C                   OTHER
     C                   IF        D1SEL <> *BLANKS
     C                   EVAL      PZamSid = 'ERC0001'
     C                   CLEAR                   PZamSda
     C                   EXSR      SRSndMg
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** If exit requested, leave loop
      *
     C                   IF        *IN03
     C                   LEAVE
     C                   ENDIF
      *
      ** Update subfile
      *
     C                   IF        WErr = WNo
     C                   IF        D1SEL <> *BLANKS
     C                   CLEAR                   D1SEL
     C                   SETON                                        6068
     C                   SETOFF                                       69
     C                   ELSE
     C                   SETOFF                                       6869
     C                   ENDIF
     C                   ELSE
     C                   EVAL      DDSFR1 = RRN1
     C                   SETON                                        606869
     C                   ENDIF
     C                   UPDATE    ER000121S0
     C                   SETOFF                                       60
      *
      ** Next changed subfile record
      *
     C                   READC     ER000121S0                             41
     C                   ENDDO
      *
     C                   EVAL      RRN1 = SAVRRN1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNewRec - Write New Records                                 *
      *                                                               *
      *  Called by : MAIN Processing                                  *
      *                                                               *
      *  Calls : SRClrSf1, SRLodSf1                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRNewRec      BEGSR
      *
      ** If Error
      *
     C                   IF        WErr = WYes
     C                   LEAVESR
     C                   ENDIF
      *
      ** Save Fields
      *
     C                   EVAL      D2ACC1 = D2ACC
      *
      ** Refresh
      *
     C                   EVAL      WAcc = D2ACC
     C                   EXSR      SRClrSf1
     C                   EXSR      SRLodSf1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLodSf1 - Fill SUBFILE 1                                    *
      *                                                               *
      *  Called by : SRNewRec, SRLpvSf1, *INZSR                       *
      *                                                               *
      *  Calls : SRSetVal                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRLodSf1      BEGSR
      *
     C                   CLEAR                   D1SEL
     C                   EVAL      RRN1 = 1
     C                   EVAL      DDSFR1 = 1
      *
      ** Fill Subfile
      *
     C                   DOU       RRN1 > Size
      *
      ** Read from file ERACEXL2
      *
     C                   READ      ERACEXD0
     C                   IF        %EOF OR F12FNR <> PFnr
     C                   LEAVE
     C                   ENDIF
      *
      ** Set subfile values
      *
     C                   EXSR      SRSetVal
      *
      ** Write subfile record
      *
     C                   WRITE     ER000121S0
     C                   EVAL      RRN1 = RRN1 + 1
     C                   ENDDO
      *
      ** Display Subfile if records read
      *
     C                   IF        RRN1 > 1
     C                   SETON                                        61
      *
      ** More records to read?
      *
     C                   READ      ERACEXD0
      *
     C                   IF        %EOF or F12FNR <> PFnr
     C                   SETON                                        63
     C                   SETOFF                                       64
     C                   ELSE
     C                   SETON                                        64
     C                   READP     ERACEXD0
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
      *  SRLmoSf1 - Fill MORE SUBFILE 1                               *
      *                                                               *
      *  Called by : MAIN Processing                                  *
      *                                                               *
      *  Calls : SRSetVal                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRLmoSf1      BEGSR
      *
     C                   CLEAR                   D1SEL
     C                   EVAL      COUNT = 1
     C                   EVAL      DDSFR1 = RRN1
      *
      ** Fill more Subfile
      *
     C                   DOU       COUNT > Size
      *
      ** Read from file ERACEXL2
      *
     C                   READ      ERACEXD0
     C                   IF        %EOF OR F12FNR <> PFnr
     C                   LEAVE
     C                   ENDIF
      *
      **Set subfile values
      *
     C                   EXSR      SRSetVal
      *
      ** Write subfile record
      *
     C                   WRITE     ER000121S0
     C                   EVAL      RRN1 = RRN1 + 1
     C                   EVAL      COUNT = COUNT + 1
     C                   ENDDO
      *
      ** More records to read?
      *
     C                   READ      ERACEXD0
      *
     C                   IF        %EOF OR F12FNR <> PFnr
     C                   SETON                                        63
     C                   SETOFF                                       64
     C                   ELSE
     C                   SETON                                        64
     C                   READP     ERACEXD0
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLpvSf1 - Fill SUBFILE 1 With Previous Records              *
      *                                                               *
      *  Called by : MAIN Processing                                  *
      *                                                               *
      *  Calls : SRClrSf1, SRLodSf1                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRLpvSf1      BEGSR
      *
      ** Position to previous records in file ERACEXL2
      *
     C     KLerac        SETLL     ERACEXL2
      *
     C                   DO        Size
     C                   READP     ERACEXD0
      *
     C                   IF        %EOF OR F12FNR <> PFnr
     C                   CLEAR                   F12ACC
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Reload subfile
      *
     C                   EVAL      WAcc = F12ACC
     C                   EXSR      SRClrSf1
     C                   EXSR      SRLodSf1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetVal - Set SUBFILE Values                                *
      *                                                               *
      *  Called by : SRLodSf1, SRLmoSf1                               *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRSetVal      BEGSR
      *
     C                   EVAL      D1VDT = F12VDT
     C                   EVAL      D1VTM = F12VTM
     C                   EVAL      D1DTP = F12DTP
     C                   EVAL      D1ACC = F12ACC
     C                   EVAL      D1ACCX = F12ACC
     C                   EVAL      D1REF = F12REF
     C                   EVAL      D1REFX = F12REF
     C                   EVAL      D1CCY = F12CCY
      *
     C                   EVAL      WDate = F12CDT
     C                   Z-ADD     WYear         WYear2
     C                   Z-ADD     WMnth         WMnth2
     C                   Z-ADD     WDay          WDay2
     C                   Z-ADD     WDate2        D1CDT
      *
     C                   EVAL      WDate = F12VDT
     C                   Z-ADD     WYear         WYear2
     C                   Z-ADD     WMnth         WMnth2
     C                   Z-ADD     WDay          WDay2
     C                   Z-ADD     WDate2        D1VDT1
      *
     C                   EVAL      WDate = F12DDT
     C                   Z-ADD     WYear         WYear2
     C                   Z-ADD     WMnth         WMnth2
     C                   Z-ADD     WDay          WDay2
     C                   Z-ADD     WDate2        D1DDT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrSf1 - Clesr SUBFILE 1                                   *
      *                                                               *
      *  Called by : SRNewRec, SRLpvSf1, *INZSR                       *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRClrSf1      BEGSR
      *
     C                   SETON                                        62
     C                   WRITE     ER000121C0
     C                   SETOFF                                       616263
     C                   SETOFF                                       6465
      *
      ** Postion to record
      *
     C     KLerac        SETLL     ERACEXL2
      *
      ** Check if previous records exist, if so then allow ROLLDOWN
      *
     C                   READP     ERACEXD0
      *
     C                   IF        NOT(%EOF) and F12FNR = PFnr
     C                   SETON                                        65
     C                   ENDIF
      *
     C     KLerac        SETLL     ERACEXL2
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMg - Send a Message to the Program                      *
      *                                                               *
      *  Called by : SRChkInp                                         *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
     C     SRSndMg       BEGSR
      *
     C     PZapGmq       IFEQ      *BLANKS
     C                   EVAL      PZapGmq = DDPGM
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PZapGmq
     C                   PARM                    PZapGrl
     C                   PARM                    PZamSid
     C                   PARM                    PZamSgf
     C                   PARM                    PZamSda
     C                   PARM                    PZamStp
      *
     C                   EVAL      WErr = WYes
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrMg - Clear Msg                                          *
      *                                                               *
      *  Called by : *INZSR                                           *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRClrMg       BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         PZapGmq
     C                   PARM      '*SAME'       PZapGrl
      *
     C                   EVAL      WErr = WNo
     C                   SETOFF                                       6869
     C                   MOVEA     WAllOf        *IN(71)
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR -  Program initialization                             *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *                                                               *
      *  Calls : SRClrMg, SRClrSf1, SRLodSf1                          *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Define *ENTRY parameter list
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFnr
     C                   PARM      *IN03         PIn03
      *
      ** Set program and job name
      *
     C                   EVAL      DDPGM = PSProcName
     C                   EVAL      DDJOB = PSJobName
      *
      ** Set MIDAS rundate
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   EVALR     DDMRDT = MRDT
      *
      ** Messages file
      *
     C                   EVAL      PZamSgf = 'STUSRMSG'
      *
      ** Clear program messages
      *
     C                   EXSR      SRClrMg
      *
      ** Init the Select Fields
      *
     C                   CLEAR                   D2ACC
     C                   CLEAR                   D2ACC1
      *
      ** Init the Subfile
      *
     C                   CLEAR                   WAcc
     C                   EXSR      SRClrSf1
     C                   EXSR      SRLodSf1
      *
      ** Defining KeyLists
      *
     C     KLerac        KLIST
     C                   KFLD                    PFnr
     C                   KFLD                    WAcc
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Program, module and procedure names for DB error processing.
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
