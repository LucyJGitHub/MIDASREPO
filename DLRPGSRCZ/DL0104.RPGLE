     H DEBUG
     H COPYRIGHT('(C) Copyright Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL Deals Interest & Drawings Report')            *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  DL0104 - Deals Interest & Drawings Report                    *
      *                                                               *
      *  (C) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. CDL104   *CREATE   Date 02Oct23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL104 - Principal Decrease events on Fixed Term MM Deals    *
      *                                                               *
      *****************************************************************
     FDEALSL1   IF   E           K Disk    INFSR(*PSSR)  INCLUDE(DEALSDCF)
      **  Loan/Deposit Deals details in branch/deal number order
      *
     FDLEVNDV0  IF   E           K Disk    INFSR(*PSSR)
      **  Dealing events file
      *
     FDL0104P1  O    E             PRINTER INFSR(*PSSR)  INFDS(SPOOL)
     F                                     OFLIND(*IN50)
      ** Deals Interest & Drawings Report
      *
      ** Program Status Data Structure
      ** =============================
     D/COPY ZACPYSRC,PSDS
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      **   Manually included D-specs
      **   =========================
      *
      **   Arrays and Data Structures
      **   ==========================
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General ledger data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
      ** Local data area
      *
     D SPOOL           DS
     DSpoolNo                123    124B 0
      ** Information data structure for DL0104P1
      *
      *
      **   End of D-specs
      **   ==============
      *
      /EJECT
      *****************************************************************
      *
      **  Main Processing
     C                   Exsr      Sr_Main
      *
      *
      **  Termination Processing
     C                   Exsr      Sr_Term
      *
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_Main - Main Processing                                     *
      *                                                               *
      *****************************************************************
     C     Sr_Main       Begsr
      *
      **  Read through deal details (live deals only)
     C                   Read      Dealsdcf                               89
      *
      **  Report error if deal number not found
     C                   Dow       *In89 = *Off
      *
      **  Process deal for reporting purposes if fixed term deal
      **  and interest to be capitalised
     C                   If        (INTC = 'Y') and
     C                             (DTYP = 'TI' or DTYP = 'TD' or
     C                             DTYP = 'IP' or DTYP = 'IT')
     C                   Exsr      Sr_ProcDeal
     C                   Endif
      *
     C                   Read      Dealsdcf                               89
     C                   Enddo
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_Term - Termination Processing                              *
      *                                                               *
      *****************************************************************
     C     Sr_Term       Begsr
      *
      **  No details reported
     C     RptDtl        Ifne      'Y'
     C                   Write     DL0104D1
     C                   Endif
      *
      **  Output report trailer
     C                   Write     DL0104T0
      *
      **  Return to calling program
     C                   Move      *On           *InLR
     C                   Return
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_ProcDeal - Process Deal for Reporting Purposes             *
      *                                                               *
      *****************************************************************
     C     Sr_ProcDeal   Begsr
      *
      **  Read through dealing events
     C                   Exsr      Sr_Events
      *
      **  Format deal details for output
     C                   Exsr      Sr_Format
      *
      **  Output deal details to report
     C                   Exsr      Sr_Report
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_Events - Read through Dealing Events                       *
      *                                                               *
      *****************************************************************
     C     Sr_Events     Begsr
      *
      **  Reset work fields
     C                   Z-add     PCPL          Principal        13 0
     C                   Z-add     0             Interest         13 0
     C                   Z-add     0             LastEvnt          5 0
     C                   Z-add     0             ValueDate         5 0
     C                   Z-add     0             Deposits         15 0
     C                   Z-add     0             Withdrawal       15 0
     C                   Move      'N'           Overdrawn         1
     C                   Move      'Y'           RptDtl            1
     C                   Move      *Blanks       SeqNo             3
     C                   Move      *Blanks       Sequence          3
      *
      **  Read through dealing events file
     C     DLNO          Setll     DLEVNDV0
     C     DLNO          Reade     DLEVNDV0                               88
      *
      **  Read through dealing events
     C                   Dow       *In88 = *Off
      *
      **  Process event just read
     C                   Select
      *
      **  Interest due event
     C     ETYP          Wheneq    '15I2'
     C     ETYP          oreq      '16I2'
     C     ETYP          oreq      '15M2'
     C     ETYP          oreq      '16M2'
     C                   Add       EAMT          Principal
     C     Interest      Ifeq      *Zero
     C                   Z-Add     EAMT          Interest
     C                   Endif
      *
      **  Principal Decrease Event
     C     ETYP          Wheneq    '15M4'
     C     ETYP          oreq      '16M4'
     C                   Sub       EAMT          Principal
     C                   Add       EAMT          Withdrawal
     C                   Move      DASN          SeqNo
      *
      **  Principal Increase Event
     C     ETYP          Wheneq    '15V3'
     C     ETYP          oreq      '16V3'
     C                   Add       EAMT          Principal
     C                   Add       EAMT          Deposits
      *
     C                   Endsl
      *
      **  Change of event date
     C     EDAT          Ifne      LastEvnt
      *
      **  Check if principal has become negative
     C     Principal     Iflt      0
     C     Overdrawn     andeq     'N'
     C                   Move      'Y'           Overdrawn
     C                   Move      SeqNo         Sequence
     C                   Z-add     LastEvnt      ValueDate
      *
      **  If date of overdrawn is prior to next working day then send
      **  message to operator to prevent COB from starting
     C     LastEvnt      Ifle      BJDNWD
     C                   Move      '*OVRDRW'     RetCode
     C                   Endif
      *
     C                   Endif
      *
      **  Save last evnt date
     C                   Z-add     EDAT          LastEvnt
      *
     C                   Endif
      *
     C     DLNO          Reade     DLEVNDV0                               88
     C                   Enddo
      *
      **  Check if principal has become negative
     C     Principal     Iflt      0
     C     Overdrawn     andeq     'N'
     C                   Move      'Y'           Overdrawn
     C                   Endif
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_Format - Format Details for Reporting                      *
      *                                                               *
      *****************************************************************
     C     Sr_Format     Begsr
      *
      ** Get currency decimal places
     C                   Exsr      Sr_GetCcy
      *
      ** Clear out format
     C                   Clear                   DL0104D0
      *
      ** Set up output fields
     C                   Move      DLNO          L#DLNO
     C                   Move      CCY           L#CYCD
      *
      **  Edit current principal
     C                   Z-add     PCPL          AmountIn
     C                   Call      'ZSEDIT'
     C                   Parm                    AmountIn         15 0
     C                   Parm      A6NBDP        Decimals          1 0
     C                   Parm      'J'           EditCode          1
     C                   Parm                    AmountOut        21
     C                   Move      AmountOut     L#PCPL
      *
      **  Edit interest due at next interest date
     C                   Z-add     Interest      AmountIn
     C                   Call      'ZSEDIT'
     C                   Parm                    AmountIn         15 0
     C                   Parm      A6NBDP        Decimals          1 0
     C                   Parm      'J'           EditCode          1
     C                   Parm                    AmountOut        21
     C                   Move      AmountOut     L#INTR
      *
      **  Edit total deposits (ie principal increase)
     C                   Z-add     Deposits      AmountIn
     C                   Call      'ZSEDIT'
     C                   Parm                    AmountIn         15 0
     C                   Parm      A6NBDP        Decimals          1 0
     C                   Parm      'J'           EditCode          1
     C                   Parm                    AmountOut        21
     C                   Move      AmountOut     L#TOTD
      *
      **  Edit total withdrawals (ie principal decrease)
     C                   Z-add     Withdrawal    AmountIn
     C                   Call      'ZSEDIT'
     C                   Parm                    AmountIn         15 0
     C                   Parm      A6NBDP        Decimals          1 0
     C                   Parm      'J'           EditCode          1
     C                   Parm                    AmountOut        21
     C                   Move      AmountOut     L#TOTW
      *
      **  Highlight deal as overdrawn
     C     Overdrawn     Ifeq      'Y'
     C                   Movel     'OVERDRAWN'   L#STAT
     C                   Else
     C                   Move      *Blanks       L#STAT
     C                   Endif
      *
      *
      **  If overdrawn then print deal amendment reference
     C     Overdrawn     Ifeq      'Y'
     C                   Z-add     ValueDate     ZDayNo
     C                   Call      'ZDATE2'
     C                   Parm                    ZDayNo            5 0
     C                   Parm      BJDFIN        ZDatfm            1
     C                   Parm                    ZDate             6 0
     C                   Parm                    ZData             7
     C                   Z-add     ZDate         L#DAVD
     C                   Move      Sequence      L#DASN
     C                   Else
     C                   Move      *Blanks       L#DAVD
     C                   Move      *Blanks       L#DASN
     C                   Endif
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_Report - Report Deal Details                               *
      *                                                               *
      *****************************************************************
     C     Sr_Report     Begsr
      *
      **  Output report details
     C     *In50         Ifeq      *On
     C                   Write     DL0104H0
     C                   Move      *Off          *In50
     C                   Endif
     C                   Write     DL0104D0
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_GetCcy - Get Currency Details                              *
      *                                                               *
      *****************************************************************
     C     Sr_GetCcy     Begsr
      *
      **  Get currency decimal places
     C                   Call      'AOCURRR0'
     C                   Parm                    P@Rtcd            7
     C                   Parm      '*KEY   '     P@Optn            7
     C                   Parm      CCY           P@Cycd            3
     C     SDCURR        Parm      SDCURR        DSSDY
      *
      ** Database error if record not found
     C     @RTCD         Ifne      *BLANKS
     C                   In        LDA
     C                   Movel     'SDCURRPD'    DBFILE
     C                   Movel     '903'         DBASE
     C                   Movel     CCY           DBKEY
     C                   Movel     ##PGM         DBPGM
     C                   Unlock    LDA
     C                   Exsr      *PSSR
     C                   End
      *
     C                   Endsr                                                  *** InzEnd ***
      /EJECT
      ****************************************************************
      ** SR/*PSSR  - Error Handling Routine
      ****************************************************************
     C     *PSSR         Begsr
      *
      **  Produce dump
     C     ULERROR       Ifne      'Y'
     C                   Move      'Y'           ULERROR           1
     C                   Dump
     C                   Move      '*ERROR'      RetCode
     C                   Move      *on           *inU7
     C                   Move      *on           *inU8
     C                   Endif
      *
      **  Exit program
     C                   Move      *on           *inLR
     C                   Return
      *
     C                   Endsr
      *
      /Eject
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
      *
     C     *Entry        Plist
     C                   Parm                    RetCode           7
     C                   Parm                    P@RepSeq          5
     C                   Parm                    P@RLevel          1
     C                   Parm                    P@Entity          3
      *
      ** Initialse program name
     C                   Move      'DL0104'      ##Pgm            10
      *
      ** Get Bank Details
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
      *
      ** Database error if record not found
     C     @RTCD         Ifne      *BLANKS
     C                   In        LDA
     C                   Movel     'SDBANKPD'    DBFILE
     C                   Movel     '901'         DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Movel     ##PGM         DBPGM
     C                   Unlock    LDA
     C                   Exsr      *PSSR
     C                   End
      *
      ** Get General Ledger ICD Details
     C                   Call      'AOGELRR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDGELR        Parm      SDGELR        DSFDY
      *
      ** Database error if record not found
     C     @RTCD         Ifne      *BLANKS
     C                   In        LDA
     C                   Movel     'SDGELRPD'    DBFILE
     C                   Movel     '902'         DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Movel     ##PGM         DBPGM
     C                   Unlock    LDA
     C                   Exsr      *PSSR
     C                   End
      *
      **  Call ZSFILE for RCF processing
     C                   Z-add     SpoolNo       P@SpoolNo         6 0
     C                   Call      'ZSFILE'
     C                   Parm                    P@RepSeq          5
     C                   Parm                    P@Entity          3
     C                   Parm      'DL0104P1'    P@FileName       10
     C                   Parm                    P@SpoolNo
     C                   Parm      *blanks       P@Rtcd
      *
      **  Output report header
     C                   Write     DL0104H0
      *
      *
     C                   Endsr                                                  *** InzEnd ***
      /EJECT
