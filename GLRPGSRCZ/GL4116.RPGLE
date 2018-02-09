     H DEBUG
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                       CGL120
/*STD *  RPGBASEMOD                                                   *                       CGL120
/*EXI *  TEXT('Midas GL Daily journal summary')                       *
     F*****************************************************************
     F*                                                               *
     F*    Midas - General Ledger Module                          *
     F*                                                               *
     F*    GL4116 - Daily Journal Summary                             *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL127AQ           Date 06Aug12               *
      *                 CGL120             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD005             Date 11MAR99               *
      *                 CTI002 EM / TI Interface 23/09/98             *
     F*                   CRT001 *CREATE   DATE  28FEB95              *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL127AQ - COB Restructure - GL COB Optimisation Phase 1     *
      *  CGL120 - GL COB Components Task Split                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
     F*  CSD005 - Standing Data Account Narrative. If swichable featur*
     F*           is active thw current account description           *
     F*           is replaced with the account narrative.             *
      *  CTI002 - Recompiled : File SDACODPD changed                  *
     F*  CRT001  - Retail Teller System                               *
     F*                                                               *
     F*****************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*****************************************************************
     F*
     FACJXH     IP   E             DISK
     F** EOD Postings Extract Header
     F*
     FACJXD     IS   E           K DISK
     F** EOD Postings Extract Detail
     F*
     FACJXT     IS   E             DISK
     F** EOD Postings Extract Trailer
     F*
     FSDCURRL1  IF   E             DISK                                                     CGL127AQ
      ** Midas SD Currency codes file                                                       CGL127AQ
      *                                                                                     CGL127AQ
     FGL4116P1  O    E             PRINTER INFDS(SPOOL)
     F                                     OFLIND(*IN01)
     F                                     USROPN
     F** Daily Journal Summary Report
     F*
     FGL4116AU  O    E             PRINTER INFDS(SPOOLU)
     F** Daily Journal Summary Audit Report
     F*
     F*****************************************************************
     F*                                                               *
     F* F U N C T I O N   O F   I N D I C A T O R S                   *
     F*                                                               *
     F*   01  -  Overflow indicator                                   *
     F*   02  -  PF/ACJXD- detail                                     *
     F*                                                               *
     F*   10  -  Output A/C code header after A/C Code change         *
     F*   20  -  First cycle indicator                                *
     F*   21  -  Allows output after first level break                *
     F*   30  -  Posting is a debit                                   *
     F*   31  -  Posting is a credit                                  *
     F*   32  -  Multibranching ON                                    *
     F*   40  -  Sort sequence indicator - P                          *
     F*   41  -  Sort sequence indicator - R                          *
     F*   60  -  Currency has zero Decimal Place                      *
     F*   61  -  Currency has ONE Decimal Place                       *
     F*   62  -  Currency has TWO Decimal Places                      *
     F*   63  -  Currency has THREE Decimal Places                    *
     F*   70  -  Hash totals disagree                                 *
     F*   71  -  Number of records disagree                           *
     F*   75  -  Chain fail indicator                                 *
     F*                                                               *
     F*   U7  -  Database in error                                    *
     F*   U8  -  Database in error/files out of balance               *
     F**                                                              *
     F*****************************************************************
     F/EJECT
     F*****************************************************************
     F*                                                               *
     F*  S U B R O U T I N E   I N D E X                              *
     F*                                                               *
     F*  FIRST  - Initial processing                                  *
     F*  SETBRC - Set branch details                                  *
     F*  FINAL  - Final Processing                                    *
     F*                                                               *
     F*****************************************************************
     F*
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *                                                                                     CGL127AQ
     D ARSCURR         C                   CONST(250)                                       CGL127AQ
     D TRUE            C                   CONST(*ON)                                       CGL127AQ
     D FALSE           C                   CONST(*OFF)                                      CGL127AQ
      *                                                                                     CGL127AQ
     D CCURR           S              3A   DIM(ARSCURR) INZ                                 CGL127AQ
      *                                                                                     CGL127AQ
     D LDA             DS           256
     D**  Local data area for data base errors.
     D*
     D**  Field combining the following fields
     D  DBLOT                134    183
     D**  Name of database file in error
     D  DBFILE               134    141
     D**  Key value causing database error
     D  DBKEY                142    170
     D**  Name of program causing database error
     D  DBPGM                171    180
     D**  Number of database error
     D  DBASE                181    183  0
     D*
     D** Data Area Rundat
     D*
     D RUNDAT          DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D** Bank Details              Retrieval index
     D*
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D                                     OCCURS(ARSCURR)                                  CGL127AQ
     D                                     INZ                                              CGL127AQ
     D** Currency Code             Retrieval index
     D*
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D** Account Code Details      Retrieval index
     D*
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D**  Branch Codes
     D*                                                                   CSD005
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSD005
     D** MIDAS Switchable Features Accessed Via Access Program            CSD005
     D*                                                                   CSD005
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D                                     INZ                                              CGL127AQ
     D*
     D** First DS for access programs, Short data structure
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D                                     INZ                                              CGL127AQ
     D*
     D** Second DS for access programs, Long data structure
     D*
     D PFKEY           S              3A   INZ                                              CGL127AQ
     D FoundInCache    S              1N   INZ                                              CGL127AQ
      *                                                                                     CGL127AQ
     D IDXTRLCR        S              4  0 INZ                                              CGL127AQ
     D IDXCURCR        S                   INZ LIKE(IDXTRLCR)                               CGL127AQ
     D KEYTMPCR        S                   INZ LIKE(PFKEY)                                  CGL127AQ
      *                                                                                     CGL127AQ
     D** FILE INFORMATION DATA STRUCTURE
     D*
     D SPOOL           DS
     D  OPEN                   9      9
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D SPOOLU          DS
     D  OPENU                  9      9
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     I*
     I*    SORTED ACCOUNT JOURNAL POSTINGS EXTRACT FILE DETAIL RECORD.
     I*
     IACJXPDF
     I                                          CCY           L4
     I                                          ACOD          L3
     I                                          BRCA          L1
     I                                          SSIN          L2
     I                                          ORBR          L5
     I*
     C/EJECT
     C********************************************************************
     C*                                                                  *
     C**          F I R S T   C Y C L E   P R O C E S S I N G           **
     C*                                                                  *
     C********************************************************************
     C*
     C** COPYRIGHT STATEMENT
     C                   MOVEA     CPY@          BIS@             80
     C   20              GOTO      START
     C                   SETON                                        20
     C*
     C** First Cycle Processing
     C                   EXSR      FIRST
     C*
     C                   GOTO      END
     C*
     C********************************************************************
     C*                                                                  *
     C**         D E T A I L   C Y C L E   P R O C E S S I N G          **
     C*                                                                  *
     C********************************************************************
     C*
     C     START         TAG                                                    ** START TAG **
     C*
     C   L4
     COR L5              SETON                                        01
     C*
     C**   MAINTAIN COUNT OF ALL RECORDS READ
     C                   ADD       1             COUNT             5 0
     C*
     C**   ALL FURTHER CALCULATIONS ONLY FOR DETAIL RECORDS
     C     RECI          COMP      'D'                                    02
     C*
     C**   Get branch details and open printer file
     C     *INL5         IFEQ      '1'
     C     *IN02         ANDEQ     '1'
     C                   EXSR      SETBRC
     C                   END
     C*
     C  N02              GOTO      END
     C*
     C**   ACCRUE HASH TOTALS FOR EACH POSTING READ FROM S/SACJX
     C                   MOVE      PSTA          ZZAMT
     C                   Z-ADD     TOTI          ZZTOTI
     C                   Z-ADD     TOTD          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        TOTI             15 0
     C                   Z-ADD     ZZTOTD        TOTD              3 0
     C*
     C*
     C**   CLEAR TOTALS
     C   L3              Z-ADD     0             DRTOTA           13 0
     C   L3              Z-ADD     0             CRTOTA           13 0
     C   L3              Z-ADD     0             ACTOT            13 0
     C*
     C   L1              Z-ADD     0             DRTOT            13 0
     C   L1              Z-ADD     0             CRTOT            13 0
     C   L1              Z-ADD     0             BRTOT            13 0
     C*
     C*
     C**   ACCESS CURRENCY TABLE FOR CURRENCY NAME AND DECIMAL PLACES
     C   L4              SETOFF                                       0499
     C*
     C   L4              EVAL      KEYTMPCR = PFKEY                                         CGL127AQ
     C   L4              EVAL      FoundInCache = FALSE                                     CGL127AQ
      *                                                                                     CGL127AQ
     C   L4              IF        IDXTRLCR <> 0                                            CGL127AQ
      *                                                                                     CGL127AQ
     C                   IF        KEYTMPCR = CCURR(IDXCURCR)                               CGL127AQ
     C                   EVAL      FoundInCache = TRUE                                      CGL127AQ
     C                   ELSE                                                               CGL127AQ
      *                                                                                     CGL127AQ
     C                   EVAL      IDXCURCR = %LOOKUP( KEYTMPCR :                           CGL127AQ
     C                                                 CCURR :                              CGL127AQ
     C                                                 1 : IDXTRLCR )                       CGL127AQ
     C                   IF        IDXCURCR <> 0                                            CGL127AQ
     C                   EVAL      FoundInCache = True                                      CGL127AQ
     C                   ENDIF                                                              CGL127AQ
      *                                                                                     CGL127AQ
     C                   ENDIF                                                              CGL127AQ
      *                                                                                     CGL127AQ
     C                   ENDIF                                                              CGL127AQ
      *                                                                                     CGL127AQ
     C   L4              IF        FoundInCache                                             CGL127AQ
     C                   EVAL      %OCCUR(SDCURR) = IDXCURCR                                CGL127AQ
     C                   Z-ADD     A6NBDP        CDP                                        CGL127AQ
     C                   MOVEL     A6CYNM        CCNM                                       CGL127AQ
      *                                                                                     CGL127AQ
     C                   ELSE                                                               CGL127AQ
     C                   EVAL      %OCCUR(SDCURR) = IDXCURCR                                CGL127AQ
     C***L4*****         CALL      'AOCURRR0'                                                 CGL120
     C   L4              CALLB     'AOCURRR0'                                                 CGL120
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CCY           @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C                   Z-ADD     A6NBDP        CDP               1 0
     C                   MOVEL     A6CYNM        CCNM             14
     C*
     C   L4@RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   SETON                                        U7U8LR
     C                   MOVE      'SDCURRPD'    DBFILE                         ***************
     C                   Z-ADD     2             DBASE                          **DB ERROR 02**
     C                   MOVEL     CCY           DBKEY                          ***************
     C                   GOTO      END
     C                   END
      *                                                                                     CGL127AQ
     C                   ENDIF                                                              CGL127AQ
     C*
     C**   DETERMINE NUMBER OF DECIMAL PLACES
     C   L4CDP           COMP      1                                    6061
     C   L4CDP           COMP      2                                  63  62
     C*
     C**   ACCESS ACCOUNT CODES TABLE FOR ACCOUNT CODE DESCRIPTION
     C   L3              SETOFF                                       0399
     C***L3*****           MOVE ACOD      ACODA   4                                           CGL029
     C   L3              MOVE      ACOD          ACODA            10                          CGL029
     C*
     C***L3*****         CALL      'AOACODR0'                                                 CGL120
     C   L3              CALLB     'AOACODR0'                                                 CGL120
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C**********           PARM ACODA     @ACOD   4                                           CGL029
     C                   PARM      ACODA         @ACOD            10                          CGL029
     C     SDACOD        PARM      SDACOD        DSSDY
     C*
     C     *IN73         IFEQ      *OFF                                                       CSD005
     C                   MOVEL     A5ACCN        ACKN             25
     C                   ELSE                                                                 CSD005
     C                   MOVEL     A5NARR        W#NARR           50                          CSD005
     C                   ENDIF                                                                CSD005
     C*
     C   L3@RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   SETON                                        U7U8LR
     C                   MOVE      'SDACODPD'    DBFILE                         ***************
     C                   Z-ADD     3             DBASE                          * DB ERROR 03 *
     C                   MOVEL     ACODA         DBKEY                          ***************
     C                   GOTO      END
     C                   END
     C*
     C**   SET INDICATOR TO ALLOW OUTPUT AFTER FIRST LEVEL BREAK
     C   L1              SETON                                        21
     C*
     C**   SET INDICATOR TO ALLOW OUTPUT FOR A/C CODE HEADER
     C**   AFTER A/C CODE CHANGE.
     C   L3              MOVE      '1'           *IN10
     C*
     C**   DETERMINE IF POSTING IS A DEBIT OR CREDIT
     C     DRCR          COMP      0                                  31  30
     C*
     C*    ACCUMULATE DEBIT & CREDIT BRANCH TOTALS
     C   30DRTOT         ADD       PSTA          DRTOT
     C   31CRTOT         ADD       PSTA          CRTOT
     C*
     C*    ACCUMULATE DEBIT & CREDIT ACCOUNT CODE TOTALS
     C   30DRTOTA        ADD       PSTA          DRTOTA
     C   31CRTOTA        ADD       PSTA          CRTOTA
     C*
     C**   DETERMINE SOURCE OF POSTING FROM SORT SEQUENCE INDICATOR
     C     SSIN          COMP      'P'                                    40
     C     SSIN          COMP      'R'                                    41
     C*
     C*    MOVE DEBIT & CREDIT AMOUNTS TO OUTPUT FIELDS FOR REPORT
     C   60              Z-ADD     DRTOT         DRTOT0
     C   61              Z-ADD     DRTOT         DRTOT1
     C   62              Z-ADD     DRTOT         DRTOT2
     C   63              Z-ADD     DRTOT         DRTOT3
     C*
     C   60              Z-ADD     DRTOTA        DTOTA0
     C   61              Z-ADD     DRTOTA        DTOTA1
     C   62              Z-ADD     DRTOTA        DTOTA2
     C   63              Z-ADD     DRTOTA        DTOTA3
     C*
     C   60              Z-ADD     CRTOT         CRTOT0
     C   61              Z-ADD     CRTOT         CRTOT1
     C   62              Z-ADD     CRTOT         CRTOT2
     C   63              Z-ADD     CRTOT         CRTOT3
     C*
     C   60              Z-ADD     CRTOTA        CTOTA0
     C   61              Z-ADD     CRTOTA        CTOTA1
     C   62              Z-ADD     CRTOTA        CTOTA2
     C   63              Z-ADD     CRTOTA        CTOTA3
     C*
     C     END           TAG                                                    ** END TAG **
     C**   SET OFF OVERFLOW INDICATOR
     C** 01                SETOF                     01
     C*
     C**   CALCULATE NET TOTAL FOR BRANCH
     CL1   DRTOT         SUB       CRTOT         BRTOT
     CL1 60              Z-ADD     BRTOT         BRTOT0
     CL1 61              Z-ADD     BRTOT         BRTOT1
     CL1 62              Z-ADD     BRTOT         BRTOT2
     CL1 63              Z-ADD     BRTOT         BRTOT3
     CL1 21
     CAN 01              WRITE     HEADP1
     CL1 21
     CAN 01              WRITE     HEADP2
     CL1 21
     CAN 01              SETOFF                                       01
     CL1 21
     CAN 10              WRITE     HEADP3
     CL1 21
     CAN 10              MOVE      '0'           *IN10
     CL1 21              WRITE     DETAIL
     C*
     C**   CALCULATE NET TOTAL FOR ACCOUNT CODE
     CL3   DRTOTA        SUB       CRTOTA        ACTOT
     CL3 60              Z-ADD     ACTOT         ACTOT0
     CL3 61              Z-ADD     ACTOT         ACTOT1
     CL3 62              Z-ADD     ACTOT         ACTOT2
     CL3 63              Z-ADD     ACTOT         ACTOT3
     CL3 21
     CAN 01              WRITE     HEADP1
     CL3 21
     CAN 01              WRITE     HEADP2
     CL3 21
     CAN 01              SETOFF                                       01
     CL3 21              WRITE     TOTAL
     C*
     C*
     C********************************************************************
     C*                                                                  *
     C**          L A S T   C Y C L E   P R O C E S S I N G             **
     C*                                                                  *
     C********************************************************************
     C*
     CLR                 EXSR      FINAL
     CLR                 CLOSE     *ALL
     C*
      /EJECT
      *****************************************************************
      *                                                               *
      *            SETBRC - Set Branch Sub-Heading                    *
      *                                                               *
      * CALLS                                                         *
      *                                                               *
      * CALLED BY  MAIN   - Control Processing                        *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     SETBRC        BEGSR                                                  ** RCFP1  **
     C*
     C     OPEN          IFEQ      'Y'
     C                   WRITE     LAST
     C                   CLOSE     GL4116P1
     C                   END
     C*
     C** Open printer file GL4116P1 if entity is not blank or the
     C** printer file is not yet open
     C*
     C     OPEN          IFNE      'Y'
     C                   OPEN      GL4116P1
     C                   MOVE      '1'           *IN01
     C                   MOVE      'Y'           OPEN
     C*
     C** Ensure Report Spool File Recorded by RCF for P1 report
     C*
     C                   Z-ADD     SFNUM         ZSNUM             6 0
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ               5
     C                   PARM      ORBR          SENTY             3
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM      *BLANKS       ZSERR             1
     C*
     C** Error During ZSFILE Processing, Return to Calling Program
     C*
     C     ZSERR         IFEQ      'Y'
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   END
     C*
     C**  Get branch name using access object
     C*
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      ORBR          @BRCA             3
     C********** SDBRCH    PARM SDBRCH    DSFDY                                               CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C*
     C**  Check if error occurred
     C*
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   SETON                                        U7U8LR
     C                   MOVE      'SDBRCHPD'    DBFILE                         *************
     C                   Z-ADD     4             DBASE                          * DB ERR 04 *
     C                   MOVEL     @BRCA         DBKEY                          *************
     C                   GOTO      END
     C                   END
     C*
     C                   MOVE      A8BRNM        PBRNM
     C*
     C                   END
     C**
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*            FINAL  - Final Processing                          *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  Main   - Control Process                           *
     C*                                                               *
     C*****************************************************************
     C     FINAL         BEGSR                                                  *** FIRST  ***
     C**
     C                   ADD       1             COUNT
     C*
     C**   Compare hash totals to trailer value
     C     TOTI          COMP      HRWN                               7070
     C     *IN70         IFEQ      '0'
     C     TOTD          COMP      HRDC                               7070
     C     *IN70         IFEQ      '1'
     C                   MOVE      '1'           *INU7
     C                   END
     C                   END
     C*
     C**   Compare number of records calculated to trailer value
     C     NORE          COMP      COUNT                              7171
     C     *IN71         IFEQ      '1'
     C                   MOVE      '1'           *INU7
     C                   END
     C*
     C**   Write audit header
     C                   WRITE     HEADAU
     C*
     C**   Database error processing
     C     *INU7         IFEQ      '1'
     C     *INU8         ANDEQ     '1'
     C                   MOVEL     'GL4116'      DBPGM
     C                   WRITE     ERROR
      *
     C     OPEN          IFEQ      'Y'
     C                   WRITE     ERRLINE
     C                   END
      *
     C                   OUT       LDA
     C                   DUMP
     C*
     C                   ELSE
     C*
     C**   Write audit details
     C     COUNT         IFGT      2
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   END
     C*
     C                   END
      *
     C**   Write END OF REPORT
     C     COUNT         IFGT      2
     C     OPEN          ANDEQ     'Y'
     C                   WRITE     LAST
     C                   END
      *
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*            FIRST  - Initial Processing                        *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY  Main   - Control Process                           *
     C*                                                               *
     C*****************************************************************
     C     FIRST         BEGSR                                                  *** FIRST  ***
      *
      **   Reset LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBPGM
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA
     C*
     C** Ensure Audit Spool File Recorded by RCF
     C*
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSEQ              5
     C                   PARM                    SENTY             3
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANKS       ZSERRU            1
     C*
     C** Error During ZSFILE Processing, Return to Calling Program
     C*
     C     ZSERRU        IFEQ      'Y'
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   END
     C*
     C** Access bank details for midas-run-date
     C*
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C                   MOVEL     BJDFIN        DATF              1
     C*
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   SETON                                        U7U8LR
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   MOVEL     @OPTN         DBKEY                          ***************
     C                   GOTO      END
     C                   END
     C*
     C*    CHECK SYSTEM DATE FORMAT, DDMMYY OR MMDDYY.
     C     DATF          COMP      'M'                                    98    -MMDDYY
     C*
     C** Read in DTAARA/RUNDAT to get multibranching indicator
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C*
     C                   MOVE      '0'           *IN32
     C     MBIN          IFEQ      'Y'
     C                   MOVE      '1'           *IN32
     C                   END
     C*
     C                   MOVE      *BLANKS       DBLOT
     C                   MOVEL     'GL4116'      DBPGM
     C                   Z-ADD     0             COUNT
      *                                                                   CSD005
      * Obtain switchable feature CSD005 status.                          CSD005
      *                                                                   CSD005
     C                   CALL      'AOSARDR0'                                                 CSD005
     C                   PARM      *BLANKS       @RTCD             7                          CSD005
     C                   PARM      '*VERIFY'     @OPTN             7                          CSD005
     C                   PARM      'CSD005'      @SARD             6                          CSD005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD005
      *                                                                   CSD005
     C                   SELECT                                                               CSD005
     C     @RTCD         WHENEQ    *BLANK                                                     CSD005
     C                   MOVE      *ON           *IN73                                        CSD005
     C     @RTCD         WHENEQ    '*NRF'                                                     CSD005
     C                   MOVE      *OFF          *IN73                                        CSD005
     C                   OTHER                                                                CSD005
     C     *LOCK         IN        LDA                                                        CSD005
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CSD005
     C                   MOVEL     '005'         DBASE                          *DBERROR 005* CSD005
     C                   MOVEL     @OPTN         DBKEY                          ************* CSD005
     C                   SETON                                        U7U8LR                  CSD005
     C                   GOTO      END                                                        CSD005
     C                   ENDSL                                                                CSD005
      *                                                                   CSD005
      ** Full Cache SDCURRPD                                                                CGL127AQ
      *                                                                                     CGL127AQ
     C                   READ      SDCURRL1                               13                CGL127AQ
     C                   IF        *IN13 = *OFF                                             CGL127AQ
     C                   EVAL      IDXTRLCR = 1                                             CGL127AQ
     C                   EVAL      CCURR(IDXTRLCR) = A6CYCD                                 CGL127AQ
     C                   ENDIF                                                              CGL127AQ
      *                                                                                     CGL127AQ
     C                   DOW       *IN13 = *OFF                                             CGL127AQ
     C                   EVAL      IDXTRLCR += 1                                            CGL127AQ
      *                                                                                     CGL127AQ
     C                   IF        IDXTRLCR > ARSCURR                                       CGL127AQ
     C                   Z-ADD     1             IDXTRLCR                                   CGL127AQ
     C                   ENDIF                                                              CGL127AQ
      *                                                                                     CGL127AQ
     C                   READ      SDCURRL1                               13                CGL127AQ
     C                   IF        *IN13 = *OFF                                             CGL127AQ
     C                   EVAL      CCURR(IDXTRLCR) = A6CYCD                                 CGL127AQ
     C                   ENDIF                                                              CGL127AQ
      *                                                                                     CGL127AQ
     C                   ENDDO                                                              CGL127AQ
      *                                                                                     CGL127AQ
     C                   EVAL      IDXCURCR = IDXTRLCR                                      CGL127AQ
     C*
     CSR                 ENDSR
     C*
      /EJECT
     C********************************************************************
     C* GLZADD SR. TO ADD AN AMOUNT (ZZAMT) TO THE TOTAL (ZZTOTI,ZZTOTD).
     C*             IND '99' IS SET BY AN OVERFLOW ERROR.
     C*
     CSR   GLZADD        BEGSR                                                  *** GLZADD ***
     C*
     CSR                 Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
     CSR 91              GOTO      ZZAEND                                       AMT = 0.BYPASS
     C*
     C* SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS.
     CSR                 Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
     CSR                 MOVE      ZZAMT         ZZAMTD            3 0          DECIMAL FIELD
     C* BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW.
     C*
     CSR                 EXSR      GLZSUM
     C*
     CSR   ZZAEND        ENDSR                                                  ** ZZAEND TAG *
     C*
     C********************************************************************
     C* GLZSUM SR. TO CARRY OUT THE ADDITION FOR SUBROUTINES -
     C*                                            GLZADD, GLZSUB, GLZCMP.
     C*      PARAMETERS. I/P - ZZAMTI,ZZAMTD
     C*                  O/P - ZZTOTI,ZZTOTD,ZZNEGD,IND 96,IND 99.
     C*
     CSR   GLZSUM        BEGSR                                                  *** GLZSUM ***
     CSR                 Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
     CSR                 Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
     CSR                 SETOFF                                       919293
     CSR                 SETOFF                                       949599
     C*
     C*    DETERMINE SIGN OF ZZAMTI & D, 92 IF NEGATIVE.
     CSR   ZZAMTI        COMP      0                                    9293
     CSR 93ZZAMTD        COMP      0                                    9293
     CSR 93              GOTO      ZZSEND                                       ZERO BYPASS
     C*
     C*    DETERMINE SIGN OF ZZTOTI & D, 91 IF NEGATIVE.
     CSR   ZZTOTI        COMP      0                                    9193
     CSR 93ZZTOTD        COMP      0                                    9193
     C*
     C*    IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.
     CSR 93              Z-ADD     ZZAMTI        ZZTOTI
     CSR 93              Z-ADD     ZZAMTD        ZZTOTD
     CSR 93              GOTO      ZZSEND                                       ZERO BYPASS
     C*
     C*    IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.
     CSR 91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
     C*
     CSR   ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     CSR   ZZWK2         COMP      999                                93        '93' = CARRY
     CSRN93ZZWK2         COMP      -999                                 93             INTO INTEGER.
     C*
     CSR 93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0          ADD 'CARRY' +VE
     CSR 93
     CAN 92ZZAMTI        SUB       1             ZZWK3                          SUB 'CARRY' -VE
     CSR 93ZZTOTI        ADD       ZZWK3         ZZWK3
     CSRN93ZZTOTI        ADD       ZZAMTI        ZZWK3
     C*
     C* IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED.
     CSRN92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS ZZAMT
     CSR 92ZZWK3         COMP      ZZTOTI                             99                IS NEGATIVE.
     CSRN99              Z-ADD     ZZWK2         ZZTOTD
     CSRN99              Z-ADD     ZZWK3         ZZTOTI
     C*
     C* IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.
     CSR 99              Z-ADD     0             ZZAMT            15 3
     CSR                 GOTO      ZZSEND
     C*
     C*    THE 'SIGNS' ARE DIFFERENT.
     CSR   ZZOFPS        TAG                                                    ** ZZOFPS TAG**
     C*
     C*    IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT.
     CSR 92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     CSR 92              Z-SUB     ZZAMTD        ZZAMTD            3 0
     C*
     C*    IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.
     CSR 91              Z-SUB     ZZTOTI        ZZTOTI
     CSR 91              Z-SUB     ZZTOTD        ZZTOTD
     C*    BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.
     C*
     CSR   ZZTOTI        COMP      ZZAMTI                             93  95
     CSR 95ZZTOTD        COMP      ZZAMTD                             93  95
     C*
     C*    IF ZZTOT EQ. ZZAMT RETURN ZERO.
     CSR 95              Z-ADD     0             ZZTOTI
     CSR 95              Z-ADD     0             ZZTOTD
     CSR 95              GOTO      ZZSEND
     C*
     C*    IF ZZTOT GT. ZZAMT.
     CSR 93ZZAMTD        COMP      ZZTOTD                             94
     CSR 93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     CSR 93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     CSR 93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     CSR 93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     CSR 93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
     C*
     C*    IF ZZAMT GT. ZZTOT.
     CSRN93ZZTOTD        COMP      ZZAMTD                             94
     CSRN93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     CSRN93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     CSRN93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     CSRN93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     CSRN93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     CSRN93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
     C*
     C*    REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE.
     CSR                 SETOFF                                       94
     CSR 93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     CSR 94              Z-SUB     ZZTOTI        ZZTOTI
     CSR 94              Z-SUB     ZZTOTD        ZZTOTD
     C*
     C*    RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.
     CSR 92              Z-SUB     ZZAMTI        ZZAMTI
     CSR 92              Z-SUB     ZZAMTD        ZZAMTD
     C*
     C*    IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.
     CSR   ZZSEND        TAG                                                    ** ZZSEND TAG *
     CSR                 SETOFF                                       96
     CSR   ZZTOTD        COMP      0                                      91
     CSR 91ZZTOTI        COMP      0                                    96
     CSR 96              MOVE      '.000-'       ZZNEGD            5
     CSR                 ENDSR                                                           ** ENDSR **
     C*
     C********************************************************************
** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
