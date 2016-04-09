     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Sync Instrument types to ext. files')         *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00218 - Midas SM Sync Instrument types to ext. files      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR790667A*CREATE   Date 30Jun11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR790667A - RSTC - Restore of zzDVLIB failed                 *
      *                                                               *
      *****************************************************************
      *
      * +--------------------------------------+
      * ¦ F-specs                              ¦
      * ¦ =======                              ¦
      * +--------------------------------------+
      *
     FINTYPD    IF   E             DISK    INFSR(*PSSR)
      ** Midas FF Instrument types detail
 
     FFFITX1PD  IF A E           K DISK    INFSR(*PSSR)
      ** Midas IBLC 2002 FF Instrument Types
 
     FFFITX2PD  IF A E           K DISK    INFSR(*PSSR)
      ** MIDAS/ABS FF Instrument type - CAD ext. file
 
     FINTYPDQD  IF A E           K DISK    INFSR(*PSSR)
      ** Midas FF Intrument Type Extension File
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D  @RUN           S              1A   INZ(*BLANKS)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C     1             SETLL     INTYPD
     C                   READ      INTYPD
     C                   DOW       NOT %EOF
     C                   EXSR      SRITX1
     C                   EXSR      SRITX2
     C                   EXSR      SRITXQD
     C                   READ      INTYPD
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRITX1 - Synchronise ext file number 1                        *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRITX1        BEGSR
 
     C     ISTT          CHAIN     FFITX1PD
     C                   IF        NOT %FOUND
     C                   EVAL      INISTT = ISTT
     C                   EVAL      INMRKT = *Blanks
     C                   WRITE     INTYPDDL
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRITX2 - Synchronise ext file number 2                        *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRITX2        BEGSR
 
     C     ISTT          CHAIN     FFITX2PD
     C                   IF        NOT %FOUND
     C                   EVAL      CBISTT = ISTT
     C                   EVAL      CBOPCM = *Zero
     C                   EVAL      CBSESN = *Blanks
     C                   EVAL      CBBBIX = *Zero
     C                   WRITE     INTYPDD6
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRITXQD - Synchronise QD Ext file                             *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRITXQD       BEGSR
 
     C                   EVAL      MIISTT = ISTT
     C                   EVAL      MIFRID = *Blanks
     C                   WRITE     INTYPQD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
