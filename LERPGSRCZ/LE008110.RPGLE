     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Stamp Tax A/c Keys and Generated Entries')    *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Customer Lending                                     *
     F*                                                               *
     F*  LE008110 - Stamp Tax Account Keys & Generated Entries Report *
     F*                                                               *
     F*  (c) Copyright Finastra International Limited 2010            *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CER049  *CREATE    Date 06Dec201              *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
     F*  CER049 - Stamp Tax                                           *
     F*                                                               *
     F*****************************************************************
     FLESTGEPD  IP   E           K DISK
     FLE008110P1O    E             PRINTER INFDS(SPOOL1)
      *
      * Extra postings for Stamp Tax
      *
      ********************************************************************
      *
      * ID C  F  H  L    Function of indicators
      *
      *    90            General Error
      *    91            End of Lending Account Keys
      * U7U8LR           DB error
      *
     F********************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D/COPY ZSRSRC,ZSEDITZ1LE
      ** Data structure for ouput parameter
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data structure for bank file
      *
     D SDCURR        E DS                  OCCURS(2) EXTNAME(SDCURRPD)
      **  Data structure for currency details
      *
     D                 DS
     D  WORK15                 1     15  0
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short data structure for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long data structure for access programs
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      **  Local data area
      *
     D SPOOL1          DS
      *
      **  DS FOR P1 SPOOL FILE NAME
      *
     D  SFILE1                83     92
     D  SFNUM                123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ** Parameter fields
      *
     D U#DATE          S              5  0
     D U#FMT           S              1
     D U#DYNB          S              6  0
     D YEVDT           S              7
     D @RTCD           S              7
     D @OPTN           S              7
     D SEQNO           S              5
     D ENTY            S              3
     D ZSERR           S              1
      *
      ** Work fields
      *
     D BIS@            S             80
     D FIRST           S              1
     D ZSNUM           S              6  0
     D ##CYCD          S                   LIKE(A6CYCD)
      *
     ILESTGED0
     I                                          E4AKEY        L2
     I                                          E4ECCY        L2
     I                                          E4EDAT        L2
     I                                          E4EAMT        L2
      *
     I                                          E4LNNO        L1
      *
      *****************************************************************
     C/EJECT
      *
     C     FIRST         CASEQ     ' '           SRINIT
     C                   END
      ** Main process
      *
      * Print Account Key Details
     C   L2              EXSR      PRTDT2
      *
     C     E4CNUM        IFNE      *BLANKS
     C     E4ACOD        ANDNE     0
     C     E4CCY         ANDNE     *BLANKS
     C     E4ACSQ        ANDNE     0
      *
      * Print Posting Details
     C                   EXSR      PRTDT3
     C                   END
      * Print Trailer
     CLR                 EXSR      SREND
      *
      *******************************************************************
      **  PRTDT2 - Print Report LE008110P1 - Record DETLP21 and DETLP23 *
      *******************************************************************
      *
     C     PRTDT2        BEGSR
      *
     C     PRTLN1        IFGE      57
     C                   WRITE     HEADP1
     C                   END
      *
      ** Retrieve Ccy Details
     C                   MOVEL     E4ECCY        ##CYCD
     C                   EXSR      SRNCCY
      *
     C                   MOVE      E4REVI        RVRS
     C                   MOVE      E4AKEY        AKEY
     C                   MOVE      E4ECCY        EVCY
     C                   MOVE      E4LNNO        LNNO
     C                   MOVE      E4MISS        SMISS
      *
      ** Midas Conv. Day to Date - Standard functions
     C                   CALL      'ZDATE2'                             90
     C                   PARM      E4EDAT        U#DATE
     C                   PARM      BJDFIN        U#FMT
     C                   PARM      *ZERO         U#DYNB
     C                   PARM      *BLANK        YEVDT
      *
     C                   Z-ADD     E4EAMT        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        EDEVAM
      *
      ** Output Account Key Details
     C                   WRITE     DETLP21
      *
     C                   ENDSR
      *
      *******************************************************************
      *   PRTDT3 - Print Report LE008110P1 - Record DETLP21 and DETLP23 *
      *******************************************************************
      *
     C     PRTDT3        BEGSR
      *
     C     E4PSTD        IFNE      0
     C     E4VALD        ORNE      0
      *
      ** Retrieve Ccy Details
     C                   MOVEL     E4CCY         ##CYCD
     C                   EXSR      SRNCCY
      *
      ** Set Posting Details
     C                   CALL      'ZDATE2'                             90
     C                   PARM      E4PSTD        U#DATE
     C                   PARM      BJDFIN        U#FMT
     C                   PARM      *ZERO         U#DYNB
     C                   PARM      *BLANK        PPSTD
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      E4VALD        U#DATE
     C                   PARM      BJDFIN        U#FMT
     C                   PARM      *ZERO         U#DYNB
     C                   PARM      *BLANK        PVALD
      *
     C                   Z-ADD     E4PSTA        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PPSTA
      *
     C                   MOVE      E4BRCA        P1BRCA
     C                   MOVE      E4CNUM        P1CNUM
     C                   MOVE      E4CCY         P1CCY
     C                   MOVE      E4ACOD        P1ACOD
     C                   MOVE      E4ACSQ        P1ACSQ
     C                   MOVE      E4DRCR        PDRCR
     C                   MOVE      E4PNAR        PNAR
      *
     C     PRTLN1        IFGE      57
     C                   WRITE     HEADP1
     C                   END
      *
     C                   WRITE     DETLP31
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *   SRNCCY - Process new currency                               *
      *****************************************************************
      *
     C     SRNCCY        BEGSR
      *
      **  Access currency details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##CYCD
     C     SDCURR        PARM      *BLANK        DSSDY
      *
      ** If no record is found on sdcurrpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '001'         DBASE
     C                   MOVEL     ##CYCD        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      *   SREND -                                                     *
      *****************************************************************
      *
     C     SREND         BEGSR
      *
     C     PRTLN1        IFGE      54
     C                   WRITE     HEADP1
     C                   END
     C                   WRITE     TRAILP1
      *
     C                   ENDSR
      *****************************************************************
      *   SRINIT - inital process                                     *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
     C                   MOVEA     CPY@          BIS@
     C                   MOVE      'Y'           FIRST
      *
      **  Set up LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'LE008110'    DBPGM
     C                   MOVE      *BLANKS       DBASE
     C                   OUT       LDA
      *
      **  Access SDBANKPD for report title
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If no record is found on sdbankpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '002'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Output LE008110P1 Header
     C                   WRITE     HEADP1
      *
      ** Ensure the spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUM         ZSNUM
      *
      ** Call ZSFILE for LE008110P1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQNO
     C                   PARM      *BLANKS       ENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
      *
      ** If error in ZSFILE, exit via *PSSR
      *
     C     ZSERR         IFEQ      'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
     C/EJECT
     E/COPY ZSRSRC,ZSEDITZ3LE
      *****************************************************************
      **  *PSSR - error handling                                      *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
** CPY@   **      OBJECT COPYRIGHT
(C) Copyright Finastra International Limited 2010
