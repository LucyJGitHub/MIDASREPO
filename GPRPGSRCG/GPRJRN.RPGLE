     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*XBI *  OVRDBF FILE(GBEGINJRNF) TOFILE(UPOBJDTPD)                    *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP - Report object to journal')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GPRJRN   - This program add records in GBEGINJRNF for any    *
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
     FGBEGINJRNFUF A E             DISK

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
