     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('G-AML FTP Check Program')                              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***SCJ00004*-*G-AML*FTP*Check*Program****************************
      *  XX109013 - G-AML FTP Check Program                           *
      *                                                               *
      *  Function:  This program will check if FTP succeeded          *
      *                                                               *
      ***Called*By:*SCCJ003*-*G-AML*FTP*Processing*********************
      *  Called By: XX109010 - G-AML FTP Processing                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. JMI109             Date 23May18               *
      *  Prev Amend No. JMI026  *CREATE    Date 30Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI109 - G-AML PreProcessor (Upgrade to FB Midas)            *
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
     F*SCFTPOPP  IF   E             DISK    INFSR(*PSSR)                                      JMI109
     FXXFTPOPD  IF   E             DISK    INFSR(*PSSR)                                       JMI109

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

     D                 DS
      ** Data Structure for Constants.
     D  WSYNTX                 1     11    INZ('Subcommand')
     D  WLINK                 30     70    INZ('Cannot connect to host')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D                 DS
      ** Data Structure for FTP Output.
     D  F7LN80                 1     80
     D  WLN03                  1      3
     D  WLN01                  1      1
     D  WLN04                  4      7
     D  WLN07                  1      7
     D  WLN10                  1     10
     D  WLN22                  1     22
     D  WLN08                  1      8

     D  ARRTCD         S              3A   DIM(6) CTDATA

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
      ** Check link to remote system.
     C                   EXSR      ZRLINK
      *
      ** Check for invalid command and syntax error for the subcommands
      ** used in transferring of file.
     C                   EXSR      ZSYNTX
      *
      ** If the subcommands are all valid (no invalid command & syntax
      ** error), then check if the user has successfully logged-on to
      ** the remote system and if each subcommand was executed
      ** successfully.
     C                   EXSR      ZCOMND

     C                   SETON                                        LR
     C                   RETURN

     *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE : ZRLINK - Check link to remote system            *
      *                                                               *
      *  CALLED BY  : MAIN   - Main Controlling Routine               *
      *                                                               *
      *  CALLS      : *PSSR  - Error Handling Subroutine              *
      *                                                               *
      *****************************************************************
      *
     C     ZRLINK        BEGSR

      ** Position pointer to first record on file.
      *
     C*****1             SETLL     SDFTPID0                                                   JMI109
     C*****              READ      SDFTPID0                               88                  JMI109
     C     1             SETLL     XXFTPID0                                                   JMI109
     C                   READ      XXFTPID0                               88                  JMI109
      *
      ** Check if link is down...
      *
     C     *IN88         DOWEQ     '0'
      *
     C                   MOVEL     GFTPO         F7LN80
      *
      ** If the first 22 characters of FTP output is 'Cannot connect
      ** host, the link is down. Hence set return code to 'FAILED',
      ** seton LR and terminate.
      *
     C     WLN22         IFEQ      WLINK
     C                   MOVEL     'FAILED'      Return_Code
     C                   SETON                                            LR
     C                   RETURN
     C                   ENDIF
      *
      ** Read next record.
      *
     C*****              READ      SDFTPID0                               88                  JMI109
     C                   READ      XXFTPID0                               88                  JMI109
      *
     C                   ENDDO
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE : ZSYNTX - Check for invalid subcommand and       *
      *                        incorrect syntax                       *
      *                                                               *
      *  CALLED BY  : MAIN   - Main Controlling Routine               *
      *                                                               *
      *  CALLS      : *PSSR  - Error Handling Subroutine              *
      *                                                               *
      *****************************************************************
      *
     C     ZSYNTX        BEGSR
      *
      ** Position pointer to first record on file.
      *
     C*****1             SETLL     SDFTPID0                                                   JMI109
     C*****              READ      SDFTPID0                               88                  JMI109
     C     1             SETLL     XXFTPID0                                                   JMI109
     C                   READ      XXFTPID0                               88                  JMI109
      *
     C                   MOVEL     GFTPO         F7LN80
      *
      ** Check for invalid command and syntax error for the subcommands
      ** used in transferring of file.
      *
     C     *IN88         DOWEQ     '0'
      *
      ** If the first 10 characters of FTP output is 'Subcommand',
      ** there is a syntax error in the subcommand, so return 'COMMAND'
      ** as return code
      *
     C     WLN10         IFEQ      WSYNTX
     C                   MOVEL     'COMMAND'     Return_Code
     C                   SETON                                            LR
     C                   RETURN
     C                   ENDIF
      *
      ** Read the next record on file.
      *
     C*****              READ      SDFTPID0                               88                  JMI109
     C                   READ      XXFTPID0                               88                  JMI109
      *
     C                   MOVEL     GFTPO         F7LN80
     C                   ENDDO
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE : ZCOMND - Check for user logged-on and return    *
      *                        codes sent after executing subcommands *
      *                                                               *
      *  CALLED BY  : MAIN   - Main Controlling Routine               *
      *                                                               *
      *  CALLS      : ZRCODE - Check Subcommands' Return codes        *
      *               *PSSR  - Error Handling Subroutine              *
      *                                                               *
      *****************************************************************
      *
     C     ZCOMND        BEGSR
      *
      ** Retrieve Operating System version and level, as V3R1M0 and
      ** above protocol (TCP/IP) uses different format for returning
      ** FTP commands in output file.
      *
     C                   CALL      'UTC0280'
     C                   PARM                    IBMLVL            6
     C                   PARM                    RPYTYP            5
      *
     C     1             SUBST     IBMLVL:2      IBMVRS            1
      *
     C     IBMVRS        IFEQ      '1'
     C     IBMVRS        OREQ      '2'
     C     IBMLVL        OREQ      'V3R0M5'
     C                   MOVE      'N'           TCPIP             1
     C                   ELSE
     C                   MOVE      'Y'           TCPIP
     C                   END
      *
      ** Position pointer to first record on file.
      *
     C*****1             SETLL     SDFTPID0                                                   JMI109
     C*****              READ      SDFTPID0                               88                  JMI109
     C     1             SETLL     XXFTPID0                                                   JMI109
     C                   READ      XXFTPID0                               88                  JMI109
      *
     C                   MOVEL     GFTPO         F7LN80

      ** Check if user has successfully logged-on to the remote system.
      *
     C     *IN88         DOWEQ     '0'
     C     TCPIP         ANDEQ     'Y'
     C     WLN03         ANDNE     '331'
     C     *IN88         OREQ      '0'
     C     TCPIP         ANDEQ     'N'
     C     WLN07         ANDNE     '>>>PASS'
     C*****              READ      SDFTPID0                               88                  JMI109
     C                   READ      XXFTPID0                               88                  JMI109
      *
     C                   MOVEL     GFTPO         F7LN80
     C                   ENDDO
      *
      ** If end of file was reached (there is no return code for the
      ** subcommand, there was a COMMAND error
      *
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'COMMAND'     Return_Code
     C                   SETON                                            LR
     C                   RETURN
      *
     C                   ELSE
      *
      ** Read the next record to get the return code. If the first 3
      ** characters of the return code is not '230', log-on failed, because
      ** the user is not authorised to log-on to the system or the
      ** password used by the user is not valid. Hence, set return code
      ** to 'LOGIN' and terminate.
      *
     C*****              READ      SDFTPID0                               88                  JMI109
     C                   READ      XXFTPID0                               88                  JMI109
      *
     C                   MOVEL     GFTPO         F7LN80
      *
     C     WLN03         IFNE      '230'
     C                   MOVEL     'LOGIN'       Return_Code
     C                   SETON                                        LR
     C                   RETURN
     C                   ELSE
      *
      ** The user has successfully logged-on to the system... Check for
      ** the return codes sent after performing each subcommand.
      *
     C                   EXSR      ZRCODE
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE : ZRCODE - Check Subcommands' Return codes        *
      *                                                               *
      *  CALLED BY  : ZCOMND - Check for user logged-on and return    *
      *                        codes sent after executing subcommands *
      *                                                               *
      *  CALLS      : *PSSR  - Error Handling Subroutine              *
      *                                                               *
      *****************************************************************
      *
     C     ZRCODE        BEGSR
      *
      ** Check for the return codes sent after performing each
      ** subcommand... Terminate the program after scanning all records
      ** in the FTP output or if a subcommand failed.
     C*****              READ      SDFTPID0                               88                  JMI109
     C                   READ      XXFTPID0                               88                  JMI109
      *
     C                   MOVEL     GFTPO         F7LN80
      *
     C     *IN88         DOWEQ     '0'
      *
      ** Search for Subcommands ">"
      *
     C     WLN01         IFEQ      '>'
      *
     C*****              READ      SDFTPID0                               88                  JMI109
     C                   READ      XXFTPID0                               88                  JMI109
      *
     C                   MOVEL     GFTPO         F7LN80
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'COMMAND'     Return_Code
     C                   SETON                                            LR
     C                   RETURN
     C                   ENDIF
      *
      ** A VALID RETURN CODE TO BE FOUND BEFORE NEXT SUBCOMMANDS
      *
     C                   MOVE      '0'           *IN87
     C     *IN87         DOWEQ     '0'
      *
     C     WLN08         IFEQ      'SENDPASV'
     C                   LEAVE
     C                   ENDIF
      *
     C     WLN01         IFEQ      '>'
     C                   MOVEL     'COMMAND'     Return_Code
     C                   SETON                                            LR
     C                   RETURN
     C                   ENDIF
      *
     C     WLN03         LOOKUP    ARRTCD                                 80
      *
     C     *IN80         IFEQ      '0'
     C*****              READ      SDFTPID0                               88                  JMI109
     C                   READ      XXFTPID0                               88                  JMI109
      *
     C                   MOVEL     GFTPO         F7LN80
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'COMMAND'     Return_Code
     C                   SETON                                            LR
     C                   RETURN
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '1'           *IN87
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
      *
      ** CONTINUE TO READ UNTIL END OF FILE
      *
     C*****              READ      SDFTPID0                               88                  JMI109
     C                   READ      XXFTPID0                               88                  JMI109
      *
     C                   MOVEL     GFTPO         F7LN80
     C                   ENDDO
      *
      ** Operation is successful, set Return Code to 'READY.
      *
     C                   MOVEL     *BLANKS       Return_Code
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
     C                   PARM                    Return_Code       7

     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
     C                   MOVEL     'SCJ00004'    DBPGM
      *
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
     C                   EVAL       Return_Code = '*Error'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**CTDATA ARRTCD
200
226
221
250
500
501
