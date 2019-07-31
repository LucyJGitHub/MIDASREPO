     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Global Customer Details - Select')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000010S - Global Customer Details Select                   *
      *                                                               *
      *  Function:  This module displays the existing global customers*
      *             and allows the user to select one from the list.  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP001 - Global Processing                                   *
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
      *  SrReadItem - Read an item held in the Case Management        *
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
 
     FSD000010DFCF   E             WORKSTN
     F                                     SFILE(SD000010S1:WkSRRN1)
      ** Select Customer Global Details Screen
 
     FGPCUSTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Global Customer Details
 
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
     D Indicators      DS                  BASED(IndicatorP)
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
     D IndicatorP      S               *   INZ(%Addr(*IN))
      **---------------------------------------------------------
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Current Selection Fields
     D CurSelFlds      DS
     D  #2GCUS                       10A
     D  #2CNA1                       35A
     D  #2CRNM                       20A
     D  #2CRTN                       10A
 
      ** Previous Selection Fields
     D PrvSelFlds      DS
     D  WPGCUS                       10A
     D  WPCNA1                       35A
     D  WPCRNM                       20A
     D  WPCRTN                       10A
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters Used
 
      ** Parameters
     D PRetCode        S              7A
     D PGlbCustID      S             10A
 
      ** Parameters for QCLSCAN
     D PLength1        S              3  0
     D PStart          S              3  0
     D PLength2        S              3  0
     D PTranslate      S              1
     D PTrim           S              1
     D PWild           S              1
     D PResult         S              3  0
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Parameters for ZA0350
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgId          S             10A
     D PMsgData        S             45A
 
     D FirstPass       S              1A
     D KeyFlag         S              1A
     D WValid1         S              1A
     D WValid2         S              1A
     D WValid3         S              1A
     D WError          S              1A
     D W1stRec         S              1A
     D WScrn           S              1A
 
     D KGlbCustID      S             10A
     D WGlbCustID      S             10A
 
     D WLRcdNum        S              5  0
     D WkSRRN1         S              5  0
     D WkCnt           S              5  0
 
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
 
     C                   EXSR      SrBldSfl
 
      ** Display Screen
 
     C                   DOW       WScrn = '1'
     C                   EXSR      SrDspScn
     C                   ENDDO
 
     C                   IF        WScrn = 'T'
 
      ** Return to calling program
 
     C                   EVAL      PGlbCustID = *BLANKS
     C                   IF        PRetCode = *BLANKS and
     C                             WGlbCustID <> *BLANKS
     C                   EVAL      PGlbCustID = WGlbCustID
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBldSfl - Build Subfile                                     *
      *                                                               *
      *****************************************************************
     C     SrBldSfl      BEGSR
 
      ** If first time in
 
     C                   IF        FirstPass = 'Y'
 
      ** Clear subfile
 
     C                   EVAL      SFleClr = *ON
     C                   WRITE     SD000010C1
     C                   EVAL      SFleClr = *OFF
     C                   EVAL      WGlbCustID = *BLANKS
     C                   EVAL      ErrSelOpt = *OFF
     C                   EVAL      KeyFlag = 'N'
     C                   EVAL      FirstPass = 'N'
     C                   EVAL      WLRcdNum  = 0
     C                   EVAL      SFleEnd = *OFF
     C                   ENDIF
 
      ** Initialise count of records written to subfile page.
      ** Initialise subfile relative record number.
 
     C                   EVAL      WkCnt = 0
     C                   EVAL      WkSRRN1 = WLRcdNum
 
      ** Set file pointer on key displayed on screen.
 
     C                   SELECT
     C                   WHEN      KeyFlag = 'Y'
     C     KGlbCustID    SETLL     GPCUSTL0
     C                   WHEN      KeyFlag = 'R'
     C     KGlbCustID    SETGT     GPCUSTL0
     C                   WHEN      KeyFlag <> 'Y' and KeyFlag <> 'R'
     C     *LOVAL        SETLL     GPCUSTL0
     C                   ENDSL
 
      ** Read a Valid Transaction
 
     C                   EXSR      SrReadItem
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      RollUp = *ON
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 is input.
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       EndOfFile = *OFF and
     C                             WKCnt < 7
 
     C                   IF        WValid1 = 'Y' and WValid2 = 'Y' and
     C                             WValid3 = 'Y'
 
      ** Increment the subfile record no. and records written fields.
 
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN1 = WkSRRN1 + 1
 
      ** There is data so turn off NoData2Dsp indicator
 
     C                   EVAL      NoData2Dsp = *OFF
 
      ** Format transaction fields for output
 
     C                   EXSR      SrFmtDet
 
      ** Write details to the subfile.
 
     C                   Z-ADD     WkSRRN1       #1SFRN
     C                   WRITE     SD000010S1
     C                   MOVE      #1GCUS        KGlbCustID
 
     C                   ENDIF
 
      ** Read next record in file GPCUSTL0
 
     C                   EXSR      SrReadItem
     C                   ENDDO
 
      ** Set the record pointer to the previous record retrieved, using
      ** READPE if not yet end of file
 
     C                   IF        EndOfFile = False
     C     KGlbCustID    READPE    GPCUSTL0                               01
     C                   IF        EndOfFile = True
     C                   EVAL      SfleEnd = True
     C                   ENDIF
     C                   ELSE
     C                   EVAL      SFleEnd = True
     C                   ENDIF
 
      ** Save last relative record number to workfield to be use when rollup
      ** is pressed
 
     C                   Z-ADD     WkSRRN1       WLRcdNum
 
     C                   IF        WkCnt = 0
 
     C                   EVAL      MsgIdArr(1) = 'ASM0001'
 
      ** Write blank detail to subfile.
 
     C                   Z-ADD     1             WkSRRN1
     C                   Z-ADD     1             #1SFRN
     C                   CLEAR                   #1SEL
     C                   CLEAR                   #1GCUS
     C                   CLEAR                   #1CNA1
     C                   CLEAR                   #1CRNM
     C                   CLEAR                   #1CRTN
     C                   EVAL      NoData2Dsp = True
     C                   WRITE     SD000010S1
     C                   ELSE
     C                   EVAL      NoData2Dsp = False
     C                   ENDIF
 
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
 
     C                   EXSR      SRSndMsg
 
      ** Write the select screen footer to the screen.
      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.
 
     C                   WRITE     SD000010F1
     C                   EVAL      SflActive = True
     C                   WRITE     SD000010C2
     C                   EXFMT     SD000010C1
 
      ** Perform message subfile clear and message data clear
 
     C                   EXSR      SRClrMsg
 
      ** Select processing type
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      *INKC = True
     C                   EVAL      PRetCode  = '*NOSEL '
     C                   EVAL      WScrn = 'T'
 
      ** RollUp pressed
 
     C                   WHEN      RollUp = True
     C                   EVAL      KeyFlag = 'R'
     C                   EXSR      SRBldSfl
     C                   EVAL      WScrn = '1'
 
     C                   OTHER
     C                   EXSR      SRValScn
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValScn  - Validate subfile screen                           *
      *                                                               *
      *****************************************************************
     C     SRValScn      BEGSR
 
     C                   EVAL      WScrn = '1'
     C                   EVAL      W1stRec = 'N'
     C                   EVAL      WError  = 'N'
 
      ** Read subfile
 
     C                   READC     SD000010S1                             01
 
     C                   DOW       EndOfFile = False
 
     C                   IF        #1SEL  <> *BLANK
     C                   IF        #1SEL  = '1'
     C                   IF        W1stRec = 'N'
     C                   EVAL      W1stRec = 'Y'
     C                   EVAL      WGlbCustID = #1GCUS
     C                   ENDIF
     C                   ELSE
     C                   EVAL      ErrSelOpt  = *ON
     C                   EVAL      SFleNxtChg = *ON
     C                   UPDATE    SD000010S1
     C                   EVAL      SFleNxtChg = *OFF
     C                   EVAL      ErrSelOpt  = *OFF
     C                   EVAL      WGlbCustID = *BLANKS
     C                   EVAL      WError  = 'Y'
     C                   EVAL      MsgIdArr(1) = 'USR9173'
     C                   ENDIF
     C                   ENDIF
 
      ** Read subfile
 
     C                   READC     SD000010S1                             01
 
     C                   ENDDO
 
     C                   IF        CurSelFlds <> PrvSelFlds
     C                             and WError = 'N'
     C                             and WGlbCustID = *BLANKS
     C                   IF        #2GCUS <> *BLANKS
     C                   EVAL      KeyFlag = 'Y'
     C                   EVAL      KGlbCustID = #2GCUS
     C                   EVAL      SFleClr = True
     C                   WRITE     SD000010C1
     C                   EVAL      SFleClr = False
     C                   EVAL      WLRcdNum  = 0
     C                   EVAL      SFleEnd = False
     C                   ELSE
     C                   EVAL      FirstPass = 'Y'
     C                   EVAL      KeyFlag = 'N'
     C                   ENDIF
     C                   EVAL      PrvSelFlds = CurSelFlds
     C                   EXSR      SRBldSfl
     C                   EVAL      WScrn = '1'
     C                   ENDIF
 
     C                   IF        WError = 'N' and WGlbCustID <> *BLANKS
     C                   EVAL      PGlbCustID = WGlbCustID
     C                   EVAL      WScrn = 'T'
     C                   ENDIF
 
     C     EndValS1      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrMsg - Clear message subfile and data                     *
      *                                                               *
      *****************************************************************
     C     SRClrMsg      BEGSR
 
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WFldNamArr
     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0
 
      ** Clear message subfile.
 
     C                   CALL      'ZA0250'
 
      ** Reset error indicators
 
     C                   MOVEA     '0'           *IN(31)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReadItem - Read an item held in the Case Management        *
      *                                                               *
      *****************************************************************
     C     SrReadItem    BEGSR
 
      ** Reset End of File and skip record indicator
 
     C                   EVAL      EndOfFile = *OFF
 
      ** Reset Check if valid
 
     C                   EVAL      WValid1 = 'Y'
     C                   EVAL      WValid2 = 'Y'
     C                   EVAL      WValid3 = 'Y'
 
      ** Read first record.
 
 
     C                   READ      GPCUSTL0                               01
 
      ** Select according to Customer Name and Address 1
 
     C                   IF        #2CNA1  <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CUCNA1
     C                   PARM      35            PLength1
     C                   PARM      1             PStart
     C                   PARM                    #2CNA1
     C                   PARM      35            PLength2
     C                   PARM      '1'           PTranslate
     C                   PARM      '1'           PTrim
     C                   PARM      '?'           PWild
     C                   PARM                    PResult
     C                   IF        PResult < 1
     C                   EVAL      WValid1 = 'N'
     C                   ENDIF
     C                   ENDIF
 
      ** Select according to report name
 
     C                   IF        #2CRNM  <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CUCRNM
     C                   PARM      20            PLength1
     C                   PARM      1             PStart
     C                   PARM                    #2CRNM
     C                   PARM      20            PLength2
     C                   PARM      '1'           PTranslate
     C                   PARM      '1'           PTrim
     C                   PARM      '?'           PWild
     C                   PARM                    PResult
     C                   IF        PResult < 1
     C                   EVAL      WValid2 = 'N'
     C                   ENDIF
     C                   ENDIF
 
      ** Select according to report town
 
     C                   IF        #2CRTN  <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CUCRTN
     C                   PARM      10            PLength1
     C                   PARM      1             PStart
     C                   PARM                    #2CRTN
     C                   PARM      10            PLength2
     C                   PARM      '1'           PTranslate
     C                   PARM      '1'           PTrim
     C                   PARM      '?'           PWild
     C                   PARM                    PResult
     C                   IF        PResult < 1
     C                   EVAL      WValid3 = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFmtDet - Format Details for Output                         *
      *                                                               *
      *****************************************************************
     C     SrFmtDet      BEGSR
 
      ** Global Customer Details
 
     C                   EVAL      #1GCUS = CUGCUS
     C                   EVAL      #1CNA1 = CUCNA1
     C                   EVAL      #1CRNM = CUCRNM
     C                   EVAL      #1CRTN = CUCRTN
 
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
 
     C                   EVAL      Idx = 1
     C                   DOW       MsgIdArr(Idx) <> *BLANKS
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM      MsgIdArr(Idx) PMsgId
     C                   PARM      *BLANKS       PMsgData
     C                   EVAL      Idx = Idx + 1
     C                   ENDDO
 
     C                   EVAL      Idx = 1
     C                   DOW       WMsgIdArr(Idx) <> *BLANKS
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM      WMsgIdArr(Idx)PMsgId
     C                   PARM      *BLANKS       PMsgData
     C                   EVAL      Idx = Idx + 1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Return Code
      ** Global Customer ID
 
     C                   PARM                    PRetCode
     C                   PARM                    PGlbCustID
 
      ** Standing Data:
 
      ** Access bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE= 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SD000010S'
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      #1WID = PsJobName
     C                   EVAL      #1USER = PsUser
 
     C                   EVAL      *IN94 = *ON
     C                   EVAL      #2PGMQ = '*'
 
     C                   EVAL      FirstPass = 'Y'
     C                   EVAL      WScrn = '1'
 
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
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   IF        RunBefore <> 'Y'
 
     C                   EVAL      RunBefore = 'Y'
 
      ** Load the APDUMP fields
 
     C     *LOCK         IN        APDUMP                               99
 
      ** If there is an error in reading the APDUMP data area, it
      ** probably doesn't exist, so call the procedure which creates it
      ** and try again.
 
     C                   IF        *IN99
 
     C                   CLEAR                   PSSRRetCde
     C                   CALL      'APCCRTQTO'
     C                   PARM                    PSSRRetCde       10
 
     C     *LOCK         IN        APDUMP
 
     C                   ENDIF
 
     C                   EVAL      ARErrMod = PSProcMod
     C                   OUT       APDUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2003
