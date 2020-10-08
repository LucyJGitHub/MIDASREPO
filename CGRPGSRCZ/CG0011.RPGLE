     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/*S*D ***RPGBNOCVT*****************************************************              CSD053 MD056543
/*E*S ***RPGCVTOPT1****************************************************              CSD053 MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG Correspondence details validation')
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                  *
     F*                                                               *
     F*  CG0011 - Correspondence details validation                   *
     F*                                                               *
     F*  Function:  This program xxxxxxxxxxxxxxxxxxxxxxxxxxxx         *
     F*  (phase(s))                                                   *
     F*                                                               *
     F*  Called By: mmCnnnn - (program name)                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD053             Date 01Jun06               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01522             Date 01Jan95               *
      *                                    Date ddmmmyy               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD to readable  *
      *             unicode equivalent.                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     FCGCORRL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FCGCASCL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FCGCASCL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FCGCSTRL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
     D/EJECT
     D*
     D*  Array containing Copyright statement
     D*
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      **                                                                                      CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      **                                                                                      CSC022
     D WCMT            S             10    DIM(10)                                            CSC022
      **                                                                                      CSC022
     D*COPY*CGCPYSRC,SRERRE                                                                 MD056543
     D/COPY CGCPYSRC,SRERRDLE                                                               MD056543
     D*
     D*  Copysource for error processing
     D*
     D*COPY*CGCPYSRC,SRERRI                                                                 MD056543
     D*
     D*  End of Program Error Processing copysource
     D*
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D*
     D* Modules Data Structure *
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     S01194
     D*                                                                                       S01194
     D* Data Structures used by Access Programs                                               S01194
     D*                                                                                       S01194
     D*COPY*CGCPYSRC,CGCOV                                                           S01194 MD056543
     D/COPY CGCPYSRC,CGCOVLE                                                                MD056543
     D*
     D* Plist DS
     D*
      *
     D                 DS
     D  Z1                     1      4  0
     D  Z2                     5      8  0
     D  Z3                     9     12  0
     D  Z4                    13     16  0
     D  Z5                    17     20  0
      *
     D STACK           DS
      *
     D  ACTION                 1     38
      *
     D                 DS
     D  #L                     1      5  0 INZ(99999)
      *
     D WKDQ1           C                   CONST('PCOSTACK  ')
     D WKDQ2           C                   CONST('PCOSTORE  ')
     D LIBL            C                   CONST('*LIBL')
     D ERRMSG          C                   CONST('CGD1811')
      *
     D                 DS
     D  WKDL1                  1      2P 0 INZ(38)
     D  WKDL2                  3      4P 0 INZ(1)
     D  WKDK2                  3      4P 0 INZ(10)
      *
     D ST1DS           DS
     D  ST1DS1                 1     10
     D  ST1DS2                11     20
     D  ST1DS3                21     23  0
     D  ST1DS4                24     26  0
     D  ST1DS5                27     29  0
     D  ST1DS6                30     30
      *
     D  ST1DS7                31     34
      *
     D  STF001                31     31
     D  STF002                32     32
     D  STF003                33     33
     D  STF004                34     34
      *
     D  ST1DS8                35     38
      *
     D  STT001                35     35
     D  STT002                36     36
     D  STT003                37     37
     D  STT004                38     38
      *
     D ST2DS           DS
     D  ST2DS1                 1     10
      *
     D                 DS
     D  ZADFMF                 1     10    INZ('CGUSRMSG')
      **                                                                                      CSC022
     D SCCMT           DS           256                                                       CSC022
     D  WCMTNO                 1      3  0                                                    CSC022
     D  WCJOBS                 4    103                                                       CSC022
      ** Commitment Control dataarea                                                          CSC022
      **                                                                                      CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      ** DS for Switchable Features details                                                   CSC022
      **                                                                                      CSC022
      *****************************************************************
      *                 M A I N L I N E
      *****************************************************************
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    CGCOV
      *
     C     STINZ1        PLIST
     C                   PARM      WKDQ1         QNAME            10
     C                   PARM      LIBL          LIB              10
      *
     C     STINZ2        PLIST
     C                   PARM      WKDQ2         QNAME            10
     C                   PARM      LIBL          LIB              10
      *
     C     STPUSH        PLIST
     C                   PARM      WKDQ1         QNAME            10
     C                   PARM      LIBL          LIB              10
     C                   PARM      WKDL1         FLDLEN            5 0
     C                   PARM      ST1DS         STACK
      *
     C     STPOP         PLIST
     C                   PARM      WKDQ1         QNAME            10
     C                   PARM      LIBL          LIB              10
     C                   PARM      WKDL2         FLDLEN            5 0
     C     ST1DS         PARM                    STACK
     C                   PARM      0             WAIT              5 0
      *
     C     STSTOR        PLIST
     C                   PARM      WKDQ2         QNAME            10
     C                   PARM      LIBL          LIB              10
     C                   PARM      WKDL2         FLDLEN            5 0
     C                   PARM                    DUMMY1            1
     C                   PARM      WKDK2         KEYLEN            3 0
     C                   PARM      ST2DS         KEYVAL           10
      *
     C     STPULL        PLIST
     C                   PARM      WKDQ2         QNAME            10
     C                   PARM      LIBL          LIB              10
     C                   PARM      WKDL2         FLDLEN            5 0
     C                   PARM                    DUMMY1            1
     C                   PARM      0             WAIT              5 0
     C                   PARM      'EQ'          KEYORD            2
     C                   PARM      WKDK2         KEYLEN            3 0
     C                   PARM      ST2DS         KEYVAL           10
     C                   PARM      0             SNDLEN            3 0
     C                   PARM                    SNDR             44
      *
     C     KEYL01        KLIST
     C                   KFLD                    CAFCOR
      *
     C     KEYL02        KLIST
     C                   KFLD                    CATCOR
      *
     C     KEYL03        KLIST
     C                   KFLD                    CDCORR
      *
     C     KEYL04        KLIST
     C                   KFLD                    CSCSTR
      *
      *  Reset return code
      *
     C                   MOVEL     *BLANKS       P0RTN
      *  Clear stack
     C                   CALL      'QCLRDTAQ'    STINZ1
      *  Process known updates
     C                   SELECT
      *
     C     W0FIL         WHENEQ    'C'
     C     W0ACTP        ANDEQ     'A'
      *
      *  Check backwards for error
      *
     C                   MOVE      'B'           #DIREC
      *
     C                   Z-ADD     1             #L
      *
     C                   CLEAR                   ST1DS
     C                   MOVE      *HIVAL        ST1DS1
     C                   MOVEL(P)  W0COR1        ST1DS2
     C                   EXSR      SRCHKC
      *
      *  Check forwards for error & loop
      *
     C                   MOVE      'F'           #DIREC
      *
     C                   RESET                   #L
      *
     C                   CLEAR                   ST1DS
     C                   MOVEL(P)  W0COR1        ST1DS1
     C                   MOVE      *HIVAL        ST1DS2
     C                   EXSR      SRCHKC
      *
     C     W0FIL         WHENEQ    'A'
     C     W0ACTP        ANDEQ     'I'
      *
      *  Check backwards for error
      *
     C                   MOVE      'B'           #DIREC
      *
     C                   Z-ADD     1             #L
      *
     C                   CLEAR                   ST1DS
     C                   MOVEL(P)  W0COR1        ST1DS1
     C                   MOVEL(P)  W0COR2        ST1DS2
     C                   EXSR      SRCHKC
      *
      *  Check forwards for error & loop
      *
     C                   MOVE      'F'           #DIREC
      *
     C                   RESET                   #L
      *
     C                   CLEAR                   ST1DS
     C                   MOVEL(P)  W0COR1        ST1DS1
     C                   MOVEL(P)  W0COR2        ST1DS2
     C                   EXSR      SRCHKC
      *
     C     W0FIL         WHENEQ    'S'
     C     W0ACTP        ANDEQ     'I'
      *
      *  Check backwards for error
      *
     C                   MOVE      'B'           #DIREC
      *
     C                   RESET                   #L
      *
     C                   CLEAR                   ST1DS
     C                   MOVE      *HIVAL        ST1DS1
     C                   MOVEL(P)  W0COR2        ST1DS2
     C                   EXSR      SRCHKC
      *  if link not found error
     C     #CORRS        IFEQ      *BLANKS
      *
     C                   MOVEL     W0PGM         ZAPGMQ
     C                   MOVEL     'CGD1806'     ZAMSID
     C     W0COR1        CAT(P)    W0COR2        ZAMSDA
     C                   EXSR      ZASNMS
     C                   MOVEL     ERRMSG        P0RTN
      *
     C                   END
      *
     C                   OTHER
      *
      *  Unknown update: serious error
      *
     C                   MOVEL     ERRMSG        P0RTN
      *
     C                   ENDSL
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *  Return to calling program
      *
     C                   RETURN
     C/EJECT
     C     *INZSR        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     '*INZSR'      @STK(Q)
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          ACT@             80
      *
      *  Get Rundate information
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
     C*
     C* Get modules information
     C*
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     MMODDS        PARM      *BLANKS       DSFDY                          O:Module Flg
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Put DTAQ into QTEMP for use as stack
      *
     C                   CALL      'CGC3002'                            9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      WKDQ1         P@DTAQ           10
     C                   PARM      WKDL1         P@DTAL            3 0
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'CGC3002'     W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'CGD1741'     W0MSGD                         ***************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Put DTAQ into QTEMP for use as store
      *
     C                   CALL      'CGC3005'                            9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      WKDQ2         P@DTAQ           10
     C                   PARM      WKDL2         P@DTAL            3 0
     C                   PARM      WKDK2         P@KEYL            3 0
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'CGC3002'     W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     3             W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'CGD1741'     W0MSGD                         ***************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   END
      **                                                                                      CSC022
      ** Initialize CSC022 and Skip Commit/Rollback flags                                     CSC022
      **                                                                                      CSC022
     C                   MOVE      'N'           CSC022            1                          CSC022
     C                   MOVE      'N'           WCMTSK            1                          CSC022
      **                                                                                      CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      **                                                                                      CSC022
     C                   CALL      'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       P@RTCD            7                          CSC022
     C                   PARM      '*VERIFY '    P@OPTN            7                          CSC022
     C                   PARM      'CSC022'      P@SARD            6                          CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      **                                                                                      CSC022
     C     P@RTCD        IFEQ      *BLANKS                                                    CSC022
     C                   MOVE      'Y'           CSC022                                       CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C     *DTAARA       DEFINE    SCCMTJOB      SCCMT                                        CSC022
     C                   IN        SCCMT                                                      CSC022
      **                                                                                      CSC022
     C     WCMTNO        IFGT      0                                                          CSC022
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MOVEA     WCJOBS        WCMT                                         CSC022
      ** Verify if job running exists in array                                                CSC022
     C     ##JOB         LOOKUP    WCMT                                   50                  CSC022
     C     *IN50         IFEQ      *ON                                                        CSC022
     C                   MOVE      'Y'           WCMTSK                                       CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      **                                                                                      CSC022
     C                   ELSE                                                                 CSC022
      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
     C     P@RTCD        IFNE      '*NRF'                                                     CSC022
     C                   MOVEL     'CSC022'      W0KEY                                        CSC022
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CSC022
     C                   Z-ADD     1             W0ERNB                                       CSC022
     C                   EXSR      SRERR                                                      CSC022
     C                   ENDIF                                                                CSC022
      **                                                                                      CSC022
     C                   ENDIF                                                                CSC022
      **                                                                                      CSC022
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKC   : Push next level                                   *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *  OFFSET   : 010                                               *
      *                                                               *
      *****************************************************************
     CSR   SRCHKC        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCHKC'      @STK(Q)
      *
      *  Initialise duplicates queue
      *
     C                   CALL      'QCLRDTAQ'    STINZ2
      *  Store starting point
     C                   SELECT
     C     #DIREC        WHENEQ    'F'
     C                   MOVE      ST1DS1        ST2DS1
     C     #DIREC        WHENEQ    'B'
     C                   MOVE      ST1DS2        ST2DS1
     C                   ENDSL
      *
     C                   CALL      'QSNDDTAQ'    STSTOR
      *
      *  Clear working indicators
      *
     C     *LIKE         DEFINE    W0COR1        #CORRS
     C                   CLEAR                   #CORRS
     C                   CLEAR                   FLDLEN
      *
      *  DOU Stack Pull End
      *
     C     FLDLEN        DOUEQ     0
      *  validate node
     C     FLDLEN        IFNE      0
      *  set flag if link
     C     ST1DS1        IFEQ      W0COR1
     C                   MOVE      ST1DS1        #CORRS
     C                   END
      *
     C                   SELECT
      *
     C     #DIREC        WHENEQ    'B'
      *
     C     STT001        IFEQ      '0'
      *
     C                   MOVEL     W0PGM         ZAPGMQ
     C                   MOVEL     'CGD1807'     ZAMSID
     C     ST1DS2        CAT       ST1DS1        ZAMSDA
     C                   EXSR      ZASNMS
     C                   MOVEL     ERRMSG        P0RTN
      *
     C                   END
      *
     C     'S'           SCAN      ST1DS8                                 30
     C     *IN30         IFEQ      *OFF
     C     ST1DS5        ANDGT     1
      *
     C                   MOVEL     W0PGM         ZAPGMQ
     C                   MOVEL     'CGD1808'     ZAMSID
     C     ST1DS2        CAT       ST1DS1        ZAMSDA
     C                   EXSR      ZASNMS
     C                   MOVEL     ERRMSG        P0RTN
      *
     C                   END
      *
     C     #DIREC        WHENEQ    'F'
      *
     C     STF002        IFEQ      '0'
      *
     C                   MOVEL     W0PGM         ZAPGMQ
     C                   MOVEL     'CGD1809'     ZAMSID
     C     ST1DS1        CAT       ST1DS2        ZAMSDA
     C                   EXSR      ZASNMS
     C                   MOVEL     ERRMSG        P0RTN
      *
     C                   END
      *
     C                   ENDSL
      *
     C                   END
      *
     C                   ADD       1             ST1DS3
     C                   Z-ADD     0             ST1DS4
     C                   Z-ADD     0             ST1DS5
      *
     C     ST1DS3        IFLE      #L
      *
      *  Push first (no database entry at this point)
      *
     C     ST1DS3        IFEQ      1
     C     ST1DS1        ANDNE     *HIVAL
     C     ST1DS2        ANDNE     *HIVAL
     C                   EXSR      SRPUSH
     C                   END
      *  check for associations
     C                   SELECT
     C     #DIREC        WHENEQ    'F'
      *
     C     ST1DS3        IFGT      1
     C                   MOVEL     ST1DS2        ST1DS1
     C                   END
      *
     C                   MOVEL(P)  ST1DS1        CAFCOR
     C     KEYL01        CHAIN     @CASCL1                            02
      *
     C     *IN02         DOWEQ     *OFF
      *
     C                   MOVEL(P)  CATCOR        ST1DS2
     C                   EXSR      SRPUSH
      *
     C     KEYL01        READE     @CASCL1                                02
     C                   END
      *
     C     #DIREC        WHENEQ    'B'
      *
     C     ST1DS3        IFGT      1
     C                   MOVEL     ST1DS1        ST1DS2
     C                   END
      *
     C                   MOVEL(P)  ST1DS2        CATCOR
     C     KEYL02        CHAIN     @CASCL2                            03
      *
     C     *IN03         DOWEQ     *OFF
      *
     C                   MOVEL(P)  CAFCOR        ST1DS1
     C                   EXSR      SRPUSH
      *
     C     KEYL02        READE     @CASCL2                                03
     C                   END
      *
     C                   ENDSL
      *
     C                   END
      *
     C                   CALL      'QRCVDTAQ'    STPOP
      *
     C                   END
      *
     C                   MOVE      *BLANKS       #DIREC            1
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPUSH   : Push next level                                   *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *  OFFSET   : 100                                               *
      *                                                               *
      *****************************************************************
     CSR   SRPUSH        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPUSH'      @STK(Q)
      *
     C                   SELECT
     C     #DIREC        WHENEQ    'F'
     C                   MOVE      ST1DS2        ST2DS1
     C     #DIREC        WHENEQ    'B'
     C                   MOVE      ST1DS1        ST2DS1
     C                   ENDSL
      *  Test for loop
     C                   CALL      'QRCVDTAQ'    STPULL
      *
     C     FLDLEN        IFNE      0
      *
     C     ST1DS6        IFEQ      'N'
      *
     C                   MOVEL     W0PGM         ZAPGMQ
     C                   MOVEL     'CGD1810'     ZAMSID
     C     ST1DS1        CAT       ST1DS2        ZAMSDA
     C                   EXSR      ZASNMS
     C                   MOVEL     ERRMSG        P0RTN
      *
     C                   END
      *
     C                   ELSE
      *
     C                   CALL      'QSNDDTAQ'    STSTOR
      *
     C                   ADD       1             ST1DS4
     C                   MOVEL     ST1DS1        CDCORR
     C     KEYL03        CHAIN     @CORRL1                            01
      *
     C     *IN01         IFEQ      *ON
     C                   MOVEL     'CGCORRL1'    W0FILE
     C                   MOVEL     ST1DS1        W0KEY                          ***************
     C                   Z-ADD     101           W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   MOVEL     CDCSTR        CSCSTR
      *
     C     W0CSTR        IFNE      *BLANKS
     C     W0COR1        ANDEQ     CDCORR
     C                   MOVEL     W0CSTR        CSCSTR
     C                   END
      *
     C     KEYL04        CHAIN     @CSTRL1                            04
      *
     C     *IN04         IFEQ      *ON
     C                   MOVEL     'CGCSTRL1'    W0FILE
     C                   MOVEL     CSCSTR        W0KEY                          ***************
     C                   Z-ADD     102           W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   MOVEL     CSATYP        ST1DS7
      *
     C     #DIREC        IFEQ      'B'
      * MIDAS Entity
     C     CDCUST        IFNE      *BLANKS
     C     CDCPNC        ORNE      *BLANKS
     C     CDBICC        ORNE      *BLANKS
     C     CDBICB        ORNE      *BLANKS
     C                   ADD       1             ST1DS5
     C                   END
      * Non recursor in loop
     C     'R'           SCAN      ST1DS7                                 30
     C     *IN30         IFEQ      *OFF
     C                   MOVE      'N'           ST1DS6
     C                   END
      *
     C                   END
      *
     C                   MOVEL     ST1DS2        CDCORR
     C     KEYL03        CHAIN     @CORRL1                            01
      *
     C     *IN01         IFEQ      *ON
     C                   MOVEL     'CGCORRL1'    W0FILE
     C                   MOVEL     ST1DS1        W0KEY                          ***************
     C                   Z-ADD     103           W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   MOVEL     CDCSTR        CSCSTR
      *
     C     W0CSTR        IFNE      *BLANKS
     C     W0COR1        ANDEQ     CDCORR
     C                   MOVEL     W0CSTR        CSCSTR
     C                   END
      *
     C     KEYL04        CHAIN     @CSTRL1                            04
      *
     C     *IN04         IFEQ      *ON
     C                   MOVEL     'CGCSTRL1'    W0FILE
     C                   MOVEL     CSCSTR        W0KEY                          ***************
     C                   Z-ADD     104           W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   MOVEL     CSATYP        ST1DS8
      *
     C     #DIREC        IFEQ      'F'
      * MIDAS Entity
     C     CDCUST        IFNE      *BLANKS
     C     CDCPNC        ORNE      *BLANKS
     C     CDBICC        ORNE      *BLANKS
     C     CDBICB        ORNE      *BLANKS
     C                   ADD       1             ST1DS5
     C                   END
      * Non recursor in loop
     C     'R'           SCAN      ST1DS7                                 30
     C     *IN30         IFEQ      *OFF
     C                   MOVE      'N'           ST1DS6
     C                   END
      *
     C                   END
      *
     C                   CALL      'QSNDDTAQ'    STPUSH
      *
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
     C/EJECT
      *
      * File and Program Error Processing
      *
     C*COPY*CGCPYSRC,SRERRC                                                                 MD056543
     C/COPY CGCPYSRC,SRERRCLE                                                               MD056543
     C/EJECT
**  CPY@
(c) Finastra International Limited 2001
