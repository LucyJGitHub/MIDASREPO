     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management Repair Browse')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDDCMTRPB - Invalid Document Management Repair Browse        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Invalid Document Management Browse
     FSDDCMTRPDFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SDDCMTS1:WkSRRN)
 
      ** Midas SD Invalid DCMT by Timestamp and FOID - Retrieve
     FSDIDCMTL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDIDCMTD0:SDIDCMTX0)
 
      ** Midas SD Invalid DCMT by Timestamp and FOID - Update
     FSDIDCMTL1 UF   E           K DISK    INFSR(*PSSR)
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
 
     D InvTr         E DS                  Extname(SDIDCMTPD)
 
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
     D PAcSel          S              1A
     D PFoTranSel      S             20A
     D PFoAsocSel      S             20A
     D PTMESTPSEL      S             26A
 
      ** Command Keys
     D PINKC           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
 
      ** SDBANKPD field
     D PRMRDT          S              7A
     D PRSBRC          S              3A
 
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
 
      ** Parameter for RPC1600
     D EntryData       S           3000A
     D FileName        S             10A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Initialise fields
 
     C                   EXSR      SRINIT
 
      ** Build Sub-file
 
     C                   IF        PBdSfl = 'Y'
     C                   EXSR      SRBldSfl
     C                   ENDIF
 
      ** Read Subfile Record
 
     C                   IF        PRdSfl = 'Y'
     C                   EXSR      SRRdSflR
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInit - Initialisation of Fields                             *
      *****************************************************************
 
     C     SRInit        BEGSR
 
     C                   EVAL      PErrms = *Blanks
     C                   EVAL      POpSel = *Blanks
     C                   EVAL      PAcSel = *Blanks
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
 
     C                   IF        PRSBRC <> *Blanks
     C                   EXSR      SRChkAut
     C                   ENDIF
 
      ** Initialise subfile relative record number
 
     C                   EVAL      WkSRRN = 0
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
 
     C                   EVAL      *IN97 = *On
     C                   WRITE     SDDCMTS0
     C                   EVAL      *IN97 = *Off
 
      ** Write the select screen footer to the screen.
      ** If previous transaction was not successful due to deal being
      ** updated by another workstation then display message on screen
 
     C                   IF        PErrUp = 'Y'
     C                   EVAL      *IN61 = *ON
     C                   ELSE
     C                   EVAL      *IN61 = *OFF
     C                   ENDIF
 
     C                   WRITE     SDDCMTF1
 
      ** Set file pointer to start of file
 
     C     *LOVAL        SETLL     SDIDCMTL0
 
      ** Read an Invalid Record
 
     C                   EXSR      SRRdIRec
 
      ** If no records exist - set up an error message.
      ** Display a message 'No invalid transactions present'
      ** then terminate
 
     C                   IF        WkEOF = 'Y'
     C                   EVAL      PErrMs = 'ABM0565'
     C                   EVAL      *IN10 = *OFF
     C                   EXFMT     SDDCMTF1
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
 
     C                   EVAL      WkSRRN = WkSRRN + 1
     C                   EVAL      WkCNT = WkCNT + 1
 
      ** Write the invalid record to the subfile
 
     C                   EVAL      DDOPT = *Blanks
      *
     C                   Z-ADD     WkSRRN        DDSFRN
     C                   MOVE      DDTMESTMP     DDTMSTMP
     C                   WRITE     SDDCMTS1
 
      ** Read an invalid record
 
     C                   EXSR      SRRdIRec
     C                   ENDDO
 
      **  Write the subfile control record to the screen to display
      **  the subfile.
 
     C                   WRITE     SDDCMTS0
 
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
 
     C                   READ      SDDCMTS0                               99
 
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
     C                   READC     SDDCMTS1                               99
 
      ** Validate repair option code
 
     C                   IF        *IN99 = *Off and DDOPT <> *Blanks
     C                   EXSR      SRValRpr
     C                   ENDIF
 
      ** If 'E' is input, enquire upon invalid record
 
     C                   IF        *IN99 = *Off and DDOPT = 'E'
     C                   MOVE      DDTMSTMP      PTMESTPSEL
     C                   EXSR      SREnqInv
     C                   EVAL      DDOPT = *Blanks
     C                   ENDIF
 
      ** If 'Q' is input, prompt for deletion of invalid record
 
     C                   IF        *IN99 = *Off and DDOPT = 'Q'
     C                   EXSR      SRPromDel
     C                   EVAL      DDOPT = *Blanks
     C                   ENDIF
 
     C                   ENDDO
 
      **  Return the selected option, action and front office transaction ID
 
     C                   IF        *IN99 <> *On AND DDOPT <> *Blanks
 
     C                   EVAL      POpSel = DDOPT
     C                   EVAL      PAcSel = DDACTN
     C                   EVAL      PFOTranSel = DDFOTRANID
     C                   MOVE      DDTMSTMP      PTMESTPSEL
 
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
     C                   EXFMT     SDDCMTF1
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
 
     C                   READ      SDIDCMTL0                              96
 
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
 
      * Input Parameters :
 
      ** Return Code
      ** Option code
      ** Front Office ID
      ** Booking Branch
      ** ICD Single branch code
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM                    DDOPT
     C                   PARM                    DDFOTRANID
     C                   PARM      *Blanks       WBookBrch
     C                   PARM                    PRSBRC
 
      * Output Parameters :
 
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
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
 
     C     KEY1          CHAIN     SDIDCMTX0                          99
 
     C                   CALLB     'ZAINVTRENQ'
 
      * Input Parameters :
 
      ** Return Code
      ** Action code
      ** Front Office ID
      ** Associated Front Office ID
      ** Timestamp
      ** Invalid file names
      ** Invalid file data
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDFOTRANID
     C                   PARM      *Blanks       PFoAsocSel
     C                   PARM                    DDTMSTMP
     C                   PARM      'SDIDCMTPD'   PInvFile1
     C                   PARM      *Blanks       PInvFile2
     C                   PARM      *Blanks       PInvFile3
     C                   PARM      InvTr         PInvFDta1
     C                   PARM      *Blanks       PInvFDta2
     C                   PARM      *Blanks       PInvFDta3
 
      * Output Parameters :
 
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
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
 
      * Input Parameters :
 
      ** Return Code
      ** Action code
      ** Front Office Trans ID
      ** Front Office Associated Trans ID
      ** Timestamp
      ** Narrative & Field Content 1 - 9
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDFOTRANID
     C                   PARM      *Blanks       PFoAsocSel
     C                   PARM                    DDTMSTMP
     C                   PARM                    DDNAR1
     C                   PARM      DDREFN        DDFLD1
     C                   PARM                    DDNAR2
     C                   PARM      DDCODE        DDFLD2
     C                   PARM                    DDNAR3
     C                   PARM      DDSTCD        DDFLD3
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
 
      * Output Parameters :
 
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
     C                   MOVE      DDTMSTMP      PTMESTPSEL
     C     KEY1          CHAIN     SDIDCMTD0                          99
 
     C                   IF        *IN99 = *Off
     C                   EVAL      DDACTN    = 'D'
     C                   EVAL      EntryData = *BLANKS
     C                   EVAL      FileName  = *BLANKS
     C                   CALL      'RPC1600'
     C                   PARM      InvTr         EntryData
     C                   PARM      'SDIARCVPD'   FileName
     C                   DELETE    SDIDCMTD0
     C                   ENDIF
 
      ** Delete invalid record from the log file.
 
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
     C                   PARM      *Blanks       MSGTXT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      * Input Parameters :
 
      ** Return Code
      ** Build Sub-file
      ** Read subfile record
      ** Error in update of previous record
      ** Single Branch Code
      ** Midas Run Date
     C                   PARM                    RetCodeIn
     C                   PARM                    PBdSfl
     C                   PARM                    PRdSfl
     C                   PARM                    PErrUp
     C                   PARM                    PRSBRC
     C                   PARM                    PRMRDT
 
      ** Output Parameters :
 
      ** Error Message
      ** Option Selected
      ** Action Selected
      ** FO Transaction ID Selected
      ** Timestamp of transaction selected
      ** Command Keys
     C                   PARM                    PErrMs
     C                   PARM                    POpSel
     C                   PARM                    PAcSel
     C                   PARM                    PFOTranSel
     C                   PARM                    PTMESTPSEL
     C                   PARM                    PINKC
 
      ** Move workstation ID to screen fields
 
     C                   EVAL      DDWID = PSJobName
     C                   EVAL      DDUSER = PSUser
 
      ** Key Lists
 
     C     KEY1          KLIST
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    PTMESTPSEL
 
      ** Format text for invalid record deletion function
 
     C                   MOVEL     'APA0500'     MSGDNB
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
 
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
