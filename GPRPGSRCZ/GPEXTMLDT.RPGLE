     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Extract ML Details')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPEXTMLDT - Extract ML Details                               *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. DAI103             Date 25Jun19               *
      *  Prev Amend No. NADC01  *CREATE    Date 17Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI103 - Upgraded MPlus 121 NADC01 ML Extracts to FB 2.1     *
      *  NADC01 - ML EXTRACTS FOR MIZUHO                              *
      *                                                               *
      *****************************************************************
 
     FT_MLTRNEXPIP   E             DISK     rename(T_MLTRNEXP:TRNEXP)
     FT_UCAPTRANIS   E             DISK     rename(T_UCAPTRAN:UCAPTR)
     FTXMLTRNEXPO    E             DISK
     FTXUCAPTRANO    E             DISK
 
     ITRNEXP        01
     IUCAPTR        02
 
 
      * Extract Transaction Exposures
 
     C   01              EVAL      TETRNIDX = TETRNID
     C   01              WRITE     TXMLTRNEXF
 
      * Extract Uncaptured Transactions
 
     C   02              EVAL      TRAN_IDX = TRAN_ID
     C   02              WRITE     TXUCAPTRAF
 
