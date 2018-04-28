     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*X*IA***CRTPF*FILE(QTEMP/GO000108F1)*RCDLEN(132)**********************                     MD020696
/*X*IB***RNMOBJFOBJ(QTEMP/GO000108F1)*OBJTYPE(*FILE)*******************                     MD020696
/*X*IB***NEWOBJ(GO000108F2)O000108F1)*OBJTYPE(*FILE)*******************                     MD020696
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Download data control - Subsystem')           *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000108 - Global Processing data dowload, subsystem         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD020696A          Date 01Jul13               *
      *  Prev Amend No. MD020696           Date 03Jun13               *
      *                 MD020167           Date 23Apr13               *
      *                 CCB023             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG9512            Date 05Dec05               *
      *                 CGP002  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020696A - Call PGM/GO001081 to get subsystem information   *
      *              instead of using PF/GOSBSDPD                     *
      *  MD020696 - Dashboard doesn't show proper value of Jobs in    *
      *             MSGW status. Use API to get active jobs from sub- *
      *             system instead of using the spooled file from     *
      *             WRKACTJOB *PRINT                                  *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring (Recompile)                           *
      *  BUG9512 - Signal errors to calling program in U7U8.          *
      *  CGP002 - Global Processing data download                     *
      *                                                               *
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
      *
     F***GO000108F2IF   E             DISK    INFSR(*PSSR)                                  MD020696
     F**********                           PREFIX(X)                                        MD020696
     F***GOSBSDPD  IF   E             DISK    INFSR(*PSSR)                        MD020696 MD020696A
     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN                                            BUG9512
      **
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D                 DS
     D  CountN                 1      5  0
     D  CountA                 1      5
     D**********       DS                                                                   MD020696
     D***Subsystem               1    132                                                   MD020696
     D***SubsystemName          1     10                                                    MD020696
     D***Job                    4     13                                                    MD020696
     D***Status               111    114                                                    MD020696
                                                                                           MD020696A
     D W_QualJobName   DS                                                                  MD020696A
     D  JobName                1     10                                                    MD020696A
     D  JobUser               11     20                                                    MD020696A
     D  JobNumber             21     26    INZ('*ALL  ')                                   MD020696A
      *
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      * Midas Local Data Area for database error reporting
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      * The following fields are defined in the external file:
      *                                     134 141 DBFile
      *                                     142 170 DBKey
      *                                     171 180 DBPgm
      *                                     181 1830DBase
      *                                     184 193 DBMod
      *                                     194 203 DBProc
      * Midas SD Data Area                                                                 MD020696A
     D SDSTAT        E DS                  EXTNAME(SDSTAT)                                 MD020696A
     D  SystemId     E                     EXTFLD(LIBR)                                    MD020696A
      *                                                                                    MD020696A
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1
     D Value           S             50
     D InSBSName       S             10
     D W_Subsystem     S             10A                                                   MD020696A
     D W_JobStatus     S              4A                                                   MD020696A
     D W_Mode          S              6A                                                   MD020696A
     D W_RtnStatus     S              4A                                                   MD020696A
     D W_RtnCount      S              5S 0                                                 MD020696A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
     I***GOSBSDD0                                                                 MD020696 MD020696A
      ***Rename*Fields*************************************************           MD020696 MD020696A
     I**********    FJOBNAM                     Job                               MD020696 MD020696A
     I**********    FJOBSTAT                    Status                            MD020696 MD020696A
      *                                                                           MD020696 MD020696A
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C/COPY GOCPYSRC,GOUPD_PARM
      *
      ** Get Subsystem Name and Job User (xxOWNER)                                         MD020696A
      *                                                                                    MD020696A
     C     *DTAARA       DEFINE                  SDSTAT                                    MD020696A
     C                   IN        SDSTAT                                                  MD020696A
                                                                                           MD020696A
     C                   EVAL      W_Subsystem = 'M' + SystemId + 'SBS'                    MD020696A
     C                   EVAL      JobUser = SystemId + 'OWNER   '                         MD020696A
                                                                                           MD020696A
      * CoB Monitor active?
     C                   IF        Key_Desc = 'CoBMonitorActive'
      *
      * If the Midas phase is not CoB then set data to blank.
     C                   IF        MidasPhase <> 'C'
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      Value = *blanks
                                                                                           MD020696A
      ** Call program to get status of COBMONITOR                                          MD020696A
                                                                                           MD020696A
     C                   EVAL      JobName = 'COBMONITOR'                                  MD020696A
                                                                                           MD020696A
     C                   CALL      'GO001081'                                              MD020696A
     C                   PARM                    W_QualJobName                             MD020696A
     C                   PARM                    W_Subsystem                               MD020696A
     C                   PARM      *BLANKS       W_JobStatus                               MD020696A
     C                   PARM      '*STAT'       W_Mode                                    MD020696A
     C                   PARM      *BLANKS       W_RtnStatus                               MD020696A
     C                   PARM      *ZEROS        W_RtnCount                                MD020696A
                                                                                           MD020696A
     C                   EVAL      Value = W_RtnStatus                                     MD020696A
      *
     C*****1****         SETLL     GO000108F2                                               MD020696
     C**********         READ      GO000108F2                             01                MD020696
     C*****1****         SETLL     GOSBSDPD                                       MD020696 MD020696A
     C**********         READ      GOSBSDPD                               01      MD020696 MD020696A
      *****************************************************************                    MD020696A
     C**********         DOW       *IN01 = *OFF                                            MD020696A
     C**********         EVAL      Subsystem = XGO000108F1                                  MD020696
     C**********         IF        Job = 'COBMONITOR'                                      MD020696A
     C**********         EVAL      Value = Status                                          MD020696A
     C**********         EVAL      *IN01 = *ON                                             MD020696A
     C**********         ENDIF                                                             MD020696A
     C**********         READ      GO000108F2                             01                MD020696
     C**********         READ      GOSBSDPD                               01      MD020696 MD020696A
     C**********         ENDDO                                                             MD020696A
      *
      * If Value is blank this means that the COBMONITOR job was not found.
     C                   IF        Value = *blanks
     C                   EVAL      Value = '*INACTIVE'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * CoB Scheduler active?
     C                   IF        Key_Desc = 'CoBSchedulerActive'
      *
      * If the Midas phase is not CoB then set data to blank.
     C                   IF        MidasPhase <> 'C'
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      Value = *blanks
                                                                                           MD020696A
      ** Call program to get status of COBSCHED                                            MD020696A
                                                                                           MD020696A
     C                   EVAL      JobName = 'COBSCHED  '                                  MD020696A
                                                                                           MD020696A
     C                   CALL      'GO001081'                                              MD020696A
     C                   PARM                    W_QualJobName                             MD020696A
     C                   PARM                    W_Subsystem                               MD020696A
     C                   PARM      *BLANKS       W_JobStatus                               MD020696A
     C                   PARM      '*STAT'       W_Mode                                    MD020696A
     C                   PARM      *BLANKS       W_RtnStatus                               MD020696A
     C                   PARM      *ZEROS        W_RtnCount                                MD020696A
                                                                                           MD020696A
     C                   EVAL      Value = W_RtnStatus                                     MD020696A
      *
     C*****1****         SETLL     GO000108F2                                               MD020696
     C**********         READ      GO000108F2                             01                MD020696
     C*****1****         SETLL     GOSBSDPD                                       MD020696 MD020696A
     C**********         READ      GOSBSDPD                               01      MD020696 MD020696A
      *****************************************************************                    MD020696A
     C**********         DOW       *IN01 = *OFF                                            MD020696A
     C**********         EVAL      Subsystem = XGO000108F1                                  MD020696
     C**********         IF        Job = 'COBSCHED'                                        MD020696A
     C**********         EVAL      Value = Status                                          MD020696A
     C**********         EVAL      *IN01 = *ON                                             MD020696A
     C**********         ENDIF                                                             MD020696A
     C**********         READ      GO000108F2                             01                MD020696
     C**********         READ      GOSBSDPD                               01      MD020696 MD020696A
     C**********         ENDDO                                                             MD020696A
      *
      * If Value is blank this means that the COBSCHED job was not found.
     C                   IF        Value = *blanks
     C                   EVAL      Value = '*INACTIVE'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Jobs in subsystem on message wait
     C                   IF        Key_Desc = 'JobsOnMessageWait'
      *
     C                   EVAL      CountN = 0
                                                                                           MD020696A
      ** Call program to number of jobs in MSGW                                            MD020696A
                                                                                           MD020696A
     C                   EVAL      JobName = '*ALL      '                                  MD020696A
                                                                                           MD020696A
     C                   CALL      'GO001081'                                              MD020696A
     C                   PARM                    W_QualJobName                             MD020696A
     C                   PARM                    W_Subsystem                               MD020696A
     C                   PARM      'MSGW'        W_JobStatus                               MD020696A
     C                   PARM      '*COUNT'      W_Mode                                    MD020696A
     C                   PARM      *BLANKS       W_RtnStatus                               MD020696A
     C                   PARM      *ZEROS        W_RtnCount                                MD020696A
                                                                                           MD020696A
     C                   EVAL      CountN = W_RtnCount                                     MD020696A
      *
     C*****1****         SETLL     GO000108F2                                               MD020696
     C**********         READ      GO000108F2                             01                MD020696
     C*****1****         SETLL     GOSBSDPD                                       MD020696 MD020696A
     C**********         READ      GOSBSDPD                               01      MD020696 MD020696A
      *****************************************************************                    MD020696A
     C**********         DOW       *IN01 = *OFF                                            MD020696A
     C**********         EVAL      Subsystem = XGO000108F1                                  MD020696
     C**********         IF        Status = 'MSGW'                                         MD020696A
     C**********         EVAL      CountN = CountN + 1                                     MD020696A
     C**********         ENDIF                                                             MD020696A
     C**********         READ      GO000108F2                             01                MD020696
     C**********         READ      GOSBSDPD                               01      MD020696 MD020696A
     C**********         ENDDO                                                             MD020696A
      *
     C                   EVAL      Value = CountA
      *
     C                   ENDIF
      *
     C/COPY GOCPYSRC,GOUPD_DWNL
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
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
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   SetOn                                        U7U8                   BUG9512
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
