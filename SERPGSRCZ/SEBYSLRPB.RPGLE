     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Buy sell back invalid transactions browse')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEBYSLRPB - Buy Sell Back Invalid Transactions Browse        *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of invalid deals for selection *
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 249071             Date 31Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233708             Date 02Jun05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 14Mar02               *
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249071 - CSE097 problems in BYSL(Recompile)                  *
      *  233708 - Addition of fields for CGL031(Recompile)            *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSC011 - 24x7 Midas Availabilty                              *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FSEBYSLRDF CF   E             WORKSTN
     F                                     SFILE(SEBYSLS1:@@RRN)
 
     FSEIBYSLL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEIBYSLD0:SEIBYSLX0)
 
     FSEIBYSLL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FSEIBYSLL2 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEIBYSLD0:SEIBYSLX2)
 
      ** API Invalid Log File                                                                 CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR)                                       CSC011
     F                                     COMMIT                                             CSC011
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
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
     D InvTr         E DS                  EXTNAME(SEIBYSLPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access programs, short data structure
      *
     D ErrorText       S             56    DIM(2) CTDATA PERRCD(1)
      ** Array containing messages
      *
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data Area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
     D CSC011          S              1A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOfcID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
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
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   EXSR      SRInit
      *
      ** Build Sub-file
      *
     C     @BDSFL        IFEQ      'Y'
     C                   EXSR      SRBldSfl
     C                   ENDIF
      *
      ** Read subfile record
      *
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      SRRdSfRc
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Build Subfile                                     *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
      *
      ** Check for user authority to browse if not multi-branching
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SRChAutN
     C                   ENDIF
      *
      ** Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
      *
     C                   MOVE      *ON           *IN97
     C                   WRITE     SEBYSLS0
     C                   MOVE      *OFF          *IN97
      *
      ** Write the select screen footer to the screen.
      ** If previous transaction was not successful due to deal being
      ** updated by another workstation then display message on screen
      *
     C     @ERRUP        IFEQ      'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   MOVE      *BLANKS       ERRORMSG
      *
      ** Print appropriate narrative
      *
     C                   IF        @SITR <> *BLANKS AND
     C                             PSITR <> *BLANKS
     C                   MOVEL     ErrorText(2)  ERRORMSG
     C                   EVAL      %SUBST(ERRORMSG:16:6) = @SITR
     C                   EVAL      %SUBST(ERRORMSG:27:6) = PSITR
     C                   ENDIF
     C                   ENDIF
      *
     C                   WRITE     SEBYSLF1
      *
      ** Set file pointer to start of file
      *
     C     *LOVAL        SETLL     SEIBYSLL2
      *
      ** Read an invalid Buy-Sell Transaction
      *
     C                   EXSR      SRRdInBS
      *
      ** If no records exist - set up an error message.
      ** Display a message 'No invalid transactions present'
      ** then terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'FXM1007'     @ERRMS
     C                   EXFMT     SEBYSLEND
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      *ON           *IN98
      *
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.
      *
     C     @@EOF         DOWNE     'Y'
     C     *IN98         ANDEQ     *ON
      *
      ** Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Write the invalid buy-sell to the subfile
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   MOVE      DDTMESTMP     D@TMESTMP
     C                   WRITE     SEBYSLS1
      *
      ** Read an invalid buy-sell transaction
      *
     C                   EXSR      SRRdInBS
     C                   ENDDO
      *
      ** Write the subfile control record to the screen to display
      ** the subfile.
      *
     C                   WRITE     SEBYSLS0
      *
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
      *
     C                   READ      SEBYSLS0                               99
      *
      ** If F3, bypass further processing.
      *
     C     *INKC         IFEQ      *ON
     C                   MOVEL     *ON           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      ** If F12, bypass further processing.
      *
     C     *INKL         IFEQ      *ON
     C                   MOVEL     *ON           @INKL
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdSfRc - Read Subfile Record                                *
      *                                                               *
      *****************************************************************
     C     SRRdSfRc      BEGSR
      *
      ** Read the subfile for selected records
      ** Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     *ON
     C     DDOPT         ORNE      *BLANK
     C                   READC     SEBYSLS1                               99
      *
      ** Validate repair option code
      *
     C     *IN99         IFEQ      *OFF
     C                   EXSR      SRValROp
     C                   ENDIF
      *
      ** If 'E' is input, enquire upon invalid transaction
      *
     C     *IN99         IFEQ      *OFF
     C     DDOPT         ANDEQ     'E'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C                   EXSR      SREnqInv
     C                   MOVEL     *BLANK        DDOPT
     C                   ENDIF
      *
      ** If 'Q' is input, prompt for deletion of invalid transaction
      *
     C     *IN99         IFEQ      *OFF
     C     DDOPT         ANDEQ     'Q'
     C                   EXSR      SRPrmDlt
     C                   MOVEL     *BLANK        DDOPT
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Return the selected option, action, front office transaction ID
      ** and front office associated transaction ID
      *
     C     *IN99         IFNE      *ON
     C     DDOPT         ANDNE     *BLANK
     C                   MOVE      DDOPT         @OPSEL
     C                   MOVE      DDACTN        @ACSEL
     C                   MOVE      DDFOTRANID    @FOTRANSEL
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValROp - Validate Repair Option Code                        *
      *                                                               *
      *****************************************************************
     C     SRValROp      BEGSR
      *
     C                   CALLB     'ZAROPTVAL'
      *
      ** INPUTS
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Option code
      ** Front Office ID
      ** Booking Branch
     C                   PARM                    DDOPT
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDBRSN
      *
      ** ICD Single branch code
     C                   PARM                    BJSBRC
      *
      ** OUTPUTS
      ** Function Keys
     C                   PARM      *OFF          @INKC
     C                   PARM      *OFF          @INKL
      *
      ** If F3, bypass further processing.
      *
     C     @INKC         IFEQ      *ON
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
      ** If F12, continue with next option
      *
     C     @INKL         IFEQ      *ON
     C                   MOVEL     *BLANK        DDOPT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnqInv - Enquire on Invalid Transaction                     *
      *                                                               *
      *****************************************************************
     C     SREnqInv      BEGSR
      *
      ** Pass the invalid transaction details to the enquiry
      *
     C     ZATRNKX0      CHAIN     SEIBYSLX0                          99
      *
     C                   CALLB     'ZAINVTRENQ'
      *
      ** INPUTS
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Action code
      ** Front Office ID
      ** Associated Front Office ID
      ** Timestamp
     C                   PARM                    DDACTN
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDFOASOCID
     C                   PARM                    D@TMESTMP
      *
      ** Invalid file names
     C                   PARM      'SEIBYSLPD'   InvFile1         10
     C                   PARM                    InvFile2         10
     C                   PARM                    InvFile3         10
      *
      ** Invalid file data
     C                   PARM      InvTr         InvFDta1       4000
     C                   PARM                    InvFDta2       4000
     C                   PARM                    InvFDta3       4000
      *
      ** OUTPUTS
      ** Function Keys
     C                   PARM      *OFF          @INKC
     C                   PARM      *OFF          @INKL
      *
      ** If F3, bypass further processing.
      *
     C     @INKC         IFEQ      *ON
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrmDlt - Prompt for Deletion                                *
      *                                                               *
      *****************************************************************
     C     SRPrmDlt      BEGSR
      *
     C                   CALLB     'ZAINVTRDEL'
      *
      ** INPUTS
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** Front Office Trans ID & Front Office Associated Trans ID
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDFOASOCID       20
      *
      ** Timestamp
     C                   PARM                    D@TMESTMP
      *
      ** Narrative & Field Content 1 - 9
     C                   PARM                    DDNAR1           30
     C                   PARM      DDTDRF        DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      DDSESN        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      DDCNUM        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM      DDINCS        DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM      DDTDTP        DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM      DDNOML        DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM      DDTPDY        DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM      DDTDVD        DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM      DDTDDT        DDFLD9           35
      *
      ** OUTPUTS
      ** Function keys
     C                   PARM      *OFF          @INKC             1
     C                   PARM      *OFF          @INKJ             1
     C                   PARM      *OFF          @INKL             1
      *
      ** If F3, bypass further processing.
      *
     C     @INKC         IFEQ      *ON
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
      ** If F10, delete invalid buy-sell transaction
      *
     C     @INKJ         IFEQ      *ON
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKD0      CHAIN     SEIBYSLD0                          99
      *
     C     *IN99         IFEQ      *OFF
     C                   MOVE      'D'           DDACTN
     C                   MOVEL     *BLANKS       EntryData
     C                   MOVEL     *BLANKS       FileName
     C                   CALL      'RPC1600'
     C                   PARM      InvTr         EntryData      3000
     C                   PARM      'SEIBYSLPD'   FileName         10
     C                   ENDIF
      *
     C     *IN99         IFEQ      *OFF
     C                   DELETE    SEIBYSLD0
                                                                                              CSC011
      ** Delete the first leg of the transaction.                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and LIBR = S1SUPP                             CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'SEBYSL'                                        CSC011
     C                   EVAL      KFrntOfcID = DDFOTRANID                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
      *
      ** Use associated front office id to chain the second leg
      *
     C                   MOVEL     DDFOASOCID    DDFOTRANID
      *
     C     DDFOASOCID    CHAIN     SEIBYSLD0                          99
      *
     C     *IN99         IFEQ      *OFF
     C                   MOVE      'D'           DDACTN
     C                   MOVEL     *BLANKS       EntryData
     C                   MOVEL     *BLANKS       FileName
     C                   CALL      'RPC1600'
     C                   PARM      InvTr         EntryData      3000
     C                   PARM      'SEIBYSLPD'   FileName         10
     C                   ENDIF
      *
      ** If second leg is found, delte this as well
      *
     C     *IN99         IFEQ      *OFF
     C                   DELETE    SEIBYSLD0
                                                                                              CSC011
      ** Delete the second leg of the transaction.                                            CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and LIBR = S1SUPP                             CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'SEBYSL'                                        CSC011
     C                   EVAL      KFrntOfcID = DDFOTRANID                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
      *
     C                   COMMIT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdInBS - Read an Invalid Buy-Sell Transaction               *
      *                                                               *
      *****************************************************************
     C     SRRdInBS      BEGSR
      *
      ** Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      ** Read the file.
      *
     C                   READ      SEIBYSLL2                              96
      *
      ** End of File
      *
     C     *IN96         IFEQ      *ON
     C                   MOVEL     'Y'           @@EOF
     C                   ENDIF
      *
     C     ERDDEL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChAutN - Check for User Authority if not Multi-branching    *
      *                                                               *
      *****************************************************************
     C     SRChAutN      BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ** Return error message
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvTxt - Retrieve Text                                      *
      *                                                               *
      *****************************************************************
     C     SRRtvTxt      BEGSR
      *
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM      'ZZGBMSGF  '  MSGNM            10
     C                   PARM      *BLANK        MSGTXT           80
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation                                       *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
      *
      ** Clear outputs
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @ACSEL
     C                   MOVE      *BLANK        @FOTRANSEL
     C                   CLEAR                   @TMESTPSEL
     C                   MOVE      *OFF          @INKC
     C                   MOVE      *OFF          @INKL
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUTS
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Build Subfile
     C                   PARM                    @BDSFL            1
      *
      ** Read Subfile record
     C                   PARM                    @RDSFL            1
      *
      ** Error in update of previous deal
     C                   PARM                    @ERRUP            1
      *
      ** OUTPUTS
      ** Error Message
     C                   PARM                    @ERRMS            7
      *
      ** Option Selected
     C                   PARM                    @OPSEL            1
      *
      ** Action Selected
     C                   PARM                    @ACSEL            1
      *
      ** FO Transaction Id Selected
     C                   PARM                    @FOTRANSEL       20
      *
      ** Timestamp of transaction selected
     C                   PARM                    @TMESTPSEL
      *
      ** Commaned keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ** Successful Insert Buy-Sell Transaction
     C                   PARM                    @SITR             6
      *
      ** Successful Insert Buy-Sell Transaction 2
     C                   PARM                    PSITR             6
     C                   PARM                    CSC011                                       CSC011
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEBYSLRPB'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
                                                                                              CSC011
      ** Access SDSTAT and SC24X7 if CSC011 is installed                                      CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ENDIF                                                                CSC011
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    DDFOTRANID
                                                                                              CSC011
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOfcID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
                                                                                              CSC011
      *
      ** Format text for invalid transaction deletion function
      *
     C                   MOVEL     'APA0091'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR1
     C                   MOVEL     'APA0092'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR2
     C                   MOVEL     'APA0093'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR3
     C                   MOVEL     'APA0094'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR4
     C                   MOVEL     'APA0095'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR5
     C                   MOVEL     'APA0096'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR6
     C                   MOVEL     'APA0097'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR7
     C                   MOVEL     'APA0098'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR8
     C                   MOVEL     'APA0099'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR9
      *
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
(c) Finastra International Limited 2001
**  Array of error messages - ErrorText
The last transaction was not applied to the database.
Buy-sell backs 999999 and 999999 successfully inserted.
