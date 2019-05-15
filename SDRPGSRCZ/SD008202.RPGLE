     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Take on of Stamp Tax Cheques to be Paid')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD008202 - Midas Take on of Stamp Tax Cheques to be Paid     *
      *                                                               *
      *  (C) Copyright Finastra International Limited 2011            *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR821872 *CREATE   Date 03Sep11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR821872 - Component FTC0610 00001 failed                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas FT Cheques to be Paid
     FCQPADDL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas FT Stamp Tax Cheques to be Paid Ext File
     FCQPACQL0  UF A E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Stamp Tax Customer Extension File
     FSDCUSQL0  IF A E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Branches Extension Acceptance File
     FSDBRCHEXL0IF A E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D @RUN            S              1A
     D @CUST           S              6A
     D @@CCY           S              3A
     D @@TYP1          S              1A
     D @@ACC1          S             24A
     D @@TYP2          S              1A
     D @@ACC2          S             24A
     D U#BRCH          S              3A
     D U#CUST          S              6A
 
     D W0MSG           S            256A
     D W0RTN           S              7A
 
     D W0DATA          DS           256
 
      ** Calling parameter data structure
     D  I#PT1                  1      1
     D  I#PTY1                 2     36
     D  I#PT2                 37     37
     D  I#PTY2                38     72
     D  I#CCY                 73     75
     D  O#CUST                76     81
     D  O#CYCD                82     84
     D  O#ACCD                85     94
     D  O#ACSN                95     96
     D  O#BRCD                97     99
      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      ** External DS for RUNDAT DataArea Layout file
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   DOU       %EOF(CQPADDL1)
     C                   READ      CQPADDL1
 
     C                   MOVEL     *BLANKS       @@TYP1
     C                   MOVEL     *BLANKS       @@ACC1
     C                   MOVEL     *BLANKS       @@TYP2
     C                   MOVEL     *BLANKS       @@ACC2
     C                   MOVEL     *BLANKS       @@CCY
 
     C                   IF        NOT(%EOF(CQPADDL1))
 
     C                   IF        CDRT <> *BLANKS
     C                   MOVEL     CDRT          @@TYP1
     C                   MOVEL     CDRO          W0FLD            18
     C     W0FLD         CAT       CDBR          @@ACC1
     C                   MOVEL     BJCYCD        @@CCY
     C                   ELSE
     C                   MOVEL     DRPT          @@TYP1
     C                   MOVEL     DRPY          W0FLD
     C     W0FLD         CAT       DRBR          @@ACC1
     C                   MOVEL     DRCY          @@CCY
     C                   ENDIF
 
     C                   CLEAR                   W0DATA
     C                   MOVEL(P)  @@TYP1        I#PT1
     C                   MOVEL(P)  @@ACC1        I#PTY1
     C                   MOVEL(P)  @@TYP2        I#PT2
     C                   MOVEL(P)  @@ACC2        I#PTY2
     C                   MOVEL(P)  @@CCY         I#CCY
 
     C                   CALL      'GL008101'
     C                   PARM                    W0RTN
     C                   PARM                    W0DATA
     C                   PARM                    W0MSG
 
      ** Move Customer and branch into fields to CHAIN to files to see if
      ** liable to Stamp Tax.
 
     C                   MOVEL     O#CUST        U#CUST
     C                   MOVEL     O#BRCD        U#BRCH
 
      ** Check Customer's Stamp Tax flag
 
     C                   EXSR      STCUS
 
      ** Check Branch Code's Stamp Tax flag
 
     C                   EXSR      STBRA
 
     ** Populated Stamp Tax fields
 
     C                   Z-ADD     BJRDNB        QPCDTE
 
     ** Stamp Tax Liable of Cheques for Collection will only be defaulted
     ** to 'Y' if both Customer and Branch are Stamp Tax Liable 'Y'
 
     C                   IF        W#CTAX = 'Y' AND W#BTAX = 'Y'
     C                   EVAL      QPTAX  = 'Y'
     C                   ELSE
     C                   EVAL      QPTAX  = 'N'
     C                   ENDIF
 
     C     KCQPACQ       CHAIN     CQPACQL0
     C                   IF        %FOUND(CQPACQL0)
     C                   UPDATE    CQPACQD0
     C                   ELSE
     C                   EVAL      QPPREF = PREF
     C                   Z-ADD     CQSQ          QPCQSQ
     C                   Z-ADD     0             QPSTAF
     C                   WRITE     CQPACQD0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/STCUS - Check Customer's Stamp Tax  Flag                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     STCUS         BEGSR
 
     C     KLCUST        CHAIN     SDCUSQL0                           84
     C     *IN84         IFEQ      *OFF
     C     CQTAX         IFEQ      'Y'
     C                   MOVE      'Y'           W#CTAX            1
     C                   ELSE
     C                   MOVE      'N'           W#CTAX
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           W#CTAX
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/STBRA - Check Branch Code's Stamp Tax  Flag                *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     STBRA         BEGSR
 
     C     KLBRCH        CHAIN     SDBRCHEXL0                         83
     C     *IN83         IFEQ      *OFF
     C     BXTAX         IFEQ      'Y'
     C                   MOVE      'Y'           W#BTAX            1
     C                   ELSE
     C                   MOVE      'N'           W#BTAX
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           W#BTAX
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Key fields
 
     C     KCQPACQ       KLIST
     C                   KFLD                    PREF
     C                   KFLD                    CQSQ
 
     C     KLCUST        KLIST
     C                   KFLD                    U#CUST
 
     C     KLBRCH        KLIST
     C                   KFLD                    U#BRCH
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(C) Copyright Finastra International Limited 2011
