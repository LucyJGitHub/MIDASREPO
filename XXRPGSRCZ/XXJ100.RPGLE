     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Next Capitalisation Date Update')             *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      ***REJ100*-*Midas*RE*Next*Capitalisation update******************         JMI108
      *  XXJ100 - Midas RE Next Capitalisation update                 *         JMI108
      *                                                               *
      *  Function:  This program runs on the first working day of the *
      *             month                                             *
      *                                                               *
      ***Called*By:*RECJ100********************************************         JMI108
      *  Called By: XXCJ100                                           *         JMI108
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2005*************         JMI108
      *  (c) Finastra International Limited 2018                      *         JMI108
      *                                                               *
      *  Last Amend No. JMI108             Date 31May18               *
      *  Prev Amend No. TFJ11B  *CREATE    Date 17Jan07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI108 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ11B - Retail interest Capitalisation Date Change Utility  *
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
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Account Pooling Details
     F***SDPLACPP  IF   E             DISK    INFSR(*PSSR)                      JMI108
     FXXPLACPP  IF   E             DISK    INFSR(*PSSR)                         JMI108
     F                                     USROPN
      ** Account Details
     FACCNT     UF   E           K DISK    INFSR(*PSSR)

      ** I/O Account Capitalisation Details
     F***REIORCPP  O    E             DISK    INFSR(*PSSR)                      JMI108
     FXXIORCPP  O    E             DISK    INFSR(*PSSR)                         JMI108
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
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      ** EXTERNAL DS FOR RETAIL DETAILS

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1

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
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT

     C                   EXSR      MAIN

     C                   EXSR      END

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Processing routine                                *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     MAIN          BEGSR

     C****************** OPEN      SDPLACPP                                     JMI108
     C                   OPEN      XXPLACPP                                     JMI108
      *
      * Read all Account Pooling records
     C****************** READ      SDPLACD0                               80    JMI108
     C                   READ      XXPLACD0                               80    JMI108
     C     *IN80         DOWEQ     *OFF
      *
      * If Pooling Account is a live inter-office account
B1   C     JSCHMI        IFEQ      'I'
B1   C     JRECI         ANDNE     '*'
      *
     C     KACCNT        CHAIN     ACCNT                              81

      * If found and Debit Interest Frequency is 'B' (Last working
      * day of month) change next Debit interest capitalisation date
B2   C     *IN81         IFEQ      *OFF
     C     DRIF          ANDEQ     'B'
     C     RECI          ANDNE     'C'
     C                   Z-ADD     NDID          JNDIDB
     C     NDID          SUB       1             NDID
     C                   Z-ADD     NDID          JNDIDA
E2   C                   ENDIF
      *
      * If found and Credit Interest Frequency is 'B' (Last working
      * day of month) change next Credit interest capitalisation date
B2   C     *IN81         IFEQ      *OFF
     C     CRIF          ANDEQ     'B'
     C     RECI          ANDNE     'C'
     C                   Z-ADD     NCID          JNCIDB
     C     NCID          SUB       1             NCID
     C                   Z-ADD     NCID          JNCIDA
E2   C                   ENDIF
      *
      * If either of the Debit or Credit interest frequencies is 'B'
      * then update ACCNTAB and write record to extract file
B2   C     DRIF          IFEQ      'B'
     C     RECI          ANDNE     'C'
     C     *IN81         ANDEQ     *OFF
     C     CRIF          OREQ      'B'
     C     RECI          ANDNE     'C'
     C     *IN81         ANDEQ     *OFF
     C                   UPDATE    ACCNTABF
      *
     C                   MOVE      BRCA          JBRCA
     C****************** Z-ADD     CNUM          JCNUM                          JMI108
     C                   MOVEL     CNUM          JCNUM                          JMI108
     C                   MOVE      CCY           JCCY
     C                   Z-ADD     ACOD          JACOD
     C                   Z-ADD     ACSQ          JACSQ
     C                   Z-ADD     ACNO          JACNO
     C                   MOVE      ANAM          JANAM
      *
B3   C     DRIF          IFNE      'B'
     C                   Z-ADD     NDID          JNDIDB
     C                   Z-ADD     NDID          JNDIDA
E3   C                   ENDIF
      *
B3   C     CRIF          IFNE      'B'
     C                   Z-ADD     NCID          JNCIDB
     C                   Z-ADD     NCID          JNCIDA
E3   C                   ENDIF
      *
     C****************** WRITE     REIORCD0                                     JMI108
     C                   WRITE     XXIORCD0                                     JMI108
E2   C                   ENDIF
      *
E1   C                   ENDIF
      *
     C****************** READ      SDPLACD0                               80    JMI108
     C                   READ      XXPLACD0                               80    JMI108
     C                   ENDDO
      *
     C****************** CLOSE     SDPLACPP                                     JMI108
     C                   CLOSE     XXPLACPP                                     JMI108

     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * END - End Program                                            *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     END           BEGSR
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST
     C                   PARM                    REPORT            1

     C     KACCNT        KLIST
     C                   KFLD                    JCNUM
     C                   KFLD                    JCCY
     C                   KFLD                    JACOD
     C                   KFLD                    JACSQ
     C                   KFLD                    JBRCA
      *
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDRETL        PARM      SDRETL        DSSDY

     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'AORETLR0'
     C                   EVAL      DBKEY  =  @OPTN
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     BMLDAI        IFEQ      'Y'
     C                   MOVE      'N'           REPORT
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

     C                   EVAL      DBPGM  =  PSProcPgm

     C                   ENDSR

      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
