     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Change CoB components')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP0028 - Allow user to change run priority and/or timeslice  *
      *            of CoB component.                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CUP014 *CREATE     Date 17Apr01               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CUP014  -  New utility for Bridge.                           *
      *                                                               *
      *****************************************************************
      *  Function of indicators
      *
      *       69      Error on file access
      *       80      End of file indicator
      *****************************************************************
     FCBCMPNPD  UF   E             DISK    INFSR(*PSSR)
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    EXPTY             2 0
     C                   PARM                    TIMS              8 0
      *
     C                   READ      CBCMPNPD                             6980
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C     *IN80         DOWNE     *ON
      *
      * If Execution Priority has been requested then change
     C     EXPTY         IFGE      1
     C     EXPTY         ANDLE     99
     C                   Z-ADD     EXPTY         DHCEPY
     C                   ENDIF
      *
      * If Timeslice has been requested then change
     C     TIMS          IFGE      1
     C     TIMS          ANDLE     99999999
     C                   Z-ADD     TIMS          DHCTSL
     C                   ENDIF
      *
     C                   UPDATE    CBCMPND0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      CBCMPNPD                             6980
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
