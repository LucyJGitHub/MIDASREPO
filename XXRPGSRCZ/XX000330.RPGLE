     H DEBUG
     H*COPYRIGHT('(c)*Misys*International*Banking*Systems*Ltd.*2007')**                       JMI111
     H COPYRIGHT('(c) Finastra  International Limited 2018')                                  JMI111
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Extract Position Updates for OPICS')          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GLJ20001*-*Extract*all*Spot*Position*Updates*for*non-OPICS****                       JMI111
      **************transactions.**************************************                       JMI111
      *  XX000330 - Extract all Spot Position Updates for non-OPICS   *                       JMI111
      *             transactions.                                     *                       JMI111
      *                                                               *
      *  Function:  This program will be called during the COB        *
      *   (COB)     to extract all Position Updates for non-OPICS     *
      *             trsansactions.                                    *
      *                                                               *
      ***(C)*Copyright*Misys*International*Financial*Systems*2007******                       JMI111
      *  (c) Finastra  International Limited 2018                     *                       JMI111
      *                                                               *
      *  Last Amend No. JMI111             Date 12Nov18               *
      *  Prev Amend No. CGL019  *CREATE    Date 20Apr07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI111 - Midas-OPICS Interface. Upgrade to FBM 2.1           *
      *  CGL019 - OPICS-Midas GL Interface                            *
      *                                                               *
      *****************************************************************
     FACBRC     IF   E           K DISK
      *
      /EJECT
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Work fields
     D NetAmount       S             15S 0
     D BrStored        S              3A
     D CcyStored       S              3A

     D DataQueueName   S             10A   INZ('GLESPUDTAQ')
     D DataQueueLib    S             10A   INZ('*LIBL     ')

     D                 DS
     D  DataQueueVal           1     27
     D   BranchCode            1      3
     D   CurrencyCode          4      6
     D   SignedNetAmt          7     27


     C/EJECT
      *****************************************************************
      * MAIN PROCESSING                                               *
      *****************************************************************
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Check whether there are any entries
     C                   READ      ACBRC                                  75
      *
      ** Process all postings to the spot trade account
     C                   DOW       *In75 = *Off
      *
     C                   Eval      BrStored = BRCA
      *
      ** For each branch, get the total spot positions for each currency
     C                   Dow       *In75 = *Off and BRCA= BrStored
      *
     C                   Eval      CcyStored = CCY
      *
     C                   Dow       *In75 = *Off and BRCA = BrStored and
     C                             CCY = CcyStored
      *
      ** Add/subtract the spot position depending on the debit/credit
      ** indicator
     C                   Eval      NetAmount = NetAmount - LDBL
      *
     C                   READ      ACBRC                                  75
      *
     C                   EndDo
      *
      ** Write a record for each branch/currency combination
     C                   Eval      BranchCode   = BrStored
     C                   Eval      Currencycode = CcyStored
      *
     C                   Eval      ZFLD15 = NetAmount
      *
     C                   Callb     'ZSEDIT'
     C                   Parm                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM                    ZOUT21           21

     C                   Eval      SignedNetAmt = ZOUT21
     C                   Eval      DataQueueLen = 27
      *
     C                   Call      'QSNDDTAQ'
     C                   Parm                    DataQueueName
     C                   Parm                    DataQueueLib
     C                   Parm                    DataQueueLen      5 0
     C                   Parm                    DataQueueVal
      *
     C                   Eval      NetAmount = 0
      *
     C                   EndDo
      *
     C                   EndDo
      *
      ** Return
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2018                                                       JMI111
