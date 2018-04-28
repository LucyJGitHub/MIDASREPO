     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Invalid incoming payments browse')            *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAYRPB - Invalid Incoming Payments Browse                 *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            - displays a list of invalid Incoming Payments     *
      *              for selection.                                   *
      *            - picks off the selection made.                    *
      *                                                               *
      *  Component of: FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 258227             Date 24Dec08               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249652             Date 09Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 CER001             Date 25Apr05               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  258227 - Text of comment is unreadable (Recompile)           *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249652 - CFT032, a few problems (Recompile)                  *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
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
     FFTIPAYRDF CF   E             WORKSTN
     F                                     SFILE(FTIIPAYS0:W_RRN)
      *
      ** Invalid Incoming Payments by Timestamp and Front Office Id
      ** - for record retrieval
     FFTIIPAYL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FTIIPAYD0:FTIIPAYX0)
      *
      ** Invalid Incoming Payments by Front Office Id and Timestamp
      ** - for record update
     FFTIIPAYL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
     F/COPY WNCPYSRC,FTIPAYPF01
     FFTIIPLX1L0UF   E           K DISK    USROPN                                             CER001
      *                                                                                       CER001
      ** Midas FT IPAY - Invalid File                                                         CER001
      *                                                                                       CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
     F/COPY WNCPYSRC,FTH00133
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
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022
      *
      ** DS for invalid Incoming Payment details
     D InvTr         E DS                  EXTNAME(FTIIPAYPD)
     D InvExt        E DS                  EXTNAME(FTIIPLX1L0)                                CER001
     D InvRxt        E DS                  EXTNAME(FTIPRXPD)                                  CER001
                                                                                              CSC011
      ** DS for Switchable Features details                                                   CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
                                                                                              CSC011
      ** DS for Access Objects - short data structure                                         CSC011
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC011
                                                                                              CSC011
      ** 24X7 Status DataArea Layout                                                          CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Status DataArea Layout                                                            CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      **                                                                                      CSC022
     D/COPY WNCPYSRC,FTH00134
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Timestamp selected
     D PTMESTPSEL      S             26Z
     D/COPY WNCPYSRC,FTIPAYPD01
                                                                                              CSC011
      ** 24X7 Midas Availability switchable field                                             CSC011
     D CSC011          S              1A                                                      CSC011
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      **                                                                                      CSC022
                                                                                              CSC011
      ** Message Type key field                                                               CSC011
     D KMTYP           S              8A                                                      CSC011
     D/COPY WNCPYSRC,FTH00263
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
     C                   EXSR      SRBldSfl
     C                   ENDIF
      *
      ** Read subfile record.
      *
     C                   If        PRDSFL = 'Y'
     C                   EXSR      SRRdsSfl
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
      *                                                                                       CSC011
      * If 24x7 is present then journal APILOGL0                                              CSC011
      *                                                                                       CSC011
     C                   IF        (CSC011 = 'Y')                                             CSC011
     C                   OPEN      APILOGL0                             22                    CSC011
     C                   ENDIF                                                                CSC011
      *
      ** Clear output.
      *
     C                   MOVE      '0'           PINKC
     C                   MOVE      *Blanks       PERRMS
     C                   MOVE      *Blanks       POPSEL
     C                   MOVE      *Blanks       PACSEL
     C                   MOVE      *Blanks       PPREFSEL
     C                   MOVE      *Blanks       PFOTRANSEL
      *
     C                   CLEAR                   PTMESTPSEL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBLDSFL - Build the subfile for the browse screen           *
      *                                                               *
      *****************************************************************
      *
     C     SRBldSfl      BEGSR
      *
      ** Check for user authority to browse if not multi-branching.
      *
     C                   If        BJSBRC <> *Blanks
     C                   EXSR      SRChkAut
     C                   EndIf
      *
      ** Initialise subfile relative record number.
      *
     C                   Z-ADD     0             W_RRN             5 0
      *
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     FTIIPAYC0
     C                   MOVE      '0'           *IN97
      *
      ** Determine message to display on screen footer.
      *
     C                   SELECT
      *
      ** Previous transaction was not successful due to
      ** Incoming Payment being updated by another
      ** workstation.
      *
     C                   WHEN      PERRUP = 'Y'
     C                   MOVE      *ON           *IN61
     C                   MOVE      *OFF          *IN62
      *
      ** Previous transaction was a succesful Insert.
      *
     C                   WHEN      PERRUP = 'I'
     C                   MOVE      *OFF          *IN61
     C                   MOVE      *ON           *IN62
     C                   MOVE      PPREFI        DDPREFI
      *
     C                   OTHER
     C                   MOVE      *OFF          *IN61
     C                   MOVE      *OFF          *IN62
      *
     C                   ENDSL
      *
      ** Write the select screen footer to the screen.
      *
     C                   WRITE     FTIIPAYF1
      *
      ** Set file pointer to start of file.
      *
     C     *LOVAL        SETLL     FTIIPAYX0
      *
      ** Read an invalid Incoming Payment from file.
      *
     C                   EXSR      SRRDIINPAY
      *
      ** If no records exist - set up an error message.
      ** Display message 'NO INVALID INCOMING PAYMENTS
      ** PRESENT'.
      *
     C                   If        W_EOF = 'Y'
     C                   MOVEL     'FTA0118'     PERRMS
     C                   EVAL      *IN10 = *Off
     C                   TIME                    DDTIME
     C                   EXFMT     FTIIPAYEND
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   EndIf
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      *On           *IN98
      *
      ** Read records from the file into the subfile until a
      ** page has been filled or there are no more records.
      ** Repeat the process until either the end of file,
      ** ROLLUP has not been entered or F3 is input.
      *
     C                   DOW       W_EOF <> 'Y' and
     C                             *IN98 = *On
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
      ** Write the invalid Incoming Payment details to the subfile.
      *
     C                   MOVE      *Blank        DDOPTN
     C                   Z-ADD     W_RRN         DDSFRN
     C                   MOVEL     DDSND1        DDSEND
     C                   MOVEL     DDBNC1        DDBENF
     C                   MOVE      DDTMST        D@TMST
     C                   WRITE     FTIIPAYS0
      *
      ** Read next invalid Incoming Payment from file.
      *
     C                   EXSR      SRRDIInpay
      *
     C                   ENDDO
      *
      ** Retrieve Time for display.
      *
     C                   TIME                    DDTIME
      *
      ** Write the subfile control record to the screen to
      ** display the subfile.
      *
     C                   WRITE     FTIIPAYC0
      *
      ** Read the subfile control record to determine whether
      ** records have been selected or whether ROLLUP is
      ** required.
      *
     C                   READ      FTIIPAYC0                              99
      *
      ** If F3, bypass further processing.
      *
     C                   If        *INKC = *On
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   EndIf
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDSSFL - Read details of the selected subfile record       *
      *                                                               *
      *****************************************************************
      *
     C     SRRDsSfl      BEGSR
      *
      ** Read the subfile for selected records.  Only process
      ** those for which the option field is not blank.
      *
     C                   DOU       *IN99 = *On or
     C                             DDOPTN <> *Blank
      *
     C                   READC     FTIIPAYS0                              99
      *
      ** Validate repair option code.
      *
     C                   IF        *IN99 = *Off
     C                   EXSR      SRValidOpt
     C                   ENDIF
      *
      ** If 'E' is input, enquire upon invalid transaction.
      *
     C                   IF        *IN99 = *Off and
     C                             DDOPTN = 'E'
     C                   MOVE      D@TMST        PTMESTPSEL
     C                   EXSR      SREnqInv
     C                   MOVEL     *Blank        DDOPTN
     C                   ENDIF
      *
      ** If 'Q' is input, prompt for deletion of invalid transaction.
      *
     C                   IF        *IN99 = *Off and
     C                             DDOPTN = 'Q'
     C                   EXSR      SRProm_Delt
     C                   MOVEL     *Blank        DDOPTN
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Return the selected option, Action Code, Payment
      ** Reference, Front Office Transaction Id and
      ** Timestamp.
      *
     C                   IF        *IN99 <> *On and
     C                             DDOPTN <> *Blank
     C                   MOVE      DDOPTN        POPSEL
     C                   MOVE      DDACTN        PACSEL
     C                   MOVE      DDPREF        PPREFSEL
     C                   MOVE      DDFRNT        PFOTRANSEL
     C                   MOVE      D@TMST        PTMESTPSEL
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDIINPAY - Read an invalid Incoming Payment                *
      *                                                               *
      *****************************************************************
      *
     C     SRRDIInpay    BEGSR
      *
      ** Reset End of File indicator.
      *
     C                   MOVE      *Blank        W_EOF             1
      *
      ** Read the invalid records file.
      *
     C                   READ      FTIIPAYX0                              96
      *
      ** End of file.
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           W_EOF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidOpt - Validate Repair option code                     *
      *                                                               *
      *****************************************************************
      *
     C     SRValidOpt    BEGSR
      *
     C                   CALLB     'ZAROPTVAL'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Option Code
     C                   PARM                    DDOPTN
      *
      ** Front Office Id
     C                   PARM                    DDFRNT
      *
      ** Booking Branch
     C                   PARM                    DDBRCA
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
      *
      ** If F3, bypass further processing.
      *
     C     PINKC         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
      *
      ** If F12, continue with next option.
      *
     C     PINKL         IFEQ      '1'
     C                   MOVEL     *BLANK        DDOPTN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnqInv - Enquire on invalid transaction                    *
      *                                                               *
      *****************************************************************
      *
     C     SREnqInv      BEGSR
      *
      ** Pass the invalid transaction details to the enquiry.
      *
     C     ZATRNKX0      CHAIN     FTIIPAYX0                          99
      *                                                                                       CER001
     C                   IF        ULX611 = 'Y' AND ULX043 = 'Y'                              CER001
     C     ZATRNKDX      CHAIN     FTIIPLX1L0                         99                      CER001
     C                   EVAL      InvFile2 = 'FTIPRXPD'                                      CER001
     C                   MOVE      InvExt        InvRxt                                       CER001
     C                   EVAL      InvFdta2 = InvRxt                                          CER001
     C                   ENDIF                                                                CER001
      *
     C/COPY WNCPYSRC,FTH00135
     C                   CALLB     'ZAINVTRENQ'
      *                             ==========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Front Office Id
     C                   PARM                    DDFRNT
      *
      ** Associated Front Office Id
     C                   PARM      *Blanks       PAFRT            20
      *
      ** Timestamp
     C                   PARM                    D@TMST
      *
      ** Invalid file names
     C                   PARM      'FTIIPAYPD'   InvFile1         10
     C                   PARM                    InvFile2         10
     C                   PARM                    InvFile3         10
      *
      ** Invalid file data
     C***********        PARM      InvTr         InvFDta1       2000            CFT014
     C***********        PARM                    InvFDta2       2000            CFT014
     C***********        PARM                    InvFDta3       2000            CFT014
     C                   PARM      InvTr         InvFDta1       4000            CFT014
     C                   PARM                    InvFDta2       4000            CFT014
     C                   PARM                    InvFDta3       4000            CFT014
      *
      ** OUTPUT
      ** ======
      *
      * Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
      *
      ** If F3, bypass further processing.
      *
     C     PINKC         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROM_DELT - Read details of the selected subfile record    *
      *                for deletion                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRProm_Delt   BEGSR
      *
     C                   CALLB     'ZAINVTRDEL'
      *                             ==========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *Blank        RetCodeOut
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Front Office Transaction Id
     C                   PARM                    DDFRNT
      *
      ** Associated Front Office Transaction Id
     C                   PARM      *Blanks       PAFRT
      *
      ** Timestamp
     C                   PARM                    D@TMST
      *
      ** Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1           30
     C                   PARM      DDPREF        DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      DDSND1        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      DDBNC1        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      DDSMCY        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      DDSMAM        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      DDSLDT        DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      DDPCCY        DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM      DDPYAM        DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM      DDPYDT        DDFLD9           35
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ             1
     C                   PARM      '0'           PINKL             1
      *
      ** If F3, bypass further processing.
      *
     C     PINKC         IFEQ      '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** If F10, delete invalid Incoming Payment.
      *
     C     PINKJ         IFEQ      '1'
     C                   MOVE      D@TMST        PTMESTPSEL
     C     ZATRNKD0      CHAIN     FTIIPAYD0                          99
     C     *IN99         IFEQ      '0'
     C                   DELETE    FTIIPAYD0
     C                   ENDIF
      *                                                                                       CSC011
      ** Delete invalid record from the log file.                                             CSC011
      *                                                                                       CSC011
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
     C                   EVAL      KMTYP = 'FTIPAY'                                           CSC011
     C     KLOGL0        CHAIN     APILOGL0                           99                      CSC011
      *                                                                                       CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGD0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
      *                                                                                       CER001
     C                   IF        ULX611 = 'Y' and ULX043 = 'Y'                              CER001
      *                                                                                       CER001
      ** Delete Records from Invalid File                                                     CER001
      *                                                                                       CER001
     C     ZATRNKDX      CHAIN     FTIIPLX1L0                         99                      CER001
     C  N99              DELETE    FTIIPLXDL                                                  CER001
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,FTH00136
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKAUT - Check for user authority if not multi-branching   *
      *                                                               *
      *****************************************************************
      *
     C     SRChkAut      BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PACTN             1
     C                   PARM      *Zero         P_ERR             1 0
      *
      ** Return error message for user not authorised and then
      ** terminate.
      *
     C     P_ERR         IFEQ      1
     C                   MOVEL     'FTA0114'     PERRMS
     C                   EVAL      *IN10 = *On
     C                   TIME                    DDTIME
     C                   EXFMT     FTIIPAYEND
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRTVTXT - Retrieve text narrative for transaction deletion  *
      *                                                               *
      *****************************************************************
      *
     C     SRRTVTXT      BEGSR
      *
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMSGDNB           7
     C                   PARM      'ZZGBMSGF  '  PMSGNM           10
     C                   PARM      *BLANK        PMSGTXT          80
      *
     C                   ENDSR
      *
      *****************************************************************
     C/COPY WNCPYSRC,FTH00264
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
      ** Build Subfile
     C                   PARM                    PBDSFL            1
      *
      ** Read Subfile Record
     C                   PARM                    PRDSFL            1
      *
      ** Update Status of Previous Transaction
     C                   PARM                    PERRUP            1
      *
      ** Payment Reference Assigned to Previous Insert
     C                   PARM                    PPREFI           15
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
      ** Action Selected
     C                   PARM                    PACSEL            1
      *
      ** Payment Reference Selected
     C                   PARM                    PPREFSEL         15
      *
      ** Front Office Transaction Id Selected
     C                   PARM                    PFOTRANSEL       20
      *
      ** Timestamp of Transaction Selected
     C                   PARM                    PTMESTPSEL
      *
      ** Function Key Enabled - F3
     C                   PARM                    PINKC             1
     C                   PARM                    CSC011                                       CSC011
     C                   PARM                    CSC022                                       CSC022
      *
      ** Key Lists.
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFRNT
     C                   KFLD                    PTMESTPSEL
      *
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    DDFRNT
      *                                                                                       CSC011
     C     KLOGL0        KLIST                                                                CSC011
     C                   KFLD                    KMTYP                                        CSC011
     C                   KFLD                    DDFRNT                                       CSC011
     C                   KFLD                    PTMESTPSEL                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
      ** Get support system prefix and current system prefix                                  CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ENDIF                                                                CSC011
      **                                                                                      CSC022
      ** Initialize Commit/Skip Flag                                                          CSC022
     C                   Eval      WSkpComtRolbk = 'N'                                        CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'Y'                                               CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MoveA     WDSJobs       WJobs                                        CSC022
      ** Verify if job running exists in array                                                CSC022
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                         CSC022
     C                   If        WArrPtr > 0                                                CSC022
     C                   Eval      WSkpComtRolbk = 'Y'                                        CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
      *
      ** Format text for invalid transaction deletion function.
      *
      ** Payment Reference.
      *
     C                   MOVEL     'APA1062'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR1
      *
      ** Sender.
      *
     C                   MOVEL     'APA1063'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR2
      *
      ** Beneficiary.
      *
     C                   MOVEL     'APA1064'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR3
      *
      ** Settlement Currency.
      *
     C                   MOVEL     'APA1065'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR4
      *
      ** Settlement Amount.
      *
     C                   MOVEL     'APA1066'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR5
      *
      ** Settlement Value Date.
      *
     C                   MOVEL     'APA1067'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR6
      *
      ** Payment Currency.
      *
     C                   MOVEL     'APA1068'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR7
      *
      ** Payment Amount.
      *
     C                   MOVEL     'APA1069'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR8
      *
      ** Payment Value Date.
      *
     C                   MOVEL     'APA1070'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR9
     C/COPY WNCPYSRC,FTIPAYPC01
      *                                                                                       CER001
      ** ULX611 - API Luxembourg - Function FTIPAY                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX611            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX611'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX611                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX611'                                          CER001
     C                   EVAL      DBASE  = 001                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX043 - New IBLC 2002 as feature                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
      *                                                                                       CER001
      ** Open Invalid File                                                                    CER001
      *                                                                                       CER001
     C                   OPEN      FTIIPLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX043'                                          CER001
     C                   EVAL      DBASE  = 002                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ZATRNKDX      KLIST                                                                CER001
     C                   KFLD                    PTMESTPSEL                                   CER001
     C                   KFLD                    DDFRNT                                       CER001
      *                                                                                       CER001
     C/COPY WNCPYSRC,FTH00137
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
(c) Misys International Banking Systems Ltd. 2001
