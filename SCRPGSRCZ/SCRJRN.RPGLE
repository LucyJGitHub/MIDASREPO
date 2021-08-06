     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*XBI *  OVRDBF FILE(BEGINJRNF) TOFILE(UPOBJDTPD)                     *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC - Report object to journal')                  *
      *****************************************************************
      *                                                               *
      *  Midas - System Control                                       *
      *                                                               *
      *  SCRJRN   - This program add records in BEGINJRNF for any     *
      *             object not journalled.                            *
      *                                                               *
      *  (c) Finastra International 2021                              *
      *                                                               *
      *  Last Amend No. MD058520   *CREATE   Date 01Aug21             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058520 - Journaling improvement                            *
      *                                                               *
      *****************************************************************
     FBEGINJRNF UF A E             DISK

     C                   WRITE     QLIDOBJD
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    ODLBNM
     C                   PARM                    ODOBNM
     C                   PARM                    ODOBTP
     C                   PARM                    ODOBAT

     C                   ENDSR
