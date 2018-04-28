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
      *  RDQMS - Receive Dataqueue Message.                           *
      *                                                               *
      *  Calls: QRCVDTAQ -                                            *
      *                                                               *
      *  Flds used: P@QRC  - DataQ Name                               *
      *             P@QLR  - DataQ Library                            *
      *             P@QNR  - DataQ Length                             *
      *             P@QDR  - DataQ Data                               *
      *             P@QTM  - DataQ Timeout                            *
      *                                                               *
      *****************************************************************---
     C     RDQMS         BEGSR
      *===================================================================
      * Receive a Dataqueue Message.
      *
     C                   CLEAR                   P@QDR                          Clr DtaQ Data
      *
     C                   CALL      'QRCVDTAQ'                           70      Rcv Fm DataQ
     C                   PARM                    P@QRC            10            -DataQ Name
     C                   PARM                    P@QLR            10            -DataQ Library
     C                   PARM                    P@QNR             5 0          -DataQ Length
     C                   PARM                    P@QDR                          -DataQ Data
     C                   PARM                    P@QTM             5 0          -DataQ Timeout
      *
     C                   MOVEL     'QRCVDTAQ'    P@QRS            10
     C                   MOVEL     P@QRC         P@QKY            20
      *
      *===================================================================
     C                   ENDSR
