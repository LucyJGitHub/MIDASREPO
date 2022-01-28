     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *
      *       (c) Finastra International Limited 2021
      *
      *       Last Amend No. MD058809  *CREATE  Date 16Dec21
      *
      ********************************************************************
      *
      *       MD058809 - After installation of MQ9 compatibility patch and
      *                  restart of the Meridian Replication subsystem
      *                  REPMIDASPT, the job MPT1PBSIN ended in MSGW.
      *
      ********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    PGM              21
     C                   PARM                    PCT               3 0
     C                   PARM                    P1                1
     C                   PARM                    P2                1
     C                   PARM                    P3                1
     C                   PARM                    P4                1
     C                   PARM                    P5                1
     C                   PARM                    P6                1
     C                   PARM                    P7                1
     C                   PARM                    P8                1
     C                   PARM                    P9                1
     C                   PARM                    P10               1
      *
     C                   SELECT
      *
     C                   WHEN      PCT = 0
     C                   CALL      PGM
      *
     C                   WHEN      PCT = 1
     C                   CALL      PGM
     C                   PARM                    P1
      *
     C                   WHEN      PCT = 2
     C                   CALL      PGM
     C                   PARM                    P1
     C                   PARM                    P2
      *
     C                   WHEN      PCT = 3
     C                   CALL      PGM
     C                   PARM                    P1
     C                   PARM                    P2
     C                   PARM                    P3
      *
     C                   WHEN      PCT = 4
     C                   CALL      PGM
     C                   PARM                    P1
     C                   PARM                    P2
     C                   PARM                    P3
     C                   PARM                    P4
      *
     C                   WHEN      PCT = 5
     C                   CALL      PGM
     C                   PARM                    P1
     C                   PARM                    P2
     C                   PARM                    P3
     C                   PARM                    P4
     C                   PARM                    P5
      *
     C                   WHEN      PCT = 6
     C                   CALL      PGM
     C                   PARM                    P1
     C                   PARM                    P2
     C                   PARM                    P3
     C                   PARM                    P4
     C                   PARM                    P5
     C                   PARM                    P6
      *
     C                   WHEN      PCT = 7
     C                   CALL      PGM
     C                   PARM                    P1
     C                   PARM                    P2
     C                   PARM                    P3
     C                   PARM                    P4
     C                   PARM                    P5
     C                   PARM                    P6
     C                   PARM                    P7
      *
     C                   WHEN      PCT = 8
     C                   CALL      PGM
     C                   PARM                    P1
     C                   PARM                    P2
     C                   PARM                    P3
     C                   PARM                    P4
     C                   PARM                    P5
     C                   PARM                    P6
     C                   PARM                    P7
     C                   PARM                    P8
      *
     C                   WHEN      PCT = 9
     C                   CALL      PGM
     C                   PARM                    P1
     C                   PARM                    P2
     C                   PARM                    P3
     C                   PARM                    P4
     C                   PARM                    P5
     C                   PARM                    P6
     C                   PARM                    P7
     C                   PARM                    P8
     C                   PARM                    P9
      *
     C                   WHEN      PCT = 10
     C                   CALL      PGM
     C                   PARM                    P1
     C                   PARM                    P2
     C                   PARM                    P3
     C                   PARM                    P4
     C                   PARM                    P5
     C                   PARM                    P6
     C                   PARM                    P7
     C                   PARM                    P8
     C                   PARM                    P9
     C                   PARM                    P10
     C                   ENDSL
     C                   RETURN
