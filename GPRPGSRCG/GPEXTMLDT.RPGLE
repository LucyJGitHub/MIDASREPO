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
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. EML109  *CREATE    Date 08Feb20               *
      * Bank Fusion Midas 2.1 Base------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML109 - Upgrade of NAD1 to FB2.1 SP21                       *
      *           NADC01 - ML Extracts for Mizuho                     *
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

