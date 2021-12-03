     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas UP Change CoB components')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP0028 - Allow user to change run priority and/or timeslice  *
      *            of CoB component.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058986           Date 11Oct21               *
      *  Prev Amend No. MD055891           Date 01Sep20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CUP014 *CREATE     Date 17Apr01               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058986 - Add Logical Delete for components and dependencies*
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP014  -  New utility for Bridge.                           *
      *                                                               *
      *****************************************************************
      *  Function of indicators
      *
      *       69      Error on file access
      *       80      End of file indicator
      *****************************************************************
     F*CBCMPNPD* UF   E             DISK    INFSR(*PSSR)                                    MD055891
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD055891
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    EXPTY             2 0
     C                   PARM                    TIMS              8 0
      *
     C**********         READ      CBCMPNPD                             6980                MD055891
     C******IN69         IFEQ      *ON                                                      MD055891
     C**********         EXSR      *PSSR                                                    MD055891
     C**********         ENDIF                                                              MD055891
     C******IN80         DOWNE     *ON                                                      MD055891
      *
      * If Execution Priority has been requested then change
     C     EXPTY         IFGE      1
     C     EXPTY         ANDLE     99
     C                   Z-ADD     EXPTY         DHCEPY
     C/EXEC SQL                                                                             MD055891
     C+ update CBCMPXTD                                                                     MD055891
     C+  SET DHCEPY = :EXPTY                                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   ENDIF
      *
      * If Timeslice has been requested then change
     C     TIMS          IFGE      1
     C     TIMS          ANDLE     99999999
     C                   Z-ADD     TIMS          DHCTSL
     C/EXEC SQL                                                                             MD055891
     C+ update CBCMPXTD                                                                     MD055891
     C+  SET DHCTSL = :TIMS                                                                 MD055891
     C/END-EXEC                                                                             MD055891
     C                   ENDIF
      *
     C***********        UPDATE    CBCMPND0                             69                  MD055891
     C******IN69         IFEQ      *ON                                                      MD055891
     C                   IF        SQLCODE <> 0                                             MD055891
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C**********         READ      CBCMPNPD                             6980                MD055891
     C******IN69         IFEQ      *ON                                                      MD055891
     C**********         EXSR      *PSSR                                                    MD055891
     C**********         ENDIF                                                              MD055891
     C**********         ENDDO                                                              MD055891
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
