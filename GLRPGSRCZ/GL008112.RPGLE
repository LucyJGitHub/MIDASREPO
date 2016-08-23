     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax A/c Keys & Generated Ents Rept')    *
     F*****************************************************************
     F*                                                               *
     F*  Midas - General Ledger                                       *
     F*                                                               *
     F*  GL008112 - Account Keys & Generated Entries Report           *
     F*                                                               *
     F*  (c) Misys International Banking Systems Ltd 2010             *
     F*                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. AR864045           Date 20Nov11               *
      *                 CER049  *CREATE    Date 06Dec10               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR864045 - Component GLC008140 00001 failed                  *
     F*  CER049 - Stamp Tax                                           *
     F*                                                               *
     F*****************************************************************
     FGLSTGEPD  IP   E           K DISK
     FGL008112P1O    E             PRINTER INFDS(SPOOL1)
      *
      ** Extra postings for Posting Summary
      *
      ********************************************************************
      *
      * ID C  F  H  L    Function of indicators
      *
      *    90            General Error
      *    91            End of Dealing Account Keys
      * U7U8LR           DB error
      *
     F********************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D/COPY ZSRSRC,ZSEDITZ1LE
      *
      ** Data structure for ouput parameter
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for bank file
      *
     D SDCURR        E DS                  OCCURS(2) EXTNAME(SDCURRPD)
      ** Data structure for currency details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access programs
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      ** Local data area
      *
     D SPOOL1          DS
      *
      ** DS FOR P1 SPOOL FILE NAME
      *
     D  SFILE1                83     92
     D  SFNUM                123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D @OTAC           DS
     D  @OBRCA                 1      3
     D  @OCNUM                 4      9
     D  @OCCY                 10     12
     D  @OACOD                13     22
     D  @OACSQ                23     24
      *
     D OTACDS          DS
     D  OBRCA                  1      3
     D  FIL1                   4      4
     D  OCNUM                  5     10
     D  FIL2                  11     11
     D  OCCY                  12     14
     D  FIL3                  15     15
     D  OACOD                 16     25  0
     D  FIL4                  26     26
     D  OACSQ                 27     28  0
     D                 DS
     D  WORK15                 1     15  0
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
      *
     IGLSTGED0
     I                                          E8AKEY        L2
     I                                          E8ECCY        L2
     I                                          E8EDAT        L2
     I                                          E8EAMT        L2
      *
     I                                          E8DLNO        L1
     I                                          E8LNNO        L1
     I                                          E8OTAC        L1
     I*
      *****************************************************************
     C/EJECT
      *
     C     FIRST         CASEQ     ' '           SRINIT
     C                   END
      ** Main process
      *
      * Print Details
     C                   EXSR      PRTDET
      *
      ** Print Trailer
     CLR                 EXSR      SREND
      *
      *******************************************************************
      ** PRTDET - Print Report GL008112P1 - Record DETLP21 and DETLP23 *
      *******************************************************************
      *
     C     PRTDET        BEGSR
      *
     C     PRTLN1        IFGE      57
     C                   WRITE     HEADP1
     C                   END
      *
      ** Retrieve Ccy Details
      *
     C                   EXSR      SRNCCY
      *
     C                   CLEAR                   ORIGAC
     C*****E8LNNO        IFEQ      *ZEROS                                                     CLE148
     C     E8LNNO        IFEQ      *BLANKS                                                    CLE148
     C     E8DLNO        ANDEQ     *ZEROS
     C                   MOVE      E8OTAC        @OTAC
     C                   MOVE      @OBRCA        OBRCA
     C                   MOVE      @OCNUM        OCNUM
     C                   MOVE      @OCCY         OCCY
     C                   MOVE      @OACOD        OACOD
     C                   MOVE      @OACSQ        OACSQ
     C                   MOVE      OTACDS        ORIGAC
     C                   END
     C                   MOVE      E8AKEY        AKEY
     C                   MOVE      E8ECCY        EVCY
     C                   MOVE      E8LNNO        LNNO
     C                   MOVE      E8MISS        SMISS
      *
      ** Midas Conv. Day to Date - Standard functions
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      E8EDAT        U#DATE
     C                   PARM      BJDFIN        U#FMT
     C                   PARM      *ZERO         U#DYNB
     C                   PARM      *BLANK        YEVDT
      *
     C                   Z-ADD     E8EAMT        ZFLD15
     C                   Z-ADD     AKNBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR864045
     C                   CALL      'ZSEDIT'                                                 AR864045
     C                   PARM                    ZFLD15                                     AR864045
     C                   PARM                    ZDECS                                      AR864045
     C                   PARM                    ZECODE                                     AR864045
     C                   PARM                    ZOUT21                                     AR864045
     C                   MOVE      ZOUT21        EDEVAM
      *
     C                   MOVE      E8ECCY        EVCY
     C                   MOVE      E8REVI        RVRS
      *
      ** Output Account Key Details
      *
     C   L2              WRITE     DETLP21
      *
     C     PRTLN1        IFGE      57
     C                   WRITE     HEADP1
     C                   END
      *
      ** Set Posting Details
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      E8PSTD        U#DATE
     C                   PARM      BJDFIN        U#FMT
     C                   PARM      *ZERO         U#DYNB
     C                   PARM      *BLANK        PPSTD
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      E8VALD        U#DATE
     C                   PARM      BJDFIN        U#FMT
     C                   PARM      *ZERO         U#DYNB
     C                   PARM      *BLANK        PVALD
      *
     C                   Z-ADD     E8PSTA        ZFLD15
     C                   Z-ADD     PSNBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR864045
     C                   CALL      'ZSEDIT'                                                 AR864045
     C                   PARM                    ZFLD15                                     AR864045
     C                   PARM                    ZDECS                                      AR864045
     C                   PARM                    ZECODE                                     AR864045
     C                   PARM                    ZOUT21                                     AR864045
     C                   MOVE      ZOUT21        PPSTA
      *
     C                   MOVE      E8BRCA        P1BRCA
     C                   MOVE      E8CNUM        P1CNUM
     C                   MOVE      E8CCY         P1CCY
     C                   MOVE      E8ACOD        P1ACOD
     C                   MOVE      E8ACSQ        P1ACSQ
     C                   MOVE      E8DRCR        PDRCR
     C                   MOVE      E8PNAR        PNAR
      *
     C                   WRITE     DETLP31
      *
     C                   ENDSR
      *
      *****************************************************************
      ** SRNCCY - Process new currency                                *
      *****************************************************************
      *
     C     SRNCCY        BEGSR
      *
      **  Access currency details
      *
     C     *LIKE         DEFINE    A6CYCD        ##CYCD
     C     *LIKE         DEFINE    A6NBDP        AKNBDP
     C     *LIKE         DEFINE    A6NBDP        PSNBDP
      *
     C     E8ECCY        IFNE      *BLANKS
     C                   MOVEL     E8ECCY        ##CYCD
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
     C                   MOVE      A6NBDP        AKNBDP
      *
     C     E8CCY         IFNE      *BLANKS
     C                   MOVEL     E8CCY         ##CYCD
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
     C                   MOVE      '002'         DBASE
     C                   MOVEL     ##CYCD        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   MOVE      A6NBDP        PSNBDP
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      **  SREND - Write Trailer Detail
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
      **  SRINIT - inital process                                     *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
     C                   MOVEA     CPY@          BIS@
     C                   MOVE      'Y'           FIRST
      *
     C                   MOVE      '-'           FIL1
     C                   MOVE      '-'           FIL2
     C                   MOVE      '-'           FIL3
     C                   MOVE      '-'           FIL4
      *
      **  Set up LDA
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'GL008112'    DBPGM
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
     C                   MOVE      '003'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Output GL008112P1 Header
      *
     C                   WRITE     HEADP1
      *
      ** Ensure the spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUM         ZSNUM
      *
      ** Call ZSFILE for GL008112P1
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
(C) Copyright Misys International Banking Systems Ltd. 2010
