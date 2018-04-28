     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Data replication exit program')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000620 - Exit program for RCVJRNE command                  *
      *                                                               *
      *  Function:  This is the exit program for the RCVJRNE command  *
      *             in SC000610. This calls SC000630, which is the    *
      *             generic function that performs the data           *
      *             replication.                                      *
      *                                                               *
      *  Called by: SC000610                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRJSN0     - Update Last journal sequence number processed    *
      * SRBatchSts - Update Batch Status Routine                      *
      * SRClose    - Close the appropriate file                       *
      * SRSelUpd   - Select on which file to update                   *
      * SRSelChain - Select on which file to chain                    *
      * *PSSR      - Program Exception Error Routine                  *
      * *INZSR    - Initialise                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Selected files for replication
     FSCFDTLL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** Data Replication Journal Sequence Number file
     FSCJSN0PD  UF   E             DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
     FSCJSN1PD  UF   E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D1)
     F                                     COMMIT
     FSCJSN2PD  UF   E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D2)
     F                                     COMMIT
     FSCJSN3PD  UF   E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D3)
     F                                     COMMIT
     FSCJSN4PD  UF   E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D4)
     F                                     COMMIT
     FSCJSN5PD  UF   E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D5)
     F                                     COMMIT
     FSCJSN6PD  UF   E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D6)
     F                                     COMMIT
     FSCJSN7PD  UF   E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D7)
     F                                     COMMIT
     FSCJSN8PD  UF   E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D8)
     F                                     COMMIT
     FSCJSN9PD  UF   E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D9)
     F                                     COMMIT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data replication Status data area
     D SCDRSTAT      E DS                  EXTNAME(SCDRSTAT) DTAARA(SCDRSTAT)
 
      ** Journal entry data
     D JournalEnt      DS
     D   Filler01                     5A
     D   JrnSeqn                     10A
     D   JrnCode                      1A
     D   JrnEnt                       2A
     D   Filler02                    38A
     D   JrnPgm                      10A
     D   JrnFile                     10A
     D   JrnLib                      10A
     D   JrnMbr                      10A
     D   JrnRRN                      10A
     D   JrnFlag                      1A
     D   Filler03                    18A
     D   JrnData                   6000A
 
      ** Control Information
     D ControlInf      DS
     D   CTRLInfo1                    1
     D   CTRLInfo2                    1
 
      ** Local data area for database error details
     D LDA             DS           256    DTAARA(LDA)
     D   BatchNum              1      1
     D   DBFILE              134    141
     D   DBKEY               142    170
     D   DBPGM               171    180
     D   DBASE               181    183
     D   DBMOD               184    193
     D   DBPROC              194    203
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Command         S            100A
     D CommandLen      S             15  5
     D PRetCode        S             10A
     D WJSNx           S             10A
     D WRun            S              1A
     D WStatus         S              1A
     D WValid          S              1A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    JournalEnt
     C                   PARM                    ControlInf
 
      ** Initialise LDA fields
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
 
      ** If no data has been received, end program
 
     C                   IF        CTRLInfo1 = '0'
     C                   EVAL      CTRLInfo1 = '9'
     C                   RETURN
     C                   ENDIF
 
      ** If 'stop' requested, update PF/SCJSN0PD and end program
 
     C                   IF        JrnCode = 'U'
     C                   IF        JrnEnt = 'EG' OR
     C                             (JrnEnt = 'XE' AND JrnFile = 'SDBANKPD') OR
     C                             (JrnEnt = 'XJ' AND JrnFile = 'SDBANKPD')
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      SRJSN0
     C                   EXSR      SRCLOSE
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Check whether file is selected for replication
 
     C                   EVAL      WValid = *BLANKS
     C     JrnFile       CHAIN     SCFDTLL2                           81
     C                   IF        *IN81 = *OFF
     C                   EVAL      WValid = 'Y'
     C                   ENDIF
 
     C                   IF        WValid = 'Y'
     C                   EVAL      WValid = *BLANKS
 
      ** If so, check if journal entry type is valid
 
     C                   IF        JrnCode = 'F'
     C                   IF        JrnEnt = 'RG' OR JrnEnt = 'CR' OR
     C                             JrnEnt = 'JM' OR JrnEnt = 'MD' OR
     C                             JrnEnt = 'IZ'
     C                   EVAL      WValid = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        JrnCode = 'R'
     C                   IF        JrnEnt = 'PT' OR JrnEnt = 'PX' OR
     C                             JrnEnt = 'UP' OR JrnEnt = 'UR' OR
     C                             JrnEnt = 'DL' OR JrnEnt = 'DR'
     C                   EVAL      WValid = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** If valid, call the update function
 
     C                   IF        WValid = 'Y'
 
     C                   CALL      'SC000630'
     C                   PARM                    PRetCode
     C                   PARM                    JrnSeqn
     C                   PARM                    JrnEnt
     C                   PARM                    JrnFile
     C                   PARM                    JrnMbr
     C                   PARM                    JrnRRN
     C                   PARM                    JrnFlag
     C                   PARM                    JrnData
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      CTRLInfo1 = '9'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = '001'
     C                   EVAL      DBFILE = 'SC000630'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Update the PF/SCJSN0PD and end program
 
     C                   EXSR      SRJSN0
 
      ** 'Normal' return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJSN0 - Routine to update the Last journal sequence number  *
      *           field in PF/SCJSN0PD                                *
      *                                                               *
      *****************************************************************
     C     SRJSN0        BEGSR
 
     C                   EXSR      SRSelChain
 
      ** If record is not found, do error processing
 
     C                   IF        *IN80 = *ON
     C                   EVAL      CTRLInfo1 = '9'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = '002'
     C                   EVAL      DBFILE = WJSNx
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Otherwise, update the Last journal sequence number
 
     C                   EVAL      JSLSEQ = JrnSeqn
     C                   EXSR      SRSelUpd
     C                   COMMIT
 
      ** Also update the Batch status
 
     C                   EVAL      WStatus = *BLANKS
     C                   IF        JrnCode = 'U'
 
     C                   IF        JrnEnt = 'EG'
     C                   IF        %SUBST(JrnData:1:9) = 'SCC004306'
     C                   EVAL      WStatus = 'E'
     C                   ELSE
     C                   EVAL      WStatus = 'T'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        JrnFile = 'SDBANKPD'
     C                   IF        JrnEnt = 'XE' OR JrnEnt = 'XJ'
     C                   EVAL      WStatus = 'T'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SRBatchSts
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBatchSts - Update Batch Status Routine                     *
      *                                                               *
      *****************************************************************
     C     SRBatchSts    BEGSR
 
     C     *LOCK         IN        SCDRSTAT
     C                   SELECT
     C                   WHEN      BatchNum = '0'
     C                   EVAL      DASTA0 = WStatus
     C                   WHEN      BatchNum = '1'
     C                   EVAL      DASTA1 = WStatus
     C                   WHEN      BatchNum = '2'
     C                   EVAL      DASTA2 = WStatus
     C                   WHEN      BatchNum = '3'
     C                   EVAL      DASTA3 = WStatus
     C                   WHEN      BatchNum = '4'
     C                   EVAL      DASTA4 = WStatus
     C                   WHEN      BatchNum = '5'
     C                   EVAL      DASTA5 = WStatus
     C                   WHEN      BatchNum = '6'
     C                   EVAL      DASTA6 = WStatus
     C                   WHEN      BatchNum = '7'
     C                   EVAL      DASTA7 = WStatus
     C                   WHEN      BatchNum = '8'
     C                   EVAL      DASTA8 = WStatus
     C                   WHEN      BatchNum = '9'
     C                   EVAL      DASTA9 = WStatus
     C                   ENDSL
     C                   OUT       SCDRSTAT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSelChain - Select on which file to Chain                    *
      *                                                               *
      *****************************************************************
     C     SRSelChain    BEGSR
 
     C                   SELECT
     C                   WHEN      BatchNum = '0'
     C     1             CHAIN     SCJSN0PD                           8080
 
     C                   WHEN      BatchNum = '1'
     C     1             CHAIN     SCJSN1PD                           8080
 
     C                   WHEN      BatchNum = '2'
     C     1             CHAIN     SCJSN2PD                           8080
 
     C                   WHEN      BatchNum = '3'
     C     1             CHAIN     SCJSN3PD                           8080
 
     C                   WHEN      BatchNum = '4'
     C     1             CHAIN     SCJSN4PD                           8080
 
     C                   WHEN      BatchNum = '5'
     C     1             CHAIN     SCJSN5PD                           8080
 
     C                   WHEN      BatchNum = '6'
     C     1             CHAIN     SCJSN6PD                           8080
 
     C                   WHEN      BatchNum = '7'
     C     1             CHAIN     SCJSN7PD                           8080
 
     C                   WHEN      BatchNum = '8'
     C     1             CHAIN     SCJSN8PD                           8080
 
     C                   WHEN      BatchNum = '9'
     C     1             CHAIN     SCJSN9PD                           8080
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSelUpd - Select on which file to Update                     *
      *                                                               *
      *****************************************************************
     C     SRSelUpd      BEGSR
 
     C                   SELECT
     C                   WHEN      BatchNum = '0'
     C                   UPDATE    SCJSN0D0
 
     C                   WHEN      BatchNum = '1'
     C                   UPDATE    SCJSN0D1
 
     C                   WHEN      BatchNum = '2'
     C                   UPDATE    SCJSN0D2
 
     C                   WHEN      BatchNum = '3'
     C                   UPDATE    SCJSN0D3
 
     C                   WHEN      BatchNum = '4'
     C                   UPDATE    SCJSN0D4
 
     C                   WHEN      BatchNum = '5'
     C                   UPDATE    SCJSN0D5
 
     C                   WHEN      BatchNum = '6'
     C                   UPDATE    SCJSN0D6
 
     C                   WHEN      BatchNum = '7'
     C                   UPDATE    SCJSN0D7
 
     C                   WHEN      BatchNum = '8'
     C                   UPDATE    SCJSN0D8
 
     C                   WHEN      BatchNum = '9'
     C                   UPDATE    SCJSN0D9
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLOSE - Close the appropriate file                          *
      *                                                               *
      *****************************************************************
     C     SRClose       BEGSR
 
     C                   SELECT
     C                   WHEN      BatchNum = '0'
     C                   CLOSE     SCJSN0PD
 
     C                   WHEN      BatchNum = '1'
     C                   CLOSE     SCJSN1PD
 
     C                   WHEN      BatchNum = '2'
     C                   CLOSE     SCJSN2PD
 
     C                   WHEN      BatchNum = '3'
     C                   CLOSE     SCJSN3PD
 
     C                   WHEN      BatchNum = '4'
     C                   CLOSE     SCJSN4PD
 
     C                   WHEN      BatchNum = '5'
     C                   CLOSE     SCJSN5PD
 
     C                   WHEN      BatchNum = '6'
     C                   CLOSE     SCJSN6PD
 
     C                   WHEN      BatchNum = '7'
     C                   CLOSE     SCJSN7PD
 
     C                   WHEN      BatchNum = '8'
     C                   CLOSE     SCJSN8PD
 
     C                   WHEN      BatchNum = '9'
     C                   CLOSE     SCJSN9PD
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
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
 
     C                   IN        LDA
     C                   SELECT
     C                   WHEN      BatchNum = '0'
     C                   OPEN      SCJSN0PD
     C                   EVAL      WJSNx = 'SCJSN0PD'
 
     C                   WHEN      BatchNum = '1'
     C                   OPEN      SCJSN1PD
     C                   EVAL      WJSNx = 'SCJSN1PD'
 
     C                   WHEN      BatchNum = '2'
     C                   OPEN      SCJSN2PD
     C                   EVAL      WJSNx = 'SCJSN2PD'
 
     C                   WHEN      BatchNum = '3'
     C                   OPEN      SCJSN3PD
     C                   EVAL      WJSNx = 'SCJSN3PD'
 
     C                   WHEN      BatchNum = '4'
     C                   OPEN      SCJSN4PD
     C                   EVAL      WJSNx = 'SCJSN4PD'
 
     C                   WHEN      BatchNum = '5'
     C                   OPEN      SCJSN5PD
     C                   EVAL      WJSNx = 'SCJSN5PD'
 
     C                   WHEN      BatchNum = '6'
     C                   OPEN      SCJSN6PD
     C                   EVAL      WJSNx = 'SCJSN6PD'
 
     C                   WHEN      BatchNum = '7'
     C                   OPEN      SCJSN7PD
     C                   EVAL      WJSNx = 'SCJSN7PD'
 
     C                   WHEN      BatchNum = '8'
     C                   OPEN      SCJSN8PD
     C                   EVAL      WJSNx = 'SCJSN8PD'
 
     C                   WHEN      BatchNum = '9'
     C                   OPEN      SCJSN9PD
     C                   EVAL      WJSNx = 'SCJSN9PD'
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
      ** Update the Batch status to failed
 
     C                   EVAL      WStatus = 'F'
     C                   EXSR      SRBatchSts
     C                   EXSR      SRClose
 
     C                   DUMP
     C                   ROLBK
     C                   ENDIF
 
      ** End program
 
     C                   EVAL      CTRLInfo1 = '9'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
