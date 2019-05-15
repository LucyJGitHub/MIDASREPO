     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA AML FTP import table uploader')
      *****************************************************************
      *                                                               *
      *  Midas - Common Programs                                      *
      *                                                               *
      *  ZAAMLFTPTU - AML FTP Import Table Uploader                   *
      *                                                               *
      *  Function:  This module uploads the AML Import Tables to      *
      *             the Compliance Alert Server via FTP.              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD017  *CREATE    Date 08Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *
      ** AML FTP Command Script
      *
     FSDFTPSPD  O    E             DISK    INFSR(*PSSR) USROPN
      *
      ** AML FTP Log
      *
     FSDFTPLPD  IF   E             DISK    INFSR(*PSSR) USROPN
      *
      ** AML FTP Trigger
      *
     FSDFTPTPD  O    E             DISK    INFSR(*PSSR) USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition.
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      *
      ** Useful Constants
      *
     D SPACE           C                   CONST(' ')
     D QUOTE           C                   CONST('''')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      *
      ** AML Import Table Array
      *
     D AMLIT           S             18A   DIM(6)
      *
      ** AML FTP Physical File Array
      *
     D FTPPF           S              8A   DIM(3)
      *
      ** OS/400 FTP Command Array
      *
     D FTPCMD          S             65A   DIM(4) CTDATA
      *
      ** Compliance Watch Configuration Data DS
      *
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
      *
      ** Switchable Feature Details DS
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Short Access Object DS
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Long Access Object DS
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** SDSTAT Data Area
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
     D                                     DTAARA(SDSTAT)
      *
      ** 24X7 Status Data Area
      *
     D SC24X7        E DS                  EXTNAME(SC24X7)
     D                                     DTAARA(SC24X7)
      *
      ** RUNDAT Data Area
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
     D                                     DTAARA(RUNDAT)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *
      ** Program Parameter
      *
     D PRetCde         S             10A
      *
      ** Switchable Feature Indicator
      *
     D CSC011          S              1A   INZ('N')
      *
      ** Working Variables
      *
     D WSrcLib         S              7A
     D WTargDir        S                   LIKE(W1STDI)
     D WRmtSys         S                   LIKE(W1CASR)
     D WCmd            S                   LIKE(FTPCMD)
     D WCtr            S              2P 0
     D WLen            S              2P 0
 
      ** +--------------------------------------+
      ** ¦ Prototype Declarations               ¦
      ** ¦ ======================               ¦
      ** +--------------------------------------+
 
      *
      ** RPG-OS/400 Command Relay
      *
     D QCMDEXC         PR                  EXTPGM('QCMDEXC')
     D  PCmd                         65A   CONST OPTIONS(*VARSIZE)
     D  PLen                         15P 5 CONST
      *
      ** QCMDEXC Wrapper
      *
     D SPExecCmd       PR
     D  PCmd                         65A   VALUE
      *
      ** FTP Message Analyser
      *
     D SPAnaMsg        PR            10A
     D  PFTPMsg                     256A   VALUE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *
      ** Begin FTP Session
      ** =================
      *
      ** Execute the initial FTP setup.
      *
     C                   EXSR      SRStpFTP
      *
     C                   EXSR      SRClrFTPPFs
      *
      ** Build the FTP script.
      *
     C                   EXSR      SRBldFTPScr
      *
      ** Upload the AML Import Tables.
      *
     C                   EXSR      SRStrFTP
      *
      ** Analyse the FTP Log.
      *
     C                   EXSR      SRAnaLog
      *
      ** Clear the FTP-related objects.
      *
     C                   EXSR      SRClrFTP
      *
      ** End FTP Session
      ** ===============
      *
     C                   EVAL      *INLR = True
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRStpFTP - Executes the initial FTP setup.                    *
      *                                                               *
      *****************************************************************
     C     SRStpFTP      BEGSR
      *
      ** Derive the source library by getting the system prefix.
      *
     C                   IF        CSC011 = 'Y'
     C                   EVAL      WSrcLib = S1MAIN + 'DMLIB'
     C                   ELSE
     C                   EVAL      WSrcLib = LIBR + 'DMLIB'
     C                   ENDIF
      *
      ** Set the AML Import Tables to be uploaded.
      *
     C                   EVAL      AMLIT(1) = WSrcLib + '/SDCORIPD'
     C                   EVAL      AMLIT(2) = WSrcLib + '/SDCUSIPD'
     C                   EVAL      AMLIT(3) = WSrcLib + '/SDBRAIPD'
     C                   EVAL      AMLIT(4) = WSrcLib + '/SDAHOLPD'
     C                   EVAL      AMLIT(5) = WSrcLib + '/SDACCTPD'
     C                   EVAL      AMLIT(6) = WSrcLib + '/SDAHISPD'
      *
      ** Check the AML Import Tables first before we go any further.
      *
     C                   EXSR      SRChkAMLITs
      *
      ** Set the AML FTP Physical Files.
      *
     C                   EVAL      FTPPF(1) = 'SDFTPSPD'
     C                   EVAL      FTPPF(2) = 'SDFTPLPD'
     C                   EVAL      FTPPF(3) = 'SDFTPTPD'
      *
      ** Derive the target directory.
      *
     C                   IF        W1STDI <> *BLANKS
      *
     C                   IF        %SCAN(SPACE: %TRIM(W1STDI)) = 0
      *
      ** Standard DOS short file name or Windows long file name
      ** w/o spaces.
      *
     C                   EVAL      WTargDir = %TRIM(W1STDI)
     C                   ELSE
      *
      ** Standard Windows long file name.
      *
     C                   EVAL      WTargDir = QUOTE + %TRIM(W1STDI) +
     C                             QUOTE
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Derive the Remote System.
      *
     C                   EVAL      WLen = %SCAN(':' : W1CASR)
      *
     C                   IF        WLen <> 0
     C                   EVAL      WRmtSys = %TRIM(%SUBST(W1CASR : 1 :
     C                             WLen - 1))
     C                   ELSE
     C                   EVAL      WRmtSys = %TRIM(W1CASR)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrFTPPFs - Clears the AML FTP Physical Files.              *
      *                                                               *
      *****************************************************************
     C     SRClrFTPPFs   BEGSR
      *
      ** Clear the AML FTP Physical Files.
      *
     C                   FOR       WCtr = 1 TO %ELEM(FTPPF)
      *
     C                   EVAL      WCmd = 'CLRPFM FILE' +
     C                             '(' + %TRIM(FTPPF(WCtr)) + ')'
     C                   CALLP     SPExecCmd(WCmd)
      *
     C                   ENDFOR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldFTPScr - Builds the FTP upload script.                   *
      *                                                               *
      *****************************************************************
     C     SRBldFTPScr   BEGSR
      *
      ** Set the initial login information (User Name and Password).
      *
     C                   OPEN      SDFTPSPD
      *
     C                   EVAL      W5FTPS = %TRIM(W1CAUS) + SPACE +
     C                                      %TRIM(W1CAPW)
     C                   WRITE     SDFTPSD0
      *
      ** Set the FTP session in ASCII (Text) Mode.
      *
     C                   EVAL      W5FTPS = 'ASCII'
     C                   WRITE     SDFTPSD0
      *
      ** If the target directory is not specified, files will be
      ** uploaded to the default FTP folder.
      *
     C                   IF        WTargDir <> *BLANKS
     C                   EVAL      W5FTPS = 'CD ' + %TRIM(WTargDir)
     C                   WRITE     SDFTPSD0
     C                   ENDIF
      *
      ** Add the Import Tables.
      *
     C                   FOR       WCtr = 1 TO %ELEM(AMLIT)
      *
     C                   IF        AMLIT(WCtr) <> *BLANKS
     C                   EVAL      W5FTPS = 'PUT ' + %TRIM(AMLIT(WCtr))
     C                   WRITE     SDFTPSD0
     C                   ENDIF
      *
     C                   ENDFOR
      *
      ** Add the AML FTP Trigger.
      *
     C                   EVAL      W5FTPS = 'PUT ' + WSrcLib + '/SDFTPTPD'
     C                   WRITE     SDFTPSD0
      *
      ** Signal for disconnection after the transfer is completed.
      *
     C                   EVAL      W5FTPS = 'QUIT'
     C                   WRITE     SDFTPSD0
      *
     C                   CLOSE     SDFTPSPD
      *
      ** Write the Midas Run Date to the AML FTP Trigger.
      *
     C                   OPEN      SDFTPTPD
      *
     C                   EVAL      W5FTPT = AGMRDT
     C                   WRITE     SDFTPTD0
      *
     C                   CLOSE     SDFTPTPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRStrFTP - Starts the AML FTP session.                        *
      *                                                               *
      *****************************************************************
     C     SRStrFTP      BEGSR
      *
      ** Set the Remote System.
      *
     C                   EVAL      WCmd = %TRIM(FTPCMD(3)) + '(' +
     C                             QUOTE + %TRIM(WRmtSys) + QUOTE + ')'
     C                   EVAL      FTPCMD(3) = WCmd
      *
      ** Execute the prewritten OS/400 script for FTP processing.
      *
     C                   FOR       WCtr = 1 TO %ELEM(FTPCMD)
      *
     C                   EVAL      WCmd = FTPCMD(WCtr)
     C                   CALLP     SPExecCmd(WCmd)
      *
     C                   ENDFOR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAnaLog - Analyses the FTP Log for possible errors.          *
      *                                                               *
      *****************************************************************
     C     SRAnaLog      BEGSR
      *
     C                   OPEN      SDFTPLPD
      *
     C                   READ      SDFTPLD0
      *
     C                   DOW       NOT %EOF(SDFTPLPD)
      *
      ** Analyse the log one message at a time.
      *
     C                   EVAL      PRetCde = SPAnaMsg(W5FTPL)
      *
      ** Return to the calling program if the FTP script failed.
      *
     C                   IF        PRetCde <> *BLANKS
     C                   EVAL      *INLR = True
     C                   RETURN
     C                   ENDIF
      *
     C                   READ      SDFTPLD0
      *
     C                   ENDDO
      *
     C                   CLOSE     SDFTPLPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrAMITs - Clears the AML Import Tables.                    *
      *                                                               *
      *****************************************************************
     C     SRClrAMLITs   BEGSR
      *
      ** Clear the AML Import Tables.
      *
     C                   FOR       WCtr = 1 TO %ELEM(AMLIT)
      *
     C                   EVAL      WCmd = 'CLRPFM FILE' +
     C                             '(' + %TRIM(AMLIT(WCtr)) + ')'
     C                   CALLP     SPExecCmd(WCmd)
      *
     C                   ENDFOR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrFTP - Clears the FTP-related objects.                    *
      *                                                               *
      *****************************************************************
     C     SRClrFTP      BEGSR
      *
      ** Clear all relevant physical files.
      *
     C                   EXSR      SRClrFTPPFs
      *
     C                   EXSR      SRClrAMLITs
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkAMLITs - Checks if all AML Import Tables exist in the    *
      *               derived source library.                         *
      *                                                               *
      *****************************************************************
     C     SRChkAMLITs   BEGSR
      *
     C                   MONITOR
      *
      ** Do all AML Import Tables exist?
      *
     C                   FOR       WCtr = 1 TO %ELEM(AMLIT)
      *
     C                   EVAL      WCmd = 'CHKOBJ OBJ' +
     C                             '(' + %TRIM(AMLIT(WCtr)) +
     C                             ')' + ' OBJTYPE(*FILE)'
     C                   CALLP     SPExecCmd(WCmd)
      *
     C                   ENDFOR
      *
      ** Return to the calling program if an error occurs.
      *
     C                   ON-ERROR  *ALL
      *
     C                   EVAL      PRetCde = '*UNKWNSRLB'
     C                   EVAL      *INLR = True
     C                   RETURN
      *
     C                   ENDMON
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Subroutine                    *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameter List
      ** ==============
      *
     C     *ENTRY        PLIST
      *
      ** Output Parameter:
      *
      ** Return Code
      *
     C                   PARM                    PRetCde
      *
      ** End of Parameter List
      ** =====================
      *
      ** Access the SDSTAT and RUNDAT Data Areas.
      *
     C                   IN        SDSTAT
     C                   IN        RUNDAT
      *
      ** Access the Compliance Watch Configuration Data.
      *
     C                   CALL      'AOCWCDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDCWCD        PARM      SDCWCD        DSSDY
      *
     C                   IF        @RtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCWCDPD'
     C                   EVAL      DBKey = @Optn
     C                   EVAL      DBase = 901
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details to see if CSC011 is enabled.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   ELSE
      *
     C                   IF        @RtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = @SARD
     C                   EVAL      DBase = 902
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Error-Handling Routines              ¦
      ** ¦ =======================              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the *PSSR subroutine.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Subprocedure Definitions             ¦
      ** ¦ ========================             ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SPExecCmd - Executes a given OS/400 command through QCMDEXC.  *
      *                                                               *
      *****************************************************************
     P SPExecCmd       B
     D SPExecCmd       PI
     D  PCmd                         65A   VALUE
      *
     C                   CALLP     QCMDEXC(PCmd : %SIZE(PCmd))
      *
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SPAnaMsg - Analyses FTP messages for possible errors.         *
      *                                                               *
      *****************************************************************
     P SPAnaMsg        B
     D SPAnaMsg        PI            10A
     D  PFTPMsg                     256A   VALUE
      *
      ** Useful Constants
      *
     D DIGITS          C                   CONST('1234567890')
     D BYTESMSG        C                   CONST('bytes transferred')
     D HOSTSIG         C                   CONST('Cannot find host')
     D LOGINSIG        C                   CONST('cannot log in')
      *
      ** Error Signature Array
      *
     D ERRSIG          S             20A   DIM(4)
      *
      ** FTP Severity Constants
      *
     D INCOMPLETE      C                   CONST('4')
     D BAD             C                   CONST('5')
      *
      ** FTP Message Layout
      *
     D FTPMSG          DS
     D  CodeID                 1      3A
     D  Severity               1      1A
     D  Pad                    4      4A
     D  MsgText                5    256A
      *
      ** Working Variables
      *
     D WRetCde         S             10A
     D WCtr            S              2P 0
      *
      ** Begin Log Analysis
      ** ==================
      *
      ** Do we have a connection to the Remote System?
      *
     C                   IF        %SCAN(HOSTSIG : PFTPMsg) <> 0
     C                   EVAL      WRetCde = '*UNKWNRSYS'
     C                   RETURN    WRetCde
     C                   ENDIF
      *
      ** How about a valid user account?
      *
     C                   IF        %SCAN(LOGINSIG : PFTPMsg) <> 0
     C                   EVAL      WRetCde = '*LOGINFAIL'
     C                   RETURN    WRetCde
     C                   ENDIF
      *
      ** Slice the FTP message.
      *
     C                   EVAL      FTPMSG = PFTPMsg
      *
      ** Is this a valid reply code?
      *
     C                   IF        %CHECK(DIGITS : CodeID) = 0 AND
     C                             %SCAN(BYTESMSG : MsgText) = 0 AND
     C                             Pad = *BLANK
      *
      ** Check the message severity.
      *
     C                   IF        Severity = INCOMPLETE OR
     C                             Severity = BAD
     C                   EVAL      WRetCde = '*ERROR'
     C                   RETURN    WRetCde
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Set the Error Signatures.
      *
     C                   EVAL      ERRSIG(1) = 'not found'
     C                   EVAL      ERRSIG(2) = 'Error'
     C                   EVAL      ERRSIG(3) = 'You must first issue'
     C                   EVAL      ERRSIG(4) = 'not valid'
      *
      ** Try to find Error Signatures.
      *
     C                   IF        WRetCde = *BLANKS
      *
     C                   FOR       WCtr = 1 TO %ELEM(ERRSIG)
      *
     C                   IF        %SCAN(%TRIM(ERRSIG(WCtr)) :
     C                             PFTPMsg) <> 0
     C                   EVAL      WRetCde = '*ERROR'
     C                   RETURN    WRetCde
     C                   ENDIF
      *
     C                   ENDFOR
      *
     C                   ENDIF
      *
      ** End Log Analysis
      ** ================
      *
     C                   RETURN    WRetCde
      *
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
 
** CPY@
(c) Finastra International Limited 2002
** CTDATA FTPCMD - OS/400 commands for FTP processing.
OVRDBF FILE(INPUT) TOFILE(SDFTPSPD) MBR(SDFTPSPD) OVRSCOPE(*JOB)
OVRDBF FILE(OUTPUT) TOFILE(SDFTPLPD) MBR(SDFTPLPD) OVRSCOPE(*JOB)
FTP RMTSYS
DLTOVR FILE(INPUT OUTPUT) LVL(*JOB)
