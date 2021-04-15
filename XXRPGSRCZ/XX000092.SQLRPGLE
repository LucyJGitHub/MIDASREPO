     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GO Download data control - Repair Queue')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  XX000092 - Midas GO Download data control -                  *
      *             Unauthorised Amount Accruals                      *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. DAI101             Date 03Oct19               *
      *  Prev Amend No.                    Date DDMMMYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI101 - Accrual Authorisation                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+

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
     D Zone            S             10

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
     C                   EVAL      Zone = ZOZONE

      ** If the Midas phase is not Input Cycle then set data to blank.

     C                   IF        MidasPhase = 'C'
     C                   EVAL      Value = *Blanks
     C                   ELSE

     C                   EVAL      CountN = 0

     C/EXEC SQL
     C+  SELECT COUNT(*) INTO :CountN FROM XXAMACPD
     C/END-EXEC

      * Check for successful completion

     C                   IF        SQLCOD <> 0
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      Value = CountA

     C                   ENDIF

     C                   IF        %OPEN(GPDWNLL0)
     C                   CLOSE     GPDWNLL0
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
