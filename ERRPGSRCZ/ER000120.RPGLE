     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas @24 KWG display transmission file history')      *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000120 - Midas @24 KWG display transmission file history   *
      *                                                               *
      *  Function : This program displays the transmission file       *
      *             history and enables to recreate a transmission    *
      *             file.                                             *
      *                                                               *
      *  Component of : ER000120                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. MD031059           Date 25Nov14               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG24101           Date 27May09               *
      *                 BUG23947           Date 20May09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031059 - Bug in enquiry screen: §24c KWG Transmission File *
      *             History. Do not call ZVACTBU when action code is  *
      *             blank.                                            *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24101 - KWG Extract does not capture non-account holders  *
      *             (Recompile)                                       *
      *  BUG23947 - Menu Item should show correct symbol "§"          *
      *             ReCompile Due to DSPF Modification                *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      *
      ** Midas @24 KWG display transmission file history
      *
     FER000120DFCF   E             WORKSTN SFILE(ER000120S0:RRN1)
      *
      ** Midas @24 KWG file info by file number
      *
     FERTINFL0  IF   E           K DISK
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
      ** The following /COPY line includes all the defined field in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Declare constants for the call of 'AOSVALR0'
      *
     D WVal01          C                   'TransFileFolder'
      *
      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** External data structures for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
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
      ** Data structure for data area ZMUSER
      *
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
      *
      **  Data structure to format dates
      *
     D WDfmt           DS
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
      ** Define variables
      *
     D  Size           S              3P 0 INZ(14)
     D  RRN1           S              4P 0
     D  SAVRRN1        S              4P 0
     D  COUNT          S              4P 0
     D  WErr           S              1A   INZ(WNo)
     D  WSts           S             23    DIM(3)
      *
     D  D2FNR1         S                   LIKE(D2FNR)
     D  D2DAT1         S                   LIKE(D2DAT)
      *
      ** Define constants
      *
     D  WYes           C                   CONST('Y')
     D  WNo            C                   CONST('N')
     D  WAllOf         C                   CONST('000000000')
      *
      ** Parameter Variables for the call of 'AOSVALR0'
      *
     D PRtcd1          S              7A
     D POp01           S             20A
     D POp02           S             20A
     D POp03           S             20A
     D POp04           S             20A
     D POp05           S             20A
     D POp06           S             20A
     D POp07           S             20A
     D POp08           S             20A
     D POp09           S             20A
     D POp10           S             20A
      *
     D PVl01           S            200A
     D PVl02           S            200A
     D PVl03           S            200A
     D PVl04           S            200A
     D PVl05           S            200A
     D PVl06           S            200A
     D PVl07           S            200A
     D PVl08           S            200A
     D PVl09           S            200A
     D PVl10           S            200A
      *
     D WCharDate       S              8A
     D WInfKey         S              8P 0
     D PFnr            S              8P 0
     D PIn03           S              1A
     D PUtp            S              1A
     D WWErr           S              1P 0
     D PRtcd           S              7A
     D POptn           S              7A
     D PRtnCde         S              1P 0
     D PZaPgmq         S             10A
     D PZaPgrl         S              5A
     D PZaMsid         S              7A
     D PZaMsgf         S             10A
     D PZaMsda         S            132A
     D PZaMstp         S              7A
     D PWortn          S              7A
     D PZaMstx         S            132A
     D PZaCtn          S              1A
     D PZbr            S              3A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing ------------------------------+
      ** ¦                                                           ¦
      ** ¦ Initial processing is perfORmed automatically: the *INZ   ¦
      ** ¦ executed at program activation.                           ¦
      ** ¦                                                           ¦
      ** +-----------------------------------------------------------+
      *
      *****************************************************************
      ** MAIN PROCEDURE
      *****************************************************************
      *
      ** Defining Keylists
      *
     C     KLerti        KLIST
     C                   KFLD                    WInfKey
      *
      ** Main Loop
      *
     C                   DOW       NOT(*IN03)
     C                   WRITE     ER000120F0
     C                   WRITE     ER000120C1
     C  N61              WRITE     ER000120F1
     C                   EXFMT     ER000120C0
     C                   EXSR      SRClrMg
      *
      ** Select function key
      *
     C                   SELECT
      *
      ** Refresh
      *
     C                   WHEN      *IN05
     C                   CALL      'ER000110'
     C                   EXSR      SRClrSf1
     C                   EXSR      SRLodSf1
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
     C                   WHEN      D2FNR <> D2FNR1 or
     C                             D2DAT <> D2DAT1
     C                   EXSR      SRNewRec
      *
      ** Check input fields
      *
     C                   OTHER
     C                   IF        NOT(*IN03) and *IN61
     C                   EXSR      SRChkInp
     C                   ELSE
     C                   SETON                                        03
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
      *  Calls : SRAcsSec, SRSndMg, SRRecrt, SRSndMg                  *
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
     C                   READC     ER000120S0                             41
      *
      ** No changed records, leave the program
      *
     C                   IF        *IN41
     C                   SETON                                        03
     C                   ENDIF
      *
      ** Read all changed subfile records
      *
     C                   DOW       NOT(*IN41)
      *
      ** Security check
      *
     C                   EXSR      SRAcsSec
     C                   IF        WErr = WNo
     C                   SELECT
      *
      ** Enquire details
      *
     C                   WHEN      D1SEL = 'E'
     C                   IF        D1STS = WSts(1)
     C                   EVAL      PZaMsid = 'ERC0011'
     C                   MOVEL(P)  D1FNR         PZaMsda
     C                   EXSR      SRSndMg
     C                   ELSE
     C                   CALLB     'ER000123'
     C                   PARM      D1FNR         PFnr
     C     *IN03         PARM                    PIn03
     C                   ENDIF
      *
      ** Detailed list of sent records
      *
     C                   WHEN      D1SEL = 'D'
     C                   CALLB     'ER000121'
     C                   PARM      D1FNR         PFnr
     C     *IN03         PARM                    PIn03
      *
      ** Recreate transmission file
      *
     C                   WHEN      D1SEL = 'R'
     C                   EXSR      SRRecrt
      *
      ** Invalid Option
      *
     C                   OTHER
     C                   IF        D1SEL <> *BLANKS
     C                   EVAL      PZaMsid = 'ERC0001'
     C                   CLEAR                   PZaMsda
     C                   EXSR      SRSndMg
     C                   ENDIF
      *
     C                   ENDSL
     C                   ENDIF
      *
      ** If exit requested, leave loop
      *
     C                   IF        *IN03
     C                   LEAVE
     C                   ENDIF
      *
      ** Set color for status
      *
     C                   IF        D1STS = WSts(3)
     C                   SETON                                        79
     C                   ELSE
     C                   SETOFF                                       79
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
     C                   UPDATE    ER000120S0
     C                   SETOFF                                       60
      *
      ** Next changed subfile record
      *
     C                   READC     ER000120S0                             41
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
      *  SRRecrt - Recreate Transmission File                         *
      *                                                               *
      *  Called by : SRChkInp                                         *
      *                                                               *
      *  Calls : SRSndMg                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRRecrt       BEGSR
      *
      ** Call recreation program
      *
     C                   CALL      'ERC0100'                            98
     C                   PARM      D1UTP         PUtp
     C                   PARM      D1FNR         PFnr
     C                   PARM                    PRtnCde
      *
      ** Select for error that may have occured
      *
     C                   SELECT
     C                   WHEN      *IN98
     C                   EVAL      PZaMsid = 'ERC0003'
     C                   MOVEL(P)  D1FNR         PZaMsda
     C                   EXSR      SRSndMg
      *
     C                   WHEN      PRtnCde = 1
     C                   EVAL      PZaMsid = 'ERC0004'
     C                   EVAL      PZaMsda = D1FNM + %SUBST(PVl01:1:60)
     C                   EXSR      SRSndMg
      *
     C                   WHEN      PRtnCde = 2
     C                   EVAL      PZaMsid = 'ERC0005'
     C                   EVAL      PZaMsda = D1FNM
     C                   EXSR      SRSndMg
      *
     C                   WHEN      PRtnCde = 3
     C                   EVAL      PZaMsid = 'ERC0006'
     C                   EVAL      PZaMsda = D1FNM + %SUBST(PVl01:1:60)
     C                   EXSR      SRSndMg
      *
     C                   WHEN      PRtnCde = 4
     C                   EVAL      PZaMsid = 'ERC0012'
     C                   MOVEL(P)  D1FNR         PZaMsda
     C                   EXSR      SRSndMg
      *
     C                   OTHER
     C                   EVAL      PZaMsid = 'ERC0007'
     C                   MOVEL(P)  D1FNR         PZaMsda
     C                   EXSR      SRSndMg
     C                   EVAL      WErr = WNo
      *
     C                   ENDSL
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
      *  Calls : SRSndMg, SRClrSf1                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRNewRec      BEGSR
      *
      ** Check date
      *
     C                   IF        D2DAT <> 0
     C                   MOVEL     D2DAT         WCharDate
     C     *EUR0         TEST(DE)                WCharDate
     C                   IF        %ERROR
     C                   EVAL      PZaMsid = 'ERC0002'
     C                   CLEAR                   PZaMsda
     C                   EXSR      SRSndMg
     C                   SETON                                        72
     C                   ENDIF
     C                   ENDIF
      *
      ** If Error
      *
     C                   IF        WErr = WYes
     C                   LEAVESR
     C                   ENDIF
      *
      ** Save Fields
      *
     C                   EVAL      D2FNR1 = D2FNR
     C                   EVAL      D2DAT1 = D2DAT
      *
      ** Refresh
      *
     C                   IF        D2FNR > 0
     C                   EVAL      WInfKey = D2FNR
     C                   ELSE
     C                   MOVE      *HIVAL        WInfKey
     C                   ENDIF
     C                   EXSR      SRClrSf1
     C                   EXSR      SRLodSf1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLodSf1 - Subroutine to Fill SUBFILE 1                      *
      *                                                               *
      *  Called by : MAIN Processing, SRNewRec, SRLpvSf1, *INZSR      *
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
      ** Read from file ERTINFL0
      *
     C                   READ      ERTINFD0
     C                   IF        %EOF
     C                   LEAVE
     C                   ENDIF
      *
      ** Set subfile values
      *
     C                   EXSR      SRSetVal
      *
      ** If start with a specific date
      *
     C                   Z-ADD     D2DAT         WDate2
     C                   Z-ADD     WYear2        WYear
     C                   Z-ADD     WMnth2        WMnth
     C                   Z-ADD     WDay2         WDay
     C                   MOVE      F10DAT        WDate2
     C                   IF        WDate > WDate2
     C                   SETON                                        65
     C                   ITER
     C                   ENDIF
      *
      ** Write subfile record
      *
     C                   WRITE     ER000120S0
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
     C                   READ      ERTINFD0
     C                   IF        %EOF
     C                   SETON                                        63
     C                   SETOFF                                       64
     C                   ELSE
     C                   SETON                                        64
     C                   READP     ERTINFD0
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLmoSf1 - Subroutine to Fill MORE SUBFILE 1                 *
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
      ** Read from file ERTINFL0
      *
     C                   READ      ERTINFD0
     C                   IF        %EOF
     C                   LEAVE
     C                   ENDIF
      *
      ** Set subfile values
      *
     C                   EXSR      SRSetVal
      *
      ** Write subfile record
      *
     C                   WRITE     ER000120S0
     C                   EVAL      RRN1 = RRN1 + 1
     C                   EVAL      COUNT = COUNT + 1
     C                   ENDDO
      *
      ** More records to read?
      *
     C                   READ      ERTINFD0
     C                   IF        %EOF
     C                   SETON                                        63
     C                   SETOFF                                       64
     C                   ELSE
     C                   SETON                                        64
     C                   READP     ERTINFD0
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
      ** Position to previous records in file ERTINFL0
      *
     C     KLerti        SETLL     ERTINFL0
     C                   DO        Size
     C                   READP     ERTINFD0
     C                   IF        %EOF
     C                   MOVE      *HIVAL        F10FNR
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
      ** Reload subfile
      *
     C                   EVAL      WInfKey = F10FNR
     C                   EXSR      SRClrSf1
     C                   EXSR      SRLodSf1
      *
     C                   ENDSR
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
     C                   EVAL      D1FNM = F10FNM
     C                   EVAL      D1FNR = F10FNR
     C                   EVAL      D1UTP = F10UTP
     C                   MOVE      F10TIM        D1TIM
      *
     C                   MOVE      F10DAT        WDate
     C                   Z-ADD     WYear         WYear2
     C                   Z-ADD     WMnth         WMnth2
     C                   Z-ADD     WDay          WDay2
     C                   Z-ADD     WDate2        D1DAT
      *
     C                   IF        F10NRC > 9999999
     C                   EVALR     D1NRC = *ALL'+'
     C                   ELSE
     C                   EVAL      D1NRC
     C                             = %SUBST(%EDITC(F10NRC:'3'):9:7)
     C                   ENDIF
      *
     C     F10SIZ        DIV       1024          SizeInKB         15 1
     C                   IF        SizeInKB > 999999.9
     C                   EVALR     D1SIZ = *ALL'+'
     C                   ELSE
     C                   EVAL      D1SIZ
     C                             = %SUBST(%EDITC(SizeInKB:'3'):9:8)
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      F10STS = 'X'
     C                   SETOFF                                       79
     C                   EVAL      D1STS = WSts(2)
     C                   WHEN      F10STS = 'E'
     C                   SETON                                        79
     C                   EVAL      D1STS = WSts(3)
     C                   OTHER
     C                   SETOFF                                       79
     C                   EVAL      D1STS = WSts(1)
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrSf1 - Subroutine to Clesr SUBFILE 1                     *
      *                                                               *
      *  Called by : MAIN Processing, SRNewRec, SRLpvSf1, *INZSR      *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRClrSf1      BEGSR
      *
     C                   SETON                                        62
     C                   WRITE     ER000120C0
     C                   SETOFF                                       616263
     C                   SETOFF                                       6465
      *
      ** Postion to record
      *
     C     KLerti        SETLL     ERTINFL0
      *
      ** Check if previous records exist, if so then allow ROLLDOWN
      *
     C                   READP     ERTINFD0
     C                   IF        NOT(%EOF)
     C                   SETON                                        65
     C                   ENDIF
     C     KLerti        SETLL     ERTINFL0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMg - Send A Message To The Program                      *
      *                                                               *
      *  Called by : SRChkInp, SRRecrt, SRNewRec, SRAcsSec            *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRSndMg       BEGSR
      *
     C     PZaPgmq       IFEQ      *BLANKS
     C                   EVAL      PZaPgmq = DDPGM
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PZaPgmq
     C                   PARM                    PZaPgrl
     C                   PARM                    PZaMsid
     C                   PARM                    PZaMsgf
     C                   PARM                    PZaMsda
     C                   PARM                    PZaMstp
      *
     C                   EVAL      WErr = WYes
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrMg - Subroutine to Clear Msg                            *
      *                                                               *
      *  Called by : MAIN Processing, *INZSR                          *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRClrMg       BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         PZaPgmq
     C                   PARM      '*SAME'       PZaPgrl
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
      *  SRRtvMg - Subroutine to Retreive Msg                         *
      *                                                               *
      *  Called by : *INZSR                                           *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvMg       BEGSR
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM                    PWortn
     C                   PARM                    PZaMsid
     C                   PARM                    PZaMsgf
     C                   PARM                    PZaMsda
     C                   PARM                    PZaMstx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcsSec - Access Security Checking                          *
      *                                                               *
      *  Called by : SRChkInp                                         *
      *                                                               *
      *  Calls : SRSndMg                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRAcsSec      BEGSR
      *
      ** If not multi-branching, check authority to only action code
      *
     C                   IF        BJSBRC <> ' '
     C                   CALL      'ZVACTU'
     C                   PARM      D1SEL         PZaCtn
     C                   PARM                    WWErr
      *
     C                   IF        WWErr = 1
     C                   EVAL      PZaMsid = 'ERC0015'
     C                   CLEAR                   PZaMsda
     C                   EXSR      SRSndMg
     C                   ENDIF
      *
      ** If multi-branching, check authority to booking branch
      *
     C                   ELSE
                                                                                            MD031059
     C                   IF        D1SEL <> *BLANK                                          MD031059
                                                                                            MD031059
     C                   CALL      'ZVACTBU'
     C                   PARM      D1SEL         PZaCtn
     C                   PARM      DBRN          PZbr
     C                   PARM                    WWErr
      *
     C                   IF        WWErr = 1
     C                   EVAL      PZaMsid = 'ERC0013'
     C                   CLEAR                   PZaMsda
     C                   EXSR      SRSndMg
     C                   ENDIF
      *
     C                   IF        WWErr = 2
     C                   EVAL      PZaMsid = 'ERC0014'
     C                   CLEAR                   PZaMsda
     C                   EXSR      SRSndMg
     C                   ENDIF
                                                                                            MD031059
     C                   ENDIF                                                              MD031059
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR -  Program initialization                             *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *                                                               *
      *  Calls : *PSSR, SRRtvMg, SRClrMg, SRClrSf1, SRLodSf1          *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Paramameters to call AOSALVAR0
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd1
     C                   PARM      WVal01        POp01
     C                   PARM                    PVl01
     C                   PARM      *BLANKS       POp02
     C                   PARM                    PVl02
     C                   PARM      *BLANKS       POp03
     C                   PARM                    PVl03
     C                   PARM      *BLANKS       POp04
     C                   PARM                    PVl04
     C                   PARM      *BLANKS       POp05
     C                   PARM                    PVl05
     C                   PARM      *BLANKS       POp06
     C                   PARM                    PVl06
     C                   PARM      *BLANKS       POp07
     C                   PARM                    PVl07
     C                   PARM      *BLANKS       POp08
     C                   PARM                    PVl08
     C                   PARM      *BLANKS       POp09
     C                   PARM                    PVl09
     C                   PARM      *BLANKS       POp10
     C                   PARM                    PVl10
      *
     C                   IF        PRtcd1 <> *BLANKS
      *
     C                   IF        PVl01 = '*NRF   '
     C                   EVAL      DBKEY = POp01
     C                   ENDIF
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'ER000120'
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
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
      ** Get Branch for mutli-branching
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     PRtcd         IFNE      *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   END
      *
      ** Messages file
      *
     C                   EVAL      PZaMsgf = 'STUSRMSG'
      *
      ** Retrieve text for status
      *
     C                   EVAL      PZaMsid = 'ERC0008'
     C                   EXSR      SRRtvMg
     C                   EVAL      WSts(1) = PZaMstx
     C                   EVAL      PZaMsid = 'ERC0009'
     C                   EXSR      SRRtvMg
     C                   EVAL      WSts(2) = PZaMstx
     C                   EVAL      PZaMsid = 'ERC0010'
     C                   EXSR      SRRtvMg
     C                   EVAL      WSts(3) = PZaMstx
      *
      ** Clear program messages
      *
     C                   EXSR      SRClrMg
      *
      ** Init the Select Fields
      *
     C                   CLEAR                   D2FNR
     C                   CLEAR                   D2FNR1
     C                   CLEAR                   D2DAT
     C                   CLEAR                   D2DAT1
      *
      ** Init the Subfile
      *
     C                   MOVE      *HIVAL        WInfKey
     C                   EXSR      SRClrSf1
     C                   EXSR      SRLodSf1
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
