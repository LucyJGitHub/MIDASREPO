     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP034
/*STD *  RPGBASEMOD                                                   *   CAP034
/*EXI *  TEXT('Midas AO Portfolio management cust detail acc obj')    *
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  AOPLCSR1 - PORTFOLIO MANAGEMENT CUSTOMER DETAILS             *
      *                                                               *
      *  Function: Access record from SDPLCSL0.                       *
      *                                                               *
      *  This function can return the SDPLCSPD format as well as      *
      *  extra information on book, portfolio and customer.           *
      *                                                               *
      *  The control of information return is controlled other than   *
      *  the standard return code for access objects                  *
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
      *                 199089             Date 04Jul02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034             Date 07Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
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
      *  199089 - Avoid access SDPLCSPD for PB but not PM cust.       *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP034 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
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
      **+--- The converted SRERRE starts here ------------------------+
      *
     D @STK            S             10    DIM(100)
     D @REC            S              3  0 DIM(100)
      *
      *  Subroutine stack
      *
      **+--- The converted SRERRE ends here --------------------------+
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
      *   APPLCSR1 Input Parameters:    Bank Port        Cust Port
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
      * Refine for MOVEL/MOVE test
     D  W#CNML                 6     11
     D  W#CNMR                10     15
     D  W#BLNK                12     15
      *
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34
      *
      *   AOPLCSR1 Output Parameters:   Bank Port        Cust Port
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
      ** External data structure for access programs (very long)                199089
     D DSLDY         E DS                  EXTNAME(DSLDY)                       199089
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
      **+--- The converted SRERRI starts here ------------------------+
      *
     D DSPGM         ESDS                  EXTNAME(Y2PGDSP)
      *
      *  Program data structure
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      *  Local data area for database error details
      *  *LOCK IN LDA immediately before and OUT LDA immediately
      *  after each database error handling.
      *
      *  Rename filler field on LDA
      *  CRT001 changes mean that there is now a field ZZ019 on APOSTPD
      *  and associated PFs, which are held in a DS in some CG programs.
      *  The same field in two DS causes those programs to fail to
      *  compile - hence this version of ZZ019 is renamed.
     D  DBZZ19       E                     EXTFLD(ZZ019)
      *                                     134 141 DBFILE
      *        Defines:                     142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *
     D ERDTA         E DS                  EXTNAME(CGERDTA)
      *
      *  Send message data structure
      *
      *                                       1  10 ERPGM
      *                                      11  20 ERFILE
      *                                      21  50 ERKEY
      *                                      51  550ERERNB
      *                                      56 135 ERNARR
      *                                     136 145 ERSTK
      *                                     146 175 ERPREF
      *
     D M#DTA           DS           256
      *
      *  Message Data - Action field
      *
      *                          Field Text
     D  #MSGTX                 1     80
      *                          Data Text
     D  ##MSGD                81    256
      **+--- The converted SRERRI ends here --------------------------+
                                                                                              CSC022
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCMTSK          S              1A                                                      CSC022
     D WDSFDY          S                   LIKE(P@FMT)                                        CSC022
     D WSARD           S                   LIKE(SARN)                                         CSC022
                                                                                              CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      * DATA STRUCTURE FOR Midas SAR Details                                                  CSC022
                                                                                              CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
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
     C                   PARM                    P@FMT                          O:Format
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
     C                   CALL      'ZASNMG'                                       <SEND MSG>
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
     C                   CALL      'DBERRCTL'
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
     C     W#BLNK        IFEQ      *BLANK
     C                   MOVEL     W#CNML        QBCUST
     C                   ELSE
     C                   MOVEL     W#CNMR        QBCUST
     C                   END
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
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM      '*KEY   '     @@OPTN            7
     C                   PARM      I#BRCA        @@BRCA            3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      ** Access customer details only if branch found
      *
     C     @@RTCD        IFEQ      *BLANK
     C                   CALL      'AOCUSTR0'
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
      *                                                                         199089
     C                   CALL      'AOCUSTR1'                                   199089
     C                   PARM      *BLANKS       @@RTCD                         199089
     C                   PARM      '*KEY   '     @@OPTN                         199089
     C                   PARM      QBCUST        @@CUST           10            199089
     C                   PARM      *BLANKS       @@KYST            7            199089
     C     SDCUST        PARM      SDCUST        DSLDY                          199089
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
     C     BBPRBA        ANDNE     'Y'                                          199089
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
     C     BBPRBA        IFNE      'Y'                                          199089
     C     I#PORS        IFEQ      'B'
     C                   MOVEL     'PMA0008'     P@RTCD
     C                   ELSE
     C                   MOVEL     'PMA0009'     P@RTCD
     C                   ENDIF
     C                   ENDIF                                                  199089
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
     C                   CALL      'AOBOOKR1'
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
     C                   CALL      'AOBOOKR0'
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
      **+--- The converted SRERRC starts here ------------------------+
      *****************************************************************
      *                                                               *
      *  SRFILE   : *PSSR routine for all files                       *
      *                                                               *
      *  CALLED BY: IBM controlled - invalid access to file           *
      *                                                               *
      *  CALLS    : AOZERROR                                          *
      *                                                               *
      * In the INIT sub-routine, the fields W0MSGD and W0MSGF should  *
      * be set to the default message I.D and message file that are   *
      * used for the module. If not, the defaults of MEM5002 and MIDAS*
      * will be used.                                                 *
      *                                                               *
      *****************************************************************
     CSR   SRFILE        BEGSR
      *
      *  Dump program
      *
     C                   DUMP
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK                                          90
     C                   ENDIF                                                                CSC022
      *
      *  If called again seton LR and return
      *
     C     @@FILE        IFNE      *BLANKS
     C                   MOVEL     '1'           *INLR
     C                   RETURN
     C                   END
      *
     C                   MOVEL     'Y'           @@FILE            1
      *
      *  Send message to MOPERQ
      *
     C                   MOVEL     *BLANKS       ERDTA
     C                   MOVEL     ##PGM         ERPGM
      *
     C     Q             IFGT      1
     C     Q             ANDLT     101
     C                   MOVEL     @STK(Q)       ERSTK
     C                   ELSE
     C                   MOVEL     '*Nostkin'    ERSTK
     C                   END
      *
     C                   MOVEL     ##ERST        ERKEY
     C                   Z-ADD     999           ERERNB
     C                   MOVEL     ##ERFL        ERFILE
     C                   MOVEL     W0PREF        ERPREF
      *
      * Get message for sending and place in msg field
      *
     C                   CALL      'SDRTVTXT'                           9090
     C                   PARM      'MEM5002'     #MSGID
     C                   PARM      'MIDAS   '    #MSGF
     C                   PARM      *BLANKS       #MSGTX
      *
     C                   MOVEL     #MSGTX        ERNARR
      *
      * Send message
      *
     C                   CALL      'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID            7
     C                   PARM      'MIDAS  '     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      ERDTA         #MSGDT          256
     C                   PARM      '*PRV'        #MSGR             5
     C                   PARM      '*'           #PRGM            10
     C                   PARM      'MOPERQ '     #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
      *
      *  Fill LDA with error data
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
      *
      *  Close down program
      *
     C                   SETON                                        U7U8LR
     C                   MOVEL     '*ERROR*'     W0RTN             7
     C*
     C* Provide a fuller report:
     C*
     C                   MOVEA     @STK          #@STK           100
     C*
     C                   CALL      'AOZERROR'                           9090
     C                   PARM                    ##ERTN            7
     C                   PARM                    DSPGM
     C                   PARM                    ERDTA
     C                   PARM                    #@STK
      *
     C                   RETURN
      *
     CSR   EXFILE        ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRERR    : Report error and close down program               *
      *                                                               *
      *  CALLED BY: All subroutines                                   *
      *                                                               *
      *  CALLS    : AOZERROR                                          *
      *                                                               *
      * In the INIT sub-routine, the fields W0MSGD and W0MSGF should  *
      * be set to the default message I.D and message file that are   *
      * used for the module. If not, the defaults of MEM5001 and MIDAS*
      * will be used.                                                 *
      *                                                               *
      *****************************************************************
     CSR   SRERR         BEGSR
      *
      *  Define work variables
      *
     C     *LIKE         DEFINE    ERKEY         W0KEY
     C     *LIKE         DEFINE    ERERNB        W0ERNB
     C     *LIKE         DEFINE    ERFILE        W0FILE
     C     *LIKE         DEFINE    ERPREF        W0PREF                         Primary Ref.
      *
     C     *LIKE         DEFINE    #MSGID        W0MSGD                         Msg I.D.
     C     *LIKE         DEFINE    #MSGF         W0MSGF                         Msg File
      *
     C                   Z-ADD     Q             Q                 5 0
      *
      *  Dump program
      *
     C                   DUMP
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK                                          90
     C                   ENDIF                                                                CSC022
      *
      *  Set up the details of the message to be sent to MOPERQ
      *
     C                   MOVEL     *BLANKS       ERDTA
     C                   MOVEL     ##PGM         ERPGM
      *
     C     Q             IFGT      1
     C     Q             ANDLT     101
     C                   MOVEL     @STK(Q)       ERSTK
     C                   ELSE
     C                   MOVEL     '*Nostkin'    ERSTK
     C                   END
      *
     C                   MOVEL     W0KEY         ERKEY
     C                   Z-ADD     W0ERNB        ERERNB
     C                   MOVEL     W0FILE        ERFILE
     C                   MOVEL     W0PREF        ERPREF
      *
      * Get message for message code. If the msg code or the msg file
      * have not been set up then use the defaults.
      *
     C     W0MSGD        IFEQ      *BLANKS
     C                   MOVEL     'MEM5001'     C#FMSG            7
     C                   ELSE
     C                   MOVEL     W0MSGD        C#FMSG
     C                   END
      *
     C     W0MSGF        IFEQ      *BLANKS
     C                   MOVEL     'MIDAS   '    C#FMSF           10
     C                   ELSE
     C                   MOVEL     W0MSGF        C#FMSF
     C                   END
      *
     C                   CALL      'SDRTVTXT'                           9090
     C                   PARM      C#FMSG        #MSGID
     C                   PARM      C#FMSF        #MSGF
     C                   PARM      *BLANKS       #MSGTX
      *
     C                   MOVEL     #MSGTX        ERNARR
      *
      * Send message
      *
     C                   CALL      'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID            7
     C                   PARM      'MIDAS  '     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      ERDTA         #MSGDT          256
     C                   PARM      '*PRV '       #MSGR             5
     C                   PARM      '*'           #PRGM            10
     C                   PARM      'MOPERQ '     #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
      *
      *  Fill LDA with error data
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
      *
      *  Close down program
      *
     C                   SETON                                        U7U8LR
     C                   MOVEL     '*ERROR*'     W0RTN             7
     C*
     C* Provide a fuller report:
     C*
     C                   MOVEA     @STK          #@STK           100
     C*
     C                   CALL      'AOZERROR'                           9090
     C                   PARM                    ##ERTN            7
     C                   PARM                    DSPGM
     C                   PARM                    ERDTA
     C                   PARM                    #@STK
     C* End the program:
     C                   RETURN
      *
     CSR   EXERR         ENDSR
      **+--- The converted SRERRC ends here --------------------------+
      *
      **+--- The converted SRERRPSSR starts here ---------------------+
     C*****************************************************************
     C**  Subroutine *PSSR handles program errors.                   **
     C**                                                             **
     C**  Note: this routine requires copy member SRERRI or          **
     C**        its equivalent in the input specifications.          **
     C**                                                             **
     C**                                                             **
     C*****************************************************************
     C     *PSSR         BEGSR                                                  ** *PSSR  **
     C*
     C                   DUMP
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK                                          90
     C                   ENDIF                                                                CSC022
     C*
     C* If second time through, halt:
     C*
     C     @@PSSR        IFNE      *BLANK
     C                   SETON                                        H1  LR
     C                   RETURN
     C                   ENDIF
     C*
     C* Flag routine as started; define action code:
     C*
     C                   MOVE      'Y'           @@PSSR            1
     C                   MOVE      W0ACT         W0ACT             8
     C*___________________________________________________________________
     C*
     C* Any other mode or type of error.
     C*
     C* Set LDA values and format message for MOPERQ:
     C*
     C                   MOVE      ##PGM         ERPGM
     C                   MOVE      ##RTVN        ERFILE
     C     ##MSID        CAT(P)    ##SQNO        ERKEY
     C                   Z-ADD     998           ERERNB
     C                   MOVEL     ##MSWK        ERNARR
     C*
     C* Move data to the LDA data area:
     C*
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
     C*
     C* Provide a fuller report:
     C*
     C                   MOVEA     @STK          #@STK           100
     C*
     C                   CALL      'AOZERROR'                           9090
     C                   PARM                    ##ERTN            7
     C                   PARM                    DSPGM
     C                   PARM                    ERDTA
     C                   PARM                    #@STK
     C* End the program:
     C                   SETON                                        U7U8LR
     C                   MOVE      '*ERROR*'     W0RTN             7
     C                   RETURN
     C*
     C*
     C                   ENDSR
     C*****************************************************************
      **+--- The converted SRERRPSSR ends here -----------------------+
      *
      **+--- The converted SAOSNMSC starts here ----------------------+
     C/EJECT
      *****************************************************************
      *                                                               *
      *  AOSNMS   : Send message to program's message queue           *
      *                                                               *
      *  CALLED BY: When reporting errors                             *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   AOSNMS        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'AOSNMS'      @STK(Q)
      *
      * If no program send to ##PGM
      *
     C     AOPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         AOPGMQ
     C                   END
      *
      * If level to send is blanks default to *SAME
      *
     C     AOPGRL        IFEQ      *BLANK
     C                   MOVEL     '*SAME'       AOPGRL
     C                   END
      *
      * If no message file specified, use default
      *
     C     AOMSGF        IFEQ      *BLANK
     C                   MOVEL     'AOUSRMSG'    AOMSGF
     C                   END
      *
     C                   CALL      'AOCREPT'
     C                   PARM                    AOMSID            7
     C                   PARM                    AOMSGF           10
     C                   PARM                    AOMSFL           10
     C                   PARM                    AOMSDT          256
     C                   PARM                    AOPGRL            5
     C                   PARM                    AOPGMQ           10
     C                   PARM                    AOMSGQ           10
     C                   PARM                    AOMSGT            7
      *
     C                   MOVEL     'Y'           AOMSGS            1
      *
      * Clear all fields for default mechanism next time
      *
     C                   MOVEL     *BLANK        AOMSID
     C                   MOVEL     *BLANK        AOMSGF
     C                   MOVEL     *BLANK        AOMSFL
     C                   MOVEL     *BLANK        AOMSDT
     C                   MOVEL     *BLANK        AOPGRL
     C                   MOVEL     *BLANK        AOPGMQ
     C                   MOVEL     *BLANK        AOMSGQ
     C                   MOVEL     *BLANK        AOMSGT
      *
      *  Unwind subroutine stack name
      *
     C     AOEXIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      **+--- The converted SAOSNMSC ends here ------------------------+
      *****************************************************************                       CSC022
      *                                                               *                       CSC022
      *  *INZSR   : Initilisation subroutine                          *                       CSC022
      *                                                               *                       CSC022
      *  CALLED BY: Program initialisation                            *                       CSC022
      *                                                               *                       CSC022
      *  CALLS    : *NONE                                             *                       CSC022
      *                                                               *                       CSC022
      *****************************************************************                       CSC022
     C     *INZSR        BEGSR                                                                CSC022
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @@RTCD                                       CSC022
     C                   PARM      '*VERIFY'     @@OPTN                                       CSC022
     C                   PARM      'CSC022'      WSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        WDSFDY                                       CSC022
                                                                                              CSC022
     C                   IF        @@RTCD = *Blanks                                           CSC022
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
     C                   IF        %LOOKUP(##JOB:WCMT) > 0                                    CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        @@RTCD <> '*NRF'                                           CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 997                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDSR                                                                CSC022
     C*****************************************************************
**CTDATA @MG
SDPLCSL0  AOPLCSR1  Customer Details
**CTDATA ##CPY
(c) Finastra International Limited 2001
