     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Global industry code - select')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000011S - Global Industry Code Select                      *
      *                                                               *
      *  Function:  This module displays a list of existing industry  *
      *             codes for the user to select.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
     FSD000011DFCF   E             WORKSTN
     F                                     SFILE(SD000011S1 : #1SFRN)
      ** Midas SD Select Global Industry Code
 
     FGPINDSL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GP Global Industries
 
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
     D  #2GIND                       10A
     D  #2DESC                       50A
 
      ** Previous Selection Fields
     D PrvSelFlds      DS
     D  WPGIND                       10A
     D  WPDESC                       50A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters Used
     D PRetCode        S              7A
     D PGlbIndCde      S             10A
 
      ** Parameters for QCLSCAN
     D PLength1        S              3  0
     D PStart          S              3  0
     D PLength2        S              3  0
     D PTranslate      S              1A
     D PTrim           S              1A
     D PWild           S              1A
     D PResult         S              3  0
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
 
      ** Parameters for ZA0350
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgId          S             10A
     D PMsgData        S             45A
 
     D FirstPass       S              1A
     D KeyFlag         S              1A
     D WValid1         S              1A
     D WError          S              1A
     D W1stRec         S              1A
     D WScrn           S              1A
 
     D KGlbIndCde      S             10A
     D WGlbIndCde      S             10A
 
     D WkSRRN1         S              5  0
     D WkCnt           S              5  0
     D WSelCnt         S              2  0
     D WRun            S              1A
 
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
 
     C                   EVAL      PGlbIndCde = *BLANKS
     C                   IF        PRetCode = *BLANKS AND
     C                             WGlbIndCde <> *BLANKS
     C                   EVAL      PGlbIndCde = WGlbIndCde
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
     C                   WRITE     SD000011C1
     C                   EVAL      SFleClr = *OFF
     C                   EVAL      WGlbIndCde = *BLANKS
     C                   EVAL      ErrSelOpt = *OFF
     C                   EVAL      KeyFlag = 'N'
     C                   EVAL      FirstPass = 'N'
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      WkSRRN1 = *ZERO
     C                   EVAL      SFleEnd = *OFF
     C                   ENDIF
 
      ** Initialise count of records written to subfile page.
 
     C                   EVAL      WkCnt = *ZERO
 
      ** Set file pointer on key displayed on screen.
 
     C                   SELECT
     C                   WHEN      KeyFlag = 'Y'
     C     KGlbIndCde    SETLL     GPINDSL0
     C                   WHEN      KeyFlag = 'R'
     C     KGlbIndCde    SETGT     GPINDSL0
     C                   WHEN      KeyFlag <> 'Y' and KeyFlag <> 'R'
     C     *LOVAL        SETLL     GPINDSL0
     C                   ENDSL
 
      ** Read a Valid Transaction
 
     C                   EXSR      SrReadItem
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      RollUp = *ON
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       EndOfFile = *OFF AND
     C                             WKCnt < 14
 
     C                   IF        WValid1 = 'Y'
 
      ** Increment the subfile record no. and records written fields.
 
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN1 = WkSRRN1 + 1
 
      ** There is data so turn off NoData2Dsp indicator
 
     C                   EVAL      NoData2Dsp = *OFF
 
      ** Format transaction fields for output
 
     C                   EXSR      SrFmtDet
 
      ** Write details to the subfile.
 
     C                   Z-ADD     WkSRRN1       #1SFRN
     C                   WRITE     SD000011S1
     C                   MOVE      #1GIND        KGlbIndCde
 
     C                   ENDIF
 
      ** Read next record in file GPINDSL0
 
     C                   EXSR      SrReadItem
     C                   ENDDO
 
      ** Set the record pointer to the previous record retrieved, using
      ** READPE if not yet end of file
 
     C                   IF        EndOfFile = False
     C     KGlbIndCde    READPE    GPINDSL0                               01
     C                   IF        EndOfFile = True
     C                   EVAL      SfleEnd = True
     C                   ENDIF
     C                   ELSE
     C                   EVAL      SFleEnd = True
     C                   ENDIF
 
      ** No details to display
 
     C                   IF        WkCnt = *ZERO
     C                   EVAL      MsgIdArr(1) = 'GPM0003'
     C                   Z-ADD     1             WkSRRN1
     C                   Z-ADD     1             #1SFRN
     C                   CLEAR                   #1SEL
     C                   CLEAR                   #1GIND
     C                   CLEAR                   #1DESC
     C                   EVAL      NoData2Dsp = True
     C                   WRITE     SD000011S1
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
 
     C                   WRITE     SD000011F1
     C                   EVAL      SflActive = True
     C                   WRITE     SD000011C2
     C                   EXFMT     SD000011C1
 
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
 
      ** Validate user input
 
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
     C                   EVAL      WSelCnt = *ZERO
     C                   EVAL      Idx = *ZERO
 
      ** Read subfile
 
     C                   READC     SD000011S1                             01
 
     C                   DOW       EndOfFile = False
     C                   EVAL      ErrSelOpt  = *OFF
 
     C                   IF        #1SEL <> *BLANK
 
     C                   EVAL      WSelCnt = WSelCnt + 1
 
     C                   IF        #1SEL = '1'
     C                   IF        W1stRec = 'N'
     C                   EVAL      W1stRec = 'Y'
     C                   EVAL      WGlbIndCde = #1GIND
     C                   ENDIF
     C                   ENDIF
 
      ** Action Code must be '1' (Select).
 
     C                   IF        #1SEL <> '1'
     C                   EVAL      ErrSelOpt  = *ON
     C                   EVAL      WGlbIndCde = *BLANKS
     C                   EVAL      WError  = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'GPM0001'
     C                   ENDIF
 
      ** Only one option can be selected.
 
     C                   IF        WSelCnt > 1
     C                   EVAL      ErrSelOpt  = *ON
     C                   EVAL      WGlbIndCde = *BLANKS
     C                   EVAL      WError  = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'GPM0002'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      SFleNxtChg = *ON
     C                   UPDATE    SD000011S1
     C                   EVAL      SFleNxtChg = *OFF
 
      ** Read subfile
 
     C                   READC     SD000011S1                             01
 
     C                   ENDDO
 
     C                   IF        WError = 'N' AND
     C                             WGlbIndCde = *BLANKS
 
     C                   IF        #2GIND <> *BLANKS
     C                   EVAL      KeyFlag = 'Y'
     C                   EVAL      KGlbIndCde = #2GIND
     C                   EVAL      SFleClr = *ON
     C                   WRITE     SD000011C1
     C                   EVAL      SFleClr = *OFF
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      WkSRRN1 = *ZERO
     C                   EVAL      SFleEnd = *OFF
     C                   ELSE
     C                   EVAL      FirstPass = 'Y'
     C                   EVAL      KeyFlag = 'N'
     C                   ENDIF
 
     C                   EXSR      SRBldSfl
     C                   EVAL      WScrn = '1'
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        WError = 'N' AND
     C                             WGlbIndCde <> *BLANKS
     C                   EVAL      PGlbIndCde = WGlbIndCde
     C                   EVAL      WScrn = 'T'
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        WkCnt = *ZERO
     C                   EVAL      MsgIDArr(1) = 'GPM0003'
     C                   EVAL      WScrn = '1'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDSR
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
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
      ** Reset error indicators
 
     C                   EVAL      ErrSelOpt = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReadItem - Read an item held in the Global industry code   *
      *                                                               *
      *****************************************************************
     C     SrReadItem    BEGSR
 
      ** Reset End of File and skip record indicator
 
     C                   EVAL      EndOfFile = *OFF
 
      ** Reset check if valid
 
     C                   EVAL      WValid1 = 'Y'
 
      ** Read first record
 
     C                   READ      GPINDSL0                               01
 
      ** Select according to Industry description
 
     C                   IF        #2DESC  <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    IDDESC
     C                   PARM      50            PLength1
     C                   PARM      1             PStart
     C                   PARM                    #2DESC
     C                   PARM      50            PLength2
     C                   PARM      '1'           PTranslate
     C                   PARM      '1'           PTrim
     C                   PARM      '?'           PWild
     C                   PARM                    PResult
     C                   IF        PResult < 1
     C                   EVAL      WValid1 = 'N'
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
 
     C                   EVAL      #1SEL = *BLANK
     C                   EVAL      #1GIND = IDGIND
     C                   EVAL      #1DESC = IDDESC
 
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
     C                   PARM                    PGlbIndCde
 
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
 
     C                   EVAL      DBPGM = 'SD000011S'
 
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
      *  *PSSR - Program Exception Subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun <> 'Y'
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
** CPY@
(c) Misys International Banking Systems Ltd. 2003
