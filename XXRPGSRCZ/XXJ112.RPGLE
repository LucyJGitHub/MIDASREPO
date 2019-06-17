     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Pooling Accounts Receive')                    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      ***GLJ102*-*Midas*GL*Account*Pooling Receive*********************         JMI108
      *  XXJ112 - Midas GL Account Pooling Receive                    *         JMI108
      *                                                               *
      *  Function:  This program determines whether it is time a file *
      *             is received from the server and if it is time the *
      *             program sets up the FTP commands required to      *
      *             retreive the file                                 *
      *                                                               *
      ***Called*By:*GLCJ102*-*Account*Pooling*Receive*Background*job***         JMI108
      *  Called By: XXCJ112 - Account Pooling Receive Background job  *         JMI108
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************         JMI108
      *  (c) Finastra International Limited 2018                      *         JMI108
      *                                                               *
      *  Last Amend No. JMI108             Date 31May18               *
      *  Prev Amend No. AR1065165          Date 18Jan13               *
      *                 TFJ011  (CHG002)   Date 23Jan07               *
      *                 TFJ011  (CHG001)   Date 08Jul05               *
      *                 TFJ011  *CREATE    Date 15Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI108 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  AR1065165 - No pooling is done due to wrong system date.     *
      *              Ensure correct format of system date is being    *
      *              used (Child: AR1065166)                          *
      *  TFJ011 - (CHG002) Changes due to Difference of the File      *
      *           System                                              *
      *  TFJ011 - (CHG001) Check that Midas Date = System Date        *
      *  TFJ011 - Account Pooling                                     *
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

      * Account Pooling Status file
     F***SDPSTSV0  IF   E           K DISK    USROPN                            JMI108
     FXXPSTSV0  IF   E           K DISK    USROPN                               JMI108

      * Account Pooling FTP command details
     F***GLPRINPP  O    E             DISK    USROPN                            JMI108
     FXXPRINPP  O    E             DISK    USROPN                               JMI108
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
      ** Data Area giving Installation Control Details

     D*** GLFTPDA       E DS                  EXTNAME(GLFTPDA)                         CHG001 JMI108
     D XXFTPDA       E DS                  EXTNAME(XXFTPDA)                                   CHG001
      ** Data Area giving FTP Process Settings                                                CHG001
                                                                                              CHG001
     D*** SDPFTPDA      E DS                  EXTNAME(SDPFTPDA)                 JMI108
     D XXPFTPDA      E DS                  EXTNAME(XXPFTPDA)                    JMI108
      ** Data Area giving Pooling ICD FTP details

      ** Data structure for User ID on PF/GLPRINPD
     D@USRID           DS
     D USER                    1     20
     D PASW                   22     41

      ** Data Structure for GET write to PF/GLPRINPD
     D@GET             DS
     D GET                     1      3
     D @1                      4      4
     D PATH                    5     35
     D @3                     36     36
     D LIBNM                  37     46
     D @4                     47     47
     D FILNM                  48     57
     D @5                     58     58
     D REPLC                  59     71

     D                 DS
     D STIME_5                 1      4  0
     D STIME_5HH               1      2  0
     D STIME_5MM               3      4  0
      *                                                                                    AR1065165
     D #DATE                           D   DATFMT(*DMY)                                    AR1065165

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D*** SDPICD        E DS                  EXTNAME(SDPICDPP)                 JMI108
     D XXPICD        E DS                  EXTNAME(XXPICDPP)                    JMI108
      ** EXTERNAL DS FOR POOLING ICD DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** FIRST DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      ** Array of FTP Incoming times
     D ITIMEA          S              4  0 DIM(20)
     D File_Name       S              1    DIM(10)
     D PATHA           S              1    DIM(31)

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
      * Obtain the FTP incoming times from the Pooling ICD
     C****************** CALL      'AOPICDR0'                                   JMI108
     C                   CALL      'XXPICDR0'                                   JMI108
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C**** SDPICD        PARM      SDPICD        DSSDY                          JMI108
     C     XXPICD        PARM      XXPICD        DSSDY                          JMI108
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C****************** MOVEL     'SDPICDPP'    DBFILE                         JMI108
     C                   MOVEL     'XXPICDPP'    DBFILE                         JMI108
     C                   MOVEL     @OPTN         DBKEY                      ************
     C                   Z-ADD     001           DBASE                      * DBERR 001*
     C                   OUT       LDA                                      ************
     C                   EXSR      *PSSR
     C                   ENDIF

     C**** *LOCK         IN        SDPFTPDA                                     JMI108
     C****               OUT       SDPFTPDA                                     JMI108
     C     *LOCK         IN        XXPFTPDA                                     JMI108
     C                   OUT       XXPFTPDA                                     JMI108

     C                   TIME                    #TIME             6 0
     C                   MOVEL     #TIME         STIME             4 0
     C                   MOVEL     #TIME         STIME_5
      *
      * Subtract 5 minutes from system time
     C     STIME_5MM     IFGE      5
     C     STIME_5MM     SUB       5             STIME_5MM
     C                   ELSE
     C     STIME_5MM     SUB       5             TEMPMM            2 0
     C     60            ADD       TEMPMM        STIME_5MM
     C     STIME_5HH     SUB       1             STIME_5HH
     C                   ENDIF
      *
      * Need to compare all times (if not 0) to see if any are less than
      * or equal to current system time
     C                   MOVE      JPITM1        ITIMEA(1)
     C                   MOVE      JPITM2        ITIMEA(2)
     C                   MOVE      JPITM3        ITIMEA(3)
     C                   MOVE      JPITM4        ITIMEA(4)
     C                   MOVE      JPITM5        ITIMEA(5)
     C                   MOVE      JPITM6        ITIMEA(6)
     C                   MOVE      JPITM7        ITIMEA(7)
     C                   MOVE      JPITM8        ITIMEA(8)
     C                   MOVE      JPITM9        ITIMEA(9)
     C                   MOVE      JPITM10       ITIMEA(10)
     C                   MOVE      JPITM11       ITIMEA(11)
     C                   MOVE      JPITM12       ITIMEA(12)
     C                   MOVE      JPITM13       ITIMEA(13)
     C                   MOVE      JPITM14       ITIMEA(14)
     C                   MOVE      JPITM15       ITIMEA(15)
     C                   MOVE      JPITM16       ITIMEA(16)
     C                   MOVE      JPITM17       ITIMEA(17)
     C                   MOVE      JPITM18       ITIMEA(18)
     C                   MOVE      JPITM19       ITIMEA(19)
     C                   MOVE      JPITM20       ITIMEA(20)
     C
      * Read through times now on array until find one that is equal
      * to system time or within 5 minutes prior to system time
     C                   Z-ADD     1             X                 3 0
     C     X             DOUEQ     21
     C     STIME         IFGE      ITIMEA(X)
     C     STIME_5       ANDLE     ITIMEA(X)
     C     ITIMEA(X)     ANDNE     0
      *
      * Access Pooling status file to see if file at this time has been
      * received.
     C                   MOVE      X             Seq               3
     C                   MOVE      'R'           FTP_Type          1
     C****               OPEN      SDPSTSV0                                     JMI108
     C**** KPSTS         CHAIN     SDPSTSV0                           80        JMI108
     C****               CLOSE     SDPSTSV0                                     JMI108
     C                   OPEN      XXPSTSV0                                     JMI108
     C     KPSTS         CHAIN     XXPSTSV0                           80        JMI108
     C                   CLOSE     XXPSTSV0                                     JMI108
      *
     C     *IN80         IFEQ      *ON
      *
      * Set up FTP details
     C                   EXSR      Set_FTP
      *
     C                   MOVE      X             FTP_File_Seq
     C                   MOVEA     File_Name     FTP_File_Name
     C                   MOVEL     '*PROC'       ReturnCode
      *
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Set_FTP - Set up FTP details to receive file                  *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Set_FTP       BEGSR
      *
     C****************** OPEN      GLPRINPP                                     JMI108
     C                   OPEN      XXPRINPP                                     JMI108
      *
      ** Write user id for Transfer Request to PF/GLPRINPP
     C                   MOVEL     JUSER         USER
     C                   MOVEL     JPWORD        PASW
      *
     C                   CLEAR                   JRIDTA
     C                   MOVEL     @USRID        JRIDTA
     C****************** WRITE     GLPRIND0                                     JMI108
     C                   WRITE     XXPRIND0                                     JMI108
      *                                                                                       CHG002
      ** Write 'cd ..' transfer request to PF/GLPRINPP                                        CHG002
      *                                                                                       CHG002
     C                   CLEAR                   JRIDTA                                       CHG002
     C                   MOVEL     'cd ..'       JRIDTA                                       CHG002
     C****************** WRITE     GLPRIND0                                            CHG002 JMI108
     C                   WRITE     XXPRIND0                                                   JMI108

      ** Set up fields for transfer request to be written.
     C                   MOVEL     'GET'         GET
     C                   MOVEL     *BLANKS       @1
      *
     C                   MOVE      *BLANKS       PATH
      *
     C                   MOVEL     '(REPLACE'    REPLC
     C                   MOVEL     *BLANKS       @3
     C                   MOVEL     '/'           @4
      *
      * Set up file name and sequence number
     C                   MOVEA     JIFILE        File_Name
      *
      * Need to add sequence number to end of file, file could
      * be any number of letters
     C                   Z-ADD     1             Y                 2 0
     C     File_Name(Y)  DOUEQ     ' '
     C     File_Name(Y)  IFNE      ' '
     C                   ADD       1             Y
     C                   ENDIF
     C                   ENDDO
      *
     C     *IN80         IFEQ      *ON
     C                   MOVE      X             X_Alpha           3
     C                   MOVEA     X_Alpha       File_Name(Y)
     C                   ELSE
     C                   ADD       1             X
     C                   MOVE      X             X_Alpha
     C                   MOVEA     X_Alpha       File_Name(Y)
     C                   ENDIF

     C                   MOVEA     JDIR          PATHA

     C                   Z-ADD     1             Y
     C     PATHA(Y)      DOWNE     ' '
     C                   ADD       1             Y
     C                   ENDDO
      *
     C**********         MOVE      '/'           PATHA(Y)                                     CHG002
     C**********         ADD       1             Y                                            CHG002
     C                   MOVEA     File_Name     PATHA(Y)
      *
     C                   MOVEA     PATHA         PATH
      *
     C                   MOVEA     File_Name     FILNM
      ** Library name parameter
     C                   MOVE      @LIB          LIBNM
      *
      ** Output to file.
      *
     C                   CLEAR                   JRIDTA
     C                   MOVEL     @GET          JRIDTA
     C****************** WRITE     GLPRIND0                                     JMI108
     C                   WRITE     XXPRIND0                                     JMI108

      ** Write quit for transfer request to PF/GLPRINPP
     C                   CLEAR                   JRIDTA
     C                   MOVEL     'QUIT'        JRIDTA
     C****************** WRITE     GLPRIND0                                     JMI108
     C                   WRITE     XXPRIND0                                     JMI108
      *
     C****************** CLOSE     GLPRINPP                                     JMI108
     C                   CLOSE     XXPRINPP                                     JMI108
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
     C                   PARM                    ReturnCode        7
     C                   PARM                    @LIB              7
     C                   PARM                    FTP_File_Seq      3
     C                   PARM                    FTP_File_Name    10

     C     KPSTS         KLIST
     C                   KFLD                    Seq
     C                   KFLD                    FTP_Type

     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
     C**** *DTAARA       DEFINE                  GLFTPDA                               CHG001 JMI108
     C****               IN        GLFTPDA                                             CHG001 JMI108
     C     *DTAARA       DEFINE                  XXFTPDA                                      JMI108
     C                   IN        XXFTPDA                                                    JMI108
      *                                                                                       CHG001
      ** Check if Midas Date is equal to System Date                                          CHG001
     C**********         TIME                    #DATE            12 0              CHG001 AR1065165
     C                   TIME                    #DATE                                     AR1065165
     C                   MOVE      #DATE         WDATE             6 0                        CHG001
                                                                                              CHG001
     C                   CALL      'ZDATE1'                                                   CHG001
     C                   PARM      *BLANKS       PRtcd             7                          CHG001
     C                   PARM      WDATE         PMMDDYY           6 0                        CHG001
     C**********         PARM      AGDFF         PDateFmt          1                CHG001 AR1065165
     C                   PARM      'D'           PDateFmt          1                       AR1065165
     C                   PARM      *ZEROS        PMidasDayNo       5 0                        CHG001
                                                                                              CHG001
     C                   IF        FTPSET = 'Y'                                               CHG001
     C                   IF        PMidasDayNo <> AGRDNB                                      CHG001
     C                   SETON                                        LR                      CHG001
     C                   RETURN                                                               CHG001
     C                   EndIf                                                                CHG001
     C                   EndIf                                                                CHG001
      *                                                                                       CHG001
     C******DTAARA       DEFINE                  SDPFTPDA                       JMI108
     C     *DTAARA       DEFINE                  XXPFTPDA                       JMI108

     C****************** MOVEL     'GLJ102'      DBPGM                          JMI108
     C                   MOVEL     'XXJ112'      DBPGM                          JMI108

     C                   ENDSR

      *****************************************************************
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
