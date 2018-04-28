     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SE Initialisation program for CSE071')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SE000001 - Initialisation program for CSE071                 *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071  *CREATE    Date 26May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities                     *
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
     FSECTY     UP   E           K Disk    InfSR(*PSSR)
 
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
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Externally described DS for Investment type details
     D INVTP         E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(IN)
 
     D @RUN            S              1
     D PReturnCode     S              7
     D POptn           S              7
     D PInvt           S              3
     D PCcyi           S              3
     D CSE071          S              1
 
      /EJECT
      *****************************************************************
      *
      ** Main Program
      *
      ** Access AOINVTR0 to get the processing type
     C                   Call      'AOINVTR0'
     C                   Parm      *BLANKS       PReturnCode
     C                   Parm      '*KEY   '     POptn
     C                   Parm      SITP          PInvt
     C                   Parm      NMCY          PCcyi
     C     INVTP         Parm      INVTP         DSFDY
 
      ** Database error
 
     C                   If        PReturnCode <> *BLANK
     C     *Lock         In        LDA
     C                   Eval      DBFILE= 'INVTPD'
     C                   Movel     SITP          DBKEY
     C                   Move      NMCY          DBKEY
     C                   Eval      DBPGM = 'SE000001'
     C                   Eval      DBASE = 001
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
      *
      ** If processing type is 1, 3, 5, 6, 8 or 9 set Business Day convention
      *
     C                   If        INPROT = '1' or INPROT ='3' or INPROT ='5' or
     C                             INPROT = '6' or INPROT ='8' or INPROT ='9'
 
      ** Set BCNV to N when setting ON
     C                   Select
     C                   When      CSE071 = 'Y'
     C                   If        BCNV = *blanks
     C                   Eval      BCNV = 'N'
     C                   Update    SECTYDF
     C                   Endif
 
      ** Set BCNV to blank when setting OFF
     C                   When      CSE071 = 'N'
     C                   If        BCNV = 'N'
     C                   Eval      BCNV = *blanks
     C                   Update    SECTYDF
     C                   Endif
 
     C                   EndSl
 
     C                   Endif
 
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
     C                   Parm                    CSE071
 
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
(c) Misys International Banking Systems Ltd. 2005
