     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Clear GPDWNLPD for single Midas system')      *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GP000105 - Clear down GPDWNLPD for single Midas system       *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD031770           Date 25Feb15               *
      *                 MD020167           Date 23Apr13               *
      *                 CCB023             Date 06Aug12               *
      *                 AR995318           Date 26Jun12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGP002  *CREATE    Date 02Jul03               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD046248 - Finastra Rebranding                               *
      *  MD031770 - Trade Finance business day. Do not delete data of *
      *             TIPlusInputActive.                                *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring (Recompile)                           *
      *  AR995318 - GP000105 deleted the PEA dashboard data           *
      *  CGP002 - Global Processing data download                     *
      *                                                               *
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
      *
     FGPDWNLL1  UF   E           K DISK    INFSR(*PSSR)
      **
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Program Status Data Structure
     D/COPY GPCPYSRCG,PSDS
      *
      * Midas Local Data Area for database error reporting
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      * The following fields are defined in the external file:
      *                                     134 141 DBFile
      *                                     142 170 DBKey
      *                                     171 180 DBPgm
      *                                     181 1830DBase
      *                                     184 193 DBMod
      *                                     194 203 DBProc
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D @RUN            S              1
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C     *ENTRY        PLIST
     C                   PARM                    System_ID         2
      *
     C     GPDWNLL1Key   KLIST
     C                   KFLD                    System_ID
      *
      * Find start of records for the Midas system using partial key.
     C     GPDWNLL1Key   SETLL     GPDWNLL1
     C     GPDWNLL1Key   CHAIN     GPDWNLL1                           11
     C                   DOW       *IN11 = *OFF
     C                   IF        DLKEYD <> 'PEASystemStatus'                              AR995318
     C                             AND DLKEYD <> 'TIPlusInputActive'                        MD031770
     C                   DELETE    @DWNLL1
     C                   ENDIF                                                              AR995318
     C                   READ      GPDWNLL1                               11
     C                   IF        DLMSID <> System_ID
     C                   EVAL      *IN11 = *ON
     C                   ENDIF
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
