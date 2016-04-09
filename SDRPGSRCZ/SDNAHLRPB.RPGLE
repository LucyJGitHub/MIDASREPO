     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - Repair Browse')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHLRPB - Invalid Non-A/C Holders Browse                   *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of invalid Non-A/C Holders     *
      *             for selection.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CGL132             Date 01May13               *
      *  Prev Amend No. AR689705           Date 03Jan11               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 31Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue (Recompile)                            *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Standard Changes (Recompile)             *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL032 - Automatic Exchange of Information.                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDNAHLRDF CF   E             Workstn
     F                                     Sfile(SDNAHLS1:@@RRN)
 
     FSDINAHLL0 IF   E           K DISK    Infsr(*PSSR)
     F                                     Rename(SDINAHLD0:SDINAHLX0)
 
     FSDINAHLL1 UF   E           K DISK    Infsr(*PSSR)
     F                                     Commit
     FSDIFTNHL0 IF   E           K DISK    Infsr(*PSSR)                                       CGL132
 
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
      **    True       logical = *On (for indcator processing)
      **    False      logical = *Off (for indcator processing)
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
 
     D @@CNT           S              3  0
     D @@RRN           S              5  0
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D InvCd         E DS                  Extname(SDINAHLPD)
     D InvFt         E DS                  Extname(SDIFTNHPD)                                 CGL132
 
      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)
                                                                                              CGL132
      ** External DS for SAR details                                                          CGL132
     D SCSARD        E DS                  Extname(SCSARDPD)                                  CGL132
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  Extname(DSFDY)
 
      ** Array containing messages
     D ErrorText       S             52    Dim(1) CTDATA PERRCD(1)
 
      ** SD data area
     D SDSTAT        E DS                  Extname(SDSTAT) DTAARA(SDSTAT)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
 
      ** Fields defined for Enhancement CSC011
 
     D CSC011          S              1A
     D KMsgType        S              8A
     D KFrntOffID      S             20A
     D KTimeStamp      S                   LIKE(@TMESTPSEL)
 
      ** Parameter fields for ZAINVTRENQ
     D DDFOASOCID      S             20
     D InvFile1        S             10
     D InvFile2        S             10
     D InvFile3        S             10
     D InvFDta1        S           4000
     D InvFDta2        S           4000
     D InvFDta3        S           4000
 
      ** Parameter fields for ZAINVTRDEL
     D DDNAR1          S             30
     D DDFLD1          S             35
     D DDNAR2          S             30
     D DDFLD2          S             35
     D DDNAR3          S             30
     D DDFLD3          S             35
     D DDNAR4          S             30
     D DDFLD4          S             35
     D DDNAR5          S             30
     D DDFLD5          S             35
     D DDNAR6          S             30
     D DDFLD6          S             35
     D DDNAR7          S             30
     D DDFLD7          S             35
     D DDNAR8          S             30
     D DDFLD8          S             35
     D DDNAR9          S             30
     D DDFLD9          S             35
     D @INKC           S              1
     D @INKJ           S              1
     D @INKL           S              1
 
      ** Parameter fields for ZVACTU
     D ZACTN           S              1
     D @@ERR           S              1  0
 
      ** Parameter for RPC1600
     D EntryData       S           3000A
     D FileName        S             10A
 
      ** Parameter fields for SDRTVTXT
     D MSGDNB          S              7
     D MSGNM           S             10
     D MSGTXT          S             80
 
      ** Entry Parameter fields
     D @BDSFL          S              1
     D @RDSFL          S              1
     D @ERRUP          S              1
     D @ERRMS          S              7
     D @OPSEL          S              1
     D @ACSEL          S              1
     D @FOTRANSEL      S             20
     D @NAHO           S             10
 
     D DDBRSN          S              3
     D @@EOF           S              1
     D PRTCD           S              7
     D POPTN           S              7
     D PSard           S              6    INZ(*Blanks)                                       CGL132
 
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
 
      ** Initialisation
     C                   EXSR      SRInit
 
      ** Build Sub-file
     C                   IF        @BDSFL = 'Y'
     C                   EXSR      SRBldSfl
     C                   ENDIF
 
      ** Read Subfile record
 
     C                   IF        @RDSFL = 'Y'
     C                   EXSR      SRRdSflr
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      ********************************************************************
      ** SRBldSfl - Build Subfile
      ********************************************************************
     C     SRBldSfl      BEGSR
 
      ** Check for User Authority to browse IF not Multi-Branching
 
     C                   IF        BJSBRC <> *Blanks
     C                   EXSR      SRChautN
     C                   ENDIF
 
      **  Initialise subfile relative record number.
 
     C                   EVAL      @@RRN = *Zeros
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
 
     C                   EVAL      *In97 = *On
     C                   WRITE     SDNAHLS0
     C                   EVAL      *In97 = *Off
 
      **  IF previous transaction was not successful due to deal being
      **  updated by another workstation then display message on screen
 
     C                   IF        @ERRUP = 'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   EVAL      ERRORMSG = *BLANKS
     C                   ENDIF
 
      **  Write the select screen footer to the screen.
 
     C                   WRITE     SDNAHLF1
 
      **  Set file pointer to start of file
 
     C     *Loval        SETLL     SDINAHLL0
 
      ** Read an Invalid Non-A/C Holder
 
     C                   EXSR      SRRdINaho
 
      **  IF no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
 
     C                   IF        @@EOF  = 'Y'
     C                   EVAL      @ERRMS = 'FXM1007'
     C                   EXFMT     SDNAHLEND
     C                   EVAL      *InLR = *On
     C                   RETURN
     C                   ENDIF
 
      **  Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN98 = *On
 
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
 
     C                   DOW       @@EOF <> 'Y' and
     C                             *IN98 = *On
 
      **  Initialise count of records written to subfile page.
 
     C                   EVAL      @@CNT = *Zeros
 
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
 
     C                   DOW       @@EOF <> 'Y' and
     C                             @@CNT <  14
 
      **  Increment the subfile record no. and records written fields.
 
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
 
      **  Write the invalid Non-A/C Holder to the subfile.
 
     C                   EVAL      DDOPT  = *Blanks
     C                   EVAL      DDSFRN = @@RRN
     C                   MOVEL     DDTMST        D@TMESTMP
     C                   WRITE     SDNAHLS1
 
      ** Read AN Inavlid Non-A/C Holder
 
     C                   EXSR      SRRdINaho
     C                   ENDDO
 
      **  Write the subfile control record to the screen to display
      **  the subfile.
 
     C                   WRITE     SDNAHLS0
 
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
 
     C                   READ      SDNAHLS0                               99
 
      **  IF F3, bypass further processing.
 
     C                   IF        *INKC = *On
     C                   MOVEL     *On           @INKC
     C                   EVAL      *InLR = *On
     C                   RETURN
     C                   ENDIF
 
      **  IF F12, bypass further processing.
 
     C                   IF        *INKL = *On
     C                   EVAL      @INKL = *On
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      ** SRRdSflR - Read subfile record
      ********************************************************************
     C     SRRdSflR      BEGSR
 
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
 
     C                   DOU       *IN99 = *On  or
     C                             DDOPT <> *Blanks
     C                   READC     SDNAHLS1                               99
 
      ** Validate repair option code
 
     C                   IF        *IN99 = *Off
     C                   EXSR      SRValid_Ropt
     C                   ENDIF
 
      ** IF 'E' is input, enquire upon invalid transaction
 
     C                   IF        *IN99 = *Off and
     C                             DDOPT = 'E'
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C                   EXSR      SREnq_Inv
     C                   EVAL      DDOPT = *Blanks
     C                   ENDIF
 
      ** IF 'Q' is input, prompt for deletion of invalid transaction
 
     C                   IF        *IN99 = *Off and
     C                             DDOPT = 'Q'
     C                   EXSR      SRProm_Delt
     C                   EVAL      DDOPT = *Blanks
     C                   ENDIF
 
     C                   ENDDO
 
      **  RETURN the selected option, action, front office transaction ID
      **  and front office associated transaction ID
 
     C                   IF        *IN99 <> *On   and
     C                             DDOPT <> *Blanks
     C                   MOVE      DDOPT         @OPSEL
     C                   MOVE      DDACTN        @ACSEL
     C                   MOVE      DDNAHO        @NAHO
     C                   MOVE      DDFRNT        @FOTRANSEL
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRValid_Ropt - Validate Repair Option code
      *****************************************************************
     C     SRValid_Ropt  BEGSR
 
     C                   CALLB     'ZAROPTVAL'
      **                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** RETURN Code
      ** Option code
      ** Front Office ID
      ** Booking Branch
      ** ICD Single branch code
 
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM                    DDOPT
     C                   PARM                    DDFRNT
     C                   PARM      *Blanks       DDBRSN
     C                   PARM                    BJSBRC
 
      ** OUTPUTS :
      ** Function Keys
 
     C                   PARM      *Off          @INKC
     C                   PARM      *Off          @INKL
 
      **  IF F3, bypass further processing.
 
     C                   IF        @INKC = *On
     C                   EVAL      *InLR = *On
     C                   RETURN
     C                   ENDIF
 
      **  IF F12, continue with next option
 
     C                   IF        @INKL = *On
     C                   EVAL      DDOPT = *Blanks
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SREnq_Inv - Enquire on Invalid Transaction
      *****************************************************************
     C     SREnq_Inv     BEGSR
 
      ** Pass the invalid transaction details to the enquiry
 
     C     ZATRNKX0      CHAIN     SDINAHLX0                          99
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   CLEAR                   InvFt                                        CGL132
     C     ZATRNKX0      CHAIN     SDIFTNHD0                          99                      CGL132
     C                   ENDIF                                                                CGL132
 
     C                   CALLB     'ZAINVTRENQ'
      **                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** RETURN Code
      ** Action code
      ** Front Office ID
      ** Associated Front Office ID
      ** Timestamp
      ** Invalid file names
      ** Invalid file data
 
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDFRNT
     C                   PARM      *Blanks       DDFOASOCID
     C                   PARM                    D@TMESTMP
     C                   PARM      'SDINAHLPD'   InvFile1
     C**********         PARM      *Blanks       InvFile2                                     CGL132
     C                   PARM      'SDIFTNHPD'   InvFile2                                     CGL132
     C                   PARM      *Blanks       InvFile3
     C                   PARM      InvCd         InvFDta1
     C**********         PARM      *Blanks       InvFDta2                                     CGL132
     C                   PARM      InvFt         InvFDta2                                     CGL132
     C                   PARM      *Blanks       InvFDta3
 
      ** OUTPUTS :
      ** Function Keys
 
     C                   PARM      *Off          @INKC
     C                   PARM      *Off          @INKL
 
      **  IF F3, bypass further processing.
 
     C                   IF        @INKC = *On
     C                   EVAL      *InLR = *On
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRProm_Delt - Prompt for Deletion
      *****************************************************************
     C     SRProm_Delt   BEGSR
 
     C                   CALLB     'ZAINVTRDEL'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** RETURN Code
      ** Action code
      ** Front Office Trans ID & Front Office Associated Trans ID
      ** Timestamp
      ** Narrative & Field Content 1 - 9
 
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDFRNT
     C                   PARM      *Blanks       DDFOASOCID
     C                   PARM                    D@TMESTMP
     C                   PARM                    DDNAR1
     C                   PARM      DDNAHO        DDFLD1
     C                   PARM                    DDNAR2
     C                   PARM      DDNARN        DDFLD2
     C                   PARM                    DDNAR3
     C                   PARM      DDNATW        DDFLD3
     C                   PARM                    DDNAR4
     C                   PARM      DDCNA1        DDFLD4
     C                   PARM                    DDNAR5
     C                   PARM      DDCNA2        DDFLD5
     C                   PARM                    DDNAR6
     C                   PARM      DDIDE1        DDFLD6
     C                   PARM                    DDNAR7
     C                   PARM      DDIDE2        DDFLD7
     C                   PARM                    DDNAR8
     C                   PARM      DDZIPC        DDFLD8
     C                   PARM                    DDNAR9
     C                   PARM      DDCITY        DDFLD9
 
      ** OUTPUTS :
      ** Function Keys
 
     C                   PARM      *Off          @INKC
     C                   PARM      *Off          @INKJ
     C                   PARM      *Off          @INKL
 
      **  IF F3, bypass further processing.
 
     C                   IF        @INKC = *On
     C                   EVAL      *InLR = *On
     C                   RETURN
     C                   ENDIF
 
      **  IF F10, delete Invalid Non-A/C Holder
 
     C                   IF        @INKJ = *On
     C                   MOVE      D@TMESTMP     @TMESTPSEL
     C     ZATRNKD0      CHAIN     SDINAHLD0                          99
     C                   IF        *In99 = *Off
     C                   MOVE      'D'           DDACTN
     C                   MOVEL     *BLANKS       EntryData
     C                   MOVEL     *BLANKS       FileName
     C                   CALL      'RPC1600'
     C                   PARM      InvCd         EntryData
     C                   PARM      'SDINAHLPD'   FileName
     C                   DELETE    SDINAHLD0
     C                   ENDIF
 
 
      ** Delete invalid record from the log file.
 
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR
 
     C                   EVAL      KMsgType = 'SDBSRT'
     C                   EVAL      KFrntOffID = DDFRNT
     C                   EVAL      KTimeStamp = @TMESTPSEL
 
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
      ** SRRdINaho - Read an Invalid Non-A/C Holder
      *****************************************************************
     C     SRRdINaho     BEGSR
 
      **  Reset End of File indicator
 
     C                   MOVE      *Blanks       @@EOF
 
      **  Read the file.
 
     C                   READ      SDINAHLL0                              96
 
      ** End of File
 
     C                   IF        *IN96 = *On
     C                   EVAL      @@EOF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRChautN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     SRChautN      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    @@ERR
 
      ** Return Error Message
 
     C                   IF        @@ERR = 1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRRtvTxt - RETRIEVE TEXT
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
      ** SRInit - Initialisation
      *****************************************************************
     C     SRInit        BEGSR
 
      ** If 24x7 is present then journal APILOGL0
 
     C                   IF        (CSC011 = 'Y')
     C                   OPEN      APILOGL0                             22
     C                   ENDIF
 
      ** Clear outputs
 
     C                   EVAL      @ERRMS     = *Blanks
     C                   EVAL      @OPSEL     = *Blanks
     C                   EVAL      @ACSEL     = *Blanks
     C                   EVAL      @NAHO      = *Blanks
     C                   EVAL      @FOTRANSEL = *Blanks
     C                   CLEAR                   @TMESTPSEL
     C                   EVAL      @INKC      = *Off
     C                   EVAL      @INKL      = *Off
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *Entry        PLIST
 
      ** INPUTS :
      ** RETURN Code
      ** Build Sub-file
      ** Read Subfile Record
      ** Error in update of previous deal
 
     C                   PARM                    RetCodeIn
     C                   PARM                    @BDSFL
     C                   PARM                    @RDSFL
     C                   PARM                    @ERRUP
     C                   PARM                    CSC011
 
      ** OUTPUTS :
      ** Error Message
      ** Option Selected
      ** Action Selected
      ** FO Transaction ID selected
      ** Non-A/C Holder Reference
      ** Timestamp of Transaction Selected
      ** Command Keys
 
     C                   PARM                    @ERRMS
     C                   PARM                    @OPSEL
     C                   PARM                    @ACSEL
     C                   PARM                    @FOTRANSEL
     C                   PARM                    @NAHO
     C                   PARM                    @TMESTPSEL
     C                   PARM                    @INKC
     C                   PARM                    @INKL
 
      ** Initialize program name
 
     C                   MOVEL     'SDNAHLRPB'   DBPGM
 
      ** MOVE workstation ID to screen field.
 
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
      ** Access SDSTAT and SC24X7 if switchable feature CSC011 is on.
 
     C                   IF        CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
      ** Check if FATCA is switched on                                                        CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       Prtcd                                        CGL132
     C                   PARM      '*VERIFY'     Poptn                                        CGL132
     C                   PARM      'CGL132'      PSard                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
      ** Database error                                                                       CGL132
                                                                                              CGL132
     C     @RTCD         IFNE      *BLANKS                                                    CGL132
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL132
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL132
     C                   MOVEL     '908'         DBASE                                        CGL132
     C                   MOVEL     'CGL132'      DBKEY                                        CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C     @RTCD         IFEQ      *BLANK                                                     CGL132
     C                   MOVEL     'Y'           CGL132            1                          CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVEL     'N'           CGL132                                       CGL132
     C                   ENDIF                                                                CGL132
 
      ** Key Lists
 
     C     KAPILOGL0     KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    DDFRNT
     C                   KFLD                    @TMESTPSEL
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    DDFRNT
 
      ** Format text for Invalid Transaction Deletion Function
 
     C                   MOVEL     'ZZN6682'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR1
     C                   MOVEL     'ZZN6683'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR2
     C                   MOVEL     'ZZN6684'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR3
     C                   MOVEL     'ZZN6685'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR4
     C                   MOVEL     'ZZN6684'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR5
     C                   MOVEL     'ZZN6681'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR6
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
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
**  Array of error messages - ErrorText
The last transaction was not applied to the database
