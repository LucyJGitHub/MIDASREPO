     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Write Rsacmtpd file')                         *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Access Objects Module                                *
     F*                                                               *
     F*     AORSACW0 - Write RSACMTPD record                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR868380           Date 10Jun13               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 19Feb10               *
      *                 CAP204             Date 15Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 19Aug02               *
      *                 CRE009             Date 09Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                    CDE001             Date 17Nov99            *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                    CAP002             Date 01May98            *
     F*                    080050             Date 26Jan95            *
     F*                    041693             DATE 05JAN93            *
     F*                    045014             DATE 01DEC92            *
     F*                    031876             DATE 03NOV92            *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CRE009 - Projected Account Movements for Retail Accounts     *
      *  CDE001 - Data Export - CCRM Limits                           *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*  080050 - Narrative code on RSACMTPD changed to alphanumeric  *
     F*  041693 - Delivered as part of fix.                           *
     F*  045014 - Add call to AOCNTLR0 for access control             *
     F*  031876 - New program to write RSACMT file for shadow         *
     F*           post.                                               *
     F*                                                               *
     F*****************************************************************
     FRSACMTPD  O    E             DISK    COMMIT
     F                                     USROPN
     F                                     INFSR(SRFILE)
     F                                     INFDS(@RSACM)                                    AR868380
      *
      * Define RSACMTPD file
      *
     FSDBANKL1  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     RENAME(@BJREEF:@BANKL1)
      *
      * Define TABTB10 for the run date
      *
     F/COPY WNCPYSRC,AOH00022
     FACCNT     IF   E           K DISK                                                 CRE009
     F                                     INFSR(SRFILE)                                CRE009
      * Define GL Accounts Master File                                                  CRE009
      *
     F/EJECT
      *
      *  Copyright table
      *
      *
      *  List of valid calling programs
      *
     D PGM@            S             10    DIM(3) CTDATA PERRCD(1)
      *
      *  Error texts
      *
     D***********         ERR@    1   3 80                                045014
     D ERR@            S             80    DIM(4) CTDATA PERRCD(1)                               045
      *
      *  Subroutine stack
      *
     D @STK            S             10    DIM(20)
     D/EJECT
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D @RSACM        E DS                  EXTNAME(Y2IUDSP)                                 AR868380
      *
      *  Program data structure
      *
     D DSPGM         ESDS                  EXTNAME(Y2PGDSP)
      *
      *  Send message data structure
      *
     D DBDTA           DS
     D  DBPGM                  1     10
     D  DBFILE                11     20
     D  DBKEY                 21     50
     D  DBERNB                51     55  0
     D  DBNARR                56    135
     D  DBSTK                136    145
     D  DBPREF               146    175                                         045014
      *
      *  File structure for write to file
      *
     D I#RSAC        E DS                  EXTNAME(RSACMTPD)
     D/COPY WNCPYSRC,AORSACW0D1
     D**W#ACID**               1     18                                                CDE001 CGL029
     D  W#FLD1                 1      9                                                       CGL029
     D  W#FLD2                14     18                                                       CGL029
     D  P1DTA                  1    256
      *                                                                   045014
      *  Input parameters data structure for AOCNTLR0                     045014
      *                                                                   045014
     D P#CNTL          DS           256                                         045014
      *                                       Access Check                045014
     D  P#ACCK                 1      1                                         045014
     D/COPY WNCPYSRC,AOH00023
                                                                                              CGL029
     D W#FLD3          S             19                                                       CGL029
     D W#ACID          S             24                                                       CGL029
     I/EJECT
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
      * Write RSACMTPD file with passed data
      *
     C                   EXSR      SRRSAC
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      * Return to calling program
      *
     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRRSAC   : Write to RSACMTPD file                            *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRRSAC        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRSAC'      @STK(Q)
      *
      *  Define entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
     C                   PARM                    W0AMT            15 0
     C     P1DTA         PARM                    W0DTA           256
     C/COPY WNCPYSRC,AORSACW0C1
      *
      *  If narrative information is blank then use transaction no.
      *
     C*********  NRTC      IFEQ 0                                         `Z0071
     C*********  NRTD      ANDEQ*BLANKS                                   080050
      *                                                                   080050
     C     NRTC          IFEQ      *BLANKS                                                     08005
     C     NRTC          OREQ      *ZEROS                                                      08005
      *                                                                   080050
     C     NRTD          IFEQ      *BLANKS                                                     08005
     C     FUND          IFEQ      *BLANKS
     C     OTR1          IFNE      *BLANKS                                                    CAP204
     C                   MOVEL     OTR1          NRTD                                         CAP204
     C                   ELSE                                                                 CAP204
     C                   MOVEL     TNMR          NRTD
     C                   ENDIF                                                                CAP204
     C                   ELSE
     C                   MOVEL     FUND          NRTD
     C                   END
     C/COPY WNCPYSRC,AOH00024
     C                   END
     C                   END                                                                   08005
      *
      *  Format fields DORC, MVAM and PTDT
      *
     C     PTDT          IFLT      BJRDNB
     C                   Z-ADD     BJRDNB        PTDT
     C                   END
      *
     C     W0AMT         IFGT      0
     C                   Z-ADD     W0AMT         MVAM
     C                   MOVEL     '0'           DORC
     C                   ELSE
     C                   Z-SUB     W0AMT         MVAM
     C                   MOVEL     '1'           DORC
     C                   END
     C/COPY WNCPYSRC,AORSACW0C2
      *                                                                         CDE001
      ** Data export for CCRM - Limits                                          CDE001
      *                                                                         CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                   MOVEL     W#FLD1        W#FLD3                                       CGL029
     C                   MOVE      ACDE          W#FLD3                                       CGL029
     C     W#FLD3        CAT       W#FLD2        W#ACID           24                          CGL029
     C                   MOVEL     W#ACID        T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C**********         PARM                    T#TREF           20                   CDE001 CGL029
     C                   PARM                    T#TREF           26                          CGL029
     C                   PARM      'ACCT'        T#TCAT            4            CDE001
     C                   PARM      *BLANKS       T#RSRV           10            CDE005
     C                   ENDIF                                                  CDE001
      *
      ** Change posting date value if CRE009 is ON and account is retail        CRE009
      *                                                                         CRE009
     C     CRE009        IFEQ      *ON                                          CRE009
     C     ACCKEY        CHAIN     ACCNT                              80        CRE009
     C     *IN80         IFEQ      *OFF                                         CRE009
     C     ATYP          ANDEQ     'R'                                          CRE009
     C     VUDT          IFGE      BJRDNB                                       CRE009
     C                   Z-ADD     VUDT          PTDT                           CRE009
     C                   ENDIF                                                  CRE009
     C                   ENDIF                                                  CRE009
     C                   ENDIF                                                  CRE009
      *                                                                         CRE009
      *  Write a new record
      *
     C                   WRITE     RSACMTPO
      *
      *  Unwind subroutine stack name
      *
     C     EXRSAC        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRACCS   : Check for valid access                            *
      *                                                               *
      *  CALLED BY: SRINIT  - Initialise and define fields            *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRACCS        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRACCS'      @STK(Q)
      *                                                                   045014
      *  Call AOCNTLR0 to see if access should be checked                 045014
      *                                                                   045014
     C                   CALLB     'AOCNTLR0'                           9090                   04501
     C     R#RTN         PARM      *BLANKS       O#RTN             7                           04501
     C                   PARM                    P#CNTL                                        04501
      *                                                                   045014
     C     *IN90         IFEQ      '1'                                                         04501
     C     R#RTN         ORNE      *BLANKS                                                     04501
     C                   MOVEL     'AOCNTLR0'    W0FILE                                        04501
     C                   MOVEL     '*CALL'       W0KEY                                         04501
     C                   Z-ADD     1             W0ERNB                                        04501
     C                   MOVEL     ERR@(4)       DBNARR                                        04501
     C                   EXSR      SRERR                                                       04501
     C                   MOVEL     *BLANKS       R#RTN             7                           04501
     C                   END                                                                   04501
      *                                                                   045014
      * No access validation required                                     045014
      *                                                                   045014
     C     P#ACCK        CABEQ     'N'           EXACCS                                        04501
      *
      *  Check for valid access
      *
     C                   MOVEL     *BLANKS       @PGMF            10
     C                   MOVEL     *BLANKS       @PGMFA           10
      *
      *  If already found only test for change
      *
     C     @T            IFGE      1
     C                   CALLB     'AOCREPT'                            9090
     C                   PARM      'CPF9898'     #MSGID            7
     C                   PARM      'QCPFMSG'     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      'Check'       #MSGDT          256
     C                   PARM      '*PRV'        #MSGR             5
     C                   PARM      PGM@(@T)      #PRGM            10
     C                   PARM      *BLANKS       #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
      *
      *  If found set flag to stop checking of all valid programs
      *
     C     *IN90         IFEQ      '0'
     C     PGM@(1)       ANDNE     PGM@(X)
     C                   MOVEL     'PG_FND'      @PGMF
     C                   ELSE
     C                   Z-ADD     0             @T                5 0
     C                   END
     C                   END
      *
     C                   DO        3             X                 5 0
      *
      *  Check for program in stack
      *
     C                   CALLB     'AOCREPT'                            9090
     C                   PARM      'CPF9898'     #MSGID
     C                   PARM      'QCPFMSG'     #MSGF
     C                   PARM      *BLANKS       #MSGFL
     C                   PARM      'Check'       #MSGDT
     C                   PARM      '*PRV'        #MSGR
     C                   PARM      PGM@(X)       #PRGM
     C                   PARM      *BLANKS       #MSGQ
     C                   PARM      '*INFO  '     #MSGT
      *
      *  Set flag if program found
      *
     C     *IN90         IFEQ      '0'
     C     PGM@(1)       ANDNE     PGM@(X)
     C                   MOVEL     'PG_FND'      @PGMF
     C                   Z-ADD     X             @T                5 0
     C     @PGMFA        IFEQ      'PG_FND'
     C                   GOTO      ENDLOP
     C                   END
     C                   END
     C     *IN90         IFEQ      '0'
     C     PGM@(1)       ANDEQ     PGM@(X)
     C                   MOVEL     'PG_FND'      @PGMFA
     C     @PGMF         IFEQ      'PG_FND'
     C                   GOTO      ENDLOP
     C                   END
     C                   END
     C                   END
     C     ENDLOP        TAG
      *
      *  Set flag if program found
      *
     C     @PGMF         IFNE      'PG_FND'
     C     @PGMFA        ORNE      'PG_FND'
     C                   MOVEL     '*PROGRAM'    W0FILE
     C                   MOVEL     '*ONLY'       W0KEY
     C                   Z-ADD     4             W0ERNB
     C                   MOVEL     ERR@(2)       W0NARR
     C                   EXSR      SRERR
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXACCS        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRERR    : Report error and close down program               *
      *                                                               *
      *  CALLED BY: SRACCS - Valid access                             *
      *             SRINIT - Initialise and define fields             *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   SRERR         BEGSR
      *
      *  Dump program
      *
     C                   DUMP
      *
      *  Send message to MOPERQ
      *
     C                   MOVEL     *BLANKS       DBDTA
     C                   MOVEL     'AORSACW0'    DBPGM
     C                   MOVEL     @STK(Q)       DBSTK
     C                   MOVEL     W0KEY         DBKEY
     C                   MOVEL     W0ERNB        DBERNB
     C                   MOVEL     W0FILE        DBFILE
     C     W0NARR        IFEQ      *BLANKS
     C                   MOVEL     ERR@(1)       DBNARR
     C                   ELSE
     C                   MOVEL     W0NARR        DBNARR
     C                   END
      *
     C                   CALLB     'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID
     C                   PARM      'MIDAS  '     #MSGF
     C                   PARM      *BLANKS       #MSGFL
     C                   PARM      DBDTA         #MSGDT
     C                   PARM      '*PRV'        #MSGR
     C                   PARM      '*'           #PRGM
     C                   PARM      'MOPERQ '     #MSGQ
     C                   PARM      '*INFO  '     #MSGT
      *
      *  Close down program
      *
     C                   SETON                                        LR
     C                   MOVEL     '*ERROR*'     W0RTN
     C                   RETURN
      *
     CSR   EXERR         ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRFILE   : *PSSR routine for all files                       *
      *                                                               *
      *  CALLED BY: IBM controlled - invalid access to file           *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRFILE        BEGSR
      *
      *  Dump program
      *
     C     @UMSID        IFEQ      'CPF4128'                                                AR868380
     C                   SETON                                        LR                    AR868380
     C                   MOVEL     '*RECLCK'     W0RTN                                      AR868380
     C                   ELSE                                                               AR868380
     C                   DUMP
      *
      *  If called again seton LR and return
      *
     C     @@FILE        IFNE      *BLANKS
     C                   MOVEL     '1'           *INLR
     C                   RETURN
     C                   END
     C                   MOVEL     'Y'           @@FILE            1
      *
      *  Send message to MOPERQ
      *
     C                   MOVEL     *BLANKS       DBDTA
     C                   MOVEL     'AORSACW0'    DBPGM
     C                   MOVEL     @STK(Q)       DBSTK
     C                   MOVEL     ##ERST        DBKEY
     C                   MOVEL     1             DBERNB
     C                   MOVEL     ##ERFL        DBFILE
     C                   MOVEL     ERR@(3)       DBNARR
      *
     C                   CALLB     'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID
     C                   PARM      'MIDAS  '     #MSGF
     C                   PARM      *BLANKS       #MSGFL
     C                   PARM      DBDTA         #MSGDT
     C                   PARM      '*PRV'        #MSGR
     C                   PARM      '*'           #PRGM
     C                   PARM      'MOPERQ '     #MSGQ
     C                   PARM      '*INFO  '     #MSGT
      *
      *  Close down program
      *
     C                   SETON                                        LR
     C                   MOVEL     '*ERROR*'     W0RTN
                                                                                            AR868380
     C                   ENDIF                                                              AR868380
                                                                                            AR868380
     C                   RETURN
      *
     CSR   EXFILE        ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : SRACCS - valid access                             *
      *                                                               *
      *****************************************************************
     CSR   SRINIT        BEGSR
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *  Define W0 database error variables
      *
     C     *LIKE         DEFINE    DBFILE        W0FILE
     C     *LIKE         DEFINE    DBKEY         W0KEY
     C     *LIKE         DEFINE    DBERNB        W0ERNB
     C     *LIKE         DEFINE    DBNARR        W0NARR
     C     *LIKE         DEFINE    DBPREF        W0PREF
      *
      *  Check for programs in stack if none found error
      *
     C                   EXSR      SRACCS
      *
      *  Open Memos file for update
      *
     C                   OPEN      RSACMTPD
      *
      *  Open SDBANKL1 file for run date
      *
     C                   OPEN      SDBANKL1
      *
     C                   MOVEL     'BANK'        BJBANK
     C     BJBANK        CHAIN     @BANKL1                            90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'SDBANKL1'    W0FILE
     C                   MOVEL     '*ONLY'       W0KEY
     C                   Z-ADD     3             W0ERNB
     C                   EXSR      SRERR
     C                   END
     C                   CLOSE     SDBANKL1
     C/COPY WNCPYSRC,AORSACW0C3
      *                                                                         CDE001
      ** Determine if Data Export for CCRM Limits is active                     CDE001
      *                                                                         CDE001
     C                   CALLB     'AOSARDR0'                                   CDE001
     C                   PARM      *BLANKS       @RTCD             7            CDE001
     C                   PARM      '*VERIFY'     @OPTN             7            CDE001
     C                   PARM      'CDE001'      @SARD             6            CDE001
      *                                                                         CDE001
     C     @RTCD         IFEQ      *BLANK                                       CDE001
     C                   MOVEL     'Y'           CDE001            1            CDE001
     C                   ENDIF                                                  CDE001
      *                                                                         CRE009
      ** Determine if CRE009 is active                                          CRE009
      *                                                                         CRE009
     C                   CALLB     'AOSARDR0'                                   CRE009
     C                   PARM      *BLANKS       @RTCD                          CRE009
     C                   PARM      '*VERIFY'     @OPTN                          CRE009
     C                   PARM      'CRE009'      @SARD                          CRE009
      *                                                                         CRE009
     C     @RTCD         IFEQ      *BLANK                                       CRE009
     C                   MOVEL     'Y'           CRE009            1            CRE009
     C                   ELSE                                                   CRE009
     C                   MOVEL     'N'           CRE009                         CRE009
     C                   ENDIF                                                  CRE009
      *                                                                         CRE009
      ** Define key list for Accounts Master File                               CRE009
     C     ACCKEY        KLIST                                                  CRE009
     C                   KFLD                    CUSN                           CRE009
     C                   KFLD                    CCYD                           CRE009
     C                   KFLD                    ACDE                           CRE009
     C                   KFLD                    ASNC                           CRE009
     C                   KFLD                    BRCA                           CRE009
      *
      *  Indicate that set up is complete
      *
     C                   SETON                                        50
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/COPY WNCPYSRC,AOH00025
     C/EJECT
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA PGM@
AORSACW0      Real-time positions additions
AOSPOSU0      Control Update of On-line positions
QCL           Command Entry
**CTDATA ERR@
See dump for further information
Invalid Access to update object
File access error occurred - see dump for full details - see key for opcode
Error occurred on call to program - see dumps for further details
