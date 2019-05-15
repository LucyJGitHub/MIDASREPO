     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Data replication i/c monitor')                *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000050 - Data Replication I/C Monitor Program              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSC048             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC048 - Journal Caching                                     *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Data Replication File - Selected for Replication
     FSCFDTLL4  IF   E           K DISK    INFSR(*PSSR)
 
      ** Data Replication File Journal Sequence Number for Batch 0
     FSCJSN0PD  IF   E             DISK    INFSR(*PSSR)
 
      ** Data Replication File Journal Sequence Number for Batch 1
     FSCJSN1PD  IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN1D0)
 
      ** Data Replication File Journal Sequence Number for Batch 2
     FSCJSN2PD  IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN2D0)
 
      ** Data Replication File Journal Sequence Number for Batch 3
     FSCJSN3PD  IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN3D0)
 
      ** Data Replication File Journal Sequence Number for Batch 4
     FSCJSN4PD  IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN4D0)
 
      ** Data Replication File Journal Sequence Number for Batch 5
     FSCJSN5PD  IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN5D0)
 
      ** Data Replication File Journal Sequence Number for Batch 6
     FSCJSN6PD  IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN6D0)
 
      ** Data Replication File Journal Sequence Number for Batch 7
     FSCJSN7PD  IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN7D0)
 
      ** Data Replication File Journal Sequence Number for Batch 8
     FSCJSN8PD  IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN8D0)
 
      ** Data Replication File Journal Sequence Number for Batch 9
     FSCJSN9PD  IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN9D0)
 
      ** Data Replication I/C Monitor Display File
     FSC000050DFCF   E             WORKSTN
     F                                     SFILE(SC000050S0:#0SFRN)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D WQcmd           S            100    DIM(6) CTDATA PERRCD(1)
     D WPFile          S             10    DIM(10) CTDATA PERRCD(1)
 
     D WBtchUsd        S              1    DIM(10)
     D WBtchSta        S              1    DIM(10)
     D WJrnSeqNo       S             10    DIM(10)
 
     D SCDRSTAT      E DS                  EXTNAME(SCDRSTAT) DTAARA(SCDRSTAT)
     D WBtchUsdDS              5     14
     D WBtchStaDS             15     24
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
     D Command         DS           173
     D  WCmd1                 27     27
     D  WCmd2                 53     62
     D  WCmd3                 55     56
     D  WCmd4                 75     76
     D  WCmd5                102    173
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WBach           S              1A
     D WBachNum        S              1S 0
     D WNumRec         S              2P 0
     D WNum            S              2S 0
     D WError          S              1A
 
      ** Parameters for AOBANKR0
     D PRTCD           S              7A
     D POPTN           S              7A
 
      ** Parameters for QCMDEXC
     D CommandLen      S             15  5
 
      ** Parameters for ZAMSGTOSCN
     D PZMsgFile       S             10A
     D PZMsgID         S              7A
     D PZMsgDta        S             45A
     D PZMsgPgm        S             10A
     D PZMsgMod        S             10A
     D PZMsgProc       S             10A
 
      ** Parameter for ZACCHKALC
     D PObject         S             10A
     D PObjectType     S             10A
     D PFlag           S              1A
 
      ** Parameter for ZACRTVSQN
     D PJourn          S             10A
     D PFile           S             10A
     D PMember         S             10A
     D PFrEnt          S             10A
     D PToEnt          S             10A
     D PRtnSeqNbr      S             10A
 
      ** Parameter for SDRTVTXT
     D PMsgDNb         S              7A
     D PMsgNm          S             10A
     D PMsgTxt         S             80A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   DO        *HIVAL
 
     ** Build subfile
 
     C                   IF        WError <> 'Y'
     C                   EXSR      SRBUILD
     C                   EXSR      SRLSNI
     C                   ENDIF
 
     C                   WRITE     SC000050C1
     C                   WRITE     SC000050F0
     C                   EXFMT     SC000050C0
 
     ** Clear messages from program message queue
 
     C                   CALLB     'ZAMSGCLRPG'
     C                   PARM                    PZMsgPgm
     C                   PARM                    PZMsgMod
     C                   PARM                    PZMsgProc
 
     C                   EVAL      *IN24 = *OFF
 
     ** If F3 was pressed
 
     C     *INKC         CASEQ     *ON           SREND
 
     ** If F5 was pressed
 
     C     *INKE         CASEQ     *ON           SRREFRESH
 
     ** If F14 was pressed
 
     C     *INKN         CASEQ     *ON           SRPRINT
 
     C                   CAS                     SRPROCESS
     C                   ENDCS
 
     C                   ENDDO
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPRINT - Print all messages                                 *
      *                                                               *
      *****************************************************************
 
     C     SRPRINT       BEGSR
 
      ** Print message queue SC24X7Q
 
     C                   EVAL      Command = WQcmd(5)
     C                   EVAL      CommandLen = 40
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
 
      ** Move printed output of SC24X7Q to outq M24X7
 
     C                   EVAL      Command = WQcmd(6)
     C                   EVAL      CommandLen = 65
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBUILD - Build Subfile Page Routine                         *
      *                                                               *
      *****************************************************************
 
     C     SRBUILD       BEGSR
 
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   WRITE     SC000050C0
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN42 = *ON
 
     C                   EVAL      *IN41 = *OFF
 
     C                   Z-ADD     *ZERO         WNumRec
 
     C                   EXSR      SRDRSTAT
     C                   EXSR      SRJSQN
     C                   EXSR      SRLOAD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLOAD - Load Subfile Page Routine                           *
      *                                                               *
      *****************************************************************
 
     C     SRLOAD        BEGSR
 
     C                   Z-ADD     WNumRec       #0SFRN
     C                   Z-ADD     1             WNumRec
 
     C                   DOW       WNumRec <= 10
 
     C                   ADD       1             #0SFRN
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      WNum = WNumRec
 
     C                   EXSR      SRCLRSFLD
     C                   EXSR      SRMOVESFL
 
     C                   ADD       1             WNumRec
     C                   EVAL      *IN42 = *ON
 
     C                   WRITE     SC000050S0
 
     C                   ENDDO
 
     C                   EVAL      *IN41 = *ON
 
     C                   Z-ADD     #0SFRN        WNumRec
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDRSTAT - Move SCDRSTAT fields to an Array                  *
      *                                                               *
      *****************************************************************
 
     C     SRDRSTAT      BEGSR
 
     C     *LOCK         IN        SCDRSTAT
     C                   MOVEA     WBtchUsdDS    WBtchUsd
     C                   MOVEA     WBtchStaDS    WBtchSta
     C                   OUT       SCDRSTAT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJSQN - Move Journal Sequence Number Processed to Array     *
      *                                                               *
      *****************************************************************
 
     C     SRJSQN        BEGSR
 
     C                   IF        WBtchUsd(1) = 'Y'
     C     1             SETLL     SCJSN0PD
     C                   READ      SCJSN0PD                               34
     C                   IF        *IN34 = *ON
     C                   EVAL      DBASE = 03
     C                   EVAL      DBFILE = 'SCJSN0PD'
     C                   EVAL      DBKEY = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WJrnSeqNo(1) = JSLSEQ
     C                   ENDIF
 
     C                   IF        WBtchUsd(2) = 'Y'
     C     1             SETLL     SCJSN1PD
     C                   READ      SCJSN1PD                               34
     C                   IF        *IN34 = *ON
     C                   EVAL      DBASE = 04
     C                   EVAL      DBFILE = 'SCJSN1PD'
     C                   EVAL      DBKEY = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WJrnSeqNo(2) = JSLSEQ
     C                   ENDIF
 
     C                   IF        WBtchUsd(3) = 'Y'
     C     1             SETLL     SCJSN2PD
     C                   READ      SCJSN2PD                               34
     C                   IF        *IN34 = *ON
     C                   EVAL      DBASE = 05
     C                   EVAL      DBFILE = 'SCJSN2PD'
     C                   EVAL      DBKEY = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WJrnSeqNo(3) = JSLSEQ
     C                   ENDIF
 
     C                   IF        WBtchUsd(4) = 'Y'
     C     1             SETLL     SCJSN3PD
     C                   READ      SCJSN3PD                               34
     C                   IF        *IN34 = *ON
     C                   EVAL      DBASE = 06
     C                   EVAL      DBFILE = 'SCJSN3PD'
     C                   EVAL      DBKEY = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WJrnSeqNo(4) = JSLSEQ
     C                   ENDIF
 
     C                   IF        WBtchUsd(5) = 'Y'
     C     1             SETLL     SCJSN4PD
     C                   READ      SCJSN4PD                               34
     C                   IF        *IN34 = *ON
     C                   EVAL      DBASE = 07
     C                   EVAL      DBFILE = 'SCJSN4PD'
     C                   EVAL      DBKEY = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WJrnSeqNo(5) = JSLSEQ
     C                   ENDIF
 
     C                   IF        WBtchUsd(6) = 'Y'
     C     1             SETLL     SCJSN5PD
     C                   READ      SCJSN5PD                               34
     C                   IF        *IN34 = *ON
     C                   EVAL      DBASE = 08
     C                   EVAL      DBFILE = 'SCJSN5PD'
     C                   EVAL      DBKEY = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WJrnSeqNo(6) = JSLSEQ
     C                   ENDIF
 
     C                   IF        WBtchUsd(7) = 'Y'
     C     1             SETLL     SCJSN6PD
     C                   READ      SCJSN6PD                               34
     C                   IF        *IN34 = *ON
     C                   EVAL      DBASE = 09
     C                   EVAL      DBFILE = 'SCJSN6PD'
     C                   EVAL      DBKEY = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WJrnSeqNo(7) = JSLSEQ
     C                   ENDIF
 
     C                   IF        WBtchUsd(8) = 'Y'
     C     1             SETLL     SCJSN7PD
     C                   READ      SCJSN7PD                               34
     C                   IF        *IN34 = *ON
     C                   EVAL      DBASE = 10
     C                   EVAL      DBFILE = 'SCJSN7PD'
     C                   EVAL      DBKEY = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WJrnSeqNo(8) = JSLSEQ
     C                   ENDIF
 
     C                   IF        WBtchUsd(9) = 'Y'
     C     1             SETLL     SCJSN8PD
     C                   READ      SCJSN8PD                               34
     C                   IF        *IN34 = *ON
     C                   EVAL      DBASE = 11
     C                   EVAL      DBFILE = 'SCJSN8PD'
     C                   EVAL      DBKEY = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WJrnSeqNo(9) = JSLSEQ
     C                   ENDIF
 
     C                   IF        WBtchUsd(10) = 'Y'
     C     1             SETLL     SCJSN9PD
     C                   READ      SCJSN9PD                               34
     C                   IF        *IN34 = *ON
     C                   EVAL      DBASE = 12
     C                   EVAL      DBFILE = 'SCJSN9PD'
     C                   EVAL      DBKEY = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WJrnSeqNo(10) = JSLSEQ
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLSNI - Move Latest Sequence Number on ICJRN to Display     *
      *           Field                                               *
      *                                                               *
      *****************************************************************
 
     C     SRLSNI        BEGSR
 
     C                   EVAL      PJourn = 'ICJRN'
     C                   EVAL      PFile = '*ALLFILE'
     C                   EVAL      PMember = *BLANKS
     C                   EVAL      PFrEnt = '*LAST'
     C                   EVAL      PToEnt = '*LAST'
     C                   EVAL      PRtnSeqNbr = *BLANKS
 
     C                   CALL      'ZACRTVSQN'
     C                   PARM                    PJourn
     C                   PARM                    PFile
     C                   PARM                    PMember
     C                   PARM                    PFrEnt
     C                   PARM                    PToEnt
     C                   PARM                    PRtnSeqNbr
 
     C                   MOVEL     PRtnSeqNbr    #0LSNI
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROCESS - Process Screen Input Routine                     *
      *                                                               *
      *****************************************************************
 
     C     SRPROCESS     BEGSR
 
     C                   IF        *IN42 = *ON
 
     C                   READC     SC000050S0                             33
 
     C                   IF        *IN33 = *OFF
     C                   EVAL      WError = 'N'
     C                   ENDIF
 
     C                   DOW       *IN33 = *OFF
 
     C                   EVAL      *IN24 = *OFF
 
      ** Action code should be 'S' or 'T'
 
     C                   IF        #0ACTN <> 'S' AND #0ACTN <> 'T' AND
     C                             #0ACTN <> *BLANKS
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'DRM0001'
     C                   EXSR      SRZASNMS
     C                   ENDIF
 
     C
     C                   MOVE      #0BACH        WBachNum
     C                   EVAL      WNum = WBachNum + 1
     C                   EVAL      PObject = WPFile(WNum)
     C                   EVAL      PObjectType = '*FILE'
 
      ** Action code 'S' is invalid if the replication job is running
      ** or has ended.
 
     C                   IF        #0ACTN = 'S'
 
     C                   CALL      'ZACCHKALC'
     C                   PARM                    PObject
     C                   PARM                    PObjectType
     C                   PARM      *BLANKS       PFlag
 
     C                   IF        PFlag = 'Y' OR WBtchSta(WNum) = 'E'
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'DRM0002'
     C                   EXSR      SRZASNMS
     C                   ENDIF
     C                   ENDIF
 
      ** Action code 'T' is valid only if the replication job is running
 
     C                   IF        #0ACTN = 'T'
     C                   CALL      'ZACCHKALC'
     C                   PARM                    PObject
     C                   PARM                    PObjectType
     C                   PARM      *BLANKS       PFlag
 
     C                   IF        PFlag = 'N'
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'DRM0003'
     C                   EXSR      SRZASNMS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #0ACTN = *BLANKS
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   ELSE
     C                   EVAL      *IN45 = *ON
     C                   ENDIF
     C                   EVAL      *IN23 = *OFF
     C                   UPDATE    SC000050S0
 
     C                   READC     SC000050S0                             33
 
     C                   ENDDO
 
      ** If Action code is valid, process Action code
 
     C                   IF        WError <> 'Y'
     C                   EXSR      SRACTNCDE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMOVESFL - Move Array Fields to Subfile Routine             *
      *                                                               *
      *****************************************************************
 
     C     SRMOVESFL     BEGSR
 
      ** Move Batch Number field.
     C
     C                   EVAL      WBachNum = WNum - 1
     C                   MOVE      WBachNum      #0BACH
 
      ** Move Logged Status field.
 
     C                   IF        WBtchUsd(WNum) = 'Y'
 
     C                   SELECT
 
     C                   WHEN      WBtchSta(WNum) = 'T'
     C                   EVAL      PMsgDNb = 'DRM0010'
 
     C                   WHEN      WBtchSta(WNum) = 'E'
     C                   EVAL      PMsgDNb = 'DRM0011'
 
     C                   WHEN      WBtchSta(WNum) = 'F'
     C                   EVAL      PMsgDNb = 'DRM0007'
 
     C                   WHEN      WBtchSta(WNum) = *BLANKS
 
     C                   MOVE      #0BACH        WBachNum
     C                   EVAL      WNum = WBachNum + 1
     C                   EVAL      PObject = WPFile(WNum)
     C                   EVAL      PObjectType = '*FILE'
 
     C                   CALL      'ZACCHKALC'
     C                   PARM                    PObject
     C                   PARM                    PObjectType
     C                   PARM      *BLANKS       PFlag
 
     C                   IF        PFlag = 'Y'
     C                   EVAL      PMsgDNb = 'DRM0009'
     C                   ELSE
     C                   EVAL      PMsgDNb = 'DRM0006'
     C                   ENDIF
 
     C                   ENDSL
 
      ** Move Last Journal Sequence No. Processed.
 
     C                   EVAL      #0LJSQ = WJrnSeqNo(WNum)
     C                   EVAL      *IN23 = *OFF
 
     C                   ELSE
 
      ** Batch is not used.
 
     C                   EVAL      PMsgDNb = 'DRM0008'
     C                   EVAL      *IN23 = *ON
     C                   ENDIF
 
     C                   EXSR      SRRTVTXT
     C                   EVAL      #0STAT = PMsgTxt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRTVTXT - Retrieve Text from Message File                   *
      *                                                               *
      *****************************************************************
 
     C     SRRTVTXT      BEGSR
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMsgDNb
     C                   PARM      'SDUSRMSG'    PMsgNm
     C                   PARM      *BLANKS       PMsgTxt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLRSFLD - Clear Subfile Fields Routine                     *
      *                                                               *
      *****************************************************************
 
     C     SRCLRSFLD     BEGSR
 
     C                   EVAL      #0ACTN = *BLANKS
     C                   EVAL      #0BACH = *BLANKS
     C                   EVAL      #0STAT = *BLANKS
     C                   EVAL      #0LJSQ = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACTNCDE - Process Action Code Routine                      *
      *                                                               *
      *****************************************************************
 
     C     SRACTNCDE     BEGSR
 
     C                   EVAL      *IN33 = *OFF
 
     C                   READC     SC000050S0                             33
 
     C                   DOW       *IN33 = *OFF
 
     C                   SELECT
 
      ** Start replication job
 
     C                   WHEN      #0ACTN = 'S'
 
     C                   EXSR      SRClrStat
 
     C                   EVAL      Command = WQcmd(1)
     C                   EVAL      WCmd1 = #0BACH
     C                   EVAL      CommandLen = 29
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
 
     C                   EVAL      Command = WQcmd(2)
     C                   EVAL      WCmd5 = WQcmd(3)
 
     C                   IN        SC24X7
     C                   EVAL      WCmd3 = S1SUPP
     C                   EVAL      WCmd4 = S1SUPP
     C                   EVAL      CommandLen = 173
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
 
 
     C                   EVAL      PZMsgID = 'DRM0004'
     C                   EXSR      SRZASNMS
 
      ** Teminate replication job
 
     C                   WHEN      #0ACTN = 'T'
 
      ** Find the Physical File for the Batch
 
     C                   EVAL      WBach = #0BACH
     C     WBach         SETLL     SCFDTLL4
     C     WBach         READE     SCFDTLL4                               32
 
     C                   DOW       *IN32 = *OFF AND FDPHYF = 'SDBANKPD'
     C     WBach         READE     SCFDTLL4                               32
     C                   ENDDO
 
     C                   IF        *IN32 = *ON
     C                   EVAL      DBASE = 02
     C                   EVAL      DBFILE = 'SCFDTLL4'
     C                   EVAL      DBKEY = WBach
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      Command = WQcmd(4)
     C                   EVAL      WCmd2 = FDPHYF
     C**********         EVAL      CommandLen = 63                                            CSC048
     C                   EVAL      CommandLen = 75                                            CSC048
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
 
     C                   EVAL      PZMsgID = 'DRM0005'
     C                   EXSR      SRZASNMS
 
     C                   ENDSL
 
     C                   READC     SC000050S0                             33
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrStat - Reset SCDRSTAT                                   *
      *                                                               *
      *****************************************************************
 
     C     SRClrStat     BEGSR
 
     C     *LOCK         IN        SCDRSTAT
 
     C                   SELECT
     C                   WHEN      #0BACH = '0'
     C                   IF        DASTA0 <> 'E'
     C                   EVAL      DASTA0 = ' '
     C                   ENDIF
 
     C                   WHEN      #0BACH = '1'
     C                   IF        DASTA1 <> 'E'
     C                   EVAL      DASTA1 = ' '
     C                   ENDIF
 
     C                   WHEN      #0BACH = '2'
     C                   IF        DASTA2 <> 'E'
     C                   EVAL      DASTA2 = ' '
     C                   ENDIF
 
     C                   WHEN      #0BACH = '3'
     C                   IF        DASTA3 <> 'E'
     C                   EVAL      DASTA3 = ' '
     C                   ENDIF
 
     C                   WHEN      #0BACH = '4'
     C                   IF        DASTA4 <> 'E'
     C                   EVAL      DASTA4 = ' '
     C                   ENDIF
 
     C                   WHEN      #0BACH = '5'
     C                   IF        DASTA5 <> 'E'
     C                   EVAL      DASTA5 = ' '
     C                   ENDIF
 
     C                   WHEN      #0BACH = '6'
     C                   IF        DASTA6 <> 'E'
     C                   EVAL      DASTA6 = ' '
     C                   ENDIF
 
     C                   WHEN      #0BACH = '7'
     C                   IF        DASTA7 <> 'E'
     C                   EVAL      DASTA7 = ' '
     C                   ENDIF
 
     C                   WHEN      #0BACH = '8'
     C                   IF        DASTA8 <> 'E'
     C                   EVAL      DASTA8 = ' '
     C                   ENDIF
 
     C                   WHEN      #0BACH = '9'
     C                   IF        DASTA9 <> 'E'
     C                   EVAL      DASTA9 = ' '
     C                   ENDIF
     C                   ENDSL
     C                   OUT       SCDRSTAT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRREFRESH - Initialise the Selection Fields to Blanks        *
      *                                                               *
      *****************************************************************
 
     C     SRREFRESH     BEGSR
 
     C                   EVAL      #0ACTN = *BLANKS
     C                   EVAL      WError = 'N'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREND - End Program Routine                                  *
      *                                                               *
      *****************************************************************
 
     C     SREND         BEGSR
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZASNMS - Message Handling Routine                          *
      *                                                               *
      *****************************************************************
 
     C     SRZASNMS      BEGSR
 
     C                   CALLB     'ZAMSGTOSCN'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
     C                   PARM                    PZMsgDta
     C                   PARM                    PZMsgPgm
     C                   PARM                    PZMsgMod
     C                   PARM                    PZMsgProc
 
     C                   EVAL      PZMsgID = *BLANKS
     C                   EVAL      PZMsgDta = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBMOD = PSProcMod
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBASE = *ZERO
     C                   OUT       LDA
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      *BLANKS       DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBASE = 01
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*CALL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise message fields
 
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgPgm = PSProcPgm
     C                   EVAL      PZMsgMod = PSProcMod
     C                   EVAL      PZMsgProc = PSProcName
 
      ** Initialise screen fields
 
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #1PGMQ = PSProcPgm
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0WSID = PsJobName
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  WQcmd
CALL PGM(SCC000605) PARM(' ')
SBMJOB CMD(CALL PGM(SCC000606 )) JOB(DRMONITOR ) JOBD(  XLIB/DRJOBD) JOBQ(  XLIB/DRJOBQ) OUTQ(*JOBD)
PRTDEV(*JOBD) INLLIBL(*JOBD) LOGCLPGM(*YES) LOG(4 0 *SECLVL) USER(*JOBD)
SNDJRNE JRN(ICJRN) TYPE('EG') ENTDTA(SC000050) FILE(          ) FORCE(*YES)
DSPMSG MSGQ(SC24X7Q) OUTPUT(*PRINT)
CHGSPLFA FILE(QPDSPMSG) SPLNBR(*LAST) OUTQ(M24X7) SAVE(*YES)
**  WPFile
SCJSN0PD
SCJSN1PD
SCJSN2PD
SCJSN3PD
SCJSN4PD
SCJSN5PD
SCJSN6PD
SCJSN7PD
SCJSN8PD
SCJSN9PD
