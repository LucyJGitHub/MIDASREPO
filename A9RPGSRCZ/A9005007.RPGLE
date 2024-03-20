     H DEBUG
     H
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas A9 TAB001 upload to A9ACHOMTD')                  *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  A9005007 - Midas A9 TAB001 upload to A9ACHOMTD               *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. MD058916           Date 11Mar24               *
      *  Prev Amend No. BA9005  *CREATE    Date 11Mar24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058916 - DRI005 installation issues (Recompile).           *
      *  BA9005 - HO and EDW Extracts                                 *
      *                                                               *
      *****************************************************************
      *
     FTAB001L0  IF   E           K Disk    InfSR(*PSSR)
      *
     FA9ACHOML0 UF A E           K Disk    InfSR(*PSSR)
      *
      /Title Function of indicators
     F*****************************************************************
     F*                                                               *
     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
     F*                                                               *
     F*                                                               *
     F*  90-99 - Used by Standard Subroutines                         *
     F*                                                               *
     F*  U7+U8 - Database Error                                       *
     F*                                                               *
     F*****************************************************************
      /Title Subroutine Index
     F*****************************************************************
     F*                                                               *
     F*  S U B R O U T I N E   I N D E X                              *
     F*                                                               *
     F*  Init      - Initial Processing                               *
     F*  Proces    - Main processing                                  *
     F*                                                               *
     F*  *PSSR     - Program error handling routine                   *
     F*                                                               *
     F*****************************************************************
     D/Title D-Specifications
     D CPY@            S             80    Dim(1) CTData PerRCD(1)
      ***  Array for Object Copyright Statement.
      *
     D SDBANK        E DS                  ExtName(SDBANKPD)
      ** Bank Details
      *
     D DSSDY         E DS                  ExtName(DSSDY)
      ** Second DS For Access Programs, Long Data Structure
      *
     D DBERR           DS           256
      * Data structure for data-base error processing
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *

     C/Title Main Processing
      *================================================================
      *  P R O G R A M     S T A R T                                  *
      *================================================================
      *
      * Perform Initialisation.
     C                   ExSR      Init
      *
      * Perform Upload from TAB001
     C                   ExSR      UpLoad
      *
     C                   SetOn                                        LR
     C                   Return
      *================================================================
      *  P R O G R A M     E N D                                      *
      *================================================================
      /Title SR/Init
      *****************************************************************
      *                                                               *
      *  Init   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     Init          BegSR
      *
      ***  Copyright Statement.
     C                   MoveA     CPY@          BIS@             80
      *
      ** Klist to access the XXFEEDDTD file
     C     KACHOD        KList
     C                   KFld                    KACOD            10 0
      *
     C                   EndSR
      *****************************************************************
      /Title SR/Feeder
      *****************************************************************
      *                                                               *
      *  UpLoad - Subroutine to upload recs from TAB001 to XXACHOMTD  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     UpLoad        BegSR
      *
      ** Access TAB001
      ** Write to XXACHOMTD
     C     *LOVAL        SETLL     TAB001L0
     C                   READ      TAB001L0                               50
     C                   Dow       *IN50 = '0'
      *
     C                   MOVEL     ACODE         WKACOD           10
     C                   MOVE      '000000'      WKACOD
     C                   MOVEL     WKACOD        KACOD
     C     KACHOD        CHAIN     A9ACHOML0                          51
     C                   if        *IN51 = '1'
     C                   Z-ADD     KACOD         XXMACOD
     C                   Z-ADD     ACODE1        XXMHOAC
     C                   MOVEL     PRCODE1       XXMHOPC
     C                   MOVEL     MKCODE1       XXMHOMC
     C                   MOVEL     'N'           XXMEXCL
     C                   WRITE     A9ACHOMD0
     C                   ENDIF
      *
     C                   READ      TAB001L0                               50
     C                   ENDDO
      *
     C                   EndSR
      *
      *****************************************************************
      /Title SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BegSR                                                  *** *PSSR  ***
      *
      ***  Check to see that *PSSR has not already been called.
     C                   If        WRUN = *BLANK
     C                   Move      'Y'           WRUN              1
     C                   MoveL     'A9005007'    DBPGM
      *
     C     *DTAARA       Define    LDA           WLDA            256
     C     *Lock         In        WLDA
     C                   MoveL     DBERR         WLDA
     C                   Out       WLDA
     C                   SetOn                                        U7U8LR
      *
     C                   Dump
     C                   EndIf
      *
      ** Exit program
     C                   Return
      *
     C                   EndSR
      *
      *****************************************************************
      ***
**  CPY@
(c) Finastra International Limited 2024
