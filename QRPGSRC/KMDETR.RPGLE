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
     D @TYPE           DS
     D  $TYPE                  1      2B 0
     D @LEN            DS
     D  $LEN                   1      2B 0
     D @DPS            DS
     D  $DPS                   1      2B 0
     C     *ENTRY        PLIST
     C                   PARM                    @NAME            10
     C                   PARM                    @TYPE
     C                   PARM                    @LEN
     C                   PARM                    @DPS
     C                   PARM                    @FLAG             1
      *
      *  Set @TYPE as follows
      *   @TYPE -> 0 if CHAR
      *   @TYPE -> 1 if SHORT
      *   @TYPE -> 2 if LONG
      *   @TYPE -> 3 if FLOAT
      *   @TYPE -> 4 if DOUBLE
      *   @TYPE -> 5 if PACKED
      *   @TYPE -> 6 if ZONED
      *
     C                   MOVE      'N'           @FLAG
     C     @NAME         IFEQ      ':ENVDTE'
     C                   Z-ADD     6             $TYPE
     C                   Z-ADD     7             $LEN
     C                   Z-ADD     0             $DPS
     C                   MOVE      'Y'           @FLAG
     C                   END
     C                   RETURN
