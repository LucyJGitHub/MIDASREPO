     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Risk Weighted Assets Codes Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - SD Module                                            *
      *                                                               *
      *  SD001241  - Risk Weighted Assets Codes Maintenance           *
      *                                                               *
      *  Function:  This program records valid Risk Weighted          *
      *             Assets Codes.                                     *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL018  *CREATE    Date 17Sep02               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
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
      **  RISK WEIGHTED ASSET MASTER FILE UPDATE INDEX
      *
     FSDRWASL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDRWASD0:RSDRWASL0)
      *
      **  RISK WEIGHTED ASSET CODES MASTER FILE RETR. INDEX
      *
     F*DRWACL1**IF***E           K DISK    INFSR(*PSSR)
     FSDRWACL2  IF   E           K DISK    INFSR(*PSSR)
      *
      **  RISK WEIGHTED ASSET CODES MASTER FILE UPDATE INDEX
      *
     FSDRWACL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDRWACD0:RSDRWACL0)
     F                                     PREFIX(C_)
     F                                     COMMIT
      *
      **  CUSTOMER RISK WEIGHTED ASSETS CODES
      *
     FSDCRWAPD  IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(CU)
      *
      **  ACCOUNTS RISK WEIGHTED ASSETS CODES
      *
     FGLARWAPD  IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(AC)
      *
      **  SECURITIES RISK WEIGHTED ASSETS CODES
      *
     FSESRWAPD  IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(SE)
      *
      **  COLLATERAL RISK WEIGHTED ASSETS CODES
      *
     FGLORWAPD  IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(CO)
      *
      **  RISK WEIGHTED ASSETS SETS MAINTENANCE DISPLAY
      *
     FSD001241DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SD1241S1:DDSFRN)
     F                                     INFDS(INFDS#)
      *
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
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D MUSER         E DS                  EXTNAME(MUSERDD)
     D                                     PREFIX(U)
      ** EXTERNAL DS FOR USER DETAILS
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
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
 
      **  Array For ZEDIT And ZALIGN
     d/COPY ZSRSRC,ZALIGNZ1LE
 
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
      **  READ AN RECORDS
      *
     C                   EXSR      SETSCR
     C                   ENDDO
      *********************************************************************
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *********************************************************************
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
     C                   MOVEL     'SD001241  '  DBPGM
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
      **  SET DISPLAY VARIABLES
      *
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWID = PSJobName
     C                   EVAL      DDPGMQ = PSProcPgm
      *
      **  CLEAR MESSAGE SUBFILE
      *
     C                   EXSR      SRCLRM
      *
      **  SET SFLMSG IND.
      *
     C                   MOVE      *ON           *IN91
      *
      **  KEYS
      *
     C     K#COD1        KLIST
     C                   KFLD                    DDCODE
     C                   KFLD                    DDSETN
      *
     C     K#COD2        KLIST
     C                   KFLD                    DDSETN
     C                   KFLD                    DDCODE
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
     C
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
     C
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
     C                   EVAL      DDCODE = *loval
     C                   EVAL      DDSETN = *loval
     C                   EXSR      BLDSFL
     C                   ENDIF
     C
     C                   MOVE      *BLANK        V#BLD
     C                   EVAL      *IN80 = *off
     C                   WRITE     SD1241M0                                     MESSAGE CTL
      *
      **  SHOW SUBFILE SCREEN
      *
     C     V#SFR3        IFNE      0
      *
      **  ANY SELECTION CRITERIA?
      *
     C                   IF        DQCODE <> *BLANK OR
     C                             DQSETN <> *BLANK
     C                   EVAL      DDCODE = DQCODE
     C                   EVAL      DDSETN = DQSETN
     C                   EXSR      BLDSFL
     C                   ENDIF
     C                   ENDIF
     C
     C                   IF        V#SFR3 > 0
     C                   WRITE     SD1241F1
     C                   EXFMT     SD1241S0
     C
     C                   ELSE
      *
      **  NO RECORD SCREEN
      *
     C                   MOVE      *ON           *IN80                          TEXT ON BOTTOM SCR
     C                   EVAL      V#BLD = 'Y'
     C                   WRITE     SD1241N1
     C                   WRITE     SD1241F1
     C                   READ      SD1241N1
     C                   ENDIF
      *
      **  CLEAR MESSAGE SUBFILE
      *
     C                   EXSR      SRCLRM
      *
      **  PRESSED F3 OR F12 KEY
      *
     C                   IF        *INKC = *ON OR
     C                             *INKL = *ON
     C                   ITER
     C                   ENDIF
      *
      **  PRESSED F5 KEY
      *
     C                   IF        *INKE = *ON
     C                   MOVE      *OFF          *INKE
     C                   MOVE      'Y'           V#BLD
     C                   ITER
     C                   ENDIF
      *
      **  PRESSED F9 KEY
      *
     C                   IF        *INKI = *ON
     C
     C                   MOVE      'I'           DDOPT
     C                   EXSR      VALOPT
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
      **  CHECK SUBFILE OPTION
      *
     C                   MOVE      ' '           VALSFLOK          1
     C                   EXSR      VALSFL
      *
      **  SELECT AN EVENT
      *
     C                   IF        VALSFLOK = *BLANK
      *
      **       DELETE ---------------------------------------
      *
     C                   IF        V#ACT1 = 'D'
     C
     C                   MOVE      'D'           DDOPT
     C                   EXSR      VALOPT
     C     WERR          IFNE      0
      *
      **  User is not authorised to this action code
      *
     C                   MOVE      'CSF9006'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   ELSE
      *
      **  Default weighting for set may not be deleted
      *
     C                   IF        DDCODE = *blanks
     C                   EVAL      ZAMSID = 'USR9386'
     C                   EXSR      SRSENDMSG
     C                   ELSE
      *
      **  CHECK RELATED RECORD
      *
     C                   EXSR      CHKRELRC
     C
     C                   IF        VALSFLOK = *BLANK
     C                   EXSR      SRDEL
     C                   ELSE
      *
      **  RWA codes already exist for this set
      *
     C                   MOVE      'USR9380'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   ENDIF
     C                   ENDIF                                                  CGL018
     C                   ENDIF
     C
     C                   ENDIF
      *
      **       AMEND  ---------------------------------------
      *
     C                   IF        V#ACT1 = 'A'
     C
     C                   MOVE      'A'           DDOPT
     C                   EXSR      VALOPT
     C     WERR          IFNE      0
      *
      **  User is not authorised to this action code
      *
     C                   MOVE      'CSF9006'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   ELSE
     C                   EXSR      SRAMD
     C                   ENDIF
     C                   ENDIF
      *
      **       ENQUIRY --------------------------------------
      *
     C                   IF        V#ACT1 = 'E'
     C
     C                   MOVE      'E'           DDOPT
     C                   EXSR      VALOPT
     C     WERR          IFNE      0
      *
      **  User is not authorised to this action code
      *
     C                   MOVE      'CSF9006'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   ELSE
     C                   EXSR      SRENQ
     C                   ENDIF
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
      **  Subfile Clear
      *
     C                   MOVE      *ON           *IN97
     C                   WRITE     SD1241S0
     C                   MOVE      *OFF          *IN97
     C                   Z-ADD     DDSFRN        V#LARC            4 0
     C                   Z-ADD     0             DDSFRN
      *
      **  Reading Cycle
      *
     C                   MOVE      *OFF          *IN25
     C     K#COD2        SETLL     SDRWACL2
     C                   MOVE      ' '           V#RDB3            1
     C
     C     *IN25         DOUEQ     *ON
     C                   READ      SDRWACL2                               25
     C
     C     *IN25         IFEQ      *OFF
     C                   MOVE      'Y'           V#RDB3
     C                   MOVE      *ON           *IN26
      *
      **  ONLY LIVE RECORDS
      *
     C                   IF        RWRECI = '*'
     C                   MOVE      *OFF          *IN26
     C                   ENDIF
      *
      **  IF *IN26 *ON (RECORD IS VALID) RECORD IS WRITTEN TO SFL
      *
     C     *IN26         IFEQ      *ON
     C                   MOVE      *BLANK        DDOPT
     C                   MOVE      RWCODE        DDCODE
     C                   MOVE      RWSETN        DDSETN
      *
      **  ZEDIT RWRWAP
      **                 100.00  -->  '100.00'
      *
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      RWRWAP        ZFIELD
     C                   Z-ADD     2             ZADEC
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        DDRWAP
     C
     C                   MOVEL(P)  RWCDESC       DDDESC
     C
     C                   ADD       1             DDSFRN
     C                   WRITE     SD1241S1
     C                   ENDIF
     C
     C                   ENDIF
     C                   ENDDO
     C
     C                   Z-ADD     DDSFRN        V#SFR3            3 0
      *
      **  SET ON THE FIRST POSITION
      *
     C                   IF        DDSFRN <> 0
     C                   Z-ADD     1             DDSFRN
     C                   ENDIF
      *
     C                   IF        V#GO2R = 'Y' and
     C                             V#LARC <= V#SFR3
     C                   Z-ADD     V#LARC        DDSFRN
     C                   MOVE      *BLANK        V#GO2R            1
     C                   ENDIF
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * VALSF - VALIDATE SUBFILE OPTIONS                              *
      *****************************************************************
      *
     C     VALSFL        BEGSR
      *
      **  SET OF IND. AND VARIABLES
      *
     C                   MOVE      *OFF          *IN70
     C                   MOVE      'OLD'         V#MODE            3
     C                   Z-ADD     1             DDSFRN
     C                   MOVE      'N'           V#RCS1            1
     C                   MOVE      *off          *IN28
      *
      **  SUBFILE READ CYCLE
      *
     C                   DOU       *IN28 = *ON OR
     C                             V#RCS1 = 'Y'
     C                   READC     SD1241S1                               28
     C
     C                   IF        *IN28 = *OFF
     C
     C                   IF        DDOPT  = *BLANK
     C                   UPDATE    SD1241S1
     C                   ELSE
      *
      **  ANY ACTION CODE
      *
     C                   MOVE      'Y'           V#RCS1
      *
      **  SAVE ACTION CODE TO VARIABLE
      *
     C                   MOVE      DDOPT         V#ACT1            1
      *
      **  VALIDATE OPTION
      *
     C                   IF        DDOPT <> 'A' AND
     C                             DDOPT <> 'D' AND
     C                             DDOPT <> 'E'
      *
      **   Action code must be one of A, D or E
      *
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
      **   User is not authorised to this action code
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
     C                   IF        V#RCS1 = 'N'
     C                   MOVE      'N'           VALSFLOK
     C                   ENDIF
      *
      **  If An Error Build SFL
      *
     C     VALSFLOK      IFEQ      'N'
     C                   MOVE      *ON           *IN70
     C                   ELSE
     C                   MOVE      ' '           DDOPT
     C                   ENDIF
     C
     C     V#RCS1        IFEQ      'Y'
     C                   UPDATE    SD1241S1
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
     C                   MOVE      *OFF          *IN81                          PC AND RI
     C                   MOVE      *OFF          *IN82                          PC AND RI
     C                   MOVE      *OFF          *IN83                          PC AND RI
     C                   MOVE      *OFF          *INKC                          F3
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      '1'           DDRWAP                         DEFAULT VALUE
     C                   MOVE      *BLANK        DDCODE                         INZ
     C                   MOVE      *BLANK        DDSETN                         INZ
     C                   MOVE      *BLANK        DDRWAP                         INZ
     C                   MOVE      *BLANK        DDDESC                         INZ
     C                   MOVE      *ON           *IN27                          INSERT
      *
      **  CLEAR MESSAGE SUBFILE
      *
     C                   EXSR      SRCLRM
      *
      **  ADD RECORD CYCLE
      *
     C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF
     C                   WRITE     SD1241M0                                     MESSAGE CTL
     C                   EXFMT     SD1241A1
     C
     C                   MOVE      *OFF          *IN81                          PC AND RI
     C                   MOVE      *OFF          *IN82                          PC AND RI
     C                   MOVE      *OFF          *IN83                          PC AND RI
      *
      **  CLEAR MESSAGE SUBFILE
      *
     C                   EXSR      SRCLRM
      *
      **  PRESSED F3 OR F12 KEY
      *
     C                   IF        *INKC = *ON OR
     C                             *INKL = *ON
     C                   ITER
     C                   ENDIF
      *
      **  CHECK THE CODE (BLANK)
      *
     C                   IF        DDCODE = *BLANK
     C                   MOVE      *ON           *IN81
     C                   ITER
     C                   ENDIF
      *
      **  CHECK THE SET ID (BLANK)
      *
     C                   IF        DDSETN = *BLANK
     C                   MOVE      *ON           *IN82
     C                   ITER
     C                   ENDIF
      *
      **  CHECK THE SET ID (EXIST)
      *
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     DDSETN        SETLL     SDRWASL0
     C     *IN01         DOWEQ     *OFF
     C     DDSETN        READE     SDRWASL0                               01
     C                   IF        *IN01 = *OFF AND
     C                             RWRECI = *BLANK
     C                   MOVE      *ON           *IN02
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C
     C                   IF        *IN02 = *OFF
      *
      **  RWA Set does not exists
      *
     C                   MOVE      'USR9387'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN82
     C                   ITER
     C                   ENDIF
      *
      **  CHECK THE CODE & SET COMBINATION
      *
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     K#COD2        SETLL     SDRWACD0
     C     *IN01         DOWEQ     *OFF
     C     K#COD2        READE     SDRWACD0                               01
     C                   IF        *IN01 = *OFF AND
     C                             RWRECI = *BLANK
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
     C                   MOVE      *ON           *IN81
     C                   MOVE      *ON           *IN82
     C                   ITER
     C                   ENDIF
      *
      **  CHECK THE WEIGHTING
      *
     C                   IF        DDRWAP = *BLANK
      *
      **  Mandatory Entry ...
      *
     C                   MOVE      'USR0270'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN83
     C                   ITER
     C                   ENDIF
     C
     C                   MOVEL(P)  DDRWAP        ZFIELD
     C                   Z-ADD     2             ZADEC
     C                   Z-ADD     3             ZADIG
     C                   MOVE      *OFF          *IN99
     C                   EXSR      ZALIGN
     C
     C                   IF        *IN99 = *OFF
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        DDRWAP
     C                   ELSE
      *
      **  Amount Must Be Numeric
      *
     C                   MOVE      'USR1510'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN83
     C                   ITER
     C                   ENDIF
      *
      **  ALL IS OK, WRITE RECORDS
      *
     C                   EXSR      WRIREC
      *
      **  SET VARIABLE TO BUILD SFL
      *
     C                   MOVE      'Y'           V#BLD
      *
      **  SET F12 KEY TO LEAVE THE CYCLE
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
     C                   MOVE      *OFF          *IN81                          PC AND RI
     C                   MOVE      *OFF          *IN82                          PC AND RI
     C                   MOVE      *OFF          *IN83                          PC AND RI
     C                   MOVE      *OFF          *INKC                          F3
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *ON           *IN24                          DELETE ATTRIB.
      *
      **  DELETE RECORD
      *
     C                   DOW       *INKC = *OFF AND                             F3
     C                             *INKL = *OFF AND                             F12
     C                             *INKJ = *OFF                                 F10
      *
      **  CLEAR MESSAGE SUBFILE
      *
     C                   EXSR      SRCLRM
      *
      **  Press F10 to confirm delete
      *
     C                   MOVE      'ASM0028'     ZAMSID
     C                   EXSR      SRSENDMSG
     C
     C                   WRITE     SD1241M0                                     MESSAGE CTL
     C                   EXFMT     SD1241A1
      *
      **  CLEAR MESSAGE SUBFILE
      *
     C                   EXSR      SRCLRM
      *
      **  PRESSED F3 OR F12 KEY
      *
     C                   IF        *INKC = *ON OR
     C                             *INKL = *ON
     C                   ITER
     C                   ELSE
      *
      **  PRESSED F10 KEY
      *
     C                   IF        *INKJ = *ON
      *
      **  SDRWACL0
      *
     C                   MOVE      *OFF          *IN01
     C     K#COD1        CHAIN     RSDRWACL0                          01
     C                   IF        *IN01 = *OFF AND
     C                             C_RWRECI = *BLANK
     C                   MOVE      '*'           C_RWRECI
     C                   MOVE      'D'           C_RWCHTP
     C                   Z-ADD     AGRDNB        C_RWLCD
     C                   UPDATE    RSDRWACL0                            01
     C
     C                   IF        *IN01
     C                   MOVE      'SDRWACL0'    DBFILE                         ***************
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
      *
      **  SET VARIABLE TO BUILD SFL
      *
     C                   MOVE      'Y'           V#BLD
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *OFF          *INKJ                          F10
     C                   MOVE      *OFF          *IN24                          DELETE ATTRIB.
      *
      **  All Is OK
      *
     C                   COMMIT
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRAMD - AMEND RECORD                                          *
      *****************************************************************
      *
     C     SRAMD         BEGSR
     C
     C                   MOVE      *OFF          *IN81                          PC AND RI
     C                   MOVE      *OFF          *IN82                          PC AND RI
     C                   MOVE      *OFF          *IN83                          PC AND RI
     C                   MOVE      *OFF          *INKC                          F3
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *ON           *IN22                          AMEND ATTRIB.
      *
      **  CLEAR MESSAGE SUBFILE
      *
     C                   EXSR      SRCLRM
      *
      **  AMEND RECORD
      *
     C                   DOW       *INKC = *OFF AND                             F3
     C                             *INKL = *OFF                                 F12
     C                   WRITE     SD1241M0                                     MESSAGE CTL
     C                   EXFMT     SD1241A1
      *
      **  CLEAR MESSAGE SUBFILE
      *
     C                   EXSR      SRCLRM
      *
      **  PRESSED F3 OR F12 KEY
      *
     C                   IF        *INKC = *ON OR
     C                             *INKL = *ON
     C                   ITER
     C                   ELSE
      *
      **  CHECK THE WEIGHTING
      *
     C                   IF        DDRWAP = *BLANK
      *
      **  Mandatory Entry ...
      *
     C                   MOVE      'USR0270'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN83
     C                   ITER
     C                   ENDIF
     C
     C                   MOVEL(P)  DDRWAP        ZFIELD
     C                   Z-ADD     2             ZADEC
     C                   Z-ADD     3             ZADIG
     C                   MOVE      *OFF          *IN99
     C                   EXSR      ZALIGN
     C
     C                   IF        *IN99 = *OFF
     C                   MOVE      ZFIELD        DDRWAP
     C                   ELSE
      *
      **  Amount Must Be Numeric
      *
     C                   MOVE      'USR1510'     ZAMSID
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN83
     C                   ITER
     C                   ENDIF
      *
      **  SDRWACL0
      *
     C     K#COD1        CHAIN     RSDRWACL0                          1920
     C                   IF        *IN19 OR
     C                             *IN20
     C                   MOVE      'SDRWACL0'    DBFILE                         ***************
     C                   Z-ADD     3             DBASE                          * DB ERROR 03 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C
     C                   MOVEL(P)  DDDESC        C_RWCDESC
     C                   MOVE      DDRWAP        C_RWRWAP
     C                   MOVE      'A'           C_RWCHTP
     C                   Z-ADD     AGRDNB        C_RWLCD
     C                   UPDATE    RSDRWACL0                            01
     c
     C                   IF        *IN01
     C                   MOVE      'SDRWACL0'    DBFILE                         ***************
     C                   Z-ADD     4             DBASE                          * DB ERROR 04 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      **  SET VARIABLE TO BUILD SFL
      *
     C                   MOVE      'Y'           V#BLD
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *OFF          *IN22                          AMEND ATTRIB.
      *
      **  All Is OK
      *
     C                   COMMIT
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRENQ - ENQUIRY                                               *
      *****************************************************************
      *
     C     SRENQ         BEGSR
     C
     C                   MOVE      *OFF          *IN81                          PC AND RI
     C                   MOVE      *OFF          *IN82                          PC AND RI
     C                   MOVE      *OFF          *IN83                          PC AND RI
     C                   MOVE      *OFF          *INKC                          F3
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *ON           *IN29                          DISPLAY ATTRIB.
      *
      **  CLEAR MESSAGE SUBFILE
      *
     C                   EXSR      SRCLRM
      *
      **  DISPLAY RECORD
      *
     C                   DOW       *INKC = *OFF AND                             F3
     C                             *INKL = *OFF                                 F12
     C                   WRITE     SD1241M0                                     MESSAGE CTL
     C                   EXFMT     SD1241A1
      *
      **  CLEAR MESSAGE SUBFILE
      *
     C                   EXSR      SRCLRM
     C                   ENDDO
     C
     C                   MOVE      *OFF          *INKL                          F12
     C                   MOVE      *OFF          *IN29                          AMEND ATTRIB.
     C
     C                   ENDSR
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
      **  ELSE MULTIENTITY SYSTEM, SO CHECK USER IS AUTHORISED TO
      **  Action for Default Branch
      *
     C                   ELSE
      *
     C                   CALL      'AOUSERR0'
     C                   PARM                    UReturn           7
     C                   PARM      '*KEY'        UOption           7
     C                   PARM      DDUSER        UUserID          10
     C     MUSER         PARM      MUSER         DSFDY
 
     C                   CALL      'ZVACTBU'
     C                   PARM      DDOPT         WACTN
     C                   PARM      UDBRN         WZBR              3
     C                   PARM                    WERR
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * WRIREC - WRITE AN RECORDS                                     *
      *****************************************************************
      *
     C     WRIREC        BEGSR
      *
      **  SDRWACL0 - Try To Update Existing
      *
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     K#COD1        SETLL     SDRWACL0
     C     *IN01         DOWEQ     *OFF
     C     K#COD1        READE     SDRWACL0                               01
     C                   IF        *IN01 = *OFF AND
     C                             C_RWRECI = '*'
     C                   MOVE      *ON           *IN02
     C                   MOVE      *BLANK        C_RWRECI
     C                   MOVE      DDCODE        C_RWCODE
     C                   MOVE      DDSETN        C_RWSETN
      *
     C                   MOVEL(P)  DDRWAP        ZFIELD
     C                   Z-ADD     2             ZADEC
     C                   Z-ADD     3             ZADIG
     C                   MOVE      *OFF          *IN99
     C                   EXSR      ZALIGN
     C
     C                   IF        *IN99 = *OFF
     C                   MOVE      ZFIELD        C_RWRWAP
     C                   ELSE
     C                   MOVE      'ZALIGN  '    DBFILE                         ***************
     C                   Z-ADD     5             DBASE                          * DB ERROR 05 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
     C                   MOVEL(P)  DDDESC        C_RWCDESC
     C                   MOVE      'I'           C_RWCHTP
     C                   Z-ADD     AGRDNB        C_RWLCD
     C                   UPDATE    RSDRWACL0                            03
     C
     C                   IF        *IN03
     C                   MOVE      'SDRWACL0'    DBFILE                         ***************
     C                   Z-ADD     6             DBASE                          * DB ERROR 06 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      **  SDRWACL0 - If *IN02 Still *OFF Write a Record
      *
     C                   IF        *IN02 = *OFF
     C                   MOVE      *BLANK        C_RWRECI
     C                   MOVE      DDCODE        C_RWCODE
     C                   MOVE      DDSETN        C_RWSETN
      *
     C                   MOVEL(P)  DDRWAP        ZFIELD
     C                   Z-ADD     2             ZADEC
     C                   Z-ADD     3             ZADIG
     C                   MOVE      *OFF          *IN99
     C                   EXSR      ZALIGN
     C
     C                   IF        *IN99 = *OFF
     C                   MOVE      ZFIELD        C_RWRWAP
     C                   ELSE
     C                   MOVE      'ZALIGN  '    DBFILE                         ***************
     C                   Z-ADD     7             DBASE                          * DB ERROR 07 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
     C                   MOVEL(P)  DDDESC        C_RWCDESC
     C                   MOVE      'I'           C_RWCHTP
     C                   Z-ADD     AGRDNB        C_RWLCD
     C                   WRITE     RSDRWACL0                            03
     C
     C                   IF        *IN03
     C                   MOVE      'SDRWACL0'    DBFILE                         ***************
     C                   Z-ADD     8             DBASE                          * DB ERROR 08 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
      *
      **  All Is OK
      *
     C                   COMMIT
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
      * CHKRELRC - CHECK RELATED RECORD IN ACCOUNTS, CUSTOMERS,       *
      *            SECURITIES AND COLLATERALS.                        *
      *                                                               *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     CHKRELRC      BEGSR
      *
      **  CUSTOMERS - SDCRWAPD
      *
     C                   MOVE      *OFF          *IN01
     C     1             SETLL     SDCRWAPD
     C     *IN01         DOWEQ     *OFF
     C                   READ      SDCRWAPD                               01
     C                   IF        *IN01 = *OFF      AND
     C                             CURWRECI = *BLANK AND                        LIVE REC.
     C                             CURWCODE = DDCODE AND
     C                             CURWSETN = DDSETN
     C                   MOVE      'N'           VALSFLOK
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
      **  ACCOUNTS - GLARWAPD
      *
     C                   IF        VALSFLOK = *BLANK
     C                   MOVE      *OFF          *IN01
     C     1             SETLL     GLARWAPD
     C     *IN01         DOWEQ     *OFF
     C                   READ      GLARWAPD                               01
     C                   IF        *IN01 = *OFF      AND
     C                             ACRWRECI = *BLANK AND                        LIVE REC.
     C                             ACRWCODE = DDCODE AND
     C                             ACRWSETN = DDSETN
     C                   MOVE      'N'           VALSFLOK
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
      **  SECURITIES - SESRWAPD
      *
     C                   IF        VALSFLOK = *BLANK
     C                   MOVE      *OFF          *IN01
     C     1             SETLL     SESRWAPD
     C     *IN01         DOWEQ     *OFF
     C                   READ      SESRWAPD                               01
     C                   IF        *IN01 = *OFF      AND
     C                             SERWRECI = *BLANK AND                        LIVE REC.
     C                             SERWCODE = DDCODE AND
     C                             SERWSETN = DDSETN
     C                   MOVE      'N'           VALSFLOK
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
      **  COLLATERALS - GLORWAPD
      *
     C                   IF        VALSFLOK = *BLANK
     C                   MOVE      *OFF          *IN01
     C     1             SETLL     GLORWAPD
     C     *IN01         DOWEQ     *OFF
     C                   READ      GLORWAPD                               01
     C                   IF        *IN01 = *OFF      AND
     C                             CORWRECI = *BLANK AND                        LIVE REC.
     C                             CORWCODE = DDCODE AND
     C                             CORWSETN = DDSETN
     C                   MOVE      'N'           VALSFLOK
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
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
      /EJECT
      *****************************************************************
      * ZALIGN   - Midas ZS Val/right aligned numeric fields          *
      * ------                                                        *
      * Called by: SRValdSTLR                                         *
      * Calls:                                                        *
      *****************************************************************
     d/COPY ZSRSRC,ZALIGNZ2LE
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
