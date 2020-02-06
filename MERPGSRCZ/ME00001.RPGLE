     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME Initialisation program for CSW099')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  ME00001  - Initialisation program for CSW099                 *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSW099  *CREATE    Date 04Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW099 - MT970 Netting Statement generation                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  *PSSR         -  Delete all records flagged for delete       *
      *                                                               *
      *****************************************************************
      /EJECT
 
      ** SD Extended Settlements
     FMEFNARPD  O    E             Disk    InfSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------------------------
 
      **------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------------------------
 
      /EJECT
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D @RUN            S              1
     D PReturnCode     S              7
     D POptn           S              7
     D CSW099          S              1
 
      /EJECT
      *****************************************************************
      *
      ** Set New Fields
      ** Record 1
     C                   Eval      LPMTT = 'FS'
     C                   Eval      LFTTR = 'N'
     C                   Eval      LLANC = *Blanks
     C                   Eval      LNATV = 'FX Sale'
     C                   Eval      LSTTI = 'FEX'
     C                   Eval      LTRMD = 'D'
     C                   Eval      LLCD = BJRDNB - 1
     C                   Eval      LTYLC = 'I'
     C                   Write     MEFNARD0
 
      ** Record 2
     C                   Eval      LPMTT = 'FP'
     C                   Eval      LFTTR = 'N'
     C                   Eval      LLANC = *Blanks
     C                   Eval      LNATV = 'FX Purchase'
     C                   Eval      LSTTI = 'FEX'
     C                   Eval      LTRMD = 'D'
     C                   Eval      LLCD = BJRDNB - 1
     C                   Eval      LTYLC = 'I'
     C                   Write     MEFNARD0
 
     C                   Eval      *InLR = *On
 
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : AOBANKR0 - Access Bank Details                    *
      *             *PSSR                                             *
      *                                                               *
      *****************************************************************
     C     *InzSr        BegSr
 
     C     *Entry        PList
     C                   Parm                    CSW099
 
      ** Access bank details.
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       PReturnCode
     C                   Parm      '*FIRST '     POptn
     C     SDBANK        Parm      SDBANK        DSFDY
 
      ** Database error
 
     C                   If        PReturnCode <> *BLANK
     C     *Lock         In        LDA
     C                   Eval      DBFILE= 'SDBANKPD'
     C                   Eval      DBKEY = POptn
     C                   Eval      DBASE = 001
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *  Called by: Various                                           *
      *                                                               *
      *  Calls    : DBERRCTL - Database Error Control                 *
      *                                                               *
      *****************************************************************
     C     *PSSR         BegSr
 
     C                   Dump
 
     C                   If        @RUN = *BLANK
     C                   Eval      @RUN = 'Y'
     C                   Call      'DBERRCTL'
     C                   EndIf
      *
     C                   Eval      *InU7 = *ON
     C                   Eval      *InU8 = *ON
     C                   Eval      *InLR = *ON
     C                   Return
 
     C                   EndSr
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
