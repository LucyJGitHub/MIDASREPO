     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments browse')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAYBRW - Incoming Payments Browse                         *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            - displays a list of Incoming Payments for         *
      *              selection.                                       *
      *            - picks off the selection made.                    *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT151             Date 20Mar14               *
      *                 CFT120             Date 28Sep12               *
      *                 AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 228101             Date 09Oct06               *
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT151 - FT IN/OP Alphanumeric sequence                      *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FTH00035                                 *
      *             WNCPYSRC,FTH00036                                 *
      *             WNCPYSRC,FTH00037                                 *
      *             WNCPYSRC,FTH00038                                 *
      *  228101 - Transactions should be sorted by reference, with    *
      *           the latest ones first. Applied fix 217202.          *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Browse screen
     FFTIPAYBDF CF   E             WORKSTN
     F                                     SFILE(FTIPAYS0:W_RRN)
     F                                     SFILE(FTIPAYS1:W_RRN)
      *
      ** Incoming Payments by Front Office Id
     F***INPAYL0***IF***E           K DISK    INFSR(*PSSR)                                    228101
     FINPAYL5   IF   E           K DISK    INFSR(*PSSR)                                       228101
     F                                     RENAME(INPAYDDF:INPAYX0)
      *
      ** Incoming Payments by Payment Reference
     F***INPAY*****IF***E           K DISK    INFSR(*PSSR)                                    228101
     FINPAYL4   IF   E           K DISK    INFSR(*PSSR)                                       228101
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** DS for Payment Reference
     D                 DS
     D WPREF                   1     15
     D  WP                     1      1
     D  WDate                  2      7
     D  WPmtRef                8     11
     D  WPmtTyp               12     13
     D  WStmTyp               14     15
     D/COPY WNCPYSRC,FTH00035
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CFT151
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT151
      *
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialisation.
      *
     C                   EXSR      SRInit
      *
      ** Build subfile.
      *
     C                   IF        PBDSFL = 'Y'
      *
      ** Validate Payment Reference.
      *
     C                   EXSR      SRValRef
      *
      ** If first time in or subfile by backoffice key was previously
      ** being run, then build subfile keyed on Payment Reference.
      ** Stay in loop while F11 toggle key is used.
      *
     C                   IF        WPrvOrd <> 'F'
      *
     C                   DOU       *INKK = *Off
      *
     C                   EXSR      SRBldSfl1
      *
      ** If F11, switch to subfile by Front Office Id.
      *
     C                   IF        *INKK = *On
     C                   EXSR      SRBldSfl2
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ELSE
      *
      ** If the subfile by Front Office Identifier was previously
      ** being run, then build subfile keyed on Front Office Id.
      ** Stay in loop while F11 toggle key is used.
      *
     C                   DOU       *INKK = *Off
      *
     C                   EXSR      SRBldSfl2
      *
      ** If F11, switch to subfile by Midas Payment Reference.
      *
     C                   IF        *INKK = *On
     C                   EXSR      SRBldSfl1
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read subfile record.
      *
     C                   If        PRDSFL = 'Y'
     C                   EXSR      SRRdSfl
     C                   EndIf
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation Processing                           *
      *                                                               *
      *****************************************************************
      *
     C     SRInit        BEGSR
      *
      ** Clear output.
      *
     C                   MOVE      '0'           PINKC
     C                   MOVE      '0'           PINKL
     C                   MOVE      *Blanks       PERRMS
     C                   MOVE      *Blanks       POPSEL
     C                   MOVE      *Blanks       PPREFSEL
      *
     C/COPY WNCPYSRC,FTH00036
     C                   CALLB     'AOSARDR0'                                                 CFT151
     C                   PARM      *BLANKS       PRTCD             7                          CFT151
     C                   PARM      '*VERIFY'     POPTN             7                          CFT151
     C                   PARM      'CFT151'      PSARD             6                          CFT151
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT151
      *                                                                                       CFT151
     C     PRTCD         IFEQ      *BLANKS                                                    CFT151
     C                   MOVE      'Y'           CFT151            1                          CFT151
     C                   ELSE                                                                 CFT151
     C                   MOVE      'N'           CFT151                                       CFT151
     C                   ENDIF                                                                CFT151
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValRef - Validate Payment Reference pointer                *
      *                                                               *
      *****************************************************************
      *
     C     SRValRef      BEGSR
      *
      ** Validate if the Payment Ref is in correct format or blank.
      *
     C     DDPREF        IFNE      *BLANKS
      *
     C                   MOVE      DDPREF        WPREF
     C/COPY WNCPYSRC,FTH00037
      *
     C     CFT151        IFEQ      'N'                                                        CFT151
     C                   TESTN                   WDate                01
     C                   TESTN                   WPmtRef              02
     C                   TESTN                   WStmTyp              03
      *
     C     WP            IFNE      'P'
     C     WPmtTyp       ORNE      'IN'
     C     *IN01         ORNE      *ON
     C     *IN02         ORNE      *ON
     C     *IN03         ORNE      *ON
     C                   MOVEL     'FTA0108'     PErrMs
     C                   RETURN
     C                   ENDIF
      *                                                                                       CFT151
     C                   ELSE                                                                 CFT151
     C                   TESTN                   WDate                01                      CFT151
     C                   TESTN                   WStmTyp              03                      CFT151
      *                                                                                       CFT151
     C     WP            IFNE      'P'                                                        CFT151
     C     WPmtTyp       ORNE      'IN'                                                       CFT151
     C     *IN01         ORNE      *ON                                                        CFT151
     C     *IN03         ORNE      *ON                                                        CFT151
     C                   MOVEL     'FTA0108'     PErrMs                                       CFT151
     C                   RETURN                                                               CFT151
     C                   ENDIF                                                                CFT151
     C                   ENDIF                                                                CFT151
     C/COPY WNCPYSRC,FTH00038
      *
     C                   ENDIF
      *
     C                   MOVE      DDPREF        KPREF            15
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBLDSFL1 - Build Subfile by Midas Payment Reference         *
      *                                                               *
      *****************************************************************
      *
     C     SRBldSfl1     BEGSR
      *
      ** Set flag for Midas Payment Reference key used.
      *
     C                   MOVE      'B'           WPrvOrd           1
      *
      ** Check for user authority to browse if not multi-branch environment.
      *
     C                   IF        BJSBRC <> *Blanks
     C                   EXSR      SRChkAut
     C                   ENDIF
      *
      ** Initialise subfile relative record number.
      *
     C                   Z-ADD     0             W_RRN             5 0
      *
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     FTIPAYC0
     C                   MOVE      '0'           *IN97
      *
      ** Select screen footer for the screen.
      *
     C                   WRITE     FTIPAYF1
      *
      ** Set record pointer to first record.
      *
     C     DDPREF        IFEQ      *BLANKS                                                    228101
     C                   EVAL      KPREF = '999999999999999'                                  228101
     C                   ENDIF                                                                228101
     C*****KPREF*********SETLL     INPAY                                                      228101
     C     KPREF         SETGT     INPAYL4                                                    228101
      *
      ** Read an Incoming Payment from file.
      *
     C                   EXSR      SRRDINPAY
      *
      ** If no record read, set up an error message.
      *
     C                   IF        W_EOF = 'Y'
      *
      ** If key is blank, display 'No Incoming Payments present.'.
      *
     C                   IF        KPREF = *Blanks
     C                   MOVEL     'FTA0112'     PERRMS
     C                   ELSE
      *
      ** Else, display 'No Incoming Payments to display for the
      ** selection made.'.
      *
     C                   MOVEL     'FTA0113'     PERRMS
     C                   ENDIF
      *
     C                   RETURN
     C                   ENDIF
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      *On           *IN98
      *
      ** While ROLLUP, build a subfile page.
      *
     C                   DOW       *IN98 = *On
      *
      ** Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             W_CNT             3 0
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C                   DOW       W_EOF <> 'Y' and
     C                             W_CNT < 14
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             W_RRN
     C                   ADD       1             W_CNT
      *
      ** Format fields for output.
      *
     C                   EXSR      SRFmtDet
      *
      ** Write the Incoming Payments details to subfile.
      *
     C                   MOVE      *Blank        DDOPTN
     C                   Z-ADD     W_RRN         DDSFRN
     C                   WRITE     FTIPAYS0
      *
      ** Read next Incoming Payment.
      *
     C                   EXSR      SRRDInpay
      *
     C                   ENDDO
      *
      ** Retrieve Time for display.
      *
     C                   TIME                    DDTIME
      *
      ** Write and read the subfile control.
      *
     C                   EXFMT     FTIPAYC0
      *
      ** If F3, bypass further processing.
      *
     C                   IF        *INKC = *On
     C                   EVAL      PINKC = '1'
     C                   MOVE      *On           *INLR
     C                   RETURN
     C                   ENDIF
      *
      ** If F12, bypass further processing.
      *
     C                   IF        *INKL = *On
     C                   EVAL      PINKL = '1'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBLDSFL2 - Build Subfile by Front Office Id                 *
      *                                                               *
      *****************************************************************
      *
     C     SRBldSfl2     BEGSR
      *
      ** Set flag for Front Office Id key used.
      *
     C                   MOVE      'F'           WPrvOrd
      *
      ** Check for user authority to browse if not multi-branch environment.
      *
     C                   IF        BJSBRC <> *Blanks
     C                   EXSR      SRChkAut
     C                   ENDIF
      *
      ** Initialise subfile relative record number.
      *
     C                   Z-ADD     0             W_RRN
      *
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     FTIPAYC1
     C                   MOVE      '0'           *IN97
      *
      ** Select screen footer for the screen.
      *
     C                   WRITE     FTIPAYF1
      *
      ** Set record pointer to first record.
      *
     C*****KPREF*********SETLL     INPAY                                                      228101
     C     KPREF         SETLL     INPAYL4                                                    228101
      *
     C                   READ      INPAYDDF                               96
      *
      ** If end of file, blank out Front Office field to
      ** position pointer to first record on file
      ** (keyed by Front Office Transaction Id).
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     *BLANKS       FRNT
     C                   ENDIF
      *
      ** Set file pointer.
      *
     C     FRNT          IFEQ      *BLANKS                                                    228101
     C                   EVAL      FRNT = '999999999999999'                                   228101
     C                   ENDIF                                                                228101
     C*****FRNT**********SETLL     INPAYL0                                                    228101
     C     FRNT          SETGT     INPAYL5                                                    228101
      *
      ** Read an Incoming Payment from file.
      *
     C                   EXSR      SRRDINPAY
      *
      ** If no record read, set up an error message.  Display
      ** 'No Incoming Payments present.'.
      *
     C                   IF        W_EOF = 'Y'
     C                   MOVEL     'FTA0112'     PERRMS
     C                   MOVEL     *Blanks       DDPREF
     C                   RETURN
     C                   ENDIF
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      *On           *IN98
      *
      ** While ROLLUP, build a subfile page.
      *
     C                   DOW       *IN98 = *On
      *
      ** Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             W_CNT
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C                   DOW       W_EOF <> 'Y' and
     C                             W_CNT < 14
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             W_RRN
     C                   ADD       1             W_CNT
      *
      ** Format fields for output.
      *
     C                   EXSR      SRFmtDet
      *
      ** Write the Incoming Payments details to subfile.
      *
     C                   MOVE      *Blank        DDOPTN
     C                   Z-ADD     W_RRN         DDSFRN
     C                   WRITE     FTIPAYS1
      *
      ** Read next Incoming Payment.
      *
     C                   EXSR      SRRDInpay
      *
     C                   ENDDO
      *
      ** Retrieve Time for display.
      *
     C                   TIME                    DDTIME
      *
      ** Write and read the subfile control.
      *
     C                   EXFMT     FTIPAYC1
      *
      ** If F3, bypass further processing.
      *
     C                   IF        *INKC = *On
     C                   EVAL      PINKC = '1'
     C                   MOVE      *On           *INLR
     C                   RETURN
     C                   ENDIF
      *
      ** If F12, bypass further processing.
      *
     C                   IF        *INKL = *On
     C                   EVAL      PINKL = '1'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDSFL - Read Subfile Record                                *
      *                                                               *
      *****************************************************************
      *
     C     SRRDSfl       BEGSR
      *
      ** Read the subfile for selected records.
      ** Only process those for which the option field is not blank.
      *
     C                   DOU       *IN99 = *On or
     C                             DDOPTN <> *Blank
      *
     C                   IF        WPrvOrd <> 'F'
     C                   READC     FTIPAYS0                               99
     C                   Else
     C                   READC     FTIPAYS1                               99
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Return the selected option and Payment Reference.
      *
     C                   IF        *IN99 <> *On and
     C                             DDOPTN <> *Blank
      *
     C                   IF        DDOPTN = 'A' or
     C                             DDOPTN = 'D' or
     C                             DDOPTN = 'E' or
     C                             DDOPTN = 'I' and
     C                             PParmlevel = '2'
     C                   MOVE      DDOPTN        POPSEL
     C                   ELSE
     C                   MOVE      'E'           POPSEL
     C                   ENDIF
      *
     C                   MOVE      DDPREF        PPREFSEL
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkAut - Check for user authority if not multi-branching   *
      *                                                               *
      *****************************************************************
      *
     C     SRChkAut      BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PActn             1
     C                   PARM      *ZERO         PError            1 0
      *
      ** Return error message.
      *
     C     PError        IFEQ      1
     C                   MOVEL     'FTA0114'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDINPAY - Read a Valid Incoming Payment from file          *
      *                                                               *
      *****************************************************************
      *
     C     SRRDInpay     BEGSR
      *
      ** Reset End of File indicator.
      *
     C                   MOVE      *Blank        W_EOF             1
      *
      ** Read the file initially - if W_EOF is set on, then the end of
      ** the file has been reached.  Read until a valid record is
      ** found or until no more records exist.
      *
     C                   DOU       W_EOF = 'Y' or
     C                             PError = *Zero
      *
      ** Read the file by Back Office or Front Office key.
      *
     C                   IF        WPrvOrd = 'B'
     C*******************READ      INPAY                                  96                  228101
     C                   READ      INPAYL4                                96                  228101
     C                   ELSE
     C*******************READ      INPAYL0                                96                  228101
     C                   READ      INPAYL5                                96                  228101
     C                   ENDIF
      *
      ** End of file.
      *
     C                   IF        *IN96 = *On
     C                   MOVEL     'Y'           W_EOF
     C                   ENDIF
      *
      ** If Incoming Payment read, check whether user can see it.
      *
     C                   IF        W_EOF <> 'Y'
      *
     C                   IF        BJSBRC = *Blanks
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           PACTN
     C                   PARM      BRCA          PBrca             3
     C                   PARM      *ZERO         PError
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFMTDET - Format Incoming Payments Details for Output       *
      *             to Subfile                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRFmtDet      BEGSR
      *
      ** Payment Reference.
      *
     C                   MOVEL     PREF          DDPREF
      *
      ** Front Office Transaction Id.
      *
     C                   MOVEL     FRNT          DDFRNT
      *
      ** Payment Status.
      *
     C                   SELECT
      *
      ** Authorised.
      *
     C     RECI          WHENEQ    'D'
     C     AUIN          ANDEQ     'Y'
     C                   MOVEL     'FTM2309'     PMSGID
     C                   EXSR      SRRtvMsg
     C                   MOVEL     PMSTX1        DDSTTS
      *
      ** Matured.
      *
     C     RECI          WHENEQ    'M'
     C                   MOVEL     'FTM2308'     PMSGID
     C                   EXSR      SRRtvMsg
     C                   MOVEL     PMSTX1        DDSTTS
      *
      ** Deleted.
      *
     C     RECI          WHENEQ    'C'
     C                   MOVEL     'FTM2311'     PMSGID
     C                   EXSR      SRRtvMsg
     C                   MOVEL     PMSTX1        DDSTTS
      *
      ** Live.
      *
     C     RECI          WHENEQ    'D'
     C                   MOVEL     'FTM2310'     PMSGID
     C                   EXSR      SRRtvMsg
     C                   MOVEL     PMSTX1        DDSTTS
      *
     C                   ENDSL
      *
      ** Sender.
      *
     C                   MOVEL     SND1          DDSEND
      *
      ** Beneficiary.
      *
     C                   MOVEL     BNC1          DDBENF
      *
      ** Settle Currency.
      *
     C                   MOVEL     SMCY          DDSMCY
      *
      ** Payment Currency.
      *
     C                   MOVEL     PCCY          DDPCCY
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvMsg - Retrieve message using MEC1150                    *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvMsg      BEGSR
      *
     C                   CALL      'MEC1150'
     C                   PARM                    PMSGID            7
     C                   PARM      'FTUSRMSG'    PMsgFile         10
     C                   PARM      *BLANKS       PMSDTA          132
     C                   PARM      *BLANKS       PMSTX1          132
     C                   PARM      *BLANKS       PMSTX2          512
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Payment Reference (pointer)
     C                   PARM                    DDPREF           15
      *
      ** Build Subfile
     C                   PARM                    PBDSFL            1
      *
      ** Read Subfile Record
     C                   PARM                    PRDSFL            1
      *
      ** Entry Point
     C                   PARM                    PParmLevel        1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT            7
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** OUTPUT
      ** ======
      *
      ** Error Message
     C                   PARM                    PERRMS            7
      *
      ** Option Selected
     C                   PARM                    POPSEL            1
      *
      ** Payment Reference Selected
     C                   PARM                    PPREFSEL         15
      *
      ** Function Key Enabled - F3
     C                   PARM                    PINKC             1
      *
      ** Function Key Enabled - F12
     C                   PARM                    PINKL             1
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
