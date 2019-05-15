      *****************************************************************
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *  Last Amend No. CRT004  *CREATE    Date 02JUN00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRT004 - Cashier Midas TCP/IP interface.                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SDQMS  - Send Dataqueue Messages                             *
      *                                                               *
      *  Calls: QSNDDTAQ -                                            *
      *                                                               *
      *  Flds used: P@QSN  - DataQueue Name                           *
      *             P@QLS  - DataQ Library                            *
      *             P@QNS  - DataQ Length                             *
      *             P@QDS  - DataQueue Data                           *
      *                                                               *
      *****************************************************************
     C     SDQMS         BEGSR
      *================================================================
      * Send Message.
     C                   CALL      'QSNDDTAQ'                             70
     C                   PARM                    P@QSN            10
     C                   PARM                    P@QLS            10
     C                   PARM                    P@QNS             5 0
     C                   PARM                    P@QDS
      *
     C                   MOVEL     'QSNDDTAQ'    P@QRS            10
     C                   MOVEL     P@QSN         P@QKY            20
      *----------------------------------------------------------------
      * Reset Values.
     C                   CLEAR                   P@QDS
      *================================================================
     C                   ENDSR
