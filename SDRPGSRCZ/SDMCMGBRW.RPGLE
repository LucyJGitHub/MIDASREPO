     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Case Management - browse')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDMCMGBRW - Case Management Browse                           *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of held items in the Case      *
      *             Management.  The other picks off the selection    *
      *             made.                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD019             Date 02Jun03               *
      *  Prev Amend No. CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD019 - Midas Compliance Watch - Entry Level Watch List     *
      *           Checking                                            *
      *  CSD015 - Midas Compliance Watch                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Use for LOOKUP command                          *
      *    02         Use for LOOKUP command                          *
      *    03         Use for LOOKUP command                          *
      *    04         Use for READC command                           *
      *    40         'E=Watch List Match' Display File Indicator     *                       CSD019
      *    80         No Data to Display                              *
      *    92         DSPATR(RI PC)                                   *
      *    93         DSPATR(ND)                                      *
      *    94         SFLEND MSG SUBFILE CONTRL                       *
      *    95         SFLNXTCHG                                       *
      *    96         SFLEND SELECT SCREEN CONTROL                    *
      *    97         SFLCLR                                          *
      *    98         Rollup                                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrBldSfl   - Build Subfile                                   *
      *  SrRdSflR   - Read Subfile Record                             *
      *  SrFmtDet   - Format Details for Output                       *
      *  SrReadItem - Read an item held in the Case Management        *
      *  SrChAutN   - Check for User Authority if not multi-branching *
      *  SrInit     - Initialization                                  *
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
 
     FSDMCMGBDF CF   E             WORKSTN
     F                                     SFILE(SDMCMGS1:#1SFRN)
      ** Case Management Browse Display File
 
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Compliance Watch Hit List(FType/Identifier/Branch)
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      ** Table of field numbers and names
 
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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
 
     D PreviousSel     DS
     D  PR#1SFUNT              1      8
     D  PR#1SIDEN              9     48
     D  PR#1SBRCH             49     51
     D  PR#1SHSTS             52     61
     D  PR#1SUNCF             62     62
     D  PR#1STREL             63     63
 
     D CurrentSel      DS
     D  #1SFUNT                1      8
     D  #1SIDEN                9     48
     D  #1SBRCH               49     51
     D  #1SHSTS               52     61
     D  #1SUNCF               62     62
     D  #1STREL               63     63
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters Used
 
      ** Input Parameters
     D #1OPTN          S              1
     D PFuntPtr        S              8A
     D PIdenPtr        S             40A
     D PBrchPtr        S              3A
     D PBdSfl          S              1
     D PRdSfl          S              1
     D OKOPTN          S              1A
     D OKITEM          S              1A
     D IDx             S              3P 0
     D BJMRDT          S              7
     D BJSBRC          S              3
     D CSD019          S              1A                                                      CSD019
 
      ** Output Parameters
     D PErrMs          S              7
     D POpSel          S              1
     D PFuntSel        S              8
     D PIdenSel        S             40
     D PBrchSel        S              3
     D PINKC           S              1
     D PINKE           S              1
 
      ** Parameters for QCLSCAN
     D PLength1        S              3  0
     D PStart          S              3  0
     D PLength2        S              3  0
     D PTranslate      S              1
     D PTrim           S              1
     D PWild           S              1
     D PResult         S              3  0
 
      ** Parameters for ZVACTU
     D PAction         S              1
     D PError          S              1  0
 
     D WEofF           S              1
     D WFirst          S              1
     D WCount          S              3  0
     D WRelRecNo       S              5  0
 
     D KFunt           S              8A
     D KIden           S             40A
     D KBrch           S              3A
 
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
 
      ** Set up the transaction reference to be used by the message handler
 
     C                   EVAL      TranRef = #1FUNT
     C                   EVAL      ActionCode = #1OPTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Initialization
 
     C                   EXSR      SrInit
 
      ** Build Sub-file
 
     C                   IF        PBdSfl = 'Y'
 
     C                   EXSR      SrBldSfl
 
     C                   ENDIF
 
      ** Read Subfile Record
 
     C                   IF        PRdSfl = 'Y'
 
     C                   EXSR      SrRdSflR
 
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBldSfl - Build Subfile                                     *
      *                                                               *
      *****************************************************************
     C     SrBldSfl      BEGSR
 
     C                   EVAL      PreviousSel = CurrentSel
 
      ** Check for user Authority to Browse if not multi-branching
 
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      SrChAutN
     C                   ENDIF
 
      ** Move Item Details (FOR POINTER)
 
     C                   MOVE      PFuntPtr      KFunt
     C                   MOVE      PIdenPtr      KIden
     C                   MOVE      PBrchPtr      KBrch
 
      ** Initialise subfile relative record number.
 
     C                   Z-ADD     0             WRelRecNo
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
 
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDMCMGC1
     C                   EVAL      *IN97 = *OFF
 
      ** Set file pointer on key displayed on screen.
 
     C     K_Sdcwhtl1    SETLL     SDCWHTL1
 
      ** Read a Valid Transaction
 
     C                   EXSR      SrReadItem
 
      ** Set up message 'no data to display'
 
     C                   EVAL      *IN80 = *OFF
     C                   IF        WEofF = 'Y'
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN98 = *ON
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 is input.
 
     C                   DOW       *IN98 = *ON
 
      ** Initialise count of records written to subfile page.
 
     C                   Z-ADD     0             WCount
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       WEofF <> 'Y' and
     C                             WCount < 14
 
      ** Increment the subfile record no. and records written fields.
 
     C                   ADD       1             WRelRecNo
     C                   ADD       1             WCount
 
      ** Format transaction fields for output
 
     C                   EXSR      SrFmtDet
 
      ** Write the transaction to the subfile.
 
      ** If action code or item selected is invalid the subfile
      ** positions on the error record and rebuilds
 
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   IF        WRelRecNo <> 1
     C                   EVAL      #1OPTN = *BLANK
     C                   ELSE
     C     '#1OPTN    '  LOOKUP    FldNameArr                             01
     C     '#1ITEM    '  LOOKUP    FldNameArr                             02
     C     'USR9629'     LOOKUP    MsgIdArr                               03
     C                   IF        *IN01 <> *ON and
     C                             *IN02 <> *ON
     C                   EVAL      #1OPTN = *BLANK
     C                   ELSE
     C                   IF        *IN03 <> *ON
     C                   EVAL      *IN92 = *ON
     C                   EVAL      *IN95 = *ON
     C                   ELSE
     C                   EVAL      #1OPTN = *BLANK
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     WRelRecNo     #1SFRN
     C                   WRITE     SDMCMGS1
 
      ** Read a valid item in the Case Management
 
     C                   EXSR      SrReadItem
     C                   ENDDO
 
      ** Set up footer toggle text and write the footer
 
     C                   WRITE     SDMCMGF0
 
      ** Write the message subfile
 
     C                   WRITE     SDMCMGC0
 
      ** If there is no data to display, set on SFLCLR condition and
      ** write the subfile control record
 
     C                   IF        WCount = 0
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDMCMGC1
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      WRelRecNo = 1
     C                   EVAL      #1SFRN = 1
 
      ** Write to the subfile with non-display set on
 
     C                   EVAL      *IN93 = *ON
     C                   WRITE     SDMCMGS1
     C                   EVAL      *IN93 = *OFF
     C                   WRITE     SDMCMGC1
     C                   ELSE
 
     C                   WRITE     SDMCMGC1
     C                   ENDIF
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
 
     C                   READ      SDMCMGC1
 
      ** Clear any messages before processing user input
 
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
     C                   EVAL      IDx = *ZERO
 
      ** If F3, bypass further processing.
 
     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If F5, initialize the selection fields to blanks.
 
     C                   IF        *INKE = *ON
     C                   EVAL      #1OPTN = *BLANKS
     C                   EVAL      #1SFUNT = *BLANKS
     C                   EVAL      #1SIDEN = *BLANKS
     C                   EVAL      #1SBRCH = *BLANKS
     C                   EVAL      #1SHSTS = *BLANKS
     C                   EVAL      #1SUNCF = *BLANKS
     C                   EVAL      #1STREL = *BLANKS
     C                   EVAL      PINKE = '1'
     C                   ENDIF
 
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRdSflR - Read Subfile Record                               *
      *                                                               *
      *****************************************************************
     C     SrRdSflR      BEGSR
 
      ** Read the subfile for selected records
      ** Only process those for which the option field is blank.
 
     C                   DOU       *IN04 = *ON or
     C                             #1OPTN <> *BLANK
 
     C                   READC     SDMCMGS1                               04
 
     C                   ENDDO
 
      ** Return the selected transaction reference and option
 
     C                   IF        *IN04 <> *ON and
     C                             #1OPTN <> *BLANK
 
     C                   EVAL      POpSel = #1OPTN
     C                   EVAL      PFuntSel = #1FUNT
     C                   EVAL      PIdenSel = #1IDEN
     C                   EVAL      PBrchSel = #1BRCH
 
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
 
      * Transaction reference
 
     C                   EVAL      #1FUNT  = W3FUNT
     C                   EVAL      #1IDEN = W3IDEN
     C                   EVAL      #1BRCH = W3BRCH
     C                   EVAL      #1HSTS = W3HSTS
     C                   EVAL      #1UNCF = W3UNCF
     C                   EVAL      #1TREL = W3TREL
 
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReadItem - Read an item held in the Case Management        *
      *                                                               *
      *****************************************************************
     C     SrReadItem    BEGSR
 
      ** Reset End of File and skip record indicator
 
     C                   MOVE      *BLANK        WEofF
 
      ** Reset Read First Record Flag
 
     C                   EVAL      WFirst = 'Y'
 
      ** Read the file initially - if WEofF is set on then the end of
      ** the file has been reached.  Read until a valid record is
      ** found or until no more records exist.
 
     C                   DOU       WEofF = 'Y' or
     C                             W3FUNT <> *BLANKS and
     C                             PError = *ZERO
 
      ** Read the file
 
      ** Position according to Function Type
 
     C                   IF        #1SFUNT <> *BLANKS AND PFuntPtr = *BLANKS
     C                             AND PIdenPtr = *BLANKS AND PBrchPtr = *BLANKS
     C                             AND WRELRECNO = *ZERO AND WFIRST = 'Y'
     C     #1SFUNT       SETLL     SDCWHTL1
     C                   ENDIF
 
     C                   READ      SDCWHTD0                               96
     C                   EVAL      WFirst = 'N'
 
      ** Select according to Identifier mask
 
     C                   IF        #1SIDEN <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    W3IDEN
     C                   PARM      40            PLength1
     C                   PARM      1             PStart
     C                   PARM                    #1SIDEN
     C                   PARM      40            PLength2
     C                   PARM      '1'           PTranslate
     C                   PARM      '1'           PTrim
     C                   PARM      '?'           PWild
     C                   PARM                    PResult
     C                   IF        PResult < 1
     C                   EVAL      W3FUNT = *BLANK
     C                   ENDIF
     C                   ENDIF
 
      ** Select on branch
 
     C                   IF        #1SBRCH <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    W3BRCH
     C                   PARM      3             PLength1
     C                   PARM      1             PStart
     C                   PARM                    #1SBRCH
     C                   PARM      3             PLength2
     C                   PARM      '1'           PTranslate
     C                   PARM      '1'           PTrim
     C                   PARM      '?'           PWild
     C                   PARM                    PResult
     C                   IF        PResult < 1
     C                   EVAL      W3FUNT = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
      ** Select on Hit Status
 
     C                   IF        #1SHSTS <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    W3HSTS
     C                   PARM      10            PLength1
     C                   PARM      1             PStart
     C                   PARM                    #1SHSTS
     C                   PARM      10            PLength2
     C                   PARM      '1'           PTranslate
     C                   PARM      '1'           PTrim
     C                   PARM      '?'           PWild
     C                   PARM                    PResult
     C                   IF        PResult < 1
     C                   EVAL      W3FUNT = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
      ** Select on Hit Unconfirmed Flag
 
     C                   IF        #1SUNCF <> *BLANKS and #1SUNCF <> W3UNCF
     C                   EVAL      W3FUNT = *BLANKS
     C                   ENDIF
 
      ** Select on Temporarily Release Flag
 
     C                   IF        #1STREL <> *BLANKS and #1STREL <> W3TREL
     C                   EVAL      W3FUNT = *BLANKS
     C                   ENDIF
 
      ** End of File
 
     C                   IF        *IN96 = *ON
     C                   EVAL      WEofF = 'Y'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChAutN - Check For User Authority If Not Multi-Branching   *
      *                                                               *
      *****************************************************************
     C     SrChAutN      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PAction
     C                   PARM                    PError
 
      ** Return Error Message
 
     C                   IF        PError = 1
     C                   EVAL      PErrMs = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialization                                      *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR
 
      ** Clear outputs
 
     C                   EVAL      PErrMs = *BLANK
     C                   EVAL      POpSel = *BLANK
     C                   EVAL      PFuntSel = *BLANK
     C                   EVAL      PIdenSel = *BLANK
     C                   EVAL      PBrchSel = *BLANK
 
     C                   IF        PBdSfl = 'Y' AND (PFuntPtr<> *BLANKS OR
     C                             PIdenPtr <> *BLANKS AND PBrchPtr <> *BLANKS)
     C                             AND PreviousSel <> CurrentSel
     C                   EVAL      #1SFUNT = *BLANKS
     C                   EVAL      #1SIDEN = *BLANKS
     C                   EVAL      #1SBRCH = *BLANKS
     C                   EVAL      #1SHSTS = *BLANKS
     C                   EVAL      #1SUNCF = *BLANKS
     C                   EVAL      #1STREL = *BLANKS
     C                   ENDIF
 
     C                   EVAL      PINKC  = '0'
     C                   EVAL      PINKE  = '0'
 
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
 
      ** Input Parameters :
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Action Code
 
     C                   PARM                    #1OPTN
 
      ** Key fields (file pointer)
 
     C                   PARM                    PFuntPtr
     C                   PARM                    PIdenPtr
     C                   PARM                    PBrchPtr
 
      ** Build Subfile
 
     C                   PARM                    PBdSfl
 
      ** Read Subfile Record
 
     C                   PARM                    PRdSfl
 
      ** Error Flag
 
     C                   PARM                    OKOPTN
     C                   PARM                    OKITEM
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    IDx
 
      ** Standing Data:
 
      ** Midas Rundate from SDBANKPD
 
     C                   PARM                    BJMRDT
 
      ** Single Branch Code from SDBANKPD
 
     C                   PARM                    BJSBRC
 
      ** Switchable Features:                                                                 CSD019
                                                                                              CSD019
      ** Midas Compliance Watch - Entry Level Watch List Checking                             CSD019
                                                                                              CSD019
     C                   PARM                    CSD019                                       CSD019
                                                                                              CSD019
      ** Output Parameters:
 
      ** Error Message
 
     C                   PARM                    PErrMs
 
      ** Option Selected
 
     C                   PARM                    POpSel
 
      ** Item Selected
 
     C                   PARM                    PFuntSel
     C                   PARM                    PIdenSel
     C                   PARM                    PBrchSel
 
      ** Command Keys
 
     C                   PARM                    PINKC
 
     C                   PARM                    PINKE
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDMCMGBRW'
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      #1WID = PsJobName
     C                   EVAL      #1USER = PsUser
 
     C                   EVAL      *IN94 = *ON
     C                   EVAL      #0PGMQ = '*'
 
      ** Display 'E=Watch List Match' if CSD019 is installed.                                 CSD019
                                                                                              CSD019
     C                   IF        CSD019 = 'Y'                                               CSD019
     C                   EVAL      *IN40 = *ON                                                CSD019
     C                   ELSE                                                                 CSD019
     C                   EVAL      *IN40 = *OFF                                               CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C     K_Sdcwhtl1    KLIST
     C                   KFLD                    KFunt
     C                   KFLD                    KIden
     C                   KFLD                    KBrch
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** Functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      *
      /EJECT
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
