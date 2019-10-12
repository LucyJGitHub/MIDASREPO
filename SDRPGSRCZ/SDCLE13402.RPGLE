     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('TAKE-ON - Initialise New Fields on SDACUSPD')          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  SDCLE13402 - Initialise New Field on SDACUSPD                *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL132             Date 01May13               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      ** Midas SD Additional customer details
     FSDACUSL1  UP   E           K DISK
      *
      *****************************************************************
     D/EJECT
      *****************************************************************
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D DSLoop          S              9  0 INZ
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Main Processing Control
      *****************************************************************
      ** Initialise Miscellaneous Values.
 
     C                   EVAL      E5PDCU      = 'N'
 
      ** Update Customer Details
 
     C                   UPDATE(E) @ACUSL1
