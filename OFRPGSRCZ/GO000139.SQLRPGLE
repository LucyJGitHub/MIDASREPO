     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF MT940/950 I/C generation status')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO000139 - Midas OF MT940/950 I/C Generation Status          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CGL146A   *CREATE  Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL146A - MT940/MT950 Production in Input Cycle              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
 
     FGPZONEL2  IF   E           K DISK    INFSR(*PSSR)
     FGLNWACL4  IF   E           K DISK    INFSR(*PSSR)
     FGLNW94L2  IF   E           K DISK    INFSR(*PSSR)
     FSDNWRKI0  IF   E           K DISK    INFSR(*PSSR)
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
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External Data Structure for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs: Short Data Structure
 
 
     D @RUN            S              1
     D Value           S             50
     D Zone            S             10
     D CountX          S              5  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    System_ID         2
     C                   PARM                    MidasPhase        1
     C                   PARM                    Key_Desc         20
     C                   PARM                    Extra_Parms      30
     C                   PARM                    Maint_Program    10
     C                   PARM                    Maint_Parms      30
     C                   PARM                    Enq_Program      10
     C                   PARM                    Enq_Parms        30
     C                   PARM                    Unauth_Ind        1
 
      ** Retrieve Bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        MidasPhase = 'C'
     C                   EVAL      Value = *blanks
     C                   ELSE
     C                   EVAL      CountN = 0
     C                   ENDIF
 
     C                   READ      SDNWRKI0                               90
     C                   DOW       *IN90 = *OFF
     C                   IF        EDP950 = 'Y' OR EDP940 = 'Y'
 
     C     EDNWR1        CHAIN     GLNWACL4                           91
     C                   DOW       *IN91 = *OFF
     C                   IF        NAG950 = 'Y' AND EDP950 = 'Y'
     C                   EXSR      UpdateCountA
     C                   ENDIF
     C     EDNWR1        READE     GLNWACL4                               91
     C                   ENDDO
 
 
     C     EDNWR1        CHAIN     GLNW94L2                           91
     C                   DOW       *IN91 = *OFF
     C                   IF        N4G940 = 'Y' AND EDP940 = 'Y'
     C                   EXSR      UpdateCountB
     C                   ENDIF
     C     EDNWR1        READE     GLNW94L2                               91
     C                   ENDDO
     C                   ENDIF
     C                   READ      SDNWRKI0                               90
     C                   ENDDO
 
     C                   IF        %Open(GPDWNLL0)
     C                   CLOSE     GPDWNLL0
     C                   ENDIF
 
     C     GPDWNLL0Key   KLIST
     C                   KFLD                    DLMSID
     C                   KFLD                    DLKEYD
 
      ** Update Global Processing download file.
 
     C                   Open      GPDWNLL0
     C                   EVAL      DLMSID = System_ID
     C                   EVAL      DLKEYD = Key_Desc
 
     C     GPDWNLL0Key   SETLL     GPDWNLL0
     C     GPDWNLL0Key   CHAIN     GPDWNLL0                           11
 
     C                   IF        MidasPhase <> 'C'
     C                   EVAL      Value = CountA
     C                   ENDIF
 
     C                   EVAL      DLVAL = Value
     C                   EVAL      DLMPGM = Maint_Program
     C                   EVAL      DLMPRM = Maint_Parms
     C                   EVAL      DLEPGM = Enq_Program
     C                   EVAL      DLEPRM = Enq_Parms
     C                   EVAL      DLUATH = Unauth_Ind
     C                   IF        *IN11 = *ON
     C                   WRITE     @DWNLL0
     C                   ELSE
     C                   UPDATE    @DWNLL0
     C                   ENDIF
     C                   Close     GPDWNLL0
 
     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdateCountA - This does the read of the file containing      *
      *                unauthorised retail account transfer updates   *
      *                the count accordingly.                         *
      *                                                               *
      * Called by: *MAIN                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     UpdateCountA  BEGSR
 
      ** If the Midas phase is not Input Cycle then set data to blank.
 
     C                   IF        MidasPhase <> 'C'
     C                   EVAL      CountX = 0
 
     C/EXEC SQL
     C+  SELECT COUNT(*) INTO :CountX FROM GLMR94PD WHERE
     C+      MRNWRK=:NANWRK  AND
     C+      MRBRCA=:NABRCH  AND
     C+      MRCNUM=:NACNUM  AND
     C+      MRCCY =:NACCY   AND
     C+      MRACSQ=:NAACSQ  AND
     C+      MRNATY=:NANATY  AND
     C+      MRDSTN='           ' AND
     C+      MRMTPY='950'    AND
     C+      MRRDTE=:BJRDNB  AND
     C+      MRSTAT= 'GENERATED'
     C/END-EXEC
 
      ** Check for successful completion
 
     C                   IF        SQLCOD <> 0
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        CountX = 0
     C                   EVAL      CountN = CountN + 1
     C                   ENDIF
 
     C                   ENDIF
 
     C     UpdateCountAE ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdateCountB - This does the read of the file containing      *
      *                unauthorised retail account transfer updates   *
      *                the count accordingly.                         *
      *                                                               *
      * Called by: *MAIN                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     UpdateCountB  BEGSR
 
      ** If the Midas phase is not Input Cycle then set data to blank.
 
     C                   IF        MidasPhase <> 'C'
     C                   EVAL      CountX = 0
 
     C/EXEC SQL
     C+  SELECT COUNT(*) INTO :CountX FROM GLMR94PD WHERE
     C+      MRNWRK=:N4NWRK  AND
     C+      MRBRCA=:N4BRCA  AND
     C+      MRCNUM=:N4CNUM  AND
     C+      MRCCY =:N4CCY   AND
     C+      MRACSQ=:N4ACSQ  AND
     C+      MRNATY=:N4NATY  AND
     C+      MRDSTN=:N4DSTN  AND
     C+      MRMTPY='940'    AND
     C+      MRRDTE=:BJRDNB  AND
     C+      MRSTAT= 'GENERATED'
     C/END-EXEC
 
      * Check for successful completion
 
     C                   IF        SQLCOD <> 0
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        CountX = 0
     C                   EVAL      CountN = CountN + 1
     C                   ENDIF
 
     C                   ENDIF
 
     C     UpdateCountBE ENDSR
 
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
