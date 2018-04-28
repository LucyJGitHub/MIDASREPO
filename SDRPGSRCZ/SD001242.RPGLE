     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer risk weighted asset codes maint')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001242  - Customer Risk Weighted Assets Codes Maintenance  *
      *                                                               *
      *  Function:  This program records valid Risk Weighted          *
      *             Assets Sets.                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. CSD079             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 BUG5139            Date 10Mar05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 TDA035             Date 02Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL018  *CREATE    Date 17Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API (Recompile)       *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  BUG5139 - Unable to process additional customer during       *
      *            insert                                             *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL018 - Risk Weighted Assets                                *
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
      **  Customer Risk Weighted Asset Master File Retr. Ind
      *
     FSDCRWAL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L1)
      *
      **  Customer Risk Weighted Asset Master File Update In
      *
     FSDCRWAL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L0)
     F                                     RENAME(SDCRWAD0:RSDCRWAD0)
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
                                                                                             BUG5139
      ** RTV : Customer Details Shadow file by key                                           BUG5139
                                                                                             BUG5139
     FSDCDSHL1  IF   E           K DISK    INFSR(*PSSR)                                      BUG5139
     F                                     RENAME(@BBREBF:@BBREBFZ)                          BUG5139
     F                                     PREFIX(CD)                                        BUG5139
      *
      **  Risk Weighted Assets Sets Maintenance Display
      *
     FSD001242DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SD1242S1:DDSFRN)
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
 
     D MUSER         E DS                  EXTNAME(MUSERDD)
     D                                     PREFIX(U)
 
      ** EXTERNAL DS FOR USER DETAILS
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
 
      ** External DS for SAR details                                                          CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
                                                                                              CSC022
      ** External DS for Commitment Control Data Area                                         CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitjobs             4    103                                                       CSC022
                                                                                              CSC022
      ** Commitment Control Array                                                             CSC022
     D wComitarr       S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
                                                                                              CSC022
      ** Commitment Control Variables                                                         CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wSkip           S              1A   INZ('N')                                           CSC022
      ** Fields defined for BUG5139                                                          BUG5139
     D WBCSSN          S                   LIKE(DDSHTN)                                      BUG5139
     D WBCRNM          S                   LIKE(DDSCRN)                                      BUG5139
     D WBCNA2          S                   LIKE(DDCNA2)                                      BUG5139
 
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
     C                   PARM                    P#RTCD            1
     C                   PARM                    DDCUST
     C                   PARM                    ACTION            1
     C                   PARM                    WBCSSN                                      BUG5139
     C                   PARM                    WBCRNM                                      BUG5139
     C                   PARM                    WBCNA2                                      BUG5139
      *
      **  Transfer Action Code from calling program
      *
     C                   IF        ACTION = 'E'
     C                   EVAL      *IN79 = *ON
     C                   ENDIF
      *
      **  Initialise LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBPGM
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
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      ** Access SAR details file to determine if CSC022 is on.                                CSC022
      *                                                                                       CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD             7                          CSC022
     C                   Parm      '*VERIFY'     @OPTN             7                          CSC022
     C                   Parm      'CSC022'      @SARD             6                          CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
      ** Database Error                                                                       CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> *BLANKS and                                       CSC022
     C                             @RTCD <> '*NRF   '                                         CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBASE = 6                                                  CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *BLANK                                             CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        Comitnum > 0                                               CSC022
     C                   MoveA     wComitjobs    wComitarr                                    CSC022
     C     psJobname     Lookup    wComitarr                              10                  CSC022
     C                   If        *IN10                                                      CSC022
     C                   Eval      wSkip = 'Y'                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CSC022
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
      **  Set SFLMSG Indicator
      *
     C                   MOVE      *ON           *IN91
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
     C                   If        CSC022 = 'N' or                                            CSC022
     C                             (wSkip = 'N' and CSC022 = 'Y')                             CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
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
     C                   MOVE      'Y'           V#CLRM            1
     C                   MOVE      'Y'           V#BLD             1
     C
 B1  C                   DOW       *INKC = *OFF AND
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
     C                   WRITE     SD1242M0                                     Message CTL
      *
      **  Show Subfile Screen
      *
 B2  C     V#SFR3        IFNE      0
     C                   EVAL      *IN80 = *off
     C                   WRITE     SD1242F1
     C                   EXFMT     SD1242S0
     C
 X2  C                   ELSE
      *
      **  No Record Screen
      *
     C                   MOVE      *ON           *IN80                          Text On Bottom Scr
     C                   WRITE     SD1242F1
     C                   EXFMT     SD1242N1
 E2  C                   ENDIF
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
 B2  C                   IF        VALSFLOK = *BLANK
      *
      **       DELETE ---------------------------------------
      *
     C                   IF        V#ACT1 = 'D'
     C                   MOVE      'D'           DDOPT
      *
     C                   EXSR      SRDEL
     C                   ELSE
     C                   MOVE      'E'           DDOPT
     C                   ENDIF
     C
 E2  C                   ENDIF
     C
 E1  C                   ENDDO
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
     C                   WRITE     SD1242S0
     C                   MOVE      *OFF          *IN97
     C                   Z-ADD     DDSFRN        V#LARC            4 0
     C                   Z-ADD     0             DDSFRN
      *
      **  Read the record from the file, write the record to the subfile
      *
     C                   MOVE      *OFF          *IN25
     C     DDCUST        SETLL     SDCRWAL1                                     Live Rec.
     C                   MOVE      ' '           V#RDB3            1
     C
 B1  C     *IN25         DOUEQ     *ON
     C     DDCUST        READE     SDCRWAL1                               25
     C
 B2  C                   IF        *IN25 = *OFF   AND
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
     C                   WRITE     SD1242S1
     C                   ENDIF
     C
 E2  C                   ENDIF
 E1  C                   ENDDO
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
      **  Find Out Relevant Details
      *
     C     DDCUST        CHAIN     SDCDSHL1                           01                     BUG5139
     C                   IF        *IN01                                                     BUG5139
                                                                                             BUG5139
     C     ACTION        IFNE      'I'                                                       BUG5139
     C     DDCUST        CHAIN     SDCUSTL1                           01
     C                   IF        *IN01
     C                   MOVE      'SDCUSTL1'    DBFILE                         ***************
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C
     C                   MOVEL(P)  CUBBCSSN      DDSHTN
     C                   MOVEL(P)  CUBBCRNM      DDSCRN
     C                   MOVEL(P)  CUBBCNA2      DDCNA2
     C                   ELSE                                                                BUG5139
     C                   MOVEL     WBCSSN        DDSHTN                                      BUG5139
     C                   MOVEL     WBCRNM        DDSCRN                                      BUG5139
     C                   MOVEL     WBCNA2        DDCNA2                                      BUG5139
     C                   ENDIF                                                               BUG5139
                                                                                             BUG5139
     C                   ELSE                                                                BUG5139
     C                   MOVEL(P)  CDBBCSSN      DDSHTN                                      BUG5139
     C                   MOVEL(P)  CDBBCRNM      DDSCRN                                      BUG5139
     C                   MOVEL(P)  CDBBCNA2      DDCNA2                                      BUG5139
     C                   ENDIF                                                               BUG5139
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
      *
      **  Subfile read cycle
      *
 B1  C                   DOU       *IN28 = *ON OR
     C                             V#RCS1 = 'Y'
     C                   READC     SD1242S1                               28
     C
 B2  C                   IF        *IN28 = *OFF
     C
 B3  C                   IF        DDOPT  = *BLANK
     C                   UPDATE    SD1242S1
 X3  C                   ELSE
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
 B4  C                   IF        DDOPT <> 'D'
      *
      **  Invalid action code: must be D or blank
      *
     C                   MOVE      'ASM0058'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN92                          PC AND RI
     C
 X4  C                   ELSE
     C
 E4  C                   ENDIF
     C                   MOVE      *OFF          *IN92                          PC AND RI
     C
 E3  C                   ENDIF
 E2  C                   ENDIF
     C
 E1  C                   ENDDO
      *
      **  No record selected, validation VALSFLOK is set to 'N'
      *
     C                   IF        V#RCS1 = 'N'
     C                   MOVE      'N'           VALSFLOK
     C                   ENDIF
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
     C                   UPDATE    SD1242S1
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
 B1  C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF
     C                   WRITE     SD1242M0                                     Message CTL
     C                   EXFMT     SD1242A1
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
 B2  C                   IF        DDCODE = '? ' OR
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
 E2  C                   ENDIF
      *
      **  Check the RWA code (Exist)
      *
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     DDCODE        SETLL     SDRWACL1
 B4  C     *IN01         DOWEQ     *OFF
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
 E4  C                   ENDDO
     C
     C                   IF        *IN02 = *OFF
      *
      **  Invalid value, enter '?'
      *
     C                   MOVE      'USR0804'     ZAMSID
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
     C                   MOVE      'USR0804'     ZAMSID
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
 B2  C     *IN01         DOWEQ     *OFF
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
 E2  C                   ENDDO
     C
     C                   IF        *IN02 = *OFF
      *
      **  Invalid value, enter '?'
      *
     C                   MOVE      'USR0804'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN82
     C                   ITER
     C                   ENDIF
      *
      **  Check the RWA code & RWA Set Id (combination with customer)
      *
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     DDCUST        SETLL     SDCRWAL0
 B2  C     *IN01         DOWEQ     *OFF
     C     DDCUST        READE     SDCRWAL0                               01
     C                   IF        *IN01
     C                   ITER
     C                   ENDIF
     C
     C                   IF        *IN01 = *OFF      AND
     C                             L0RWRECI = *BLANK AND
     C                             L0RWSETN = DDSETN
     C                   MOVE      *ON           *IN02
     C                   LEAVE
     C                   ENDIF
 E2  C                   ENDDO
     C
     C                   IF        *IN02 = *ON
      *
      **  RWA Code & Set ID combination already exists
      *
     C                   IF        L0RWCODE = DDCODE
     C                   MOVE      'USR9373'     ZAMSID
      *
      **  Only 1 RWA code per set allowed for customer
      *
     C                   ELSE
     C                   EVAL      ZAMSID = 'USR9376'
     C                   ENDIF
 
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
 E1  C                   ENDDO
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
 B1  C                   DOW       *INKC = *OFF AND                             F3
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
     C                   EXSR      SRSENDMSG
     C
     C                   WRITE     SD1242M0                                     Message CTL
     C                   EXFMT     SD1242A1
      *
      **  Clear message subfile
      *
     C                   EXSR      SRCLRM
      *
      **  Pressed F3 or F12 Key
      *
 B2  C                   IF        *INKC = *ON OR
     C                             *INKL = *ON
     C                   ITER
 X2  C                   ELSE
      *
      **  Pressed F10 Key
      *
 B3  C                   IF        *INKJ = *ON
      *
      **  SDCRWAL0   /* PREFIX(L0) RENAME(SDCRWAD0:RSDCRWAD0) */
      *
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     DDCUST        SETLL     SDCRWAL0
 B2  C     *IN01         DOWEQ     *OFF
     C     DDCUST        READE     SDCRWAL0                               01
     C                   IF        *IN01
     C                   ITER
     C                   ENDIF
     C
     C                   IF        *IN01 = *OFF      AND
     C                             L0RWRECI = *BLANK AND
     C                             L0RWCODE = DDCODE AND
     C                             L0RWSETN = DDSETN
     C                   DELETE    RSDCRWAD0                            02
     C
     C                   IF        *IN02
     C                   MOVE      'SDCRWAL0'    DBFILE                         ***************
     C                   Z-ADD     4             DBASE                          * DB ERROR 04 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
 E2  C                   ENDDO
      *
      **  Set Variable To Build SFL
      *
     C                   MOVE      'Y'           V#BLD
 E3  C                   ENDIF
 E2  C                   ENDIF
 E1  C                   ENDDO
     C
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *OFF          *INKJ                          F10
     C                   MOVE      *OFF          *IN24                          Delete Attrib.
      *
      **  All Is OK
      *
     C                   If        CSC022 = 'N' or                                            CSC022
     C                             (wSkip = 'N' and CSC022 = 'Y')                             CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * WRIREC - WRITE AN RECORDS                                     *
      *****************************************************************
      *
     C     WRIREC        BEGSR
      *
      **  SDCRWAL0
      *
     C                   MOVE      *BLANK        L0RWRECI
     C                   MOVE      DDCUST        L0RWCUST
     C                   MOVE      DDCODE        L0RWCODE
     C                   MOVE      DDSETN        L0RWSETN
     C                   MOVE      'I'           L0RWCHTP
     C                   Z-ADD     AGRDNB        L0RWLCD
     C                   WRITE     RSDCRWAD0                            01
     C
     C                   IF        *IN01
     C                   MOVE      'SDCRWAL0'    DBFILE                         ***************
     C                   Z-ADD     5             DBASE                          * DB ERROR 05 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      **  All Is OK
      *
     C                   If        CSC022 = 'N' or                                            CSC022
     C                             (wSkip = 'N' and CSC022 = 'Y')                             CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
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
     C     SRSENDMSG     begsr
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
     C                   PARM      PSPROCPGM     ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
     C
     C                   ENDSR
      *
