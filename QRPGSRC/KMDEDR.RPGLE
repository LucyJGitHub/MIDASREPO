     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
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
     H DEBUG
     C     *ENTRY        PLIST
     C                   PARM                    @NAME            10
     C                   PARM                    @DATA            20
      *
      *
     C     @NAME         IFEQ      ':ENVDTE'
     C                   MOVEL     '1000105'     @DATA
     C                   END
     C                   RETURN
