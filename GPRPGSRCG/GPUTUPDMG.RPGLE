     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBIA*  OVRDBF FILE(GPUTJSPDN) TOFILE(GPUTJSPD) SHARE(*NO)           *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Universal transactions update manager')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPUTUPDMG - Universal Transactions Update Manager            *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. AR920119           Date 09Mar12               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSC043             Date 18Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGP009             Date 22Dec04               *
      *                 BUG3860            Date 11Aug04               *
      *                 CLE024             Date 20Oct03               *
      *                 BUG2678            Date 25May04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR920119 - Do not start updater if Close of Business is      *
      *             running in the zone. (Child: AR920127)            *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC043 - MidasPlus IASP Enablement                           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  BUG3860 - (recompile)                                        *
      *  CLE024 - Collateralised Lending                              *
      *  BUG2678 - Inputs failing due to lock on GPZONEPD.            *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPZONEL0  IF   E           K DISK    INFSR(*PSSR)
     F*GPZONEL1**UF   E           K DISK    INFSR(*PSSR) COMMIT                              BUG2678
     FGPZONEL1  UF   E           K DISK    INFSR(*PSSR) USROPN                               BUG2678
     F                                     RENAME(GPZONED0:GPZONED1)
     FGPUTCIL0  UF A E           K DISK    INFSR(*PSSR) COMMIT
     FGPWTRAPPD O    E           K DISK    INFSR(*PSSR) COMMIT
     FGPUTJSPD  UF   E             DISK    INFSR(*PSSR) COMMIT
     FGPUTJSPDN UF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(GPUTJSD0:GPUTJSDN)
     FGPULOGPD  O  A E             DISK    INFSR(*PSSR)
     FGPDWNLL0  IF A E           K DISK    INFSR(*PSSR)                                     AR920119
 
      *****************************************************************
 
     D/COPY GPCPYSRCG,STD_D_SPEC
     D/COPY GPCPYSRCG,PSDS
 
     D #_ZOZONE        S             10    DIM(99)
     D #_ZOSHTC        S              4    DIM(99)
     D #_ZOMSYS        S              2    DIM(99)
     D #_ZOSSYS        S              2    DIM(99)
     D #_ZONJOB        S              1  0 DIM(99)
     D #_ZOJOBN        S              1  0 DIM(99)
     D #_ZOSTRJ        S              1    DIM(99)
     D #_ZOENDJ        S              1    DIM(99)
 
 
     D #_CHKOBJ        S             70    DIM(1)  CTDATA PERRCD(1)
     D #_ALCOBJ        S             70    DIM(1)  CTDATA PERRCD(1)
     D #_DLCOBJ        S             70    DIM(1)  CTDATA PERRCD(1)
     D #_SBMJOB        S             70    DIM(1)  CTDATA PERRCD(1)
     D #_DLYJOB        S             70    DIM(1)  CTDATA PERRCD(1)
     D #_TXT           S              1    DIM(70)
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPWTRAPPD)
 
 
     D JournalEnt      DS
      * Standard fields on all journal entries
     D  Filler01                      5A
     D  JrnSeqn                      10A
     D  JrnCode                       1A
     D  JrnEntType                    2A
     D  Filler02                     38A
     D  Program                      10A
     D  Object                       10A
     D  Library                      10A
     D  Member                       10A
     D  Filler03                     11A
     D  CommitId                     10A
     D  Filler04                      8A
      * Fields specific to the journal entry
     D  EntryData                  1000A
 
 
     D ControlInf      DS
     D  CTRLInfo1                     1
     D  CTRLInfo2                     1
 
 
     D                 DS
     D  MsgInfo                1     18
     D  Instruction            1      5
     D  Rcvr                   1     10
     D  MsgZone                7     16
     D  NoJobs                18     18
 
 
     D                 DS
     D  ZoneDTAQ               1     10
     D  DTAQPrefix             1      5
     D  ZOSHTC                 6      9
     D  JOBN                  10     10  0
     D  ZA                    10     10
     D  JobNameSuffix          6     10
 
     D CLE024          S              1                                                       CLE024
     D PSARD           S              6                                                       CLE024
     D PRTCD           S              7                                                       CLE024
     D POPTN           S              7                                                       CLE024
     D ZONID           S              2                                                     AR920119
     D PHASKEY         S             20    INZ('MidasPhaseOfDay')                           AR920119
     D PHAS50          S             50                                                     AR920119
     D PHAS1           S              1                                                     AR920119
 
     C     *ENTRY        PLIST
     C                   PARM                    JournalEnt
     C                   PARM                    ControlInf
 
     C                   MOVEL     EntryData     MsgInfo
 
      * If the first byte of Control Information is 0, no data has been
      *  passed so simply return
 
     C                   IF        CTRLInfo1 = '0'
     C                   RETURN
     C                   ENDIF
 
      * If the journal receiver has been changed
 
     C                   IF        JrnEntType = 'NR'
     C                   EXSR      UPD_COM_UTJS
     C                   EVAL      UTMSG = 'Manager will switch to ' + Rcvr
     C                   EXSR      WRITE_LOG
     C                   MOVEL     'Y'           #_ZOENDJ
     C                   EXSR      END_UPDATERS
     C                   EVAL      CTRLInfo1 = '9'
     C                   SETON                                        U6LR
     C                   RETURN
     C                   ENDIF
 
 
     C                   SELECT
 
      *---------------------------------------------------------------------
     C     Program       WHENEQ    'GPUTUPDMG'
      *---------------------------------------------------------------------
 
      * Ignore journal entries generated by this function
 
     C                   EXSR      UPD_NCOM_UTJS
 
      *---------------------------------------------------------------------
     C     JrnEntType    WHENEQ    'UT'
     C     Instruction   ANDEQ     'END  '
     C     MsgZone       ANDEQ     *BLANK
      *---------------------------------------------------------------------
 
      * If this is an 'END' manager entry,
      *  Write to the log file
      *  End all the zone updater jobs
      *  and tell the RCVJRNE command (and hence the controlling CL) to stop
 
     C                   EVAL      UTMSG = 'Manager END message received'
     C                   EXSR      WRITE_LOG
     C                   MOVEL     'Y'           #_ZOENDJ
     C                   EXSR      END_UPDATERS
     C                   EXSR      UPD_COM_UTJS
     C                   EVAL      UTMSG = 'Manager has ENDED'
     C                   EXSR      WRITE_LOG
     C                   EVAL      CTRLInfo1 = '9'
 
      *---------------------------------------------------------------------
     C     JrnEntType    WHENEQ    'UT'
     C     Instruction   ANDEQ     'END  '
     C     MsgZone       ANDNE     *BLANK
      *---------------------------------------------------------------------
 
      * If this is an 'END' zone entry,
      *  Write to the log file
      *  Reload the zone
      *  End the zone updater jobs
 
     C                   EVAL      UTMSG = 'Manager END message received'
     C                                     + '.Zone is ' + MsgZone
     C                   EXSR      WRITE_LOG
     C                   EXSR      RELOAD_ZONE
     C                   EXSR      END_UPDATERS
     C                   EXSR      UPD_COM_UTJS
     C                   EVAL      UTMSG = 'Manager END message processed'
     C                                     + '.Zone is ' + MsgZone
     C                   EXSR      WRITE_LOG
 
      *---------------------------------------------------------------------
     C     JrnEntType    WHENEQ    'UT'
     C     Instruction   ANDEQ     'START'
     C     MsgZone       ANDNE     *BLANK
      *---------------------------------------------------------------------
 
      * If this is a 'START' zone entry,
      *  Write to the log file
      *  Reload the zone
      *  Start the zone updater jobs
 
     C                   EVAL      UTMSG = 'Manager START message received'
     C                                     + '.Zone is ' + MsgZone
     C                   EXSR      WRITE_LOG
     C                   EXSR      RELOAD_ZONE
     C                   EXSR      STR_UPDATERS
     C                   EXSR      UPD_COM_UTJS
     C                   EVAL      UTMSG = 'Manager START message processed'
     C                                     + '.Zone is ' + MsgZone
     C                   EXSR      WRITE_LOG
 
      *---------------------------------------------------------------------
     C     JrnEntType    WHENEQ    'UT'
     C     Instruction   ANDEQ     'OPENZ'
     C     JrnEntType    OREQ      'UT'
     C     Instruction   ANDEQ     'CLOSZ'
      *---------------------------------------------------------------------
 
      * If this is a 'OPENZ' or 'CLOSZ' entry,
      *  Write to the log file
      *  Send an 'OPENZ'/'CLOSZ' message to all the updaters
 
     C                   EVAL      UTMSG = 'Manager ' + Instruction + ' message'
     C                                     + ' received' + '.Zone is ' + MsgZone
     C                   EXSR      WRITE_LOG
     C                   Z-ADD     1             ZZ
     C     MsgZone       LOOKUP    #_ZOZONE(ZZ)                           99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     #_ZOSHTC(ZZ)  ZOSHTC
     C                   EVAL      DtqDta = Instruction
     C                   EXSR      SEND_MSG_ALL
     C                   EXSR      UPD_COM_UTJS
     C                   ENDIF
     C                   EVAL      UTMSG = 'Manager ' + Instruction + ' message'
     C                                     + ' processd' + '.Zone is ' + MsgZone
     C                   EXSR      WRITE_LOG
 
      *---------------------------------------------------------------------
     C     JrnEntType    WHENEQ    'CM'
      *---------------------------------------------------------------------
 
      * If this is a commit entry, action it
 
     C                   EXSR      ACTN_COMMIT
     C     CommitUpdate  IFEQ      'Y'
     C                   EXSR      UPD_COM_UTJS
     C                   ELSE
     C                   EXSR      UPD_NCOM_UTJS
     C                   ENDIF
 
      *---------------------------------------------------------------------
     C     JrnEntType    WHENEQ    'RB'
      *---------------------------------------------------------------------
 
      * If this is a rollback entry, action it
 
     C                   EXSR      ACTN_ROLLBACK
     C     CommitUpdate  IFEQ      'Y'
     C                   EXSR      UPD_COM_UTJS
     C                   ELSE
     C                   EXSR      UPD_NCOM_UTJS
     C                   ENDIF
 
      *---------------------------------------------------------------------
     C     JrnEntType    WHENEQ    'PT'
     C     JrnEntType    OREQ      'PX'
     C     JrnEntType    OREQ      'UP'
      *---------------------------------------------------------------------
 
      * If this is an update entry and the TRAP records carries a zero
      * commit id, then action it. However ignore entries written to TRAP
      * not under commitment control.
 
     C                   MOVEL     EntryData     T_TRAP
     C     T_CCID        IFEQ      0
     C     CommitID      ANDNE     '0000000000'
     C                   EXSR      ACTN_UPDATE
     C                   EXSR      UPD_COM_UTJS
     C                   ELSE
     C                   EXSR      UPD_NCOM_UTJS
     C                   ENDIF
 
      *---------------------------------------------------------------------
 
     C                   ENDSL
 
     C                   RETURN
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Action commit
      *********************************************************************
     C     ACTN_COMMIT   BEGSR
 
     C                   MOVE      'N'           CommitUpdate      1
 
      * Update commit id record to signify universal data can be updated
 
     C                   MOVEL     CommitId      CICCID
     C     CICCID        CHAIN     GPUTCID0                           99
     C     *IN99         IFEQ      *OFF
     C                   MOVE      'Y'           CIUUNV
     C                   UPDATE    GPUTCID0
 
     C                   MOVE      'Y'           CommitUpdate
 
      * Get the zone shortcode
 
     C                   Z-ADD     1             ZZ
     C     CIZONE        LOOKUP    #_ZOZONE(ZZ)                           99
     C                   MOVEL     #_ZOSHTC(ZZ)  ZOSHTC
 
      * Set the job number
 
     C                   Z-ADD     CIJOBN        JOBN
 
      * Send a 'GO' message to a zone updater job
 
     C                   EVAL      DtqDta = 'GO'
     C                   EXSR      SEND_MSG
 
     C                   ENDIF
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Action rollback
      *********************************************************************
     C     ACTN_ROLLBACK BEGSR
 
     C                   MOVE      'N'           CommitUpdate
 
      * Delete commit id record
 
     C                   MOVEL     CommitId      CICCID
     C     CICCID        CHAIN     GPUTCID0                           99
     C     *IN99         IFEQ      *OFF
     C                   DELETE    GPUTCID0
     C                   MOVE      'Y'           CommitUpdate
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Action update
      *********************************************************************
     C     ACTN_UPDATE   BEGSR
 
      * Write TRAP record to 'work' TRAP file
 
     C                   MOVEL     CommitId      T_CCID
     C                   WRITE     GOTRAPD0
 
      * Write new commitment id record if not present
 
     C                   MOVEL     CommitId      CICCID
     C     CICCID        CHAIN     GPUTCID0                           99
 
     C     *IN99         IFEQ      *ON
 
      * Get the last job number used
 
     C                   Z-ADD     1             ZZ
     C     T_ZONE        LOOKUP    #_ZOZONE(ZZ)                           99
 
      * Advance to the next job number
 
     C                   ADD       1             #_ZOJOBN(ZZ)
     C     #_ZOJOBN(ZZ)  IFGT      #_ZONJOB(ZZ)
     C     #_ZOJOBN(ZZ)  OREQ      0
     C                   Z-ADD     1             #_ZOJOBN(ZZ)
     C                   ENDIF
 
     C                   MOVE      T_ZONE        CIZONE
     C                   Z-ADD     #_ZOJOBN(ZZ)  CIJOBN
     C                   MOVE      'N'           CIUUNV
     C                   WRITE     GPUTCID0
     C                   ENDIF
                                                                                              CLE024
      ** Set up Update Exposure for Collateralised Lending if installed.                      CLE024
                                                                                              CLE024
     C                   IF        CLE024 = 'Y'                                               CLE024
     C                   EVAL      CIUEXC = 'N'                                               CLE024
     C                   ENDIF                                                                CLE024
                                                                                              CLE024
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Update GPUTJSPD with commit
      ********************************************************************
     C     UPD_COM_UTJS  BEGSR
 
      * Change the sequence number reached on the journal
 
     C     1             CHAIN     GPUTJSD0                           99
     C     *IN99         IFEQ      *OFF
     C                   EVAL      I#LASTSEQ = JrnSeqn
     C                   UPDATE    GPUTJSD0
     C                   ELSE
     C                   EVAL      I#ERMS   = 'ERROR ON ACCESS OF GPUTJSPD'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Commit the updates
 
     C                   COMMIT
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Update GPUTJSPD with no commit
      ********************************************************************
     C     UPD_NCOM_UTJS BEGSR
 
      * Only update on every 100th entry
 
     C     CountEntries  IFEQ      100
 
      * Change the sequence number reached on the journal
 
     C     1             CHAIN     GPUTJSDN                           99
     C     *IN99         IFEQ      *OFF
     C                   EVAL      I#LASTSEQ = JrnSeqn
     C                   UPDATE    GPUTJSDN
     C                   ELSE
     C                   EVAL      I#ERMS   = 'ERROR ON ACCESS OF GPUTJSPD'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     0             CountEntries
     C                   ELSE
     C                   ADD       1             CountEntries
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Allocate a zone updater data queue
      ********************************************************************
     C     ALC_DTAQ      BEGSR
 
     C                   MOVEL     *BLANK        DTAQ_alloc        1
 
     C                   MOVEA     #_CHKOBJ      #_TXT
     C                   MOVEA     ZoneDTAQ      #_TXT(13)
     C                   MOVEA     #_TXT         #_CHKOBJ
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_CHKOBJ
     C                   PARM      70            LEN              15 5
 
      * If DTAQ exists
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     0             NoOfAttempts      2 0
     C     DTAQ_alloc    DOUEQ     'Y'
     C     DTAQ_allocREQ OREQ      'N'
     C     NoOfAttempts  OREQ      20
     C                   MOVEA     #_ALCOBJ      #_TXT
     C                   MOVEA     ZoneDTAQ      #_TXT(13)
     C                   MOVEA     #_TXT         #_ALCOBJ
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_ALCOBJ
     C                   PARM      70            LEN              15 5
     C                   ADD       1             NoOfAttempts
      * DTAQ allocated?
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     'Y'           DTAQ_alloc
     C                   ELSE
     C                   MOVEL     'N'           DTAQ_alloc
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
 
      * Write to the log file
 
     C     DTAQ_allocREQ IFEQ      'Y'
     C     DTAQ_alloc    ANDEQ     'N'
     C                   EVAL      UTMSG = 'Dataq ' + ZoneDTAQ
     C                                   + ' NOT allocated!!!!'
     C                   EXSR      WRITE_LOG
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Deallocate a zone updater data queue
      ********************************************************************
     C     DLC_DTAQ      BEGSR
 
     C                   MOVEA     #_DLCOBJ      #_TXT
     C                   MOVEA     ZoneDTAQ      #_TXT(13)
     C                   MOVEA     #_TXT         #_DLCOBJ
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_DLCOBJ
     C                   PARM      70            LEN              15 5
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Submit a zone updater job
      ********************************************************************
     C     SBM_JOB       BEGSR
      * submit a job
     C                   MOVEA     #_SBMJOB(1)   #_TXT
     C                   MOVEA     ZOMSYS        #_TXT(6)
     C**********         MOVEA     ZOZONE        #_TXT(26)                                    CSC043
     C**********         MOVEA     ZOMSYS        #_TXT(37)                                    CSC043
     C**********         MOVEA     JobNameSuffix #_TXT(40)                                    CSC043
     C**********         MOVEA     ZoneDTAQ      #_TXT(46)                                    CSC043
     C                   MOVEA     ZOZONE        #_TXT(27)                                    CSC043
     C                   MOVEA     ZOMSYS        #_TXT(38)                                    CSC043
     C                   MOVEA     JobNameSuffix #_TXT(41)                                    CSC043
     C                   MOVEA     ZoneDTAQ      #_TXT(47)                                    CSC043
     C                   MOVEA     #_TXT         #_SBMJOB(1)
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    #_SBMJOB
     C                   PARM      70            LEN              15 5
      * Write to the log file
     C     *IN99         IFEQ      *OFF
     C                   EVAL      UTMSG = 'Updater ' + JobNameSuffix
     C                                   + ' submitted'
     C                   ELSE
     C                   EVAL      UTMSG = 'Updater ' + JobNameSuffix
     C                                   + ' NOT submitted!!!!'
     C                   ENDIF
     C                   EXSR      WRITE_LOG
      * Delay this job
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_DLYJOB
     C                   PARM      70            LEN              15 5
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Start the zone updater jobs
      *********************************************************************
     C     STR_UPDATERS  BEGSR
 
     C                   Z-ADD     1             ZZ                2 0
     C     #_ZOZONE(ZZ)  DOWNE     *BLANK
      *                                                                                     AR920119
      ** Check whether the zone is in Close of Business by chaining to                      AR920119
      ** the 'MidasPhaseOfDay' record for the zone on the dashboard                         AR920119
      ** file GPDWNLL0.                                                                     AR920119
      *                                                                                     AR920119
     C                   EVAL      ZONID = #_ZOMSYS(ZZ)                                     AR920119
     C     DWNKEY        CHAIN     GPDWNLL0                           66                    AR920119
      *                                                                                     AR920119
      ** If chain is successful, determine value of Midas phase of day                      AR920119
      *                                                                                     AR920119
     C     *IN66         IFEQ      *OFF                                                     AR920119
     C                   MOVEL     DLVAL         PHAS50                                     AR920119
     C                   MOVEL     PHAS50        PHAS1                                      AR920119
      *                                                                                     AR920119
      ** If Close of Business is running                                                    AR920119
      *                                                                                     AR920119
     C     PHAS1         IFNE      'A'                                                      AR920119
     C     PHAS1         ANDNE     'F'                                                      AR920119
      *                                                                                     AR920119
      ** Set 'submit job' flag to 'N'                                                       AR920119
      *                                                                                     AR920119
     C                   EVAL      #_ZOSTRJ(ZZ) = 'N'                                       AR920119
     C                   ENDIF                                                              AR920119
      *                                                                                     AR920119
     C                   ENDIF                                                              AR920119
      *                                                                                     AR920119
     C     #_ZOSTRJ(ZZ)  IFEQ      'Y'
     C                   MOVEL     *BLANK        #_ZOSTRJ(ZZ)
     C                   MOVEL     #_ZOZONE(ZZ)  ZOZONE
     C                   MOVEL     #_ZOSHTC(ZZ)  ZOSHTC
     C                   MOVEL     #_ZOMSYS(ZZ)  ZOMSYS
     C                   MOVEL     #_ZOSSYS(ZZ)  ZOSSYS
     C                   Z-ADD     0             JOBN              1 0
     C     JOBN          DOUEQ     #_ZONJOB(ZZ)
     C                   ADD       1             JOBN
     C                   MOVEL     'Y'           DTAQ_allocREQ     1
     C                   EXSR      ALC_DTAQ
     C     DTAQ_alloc    IFEQ      'Y'
     C                   EXSR      DLC_DTAQ
     C                   EXSR      SBM_JOB
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ADD       1             ZZ
     C                   ENDDO
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * End the zone updater jobs
      *********************************************************************
     C     END_UPDATERS  BEGSR
 
     C                   Z-ADD     1             ZZ                2 0
     C     #_ZOZONE(ZZ)  DOWNE     *BLANK
     C     #_ZOENDJ(ZZ)  IFEQ      'Y'
     C                   MOVEL     *BLANK        #_ZOENDJ(ZZ)
     C                   MOVEL     #_ZOSHTC(ZZ)  ZOSHTC
     C                   EVAL      DtqDta = 'STOP'
     C                   EXSR      SEND_MSG_ALL
     C                   ENDIF
     C                   ADD       1             ZZ
     C                   ENDDO
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Send a message to all the updaters
      *********************************************************************
     C     SEND_MSG_ALL  BEGSR
     C                   Z-ADD     0             JOBN              1 0
     C     JOBN          DOUEQ     9
     C                   ADD       1             JOBN
     C                   MOVEL     'N'           DTAQ_allocREQ     1
     C                   EXSR      ALC_DTAQ
     C     DTAQ_alloc    IFEQ      'N'
     C                   EXSR      SEND_MSG
     C                   ELSE
     C     DTAQ_alloc    IFEQ      'Y'
     C                   EXSR      DLC_DTAQ
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Send a message to one zone updater job
      *********************************************************************
     C     SEND_MSG      BEGSR
      * Write to the log file
     C     DtqDta        IFNE      'GO'
     C                   EVAL      UTMSG = 'Updater ' + JobNameSuffix
     C                                   + ' has been sent the message:'
     C                                   + DtqDta
     C                   EXSR      WRITE_LOG
     C                   ENDIF
      * send a message
     C                   CALL      'QSNDDTAQ'                           9999
     C                   PARM      ZoneDTAQ      DtqNam           10
     C                   PARM      '*LIBL     '  DtqLib           10
     C                   PARM      10            DtqLen            5 0
     C                   PARM                    DtqDta           10
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Load zones
      *********************************************************************
     C     LOAD_ZONES    BEGSR
 
     C                   Z-ADD     0             ZZ                2 0
     C                   MOVEL     *BLANK        #_ZOZONE
     C                   MOVEL     *BLANK        #_ZOSHTC
     C                   MOVEL     *BLANK        #_ZOMSYS
     C                   MOVEL     *BLANK        #_ZOSSYS
     C                   Z-ADD     0             #_ZONJOB
     C                   Z-ADD     0             #_ZOJOBN
     C                   MOVEL     *BLANK        #_ZOSTRJ
     C                   MOVEL     *BLANK        #_ZOENDJ
 
     C     *LOVAL        SETLL     GPZONED0
     C                   READ      GPZONED0                               99
     C     *IN99         DOWEQ     *OFF
     C                   ADD       1             ZZ
     C                   MOVEL     ZOZONE        #_ZOZONE(ZZ)
     C                   MOVEL     ZOSHTC        #_ZOSHTC(ZZ)
     C                   MOVEL     ZOMSYS        #_ZOMSYS(ZZ)
     C                   MOVEL     ZOSSYS        #_ZOSSYS(ZZ)
     C                   Z-ADD     ZONJOB        #_ZONJOB(ZZ)
     C                   MOVEL     'Y'           #_ZOSTRJ(ZZ)
     C                   MOVEL     'Y'           #_ZOENDJ(ZZ)
     C                   READ      GPZONED0                               99
     C                   ENDDO
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Reload zone
      *********************************************************************
     C     RELOAD_ZONE   BEGSR
 
     C                   OPEN      GPZONEL1                                                  BUG2678
     C                   Z-ADD     1             ZZ
     C     MsgZone       LOOKUP    #_ZOZONE(ZZ)                           99
     C     *IN99         IFEQ      *ON
     C     MsgZone       CHAIN     GPZONED1                           99
     C     *IN99         IFEQ      *OFF
     C     NoJobs        IFNE      *BLANK
     C                   MOVE      NoJobs        ZONJOB
     C                   ENDIF
     C                   UPDATE    GPZONED1
     C                   MOVEL     ZONJOB        #_ZONJOB(ZZ)
     C     Instruction   IFEQ      'START'
     C                   MOVEL     'Y'           #_ZOSTRJ(ZZ)
     C                   ELSE
     C                   MOVEL     'Y'           #_ZOENDJ(ZZ)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   CLOSE     GPZONEL1                                                  BUG2678
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Write to the log file
      *********************************************************************
     C     WRITE_LOG     BEGSR
     C                   TIME                    TimeDate         12 0
     C                   MOVE      TimeDate      UTDATE
     C                   MOVEL     TimeDate      UTTIME
     C                   WRITE     GPULOGD0
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR
                                                                                              CLE024
      ** Determine if CLE024 is switched on                                                   CLE024
                                                                                              CLE024
     C                   CALL      'GPAOSARDR0'                                               CLE024
     C                   PARM      *BLANKS       PRTCD                                        CLE024
     C                   PARM      '*VERIFY'     POPTN                                        CLE024
     C                   PARM      'CLE024'      PSARD                                        CLE024
                                                                                              CLE024
     C                   IF        PRTCD = *BLANKS                                            CLE024
     C                   MOVE      'Y'           CLE024                                       CLE024
     C                   ELSE                                                                 CLE024
     C                   MOVE      'N'           CLE024                                       CLE024
     C                   ENDIF                                                                CLE024
 
     C                   MOVE      *BLANK        I#RTCD            7
     C                   MOVE      *BLANK        I#ERMS           50
 
     C                   Z-ADD     0             CountEntries      3 0
 
     C                   MOVEL     'GPUTU'       DTAQPrefix
 
     C                   EVAL      UTSRC  = 'M'
     C                   EVAL      UTJOB  = PSJobName
     C                   EVAL      UTUSER = PSUser
     C                   MOVEL     PSJobNo       PSJobNoA          6
     C                   EVAL      UTJOBN = PSJobNoA
 
      * Write to the log file
     C                   EVAL      UTMSG = 'Manager has STARTED'
     C                   EXSR      WRITE_LOG
 
      * Load zones
     C                   EXSR      LOAD_ZONES
 
      * End & Start the zone updater jobs
 
     C                   EXSR      END_UPDATERS
     C                   EXSR      STR_UPDATERS
      *                                                                                     AR920119
      ** Define key list for GPDWNLL0                                                       AR920119
      *                                                                                     AR920119
     C     DWNKEY        KLIST                                                              AR920119
     C                   KFLD                    ZONID                                      AR920119
     C                   KFLD                    PHASKEY                                    AR920119
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
      *                                                                                       CSC043
      ** Array '#_SBMJOB' changed to use xxXPLIB instead of xxXLIB.                           CSC043
      *                                                                                       CSC043
** #_CHKOBJ
CHKOBJ  OBJ(GPUTUxxxxN) OBJTYPE(*DTAQ)
** #_ALCOBJ
ALCOBJ OBJ((GPUTUxxxxN *DTAQ *EXCL)) WAIT(1)
** #_DLCOBJ
DLCOBJ OBJ((GPUTUxxxxN *DTAQ *EXCL))
** #_SBMJOB
CALL xxXPLIB/GOC0004 parm(xxxxxxxxxx xx xxxxN xxxxxxxxxx)                                     CSC043
** #_DLYJOB
DLYJOB DLY(1)
