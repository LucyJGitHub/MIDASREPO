     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Complete Batches from APOUTPUTPD')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL998004 - Complete Batches from APOUTPUTPD                  *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD059435 *CREATE   Date 16Feb22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059435 - STP Batch entered Midas as held with an error     *
      *             in the header record                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    98         Read GLJENSL1 indicator                         *
      *    99         Read/Chain GLBTCSL0 and GLJENHL3                *
      *    LR         End of program                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * CHK_MID_CCYTOT - Check Midas Currency Total                   *
      * GET_MID_HEADER - Get Midas Batch Header                       *
      * PRC_FAILED     - Process Failed                               *
      * PRC_VALIDATED  - Process Validated Batch                      *
      * UPD_MID_HEADER - Update Midas Batch Header                    *
      * UPDT_GLBTCS    - Update Batch Status in GLBTCSPD              *
      * *PSSR          - Error processing                             *
      * *INZSR         - Initialise                                   *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
     FGLBTCSL0  UF   E           K DISK    INFSR(*PSSR)
     FGLJENHL3  IF   E           K DISK    INFSR(*PSSR)
     FGLJENHL0  UF   E           K DISK    INFSR(*PSSR)
     FGLJENSL1  IF   E           K DISK    INFSR(*PSSR)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *********************************************************************
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
      **Read batches for today
      *
     C     GLBTCSK       SETLL     GLBTCSD0
     C     GLBTCSK       READE     GLBTCSD0                               99
     C                   DOW       *IN99=*off
      *
      ** If Midas batch header not updated for 'failed' or 'passed' batch
      *
     C                   IF        MIBHUPD <> 'Y' and
     C                             (STATUS = 'F' OR STATUS = 'P')
      *
      ** If batch failed validation, process a failed batch
      ** If batch passed validation, process a validated batch
      *
     C                   IF        STATUS = 'F'
     C                   EXSR      PRC_FAILED
     C                   ELSE
     C                   EXSR      PRC_VALIDATED
     C                   ENDIF
     C                   ENDIF
      *
      ** Read batches for today
      *
     C     GLBTCSK       READE     GLBTCSD0                               99
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * PRC_FAILED - Process Failed                                   *
      *                                                               *
      *****************************************************************
     C     PRC_FAILED    BEGSR
      *
      ** Update 'Midas batch header updated' on status record
      *
     C                   EXSR      UPDT_GLBTCS
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * PRC_VALIDATED - Process Validated Batch                       *
      *                                                               *
      *****************************************************************
     C     PRC_VALIDATED BEGSR
      *
      ** Get Midas batch header
      *
     C                   MOVEL     ' '           Batch_Hdr         1
     C                   EXSR      GET_MID_HEADER
      *
      ** If Midas batch header not present, exit
      *
     C                   IF        Batch_Hdr <> 'Y'
     C                   GOTO      EPRC_VALIDATED
     C                   ENDIF
      *
      ** If the Midas batch is accepted OR
      ** If Midas batch header totals match value totals derived from APOUTPUTPD
      ** Update 'Midas batch header updated' on status record, then exit
      *
     C                   IF        BRBTSF = 'A' OR
     C                             (BRHIIN = EXTHIIN and
     C                              BRHDIN = EXTHDIN)
     C                   EXSR      UPDT_GLBTCS
     C                   GOTO      EPRC_VALIDATED
     C                   ENDIF
      *
      ** Check if Midas batch currency DR and CR totals balance
      *
     C                   EXSR      CHK_MID_CCYTOT
      *
      ** Update Midas batch header with value totals derived
      ** Update 'Midas batch header updated' on status record
      *
     C                   EXSR      UPD_MID_HEADER
     C                   EXSR      UPDT_GLBTCS
      *
      ** Submit balance if batch currency DR and CR totals correct
      ** and if calculated total value = input total value
      *
     C                   IF        #CcysBal = 'Y' and
     C                             BRHIIN = BRHICC and
     C                             BRHDIN = BRHDCC
     C                   CALL      'GLSBMBCH'
     C                   PARM      *BLANK        PRTCD             7
     C                   PARM      BRBTNB        PBTNB             3
     C                   ENDIF
      *
     C     EPRC_VALIDATEDENDSR
      *****************************************************************
      *                                                               *
      * GET_MID_HEADER - Get Midas Batch Header                       *
      *                                                               *
      *****************************************************************
     C     GET_MID_HEADERBEGSR
      *
     C     GLJENH3K      CHAIN     @BRREMA                            99
     C                   IF        *IN99 = *OFF
     C                   MOVEL     'Y'           Batch_Hdr         1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * UPD_MID_HEADER - Update Midas Batch Header                    *
      *                                                               *
      *****************************************************************
     C     UPD_MID_HEADERBEGSR
      *
     C     GLJENH0K      CHAIN     @BRREAG                            99
     C                   EVAL      BRHIIN = EXTHIIN
     C                   EVAL      BRHDIN = EXTHDIN
     C                   EXCEPT    BTH
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * UPDT_GLBTCS - Update Batch Status in GLBTCSPD                 *
      *                                                               *
      *****************************************************************
     C     UPDT_GLBTCS   BEGSR
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    COMTMST
     C                   EVAL      MIBHUPD = 'Y'                                Midas Batch updated
     C                   EXCEPT    STS
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * CHK_MID_CCYTOT - Check Midas Currency Total                   *
      *                                                               *
      *****************************************************************
     C     CHK_MID_CCYTOTBEGSR
      *
     C                   MOVEL     *BLANKS       #CYCD             3
     C                   Z-ADD     0             #NOCCYRECS        3 0
     C                   Z-ADD     0             #CRDTOT          15 0
     C                   Z-ADD     0             #DEBTOT          15 0
     C                   MOVEL     'Y'           #CcysBal          1
      *
      ** Read through Midas batch currency total records
      *
     C                   MOVEL     *BLANKS       KCYCD             3
     C                   MOVEL     *BLANKS       KBRCD             3
     C     GLJENSK       SETLL     GLJENSL1
     C     BRBTNB        READE     GLJENSL1                               98
      *
      ** Check if Midas currency DR and CR totals balance
      *
     C     *IN98         DOWEQ     *OFF
     C     #CcysBal      ANDEQ     'Y'
      *
     C                   ADD       1             #NOCCYRECS
      *
      ** Accumulate debit and credit totals for the same currency
      *
     C     #CYCD         IFEQ      BSCYCD
     C                   ADD       BSCRTT        #CRDTOT
     C                   ADD       BSDBTT        #DEBTOT
     C                   ELSE
      *
      ** ON change of currency, compare the debit and credit total
      ** of the previous currency
      *
     C     #CRDTOT       IFNE      #DEBTOT
     C                   MOVEL     'N'           #CcysBal
     C                   ELSE
     C                   Z-ADD     BSCRTT        #CRDTOT
     C                   Z-ADD     BSDBTT        #DEBTOT
     C                   MOVEL     BSCYCD        #CYCD
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     BRBTNB        READE     GLJENSL1                               98
     C                   ENDDO
      *
      ** Check last currency
      *
     C     #NOCCYRECS    IFEQ      0
     C     #NOCCYRECS    ORNE      0
     C     #CRDTOT       ANDNE     #DEBTOT
     C                   MOVEL     'N'           #CcysBal
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /SPACE 5
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
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   MOVE      ' '           W#RUN             1
      *
      ** Key lists
      *
     C     GLBTCSK       KLIST
     C                   KFLD                    BJMRDT
      *
     C     GLJENH3K      KLIST
     C                   KFLD                    DDFOID
      *
     C     GLJENH0K      KLIST
     C                   KFLD                    BRBTNB
      *
     C     GLJENSK       KLIST
     C                   KFLD                    BRBTNB
     C                   KFLD                    KCYCD
     C                   KFLD                    KBRCD
      *
     C                   MOVEL     *blank        I#ERMS           50
      *
     C                   ENDSR
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
     C     *PSSR         BEGSR
      *
     C                   IF        W#RUN = *blank
     C                   EVAL      W#RUN = 'Y'
     C                   DUMP
     C                   EVAL      I#RTCD = '*ERROR*'
     C                   ENDIF
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
     OGLBTCSD0  E            STS
     O                       COMTMST
     O                       MIBHUPD
     O@BRREAG   E            BTH
     O                       BRHIIN
     O                       BRHDIN
