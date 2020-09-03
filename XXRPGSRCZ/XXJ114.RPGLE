     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Pooling Accounts FTP')                        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GLJ104*-*Midas*GL*Account Pooling FTP*************************         EML110
      *  XXJ114 - Midas GL Account Pooling FTP                        *         EML110
      *                                                               *
      *  Function:  This program will either send or receive a file   *
      *             to or from the server.                            *
      *                                                               *
      ***Called*By:*GLCJ104*-*Account*Pooling*FTP**********************         EML110
      *  Called By: XXCJ114 - Account Pooling FTP                     *         EML110
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************         EML110
      *  (c) Finastra International Limited 2018                      *         EML110
      *                                                               *
      *  Last Amend No. EML110             Date 20Jan20               *
      *  Prev Amend No. TFJ011  *CREATE    Date 23Jan07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML110 - Account Balance Pooling. Upgrade to FBM 2.1         *
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
      ** TCP/IP FTP Output Files (Receive, Send and Manual)
     F***GLPROTPP  IF   E             DISK    INFSR(*PSSR)                      EML110
     F***GLPSOTPP  IF   E             DISK    INFSR(*PSSR)                      EML110
     F***GLPMOTPP  IF   E             DISK    INFSR(*PSSR)                      EML110
     FXXPROTPP  IF   E             DISK    INFSR(*PSSR)                         EML110
     FXXPSOTPP  IF   E             DISK    INFSR(*PSSR)                         EML110
     FXXPMOTPP  IF   E             DISK    INFSR(*PSSR)                         EML110

      ** FTP Return Codes File - contain succesful Return Codes -
     FGLRCODL0  IF   E           K DISK    INFSR(*PSSR)

      ** Pooling Status File
     F***SDPSTSV1  UF A E           K DISK    USROPN                            EML110
     FXXPSTSV1  UF A E           K DISK    USROPN                               EML110

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
     D  WSYNTX                 1     11    INZ('Use command')
     D  WINVLD                12     29    INZ('Command not valid.')
     D  WLINK                 30     70    INZ('Not able to connect -
     D                                     to remote host -
     D                                     system')

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
     D  WLN11                  1     11
     D  WLN41                  1     41

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
     C***501             SETLL     GLPROTD0                                     EML110
     C***50              READ      GLPROTD0                               88    EML110
     C***511             SETLL     GLPSOTD0                                     EML110
     C***51              READ      GLPSOTD0                               88    EML110
     C***521             SETLL     GLPMOTD0                                     EML110
     C***52              READ      GLPMOTD0                               88    EML110
      *
     C   501             SETLL     XXPROTD0                                     EML110
     C   50              READ      XXPROTD0                               88    EML110
     C   511             SETLL     XXPSOTD0                                     EML110
     C   51              READ      XXPSOTD0                               88    EML110
     C   521             SETLL     XXPMOTD0                                     EML110
     C   52              READ      XXPMOTD0                               88    EML110
      ** Check if link is down...
      *
     C     *IN88         DOWEQ     '0'
      *
     C   50              MOVEL     JRODTA        F7LN80
     C   51              MOVEL     JSODTA        F7LN80
     C   52              MOVEL     JMODTA        F7LN80
      *
      ** If the first 41 characters of FTP output is 'Not able to
      ** connect to remote host system', the link is down. Hence set
      ** retun code to 'FAILED', seton LR and terminate.
      *
     C     WLN41         IFEQ      WLINK
     C                   MOVEL     'FAILED'      Return_Code
     C                   EXSR      Write_Status
     C                   SETON                                            LR
     C                   RETURN
     C                   ENDIF
      *
      ** Read next record.
      *
     C***50              READ      GLPROTD0                               88    EML110
     C***51              READ      GLPSOTD0                               88    EML110
     C***52              READ      GLPMOTD0                               88    EML110
     C   50              READ      XXPROTD0                               88    EML110
     C   51              READ      XXPSOTD0                               88    EML110
     C   52              READ      XXPMOTD0                               88    EML110
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
     C***501             SETLL     GLPROTD0                                     EML110
     C***50              READ      GLPROTD0                               88    EML110
     C***511             SETLL     GLPSOTD0                                     EML110
     C***51              READ      GLPSOTD0                               88    EML110
     C***521             SETLL     GLPMOTD0                                     EML110
     C***52              READ      GLPMOTD0                               88    EML110
     C   501             SETLL     XXPROTD0                                     EML110
     C   50              READ      XXPROTD0                               88    EML110
     C   511             SETLL     XXPSOTD0                                     EML110
     C   51              READ      XXPSOTD0                               88    EML110
     C   521             SETLL     XXPMOTD0                                     EML110
     C   52              READ      XXPMOTD0                               88    EML110
      *
     C   50              MOVEL     JRODTA        F7LN80
     C   51              MOVEL     JSODTA        F7LN80
     C   52              MOVEL     JMODTA        F7LN80
      *
      ** Check for invalid command and syntax error for the subcommands
      ** used in transferring of file.
      *
     C     *IN88         DOWEQ     '0'
      *
      ** If the first 11 characters of FTP output is 'Use command',
      ** there is a syntax error in the subcommand, so return 'COMMAND'
      ** as return code
      *
     C     WLN11         IFEQ      WSYNTX
     C                   MOVEL     'COMMAND'     Return_Code
     C                   EXSR      Write_Status
     C                   SETON                                            LR
     C                   RETURN
     C                   ENDIF
      *
      ** If the first 7 characters of FTP output is 'Command', scan the
      ** FTP output from position 9 until it encounters a blank. Merge
      ** the first 7 characters (which is 'Command') and all the chars
      ** from the point it encounters the blank. If the resulting
      ** string formed is 'Command not valid' return 'COMMAND' as return code.
     C                   MOVE      *BLANK        WSTR1            80
     C                   MOVE      *BLANK        WSTR2            80
      *
     C     WLN07         IFEQ      'Command'
      *
     C     ' '           SCAN      F7LN80:9      X1                2 0    86
     C     81            SUB       X1            X2                2 0
     C     X2            SUBST     F7LN80:X1     WSTR1                  87
     C     WLN07         CAT       WSTR1         WSTR2
      *
     C     WSTR2         IFEQ      WINVLD
     C                   MOVEL     'COMMAND'     Return_Code
     C                   EXSR      Write_Status
     C                   SETON                                            LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF

      ** Read the next record on file.
      *
     C***50              READ      GLPROTD0                               88    EML110
     C***51              READ      GLPSOTD0                               88    EML110
     C***52              READ      GLPMOTD0                               88    EML110
     C   50              READ      XXPROTD0                               88    EML110
     C   51              READ      XXPSOTD0                               88    EML110
     C   52              READ      XXPMOTD0                               88    EML110
      *
     C   50              MOVEL     JRODTA        F7LN80
     C   51              MOVEL     JSODTA        F7LN80
     C   52              MOVEL     JMODTA        F7LN80
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
     C***501             SETLL     GLPROTD0                                     EML110
     C***50              READ      GLPROTD0                               88    EML110
     C***511             SETLL     GLPSOTD0                                     EML110
     C***51              READ      GLPSOTD0                               88    EML110
     C***521             SETLL     GLPMOTD0                                     EML110
     C***52              READ      GLPMOTD0                               88    EML110
     C   501             SETLL     XXPROTD0                                     EML110
     C   50              READ      XXPROTD0                               88    EML110
     C   511             SETLL     XXPSOTD0                                     EML110
     C   51              READ      XXPSOTD0                               88    EML110
     C   521             SETLL     XXPMOTD0                                     EML110
     C   52              READ      XXPMOTD0                               88    EML110
      *
     C   50              MOVEL     JRODTA        F7LN80
     C   51              MOVEL     JSODTA        F7LN80
     C   52              MOVEL     JMODTA        F7LN80

      ** Check if user has successfully logged-on to the remote system.
      *
     C     *IN88         DOWEQ     '0'
     C     TCPIP         ANDEQ     'Y'
     C     WLN03         ANDNE     '331'
     C     *IN88         OREQ      '0'
     C     TCPIP         ANDEQ     'N'
     C     WLN07         ANDNE     '>>>PASS'
     C***50              READ      GLPROTD0                               88    EML110
     C***51              READ      GLPSOTD0                               88    EML110
     C***52              READ      GLPMOTD0                               88    EML110
     C   50              READ      XXPROTD0                               88    EML110
     C   51              READ      XXPSOTD0                               88    EML110
     C   52              READ      XXPMOTD0                               88    EML110
      *
     C   50              MOVEL     JRODTA        F7LN80
     C   51              MOVEL     JSODTA        F7LN80
     C   52              MOVEL     JMODTA        F7LN80
     C                   ENDDO
      *
      ** If end of file was reached (there is no return code for the
      ** subcommand, there was a COMMAND error
      *
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'COMMAND'     Return_Code
     C                   EXSR      Write_Status
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
     C***50              READ      GLPROTD0                               88    EML110
     C***51              READ      GLPSOTD0                               88    EML110
     C***52              READ      GLPMOTD0                               88    EML110
     C   50              READ      XXPROTD0                               88    EML110
     C   51              READ      XXPSOTD0                               88    EML110
     C   52              READ      XXPMOTD0                               88    EML110
      *
     C   50              MOVEL     JRODTA        F7LN80
     C   51              MOVEL     JSODTA        F7LN80
     C   52              MOVEL     JMODTA        F7LN80
      *
     C     WLN03         IFNE      '230'
     C                   MOVEL     'LOGIN'       Return_Code
     C                   EXSR      Write_Status
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
     C***50              READ      GLPROTD0                               88    EML110
     C***51              READ      GLPSOTD0                               88    EML110
     C***52              READ      GLPMOTD0                               88    EML110
     C   50              READ      XXPROTD0                               88    EML110
     C   51              READ      XXPSOTD0                               88    EML110
     C   52              READ      XXPMOTD0                               88    EML110
      *
     C   50              MOVEL     JRODTA        F7LN80
     C   51              MOVEL     JSODTA        F7LN80
     C   52              MOVEL     JMODTA        F7LN80
      *
     C     *IN88         DOWEQ     '0'
      *
      ** Search for Subcommands ">"
      *
     C     WLN01         IFEQ      '>'
      *
     C***50              READ      GLPROTD0                               88    EML110
     C***51              READ      GLPSOTD0                               88    EML110
     C***52              READ      GLPMOTD0                               88    EML110
     C   50              READ      XXPROTD0                               88    EML110
     C   51              READ      XXPSOTD0                               88    EML110
     C   52              READ      XXPMOTD0                               88    EML110
      *
     C   50              MOVEL     JRODTA        F7LN80
     C   51              MOVEL     JSODTA        F7LN80
     C   52              MOVEL     JMODTA        F7LN80
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'COMMAND'     Return_Code
     C                   EXSR      Write_Status
     C                   SETON                                            LR
     C                   RETURN
     C                   END
      *
      ** A VALID RETURN CODE TO BE FOUND BEFORE NEXT SUBCOMMANDS
      *
     C                   MOVE      '0'           *IN87
     C     *IN87         DOWEQ     '0'
      *
     C     WLN01         IFEQ      '>'
     C                   MOVEL     'COMMAND'     Return_Code
     C                   EXSR      Write_Status
     C                   SETON                                            LR
     C                   RETURN
     C                   END
      *
     C                   MOVEL     WLN03         @FTPC
     C     PMRCOD        CHAIN     GLRCODL0                           89
      *
     C     *IN89         IFEQ      '1'
     C***50              READ      GLPROTD0                               88    EML110
     C***51              READ      GLPSOTD0                               88    EML110
     C***52              READ      GLPMOTD0                               88    EML110
     C   50              READ      XXPROTD0                               88    EML110
     C   51              READ      XXPSOTD0                               88    EML110
     C   52              READ      XXPMOTD0                               88    EML110
      *
     C   50              MOVEL     JRODTA        F7LN80
     C   51              MOVEL     JSODTA        F7LN80
     C   52              MOVEL     JMODTA        F7LN80
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'COMMAND'     Return_Code
     C                   EXSR      Write_Status
     C                   SETON                                            LR
     C                   RETURN
     C                   END
     C                   ELSE
     C                   MOVE      '1'           *IN87
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
      *
      ** CONTINUE TO READ UNTIL END OF FILE
      *
     C***50              READ      GLPROTD0                               88    EML110
     C***51              READ      GLPSOTD0                               88    EML110
     C***52              READ      GLPMOTD0                               88    EML110
     C   50              READ      XXPROTD0                               88    EML110
     C   51              READ      XXPSOTD0                               88    EML110
     C   52              READ      XXPMOTD0                               88    EML110
      *
     C   50              MOVEL     JRODTA        F7LN80
     C   51              MOVEL     JSODTA        F7LN80
     C   52              MOVEL     JMODTA        F7LN80
     C                   ENDDO
      *
      ** Operation is successful, set Return Code to 'READY.
      *
     C                   MOVEL     *BLANKS       Return_Code
     C                   EXSR      Write_Status
      *
     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      **Write_Status*-*Write*file*transmit*status*to*SDPSTSPP**********         EML110
      * Write_Status - Write file transmit status to XXPSTSPP         *         EML110
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     Write_Status  BEGSR

     C****************** OPEN      SDPSTSV1                                     EML110
     C                   OPEN      XXPSTSV1                                     EML110

     C                   MOVE      FTP_File_Seq  @FTPS
     C**** PMPSTS        CHAIN     SDPSTSV1                           84        EML110
     C     PMPSTS        CHAIN     XXPSTSV1                           84        EML110

     C                   TIME                    STIME             6 0
     C                   MOVEL     STIME         JTIME

     C     Return_Code   IFEQ      *Blanks
     C                   MOVE      'Y'           JSUCC
     C                   MOVEL     *Blanks       JFAIL
     C                   ELSE
     C                   MOVE      'N'           JSUCC
     C                   MOVEL     Return_Code   JFAIL
     C                   ENDIF
      *
     C     *IN84         IFEQ      *ON
     C                   MOVE      FTP_File_Seq  JNUM
     C                   MOVE      @FTPW         JTYPE
     C                   MOVE      *BLANKS       JSTYP
     C****************** WRITE     SDPSTSD0                                     EML110
     C                   WRITE     XXPSTSD0                                     EML110
     C                   ELSE
     C****************** UPDATE    SDPSTSD0                                     EML110
     C                   UPDATE    XXPSTSD0                                     EML110
     C                   ENDIF

     C****************** CLOSE     SDPSTSV1                                     EML110
     C                   CLOSE     XXPSTSV1                                     EML110

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
     C                   PARM                    Type              7
     C                   PARM                    FTP_File_Seq      3

     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
     C****************** MOVEL     'GLJ104'      DBPGM                          EML110
     C                   MOVEL     'XXJ114'      DBPGM                          EML110

      ** LF/GLRCODL0 Key list
      *
     C     PMRCOD        KLIST
     C                   KFLD                    @FTPC
     C                   KFLD                    @FTPW
      *
      ** LF/SDPSTSV1 Key list
      *
     C     PMPSTS        KLIST
     C                   KFLD                    @FTPS
     C                   KFLD                    @FTPW
      *
      ** Define Fields
      *
     C     *LIKE         DEFINE    PFTPC         @FTPC
     C     *LIKE         DEFINE    PFTPW         @FTPW
     C     *LIKE         DEFINE    FTP_File_Seq  @FTPS

     C                   SETOFF                                       505152
     C                   SELECT
     C     TYPE          WHENEQ    'REC'
     C                   SETON                                        50
     C     TYPE          WHENEQ    'SEND'
     C                   SETON                                        51
     C     TYPE          WHENEQ    'MANUALS'
     C     TYPE          OREQ      'MANUALR'
     C                   SETON                                        52
     C                   ENDSL

     C     TYPE          IFEQ      'REC'
     C     TYPE          OREQ      'MANUALR'
     C                   MOVE      'R'           @FTPW
     C                   ELSE
     C                   MOVE      'S'           @FTPW
     C                   ENDIF
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
