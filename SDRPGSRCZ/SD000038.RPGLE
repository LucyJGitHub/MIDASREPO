     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Initialisation program for CDL031')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000028 - Initialisation program for CDL031                 *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CSD095             Date 08Apr14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG6730            Date 04May05               *
      *                 CDL031  *CREATE    Date 07Dec04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *           (Recompile)                                         *
      *  BUG6730 - Renamed SDC000028 into SDC000038                   *
      *  CDL031 - Effective Date on Extended SSI                      *
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
     FSDEXSTPD  UP   E           K Disk    InfSR(*PSSR)
 
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
     D CDL031          S              1
 
      /EJECT
      *****************************************************************
      *
      ** Main Program
     C                   Select
     C                   When      CDL031 = 'Y'
      ** Set New Fields
     C                   Eval      BYINPD = BJRDNB - 1
     C                   Eval      BYEFFD = BJRDNB - 1
     C                   Eval      BYCPST = 'C'
     C                   Eval      BYRECI = 'D'
     C                   Update    SDEXSTD0
 
     C                   When      CDL031 = 'N' and BYRECI <> 'D'
      ** Delete All Recs where BYRECI <> 'D'
     C                   Delete    SDEXSTD0
 
     C                   EndSl
 
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
     C                   Parm                    CDL031
 
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
(c) Misys International Banking Systems Ltd. 2004
