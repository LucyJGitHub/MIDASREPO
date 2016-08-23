     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Netting Multiple Settlements Select')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  FX0925 - Netting Multiple Settlements Select.                *
      *                                                               *
      *  Function:  This module displays the Netting Multiple         *
      *             settlement Details and allows the user to select  *
      *             one from the list.                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CDL025  *CREATE    Date 07Nov04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL025 - FX Netting Payment Generation                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file                                     *
      *    31         Error in selection field                        *
      *    40         No data to display                              *
      *    92         Subfile active                                  *
      *    94         Message subfile end                             *
      *    95         Subfile next change                             *
      *    96         Subfile end                                     *
      *    97         Clear subfile                                   *
      *    98         Rollup                                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrBldSfl   - Build Subfile                                   *
      *  SrDspScn   - Display Subfile Screen                          *
      *  SrValScn   - Validate Subfile Screen                         *
      *  SrClrMsg   - Clear Message Subfile and Data                  *
      *  SrFmtDet   - Format Details for Output                       *
      *  SrSndMsg   - Send Message to Subfile                         *
      *  SrExtSet   - Amend settlement details                        *
      *  *PSSR      - Error processing                                *
      *  *INZSR     - Initialise                                      *
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
 
     FFX0925DF  CF   E             WORKSTN SFILE(FX0925S1:WkSRRN1)
      ** Splitting  Details Screen
 
     FSDFNMSL0  IF   E           K DISK    INFSR(*PSSR)
      **FX Netting Multiple Settlements File
 
     FFXNETMPD  IF   E           K DISK    INFSR(*PSSR)
      ** DL Confirmed nets master file
 
     FFXNETSPD  UF A E           K DISK    INFSR(*PSSR)
      ** FX Confirmed split nets master file
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------
      ** Indicator Array
     D Indicators      DS                  Based(IndicatorP)
     D  EndOfFile             01     01
     D  NoData2Dsp            40     40
     D  SflActive             92     92
     D  MsgSFleEnd            94     94
     D  SFleNxtChg            95     95
     D  SFleEnd               96     96
     D  SFleClr               97     97
     D  RollUp                98     98
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   Inz(%Addr(*In))
 
      ** Split Amount work array
     D WSAmt           S              1A   DIM(%Size(#1SAmt)) ASCEND
 
      **---------------------------------------------------------
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  ExtName(SDBANKPD)
 
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  ExtName(RUNDAT) DtaAra(RUNDAT)
      *
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  ExtName(DSFDY)
 
      ** DSs  for call to SD2420
     D Parm2         E DS                  ExtName(SETLIAB)
     D Parm3         E DS                  ExtName(SETLIAZ)
     D Parm4         E DS                  ExtName(SDSETLPD)
 
      ** Current Selection Fields
     D PParms1       E DS                  ExtName(FXNETMPD)
     D PParms2       E DS                  ExtName(FXNTIPPD)
     D PParms3         DS
     D  PActn                         1A
     D  PVDat                         6A
     D  PGPCD                         4A
     D  PCRNM                        20A
     D  PC3SN                        10A
     D  PCRTN                        10A
     D  PNetR                        19A
     D  PPInd                         1A
     D  PNCcy                         3A
     D  PNCCN                        14A
     D  PPCy1                         3A
     D  PPC1N                        14A
     D  PPCy2                         3A
     D  PPC2N                        14A
     D  PNAmt                        20A
 
     D  PCust                              Like(LCust)
     D  PRETP                         1A
     D  PCHIM                         1A
     D  PRETS                         1A
     D  PPCYA                         4A
     D  PCSNM                        10A
     D  PMBIN                         1A
     D  PNBDP                         1S 0
     D  PDBUY                        15S 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters Used
 
      ** Parameters
     D PRetCode        S              7A
     D PSeqn           S              4A
     D PDlNo           S              6A
     D PCHGDAT         S              8P 0
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Parameters for ZA0350
     D PMsgFile        S             10A   Inz('DRSMM')
     D PMsgId          S             10A
     D PMsgData        S             45A
 
      ** Parameter used for ZALIGN and ZFRPED
     D ZField          S             15P 0
     D ZFieldA         S             16A
     D ZDec            S              1P 0
     D ZADig           S              2P 0
     D ZECode          S              1A
     D ZOut22          S             22A
     D ZOut25          S             25A
     D ZAlignOk        S              1A
 
 
     D FirstPass       S              1A
     D PageFull        S               N   Inz(*Off)
     D KeyFlag         S              1A
     D WError          S               N   Inz(*Off)
     D WSetErr         S               N   Inz(*Off)
     D WSplRec         S              3S 0 Inz(0)
     D W1stRec         S              1A
     D WScrn           S              1A
     D WRSfl           S              1A
     D WCcy            S              3A
     D WSeq            S              3A
     D WPage           S              3S 0
     D WLine           S              3S 0
 
     D KNCcy           S                   Like(LCyCd)
     D KCust           S                   Like(LCust)
     D KSeqn           S                   Like(LSeqn)
     D KNetR           S                   Like(AMNETR)
 
     D WLRcdNum        S              5  0
     D WkSRRN1         S              5  0
     D WkCnt           S              5  0
     D WkScrn          S              5  0
     D WkLines         S              5  0
     D WTotNet         S             15S 2
     D X               S              3S 0
     D Y               S              3S 0
 
     D PRtcd           S              7A
     D POptn           S              7A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Set screen Fields from passed parameters
     C                   Eval      #1Actn =  PActn
     C                   Move      PVDat         #1VDat
     C                   Eval      #1CUST =  PCUST
     C                   Eval      #1CRNM =  PCRNM
     C                   Eval      #1CSNM =  PC3SN
     C                   Eval      #1CRTN =  PCRTN
     C                   Eval      #1NetR =  PNetR
     C                   Eval      #1PInd =  PPInd
     C                   Eval      #1NCcy =  PNCcy
     C                   Eval      #1NCCN =  PNCCN
     C                   Eval      #1PCy1 =  PPCy1
     C                   Eval      #1PC1N =  PPC1N
     C                   Eval      #1PCy2 =  PPCy2
     C                   Eval      #1PC2N =  PPC2N
     C                   Eval      #1NAmt =  PNAmt
     C                   If        PPInd = 'Y'
     C                   Eval      *In31 = *On
     C                   EndIf
 
      ** Build Sub-file
     C                   Exsr      SrBldSfl
     C                   Eval      #1SFRN = 1
     C                   Eval      WRSfl = 'N'
 
      ** Display Screen
     C                   DoW       WScrn = '1'
      * Rebuild Subfile ?
     C                   If        WRSfl = 'Y'
     C                   Eval      FirstPass = 'Y'
     C                   Exsr      SrbldSfl
     C                   Eval      WRSfl = 'N'
     C                   EndIf
 
     C                   Exsr      SrDspScn
     C                   EndDo
 
     C                   If        WScrn = 'T'
      ** Return to calling program
     C                   If        PRetCode = *Blanks
     C                   EndIf
     C                   Eval      *InLR = *On
     C                   Return
 
     C                   EndIf
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBldSfl - Build Subfile                                     *
      *                                                               *
      *****************************************************************
     C     SrBldSfl      BEGSR
 
      ** If first time in
     C                   If        FirstPass = 'Y'
 
      ** Clear subfile
     C                   Eval      SFleClr = *ON
     C                   Write     FX0925C1
     C                   Eval      SFleClr = *OFF
     C                   Eval      KeyFlag = 'N'
     C                   Eval      FirstPass = 'N'
     C                   Eval      WLRcdNum  = 0
     C                   Eval      SFleEnd = *OFF
     C                   Eval      WTotNet = *Zeros
     C                   Eval      WSplRec = *Zeros
 
      ** Set file pointer on key displayed on screen.
     C                   Eval      KNetR = PNetR
     C     KNetR         Setll     FXNETSPD
     C                   EndIf
 
      ** Protect fields if enquiry mode
     C                   If        PActn = 'E'
     C                   Eval      *In70 = *On
     C                   Eval      *In71 = *Off
     C                   Else
     C                   Eval      *In70 = *Off
     C                   Eval      *In71 = *Off
     C                   EndIf
 
      ** Reset Error indicators
     C                   MoveA     '0000'        *In(60)
 
      ** Set on ROLLUP indicator to drive initial loop.
     C                   Eval      RollUp = *ON
 
      ** Initialise count of records written to subfile page.
      ** Initialise subfile relative record number.
     C                   Eval      WkCnt = 0
     C                   Eval      WkSRRN1 = WLRcdNum
 
      ** Read a Valid Transaction
     C     KNetR         ReadE     FXNETSD0
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 is input.
 
      ** For each record read, write it to the subfile.
      ** Do this until the subfile page is full.
     C                   DoW       Not %Eof(FXNETSPD)
 
      ** Clear Subfile fields
     C                   Clear                   FX0925S1
     C                   Eval      SFleNxtChg = *Off
 
      ** Increment the subfile record no. and records written fields.
     C                   Eval      WkCnt = WkCnt + 1
     C                   Eval      WkSRRN1 = WkSRRN1 + 1
 
      ** Format transaction fields for output
     C                   Eval      WTotNet = WTotNet + ASDBuy
     C                   Eval      WSplRec = WSplRec + 1
     C                   Exsr      SrFmtDet
     C                   Eval      SFleNxtChg = *On
 
      ** Write details to the subfile.
     C                   Eval      #1SFRN = WkSRRN1
     C                   Write     FX0925S1
 
      ** Read next record in file FXNETSD0
     C     KNetR         ReadE     FXNETSD0
     C                   EndDo
 
      ** Fill remainder with blank records
     C                   If        WkCnt > 0
     C     WkCnt         Div       8             WkScrn
     C                   Mvr                     WkLines
     C                   If        WkLines > 0
     C                   Eval      WkLines = (Wkscrn + 1) * 8
     C                   Else
     C                   Eval      WkLines = Wkscrn * 8
     C                   EndIf
     C                   Else
     C                   Eval      WkLines = 8
     C                   EndIf
 
     C                   DoW       WkCnt < WkLines
 
      ** Clear Subfile fields
     C                   Clear                   FX0925S1
     C                   Eval      SFleNxtChg = *Off
 
      ** Increment the subfile record no. and records written fields.
     C                   Eval      WkCnt = WkCnt + 1
     C                   Eval      WkSRRN1 = WkSRRN1 + 1
 
 
      * Protect amend Flag
     C                   If        PActn = 'E'
     C                   Eval      *In71 = *On
     C                   EndIf
 
     C                   If        WkSRRN1 = 1
      ** No Records to Display
     C                   Eval      MsgIdArr(1) = 'FXM6000'
     C                   EndIf
 
      ** Write details to the subfile.
     C                   Eval      #1SFRN = WkSRRN1
     C                   Write     FX0925S1
 
     C                   EndDo
 
      ** Set the record pointer to the previous record retrieved, using
      ** READPE if not yet end of file
     C                   Eval      SfleEnd = True
 
      ** Save last relative record number to workfield to be use when rollup
      ** is pressed
     C                   Eval      WLRcdNum = WkSRRN1
     C                   Eval      NoData2Dsp = False
     C                   Eval      *In71 = *Off
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDspScn - Display Subfile Screen                            *
      *                                                               *
      *****************************************************************
     C     SrDspScn      BEGSR
 
      ** Format 'Differences' and set display
     C                   Eval      WSetErr = *Off
 
     C                   If        WTotNet > 0 and WTotNet <> PDBuy
     C                   Eval      WSetErr = *On
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'FXM6009'
     C                   EndIf
 
      ** Send message to subfile if any.
     C                   Exsr      SRSndMsg
 
      ** Write the screen footer to the screen.
      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.
     C                   Write     FX0925F1
     C                   Eval      SflActive = True
     C                   Write     FX0925C2
     C                   Exfmt     FX0925C1
 
      ** Perform message subfile clear and message data clear
     C                   Exsr      SRClrMsg
 
      ** Select processing type
     C                   Select
      ** F3 Pressed
     C                   When      *INKC = *On
     C                   Eval      PRetCode = *Blanks
     C                   Eval      PRetCode = '03'
     C                   Eval      WScrn = 'T'
 
      ** F12 Pressed
     C                   When      *INKL = *On
     C                   Eval      PRetCode  = *Blanks
     C                   Eval      PMCMDP  = '  '
     C                   Eval      WScrn = 'T'
 
      ** F6 Pressed (only valid with no settlement errors)
     C                   When      *INKF = *On and WSetErr = *Off and
     C                             PActn <> 'E'
     C                   Exsr      SrUpdFle
     C                   If        WSetErr = *Off
     C                   Eval      PRetCode  = *Blanks
     C                   Eval      PRetCode = '06'
     C                   Eval      WScrn = 'T'
     C                   EndIf
 
      ** RollUp pressed
     C                   When      RollUp = True
     C                   If        PActn <> 'E'
     C                   Exsr      SRValScn
     C                   If        WError = *Off and PageFull = True
     C                   Eval      KeyFlag = 'R'
     C                   Exsr      SRBldSfl
     C                   Eval      WScrn = '1'
     C                   Eval      PageFull = False
     C                   EndIf
     C                   EndIf
 
     C                   Other
     C                   Exsr      SRValScn
 
      ** No Errors process selctions
     C                   If        WError = *Off
     C                   Exsr      SRPrcScn
     C                   EndIf
 
     C                   EndSl
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValScn  - Validate subfile screen                           *
      *                                                               *
      *****************************************************************
     C     SRValScn      BEGSR
 
     C                   Eval      WScrn = '1'
     C                   Eval      W1stRec = 'N'
     C                   Eval      WError  = *Off
     C                   Eval      WTotNet  = *Zeros
 
      ** Read subfile
     C                   ReadC     FX0925S1
     C                   DoW       Not %Eof
      ** Reset Error indicators
     C                   MoveA     '0000'        *In(60)
      ** Validate Amount
     C                   If        #1SAMT  <> *Blanks and #1SAMT <> #PSAMT
     C                   Eval      X = 1
     C                   MoveA     #1SAMT        WSAmt
     C     ' '           Lookup    WSAmt(X)                           60
     C                   Eval      Y = 20 - X + 1
     C                   Eval      ZFieldA = *Blanks
     C                   Eval      ZFieldA = %Subst(#1SAmt:X:Y)
     C                   Eval      ZDec = PNBDP
     C                   Eval      ZADig = 15 - ZDec
     C                   CallB     'ZALIGN'
     C                   Parm                    ZalignOk
     C                   Parm                    ZFieldA
     C                   Parm                    ZDec
     C                   Parm                    ZADig
      *
     C                   If        ZAlignOk ='N'
     C                   Eval      WError  = *On
     C                   Eval      *In61 = *On
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'FXM6001'
 
      * Format for screen display
     C                   Else
     C                   Move      ZFieldA       #PDBUY
     C                   Move      ZFieldA       ZField
     C                   CallB     'ZFRPED'
     C                   Parm                    ZField
     C                   Parm                    ZDec
     C                   Parm      'L'           ZECode
     C                   Parm                    ZOut22
     C                   Parm                    ZOut25
 
     C                   Movel     ZOut22        #1SAMT
     C                   Movel     ZOut22        #PSAMT
     C                   EndIf
     C                   EndIf
 
      ** Split Amount must be greater than 0
     C                   If        #PDBuy = *Zeros and #1SAMT <> *Blanks
     C                   Eval      WError  = *On
     C                   Eval      *In61 = *On
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'FXM6002'
     C                   EndIf
 
      ** Validate Sequence
     C                   If        #1SEQN  <> *Blanks
      ** Sequence selection request ?
     C     '?'           Scan      #1SEQN                                 99
     C                   If        *In99
     C                   Call(E)   'SD0912S'
     C                   Parm                    PRetCode
     C                   Parm      #1NCcy        PNCcy
     C                   Parm                    PCust
     C                   Parm      *Blanks       PSeqn
     C
      ** Call to SD0912S ended in error
     C                   If        %Error
     C                   Eval      WError  = *On
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'FXM6003'
     C                   Else
     C                   Eval      #1SEQN = PSeqn
     C                   EndIf
     C                   EndIf
 
      ** Search not requested
     C                   If        *In99 = *Off
     C                   Eval      ZFieldA = *Blanks
     C                   Eval      ZFieldA = #1SEQN
     C                   Eval      ZDec = 0
     C                   CallB     'ZALIGN'
     C                   Parm                    ZalignOk
     C                   Parm                    ZFieldA
     C                   Parm                    ZDec
     C                   Parm      4             ZADig
      *
     C                   If        ZAlignOk ='N'
     C                   Eval      WError  = *On
     C                   Eval      *In62 = *On
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'FXM6004'
 
      * Format for screen display
     C                   Else
     C                   Move      ZFieldA       #1SEQN
 
      ** Validate Sequence Number entered
     C                   Eval      KNCcy = #1NCcy
     C                   Eval      KCust = PCust
     C                   Move      #1SEQN        KSeqn
     C     KSDFNMS       Setll     SDFNMSL0
      ** Not Found Error
     C                   If        Not %Equal
     C                   Eval      WError  = *On
     C                   Eval      *In62 = *On
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(1) = 'FXM6005'
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
     C                   EndIf
      ** Validate Amount/Sequence Combination
     C                   If        (#1SAMT = *Blanks and #1SEQN <> *Blanks)
     C                   Eval      WError  = *On
     C                   Eval      *In61 = *On
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'FXM6006'
     C                   EndIf
 
     C                   If        (#1SAMT <> *Blanks and #1SEQN = *Blanks)
     C                   Eval      WError  = *On
     C                   Eval      *In62 = *On
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'FXM6007'
     C                   EndIf
 
      ** Validate '*'
     C                   If        #1AMND  <> '*' and #1AMND <> ' '
     C                   Eval      WError  = *On
     C                   Eval      *IN63 = *ON
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'FXM6008'
     C                   EndIf
 
     C                   Eval      SFleNxtChg = *On
     C                   UpDate    FX0925S1
 
      ** Page Full ?
     C     WkSRRN1       Div       8             WPage
     C                   MvR                     WLine
     C                   If        #1SAMT <> *Blanks and Wline = 0
     C                   Eval      PageFull = True
     C                   EndIf
 
     C                   If        #1SAMT = *Blanks and Wline = 0
     C                   Eval      PageFull = False
     C                   EndIf
 
      ** Read subfile
     C                   ReadC     FX0925S1
     C                   EndDo
 
     C                   Eval      SFleNxtChg = *Off
 
     C     EndValS1      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrcScn  - Process subfile screen                            *
      *                                                               *
      *****************************************************************
     C     SRPrcScn      BEGSR
 
     C                   Eval      WScrn = '1'
     C                   Eval      W1stRec = 'N'
     C                   Eval      WError  = *Off
 
      ** Read subfile
     C                   ReadC     FX0925S1
     C                   DoW       Not %Eof
 
     C                   Select
      ** Is record to be Added
     C                   When      #1SAMT <> *Blanks and #1SEQN <> *Blanks and
     C                             #DBUY = *Zeros and #PSEQN = *Blanks
     C                   Eval      WSplRec = WSplRec + 1
     C                   Exsr      SRAddRec
 
      ** Is record to be Deleted
     C                   When      #1SAMT = *Blanks and #1SEQN = *Blanks and
     C                             #DBUY <> *Zeros and #PSEQN <> *Blanks
     C                   Eval      WSplRec = WSplRec - 1
     C                   Exsr      SRDelRec
 
      ** Is record to be Changed
     C                   When      #DBUY <> #PDBUY or #1SEQN <> #PSEQN
     C                   Exsr      SRChgRec
 
     C                   Other
     C                   EndSl
 
      ** Validate '*'
     C                   If        #1AMND  = '*'
     C                   Eval      PSeqn = #1SEQN
     C                   Exsr      SRExtSet
     C                   Eval      #1AMND = *Blanks
     C                   EndIf
 
     C                   Eval      WTotNet = WTotNet + #DBuy
     C                   Eval      #PSEQN = #1SEQN
     C                   Eval      SFleNxtChg = *On
     C                   UpDate    FX0925S1
      ** Read subfile
     C                   ReadC     FX0925S1
     C                   EndDo
 
     C     EndPrcS1      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAddRec  - Add Split detail record                           *
      *                                                               *
      *****************************************************************
     C     SRAddRec      BEGSR
 
      ** Get existing 'Parent' Details
     C     PNetR         Chain     FXNETMPD
      ** Error if not found
     C                   If        Not %Found
     C     *Lock         In        LDA
     C                   Eval      DBFILE= 'FXNETMPD'
     C                   Eval      DBKEY = KNetR
     C                   Out       LDA
     C                   Exsr      *PSSR
      ** No Error
     C                   Else
     C                   Eval      #NETR  = AMNETR
     C                   Eval      #NTNO  = AMNTNO
     C                   Eval      #RECI  = AMRECI
     C                   Eval      #VALD  = AMVALD
     C                   Eval      #DCSN  = AMDCSN
     C                   Eval      #VDTY  = AMVDTY
     C                   Eval      #CCYD  = AMCCYD
     C                   Eval      #CCY1  = AMCCY1
     C                   Eval      #CCY2  = AMCCY2
     C                   Eval      #SEQN  = AMSEQN
     C                   Eval      #LSWC  = AMLSWC
     C                   Eval      #LSWS  = AMLSWS
     C                   Eval      #BRCA  = AMBRCA
     C                   Eval      #BSIN  = AMBSIN
     C                   Eval      #PRGI  = AMPRGI
     C                   Eval      #CNUM  = AMCNUM
     C                   Eval      #DBUY  = #PDBUY
     C                   Move      #1SEQN        #PSEQN
     C                   Move      #1SEQN        #SQNO
 
      ** Retrieve settlement Instructions
     C                   Eval      KNCcy = #1NCcy
     C                   Eval      KCust = PCust
     C                   Move      #1SEQN        KSeqn
     C     KSDFNMS       Chain     SDFNMSL0
      ** Error if not found
     C                   If        Not %Found
     C     *Lock         In        LDA
     C                   Eval      DBFILE= 'SDFNMSPD'
     C                   Eval      DBKEY = KNCCy + KCust + #1Seqn
     C                   Out       LDA
     C                   Exsr      *PSSR
      ** No Error
     C                   Else
      *  Treat Receive Instructions
     C                   If        AMBSIN = 'B'
     C                   Move      LRSTY         #SETM
      *  Setup our Nostro field
     C                   If        PMBIN = 'Y'
     C                   Eval      #ONOB = LORBR
     C                   EndIf
 
     C                   Move      LRONO         #OURN
      *  Receive Ordering Bank
     C                   Move      LROBN         #OBNK
      *  Receive Ordering Customer
     C                   Move      LROCS         #ORDC
      *
     C                   Eval      #IBNK = LRIBN
     C                   Eval      #IBNA = LRIBL
     C                   Eval      #CVMR = *Blanks
 
      **  Treat Pay instructions
     C                   Else
     C                   Move      LPSTY         #SETM
      **  Setup our Nostro field
     C                   Eval      #ONOB = LOPBR
     C                   Move      LPONO         #OURN
      **  Pay Ordering Bank
     C                   Move      LPOBN         #OBNK
      **  Pay Ordering Customer
     C                   Move      LPOCS         #ORDC
 
     C                   Eval      #CVMR = LCVMR
     C                   Eval      #IBNK = LPIBN
     C                   Eval      #IBNA = LPIBA
     C                   Eval      #RCRN = LRCNO
     C                   Eval      #RCRA = LRCAL
     C                   Eval      #RVNO = LRCNB
      **  Account With Bank
     C                   Eval      #AWBN = LACBN
     C                   Eval      #AWBA = LACBL
      **  Beneficiary
     C                   Eval      #BENN = LBYNB
     C                   Eval      #BENA = LBACL
 
     C                   Eval      #DTP1 = LDPY1
     C                   Eval      #DTP2 = LDPY2
     C                   Eval      #DTP3 = LDPY3
     C                   Eval      #DTP4 = LDPY4
 
     C                   Eval      #DCHG = LDECG
 
     C                   Eval      #BTB1 = LBBI1
     C                   Eval      #BTB2 = LBBI2
     C                   Eval      #BTB3 = LBBI3
     C                   Eval      #BTB4 = LBBI4
     C                   Eval      #BTB5 = LBBI5
     C                   Eval      #BTB6 = LBBI6
     C                   EndIf
 
     C                   EndIf
     C                   EndIf
 
     C     EndAddS1      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChgRec  - Change Split detail record                        *
      *                                                               *
      *****************************************************************
     C     SRChgRec      BEGSR
 
      * If Sequence changed get new instructions
     C                   Select
      * Change in sequence
     C                   When      #1SEQN <> #PSEQN
     C                   Exsr      SRAddRec
 
      * Change in Amount
     C                   When      #PDBUY <> #DBUY
     C                   Eval      #DBUY = #PDBUY
 
     C                   EndSl
 
     C     EndChgS1      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelRec  - Delete Split detail record                        *
      *                                                               *
      *****************************************************************
     C     SRDelRec      BEGSR
 
      ** Clear Subfile fields
     C                   Clear                   FX0925S1
 
     C     EndDelS1      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrMsg - Clear message subfile and data                     *
      *                                                               *
      *****************************************************************
     C     SRClrMsg      BEGSR
 
     C                   Clear                   MsgIdArr
     C                   Clear                   MsgDtaArr
     C                   Clear                   FldNameArr
     C                   Clear                   WMsgIdArr
     C                   Clear                   WMsgDtaArr
     C                   Clear                   WFldNamArr
     C                   Eval      Idx = 0
     C                   Eval      WIdx = 0
 
      ** Clear message subfile.
     C                   Call      'ZA0250'
 
      ** Reset error indicators
     C                   MoveA     '0'           *IN(31)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFmtDet - Format Details for Screen                         *
      *                                                               *
      *****************************************************************
     C     SrFmtDet      BEGSR
 
      ** Netting settlement details
     C                   If        ASBSIN = 'S'
     C                   Eval      Zfield = 0 - ASDBUY
     C                   Else
     C                   Eval      Zfield =  ASDBUY
     C                   EndIf
     C                   Eval      ZDec = PNBDP
     C                   CallB     'ZFRPED'
     C                   Parm                    ZField
     C                   Parm                    ZDec
     C                   Parm      'L'           ZECode
     C                   Parm                    ZOut22
     C                   Parm                    ZOut25
 
     C                   Movel     ZOut22        #1SAMT
     C                   Movel     ZOut22        #PSAMT
 
     C                   Move      ASSQNO        #1SEQN
     C                   Move      ASSQNO        #PSEQN
     C                   Eval      #PDBUY = ASDBUY
     C                   Eval      #NETR  = ASNETR
     C                   Eval      #NTNO  = ASNTNO
     C                   Eval      #RECI  = ASRECI
     C                   Eval      #VALD  = ASVALD
     C                   Eval      #DCSN  = ASDCSN
     C                   Eval      #VDTY  = ASVDTY
     C                   Eval      #CCYD  = ASCCYD
     C                   Eval      #CCY1  = ASCCY1
     C                   Eval      #CCY2  = ASCCY2
     C                   Eval      #SEQN  = ASSEQN
     C                   Eval      #LSWC  = ASLSWC
     C                   Eval      #LSWS  = ASLSWS
     C                   Eval      #BRCA  = ASBRCA
     C                   Eval      #DBUY  = ASDBUY
     C                   Eval      #BSIN  = ASBSIN
     C                   Eval      #PRGI  = ASPRGI
     C                   Eval      #CNUM  = ASCNUM
     C                   Eval      #SQNO  = ASSQNO
     C                   Eval      #SETM  = ASSETM
     C                   Eval      #ONOB  = ASONOB
     C                   Eval      #OURN  = ASOURN
     C                   Eval      #OBNK  = ASOBNK
     C                   Eval      #ORDC  = ASORDC
     C                   Eval      #IBNK  = ASIBNK
     C                   Eval      #IBNA  = ASIBNA
     C                   Eval      #CVMR  = ASCVMR
     C                   Eval      #RCRN  = ASRCRN
     C                   Eval      #RCRA  = ASRCRA
     C                   Eval      #RVNO  = ASRVNO
     C                   Eval      #AWBN  = ASAWBN
     C                   Eval      #AWBA  = ASAWBA
     C                   Eval      #BENN  = ASBENN
     C                   Eval      #BENA  = ASBENA
     C                   Eval      #DTP1  = ASDTP1
     C                   Eval      #DTP2  = ASDTP2
     C                   Eval      #DTP3  = ASDTP3
     C                   Eval      #DTP4  = ASDTP4
     C                   Eval      #DCHG  = ASDCHG
     C                   Eval      #BTB1  = ASBTB1
     C                   Eval      #BTB2  = ASBTB2
     C                   Eval      #BTB3  = ASBTB3
     C                   Eval      #BTB4  = ASBTB4
     C                   Eval      #BTB5  = ASBTB5
     C                   Eval      #BTB6  = ASBTB6
 
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRExtSet  setup amendable screen fields using File fields     *
      *                                                               *
      *****************************************************************
     C     SRExtSet      BEGSR
 
     C                   Clear                   Parm2
     C                   Clear                   Parm3
     C                   Clear                   Parm4
      *
     C                   Eval      PMRUND = BJRDNB
     C                   Eval      PMBVPD = BJBVPD
     C                   Eval      PMRETP = PRETP
     C                   Eval      PMCHIM = PCHIM
     C                   Eval      PMRETS = PRETS
     C                   Move      PPCYA         PMPCYA
 
      *  Treat Receive Instructions
     C                   If        #BSIN = 'B'
     C                   Eval      PMPRCV = 'N'
     C                   Eval      PMPPAY = 'Y'
     C                   Eval      PMRSTM = #SETM
      *  Setup our Nostro field
     C                   If        #SETM = 05 and PMBIN = 'Y'
     C                   Eval      PMROBR = #ONOB
     C                   EndIf
     C                   Eval      PMRONS = #OURN
 
      *  Receive Ordering Bank
     C                   Movel     #OBNK         PMROBN
     C                   Movel     #OBNK         PAROBN
      *  Receive Ordering Customer
     C                   Movel     #ORDC         PMROCN
     C                   Movel     #ORDC         PAROCN
      *
     C                   Movel     #IBNK         PMRIBN
     C                   Movel     #IBNK         PARIBN
     C                   Eval      PMRIBA = #IBNA
      *                                                                N.
     C                   Else
      *  Treat Pay instructions
     C                   Eval      PMPRCV = 'Y'
     C                   Eval      PMPPAY = 'N'
     C                   Eval      PMPSTM = #SETM
      *  Setup our Nostro field
     C                   If        #SETM = 05 and PMBIN = 'Y'
     C                   Eval      PMPOBR = #ONOB
     C                   EndIf
     C                   Eval      PMPONS = #OURN
 
      *  Pay Ordering Bank
     C                   Movel     #OBNK         PMPOBN
     C                   Movel     #OBNK         PAPOBN
      *  Pay Ordering Customer
     C                   Movel     #ORDC         PMPOCN
     C                   Movel     #ORDC         PAPOCN
      *
     C                   Movel     #IBNK         PMPIBN
     C                   Movel     #IBNK         PAPIBN
     C                   Eval      PMPIBA = #IBNA
      *
     C                   Movel     #RCRN         PMRCRN
     C                   Eval      PMRCRA = #RCRA
      *
     C                   Movel     #RVNO         PMRVNO
     C                   Movel     #RVNO         PARVNO
      *  Account With Bank
     C                   Movel     #AWBN         PMAWBN
     C                   Eval      PAAWBN = #AWBN
     C                   Eval      PMAWBA = #AWBA
      *  Beneficiary
     C                   Movel     #BENN         PMBENN
     C                   Eval      PABENN = #BENN
     C                   Eval      PMBENA = #BENA
      *
     C                   Eval      PMDTP1 = #DTP1
     C                   Eval      PMDTP2 = #DTP2
     C                   Eval      PMDTP3 = #DTP3
     C                   Eval      PMDTP4 = #DTP4
      *
     C                   Eval      PMDCHG = #DCHG
 
     C                   Eval      PMBTB1 = #BTB1
     C                   Eval      PMBTB2 = #BTB2
     C                   Eval      PMBTB3 = #BTB3
     C                   Eval      PMBTB4 = #BTB4
     C                   Eval      PMBTB5 = #BTB5
     C                   Eval      PMBTB6 = #BTB6
     C                   EndIf
 
     C                   Eval      PMDTRC = #VALD
     C                   Eval      PMDTPY = #VALD
     C                   Eval      PMRCCY = #CCYD
     C                   Eval      PMPCCY = #CCYD
     C                   Eval      PMFFND = 'N'
     C                   Eval      PMBRCA = #BRCA
     C                   Eval      PMACTC = PActn
      ** set enquiry conditions
     C                   If        PActn = 'E'
     C                   Eval      PMPPAY = 'Y'
     C                   Eval      PMPRCV = 'Y'
     C                   EndIf
      *
     C                   Eval      WCCY = %Subst(PNetR:8:3)
     C                   Eval      WSeq = %Subst(PNetR:17:3)
     C                   Eval      PDlNo = WCCY + WSeq
     C                   Eval      PMCVMR = #CVMR
     C                   Eval      PMCPGM = 'FXFX'
     C                   Eval      PMTTYP = 'NT'
     C                   Eval      PMCSNM = PCSNM
     C                   Eval      PMVALO = 'N'
     C                   Eval      PMSDTV = 'N'
     C                   Eval      PMFRST = 'Y'
     C                   Eval      PMCMDP = *Blanks
     C                   Eval      PMTERM = *Blanks
      *
     C                   Call      'SD2420'
     C                   Parm                    PRetCode
     C                   Parm                    PSeqn
     C                   Parm                    Parm2
     C                   Parm                    Parm3
     C                   Parm                    PDlNo
     C                   Parm                    Parm4
      *
      ** Terminate program if database error returned
     C                   If        PActn <> 'E'
     C                   If        #BSIN = 'B'
     C                   Eval      #SETM = PMRSTM
     C                   If        #SETM = 05 and PMBIN = 'Y'
     C                   Eval      #ONOB = PMROBR
     C                   EndIf
 
     C                   Eval      #OURN = PMRONS
     C                   Movel     PMROBN        #OBNK
     C                   Movel     PAROBN        #OBNK
     C                   Movel     PMROCN        #ORDC
     C                   Movel     PAROCN        #ORDC
     C                   Movel     PMRIBN        #IBNK
     C                   Movel     PARIBN        #IBNK
     C                   Eval      #IBNA = PMRIBA
 
     C                   Else
     C                   Eval      #SETM = PMPSTM
     C                   If        #SETM = 05 and PMBIN = 'Y'
     C                   Eval      #ONOB = PMPOBR
     C                   EndIf
 
     C                   Eval      #OURN = PMPONS
     C                   Movel     PMPOBN        #OBNK
     C                   Movel     PAPOBN        #OBNK
     C                   Movel     PMPOCN        #ORDC
     C                   Movel     PAPOCN        #ORDC
     C                   Movel     PMPIBN        #IBNK
     C                   Movel     PAPIBN        #IBNK
     C                   Eval      #IBNA = PMPIBA
     C                   Eval      #RCRA = PMRCRA
     C                   Movel     PMRCRN        #RCRN
     C                   Movel     PMRVNO        #RVNO
     C                   Movel     PARVNO        #RVNO
     C                   Movel     PMAWBN        #AWBN
     C                   Eval      #AWBN = PAAWBN
     C                   Eval      #AWBA = PMAWBA
     C                   Movel     PMBENN        #BENN
     C                   Eval      #BENN = PABENN
     C                   Eval      #BENA = PMBENA
     C                   Eval      #DTP1 = PMDTP1
     C                   Eval      #DTP2 = PMDTP2
     C                   Eval      #DTP3 = PMDTP3
     C                   Eval      #DTP4 = PMDTP4
     C                   Eval      #DCHG = PMDCHG
     C                   Eval      #BTB1 = PMBTB1
     C                   Eval      #BTB2 = PMBTB2
     C                   Eval      #BTB3 = PMBTB3
     C                   Eval      #BTB4 = PMBTB4
     C                   Eval      #BTB5 = PMBTB5
     C                   Eval      #BTB6 = PMBTB6
     C                   EndIf
 
     C                   Eval      #CCYD = PMRCCY
     C                   Eval      #CCYD = PMPCCY
     C                   Eval      #BRCA = PMBRCA
     C                   Eval      #CVMR = PMCVMR
 
     C                   If        PMErCd <> *Blanks
     C                   Eval      #SErr = 'Y'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'FXM1041'
 
     C                   Else
     C                   Eval      #SErr = ' '
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'FXM5001'
     C                   EndIf
     C                   EndIf
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate Update Split Settlement Instructions                 *
      *                                                               *
      *****************************************************************
     C     SrUpdFle      BEGSR
 
      ** Check all records valid
     C                   ReadC     FX0925S1
     C                   DoW       Not %Eof
      ** In Error?
     C                   If        #SERR = 'Y'
     C                   Eval      WSetErr = *On
     C                   MoveA     '11'          *In(61)
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'FXM1041'
     C                   Eval      SFleNxtChg = *On
     C                   UpDate    FX0925S1
     C                   Leave
     C                   EndIf
 
     C                   Eval      SFleNxtChg = *On
     C                   UpDate    FX0925S1
 
     C                   ReadC     FX0925S1
     C                   EndDo
 
     C                   If        WSetErr = *Off
      ** Delete previous instructions
     C     KNetR         Delete    FXNETSPD
     C                   Dow       %Found
     C     KNetR         Delete    FXNETSPD
     C                   EndDo
 
      ** Read subfile
     C                   ReadC     FX0925S1
     C                   DoW       Not %Eof
 
     C                   If        #1SAMT <> *Blanks
     C                   Eval      ASNETR = #NETR
     C                   Eval      ASNTNO = #NTNO
     C                   Eval      ASRECI = 'C'
     C                   Eval      ASVALD = #VALD
     C                   Eval      ASDCSN = #DCSN
     C                   Eval      ASVDTY = #VDTY
     C                   Eval      ASCCYD = #CCYD
     C                   Eval      ASCCY1 = #CCY1
     C                   Eval      ASCCY2 = #CCY2
     C                   Eval      ASSEQN = #SEQN
     C                   Eval      ASLSWC = #LSWC
     C                   Eval      ASLSWS = #LSWS
     C                   Eval      ASBRCA = #BRCA
     C                   Eval      ASDBUY = #DBUY
     C                   Eval      ASBSIN = #BSIN
     C                   Eval      ASPRGI = #PRGI
     C                   Eval      ASCNUM = #CNUM
     C                   Eval      ASSQNO = #SQNO
     C                   Eval      ASSETM = #SETM
     C                   Eval      ASONOB = #ONOB
     C                   Eval      ASOURN = #OURN
     C                   Eval      ASOBNK = #OBNK
     C                   Eval      ASORDC = #ORDC
     C                   Eval      ASIBNK = #IBNK
     C                   Eval      ASIBNA = #IBNA
     C                   Eval      ASCVMR = #CVMR
     C                   Eval      ASRCRN = #RCRN
     C                   Eval      ASRCRA = #RCRA
     C                   Eval      ASRVNO = #RVNO
     C                   Eval      ASAWBN = #AWBN
     C                   Eval      ASAWBA = #AWBA
     C                   Eval      ASBENN = #BENN
     C                   Eval      ASBENA = #BENA
     C                   Eval      ASDTP1 = #DTP1
     C                   Eval      ASDTP2 = #DTP2
     C                   Eval      ASDTP3 = #DTP3
     C                   Eval      ASDTP4 = #DTP4
     C                   Eval      ASDCHG = #DCHG
     C                   Eval      ASBTB1 = #BTB1
     C                   Eval      ASBTB2 = #BTB2
     C                   Eval      ASBTB3 = #BTB3
     C                   Eval      ASBTB4 = #BTB4
     C                   Eval      ASBTB5 = #BTB5
     C                   Eval      ASBTB6 = #BTB6
 
     C                   Movel     PChgDat       ASDTCH
     C                   Time                    ASCHTI
     C                   Eval      ASCHTY = 'A'
     C                   Eval      ASCHUS = PSUser
     C                   Eval      ASCHWS = PSJobName
      ** Write Record
     C                   Write     FXNETSD0
     C                   EndIf
 
     C                   ReadC     FX0925S1
     C                   EndDo
 
     C                   EndIf
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSndMsg - Send message to subfile                            *
      *                                                               *
      *****************************************************************
     C     SRSndMsg      BEGSR
 
      ** Send message to subfile
     C                   Eval      Idx = 1
     C                   DoW       MsgIdArr(Idx) <> *Blanks
     C                   Call      'ZA0350'
     C                   Parm                    PMsgFile
     C                   Parm      MsgIdArr(Idx) PMsgId
     C                   Parm      *Blanks       PMsgData
     C                   Eval      Idx = Idx + 1
     C                   EndDo
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry Parameters
     C     *ENTRY        PList
     C                   Parm                    PRetCode                       Return Code
     C                   Parm                    PParms3                    0138
     C                   Parm                    PChgDat                    0138
 
      ** Key List for SDFNMSL0
     C     KSDFNMS       KList
     C                   Kfld                    KNCcy                          Currency Code
     C                   Kfld                    KCust                          Customer Code
     C                   Kfld                    KSeqn                          Customer Code
 
      ** Key List for FXNETSPD
     C     KFXNETS       KList
     C                   Kfld                    KNetR                          Currency Code
     C                   Kfld                    KSeqn                          Customer Code
 
      ** Standing Data:
      ** Access bank details.
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       PRtcd
     C                   Parm      '*FIRST '     POptn
     C     SDBANK        Parm      SDBANK        DSFDY
 
      ** Database error
     C                   If        PRtcd <> *BLANK
     C     *Lock         In        LDA
     C                   Eval      DBFILE= 'SDBANKPD'
     C                   Eval      DBKEY = POptn
     C                   Eval      DBASE = 001
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Initialize program name
     C                   Eval      DBPGM = 'FX0925'
 
      ** Move workstation ID to screen field.
     C                   Eval      #1WID = PsJobName
     C                   Eval      #1USER = PsUser
 
     C                   Eval      *IN94 = *ON
     C                   Eval      #2PGMQ = '*'
 
     C                   Eval      FirstPass = 'Y'
     C                   Eval      WScrn = '1'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   Dump
 
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
 
     C                   If        RunBefore <> 'Y'
     C                   Eval      RunBefore = 'Y'
 
      ** Load RUNDAT
     C                   In        RUNDAT
 
      ** Load the APDUMP fields
     C     *Lock         In        APDUMP                               99
 
      ** If there is an error in reading the APDUMP data area, it
      ** probably doesn't exist, so call the procedure which creates it
      ** and try again.
     C                   If        *In99
     C                   Clear                   PSSRRetCde
     C                   Call      'APCCRTQTO'
     C                   Parm                    PSSRRetCde       10
 
     C     *Lock         In        APDUMP
     C                   EndIF
 
     C                   Eval      ARErrMod = PSProcMod
     C                   Out       APDUMP
     C                   Call      'DBERRCTL'
     C                   EndIf
 
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
