     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Risk Weighted Assets Sets Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - SD Module                                            *
      *                                                               *
      *  SD001240  - Risk Weighted Assets Sets Maintenance            *
      *                                                               *
      *  Function:  This program records valid Risk Weighted          *
      *             Assets Sets.                                      *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 TDA035             Date 02Apr04               *
      *                 CGL018  *CREATE    Date 17Sep02               *
      *                 XXXXXX             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL018 - Risk Weighted Assets                                *
      *  XXXXXX -                                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
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
      **  Risk Weighted Assets Calculation Methods
      *
     FSDRWACALPDIF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CM)
      *
      **  Risk Weighted Asset Master File Retrieval Index
      *
     FSDRWASL1  IF   E           K DISK    INFSR(*PSSR)
      *
      **  Risk Weighted Asset Master File Update Index
      *
     FSDRWASL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDRWASD0:RSDRWASL0)
     F                                     COMMIT
      *
      **  Risk Weighted Asset Codes Master File Update Index
      *
     FSDRWACL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(C_)
     F                                     COMMIT
      *
      **  Risk Weighted Assets Sets Maintenance Display
      *
     FSD001240DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SD1240S1:DDSFRN)
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
      ** External DS For Bank Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D MUSER         E DS                  EXTNAME(MUSERDD)
     D                                     PREFIX(U)
 
      ** EXTERNAL DS FOR USER DETAILS
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      **  LDA Definition
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
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
      *
     C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF
      *
      **  Reading Records
      *
     C                   EXSR      SETSCR
     C                   ENDDO
      *
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
      *
      **  Initialise LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD001240  '  DBPGM
     C                   OUT       LDA
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
     C                   Z-ADD     001           DBASE                          * DB ERROR 01 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
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
     C                   MOVEL     'SDUSRMSG'    ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *BLANK        ZAMSID            7
     C                   MOVEL     *BLANK        ZAMSDA          132
     C                   MOVEL     *BLANK        ZAMSTP            7
      *
      **  Set Display Variables
      *
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWID = PSJobName
     C                   EVAL      DDPGMQ = PSProcPgm
      *
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
      *
      **  Set SFLMSG IND.
      *
     C                   MOVE      *ON           *IN91
      *
      **  Key To SDRWACL0.
      *
     C     K#COL0        KLIST
     C                   KFLD                    DDCODE            2
     C                   KFLD                    DDSETN
      *
      ** -----------------------------------------------------------                          XXXXXX
      ** * This Code Is For Future Switchable Feature.       BEGIN *                          XXXXXX
      ** -----------------------------------------------------------                          XXXXXX
      *                                                                                       XXXXXX
      ** Access SAR details file to determine if XXXXXX is on.                                XXXXXX
      *                                                                                       XXXXXX
     C                   CALL      'AOSARDR0'                                                 XXXXXX
     C                   PARM      *BLANKS       @RTCD                                        XXXXXX
     C                   PARM      '*VERIFY'     @OPTN                                        XXXXXX
     C                   PARM      'XXXXXX'      @SARD                                        XXXXXX
     C     SCSARD        PARM      SCSARD        DSFDY                                        XXXXXX
      *                                                                                       XXXXXX
      ** Database Error                                                                       XXXXXX
      *                                                                                       XXXXXX
     C     @RTCD         IFNE      *BLANKS                                                    XXXXXX
     C     @RTCD         ANDNE     '*NRF   '                                                  XXXXXX
     C                   MOVEL     'SCSARDPD'    DBFILE                         **************XXXXXX
     C                   Z-ADD     13            DBASE                          * DB ERROR 13 XXXXXX
     C                   MOVEL     'XXXXXX'      DBKEY                          **************XXXXXX
     C                   EXSR      *PSSR                                                      XXXXXX
     C                   END                                                                  XXXXXX
      *                                                                                       XXXXXX
     C     @RTCD         IFEQ      *BLANK                                                     XXXXXX
     C                   MOVEL     'Y'           XXXXXX            1                          XXXXXX
     C                   MOVE      *OFF          *IN84                                        XXXXXX
     C                   ELSE                                                                 XXXXXX
     C                   MOVEL     'N'           XXXXXX                                       XXXXXX
     C                   MOVE      *ON           *IN84                                        XXXXXX
     C                   END                                                                  XXXXXX
      *                                                                                       XXXXXX
      ** -----------------------------------------------------------                          XXXXXX
      ** * This Code Is For Future Switchable Feature.       END   *                          XXXXXX
      ** -----------------------------------------------------------                          XXXXXX
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
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
      **  Any Error, Do Rollback
      *
     C                   ROLBK
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
     C                   WRITE     SD1240M0                                     Message CTL
      *
      **  Show Subfile Screen
      *
     C     V#SFR3        IFNE      0
     C                   EVAL      *IN80 = *off                                 CGL018
     C                   WRITE     SD1240F1
     C                   EXFMT     SD1240S0
     C
     C                   ELSE
      *
      **  No Record Screen
      *
     C                   MOVE      *ON           *IN80                          Text On Bottom SCR
     C                   WRITE     SD1240F1
     C                   EXFMT     SD1240N1
     C                   ENDIF
      *
      **  Clear Message Subfile
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
     C                   EXSR      VALOPT
     C                   dump
     C     WERR          IFNE      0
      *
      **  User is not authorised to this action code
      *
     C                   MOVE      'CSF9006'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   ELSE
     C                   EXSR      SRNEW
     C                   ENDIF
     C                   ITER
     C                   ENDIF
      *
      **  Check Subfile Action
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
      *
      **  Check Related Record
      *
     C                   MOVE      *OFF          *IN20
     C     *LOVAL        SETLL     SDRWACD0
     C     *IN20         DOWEQ     *OFF
     C                   READ      SDRWACD0                             1920
      *
      **  Error
      *
     C                   IF        *IN19
     C                   MOVE      'SDRWACL0'    DBFILE                         ***************
     C                   Z-ADD     002           DBASE                          * DB ERROR 02 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      **  EOF
      *
     C                   IF        *IN20
     C                   ITER
     C                   ENDIF
     C
     C                   IF        C_RWSETN = DDSETN AND
     C                             C_RWRECI = *BLANK AND                        LIVE RECORD
     C                             C_RWCODE <> *BLANK                           NOT DEFAULT
      *
      **  RWA codes already exist for this set
      *
     C                   MOVE      'USR9380'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C
     C                   IF        VALSFLOK = *BLANK
     C                   EXSR      SRDEL
     C                   ENDIF
     C
     C                   ENDIF
      *
      **       AMEND  ---------------------------------------
      *
     C                   IF        V#ACT1 = 'A'
     C                   EXSR      SRAMD
     C                   ENDIF
      *
      **       ENQUIRY --------------------------------------
      *
     C                   IF        V#ACT1 = 'E'
     C                   EXSR      SRENQ
     C                   ENDIF
     C
     C                   ENDIF
     C
     C                   ENDDO
     C
     C                   ENDSR
      *
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
     C                   WRITE     SD1240S0
     C                   MOVE      *OFF          *IN97
     C                   Z-ADD     DDSFRN        V#LARC            4 0
     C                   Z-ADD     0             DDSFRN
      *
      **  Read File Record, Write Into Subfile
      *
     C                   MOVE      *OFF          *IN25
     C     *LOVAL        SETLL     SDRWASL1
     C                   MOVE      ' '           V#RDB3            1
     C
     C     *IN25         DOUEQ     *ON
     C                   READ      SDRWASL1                               25
     C
     C     *IN25         IFEQ      *OFF
     C                   MOVE      'Y'           V#RDB3
     C                   MOVE      *ON           *IN26
      *
      **  Only Live Records
      *
     C                   IF        RWRECI = '*'
     C                   MOVE      *OFF          *IN26
     C                   ENDIF
      *
      **  IF *IN26 *ON (RECORD IS VALID) Record is written TO SFL
      *
     C     *IN26         IFEQ      *ON
     C                   MOVE      *BLANK        DDOPT
     C                   MOVE      RWSETN        DDSETN
     C                   MOVE      RWCALC        DDCALC
     C                   MOVE      RWDESC        DDDESC
     C
     C                   ADD       1             DDSFRN
     C                   WRITE     SD1240S1
     C                   ENDIF
     C
     C                   ENDIF
     C                   ENDDO
     C
     C                   Z-ADD     DDSFRN        V#SFR3            3 0
      *
      **  Set on the first Position
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
     C
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * VALSF - Validate Subfile Options                              *
      *****************************************************************
      *
     C     VALSFL        BEGSR
      *
      **  Set of Ind. and Variables
      *
     C                   MOVE      *OFF          *IN70
     C                   MOVE      'OLD'         V#MODE            3
     C                   Z-ADD     1             DDSFRN
     C                   MOVE      'N'           V#RCS1            1
     C                   MOVE      *off          *IN28
      *
      **  Subfile Read Cycle
      *
     C                   DOU       *IN28 = *ON OR
     C                             V#RCS1 = 'Y'
     C                   READC     SD1240S1                               28
     C
     C                   IF        *IN28 = *OFF
     C
     C                   IF        DDOPT  = *BLANK
     C                   UPDATE    SD1240S1
     C                   ELSE
      *
      **  Any Action Code
      *
     C                   MOVE      'Y'           V#RCS1
      *
      **  Save the Action Code to the Variable DDOPT
      *
     C                   MOVE      DDOPT         V#ACT1            1
      *
      **  Validate Option
      *
     C                   IF        DDOPT <> 'A' AND
     C                             DDOPT <> 'D' AND
     C                             DDOPT <> 'E'
      **  Action code must be one of A, D or E
     C                   MOVE      'CSF9853'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN92                          PC AND RI
     C
     C                   ELSE
     C
     C                   EXSR      VALOPT
     C     WERR          IFNE      0
      *
      **  User is not authorised to this action code
      *
     C                   MOVE      'CSF9006'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN92                          PC AND RI
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      *OFF          *IN92                          PC AND RI
     C
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDDO
      *
      **  If no record selected, validation VALSFLOK is set to 'N'
      *
     C                   IF        V#RCS1 = 'N'
     C                   MOVE      'N'           VALSFLOK
     C                   ENDIF
      *
      **  Check of selection criteria
      *
     C                   SETOFF                                       71
      *
      **  If an error found out, rebuild SFL
      *
     C     VALSFLOK      IFEQ      'N'
     C                   MOVE      *ON           *IN70
     C                   ELSE
     C                   MOVE      ' '           DDOPT
     C                   ENDIF
      *
      **  If an Action code entered, update of SFL
      *
     C     V#RCS1        IFEQ      'Y'
     C                   UPDATE    SD1240S1
     C                   ENDIF
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRNEW  - Adding New Record                                    *
      *****************************************************************
      *
     C     SRNEW         BEGSR
     C
     C                   MOVE      *OFF          *IN82                          PC AND RI
     C                   MOVE      *OFF          *IN83                          PC AND RI
     C                   MOVE      *OFF          *INKC                          F3
     C                   MOVE      *OFF          *INKL                          F12
      *
     C                   IF        XXXXXX = 'Y'                                               XXXXXX
     C                   MOVE      *BLANK        DDCALC                         INZ           XXXXXX
     C                   ELSE                                                                 XXXXXX
     C                   MOVE      '1'           DDCALC                         Default Value XXXXXX
     C                   ENDIF                                                                XXXXXX
      *
     C                   MOVE      *BLANK        DDSETN                         INZ
     C                   MOVE      *BLANK        DDDESC                         INZ
     C                   MOVE      *ON           *IN27                          Insert
      *
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
      *
      **  Add Record Cycle
      *
     C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF
     C                   WRITE     SD1240M0                                     Message CTL
     C                   EXFMT     SD1240A1
     C
     C                   MOVE      *OFF          *IN82                          PC AND RI
     C                   MOVE      *OFF          *IN83                          PC AND RI
      *
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
      *
      **  F3 or F12 Key Pressed
      *
     C                   IF        *INKC = *ON OR
     C                             *INKL = *ON
     C                   ITER
     C                   ENDIF
      *
      **  Check Set Id
      *
     C                   IF        DDSETN = *BLANK
     C                   MOVE      *ON           *IN82
     C                   ITER
     C                   ENDIF
     C
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     DDSETN        SETLL     SDRWASL1
     C     *IN01         DOWEQ     *OFF
     C     DDSETN        READE     SDRWASL1                               01
     C                   IF        *IN01 = *OFF AND
     C                             RWRECI = *BLANK
     C                   MOVE      *ON           *IN02
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C
     C                   IF        *IN02
      *
      **  RWA Set ID already exists
      *
     C                   MOVE      'USR9381'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN82
     C                   ITER
     C                   ENDIF
      *
      **  Check the Calculation Method (*Blank)
      *
     C                   IF        DDCALC = *BLANK
      *
      **  Calculation Method does not exists
      *
     C                   MOVE      'USR9383'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN83
     C                   ITER
     C                   ENDIF
      *
      ** -----------------------------------------------------------                          XXXXXX
      ** * This Code Is For Future Switchable Feature.       BEGIN *                          XXXXXX
      ** -----------------------------------------------------------                          XXXXXX
      *                                                                                       XXXXXX
      **  Check the Calculation Method (Exist)                                                XXXXXX
      *                                                                                       XXXXXX
     C                   IF        XXXXXX = 'Y'                                               XXXXXX
      *                                                                                       XXXXXX
     C                   MOVE      *OFF          *IN01                                        XXXXXX
     C                   MOVE      *OFF          *IN02                                        XXXXXX
     C     DDCALC        SETLL     SDRWACALPD                                                 XXXXXX
     C     *IN01         DOWEQ     *OFF                                                       XXXXXX
     C     DDCALC        READE     SDRWACALPD                             01                  XXXXXX
     C                   IF        *IN01 = *OFF AND                                           XXXXXX
     C                             CMRWRECI = *BLANK                                          XXXXXX
     C                   MOVE      *ON           *IN02                                        XXXXXX
     C                   LEAVE                                                                XXXXXX
     C                   ENDIF                                                                XXXXXX
     C                   ENDDO                                                                XXXXXX
     C                                                                                        XXXXXX
     C                   IF        *IN02 = *OFF                                               XXXXXX
      *                                                                                       XXXXXX
      **  Calculation Method does not exists                                                  XXXXXX
      *                                                                                       XXXXXX
     C                   MOVE      'USR9383'     ZAMSID                                       XXXXXX
     C                   EXSR      SRSENDMSG                                                  XXXXXX
     C                   MOVE      *ON           *IN83                                        XXXXXX
     C                   ITER                                                                 XXXXXX
     C                   ENDIF                                                                XXXXXX
      *                                                                                       XXXXXX
     C                   ENDIF                                                                XXXXXX
      *                                                                                       XXXXXX
      ** -----------------------------------------------------------                          XXXXXX
      ** * This Code Is For Future Switchable Feature.       END   *                          XXXXXX
      ** -----------------------------------------------------------                          XXXXXX
      *
      **  All OK, write Records
      *
     C                   EXSR      WRIREC
      *
      **  Set Variable to build SFL
      *
     C                   MOVE      'Y'           V#BLD
      *
      **  Set F12 Key to leave the Cycle
      *
     C                   MOVE      *ON           *INKL
     C                   ENDDO
     C
     C                   MOVE      *OFF          *INKL                          F12 Key
     C                   MOVE      *OFF          *IN27                          Insert
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRDEL - Delete a Record                                       *
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
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
      *
      **  Press F10 to confirm delete
      *
     C                   MOVE      'ASM0028'     ZAMSID
     C                   EXSR      SRSENDMSG
     C
     C                   WRITE     SD1240M0                                     Message CTL
     C                   EXFMT     SD1240A1
      *
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
      *
      **  F3 or F12 key pressed
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
      **  Find related Records and Mark them deleted
      *
      **  SDRWASPD
      *
     C                   MOVE      *OFF          *IN20
     C     *LOVAL        SETLL     RSDRWASL0
     C     *IN20         DOWEQ     *OFF
     C                   READ      RSDRWASL0                            1920
      *
      **  Error
      *
     C                   IF        *IN19
     C                   MOVE      'SDRWASL0'    DBFILE                         ***************
     C                   Z-ADD     003           DBASE                          * DB ERROR 03 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      **  EOF
      *
     C                   IF        *IN20
     C                   ITER
     C                   ENDIF
     C
     C                   IF        RWSETN = DDSETN AND
     C                             RWRECI = *BLANK                              Live Record
     C                   MOVE      '*'           RWRECI
     C                   MOVE      'D'           RWCHTP
     C                   Z-ADD     AGRDNB        RWLCD
     C
     C                   UPDATE    RSDRWASL0                            01
     C                   IF        *IN01
     C                   MOVE      'SDRWASL0'    DBFILE                         ***************
     C                   Z-ADD     004           DBASE                          * DB ERROR 04 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDDO
      *
      **  SDRWACPD
      *
     C                   MOVE      *OFF          *IN20
     C     *LOVAL        SETLL     SDRWACD0
     C     *IN20         DOWEQ     *OFF
     C                   READ      SDRWACD0                             1920
      *
      **  Error
      *
     C                   IF        *IN19
     C                   MOVE      'SDRWACL0'    DBFILE                         ***************
     C                   Z-ADD     005           DBASE                          * DB ERROR 05 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      **  EOF
      *
     C                   IF        *IN20
     C                   ITER
     C                   ENDIF
     C
     C                   IF        C_RWSETN = DDSETN AND
     C                             C_RWRECI = *BLANK                            Live Record
     C                   MOVE      '*'           C_RWRECI
     C                   MOVE      'D'           C_RWCHTP
     C                   Z-ADD     AGRDNB        C_RWLCD
     C
     C                   UPDATE    SDRWACD0                             01
     C                   IF        *IN01
     C                   MOVE      'SDRWACPD'    DBFILE                         ***************
     C                   Z-ADD     006           DBASE                          * DB ERROR 06 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDDO
      *
      **  Set Variable to build SFL
      *
     C                   MOVE      'Y'           V#BLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *OFF          *INKJ                          F10
     C                   MOVE      *OFF          *IN24                          Delete Attrib.
      *
      **  All Is OK
      *
     C                   COMMIT
     C
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * SRAMD - Amend Record                                          *
      *****************************************************************
      *
     C     SRAMD         BEGSR
     C
     C                   MOVE      *OFF          *IN82                          PC AND RI
     C                   MOVE      *OFF          *IN83                          PC AND RI
     C                   MOVE      *OFF          *INKC                          F3
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *ON           *IN22                          Amend Attrib.
      *
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
      *
      **  Amend Record
      *
     C                   DOW       *INKC = *OFF AND                             F3
     C                             *INKL = *OFF AND                             F12
     C                             *INKJ = *OFF                                 F10
     C                   WRITE     SD1240M0                                     Message CTL
     C                   EXFMT     SD1240A1
      *
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
      *
      **  F3 or F12 Key pressed
      *
     C                   IF        *INKC = *ON OR
     C                             *INKL = *ON
     C                   ITER
     C                   ENDIF
      *
      **  Check the Calculation Method (*Blank)
      *
     C                   IF        DDCALC = *BLANK
      *
      **  Calculation Method does not exists
      *
     C                   MOVE      'USR9383'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN83
     C                   ITER
     C                   ENDIF
      *
      ** -----------------------------------------------------------                          XXXXXX
      ** * This Code Is For Future Switchable Feature.       BEGIN *                          XXXXXX
      ** -----------------------------------------------------------                          XXXXXX
      *                                                                                       XXXXXX
      **  Check the Calculation Method (Exist)                                                XXXXXX
      *                                                                                       XXXXXX
     C                   IF        XXXXXX = 'Y'                                               XXXXXX
      *                                                                                       XXXXXX
     C                   MOVE      *OFF          *IN01                                        XXXXXX
     C                   MOVE      *OFF          *IN02                                        XXXXXX
     C     DDCALC        SETLL     SDRWACALPD                                                 XXXXXX
     C     *IN01         DOWEQ     *OFF                                                       XXXXXX
     C     DDCALC        READE     SDRWACALPD                             01                  XXXXXX
     C                   IF        *IN01 = *OFF AND                                           XXXXXX
     C                             CMRWRECI = *BLANK                                          XXXXXX
     C                   MOVE      *ON           *IN02                                        XXXXXX
     C                   LEAVE                                                                XXXXXX
     C                   ENDIF                                                                XXXXXX
     C                   ENDDO                                                                XXXXXX
     C                                                                                        XXXXXX
     C                   IF        *IN02 = *OFF                                               XXXXXX
      *                                                                                       XXXXXX
      **  Calculation Method does not exists                                                  XXXXXX
      *                                                                                       XXXXXX
     C                   MOVE      'USR9383'     ZAMSID                                       XXXXXX
     C                   EXSR      SRSENDMSG                                                  XXXXXX
     C                   MOVE      *ON           *IN83                                        XXXXXX
     C                   ITER                                                                 XXXXXX
     C                   ENDIF                                                                XXXXXX
      *                                                                                       XXXXXX
     C                   ENDIF                                                                XXXXXX
      *                                                                                       XXXXXX
      ** -----------------------------------------------------------                          XXXXXX
      ** * This Code Is For Future Switchable Feature.       END   *                          XXXXXX
      ** -----------------------------------------------------------                          XXXXXX
      *
      **  Find related Records and Mark them deleted
      *
      **  SDRWASPD
      *
     C                   MOVE      *OFF          *IN20
     C     *LOVAL        SETLL     RSDRWASL0
     C     *IN20         DOWEQ     *OFF
     C                   READ      RSDRWASL0                            1920
      *
      **  Error
      *
     C                   IF        *IN19
     C                   MOVE      'SDRWASL0'    DBFILE                         ***************
     C                   Z-ADD     007           DBASE                          * DB ERROR 07 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      **  EOF
      *
     C                   IF        *IN20
     C                   ITER
     C                   ENDIF
     C
     C                   IF        RWSETN = DDSETN AND
     C                             RWRECI = *BLANK                              Live Record
     C                   MOVEL(P)  DDDESC        RWDESC
     C                   MOVE      'A'           RWCHTP
     C                   Z-ADD     AGRDNB        RWLCD
     C                   UPDATE    RSDRWASL0                            01
     C
     C                   IF        *IN01
     C                   MOVE      'SDRWASL0'    DBFILE                         ***************
     C                   Z-ADD     008           DBASE                          * DB ERROR 08 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDDO
      *
      **  Set Variable to build SFL
      *
     C                   MOVE      'Y'           V#BLD
     C                   LEAVE
     C                   ENDDO
     C
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *OFF          *IN22                          Amend Attrib.
      *
      **  All Is OK
      *
     C                   COMMIT
     C
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * SRENQ - Enquiry                                               *
      *****************************************************************
      *
     C     SRENQ         BEGSR
     C
     C                   MOVE      *OFF          *IN82                          PC AND RI
     C                   MOVE      *OFF          *IN83                          PC AND RI
     C                   MOVE      *OFF          *INKC                          F3
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *ON           *IN29                          Display Attrib.
      *
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
      *
      **  Display Record
      *
     C                   DOW       *INKC = *OFF AND                             F3
     C                             *INKL = *OFF                                 F12
     C                   WRITE     SD1240M0                                     Message CTL
     C                   EXFMT     SD1240A1
      *
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
     C                   ENDDO
     C
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *OFF          *IN29                          Amend Attrib.
     C
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * VALOPT - VALIDATE OPTION                                      *
      *****************************************************************
      *
     C     VALOPT        BEGSR
     C
     C     AGMBIN        IFEQ      'N'
     C                   CALL      'ZVACTU'
     C                   PARM      DDOPT         WACTN             1
     C                   PARM                    WERR              1 0
      *
      **  else Multientity System, so check user is authorised to
      **  Action for Default Branch
      *
     C                   ELSE
      *
     C                   CALL      'AOUSERR0'
     C                   PARM                    UReturn           7
     C                   PARM      '*KEY'        UOption           7
     C                   PARM      DDUSER        UUserID          10
     C     MUSER         PARM      MUSER         DSFDY
     C
     C                   CALL      'ZVACTBU'
     C                   PARM      DDOPT         WACTN
     C                   PARM      UDBRN         WZBR              3
     C                   PARM                    WERR
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *
      *****************************************************************
      * WRIREC - Write An Records                                     *
      *****************************************************************
      *
     C     WRIREC        BEGSR
      *
      **  SDRWASL0 - Try To Update Existing
      *
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     DDSETN        SETLL     RSDRWASL0
     C     *IN01         DOWEQ     *OFF
     C     DDSETN        READE     RSDRWASL0                              01
     C                   IF        *IN01 = *OFF AND
     C                             RWRECI = '*'
     C                   MOVE      *ON           *IN02
     C                   MOVE      *BLANK        RWRECI
     C                   MOVE      DDSETN        RWSETN
     C                   MOVE      DDCALC        RWCALC
     C                   MOVEL(P)  DDDESC        RWDESC
     C                   MOVE      'I'           RWCHTP
     C                   Z-ADD     AGRDNB        RWLCD
     C                   UPDATE    RSDRWASL0                            03
     C
     C                   IF        *IN03
     C                   MOVE      'SDRWASL0'    DBFILE                         ***************
     C                   Z-ADD     009           DBASE                          * DB ERROR 09 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      **  SDRWASL0 - If *IN02 Still *OFF Write a Record
      *
     C                   IF        *IN02 = *OFF
     C                   MOVE      *BLANK        RWRECI
     C                   MOVE      DDSETN        RWSETN
     C                   MOVE      DDCALC        RWCALC
     C                   MOVEL(P)  DDDESC        RWDESC
     C                   MOVE      'I'           RWCHTP
     C                   Z-ADD     AGRDNB        RWLCD
     C                   WRITE     RSDRWASL0                            03
     C
     C                   IF        *IN03
     C                   MOVE      'SDRWASL0'    DBFILE                         ***************
     C                   Z-ADD     10            DBASE                          * DB ERROR 10 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
      *
      **  SDRWACL0 - Try To Update Existing
      *
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C                   MOVE      *BLANK        DDCODE
     C     K#COL0        SETLL     SDRWACL0
     C     *IN01         DOWEQ     *OFF
     C     K#COL0        READE     SDRWACL0                               01
     C                   IF        *IN01 = *OFF AND
     C                             C_RWRECI = '*'
     C                   MOVE      *ON           *IN02
     C                   MOVE      *BLANK        C_RWRECI
     C                   MOVE      *BLANK        C_RWCODE
     C                   MOVE      DDSETN        C_RWSETN
     C                   Z-ADD     100           C_RWRWAP
     C                   EVAL      C_RWCDESC = 'Default code for set ' +
     C                             C_RWSETN
     C                   MOVE      'I'           C_RWCHTP
     C                   Z-ADD     AGRDNB        C_RWLCD
     C                   UPDATE    SDRWACD0                             03
     C
     C                   IF        *IN03
     C                   MOVE      'SDRWACL0'    DBFILE                         ***************
     C                   Z-ADD     11            DBASE                          * DB ERROR 11 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      **  SDRWACL0 - If *IN02 Still *OFF Write a Record
      *
     C                   IF        *IN02 = *OFF
     C                   MOVE      *BLANK        C_RWRECI
     C                   MOVE      *BLANK        C_RWCODE
     C                   MOVE      DDSETN        C_RWSETN
     C                   Z-ADD     100           C_RWRWAP
     C                   EVAL      C_RWCDESC = 'Default code for set ' +
     C                             C_RWSETN
     C                   MOVE      'I'           C_RWCHTP
     C                   Z-ADD     AGRDNB        C_RWLCD
     C                   WRITE     SDRWACD0                             03
     C
     C                   IF        *IN03
     C                   MOVE      'SDRWACL0'    DBFILE                         ***************
     C                   Z-ADD     12            DBASE                          * DB ERROR 12 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
      *
      **  All Is OK
      *
     C                   COMMIT
      *
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
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   ENDIF
     C
     C                   CALL      'Y2SNMGC'
     C                   PARM      PSProcPgm     ZAPGM            10
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM      *BLANK        ZAMSDA
     C                   PARM      *BLANK        ZAMSTP
     C
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * SRCLRM - Clear Message Subfile                                *
      * ------                                                        *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     SRCLRM        BEGSR
     C
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSPROCPGM     ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
     C
     C                   ENDSR
      *
**  CPY@
(c) Finastra International Limited 2003
