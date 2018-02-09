     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Watch list configuration browse')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDWLCCBRW - Watch List Configuration Browse                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG28012           Date 31Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG28012 - SDWLCCBDF changes (Recompile)                     *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDWLCCBDF CF   E             WORKSTN
     F                                     SFILE(SDWLCCS1:WRRN)
     FSDWLCCL0  IF   E           K DISK    INFSR(*PSSR)
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PEOF            S              1A
     D POptSel         S              1A
     D PFncSel         S              8A
     D PERRMS          S              7A
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKH           S              1A
     D PRdSfl          S              1A
     D PBldSfl         S              1A
     D PACTN           S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D ZACTN           S              1A
     D PERR            S              1  0
     D PCount          S              3  0
     D WRRN            S              5  0
     D JRRN            S              5  0
     D CURRFunc        S              8A
     D PREVFunc        S              8A
     D PFUNC           S              8A
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      /COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Initialisation
 
     C                   EXSR      SRInit
 
      ** Build subfile
 
     C     PBldSfl       IFEQ      'Y'
     C                   EXSR      SRBldSfl
     C                   ENDIF
 
      ** Read subfile record
 
     C     PRdSfl        IFEQ      'Y'
     C                   EXSR      SRRdSfl
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl - Subfile Details Generation Routine                 *
      *                                                               *
      *****************************************************************
 
     C     SRBldSfl      BEGSR
 
      ** Check for user authority to browse if not multi-branching
 
     C     BJSBRC        IFNE      *BLANKS
     C                   EXSR      SRChkAut
     C                   ENDIF
 
      ** Do until selection is not changed
 
     C                   MOVE      *BLANKS       PFUNC
     C                   Z-ADD     WRRN          JRRN
 
     C     CurrFUNC      DOUEQ     PrevFUNC
 
      ** Update record selection fields
 
     C                   MOVEL     PFUNC         CurrFUNC
     C                   MOVEL     CurrFUNC      PrevFUNC
 
      ** Initialise subfile relative record number
 
     C                   Z-ADD     0             WRRN
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active
 
     C                   MOVE      *ON           *IN97
     C                   WRITE     SDWLCCS0
     C                   MOVE      *OFF          *IN97
 
      ** Set file pointer on key displayed on screen
 
     C     #0FUNC        SETLL     SDWLCCL0
 
      ** Read a valid deal
 
     C                   EXSR      SRRdTrans
 
      ** Set on ROLLUP indicator to drive initial loop
 
     C                   MOVE      *ON           *IN98
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F5 is input
      ** or the selection is changed.
 
     C     *IN98         DOWEQ     *ON
     C     CurrFUNC      ANDEQ     PrevFUNC
 
      ** Initialise count of records written to subfile page
 
     C                   Z-ADD     0             PCount
 
      ** For each record read, write it to the subfile
      ** Do this until end of file or the subfile page is full
 
     C     PEOF          DOWNE     'Y'
     C     PCount        ANDLT     12
 
      ** Increment the subfile record no. and records written fields
 
     C                   ADD       1             WRRN
     C                   ADD       1             PCount
 
      ** Format details for output
 
     C                   EXSR      SRFmtDet
 
      ** Write record to the subfile
      ** If Action Code or Function Code selected is invalid
      ** the subfile postions on the error record and rebuilds
 
     C                   EVAL      *IN11 = *OFF
     C                   MOVE      *BLANKS       #1ACTN
     C                   IF        WRRN = JRRN
     C     '#1ACTN    '  LOOKUP    FldNameArr                             76
     C     '#1FUNC    '  LOOKUP    FldNameArr                             77
     C                   IF        *IN76 = *ON or *IN77 = *ON
     C                   EVAL      *IN11 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     WRRN          DDSFRN
     C                   WRITE     SDWLCCS1
 
      ** Read a valid transaction
 
     C                   EXSR      SRRdTrans
     C                   ENDDO
 
     C     PCount        IFEQ      0
     C                   WRITE     SDWLCCF1
     C                   EXFMT     SDWLCCS2
     C                   ELSE
 
      ** Write the subfile control record to the screen to display
      ** the subfile
 
     C                   WRITE     SDWLCCM0
     C                   WRITE     SDWLCCS0
     C                   WRITE     SDWLCCF1
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required
 
     C                   READ      SDWLCCS0                               75
 
      ** Clear any messages before processing user input
 
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
 
      ** Clear program message queue
 
     C                   CALL      'ZA0250'
     C                   ENDIF
 
      ** Update record selection fields
 
     C                   MOVEL     #0FUNC        CurrFUNC
 
      ** If F3, bypass further processing
 
     C     *INKC         IFEQ      *ON
     C                   MOVEL     *ON           PINKC
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If F5, rebuild subfile
 
     C     *INKE         IFEQ      *ON
     C                   MOVE      *BLANKS       #0FUNC
     C                   MOVE      #0FUNC        PFUNC
     C                   MOVE      *BLANKS       CurrFUNC
     C                   MOVE      *BLANKS       PrevFUNC
 
      ** Clear program message queue
 
     C                   CALL      'ZA0250'
     C                   ENDIF
 
      ** If F8, leave module to update data
 
     C     *INKH         IFEQ      *ON
     C                   MOVE      *BLANKS       #0FUNC
     C                   MOVE      #0FUNC        PFUNC
     C                   MOVE      *BLANKS       CurrFUNC
     C                   MOVE      *BLANKS       PrevFUNC
 
      ** Clear program message queue
 
     C                   CALL      'ZA0250'
     C                   MOVEL     *ON           PINKH
     C                   LEAVE
     C                   ENDIF
 
     C     *INKC         IFEQ      *OFF
     C     *INKE         ANDEQ     *OFF
     C     *INKH         ANDEQ     *OFF
     C                   MOVE      #0FUNC        PFUNC
     C                   MOVE      'Y'           PRdSfl
     C     *IN98         IFEQ      *OFF
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C     PRdSfl        IFEQ      'Y'
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdSfl - Subfile Details Generation Routine                  *
      *                                                               *
      *****************************************************************
 
     C     SRRdSfl       BEGSR
 
      ** Read the subfile for selected records
      ** Only process those for which the option field is not blank
 
     C     *IN75         DOUEQ     *ON
     C     #1ACTN        ORNE      *BLANKS
     C                   READC     SDWLCCS1                               75
     C                   ENDDO
 
      ** Return the selected Function Code and Action Code
 
     C     *IN75         IFNE      *ON
     C     #1ACTN        ANDNE     *BLANKS
 
     C     #1ACTN        IFEQ      'A'
     C                   MOVE      #1ACTN        POptSel
     C                   ELSE
     C                   MOVE      *BLANKS       POptSel
     C                   ENDIF
 
     C                   MOVE      #1FUNC        PFncSel
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtDet - Routine to Change the File Format Transaction to   *
      *            Screen Format                                      *
      *                                                               *
      ******************************************************************
 
     C     SRFmtDet      BEGSR
 
     C                   MOVE      W1FUNC        #1FUNC
     C                   MOVE      W1FUND        #1FUND
     C                   MOVE      W1EWLC        #1EWLC
     C                   MOVE      W1PFRQ        #1PFRQ
     C                   IF        W1PDYN <> *ZEROS
     C                   MOVE      W1PDYN        #1PDYN
     C                   ELSE
     C                   MOVE      *BLANKS       #1PDYN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdTrans- Subroutine to Retrieve a Valid Record from the     *
      *            Transaction File                                   *
      *                                                               *
      *****************************************************************
 
     C     SRRdTrans     BEGSR
 
      ** Reset End of File indicator
 
     C                   MOVE      *BLANKS       PEOF
 
      ** Read the file
 
     C                   READ      SDWLCCL0                               96
 
      ** End of File
 
     C     *IN96         IFEQ      *ON
     C                   MOVEL     'Y'           PEOF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkAut - Subroutine to Check for User's Authority           *
      *                                                               *
      *****************************************************************
 
     C     SRChkAut      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    PERR
 
      ** Return error message
 
     C     PERR          IFEQ      1
     C                   MOVEL     'FXM0292'     PERRMS
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation Routine                               *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Clear outputs
 
     C                   MOVE      *BLANKS       PERRMS
     C                   MOVE      *BLANKS       POptSel
     C                   MOVE      *BLANKS       PFncSel
     C                   MOVE      *OFF          PINKC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - Exception Errors                                      *
      *                                                               *
      *****************************************************************
 
     C     SRERR         BEGSR
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
 
      ** Terminate the program
 
     C                   EXSR      *PSSR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Received Parameters
      ** -------------------
 
      ** Action Code
      ** Function Code
      ** Build Subfile Indicator
      ** Read Subfile Indicator
      ** Error
     C                   PARM                    PACTN
     C                   PARM                    PFUNC
     C                   PARM                    PBldSfl
     C                   PARM                    PRdSfl
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Returned Parameters
      ** -------------------
 
      ** Command Keys
      ** F3
      ** F8
     C                   PARM                    PINKC
     C                   PARM                    PINKH
      ** Error Code
     C                   PARM                    PERRMS
      ** Option Selected
      ** Function Code Selected
     C                   PARM                    POptSel
     C                   PARM                    PFncSel
 
      ** Initialise program name
 
     C                   MOVEL     'SDWLCCBRW'   DBPGM
 
      ** Move workstation ID to screen field
 
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
 
     C                   EVAL      *IN94 = *ON
     C                   EVAL      DDPGMQ = '*'
 
      ** Get Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY  = '*FIRST '
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EXSR      SRERR
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** Functions for the message handler, ZAMSGHNDLE.
      /COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      /COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
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
