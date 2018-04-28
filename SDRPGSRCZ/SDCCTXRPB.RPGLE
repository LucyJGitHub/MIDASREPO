     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details by Country of Tax Rpr Br')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCCTXRPB - Invalid Customer Details by Country of Tax Repair*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 21Sep05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  236137 - Change Control for CGL031 (Recompile)               *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Invalid CCTX Browse
     FSDCCTXRDF CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SDCCTXRS0:WkSRRN)
 
      ** Midas SD Invalid CCTX by Timestamp and FOID - Retrieve
     FSDICCTXL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDICCTXD0:SDICCTXX0)
 
      ** Midas SD Invalid CCTX by Timestamp and FOID - Update
     FSDICCTXL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** API Invalid Log File from Support Database
 
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
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
 
     D InvTr         E DS                  EXTNAME(SDICCTXPD)
 
      ** SD data area
     D SDSTAT        E DS                  Extname(SDSTAT) DTAARA(SDSTAT)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZVACTU
     D ZACTN           S              1A
     D PErr            S              1  0
 
      ** Entry Parameters
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PErrUp          S              1A
     D PErrMs          S              7A
     D POpSel          S              1A
     D PFoTranSel      S             20A
     D PFoAsocSel      S             20A
     D PTMESTPSEL      S             26Z
 
      ** Parameter for RPC1600
     D EntryData       S           3000A
     D FileName        S             10A
 
      ** Command Keys
     D PINKC           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
 
      ** SDBANKPD field
     D BJMRDT          S              7A
     D BJSBRC          S              3A
 
      ** Subfile Relative Record Number
     D WkSRRN          S              5  0
 
      ** Work Variables
     D WkEOF           S              1A
     D WkCnt           S              3  0
     D WBookBrch       S              3A
 
      ** Invalid File Names
     D PInvFile1       S             10A
     D PInvFile2       S             10A
     D PInvFile3       S             10A
 
      ** Invalid file data
     D PInvFDta1       S           4000A
     D PInvFDta2       S           4000A
     D PInvFDta3       S           4000A
 
     D MsgDNb          S              7A
     D MsgNm           S             10A
     D MsgTxt          S             80A
 
      ** Narratives Content 1 - 9
     D DDNAR1          S             30A
     D DDNAR2          S             30A
     D DDNAR3          S             30A
     D DDNAR4          S             30A
     D DDNAR5          S             30A
     D DDNAR6          S             30A
     D DDNAR7          S             30A
     D DDNAR8          S             30A
     D DDNAR9          S             30A
 
      ** Field Contents 1 - 9
     D DDFLD1          S             35A
     D DDFLD2          S             35A
     D DDFLD3          S             35A
     D DDFLD4          S             35A
     D DDFLD5          S             35A
     D DDFLD6          S             35A
     D DDFLD7          S             35A
     D DDFLD8          S             35A
     D DDFLD9          S             35A
 
      ** Fields defined for Enhancement CSC011
 
     D CSC011          S              1A
     D KMsgType        S              8A
     D KFrntOffID      S             20A
     D KTimeStamp      S                   LIKE(PTMESTPSEL)
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initialise fields
 
     C                   EXSR      SRInit
 
      ** Build Sub-file
 
     C                   IF        PBdSfl = 'Y'
     C                   EXSR      SRBldSfl
     C                   END
 
      ** Read Subfile Record
 
     C                   IF        PRdSfl = 'Y'
     C                   EXSR      SRRdSflR
     C                   END
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation of Fields                             *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   IF        (CSC011 = 'Y')
     C                   OPEN      APILOGL0                             22
     C                   ENDIF
 
     C                   EVAL      PErrms = *Blanks
     C                   EVAL      POpSel = *Blanks
     C                   EVAL      PFOTranSel = *Blanks
     C                   CLEAR                   PTMESTPSEL
     C                   EVAL      PINKC = '0'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl - Build Subfile                                      *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
 
      ** Check for user Authority to Browse if not multi-branching
 
     C                   IF        BJSBRC <> *Blanks
     C                   EXSR      SRChkAut
     C                   ENDIF
 
      ** Initialise subfile relative record number
 
     C                   EVAL      WkSRRN = 0
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
 
     C                   EVAL      *IN97 = *On
     C                   WRITE     SDCCTXRC0
     C                   EVAL      *IN97 = *Off
 
      ** Write the select screen footer to the screen.
      ** If previous transaction was not successful due to deal being
      ** updated by another workstation then display message on screen
 
     C                   IF        PErrUp = 'Y'
     C                   EVAL      *IN61 = *ON
     C                   ELSE
     C                   EVAL      *IN61 = *OFF
     C                   ENDIF
 
     C                   WRITE     SDCCTXRF0
 
      ** Set file pointer to start of file
 
     C     *LOVAL        SETLL     SDICCTXL0
 
      ** Read an Invalid Record
 
     C                   EXSR      SRRdIRec
 
      ** If no records exist - set up an error message.
      ** Display a message 'No invalid transactions present'
      ** then terminate
 
     C                   IF        WkEOF = 'Y'
     C                   EVAL      PErrMs = 'ABM0565'
     C                   EVAL      *IN10 = *OFF
     C                   EXFMT     SDCCTXRF1
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN98 = *On
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.
 
     C                   DOW       WkEOF <> 'Y' and *IN98 = *On
 
      ** Initialise count of records written to subfile page.
 
     C                   EVAL      WkCnt = 0
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       WkEOF <> 'Y' and WkCnt < 14
 
      ** Increment the subfile record no. and records written fields.
 
     C                   ADD       1             WkSRRN
     C                   ADD       1             WkCNT
 
      ** Write the invalid record to the subfile
 
     C                   EVAL      DDOPT = *Blanks
     C                   Z-ADD     WkSRRN        DDSFRN
     C                   MOVE      DDTMST        DDTMSP
     C                   WRITE     SDCCTXRS0
 
      ** Read an invalid record
 
     C                   EXSR      SRRdIRec
     C                   ENDDO
 
      **  Write the subfile control record to the screen to display
      **  the subfile.
 
     C                   WRITE     SDCCTXRC0
 
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
 
     C                   READ      SDCCTXRC0                              99
 
      **  If F3, bypass further processing.
 
     C                   IF        *INKC = *On
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdSflR - Read Subfile Record                                *
      *                                                               *
      *****************************************************************
     C     SRRdSflR      BEGSR
 
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
 
     C                   DOU       *IN99 = *On or DDOPT <> *Blanks
     C                   READC     SDCCTXRS0                              99
 
      ** Validate repair option code
 
     C                   IF        *IN99 = *Off and DDOPT <> *BLANKS
     C                   EXSR      SRValRpr
     C                   ENDIF
 
      ** If 'E' is input, enquire upon invalid record
 
     C                   IF        *IN99 = *Off and DDOPT = 'E'
     C                   MOVE      DDTMSP        PTMESTPSEL
     C                   EXSR      SREnqInv
     C                   EVAL      DDOPT = *Blanks
     C                   ENDIF
 
      ** If 'Q' is input, prompt for deletion of invalid record
 
     C                   IF        *IN99 = *Off and DDOPT = 'Q'
     C                   EXSR      SRPromDel
     C                   EVAL      DDOPT = *BLANK
     C                   ENDIF
 
     C                   ENDDO
 
      **  Return the selected option, action and front office transaction ID
 
     C                   IF        *IN99 <> *On and DDOPT <> *Blanks
 
     C                   EVAL      POpSel = DDOPT
     C                   EVAL      PFOTranSel = DDFRNT
     C                   MOVE      DDTMSP        PTMESTPSEL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkAut - Check for user authority if not multi-branching    *
      *                                                               *
      *****************************************************************
     C     SRChkAut      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    PErr
 
      ** Return error message for user not authorized then terminate.
 
     C                   IF        PErr = 1
     C                   EVAL      PErrMs = 'FXM0292'
     C                   EVAL      *IN10 = *ON
     C                   EXFMT     SDCCTXRF1
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdIRec - Read an Invalid Record                             *
      *                                                               *
      *****************************************************************
     C     SRRdIRec      BEGSR
 
      **  Reset End of File indicator
 
     C                   EVAL      WkEOF = *Blanks
 
      **  Read the file
 
     C                   READ      SDICCTXL0                              96
 
      ** End of File
 
     C                   IF        *IN96 = *On
     C                   EVAL      WkEOF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValRpr   - Validate Repair Option Code                      *
      *                                                               *
      *****************************************************************
     C     SRValRpr      BEGSR
 
     C                   CALLB     'ZAROPTVAL'
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Option code
     C                   PARM                    DDOPT
 
      ** Front Office ID
     C                   PARM                    DDFRNT
 
      ** Booking Branch
     C                   PARM      *BLANK        WBookBrch
 
      ** ICD Single branch code
     C                   PARM                    BJSBRC
 
      ** Output Parameters
      ** =================
 
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      **  If F3, bypass further processing.
 
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
      **  If F12, continue with next option
 
     C                   IF        PINKL = '1'
     C                   EVAL      DDOPT = *Blanks
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnqInv - Enquire on invalid record                          *
      *                                                               *
      *****************************************************************
     C     SREnqInv      BEGSR
 
      ** Pass the invalid record details to the enquiry
 
     C     ZATRNKX0      CHAIN     SDICCTXX0                          99
 
     C                   CALLB     'ZAINVTRENQ'
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action code
     C                   PARM                    DDACTN
 
      ** Front Office ID
     C                   PARM                    DDFRNT
 
      ** Associated Front Office ID
     C                   PARM      *BLANK        PFoAsocSel
 
      ** Timestamp
     C                   PARM                    DDTMSP
 
      ** Invalid file names
     C                   PARM      'SDICCTXPD'   PInvFile1
     C                   PARM      *BLANK        PInvFile2
     C                   PARM      *BLANK        PInvFile3
 
      ** Invalid file data
     C                   PARM      InvTr         PInvFDta1
     C                   PARM      *BLANK        PInvFDta2
     C                   PARM      *BLANK        PInvFDta3
 
      ** Output Parameters
      ** =================
 
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      ** If F3, bypass further processing.
 
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPromDel - Prompt for Deletion                               *
      *                                                               *
      *****************************************************************
     C     SRPromDel     BEGSR
 
     C                   CALLB     'ZAINVTRDEL'
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action code
     C                   PARM                    DDACTN
 
      ** Front Office Trans ID
     C                   PARM                    DDFRNT
 
      ** Front Office Associated Trans ID
     C                   PARM      *BLANK        PFoAsocSel
 
      ** Timestamp
     C                   PARM                    DDTMSP
 
      ** Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1
     C                   PARM      DDCUST        DDFLD1
     C                   PARM                    DDNAR2
     C                   PARM      DDCTTX        DDFLD2
     C                   PARM                    DDNAR3
     C                   PARM      DDETXS        DDFLD3
     C                   PARM                    DDNAR4
     C                   PARM                    DDFLD4
     C                   PARM                    DDNAR5
     C                   PARM                    DDFLD5
     C                   PARM                    DDNAR6
     C                   PARM                    DDFLD6
     C                   PARM                    DDNAR7
     C                   PARM                    DDFLD7
     C                   PARM                    DDNAR8
     C                   PARM                    DDFLD8
     C                   PARM                    DDNAR9
     C                   PARM                    DDFLD9
 
      ** Output Parameters
      ** =================
 
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
 
      **  If F3, bypass further processing.
 
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
      **  If F10, delete invalid deal
     C                   IF        PINKJ = '1'
 
     C                   MOVE      DDTMSP        PTMESTPSEL
     C     ZATRNKD0      CHAIN     SDICCTXD0                          99
 
     C                   IF        *IN99 = *Off
     C                   MOVE      'D'           DDACTN
     C                   MOVEL     *BLANKS       EntryData
     C                   MOVEL     *BLANKS       FileName
     C                   CALL      'RPC1600'
     C                   PARM      InvTr         EntryData
     C                   PARM      'SDICCTXPD'   FileName
     C                   DELETE    SDICCTXD0
     C                   ENDIF
 
      ** Delete invalid record from the log file.
 
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR
 
     C                   EVAL      KMsgType = 'SDBSRT'
     C                   EVAL      KFrntOffID = DDFRNT
     C                   EVAL      KTimeStamp = PTMESTPSEL
 
     C     KAPILOGL0     CHAIN     APILOGL0                           99
     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvTxt - Retrieve Text                                      *
      *                                                               *
      *****************************************************************
     C     SRRtvTxt      BEGSR
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB
     C                   PARM      'ZZGBMSGF  '  MSGNM
     C                   PARM      *BLANK        MSGTXT
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Build Sub-file
     C                   PARM                    PBdSfl
 
      ** Read subfile record
     C                   PARM                    PRdSfl
 
      ** Error in update of previous record
     C                   PARM                    PErrUp
 
      ** Single Branch Code
     C                   PARM                    BJSBRC
 
      ** Midas Run Date
     C                   PARM                    BJMRDT
     C                   PARM                    CSC011
 
      ** Output Parameters
      ** =================
 
      ** Error Message
     C                   PARM                    PErrMs
 
      ** Option Selected
     C                   PARM                    POpSel
 
      ** FO Transaction ID Selected
     C                   PARM                    PFOTranSel
 
      ** Timestamp of transaction selected
     C                   PARM                    PTMESTPSEL
 
      ** Command Keys
     C                   PARM                    PINKC
 
      ** Move workstation ID to screen fields
 
     C                   EVAL      DDWSID = PSJobName
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDRUNA = BJMRDT
 
      ** Key Lists
 
     C     KAPILOGL0     KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFRNT
     C                   KFLD                    PTMESTPSEL
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    DDFRNT
 
      ** Format text for invalid record deletion function
 
     C                   MOVEL     'APA0503'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR1
 
     C                   MOVEL     'APA0501'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR2
 
     C                   MOVEL     'APA0502'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR3
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ********************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
