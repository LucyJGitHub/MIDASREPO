     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Submitted restore of libraries')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000071 - Submitted restore of libraries                    *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CUP042   *CREATE   Date 08Feb12               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - New method to restore libraries.                    *
      *                                                               *
      *****************************************************************
      *
     D PLibrary        S              8
     D PGlbPfx         S              2
     D PZonPfx         S              2
     D PRstPfx         S              2
     D PBF             S              1
     D PDevice         S             10
     D PSaveFileLib    S             10
     D PIASPGrp        S             10
     D PEndOpt         S              7
      *
     D RstStatus       S              1
     D ChangeJob       S             22    INZ('CHGJOB INQMSGRPY(*DFT)')
     D ReturnCode      S              7
     D FSPos           S              2  0
     D NotPos          S              2  0
     D NotRstNosLen    S              2  0
     D NotRstNos       S              6    VARYING
     D Command         S            300
     D CommandLen      S             15  5 INZ(300)
     D Layer           S              7
     D JobData         S             34
     D JobDataLen      S              4B 0 INZ(34)
     D Format          S              8    INZ('JOBI0100')
     D JobName         S             26    INZ('*')
     D IntJobID        S             16
     D SQLString       S            200
     D Quote           S              1    INZ('''')
     D Recursive       S              1    INZ(*blank)
      *
     D                 DS
     D NotRstNosA              1      6
     D NotRstNosN              1      6  0
      *
     D                 DS
     D RSTLIBCmd               1    154
     D                         1     14    INZ('RSTLIB SAVLIB(')
     D  FromLib               15     24
     D                        25     30    INZ(') DEV(')
     D  Device                31     40
     D                        41     49    INZ(') RSTLIB(')
     D  ToLib                 50     59
     D                        60     60    INZ(')')
     D  EndOptKWord1          61     68    INZ(' ENDOPT(')
     D  EndOpt                69     78
     D  EndOptKWord2          79     79    INZ(')')
     D                        80     94    INZ(' OUTPUT(*PRINT)')
     D  SaveFile              95    124
     D  RstASPDev            125    154
      *
      /COPY GPCPYSRCG,PSDS
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLibrary
     C                   PARM                    PGlbPfx
     C                   PARM                    PZonPfx
     C                   PARM                    PRstPfx
     C                   PARM                    PBF
     C                   PARM                    PDevice
     C                   PARM                    PSaveFileLib
     C                   PARM                    PIASPGrp
     C                   PARM                    PEndOpt
      *
      * Change the job to default replies to inquiry messages.
     C                   EVAL      Command = ChangeJob
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      *
      ** Populate the RSTLIB command; if the zone prefix is blank then this is
      **  a global library.
     C                   IF        PZonPfx = *blanks
     C                   EVAL      Layer = '*GLOBAL'
     C                   EVAL      FromLib = PRstPfx + PLibrary
     C                   EVAL      ToLib = PGlbPfx + PLibrary
     C                   ELSE
      ** For BF schemas the zone uses zzgg prefix.
     C                   EVAL      Layer = '*ZONE'
     C                   IF        PBF = 'Y'
     C                   EVAL      FromLib = PRstPfx + PRstPfx + PLibrary
     C                   EVAL      ToLib = PZonPfx + PGlbPfx + PLibrary
     C                   ELSE
     C                   EVAL      FromLib = PRstPfx + PLibrary
     C                   EVAL      ToLib = PZonPfx + PLibrary
     C                   ENDIF
     C                   ENDIF
      *
      ** Get current job information and set status to 'A' (Active).
     C                   EXSR      RtvJobA
     C                   EVAL      RstStatus = 'A'
     C                   EXSR      UpdStatus
      *
      * If the device is a save file then add additional parameter to RSTLIB
      * and blank out ENDOPT parameter.
     C                   EVAL      Device = PDevice
     C                   IF        PDevice = '*SAVF'
     C                   EVAL      EndOptKWord1 = *blank
     C                   EVAL      EndOptKWord2 = *blank
     C                   EVAL      SaveFile = ' SAVF(' +
     C                             %TRIMR(PSaveFileLib) + '/' +
     C                             %TRIMR(FromLib) + ')'
     C                   ELSE
     C                   EVAL      EndOpt = PEndOpt
     C                   ENDIF
      * If IASP is being used then add this to the RSTLIB command.
     C                   EXSR      IASP
      *
     C                   EVAL      Command = RSTLIBCmd
     C                   CALL(e)   'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   IF        PSExcpNo <> *blanks
     C                   IF        PSExcpNo = '3773'
     C                   EXSR      ChkRstNos
     C                   IF        NotRstNosN > 1
     C                   EVAL      RstStatus = 'F'
     C                   ELSE
     C                   EVAL      RstStatus = 'C'
     C                   ENDIF
     C                   ELSE
     C                   IF        PSExcpNo <> '3836'
     C                             and PSExcpNo <> '3848'
     C                   EVAL      RstStatus = 'F'
     C                   ELSE
     C                   EVAL      RstStatus = 'C'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      RstStatus = 'C'
     C                   ENDIF
     C                   EXSR      UpdStatus
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *
     C     RtvJobA       BEGSR
      *
     C                   CALL      'QUSRJOBI'
     C                   PARM                    JobData
     C                   PARM                    JobDataLen
     C                   PARM                    Format
     C                   PARM                    JobName
     C                   PARM                    IntJobID
      *
      ** Update extension table with job information.
     C                   EVAL      SQLString = 'update SMIMPXTD set DFSTS = +
     C                             substr(DFSTS, 1, 1) concat ' +
     C                             Quote + %SUBST(JobData:9:26) + Quote +
     C                             ' where DFSMNU = ' +
     C                             Quote + 'RestoreLibraries' + Quote +
     C                             ' and DFLAYR = ' + Quote + Layer + Quote +
     C                             ' and DFNAME = ' + Quote + PLibrary + Quote
      *
     C/exec SQL
     C+ execute immediate :SQLString
     C/end-exec
      *
     C     RtvJobAE      ENDSR
      *
      /EJECT
      *****************************************************************
      *
     C     UpdStatus     BEGSR
      *
     C                   EVAL      SQLString = *blanks
     C                   EVAL      SQLString = 'update SMIMPXTD set DFSTS = ' +
     C                             Quote + RstStatus + Quote +
     C                             ' concat substr(DFSTS,2,39) where  +
     C                             DFSMNU = ' +
     C                             Quote + 'RestoreLibraries' + Quote +
     C                             ' and DFLAYR = ' + Quote + Layer + Quote +
     C                             ' and DFNAME = ' + Quote + PLibrary + Quote
      *
     C/exec SQL
     C+ execute immediate :SQLString
     C/end-exec
      *
     C     UpdStatusE    ENDSR
      *
      /EJECT
      *****************************************************************
      *
     C     ChkRstNos     BEGSR
      *
      * Scan the exception message to find if any did not restore;
      *  first find the full stop ...
     C                   EVAL      FSPos = %SCAN('.':PSExcpData:1)
      * ... and then find the 'not'.
     C                   EVAL      NotPos = %SCAN('not':PSExcpData:FSPos)
     C                   EVAL      NotRstNosLen = NotPos - FSPos - 2
     C                   EVAL      FSPos = FSPos + 1
     C                   EVAL      NotRstNos = %SUBST(PSExcpData:FSPos:
     C                             NotRstNosLen)
     C                   EVAL      NotRstNos = %TRIML(NotRstNos)
     C                   EVAL      NotRstNosLen = %LEN(NotRstNos)
      * Re-use NotPos to upate number of objects not restored.
     C                   EVAL      NotPos = 6 - NotRstNosLen + 1
     C                   EVAL      %SUBST(NotRstNosA:NotPos:NotRstNosLen) =
     C                             %SUBST(NotRstNos:1:NotRstNosLen)
      *
     C     ChkRstNosE    ENDSR
      *
      *****************************************************************
      *
     C     IASP          BEGSR
      *
     C                   IF        PIASPGrp <> *blank
     C                   EVAL      RstASPDev = ' RSTASPDEV(' + PIASPGrp + ')'
     C                   ENDIF
      *
     C     IASPE         ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
