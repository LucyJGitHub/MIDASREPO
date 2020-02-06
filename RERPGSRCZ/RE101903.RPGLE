     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Init REGAMXPD and RELGAMXPD for CRE022')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE101903 - Setup Extension File for REGAMXPD and RELGAMXPD   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CRE022  *CREATE    Date 23Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE022 - Cash Management Limit Check                         *
      *                                                               *
      *****************************************************************
     FREGAMXPD  UF   E             DISK
     F                                     RENAME(REGAMXD0:REGAMXFF)
      *...........................................................
     FRELGAMXPD UF   E             DISK
      *...........................................................
      *
     C     *ENTRY        PLIST
     C                   PARM                    @MODE             1
     C                   PARM                    @RTRN             7
      *
     C                   READ      REGAMXPD                               50
     C     *IN50         DOWEQ     *OFF
      *
     C     GMAGLO        IFEQ      *Blanks
     C                   MOVEL     'N'           GMAGLO
     C                   UPDATE    REGAMXFF
     C                   ENDIF
      *
     C                   READ      REGAMXPD                               50
     C                   ENDDO
      *
     C                   MOVE      *OFF          *IN50
     C                   READ      RELGAMXPD                              50
     C     *IN50         DOWEQ     *OFF
      *
     C     GMAGLO        IFEQ      *Blanks
     C                   MOVEL     'N'           GMAGLO
     C                   UPDATE    REGAMXD0
     C                   ENDIF
      *
     C                   READ      RELGAMXPD                              50
     C                   ENDDO
      *
     C                   SETON                                        LR
