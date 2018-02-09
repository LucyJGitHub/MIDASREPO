     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Movements Status - Browse')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEMVTSBRW - Movements Status - Browse                  *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of Movement Status records     *
      *             for selection , the other picks off the           *
      *             selection made.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR325346           Date 21May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSE039  *CREATE    Date 21Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR325346 - DVP/RVP should not appear                         *
      *  CSE039 - Automatic Settlement of Trades                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEMVTSBDF CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SEMVTSBS0:@@RRN)
      ** Midas SE Movements Status - Browse Display File
 
     FSEMVTSL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEMVTSD0:SEMVTSD1)
      ** Midas SE Movements Status - Main Key
 
     FSEMVTSL2  IF   E           K DISK    INFSR(*PSSR) PREFIX(P_)
     F                                     RENAME(SEMVTSD0:SEMVTSD2)
      ** Movements Status - Omit Midas-Generated Records
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      ** Table of field numbers and names (dummy use)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       01  Enables CF05 & CF09                                 *
      *       04  Enquire Mode (Disable Amend, Delete & CF09)         *
      *       12  Enables CF12 - when called by another program -     *
      *       21  SFLDSPCTL if *On / SFLCLR if *Off                   *
      *       22  SFLDSP and Displays Action Codes if *On             *
      *       23  SFLEND if *On                                       *
      *       36  Protect Fields if *On                               *
      *    41-70  Field Error Indicators                              *
      *       99  Multi-purpose                                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **---------------------------------------------------------------
 
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
 
     D SEMVTS        E DS                  EXTNAME(SEMVTSPD)
      ** Movement Status record layout
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SdSCOD        E DS                  EXTNAME(SDSCODPD)
      ** SWIFT Status and Reason Codes
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                AR325346
      ** External DS for switchable features                                                AR325346
                                                                                            AR325346
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short DS for access programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long DS for access programs
 
      ** Current screen selection criteria
     D CurrSel         DS
     D   C0TRRF
     D   C0WIOR
     D   C0NTDT
 
      ** Saved screen selection criteria
     D SavSel          DS
     D   SavTRRF                           LIKE(C0TRRF)
     D   SavWIOR                           LIKE(C0WIOR)
     D   SavNTDT                           LIKE(C0NTDT)
 
      ** Split up of the Movement Reference
     D DDMvtRef        DS
     D  DDTRRF                        6A
     D  DDTRTY                        1A
     D  DDNTDT                        6A
     D  DDSQNR                        3S 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Alternate arrays of Midas-generated Status Codes and Narratives
      ** and their related index
     D MidasGCod       S              4A   DIM(12) CTDATA PERRCD(1)
     D MidasGNar       S             60A   DIM(12) ALT(MidasGCod)
     D MGi             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** +----------------------------------------------------------------+
      *
      ** WARNING: The main loop of this module is based on the RPG cycle.
      **          I.e. the detail processing will repeat itself until the
      **          module is authorized to return to the caller.
      ** Initialization
      *
     C                   EXSR      INIT
 
      ** Build Sub-file and write/read the screen
      *
     C                   IF        @BDSFL = 'Y'
     C                   EXSR      BLDSFL
     C                   EVAL      @BDSFL = *Blank
     C                   ENDIF
 
      ** Process the last user input and/or
      ** Read and validate the next modified Subfile Record
      *
     C                   IF        @RDSFL = 'Y'
     C                   EVAL      TimeToGo = 'N'
     C                   EXSR      RDSFLR
     C                   ENDIF
 
      ** Return to the caller at the right moment
      *
     C                   IF        TimeToGo = 'Y'
     C                   RETURN
     C                   ENDIF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDSFL - Build the subfile and write/read the screen
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      ** Validate the selection fields
      *
     C                   EXSR      ValMvts
      *
      ** Quit if so requested
      *
     C     TimeToGo      CABEQ     'Y'           EndBLDSFL
      *
      ** Save the current selection criteria
      *
     C                   EVAL      SavSel = CurrSel
      *
      ** Clear the subfile and initialise its relative record number
      *
     C                   SETOFF                                       2122
     C                   WRITE     SEMVTSBC0
     C                   SETON                                        21
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      ** Set file pointer on key displayed on screen (setup in ValMvts)
      *
     C     KSEMVTSL1_1   SETLL     SEMVTSD1
      *
      ** Read the next record and validate it for display
      *
     C                   EXSR      RDMvts
      *
      ** Fill the subfile in one loop (no need to handle a rollup indicator
      ** here, as there is only a few records by transaction reference)
      *
      ** No SFLNXTCHG, nor error on Action Code
      *
     C                   SETOFF                                       2441
      *
 B1  C                   DOW       NOT %EoF(SEMVTSL1)
      *
      ** If the record is selected for display
      *
 B2  C                   IF        WRecordOK = 'Y'
      *
      ** Format record fields for output
      *
     C                   EXSR      FMTMvts
      *
      ** Write the subfile record
      *
     C                   ADD       1             @@RRN
     C                   WRITE     SEMVTSBS0
 E2  C                   ENDIF
      *
      ** Read the next record and validate it for display
      *
     C                   EXSR      RDMvts
 E1  C                   ENDDO
      *
      ** Display the subfile if there is at least one record
      ** Otherwise, send a message "no data to display"
      *
     C                   IF        @@RRN > 0
     C                   SETON                                        22
     C                   ELSE
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx)   = 'SE03930'
     C                   ENDIF
      *
      ** Set end of subfile On and allow F5 and F9
      *
     C                   SETON                                        23
     C                   SETON                                        01
      *
      ** Write/Read the screen
      *
     C                   EVAL      C0RRN = 1
     C                   EXSR      Screen
      *
      ** Return to the caller
      *
     C                   EVAL      TimeToGo = 'Y'
      *
     C     EndBLDSFL     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALMvts - Validate the selection fields
      *****************************************************************
     C     VALMvts       BEGSR
      *
      ** As the selection fields are not yet validated, any screen displayed
      ** by this routine must:
      **        .show no subfile records nor action codes
      **        .disable CF05 and CF09
      *
     C                   SETOFF                                       22        No subfile / A.Codes
     C                   SETOFF                                       01        Disable F5 & F9
     C                   SETON                                        21        Show control fmt
      *
      ** Loop until no error
      *
 B1  C                   DOU       Idx = 0
      *
      ** Output the screen or error, or the first time when not
      ** called by another program (*IN36 off)
      *
 B2  C                   IF        Idx > 0 OR
     C                             (NOT *IN36 AND WFirst <> 'N')
     C                   EXSR      Screen
 E2  C                   ENDIF
      *
     C                   MOVE      'N'           WFirst            1
      *
      ** Leave if F3 or F12
      *
 B2  C                   IF        *INKC OR *INKL
     C                   EVAL      TimeToGo = 'Y'
     C                   GOTO      EndValMvts
 E2  C                   ENDIF
      *
      ** VALIDATE SELECTION FIELDS
      ** At least a Trade OR a Depot Movement Reference must be entered
      *
 B2  C                   IF        (C0TRRF =  *Blanks AND C0WIOR =  *Blanks)
     C                                                OR
     C                             (C0TRRF <> *Blanks AND C0WIOR <> *Blanks)
     C                   SETON                                        4243
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx)   = 'SE03928'
 E2  C                   ENDIF
      *
      ** If entered, the Notification Date must be valid
      *
 B2  C                   IF        C0NTDT <> *Blanks
     C                   CALLB     'ZDATE1'
     C                   PARM      C0NTDT        DateIn            6
     C                   PARM                    DaynoOut          5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ErrorFlag         1
      *
 B3  C                   IF        ErrorFlag = 'Y'
     C                   SETON                                        44
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx)   = 'SE03929'
 E3  C                   ENDIF
      *
 X2  C                   ELSE
     C                   EVAL      DaynoOut = 99999
 E2  C                   ENDIF
      *
      ** Sets up the key fields to access the movement status file according
      ** to the selection criteria.
      ** As there is a little chance to have two different transactions (from
      ** two different transaction files) with the same transaction reference,
      ** the transaction type is forced to the first found in file, if this
      ** program isn't called by another one.
      ** Note that the RTT module should normally protect the movement status
      ** file against duplicated transaction references.
      *
 B2  C                   IF        C0TRRF = *Blanks
     C                   EVAL      TMTRRF = C0WIOR
 X2  C                   ELSE
     C                   EVAL      TMTRRF = C0TRRF
 E2  C                   ENDIF
      *
 B2  C                   IF        NOT *IN36
      *
 B3  C                   IF        C0WIOR = *Blanks
     C     TMTRRF        CHAIN     SEMVTSD1                           99
     C  N99              EVAL      C0TRTY = TMTRTY
     C   99              EVAL      C0TRTY = *Blank
 X3  C                   ELSE
     C                   EVAL      C0TRTY = 'W'
 E3  C                   ENDIF
      *
      ** The trade Ref has been found, but relates to a depot movement
      *
 B3  C                   IF        C0WIOR = *Blanks AND C0TRTY = 'W'
     C                   SETON                                        42
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx)   = 'SE03904'
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
     C                   EVAL      TMTRTY = C0TRTY
     C                   EVAL      TMNTDT = DaynoOut
      *
 E1  C                   ENDDO
      *
     C     EndValMvts    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Screen - Write and read the screen
      *****************************************************************
     C     Screen        BEGSR
      *
      ** The following /COPY doesn't clear the program message queue when
      ** there are no errors, causing messages persistence on screen.
      ** So, clear manually
      *
     C                   IF        MsgIDArr(1) = *Blanks
     C                   MOVEA     *Blanks       WkMsgIDArr
     C                   MOVEA     *Blanks       WkFldNmArr
     C                   MOVEA     *Blanks       WkMsgDtArr
     C                   EVAL      ClrPgmMsgQ = 'Y'
     C                   EXSR      ProcMsgs
     C                   ENDIF
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      *
      ** Clear message arrays
      *
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
     C                   MOVE      0             Idx               3 0
      *
      ** Output and read the screen
      *
     C                   WRITE     SEMVTSBCM                                    Options+Keys+Msgs
     C                   EXFMT     SEMVTSBC0                                    Subfile control
      *
      ** Clear error indicators
      *
     C                   SETOFF                                       424344
      *
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * RdMvts - Read the next movement record and validate it for display
      *****************************************************************
     C     RdMvts        BEGSR
      *
      ** Reset the "record ok" flag
      *
     C                   MOVE      'Y'           WRecordOK         1
      *
      ** Read the next record
      *
     C     KSEMVTSL1_2   READE     SEMVTSD1
      *
      ** Validate the record for display if not End of File:
      ** .The record must be Live
      ** .The user must have authority to view it
      *
     C                   IF        NOT %EoF(SEMVTSL1)
      *
     C                   IF        TMLCTP = 'D'
     C                   EVAL      WRecordOK = 'N'
     C                   GOTO      EndRdMvts
     C                   ENDIF
      *
     C                   EVAL      ZACTN = 'E'
     C                   EVAL      ZBR   = TMTRBB
     C                   EXSR      ChkAut
      *
     C                   IF        @@ERR <> 0
     C                   EVAL      WRecordOK = 'N'
     C                   GOTO      EndRdMvts
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EndRdMvts     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ChkAut - Check for user authority
      *****************************************************************
     C     ChkAut        BEGSR
      *
      ** If not multi-branching
      *
     C                   IF        BJSBRC <> *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ** If multi-branching
      *
     C                   ELSE
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN
     C                   PARM                    ZBR               3
     C                   PARM                    @@ERR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTMvts - Format record fields for output
      ******************************************************************
     C     FMTMvts       BEGSR
      *
      ** Booking Branch
      *
     C                   EVAL      S0TRBB   = TMTRBB
      *
      ** Message Key
      *
     C                   EVAL      S0MSGK   = TMMSGK
      *
      ** Action Code
      *
     C                   EVAL      S0ACTCDE = *Blank
      *
      ** Notification Date
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      TMNTDT        ZDayNo            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZDATE         S0NTDT
      *
      ** SWIFT Status Code
      *
     C                   EVAL      S0SWSC   =    TMSWSC
      *
      ** Input Origin
      *
     C                   EVAL      S0INOR   =    TMINOR
      *
      ** Sequence Number
      *
     C                   EVAL      S0SQNR   =    TMSQNR
      *
      ** SWIFT Reason Code
      *
     C                   EVAL      S0SWRC   =    TMSWRC
      *
      ** Last Change User
      *
     C                   EVAL      S0LCUS   =    TMLCUS
      *
      ** SWIFT Status Description
      ** Midas-generated codes are tested first, and the access object
      ** is called only if not found.
      ** In this later case, and for the "RPLY" status code only, we need
      ** to replace the "xxxx" of its narrative with the status code of
      ** the first non-Midas-generated record prior to the current one.
      *
     C                   EVAL      MGi = 1
     C     TMSWSC        LOOKUP    MidasGCod(MGi)                         99
      *
 B1  C                   IF        *IN99
     C                   EVAL      S0SWSN = MidasGNar(MGi)
 X1  C                   ELSE
     C                   CALLB     'AOSCODR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      TMSWSC        @Code             4
     C                   PARM      'S'           @CdTp             1
     C                   PARM      *Blanks       @CdDp             4
     C     SdSCOD        PARM      SdSCOD        DSFDY
      *
 B2  C                   IF        @RtCd = *Blanks
      *
 B3  C                   IF        TMSWSC = 'RPLY'
     C     KSEMVTSL2_1   SETGT     SEMVTSD2
     C     KSEMVTSL2_2   READE     SEMVTSD2                               99
      *
 B4  C                   IF        NOT *IN99
     C                   EVAL      S0SWSN = %Replace(%Trim(P_TMSWSC):SRCDNR:
     C                                               %Scan('xxxx':SRCDNR):4)
 X4  C                   ELSE
     C                   EVAL      S0SWSN = %Replace('????':SRCDNR:
     C                                               %Scan('xxxx':SRCDNR):4)
 E4  C                   ENDIF
      *
 X3  C                   ELSE
     C                   EVAL      S0SWSN = SRCDNR
 E3  C                   ENDIF
      *
 X2  C                   ELSE
     C                   EVAL      S0SWSN = *ALL'?'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** SWIFT Reason Description
      *
     C                   IF        TMSWRC <> *Blanks
     C                   CALLB     'AOSCODR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      TMSWRC        @Code             4
     C                   PARM      'R'           @CdTp             1
     C                   PARM      TMSWSC        @CdDp             4
     C     SdSCOD        PARM      SdSCOD        DSFDY
      *
     C                   IF        @RtCd = *Blanks
     C                   EVAL      S0SWRN = SRCDNR
     C                   ELSE
     C                   EVAL      S0SWRN = *ALL'?'
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      S0SWRN = *Blanks
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - Process the last user input or read/validate the next
      *          modified subfile record
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      ** Please note that Idx is always 0 at this point, as, whatever the
      ** case, the routine Screen has always been just performed
      *
      ** F3 or F12: Inform the caller and return
      *
     C                   IF        *INKC OR *INKL
     C                   EVAL      @INKC = *INKC
     C                   EVAL      @INKL = *INKL
     C                   EVAL      TimeToGo = 'Y'
     C                   GOTO      EndRDSFLR
     C                   ENDIF
      *
      ** F5 or change the selection criteria: rebuild the subfile and wait
      ** for another input
      *
     C                   IF        CurrSel <> SavSel OR *INKE
     C   KE              EVAL      CurrSel = SavSel
     C                   EVAL      @BDSFL = 'Y'
     C                   GOTO      EndRDSFLR
     C                   ENDIF
      *
      ** F9: verify that all is right to insert a new movement for the
      **     current transaction
      **     Re-output the screen if any error
      **     Otherwise, setup the output parameters and return
      *
 B1  C                   IF        *INKI
     C                   EXSR      ValIMvts
      *
 B2  C                   IF        Idx = 0
     C                   EXSR      RtvMvts
 E2  C                   ENDIF
      *
 B2  C                   IF        Idx > 0
     C                   EXSR      Screen
 X2  C                   ELSE
     C                   EVAL      @OPSEL = 'I'
     C                   EVAL      TMTRRF = DDTRRF
     C                   EVAL      TMTRTY = DDTRTY
     C                   EVAL      TimeToGo = 'Y'
 E2  C                   ENDIF
      *
     C                   GOTO      EndRDSFLR
 E1  C                   ENDIF
      *
      ** If there is no subfile, return to the caller
      *
     C                   IF        NOT *IN22
     C                   EVAL      TimeToGo = 'Y'
     C                   GOTO      EndRDSFLR
     C                   ENDIF
      *
      ** Read the next modified subfile record and validate it.
      ** Action Code "M" is processed without return to the caller.
      ** The screen is re-output at each encountered error.
      ** If the action code is not "M" and all is OK, the output
      ** parameters are filled, and control return to the caller.
      *
 B1  C                   DOU       %EoF(SEMVTSBDF)
      *
     C                   READC     SEMVTSBS0
     C                   EVAL      @OPSEL = *Blank                              Maybe 'M' / Prv loop
      *
 B2  C                   IF        %EoF(SEMVTSBDF)                              No more record
     C                   EVAL      TimeToGo = 'Y'
     C                   LEAVE                                                  --> Quit + return
 E2  C                   ENDIF
      *
 B2  C                   IF        S0ACTCDE = *Blank                            Remove an
     C                   SETOFF                                       4124        eventual
     C                   UPDATE    SEMVTSBS0                                      previous error
 X2  C                   ELSE
      *
 B3  C                   IF        S0ACTCDE = 'M'                               Action code "M"
     C                   EXSR      ViewMsg
      *
 B4  C                   IF        @RtCd = 'Y2U9999'                            F3 while viewing
     C                   EVAL      @INKC = '1'
     C                   EVAL      TimeToGo = 'Y'
     C                   LEAVE                                                  --> Quit + return
 E4  C                   ENDIF
      *
 X3  C                   ELSE                                                   Action code not "M"
     C                   EXSR      RtvMvts
 E3  C                   ENDIF
      *
 B3  C                   IF        Idx > 0                                      Action code error
     C                   SETON                                        4124      Error + SFLNXTCHG
     C                   UPDATE    SEMVTSBS0
     C                   EVAL      C0RRN = @@RRN                                View page with error
     C                   EXSR      Screen
     C                   LEAVE                                                  --> Quit
 X3  C                   ELSE
     C                   EVAL      @OPSEL = S0ACTCDE
     C                   EVAL      S0ACTCDE = *Blank
     C                   SETOFF                                       4124
     C                   UPDATE    SEMVTSBS0
 E3  C                   ENDIF
      *
 B3  C                   IF        @OPSEL <> 'M'
     C                   EVAL      TimeToGo = 'Y'
     C                   LEAVE                                                  --> Quit + return
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDDO
      *
     C     EndRDSFLR     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValIMvts - Verify that an insertion is possible
      *****************************************************************
     C     ValIMvts      BEGSR
      *
      ** Set up input parameters for the retrieve transaction module
      *
     C                   IF        C0TRRF = *Blanks
     C                   EVAL      DDTRRF = C0WIOR
     C                   EVAL      DDTRTY = 'W'
     C                   ELSE
     C                   EVAL      DDTRRF = C0TRRF
     C                   EVAL      DDTRTY = *Blank
     C                   ENDIF
      *
      ** Call the retrieve transaction module
      *
     C                   CALLB     'SEMVTSRTT'
      ** INPUT PARAMETERS:
      ** Return code
     C                   PARM                    RetCodeOut
      ** Transaction Reference
     C                   PARM                    DDTRRF
      *
      ** INPUT/OUTPUT PARAMETERS:
      ** Transaction Type
     C                   PARM                    DDTRTY
      *
      ** OUTPUT PARAMETERS:
      ** OK Indicators
     C                   PARM                    DDTRRFOK          1
     C                   PARM                    DDTRTYOK          1
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
      ** Booking Branch and Date of the retrieved Transaction
     C                   PARM                    P@BRCA
     C                   PARM                    P@TRDT
      *
      ** If there is no error, verify that there can be no confusion on
      ** the transaction type
      ** Note that the screen transaction type may be blank if there are
      ** still no records in file for the transaction, except when the module
      ** is called by another program (*IN36 on). In this later case, the
      ** transaction type must be filled and OK.
      *
     C                   IF        C0TRTY <> *Blank OR *IN36
      *
     C                   IF        Idx = 0 AND DDTRTY <> C0TRTY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx)   = 'SE03931'
     C                   EVAL      MsgDtaArr(Idx)  = C0TRTY + DDTRTY
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      C0TRTY = DDTRTY
     C                   ENDIF
      *
      ** If there is an error, position the correct error indicator
      *
     C                   IF        Idx > 0
     C     C0TRRF        COMP      *Blanks                            424243
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RtvMvts - Retrieve the movement record to process and validate
      *           the action code
      *****************************************************************
     C     RtvMvts       BEGSR
      *
      ** In Enquire processing mode, action codes 'A' and 'D' are not allowed
      *
     C                   IF        *IN04 AND
     C                             (S0ACTCDE = 'A' OR S0ACTCDE = 'D')
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx)   = 'APM0200'
     C                   GOTO      EndRtvMvts
     C                   ENDIF
      *
      ** Set up input parameters for the retrieve module
      *
     C                   IF        *INKI
     C                   EVAL      DDACTN = 'I'
     C                   ELSE
     C                   EVAL      DDACTN = S0ACTCDE
     C                   EVAL      DDNTDT = S0NTDT
     C                   EVAL      DDSQNR = S0SQNR
     C                   ENDIF
      *
     C                   IF        C0TRRF = *Blanks
     C                   EVAL      DDTRRF = C0WIOR
     C                   ELSE
     C                   EVAL      DDTRRF = C0TRRF
     C                   ENDIF
      *
     C                   EVAL      DDTRTY = C0TRTY
      *
      ** Call the retrieve module
      *
     C                   CALLB     'SEMVTSRTV'
      ** INPUT PARAMETERS
      ** Return code
     C                   PARM                    RetCodeOut
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      *Blanks       ModeofOp          6
      ** Response mode (SPF checking required)
     C                   PARM      'S'           RespMode          1
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Front Office Transaction ID
     C                   PARM      *Blanks       FOTRID           20
      ** (Midas) Movement Reference
     C                   PARM                    DDMvtRef
      *
      ** INPUT/OUPUT PARAMETERS
      ** Booking Branch of the linked Transaction (trade or DPMV)
     C                   PARM                    P@BRCA
      *
      ** OUPUT PARAMETERS
      ** Transaction Details in File Format
     C                   PARM                    SEMVTS
      ** OK - Action code and first key field of the movement reference
     C                   PARM                    DDACTNOK          1
     C                   PARM                    DDTRRFOK          1
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** If there is an error in insert, position the correct error indicator
      *
     C                   IF        Idx > 0 AND *INKI
     C     C0TRRF        COMP      *Blanks                            424243
     C                   ENDIF
      *
     C     EndRtvMvts    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ViewMsg - Validate and process option to view the linked SWIFT messages
      *****************************************************************
     C     ViewMsg       BEGSR
      *
     C                   EVAL      @RtCd = *Blanks
      *
      ** The action code "M" is only allowed for movements having a
      ** message key and not from manual origin
      *
     C                   IF        S0MSGK = *Blanks OR S0INOR = 'MANUAL'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx)   = 'SE03932'
     C                   GOTO      EndViewMsg
     C                   ENDIF
      *
      ** The user must be allowed to view messages
      *
     C                   EVAL      ZACTN = S0ACTCDE
     C                   EVAL      ZBR   = S0TRBB
     C                   EXSR      ChkAut
      *
     C                   IF        @@ERR <> 0
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx)   = 'SE03911'
     C                   GOTO      EndViewMsg
     C                   ENDIF
      *
      ** Parameters for the SWIFT Message Enquiry
      *
     C                   IF        C0TRRF = *Blanks
     C                   EVAL      DDTRRF = C0WIOR
     C                   ELSE
     C                   EVAL      DDTRRF = C0TRRF
     C                   ENDIF
      *
      ** Call the SWIFT Message Enquiry
      *
     C                   CALL      'SE4410'
     C                   PARM                    DDTRRF
     C                   PARM      C0TRTY        DDTRTY
     C                   PARM      S0MSGK        DDMSGK           40
     C                   PARM      *Blanks       @RtCd
      *
     C     EndViewMsg    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Clear outputs
      *
     C                   CLEAR                   SEMVTS
     C                   EVAL      @OPSEL = *BLANK
     C                   EVAL      P@BRCA = *BLANK
     C                   EVAL      P@TRDT = 0
     C                   EVAL      @INKC  = '0'
     C                   EVAL      @INKL  = '0'
      *
      ** It is not time to return to the caller
      *
     C                   MOVE      'N'           TimeToGo          1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Processing Mode (E/Enquiry or M/Maintenance)
     C                   PARM                    ProcesMode        1
      ** Build Subfile
     C                   PARM                    @BDSFL            1
      ** Read Subfile Record
     C                   PARM                    @RDSFL            1
      *
      ** INPUT/OUTPUT PARAMETERS
      ** In/out=Movement Reference - Out=Movement record to process
     C                   PARM                    SEMVTS
      *
      ** OUTPUT PARAMETERS
      ** Option Selected
     C                   PARM                    @OPSEL            1
      ** Booking Branch and Date of the retrieved Transaction
     C                   PARM                    P@BRCA            3
     C                   PARM                    P@TRDT            5 0
      ** Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ** Klist's
      *
     C     KSEMVTSL1_1   KLIST
     C                   KFLD                    TMTRRF
     C                   KFLD                    TMTRTY
     C                   KFLD                    TMNTDT
      *
     C     KSEMVTSL1_2   KLIST
     C                   KFLD                    TMTRRF
     C                   KFLD                    TMTRTY
      *
     C     KSEMVTSL2_1   KLIST
     C                   KFLD                    TMTRRF
     C                   KFLD                    TMTRTY
     C                   KFLD                    TMNTDT
     C                   KFLD                    TMSQNR
      *
     C     KSEMVTSL2_2   KLIST
     C                   KFLD                    TMTRRF
     C                   KFLD                    TMTRTY
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Program message queue name
      *
     C                   EVAL      MSPGMQ = '*'
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       @RtCD
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        @RtCd <> *Blanks
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     900           DBASE
     C                   MOVEL     @Optn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                     AR325346
      ** Access switchable features file - CSE041                                           AR325346
      *                                                                                     AR325346
     C                   CALLB     'AOSARDR0'                                               AR325346
     C                   PARM      *BLANKS       @RTCD                                      AR325346
     C                   PARM      '*VERIFY'     @OPTN                                      AR325346
     C                   PARM      'CSE041'      @SARD                                      AR325346
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR325346
      *                                                                                     AR325346
      ** Set screen conditioning indicator                                                  AR325346
      *                                                                                     AR325346
     C     @RTCD         IFEQ      *BLANKS                                                  AR325346
     C                   EVAL      *IN90 = '0'                                              AR325346
     C                   ELSE                                                               AR325346
     C                   EVAL      *IN90 = '1'                                              AR325346
     C                   ENDIF                                                              AR325346
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   EVAL      ModuleID     = 'SE'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
      *
      ** Set up the transaction reference to be used by the message handler
      ** (Absolutely doesn't matter in our case: the messages are sent to
      ** screen, via the program's message queue)
      *
     C                   EVAL      TranRef = 'Yo, man! What''s up?'
     C                   EVAL      ActionCode = '?'
      *
      ** Basic setup of the screen: Enquiry mode or not
      *
     C     ProcesMode    COMP      'E'                                    04    - Equal -
      *
      ** If at first call, the received record layout contains a Movement
      ** Reference, than the Movement Status Maintenance has been called
      ** by another program to work with that given reference. In this
      ** case, simply setup the selection fields with the reference.
      ** Otherwise, a screen will be output in ValMvts to
      ** ask the user for a reference to work with.
      *
 B1  C                   IF        TMTRRF <> *Blanks                            Called by Program
     C                   SETON                                        12        Allow F12
     C                   SETON                                        36        Protect Selection
     C                   EVAL      C0TRTY = TMTRTY
      *
 B2  C                   IF        TMTRTY = 'W'
     C                   EVAL      C0WIOR = TMTRRF
 X2  C                   ELSE
     C                   EVAL      C0TRRF = TMTRRF
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Clear the subfile to initialise it
      *
     C                   SETOFF                                       2122
     C                   WRITE     SEMVTSBC0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      /COPY ZACPYSRC,MSGHNDDSP2
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003
**CTDATA MidasGCod
INS Inserted                                                    :
AMD Amended                                                     :
CHG Changed                                                     :
APP Approved                                                    :
AUT Authorised                                                  :
DEL Deleted                                                     :
RVD Reversed Deletion                                           :
PST Partial Settlement                                          :
RVS Reversed Settlement                                         :
SET Fully Settled                                               :
CST Contractual Settlement                                      :
VAL Validation Failure                                          :
