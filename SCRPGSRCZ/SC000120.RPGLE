     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Update User Report Title of PEA Bank Dtls')   *
      *****************************************************************
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000120 - Update User Report Title of PEA Bank Details      *
      *                                                               *
      *  Function:  This program updates User Report Title of PEA     *
      *             system's SDBANKPD file                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1009800 *CREATE  Date 20Nov12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1009800 - Report field in SDBANKPD of PEA system should    *
      *              be restored to its original value                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR - Initialisation                                      *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Midas SC Mutually Exclusive objects
     FSCPURTPD  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(P1:2)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Access object parameters
     D PRetCode        S              7A
     D POption         S              7A
 
      ** Work variables
     D WRun            S              1A
     D/COPY ZACPYSRC,STD_D_SPEC
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Get backed-up User Report Title data
      *
     C                   READ      SCPURTPD                               90
     C                   IF        *IN90 = *ZERO AND P1URPT <> *BLANKS
      *
      ** Read Bank ICD file
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POption
     C                   EVAL      DBase = 1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Update Bank ICD file w/ PEA User Report Title
      *
     C                   EVAL      BJURPT = P1URPT
      *
     C                   CALL      'AOBANKU0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*UPDATE'     POption
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POption
     C                   EVAL      DBase = 2
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Close Bank ICD file
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FREE  '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POption
     C                   EVAL      DBase = 3
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Set up Local Data Area
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = *BLANKS
     C                   EVAL      DBKey = *BLANKS
     C                   EVAL      DBPgm = *BLANKS
     C                   EVAL      DBPgm = 'SC000120'
     C                   EVAL      DBase = *ZERO
     C                   OUT       LDA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2012
