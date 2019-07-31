     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Update Foreign Currency Positions')
      *****************************************************************
      *                                                               *
      *  Midas  - General Ledger Module                               *
      *                                                               *
      *  GL000447 - Update Foreign Currency Positions                 *
      *                                                               *
      *  Function:  Update Foreign Currency Positions with Consumer   *
      *             Banking Foreign Currency Movements                *
      *  Called By: GLC000447 - Update Foreign Currency Positions.    *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BG12179            Date 11Jan07               *
      *                 BG13010            Date 28Dec06               *
      *                 BG12134            Date 30Sep06               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG12179 - Foreign Currency movements do not get transferred  *
      *            from Equation to Midas                             *
      *  BG13010 - Equation Update of Foreign Currency Movement is    *
      *            not working                                        *
      *  BG12134 - Remove RCF processing for audit file               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *    U7+U8 -  Database Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      ***SRTMPF**-*Subroutine*To*Read*The*File*AF8PF*******************                      BG13010
      *  SRTMPF  - Subroutine To Read The File AF810LF                *                      BG13010
      *  SRRCF   - Subroutine To Register GL000447AU Via RCF          *
      *  SRUPDLM - Subroutine To Update Foreign Currency              *
      *            Movements Control File                             *
      *  SRVLCY  - Subroutine To Validate Currency                    *
      *  CVTDATE - Subroutine To Validate And Convert Date            *
      *            Into Midas Number                                  *
      *  VALBRCH - Subroutine To Validate The Input Branch            *
      *            and Find  Valid Output Branch                      *
      *  SRAUDT  - Subroutine To Output Audit Report and              *
      *            End Program                                        *
      *  FOREXM  - Subroutine To Update the Currency Projection       *
      *            File                                               *
      *  *PSSR   - Error processing                                   *
      *  *INZSR  - Initialise                                         *
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
 
     F*AF8PF**** IF   E             DISK    INFSR(*PSSR)                                     BG13010
     FAF810LF   IF   E             DISK    INFSR(*PSSR)                                      BG13010
     F                                     USROPN
      ** Time Table File
     FAF910LF   UF   E           K DISK    INFSR(*PSSR)
     F*                                     USROPN
     F*                                     COMMIT
      ** Foreign Currency Movements File
     F*GLCYPNPD* UF   E             DISK    INFSR(*PSSR)                                     BG13010
     FGLCYPNPD  UF A E             DISK    INFSR(*PSSR)                                      BG13010
     F                                     USROPN
     F                                     COMMIT
      ** Midas GL Foreign Currency  Movements Control File
     FSDBRCXL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      ** Branch Codes Extension File
     FGL000447AUO    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN99)
     F**********                           INFDS(SPOOLU)                                     BG12134
      ** Foreign Currency Extract Audit Report Print File
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D CMDDLY          S             80    DIM(1) PERRCD(1) CTDATA
      **Compile Time Array
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
     D*SPOOLU***       DS                                                                    BG12134
      ***SPOOL*Information*Data*Structure*for*ZSFILE*******************                      BG12134
 
     D*SFILEU***              83     92                                                      BG12134
     D*SFNUMU***             123    124B 0                                                   BG12134
 
     D GLCYPNCTL     E DS                  EXTNAME(GLCYPNCTL)
      ** Midas GL Foreign Currency Movements Job Control Dataarea layout
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details ICD retrieval
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variable For Timestamp Field
     D O_TIMESTAMP     S             26A   INZ
 
      ** Work Variables For Sequence Number
     D TSEQNO          S              7  0
     D LSEQNO          S              7  0
 
      ** Parameter For 'QCMDEXC'
     D CMDLEN          S             15  5
     D DLYJOB          S             80A
 
      ** Parameter For 'ZSFILE'
     D PSEQ            S              5A
     D PSENTY          S              3A
     D PZSNUM          S              6  0
     D PZSERR          S              1A
 
      ** Parameter For  AOBANKR0/AOCURRR0/AOOLPSU0
     D @RTCD           S              7A
     D @OPTN           S              7A
     D OLPOS           S              8A
     D VALDATE         S              5P 0
     D MAMT            S             15  0
     D INOTFLG         S              1A
 
      ** Parameter For ZDATE1
     D DATEIN          S              6A
     D DAYNOOUT        S              5P 0
     D @ERRFLAG        S              1A
 
      ** Work Variables
     D KBRCD           S              3A
     D MBRCD           S              3A
     D WDATEA          S              6A
 
     D @RUN            S              1
 
      *****************************************************************
      /EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Retrive The sequence Number From AF8PF
      *
     C                   EXSR      SRTMPF
      *
      ** Read Sequence  Number From GLCYPNPD
      *
     C                   READ(N)   GLCYPNPD
     C                   EVAL      LSEQNO = CYLRSN
      *
      ** Check the Data Area  Whether It Is Updated Or Not
      *
     C                   IN        GLCYPNCTL
      *
      ** Main Loop Starts .Process Until Value Of Data Area Is Not Changed To 'STOP'
      ** And TIMESTAMP of AF8PF is not equal to O_TIMESTAMP.
      *
     C**********         DOW       CYSTOP <> 'STOP' AND AF8TIME <> O_TIMESTAMP               BG13010
     C                   DOW       CYSTOP <> 'STOP'                                          BG13010
                                                                                             BG13010
     C                   IF        AF8TIME <> O_TIMESTAMP                                    BG13010
      *
     C                   EVAL      O_TIMESTAMP = AF8TIME
      *
      ** Check the Data Area  Whether It Is Updated Or Not
      *
     C                   IN        GLCYPNCTL
      *
      ** Process Until Data Area is not equal to 'STOP' And
      ***Sequence*Number*of*AF8PF*is*Greater*than*or*Equal*to*******                         BG13010
      ** Sequence Number of AF810LF is Greater than or Equal to                              BG13010
      ** Sequence Number of the GLCYPNPD file .
      *
     C                   DOW       CYSTOP <> 'STOP' AND LSEQNO <= TSEQNO
      *
      **  Read Records From The AF910LF
      *
     C     LSEQNO        SETLL     AF910LF
     C     LSEQNO        READE     AF910LF                                40
      *
      ** Check the Data Area  Whether It Is Updated Or Not
      *
     C                   IN        GLCYPNCTL
      *
      ** Process Until Data Area is not equal to 'STOP' And
      ** End of File is not reached for the File AF910LF
      *
     C                   DOW       CYSTOP <> 'STOP' AND NOT %EOF(AF910LF)
      *
      ** Process the Record
      *
     C                   EXSR      FOREXM
      *
      ** Read The Next Record From The File AF910LF With The Same
      ** Sequence Number .
      *
     C     LSEQNO        READE     AF910LF
      *
      ** Check the Data Area  Whether It Is Updated Or Not
      *
     C                   IN        GLCYPNCTL
      *
     C                   ENDDO
      *
      ** If End of File is reached,Increse LSEQNO By 1
      *
     C                   IF         %EOF(AF910LF)
     C                   EVAL      LSEQNO = LSEQNO + 1
     C                   ENDIF
      *
      ** Check the Data Area  Whether It Is Updated Or Not
      *
     C                   IN        GLCYPNCTL
     C                   ENDDO
     C                   ENDIF                                                               BG13010
      *                                                                                      BG13010
      ** Check the Data Area  Whether It Is Updated Or Not                                   BG13010
      *                                                                                      BG13010
     C                   IN        GLCYPNCTL                                                 BG13010
      *                                                                                      BG13010
      *
      ** If 'STOP' is not Encountered Delay the Job By 30 Seconds.
      ** Else Update the File GLCYPNPD to *ZEROS and Exit.
      *
      *
     C                   IF        CYSTOP <> 'STOP'
      *
      ** Delay The Job By 30 seconds
      *
     C                   MOVEA     CMDDLY(1)     DLYJOB
     C                   EVAL      CMDLEN = 80
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    DLYJOB
     C                   PARM                    CMDLEN
      *
      **  Call Ended In Error
      *
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY  = 'QCMDEXC'
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBPROC = 'SR/SRPROC'
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrive Sequence Number From AF8PF
      *
     C                   EXSR      SRTMPF
      *
     C                   ELSE
     C**********         EVAL      LSEQNO = *ZEROS                                           BG12179
     C                   EVAL      LSEQNO = 1                                                BG12179
      *
      ** Update In File GLCYPNPD
      *
     C                   EXSR      SRUPDLM
     C                   ENDIF
      *
      ** Check the Data Area  Whether It Is Updated Or Not
      *
     C                   IN        GLCYPNCTL
     C                   ENDDO
      *
     C                   EVAL      *INLR  = *ON
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      **Calls:*SRRCFA**************************************************                      BG12134
      * Calls: None                                                   *                      BG12134
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Open Files
      *
     C                   IF        Not %Open(AF910LF)
     C                   OPEN      AF910LF
     C                   ENDIF
      *
     C                   IF        Not %Open(GLCYPNPD)
     C                   OPEN      GLCYPNPD
     C                   ENDIF
      *
     C                   IF        Not %Open(SDBRCXL1)
     C                   OPEN      SDBRCXL1
     C                   ENDIF
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  GLCYPNCTL
     C
      *
      ***Execute*Subroutine*To*Register*GL000447AU*Via*RCF*************                      BG12134
      *
     C**********         EXSR      SRRCFA                                                    BG12134
      *
      ** Initialise Working Fields.
      *
     C                   EVAL      DBASE  = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBPROC = *BLANKS
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM                    DSFDY
      *
      ** Database Error
      *
     C                   IF        @RTCD  <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = @OPTN
     C                   EVAL      DBASE  = 005
     C                   EVAL      DBPROC = 'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      **SRTMPF*-*Subroutine*To*Read*The*AF8PF*File*********************                      BG13010
      * SRTMPF - Subroutine To Read The AF810LF File                  *                      BG13010
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: None.                                                 *
      *****************************************************************
     C     SRTMPF        BEGSR
      *
      ***Retrive*Sequence*Number*From*AF8PF****************************                      BG13010
      ** Retrive Sequence Number From AF810LF                                                BG13010
      *
     C**********         IF        Not %Open(AF8PF)                                          BG13010
     C**********         OPEN      AF8PF                                                     BG13010
     C                   IF        Not %Open(AF810LF)                                        BG13010
     C                   OPEN      AF810LF                                                   BG13010
     C                   ENDIF
      *
     C**********         READ      AF8PF                                                     BG13010
     C     *HIVAL        SETGT     AF810LF                                                   BG13010
     C                   READP     AF810LF                                                   BG13010
     C                   EVAL      TSEQNO  =  AF8SEQ
      *
     C**********         IF        %Open(AF8PF)                                              BG13010
     C**********         CLOSE     AF8PF                                                     BG13010
     C                   IF        %Open(AF810LF)                                            BG13010
     C                   CLOSE     AF810LF                                                   BG13010
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************                      BG12134
      ***SRRCFA**-*Subroutine*to*register*GL000447AU*via*RCF.**********                      BG12134
      *****************************************************************                      BG12134
      ***Called By:**INZSR*********************************************                      BG12134
      *****************************************************************                      BG12134
      ***Calls:*None.**************************************************                      BG12134
      *****************************************************************                      BG12134
      *                                                                                      BG12134
     C*****SRRCFA        BEGSR                                                               BG12134
      *****************************************************************                      BG12134
      ***Ensure*Report*Spool*File*recorded*by*RCF.*********************                      BG12134
      *****************************************************************                      BG12134
     C**********         Z-ADD     SFNUMU        PZSNUM                                      BG12134
      *****************************************************************                      BG12134
     C**********         CALL      'ZSFILE'                                                  BG12134
     C**********         PARM      *BLANKS       PSEQ                                        BG12134
     C**********         PARM      *BLANKS       PSENTY                                      BG12134
     C**********         PARM                    SFILEU                                      BG12134
     C**********         PARM                    PZSNUM                                      BG12134
     C**********         PARM      *BLANKS       PZSERR                                      BG12134
      *****************************************************************                      BG12134
      ***If*Error*occurs*during*ZSFILE*processing,*then*return*to*the**                      BG12134
      ***Calling*Program.**********************************************                      BG12134
      *****************************************************************                      BG12134
     C**********         IF        PZSERR = 'Y'                                              BG12134
     C**********         SETON                                        U7U8LR                 BG12134
     C**********         RETURN                                                              BG12134
     C**********         ENDIF                                                               BG12134
      *****************************************************************                      BG12134
     C**********         ENDSR                                                               BG12134
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDLM - Subroutine To Update Foreign Currency Movements    *
      *            Control File                                       *
      *                                                               *
      *  Called By: Main Processing,FOREXM                            *
      *                                                               *
      *  Calls: None.                                                 *
      *****************************************************************
      *
     C     SRUPDLM       BEGSR
      *
     C     1             SETLL     GLCYPNPD
     C                   READ(E)   GLCYPNPD
      *
      ** Read ended in error
      *
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLCYPNPD'
     C                   MOVEL     CYLRSN        DBKEY
     C                   EVAL      DBASE   = 002
     C                   EVAL      DBPROC = 'SR/SRUPDLM'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      CYLRSN = LSEQNO
      *
     C                   IF        NOT %EOF(GLCYPNPD)                                       BG13010
      *                                                                                     BG13010
      ** Update The File GLCYPNPD
      *
     C                   UPDATE(E) GLCYPND0
     C                   ELSE                                                               BG13010
      *                                                                                     BG13010
      ** Write the Projected Nostro Accounts Control file                                   BG13010
      *                                                                                     BG13010
     C                   WRITE(E)  GLCYPND0                                                 BG13010
     C                   ENDIF                                                              BG13010
      *
      ** Update Ended In Error
      *
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLCYPNPD'
     C                   MOVEL     CYLRSN        DBKEY
     C                   EVAL      DBASE   = 003
     C                   EVAL      DBPROC = 'SR/SRUPDLM'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Commit all the changes
      *
     C                   COMMIT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVLCY  - Subroutine To Validate Currency                    *
      *                                                               *
      *  Called By: FOREXM                                            *
      *                                                               *
      *  Calls: None.                                                 *
      *****************************************************************
      *
     C     SRVLCY        BEGSR
      *
      ** To Verify The Currency In The Midas File Call the Access Object
      ** 'AOCURRR0'
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM                    AF9CCYD
     C                   PARM                    DSSDY
      *
      ** Call Ended In Error
      *
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  =  AF9CCYD
     C                   EVAL      DBASE  = 004
     C                   EVAL      DBPROC = 'SR/SRVLCY'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CVTDATE - Subroutine To Validate And Convert Date Into       *
      *            MIDAS Day Number                                   *
      *                                                               *
      *  Called By: FOREXM                                            *
      *                                                               *
      *  Calls: None.                                                 *
      *****************************************************************
      *
     C     CVTDATE       BEGSR
      *
      ** To Convert The Date Into Midas Day Number
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEIN
     C                   PARM                    DAYNOOUT
     C                   PARM                    BJDFIN
     C                   PARM      *BLANKS       @ERRFLAG
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALBRCH - Subroutine To Validate Input Branch and find Valid *
      *            Output Branch                                      *
      *                                                               *
      *  Called By: FOREXM                                            *
      *                                                               *
      *  Calls: None.                                                 *
      *****************************************************************
      *
     C     VALBRCH       BEGSR
      *
     C                   EVAL      KBRCD = AF9BRCA
      *
      ** Check Whether the record exist in the  file SDBRCXL1
      *
     C     KBRCD         CHAIN     SDBRCXL1
     C                   IF        %FOUND
      *
      ** Record Exist IN SDBRCXL1
      *
     C                   EVAL      MBRCD = BXBRCD
      *
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCXL1'
     C                   EVAL      DBKEY  =  KBRCD
     C                   EVAL      DBASE   = 007
     C                   EVAL      DBPROC = 'SR/VALBRCH'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDT - Subroutine To Output Audit report and End           *
      *            Program.                                           *
      *                                                               *
      *  Called By: *PSSR                                             *
      *                                                               *
      *  Calls: None.                                                 *
      *****************************************************************
      *
     C     SRAUDT        BEGSR
      *
      ** Write The Error Report In The File GL000447AU
      *
     C                   WRITE     HEADAU
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ENDIF
     C                   WRITE     FOOTAU
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FOREXM - Subroutine To Update The Currency Projection        *
      *            File.                                              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: VALBRCH,SRVLCY,CVTDATE,SRUPDLM                        *
      *****************************************************************
      *
     C     FOREXM        BEGSR
      *
      ** Validate The Branch Code
      *
     C                   EXSR      VALBRCH
      *
      ** Validate Currency Code
      *
     C                   EXSR      SRVLCY
      *
      ** Convert  value date (YYMMDD) To Midas Day Number
      *
     C                   MOVE      AF9VUDT       WDATEA
     C                   EVAL      WDATEA = %SUBST(WDATEA:3:4)
     C                              + %SUBST(WDATEA:1:2)
     C                   MOVE      WDATEA        DATEIN
     C                   MOVE      'M'           BJDFIN
      *
      ** Convert The Date to Midas Day Number
      *
     C                   EXSR      CVTDATE
     C                   MOVE      DAYNOOUT      VALDATE
      *
      ** Set Debit Or Credit Flag .If AF9DORC = 0 ,then it is Debit
      ** If AF9DORC = 1, then it is Credit, else it is an error
      *
     C                   IF        AF9DORC = 0
     C                   EVAL      INOTFLG = 'O'
     C                   ELSE
     C                   IF        AF9DORC = 1
     C                   EVAL      INOTFLG = 'I'
     C                   ELSE
     C* Error
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'AF910LF'
     C                   MOVEL     AF9DORC       DBKEY
     C                   EVAL      DBASE  = 008
     C                   EVAL      DBPROC = 'SR/FOREXM'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      OLPOS = MBRCD + AF9CCYD + '01'
     C                   EVAL      MAMT =  AF9MVAM
      *
      ** Update The On-line Currency Position File OLPOSOA .
      *
     C                   CALL      'AOOLPSU0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    OLPOS
     C                   PARM                    VALDATE
     C                   PARM                    MAMT
     C                   PARM                    INOTFLG
      *
      ** Call Ended In Error
      *
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY  = 'AOOLPSU0'
     C                   EVAL      DBASE  = 006
     C                   EVAL      DBPROC = 'SR/FOREXM'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Delete Record from The AF910LF
      *
     C                   DELETE    AF910LF
      *
     C                   IF        LSEQNO > CYLRSN
      *
      ** Update Sequence Number In GLCYPNPD
      *
     C                   EXSR      SRUPDLM
     C                   ENDIF
     C                   COMMIT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = PSPROCPGM
     C                   EVAL      DBMOD  = PSPROCMOD
     C                   OUT       LDA
     C                   UNLOCK    LDA
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ROLBK
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      SRAUDT
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      ***********************************************************************
**
DLYJOB DLY(30)
