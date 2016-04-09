     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Access object control inf.')                  *
     F********************************************************************
     F*                                                                  *
     F*  Midas - Access Objects Module
     F*                                                                  *
     F*     AOCNTLR0 - Access Object Control Information                 *
     F*                                                                  *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                                  *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 240690             Date 29Jun06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002             Date 01May98               *
     F*                     041693             DATE  05JAN93             *
     F*                     045014             DATE  01DEC92             *
     F*                                                                  *
     F*------------------------------------------------------------------*
     F*                                                                  *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  240690 - Applied fix 232494.                                 *
      *  232494 - Database error in AOSPOSU0 when using IPN1 and FTMG *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*     041693 - Delivered as part of fix.                           *
     F*                                                                  *
     F*     045014 - New program to access control information           *
     F*                                                                  *
     F********************************************************************
     F/EJECT
      *
      *  Copyright table
      *
      *
      *  Error texts
      *
     D ERR@            S             80    DIM(4) CTDATA PERRCD(1)
      *
      *  Subroutine stack
      *
     D @STK            S             10    DIM(20)
     D/EJECT
     D/EJECT
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
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
     D  DBPREF               146    175
      *
      *  Output parameters data structure
      *
     D O#DTA           DS           256
      *                                       Access Check
     D  O#ACCK                 1      1
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
      *  Define entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
     C                   PARM      O#DTA         P0DTA           256
      *
      *  Set check field to N - i.e. switch off checking
      *
     C                   CLEAR                   O#DTA
     C                   MOVEL     'N'           O#ACCK
      *
      *  Send message to program queue indicating no check
      *
     C     ##INIT        IFEQ      *BLANKS
     C                   MOVEL     'Y'           ##INIT            1
     C                   MOVEL     *BLANKS       DBDTA
     C                   MOVEL     ERR@(4)       DBDTA
      *
     C                   CALLB     'AOCREPT'                            9090
     C                   PARM      'CPF9898'     #MSGID            7
     C                   PARM      'QCPFMSG'     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      DBDTA         #MSGDT          256
     C                   PARM      '*PRV'        #MSGR             5
     C                   PARM      '*'           #PRGM            10
     C**********         PARM      'MOPERQ '     #MSGQ            10                          232494
     C                   PARM      '       '     #MSGQ            10                          232494
     C                   PARM      '*INFO  '     #MSGT             7
     C                   END
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
     C                   MOVEL     'AOCNTLR0'    DBPGM
     C                   MOVEL     @STK(Q)       DBSTK
     C                   MOVEL     ##ERST        DBKEY
     C                   MOVEL     1             DBERNB
     C                   MOVEL     ##ERFL        DBFILE
     C                   MOVEL     ERR@(2)       DBNARR
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
     CSR   EXFILE        ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRERR    : Report error and close down program               *
      *                                                               *
      *  CALLED BY: SRINIT - Initialise and define fields             *
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
     C                   MOVEL     'AOCCYCV0'    DBPGM
     C                   MOVEL     @STK(Q)       DBSTK
     C                   MOVEL     W0KEY         DBKEY
     C                   MOVEL     W0ERNB        DBERNB
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     *BLANKS       DBPREF
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
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : SRERR  - report errors                            *
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
      *  Initialise variable lengths
      *
     C     *LIKE         DEFINE    DBFILE        W0FILE
     C     *LIKE         DEFINE    DBKEY         W0KEY
     C     *LIKE         DEFINE    DBERNB        W0ERNB
     C     *LIKE         DEFINE    DBNARR        W0NARR
     C     *LIKE         DEFINE    DBPREF        W0PREF
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
     C/EJECT
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
**CTDATA ERR@
See dump for further information
File access error occurred - see dump for full details - see key for opcode
Record not found or marked as deleted
No Access Checking will be performed
