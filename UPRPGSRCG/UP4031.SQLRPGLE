     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*XBI *  OVRDBF FILE(UPOBJCTPD) TOFILE(UPDBRLPD)                      *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP writes into UPOBJCTPD')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP4031 - This program writes in UPDBRLPD                     *
      *                                                               *
      *  (c) Finastra International 2022                              *
      *                                                               *
      *  Last Amend No. MD059476 *CREATE   Date 09Dec22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059476 - Bridge improvement for refresh                    *
      *           - Applied for MD060769.                             *
      *                                                               *
      *****************************************************************
     FUPOBJCTPD UF A E             DISK

     C                   WRITE     UPDBRLD0
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    WHACTC            1
     C                   PARM                    WHRFI            10
     C                   PARM                    WHREFI           10

     C                   ENDSR
