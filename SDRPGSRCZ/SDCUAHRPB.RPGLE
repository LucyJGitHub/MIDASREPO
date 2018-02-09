     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer/Authority Holders Det')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCUAHRPB - SD Customer/Authority Holder Repair Browse       *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of invalid Customers/Authority *
      *             Details for selection the other picks off the     *
      *             selection mode.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER034A *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER034A - German Features - New Fields and Enquiries         *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SD Customer/Authority Holder Repair Screen
      *
     FSDCUAHRDF CF   E             WORKSTN
     F                                     SFILE(SDCUAHS0:WRRN)
      *
      ** Invalid Customer/Authority Holder Details by Customer
      *
     FSDICUAHL1 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDICUAHD0:SDICUAHX0)
      *
      ** Invalid Customer/Authority Holder Details by Customer
      *
     FSDICUAHL0 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** API Invalid Log File from Support Database
      *
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     COMMIT
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
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      ** True       logical = *on (for indcator processing)
      ** False      logical = *off (for indcator processing)
      ** DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      ** error handler)
      ** and the following variables:
      ** RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
      *
      /COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
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
      ** First DS for Access Progarms, short Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for Access programs - long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Customer Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS Invalid Customer/Authority Details
      *
     D InvR          E DS                  EXTNAME(SDICUAHPD)
      *
      ** 24X7 status data area
      *
     D SC24X7        E DS                  EXTNAME(SC24X7)
     D                                     DTAARA(SC24X7)
      *
      ** SD data area
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
     D                                     DTAARA(SDSTAT)
      *
      ** Array containing messages
      *
     D ErrorText       S             52A   DIM(1) CTDATA PERRCD(1)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameter for *Entry
      *
     D Pbdsfl          S              1A
     D Prdsfl          S              1A
     D PErrUp          S              1A
     D CSC011          S              1A
     D PErrMs          S              7A
     D POpSel          S              1A
     D PAcSel          S              1A
     D PFOTranSel      S             20A
     D PCust           S             10A
     D PInkc           S              1A
     D PInkl           S              1A
     D PTmeStpSel      S             26Z
      *
      ** Parameter for Access Object
      *
     D PRtCd           S              7A
     D POptn           S              7A
      *
      ** Parameter for ZAINVTRENQ
      *
     D PInvFile1       S             10A
     D PInvFile2       S             10A
     D PInvFile3       S             10A
     D PInvFDta1       S           4000A
     D PInvFDta2       S           4000A
     D PInvFDta3       S           4000A
      *
     D WError          S              1A
     D WRun            S              1A
     D WMode           S              1A
     D PInkj           S              1A
     D PStKey          S              6A
     D PActnCd         S              1A
     D PError          S              1P 0
     D PBranch         S              3A
     D Idx             S              3P 0
     D WCnt            S              3P 0
     D WRRN            S              5P 0
     D WSet            S              1A
     D PBookBrc        S              3A
      *
      ** Parameter for ZAINVTRDEL
      *
     D DDFOASOCID      S             20A
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
      *
     D KMsgType        S              8A
     D KFrntOffID      S             20A
     D KTimeStamp      S                   LIKE(PTmeStpSel)
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
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialization
      *
     C                   EXSR      SRinit
      *
      ** Build Sub-File
      *
     C                   IF        Pbdsfl = 'Y'
     C                   EXSR      SRbldsfl
     C                   ENDIF
      *
      ** Read Subfile Record
      *
     C                   IF        Prdsfl = 'Y'
     C                   EXSR      SRRdSflr
     C                   ENDIF
      *
      ** Return to the calling program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRbldsfl - Build the Subfile                                 *
      *                                                               *
      *  Called By: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRChkAut                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRbldsfl      BEGSR
      *
      ** Check for User Authority to Browse if not Multi-Branching
      *
     C                   IF        BJSBRC <> *BLANKS
     C                   EXSR      SRChkAut
     C                   ENDIF
      *
      ** Initialise subfile relative record number
      *
     C                   Z-ADD     *ZEROS        WRRN
      *
      ** Clear subfile before refilling by writing subfile control
      ** record format with SFLCLR active
      *
     C                   EVAL      *IN22 = *ON
     C                   WRITE     SDCUAHC0
     C                   EVAL      *IN22 = *OFF
      *
      ** If previous transaction was not successful due to deal being
      ** updated by another workstation then display message on screen
      *
     C                   IF        PErrUp = 'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   EVAL      ERRORMSG = *BLANKS
     C                   ENDIF
      *
      ** Write the select screen footer to the screen
      *
     C                   WRITE     SDCUAHF0
      *
      ** Set file pointer to start of Invalid file
      *
     C     *LOVAL        SETLL     SDICUAHL0
     C                   READ      SDICUAHL0                              21
      *
      ** If no records exist - setup the message
      ** 'No invalid transactions present' and terminate
      *
     C                   IF        *IN21 = *ON
     C                   EVAL      PErrMs = 'FXM1007'
     C                   EXFMT     SDCUAHF1
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** Set on ROLLUP indicator to drive initial loop
      *
     C                   EVAL      *IN23 = *ON
      *
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input
      *
     C                   DOW       *IN21 <> *ON and
     C                             *IN23 = *ON
      *
      ** Initialise count of records written to subfile page
      *
     C                   Z-ADD     *ZEROS        WCnt
      *
      ** For each record read, write it to the subfile
      ** Do this until end of file or the subfile page is full.
      *
     C                   DOW       *IN21 <> *ON and
     C                             WCnt  < 14
      *
      ** Increment the subfile RRN and the subfile record count flag
      *
     C                   EVAL      WRRN = WRRN + 1
     C                   EVAL      WCnt = WCnt + 1
      *
      ** Write the invalid details to the subfile
      *
     C                   EVAL      DDOPTN = *BLANKS
     C                   EVAL      DDSFRRN = WRRN
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DDCUST        PCust
     C                   PARM      *BLANKS       PStKey
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   MOVE      BBCSSN        DDCUSN
     C                   ELSE
     C                   MOVE      *BLANKS       DDCUSN
     C                   ENDIF
      *
     C                   WRITE     SDCUAHS0
     C                   READ      SDICUAHL0                              21
      *
     C                   ENDDO
      *
      ** Write the subfile control record format to display the subfile
      ** screen
      *
     C                   WRITE     SDCUAHC0
      *
      ** Read the subfile control record format to determine whether
      ** the record have been selected or whether ROLLUP is pressed
      *
     C                   READ      SDCUAHC0                               24
      *
      ** If F3 pressed, bypass further processing
      *
     C                   IF        *INKC = '1'
     C                   EVAL      PInkc = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** If F12 pressed, bypass further processing
      *
     C                   IF        *INKL = '1'
     C                   EVAL      PInkl = '1'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRdSflr - Read Subfile Record                               *
      *                                                               *
      *  Called By: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRValOpt, SREnqInv, SRDltInv                          *
      *                                                               *
      *****************************************************************
      *
     C     SRRdSflr      BEGSR
      *
      ** Read the subfile for selected records.
      ** Only process those for which the option field is non-blank
      *
     C                   DOU       *IN24 = *ON OR
     C                             DDOPTN <> *BLANKS
      *
     C                   READC     SDCUAHS0                               24
      *
      ** Validate the Option Code
      *
     C                   IF        *IN24 = *OFF
     C                   EXSR      SRValOpt
     C                   ENDIF
      *
      ** If Option equals to 'E', perform Enquire processing on Invalid
      ** Remark
      *
     C                   IF        *IN24 = *OFF AND
     C                             DDOPTN = 'E'
     C                   EXSR      SREnqInv
     C                   EVAL      DDOPTN = *BLANKS
     C                   ENDIF
      *
      ** If Option equals to 'Q', perform Delete processing on Invalid
      ** Remark
      *
     C                   IF        *IN24 = *OFF AND
     C                             DDOPTN = 'Q'
     C                   EXSR      SRDltInv
     C                   EVAL      DDOPTN = *BLANKS
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Return the Option selected, Action Code, Front Office
      ** Transaction ID
      *
     C                   IF        *IN24 <> *ON AND
     C                             DDOPTN <> *BLANKS
      *
     C                   EVAL      POpSel = DDOPTN
     C                   EVAL      PAcSel = DDACTN
     C                   EVAL      PFOTranSel = DDFRNT
     C                   EVAL      PTmeStpSel = DDTMST
     C                   EVAL      PCust = DDCUST
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRValOpt - Validate Repair Option Code                       *
      *                                                               *
      *  Called By: SRRdSflr                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRValOpt      BEGSR
 
     C                   CALLB     'ZAROPTVAL'
      *
      ** INPUTS
      ** Return Code
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Option code
      *
     C                   PARM                    DDOPTN
      *
      ** Front Office ID
      *
     C                   PARM                    DDFRNT
      *
      ** Booking Branch
      *
     C                   PARM      *BLANKS       PBookBrc
     C                   PARM                    BJSBRC
      *
      ** OUTPUTS
      ** Exit Command Key
      *
     C                   PARM      '0'           PInkc
      *
      ** Cancel Command Key
      *
     C                   PARM      '0'           PInkl
      *
      ** If F3 pressed, by further processing
      *
     C                   IF        PInkc = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** If F12 pressed, continue with next option
      *
     C                   IF        PInkl = '1'
     C                   EVAL      DDOPTN = *BLANKS
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SREnqInv - Enquiry on Invalid Transaction                    *
      *                                                               *
      *  Called By: SRRdSflr                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SREnqInv      BEGSR
      *
     C     ZATRNKD0      CHAIN     SDICUAHX0
      *
      ** Pass the invalid transaction details to the enquiry
      *
     C                   CALLB     'ZAINVTRENQ'
      *
      ** INPUTS
      ** Return Code
      *
     C                   PARM                    RetCodeOut
      *
      ** Action Code
      *
     C                   PARM                    DDACTN
      *
      ** Front Office ID
      *
     C                   PARM                    DDFRNT
      *
      ** Associated Front Office ID
      *
     C                   PARM      *BLANKS       DDFOASOCID
      *
      ** TimeStamp
      *
     C                   PARM                    DDTMST
      *
      ** Invalid file names
      *
     C                   PARM      'SDICUAHPD'   PInvFile1
     C                   PARM      *BLANKS       PInvFile2
     C                   PARM      *BLANKS       PInvFile3
      *
      ** Invalid file data
      *
     C                   PARM      InvR          PInvFDta1
     C                   PARM      *BLANKS       PInvFDta2
     C                   PARM      *BLANKS       PInvFDta3
      *
      ** OUTPUTS
      ** Exit Command Key
      *
     C                   PARM      '0'           PInkc
      *
      ** Cancel Command Key
      *
     C                   PARM      '0'           PInkl
      *
      ** If F3 pressed, by further processing
      *
     C                   IF        PInkc = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDltInv - Delete an Invalid Transaction                     *
      *                                                               *
      *  Called by: SRRdSflr                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRDltInv      BEGSR
      *
      ** Pass the invalid transaction details for delete
      *
     C                   CALLB     'ZAINVTRDEL'
      *
      ** INPUTS
      ** Return Code
      *
     C                   PARM                    RetCodeOut
      *
      ** Action Code
      *
     C                   PARM                    DDACTN
      *
      ** Front Office ID
      *
     C                   PARM                    DDFRNT
      *
      ** Associated Front Office ID
      *
     C                   PARM      *BLANKS       DDFOASOCID
      *
      ** TimeStamp
      *
     C                   PARM                    DDTMST
      *
      ** Narrative & Field Content 1 - 9
      *
     C                   PARM                    PDDNAR1
     C                   PARM      DDFRNT        PDDFLD1
     C                   PARM                    PDDNAR2
     C                   PARM                    PDDFLD2
     C                   PARM                    PDDNAR3
     C                   PARM                    PDDFLD3
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
      *
      ** OUTPUTS
      ** Exit Command Key
      *
     C                   PARM      '0'           PInkc
      *
      ** F10 Command Key
      *
     C                   PARM      '0'           PInkj
      *
      ** Cancel Command Key
      *
     C                   PARM      '0'           PInkl
      *
      ** If F3 pressed, bypass further processing
      *
     C                   IF        PInkc = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** If F10 pressed, delete invalid remark
      *
     C                   IF        PInkj = '1'
     C                   EVAL      PTmeStpSel  = DDTMST
      *
     C     ZATRNKX0      CHAIN     SDICUAHD0                          24
      *
      ** If not found, Delete the invalid remark from the Invalid
      ** remarks Database
      *
     C                   IF        *IN24 = *OFF
     C                   DELETE    SDICUAHD0
     C                   ENDIF
      *
      ** Delete invalid record from the log file
      *
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
      *
     C                   EVAL      KMsgType = 'CUAH'
     C                   EVAL      KFrntOffID = DDFRNT
     C                   EVAL      KTimeStamp = PTmeStpSel
      *
     C     KAPLog        CHAIN     APILOGL0                           99
      *
     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   COMMIT
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkAut - Check for User Authority if not Multi-branching   *
      *                                                               *
      *  Called by: SRbldsfl                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRChkAut      BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PActnCd
     C                   PARM                    PError
      *
      ** Return Error message
      *
     C                   IF        PError = 1
     C                   EVAL      PErrMs = 'FXM0292'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRinit - Initialisation                                      *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRinit        BEGSR
      *
      ** If 24x7 is present then journal APILOGL0
      *
     C                   IF        CSC011 = 'Y'
     C                   OPEN      APILOGL0
     C                   ENDIF
      *
      ** Clear Outputs
      *
     C                   EVAL      PErrMs = *BLANKS
     C                   EVAL      POpSel = *BLANKS
     C                   EVAL      PAcSel = *BLANKS
     C                   EVAL      PCust = *BLANKS
     C                   EVAL      PFOTranSel = *BLANKS
     C                   CLEAR                   PTmeStpSel
     C                   EVAL      PInkc = *OFF
     C                   EVAL      PInkl = *OFF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - INitial Processing                                  *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** *Entry Parameter list
      *
     C     *ENTRY        PLIST
      *
      ** INPUTS
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Build Sub-File
      *
     C                   PARM                    PBdSfl
      *
      ** Read Subfile Record
      *
     C                   PARM                    PRdSfl
      *
      ** Error in update of previous deal
      *
     C                   PARM                    PErrUp
      *
      ** Switchable Feature
      *
     C                   PARM                    CSC011
      *
      ** OUTPUTS
      ** Error Message
      *
     C                   PARM                    PErrMs
      *
      ** Option Selected
      *
     C                   PARM                    POpSel
      *
      ** Action Selected
      *
     C                   PARM                    PAcSel
      *
      ** FO Transaction ID Selected
      *
     C                   PARM                    PFOTranSel
      *
      ** Customer Number
      *
     C                   PARM                    PCust
      *
      ** Timestamp of Transaction Selected
      *
     C                   PARM                    PTmeStpSel
      *
      ** F3 Command Key
      *
     C                   PARM                    PInkc
      *
      ** F12 Command Key
      *
     C                   PARM                    PInkl
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'SDCUAHRPB'
      *
      ** Move workstation ID to screen field
      *
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      DDJBNM = PsJobName
      *
      ** Access Bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBKEY  = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SDSTAT and SC24X7 if CSC011 is installed
      *
     C                   IF        CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
      *
      ** Define the following key lists:
      ** Define the key list - ZATRNKD0 with following key fields:
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFRNT
     C                   KFLD                    PTmeStpSel
      *
      ** Define the key list - ZATRNKX0 with following key fields:
      *
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTmeStpSel
     C                   KFLD                    DDFRNT
      *
      ** Define the key list - KAPLOG with following key fields:
      *
     C     KAPLOG        KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2008
**  Array of error messages - ErrorText
The last transaction was not applied to the database
