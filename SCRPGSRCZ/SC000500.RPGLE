     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Get Latest Journal Sequence Number')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000500 - Get Latest Journal Entry Sequence Number          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSC022             Date 24Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    80         Chain fail in data replication files            *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR     - Program exception error routine                   *
      * *INZSR    - Initialise                                        *
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

      ** Data Replication Journal Sequence Number files
     FSCJSN0PD  UF A E             DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
     FSCJSN1PD  UF A E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D1)
     F                                     COMMIT
     FSCJSN2PD  UF A E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D2)
     F                                     COMMIT
     FSCJSN3PD  UF A E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D3)
     F                                     COMMIT
     FSCJSN4PD  UF A E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D4)
     F                                     COMMIT
     FSCJSN5PD  UF A E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D5)
     F                                     COMMIT
     FSCJSN6PD  UF A E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D6)
     F                                     COMMIT
     FSCJSN7PD  UF A E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D7)
     F                                     COMMIT
     FSCJSN8PD  UF A E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D8)
     F                                     COMMIT
     FSCJSN9PD  UF A E             DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCJSN0D0:SCJSN0D9)
     F                                     COMMIT

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Copyright array, LDA layout, etc.
     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D WArrCmtJob      S             10A   DIM(10)                                            CSC022
      ** Array for Commitment Job Names                                                       CSC022
                                                                                              CSC022
      ** Data structure for SCCMTJOB data area                                                CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITNO                1      3S 0                                                    CSC022
     D  COMITJOBS              4    103                                                       CSC022
                                                                                              CSC022
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC022
      ** First DS for Access programs - short data structure                                  CSC022
                                                                                              CSC022
      ** External DS for API ICD                                                              CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PBatchNum       S              1
     D PSeqNum         S             10A
     D WSeq            S             10A   INZ('0000000001')
     D ReturnCd        S             10A
     D PSARD           S              6A                                                      CSC022
     D CSC022          S              1A   Inz                                                CSC022
     D WSkipCommit     S              1A   Inz                                                CSC022
     D WPtr            S              2S 0 Inz                                                CSC022

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Select file to be processed
     C                   SELECT

     C                   WHEN      PBatchNum = '0'
     C                   OPEN      SCJSN0PD
     C     1             CHAIN     SCJSN0PD                           80
     C                   IF        *IN80 = '0'
     C                   EVAL      PSeqNum = JSLSEQ
     C                   ELSE
     C                   EVAL      JSLSEQ = Wseq
     C                   WRITE     SCJSN0D0
     C                   ENDIF
     C                   CLOSE     SCJSN0PD

     C                   WHEN      PBatchNum = '1'
     C                   OPEN      SCJSN1PD
     C     1             CHAIN     SCJSN1PD                           80
     C                   IF        *IN80 = '0'
     C                   EVAL      PSeqNum = JSLSEQ
     C                   ELSE
     C                   EVAL      JSLSEQ = Wseq
     C                   WRITE     SCJSN0D1
     C                   ENDIF
     C                   CLOSE     SCJSN1PD

     C                   WHEN      PBatchNum = '2'
     C                   OPEN      SCJSN2PD
     C     1             CHAIN     SCJSN2PD                           80
     C                   IF        *IN80 = '0'
     C                   EVAL      PSeqNum = JSLSEQ
     C                   ELSE
     C                   EVAL      JSLSEQ = Wseq
     C                   WRITE     SCJSN0D2
     C                   ENDIF
     C                   CLOSE     SCJSN2PD

     C                   WHEN      PBatchNum = '3'
     C                   OPEN      SCJSN3PD
     C     1             CHAIN     SCJSN3PD                           80
     C                   IF        *IN80 = '0'
     C                   EVAL      PSeqNum = JSLSEQ
     C                   ELSE
     C                   EVAL      JSLSEQ = Wseq
     C                   WRITE     SCJSN0D3
     C                   ENDIF
     C                   CLOSE     SCJSN3PD

     C                   WHEN      PBatchNum = '4'
     C                   OPEN      SCJSN4PD
     C     1             CHAIN     SCJSN4PD                           80
     C                   IF        *IN80 = '0'
     C                   EVAL      PSeqNum = JSLSEQ
     C                   ELSE
     C                   EVAL      JSLSEQ = Wseq
     C                   WRITE     SCJSN0D4
     C                   ENDIF
     C                   CLOSE     SCJSN4PD

     C                   WHEN      PBatchNum = '5'
     C                   OPEN      SCJSN5PD
     C     1             CHAIN     SCJSN5PD                           80
     C                   IF        *IN80 = '0'
     C                   EVAL      PSeqNum = JSLSEQ
     C                   ELSE
     C                   EVAL      JSLSEQ = Wseq
     C                   WRITE     SCJSN0D5
     C                   ENDIF
     C                   CLOSE     SCJSN5PD

     C                   WHEN      PBatchNum = '6'
     C                   OPEN      SCJSN6PD
     C     1             CHAIN     SCJSN6PD                           80
     C                   IF        *IN80 = '0'
     C                   EVAL      PSeqNum = JSLSEQ
     C                   ELSE
     C                   EVAL      JSLSEQ = Wseq
     C                   WRITE     SCJSN0D6
     C                   ENDIF
     C                   CLOSE     SCJSN6PD

     C                   WHEN      PBatchNum = '7'
     C                   OPEN      SCJSN7PD
     C     1             CHAIN     SCJSN7PD                           80
     C                   IF        *IN80 = '0'
     C                   EVAL      PSeqNum = JSLSEQ
     C                   ELSE
     C                   EVAL      JSLSEQ = Wseq
     C                   WRITE     SCJSN0D7
     C                   ENDIF
     C                   CLOSE     SCJSN7PD

     C                   WHEN      PBatchNum = '8'
     C                   OPEN      SCJSN8PD
     C     1             CHAIN     SCJSN8PD                           80
     C                   IF        *IN80 = '0'
     C                   EVAL      PSeqNum = JSLSEQ
     C                   ELSE
     C                   EVAL      JSLSEQ = Wseq
     C                   WRITE     SCJSN0D8
     C                   ENDIF
     C                   CLOSE     SCJSN8PD

     C                   WHEN      PBatchNum = '9'
     C                   OPEN      SCJSN9PD
     C     1             CHAIN     SCJSN9PD                           80
     C                   IF        *IN80 = '0'
     C                   EVAL      PSeqNum = JSLSEQ
     C                   ELSE
     C                   EVAL      JSLSEQ = Wseq
     C                   WRITE     SCJSN0D9
     C                   ENDIF
     C                   CLOSE     SCJSN9PD

     C                   ENDSL

      ** Return to calling program

      *                                                                                       CSC022
      ** COMMIT data if either of the following is true:                                      CSC022
      ** 1. Commitment Control Changes switch is OFF; or                                      CSC022
      ** 2. Commitment Control Changes switch is ON and                                       CSC022
      ** this particular job is not included in the                                           CSC022
      ** commitment jobs in data area SCCMTJOB                                                CSC022
      *                                                                                       CSC022
     C                   If        CSC022  = 'N' or                                           CSC022
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                       CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   EVAL      *INLR = '1'

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Entry parameter, batch number

     C     *ENTRY        PLIST
     C                   PARM                    ReturnCd
     C                   PARM                    PBatchNum
     C                   PARM                    PSeqNum
      *
      ** Initialize SAR work flag and Commit flag                                             CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022      = 'N'                                          CSC022
     C                   Eval      WSkipCommit = ' '                                          CSC022
      *                                                                                       CSC022
      ** Determine if Commitment Control Changes for MidasPlus                                CSC022
      ** (CSC022) is installed                                                                CSC022
      *                                                                                       CSC022
     C                   Call      'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      **                                                                                      CSC022
      *                                                                                       CSC022
      ** If feature is on, set up SAR work flag                                               CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
     C                   Eval      CSC022      = 'Y'                                          CSC022
     C                   Eval      WSkipCommit = 'N'                                          CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        COMITNO  <> 0                                              CSC022
     C                   MoveA     COMITJOBS     WArrCmtJob                                   CSC022
     C                   Eval      WPtr = %LookUp(PSJobName:WArrCmtJob)                       CSC022
     C                   If        WPtr > 0                                                   CSC022
     C                   Eval      WSkipCommit = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** else, database error (return code other than *NRF)                                   CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> '*NRF   '                                         CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   MoveL     'SC000500'    DBPGM                                        CSC022
     C                   MoveL     'SCSARDPD'    DBFILE                                       CSC022
     C                   MoveL     'CSC022'      DBKEY                          ************* CSC022
     C                   Z-Add     900           DBASE                          * DBASE 900 * CSC022
     C                   Out       LDA                                          ************* CSC022
     C                   ExSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
                                                                                              CSC022
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        RunBefore = *BLANK
     C                   DUMP
      *
      ** ROLLBACK data if either of the following is true:                                    CSC022
      ** 1. Commitment Control Changes switch is OFF; or                                      CSC022
      ** 2. Commitment Control Changes switch is ON and                                       CSC022
      ** this particular job is not included in the                                           CSC022
      ** commitment jobs in data area SCCMTJOB                                                CSC022
      *                                                                                       CSC022
     C                   If        CSC022  = 'N'                                              CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkipCommit = 'N'                                          CSC022
     C                   ROLBK                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EVAL      ReturnCd = '*ERROR'
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      RunBefore = 'Y'
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
