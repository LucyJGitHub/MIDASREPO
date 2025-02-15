     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GO Download data control - Repair Queue LOAM')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO000128 - Midas GO Download data control - Repair queue     *
      *             (for LOAM API type)                               *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD020167           Date 23Apr13               *
      *                 CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** � Files                                �
      ** � =====                                �
      ** +--------------------------------------+

     FGPZONEL2  IF   E           K DISK    INFSR(*PSSR)
     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)

      ** +--------------------------------------+
      ** � Arrays and Data Structures           �
      ** � ==========================           �
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
      ** � Declared variables                   �
      ** � ==================                   �
      ** +--------------------------------------+

     D @RUN            S              1
     D Value           S             50
     D Zone            S             10

      ** +--------------------------------------+
      ** � End of D-specs                       �
      ** � ==============                       �
      ** +--------------------------------------+

      ** +--- Start of Main processing -----------------------------------+
      ** �                                                                �
      ** +----------------------------------------------------------------+

     C/COPY GOCPYSRC,GOUPD_PARM

      ** Get Zone Name from system ID.

     C     System_ID     CHAIN     GPZONED0                           90
     C                   EVAL      Zone = ZOZONE

      ** If the Midas phase is not Input Cycle then set data to blank.

     C                   IF        Key_Desc = 'UnrepRollovers'
     C                   IF        MidasPhase <> 'A'
     C                   EVAL      Value = *Blanks
     C                   ELSE

     C                   EVAL      CountN = 0

     C/EXEC SQL
     C+  SELECT COUNT(*) INTO :CountN FROM T_MSRPRQ WHERE MSWAPI='LOAM'
     C+  AND MSWNAVP=' ' AND MSWZONE = :Zone AND MSWSTAT NOT IN
     C+  ('AUTHORISED', 'REJECTED', 'NOT_APPROVED', 'INCOMPLETE')
     C+
     C/END-EXEC

      ** Check for successful completion

     C                   IF        SQLCOD <> 0
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      Value = CountA

     C                   ENDIF

     C                   IF        %OPEN(GPDWNLL0)
     C                   CLOSE     GPDWNLL0
     C                   ENDIF
     C                   ENDIF

     C                   IF        Key_Desc = 'UnrepLoanAmds'
     C                   IF        MidasPhase <> 'A'
     C                   EVAL      Value = *Blanks
     C                   ELSE

     C                   EVAL      CountN = 0

     C/EXEC SQL
     C+  SELECT COUNT(*) INTO :CountN FROM T_MSRPRQ WHERE MSWAPI='LOAM'
     C+  AND MSWNAVP <> ' ' AND MSWZONE = :Zone AND MSWSTAT NOT IN
     C+  ('AUTHORISED', 'REJECTED', 'NOT_APPROVED', 'INCOMPLETE')
     C+
     C/END-EXEC

      ** Check for successful completion

     C                   IF        SQLCOD <> 0
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      Value = CountA

     C                   ENDIF

     C                   IF        %OPEN(GPDWNLL0)
     C                   CLOSE     GPDWNLL0
     C                   ENDIF
     C                   ENDIF

     C/COPY GOCPYSRC,GOUPD_DWNL

     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
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
