     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Invalid yield rates browse')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDYRATRPB - Invalid Yield Rates Browse                       *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *          One display a list of invalid transactions for       *
      *          selection, the other picks off the selection made.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAS008             Date 16Jun04               *
      *  Prev Amend No. 208179             Date 05Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  208179 - 24x7 Midas Availability                             *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *    21         End of File                                     *
      *    22         Subfile Clear                                   *
      *    23         Rollup                                          *
      *    24         Read Error                                      *
      *    LR         End of Program                                  *
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
 
     FSDYRATRDF CF   E             WORKSTN
     F                                     SFILE(SDYRATS0:WRRN)
     FSDIYRATL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDIYRATD0:SDIYRATX0)
     FSDIYRATL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** API Invalid Log File from Support Database                                           208179
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR)                                       208179
     F                                     COMMIT                                             208179
     F/COPY WNCPYSRC,SDYRATRF01
 
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
 
     D InvYR1        E DS                  EXTNAME(SDIYRAT1PD)
     D InvYR2        E DS                  EXTNAME(SDIYRAT2PD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** 24X7 status data area                                                                208179
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     208179
                                                                                              208179
      ** SD data area                                                                         208179
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     208179
                                                                                              208179
      ** Array containing messages
     D ErrorText       S             52    DIM(1) CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRRN            S              5P 0
     D Counter         S              3P 0
 
      ** Input Parameters (Build Subfile Ind., Read Subfile Ind. and Update Error Ind.)
     D PBDSFL          S              1A
     D PRDSFL          S              1A
     D PERRUP          S              1A
 
      ** Output Parameters (Error Message Id, Option Selected, Action Code,
      ** Front Office Id, Transaction Reference and Timestamp)
     D PERRMS          S              7A
     D POPSEL          S              1A
     D PACSEL          S              1A
     D PFOTRANSEL      S             20A
     D PYLDC           S              5A
     D PYCCY           S              3A
     D PYICM           S              1A
     D PTMESTPSEL      S             26Z
 
      ** Function Keys (included in output parameter - F3 and F12)
     D PINKC           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
 
      ** Parameters for SDRTVTXT
     D PMSGDNB         S              7A
     D PMSGNM          S             10A
     D PMSGTXT         S             80A
 
      ** Parameters for ZAINVTRENQ
     D PDDFOASOCID     S             20A
     D PInvFile1       S             10A
     D PInvFile2       S             10A
     D PInvFile3       S             10A
     D PInvFDta1       S           4000A
     D PInvFDta2       S           4000A
     D PInvFDta3       S           4000A
 
      ** Parameters for ZVACTU
     D PACTN           S              1A
     D PERR            S              1P 0
 
      ** Parameters for Access Objects
     D PRtCd           S              7A
     D POptn           S              7A
 
      ** Parameters for ZAINVTRDEL
     D PDDNAR1         S             30A
     D PDDFLD1         S             35A
     D PDDNAR2         S             30A
     D PDDFLD2         S             35A
     D PDDNAR3         S             30A
     D PDDFLD3         S             35A
     D PDDNAR4         S             30A
     D PDDFLD4         S             35A
     D PDDNAR5         S             30A
     D PDDFLD5         S             35A
     D PDDNAR6         S             30A
     D PDDFLD6         S             35A
     D PDDNAR7         S             30A
     D PDDFLD7         S             35A
     D PDDNAR8         S             30A
     D PDDFLD8         S             35A
     D PDDNAR9         S             30A
     D PDDFLD9         S             35A
 
      ** Parameter for ZAROPTVAL
     D PDDBRSN         S              3A
                                                                                              208179
      ** Fields defined for Enhancement CSC011                                                208179
                                                                                              208179
     D CSC011          S              1A                                                      208179
     D KMsgType        S              8A                                                      208179
     D KFrntOffID      S             20A                                                      208179
     D KTimeStamp      S                   LIKE(PTMESTPSEL)                                   208179
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   EXSR      SrInit
 
      ** Build subfile
 
     C                   IF        PBDSFL = 'Y'
     C                   EXSR      SRBldSfl
     C                   ENDIF
 
      ** Read subfile record
 
     C                   IF        PRDSFL = 'Y'
     C                   EXSR      SRRdSFlr
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl - Build Subfile                                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRChAutN, SRRdITran                                    *
      *                                                               *
      *****************************************************************
 
     C     SRBldSfl      BEGSR
 
      ** Check for User Authority to browse if not multi-branching
 
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      SRChAutN
     C                   ENDIF
 
      ** Initialise subfile relative record number
 
     C                   Z-ADD     0             WRRN
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active
 
     C                   EVAL      *IN22 = *ON
     C                   WRITE     SDYRATC0
     C                   EVAL      *IN22 = *OFF
 
      ** If previous transaction was not successful due to deal being
      ** updated by another workstation then display message on screen
 
     C                   IF        PERRUP = 'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   MOVE      *BLANKS       ERRORMSG
     C                   ENDIF
 
      ** Write the select screen footer to the screen
 
     C                   WRITE     SDYRATF1
 
      ** Set file pointer to start of file
 
     C     *LOVAL        SETLL     SDIYRATL0
 
      ** Read an invalid transaction
 
     C                   EXSR      SRRdITran
 
      ** If no records exist - set up an error message then terminate
 
     C                   IF        *IN21 = *ON
     C                   EVAL      PERRMS = 'USR9245'
     C                   EXFMT     SDYRATEND
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Set on ROLLUP indicator to drive initial loop
 
     C                   EVAL      *IN23 = *ON
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.
 
     C                   DOW       *IN21 <> *ON and *IN23 = *ON
 
      ** Initialise count of records written to subfile page
 
     C                   Z-ADD     0             Counter
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full
 
     C                   DOW       *IN21 <> *ON and Counter < 14
 
      ** Increment the subfile record no. and records written fields
 
     C                   EVAL      WRRN = 1 + WRRN
     C                   EVAL      Counter = 1 + Counter
 
      ** Write the invalid transaction to the subfile
 
     C                   EVAL      #0OPT = *BLANK
     C                   EVAL      #0SFRN = WRRN
     C                   WRITE     SDYRATS0
 
      ** Read an invalid transaction
 
     C                   EXSR      SRRdITran
     C                   ENDDO
 
      ** Write the subfile control record to the screen to display
      ** the subfile
 
     C                   WRITE     SDYRATC0
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required
 
     C                   READ      SDYRATC0                               24
 
      ** If F3, bypass further processing
 
     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If F12, bypass further processing
 
     C                   IF        *INKL = *ON
     C                   EVAL      PINKL = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdSflr - Read Subfile Record                                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRValid_ROpt, SREnq_Inv, SRProm_Delt                   *
      *                                                               *
      *****************************************************************
 
     C     SRRdSflr      BEGSR
 
      ** Read the subfile for selected records.
      ** Only process those for which the option field is blank.
 
     C                   DOU       *IN24 = *ON or #0OPT <> *BLANK
     C                   READC     SDYRATS0                               24
 
      ** Validate repair option code
 
     C                   IF        *IN24 = *OFF
     C                   EXSR      SRValid_ROpt
     C                   ENDIF
 
      ** If 'E' is input, enquire upon invalid transaction
 
     C                   IF        *IN24 = *OFF and #0OPT = 'E'
     C                   MOVE      #0TMES        PTMESTPSEL
     C                   EXSR      SREnq_Inv
     C                   EVAL      #0OPT = *BLANK
     C                   ENDIF
 
      ** If 'Q' is input, prompt for deletion of invalid transaction
 
     C                   IF        *IN24 = *OFF and #0OPT = 'Q'
     C                   EXSR      SRProm_Delt
     C                   EVAL      #0OPT = *BLANK
     C                   ENDIF
     C                   ENDDO
 
      ** Return the selected option, action, front office transaction ID
      ** and front office associated transaction ID
 
     C                   IF        *IN24 <> *ON AND #0OPT <> *BLANK
     C                   EVAL      POPSEL = #0OPT
     C                   EVAL      PACSEL = #0ACTN
     C                   EVAL      PYLDC  = #0YLDC
     C                   EVAL      PYCCY  = #0YCCY
     C                   EVAL      PYICM  = #0YICM
     C                   EVAL      PFOTRANSEL = #0FOTR
     C                   MOVEL     #0TMES        PTMESTPSEL
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValid_ROpt - Validate Repair Option Code                    *
      *                                                               *
      * Called by: SRRdSflr                                           *
      *                                                               *
      * Calls: ZAROPTVAL                                              *
      *                                                               *
      *****************************************************************
 
     C     SRValid_ROpt  BEGSR
 
     C                   CALLB     'ZAROPTVAL'
 
      ** Inputs
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Option Code
      ** Front Office ID
      ** Booking Branch
 
     C                   PARM                    #0OPT
     C                   PARM                    #0FOTR
     C                   PARM                    PDDBRSN
 
      ** ICD Single Branch Code
 
     C                   PARM                    BJSBRC
 
      ** Outputs
      ** Function Keys
 
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKL
 
      ** If F3, bypass further processing
 
     C                   IF        PINKC = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If F12, continue with next option
 
     C                   IF        PINKL = *ON
     C                   EVAL      #0OPT = *BLANK
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnq_Inv - Enquire on Invalid Transaction                    *
      *                                                               *
      * Called by: SRRdSflr                                           *
      *                                                               *
      * Calls: ZAINVTRENQ                                             *
      *                                                               *
      *****************************************************************
 
     C     SREnq_Inv     BEGSR
 
      ** Pass the invalid transaction details to the enquiry
 
     C     ZAYRATX0      CHAIN     SDIYRATX0                          24
 
     C                   CALLB     'ZAINVTRENQ'
 
      ** Inputs
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action Code
      ** Front Office ID
      ** Associated Front Office ID
      ** Timestamp
 
     C                   PARM                    #0ACTN
     C                   PARM                    #0FOTR
     C                   PARM                    PDDFOASOCID
     C                   PARM                    #0TMES
 
      ** Invalid File Names
 
     C                   PARM      'SDIYRAT1PD'  PInvFile1
     C                   PARM      'SDIYRAT2PD'  PInvFile2
     C                   PARM      '         '   PInvFile3
 
      ** Invalid File Data
 
     C                   PARM      InvYR1        PInvFDta1
     C                   PARM      InvYR2        PInvFDta2
     C                   PARM      *BLANKS       PInvFDta3
 
      ** Outputs
      ** Function Keys
 
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKL
 
      ** If F3, bypass further processing
 
     C                   IF        PINKC = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProm_Delt - Prompt for Deletion                             *
      *                                                               *
      * Called by: SRRdSflr                                           *
      *                                                               *
      * Calls: ZAINVTRDEL                                             *
      *                                                               *
      *****************************************************************
 
     C     SRProm_Delt   BEGSR
 
     C                   CALLB     'ZAINVTRDEL'
 
      ** Inputs
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action Code
 
     C                   PARM                    #0ACTN
 
      ** Front Office Trans ID & Front Office Associated Trans ID
 
     C                   PARM                    #0FOTR
     C                   PARM                    PDDFOASOCID
 
      ** Timestamp
 
     C                   PARM                    #0TMES
 
      ** Narrative & Field Content 1 - 9
 
     C                   PARM                    PDDNAR1
     C                   PARM      #0YLDC        PDDFLD1
     C                   PARM                    PDDNAR2
     C                   PARM      #0YCCY        PDDFLD2
     C                   PARM                    PDDNAR3
     C                   PARM      #0YICM        PDDFLD3
     C                   PARM                    PDDNAR4
     C                   PARM                    PDDFLD4
     C                   PARM                    PDDNAR5
     C                   PARM                    PDDFLD5
     C                   PARM                    PDDNAR6
     C                   PARM                    PDDFLD6
     C                   PARM                    PDDNAR7
     C                   PARM                    PDDFLD7
     C                   PARM                    PDDNAR8
     C                   PARM                    PDDFLD8
     C                   PARM                    PDDNAR9
     C                   PARM                    PDDFLD9
 
      ** Outputs
      ** Function Keys
 
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKJ
     C                   PARM      *OFF          PINKL
 
      ** If F3, bypass further processing
 
     C                   IF        PINKC = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If F10, delete invalid transaction
 
     C                   IF        PINKJ = *ON
     C                   MOVE      #0TMES        PTMESTPSEL
     C     ZAYRATD0      CHAIN     SDIYRATD0                          24
 
     C                   IF        *IN24 = *OFF
     C                   DELETE    SDIYRATD0
     C                   ENDIF
                                                                                              208179
      ** Delete invalid record from the log file.                                             208179
                                                                                              208179
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             208179
                                                                                              208179
     C                   EVAL      KMsgType = 'SDYRAT'                                        208179
     C                   EVAL      KFrntOffID = #0FOTR                                        208179
     C                   EVAL      KTimeStamp = PTMESTPSEL                                    208179
                                                                                              208179
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      208179
     C                   IF        *IN99 = *OFF                                               208179
     C                   DELETE    APILOGL0                                                   208179
     C                   ENDIF                                                                208179
                                                                                              208179
     C                   ENDIF                                                                208179
                                                                                              208179
 
     C/COPY WNCPYSRC,SDYRATRC01
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdITran - Read an Invalid Transaction                       *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRRdITran     BEGSR
 
     C                   READ      SDIYRATL0                              21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChAutN - Check for User Authority if not multi-branching    *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls: ZVACTU                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRChAutN      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PACTN
     C                   PARM                    PERR
 
      ** Return error message
 
     C                   IF        PERR = 1
     C                   EVAL      PERRMS = 'USR9246'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvTxt - Retrieve Text                                      *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: SDRTVTXT                                               *
      *                                                               *
      *****************************************************************
 
     C     SRRtvTxt      BEGSR
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMSGDNB
     C                   PARM      'ZZGBMSGF  '  PMSGNM
     C                   PARM      *BLANK        PMSGTXT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Clear outputs
 
     C                   EVAL      PERRMS = *BLANK
     C                   EVAL      POPSEL = *BLANK
     C                   EVAL      PACSEL = *BLANK
     C                   EVAL      PYLDC  = *BLANK
     C                   EVAL      PYCCY  = *BLANK
     C                   EVAL      PYICM  = *BLANK
     C                   EVAL      PFOTRANSEL = *BLANK
     C                   CLEAR                   PTMESTPSEL
     C                   EVAL      PINKC = *OFF
     C                   EVAL      PINKL = *OFF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, SRRtvTxt, *PSSR                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Build Subfile
 
     C                   PARM                    PBDSFL
 
      ** Read Subfile Record
 
     C                   PARM                    PRDSFL
 
      ** Error in Update of Previous Deal
 
     C                   PARM                    PERRUP
 
      ** Output Parameters
      ** Error Message
 
     C                   PARM                    PERRMS
 
      ** Option Selected
 
     C                   PARM                    POPSEL
 
      ** Action Selected
 
     C                   PARM                    PACSEL
 
      ** Yield Curve
 
     C                   PARM                    PYLDC
 
      ** Currency
 
     C                   PARM                    PYCCY
 
      ** Interest Calculation Method
 
     C                   PARM                    PYICM
 
      ** FO Transaction ID Selected
 
     C                   PARM                    PFOTRANSEL
 
      ** Timestamp of Transaction Selected
 
     C                   PARM                    PTMESTPSEL
 
      ** Command Keys
 
     C                   PARM                    PINKC
     C                   PARM                    PINKL
                                                                                              208179
      ** CSC011 indicator                                                                     208179
                                                                                              208179
     C                   PARM                    CSC011                                       208179
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDYRATRPB'
 
      ** Move workstation ID to screen field
 
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WID = PsJobName
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   END
                                                                                              208179
      ** Access SDSTAT and SC24X7 if switchable feature CSC011 is on.                         208179
                                                                                              208179
     C                   IF        CSC011 = 'Y'                                               208179
     C                   IN        SDSTAT                                                     208179
     C                   IN        SC24X7                                                     208179
     C                   ENDIF                                                                208179
 
      ** Key lists
 
     C     ZAYRATD0      KLIST
     C                   KFLD                    #0FOTR
     C                   KFLD                    PTMESTPSEL
     C     ZAYRATX0      KLIST
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    #0FOTR
                                                                                              208179
     C     KAPILOGL0     KLIST                                                                208179
     C                   KFLD                    KMsgType                                     208179
     C                   KFLD                    KFrntOffID                                   208179
     C                   KFLD                    KTimeStamp                                   208179
 
      ** Format text for invalid transaction deletion function
 
     C                   EVAL      PMSGDNB = 'APA1110'
     C                   EXSR      SRRtvTxt
     C                   EVAL      PDDNAR1 = PMSGTXT
     C                   EVAL      PMSGDNB = 'APA1111'
     C                   EXSR      SRRtvTxt
     C                   EVAL      PDDNAR2 = PMSGTXT
     C                   EVAL      PMSGDNB = 'APA1112'
     C                   EXSR      SRRtvTxt
     C                   EVAL      PDDNAR3 = PMSGTXT
 
     C/COPY WNCPYSRC,SDYRATRC02
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  ErrorText
The last transaction was not applied to the database
