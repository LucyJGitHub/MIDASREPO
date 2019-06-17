     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('G-AML FTP Command Generation')                         *
      *****************************************************************
      *                                                               *
      *  Midas - System Control                                       *
      *                                                               *
      ***SCJ00002*-*G-AML*FTP*Command*Generation***********************
      *  XX109011 - G-AML FTP Command Generation                      *
      *                                                               *
      *  Function:  This program determines whether it is time a file *
      *             is Sent to the server and if it is time the       *
      *             program sets up the FTP commands required to      *
      *             send the file                                     *
      *                                                               *
      ***Called*By:*SCCJ003*_*G-AML*FTP*Processing*********************
      *  Called By: XXC109010 - G-AML FTP Processing                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. JMI109             Date 23May18               *
      *  Prev Amend No. JMI026I02          Date 16Oct08               *
      *                 JMI026             Date 29Sep08               *
      *                 JMI026 *Create     Date 30Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI109 - G-AML PreProcessor (Upgrade to FB Midas)            *
      *  JMI026I02 - Increase user profile and password               *
      *  JMI026 - Add ASC command                                     *
      *  JMI026 - G-AML PreProcessor                                  *
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

     F*SDGAMLX0  IF   E           K DISK    USROPN                                            JMI109
     FXXGAMLPD  IF   E           K DISK    USROPN                                             JMI109
      *
     F*SCFTPIPP  O    E             DISK    USROPN                                            JMI109
     FXXFTPIPD  O    E             DISK    USROPN                                             JMI109
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
     D JNSTAT        E DS                  EXTNAME(JNSTAT)
     D WDATA           DS           100
     D  WRERUN                 1      1
     D  WFDATE                 2      6

      ** Data Area giving Installation Control Details
      ***Data*structure*for*User*ID*on*PF/SDGAMLX0                                            JMI109
      ** Data structure for User ID on PF/XXGAMLPD                                            JMI109
     D@USRID           DS
     D*USER*********           1     20                                                    JMI026I02
     D*PASW*********          22     41                                                    JMI026I02
     D USER                    1     30
     D PASW                   32     51

      ** Data Structure for PUT write to PF/GLPSINPD
     D@PUT             DS
     D PUT                     1      3
     D @1                      4      4
     D LIBNM                   5     14
     D @2                     15     15
     D FILNM                  16     25
     D @3                     26     26
     D PATH                   27    128

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

     D CUSTF           C                   Const('PRM_CST_20')
     D ACCTF           C                   Const('PRM_CIF_20')
     D ACTVF           C                   Const('PRM_ACT_20')
     D CONFF           C                   Const('DAILY_MIDAS_20')

     D FCUST           C                   Const('XXCSTFPD')
     D FACCT           C                   Const('XXCIFFPD')
     D FACTV           C                   Const('XXACFFPD')
     D FCONF           C                   Const('XXCNFEPD')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** FIRST DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D X               S              1  0
     D YEAR            S              2

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
      * Set up FTP details
      *
     C                   Eval      X = 1
     C                   EXSR      SR_FTP
      *
     C                   Eval      *InLR = *On
     C                   RETURN
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_FTP - Set up FTP details to send file                      *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SR_FTP        BEGSR
      *
     C*****              IF        Not %Open(SCFTPIPP)                                        JMI109
     C*****              OPEN      SCFTPIPP                                                   JMI109
     C                   IF        Not %Open(XXFTPIPD)                                        JMI109
     C                   OPEN      XXFTPIPD                                                   JMI109
     C                   ENDIF
      *
      ***Write*user*id*for*Transfer*Request*to*PF/SCFTPIPP                                    JMI109
      ** Write user id for Transfer Request to PF/XXFTPIPD                                    JMI109
      *
     C                   MOVEL     GUSER         USER
     C                   MOVEL     *BLANKS       @1
     C                   MOVEL     GPWORD        PASW
      *
     C                   CLEAR                   GFTPI
     C                   MOVEL     @USRID        GFTPI
     C*****              WRITE     SDFTPID0                                                   JMI109
     C                   WRITE     XXFTPID0                                                   JMI109
      *
     C                   CLEAR                   GFTPI
     C                   MOVEL     'SENDPASV'    GFTPI
     C*****              WRITE     SDFTPID0                                                   JMI109
     C                   WRITE     XXFTPID0                                                   JMI109
      *
     C                   CLEAR                   GFTPI
     C                   MOVEL     'TYPE I'      GFTPI
     C*****              WRITE     SDFTPID0                                                   JMI109
     C                   WRITE     XXFTPID0                                                   JMI109
      *                                                                                       JMI026
     C                   CLEAR                   GFTPI                                        JMI026
     C                   MOVEL     'ASC'         GFTPI                                        JMI026
     C*****              WRITE     SDFTPID0                                             JMI026JMI109
     C                   WRITE     XXFTPID0                                                   JMI109
      *
      ** Set up fields for transfer request to be written.
      *
     C                   MOVEL     'PUT'         PUT
     C                   MOVEL     *BLANKS       @1
      *
     C                   DoW       X <= 4
      *
     C                   MOVE      *BLANKS       PATH
     C                   MOVEL     GDIR          PATH
      *
     C                   SELECT
     C     X             WHENEQ    1
     C                   EVAL      PATH = %Trim(Path) + '/' + CUSTF +
     C                             WADATE + '.txt'
     C                   EVAL      FILNM = FCUST
      *
     C     X             WHENEQ    2
     C                   EVAL      PATH = %Trim(Path) + '/' + ACCTF +
     C                             WADATE + '.txt'
     C                   EVAL      FILNM = FACCT
      *
     C     X             WHENEQ    3
     C                   EVAL      PATH = %Trim(Path) + '/' + ACTVF +
     C                             WADATE + '.txt'
     C                   EVAL      FILNM = FACTV
      *
     C     X             WHENEQ    4
     C                   EVAL      PATH = %Trim(Path) + '/' + CONFF +
     C                             WADATE + '.ctl'
     C                   EVAL      FILNM = FCONF
      *
     C                   ENDSL
      *
     C                   MOVEL     *BLANKS       @3
     C                   MOVEL     '/'           @2
      *
      ** Library name parameter
      *
     C                   MOVE      @LIB          LIBNM
      *
      ** Output to file.
      *
     C                   CLEAR                   GFTPI
     C                   MOVEL     @PUT          GFTPI
     C*****              WRITE     SDFTPID0                                                   JMI109
     C                   WRITE     XXFTPID0                                                   JMI109
      *
     C                   Eval      X = X+1
     C                   ENDDO
      *
      ***Write*quit*for*transfer*request*to*PF/SCFTPIPP                                       JMI109
      ** Write quit for transfer request to PF/XXFTPIPD                                       JMI109
      *
     C                   CLEAR                   GFTPI
     C                   MOVEL     'QUIT'        GFTPI
     C*****              WRITE     SDFTPID0                                                   JMI109
     C                   WRITE     XXFTPID0                                                   JMI109
      *
     C*****              IF        %Open(SCFTPIPP)                                            JMI109
     C*****              CLOSE     SCFTPIPP                                                   JMI109
     C                   IF        %Open(XXFTPIPD)                                            JMI109
     C                   CLOSE     XXFTPIPD                                                   JMI109
     C                   ENDIF
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
      *
     C     *INZSR        BEGSR
      *
     C     *Entry        PLIST
     C                   PARM                    WDATA           100
     C                   PARM                    @LIB              7
     C                   PARM                    WGIPS            15
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  JNSTAT
      *
     C*****              OPEN      SDGAMLX0                                                   JMI109
     C*****              READ      SDGAMLD0                                                   JMI109
     C                   OPEN      XXGAMLPD                                                   JMI109
     C                   READ      XXGAMLD0                                                   JMI109
      *
     C                   MOVEL     GIPS          WGIPS
      *
     C                   IF        WRERUN = 'Y'
      *
     C                   IF        WFDATE = ' '
     C                   IN        JNSTAT
     C                   MOVE      PRUN          WDATE             5 0
     C                   ELSE
     C                   MOVE      WFDATE        WDATE
     C                   ENDIF
      *
     C                   ELSE
     C                   IN        RUNDAT
     C                   MOVE      AGRDNB        WDATE
     C                   ENDIF
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    WDATE
     C                   PARM      'M'           MMDDYY            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C                   MOVE      ZDATE         WADATE            6
     C                   EVAL      YEAR = %Subst(%Trim(WADATE):5:2)
     C                   EVAL      WADATE = YEAR + WADATE
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
