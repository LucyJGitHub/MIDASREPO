     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral Risk Weighted Asset Codes Main')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL001241  - Customer Risk Weighted Assets Codes Maintenance  *
      *                                                               *
      *  Function:  This program records valid Risk Weighted          *
      *             Assets Sets.                                      *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG6979            Date 04May05               *
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL018   *CREATE   Date 17Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    30         Enable F9 Key                                   *
      *    31         Option Field (RI, PC)                           *
      *    32         Enable/Disable Action Field (PR,ND,UL)          *
      *    95         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
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
      *
      **  Collateral Risk Weighted Asset Master File Retr.
      *
     FGLORWAL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L1)
      *
      **  Collateral Risk Weighted Asset Master File Update
      *
     FGLORWAL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L0)
     F                                     RENAME(GLORWAD0:RGLORWAD0)
     F                                     COMMIT
      *
      **  Risk Weighted Asset Master File Update Index
      *
     FSDRWASL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S1)
      *
      **  Risk Weighted Asset Codes Master File Update Index
      *
     FSDRWACL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CO)
      *
      **  Midas SD Customer details retrieval
      *
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CU)
      *
      **  Risk Weighted Assets Sets Maintenance Display
      *
     FGL001241DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(GL1241S1:DDSFRN)
     F                                     INFDS(INFDS#)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for Access Programs, Short Data Structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** ExternaL DS for Bank Details
      *
     D ZMUSER        E DS                  EXTNAME(ZMUSER)
     D                                     DTAARA(ZMUSER)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      ** External DS for SAR details                                                          CSC022
                                                                                              CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program Status Data Structure
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
     D PSARD           S                   LIKE(SARN)                                         CSC022
                                                                                              CSC022
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
                                                                                             BUG6979
      ** GET ZMUSER to access default details.                                               BUG6979
      *                                                                                      BUG6979
     C                   IN        ZMUSER                                                    BUG6979
      *                                                                                      BUG6979
      **  Set Display Variables                                                              BUG6979
      *                                                                                      BUG6979
     C                   EVAL      DDUSER = PSUser                                           BUG6979
     C                   EVAL      DDWID = PSJobName                                         BUG6979
     C                   EVAL      DDPGMQ = PSProcName                                       BUG6979
      *
     C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF
      *
      **  Reading Records
      *
     C                   EXSR      SETSCR
      *
     C                   IF        *INKC = *ON OR
     C                             *INKL = *ON
     C                   IF        *INKC = *on
     C                   EVAL      P#RTCD = 'Y2U9999'
     C                   ENDIF
     C                   leave
     C                   ENDIF
      *
     C                   ENDDO
      *========================================================================================
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *========================================================================================
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
      *
     C     *INZSR        BEGSR
     C
     C     *ENTRY        PLIST
     C                   PARM                    P#RTCD            7
     C                   PARM                    Action            1
     C                   PARM                    DDCREF
     C                   PARM                    DDDESC
     C                   PARM                    RWAUpd            1
      *
      **  Initialise LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBPGM
     C                   OUT       LDA
      **********                                                                             BUG6979
     C**********         IN        ZMUSER                                                    BUG6979
      *
      **  Call Access Program for Bank Details - Title, Run Date and
      **  Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Handle Database Error.
      *
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       WRTCD                                        CSC022
     C                   PARM      '*VERIFY'     WOPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        WRTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        WRTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 6                                                  CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
      *
      **  Check System Date Format, DDMMYY (*IN95 off)
      **                            MMDDYY (*IN95 on).
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        95
     C                   ENDIF
      *
      **  Access RUNDAT for multibranching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C
     C     AGMBIN        IFEQ      'M'
     C                   SETON                                        37
     C                   ENDIF
     C
     C                   MOVEL     'GLUSRMSG'    ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *BLANK        ZAMSID            7
     C                   MOVEL     *BLANK        ZAMSDA          132
     C                   MOVEL     *BLANK        ZAMSTP            7
      **********                                                                             BUG6979
      ****Set*Display*Variables                                                              BUG6979
      **********                                                                             BUG6979
     C**********         EVAL      DDUSER = PSUser                                           BUG6979
     C**********         EVAL      DDWID = PSJobName                                         BUG6979
     C**********         EVAL      DDPGMQ = PSProcName                                       BUG6979
      *
      **  Set Of Fields
      *
     C                   IF        Action <> 'E'
     C                   MOVE      *OFF          *IN30                          Enable F9 Key
     C                   MOVE      *OFF          *IN79                          Text On Bottom Scr
     C                   MOVE      *OFF          *IN32                          Enable Action Fld
     C                   ELSE
     C                   MOVE      *ON           *IN30                          Disable F9 Key
     C                   MOVE      *ON           *IN79                          Text On Bottom Scr
     C                   MOVE      *ON           *IN32                          Disable Action Fld
     C                   ENDIF
      *
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
      *
      **  Set SFLMSG Indicator
      *
     C                   MOVE      *ON           *IN91
      *
      **  KEYS
      *
     C     K#COLA        KLIST
     C                   KFLD                    DDCREF
     C                   KFLD                    DDCODE
     C                   KFLD                    DDSETN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  '(file)'
     C                   EVAL      DBKEY  =  '(key)'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  999
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PSProcName
     C                   OUT       LDA
      *
     C                   DUMP
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
      *
     C                   CALLB     'DBERRCTL'
      *
     C                   ENDIF
      *
      **  Any Error, Do Rollback
      *
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ENDIF                                                                CSC022
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * SETSCR - SET SCREEN                                           *
      *****************************************************************
      *
     C     SETSCR        BEGSR
     C
     C                   MOVE      'Y'           V#CLRM            1
     C                   MOVE      'Y'           V#BLD             1
     C
     C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF
     C
     C     V#BLD         IFEQ      'Y'
     C                   EXSR      BLDSFL
     C     V#SFR3        IFEQ      0
     C                   EXSR      BLDSFL
     C                   ENDIF
     C                   ENDIF
     C
     C                   MOVE      *BLANK        V#BLD
     C                   EVAL      *IN80 = *off
     C                   WRITE     GL1241M0                                     Message CTL
      *
      **  Show Subfile Screen
      *
     C     V#SFR3        IFNE      0
     C                   WRITE     GL1241F1
     C                   EXFMT     GL1241S0
     C
     C                   ELSE
      *
      **  No Record Screen
      *
     C                   MOVE      *ON           *IN80                          Text On Bottom Scr
     C                   WRITE     GL1241F1
     C                   EXFMT     GL1241N1
     C                   ENDIF
      *
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
      *
      **  F3 or F12 Key Pressed
      *
     C                   IF        *INKC = *ON OR
     C                             *INKL = *ON
     C                   LEAVE
     C                   ENDIF
      *
      **  Pressed F5 Key
      *
     C                   IF        *INKE = *ON
     C                   MOVE      *OFF          *INKE
     C                   MOVE      'Y'           V#BLD
     C                   ITER
     C                   ENDIF
      *
      **  Pressed F9 Key
      *
     C                   IF        *INKI = *ON
     C
     C                   MOVE      'I'           DDOPT
      *
      **  User is not authorised to this action code
      *
     C                   EXSR      SRNEW
     C                   ITER
     C                   ENDIF
      *
      **  Check Subfile Option
      *
     C                   MOVE      ' '           VALSFLOK          1
     C                   EXSR      VALSFL
      *
      **  Select an Event
      *
     C                   IF        VALSFLOK = *BLANK
      *
      **       DELETE ---------------------------------------
      *
     C                   IF        V#ACT1 = 'D'
     C                   MOVE      'D'           DDOPT
     C                   EXSR      SRDEL
      *
      **  No Action - Exit Program
      *
     C                   ELSE
     C                   EVAL      *INKL = *on
     C                   ENDIF
     C
     C                   ENDIF
     C
     C                   ENDDO
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * BLDSFL - BUILD SUBFILE                                        *
      *****************************************************************
      *
     C     BLDSFL        BEGSR
      *
      **  Subfile Clearing
      *
     C                   MOVE      *ON           *IN97
     C                   WRITE     GL1241S0
     C                   MOVE      *OFF          *IN97
     C                   Z-ADD     DDSFRN        V#LARC            4 0
     C                   Z-ADD     0             DDSFRN
      *
      **  Read the record from the file, write the record to the subfile
      *
     C                   MOVE      *OFF          *IN25
     C     DDCREF        SETLL     GLORWAL1                                     Live Rec.
     C                   MOVE      ' '           V#RDB3            1
     C
     C     *IN25         DOUEQ     *ON
     C     DDCREF        READE     GLORWAL1                               25
     C
     C                   IF        *IN25 = *OFF   AND
     C                             L1RWRECI = *BLANK                            Live Rec.
     C                   MOVE      'Y'           V#RDB3
     C                   MOVE      *ON           *IN26
      *
      **  If *IN26 *ON (Record is valid) Record is written to SFL
      *
     C     *IN26         IFEQ      *ON
     C                   MOVE      *BLANK        DDOPT
     C                   MOVE      L1RWSETN      DDSETN
     C                   MOVE      L1RWCODE      DDCODE
     C
     C                   ADD       1             DDSFRN
     C                   WRITE     GL1241S1
     C                   ENDIF
     C
     C                   ENDIF
     C                   ENDDO
     C
     C                   Z-ADD     DDSFRN        V#SFR3            3 0
      *
      **  Set on the first position
      *
     C                   IF        DDSFRN <> 0
     C                   Z-ADD     1             DDSFRN
     C                   ENDIF
      *
      **  Stay at the same record in SFL?
      *
     C                   IF        V#GO2R = 'Y' and
     C                             V#LARC <= V#SFR3
     C                   Z-ADD     V#LARC        DDSFRN
     C                   MOVE      *BLANK        V#GO2R            1
     C                   ENDIF
     C
     C                   MOVE      *ON           *IN62
      *
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * VALSF - VALIDATE SUBFILE OPTIONS                              *
      *****************************************************************
      *
     C     VALSFL        BEGSR
      *
      **  Set of indicators and variables
      *
     C                   MOVE      *OFF          *IN70
     C                   MOVE      'OLD'         V#MODE            3
     C                   Z-ADD     1             DDSFRN
     C                   MOVE      'N'           V#RCS1            1
     C                   MOVE      *OFF          *IN28
     C                   MOVE      *OFF          *IN31
      *
      **  Subfile read cycle
      *
     C                   DOU       *IN28 = *ON OR
     C                             V#RCS1 = 'Y'
     C                   READC     GL1241S1                               28
     C
     C                   IF        *IN28 = *OFF
     C
     C                   IF        DDOPT  = *BLANK
     C                   UPDATE    GL1241S1
     C                   ELSE
     C                   MOVE      *OFF          *IN31                          PC AND RI
      *
      **  Any Action code
      *
     C                   MOVE      'Y'           V#RCS1
      *
      **  Save Action code to variable
      *
     C                   MOVE      DDOPT         V#ACT1            1
      *
      **  Validate option
      *
     C                   IF        Action <> 'E'
     C                   IF        DDOPT <> 'D' and DDOPT <> *blank
      *
      **  Invalid action code: must be D or blank
      *
     C                   MOVE      'USR1004'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN31                          PC AND RI
     C
     C                   ELSE
     C
     C                   ENDIF
      *
     C                   ELSE
     C                   IF        DDOPT <> *BLANK
      *
      **  User is not authorised to this action code
      *
     C                   MOVE      'GLX0318'     ZAMSID
     C                   MOVEL(P)  DDOPT         ZAMSDA
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN31                          PC AND RI
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDDO
      *
      **  Selection criteria check
      *
     C                   SETOFF                                       71
      *
      **  If error, rebuild SFL
      *
     C     VALSFLOK      IFEQ      'N'
     C                   MOVE      *ON           *IN70
     C                   ELSE
     C                   MOVE      ' '           DDOPT
     C                   ENDIF
      *
      **  If an Action code entered, update SFL
      *
     C     V#RCS1        IFEQ      'Y'
     C                   UPDATE    GL1241S1
     C                   ENDIF
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRNEW  - ADDING NEW RECORD                                    *
      *****************************************************************
      *
     C     SRNEW         BEGSR
     C
     C                   MOVE      *OFF          *IN82                          PC AND RI
     C                   MOVE      *OFF          *IN83                          PC AND RI
     C                   MOVE      *OFF          *INKC                          F3
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *BLANK        DDCODE                         INZ
     C                   MOVE      *BLANK        DDSETN                         INZ
     C                   MOVE      *ON           *IN27                          Insert
      *
      **  Clear message subfile
      *
     C                   EXSR      SRCLRM
      *
      **  Add record cycle
      *
     C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF
     C                   WRITE     GL1241M0                                     Message CTL
     C                   EXFMT     GL1241A1
     C
     C                   MOVE      *OFF          *IN82                          PC AND RI
     C                   MOVE      *OFF          *IN83                          PC AND RI
      *
      **  Clear message subfile
      *
     C                   EXSR      SRCLRM
      *
      **  Pressed F3 or F12 Key
      *
     C                   IF        *INKC = *ON OR
     C                             *INKL = *ON
     C                   ITER
     C                   ENDIF
      *
      **  CHeck the RWA code & RWA Set Id
      *
     C                   IF        DDCODE = '? ' OR
     C                             DDCODE = ' ?' OR
     C                             DDSETN = '?'
     C                   CALLB     'SD001243'
     C                   PARM      *BLANK        RTCD              1
     C                   PARM      *BLANK        P#CODE            2
     C                   PARM      *BLANK        P#SETN            1
     C
     C                   IF        RTCD = *BLANK
     C                   MOVE      P#CODE        DDCODE
     C                   MOVE      P#SETN        DDSETN
     C                   ELSE
     C                   MOVE      'SDRWACL1'    DBFILE                         ***************
     C                   Z-ADD     3             DBASE                          * DB ERROR 03 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ITER
     C                   ENDIF
      *
      **  Check the RWA code (Exist)
      *
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     DDCODE        SETLL     SDRWACL1
     C     *IN01         DOWEQ     *OFF
     C     DDCODE        READE     SDRWACL1                               01
     C                   IF        *IN01
     C                   ITER
     C                   ENDIF
     C
     C                   IF        CORWCODE = DDCODE AND
     C                             CORWRECI = *BLANK                            Live Rec.
     C                   MOVE      *ON           *IN02
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C
     C                   IF        *IN02 = *OFF
      *
      **  Invalid value, enter '?'
      *
     C                   MOVE      'USR1002'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN83
     C                   ITER
     C                   ENDIF
      *
      **  Check the RWA Set Id (Blank)
      *
     C                   IF        DDSETN = *BLANK
      *
      **  Invalid value, enter '?'
      *
     C                   MOVE      'USR1002'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN82
     C                   ITER
     C                   ENDIF
      *
      **  Check the RWA Set Id (exist)
      *
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     DDSETN        SETLL     SDRWASL1
     C     *IN01         DOWEQ     *OFF
     C     DDSETN        READE     SDRWASL1                               01
     C                   IF        *IN01
     C                   ITER
     C                   ENDIF
     C
     C                   IF        *IN01 = *OFF AND
     C                             S1RWRECI = *BLANK
     C                   MOVE      *ON           *IN02
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C
     C                   IF        *IN02 = *OFF
      *
      **  Invalid value, enter '?'
      *
     C                   MOVE      'USR1002'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN82
     C                   ITER
     C                   ENDIF
      *
      **  Check the RWA code & RWA Set Id (combination with customer)
      *
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     K#COLA        SETLL     GLORWAL0
     C     *IN01         DOWEQ     *OFF
     C     K#COLA        READE     GLORWAL0                               01
     C                   IF        *IN01 = *OFF      AND
     C                             L0RWRECI = *BLANK
     C                   MOVE      *ON           *IN02
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C
     C                   IF        *IN02 = *ON
      *
      **  RWA Code & Set ID combination already exists
      *
     C                   MOVE      'USR9382'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN82
     C                   MOVE      *ON           *IN83
     C                   ITER
     C                   ENDIF
      *
      **  All is OK, write records
      *
     C                   EXSR      WRIREC
      *
      **  Set variable to build SFL
      *
     C                   MOVE      'Y'           V#BLD
      *
      **  Set F12 Key to leave the cycle
      *
     C                   MOVE      *ON           *INKL
     C                   ENDDO
     C
     C                   MOVE      *OFF          *INKL                          F12 KEY
     C                   MOVE      *OFF          *IN27                          INSERT
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRDEL - DELETE A RECORD                                       *
      *****************************************************************
      *
     C     SRDEL         BEGSR
     C
     C                   MOVE      *OFF          *IN82                          PC AND RI
     C                   MOVE      *OFF          *IN83                          PC AND RI
     C                   MOVE      *OFF          *INKC                          F3
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *ON           *IN24                          Delete Attrib.
      *
      **  Delete record
      *
     C                   DOW       *INKC = *OFF AND                             F3
     C                             *INKL = *OFF AND                             F12
     C                             *INKJ = *OFF                                 F10
      *
      **  Clear message subfile
      *
     C                   EXSR      SRCLRM
      *
      **  Press F10 to confirm delete
      *
     C                   MOVE      'ASM0028'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C
     C                   WRITE     GL1241M0                                     Message CTL
     C                   EXFMT     GL1241A1
      *
      **  Clear message subfile
      *
     C                   EXSR      SRCLRM
      *
      **  Pressed F3 or F12 Key
      *
     C                   IF        *INKC = *ON OR
     C                             *INKL = *ON
     C                   ITER
     C                   ELSE
      *
      **  Pressed F10 Key
      *
     C                   IF        *INKJ = *ON
      *
      **  GLORWAL0   /* PREFIX(L0) RENAME(SDCRWAD0:RSDCRWAD0) */
      *
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     K#COLA        SETLL     GLORWAL0
     C     *IN01         DOWEQ     *OFF
     C     K#COLA        READE     GLORWAL0                               01
     C                   IF        *IN01 = *OFF      AND
     C                             L0RWRECI = *BLANK
     C                   DELETE    RGLORWAD0                            02
     C
     C                   IF        *IN02
     C                   MOVE      'GLORWAL0'    DBFILE                         ***************
     C                   Z-ADD     4             DBASE                          * DB ERROR 04 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
 
     C                   EVAL      RWAUpd = 'Y'
     C                   ENDIF
     C                   ENDDO
      *
      **  Set Variable To Build SFL
      *
     C                   MOVE      'Y'           V#BLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *OFF          *INKJ                          F10
     C                   MOVE      *OFF          *IN24                          Delete Attrib.
     C                   EVAL      V#ACT1 = *blank
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * WRIREC - WRITE AN RECORDS                                     *
      *****************************************************************
      *
     C     WRIREC        BEGSR
      *
      **  GLORWAL0
      *
     C                   MOVE      *BLANK        L0RWRECI
     C                   MOVEL(P)  DDCREF        L0RWCREF
     C                   MOVE      DDCODE        L0RWCODE
     C                   MOVE      DDSETN        L0RWSETN
     C                   MOVE      'I'           L0RWCHTP
     C                   Z-ADD     AGRDNB        L0RWLCD
     C                   WRITE     RGLORWAD0                            01
     C
     C                   IF        *IN01
     C                   MOVE      'GLORWAL0'    DBFILE                         ***************
     C                   Z-ADD     5             DBASE                          * DB ERROR 05 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      **  All Is OK
      *
     C                   EVAL      RWAUpd = 'Y'
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRSNDMSG - Send Message To The Program Message Queue          *
      * --------                                                      *
      * Called by:                                                    *
      * Calls: None                                                   *
      *****************************************************************
      *
     C     SRSENDMSG     BEGSR
     C
     C                   IF        ZAMSGF = *BLANKS
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   ENDIF
     C
     C                   CALL      'Y2SNMGC'
     C                   PARM      PSProcName    ZAPGM            10
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM      *BLANK        ZAMSTP
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRCLRM - CLEAR MESSAGE SUBFILE                                *
      * ------                                                        *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     SRCLRM        BEGSR
     C
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSProcName    ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
     C
     C                   ENDSR
      *
