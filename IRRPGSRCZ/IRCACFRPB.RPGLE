     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/Collars/Floors Repair Browse')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRCACFRPB - Invalid Caps/Collars/Floors Browse               *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of invalid deals for selection,*
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD041294           Date 19Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG2603            Date 12May04               *
      *                 CAP043             Date 02May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP055  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041294 - Customer extension details is missing in          *
      *             CUSD repair browse                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG2603- Commitment Control Changes for Midas Plus           *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    21         End of File                                     *
      *    22         Clear Subfile                                   *
      *    23         Roll Up Indicator                               *
      *    24         End of File                                     *
      *    99         Error Reading APDUMP data area in *PSSR         *
      *                                                               *
      *    KC         F3 Function indicator                           *
      *    KL         F5 Function indicator                           *
      *                                                               *
      *    U7         *PSSR                                           *
      *    U8         *PSSR                                           *
      *    LR         Program Termination                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRBldSfl - Build Subfile                                      *
      * SRRdSflr - Read Subfile Record                                *
      * SRValid_ROpt - Validate Repair Option Code                    *
      * SREnq_Inv - Enquire on Invalid Transaction                    *
      * SRProm_Delt - Prompt for Deletion                             *
      * SRDelIRCS - Delete Invalid Records for Principal Change       *                       CAP043
      * SRRdITran - Read an Invalid Transaction                       *
      * SRChAutN - Check for User Authority if not multi-branching    *
      * SRRtvTxt - Retrieve Text                                      *
      * SRInit- Initialisation                                        *
      *                                                               *
      * *PSSR - Error Processing                                      *
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
 
     FIRCACFRPDFCF   E             WORKSTN
     F                                     SFILE(IRICACFS0:WkRRN)
     FIRICACFL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(IRICACFD0:IRICACFX0)
     FIRICACFL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FIRIPCSCL1 UF   E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     PREFIX(PI)                                         CAP043
     F                                     COMMIT                                             CAP043
     FAPIDSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S_)
     F                                     RENAME(APIDSETD0:APIDSETX0)
     FAPIDSETL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
 
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** Data structure for data area commitment control                                     BUG2603
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG2603
     D  ComitJobs              4    103A                                                     BUG2603
                                                                                             BUG2603
     D JobCmtCtlDS     S             10A   DIM(10)                                           BUG2603
      * MIDAS SC Jobs Handling Commitment Control Data Structure                             BUG2603
                                                                                             BUG2603
      ** External DS for SAR details                                                         BUG2603
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG2603
                                                                                             BUG2603
     D InvTr         E DS                  EXTNAME(IRICACFPD)
     D InvTrSetIn    E DS                  EXTNAME(APIDSETPD)
     D                                     PREFIX(S_)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Successful Insert Deal Number
     D                 DS
     D  #0FOTX                 1     40
     D  DDSIDN                10     15
 
      ** Array containing messages
     D ErrorText       S             52    DIM(2) CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Incoming Parameters
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PErrUp          S              1A
     D PErrMs          S              7A
     D POpSel          S              1A
     D PAcSel          S              1A
     D P0FOId          S             20A
     D P0FOAs          S             20A
     D P0TmeS          S             26Z
     D PINKC           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PSIDN           S              6A
     D BJSBRC          S              3A
 
      ** Parameters for SDRTVTXT
     D PMsgDNb         S              7A
     D PMsgNm          S             10A
     D PMsgTxt         S             80A
 
      ** Parameters for ZAINVTRENQ
     D PInvFile1       S             10A
     D PInvFile2       S             10A
     D PInvFile3       S             10A
     D PInvFDta1       S           4000A
     D PInvFDta2       S           4000A
     D PInvFDta3       S           4000A
 
      ** Parameters for ZAINVTRDEL
     D PDDNar1         S             30A
     D PDDFld1         S             35A
     D PDDNar2         S             30A
     D PDDFld2         S             35A
     D PDDNar3         S             30A
     D PDDFld3         S             35A
     D PDDNar4         S             30A
     D PDDFld4         S             35A
     D PDDNar5         S             30A
     D PDDFld5         S             35A
     D PDDNar6         S             30A
     D PDDFld6         S             35A
     D PDDNar7         S             30A
     D PDDFld7         S             35A
     D PDDNar8         S             30A
     D PDDFld8         S             35A
     D PDDNar9         S             30A
     D PDDFld9         S             35A
 
      ** Parameters for Access Objects
     D PRtCd           S              7A
     D POptn           S              7A
     D PSarD           S              6A                                                     BUG2603
 
      ** Parameters for ZVACTU
     D PACTN           S              1A
     D PErr            S              1P 0
 
      ** Parameters for RPC1600
     D PEntryData      S           3000A
     D PFileName       S             10A
 
      ** Relative Record Number
     D WkRRN           S              5P 0
     D WkCNT           S              3P 0
 
      ** Fields used for 24x7 Midas Availability
     D CSC011          S              1A
     D KMsgType        S              8A
     D KFrntOffID      S             20A
     D KTimeStamp      S                   LIKE(P0Tmes)
 
      ** Message type field for chaining to APIDSETPD; defined in terms
      ** of the file field when the file field was changed.
     D WMSGTYPE        S                   LIKE(DDMSGTYPE)
                                                                                              CAP043
     D CAP043          S              1A                                                      CAP043
     D CAP041          S              1A                                                      CAP043
 
      ** Define workfields for Commitment Control Changes for Midas Plus                     BUG2603
     D CSC022          S              1A                                                     BUG2603
     D WSkpCom         S              1A                                                     BUG2603
     D WPos            S              2S 0                                                   BUG2603
                                                                                             BUG2603
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
      *
 
      ** Initialisation
 
     C                   EXSR      SrInit
 
      ** Build subfile
 
     C                   IF        PBdSfl = 'Y'
     C                   EXSR      SRBldSfl
     C                   END
 
      ** Read subfile record
 
     C     PRdSfl        IFEQ      'Y'
     C                   EXSR      SRRdSflr
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Build Subfile                                     *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
 
      ** Check for user authority to browse if not multi-branching
 
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      SRChAutN
     C                   ENDIF
 
      ** Initialise subfile relative record number.
 
     C                   EVAL      WkRRN = 0
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
 
     C                   EVAL      *IN22 = *ON
     C                   WRITE     IRICACFS1
     C                   EVAL      *IN22 = *OFF
 
      ** Write the select screen footer to the screen.
      ** If previous transaction was not successful due to deal being
      ** updated by another workstation then display message on screen
 
     C                   IF        PErrUp = 'Y'
     C                   EVAL      ERRORMSG = ErrorText(1)
     C                   ELSE
     C                   EVAL      ERRORMSG = *BLANKS
     C                   EVAL      #0FOTX = *BLANKS
 
     C                   IF        PSIDN <> *BLANK
     C                   EVAL      #0FOTX = ErrorText(2)
     C                   EVAL      DDSIDN = PSIDN
     C                   EVAL      PSIDN = *BLANK
     C                   EVAL      ERRORMSG = #0FOTX
     C                   ENDIF
 
     C                   ENDIF
 
     C                   WRITE     IRICACFF1
 
      ** Set file pointer to start of file
 
     C     *LOVAL        SETLL     IRICACFL0
 
      ** Read an invalid deal
 
     C                   EXSR      SRRdITran
 
      ** If no records exist - set up an error message.
      ** Display a message 'No invalid transactions present'
      ** then terminate
 
     C                   IF        *IN21 = *ON
     C                   EVAL      PErrMs = 'FXM1007'
     C                   EXFMT     IRICACFEND
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      **  Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN23 = *ON
 
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
 
     C                   DOW       (*IN21 <> *ON) AND (*IN23 = *ON)
 
      **  Initialise count of records written to subfile page.
 
     C                   EVAL      WkCNT = 0
 
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
 
     C                   DOW       (*IN21 <> *ON) AND (WkCNT < 14)
 
      **  Increment the subfile record no. and records written fields.
 
     C                   ADD       1             WkRRN
     C                   ADD       1             WkCNT
 
      **  Write the invalid deal to the subfile.
 
     C                   MOVE      *BLANK        #0OPTN
     C                   Z-ADD     WkRRN         #1SFRN
     C                   WRITE     IRICACFS0
 
      ** Read an invalid deal
 
     C                   EXSR      SRRdITran
     C                   ENDDO
 
      **  Retrieve time
 
     C                   TIME                    #1TIME
 
      **  Write the subfile control record to the screen to display
      **  the subfile.
 
     C                   WRITE     IRICACFS1
 
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
 
     C                   READ      IRICACFS1                              24
 
      **  If F3, bypass further processing.
 
     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      **  If F12, bypass further processing.
 
     C                   IF        *INKL = *ON
     C                   EVAL      PINKL = '1'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdSflr - Read Subfile Record                               *
      *                                                               *
      *****************************************************************
     C     SRRdSflr      BEGSR
 
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
 
     C                   DOU       (*IN24 = *ON) OR (#0OPTN <> *BLANK)
     C                   READC     IRICACFS0                              24
 
      ** Validate repair option code
 
     C                   IF        *IN24 = *OFF
     C                   EXSR      SRValid_ROpt
     C                   ENDIF
 
      ** If 'E' is input, enquire upon invalid transaction
 
     C                   IF        (*IN24 = *OFF) AND (#0OPTN = 'E')
     C                   MOVE      #0TMES        P0TmeS
     C                   EXSR      SREnq_Inv
     C                   EVAL      #0OPTN = *BLANK
     C                   ENDIF
 
      ** If 'Q' is input, prompt for deletion of invalid transaction
 
     C                   IF        *IN24 = *OFF and #0OPTN = 'Q'
     C                   EXSR      SRProm_Delt
     C                   EVAL      #0OPTN = *BLANK
     C                   ENDIF
 
     C                   ENDDO
 
      **  Return the selected option, action, front office transaction ID
      **  and front office associated transaction ID
 
     C                   IF        (*IN24 <> *ON) AND (#0OPTN <> *BLANK)
     C                   EVAL      POpSel = #0OPTN
     C                   EVAL      PAcSel = #0ACCD
     C                   EVAL      P0FOID = #0FOID
     C                   EVAL      P0FOAs = #0FOAS
     C                   EVAL      P0TmeS = #0TMES
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValid_ROpt - Validate Repair Option Code                   *
      *                                                               *
      *****************************************************************
     C     SRValid_ROpt  BEGSR
 
     C                   CALLB     'ZAROPTVAL'
 
      ** Inputs
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Option code
      ** Front Office ID
      ** Booking Branch
     C                   PARM                    #0OPTN
     C                   PARM                    #0FOID
     C                   PARM                    #0BRSN
 
      ** ICD Single branch code
     C                   PARM                    BJSBRC
 
      ** Outputs
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      ** If F3, bypass further processing.
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      **  If F12, continue with next option
 
     C                   IF        PINKL = '1'
     C                   EVAL      #0OPTN = *BLANK
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnq_Inv - Enquire on Invalid Transaction                   *
      *                                                               *
      *****************************************************************
     C     SREnq_Inv     BEGSR
 
      ** Pass the invalid transaction details to the enquiry
 
     C     ZATRNKX0      CHAIN     IRICACFX0                          24
     C                   CLEAR                   InvTrSetIn
     C     APDSETKX      CHAIN     APIDSETX0                          24
 
     C                   CALLB     'ZAINVTRENQ'
 
      ** Inputs
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action code
      ** Front Office ID
      ** Associated Front Office ID
      ** Timestamp
     C                   PARM                    #0ACCD
     C                   PARM                    #0FOID
     C                   PARM                    DDFOASOCID
     C                   PARM                    #0TMES
 
      ** Invalid file names
     C                   PARM      'IRICACFPD'   PInvFile1
     C                   PARM      'APIDSETPD'   PInvFile2
     C                   PARM                    PInvFile3
     C                   PARM      *Blanks       PInvFile4        10                 MD041294
 
      ** Invalid file data
     C                   PARM      InvTr         PInvFDta1
     C                   PARM      InvTrSetIn    PInvFDta2
     C                   PARM                    PInvFDta3
     C                   PARM      *Blanks       PInvFDta4      4000                 MD041294
 
      ** Outputs
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      **  If F3, bypass further processing.
 
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProm_Delt - Prompt for Deletion                            *
      *                                                               *
      *****************************************************************
     C     SRProm_Delt   BEGSR
 
     C                   CALLB     'ZAINVTRDEL'
 
      ** Inputs
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action code
     C                   PARM                    #0ACCD
 
      ** Front Office Trans ID & Front Office Associated Trans ID
     C                   PARM                    #0FOID
     C                   PARM                    #0FOAs
 
      ** Timestamp
     C                   PARM                    #0TMES
 
      ** Narrative & Field Content 1 - 9
     C                   PARM                    PDDNar1
     C                   PARM      #0DLNO        PDDFld1
     C                   PARM                    PDDNar2
     C                   PARM      #0CNUM        PDDFld2
     C                   PARM                    PDDNar3
     C                   PARM      #0DDAT        PDDFld3
     C                   PARM                    PDDNar4
     C                   PARM      #0VDAT        PDDFld4
     C                   PARM                    PDDNar5
     C                   PARM      #0MDAT        PDDFld5
     C                   PARM                    PDDNar6
     C                   PARM      #0CUCY        PDDFld6
     C                   PARM                    PDDNar7
     C                   PARM      #0PAMT        PDDFld7
     C                   PARM                    PDDNar8
     C                   PARM                    PDDFld8
     C                   PARM                    PDDNar9
     C                   PARM                    PDDFld9
 
      ** Outputs
      ** Function keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
 
      ** If F3, bypass further processing.
 
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If F10, delete invalid deal
 
     C                   IF        PINKJ = '1'
     C                   MOVE      #0TMES        P0TmeS
 
     C     ZATRNKD0      CHAIN     IRICACFD0                          24
 
     C                   IF        *IN24 = *OFF
     C                   EVAL      #0ACCD = 'D'
     C                   EVAL      PEntryData = *BLANKS
     C                   EVAL      PFileName = *BLANKS
 
     C                   CALL      'RPC1600'
     C                   PARM      InvTr         PEntryData
     C                   PARM      'IRICACFPD'   PFileName
     C                   ENDIF
 
     C                   IF        *IN24 = *OFF
     C                   DELETE    IRICACFD0
     C                   ENDIF
                                                                                              CAP043
      ** Delete invalid record from invalid file (PCSC)                                       CAP043
                                                                                              CAP043
     C                   EXSR      SRDelIRCS                                                  CAP043
 
     C     APDSETK0      CHAIN     APIDSETD0                          24
     C                   IF        *IN24 = *OFF
     C                   DELETE    APIDSETD0
 
      ** Delete invalid record from the log file
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EVAL      KMsgType = WMSGTYPE
     C                   EVAL      KFrntOffID = #0FOID
     C                   EVAL      KTimeStamp = P0TmeS
 
     C     KAPILOG       CHAIN     APILOGL0                           24
     C                   IF        *IN24 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        CSC022 = 'N' OR                                           BUG2603
     C                             CSC022 = 'Y' AND WSkpCom = 'N'                            BUG2603
     C                   COMMIT
     C                   ENDIF                                                               BUG2603
     C                   ENDIF
 
     C                   ENDSR
                                                                                              CAP043
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRDelIRCS - Delete invalid records for Princiapl Change          *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRDelIRCS     BEGSR                                                                CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
                                                                                              CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
                                                                                              CAP043
     C     ZATRNKD0      SETLL     IRIPCSCL1                                                  CAP043
     C     ZATRNKD0      READE     IRIPCSCL1                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRIPCSCL1)                                        CAP043
     C                   DELETE    IRIPCSCD0                                                  CAP043
     C     ZATRNKD0      READE     IRIPCSCL1                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdITran - Read an Invalid Transaction                      *
      *                                                               *
      *****************************************************************
     C     SRRdITran     BEGSR
 
     C                   READ      IRICACFL0                              21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChAutN - Check for User Authority if not multi-branching   *
      *                                                               *
      *****************************************************************
     C     SRChAutN      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PACTN
     C                   PARM                    PErr
 
      ** Return Error Message
 
     C                   IF        PErr = 1
     C                   EVAL      PErrMs = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvTxt - Retrieve Text                                     *
      *                                                               *
      *****************************************************************
     C     SRRtvTxt      BEGSR
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMsgDNb
     C                   PARM      'ZZGBMSGF  '  PMsgNm
     C                   PARM      *BLANK        PMsgTxt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR
 
      ** Clear Outputs
 
     C                   EVAL      PErrMs = *BLANK
     C                   EVAL      POpSel = *BLANK
     C                   EVAL      PAcSel = *BLANK
     C                   EVAL      P0FOID = *BLANK
     C                   EVAL      P0FOAs = *BLANK
     C                   CLEAR                   P0TmeS
     C                   EVAL      PINKC = '0'
     C                   EVAL      PINKL = '0'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters:
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Build subfile
     C                   PARM                    PBdSfl
 
      ** Read subfile record
     C                   PARM                    PRdSfl
 
      ** Error in update of previous deal
     C                   PARM                    PErrUp
 
      ** Single Branch Code from SDBANKPD
     C                   PARM                    BJSBRC
 
      ** 24x7 Midas Availability Enhancement
     C                   PARM                    CSC011
 
      ** Output Parameters:
      ** Error message
     C                   PARM                    PErrMs
 
      ** Option selected
     C                   PARM                    POpSel
 
      ** Action selected
     C                   PARM                    PAcSel
 
      ** FO Transaction ID selected
     C                   PARM                    P0FOID
 
      ** FO Associated Transaction ID selected
     C                   PARM                    P0FOAs
 
      ** Timestamp of Transaction selected
     C                   PARM                    P0TmeS
 
      ** Command keys
     C                   PARM                    PINKC
     C                   PARM                    PINKL
 
      ** Successful Insert Deal Number
     C                   PARM                    PSIDN
     C                   PARM                    CAP041                                       CAP043
     C                   PARM                    CAP043                                       CAP043
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'IRCACFRPB'
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      #1WID = PsJobName
 
      ** Access SDSTAT and SC24x7 when CSC011 is installed
 
     C                   IF        CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
 
      ** Key Lists
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    #0FOID
     C                   KFLD                    P0TmeS
 
     C     APDSETK0      KLIST
     C                   KFLD                    WMSGTYPE
     C                   KFLD                    #0FOID
     C                   KFLD                    P0TmeS
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    P0TmeS
     C                   KFLD                    #0FOID
 
     C     APDSETKX      KLIST
     C                   KFLD                    WMSGTYPE
     C                   KFLD                    P0TmeS
     C                   KFLD                    #0FOID
 
     C     KAPILOG       KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
      ** Message Type
 
     C                   EVAL      WMSGTYPE = 'IRCACF'
 
      ** Format Text for Invalid Transaction deletion function
 
     C                   EVAL      PMsgDNb = 'APA0071'
     C                   EXSR      SRRtvTxt
     C                   EVAL      PDDNar1 = PMsgTxt
     C                   EVAL      PMsgDNb = 'APA0072'
     C                   EXSR      SRRtvTxt
     C                   EVAL      PDDNar2 = PMsgTxt
     C                   EVAL      PMsgDNb = 'APA0073'
     C                   EXSR      SRRtvTxt
     C                   EVAL      PDDNar3 = PMsgTxt
     C                   EVAL      PMsgDNb = 'APA0074'
     C                   EXSR      SRRtvTxt
     C                   EVAL      PDDNar4 = PMsgTxt
     C                   EVAL      PMsgDNb = 'APA0075'
     C                   EXSR      SRRtvTxt
     C                   EVAL      PDDNar5 = PMsgTxt
     C                   EVAL      PMsgDNb = 'APA0076'
     C                   EXSR      SRRtvTxt
     C                   EVAL      PDDNar6 = PMsgTxt
     C                   EVAL      PMsgDNb = 'APA0077'
     C                   EXSR      SRRtvTxt
     C                   EVAL      PDDNar7 = PMsgTxt
 
      *                                                                                      BUG2603
      ** Determine if enhancement CSC022 is switched on                                      BUG2603
      *                                                                                      BUG2603
     C                   CALLB     'AOSARDR0'                                                BUG2603
     C                   PARM      *BLANKS       PRtCd                                       BUG2603
     C                   PARM      '*VERIFY'     POptn                                       BUG2603
     C                   PARM      'CSC022'      PSARD                                       BUG2603
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG2603
      *                                                                                      BUG2603
      ** Initialize work fields                                                              BUG2603
      *                                                                                      BUG2603
     C                   EVAL      CSC022 = 'N'                                              BUG2603
     C                   EVAL      WSkpCom = 'N'                                             BUG2603
      *                                                                                      BUG2603
     C                   IF        PRtCd = *Blanks                                           BUG2603
     C                   EVAL      CSC022 = 'Y'                                              BUG2603
      *                                                                                      BUG2603
     C                   IN        SCCMTJOB                                                  BUG2603
      *                                                                                      BUG2603
     C                   IF        COMITNUM <> 0                                             BUG2603
     C                   MOVEA     Comitjobs     JobCmtctlDS                                 BUG2603
     C                   EVAL      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                     BUG2603
     C                   IF        WPos > 0                                                  BUG2603
     C                   EVAL      WSkpCom = 'Y'                                             BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ELSE                                                                BUG2603
      *                                                                                      BUG2603
      ** An NRF (No Record Found) return code is valid.                                      BUG2603
      ** Issue database error only for error return codes.                                   BUG2603
      *                                                                                      BUG2603
     C                   IF        PRtCd <> '*NRF'                                           BUG2603
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG2603
     C                   EVAL      DBKEY = 'CSC022'                                          BUG2603
     C                   EVAL      DBASE = 902                                               BUG2603
     C                   EXSR      *PSSR                                                     BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ENDIF                                                               BUG2603
      *                                                                                      BUG2603
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
**  Array of error messages - ErrorText
The last transaction was not applied to the database
Deal No. 999999 successfully inserted.
