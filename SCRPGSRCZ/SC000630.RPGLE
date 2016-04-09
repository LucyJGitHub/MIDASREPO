     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Data Replication Updates')
/*XBIA*  CRTPF FILE(QTEMP/UFILE) RCDLEN(6000)                         *
/*XBIA*  CRTPF FILE(QTEMP/UFIL2) RCDLEN(6000)                         *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000630 - Data Replication Updates                          *
      *                                                               *
      *  Function:  This is the generic update program that is        *
      *             called from SC000620.                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 228542             Date 10Aug04               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  228542 - RGZPFM command has changed at V5R3                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRReplicate - Data Replication Routine                        *
      * SRErrLog    - Write to Data Replication Error Log File Routine*
      * *PSSR       - Program Exception Error Routine                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Update file - Physical file to be replicated
     FUFILE     UF A F 6000        DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** Update file - Physical file to be replicated
     FUFIL2     UF A F 6000        DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RECNO(RCNO)
 
      ** Data Replication Error Log file
     FSCELOGPD  O    E             DISK    INFSR(*PSSR)
     F                                     USROPN COMMIT
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Copyright array, LDA layout, etc.
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WConst1         C                   CONST('Record found for write')
     D WConst2         C                   CONST('Record not found for update')
     D WConst3         C                   CONST('Record not found for delete')
     D WConst4         C                   CONST('Unknown error in SC000630')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** QCommands
     D QCmd            S            100    DIM(8) CTDATA PERRCD(1)
 
      ** Data Structure for QCmd
     D Command         DS           100
     D  WCmd                   1    100
     D  WCmd8                 11     20
     D  WCmd3                 13     22
     D  WCmd7                 15     24
     D  WCmd1                 27     36
     D  WCmd4                 29     38
     D  WCmd2                 43     52
     D  WCmd5                 49     52
     D  WCmd6                 63     73
 
      ** System time and date
     D DSTime          DS
     D   Hr                           2A
     D   Min                          2A
     D   Sec                          2A
     D   Mo                           2A
     D   Day                          2A
     D   Yr                           2A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D JrnSeqn         S             10A
     D JrnEnt          S              2A
     D JrnFile         S             10A
     D JrnMbr          S             10A
     D JrnRRN          S             10A
     D JrnFlag         S              1A
     D JrnData         S           6000A
 
     D PReturn         S             10A
     D P_Exist         S              1A
 
     D CommandLen      S             15  5
     D RRN             S             10  0
     D WTime           S             12  0
     D WErrDesc        S             30A
     D WError          S              1A
     D RCNO            S             10  0
 
      ** +--------------------------------------+
      ** ¦ I-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     IUFILE     NS
     IUFIL2     NS
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PReturn
     C                   PARM                    JrnSeqn
     C                   PARM                    JrnEnt
     C                   PARM                    JrnFile
     C                   PARM                    JrnMbr
     C                   PARM                    JrnRRN
     C                   PARM                    JrnFlag
     C                   PARM                    JrnData
 
      ** Initialisation
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EVAL      PReturn = *BLANKS
 
      ** Check if member exists
 
     C                   CALL      'ZACCHKMBR'
     C                   PARM                    JrnFile
     C                   PARM                    JrnMbr
     C                   PARM                    P_Exist
 
      ** If yes, override with the correct member
 
     C                   IF        P_Exist = 'Y'
     C                   IF        JrnEnt = 'UR'
     C                   EVAL      Command = QCmd(8)
     C                   ELSE
     C                   EVAL      Command = QCmd(2)
     C                   ENDIF
     C                   EVAL      WCmd1 = JrnFile
     C                   EVAL      WCmd2 = JrnMbr
     C                   EVAL      CommandLen = 53
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   ENDIF
 
      ** Replication routine
 
     C                   EXSR      SRReplicate
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReplicate - Data Replication Routine                       *
      *                                                               *
      *****************************************************************
     C     SRReplicate   BEGSR
 
     C                   EVAL      WError = *BLANKS
 
      ** For Update, Delete or Write, chain the record first
 
     C                   IF        JrnEnt = 'UP' OR JrnEnt = 'UR' OR
     C                             JrnEnt = 'DL' OR JrnEnt = 'DR' OR
     C                             JrnEnt = 'PT' OR JrnEnt = 'PX'
 
     C                   IF        JrnEnt = 'UR'
     C                   OPEN      UFIL2
     C                   ELSE
     C                   OPEN      UFILE
     C                   ENDIF
 
     C                   MOVE      JrnRRN        RRN
     C                   IF        JrnEnt = 'UR'
     C     RRN           CHAIN     UFIL2                              80
     C                   ELSE
     C     RRN           CHAIN     UFILE                              80
     C                   ENDIF
 
     C                   IF        JrnEnt = 'PT' AND *IN80 = *OFF OR
     C                             JrnEnt = 'PX' AND *IN80 = *OFF OR
     C                             (JrnEnt <> 'PT' AND JrnEnt <> 'PX'
     C                             AND JrnEnt <> 'UR' AND *IN80 = *ON)
     C                   IF        JrnEnt = 'UR'
     C                   CLOSE     UFIL2
     C                   ELSE
     C                   CLOSE     UFILE
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      JrnEnt = 'PT' OR JrnEnt = 'PX'
     C                   EVAL      WErrDesc = WConst1
     C                   WHEN      JrnEnt = 'UP'
     C                   EVAL      WErrDesc = WConst2
     C                   WHEN      JrnEnt = 'DL' OR JrnEnt = 'DR'
     C                   EVAL      WErrDesc = WConst3
     C                   ENDSL
     C                   EXSR      SRErrLog
     C                   EVAL      WError = 'Y'
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Depending on the journal entry type, replicate to Support
 
     C                   IF        WError = *BLANKS
     C                   SELECT
 
      ** Update
 
     C                   WHEN      JrnEnt = 'UP'
     C                   EXCEPT    UPDR
     C                   CLOSE     UFILE
 
      ** Delete
 
     C                   WHEN      JrnEnt = 'DL' OR JrnEnt = 'DR'
     C                   EXCEPT    DELR
     C                   CLOSE     UFILE
 
      ** Write
 
     C                   WHEN      JrnEnt = 'PT' OR JrnEnt = 'PX'
     C                   EXCEPT    ADDR
     C                   CLOSE     UFILE
 
     C                   WHEN      JrnEnt = 'UR' AND *IN80 = *OFF
     C                   EXCEPT    UPDR2
     C                   CLOSE     UFIL2
 
     C                   WHEN      JrnEnt = 'UR' AND *IN80 = *ON
     C                   EVAL      RCNO = RRN
     C                   EXCEPT    ADDR2
     C                   CLOSE     UFIL2
 
      ** Reorganize PFM
 
     C                   WHEN      JrnEnt = 'RG'
     C**********         EVAL      Command = QCmd(3)                                          228542
     C**********         EVAL      WCmd3 = JrnFile                                            228542
     C**********         EVAL      WCmd4 = JrnMbr                                             228542
     C**********         EVAL      CommandLen = 39                                            228542
 
     C**********         CALL      'QCMDEXC'                                                  228542
     C**********         PARM                    Command                                      228542
     C**********         PARM                    CommandLen                                   228542
 
     C                   CALL      'SCC000060'                                                228542
     C                   PARM                    JrnFile                                      228542
     C                   PARM                    JrnMbr                                       228542
      *
      ** Clear PFM
 
     C                   WHEN      JrnEnt = 'CR'
     C                   EVAL      Command = QCmd(4)
     C                   EVAL      WCmd3 = JrnFile
     C                   EVAL      WCmd4 = JrnMbr
     C                   EVAL      CommandLen = 39
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
 
      ** Add PFM (if non-existent)
 
     C                   WHEN      JrnEnt = 'JM'
     C                   CALL      'ZACCHKMBR'
     C                   PARM                    JrnFile
     C                   PARM                    JrnMbr
     C                   PARM                    P_Exist
 
     C                   IF        P_Exist <> 'Y'
     C                   EVAL      Command = QCmd(5)
     C                   EVAL      WCmd3 = JrnFile
     C                   EVAL      WCmd4 = JrnMbr
     C                   EVAL      CommandLen = 39
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   ENDIF
 
      ** Initialise PFM
 
     C                   WHEN      JrnEnt = 'IZ'
     C                   EVAL      Command = QCmd(6)
     C                   EVAL      WCmd3 = JrnFile
     C                   EVAL      WCmd4 = JrnMbr
     C                   IF        JrnFlag = '0'
     C                   EVAL      WCmd5 = '*DFT'
     C                   ELSE
     C                   EVAL      WCmd5 = '*DLT'
     C                   ENDIF
     C                   EVAL      WCmd6 = JrnRRN
     C                   EVAL      CommandLen = 74
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
 
      ** Remove member
 
     C                   WHEN      JrnEnt = 'MD'
     C                   EVAL      Command = QCmd(7)
     C                   EVAL      WCmd8 = JrnFile
     C                   EVAL      WCmd1 = JrnMbr
     C                   EVAL      CommandLen = 37
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
 
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrLog - Write to Data Replication Error Log File and      *
      *             Send message to SC24X7 message queue              *
      *                                                               *
      *****************************************************************
     C     SRErrLog      BEGSR
 
     C                   OPEN      SCELOGPD
 
     C                   EVAL      FDERRF = JrnFile
     C                   EVAL      FDERRD = WErrDesc
     C                   MOVE      JrnSeqn       FDJSEQ
     C                   MOVE      JrnRRN        FDJRRN
     C                   EVAL      FDJTYP = JrnEnt
     C                   EVAL      FDMEM =  JrnMbr
     C                   EVAL      FDJDAT = JrnData
     C                   TIME                    WTime
     C                   MOVE      WTime         DSTime
     C                   EVAL      FDMDAT = Day + Mo + Yr
     C                   EVAL      FDMTIM = Hr + Min + Sec
 
     C                   WRITE     SCELOGD0
     C                   COMMIT
     C                   CLOSE     SCELOGPD
 
      ** Send message to SC24X7Q message queue
 
     C                   EVAL      Command = QCmd(1)
     C                   EVAL      CommandLen = 95
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
 
     C                   IF        WErrDesc = *BLANKS
     C                   EVAL      WErrDesc = WConst4
     C                   ENDIF
     C                   EXSR      SRErrLog
 
     C                   DUMP
     C                   ROLBK
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   EVAL      PReturn = '*ERROR'
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ O-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     OUFILE     E            UPDR
     O                       JrnData           6000
 
     OUFILE     EDEL         DELR
 
     OUFILE     EADD         ADDR
     O                       JrnData           6000
 
     OUFIL2     E            UPDR2
     O                       JrnData           6000
 
     OUFIL2     EADD         ADDR2
     O                       JrnData           6000
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  QCmd
SNDMSG MSG('Error in module SC000630. Program ended abnormally - see job log.') TOMSGQ(SC24X7Q)
OVRDBF FILE(UFILE) TOFILE(          ) MBR(          )
RGZPFM FILE(          ) MBR(          )
CLRPFM FILE(          ) MBR(          )
ADDPFM FILE(          ) MBR(          )
INZPFM FILE(          ) MBR(          ) RECORDS(    ) TOTRCDS(           )
RMVM FILE(          ) MBR(          )
OVRDBF FILE(UFIL2) TOFILE(          ) MBR(          )
