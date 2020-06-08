     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC 24x7 Queued Data file Status Update')         *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000356 - Midas SC 24x7 Queued Data file Status Update      *
      *                                                               *
      *  Function:  This program will access PF/API24X7SPD from 24x7  *
      *             layer using journal details from PF/ZATRNLOGPD    *
      *             from zone layer                                   *
      *                                                               *
      *  Called By: CLLE/SCC000356 - Midas SC 24x7 Queued Data file   *
      *               Status Update                                   *
      *                                                               *
      *  (C) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CAP702  *CREATE    Date 12May20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP702 - 24x7 APIs - Common Processing                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
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
      **
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FAPI24X7SL1UF A E           K DISK    INFSR(*PSSR)
      ** Midas AP Queued Data file
      *
     FSCCDJNPD  UF   E           K DISK    INFSR(*PSSR)
      *
      ****************************************************************
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      ** True       logical = *ON (for indcator processing)
      ** False      logical = *OFF (for indcator processing)
      ** DBErrCtl   10A = 'DBERRCTL' (the name of the database error
      ** handler)
      ** and the following variables:
      ** RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D JournalEnt      DS
      * Standard fields on all journal entries
     D  Filler01                      5A
     D  JrnSeqn                      10A
     D  JrnCode                       1A
     D  JrnEntType                    2A
     D  Filler02                     38A
     D  Program                      10A
     D  File_Name                    10A
     D  Library                      10A
     D  Member                       10A
     D  RelRecNum                    10A
     D  Filler03                     19A

     D ControlInf      DS
     D  CTRLInfo1                     1

     D WQMSGS          DS
     D  APINME                45     48

     D WAPOUT          DS         32000
     D  BufAP                 45     48

     D ZATRNLGL        DS           168
     D  AAFOTR                 1     20
     D  AATMES                21     46
     D  AAMIDA                47     48
     D  AAMIDT                49     74
     D  AAACTN                75     75
     D  AARESP                76     76
     D  AARPRL                77     77
     D  AACNFV                78     78
     D  AASTAT                79     79
     D  AAASOC                80     99
     D  AAMSGL               100    118
     D  AAMIDT2              119    168

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
      ** Process transactions
      *
     C     *ENTRY        PLIST
     C                   PARM                    JournalEnt
     C                   PARM                    ControlInf
      *
      * If the first byte of Control Information is 0, no data has been
      *  passed so simply return
      *
B1   C                   IF        ControlInf = '0'
     C                   SETON                                        LR
     C                   ELSE
B2   C     ControlInf    IFEQ      '1'
     C     File_Name     ANDEQ     'ZATRNLOGPD'
      *
      ** Perform process for T_APIMSG
      *
     C                   EXSR      PROCES
E2   C                   ENDIF
      *
      ** Read the Midas SC Extracted Journal Info file
      *
     C                   READ      SCCDJND0                               57
      *
     C     *IN57         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'SCCDJNPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      ** Update the record on PF/SCCDJNPD
      *
     C                   MOVEL     JrnSeqn       JOSEQN
     C                   UPDATE    SCCDJND0                             42
      *
B2   C     *IN42         IFEQ      '0'
     C                   COMMIT
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE
     C                   MOVEL     'SCCDJNPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
E2   C                   ENDIF
      *
      ** Determine if program is going to shut down
      *
     C                   SHTDN                                        97
B2   C     *IN97         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   MOVEL     '9'           ControlInf
E2   C                   ENDIF
      *
E1   C                   ENDIF
      *
     C                   RETURN
      *
     *****************************************************************
      /EJECT
      *****************************************************************
      * PROCES - Process Transactions details                         *
      *                                                               *
      *****************************************************************
     C     PROCES        BEGSR
      *    ------        -----
      *
     C     File_Name     IFEQ      'ZATRNLOGPD'
     C                   MOVEL     JournalEnt    ZATRNLGL
     C                   END
      *
      ** Access API24X7SPD using MQMSID
      *
     C                   MOVEL     AAMSGL        KMQSID           19 0
      *
     C     KMQSID        CHAIN     API24X7SL1                         71
     C                   IF        *IN71 = *off
      *
     C     APSTAT        IFEQ      ' '
      *
     C     AASTAT        IFEQ      'S'
     C                   MOVEL     'P'           APSTAT
     C                   ELSE
     C     AASTAT        IFEQ      'F'
     C                   MOVEL     'E'           APSTAT
     C                   ENDIF
     C                   ENDIF
     C                   UPDATE    API24X7SD0
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EndPROCES     ENDSR
      *    ----------    -----
      *****************************************************************
      * *PSSR                                                         *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
      *
     C                   RETURN
      *
     C                   ENDSR
