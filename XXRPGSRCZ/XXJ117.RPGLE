     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Pooling Accounts COB Send')                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      ***GLJ107*-*Midas*GL*Account Pooling Send************************         EML110
      *  XXJ117 - Midas GL Account Pooling Send                       *         EML110
      *                                                               *
      *  Function:  This program is called twice in the COB. Once as  *
      *             by the first component after DBIC save and once   *
      *             after posting records written to EODPOPD.         *
      *             This will set up the FTP details for the sending  *
      *             of account balances                               *
      *                                                               *
      ***Called*By:*GLCJ107*-*Account Pooling COB send*****************         EML110
      *  Called By: XXCJ117 - Account Pooling COB send                *         EML110
      *                                                               *
      ***(c)*Misys*International*Banking Systems Ltd. 2007*************         EML110
      *  (c) Finastra International Limited 2018                      *         EML110
      *                                                               *
      *  Last Amend No. EML110             Date 20Jan20               *
      *  Prev Amend No. TFJ011  (CHG001)   Date 23Jan07               *
      *                 TFJ011  *CREATE    Date 15Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML110 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ011 - (CHG001) Changes due to Difference of the File      *
      *           System                                              *
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

      * Account Pooling FTP command details
     F***GLPSINPP  O    E             DISK    USROPN                            EML110
     FXXPSINPP  O    E             DISK    USROPN                               EML110
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

     D*** SDPFTPDA      E DS                  EXTNAME(SDPFTPDA)                 EML110
     D XXPFTPDA      E DS                  EXTNAME(XXPFTPDA)                    EML110
      ** Data Area giving Pooling ICD FTP details

      ** Data structure for User ID on PF/GLPRINPD
     D@USRID           DS
     D USER                    1     20
     D PASW                   22     41

      ** Data Structure for PUT write to PF/GLPSINPD
     D@PUT             DS
     D PUT                     1      3
     D @1                      4      4
     D LIBNM                   5     14
     D @2                     15     15
     D FILNM                  16     25
     D @3                     26     26
     D PATH                   27     57

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
     D*** SDPICD        E DS                  EXTNAME(SDPICDPP)                 EML110
     D XXPICD        E DS                  EXTNAME(XXPICDPP)                    EML110
      ** EXTERNAL DS FOR POOLING ICD DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** FIRST DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

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
      * Obtain the FTP file names from the Pooling ICD
     C****************** CALL      'AOPICDR0'                                   EML110
     C                   CALL      'XXPICDR0'                                   EML110
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C**** SDPICD        PARM      SDPICD        DSSDY                          EML110
     C     XXPICD        PARM      XXPICD        DSSDY                          EML110
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C****************** MOVEL     'SDPICDPP'    DBFILE                         EML110
     C                   MOVEL     'XXPICDPP'    DBFILE                         EML110
     C                   MOVEL     @OPTN         DBKEY                      ************
     C                   Z-ADD     001           DBASE                      * DBERR 001*
     C                   OUT       LDA                                      ************
     C                   EXSR      *PSSR
     C                   ENDIF

     C******LOCK         IN        SDPFTPDA
     C*****              OUT       SDPFTPDA
     C     *LOCK         IN        XXPFTPDA                                     EML110
     C                   OUT       XXPFTPDA                                     EML110

      * Set up FTP details
     C                   EXSR      Set_FTP
      *
      * Set up A/C balance details on output file
      * If component sequence number is 00001, pass in time as
      * '8888', if 00002 pass in as '9999'.
     C     Com_Seq       IFEQ      '00001'
     C                   MOVE      8888          File_Time
     C                   ELSE
     C                   MOVE      9999          File_Time
     C                   ENDIF
      *
     C****************** CALL      'GLJ105'                                     EML110
     C                   CALL      'XXJ115'                                     EML110
     C                   PARM      *Blanks       Return_Code       7
     C                   PARM                    File_Time         4 0
      *
     C     Return_Code   IFNE      *BLANKS
     C                   MOVEL     'DBASE'       ReturnCode
     C                   ENDIF
      *
     C                   MOVEL     File_Name     FTP_File_Name
      *
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Set_FTP - Set up FTP details to send file                     *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Set_FTP       BEGSR
      *
     C****************** OPEN      GLPSINPP                                     EML110
     C                   OPEN      XXPSINPP                                     EML110

      ** Write user id for Transfer Request to PF/GLPSINPP
     C                   MOVEL     JUSER         USER
     C                   MOVEL     *BLANKS       @1
     C                   MOVEL     JPWORD        PASW
      *
     C                   CLEAR                   JSIDTA
     C                   MOVEL     @USRID        JSIDTA
     C****************** WRITE     GLPSIND0                                     EML110
     C                   WRITE     XXPSIND0                                     EML110
                                                                                              CHG001
      ** Write 'cd ..' transfer request to PF/GLPSINPP                                        CHG001
     C                   CLEAR                   JSIDTA                                       CHG001
     C                   MOVEL     'cd ..'       JSIDTA                                       CHG001
     C****************** WRITE     GLPSIND0                              CHG001 EML110
     C                   WRITE     XXPSIND0                                     EML110
      *
      ** Set up fields for transfer request to be written.
     C                   MOVEL     'PUT'         PUT
     C                   MOVEL     *BLANKS       @1
      *
     C                   MOVE      *BLANKS       PATH
      *
     C                   MOVEL     *BLANKS       @3
     C                   MOVEL     '/'           @2
      *
      * Set up file name
      * If component sequence number is 00001, file is final intra
      * day balance file, if 00002, file is COB balance file
     C     Com_Seq       IFEQ      '00001'
     C                   MOVEL     JOTFAB        File_Name        10
     C                   ELSE
     C                   MOVEL     JOTCAB        File_Name
     C                   ENDIF
      *
     C                   MOVEL     File_Name     FILNM
     C                   MOVEA     JDIR          PATHA
      *
     C                   Z-ADD     1             X                 2 0
     C     PATHA(X)      DOWNE     ' '
     C                   ADD       1             X
     C                   ENDDO
      *
     C**********         MOVE      '/'           PATHA(X)                                     CHG001
     C**********         ADD       1             X                                            CHG001
     C                   MOVEA     File_Name     PATHA(X)
      *
     C                   MOVEA     PATHA         PATH
      *
      ** Library name parameter
     C                   MOVE      @LIB          LIBNM
      *
      ** Output to file.
      *
     C                   CLEAR                   JSIDTA
     C                   MOVEL     @PUT          JSIDTA
     C****************** WRITE     GLPSIND0                                     EML110
     C                   WRITE     XXPSIND0                                     EML110

      ** Write quit for transfer request to PF/GLPSINPP
     C                   CLEAR                   JSIDTA
     C                   MOVEL     'QUIT'        JSIDTA
     C****************** WRITE     GLPSIND0                                     EML110
     C                   WRITE     XXPSIND0                                     EML110
      *
     C****************** CLOSE     GLPSINPP                                     EML110
     C                   CLOSE     XXPSINPP                                     EML110

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
     C                   PARM                    Com_Seq           5
     C                   PARM                    @LIB              7
     C                   PARM                    FTP_File_Name    10

     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
     C******DTAARA       DEFINE                  SDPFTPDA                       EML110
     C     *DTAARA       DEFINE                  XXPFTPDA                       EML110

     C****************** MOVEL     'GLJ107'      DBPGM                          EML110
     C                   MOVEL     'XXJ117'      DBPGM                          EML110

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
