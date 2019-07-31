     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Portfolio mgmt cust detail acc obj - 2')      *
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  AOPLCSR2 - PORTFOLIO MANAGEMENT CUSTOMER DETAILS - 2         *
      *                                                               *
      *  Function: Access record from SDPLCSL0.                       *
      *                                                               *
      *  This function is a modified version of AOPLCSR1.             *
      *  The changes from AOPLCSR1 are:                               *
      *  - conversion from an OPM program to an ILE module            *
      *  - conversion of CALLs to CALLBs (w/o annotation)             *
      *  - addition of the error MSGIDs in the parameter List         *
      *  - direct inclusion of all /COPY code (converted to ILE)      *
      *  - changes to SR/AOSNMS to enable the errors to be passed     *
      *    back in the PLIST                                          *
      *                                                               *
      *  These changes are annotated under CAP002, even though this   *
      *   is a new member.                                            *
      *                                                               *
      *  Any changes to this member are likely to be needed in        *
      *    AOPLCSR1, and vice versa.                                  *
      *                                                               *
      *  This function can return the SDPLCSPD format as well as      *
      *  extra information on book, portfolio and customer.           *
      *                                                               *
      *  The control of information returned is specified in a        *
      *  different manner from the access object standard, which is   *
      *  to use the return code.                                      *
      *                                                               *
      *                           Bank Port        Cust. Port         *
      *   Input Parameters        Supported        Supported          *
      *                                                               *
      *   Option                  Mandatory        Mandatory          *
      *   (*FREE/*KEY/*VERIFY)                                        *
      *   Portfolio Support       Mandatory        Mandatory          *
      *   (C/B)                                                       *
      *   9997 Port ref.          Mandatory        Mandatory          *
      *   Counterparty Cust       n/a              Mandatory          *
      *   Branch                  Mandatory        n/a                *
      *   Book                    Optional         n/a                *
      *   Screen Portfolio        Optional         n/a                *
      *                                                               *
      *   Output Parameters                                           *
      *                                                               *
      *   Default Book            Applicable       n/a                *
      *     (For Bank Ports                                           *
      *     this is input book                                        *
      *     if not blank else                                         *
      *     Portfolio book)                                           *
      *   Default Portfolio       Applicable       Applicable         *
      *     (For Bank Ports this                                      *
      *     is the Default Book                                       *
      *     portfolio)                                                *
      *   Branch Customer No.     Applicable       n/a                *
      *   Branch Customer Name    Applicable       n/a                *
      *   Branch Cust. Account    Applicable       n/a                *
      *     Officer                                                   *
      *   Customer Portfolio      Applicable       Applicable         *
      *     Dtls Record SDPLCSPD                                      *
      *     (Only rtrn with *KEY)                                     *
      *                                                               *
      *   In Midas phases other than "A" Input Cycle Input, the data  *
      *   read from SDPLCSL0 is cached in an occurrance data          *
      *   structure. This is to limit the I/O to this file when       *
      *   processing is not in branch sequence.                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 136429  *CREATE    Date 10Jun98               *
      *                 CAP002  *CREATE    Date 15Jan98               *
      *                 CPM005             Date 07Aug96               *
      *                 CPM004             Date 07Feb96               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  136429 - Rollover of deal not allowed                        *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *  CPM005 - Private Banking Phase II                            *
      *           Focus Group Changes Upgraded to DBA                 *
      *           Just Recompiled because of PM File(s) changes       *
      *  CPM004 - Bank Portfolios  (NEW PROGRAM)                      *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *        D F C H L   FUNCTION INDICATOR                         *
      *                                                               *
      *        01     INITIALISATION                                  *
      *        90     OPTION ERROR                                    *
      *                                                               *
      *****************************************************************
      *
     F/EJECT
     FSDPLCSL0  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
      * IN  - @PLCSL0 Customer Details
     D/EJECT
      * Branch details
     D ZBR             S              3    DIM(99)
     D ZBC             S              6    DIM(99)
     D ZBN             S             22    DIM(99)
      * Book details
     D ZBK             S              2    DIM(99)
     D ZBP             S              4    DIM(99)
      * Cache for Portfolio Customer Details
     D ZCS             S              6    DIM(99)
      *
      *
      * Error processing array:
      *
     D**/COPY AOCPYSRC,SRERRE                                                                 CAP002
      *                                                                                       CAP002
     D @STK            S             10    DIM(100)                                           CAP002
     D @REC            S              3  0 DIM(100)                                           CAP002
      *                                                                                       CAP002
      *  Subroutine stack                                                                     CAP002
      *                                                                                       CAP002
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITARR               4    103                                                       CSC022
      ** The following fields are defined in the external file:                               CSC022
                                                                                              CSC022
      ** Array of Commitment Job Names                                                        CSC022
     D COMITJOB        S             10A   DIM(10)                                            CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
                                                                                              CSC022
      *
     D/EJECT
     D CPYR            DS
      **  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
      *   APPLCSR2 Input Parameters:    Bank Port        Cust Port
      *                                 ---------        ---------
      *   Portfolio Support             Mandatory        Mandatory
      *   (C/B)
      *   9997 Port ref.                Mandatory        Mandatory
      *   Counterparty Cust             n/a              Mandatory
      *   Branch                        Mandatory        n/a
      *   Book                          Optional         n/a
      *   Screen Portfolio              Optional         n/a
      *
     D I@PARM          DS           256
     D  I#PORS                 1      1
     D  I#R997                 2      5
     D  I#CUST                 6     15
      *
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34
      *
      *   AOPLCSR2 Output Parameters:   Bank Port        Cust Port
      *                                 ---------        ---------
      *   Default Book                  Applicable       n/a
      *   Default Portfolio             Applicable       Applicable
      *   (For Bank Ports this
      *   is the Default Book
      *   portfolio)
      *   Branch Customer No.           Applicable       n/a
      *   Branch Customer Name          Applicable       n/a
      *   Branch Cust. Account          Applicable       n/a
      *                Officer
      *
     D O@PARM          DS           256
     D  O#BOOK                 1      2
     D  O#PTFR                 3      6
     D  O#BICN                 7     12
     D  O#CRNM                13     22
     D  O#ACOF                23     24
     D D@FMT         E DS                  EXTNAME(SDPLCSPD)
      * Customer Portfolio Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      * Branch Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  #DFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      * Customer Details
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
      * Book Details
     D P@FMT         E DS                  EXTNAME(DSFDY)
      * External Data structure to hold the outgoing record format
      * of the file.
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Error processing data structures:
      *
      * Multiple occurrance data structure for SDPLCSL0 data
      *
     D PLCS            DS           128    OCCURS(99)
     D  PLDATA                 1      1
      *
     D***MPHASE        E DS                  EXTNAME(MPHAS)                                   CCB020
      ***Data*Area*for*MPHAS*Midas*Phase*******************************                       CCB020
      *
     I**/COPY AOCPYSRC,SRERRI                                                                 CAP002
      *                                                                                       CAP002
     D DSPGM         ESDS                  EXTNAME(Y2PGDSP)                                   CAP002
      *                                                                                       CAP002
      *  Program data structure                                                               CAP002
      *                                                                                       CAP002
     D LDA           E DS           256    EXTNAME(LDA)                                       CAP002
      *                                                                                       CAP002
      *  Local data area for database error details                                           CAP002
      *  *LOCK IN LDA immediately before and OUT LDA immediately                              CAP002
      *  after each database error handling.                                                  CAP002
      *                                                                                       CAP002
      *  Rename filler field on LDA                                                           CAP002
      *  CRT001 changes mean that there is now a field ZZ019 on APOSTPD                       CAP002
      *  and associated PFs, which are held in a DS in some CG programs.                      CAP002
      *  The same field in two DS causes those programs to fail to                            CAP002
      *  compile - hence this version of ZZ019 is renamed.                                    CAP002
     D  DBZZ19       E                     EXTFLD(ZZ019)                                      CAP002
      *                                     134 141 DBFILE                                    CAP002
      *        Defines:                     142 170 DBKEY                                     CAP002
      *                                     171 180 DBPGM                                     CAP002
      *                                     181 1830DBASE                                     CAP002
      *                                                                                       CAP002
     D ERDTA         E DS                  EXTNAME(CGERDTA)                                   CAP002
      *                                                                                       CAP002
      *  Send message data structure                                                          CAP002
      *                                                                                       CAP002
      *                                       1  10 ERPGM                                     CAP002
      *                                      11  20 ERFILE                                    CAP002
      *                                      21  50 ERKEY                                     CAP002
      *                                      51  550ERERNB                                    CAP002
      *                                      56 135 ERNARR                                    CAP002
      *                                     136 145 ERSTK                                     CAP002
      *                                     146 175 ERPREF                                    CAP002
      *                                                                                       CAP002
     D M#DTA           DS           256                                                       CAP002
      *                                                                                       CAP002
      *  Message Data - Action field                                                          CAP002
      *                                                                                       CAP002
      *                          Field Text                                                   CAP002
     D  #MSGTX                 1     80                                                       CAP002
      *                          Data Text                                                    CAP002
     D  ##MSGD                81    256                                                       CAP002
                                                                                              CAP002
      *  Definition of fileds *ed out from SR/AOSNMS to prevent compilation                   CAP002
      *   errors                                                                              CAP002
     D AOMSID          S              7A                                                      CAP002
     D AOMSGF          S             10A                                                      CAP002
     D AOMSFL          S             10A                                                      CAP002
     D AOMSDT          S            256A                                                      CAP002
     D AOPGRL          S              5A                                                      CAP002
     D AOPGMQ          S             10A                                                      CAP002
     D AOMSGQ          S             10A                                                      CAP002
     D AOMSGT          S              7A                                                      CAP002
     D COBST           S              4A                                                      CCB020
     I*****************************************************************
     C/EJECT
      *
      **  Copyright
     C                   MOVEA     ##CPY         ##CPY2           80
      *
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    I@PARM                         I:Parameters
     C                   PARM                    O@PARM                         O:Parameters
     C                   PARM                    MsgID1            7                          CAP002
     C                   PARM                    MsgID2            7                          CAP002
     C                   PARM                    MsgID3            7                          CAP002
     C                   PARM                    MsgDta1          45                          CAP002
     C                   PARM                    MsgDta2          45                          CAP002
     C                   PARM                    MsgDta3          45                          CAP002
     C                   PARM                    P@FMT                          O:Format
                                                                                              CAP002
     C                   CLEAR                   MsgID1                                       CAP002
     C                   CLEAR                   MsgID2                                       CAP002
     C                   CLEAR                   MsgID3                                       CAP002
     C                   CLEAR                   MsgDta1                                      CAP002
     C                   CLEAR                   MsgDta2                                      CAP002
     C                   CLEAR                   MsgDta3                                      CAP002
      *                                                                                       CSC022
      * Access SAR details file to determine if CSC022 switchable feature                     CSC022
      * is switched on                                                                        CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @@RTCD                                       CSC022
     C                   PARM      '*VERIFY'     @@OPTN                                       CSC022
     C                   PARM      'CSC022'      @@SARD            6                          CSC022
                                                                                              CSC022
     C                   IF        @@RTCD = *Blanks                                           CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   IN        SCCMTJOB                                                   CSC022
     C                   Z-ADD     1             CNT               3 0                        CSC022
     C                   MOVEL     *BLANKS       COMITSKIP         1                          CSC022
     C                   MOVEA     COMITARR      COMITJOB                                     CSC022
     C     COMITNUM      IFGT      0                                                          CSC022
     C     CNT           DOWLE     COMITNUM                                                   CSC022
     C     ##JOB         IFEQ      COMITJOB(CNT)                                              CSC022
     C                   MOVEL     'Y'           COMITSKIP                                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ADD       1             CNT                                          CSC022
     C                   ENDDO                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CAP002
                                                                                              CAP002
      *
      ** Execute Subroutine 'MAIN'.
      *
     C                   EXSR      MAIN
      *
      ** Return to caller :
      *
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  INDEX OF SUBROUTINES                                         *
      *                                                               *
      *  MAIN - Main Process                                          *
      *  SRPORT - Validate Customer Portfolio Details                 *
      *  SRBANK - Validate Bank Portfolio Details                     *
      *  SRCUST - Validate Customer Portfolio Details                 *
      *  BRANCH Recover Branch Details                                *
      *  SRBOOK - Validate Book Details                               *
      *  PORT   Recover Portfolio Customer Details                    *
      *  BOOK1  Recover Book Details for portfolio reference          *
      *  BOOK2  Recover Book Details for Book code entered            *
      *                                                               *
      *****************************************************************
      *
      *****************************************************************
      *                                                               *
      *  MAIN - Main Process                                          *
      *                                                               *
      *****************************************************************
      *
     C     MAIN          BEGSR
      *
     C                   SETOFF                                       90         ¦ Reset error
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF   FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      SDPLCSL0                                       Open file
      *
      ** Access Midas Phas
     C******DTAARA       DEFINE    MPHAS         MPHASE                                       CCB020
     C**********         IN        MPHASE                                                     CCB020
     C                   CALL      'CBC001001'                                                CCB020
     C                   PARM      *BLANKS       COBST                                        CCB020
     C                   END                                                    FI
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF  FREE PGM
     C                   CLOSE     SDPLCSL0                                       Close file
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF
     C     P@OPTN        OREQ      '*VERIFY'                                    OR
     C                   EXSR      SRPORT
     C                   ENDIF                                                  FI
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF
     C     P@OPTN        ANDNE     '*VERIFY'                                    AND
     C     P@OPTN        ANDNE     '*FREE  '                                    AND
     C                   SETON                                          90        Parm error
     C                   END                                                    FI
      *
      * No record found or End of file - return error code :
      *          _____________
     C     T@SKIP        TAG                                                    +++ SKIP +++
      *          ~~~~~~~~~~~~~
     C   90              MOVE      '*OPTION'     P@RTCD                         Option error
      *
      * Caller requests~message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF  SEND MSG
     C     P@RTCD        ANDNE     *BLANK                                       AND ERROR
     C   90              MOVE      'ACO1007'     P@MGID                           Option error
     C                   CALLB     'ZASNMG'                                       <SEND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      ##PGM         P@PGNM           10              I:Pgm name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA                           I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI
      *
      * Caller requests DB error handling
      *
     C     W@RTCD        IFEQ      '*DBERR '                                    IF
     C     P@RTCD        ANDNE     *BLANK                                       AND
     C     P@RTCD        OREQ      '*DBERR '                                    OR
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF
     C                   MOVEL     D@FMT         P@FMT
     C                   END                                                    FI
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPORT - Validate Customer Portfolio Details                 *
      *                                                               *
      *****************************************************************
      *
     CSR   SRPORT        BEGSR
      *
      * Clear output structures
      *
     C                   CLEAR                   O@PARM
      *
      * If Bank Portfolios are supported
      *
     C     I#PORS        IFEQ      'B'
     C                   EXSR      SRBANK
     C                   ELSE
     C                   EXSR      SRCUST
     C                   ENDIF
      *
     CSR   EXPORT        ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRBANK - Validate Bank Portfolio Details                     *
      *                                                               *
      *****************************************************************
      *
     CSR   SRBANK        BEGSR
      *
      * Get branch internal customer of branch
      *
     C                   EXSR      BRANCH
      *
      * If branch exists then access Customer Portfolio details
      *
     C     @@RTCD        IFEQ      *BLANKS
     C                   MOVEL     O#BICN        QBCUST            6
     C                   EXSR      PORT
      *
      * If Customer Portfolio details exist access book details
      *
     C     *IN94         IFEQ      *OFF
     C                   EXSR      SRBOOK
     C                   ENDIF
      *
     C                   ENDIF
      *
     CSR   EXBANK        ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCUST - Validate Customer Portfolio Details                 *
      *                                                               *
      *****************************************************************
      *
     CSR   SRCUST        BEGSR
      *
      * If Bank Portfolios are not supported, use customer supplied
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @@RTCD
     C                   PARM      '*KEY   '     @@OPTN
     C                   PARM      I#CUST        @@CUST
     C                   PARM      *BLANKS       @@KYST
     C     SDCUST        PARM      SDCUST        DSSDY
     C     @@RTCD        IFEQ      *BLANK                                       136429
     C                   MOVEL     BBCUST        QBCUST
     C                   MOVEL     *BLANK        I#CUST
     C                   MOVEL     BBCUST        I#CUST
     C                   END                                                    136429
      *
      * Access Customer Portfolio details
      *
     C                   EXSR      PORT
      *
     CSR   EXCUST        ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  BRANCH Recover Branch Details                                *
      *                                                               *
     C*****************************************************************
      *
     C     BRANCH        BEGSR
      *
      * If B1 is greater than zero look up branch in array
      *
     C                   MOVEL     *BLANK        @@RTCD
      *
     C     B1            IFGT      0
     C     I#BRCA        ANDNE     *BLANKS
     C                   Z-ADD     1             Z                 3 0
     C     I#BRCA        LOOKUP    ZBR(Z)                                 99    *
     C                   ENDIF
      *
      * If not found then find branch details
      *
     C     B1            IFEQ      0
     C     *IN99         OREQ      '0'
      *
      ** Access branch details
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM      '*KEY   '     @@OPTN            7
     C                   PARM      I#BRCA        @@BRCA            3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      ** Access customer details only if branch found
      *
     C     @@RTCD        IFEQ      *BLANK
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @@RTCD
     C                   PARM      '*KEY   '     @@OPTN
     C                   PARM      A8BICN        @@CUST           10
     C                   PARM      *BLANKS       @@KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   ENDIF
      *
      * If found store details
      *
     C     @@RTCD        IFEQ      *BLANK
     C                   ADD       1             B1                5 0
      *
      * If full start from beginning again
      *
     C     B1            IFGT      99
     C                   Z-ADD     1             B1
     C                   ENDIF
      *
      * Fill details
      *
     C                   MOVEL     A8BRCD        ZBR(B1)
     C                   MOVEL     A8BICN        ZBC(B1)
     C                   MOVEL     BBCRNM        ZBN(B1)
     C                   MOVE      BBACOC        ZBN(B1)
     C                   Z-ADD     B1            Z
     C                   ENDIF
     C                   ENDIF
      *
      * If found retrieve details else Db err
      *
     C     @@RTCD        IFEQ      *BLANK
     C                   MOVEL     ZBC(Z)        O#BICN
     C                   MOVEL     ZBN(Z)        O#CRNM
     C                   MOVE      ZBN(Z)        O#ACOF
     C                   ELSE
     C     I#BRCA        CAT(P)    ' '           AOMSDT
     C                   MOVEL     'PMA0007'     AOMSID
     C                   MOVEL     I#CPGM        AOPGMQ
     C                   MOVEL     '*DIAG'       AOMSGT
     C                   MOVEL     'PMUSRMSG'    AOMSGF
     C                   EXSR      AOSNMS
     C                   MOVEL     'PMA0007'     P@RTCD
     C                   ENDIF
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRBOOK - Validate Book Details                               *
      *                                                               *
      *****************************************************************
      *
     CSR   SRBOOK        BEGSR
      *
      * If input book is blank
      * get book code for portfolio reference
      *
     C     I#BOOK        IFEQ      *BLANK
      *
     C     O#PTFR        IFNE      *BLANK
     C                   EXSR      BOOK1
     C                   ENDIF
      *
      * If input book is not blank
      * Get associated portfolio of book
      *
     C                   ELSE
      *
     C                   EXSR      BOOK2
      *
     C                   ENDIF
      *
     CSR   EXBOOK        ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  PORT   Recover Portfolio Customer Details                    *
      *                                                               *
      *****************************************************************
      *
     C     PORT          BEGSR
      *
      * If phase is not Input Cycle then use caching subroutine
      *
     C*****MPHASE        IFNE      'A'                                                        CCB020
     C                   IF        COBST = '*YES'                                             CCB020
     C                   EXSR      SRPLCS
     C                   ELSE
      *
      * Access Portfolio Management Customer Details
      *
     C     QBCUST        CHAIN     @PLCSL0                            94          Get record
     C                   ENDIF
      *
      * Record not found
      *
     C     *IN94         IFEQ      *ON
     C     *IN94         OREQ      *OFF
     C     QBRECI        ANDEQ     '*'
     C                   MOVE      *ON           *IN94
      *
      * Only send message if input Portfolio Reference is not blank
      *
     C     I#PTFR        IFNE      *BLANK
      *
     C     I#PORS        IFEQ      'B'
     C                   MOVEL     'PMA0008'     AOMSID
     C                   ELSE
     C                   MOVEL     'PMA0009'     AOMSID
     C                   ENDIF
     C     QBCUST        CAT(P)    ' '           AOMSDT
     C                   MOVEL     '*DIAG'       AOMSGT
     C                   MOVEL     I#CPGM        AOPGMQ
     C                   MOVEL     'PMUSRMSG'    AOMSGF
     C                   EXSR      AOSNMS
      *
     C                   ENDIF
      *
     C     I#PORS        IFEQ      'B'
     C                   MOVEL     'PMA0008'     P@RTCD
     C                   ELSE
     C                   MOVEL     'PMA0009'     P@RTCD
     C                   ENDIF
      *
     C                   END
      *
      * Default Portfolio Reference
      *
     C     I#PTFR        IFEQ      *BLANK
      *
     C     QBDFPO        IFNE      *BLANK
     C     QBDFPO        ANDNE     '9997'
     C                   MOVEL     QBDFPO        O#PTFR
     C                   ELSE
     C                   MOVEL     I#R997        O#PTFR
     C                   END
      *
     C                   ELSE
      *
     C                   MOVEL     I#PTFR        O#PTFR
     C                   ENDIF
      *
     C     PORTEX        ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  BOOK1  Recover Book Details for portfolio reference          *
      *                                                               *
      *****************************************************************
      *
     C     BOOK1         BEGSR
      *
      * If B2 is greater than zero look up Portfolio in array
      *
     C                   MOVEL     *BLANK        @@RTCD
      *
     C     B2            IFGT      0
     C                   Z-ADD     1             Z
     C     O#PTFR        LOOKUP    ZBP(Z)                                 99    *
     C                   ENDIF
      *
      * If not found then find Portfolio details
      *
     C     B2            IFEQ      0
     C     *IN99         OREQ      '0'
      *
      ** Access book details (by portfolio reference)
      *
     C     O#PTFR        IFEQ      I#R997
     C                   MOVEL     '9997'        @@PTFR
     C                   ELSE
     C                   MOVEL     O#PTFR        @@PTFR
     C                   ENDIF
      *
     C                   CALLB     'AOBOOKR1'
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM      '*KEY   '     @@OPTN            7
     C                   PARM                    @@PTFR            4
     C     SDBOOK        PARM      SDBOOK        DSSDY
      *
     C     @@RTCD        IFEQ      *BLANK
     C                   ADD       1             B2                5 0
      *
      * If full start from beginning again
      *
     C     B2            IFGT      99
     C                   Z-ADD     1             B2
     C                   ENDIF
      *
      * Fill details
      *
     C                   MOVEL     BDBKCD        ZBK(B2)
     C                   MOVEL     BDASPR        ZBP(B2)
     C                   Z-ADD     B2            Z
     C                   ENDIF
     C                   ENDIF
      *
      * If found retrieve details else Db err
      *
     C     @@RTCD        IFEQ      *BLANK
     C                   MOVEL     ZBK(Z)        O#BOOK
     C                   ELSE
     C*  Record not found
     C     O#PTFR        CAT(P)    ' '           AOMSDT
     C                   MOVEL     'PMA0010'     AOMSID
     C                   MOVEL     I#CPGM        AOPGMQ
     C                   MOVEL     '*DIAG'       AOMSGT
     C                   MOVEL     'PMUSRMSG'    AOMSGF
     C                   EXSR      AOSNMS
     C                   MOVEL     'PMA0010'     P@RTCD
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BOOK2  Recover Book Details for Book code entered            *
      *                                                               *
      *****************************************************************
      *
     C     BOOK2         BEGSR
      *
      * If B2 is greater than zero look up Portfolio in array
      *
     C                   MOVEL     *BLANK        @@RTCD
     C                   MOVEL     I#BOOK        O#BOOK
      *
     C     B2            IFGT      0
     C                   Z-ADD     1             Z
     C     O#BOOK        LOOKUP    ZBK(Z)                                 99    *
     C                   ENDIF
      *
      * If not found then find Portfolio details
      *
     C     B2            IFEQ      0
     C     *IN99         OREQ      '0'
      *
      ** Access book details (by portfolio reference)
      *
     C                   CALLB     'AOBOOKR0'
     C                   PARM      *BLANKS       @@RTCD
     C                   PARM      '*KEY   '     @@OPTN
     C                   PARM      O#BOOK        @@BOOK            2
     C     SDBOOK        PARM      SDBOOK        DSSDY
      *
     C     @@RTCD        IFEQ      *BLANK
     C                   ADD       1             B2                5 0
      *
      * If full start from beginning again
      *
     C     B2            IFGT      99
     C                   Z-ADD     1             B2
     C                   ENDIF
      *
      * Fill details
      *
     C                   MOVEL     BDBKCD        ZBK(B2)
     C                   MOVEL     BDASPR        ZBP(B2)
     C                   Z-ADD     B2            Z
     C                   ENDIF
     C                   ENDIF
      *
      * If found retrieve details else, DB error.
      *
     C     @@RTCD        IFEQ      *BLANK
     C     ZBP(Z)        IFEQ      '9997'
     C                   MOVEL     I#R997        O#PTFR
     C                   ELSE
     C                   MOVEL     ZBP(Z)        O#PTFR
     C                   ENDIF
     C                   ELSE
     C     O#BOOK        CAT(P)    ' '           AOMSDT
     C                   MOVEL     'PMA0015'     AOMSID
     C                   MOVEL     I#CPGM        AOPGMQ
     C                   MOVEL     '*DIAG'       AOMSGT
     C                   MOVEL     'PMUSRMSG'    AOMSGF
     C                   EXSR      AOSNMS
     C                   MOVEL     'PMA0015'     P@RTCD
     C                   ENDIF
     C*
     C**  Book is not associated with a portfolio.
     C*
     C     O#PTFR        IFEQ      *BLANKS
     C     O#BOOK        CAT(P)    ' '           AOMSDT
     C                   MOVEL     'PMA0011'     AOMSID
     C                   MOVEL     I#CPGM        AOPGMQ
     C                   MOVEL     '*DIAG'       AOMSGT
     C                   MOVEL     'PMUSRMSG'    AOMSGF
     C                   EXSR      AOSNMS
     C                   MOVEL     'PMA0011'     P@RTCD
     C                   ENDIF
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPLCS Get Portfolio Customer Details                        *
      *                                                               *
      *****************************************************************
      *
     C     SRPLCS        BEGSR
      *
      * Set indicator 94 to Off to show record found
      *
     C                   MOVEL     *OFF          *IN94
      *
     C     B3            IFGT      0
     C                   Z-ADD     1             Z
     C     QBCUST        LOOKUP    ZCS(Z)                                 99    *
     C                   ENDIF
      *
      * If not found then find Portfolio details
      *
     C     B3            IFEQ      0
     C     *IN99         OREQ      '0'
      *
     C                   BITOFF    '01234567'    ##X00             1
      *
      ** Access Customer Portfolio Details
      *
     C     QBCUST        CHAIN     @PLCSL0                            94
      *
      * Record not found
      *
     C     *IN94         IFEQ      *ON
     C     *LIKE         DEFINE    QBCUST        ##CUST
     C                   MOVEL     QBCUST        ##CUST
     C                   CLEAR                   D@FMT
     C                   MOVEL     ##CUST        QBCUST
     C                   BITOFF    '01234567'    QBRECI
     C                   ENDIF
      *
      * Record Deleted
      *
     C     *IN94         IFEQ      *OFF
     C     QBRECI        ANDEQ     '*'
     C                   MOVEL     *ON           *IN94
     C                   ENDIF
      *
      *
     C                   ADD       1             B3                5 0
      *
      * If full start from beginning again
      *
     C     B3            IFGT      99
     C                   Z-ADD     1             B3
     C                   ENDIF
      *
      * Fill details
      *
     C                   MOVEL     QBCUST        ZCS(B3)
     C     B3            OCCUR     PLCS
     C                   MOVEL     D@FMT         PLCS
     C                   Z-ADD     B3            Z
     C                   ENDIF
      *
      * Retrieve details
      *
     C     Z             OCCUR     PLCS
     C                   MOVEL     PLCS          D@FMT
      *
      * Record not found or deleted
      *
     C     QBRECI        IFEQ      ##X00
     C     *IN94         OREQ      *OFF
     C     QBRECI        ANDEQ     '*'
     C                   MOVEL     *OFF          *IN94
     C                   ENDIF
      *
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *
      * File and Program Error Processing
      *
     C**/COPY AOCPYSRC,SRERRC                                                                 CAP002
      *****************************************************************                       CAP002
      *                                                               *                       CAP002
      *  SRFILE   : *PSSR routine for all files                       *                       CAP002
      *                                                               *                       CAP002
      *  CALLED BY: IBM controlled - invalid access to file           *                       CAP002
      *                                                               *                       CAP002
      *  CALLS    : AOZERROR                                          *                       CAP002
      *                                                               *                       CAP002
      * In the INIT sub-routine, the fields W0MSGD and W0MSGF should  *                       CAP002
      * be set to the default message I.D and message file that are   *                       CAP002
      * used for the module. If not, the defaults of MEM5002 and MIDAS*                       CAP002
      * will be used.                                                 *                       CAP002
      *                                                               *                       CAP002
      *****************************************************************                       CAP002
     CSR   SRFILE        BEGSR                                                                CAP002
      *                                                                                       CAP002
      *  Dump program                                                                         CAP002
      *                                                                                       CAP002
     C                   DUMP                                                                 CAP002
     C     CSC022        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                          90                    CAP002
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                          90                    CSC022
     C                   END                                                                  CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CAP002
      *  If called again seton LR and return                                                  CAP002
      *                                                                                       CAP002
     C     @@FILE        IFNE      *BLANKS                                                    CAP002
     C                   MOVEL     '1'           *INLR                                        CAP002
     C                   RETURN                                                               CAP002
     C                   END                                                                  CAP002
      *                                                                                       CAP002
     C                   MOVEL     'Y'           @@FILE            1                          CAP002
      *                                                                                       CAP002
      *  Send message to MOPERQ                                                               CAP002
      *                                                                                       CAP002
     C                   MOVEL     *BLANKS       ERDTA                                        CAP002
     C                   MOVEL     ##PGM         ERPGM                                        CAP002
      *                                                                                       CAP002
     C     Q             IFGT      1                                                          CAP002
     C     Q             ANDLT     101                                                        CAP002
     C                   MOVEL     @STK(Q)       ERSTK                                        CAP002
     C                   ELSE                                                                 CAP002
     C                   MOVEL     '*Nostkin'    ERSTK                                        CAP002
     C                   END                                                                  CAP002
      *                                                                                       CAP002
     C                   MOVEL     ##ERST        ERKEY                                        CAP002
     C                   Z-ADD     999           ERERNB                                       CAP002
     C                   MOVEL     ##ERFL        ERFILE                                       CAP002
     C                   MOVEL     W0PREF        ERPREF                                       CAP002
      *                                                                                       CAP002
      * Get message for sending and place in msg field                                        CAP002
      *                                                                                       CAP002
     C                   CALL      'SDRTVTXT'                           9090                  CAP002
     C                   PARM      'MEM5002'     #MSGID                                       CAP002
     C                   PARM      'MIDAS   '    #MSGF                                        CAP002
     C                   PARM      *BLANKS       #MSGTX                                       CAP002
      *                                                                                       CAP002
     C                   MOVEL     #MSGTX        ERNARR                                       CAP002
      *                                                                                       CAP002
      * Send message                                                                          CAP002
      *                                                                                       CAP002
     C                   CALL      'AOCREPT'                            9090                  CAP002
     C                   PARM      'MEM5000'     #MSGID            7                          CAP002
     C                   PARM      'MIDAS  '     #MSGF            10                          CAP002
     C                   PARM      *BLANKS       #MSGFL           10                          CAP002
     C                   PARM      ERDTA         #MSGDT          256                          CAP002
     C                   PARM      '*PRV'        #MSGR             5                          CAP002
     C                   PARM      '*'           #PRGM            10                          CAP002
     C                   PARM      'MOPERQ '     #MSGQ            10                          CAP002
     C                   PARM      '*INFO  '     #MSGT             7                          CAP002
      *                                                                                       CAP002
      *  Fill LDA with error data                                                             CAP002
      *                                                                                       CAP002
     C     *LOCK         IN        LDA                                                        CAP002
     C                   MOVEL     W0KEY         DBKEY                                        CAP002
     C                   Z-ADD     W0ERNB        DBASE                                        CAP002
     C                   MOVEL     W0FILE        DBFILE                                       CAP002
     C                   MOVEL     ##PGM         DBPGM                                        CAP002
     C                   OUT       LDA                                                        CAP002
      *                                                                                       CAP002
      *  Close down program                                                                   CAP002
      *                                                                                       CAP002
     C                   SETON                                        U7U8LR                  CAP002
     C                   MOVEL     '*ERROR*'     W0RTN             7                          CAP002
     C*                                                                                       CAP002
     C* Provide a fuller report:                                                              CAP002
     C*                                                                                       CAP002
     C                   MOVEA     @STK          #@STK           100                          CAP002
     C*                                                                                       CAP002
     C                   CALL      'AOZERROR'                           9090                  CAP002
     C                   PARM                    ##ERTN            7                          CAP002
     C                   PARM                    DSPGM                                        CAP002
     C                   PARM                    ERDTA                                        CAP002
     C                   PARM                    #@STK                                        CAP002
      *                                                                                       CAP002
     C                   RETURN                                                               CAP002
      *                                                                                       CAP002
     CSR   EXFILE        ENDSR                                                                CAP002
     C/EJECT                                                                                  CAP002
      *****************************************************************                       CAP002
      *                                                               *                       CAP002
      *  SRERR    : Report error and close down program               *                       CAP002
      *                                                               *                       CAP002
      *  CALLED BY: All subroutines                                   *                       CAP002
      *                                                               *                       CAP002
      *  CALLS    : AOZERROR                                          *                       CAP002
      *                                                               *                       CAP002
      * In the INIT sub-routine, the fields W0MSGD and W0MSGF should  *                       CAP002
      * be set to the default message I.D and message file that are   *                       CAP002
      * used for the module. If not, the defaults of MEM5001 and MIDAS*                       CAP002
      * will be used.                                                 *                       CAP002
      *                                                               *                       CAP002
      *****************************************************************                       CAP002
     CSR   SRERR         BEGSR                                                                CAP002
      *                                                                                       CAP002
      *  Define work variables                                                                CAP002
      *                                                                                       CAP002
     C     *LIKE         DEFINE    ERKEY         W0KEY                                        CAP002
     C     *LIKE         DEFINE    ERERNB        W0ERNB                                       CAP002
     C     *LIKE         DEFINE    ERFILE        W0FILE                                       CAP002
     C     *LIKE         DEFINE    ERPREF        W0PREF                         Primary Ref.  CAP002
      *                                                                                       CAP002
     C     *LIKE         DEFINE    #MSGID        W0MSGD                         Msg I.D.      CAP002
     C     *LIKE         DEFINE    #MSGF         W0MSGF                         Msg File      CAP002
      *                                                                                       CAP002
     C                   Z-ADD     Q             Q                 5 0                        CAP002
      *                                                                                       CAP002
      *  Dump program                                                                         CAP002
      *                                                                                       CAP002
     C                   DUMP                                                                 CAP002
     C     CSC022        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                          90                    CAP002
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                          90                    CSC022
     C                   END                                                                  CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CAP002
      *  Set up the details of the message to be sent to MOPERQ                               CAP002
      *                                                                                       CAP002
     C                   MOVEL     *BLANKS       ERDTA                                        CAP002
     C                   MOVEL     ##PGM         ERPGM                                        CAP002
      *                                                                                       CAP002
     C     Q             IFGT      1                                                          CAP002
     C     Q             ANDLT     101                                                        CAP002
     C                   MOVEL     @STK(Q)       ERSTK                                        CAP002
     C                   ELSE                                                                 CAP002
     C                   MOVEL     '*Nostkin'    ERSTK                                        CAP002
     C                   END                                                                  CAP002
      *                                                                                       CAP002
     C                   MOVEL     W0KEY         ERKEY                                        CAP002
     C                   Z-ADD     W0ERNB        ERERNB                                       CAP002
     C                   MOVEL     W0FILE        ERFILE                                       CAP002
     C                   MOVEL     W0PREF        ERPREF                                       CAP002
      *                                                                                       CAP002
      * Get message for message code. If the msg code or the msg file                         CAP002
      * have not been set up then use the defaults.                                           CAP002
      *                                                                                       CAP002
     C     W0MSGD        IFEQ      *BLANKS                                                    CAP002
     C                   MOVEL     'MEM5001'     C#FMSG            7                          CAP002
     C                   ELSE                                                                 CAP002
     C                   MOVEL     W0MSGD        C#FMSG                                       CAP002
     C                   END                                                                  CAP002
      *                                                                                       CAP002
     C     W0MSGF        IFEQ      *BLANKS                                                    CAP002
     C                   MOVEL     'MIDAS   '    C#FMSF           10                          CAP002
     C                   ELSE                                                                 CAP002
     C                   MOVEL     W0MSGF        C#FMSF                                       CAP002
     C                   END                                                                  CAP002
      *                                                                                       CAP002
     C                   CALL      'SDRTVTXT'                           9090                  CAP002
     C                   PARM      C#FMSG        #MSGID                                       CAP002
     C                   PARM      C#FMSF        #MSGF                                        CAP002
     C                   PARM      *BLANKS       #MSGTX                                       CAP002
      *                                                                                       CAP002
     C                   MOVEL     #MSGTX        ERNARR                                       CAP002
      *                                                                                       CAP002
      * Send message                                                                          CAP002
      *                                                                                       CAP002
     C                   CALL      'AOCREPT'                            9090                  CAP002
     C                   PARM      'MEM5000'     #MSGID            7                          CAP002
     C                   PARM      'MIDAS  '     #MSGF            10                          CAP002
     C                   PARM      *BLANKS       #MSGFL           10                          CAP002
     C                   PARM      ERDTA         #MSGDT          256                          CAP002
     C                   PARM      '*PRV '       #MSGR             5                          CAP002
     C                   PARM      '*'           #PRGM            10                          CAP002
     C                   PARM      'MOPERQ '     #MSGQ            10                          CAP002
     C                   PARM      '*INFO  '     #MSGT             7                          CAP002
      *                                                                                       CAP002
      *  Fill LDA with error data                                                             CAP002
      *                                                                                       CAP002
     C     *DTAARA       DEFINE                  LDA                                          CAP002
     C     *LOCK         IN        LDA                                                        CAP002
     C                   MOVEL     W0KEY         DBKEY                                        CAP002
     C                   Z-ADD     W0ERNB        DBASE                                        CAP002
     C                   MOVEL     W0FILE        DBFILE                                       CAP002
     C                   MOVEL     ##PGM         DBPGM                                        CAP002
     C                   OUT       LDA                                                        CAP002
      *                                                                                       CAP002
      *  Close down program                                                                   CAP002
      *                                                                                       CAP002
     C                   SETON                                        U7U8LR                  CAP002
     C                   MOVEL     '*ERROR*'     W0RTN             7                          CAP002
     C*                                                                                       CAP002
     C* Provide a fuller report:                                                              CAP002
     C*                                                                                       CAP002
     C                   MOVEA     @STK          #@STK           100                          CAP002
     C*                                                                                       CAP002
     C                   CALL      'AOZERROR'                           9090                  CAP002
     C                   PARM                    ##ERTN            7                          CAP002
     C                   PARM                    DSPGM                                        CAP002
     C                   PARM                    ERDTA                                        CAP002
     C                   PARM                    #@STK                                        CAP002
     C* End the program:                                                                      CAP002
     C                   RETURN                                                               CAP002
      *                                                                                       CAP002
     CSR   EXERR         ENDSR                                                                CAP002
     C/EJECT                                                                                  CAP002
     C**/COPY AOCPYSRC,SRERRPSSR                                                              CAP002
     C*****************************************************************                       CAP002
     C**  Subroutine *PSSR handles program errors.                   **                       CAP002
     C**                                                             **                       CAP002
     C**  Note: this routine requires copy member SRERRI or          **                       CAP002
     C**        its equivalent in the input specifications.          **                       CAP002
     C**                                                             **                       CAP002
     C**                                                             **                       CAP002
     C*****************************************************************                       CAP002
     C     *PSSR         BEGSR                                                  ** *PSSR  **  CAP002
     C*                                                                                       CAP002
     C                   DUMP                                                                 CAP002
     C     CSC022        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                          90                    CAP002
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                          90                    CSC022
     C                   END                                                                  CSC022
     C                   ENDIF                                                                CSC022
     C*                                                                                       CAP002
     C* If second time through, halt:                                                         CAP002
     C*                                                                                       CAP002
     C     @@PSSR        IFNE      *BLANK                                                     CAP002
     C                   SETON                                        H1  LR                  CAP002
     C                   RETURN                                                               CAP002
     C                   ENDIF                                                                CAP002
     C*                                                                                       CAP002
     C* Flag routine as started; define action code:                                          CAP002
     C*                                                                                       CAP002
     C                   MOVE      'Y'           @@PSSR            1                          CAP002
     C                   MOVE      W0ACT         W0ACT             8                          CAP002
     C*___________________________________________________________________                    CAP002
     C*                                                                                       CAP002
     C* Any other mode or type of error.                                                      CAP002
     C*                                                                                       CAP002
     C* Set LDA values and format message for MOPERQ:                                         CAP002
     C*                                                                                       CAP002
     C                   MOVE      ##PGM         ERPGM                                        CAP002
     C                   MOVE      ##RTVN        ERFILE                                       CAP002
     C     ##MSID        CAT(P)    ##SQNO        ERKEY                                        CAP002
     C                   Z-ADD     998           ERERNB                                       CAP002
     C                   MOVEL     ##MSWK        ERNARR                                       CAP002
     C*                                                                                       CAP002
     C* Move data to the LDA data area:                                                       CAP002
     C*                                                                                       CAP002
     C     *LOCK         IN        LDA                                                        CAP002
     C                   MOVEL     W0KEY         DBKEY                                        CAP002
     C                   Z-ADD     W0ERNB        DBASE                                        CAP002
     C                   MOVEL     W0FILE        DBFILE                                       CAP002
     C                   MOVEL     ##PGM         DBPGM                                        CAP002
     C                   OUT       LDA                                                        CAP002
     C*                                                                                       CAP002
     C* Provide a fuller report:                                                              CAP002
     C*                                                                                       CAP002
     C                   MOVEA     @STK          #@STK           100                          CAP002
     C*                                                                                       CAP002
     C                   CALL      'AOZERROR'                           9090                  CAP002
     C                   PARM                    ##ERTN            7                          CAP002
     C                   PARM                    DSPGM                                        CAP002
     C                   PARM                    ERDTA                                        CAP002
     C                   PARM                    #@STK                                        CAP002
     C* End the program:                                                                      CAP002
     C                   SETON                                        U7U8LR                  CAP002
     C                   MOVE      '*ERROR*'     W0RTN             7                          CAP002
     C                   RETURN                                                               CAP002
     C*                                                                                       CAP002
     C*                                                                                       CAP002
     C                   ENDSR                                                                CAP002
     C*****************************************************************                       CAP002
     C**/COPY AOCPYSRC,SAOSNMSC                                                               CAP002
      **********************************************************************                  CAP002
      *                                                                    *                  CAP002
      *  AOSNMS   : Was 'Send message to program's message queue'          *                  CAP002
      *             Changed to 'Store error MSGIDs for return to caller'   *                  CAP002
      *                                                                    *                  CAP002
      *  CALLED BY: When reporting errors                                  *                  CAP002
      *                                                                    *                  CAP002
      *  CALLS    : *NONE                                                  *                  CAP002
      *                                                                    *                  CAP002
      **********************************************************************                  CAP002
     CSR   AOSNMS        BEGSR                                                                CAP002
      *                                                                                       CAP002
      *  Set up subroutine stack name                                                         CAP002
      *                                                                                       CAP002
     C                   ADD       1             Q                                            CAP002
     C                   MOVEL     'AOSNMS'      @STK(Q)                                      CAP002
      *                                                                                       CAP002
      * If no program send to ##PGM                                                           CAP002
      *                                                                                       CAP002
     C     AOPGMQ        IFEQ      *BLANK                                                     CAP002
     C                   MOVEL     ##PGM         AOPGMQ                                       CAP002
     C                   END                                                                  CAP002
      *                                                                                       CAP002
      * If level to send is blanks default to *SAME                                           CAP002
      *                                                                                       CAP002
     C     AOPGRL        IFEQ      *BLANK                                                     CAP002
     C                   MOVEL     '*SAME'       AOPGRL                                       CAP002
     C                   END                                                                  CAP002
      *                                                                                       CAP002
      * If no message file specified, use default                                             CAP002
      *                                                                                       CAP002
     C     AOMSGF        IFEQ      *BLANK                                                     CAP002
     C                   MOVEL     'AOUSRMSG'    AOMSGF                                       CAP002
     C                   END                                                                  CAP002
      *                                                                                       CAP002
      *--------- Changes relative to original AOSNMS start here ------------                  CAP002
      *                                                                                       CAP002
     C*******************CALL      'AOCREPT'                                                  CAP002
     C*******************PARM                    AOMSID            7                          CAP002
     C*******************PARM                    AOMSGF           10                          CAP002
     C*******************PARM                    AOMSFL           10                          CAP002
     C*******************PARM                    AOMSDT          256                          CAP002
     C*******************PARM                    AOPGRL            5                          CAP002
     C*******************PARM                    AOPGMQ           10                          CAP002
     C*******************PARM                    AOMSGQ           10                          CAP002
     C*******************PARM                    AOMSGT            7                          CAP002
      *                                                                                       CAP002
     C                   MOVEL     'Y'           AOMSGS            1                          CAP002
      *                                                                                       CAP002
      *  Store the error message ID and data in the next available fields                     CAP002
     C                   SELECT                                                               CAP002
      *                                                                                       CAP002
     C                   WHEN      MsgID1 = *BLANK                                            CAP002
     C                   MOVEL     AOMSID        MsgID1                                       CAP002
     C                   MOVEL     AOMSDT        MsgDta1                                      CAP002
      *                                                                                       CAP002
     C                   WHEN      MsgID2 = *BLANK                                            CAP002
     C                   MOVEL     AOMSID        MsgID2                                       CAP002
     C                   MOVEL     AOMSDT        MsgDta2                                      CAP002
      *                                                                                       CAP002
     C                   WHEN      MsgID3 = *BLANK                                            CAP002
     C                   MOVEL     AOMSID        MsgID3                                       CAP002
     C                   MOVEL     AOMSDT        MsgDta3                                      CAP002
      *                                                                                       CAP002
     C                   ENDSL                                                                CAP002
      *                                                                                       CAP002
      *--------- Changes relative to original AOSNMS end here ------------                    CAP002
      *                                                                                       CAP002
      * Clear all fields for default mechanism next time                                      CAP002
      *                                                                                       CAP002
     C                   MOVEL     *BLANK        AOMSID                                       CAP002
     C                   MOVEL     *BLANK        AOMSGF                                       CAP002
     C                   MOVEL     *BLANK        AOMSFL                                       CAP002
     C                   MOVEL     *BLANK        AOMSDT                                       CAP002
     C                   MOVEL     *BLANK        AOPGRL                                       CAP002
     C                   MOVEL     *BLANK        AOPGMQ                                       CAP002
     C                   MOVEL     *BLANK        AOMSGQ                                       CAP002
     C                   MOVEL     *BLANK        AOMSGT                                       CAP002
      *                                                                                       CAP002
      *  Unwind subroutine stack name                                                         CAP002
      *                                                                                       CAP002
     C     AOEXIT        TAG                                                                  CAP002
     C                   MOVEA     *BLANKS       @STK(Q)                                      CAP002
     C                   SUB       1             Q                                            CAP002
      *                                                                                       CAP002
     CSR                 ENDSR                                                                CAP002
     C*****************************************************************
**CTDATA @MG
SDPLCSL0  AOPLCSR2  Customer Details
**CTDATA ##CPY
(c) Finastra International Limited 2001
