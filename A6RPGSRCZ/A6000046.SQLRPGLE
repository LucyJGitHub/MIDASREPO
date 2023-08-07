     H DEBUG
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD056963
/*STD *  RPGSQLBND                                                    *                     MD056963
/*EXI *  TEXT('Utility to Update Ext. Files A6RETRPD and A6NW94PD')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  A6000046 - Utility to Update Extension Files A6RETRPD and    *
      *             A6NW94PD                                          *
      *                                                               *
      *       (c) Finastra International Limited 2023                 *
      *                                                               *
      *  Last Amend No. MD056963           Date 07Jun23               *
      *  Prev Amend No. BA6026   *CREATE   Date 18Jan23               *
      *                 XXXXXX             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056963 - Apply DDS change to SDNWRKPD and SDRETRPD during  *
      *             incorporation of BA6026 to core.                  *
      *             Corrected the read file.                          *
      *  BA6026 - Structuring Current MT940 and SEPA Compliance.      *
      *           Include GSH026.                                     *
      *                                                               *
      *****************************************************************
      *
     F***SDRETRL0*  IF   E           K DISK    INFSR(*PSSR)                                 MD056963
      ** Midas Retail Transaction Types Retrieval Index
      *
     FA6RETRL0  UF A E           K DISK    INFSR(*PSSR)
      ** Midas Retail Transaction Types - Extension Update
      *
     FGLNW94L1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D1)
      ** Midas GL Network Accounts - MT94x Retrieval
      *
     FA6NW94L1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(A6NW94D0:A6NW94D2)
      ** Midas GL Network Accounts MT94x Extension Details - Update
      *
      /EJECT
      *****************************************************************
      *
      ** Automatically included D-specs
      ** ==============================
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects
      *
     D*DsNWRK***     E DS                  EXTNAME(SDNWRKPD)                                MD056963
     D DsNWRK        E DS                  EXTNAME(SDNWKJW0)                                MD056963
      ** Network details record format data structure
      *
     D SDRETR        E DS                  EXTNAME(SDRTRJW0)                                MD056963
     I
     C/TITLE Main Processing
      *================================================================
      *  M A I N                                                      *
      *================================================================
      *
      ** Update processing routine.
      *
     C                   Exsr      PrcUpdTrnTyp
     C                   Exsr      PrcUpdNwrkAc
      *
      ** End of program routine.
      *
     C                   Exsr      EndRoutine
      /EJECT
      *****************************************************************
      *                                                               *
      *  PrcUpdTrnTyp - Process update of Retail Transaction Type     *
      *                 Extension File.                               *
      *                                                               *
      *  Called From:  Main program                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     PrcUpdTrnTyp  BegSr
      *
     C******Loval        Setll     A6RETRL0                                                 MD056963
     C**********         Read      A6RETRL0                                                 MD056963
     C**********         Dow       Not %EOF(A6RETRL0)                                       MD056963
     C/EXEC SQL                                                                             MD056963
     C+ close ACursor                                                                       MD056963
     C/END-EXEC                                                                             MD056963
                                                                                            MD056963
     C/EXEC SQL                                                                             MD056963
     C+ declare ACursor insensitive scroll cursor for                                       MD056963
     C+ select * from SDRTRJW0                                                              MD056963
     C+ order by A1RTTY                                                                     MD056963
     C/END-EXEC                                                                             MD056963
                                                                                            MD056963
     C/EXEC SQL                                                                             MD056963
     C+ open ACursor                                                                        MD056963
     C/END-EXEC                                                                             MD056963
                                                                                            MD056963
     C                   Setoff                                       99                    MD056963
     C/EXEC SQL                                                                             MD056963
     C+ fetch next from ACursor into :SDRETR                                                MD056963
     C/END-EXEC                                                                             MD056963
     C                   If        SQLCODE = 100                                            MD056963
     C                   Seton                                        99                    MD056963
     C                   Endif                                                              MD056963
     C     *IN99         DOWEQ     '0'                                                      MD056963
      *
      ** Clear extension file's record format.
      *
     C                   Clear                   A6RETRD0
      *
      ** Populate extension file fields.
      *
     C                   Eval      G1RTTY = A1RTTY
      *
     C                   Select
     C                   When      A1RTTY = '12001'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '12002'
     C                   Eval      G1SIDC = 'NDDT'
      *
     C                   When      A1RTTY = '12006'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '12007'
     C                   Eval      G1SIDC = 'NRTI'
      *
     C                   When      A1RTTY = '12008'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '12015'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '12997'
     C                   Eval      G1SIDC = 'NRTI'
      *
     C                   When      A1RTTY = '12998'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '12999'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '13000'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '13001'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '13006'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '13007'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '13012'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '13015'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '13016'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '13017'
     C                   Eval      G1SIDC = 'NRTI'
      *
     C                   When      A1RTTY = '13018'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '13019'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '14001'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '14002'
     C                   Eval      G1SIDC = 'NCHG'
      *
     C                   When      A1RTTY = '14003'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '14004'
     C                   Eval      G1SIDC = 'NCHG'
      *
     C                   When      A1RTTY = '14005'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '90001'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   When      A1RTTY = '90002'
     C                   Eval      G1SIDC = 'NTRF'
      *
     C                   Other
     C                   Eval      G1SIDC = '    '
      *
     C                   EndSl
      *
      ** Write a record to extension file.
      *
     C                   Write     A6RETRD0
      *
     C**********         Read      A6RETRL0                                                 MD056963
     C/EXEC SQL                                                                             MD056963
     C+ fetch next from ACursor into :SDRETR                                                MD056963
     C/END-EXEC                                                                             MD056963
     C                   If        SQLCODE = 100                                            MD056963
     C                   Seton                                        99                    MD056963
     C                   Endif                                                              MD056963
     C                   EndDo
      *
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      *  PrcUpdNwrkAc - Process update of GL Network Accounts         *
      *                 Extension file.                               *
      *                                                               *
      *  Called From:  Main program                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     PrcUpdNwrkAc  BegSr
      *
     C     *Loval        Setll     GLNW94L1
     C                   Read      GLNW94L1
     C                   Dow       Not %EOF(GLNW94L1)
      *
      ** Retrieve the associated network record
      *
     C                   Call      'AONWRKR1'
     C                   Parm      *Blanks       @RtCd             7
     C                   Parm      '*KEY'        @Optn             7
     C                   Parm      N4NWRK        @NWRK             6
     C     DsNWRK        Parm                    DSLDY

     C                   If        @RtCd <> *Blanks
     C     *LOCK         In        LDA
     C                   Eval      DBFile = 'SDNWRKPD'
     C                   Eval      DBKey  = N4NWRK
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      DBase  = 001
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = PSProcName
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
      *
      ** Select network having '*SWIFT' as network protocol.
      *
     C                   If        EDPROT = '*SWIFT'
      *
      ** Clear extension file's record format.
      *
     C                   Clear                   A6NW94D2
      *
      ** Populate extension file fields.
      *
     C                   Eval      G4RECI = N4RECI
     C                   Eval      G4NWRK = N4NWRK
     C                   Eval      G4BRCA = N4BRCA
     C                   Eval      G4CNUM = N4CNUM
     C                   Eval      G4CCY  = N4CCY
     C                   Eval      G4ACCD = N4ACCD
     C                   Eval      G4ACSQ = N4ACSQ
     C                   Eval      G4NATY = N4NATY
     C                   Eval      G4DSTN = N4DSTN
     C                   Eval      G4SF86 = 'N'
      *
      ** Write a record to extension file.
      *
     C                   Write     A6NW94D2
     C                   EndIf
      *
     C                   Read      GLNW94L1
     C                   EndDo
      *
     C                   EndSr
      /EJECT
      *****************************************************************
      *                                                               *
      *  EndRoutine - End of program routine.                         *
      *                                                               *
      *  Called From:  Main program                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     EndRoutine    BegSr
      *
     C/exec SQL                                                                             MD056963
     C+ Close ACursor                                                                       MD056963
     C/end-exec                                                                             MD056963
     C                   SetOn                                        LR
     C                   Return
      *
     C                   EndSr
      /EJECT
      *****************************************************************
      * *PSSR     : Program exception error subroutine                *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
      *
     C                   CALL      'DBERRCTL'                           99
      *
     C     @PSSR         ENDSR
