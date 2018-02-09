     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Exemption Threshold History Update')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SD000813 - Midas SD Exemption Threshold History Update       *
      *                                                               *
      *  Function: This program drops records from the threshold      *
      *            history file with last action date less than or    *
      *            equal to run date minus retention period (number   *
      *            of months * 31)                                    *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG23660A          Date 03Jun09               *
      *                 BUG23660           Date 17Apr09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23660A - Exemption Threshold history does not clear down  *
      *             due to filter of customer number with multiple    *
      *             records.                                          *
      *  BUG23660 - Exemption Threshold history does not clear down   *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR - Initialise                                          *
      *  *PSSR - Error processing                                     *
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
      *
      ** SD Withholding tax ICD
      *
     FSDSTAXPD  IF   E             DISK    INFSR(*PSSR)
      *
      ** Threshold History file
      *
     FSDTHRHL3  UF   E           K DISK    INFSR(*PSSR)
      *
      ** SD Exemption Threshold History Update - Audit
      *
     FSD000813AUO    E             PRINTER
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs:                             ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,and the following
      ** named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Externally described DS for Bank details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** First DS for Access programs - short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D WCtld           S              5P 0
     D*WCust****       S              6A                                                   BUG23660A
     D WRun            S              1A
     D PRtcd           S             10A
     D POptn           S              7A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Read the Exemption Threshold History File
      *
     C     *LOVAL        SETLL     SDTHRHL3
     C                   READ      SDTHRHL3
      *
     C                   DOW       NOT %EOF(SDTHRHL3)
     C                   EVAL      COUNT = COUNT + 1
      *
      ** If Change date is Less or equal than control date
      *
     C                   IF        TEACTD <= WCtld
      *
      ** First record : Previous customer is different of Read customer
      *
     C**********         IF        WCust <> TECUST                                         BUG23660A
      *
      ***Delete if Approval date and value date are ZERO                                    BUG23660
      ***                                                                                   BUG23660
     C**********         IF        TETRAD = *ZEROS AND                                      BUG23660
     C**********                   TETRVD = *ZEROS                                          BUG23660
     C**********         EVAL      DROP = DROP + 1                                          BUG23660
     C**********         DELETE    SDTHRHD0                                                 BUG23660
     C**********         ENDIF                                                              BUG23660
      ***                                                                                   BUG23660
     C**********         ELSE                                                               BUG23660
      *
      ** Not first record but Action date Less or equal than retention
      ** Limit
      *
     C                   EVAL      DROP = DROP + 1
     C                   DELETE    SDTHRHD0
      *
     C*********          ENDIF                                                             BUG23660A
     C                   ENDIF
      *
      ** Save previous customer read
      *
     C*********          EVAL      WCust = TECUST                                          BUG23660A
      *
      ** Read next record
      *
     C                   READ      SDTHRHL3
      *
     C                   ENDDO
      *
      ** Write audit report (number of record read and drop)
      *
     C                   WRITE     SD000813R0
     C                   WRITE     SD000813R1
      *
      ** Normal end
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Access Witholding tac I.C.D
      *
     C     1             SETLL     SDSTAXPD
     C                   READ      SDSTAXPD
     C                   IF        NOT %FOUND(SDSTAXPD)
      *
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBase = 001
     C                   EVAL      DBfile = 'SDSTAXPD'
     C                   EVAL      DBkey = 'Wtax ICD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set Retention date : Runday No From SDBANKPD + Retention
      ** period (nbr of month * 31)
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBfile = 'SDBANKPD'
     C                   EVAL      DBkey  = POptn
     C                   EVAL      DBase  = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      WCtld = TXTHRP * 31
     C                   EVAL      WCtld = BJRDNB - WCtld
      *
      ** Setup of working fields
      *
     C**********         EVAL      WCust = *BLANKS                                         BUG23660A
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
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   WRITE     SD000813R0
     C                   WRITE     SD000813R2
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
