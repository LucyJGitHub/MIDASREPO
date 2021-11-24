     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/********RPGBASEBND                                                   *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas CB Set status to blank')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business module                             *
      *                                                               *
      *  CB000028 - Set status to blank                               *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD058986           Date 11Oct21               *
      *  Prev Amend No. MD055891           Date 01Sep20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK018 *CREATE     Date 21Feb04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058986 - Add Logical Delete for components and dependencies*
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK018 - MidasPlus packaging.  Additional CoB validation.    *
      *                                                               *
      *****************************************************************
      *  Function of indicators
      *
      *       69      Error on file access
      *       80      End of file indicator
      *****************************************************************
     F*CBCMPNPD* UF   E             DISK    INFSR(*PSSR)                                    MD055891
                                                                                            MD055891
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD055891
      *
      *
     C*****1****         SETLL     CBCMPNPD                                                 MD055891
     C**********         READ      CBCMPNPD                             6980                MD055891
     C******IN69         IFEQ      *ON                                                      MD055891
     C**********         EXSR      *PSSR                                                    MD055891
     C**********         ENDIF                                                              MD055891
      *
     C******IN80         DOWNE     *ON                                                      MD055891
      *
      * Set status to blank unless component is COBBEGIN.
     C*****DHCOTT        IFNE      'COBBEGIN'                                               MD055891
     C**********         EVAL      DHCSTS = ' '                                             MD055891
     C**********         ENDIF                                                              MD055891
      *
     C**********         UPDATE    CBCMPND0                             69                  MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBCMPCTD                                                                     MD055891
     C+  SET DHCSTS = ' '                                                                   MD055891
     C+ WHERE DHCOTT <> 'COBBEGIN'                                                          MD055891
     C/END-EXEC                                                                             MD055891
     C                   IF        SQLCODE <> 0                                             MD055891
     C                   EXSR      *PSSR
     C                   Endif                                                              MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBCMPBTD                                                                     MD055891
     C+  SET DHCSTS = ' '                                                                   MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   IF        SQLCODE <> 0                                             MD055891
     C                             and SQLCODE <> 100                                       MD055891
     C                   EXSR      *PSSR                                                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C******IN69         IFEQ      *ON                                                      MD055891
     C**********         EXSR      *PSSR                                                    MD055891
     C**********         ENDIF                                                              MD055891
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
