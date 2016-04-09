     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Invalid Additional Custmr Details Browse')    *
      *****************************************************************
      *                                                               *
      *  Midas - Additional Customer Details Module                   *
      *                                                               *
      *  SDCUSDRPB - Invalid Additional Customers Browse              *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of invalid Additional Customers*
      *             for selection the other picks off the selection   *
      *             mode.                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. AR689705           Date 03Jan11               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD029             Date 22Aug05               *
      *                 232543             Date 31Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue (Recompile)                            *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CSD029 - Customer Details Additional Fields (Recompile)      *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation on Savings Income                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Invalid Additional Customer Detail - Browse
     FSDACUDRDF CF   E             WORKSTN
     F                                     SFILE(SDACUDS1:WKRRN)
 
      ** Midas SD Invalid ACUD by Timestamp & FOID
     FSDIACUDL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDIACUDD0:SDIACUDX0)
 
      ** Midas SD Invalid ACUD by FOID & Timestamp
     FSDIACUDL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Customer Details File - by Customer number
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** API Invalid Log File from Support Database
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
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
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
      /COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
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
 
      ** External DS Invalid Additional Customer Details
     D InvCd         E DS                  EXTNAME(SDIACUDPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Progarms, short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Array containing messages
     D ErrorText       S             52    DIM(1) CTDATA PERRCD(1)
 
      ** SD data area
     D SDSTAT        E DS                  Extname(SDSTAT) DTAARA(SDSTAT)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
 
      ** Parameter for *Entry
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PErrUp          S              1A
     D PErrMs          S              7A
     D POpSel          S              1A
     D PAcSel          S              1A
     D PFOTranSel      S             20A
     D PCUST           S              6A
     D PINKC           S              1A
     D PINKL           S              1A
     D PTmeStpSel      S             26Z
 
      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A
 
      ** Parameter for ZAINVTRENQ
     D PInvFile1       S             10A
     D PInvFile2       S             10A
     D PInvFile3       S             10A
     D PInvFDta1       S           4000A
     D PInvFDta2       S           4000A
     D PInvFDta3       S           4000A
 
      ** Parameter for ZAINVTRDEL
     D DDFOASOCID      S             20A
     D DDNAR1          S             30A
     D DDFLD1          S             35A
     D DDNAR2          S             30A
     D DDFLD2          S             35A
     D DDNAR3          S             30A
     D DDFLD3          S             35A
     D DDNAR4          S             30A
     D DDFLD4          S             35A
     D DDNAR5          S             30A
     D DDFLD5          S             35A
     D DDNAR6          S             30A
     D DDFLD6          S             35A
     D DDNAR7          S             30A
     D DDFLD7          S             35A
     D DDNAR8          S             30A
     D DDFLD8          S             35A
     D DDNAR9          S             30A
     D DDFLD9          S             35A
 
     D PINKJ           S              1A
 
      ** Parameter for ZVACTU
     D ZACTN           S              1A
     D P@Err           S              1P 0
 
      ** Parameter for SDRTVTXT
     D MSGDNB          S              7A
     D MSGNM           S             10A
     D MSGTXT          S             80A
 
      ** Parameter for RPC1600
     D EntryData       S           3000A
     D FileName        S             10A
 
      ** Other Variables
     D WKEOF           S              1A
     D WKRRN           S              5P 0
     D WKCNT           S              3P 0
 
     D WBookBrc        S              3A
 
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
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   EXSR      SRInit
 
      ** Build Sub-File
 
     C                   IF        PBdSfl = 'Y'
     C                   EXSR      SRBldSfl
     C                   ENDIF
 
      ** Read Subfile Record
 
     C                   IF        PRdSfl = 'Y'
     C                   EXSR      SRRdSflr
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      ********************************************************************
      * SRBldSfl - Build Subfile
      ********************************************************************
     C     SRBldSfl      BEGSR
 
      ** Check for User Authority to Browse if not Multi-Branching
 
     C                   IF        BJSBRC <> *Blanks
     C                   EXSR      SRChAutn
     C                   ENDIF
 
      **  Initialise subfile relative record number.
 
     C                   EVAL      WKRRN = 0
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
 
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDACUDS0
     C                   EVAL      *IN97 = *OFF
 
      **  If previous transaction was not successful due to deal being
      **  updated by another workstation then display message on screen
 
     C                   IF        PErrUp = 'Y'
     C                   EVAL      ERRORMSG = ErrorText(1)
     C                   ELSE
     C                   EVAL      ERRORMSG = *Blanks
     C                   ENDIF
 
      **  Write the select screen footer to the screen.
 
     C                   WRITE     SDACUDF1
 
      **  Set file pointer to start of file
 
     C     *LOVAL        SETLL     SDIACUDL0
 
      ** Read an Invalid Additional Customer
 
     C                   EXSR      SRRdIAcus
 
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
 
     C                   IF        WKEOF = 'Y'
     C                   EVAL      PErrMs = 'FXM1007'
     C                   EXFMT     SDACUDEND
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      **  Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN98 = *ON
 
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
 
     C                   DOW       WKEOF <> 'Y' and
     C                             *IN98 = *ON
 
      **  Initialise count of records written to subfile page.
 
     C                   Z-ADD     0             WKCNT
 
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
 
     C                   DOW       WKEOF <> 'Y' and
     C                             WKCNT < 14
 
      **  Increment the subfile record no. and records written fields.
 
     C                   ADD       1             WKRRN
     C                   ADD       1             WKCNT
 
      **  Write the invalid customer to the subfile.
 
     C                   EVAL      DDOPT = *Blanks
     C                   EVAL      DDSFRN = WKRRN
     C                   MOVEL     DDTMST        D@TMESTMP
     C                   WRITE     SDACUDS1
 
      ** Read an Invalid Additional Customer
 
     C                   EXSR      SRRdIAcus
     C                   ENDDO
 
      **  Write the subfile control record to the screen to display
      **  the subfile.
 
     C                   WRITE     SDACUDS0
 
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
 
     C                   READ      SDACUDS0                               99
 
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
      ********************************************************************
      /EJECT
      ********************************************************************
      * SRRdSflr - Read Subfile Record
      ********************************************************************
     C     SRRdSflr      BEGSR
 
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
 
     C                   DOU       *IN99 = *ON or
     C                             DDOPT <> *Blanks
     C                   READC     SDACUDS1                               99
 
      ** Validate repair option code
 
     C                   IF        *IN99 = *OFF
     C                   EXSR      SRValid_ROpt
     C                   ENDIF
 
      ** If 'E' is input, enquire upon invalid transaction
 
     C                   IF        *IN99 = *OFF and
     C                             DDOPT = 'E'
     C                   MOVEL     D@TMESTMP     PTmeStpSel
     C                   EXSR      SREnq_Inv
     C                   EVAL      DDOPT = *Blanks
     C                   ENDIF
 
      ** If 'Q' is input, prompt for deletion of invalid transaction
 
     C                   IF        *IN99 = *OFF and
     C                             DDOPT = 'Q'
     C                   EXSR      SRProm_Delt
     C                   EVAL      DDOPT = *Blanks
     C                   ENDIF
 
     C                   ENDDO
 
      **  Return the selected option, action, front office transaction ID
      **  and front office associated transaction ID
 
     C                   IF        *IN99 <> *ON and
     C                             DDOPT <> *Blanks
 
     C                   EVAL      POpSel     = DDOPT
     C                   EVAL      PAcSel     = DDACTN
     C                   EVAL      PCUST      = DDCUST
     C                   EVAL      PFOTranSel = DDFRNT
     C                   MOVEL     D@TMESTMP     PTmeStpSel
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValid_ROpt - Validate Repair Option Code
      *****************************************************************
     C     SRValid_ROpt  BEGSR
 
     C                   CALLB     'ZAROPTVAL'
 
      ** INPUTS
      ** Return Code
     C                   PARM      *Blanks       RetCodeOut
 
      ** Option code
      ** Front Office ID
      ** Booking Branch
     C                   PARM                    DDOPT
     C                   PARM                    DDFRNT
     C                   PARM      *Blanks       WBookBrc
 
      ** ICD Single branch code
     C                   PARM                    BJSBRC
 
      ** OUTPUTS
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      **  If F3, bypass further processing.
 
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *ON
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
      * SREnq_Inv - Enquire on Invalid Transaction
      *****************************************************************
     C     SREnq_Inv     BEGSR
 
      ** Pass the invalid transaction details to the enquiry
 
     C     ZATRNKX0      CHAIN     SDIACUDX0                          99
 
     C                   CALLB     'ZAINVTRENQ'
 
      ** INPUTS
      ** Return Code
     C                   PARM      *Blanks       RetCodeOut
 
      ** Action code
      ** Front Office ID
      ** Associated Front Office ID
      ** Timestamp
     C                   PARM                    DDACTN
     C                   PARM                    DDFRNT
     C                   PARM      *Blanks       DDFOASOCID
     C                   PARM                    D@TMESTMP
 
      ** Invalid file names
     C                   PARM      'SDIACUDPD'   PInvFile1
     C                   PARM      *Blanks       PInvFile2
     C                   PARM      *Blanks       PInvFile3
 
      ** Invalid file data
     C                   PARM      InvCd         PInvFDta1
     C                   PARM      *Blanks       PInvFDta2
     C                   PARM      *Blanks       PInvFDta3
 
      ** OUTPUTS
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
      * SRProm_Delt - Prompt for Deletion
      *****************************************************************
     C     SRProm_Delt   BEGSR
 
     C                   CALLB     'ZAINVTRDEL'
 
      ** INPUTS
      ** Return Code
     C                   PARM      *Blanks       RetCodeOut
 
      ** Action code
     C                   PARM                    DDACTN
 
      ** Front Office Trans ID & Front Office Associated Trans ID
     C                   PARM                    DDFRNT
     C                   PARM      *Blanks       DDFOASOCID
 
      ** Timestamp
     C                   PARM                    D@TMESTMP
 
      ** Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1
     C                   PARM      DDCUST        DDFLD1
     C                   PARM                    DDNAR2
     C                   PARM      DDCSSN        DDFLD2
     C                   PARM                    DDNAR3
     C                   PARM      DDCRNM        DDFLD3
     C                   PARM                    DDNAR4
     C                   PARM      DDCNA1        DDFLD4
     C                   PARM                    DDNAR5
     C                   PARM      DDCNA2        DDFLD5
     C                   PARM                    DDNAR6
     C                   PARM      DDCNA3        DDFLD6
     C                   PARM                    DDNAR7
     C                   PARM      DDCNA4        DDFLD7
     C                   PARM                    DDNAR8
     C                   PARM      DDZIPC        DDFLD8
     C                   PARM                    DDNAR9
     C                   PARM      DDCITY        DDFLD9
 
      ** OUTPUTS
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
 
      **  If F3, bypass further processing.
 
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      **  If F10, delete invalid customer
 
     C                   IF        PINKJ = '1'
     C                   MOVEL     D@TMESTMP     PTmeStpSel
     C     ZATRNKD0      CHAIN     SDIACUDD0                          99
     C                   IF        *IN99 = *OFF
     C                   MOVE      'D'           DDACTN
     C                   MOVEL     *BLANKS       EntryData
     C                   MOVEL     *BLANKS       FileName
     C                   CALL      'RPC1600'
     C                   PARM      InvCd         EntryData
     C                   PARM      'SDIACUDPD'   FileName
     C                   DELETE    SDIACUDD0
     C                   ENDIF
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRdIAcus - Read an Invalid Additional Customer
      *****************************************************************
     C     SRRdIAcus     BEGSR
 
      ** Reset End of File indicator
 
     C                   EVAL      WKEOF = *Blanks
 
      ** Read the file.
 
     C                   READ      SDIACUDL0                              96
 
      ** Get Customer details
 
     C                   EXSR      SRGetCust
 
      ** End of File
 
     C                   IF        *IN96 = *ON
     C                   EVAL      WKEOF = 'Y'
     C                   ENDIF
 
     C     ERDDEL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRGetCust - Get Customer Details
      *****************************************************************
     C     SRGetCust     BEGSR
 
     C     DDCUST        CHAIN     SDCUSTL1
 
      ** Database Error
 
     C                   IF        Not %Found(SDCUSTL1)  AND
     C                             *IN96 = *OFF
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 902
     C                   EVAL      DBKEY = DDCUST
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFmtTran - Format Transaction for Output
      *****************************************************************
     C     SRFmtTran     BEGSR
 
      ** Transaction reference
 
     C                   EVAL      DDFRNT = BBFRNT
     C                   EVAL      DDCUST = BBCUST
     C                   EVAL      DDCSSN = BBCSSN
     C                   EVAL      DDCRNM = BBCRNM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRChAutn - Check for User Authority if not Multi-Branching
      *****************************************************************
     C     SRChAutn      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    P@Err
 
      ** Return Error Message
 
     C                   IF        P@Err = 1
     C                   EVAL      PErrMs = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvTxt - Retrieve Text
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
      * SRInit - Initialization
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   IF        (CSC011 = 'Y')
     C                   OPEN      APILOGL0                             22
     C                   ENDIF
 
      ** Clear Outputs
 
     C                   CLEAR                   PErrMs
     C                   CLEAR                   POpSel
     C                   CLEAR                   PAcSel
     C                   CLEAR                   PCUST
     C                   CLEAR                   PFOTranSel
     C                   CLEAR                   PTmeStpSel
     C                   EVAL      PINKC = '0'
     C                   EVAL      PINKL = '0'
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INitial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** INPUT Parameters
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Build Sub-File
     C                   PARM                    PBdSfl
 
      ** Read Subfile Record
     C                   PARM                    PRdSfl
 
      ** Error in update of previous deal
     C                   PARM                    PErrUp
     C                   PARM                    CSC011
 
      ** OUTPUT Parameters
      ** Error Message
     C                   PARM                    PErrMs
 
      ** Option Selected
     C                   PARM                    POpSel
 
      ** Action Selected
     C                   PARM                    PAcSel
 
      ** FO Transaction ID Selected
     C                   PARM                    PFOTranSel
 
      ** Customer Number
     C                   PARM                    PCUST
 
      ** Timestamp of Transaction Selected
     C                   PARM                    PTmeStpSel
 
      ** Command Keys
     C                   PARM                    PINKC
     C                   PARM                    PINKL
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDACUDRPB'
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDWID  = PsJobName
 
      ** Access Bank Detials
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** DATABASE ERROR
 
     C                   IF        PRtcd <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key Lists
 
     C     KAPILOGL0     KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFRNT
     C                   KFLD                    PTmeStpSel
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTmeStpSel
     C                   KFLD                    DDFRNT
 
      ** Format Test for Invalid Transaciton Deletion Function
 
     C                   EVAL      MSGDNB = 'ZZN6682'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR1 = MSGTXT
     C                   EVAL      MSGDNB = 'ZZN6683'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR2 = MSGTXT
     C                   EVAL      MSGDNB = 'ZZN6684'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR3 = MSGTXT
     C                   EVAL      MSGDNB = 'ZZN6685'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR4 = MSGTXT
     C                   EVAL      MSGDNB = 'ZZN6684'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR5 = MSGTXT
     C                   EVAL      MSGDNB = 'ZZN6681'
     C                   EXSR      SRRtvTxt
     C                   EVAL      DDNAR6 = MSGTXT
     C                   EVAL      DDNAR7 = *Blanks
     C                   EVAL      DDNAR8 = *Blanks
     C                   EVAL      DDNAR9 = *Blanks
 
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
** CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2004
**  Array of error messages - ErrorText
The last transaction was not applied to the database
