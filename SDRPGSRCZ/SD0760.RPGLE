     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD SSI Effective Date Processing')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0760 - Midas SD Standard Settlement Effective Date Update  *
      *                                                               *
      *  Called By: SDC0760                                           *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 252514             Date 19Aug14               *
      *                 CSD095             Date 08Apr14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL031  *CREATE    Date 25Nov04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  252514 - Apply core fix 252050.                              *
      *  252050 - Update SDFCTLPA when BYRECI changed to or from 'D'. *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *           (Recompile)                                         *
      *  CDL031 - Effective Date on Extended SSI                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRDelete      -  Delete all records flagged for delete       *
      *  *PSSR         -  Delete all records flagged for delete       *
      *                                                               *
      *****************************************************************
      /EJECT
 
      ** SD Extended Settlements
     FSDEXSTPD  IP   E           K Disk    InfSR(*PSSR)
 
      ** SD Extended Settlements by CYCD/CUST/TRTY/EFFD
     FSDEXSTLA  UF   E           K Disk    InfSR(*PSSR)
     F                                     Rename(SDEXSTD0:SDEXSTDA)
     F                                     Prefix(L:1)
      *                                                                                       252050
      ** SD File Controls update                                                              252050
      *                                                                                       252050
     FSDFCTLL0  UF   E           K Disk    INFSR(*PSSR)                                       252050
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
 
     D @RUN            S              1
 
      ** Define Key Fields
     D K#CUST          S                   Like(BYCUST)
     D K#CYCD          S                   Like(BYCYCD)
     D K#TRTY          S                   Like(BYTRTY)
 
      /EJECT
      *****************************************************************
      *
      ** Main Program
      ** Set Key Fields
     C                   Eval      K#CUST = BYCUST
     C                   Eval      K#CYCD = BYCYCD
     C                   Eval      K#TRTY = BYTRTY
 
     C     KeyLA         Setll     SDEXSTDA
     C     KeyLA         ReadE     SDEXSTDA
 
      ** Process history and current records
     C                   Dow       Not %Eof
 
     C                   Select
 
     C                   When      LYRECI = '*'
      ** No Action,deleted later
 
     C                   When      LYRECI = 'H'
     C                   Eval      LYRECI = '*'
     C                   Update    SDEXSTDA
 
     C                   When      LYRECI = 'D'
     C                   Eval      LYRECI = 'H'
     C                   Update    SDEXSTDA
     C                   Eval      AHFLNM = 'SDEXSTPD'                                        252050
     C     AHFLNM        Chain     SDFCTLL0                                                   252050
     C                   Eval      AHNORC = AHNORC - 1                                        252050
     C                   Eval      AHNODL = AHNODL + 1                                        252050
     C                   Update    @AHREAU                                                    252050
 
     C                   When      LYRECI = 'F' and LYEFFD = BYEFFD
     C                   Eval      LYRECI = 'D'
     C                   Update    SDEXSTDA
     C                   Eval      AHFLNM = 'SDEXSTPD'                                        252050
     C     AHFLNM        Chain     SDFCTLL0                                                   252050
     C                   Eval      AHNORC = AHNORC + 1                                        252050
     C                   Eval      AHNOIN = AHNOIN + 1                                        252050
     C                   Update    @AHREAU                                                    252050
 
     C                   Other
 
     C                   EndSl
 
     C     KEYLA         ReadE     SDEXSTDA
     C                   EndDo
 
     CLR                 Exsr      SRDelete
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete recs with RecID = '*'                      *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRDelete      BegSr
 
      ** Clear Key Fields
     C                   Clear                   K#CUST
     C                   Clear                   K#CYCD
     C                   Clear                   K#TRTY
 
     C     KEYLA         Setll     SDEXSTLA
     C                   Read      SDEXSTLA
      ** Process all records
     C                   Dow       Not %Eof
      ** Record for deletion
     C                   If        LYRECI = '*'
     C                   Delete    SDEXSTLA
     C                   EndIf
 
     C                   Read      SDEXSTLA
     C                   EndDo
 
     C                   EndSr
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
 
      ** Define LDA
     C     *Lock         In        LDA
     C                   Eval      DBPGM = 'SD0760'
     C                   Eval      DBFILE = *BLANKS
     C                   Eval      DBKEY =  *BLANKS
     C                   Eval      DBASE = 0
     C                   Out       LDA
 
      ** Initialise Key Lists
     C     KeyLA         KList
     C                   KFld                    K#CUST
     C                   KFld                    K#CYCD
     C                   KFld                    K#TRTY
 
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
 
     C                   If        @RUN = *BLANK
     C                   Eval      @RUN = 'Y'
     C                   Seton                                        U7U8LR
     C                   Dump
     C                   Return
     C                   EndIf
      *
      ** If *PSSR already run, then just end the program here.
     C                   Seton                                        U7U8LR
     C                   Return
 
     C                   EndSr
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
