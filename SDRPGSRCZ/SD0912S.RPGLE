     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FX Netting Multiple Settlements Select')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0912S - FX Netting Multiple Settlements Select             *
      *                                                               *
      *  Function:  This module displays the Netting Multiple         *
      *             settlement Details and allows the user to select  *
      *             one from the list.                                *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CDL025  *CREATE    Date 07Nov04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
     FSD0912DF  CF   E             WORKSTN
     F                                     SFILE(SD0912S1:WkSRRN1)
      ** Select Customer Global Details Screen
 
     FSDFNMSL0  IF   E           K DISK    INFSR(*PSSR)
      **FX Netting Multiple Settlements File
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **----------------------------------------------------------------
 
      **----------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **----------------------------------------------------------------
 
      **----------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **----------------------------------------------------------------
 
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
     D  ErrSelOpt             31     31
     D  NoData2Dsp            40     40
     D  SflActive             92     92
     D  MsgSFleEnd            94     94
     D  SFleNxtChg            95     95
     D  SFleEnd               96     96
     D  SFleClr               97     97
     D  RollUp                98     98
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   Inz(%Addr(*In))
      **---------------------------------------------------------
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  ExtName(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  ExtName(DSFDY)
 
      ** Current Selection Fields
     D PParms          DS
     D  #1CyCd                        3A
     D  #1Cust                        6A
     D  #1Seqn                        4A
 
      ** Previous Selection Fields
     D WParms          DS
     D  WCyCd                         3A
     D  WCust                         6A
     D  WSeqn                         4A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters Used
 
      ** Parameters
     D PRetCode        S              7A
     D PCyCd           S              3A
     D PCust           S              6A
     D PSeqn           S              4A
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Parameters for ZA0350
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgId          S             10A
     D PMsgData        S             45A
 
     D FirstPass       S              1A
     D KeyFlag         S              1A
     D WError          S              1A
     D W1stRec         S              1A
     D WScrn           S              1A
 
     D KCycd           S                   Like(LCyCd)
     D KCust           S                   Like(LCust)
     D KSeqn           S                   Like(LSeqn)
 
     D WLRcdNum        S              5S 0
     D WkSRRN1         S              5S 0
     D WkCnt           S              5S 0
 
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
 
      ** Build Sub-file
     C                   Exsr      SrBldSfl
 
      ** Display Screen
     C                   DoW       WScrn = '1'
     C                   Exsr      SrDspScn
     C                   EndDo
 
     C                   If        WScrn = 'T'
      ** Return to calling program
     C                   Eval      PParms  = *Blanks
     C                   If        PRetCode = *Blanks and
     C                             WParms <> *Blanks
     C                   Eval      PSeqn = WSeqn
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
     C                   Write     SD0912C1
     C                   Eval      SFleClr = *OFF
     C                   Eval      WParms = *BLANKS
     C                   Eval      ErrSelOpt = *OFF
     C                   Eval      KeyFlag = 'N'
     C                   Eval      FirstPass = 'N'
     C                   Eval      WLRcdNum  = 0
     C                   Eval      SFleEnd = *OFF
     C                   EndIf
 
      ** Initialise count of records written to subfile page.
      ** Initialise subfile relative record number.
     C                   Eval      WkCnt = 0
     C                   Eval      WkSRRN1 = WLRcdNum
 
      ** Set file pointer on key displayed on screen.
     C                   Eval      KCyCd = PCyCd
     C                   Eval      KCust = PCust
     C                   Eval      KSeqn = *Zeros
     C     KSDFNMS       Setll     SDFNMSL0
 
      ** Read a Valid Transaction
     C     KSDFNMS       ReadE     SDFNMSL0
 
      ** Set on ROLLUP indicator to drive initial loop.
     C                   Eval      RollUp = *ON
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 is input.
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
     C                   DoW       Not %Eof and WkCnt < 14
 
      ** Increment the subfile record no. and records written fields.
     C                   Eval      WkCnt = WkCnt + 1
     C                   Eval      WkSRRN1 = WkSRRN1 + 1
 
      ** Format transaction fields for output
     C                   Exsr      SrFmtDet
 
      ** Write details to the subfile.
     C                   Eval      #1SFRN = WkSRRN1
     C                   Write     SD0912S1
 
 
      ** Read next record in file SDFNMSL0
 
     C     KSDFNMS       ReadE     SDFNMSL0
     C                   EndDo
 
      ** Set the record pointer to the previous record retrieved, using
      ** READPE if not yet end of file
 
     C                   If        Not %Eof
     C     KSDFNMS       ReadPE    SDFNMSL0
     C                   If        %Eof
     C                   Eval      SfleEnd = True
     C                   EndIf
     C                   Else
     C                   Eval      SFleEnd = True
     C                   EndIf
 
      ** Save last relative record number to workfield to be use when rollup
      ** is pressed
     C                   Eval      WLRcdNum = WkSRRN1
 
     C                   If        WkCnt = 0
     C                   Eval      MsgIdArr(1) = 'ASM0001'
 
      ** Write blank detail to subfile.
     C                   EvaL      WkSRRN1 = 1
     C                   EvaL      #1SFRN = 1
     C                   Clear                   #1SEL
     C                   Clear                   #1CYCD
     C                   Clear                   #1CUST
     C                   Clear                   #1SEQN
     C                   Clear                   #1TRTY
     C                   Eval      NoData2Dsp = True
     C                   Write     SD0912S1
     C                   Else
     C                   Eval      NoData2Dsp = False
     C                   EndIF
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDspScn - Display Subfile Screen                            *
      *                                                               *
      *****************************************************************
     C     SrDspScn      BEGSR
 
      ** Send message to subfile if any.
     C                   Exsr      SRSndMsg
 
      ** Write the select screen footer to the screen.
      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.
     C                   Write     SD0912F1
     C                   Eval      SflActive = True
     C                   Write     SD0912C2
     C                   Exfmt     SD0912C1
 
      ** Perform message subfile clear and message data clear
     C                   Exsr      SRClrMsg
 
      ** Select processing type
     C                   Select
      ** F3 Pressed
     C                   When      *INKC = True
     C                   Eval      PRetCode  = '*NOSEL '
     C                   Eval      WScrn = 'T'
 
      ** RollUp pressed
     C                   When      RollUp = True
     C                   Eval      KeyFlag = 'R'
     C                   Exsr      SRBldSfl
     C                   Eval      WScrn = '1'
 
     C                   Other
     C                   Exsr      SRValScn
 
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
     C                   Eval      WError  = 'N'
 
      ** Read subfile
     C                   ReadC     SD0912S1
     C                   DoW       Not %Eof
 
     C                   If        #1SEL  <> *Blanks
     C                   If        #1SEL  = '1'
     C                   If        W1stRec = 'N'
     C                   Eval      W1stRec = 'Y'
     C                   Eval      WCyCd = #1CYCD
     C                   Eval      WCust = #1CUST
     C                   Eval      WSeqn = #1SEQN
     C                   EndIf
 
     C                   Else
     C                   Eval      ErrSelOpt  = *ON
     C                   Eval      SFleNxtChg = *ON
     C                   UpDate    SD0912S1
 
     C                   Eval      SFleNxtChg = *OFF
     C                   Eval      ErrSelOpt  = *OFF
     C                   Eval      WCyCd = *Blanks
     C                   Eval      WCust = *Blanks
     C                   Eval      WSeqn = *Blanks
     C                   Eval      WError  = 'Y'
     C                   Eval      MsgIdArr(1) = 'USR9173'
     C                   EndIf
     C                   EndIf
 
      ** Read subfile
     C                   ReadC     SD0912S1
     C                   EndDo
 
     C                   If        WError = 'N' and WParms <> *Blanks
     C                   Eval      PParms = WParms
     C                   Eval      WScrn = 'T'
     C                   EndIf
 
     C     EndValS1      ENDSR
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
      *  SrFmtDet - Format Details for Output                         *
      *                                                               *
      *****************************************************************
     C     SrFmtDet      BEGSR
 
      ** Netting settlement details
     C                   Eval      #1CUST = LCUST
     C                   Eval      #1CYCD = LCYCD
     C                   Move      LSEQN         #1SEQN
     C                   Eval      #1TRTY = LTRTY
 
     C                   ENDSR
      ******************************************************************
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
     C                   Parm                    PCyCd                          Currency Code
     C                   Parm                    PCust                          Customer Code
     C                   Parm                    PSeqn                          Sequence Number
 
      ** Key List for SDFNMSL0
     C     KSDFNMS       KList
     C                   Kfld                    KCyCd                          Currency Code
     C                   Kfld                    KCust                          Customer Code
 
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
     C                   Eval      DBPGM = 'SD0912S'
 
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
(c) Finastra International Limited 2003
