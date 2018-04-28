     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                    BUG27831A
/*STD *  RPGSQLBND                                                    *                    BUG27831A
/*EXI *  TEXT('Midas GO Download data control - Unauthorised WIP')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      ***GO000125*-*Midas*GO*Download*data*control*-*RATF**************
      *  GO000125 - Midas GO Download data control -                  *
      *             Unauthorised WIP items                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. MD020167           Date 23Apr13               *
      *  Prev Amend No. CCB020A            Date 06Aug12               *
      *                 CCB023             Date 06Aug12               *
      *                 BUG27831A          Date 03Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27265           Date 24Mar10               *
      *                 CAP204    *CREATE  Date 09Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  CCB020A - COB Restructure - Secondary COB Infrastructure     *
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring (Recompile)                           *
      *  BUG27831A - Forward Account Transfer Processing              *
      *  BUG27265 - In the MidasPlus Dashboard RAT items in WIP were  *
      *             not reflected                                     *
      *  CAP204 - Retail Account Transfer (Include in MidasPlus       *
      *           Dashboard)                                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
 
     F***GPATWIPL  IF   E           K DISK    INFSR(*PSSR)                                 BUG27831A
     FGPZONEL2  IF   E           K DISK    INFSR(*PSSR)
     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D                 DS
     D  CountN                 1      5  0
     D  CountA                 1      5
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** Midas Local Data Area for database error reporting
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D Value           S             50
     D Zone            S             10                                                    BUG27831A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C/COPY GOCPYSRC,GOUPD_PARM
 
      ** Get Zone Name from system ID.
 
     C     System_ID     CHAIN     GPZONED0                           90
     C                   EVAL      Zone = ZOZONE                                           BUG27831A
 
      ** Unauthorised Retail Account Transfer
 
     C**********         IF        Key_Desc = 'UnauthRATF'                                  BUG27265
     C**********         IF        Key_Desc = 'UnauthAcctTransfers'               BUG27265 BUG27831A
 
     C                   EXSR      UpdateCount
 
     C**********         ENDIF                                                             BUG27831A
 
     C                   IF        %Open(GPDWNLL0)
     C                   CLOSE     GPDWNLL0
     C                   ENDIF
 
     C/COPY GOCPYSRC,GOUPD_DWNL
 
     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdateCount - This does the read of the file containing       *
      *               unauthorised retail account transfer updates    *
      *               the count accordingly.                          *
      *                                                               *
      * Called by: *MAIN                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     UpdateCount   BEGSR
 
      ** If the Midas phase is not Input Cycle then set data to blank.
 
     C**********         IF        MidasPhase <> 'A'                                         CCB020A
     C                   IF        MidasPhase = 'C'                                          CCB020A
     C                   EVAL      Value = *blanks
     C                   ELSE
 
     C                   EVAL      CountN = 0
 
     C******LOVAL        SETLL     T@MSWIP                                                 BUG27831A
     C**********         READ      T@MSWIP                                01               BUG27831A
      **********                                                                           BUG27831A
     C**********         DOW       *IN01 = *OFF                                            BUG27831A
     C**********         IF        MSWZONE = ZOZONE                                        BUG27831A
     C**********         EVAL      CountN = CountN + 1                                     BUG27831A
     C**********         ENDIF                                                             BUG27831A
     C**********         READ      T@MSWIP                                01               BUG27831A
     C**********         ENDDO                                                             BUG27831A
                                                                                           BUG27831A
     C/EXEC SQL                                                                            BUG27831A
     C+  SELECT COUNT(*) INTO :CountN FROM T_MSWIP WHERE MSWAPI=:Extra_Parms               BUG27831A
     C+  AND MSWZONE = :Zone AND MSWSTAT NOT IN ('AUTHORISED', 'REJECTED',                 BUG27831A
     C+  'NOT_APPROVED', 'INCOMPLETE')                                                     BUG27831A
     C/END-EXEC                                                                            BUG27831A
                                                                                           BUG27831A
      * Check for successful completion                                                    BUG27831A
                                                                                           BUG27831A
     C                   IF        SQLCOD <> 0                                             BUG27831A
     C                   EXSR      *PSSR                                                   BUG27831A
     C                   ENDIF                                                             BUG27831A
 
     C                   EVAL      Value = CountA
 
     C                   ENDIF
 
     C     UpdateCountE  ENDSR
 
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
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
